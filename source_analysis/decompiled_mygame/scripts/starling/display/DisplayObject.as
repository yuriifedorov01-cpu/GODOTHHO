package starling.display
{
   import flash.errors.*;
   import flash.geom.*;
   import flash.system.*;
   import flash.ui.*;
   import flash.utils.*;
   import starling.core.*;
   import starling.errors.*;
   import starling.events.*;
   import starling.filters.FragmentFilter;
   import starling.rendering.*;
   import starling.utils.*;
   
   use namespace starling_internal;
   
   public class DisplayObject extends EventDispatcher
   {
      
      private static var sAncestors:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      private static var sHelperPoint:Point = new Point();
      
      private static var sHelperPoint3D:Vector3D = new Vector3D();
      
      private static var sHelperPointAlt3D:Vector3D = new Vector3D();
      
      private static var sHelperRect:Rectangle = new Rectangle();
      
      private static var sHelperMatrix:Matrix = new Matrix();
      
      private static var sHelperMatrixAlt:Matrix = new Matrix();
      
      private static var sHelperMatrix3D:Matrix3D = new Matrix3D();
      
      private static var sHelperMatrixAlt3D:Matrix3D = new Matrix3D();
      
      private var _x:Number;
      
      private var _y:Number;
      
      private var _pivotX:Number;
      
      private var _pivotY:Number;
      
      private var _scaleX:Number;
      
      private var _scaleY:Number;
      
      private var _skewX:Number;
      
      private var _skewY:Number;
      
      private var _rotation:Number;
      
      private var _alpha:Number;
      
      private var _visible:Boolean;
      
      private var _touchable:Boolean;
      
      private var _blendMode:String;
      
      private var _name:String;
      
      private var _useHandCursor:Boolean;
      
      private var _parent:DisplayObjectContainer;
      
      private var _transformationMatrix:Matrix;
      
      private var _transformationMatrix3D:Matrix3D;
      
      private var _orientationChanged:Boolean;
      
      private var _is3D:Boolean;
      
      private var _isMask:Boolean;
      
      internal var _lastParentOrSelfChangeFrameID:uint;
      
      internal var _lastChildChangeFrameID:uint;
      
      internal var _tokenFrameID:uint;
      
      internal var _pushToken:BatchToken = new BatchToken();
      
      internal var _popToken:BatchToken = new BatchToken();
      
      internal var _hasVisibleArea:Boolean;
      
      internal var _filter:FragmentFilter;
      
      internal var _mask:DisplayObject;
      
      public function DisplayObject()
      {
         super();
         if(Boolean(Capabilities.isDebugger) && getQualifiedClassName(this) == "starling.display::DisplayObject")
         {
            throw new AbstractClassError();
         }
         this._x = this._y = this._pivotX = this._pivotY = this._rotation = this._skewX = this._skewY = 0;
         this._scaleX = this._scaleY = this._alpha = 1;
         this._visible = this._touchable = this._hasVisibleArea = true;
         this._blendMode = BlendMode.AUTO;
         this._transformationMatrix = new Matrix();
      }
      
      private static function findCommonParent(param1:DisplayObject, param2:DisplayObject) : DisplayObject
      {
         var _loc3_:DisplayObject = param1;
         while(_loc3_)
         {
            sAncestors[sAncestors.length] = _loc3_;
            _loc3_ = _loc3_._parent;
         }
         _loc3_ = param2;
         while(Boolean(_loc3_) && sAncestors.indexOf(_loc3_) == -1)
         {
            _loc3_ = _loc3_._parent;
         }
         sAncestors.length = 0;
         if(_loc3_)
         {
            return _loc3_;
         }
         throw new ArgumentError("Object not connected to target");
      }
      
      public function dispose() : void
      {
         if(this._filter)
         {
            this._filter.dispose();
         }
         if(this._mask)
         {
            this._mask.dispose();
         }
         this.removeEventListeners();
         this.mask = null;
      }
      
      public function removeFromParent(param1:Boolean = false) : void
      {
         if(this._parent)
         {
            this._parent.removeChild(this,param1);
         }
         else if(param1)
         {
            this.dispose();
         }
      }
      
      public function getTransformationMatrix(param1:DisplayObject, param2:Matrix = null) : Matrix
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:DisplayObject = null;
         if(param2)
         {
            param2.identity();
         }
         else
         {
            param2 = new Matrix();
         }
         if(param1 == this)
         {
            return param2;
         }
         if(param1 == this._parent || param1 == null && this._parent == null)
         {
            param2.copyFrom(this.transformationMatrix);
            return param2;
         }
         if(param1 == null || param1 == this.base)
         {
            _loc4_ = this;
            while(_loc4_ != param1)
            {
               param2.concat(_loc4_.transformationMatrix);
               _loc4_ = _loc4_._parent;
            }
            return param2;
         }
         if(param1._parent == this)
         {
            param1.getTransformationMatrix(this,param2);
            param2.invert();
            return param2;
         }
         _loc3_ = findCommonParent(this,param1);
         _loc4_ = this;
         while(_loc4_ != _loc3_)
         {
            param2.concat(_loc4_.transformationMatrix);
            _loc4_ = _loc4_._parent;
         }
         if(_loc3_ == param1)
         {
            return param2;
         }
         sHelperMatrix.identity();
         _loc4_ = param1;
         while(_loc4_ != _loc3_)
         {
            sHelperMatrix.concat(_loc4_.transformationMatrix);
            _loc4_ = _loc4_._parent;
         }
         sHelperMatrix.invert();
         param2.concat(sHelperMatrix);
         return param2;
      }
      
      public function getBounds(param1:DisplayObject, param2:Rectangle = null) : Rectangle
      {
         throw new AbstractMethodError();
      }
      
      public function hitTest(param1:Point) : DisplayObject
      {
         if(!this._visible || !this._touchable)
         {
            return null;
         }
         if(Boolean(this._mask) && !this.hitTestMask(param1))
         {
            return null;
         }
         if(this.getBounds(this,sHelperRect).containsPoint(param1))
         {
            return this;
         }
         return null;
      }
      
      public function hitTestMask(param1:Point) : Boolean
      {
         var _loc2_:Point = null;
         if(this._mask)
         {
            if(this._mask.stage)
            {
               this.getTransformationMatrix(this._mask,sHelperMatrixAlt);
            }
            else
            {
               sHelperMatrixAlt.copyFrom(this._mask.transformationMatrix);
               sHelperMatrixAlt.invert();
            }
            _loc2_ = param1 == sHelperPoint ? new Point() : sHelperPoint;
            MatrixUtil.transformPoint(sHelperMatrixAlt,param1,_loc2_);
            return this._mask.hitTest(_loc2_) != null;
         }
         return true;
      }
      
      public function localToGlobal(param1:Point, param2:Point = null) : Point
      {
         if(this.is3D)
         {
            sHelperPoint3D.setTo(param1.x,param1.y,0);
            return this.local3DToGlobal(sHelperPoint3D,param2);
         }
         this.getTransformationMatrix(this.base,sHelperMatrixAlt);
         return MatrixUtil.transformPoint(sHelperMatrixAlt,param1,param2);
      }
      
      public function globalToLocal(param1:Point, param2:Point = null) : Point
      {
         if(this.is3D)
         {
            this.globalToLocal3D(param1,sHelperPoint3D);
            this.stage.getCameraPosition(this,sHelperPointAlt3D);
            return MathUtil.intersectLineWithXYPlane(sHelperPointAlt3D,sHelperPoint3D,param2);
         }
         this.getTransformationMatrix(this.base,sHelperMatrixAlt);
         sHelperMatrixAlt.invert();
         return MatrixUtil.transformPoint(sHelperMatrixAlt,param1,param2);
      }
      
      public function render(param1:Painter) : void
      {
         throw new AbstractMethodError();
      }
      
      public function alignPivot(param1:String = "center", param2:String = "center") : void
      {
         var _loc3_:Rectangle = this.getBounds(this,sHelperRect);
         this.setOrientationChanged();
         if(param1 == Align.LEFT)
         {
            this._pivotX = _loc3_.x;
         }
         else if(param1 == Align.CENTER)
         {
            this._pivotX = _loc3_.x + _loc3_.width / 2;
         }
         else
         {
            if(param1 != Align.RIGHT)
            {
               throw new ArgumentError("Invalid horizontal alignment: " + param1);
            }
            this._pivotX = _loc3_.x + _loc3_.width;
         }
         if(param2 == Align.TOP)
         {
            this._pivotY = _loc3_.y;
         }
         else if(param2 == Align.CENTER)
         {
            this._pivotY = _loc3_.y + _loc3_.height / 2;
         }
         else
         {
            if(param2 != Align.BOTTOM)
            {
               throw new ArgumentError("Invalid vertical alignment: " + param2);
            }
            this._pivotY = _loc3_.y + _loc3_.height;
         }
      }
      
      public function getTransformationMatrix3D(param1:DisplayObject, param2:Matrix3D = null) : Matrix3D
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:DisplayObject = null;
         if(param2)
         {
            param2.identity();
         }
         else
         {
            param2 = new Matrix3D();
         }
         if(param1 == this)
         {
            return param2;
         }
         if(param1 == this._parent || param1 == null && this._parent == null)
         {
            param2.copyFrom(this.transformationMatrix3D);
            return param2;
         }
         if(param1 == null || param1 == this.base)
         {
            _loc4_ = this;
            while(_loc4_ != param1)
            {
               param2.append(_loc4_.transformationMatrix3D);
               _loc4_ = _loc4_._parent;
            }
            return param2;
         }
         if(param1._parent == this)
         {
            param1.getTransformationMatrix3D(this,param2);
            param2.invert();
            return param2;
         }
         _loc3_ = findCommonParent(this,param1);
         _loc4_ = this;
         while(_loc4_ != _loc3_)
         {
            param2.append(_loc4_.transformationMatrix3D);
            _loc4_ = _loc4_._parent;
         }
         if(_loc3_ == param1)
         {
            return param2;
         }
         sHelperMatrix3D.identity();
         _loc4_ = param1;
         while(_loc4_ != _loc3_)
         {
            sHelperMatrix3D.append(_loc4_.transformationMatrix3D);
            _loc4_ = _loc4_._parent;
         }
         sHelperMatrix3D.invert();
         param2.append(sHelperMatrix3D);
         return param2;
      }
      
      public function local3DToGlobal(param1:Vector3D, param2:Point = null) : Point
      {
         var _loc3_:Stage = this.stage;
         if(_loc3_ == null)
         {
            throw new IllegalOperationError("Object not connected to stage");
         }
         this.getTransformationMatrix3D(_loc3_,sHelperMatrixAlt3D);
         MatrixUtil.transformPoint3D(sHelperMatrixAlt3D,param1,sHelperPoint3D);
         return MathUtil.intersectLineWithXYPlane(_loc3_.cameraPosition,sHelperPoint3D,param2);
      }
      
      public function globalToLocal3D(param1:Point, param2:Vector3D = null) : Vector3D
      {
         var _loc3_:Stage = this.stage;
         if(_loc3_ == null)
         {
            throw new IllegalOperationError("Object not connected to stage");
         }
         this.getTransformationMatrix3D(_loc3_,sHelperMatrixAlt3D);
         sHelperMatrixAlt3D.invert();
         return MatrixUtil.transformCoords3D(sHelperMatrixAlt3D,param1.x,param1.y,0,param2);
      }
      
      starling_internal function setParent(param1:DisplayObjectContainer) : void
      {
         var _loc2_:DisplayObject = param1;
         while(_loc2_ != this && _loc2_ != null)
         {
            _loc2_ = _loc2_._parent;
         }
         if(_loc2_ == this)
         {
            throw new ArgumentError("An object cannot be added as a child to itself or one " + "of its children (or children\'s children, etc.)");
         }
         this._parent = param1;
      }
      
      internal function setIs3D(param1:Boolean) : void
      {
         this._is3D = param1;
      }
      
      internal function get isMask() : Boolean
      {
         return this._isMask;
      }
      
      public function setRequiresRedraw() : void
      {
         var _loc1_:DisplayObject = this._parent;
         var _loc2_:int = int(Starling.frameID);
         this._hasVisibleArea = this._alpha != 0 && Boolean(this._visible) && !this._isMask && this._scaleX != 0 && this._scaleY != 0;
         this._lastParentOrSelfChangeFrameID = _loc2_;
         while(Boolean(_loc1_) && _loc1_._lastChildChangeFrameID != _loc2_)
         {
            _loc1_._lastChildChangeFrameID = _loc2_;
            if(_loc1_._mask)
            {
               _loc1_._mask.setRequiresRedraw();
            }
            _loc1_ = _loc1_._parent;
         }
         if(this._isMask)
         {
            Starling.current.setRequiresRedraw();
         }
         else if(this._mask)
         {
            this._mask.setRequiresRedraw();
         }
      }
      
      public function get requiresRedraw() : Boolean
      {
         var _loc1_:uint = uint(Starling.frameID);
         return this._lastParentOrSelfChangeFrameID == _loc1_ || this._lastChildChangeFrameID == _loc1_;
      }
      
      starling_internal function excludeFromCache() : void
      {
         var _loc1_:DisplayObject = this;
         var _loc2_:uint = 4294967295;
         while(Boolean(_loc1_) && _loc1_._tokenFrameID != _loc2_)
         {
            _loc1_._tokenFrameID = _loc2_;
            _loc1_ = _loc1_._parent;
         }
      }
      
      private function setOrientationChanged() : void
      {
         this._orientationChanged = true;
         this.setRequiresRedraw();
      }
      
      override public function dispatchEvent(param1:Event) : void
      {
         if(param1.type == Event.REMOVED_FROM_STAGE && this.stage == null)
         {
            return;
         }
         super.dispatchEvent(param1);
      }
      
      override public function addEventListener(param1:String, param2:Function) : void
      {
         if(param1 == Event.ENTER_FRAME && !hasEventListener(param1))
         {
            this.addEventListener(Event.ADDED_TO_STAGE,this.addEnterFrameListenerToStage);
            this.addEventListener(Event.REMOVED_FROM_STAGE,this.removeEnterFrameListenerFromStage);
            if(this.stage)
            {
               this.addEnterFrameListenerToStage();
            }
         }
         super.addEventListener(param1,param2);
      }
      
      override public function removeEventListener(param1:String, param2:Function) : void
      {
         super.removeEventListener(param1,param2);
         if(param1 == Event.ENTER_FRAME && !hasEventListener(param1))
         {
            this.removeEventListener(Event.ADDED_TO_STAGE,this.addEnterFrameListenerToStage);
            this.removeEventListener(Event.REMOVED_FROM_STAGE,this.removeEnterFrameListenerFromStage);
            this.removeEnterFrameListenerFromStage();
         }
      }
      
      override public function removeEventListeners(param1:String = null) : void
      {
         if((param1 == null || param1 == Event.ENTER_FRAME) && hasEventListener(Event.ENTER_FRAME))
         {
            this.removeEventListener(Event.ADDED_TO_STAGE,this.addEnterFrameListenerToStage);
            this.removeEventListener(Event.REMOVED_FROM_STAGE,this.removeEnterFrameListenerFromStage);
            this.removeEnterFrameListenerFromStage();
         }
         super.removeEventListeners(param1);
      }
      
      private function addEnterFrameListenerToStage() : void
      {
         Starling.current.stage.addEnterFrameListener(this);
      }
      
      private function removeEnterFrameListenerFromStage() : void
      {
         Starling.current.stage.removeEnterFrameListener(this);
      }
      
      public function get transformationMatrix() : Matrix
      {
         var _loc1_:Number = Number(NaN);
         var _loc2_:Number = Number(NaN);
         var _loc3_:Number = Number(NaN);
         var _loc4_:Number = Number(NaN);
         var _loc5_:Number = Number(NaN);
         var _loc6_:Number = Number(NaN);
         var _loc7_:Number = Number(NaN);
         var _loc8_:Number = Number(NaN);
         if(this._orientationChanged)
         {
            this._orientationChanged = false;
            if(this._skewX == 0 && this._skewY == 0)
            {
               if(this._rotation == 0)
               {
                  this._transformationMatrix.setTo(this._scaleX,0,0,this._scaleY,this._x - this._pivotX * this._scaleX,this._y - this._pivotY * this._scaleY);
               }
               else
               {
                  _loc1_ = Math.cos(this._rotation);
                  _loc2_ = Math.sin(this._rotation);
                  _loc3_ = this._scaleX * _loc1_;
                  _loc4_ = this._scaleX * _loc2_;
                  _loc5_ = this._scaleY * -_loc2_;
                  _loc6_ = this._scaleY * _loc1_;
                  _loc7_ = this._x - this._pivotX * _loc3_ - this._pivotY * _loc5_;
                  _loc8_ = this._y - this._pivotX * _loc4_ - this._pivotY * _loc6_;
                  this._transformationMatrix.setTo(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_);
               }
            }
            else
            {
               this._transformationMatrix.identity();
               this._transformationMatrix.scale(this._scaleX,this._scaleY);
               MatrixUtil.skew(this._transformationMatrix,this._skewX,this._skewY);
               this._transformationMatrix.rotate(this._rotation);
               this._transformationMatrix.translate(this._x,this._y);
               if(this._pivotX != 0 || this._pivotY != 0)
               {
                  this._transformationMatrix.tx = this._x - this._transformationMatrix.a * this._pivotX - this._transformationMatrix.c * this._pivotY;
                  this._transformationMatrix.ty = this._y - this._transformationMatrix.b * this._pivotX - this._transformationMatrix.d * this._pivotY;
               }
            }
         }
         return this._transformationMatrix;
      }
      
      public function set transformationMatrix(param1:Matrix) : void
      {
         var _loc2_:Number = Math.PI / 4;
         this.setRequiresRedraw();
         this._orientationChanged = false;
         this._transformationMatrix.copyFrom(param1);
         this._pivotX = this._pivotY = 0;
         this._x = param1.tx;
         this._y = param1.ty;
         this._skewX = Math.atan(-param1.c / param1.d);
         this._skewY = Math.atan(param1.b / param1.a);
         if(this._skewX != this._skewX)
         {
            this._skewX = 0;
         }
         if(this._skewY != this._skewY)
         {
            this._skewY = 0;
         }
         this._scaleY = this._skewX > -_loc2_ && this._skewX < _loc2_ ? param1.d / Math.cos(this._skewX) : -param1.c / Math.sin(this._skewX);
         this._scaleX = this._skewY > -_loc2_ && this._skewY < _loc2_ ? param1.a / Math.cos(this._skewY) : param1.b / Math.sin(this._skewY);
         if(MathUtil.isEquivalent(this._skewX,this._skewY))
         {
            this._rotation = this._skewX;
            this._skewX = this._skewY = 0;
         }
         else
         {
            this._rotation = 0;
         }
      }
      
      public function get transformationMatrix3D() : Matrix3D
      {
         if(this._transformationMatrix3D == null)
         {
            this._transformationMatrix3D = new Matrix3D();
         }
         return MatrixUtil.convertTo3D(this.transformationMatrix,this._transformationMatrix3D);
      }
      
      public function get is3D() : Boolean
      {
         return this._is3D;
      }
      
      public function get useHandCursor() : Boolean
      {
         return this._useHandCursor;
      }
      
      public function set useHandCursor(param1:Boolean) : void
      {
         if(param1 == this._useHandCursor)
         {
            return;
         }
         this._useHandCursor = param1;
         if(this._useHandCursor)
         {
            this.addEventListener(TouchEvent.TOUCH,this.onTouch);
         }
         else
         {
            this.removeEventListener(TouchEvent.TOUCH,this.onTouch);
         }
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         Mouse.cursor = param1.interactsWith(this) ? MouseCursor.BUTTON : MouseCursor.AUTO;
      }
      
      public function get bounds() : Rectangle
      {
         return this.getBounds(this._parent);
      }
      
      public function get width() : Number
      {
         return this.getBounds(this._parent,sHelperRect).width;
      }
      
      public function set width(param1:Number) : void
      {
         var _loc2_:Number = Number(NaN);
         if(this._scaleX == 0)
         {
            this.scaleX = 1;
            _loc2_ = this.width;
         }
         else
         {
            _loc2_ = Math.abs(this.width / this._scaleX);
         }
         if(_loc2_)
         {
            this.scaleX = param1 / _loc2_;
         }
      }
      
      public function get height() : Number
      {
         return this.getBounds(this._parent,sHelperRect).height;
      }
      
      public function set height(param1:Number) : void
      {
         var _loc2_:Number = Number(NaN);
         if(this._scaleY == 0)
         {
            this.scaleY = 1;
            _loc2_ = this.height;
         }
         else
         {
            _loc2_ = Math.abs(this.height / this._scaleY);
         }
         if(_loc2_)
         {
            this.scaleY = param1 / _loc2_;
         }
      }
      
      public function get x() : Number
      {
         return this._x;
      }
      
      public function set x(param1:Number) : void
      {
         if(this._x != param1)
         {
            this._x = param1;
            this.setOrientationChanged();
         }
      }
      
      public function get y() : Number
      {
         return this._y;
      }
      
      public function set y(param1:Number) : void
      {
         if(this._y != param1)
         {
            this._y = param1;
            this.setOrientationChanged();
         }
      }
      
      public function get pivotX() : Number
      {
         return this._pivotX;
      }
      
      public function set pivotX(param1:Number) : void
      {
         if(this._pivotX != param1)
         {
            this._pivotX = param1;
            this.setOrientationChanged();
         }
      }
      
      public function get pivotY() : Number
      {
         return this._pivotY;
      }
      
      public function set pivotY(param1:Number) : void
      {
         if(this._pivotY != param1)
         {
            this._pivotY = param1;
            this.setOrientationChanged();
         }
      }
      
      public function get scaleX() : Number
      {
         return this._scaleX;
      }
      
      public function set scaleX(param1:Number) : void
      {
         if(this._scaleX != param1)
         {
            this._scaleX = param1;
            this.setOrientationChanged();
         }
      }
      
      public function get scaleY() : Number
      {
         return this._scaleY;
      }
      
      public function set scaleY(param1:Number) : void
      {
         if(this._scaleY != param1)
         {
            this._scaleY = param1;
            this.setOrientationChanged();
         }
      }
      
      public function get scale() : Number
      {
         return this.scaleX;
      }
      
      public function set scale(param1:Number) : void
      {
         this.scaleX = this.scaleY = param1;
      }
      
      public function get skewX() : Number
      {
         return this._skewX;
      }
      
      public function set skewX(param1:Number) : void
      {
         param1 = Number(MathUtil.normalizeAngle(param1));
         if(this._skewX != param1)
         {
            this._skewX = param1;
            this.setOrientationChanged();
         }
      }
      
      public function get skewY() : Number
      {
         return this._skewY;
      }
      
      public function set skewY(param1:Number) : void
      {
         param1 = Number(MathUtil.normalizeAngle(param1));
         if(this._skewY != param1)
         {
            this._skewY = param1;
            this.setOrientationChanged();
         }
      }
      
      public function get rotation() : Number
      {
         return this._rotation;
      }
      
      public function set rotation(param1:Number) : void
      {
         param1 = Number(MathUtil.normalizeAngle(param1));
         if(this._rotation != param1)
         {
            this._rotation = param1;
            this.setOrientationChanged();
         }
      }
      
      public function get alpha() : Number
      {
         return this._alpha;
      }
      
      public function set alpha(param1:Number) : void
      {
         if(param1 != this._alpha)
         {
            this._alpha = param1 < 0 ? 0 : (param1 > 1 ? 1 : param1);
            this.setRequiresRedraw();
         }
      }
      
      public function get visible() : Boolean
      {
         return this._visible;
      }
      
      public function set visible(param1:Boolean) : void
      {
         if(param1 != this._visible)
         {
            this._visible = param1;
            this.setRequiresRedraw();
         }
      }
      
      public function get touchable() : Boolean
      {
         return this._touchable;
      }
      
      public function set touchable(param1:Boolean) : void
      {
         this._touchable = param1;
      }
      
      public function get blendMode() : String
      {
         return this._blendMode;
      }
      
      public function set blendMode(param1:String) : void
      {
         if(param1 != this._blendMode)
         {
            this._blendMode = param1;
            this.setRequiresRedraw();
         }
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get filter() : FragmentFilter
      {
         return this._filter;
      }
      
      public function set filter(param1:FragmentFilter) : void
      {
         if(param1 != this._filter)
         {
            if(this._filter)
            {
               this._filter.setTarget(null);
            }
            if(param1)
            {
               param1.setTarget(this);
            }
            this._filter = param1;
            this.setRequiresRedraw();
         }
      }
      
      public function get mask() : DisplayObject
      {
         return this._mask;
      }
      
      public function set mask(param1:DisplayObject) : void
      {
         if(this._mask != param1)
         {
            if(this._mask)
            {
               this._mask._isMask = false;
            }
            if(param1)
            {
               param1._isMask = true;
               param1._hasVisibleArea = false;
            }
            this._mask = param1;
            this.setRequiresRedraw();
         }
      }
      
      public function get parent() : DisplayObjectContainer
      {
         return this._parent;
      }
      
      public function get base() : DisplayObject
      {
         var _loc1_:DisplayObject = this;
         while(_loc1_._parent)
         {
            _loc1_ = _loc1_._parent;
         }
         return _loc1_;
      }
      
      public function get root() : DisplayObject
      {
         var _loc1_:DisplayObject = this;
         while(_loc1_._parent)
         {
            if(_loc1_._parent is Stage)
            {
               return _loc1_;
            }
            _loc1_ = _loc1_.parent;
         }
         return null;
      }
      
      public function get stage() : Stage
      {
         return this.base as Stage;
      }
   }
}

