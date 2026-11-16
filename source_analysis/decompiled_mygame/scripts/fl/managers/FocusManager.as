package fl.managers
{
   import fl.controls.*;
   import fl.core.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   
   public class FocusManager implements IFocusManager
   {
      
      private var focusableObjects:Dictionary;
      
      private var _showFocusIndicator:Boolean = true;
      
      private var defButton:Button;
      
      private var focusableCandidates:Array;
      
      private var _form:DisplayObjectContainer;
      
      private var _defaultButtonEnabled:Boolean = true;
      
      private var activated:Boolean = false;
      
      private var _defaultButton:Button;
      
      private var calculateCandidates:Boolean = true;
      
      private var lastFocus:InteractiveObject;
      
      private var lastAction:String;
      
      public function FocusManager(param1:DisplayObjectContainer)
      {
         super();
         this.focusableObjects = new Dictionary(true);
         if(param1 != null)
         {
            this._form = param1;
            this.addFocusables(DisplayObject(param1));
            param1.addEventListener(Event.ADDED,this.addedHandler);
            param1.addEventListener(Event.REMOVED,this.removedHandler);
            this.activate();
         }
      }
      
      public function get showFocusIndicator() : Boolean
      {
         return this._showFocusIndicator;
      }
      
      private function getIndexOfNextObject(param1:int, param2:Boolean, param3:Boolean, param4:String) : int
      {
         var _loc5_:DisplayObject = null;
         var _loc6_:IFocusManagerGroup = null;
         var _loc7_:int = 0;
         var _loc8_:DisplayObject = null;
         var _loc9_:IFocusManagerGroup = null;
         var _loc10_:int = int(this.focusableCandidates.length);
         var _loc11_:int = param1;
         while(true)
         {
            if(param2)
            {
               param1--;
            }
            else
            {
               param1++;
            }
            if(param3)
            {
               if(param2 && param1 < 0)
               {
                  break;
               }
               if(!param2 && param1 == _loc10_)
               {
                  break;
               }
            }
            else
            {
               param1 = int((param1 + _loc10_) % _loc10_);
               if(_loc11_ == param1)
               {
                  break;
               }
            }
            if(this.isValidFocusCandidate(this.focusableCandidates[param1],param4))
            {
               _loc5_ = DisplayObject(this.findFocusManagerComponent(this.focusableCandidates[param1]));
               if(_loc5_ is IFocusManagerGroup)
               {
                  _loc6_ = IFocusManagerGroup(_loc5_);
                  _loc7_ = 0;
                  while(_loc7_ < this.focusableCandidates.length)
                  {
                     _loc8_ = this.focusableCandidates[_loc7_];
                     if(_loc8_ is IFocusManagerGroup)
                     {
                        _loc9_ = IFocusManagerGroup(_loc8_);
                        if(_loc9_.groupName == _loc6_.groupName && _loc9_.selected)
                        {
                           param1 = _loc7_;
                           break;
                        }
                     }
                     _loc7_++;
                  }
               }
               return param1;
            }
         }
         return param1;
      }
      
      private function mouseFocusChangeHandler(param1:FocusEvent) : void
      {
         if(param1.relatedObject is TextField)
         {
            return;
         }
         param1.preventDefault();
      }
      
      public function set form(param1:DisplayObjectContainer) : void
      {
         this._form = param1;
      }
      
      private function addFocusables(param1:DisplayObject, param2:Boolean = false) : void
      {
         var _loc3_:IFocusManagerComponent = null;
         var _loc4_:InteractiveObject = null;
         var _loc5_:DisplayObjectContainer = null;
         var _loc6_:int = 0;
         var _loc7_:DisplayObject = null;
         var _loc8_:DisplayObject = param1;
         var _loc9_:Boolean = param2;
         if(!_loc9_)
         {
            if(_loc8_ is IFocusManagerComponent)
            {
               _loc3_ = IFocusManagerComponent(_loc8_);
               if(_loc3_.focusEnabled)
               {
                  if(_loc3_.tabEnabled && Boolean(this.isTabVisible(_loc8_)))
                  {
                     this.focusableObjects[_loc8_] = true;
                     this.calculateCandidates = true;
                  }
                  _loc8_.addEventListener(Event.TAB_ENABLED_CHANGE,this.tabEnabledChangeHandler);
                  _loc8_.addEventListener(Event.TAB_INDEX_CHANGE,this.tabIndexChangeHandler);
               }
            }
            else if(_loc8_ is InteractiveObject)
            {
               _loc4_ = _loc8_ as InteractiveObject;
               if(Boolean(_loc4_) && Boolean(_loc4_.tabEnabled) && this.findFocusManagerComponent(_loc4_) == _loc4_)
               {
                  this.focusableObjects[_loc4_] = true;
                  this.calculateCandidates = true;
               }
               _loc4_.addEventListener(Event.TAB_ENABLED_CHANGE,this.tabEnabledChangeHandler);
               _loc4_.addEventListener(Event.TAB_INDEX_CHANGE,this.tabIndexChangeHandler);
            }
         }
         if(_loc8_ is DisplayObjectContainer)
         {
            _loc5_ = DisplayObjectContainer(_loc8_);
            _loc8_.addEventListener(Event.TAB_CHILDREN_CHANGE,this.tabChildrenChangeHandler);
            if(_loc5_ is Stage || _loc5_.parent is Stage || _loc5_.tabChildren)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc5_.numChildren)
               {
                  try
                  {
                     _loc7_ = _loc5_.getChildAt(_loc6_);
                     if(_loc7_ != null)
                     {
                        this.addFocusables(_loc5_.getChildAt(_loc6_));
                     }
                  }
                  catch(error:SecurityError)
                  {
                  }
                  _loc6_++;
               }
            }
         }
      }
      
      private function getChildIndex(param1:DisplayObjectContainer, param2:DisplayObject) : int
      {
         return param1.getChildIndex(param2);
      }
      
      public function findFocusManagerComponent(param1:InteractiveObject) : InteractiveObject
      {
         var _loc2_:InteractiveObject = param1;
         while(param1)
         {
            if(param1 is IFocusManagerComponent && Boolean(IFocusManagerComponent(param1).focusEnabled))
            {
               return param1;
            }
            param1 = param1.parent;
         }
         return _loc2_;
      }
      
      private function focusOutHandler(param1:FocusEvent) : void
      {
         var _loc2_:InteractiveObject = param1.target as InteractiveObject;
      }
      
      private function isValidFocusCandidate(param1:DisplayObject, param2:String) : Boolean
      {
         var _loc3_:IFocusManagerGroup = null;
         if(!this.isEnabledAndVisible(param1))
         {
            return false;
         }
         if(param1 is IFocusManagerGroup)
         {
            _loc3_ = IFocusManagerGroup(param1);
            if(param2 == _loc3_.groupName)
            {
               return false;
            }
         }
         return true;
      }
      
      private function setFocusToNextObject(param1:FocusEvent) : void
      {
         if(!this.hasFocusableObjects())
         {
            return;
         }
         var _loc2_:InteractiveObject = this.getNextFocusManagerComponent(param1.shiftKey);
         if(_loc2_)
         {
            this.setFocus(_loc2_);
         }
      }
      
      private function sortFocusableObjectsTabIndex() : void
      {
         var _loc1_:Object = null;
         var _loc2_:InteractiveObject = null;
         this.focusableCandidates = [];
         for(_loc1_ in this.focusableObjects)
         {
            _loc2_ = InteractiveObject(_loc1_);
            if(Boolean(_loc2_.tabIndex) && !isNaN(Number(_loc2_.tabIndex)))
            {
               this.focusableCandidates.push(_loc2_);
            }
         }
         this.focusableCandidates.sort(this.sortByTabIndex);
      }
      
      private function removeFocusables(param1:DisplayObject) : void
      {
         var _loc2_:Object = null;
         var _loc3_:DisplayObject = null;
         if(param1 is DisplayObjectContainer)
         {
            param1.removeEventListener(Event.TAB_CHILDREN_CHANGE,this.tabChildrenChangeHandler);
            param1.removeEventListener(Event.TAB_INDEX_CHANGE,this.tabIndexChangeHandler);
            for(_loc2_ in this.focusableObjects)
            {
               _loc3_ = DisplayObject(_loc2_);
               if(DisplayObjectContainer(param1).contains(_loc3_))
               {
                  if(_loc3_ == this.lastFocus)
                  {
                     this.lastFocus = null;
                  }
                  _loc3_.removeEventListener(Event.TAB_ENABLED_CHANGE,this.tabEnabledChangeHandler);
                  delete this.focusableObjects[_loc2_];
                  this.calculateCandidates = true;
               }
            }
         }
      }
      
      private function getTopLevelFocusTarget(param1:InteractiveObject) : InteractiveObject
      {
         while(param1 != InteractiveObject(this.form))
         {
            if(param1 is IFocusManagerComponent && Boolean(IFocusManagerComponent(param1).focusEnabled) && Boolean(IFocusManagerComponent(param1).mouseFocusEnabled) && Boolean(UIComponent(param1).enabled))
            {
               return param1;
            }
            param1 = param1.parent;
            if(param1 == null)
            {
               break;
            }
         }
         return null;
      }
      
      public function sendDefaultButtonEvent() : void
      {
         this.defButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }
      
      private function addedHandler(param1:Event) : void
      {
         var _loc2_:DisplayObject = DisplayObject(param1.target);
         if(_loc2_.stage)
         {
            this.addFocusables(DisplayObject(param1.target));
         }
      }
      
      private function isEnabledAndVisible(param1:DisplayObject) : Boolean
      {
         var _loc2_:TextField = null;
         var _loc3_:SimpleButton = null;
         var _loc4_:DisplayObjectContainer = DisplayObject(this.form).parent;
         while(param1 != _loc4_)
         {
            if(param1 is UIComponent)
            {
               if(!UIComponent(param1).enabled)
               {
                  return false;
               }
            }
            else if(param1 is TextField)
            {
               _loc2_ = TextField(param1);
               if(_loc2_.type == TextFieldType.DYNAMIC || !_loc2_.selectable)
               {
                  return false;
               }
            }
            else if(param1 is SimpleButton)
            {
               _loc3_ = SimpleButton(param1);
               if(!_loc3_.enabled)
               {
                  return false;
               }
            }
            if(!param1.visible)
            {
               return false;
            }
            param1 = param1.parent;
         }
         return true;
      }
      
      private function tabChildrenChangeHandler(param1:Event) : void
      {
         if(param1.target != param1.currentTarget)
         {
            return;
         }
         this.calculateCandidates = true;
         var _loc2_:DisplayObjectContainer = DisplayObjectContainer(param1.target);
         if(_loc2_.tabChildren)
         {
            this.addFocusables(_loc2_,true);
         }
         else
         {
            this.removeFocusables(_loc2_);
         }
      }
      
      private function deactivateHandler(param1:Event) : void
      {
         var _loc2_:InteractiveObject = InteractiveObject(param1.target);
      }
      
      public function setFocus(param1:InteractiveObject) : void
      {
         if(param1 is IFocusManagerComponent)
         {
            IFocusManagerComponent(param1).setFocus();
         }
         else
         {
            this.form.stage.focus = param1;
         }
      }
      
      public function getFocus() : InteractiveObject
      {
         var _loc1_:InteractiveObject = this.form.stage.focus;
         return this.findFocusManagerComponent(_loc1_);
      }
      
      private function hasFocusableObjects() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:* = this.focusableObjects;
         var _loc4_:int = 0;
         var _loc5_:* = _loc3_;
         for(_loc1_ in _loc5_)
         {
            return true;
         }
         return false;
      }
      
      private function tabIndexChangeHandler(param1:Event) : void
      {
         this.calculateCandidates = true;
      }
      
      public function set defaultButton(param1:Button) : void
      {
         var _loc2_:Button = param1 ? Button(param1) : null;
         if(_loc2_ != this._defaultButton)
         {
            if(this._defaultButton)
            {
               this._defaultButton.emphasized = false;
            }
            if(this.defButton)
            {
               this.defButton.emphasized = false;
            }
            this._defaultButton = _loc2_;
            this.defButton = _loc2_;
            if(_loc2_)
            {
               _loc2_.emphasized = true;
            }
         }
      }
      
      private function sortFocusableObjects() : void
      {
         var _loc1_:Object = null;
         var _loc2_:InteractiveObject = null;
         this.focusableCandidates = [];
         for(_loc1_ in this.focusableObjects)
         {
            _loc2_ = InteractiveObject(_loc1_);
            if(Boolean(_loc2_.tabIndex) && Boolean(!isNaN(Number(_loc2_.tabIndex))) && _loc2_.tabIndex > 0)
            {
               this.sortFocusableObjectsTabIndex();
               return;
            }
            this.focusableCandidates.push(_loc2_);
         }
         this.focusableCandidates.sort(this.sortByDepth);
      }
      
      private function keyFocusChangeHandler(param1:FocusEvent) : void
      {
         this.showFocusIndicator = true;
         if((param1.keyCode == Keyboard.TAB || param1.keyCode == 0) && !param1.isDefaultPrevented())
         {
            this.setFocusToNextObject(param1);
            param1.preventDefault();
         }
      }
      
      private function getIndexOfFocusedObject(param1:DisplayObject) : int
      {
         var _loc2_:int = int(this.focusableCandidates.length);
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.focusableCandidates[_loc3_] == param1)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      public function hideFocus() : void
      {
      }
      
      private function removedHandler(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:InteractiveObject = null;
         var _loc4_:DisplayObject = DisplayObject(param1.target);
         if(_loc4_ is IFocusManagerComponent && this.focusableObjects[_loc4_] == true)
         {
            if(_loc4_ == this.lastFocus)
            {
               IFocusManagerComponent(this.lastFocus).drawFocus(false);
               this.lastFocus = null;
            }
            _loc4_.removeEventListener(Event.TAB_ENABLED_CHANGE,this.tabEnabledChangeHandler);
            delete this.focusableObjects[_loc4_];
            this.calculateCandidates = true;
         }
         else if(_loc4_ is InteractiveObject && this.focusableObjects[_loc4_] == true)
         {
            _loc3_ = _loc4_ as InteractiveObject;
            if(_loc3_)
            {
               if(_loc3_ == this.lastFocus)
               {
                  this.lastFocus = null;
               }
               delete this.focusableObjects[_loc3_];
               this.calculateCandidates = true;
            }
            _loc4_.addEventListener(Event.TAB_ENABLED_CHANGE,this.tabEnabledChangeHandler);
         }
         this.removeFocusables(_loc4_);
      }
      
      private function sortByDepth(param1:InteractiveObject, param2:InteractiveObject) : Number
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = "";
         var _loc7_:String = "";
         var _loc8_:String = "0000";
         var _loc9_:DisplayObject = DisplayObject(param1);
         var _loc10_:DisplayObject = DisplayObject(param2);
         while(_loc9_ != DisplayObject(this.form) && Boolean(_loc9_.parent))
         {
            _loc3_ = int(this.getChildIndex(_loc9_.parent,_loc9_));
            _loc4_ = _loc3_.toString(16);
            if(_loc4_.length < 4)
            {
               _loc5_ = _loc8_.substring(0,4 - _loc4_.length) + _loc4_;
            }
            _loc6_ = _loc5_ + _loc6_;
            _loc9_ = _loc9_.parent;
         }
         while(_loc10_ != DisplayObject(this.form) && Boolean(_loc10_.parent))
         {
            _loc3_ = int(this.getChildIndex(_loc10_.parent,_loc10_));
            _loc4_ = _loc3_.toString(16);
            if(_loc4_.length < 4)
            {
               _loc5_ = _loc8_.substring(0,4 - _loc4_.length) + _loc4_;
            }
            _loc7_ = _loc5_ + _loc7_;
            _loc10_ = _loc10_.parent;
         }
         return _loc6_ > _loc7_ ? 1 : (_loc6_ < _loc7_ ? -1 : 0);
      }
      
      public function get defaultButton() : Button
      {
         return this._defaultButton;
      }
      
      private function activateHandler(param1:Event) : void
      {
         var _loc2_:InteractiveObject = InteractiveObject(param1.target);
         if(this.lastFocus)
         {
            if(this.lastFocus is IFocusManagerComponent)
            {
               IFocusManagerComponent(this.lastFocus).setFocus();
            }
            else
            {
               this.form.stage.focus = this.lastFocus;
            }
         }
         this.lastAction = "ACTIVATE";
      }
      
      public function showFocus() : void
      {
      }
      
      public function set defaultButtonEnabled(param1:Boolean) : void
      {
         this._defaultButtonEnabled = param1;
      }
      
      public function getNextFocusManagerComponent(param1:Boolean = false) : InteractiveObject
      {
         var _loc2_:IFocusManagerGroup = null;
         if(!this.hasFocusableObjects())
         {
            return null;
         }
         if(this.calculateCandidates)
         {
            this.sortFocusableObjects();
            this.calculateCandidates = false;
         }
         var _loc3_:DisplayObject = this.form.stage.focus;
         _loc3_ = DisplayObject(this.findFocusManagerComponent(InteractiveObject(_loc3_)));
         var _loc4_:String = "";
         if(_loc3_ is IFocusManagerGroup)
         {
            _loc2_ = IFocusManagerGroup(_loc3_);
            _loc4_ = _loc2_.groupName;
         }
         var _loc5_:int = int(this.getIndexOfFocusedObject(_loc3_));
         var _loc6_:Boolean = false;
         var _loc7_:int = _loc5_;
         if(_loc5_ == -1)
         {
            if(param1)
            {
               _loc5_ = int(this.focusableCandidates.length);
            }
            _loc6_ = true;
         }
         var _loc8_:int = int(this.getIndexOfNextObject(_loc5_,param1,_loc6_,_loc4_));
         return this.findFocusManagerComponent(this.focusableCandidates[_loc8_]);
      }
      
      private function mouseDownHandler(param1:MouseEvent) : void
      {
         if(param1.isDefaultPrevented())
         {
            return;
         }
         var _loc2_:InteractiveObject = this.getTopLevelFocusTarget(InteractiveObject(param1.target));
         if(!_loc2_)
         {
            return;
         }
         this.showFocusIndicator = false;
         if((_loc2_ != this.lastFocus || this.lastAction == "ACTIVATE") && !(_loc2_ is TextField))
         {
            this.setFocus(_loc2_);
         }
         this.lastAction = "MOUSEDOWN";
      }
      
      private function isTabVisible(param1:DisplayObject) : Boolean
      {
         var _loc2_:DisplayObjectContainer = param1.parent;
         while(Boolean(_loc2_) && Boolean(!(_loc2_ is Stage)) && !(_loc2_.parent && _loc2_.parent is Stage))
         {
            if(!_loc2_.tabChildren)
            {
               return false;
            }
            _loc2_ = _loc2_.parent;
         }
         return true;
      }
      
      public function get nextTabIndex() : int
      {
         return 0;
      }
      
      private function keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.TAB)
         {
            this.lastAction = "KEY";
            if(this.calculateCandidates)
            {
               this.sortFocusableObjects();
               this.calculateCandidates = false;
            }
         }
         if(Boolean(this.defaultButtonEnabled && param1.keyCode == Keyboard.ENTER) && Boolean(this.defaultButton) && Boolean(this.defButton.enabled))
         {
            this.sendDefaultButtonEvent();
         }
      }
      
      private function focusInHandler(param1:FocusEvent) : void
      {
         var _loc2_:Button = null;
         var _loc3_:InteractiveObject = InteractiveObject(param1.target);
         if(this.form.contains(_loc3_))
         {
            this.lastFocus = this.findFocusManagerComponent(InteractiveObject(_loc3_));
            if(this.lastFocus is Button)
            {
               _loc2_ = Button(this.lastFocus);
               if(this.defButton)
               {
                  this.defButton.emphasized = false;
                  this.defButton = _loc2_;
                  _loc2_.emphasized = true;
               }
            }
            else if(Boolean(this.defButton) && this.defButton != this._defaultButton)
            {
               this.defButton.emphasized = false;
               this.defButton = this._defaultButton;
               this._defaultButton.emphasized = true;
            }
         }
      }
      
      private function tabEnabledChangeHandler(param1:Event) : void
      {
         this.calculateCandidates = true;
         var _loc2_:InteractiveObject = InteractiveObject(param1.target);
         var _loc3_:Boolean = this.focusableObjects[_loc2_] == true;
         if(_loc2_.tabEnabled)
         {
            if(!_loc3_ && Boolean(this.isTabVisible(_loc2_)))
            {
               if(!(_loc2_ is IFocusManagerComponent))
               {
                  _loc2_.focusRect = false;
               }
               this.focusableObjects[_loc2_] = true;
            }
         }
         else if(_loc3_)
         {
            delete this.focusableObjects[_loc2_];
         }
      }
      
      public function set showFocusIndicator(param1:Boolean) : void
      {
         this._showFocusIndicator = param1;
      }
      
      public function get form() : DisplayObjectContainer
      {
         return this._form;
      }
      
      private function sortByTabIndex(param1:InteractiveObject, param2:InteractiveObject) : int
      {
         return param1.tabIndex > param2.tabIndex ? 1 : (param1.tabIndex < param2.tabIndex ? -1 : int(this.sortByDepth(param1,param2)));
      }
      
      public function get defaultButtonEnabled() : Boolean
      {
         return this._defaultButtonEnabled;
      }
      
      public function activate() : void
      {
         if(this.activated)
         {
            return;
         }
         this.form.stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.mouseFocusChangeHandler,false,0,true);
         this.form.stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.keyFocusChangeHandler,false,0,true);
         this.form.addEventListener(FocusEvent.FOCUS_IN,this.focusInHandler,true);
         this.form.addEventListener(FocusEvent.FOCUS_OUT,this.focusOutHandler,true);
         this.form.stage.addEventListener(Event.ACTIVATE,this.activateHandler,false,0,true);
         this.form.stage.addEventListener(Event.DEACTIVATE,this.deactivateHandler,false,0,true);
         this.form.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         this.form.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler,true);
         this.activated = true;
         if(this.lastFocus)
         {
            this.setFocus(this.lastFocus);
         }
      }
      
      public function deactivate() : void
      {
         this.form.stage.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.mouseFocusChangeHandler);
         this.form.stage.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.keyFocusChangeHandler);
         this.form.removeEventListener(FocusEvent.FOCUS_IN,this.focusInHandler,true);
         this.form.removeEventListener(FocusEvent.FOCUS_OUT,this.focusOutHandler,true);
         this.form.stage.removeEventListener(Event.ACTIVATE,this.activateHandler);
         this.form.stage.removeEventListener(Event.DEACTIVATE,this.deactivateHandler);
         this.form.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         this.form.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler,true);
         this.activated = false;
      }
   }
}

