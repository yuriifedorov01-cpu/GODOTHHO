package starling.rendering
{
   import flash.display3D.*;
   import flash.display3D.textures.TextureBase;
   import flash.geom.*;
   import starling.display.*;
   import starling.textures.Texture;
   import starling.utils.*;
   
   public class RenderState
   {
      
      private static var sMatrix3D:Matrix3D = new Matrix3D();
      
      internal var _alpha:Number;
      
      internal var _blendMode:String;
      
      internal var _modelviewMatrix:Matrix;
      
      private var _renderTarget:Texture;
      
      private var _renderTargetOptions:uint;
      
      private var _culling:String;
      
      private var _clipRect:Rectangle;
      
      private var _onDrawRequired:Function;
      
      private var _modelviewMatrix3D:Matrix3D;
      
      private var _projectionMatrix3D:Matrix3D;
      
      private var _mvpMatrix3D:Matrix3D;
      
      public function RenderState()
      {
         super();
         this.reset();
      }
      
      public function copyFrom(param1:RenderState) : void
      {
         var _loc2_:TextureBase = null;
         var _loc3_:TextureBase = null;
         var _loc4_:Boolean = false;
         if(this._onDrawRequired != null)
         {
            _loc2_ = this._renderTarget ? this._renderTarget.base : null;
            _loc3_ = param1._renderTarget ? param1._renderTarget.base : null;
            _loc4_ = Boolean(this._clipRect) || Boolean(param1._clipRect) ? !RectangleUtil.compare(this._clipRect,param1._clipRect) : false;
            if(this._blendMode != param1._blendMode || this._culling != param1._culling || _loc2_ != _loc3_ || _loc4_)
            {
               this._onDrawRequired();
            }
         }
         this._alpha = param1._alpha;
         this._blendMode = param1._blendMode;
         this._renderTarget = param1._renderTarget;
         this._renderTargetOptions = param1._renderTargetOptions;
         this._culling = param1._culling;
         this._modelviewMatrix.copyFrom(param1._modelviewMatrix);
         this._projectionMatrix3D.copyFrom(param1._projectionMatrix3D);
         if(Boolean(this._modelviewMatrix3D) || Boolean(param1._modelviewMatrix3D))
         {
            this.modelviewMatrix3D = param1._modelviewMatrix3D;
         }
         if(Boolean(this._clipRect) || Boolean(param1._clipRect))
         {
            this.clipRect = param1._clipRect;
         }
      }
      
      public function reset() : void
      {
         this.alpha = 1;
         this.blendMode = BlendMode.NORMAL;
         this.culling = Context3DTriangleFace.NONE;
         this.modelviewMatrix3D = null;
         this.renderTarget = null;
         this.clipRect = null;
         if(this._modelviewMatrix)
         {
            this._modelviewMatrix.identity();
         }
         else
         {
            this._modelviewMatrix = new Matrix();
         }
         if(this._projectionMatrix3D)
         {
            this._projectionMatrix3D.identity();
         }
         else
         {
            this._projectionMatrix3D = new Matrix3D();
         }
         if(this._mvpMatrix3D == null)
         {
            this._mvpMatrix3D = new Matrix3D();
         }
      }
      
      public function transformModelviewMatrix(param1:Matrix) : void
      {
         MatrixUtil.prependMatrix(this._modelviewMatrix,param1);
      }
      
      public function transformModelviewMatrix3D(param1:Matrix3D) : void
      {
         if(this._modelviewMatrix3D == null)
         {
            this._modelviewMatrix3D = Pool.getMatrix3D();
         }
         this._modelviewMatrix3D.prepend(MatrixUtil.convertTo3D(this._modelviewMatrix,sMatrix3D));
         this._modelviewMatrix3D.prepend(param1);
         this._modelviewMatrix.identity();
      }
      
      public function setProjectionMatrix(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number = 0, param6:Number = 0, param7:Vector3D = null) : void
      {
         MatrixUtil.createPerspectiveProjectionMatrix(param1,param2,param3,param4,param5,param6,param7,this._projectionMatrix3D);
      }
      
      public function setModelviewMatricesToIdentity() : void
      {
         this._modelviewMatrix.identity();
         if(this._modelviewMatrix3D)
         {
            this._modelviewMatrix3D.identity();
         }
      }
      
      public function get modelviewMatrix() : Matrix
      {
         return this._modelviewMatrix;
      }
      
      public function set modelviewMatrix(param1:Matrix) : void
      {
         this._modelviewMatrix.copyFrom(param1);
      }
      
      public function get modelviewMatrix3D() : Matrix3D
      {
         return this._modelviewMatrix3D;
      }
      
      public function set modelviewMatrix3D(param1:Matrix3D) : void
      {
         if(param1)
         {
            if(this._modelviewMatrix3D == null)
            {
               this._modelviewMatrix3D = Pool.getMatrix3D(false);
            }
            this._modelviewMatrix3D.copyFrom(param1);
         }
         else if(this._modelviewMatrix3D)
         {
            Pool.putMatrix3D(this._modelviewMatrix3D);
            this._modelviewMatrix3D = null;
         }
      }
      
      public function get projectionMatrix3D() : Matrix3D
      {
         return this._projectionMatrix3D;
      }
      
      public function set projectionMatrix3D(param1:Matrix3D) : void
      {
         this._projectionMatrix3D.copyFrom(param1);
      }
      
      public function get mvpMatrix3D() : Matrix3D
      {
         this._mvpMatrix3D.copyFrom(this._projectionMatrix3D);
         if(this._modelviewMatrix3D)
         {
            this._mvpMatrix3D.prepend(this._modelviewMatrix3D);
         }
         this._mvpMatrix3D.prepend(MatrixUtil.convertTo3D(this._modelviewMatrix,sMatrix3D));
         return this._mvpMatrix3D;
      }
      
      public function setRenderTarget(param1:Texture, param2:Boolean = true, param3:int = 0) : void
      {
         var _loc4_:TextureBase = this._renderTarget ? this._renderTarget.base : null;
         var _loc5_:TextureBase = param1 ? param1.base : null;
         var _loc6_:uint = uint(uint(param2) | param3 << 4);
         if(_loc4_ != _loc5_ || this._renderTargetOptions != _loc6_)
         {
            if(this._onDrawRequired != null)
            {
               this._onDrawRequired();
            }
            this._renderTarget = param1;
            this._renderTargetOptions = _loc6_;
         }
      }
      
      public function get alpha() : Number
      {
         return this._alpha;
      }
      
      public function set alpha(param1:Number) : void
      {
         this._alpha = param1;
      }
      
      public function get blendMode() : String
      {
         return this._blendMode;
      }
      
      public function set blendMode(param1:String) : void
      {
         if(param1 != BlendMode.AUTO && this._blendMode != param1)
         {
            if(this._onDrawRequired != null)
            {
               this._onDrawRequired();
            }
            this._blendMode = param1;
         }
      }
      
      public function get renderTarget() : Texture
      {
         return this._renderTarget;
      }
      
      public function set renderTarget(param1:Texture) : void
      {
         this.setRenderTarget(param1);
      }
      
      internal function get renderTargetBase() : TextureBase
      {
         return this._renderTarget ? this._renderTarget.base : null;
      }
      
      public function get culling() : String
      {
         return this._culling;
      }
      
      public function set culling(param1:String) : void
      {
         if(this._culling != param1)
         {
            if(this._onDrawRequired != null)
            {
               this._onDrawRequired();
            }
            this._culling = param1;
         }
      }
      
      public function get clipRect() : Rectangle
      {
         return this._clipRect;
      }
      
      public function set clipRect(param1:Rectangle) : void
      {
         if(!RectangleUtil.compare(this._clipRect,param1))
         {
            if(this._onDrawRequired != null)
            {
               this._onDrawRequired();
            }
            if(param1)
            {
               if(this._clipRect == null)
               {
                  this._clipRect = Pool.getRectangle();
               }
               this._clipRect.copyFrom(param1);
            }
            else if(this._clipRect)
            {
               Pool.putRectangle(this._clipRect);
               this._clipRect = null;
            }
         }
      }
      
      public function get renderTargetAntiAlias() : int
      {
         return this._renderTargetOptions >> 4;
      }
      
      public function get renderTargetSupportsDepthAndStencil() : Boolean
      {
         return (this._renderTargetOptions & 0x0F) != 0;
      }
      
      public function get is3D() : Boolean
      {
         return this._modelviewMatrix3D != null;
      }
      
      internal function get onDrawRequired() : Function
      {
         return this._onDrawRequired;
      }
      
      internal function set onDrawRequired(param1:Function) : void
      {
         this._onDrawRequired = param1;
      }
   }
}

