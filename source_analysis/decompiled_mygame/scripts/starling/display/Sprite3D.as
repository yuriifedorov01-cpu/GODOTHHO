package starling.display
{
   import flash.geom.*;
   import starling.events.*;
   import starling.rendering.Painter;
   import starling.utils.*;
   
   public class Sprite3D extends DisplayObjectContainer
   {
      
      private static const E:Number = 0.00001;
      
      private static var sHelperPoint:Vector3D = new Vector3D();
      
      private static var sHelperPointAlt:Vector3D = new Vector3D();
      
      private static var sHelperMatrix:Matrix3D = new Matrix3D();
      
      private var _rotationX:Number;
      
      private var _rotationY:Number;
      
      private var _scaleZ:Number;
      
      private var _pivotZ:Number;
      
      private var _z:Number;
      
      private var _transformationMatrix:Matrix;
      
      private var _transformationMatrix3D:Matrix3D;
      
      private var _transformationChanged:Boolean;
      
      private var _is2D:Boolean;
      
      public function Sprite3D()
      {
         super();
         this._scaleZ = 1;
         this._rotationX = this._rotationY = this._pivotZ = this._z = 0;
         this._transformationMatrix = new Matrix();
         this._transformationMatrix3D = new Matrix3D();
         this._is2D = true;
         setIs3D(true);
         addEventListener(Event.ADDED,this.onAddedChild);
         addEventListener(Event.REMOVED,this.onRemovedChild);
      }
      
      override public function render(param1:Painter) : void
      {
         if(this._is2D)
         {
            super.render(param1);
         }
         else
         {
            param1.finishMeshBatch();
            param1.pushState();
            param1.state.transformModelviewMatrix3D(this.transformationMatrix3D);
            super.render(param1);
            param1.finishMeshBatch();
            param1.excludeFromCache(this);
            param1.popState();
         }
      }
      
      override public function hitTest(param1:Point) : DisplayObject
      {
         if(this._is2D)
         {
            return super.hitTest(param1);
         }
         if(!visible || !touchable)
         {
            return null;
         }
         sHelperMatrix.copyFrom(this.transformationMatrix3D);
         sHelperMatrix.invert();
         stage.getCameraPosition(this,sHelperPoint);
         MatrixUtil.transformCoords3D(sHelperMatrix,param1.x,param1.y,0,sHelperPointAlt);
         MathUtil.intersectLineWithXYPlane(sHelperPoint,sHelperPointAlt,param1);
         return super.hitTest(param1);
      }
      
      override public function setRequiresRedraw() : void
      {
         this._is2D = this._z > -E && this._z < E && this._rotationX > -E && this._rotationX < E && this._rotationY > -E && this._rotationY < E && this._pivotZ > -E && this._pivotZ < E;
         super.setRequiresRedraw();
      }
      
      private function onAddedChild(param1:Event) : void
      {
         this.recursivelySetIs3D(param1.target as DisplayObject,true);
      }
      
      private function onRemovedChild(param1:Event) : void
      {
         this.recursivelySetIs3D(param1.target as DisplayObject,false);
      }
      
      private function recursivelySetIs3D(param1:DisplayObject, param2:Boolean) : void
      {
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1 is Sprite3D)
         {
            return;
         }
         if(param1 is DisplayObjectContainer)
         {
            _loc3_ = param1 as DisplayObjectContainer;
            _loc4_ = _loc3_.numChildren;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               this.recursivelySetIs3D(_loc3_.getChildAt(_loc5_),param2);
               _loc5_++;
            }
         }
         param1.setIs3D(param2);
      }
      
      private function updateMatrices() : void
      {
         var _loc1_:Number = this.x;
         var _loc2_:Number = this.y;
         var _loc3_:Number = this.scaleX;
         var _loc4_:Number = this.scaleY;
         var _loc5_:Number = this.pivotX;
         var _loc6_:Number = this.pivotY;
         var _loc7_:Number = this.rotation;
         this._transformationMatrix3D.identity();
         if(_loc3_ != 1 || _loc4_ != 1 || this._scaleZ != 1)
         {
            this._transformationMatrix3D.appendScale(_loc3_ || Number(E),_loc4_ || Number(E),Number(this._scaleZ) || Number(E));
         }
         if(this._rotationX != 0)
         {
            this._transformationMatrix3D.appendRotation(rad2deg(this._rotationX),Vector3D.X_AXIS);
         }
         if(this._rotationY != 0)
         {
            this._transformationMatrix3D.appendRotation(rad2deg(this._rotationY),Vector3D.Y_AXIS);
         }
         if(_loc7_ != 0)
         {
            this._transformationMatrix3D.appendRotation(rad2deg(_loc7_),Vector3D.Z_AXIS);
         }
         if(_loc1_ != 0 || _loc2_ != 0 || this._z != 0)
         {
            this._transformationMatrix3D.appendTranslation(_loc1_,_loc2_,this._z);
         }
         if(_loc5_ != 0 || _loc6_ != 0 || this._pivotZ != 0)
         {
            this._transformationMatrix3D.prependTranslation(-_loc5_,-_loc6_,-this._pivotZ);
         }
         if(this._is2D)
         {
            MatrixUtil.convertTo2D(this._transformationMatrix3D,this._transformationMatrix);
         }
         else
         {
            this._transformationMatrix.identity();
         }
      }
      
      override public function get transformationMatrix() : Matrix
      {
         if(this._transformationChanged)
         {
            this.updateMatrices();
            this._transformationChanged = false;
         }
         return this._transformationMatrix;
      }
      
      override public function set transformationMatrix(param1:Matrix) : void
      {
         super.transformationMatrix = param1;
         this._rotationX = this._rotationY = this._pivotZ = this._z = 0;
         this._transformationChanged = true;
      }
      
      override public function get transformationMatrix3D() : Matrix3D
      {
         if(this._transformationChanged)
         {
            this.updateMatrices();
            this._transformationChanged = false;
         }
         return this._transformationMatrix3D;
      }
      
      override public function set x(param1:Number) : void
      {
         super.x = param1;
         this._transformationChanged = true;
      }
      
      override public function set y(param1:Number) : void
      {
         super.y = param1;
         this._transformationChanged = true;
      }
      
      public function get z() : Number
      {
         return this._z;
      }
      
      public function set z(param1:Number) : void
      {
         this._z = param1;
         this._transformationChanged = true;
         this.setRequiresRedraw();
      }
      
      override public function set pivotX(param1:Number) : void
      {
         super.pivotX = param1;
         this._transformationChanged = true;
      }
      
      override public function set pivotY(param1:Number) : void
      {
         super.pivotY = param1;
         this._transformationChanged = true;
      }
      
      public function get pivotZ() : Number
      {
         return this._pivotZ;
      }
      
      public function set pivotZ(param1:Number) : void
      {
         this._pivotZ = param1;
         this._transformationChanged = true;
         this.setRequiresRedraw();
      }
      
      override public function set scaleX(param1:Number) : void
      {
         super.scaleX = param1;
         this._transformationChanged = true;
      }
      
      override public function set scaleY(param1:Number) : void
      {
         super.scaleY = param1;
         this._transformationChanged = true;
      }
      
      public function get scaleZ() : Number
      {
         return this._scaleZ;
      }
      
      public function set scaleZ(param1:Number) : void
      {
         this._scaleZ = param1;
         this._transformationChanged = true;
         this.setRequiresRedraw();
      }
      
      override public function set skewX(param1:Number) : void
      {
         throw new Error("3D objects do not support skewing");
      }
      
      override public function set skewY(param1:Number) : void
      {
         throw new Error("3D objects do not support skewing");
      }
      
      override public function set rotation(param1:Number) : void
      {
         super.rotation = param1;
         this._transformationChanged = true;
      }
      
      public function get rotationX() : Number
      {
         return this._rotationX;
      }
      
      public function set rotationX(param1:Number) : void
      {
         this._rotationX = MathUtil.normalizeAngle(param1);
         this._transformationChanged = true;
         this.setRequiresRedraw();
      }
      
      public function get rotationY() : Number
      {
         return this._rotationY;
      }
      
      public function set rotationY(param1:Number) : void
      {
         this._rotationY = MathUtil.normalizeAngle(param1);
         this._transformationChanged = true;
         this.setRequiresRedraw();
      }
      
      public function get rotationZ() : Number
      {
         return rotation;
      }
      
      public function set rotationZ(param1:Number) : void
      {
         this.rotation = param1;
      }
   }
}

