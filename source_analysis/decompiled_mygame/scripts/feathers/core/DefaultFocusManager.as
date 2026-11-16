package feathers.core
{
   import feathers.controls.supportClasses.*;
   import feathers.events.*;
   import feathers.utils.display.*;
   import flash.display.*;
   import flash.events.*;
   import flash.ui.*;
   import flash.utils.*;
   import starling.core.Starling;
   import starling.display.*;
   import starling.events.*;
   
   public class DefaultFocusManager implements IFocusManager
   {
      
      protected static var NATIVE_STAGE_TO_FOCUS_TARGET:Dictionary = new Dictionary(true);
      
      protected var _starling:Starling;
      
      protected var _nativeFocusTarget:NativeFocusTarget;
      
      protected var _root:starling.display.DisplayObjectContainer;
      
      protected var _isEnabled:Boolean = false;
      
      protected var _savedFocus:IFocusDisplayObject;
      
      protected var _focus:IFocusDisplayObject;
      
      public function DefaultFocusManager(param1:starling.display.DisplayObjectContainer)
      {
         super();
         if(!param1.stage)
         {
            throw new ArgumentError("Focus manager root must be added to the stage.");
         }
         this._root = param1;
         this._starling = stageToStarling(param1.stage);
      }
      
      public function get root() : starling.display.DisplayObjectContainer
      {
         return this._root;
      }
      
      public function get isEnabled() : Boolean
      {
         return this._isEnabled;
      }
      
      public function set isEnabled(param1:Boolean) : void
      {
         var _loc2_:IFocusDisplayObject = null;
         if(this._isEnabled == param1)
         {
            return;
         }
         this._isEnabled = param1;
         if(this._isEnabled)
         {
            this._nativeFocusTarget = NATIVE_STAGE_TO_FOCUS_TARGET[this._starling.nativeStage] as NativeFocusTarget;
            if(!this._nativeFocusTarget)
            {
               this._nativeFocusTarget = new NativeFocusTarget();
               this._starling.nativeOverlay.addChild(this._nativeFocusTarget);
            }
            else
            {
               ++this._nativeFocusTarget.referenceCount;
            }
            this.setFocusManager(this._root);
            this._root.addEventListener(Event.ADDED,this.topLevelContainer_addedHandler);
            this._root.addEventListener(Event.REMOVED,this.topLevelContainer_removedHandler);
            this._root.addEventListener(TouchEvent.TOUCH,this.topLevelContainer_touchHandler);
            this._starling.nativeStage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.stage_keyFocusChangeHandler,false,0,true);
            this._starling.nativeStage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.stage_mouseFocusChangeHandler,false,0,true);
            if(Boolean(this._savedFocus) && !this._savedFocus.stage)
            {
               this._savedFocus = null;
            }
            this.focus = this._savedFocus;
            this._savedFocus = null;
         }
         else
         {
            --this._nativeFocusTarget.referenceCount;
            if(this._nativeFocusTarget.referenceCount <= 0)
            {
               this._nativeFocusTarget.parent.removeChild(this._nativeFocusTarget);
               delete NATIVE_STAGE_TO_FOCUS_TARGET[this._starling.nativeStage];
            }
            this._nativeFocusTarget = null;
            this._root.removeEventListener(Event.ADDED,this.topLevelContainer_addedHandler);
            this._root.removeEventListener(Event.REMOVED,this.topLevelContainer_removedHandler);
            this._root.removeEventListener(TouchEvent.TOUCH,this.topLevelContainer_touchHandler);
            this._starling.nativeStage.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.stage_keyFocusChangeHandler);
            this._starling.nativeStage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.stage_mouseFocusChangeHandler);
            _loc2_ = this.focus;
            this.focus = null;
            this._savedFocus = _loc2_;
         }
      }
      
      public function get focus() : IFocusDisplayObject
      {
         return this._focus;
      }
      
      public function set focus(param1:IFocusDisplayObject) : void
      {
         if(this._focus == param1)
         {
            return;
         }
         var _loc2_:Boolean = false;
         var _loc3_:IFeathersDisplayObject = this._focus;
         if(Boolean(this._isEnabled && param1) && Boolean(param1.isFocusEnabled) && param1.focusManager == this)
         {
            this._focus = param1;
            _loc2_ = true;
         }
         else
         {
            this._focus = null;
         }
         var _loc4_:flash.display.Stage = this._starling.nativeStage;
         if(Boolean(_loc4_) && Boolean(_loc4_.focus))
         {
            _loc4_.focus.removeEventListener(FocusEvent.FOCUS_OUT,this.nativeFocus_focusOutHandler);
         }
         if(_loc3_)
         {
            _loc3_.dispatchEventWith(FeathersEventType.FOCUS_OUT);
         }
         if(_loc2_ && this._focus !== param1)
         {
            return;
         }
         if(this._isEnabled)
         {
            if(this._focus)
            {
               if(this._focus is INativeFocusOwner)
               {
                  _loc4_.focus = INativeFocusOwner(this._focus).nativeFocus;
               }
               if(!_loc4_.focus)
               {
                  _loc4_.focus = this._nativeFocusTarget;
               }
               _loc4_.focus.addEventListener(FocusEvent.FOCUS_OUT,this.nativeFocus_focusOutHandler,false,0,true);
               this._focus.dispatchEventWith(FeathersEventType.FOCUS_IN);
            }
            else
            {
               _loc4_.focus = null;
            }
         }
         else
         {
            this._savedFocus = param1;
         }
      }
      
      protected function setFocusManager(param1:starling.display.DisplayObject) : void
      {
         var _loc2_:IFocusDisplayObject = null;
         var _loc3_:starling.display.DisplayObjectContainer = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:starling.display.DisplayObject = null;
         var _loc7_:IFocusExtras = null;
         var _loc8_:Vector.<starling.display.DisplayObject> = null;
         if(param1 is IFocusDisplayObject)
         {
            _loc2_ = IFocusDisplayObject(param1);
            _loc2_.focusManager = this;
         }
         if(param1 is DisplayObjectContainer && !(param1 is IFocusDisplayObject) || param1 is IFocusContainer && Boolean(IFocusContainer(param1).isChildFocusEnabled))
         {
            _loc3_ = DisplayObjectContainer(param1);
            _loc4_ = _loc3_.numChildren;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = _loc3_.getChildAt(_loc5_);
               this.setFocusManager(_loc6_);
               _loc5_++;
            }
            if(_loc3_ is IFocusExtras)
            {
               _loc7_ = IFocusExtras(_loc3_);
               _loc8_ = _loc7_.focusExtrasBefore;
               if(_loc8_)
               {
                  _loc4_ = int(_loc8_.length);
                  _loc5_ = 0;
                  while(_loc5_ < _loc4_)
                  {
                     _loc6_ = _loc8_[_loc5_];
                     this.setFocusManager(_loc6_);
                     _loc5_++;
                  }
               }
               _loc8_ = _loc7_.focusExtrasAfter;
               if(_loc8_)
               {
                  _loc4_ = int(_loc8_.length);
                  _loc5_ = 0;
                  while(_loc5_ < _loc4_)
                  {
                     _loc6_ = _loc8_[_loc5_];
                     this.setFocusManager(_loc6_);
                     _loc5_++;
                  }
               }
            }
         }
      }
      
      protected function clearFocusManager(param1:starling.display.DisplayObject) : void
      {
         var _loc2_:IFocusDisplayObject = null;
         var _loc3_:starling.display.DisplayObjectContainer = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:starling.display.DisplayObject = null;
         var _loc7_:IFocusExtras = null;
         var _loc8_:Vector.<starling.display.DisplayObject> = null;
         if(param1 is IFocusDisplayObject)
         {
            _loc2_ = IFocusDisplayObject(param1);
            if(_loc2_.focusManager == this)
            {
               if(this._focus == _loc2_)
               {
                  this.focus = _loc2_.focusOwner;
               }
               _loc2_.focusManager = null;
            }
         }
         if(param1 is DisplayObjectContainer)
         {
            _loc3_ = DisplayObjectContainer(param1);
            _loc4_ = _loc3_.numChildren;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = _loc3_.getChildAt(_loc5_);
               this.clearFocusManager(_loc6_);
               _loc5_++;
            }
            if(_loc3_ is IFocusExtras)
            {
               _loc7_ = IFocusExtras(_loc3_);
               _loc8_ = _loc7_.focusExtrasBefore;
               if(_loc8_)
               {
                  _loc4_ = int(_loc8_.length);
                  _loc5_ = 0;
                  while(_loc5_ < _loc4_)
                  {
                     _loc6_ = _loc8_[_loc5_];
                     this.clearFocusManager(_loc6_);
                     _loc5_++;
                  }
               }
               _loc8_ = _loc7_.focusExtrasAfter;
               if(_loc8_)
               {
                  _loc4_ = int(_loc8_.length);
                  _loc5_ = 0;
                  while(_loc5_ < _loc4_)
                  {
                     _loc6_ = _loc8_[_loc5_];
                     this.clearFocusManager(_loc6_);
                     _loc5_++;
                  }
               }
            }
         }
      }
      
      protected function findPreviousContainerFocus(param1:starling.display.DisplayObjectContainer, param2:starling.display.DisplayObject, param3:Boolean) : IFocusDisplayObject
      {
         var _loc4_:IFocusExtras = null;
         var _loc5_:Vector.<starling.display.DisplayObject> = null;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:* = 0;
         var _loc9_:starling.display.DisplayObject = null;
         var _loc10_:IFocusDisplayObject = null;
         var _loc11_:IFocusDisplayObject = null;
         if(param1 is LayoutViewPort)
         {
            param1 = param1.parent;
         }
         var _loc12_:Boolean = param2 == null;
         if(param1 is IFocusExtras)
         {
            _loc4_ = IFocusExtras(param1);
            _loc5_ = _loc4_.focusExtrasAfter;
            if(_loc5_)
            {
               _loc6_ = false;
               if(param2)
               {
                  _loc7_ = _loc5_.indexOf(param2) - 1;
                  _loc12_ = _loc7_ >= -1;
                  _loc6_ = !_loc12_;
               }
               else
               {
                  _loc7_ = _loc5_.length - 1;
               }
               if(!_loc6_)
               {
                  _loc8_ = _loc7_;
                  while(_loc8_ >= 0)
                  {
                     _loc9_ = _loc5_[_loc8_];
                     _loc10_ = this.findPreviousChildFocus(_loc9_);
                     if(this.isValidFocus(_loc10_))
                     {
                        return _loc10_;
                     }
                     _loc8_--;
                  }
               }
            }
         }
         if(Boolean(param2) && !_loc12_)
         {
            _loc7_ = param1.getChildIndex(param2) - 1;
            _loc12_ = _loc7_ >= -1;
         }
         else
         {
            _loc7_ = param1.numChildren - 1;
         }
         _loc8_ = _loc7_;
         while(_loc8_ >= 0)
         {
            _loc9_ = param1.getChildAt(_loc8_);
            _loc10_ = this.findPreviousChildFocus(_loc9_);
            if(this.isValidFocus(_loc10_))
            {
               return _loc10_;
            }
            _loc8_--;
         }
         if(param1 is IFocusExtras)
         {
            _loc5_ = _loc4_.focusExtrasBefore;
            if(_loc5_)
            {
               _loc6_ = false;
               if(Boolean(param2) && !_loc12_)
               {
                  _loc7_ = _loc5_.indexOf(param2) - 1;
                  _loc12_ = _loc7_ >= -1;
                  _loc6_ = !_loc12_;
               }
               else
               {
                  _loc7_ = _loc5_.length - 1;
               }
               if(!_loc6_)
               {
                  _loc8_ = _loc7_;
                  while(_loc8_ >= 0)
                  {
                     _loc9_ = _loc5_[_loc8_];
                     _loc10_ = this.findPreviousChildFocus(_loc9_);
                     if(this.isValidFocus(_loc10_))
                     {
                        return _loc10_;
                     }
                     _loc8_--;
                  }
               }
            }
         }
         if(param3 && param1 != this._root)
         {
            if(param1 is IFocusDisplayObject)
            {
               _loc11_ = IFocusDisplayObject(param1);
               if(this.isValidFocus(_loc11_))
               {
                  return _loc11_;
               }
            }
            return this.findPreviousContainerFocus(param1.parent,param1,true);
         }
         return null;
      }
      
      protected function findNextContainerFocus(param1:starling.display.DisplayObjectContainer, param2:starling.display.DisplayObject, param3:Boolean) : IFocusDisplayObject
      {
         var _loc4_:IFocusExtras = null;
         var _loc5_:Vector.<starling.display.DisplayObject> = null;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:starling.display.DisplayObject = null;
         var _loc11_:IFocusDisplayObject = null;
         if(param1 is LayoutViewPort)
         {
            param1 = param1.parent;
         }
         var _loc12_:Boolean = param2 == null;
         if(param1 is IFocusExtras)
         {
            _loc4_ = IFocusExtras(param1);
            _loc5_ = _loc4_.focusExtrasBefore;
            if(_loc5_)
            {
               _loc6_ = false;
               if(param2)
               {
                  _loc7_ = _loc5_.indexOf(param2) + 1;
                  _loc12_ = _loc7_ > 0;
                  _loc6_ = !_loc12_;
               }
               else
               {
                  _loc7_ = 0;
               }
               if(!_loc6_)
               {
                  _loc8_ = int(_loc5_.length);
                  _loc9_ = _loc7_;
                  while(_loc9_ < _loc8_)
                  {
                     _loc10_ = _loc5_[_loc9_];
                     _loc11_ = this.findNextChildFocus(_loc10_);
                     if(this.isValidFocus(_loc11_))
                     {
                        return _loc11_;
                     }
                     _loc9_++;
                  }
               }
            }
         }
         if(Boolean(param2) && !_loc12_)
         {
            _loc7_ = param1.getChildIndex(param2) + 1;
            _loc12_ = _loc7_ > 0;
         }
         else
         {
            _loc7_ = 0;
         }
         _loc8_ = param1.numChildren;
         _loc9_ = _loc7_;
         while(_loc9_ < _loc8_)
         {
            _loc10_ = param1.getChildAt(_loc9_);
            _loc11_ = this.findNextChildFocus(_loc10_);
            if(this.isValidFocus(_loc11_))
            {
               return _loc11_;
            }
            _loc9_++;
         }
         if(param1 is IFocusExtras)
         {
            _loc5_ = _loc4_.focusExtrasAfter;
            if(_loc5_)
            {
               _loc6_ = false;
               if(Boolean(param2) && !_loc12_)
               {
                  _loc7_ = _loc5_.indexOf(param2) + 1;
                  _loc12_ = _loc7_ > 0;
                  _loc6_ = !_loc12_;
               }
               else
               {
                  _loc7_ = 0;
               }
               if(!_loc6_)
               {
                  _loc8_ = int(_loc5_.length);
                  _loc9_ = _loc7_;
                  while(_loc9_ < _loc8_)
                  {
                     _loc10_ = _loc5_[_loc9_];
                     _loc11_ = this.findNextChildFocus(_loc10_);
                     if(this.isValidFocus(_loc11_))
                     {
                        return _loc11_;
                     }
                     _loc9_++;
                  }
               }
            }
         }
         if(param3 && param1 != this._root)
         {
            return this.findNextContainerFocus(param1.parent,param1,true);
         }
         return null;
      }
      
      protected function findPreviousChildFocus(param1:starling.display.DisplayObject) : IFocusDisplayObject
      {
         var _loc2_:starling.display.DisplayObjectContainer = null;
         var _loc3_:IFocusDisplayObject = null;
         var _loc4_:IFocusDisplayObject = null;
         if(param1 is DisplayObjectContainer && !(param1 is IFocusDisplayObject) || param1 is IFocusContainer && Boolean(IFocusContainer(param1).isChildFocusEnabled))
         {
            _loc2_ = DisplayObjectContainer(param1);
            _loc3_ = this.findPreviousContainerFocus(_loc2_,null,false);
            if(_loc3_)
            {
               return _loc3_;
            }
         }
         if(param1 is IFocusDisplayObject)
         {
            _loc4_ = IFocusDisplayObject(param1);
            if(this.isValidFocus(_loc4_))
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      protected function findNextChildFocus(param1:starling.display.DisplayObject) : IFocusDisplayObject
      {
         var _loc2_:IFocusDisplayObject = null;
         var _loc3_:starling.display.DisplayObjectContainer = null;
         var _loc4_:IFocusDisplayObject = null;
         if(param1 is IFocusDisplayObject)
         {
            _loc2_ = IFocusDisplayObject(param1);
            if(this.isValidFocus(_loc2_))
            {
               return _loc2_;
            }
         }
         if(param1 is DisplayObjectContainer && !(param1 is IFocusDisplayObject) || param1 is IFocusContainer && Boolean(IFocusContainer(param1).isChildFocusEnabled))
         {
            _loc3_ = DisplayObjectContainer(param1);
            _loc4_ = this.findNextContainerFocus(_loc3_,null,false);
            if(_loc4_)
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      protected function isValidFocus(param1:IFocusDisplayObject) : Boolean
      {
         if(!param1 || !param1.isFocusEnabled || param1.focusManager != this)
         {
            return false;
         }
         var _loc2_:IFeathersControl = param1 as IFeathersControl;
         if(Boolean(_loc2_) && !_loc2_.isEnabled)
         {
            return false;
         }
         return true;
      }
      
      protected function stage_mouseFocusChangeHandler(param1:FocusEvent) : void
      {
         if(param1.relatedObject)
         {
            this.focus = null;
            return;
         }
         param1.preventDefault();
      }
      
      protected function stage_keyFocusChangeHandler(param1:FocusEvent) : void
      {
         var _loc2_:IFocusDisplayObject = null;
         if(param1.keyCode != Keyboard.TAB && param1.keyCode != 0)
         {
            return;
         }
         var _loc3_:IFocusDisplayObject = this._focus;
         if(Boolean(_loc3_) && Boolean(_loc3_.focusOwner))
         {
            _loc2_ = _loc3_.focusOwner;
         }
         else if(param1.shiftKey)
         {
            if(_loc3_)
            {
               if(_loc3_.previousTabFocus)
               {
                  _loc2_ = _loc3_.previousTabFocus;
               }
               else
               {
                  _loc2_ = this.findPreviousContainerFocus(_loc3_.parent,DisplayObject(_loc3_),true);
               }
            }
            if(!_loc2_)
            {
               _loc2_ = this.findPreviousContainerFocus(this._root,null,false);
            }
         }
         else
         {
            if(_loc3_)
            {
               if(_loc3_.nextTabFocus)
               {
                  _loc2_ = _loc3_.nextTabFocus;
               }
               else if(_loc3_ is IFocusContainer && Boolean(IFocusContainer(_loc3_).isChildFocusEnabled))
               {
                  _loc2_ = this.findNextContainerFocus(DisplayObjectContainer(_loc3_),null,false);
               }
               else
               {
                  _loc2_ = this.findNextContainerFocus(_loc3_.parent,DisplayObject(_loc3_),true);
               }
            }
            if(!_loc2_)
            {
               _loc2_ = this.findNextContainerFocus(this._root,null,false);
            }
         }
         if(_loc2_)
         {
            param1.preventDefault();
         }
         this.focus = _loc2_;
         if(this._focus)
         {
            this._focus.showFocus();
         }
      }
      
      protected function topLevelContainer_addedHandler(param1:starling.events.Event) : void
      {
         this.setFocusManager(DisplayObject(param1.target));
      }
      
      protected function topLevelContainer_removedHandler(param1:starling.events.Event) : void
      {
         this.clearFocusManager(DisplayObject(param1.target));
      }
      
      protected function topLevelContainer_touchHandler(param1:starling.events.TouchEvent) : void
      {
         var _loc2_:IFocusDisplayObject = null;
         var _loc3_:Touch = param1.getTouch(this._root,TouchPhase.BEGAN);
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:IFocusDisplayObject = null;
         var _loc5_:starling.display.DisplayObject = _loc3_.target;
         do
         {
            if(_loc5_ is IFocusDisplayObject)
            {
               _loc2_ = IFocusDisplayObject(_loc5_);
               if(this.isValidFocus(_loc2_))
               {
                  if(!_loc4_ || !(_loc2_ is IFocusContainer) || !IFocusContainer(_loc2_).isChildFocusEnabled)
                  {
                     _loc4_ = _loc2_;
                  }
               }
            }
            _loc5_ = _loc5_.parent;
         }
         while(_loc5_);
         this.focus = _loc4_;
      }
      
      protected function nativeFocus_focusOutHandler(param1:FocusEvent) : void
      {
         var _loc2_:InteractiveObject = InteractiveObject(param1.currentTarget);
         var _loc3_:flash.display.Stage = this._starling.nativeStage;
         if(Boolean(this._focus) && !_loc3_.focus)
         {
            _loc3_.focus = _loc2_;
         }
         if(_loc2_ != _loc3_.focus)
         {
            _loc2_.removeEventListener(FocusEvent.FOCUS_OUT,this.nativeFocus_focusOutHandler);
         }
      }
   }
}

import flash.display.Sprite;

class NativeFocusTarget extends Sprite
{
   
   public var referenceCount:int = 1;
   
   public function NativeFocusTarget()
   {
      super();
      this.tabEnabled = true;
      this.mouseEnabled = false;
      this.mouseChildren = false;
      this.alpha = 0;
   }
}
