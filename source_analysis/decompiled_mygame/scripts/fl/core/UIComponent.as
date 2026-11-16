package fl.core
{
   import fl.events.*;
   import fl.managers.*;
   import flash.display.*;
   import flash.events.*;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class UIComponent extends Sprite
   {
      
      public static var createAccessibilityImplementation:Function;
      
      public static var inCallLaterPhase:Boolean = false;
      
      private static var defaultStyles:Object = {
         "focusRectSkin":"focusRectSkin",
         "focusRectPadding":2,
         "textFormat":new TextFormat("_sans",11,0,false,false,false,"","",TextFormatAlign.LEFT,0,0,0,0),
         "disabledTextFormat":new TextFormat("_sans",11,10066329,false,false,false,"","",TextFormatAlign.LEFT,0,0,0,0),
         "defaultTextFormat":new TextFormat("_sans",11,0,false,false,false,"","",TextFormatAlign.LEFT,0,0,0,0),
         "defaultDisabledTextFormat":new TextFormat("_sans",11,10066329,false,false,false,"","",TextFormatAlign.LEFT,0,0,0,0)
      };
      
      private static var focusManagers:Dictionary = new Dictionary(false);
      
      protected var _x:Number;
      
      protected var _enabled:Boolean = true;
      
      protected var callLaterMethods:Dictionary;
      
      private var _mouseFocusEnabled:Boolean = true;
      
      private var tempText:TextField;
      
      private var _focusEnabled:Boolean = true;
      
      protected var startHeight:Number;
      
      protected var _height:Number;
      
      protected var invalidateFlag:Boolean = false;
      
      protected var _oldIMEMode:String = null;
      
      protected var _inspector:Boolean = false;
      
      protected var startWidth:Number;
      
      public var focusTarget:IFocusManagerComponent;
      
      protected var errorCaught:Boolean = false;
      
      protected var invalidHash:Object;
      
      protected var sharedStyles:Object;
      
      protected var uiFocusRect:DisplayObject;
      
      protected var isLivePreview:Boolean = false;
      
      protected var _imeMode:String = null;
      
      protected var _width:Number;
      
      protected var instanceStyles:Object;
      
      public var version:String = "3.0.0.16";
      
      protected var isFocused:Boolean = false;
      
      protected var _y:Number;
      
      public function UIComponent()
      {
         super();
         this.instanceStyles = {};
         this.sharedStyles = {};
         this.invalidHash = {};
         this.callLaterMethods = new Dictionary();
         StyleManager.registerInstance(this);
         this.configUI();
         this.invalidate(InvalidationType.ALL);
         tabEnabled = this is IFocusManagerComponent;
         focusRect = false;
         if(tabEnabled)
         {
            addEventListener(FocusEvent.FOCUS_IN,this.focusInHandler);
            addEventListener(FocusEvent.FOCUS_OUT,this.focusOutHandler);
            addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
            addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
         }
         this.initializeFocusManager();
         addEventListener(Event.ENTER_FRAME,this.hookAccessibility,false,0,true);
      }
      
      public static function getStyleDefinition() : Object
      {
         return defaultStyles;
      }
      
      public static function mergeStyles(... rest) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:Object = {};
         var _loc5_:uint = uint(rest.length);
         var _loc6_:uint = 0;
         while(_loc6_ < _loc5_)
         {
            _loc2_ = rest[_loc6_];
            for(_loc3_ in _loc2_)
            {
               if(_loc4_[_loc3_] == null)
               {
                  _loc4_[_loc3_] = rest[_loc6_][_loc3_];
               }
            }
            _loc6_++;
         }
         return _loc4_;
      }
      
      public function getStyle(param1:String) : Object
      {
         return this.instanceStyles[param1];
      }
      
      protected function checkLivePreview() : Boolean
      {
         var _loc1_:String = null;
         if(parent == null)
         {
            return false;
         }
         try
         {
            _loc1_ = getQualifiedClassName(parent);
         }
         catch(e:Error)
         {
         }
         return _loc1_ == "fl.livepreview::LivePreviewParent";
      }
      
      private function callLaterDispatcher(param1:Event) : void
      {
         var _loc2_:Object = null;
         if(param1.type == Event.ADDED_TO_STAGE)
         {
            removeEventListener(Event.ADDED_TO_STAGE,this.callLaterDispatcher);
            stage.addEventListener(Event.RENDER,this.callLaterDispatcher,false,0,true);
            stage.invalidate();
            return;
         }
         param1.target.removeEventListener(Event.RENDER,this.callLaterDispatcher);
         if(stage == null)
         {
            addEventListener(Event.ADDED_TO_STAGE,this.callLaterDispatcher,false,0,true);
            return;
         }
         inCallLaterPhase = true;
         var _loc3_:Dictionary = this.callLaterMethods;
         for(_loc2_ in _loc3_)
         {
            _loc2_();
            delete _loc3_[_loc2_];
         }
         inCallLaterPhase = false;
      }
      
      protected function validate() : void
      {
         this.invalidHash = {};
      }
      
      protected function focusOutHandler(param1:FocusEvent) : void
      {
         if(this.isOurFocus(param1.target as DisplayObject))
         {
            this.drawFocus(false);
            this.isFocused = false;
         }
      }
      
      public function set mouseFocusEnabled(param1:Boolean) : void
      {
         this._mouseFocusEnabled = param1;
      }
      
      public function getFocus() : InteractiveObject
      {
         if(stage)
         {
            return stage.focus;
         }
         return null;
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      private function addedHandler(param1:Event) : void
      {
         removeEventListener("addedToStage",this.addedHandler);
         this.initializeFocusManager();
      }
      
      protected function getStyleValue(param1:String) : Object
      {
         return this.instanceStyles[param1] == null ? this.sharedStyles[param1] : this.instanceStyles[param1];
      }
      
      public function invalidate(param1:String = "all", param2:Boolean = true) : void
      {
         this.invalidHash[param1] = true;
         if(param2)
         {
            this.callLater(this.draw);
         }
      }
      
      protected function isOurFocus(param1:DisplayObject) : Boolean
      {
         return param1 == this;
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      protected function getScaleX() : Number
      {
         return super.scaleX;
      }
      
      protected function getScaleY() : Number
      {
         return super.scaleY;
      }
      
      public function get focusEnabled() : Boolean
      {
         return this._focusEnabled;
      }
      
      protected function afterComponentParameters() : void
      {
      }
      
      override public function get scaleY() : Number
      {
         return this.height / this.startHeight;
      }
      
      protected function setIMEMode(param1:Boolean) : *
      {
         var enabled:Boolean = param1;
         if(this._imeMode != null)
         {
            if(enabled)
            {
               IME.enabled = true;
               this._oldIMEMode = IME.conversionMode;
               try
               {
                  if(!this.errorCaught && IME.conversionMode != IMEConversionMode.UNKNOWN)
                  {
                     IME.conversionMode = this._imeMode;
                  }
                  this.errorCaught = false;
               }
               catch(e:Error)
               {
                  errorCaught = true;
                  throw new Error("IME mode not supported: " + _imeMode);
               }
            }
            else
            {
               if(IME.conversionMode != IMEConversionMode.UNKNOWN && this._oldIMEMode != IMEConversionMode.UNKNOWN)
               {
                  IME.conversionMode = this._oldIMEMode;
               }
               IME.enabled = false;
            }
         }
      }
      
      protected function draw() : void
      {
         if(this.isInvalid(InvalidationType.SIZE,InvalidationType.STYLES))
         {
            if(this.isFocused && this.focusManager.showFocusIndicator)
            {
               this.drawFocus(true);
            }
         }
         this.validate();
      }
      
      override public function set height(param1:Number) : void
      {
         if(this._height == param1)
         {
            return;
         }
         this.setSize(this.width,param1);
      }
      
      protected function configUI() : void
      {
         this.isLivePreview = this.checkLivePreview();
         var _loc1_:Number = rotation;
         rotation = 0;
         var _loc2_:Number = super.width;
         var _loc3_:Number = super.height;
         super.scaleX = super.scaleY = 1;
         this.setSize(_loc2_,_loc3_);
         this.move(super.x,super.y);
         rotation = _loc1_;
         this.startWidth = _loc2_;
         this.startHeight = _loc3_;
         if(numChildren > 0)
         {
            removeChildAt(0);
         }
      }
      
      protected function setScaleY(param1:Number) : void
      {
         super.scaleY = param1;
      }
      
      override public function get scaleX() : Number
      {
         return this.width / this.startWidth;
      }
      
      protected function setScaleX(param1:Number) : void
      {
         super.scaleX = param1;
      }
      
      private function initializeFocusManager() : void
      {
         if(stage == null)
         {
            addEventListener(Event.ADDED_TO_STAGE,this.addedHandler,false,0,true);
         }
         else
         {
            this.createFocusManager();
         }
      }
      
      protected function keyDownHandler(param1:KeyboardEvent) : void
      {
      }
      
      public function set focusManager(param1:IFocusManager) : void
      {
         UIComponent.focusManagers[this] = param1;
      }
      
      public function clearStyle(param1:String) : void
      {
         this.setStyle(param1,null);
      }
      
      protected function isInvalid(param1:String, ... rest) : Boolean
      {
         if(Boolean(this.invalidHash[param1]) || Boolean(this.invalidHash[InvalidationType.ALL]))
         {
            return true;
         }
         while(rest.length > 0)
         {
            if(this.invalidHash[rest.pop()])
            {
               return true;
            }
         }
         return false;
      }
      
      public function setStyle(param1:String, param2:Object) : void
      {
         if(this.instanceStyles[param1] === param2 && !(param2 is TextFormat))
         {
            return;
         }
         this.instanceStyles[param1] = param2;
         this.invalidate(InvalidationType.STYLES);
      }
      
      override public function get visible() : Boolean
      {
         return super.visible;
      }
      
      protected function focusInHandler(param1:FocusEvent) : void
      {
         var _loc2_:IFocusManager = null;
         if(this.isOurFocus(param1.target as DisplayObject))
         {
            _loc2_ = this.focusManager;
            if(Boolean(_loc2_) && _loc2_.showFocusIndicator)
            {
               this.drawFocus(true);
               this.isFocused = true;
            }
         }
      }
      
      public function get componentInspectorSetting() : Boolean
      {
         return this._inspector;
      }
      
      override public function get x() : Number
      {
         return isNaN(this._x) ? super.x : this._x;
      }
      
      override public function get y() : Number
      {
         return isNaN(this._y) ? super.y : this._y;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(param1 == this._enabled)
         {
            return;
         }
         this._enabled = param1;
         this.invalidate(InvalidationType.STATE);
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         this._width = param1;
         this._height = param2;
         this.invalidate(InvalidationType.SIZE);
         dispatchEvent(new ComponentEvent(ComponentEvent.RESIZE,false));
      }
      
      protected function keyUpHandler(param1:KeyboardEvent) : void
      {
      }
      
      public function setSharedStyle(param1:String, param2:Object) : void
      {
         if(this.sharedStyles[param1] === param2 && !(param2 is TextFormat))
         {
            return;
         }
         this.sharedStyles[param1] = param2;
         if(this.instanceStyles[param1] == null)
         {
            this.invalidate(InvalidationType.STYLES);
         }
      }
      
      public function set focusEnabled(param1:Boolean) : void
      {
         this._focusEnabled = param1;
      }
      
      override public function set width(param1:Number) : void
      {
         if(this._width == param1)
         {
            return;
         }
         this.setSize(param1,this.height);
      }
      
      public function setFocus() : void
      {
         if(stage)
         {
            stage.focus = this;
         }
      }
      
      override public function set scaleX(param1:Number) : void
      {
         this.setSize(this.startWidth * param1,this.height);
      }
      
      public function get mouseFocusEnabled() : Boolean
      {
         return this._mouseFocusEnabled;
      }
      
      override public function set scaleY(param1:Number) : void
      {
         this.setSize(this.width,this.startHeight * param1);
      }
      
      protected function getDisplayObjectInstance(param1:Object) : DisplayObject
      {
         var skin:Object = null;
         skin = param1;
         var classDef:Object = null;
         if(skin is Class)
         {
            return new skin() as DisplayObject;
         }
         if(skin is DisplayObject)
         {
            (skin as DisplayObject).x = 0;
            (skin as DisplayObject).y = 0;
            return skin as DisplayObject;
         }
         try
         {
            classDef = getDefinitionByName(skin.toString());
         }
         catch(e:Error)
         {
            try
            {
               classDef = loaderInfo.applicationDomain.getDefinition(skin.toString()) as Object;
            }
            catch(e:Error)
            {
            }
         }
         if(classDef == null)
         {
            return null;
         }
         return new classDef() as DisplayObject;
      }
      
      protected function copyStylesToChild(param1:UIComponent, param2:Object) : void
      {
         var _loc3_:String = null;
         for(_loc3_ in param2)
         {
            param1.setStyle(_loc3_,this.getStyleValue(param2[_loc3_]));
         }
      }
      
      protected function initializeAccessibility() : void
      {
         if(UIComponent.createAccessibilityImplementation != null)
         {
            UIComponent.createAccessibilityImplementation(this);
         }
      }
      
      public function get focusManager() : IFocusManager
      {
         var _loc1_:DisplayObject = this;
         while(_loc1_)
         {
            if(UIComponent.focusManagers[_loc1_] != null)
            {
               return IFocusManager(UIComponent.focusManagers[_loc1_]);
            }
            _loc1_ = _loc1_.parent;
         }
         return null;
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      protected function beforeComponentParameters() : void
      {
      }
      
      protected function callLater(param1:Function) : void
      {
         if(inCallLaterPhase)
         {
            return;
         }
         this.callLaterMethods[param1] = true;
         if(stage != null)
         {
            stage.addEventListener(Event.RENDER,this.callLaterDispatcher,false,0,true);
            stage.invalidate();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.callLaterDispatcher,false,0,true);
         }
      }
      
      public function move(param1:Number, param2:Number) : void
      {
         this._x = param1;
         this._y = param2;
         super.x = Math.round(param1);
         super.y = Math.round(param2);
         dispatchEvent(new ComponentEvent(ComponentEvent.MOVE));
      }
      
      public function validateNow() : void
      {
         this.invalidate(InvalidationType.ALL,false);
         this.draw();
      }
      
      override public function set visible(param1:Boolean) : void
      {
         if(super.visible == param1)
         {
            return;
         }
         super.visible = param1;
         var _loc2_:String = param1 ? ComponentEvent.SHOW : ComponentEvent.HIDE;
         dispatchEvent(new ComponentEvent(_loc2_,true));
      }
      
      protected function createFocusManager() : void
      {
         if(focusManagers[stage] == null)
         {
            focusManagers[stage] = new FocusManager(stage);
         }
      }
      
      protected function hookAccessibility(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.hookAccessibility);
         this.initializeAccessibility();
      }
      
      public function set componentInspectorSetting(param1:Boolean) : void
      {
         this._inspector = param1;
         if(this._inspector)
         {
            this.beforeComponentParameters();
         }
         else
         {
            this.afterComponentParameters();
         }
      }
      
      override public function set y(param1:Number) : void
      {
         this.move(this._x,param1);
      }
      
      public function drawFocus(param1:Boolean) : void
      {
         var _loc2_:Number = Number(NaN);
         this.isFocused = param1;
         if(this.uiFocusRect != null && contains(this.uiFocusRect))
         {
            removeChild(this.uiFocusRect);
            this.uiFocusRect = null;
         }
         if(param1)
         {
            this.uiFocusRect = this.getDisplayObjectInstance(this.getStyleValue("focusRectSkin")) as Sprite;
            if(this.uiFocusRect == null)
            {
               return;
            }
            _loc2_ = Number(this.getStyleValue("focusRectPadding"));
            this.uiFocusRect.x = -_loc2_;
            this.uiFocusRect.y = -_loc2_;
            this.uiFocusRect.width = this.width + _loc2_ * 2;
            this.uiFocusRect.height = this.height + _loc2_ * 2;
            addChildAt(this.uiFocusRect,0);
         }
      }
      
      override public function set x(param1:Number) : void
      {
         this.move(param1,this._y);
      }
      
      public function drawNow() : void
      {
         this.draw();
      }
   }
}

