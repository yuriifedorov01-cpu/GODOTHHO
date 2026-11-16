package starling.display
{
   import flash.geom.*;
   import flash.system.*;
   import flash.utils.*;
   import starling.core.starling_internal;
   import starling.errors.*;
   import starling.events.*;
   import starling.filters.FragmentFilter;
   import starling.rendering.*;
   import starling.utils.*;
   
   use namespace starling_internal;
   
   public class DisplayObjectContainer extends DisplayObject
   {
      
      private static var sHelperMatrix:Matrix = new Matrix();
      
      private static var sHelperPoint:Point = new Point();
      
      private static var sBroadcastListeners:Vector.<DisplayObject> = null;
      
      private static var sSortBuffer:Vector.<DisplayObject> = null;
      
      private static var sCacheToken:BatchToken = new BatchToken();
      
      private var _children:Vector.<DisplayObject>;
      
      private var _touchGroup:Boolean;
      
      public function DisplayObjectContainer()
      {
         super();
         if(Boolean(Capabilities.isDebugger) && getQualifiedClassName(this) == "starling.display::DisplayObjectContainer")
         {
            throw new AbstractClassError();
         }
         this._children = new Vector.<DisplayObject>(0);
      }
      
      private static function mergeSort(param1:Vector.<DisplayObject>, param2:Function, param3:int, param4:int, param5:Vector.<DisplayObject>) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(param4 > 1)
         {
            _loc7_ = param3 + param4;
            _loc8_ = param4 / 2;
            _loc9_ = param3;
            _loc10_ = param3 + _loc8_;
            mergeSort(param1,param2,param3,_loc8_,param5);
            mergeSort(param1,param2,param3 + _loc8_,param4 - _loc8_,param5);
            _loc6_ = 0;
            while(_loc6_ < param4)
            {
               if(_loc9_ < param3 + _loc8_ && (_loc10_ == _loc7_ || param2(param1[_loc9_],param1[_loc10_]) <= 0))
               {
                  param5[_loc6_] = param1[_loc9_];
                  _loc9_++;
               }
               else
               {
                  param5[_loc6_] = param1[_loc10_];
                  _loc10_++;
               }
               _loc6_++;
            }
            _loc6_ = param3;
            while(_loc6_ < _loc7_)
            {
               param1[_loc6_] = param5[int(_loc6_ - param3)];
               _loc6_++;
            }
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:* = int(this._children.length - 1);
         while(_loc1_ >= 0)
         {
            this._children[_loc1_].dispose();
            _loc1_--;
         }
         super.dispose();
      }
      
      public function addChild(param1:DisplayObject) : DisplayObject
      {
         return this.addChildAt(param1,this._children.length);
      }
      
      public function addChildAt(param1:DisplayObject, param2:int) : DisplayObject
      {
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:int = int(this._children.length);
         if(param2 >= 0 && param2 <= _loc4_)
         {
            setRequiresRedraw();
            if(param1.parent == this)
            {
               this.setChildIndex(param1,param2);
            }
            else
            {
               this._children.insertAt(param2,param1);
               param1.removeFromParent();
               param1.setParent(this);
               param1.dispatchEventWith(Event.ADDED,true);
               if(stage)
               {
                  _loc3_ = param1 as DisplayObjectContainer;
                  if(_loc3_)
                  {
                     _loc3_.broadcastEventWith(Event.ADDED_TO_STAGE);
                  }
                  else
                  {
                     param1.dispatchEventWith(Event.ADDED_TO_STAGE);
                  }
               }
            }
            return param1;
         }
         throw new RangeError("Invalid child index");
      }
      
      public function removeChild(param1:DisplayObject, param2:Boolean = false) : DisplayObject
      {
         var _loc3_:int = this.getChildIndex(param1);
         if(_loc3_ != -1)
         {
            return this.removeChildAt(_loc3_,param2);
         }
         return null;
      }
      
      public function removeChildAt(param1:int, param2:Boolean = false) : DisplayObject
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:DisplayObjectContainer = null;
         if(param1 >= 0 && param1 < this._children.length)
         {
            setRequiresRedraw();
            _loc3_ = this._children[param1];
            _loc3_.dispatchEventWith(Event.REMOVED,true);
            if(stage)
            {
               _loc4_ = _loc3_ as DisplayObjectContainer;
               if(_loc4_)
               {
                  _loc4_.broadcastEventWith(Event.REMOVED_FROM_STAGE);
               }
               else
               {
                  _loc3_.dispatchEventWith(Event.REMOVED_FROM_STAGE);
               }
            }
            _loc3_.setParent(null);
            param1 = int(this._children.indexOf(_loc3_));
            if(param1 >= 0)
            {
               this._children.removeAt(param1);
            }
            if(param2)
            {
               _loc3_.dispose();
            }
            return _loc3_;
         }
         throw new RangeError("Invalid child index");
      }
      
      public function removeChildren(param1:int = 0, param2:int = -1, param3:Boolean = false) : void
      {
         if(param2 < 0 || param2 >= this.numChildren)
         {
            param2 = this.numChildren - 1;
         }
         var _loc4_:int = param1;
         while(_loc4_ <= param2)
         {
            this.removeChildAt(param1,param3);
            _loc4_++;
         }
      }
      
      public function getChildAt(param1:int) : DisplayObject
      {
         var _loc2_:int = int(this._children.length);
         if(param1 < 0)
         {
            param1 = _loc2_ + param1;
         }
         if(param1 >= 0 && param1 < _loc2_)
         {
            return this._children[param1];
         }
         throw new RangeError("Invalid child index");
      }
      
      public function getChildByName(param1:String) : DisplayObject
      {
         var _loc2_:int = int(this._children.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._children[_loc3_].name == param1)
            {
               return this._children[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getChildIndex(param1:DisplayObject) : int
      {
         return this._children.indexOf(param1);
      }
      
      public function setChildIndex(param1:DisplayObject, param2:int) : void
      {
         var _loc3_:int = this.getChildIndex(param1);
         if(_loc3_ == param2)
         {
            return;
         }
         if(_loc3_ == -1)
         {
            throw new ArgumentError("Not a child of this container");
         }
         this._children.removeAt(_loc3_);
         this._children.insertAt(param2,param1);
         setRequiresRedraw();
      }
      
      public function swapChildren(param1:DisplayObject, param2:DisplayObject) : void
      {
         var _loc3_:int = this.getChildIndex(param1);
         var _loc4_:int = this.getChildIndex(param2);
         if(_loc3_ == -1 || _loc4_ == -1)
         {
            throw new ArgumentError("Not a child of this container");
         }
         this.swapChildrenAt(_loc3_,_loc4_);
      }
      
      public function swapChildrenAt(param1:int, param2:int) : void
      {
         var _loc3_:DisplayObject = this.getChildAt(param1);
         var _loc4_:DisplayObject = this.getChildAt(param2);
         this._children[param1] = _loc4_;
         this._children[param2] = _loc3_;
         setRequiresRedraw();
      }
      
      public function sortChildren(param1:Function) : void
      {
         if(sSortBuffer == null)
         {
            sSortBuffer = new Vector.<DisplayObject>(0);
         }
         sSortBuffer.length = this._children.length;
         mergeSort(this._children,param1,0,this._children.length,sSortBuffer);
         sSortBuffer.length = 0;
         setRequiresRedraw();
      }
      
      public function contains(param1:DisplayObject) : Boolean
      {
         while(param1)
         {
            if(param1 == this)
            {
               return true;
            }
            param1 = param1.parent;
         }
         return false;
      }
      
      override public function getBounds(param1:DisplayObject, param2:Rectangle = null) : Rectangle
      {
         var _loc3_:Number = Number(NaN);
         var _loc4_:Number = Number(NaN);
         var _loc5_:Number = Number(NaN);
         var _loc6_:Number = Number(NaN);
         var _loc7_:int = 0;
         if(param2 == null)
         {
            param2 = new Rectangle();
         }
         var _loc8_:int = int(this._children.length);
         if(_loc8_ == 0)
         {
            getTransformationMatrix(param1,sHelperMatrix);
            MatrixUtil.transformCoords(sHelperMatrix,0,0,sHelperPoint);
            param2.setTo(sHelperPoint.x,sHelperPoint.y,0,0);
         }
         else if(_loc8_ == 1)
         {
            this._children[0].getBounds(param1,param2);
         }
         else
         {
            _loc3_ = Number.MAX_VALUE;
            _loc4_ = -Number.MAX_VALUE;
            _loc5_ = Number.MAX_VALUE;
            _loc6_ = -Number.MAX_VALUE;
            _loc7_ = 0;
            while(_loc7_ < _loc8_)
            {
               this._children[_loc7_].getBounds(param1,param2);
               if(_loc3_ > param2.x)
               {
                  _loc3_ = param2.x;
               }
               if(_loc4_ < param2.right)
               {
                  _loc4_ = param2.right;
               }
               if(_loc5_ > param2.y)
               {
                  _loc5_ = param2.y;
               }
               if(_loc6_ < param2.bottom)
               {
                  _loc6_ = param2.bottom;
               }
               _loc7_++;
            }
            param2.setTo(_loc3_,_loc5_,_loc4_ - _loc3_,_loc6_ - _loc5_);
         }
         return param2;
      }
      
      override public function hitTest(param1:Point) : DisplayObject
      {
         var _loc2_:DisplayObject = null;
         if(!visible || !touchable || !hitTestMask(param1))
         {
            return null;
         }
         var _loc3_:DisplayObject = null;
         var _loc4_:Number = param1.x;
         var _loc5_:Number = param1.y;
         var _loc6_:int = int(this._children.length);
         var _loc7_:* = int(_loc6_ - 1);
         while(_loc7_ >= 0)
         {
            _loc2_ = this._children[_loc7_];
            if(!_loc2_.isMask)
            {
               sHelperMatrix.copyFrom(_loc2_.transformationMatrix);
               sHelperMatrix.invert();
               MatrixUtil.transformCoords(sHelperMatrix,_loc4_,_loc5_,sHelperPoint);
               _loc3_ = _loc2_.hitTest(sHelperPoint);
               if(_loc3_)
               {
                  return this._touchGroup ? this : _loc3_;
               }
            }
            _loc7_--;
         }
         return null;
      }
      
      override public function render(param1:Painter) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:FragmentFilter = null;
         var _loc5_:int = int(this._children.length);
         var _loc6_:uint = param1.frameID;
         var _loc7_:Boolean = _lastParentOrSelfChangeFrameID == _loc6_;
         var _loc8_:int = 0;
         while(_loc8_ < _loc5_)
         {
            _loc2_ = this._children[_loc8_];
            if(_loc2_._hasVisibleArea)
            {
               if(_loc7_)
               {
                  _loc2_._lastParentOrSelfChangeFrameID = _loc6_;
               }
               if(_loc2_._lastParentOrSelfChangeFrameID != _loc6_ && _loc2_._lastChildChangeFrameID != _loc6_ && _loc2_._tokenFrameID == _loc6_ - 1)
               {
                  param1.pushState(sCacheToken);
                  param1.drawFromCache(_loc2_._pushToken,_loc2_._popToken);
                  param1.popState(_loc2_._popToken);
                  _loc2_._pushToken.copyFrom(sCacheToken);
               }
               else
               {
                  _loc3_ = _loc2_._mask;
                  _loc4_ = _loc2_._filter;
                  param1.pushState(_loc2_._pushToken);
                  param1.setStateTo(_loc2_.transformationMatrix,_loc2_.alpha,_loc2_.blendMode);
                  if(_loc3_)
                  {
                     param1.drawMask(_loc3_,_loc2_);
                  }
                  if(_loc4_)
                  {
                     _loc4_.render(param1);
                  }
                  else
                  {
                     _loc2_.render(param1);
                  }
                  if(_loc3_)
                  {
                     param1.eraseMask(_loc3_);
                  }
                  param1.popState(_loc2_._popToken);
               }
               _loc2_._tokenFrameID = _loc6_;
            }
            _loc8_++;
         }
      }
      
      public function broadcastEvent(param1:Event) : void
      {
         if(param1.bubbles)
         {
            throw new ArgumentError("Broadcast of bubbling events is prohibited");
         }
         if(sBroadcastListeners == null)
         {
            sBroadcastListeners = new Vector.<DisplayObject>(0);
         }
         var _loc2_:int = int(sBroadcastListeners.length);
         this.getChildEventListeners(this,param1.type,sBroadcastListeners);
         var _loc3_:int = int(sBroadcastListeners.length);
         var _loc4_:int = _loc2_;
         while(_loc4_ < _loc3_)
         {
            sBroadcastListeners[_loc4_].dispatchEvent(param1);
            _loc4_++;
         }
         sBroadcastListeners.length = _loc2_;
      }
      
      public function broadcastEventWith(param1:String, param2:Object = null) : void
      {
         var _loc3_:Event = Event.fromPool(param1,false,param2);
         this.broadcastEvent(_loc3_);
         Event.toPool(_loc3_);
      }
      
      public function get numChildren() : int
      {
         return this._children.length;
      }
      
      public function get touchGroup() : Boolean
      {
         return this._touchGroup;
      }
      
      public function set touchGroup(param1:Boolean) : void
      {
         this._touchGroup = param1;
      }
      
      internal function getChildEventListeners(param1:DisplayObject, param2:String, param3:Vector.<DisplayObject>) : void
      {
         var _loc4_:Vector.<DisplayObject> = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:DisplayObjectContainer = param1 as DisplayObjectContainer;
         if(param1.hasEventListener(param2))
         {
            param3[param3.length] = param1;
         }
         if(_loc7_)
         {
            _loc4_ = _loc7_._children;
            _loc5_ = int(_loc4_.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               this.getChildEventListeners(_loc4_[_loc6_],param2,param3);
               _loc6_++;
            }
         }
      }
   }
}

