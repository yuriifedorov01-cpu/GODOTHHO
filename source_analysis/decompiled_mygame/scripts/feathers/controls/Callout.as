package feathers.controls
{
   import feathers.core.*;
   import feathers.events.*;
   import feathers.layout.*;
   import feathers.skins.IStyleProvider;
   import feathers.utils.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.ui.*;
   import starling.core.*;
   import starling.display.*;
   import starling.events.*;
   
   public class Callout extends FeathersControl
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      public static const DIRECTION_ANY:String = "any";
      
      public static const DIRECTION_VERTICAL:String = "vertical";
      
      public static const DIRECTION_HORIZONTAL:String = "horizontal";
      
      public static const DIRECTION_UP:String = "up";
      
      public static const DIRECTION_DOWN:String = "down";
      
      public static const DIRECTION_LEFT:String = "left";
      
      public static const DIRECTION_RIGHT:String = "right";
      
      public static const ARROW_POSITION_TOP:String = "top";
      
      public static const ARROW_POSITION_RIGHT:String = "right";
      
      public static const ARROW_POSITION_BOTTOM:String = "bottom";
      
      public static const ARROW_POSITION_LEFT:String = "left";
      
      protected static const INVALIDATION_FLAG_ORIGIN:String = "origin";
      
      private static const HELPER_RECT:Rectangle = new Rectangle();
      
      private static const HELPER_POINT:Point = new Point();
      
      protected static const DIRECTION_TO_FUNCTION:Object = {};
      
      protected static const FUZZY_CONTENT_DIMENSIONS_PADDING:Number = 0.000001;
      
      public static var stagePaddingTop:Number = 0;
      
      public static var stagePaddingRight:Number = 0;
      
      public static var stagePaddingBottom:Number = 0;
      
      public static var stagePaddingLeft:Number = 0;
      
      public static var calloutFactory:Function = defaultCalloutFactory;
      
      public static var calloutOverlayFactory:Function = PopUpManager.defaultOverlayFactory;
      
      DIRECTION_TO_FUNCTION[DIRECTION_ANY] = positionBestSideOfOrigin;
      DIRECTION_TO_FUNCTION[DIRECTION_UP] = positionAboveOrigin;
      DIRECTION_TO_FUNCTION[DIRECTION_DOWN] = positionBelowOrigin;
      DIRECTION_TO_FUNCTION[DIRECTION_LEFT] = positionToLeftOfOrigin;
      DIRECTION_TO_FUNCTION[DIRECTION_RIGHT] = positionToRightOfOrigin;
      DIRECTION_TO_FUNCTION[DIRECTION_VERTICAL] = positionAboveOrBelowOrigin;
      DIRECTION_TO_FUNCTION[DIRECTION_HORIZONTAL] = positionToLeftOrRightOfOrigin;
      
      public var closeOnTouchBeganOutside:Boolean = false;
      
      public var closeOnTouchEndedOutside:Boolean = false;
      
      public var closeOnKeys:Vector.<uint>;
      
      public var disposeOnSelfClose:Boolean = true;
      
      public var disposeContent:Boolean = true;
      
      protected var _isReadyToClose:Boolean = false;
      
      protected var _content:DisplayObject;
      
      protected var _origin:DisplayObject;
      
      protected var _supportedDirections:String = "any";
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _arrowPosition:String = "top";
      
      protected var _originalBackgroundWidth:Number = NaN;
      
      protected var _originalBackgroundHeight:Number = NaN;
      
      protected var _backgroundSkin:DisplayObject;
      
      protected var currentArrowSkin:DisplayObject;
      
      protected var _bottomArrowSkin:DisplayObject;
      
      protected var _topArrowSkin:DisplayObject;
      
      protected var _leftArrowSkin:DisplayObject;
      
      protected var _rightArrowSkin:DisplayObject;
      
      protected var _topArrowGap:Number = 0;
      
      protected var _bottomArrowGap:Number = 0;
      
      protected var _rightArrowGap:Number = 0;
      
      protected var _leftArrowGap:Number = 0;
      
      protected var _arrowOffset:Number = 0;
      
      protected var _lastGlobalBoundsOfOrigin:Rectangle;
      
      protected var _ignoreContentResize:Boolean = false;
      
      public function Callout()
      {
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.callout_addedToStageHandler);
      }
      
      public static function get stagePadding() : Number
      {
         return Callout.stagePaddingTop;
      }
      
      public static function set stagePadding(param1:Number) : void
      {
         Callout.stagePaddingTop = param1;
         Callout.stagePaddingRight = param1;
         Callout.stagePaddingBottom = param1;
         Callout.stagePaddingLeft = param1;
      }
      
      public static function show(param1:DisplayObject, param2:DisplayObject, param3:String = "any", param4:Boolean = true, param5:Function = null, param6:Function = null) : Callout
      {
         if(!param2.stage)
         {
            throw new ArgumentError("Callout origin must be added to the stage.");
         }
         var _loc7_:Function = param5;
         if(_loc7_ == null)
         {
            _loc7_ = calloutFactory != null ? calloutFactory : defaultCalloutFactory;
         }
         var _loc8_:Callout = Callout(_loc7_());
         _loc8_.content = param1;
         _loc8_.supportedDirections = param3;
         _loc8_.origin = param2;
         _loc7_ = param6;
         if(_loc7_ == null)
         {
            _loc7_ = calloutOverlayFactory != null ? calloutOverlayFactory : PopUpManager.defaultOverlayFactory;
         }
         PopUpManager.addPopUp(_loc8_,param4,false,_loc7_);
         return _loc8_;
      }
      
      public static function defaultCalloutFactory() : Callout
      {
         var _loc1_:Callout = new Callout();
         _loc1_.closeOnTouchBeganOutside = true;
         _loc1_.closeOnTouchEndedOutside = true;
         _loc1_.closeOnKeys = new <uint>[Keyboard.BACK,Keyboard.ESCAPE];
         return _loc1_;
      }
      
      protected static function positionWithSupportedDirections(param1:Callout, param2:Rectangle, param3:String) : void
      {
         var _loc4_:Function = null;
         if(DIRECTION_TO_FUNCTION.hasOwnProperty(param3))
         {
            _loc4_ = DIRECTION_TO_FUNCTION[param3];
            _loc4_(param1,param2);
         }
         else
         {
            positionBestSideOfOrigin(param1,param2);
         }
      }
      
      protected static function positionBestSideOfOrigin(param1:Callout, param2:Rectangle) : void
      {
         param1.measureWithArrowPosition(RelativePosition.TOP,HELPER_POINT);
         var _loc3_:Number = Starling.current.stage.stageHeight - HELPER_POINT.y - (param2.y + param2.height);
         if(_loc3_ >= stagePaddingBottom)
         {
            positionBelowOrigin(param1,param2);
            return;
         }
         param1.measureWithArrowPosition(RelativePosition.BOTTOM,HELPER_POINT);
         var _loc4_:Number = param2.y - HELPER_POINT.y;
         if(_loc4_ >= stagePaddingTop)
         {
            positionAboveOrigin(param1,param2);
            return;
         }
         param1.measureWithArrowPosition(RelativePosition.LEFT,HELPER_POINT);
         var _loc5_:Number = Starling.current.stage.stageWidth - HELPER_POINT.x - (param2.x + param2.width);
         if(_loc5_ >= stagePaddingRight)
         {
            positionToRightOfOrigin(param1,param2);
            return;
         }
         param1.measureWithArrowPosition(RelativePosition.RIGHT,HELPER_POINT);
         var _loc6_:Number = param2.x - HELPER_POINT.x;
         if(_loc6_ >= stagePaddingLeft)
         {
            positionToLeftOfOrigin(param1,param2);
            return;
         }
         if(_loc3_ >= _loc4_ && _loc3_ >= _loc5_ && _loc3_ >= _loc6_)
         {
            positionBelowOrigin(param1,param2);
         }
         else if(_loc4_ >= _loc5_ && _loc4_ >= _loc6_)
         {
            positionAboveOrigin(param1,param2);
         }
         else if(_loc5_ >= _loc6_)
         {
            positionToRightOfOrigin(param1,param2);
         }
         else
         {
            positionToLeftOfOrigin(param1,param2);
         }
      }
      
      protected static function positionAboveOrBelowOrigin(param1:Callout, param2:Rectangle) : void
      {
         param1.measureWithArrowPosition(RelativePosition.TOP,HELPER_POINT);
         var _loc3_:Number = Starling.current.stage.stageHeight - HELPER_POINT.y - (param2.y + param2.height);
         if(_loc3_ >= stagePaddingBottom)
         {
            positionBelowOrigin(param1,param2);
            return;
         }
         param1.measureWithArrowPosition(RelativePosition.BOTTOM,HELPER_POINT);
         var _loc4_:Number = param2.y - HELPER_POINT.y;
         if(_loc4_ >= stagePaddingTop)
         {
            positionAboveOrigin(param1,param2);
            return;
         }
         if(_loc3_ >= _loc4_)
         {
            positionBelowOrigin(param1,param2);
         }
         else
         {
            positionAboveOrigin(param1,param2);
         }
      }
      
      protected static function positionToLeftOrRightOfOrigin(param1:Callout, param2:Rectangle) : void
      {
         param1.measureWithArrowPosition(RelativePosition.LEFT,HELPER_POINT);
         var _loc3_:Number = Starling.current.stage.stageWidth - HELPER_POINT.x - (param2.x + param2.width);
         if(_loc3_ >= stagePaddingRight)
         {
            positionToRightOfOrigin(param1,param2);
            return;
         }
         param1.measureWithArrowPosition(RelativePosition.RIGHT,HELPER_POINT);
         var _loc4_:Number = param2.x - HELPER_POINT.x;
         if(_loc4_ >= stagePaddingLeft)
         {
            positionToLeftOfOrigin(param1,param2);
            return;
         }
         if(_loc3_ >= _loc4_)
         {
            positionToRightOfOrigin(param1,param2);
         }
         else
         {
            positionToLeftOfOrigin(param1,param2);
         }
      }
      
      protected static function positionBelowOrigin(param1:Callout, param2:Rectangle) : void
      {
         param1.measureWithArrowPosition(RelativePosition.TOP,HELPER_POINT);
         var _loc3_:Number = param2.x + Math.round((param2.width - HELPER_POINT.x) / 2);
         var _loc4_:Number = Math.max(stagePaddingLeft,Math.min(Starling.current.stage.stageWidth - HELPER_POINT.x - stagePaddingRight,_loc3_));
         param1.x = _loc4_;
         param1.y = param2.y + param2.height;
         if(param1._isValidating)
         {
            param1._arrowOffset = _loc3_ - _loc4_;
            param1._arrowPosition = RelativePosition.TOP;
         }
         else
         {
            param1.arrowOffset = _loc3_ - _loc4_;
            param1.arrowPosition = RelativePosition.TOP;
         }
      }
      
      protected static function positionAboveOrigin(param1:Callout, param2:Rectangle) : void
      {
         param1.measureWithArrowPosition(RelativePosition.BOTTOM,HELPER_POINT);
         var _loc3_:Number = param2.x + Math.round((param2.width - HELPER_POINT.x) / 2);
         var _loc4_:Number = Math.max(stagePaddingLeft,Math.min(Starling.current.stage.stageWidth - HELPER_POINT.x - stagePaddingRight,_loc3_));
         param1.x = _loc4_;
         param1.y = param2.y - HELPER_POINT.y;
         if(param1._isValidating)
         {
            param1._arrowOffset = _loc3_ - _loc4_;
            param1._arrowPosition = RelativePosition.BOTTOM;
         }
         else
         {
            param1.arrowOffset = _loc3_ - _loc4_;
            param1.arrowPosition = RelativePosition.BOTTOM;
         }
      }
      
      protected static function positionToRightOfOrigin(param1:Callout, param2:Rectangle) : void
      {
         param1.measureWithArrowPosition(RelativePosition.LEFT,HELPER_POINT);
         param1.x = param2.x + param2.width;
         var _loc3_:Number = param2.y + Math.round((param2.height - HELPER_POINT.y) / 2);
         var _loc4_:Number = Math.max(stagePaddingTop,Math.min(Starling.current.stage.stageHeight - HELPER_POINT.y - stagePaddingBottom,_loc3_));
         param1.y = _loc4_;
         if(param1._isValidating)
         {
            param1._arrowOffset = _loc3_ - _loc4_;
            param1._arrowPosition = RelativePosition.LEFT;
         }
         else
         {
            param1.arrowOffset = _loc3_ - _loc4_;
            param1.arrowPosition = RelativePosition.LEFT;
         }
      }
      
      protected static function positionToLeftOfOrigin(param1:Callout, param2:Rectangle) : void
      {
         param1.measureWithArrowPosition(RelativePosition.RIGHT,HELPER_POINT);
         param1.x = param2.x - HELPER_POINT.x;
         var _loc3_:Number = param2.y + Math.round((param2.height - HELPER_POINT.y) / 2);
         var _loc4_:Number = Math.max(stagePaddingLeft,Math.min(Starling.current.stage.stageHeight - HELPER_POINT.y - stagePaddingBottom,_loc3_));
         param1.y = _loc4_;
         if(param1._isValidating)
         {
            param1._arrowOffset = _loc3_ - _loc4_;
            param1._arrowPosition = RelativePosition.RIGHT;
         }
         else
         {
            param1.arrowOffset = _loc3_ - _loc4_;
            param1.arrowPosition = RelativePosition.RIGHT;
         }
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return Callout.globalStyleProvider;
      }
      
      public function get content() : DisplayObject
      {
         return this._content;
      }
      
      public function set content(param1:DisplayObject) : void
      {
         if(this._content == param1)
         {
            return;
         }
         if(this._content)
         {
            if(this._content is IFeathersControl)
            {
               IFeathersControl(this._content).removeEventListener(FeathersEventType.RESIZE,this.content_resizeHandler);
            }
            if(this._content.parent == this)
            {
               this._content.removeFromParent(false);
            }
         }
         this._content = param1;
         if(this._content)
         {
            if(this._content is IFeathersControl)
            {
               IFeathersControl(this._content).addEventListener(FeathersEventType.RESIZE,this.content_resizeHandler);
            }
            this.addChild(this._content);
         }
         this.invalidate(INVALIDATION_FLAG_SIZE);
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get origin() : DisplayObject
      {
         return this._origin;
      }
      
      public function set origin(param1:DisplayObject) : void
      {
         if(this._origin == param1)
         {
            return;
         }
         if(Boolean(param1) && !param1.stage)
         {
            throw new ArgumentError("Callout origin must have access to the stage.");
         }
         if(this._origin)
         {
            this.removeEventListener(EnterFrameEvent.ENTER_FRAME,this.callout_enterFrameHandler);
            this._origin.removeEventListener(Event.REMOVED_FROM_STAGE,this.origin_removedFromStageHandler);
         }
         this._origin = param1;
         this._lastGlobalBoundsOfOrigin = null;
         if(this._origin)
         {
            this._origin.addEventListener(Event.REMOVED_FROM_STAGE,this.origin_removedFromStageHandler);
            this.addEventListener(EnterFrameEvent.ENTER_FRAME,this.callout_enterFrameHandler);
         }
         this.invalidate(INVALIDATION_FLAG_ORIGIN);
      }
      
      public function get supportedDirections() : String
      {
         return this._supportedDirections;
      }
      
      public function set supportedDirections(param1:String) : void
      {
         this._supportedDirections = param1;
      }
      
      public function get padding() : Number
      {
         return this._paddingTop;
      }
      
      public function set padding(param1:Number) : void
      {
         this.paddingTop = param1;
         this.paddingRight = param1;
         this.paddingBottom = param1;
         this.paddingLeft = param1;
      }
      
      public function get paddingTop() : Number
      {
         return this._paddingTop;
      }
      
      public function set paddingTop(param1:Number) : void
      {
         if(this._paddingTop == param1)
         {
            return;
         }
         this._paddingTop = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get paddingRight() : Number
      {
         return this._paddingRight;
      }
      
      public function set paddingRight(param1:Number) : void
      {
         if(this._paddingRight == param1)
         {
            return;
         }
         this._paddingRight = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get paddingBottom() : Number
      {
         return this._paddingBottom;
      }
      
      public function set paddingBottom(param1:Number) : void
      {
         if(this._paddingBottom == param1)
         {
            return;
         }
         this._paddingBottom = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get paddingLeft() : Number
      {
         return this._paddingLeft;
      }
      
      public function set paddingLeft(param1:Number) : void
      {
         if(this._paddingLeft == param1)
         {
            return;
         }
         this._paddingLeft = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get arrowPosition() : String
      {
         return this._arrowPosition;
      }
      
      public function set arrowPosition(param1:String) : void
      {
         if(this._arrowPosition == param1)
         {
            return;
         }
         this._arrowPosition = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get backgroundSkin() : DisplayObject
      {
         return this._backgroundSkin;
      }
      
      public function set backgroundSkin(param1:DisplayObject) : void
      {
         if(this._backgroundSkin == param1)
         {
            return;
         }
         if(this._backgroundSkin)
         {
            this.removeChild(this._backgroundSkin);
         }
         this._backgroundSkin = param1;
         if(this._backgroundSkin)
         {
            this._originalBackgroundWidth = this._backgroundSkin.width;
            this._originalBackgroundHeight = this._backgroundSkin.height;
            this.addChildAt(this._backgroundSkin,0);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get bottomArrowSkin() : DisplayObject
      {
         return this._bottomArrowSkin;
      }
      
      public function set bottomArrowSkin(param1:DisplayObject) : void
      {
         var _loc2_:int = 0;
         if(this._bottomArrowSkin == param1)
         {
            return;
         }
         if(this._bottomArrowSkin)
         {
            this.removeChild(this._bottomArrowSkin);
         }
         this._bottomArrowSkin = param1;
         if(this._bottomArrowSkin)
         {
            this._bottomArrowSkin.visible = false;
            _loc2_ = this.getChildIndex(this._content);
            if(_loc2_ < 0)
            {
               this.addChild(this._bottomArrowSkin);
            }
            else
            {
               this.addChildAt(this._bottomArrowSkin,_loc2_);
            }
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get topArrowSkin() : DisplayObject
      {
         return this._topArrowSkin;
      }
      
      public function set topArrowSkin(param1:DisplayObject) : void
      {
         var _loc2_:int = 0;
         if(this._topArrowSkin == param1)
         {
            return;
         }
         if(this._topArrowSkin)
         {
            this.removeChild(this._topArrowSkin);
         }
         this._topArrowSkin = param1;
         if(this._topArrowSkin)
         {
            this._topArrowSkin.visible = false;
            _loc2_ = this.getChildIndex(this._content);
            if(_loc2_ < 0)
            {
               this.addChild(this._topArrowSkin);
            }
            else
            {
               this.addChildAt(this._topArrowSkin,_loc2_);
            }
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get leftArrowSkin() : DisplayObject
      {
         return this._leftArrowSkin;
      }
      
      public function set leftArrowSkin(param1:DisplayObject) : void
      {
         var _loc2_:int = 0;
         if(this._leftArrowSkin == param1)
         {
            return;
         }
         if(this._leftArrowSkin)
         {
            this.removeChild(this._leftArrowSkin);
         }
         this._leftArrowSkin = param1;
         if(this._leftArrowSkin)
         {
            this._leftArrowSkin.visible = false;
            _loc2_ = this.getChildIndex(this._content);
            if(_loc2_ < 0)
            {
               this.addChild(this._leftArrowSkin);
            }
            else
            {
               this.addChildAt(this._leftArrowSkin,_loc2_);
            }
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get rightArrowSkin() : DisplayObject
      {
         return this._rightArrowSkin;
      }
      
      public function set rightArrowSkin(param1:DisplayObject) : void
      {
         var _loc2_:int = 0;
         if(this._rightArrowSkin == param1)
         {
            return;
         }
         if(this._rightArrowSkin)
         {
            this.removeChild(this._rightArrowSkin);
         }
         this._rightArrowSkin = param1;
         if(this._rightArrowSkin)
         {
            this._rightArrowSkin.visible = false;
            _loc2_ = this.getChildIndex(this._content);
            if(_loc2_ < 0)
            {
               this.addChild(this._rightArrowSkin);
            }
            else
            {
               this.addChildAt(this._rightArrowSkin,_loc2_);
            }
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get topArrowGap() : Number
      {
         return this._topArrowGap;
      }
      
      public function set topArrowGap(param1:Number) : void
      {
         if(this._topArrowGap == param1)
         {
            return;
         }
         this._topArrowGap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get bottomArrowGap() : Number
      {
         return this._bottomArrowGap;
      }
      
      public function set bottomArrowGap(param1:Number) : void
      {
         if(this._bottomArrowGap == param1)
         {
            return;
         }
         this._bottomArrowGap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get rightArrowGap() : Number
      {
         return this._rightArrowGap;
      }
      
      public function set rightArrowGap(param1:Number) : void
      {
         if(this._rightArrowGap == param1)
         {
            return;
         }
         this._rightArrowGap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get leftArrowGap() : Number
      {
         return this._leftArrowGap;
      }
      
      public function set leftArrowGap(param1:Number) : void
      {
         if(this._leftArrowGap == param1)
         {
            return;
         }
         this._leftArrowGap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get arrowOffset() : Number
      {
         return this._arrowOffset;
      }
      
      public function set arrowOffset(param1:Number) : void
      {
         if(this._arrowOffset == param1)
         {
            return;
         }
         this._arrowOffset = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      override public function dispose() : void
      {
         this.origin = null;
         var _loc1_:DisplayObject = this._content;
         this.content = null;
         if(Boolean(_loc1_) && this.disposeContent)
         {
            _loc1_.dispose();
         }
         super.dispose();
      }
      
      public function close(param1:Boolean = false) : void
      {
         if(this.parent)
         {
            this.removeFromParent(false);
            this.dispatchEventWith(Event.CLOSE);
         }
         if(param1)
         {
            this.dispose();
         }
      }
      
      override protected function initialize() : void
      {
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.callout_removedFromStageHandler);
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc5_:Boolean = this.isInvalid(INVALIDATION_FLAG_ORIGIN);
         if(_loc2_)
         {
            this._lastGlobalBoundsOfOrigin = null;
            _loc5_ = true;
         }
         if(_loc5_)
         {
            this.positionToOrigin();
         }
         if(_loc4_ || _loc3_)
         {
            this.refreshArrowSkin();
         }
         if(_loc3_)
         {
            if(this._content is IFeathersControl)
            {
               IFeathersControl(this._content).isEnabled = this._isEnabled;
            }
         }
         _loc2_ = this.autoSizeIfNeeded() || _loc2_;
         if(_loc2_ || _loc4_ || _loc1_ || _loc3_)
         {
            this.layoutChildren();
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         this.measureWithArrowPosition(this._arrowPosition,HELPER_POINT);
         return this.setSizeInternal(HELPER_POINT.x,HELPER_POINT.y,false);
      }
      
      protected function measureWithArrowPosition(param1:String, param2:Point = null) : Point
      {
         var _loc3_:Number = Number(NaN);
         var _loc4_:Number = Number(NaN);
         var _loc5_:Number = Number(NaN);
         var _loc6_:Number = Number(NaN);
         var _loc7_:Number = Number(NaN);
         var _loc8_:Number = Number(NaN);
         var _loc9_:Number = Number(NaN);
         var _loc10_:Number = Number(NaN);
         var _loc11_:Number = Number(NaN);
         var _loc12_:Number = Number(NaN);
         var _loc13_:IFeathersControl = null;
         if(!param2)
         {
            param2 = new Point();
         }
         var _loc14_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc15_:Boolean = this._explicitHeight !== this._explicitHeight;
         if(!_loc14_ && !_loc15_)
         {
            param2.x = this._explicitWidth;
            param2.y = this._explicitHeight;
            return param2;
         }
         var _loc16_:Number = this._explicitMinWidth;
         var _loc17_:Number = this._maxWidth;
         var _loc18_:Number = this._explicitMinHeight;
         var _loc19_:Number = this._maxHeight;
         if(this._originalBackgroundWidth === this._originalBackgroundWidth && _loc16_ < this._originalBackgroundWidth)
         {
            _loc16_ = this._originalBackgroundWidth;
         }
         if(this._originalBackgroundHeight === this._originalBackgroundHeight && _loc18_ < this._originalBackgroundHeight)
         {
            _loc18_ = this._originalBackgroundHeight;
         }
         if(param1 === RelativePosition.TOP && Boolean(this._topArrowSkin))
         {
            _loc3_ = this._topArrowSkin.width + this._paddingLeft + this._paddingRight;
            if(_loc16_ < _loc3_)
            {
               _loc16_ = _loc3_;
            }
         }
         if(param1 === RelativePosition.BOTTOM && Boolean(this._bottomArrowSkin))
         {
            _loc4_ = this._bottomArrowSkin.width + this._paddingLeft + this._paddingRight;
            if(_loc16_ < _loc4_)
            {
               _loc16_ = _loc4_;
            }
         }
         if(param1 === RelativePosition.LEFT && Boolean(this._leftArrowSkin))
         {
            _loc5_ = this._leftArrowSkin.height + this._paddingTop + this._paddingBottom;
            if(_loc18_ < _loc5_)
            {
               _loc18_ = _loc5_;
            }
         }
         if(param1 === RelativePosition.RIGHT && Boolean(this._rightArrowSkin))
         {
            _loc6_ = this._rightArrowSkin.height + this._paddingTop + this._paddingBottom;
            if(_loc18_ < _loc6_)
            {
               _loc18_ = _loc6_;
            }
         }
         if(this.stage)
         {
            _loc7_ = this.stage.stageWidth - stagePaddingLeft - stagePaddingRight;
            _loc8_ = this.stage.stageHeight - stagePaddingTop - stagePaddingBottom;
            if(_loc17_ > _loc7_)
            {
               _loc17_ = _loc7_;
            }
            if(_loc19_ > _loc8_)
            {
               _loc19_ = _loc8_;
            }
         }
         var _loc20_:Number = 0;
         if(param1 === RelativePosition.LEFT && Boolean(this._leftArrowSkin))
         {
            _loc20_ += this._leftArrowSkin.width + this._leftArrowGap;
         }
         else if(param1 === RelativePosition.RIGHT && Boolean(this._rightArrowSkin))
         {
            _loc20_ += this._rightArrowSkin.width + this._rightArrowGap;
         }
         var _loc21_:Number = 0;
         if(param1 === RelativePosition.TOP && Boolean(this._topArrowSkin))
         {
            _loc21_ += this._topArrowSkin.height + this._topArrowGap;
         }
         else if(param1 === RelativePosition.BOTTOM && Boolean(this._bottomArrowSkin))
         {
            _loc21_ += this._bottomArrowSkin.height + this._bottomArrowGap;
         }
         if(this._content is IFeathersControl)
         {
            _loc9_ = _loc16_ - _loc20_ - this._paddingLeft - this._paddingRight;
            _loc10_ = _loc17_ - _loc20_ - this._paddingLeft - this._paddingRight;
            _loc11_ = _loc18_ - _loc21_ - this._paddingTop - this._paddingBottom;
            _loc12_ = _loc19_ - _loc21_ - this._paddingTop - this._paddingBottom;
            _loc13_ = IFeathersControl(this._content);
            if(_loc13_.minWidth < _loc9_)
            {
               _loc13_.minWidth = _loc9_;
            }
            if(_loc13_.maxWidth > _loc10_)
            {
               _loc13_.maxWidth = _loc10_;
            }
            if(_loc13_.minHeight < _loc11_)
            {
               _loc13_.minHeight = _loc11_;
            }
            if(_loc13_.maxHeight > _loc12_)
            {
               _loc13_.maxHeight = _loc12_;
            }
         }
         if(this._content is IValidating)
         {
            IValidating(this._content).validate();
         }
         var _loc22_:Number = this._explicitWidth;
         var _loc23_:Number = this._explicitHeight;
         if(_loc14_)
         {
            _loc22_ = this._content.width + _loc20_ + this._paddingLeft + this._paddingRight;
            if(_loc22_ < _loc16_)
            {
               _loc22_ = _loc16_;
            }
            else if(_loc22_ > _loc17_)
            {
               _loc22_ = _loc17_;
            }
         }
         if(_loc15_)
         {
            _loc23_ = this._content.height + _loc21_ + this._paddingTop + this._paddingBottom;
            if(_loc23_ < _loc18_)
            {
               _loc23_ = _loc18_;
            }
            else if(_loc23_ > _loc19_)
            {
               _loc23_ = _loc19_;
            }
         }
         param2.x = _loc22_;
         param2.y = _loc23_;
         return param2;
      }
      
      protected function refreshArrowSkin() : void
      {
         this.currentArrowSkin = null;
         if(this._arrowPosition == RelativePosition.BOTTOM)
         {
            this.currentArrowSkin = this._bottomArrowSkin;
         }
         else if(this._bottomArrowSkin)
         {
            this._bottomArrowSkin.visible = false;
         }
         if(this._arrowPosition == RelativePosition.TOP)
         {
            this.currentArrowSkin = this._topArrowSkin;
         }
         else if(this._topArrowSkin)
         {
            this._topArrowSkin.visible = false;
         }
         if(this._arrowPosition == RelativePosition.LEFT)
         {
            this.currentArrowSkin = this._leftArrowSkin;
         }
         else if(this._leftArrowSkin)
         {
            this._leftArrowSkin.visible = false;
         }
         if(this._arrowPosition == RelativePosition.RIGHT)
         {
            this.currentArrowSkin = this._rightArrowSkin;
         }
         else if(this._rightArrowSkin)
         {
            this._rightArrowSkin.visible = false;
         }
         if(this.currentArrowSkin)
         {
            this.currentArrowSkin.visible = true;
         }
      }
      
      protected function layoutChildren() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Number = Number(NaN);
         var _loc3_:Number = Number(NaN);
         var _loc4_:Number = Number(NaN);
         var _loc5_:Number = Boolean(this._leftArrowSkin) && this._arrowPosition == RelativePosition.LEFT ? this._leftArrowSkin.width + this._leftArrowGap : 0;
         var _loc6_:Number = Boolean(this._topArrowSkin) && this._arrowPosition == RelativePosition.TOP ? this._topArrowSkin.height + this._topArrowGap : 0;
         var _loc7_:Number = Boolean(this._rightArrowSkin) && this._arrowPosition == RelativePosition.RIGHT ? this._rightArrowSkin.width + this._rightArrowGap : 0;
         var _loc8_:Number = Boolean(this._bottomArrowSkin) && this._arrowPosition == RelativePosition.BOTTOM ? this._bottomArrowSkin.height + this._bottomArrowGap : 0;
         var _loc9_:Number = this.actualWidth - _loc5_ - _loc7_;
         var _loc10_:Number = this.actualHeight - _loc6_ - _loc8_;
         if(this._backgroundSkin)
         {
            this._backgroundSkin.x = _loc5_;
            this._backgroundSkin.y = _loc6_;
            this._backgroundSkin.width = _loc9_;
            this._backgroundSkin.height = _loc10_;
         }
         if(this.currentArrowSkin)
         {
            if(this._arrowPosition == RelativePosition.LEFT)
            {
               this._leftArrowSkin.x = _loc5_ - this._leftArrowSkin.width - this._leftArrowGap;
               this._leftArrowSkin.y = this._arrowOffset + _loc6_ + Math.round((_loc10_ - this._leftArrowSkin.height) / 2);
               this._leftArrowSkin.y = Math.min(_loc6_ + _loc10_ - this._paddingBottom - this._leftArrowSkin.height,Math.max(_loc6_ + this._paddingTop,this._leftArrowSkin.y));
            }
            else if(this._arrowPosition == RelativePosition.RIGHT)
            {
               this._rightArrowSkin.x = _loc5_ + _loc9_ + this._rightArrowGap;
               this._rightArrowSkin.y = this._arrowOffset + _loc6_ + Math.round((_loc10_ - this._rightArrowSkin.height) / 2);
               this._rightArrowSkin.y = Math.min(_loc6_ + _loc10_ - this._paddingBottom - this._rightArrowSkin.height,Math.max(_loc6_ + this._paddingTop,this._rightArrowSkin.y));
            }
            else if(this._arrowPosition == RelativePosition.BOTTOM)
            {
               this._bottomArrowSkin.x = this._arrowOffset + _loc5_ + Math.round((_loc9_ - this._bottomArrowSkin.width) / 2);
               this._bottomArrowSkin.x = Math.min(_loc5_ + _loc9_ - this._paddingRight - this._bottomArrowSkin.width,Math.max(_loc5_ + this._paddingLeft,this._bottomArrowSkin.x));
               this._bottomArrowSkin.y = _loc6_ + _loc10_ + this._bottomArrowGap;
            }
            else
            {
               this._topArrowSkin.x = this._arrowOffset + _loc5_ + Math.round((_loc9_ - this._topArrowSkin.width) / 2);
               this._topArrowSkin.x = Math.min(_loc5_ + _loc9_ - this._paddingRight - this._topArrowSkin.width,Math.max(_loc5_ + this._paddingLeft,this._topArrowSkin.x));
               this._topArrowSkin.y = _loc6_ - this._topArrowSkin.height - this._topArrowGap;
            }
         }
         if(this._content)
         {
            this._content.x = _loc5_ + this._paddingLeft;
            this._content.y = _loc6_ + this._paddingTop;
            _loc1_ = this._ignoreContentResize;
            this._ignoreContentResize = true;
            _loc2_ = _loc9_ - this._paddingLeft - this._paddingRight;
            _loc3_ = Math.abs(this._content.width - _loc2_);
            if(_loc3_ > FUZZY_CONTENT_DIMENSIONS_PADDING)
            {
               this._content.width = _loc2_;
            }
            _loc4_ = _loc10_ - this._paddingTop - this._paddingBottom;
            _loc3_ = Math.abs(this._content.height - _loc4_);
            if(_loc3_ > FUZZY_CONTENT_DIMENSIONS_PADDING)
            {
               this._content.height = _loc4_;
            }
            this._ignoreContentResize = _loc1_;
         }
      }
      
      protected function positionToOrigin() : void
      {
         if(!this._origin)
         {
            return;
         }
         this._origin.getBounds(Starling.current.stage,HELPER_RECT);
         var _loc1_:Boolean = this._lastGlobalBoundsOfOrigin != null;
         if(!_loc1_ || !this._lastGlobalBoundsOfOrigin.equals(HELPER_RECT))
         {
            if(!_loc1_)
            {
               this._lastGlobalBoundsOfOrigin = new Rectangle();
            }
            this._lastGlobalBoundsOfOrigin.x = HELPER_RECT.x;
            this._lastGlobalBoundsOfOrigin.y = HELPER_RECT.y;
            this._lastGlobalBoundsOfOrigin.width = HELPER_RECT.width;
            this._lastGlobalBoundsOfOrigin.height = HELPER_RECT.height;
            positionWithSupportedDirections(this,this._lastGlobalBoundsOfOrigin,this._supportedDirections);
         }
      }
      
      protected function callout_addedToStageHandler(param1:starling.events.Event) : void
      {
         var _loc2_:int = -getDisplayObjectDepthFromStage(this);
         Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN,this.callout_nativeStage_keyDownHandler,false,_loc2_,true);
         this.stage.addEventListener(TouchEvent.TOUCH,this.stage_touchHandler);
         this._isReadyToClose = false;
         this.addEventListener(EnterFrameEvent.ENTER_FRAME,this.callout_oneEnterFrameHandler);
      }
      
      protected function callout_removedFromStageHandler(param1:starling.events.Event) : void
      {
         this.stage.removeEventListener(TouchEvent.TOUCH,this.stage_touchHandler);
         Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN,this.callout_nativeStage_keyDownHandler);
      }
      
      protected function callout_oneEnterFrameHandler(param1:starling.events.Event) : void
      {
         this.removeEventListener(EnterFrameEvent.ENTER_FRAME,this.callout_oneEnterFrameHandler);
         this._isReadyToClose = true;
      }
      
      protected function callout_enterFrameHandler(param1:EnterFrameEvent) : void
      {
         this.positionToOrigin();
      }
      
      protected function stage_touchHandler(param1:starling.events.TouchEvent) : void
      {
         var _loc2_:Touch = null;
         var _loc3_:DisplayObject = DisplayObject(param1.target);
         if(!this._isReadyToClose || !this.closeOnTouchEndedOutside && !this.closeOnTouchBeganOutside || this.contains(_loc3_) || Boolean(PopUpManager.isPopUp(this)) && !PopUpManager.isTopLevelPopUp(this))
         {
            return;
         }
         if(this._origin == _loc3_ || this._origin is DisplayObjectContainer && Boolean(DisplayObjectContainer(this._origin).contains(_loc3_)))
         {
            return;
         }
         if(this.closeOnTouchBeganOutside)
         {
            _loc2_ = param1.getTouch(this.stage,TouchPhase.BEGAN);
            if(_loc2_)
            {
               this.close(this.disposeOnSelfClose);
               return;
            }
         }
         if(this.closeOnTouchEndedOutside)
         {
            _loc2_ = param1.getTouch(this.stage,TouchPhase.ENDED);
            if(_loc2_)
            {
               this.close(this.disposeOnSelfClose);
               return;
            }
         }
      }
      
      protected function callout_nativeStage_keyDownHandler(param1:flash.events.KeyboardEvent) : void
      {
         if(param1.isDefaultPrevented())
         {
            return;
         }
         if(!this.closeOnKeys || this.closeOnKeys.indexOf(param1.keyCode) < 0)
         {
            return;
         }
         param1.preventDefault();
         this.close(this.disposeOnSelfClose);
      }
      
      protected function origin_removedFromStageHandler(param1:starling.events.Event) : void
      {
         this.close(this.disposeOnSelfClose);
      }
      
      protected function content_resizeHandler(param1:starling.events.Event) : void
      {
         if(this._ignoreContentResize)
         {
            return;
         }
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
   }
}

