package starling.core
{
   import flash.display.*;
   import flash.display3D.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import starling.animation.*;
   import starling.display.*;
   import starling.events.*;
   import starling.rendering.*;
   import starling.utils.*;
   
   public class Starling extends starling.events.EventDispatcher
   {
      
      private static var sCurrent:Starling;
      
      public static const VERSION:String = "2.0.1";
      
      private static const PROGRAM_DATA_NAME:String = "Starling.programs";
      
      private static var sPainters:Dictionary = new Dictionary(true);
      
      private static var sAll:Vector.<Starling> = new Vector.<Starling>(0);
      
      private var _stage:starling.display.Stage;
      
      private var _rootClass:Class;
      
      private var _root:starling.display.DisplayObject;
      
      private var _juggler:Juggler;
      
      private var _painter:Painter;
      
      private var _touchProcessor:TouchProcessor;
      
      private var _antiAliasing:int;
      
      private var _frameTimestamp:Number;
      
      private var _frameID:uint;
      
      private var _leftMouseDown:Boolean;
      
      private var _statsDisplay:StatsDisplay;
      
      private var _started:Boolean;
      
      private var _rendering:Boolean;
      
      private var _supportHighResolutions:Boolean;
      
      private var _skipUnchangedFrames:Boolean;
      
      private var _showStats:Boolean;
      
      private var _viewPort:Rectangle;
      
      private var _previousViewPort:Rectangle;
      
      private var _clippedViewPort:Rectangle;
      
      private var _nativeStage:flash.display.Stage;
      
      private var _nativeStageEmpty:Boolean;
      
      private var _nativeOverlay:flash.display.Sprite;
      
      public function Starling(param1:Class, param2:flash.display.Stage, param3:Rectangle = null, param4:Stage3D = null, param5:String = "auto", param6:Object = "auto")
      {
         var _loc7_:String = null;
         super();
         if(param2 == null)
         {
            throw new ArgumentError("Stage must not be null");
         }
         if(param3 == null)
         {
            param3 = new Rectangle(0,0,param2.stageWidth,param2.stageHeight);
         }
         if(param4 == null)
         {
            param4 = param2.stage3Ds[0];
         }
         SystemUtil.initialize();
         sAll.push(this);
         this.makeCurrent();
         this._rootClass = param1;
         this._viewPort = param3;
         this._previousViewPort = new Rectangle();
         this._stage = new starling.display.Stage(param3.width,param3.height,param2.color);
         this._nativeOverlay = new Sprite();
         this._nativeStage = param2;
         this._nativeStage.addChild(this._nativeOverlay);
         this._touchProcessor = new TouchProcessor(this._stage);
         this._juggler = new Juggler();
         this._antiAliasing = 0;
         this._supportHighResolutions = false;
         this._frameTimestamp = getTimer() / 1000;
         this._painter = this.createPainter(param4);
         param2.scaleMode = StageScaleMode.NO_SCALE;
         param2.align = StageAlign.TOP_LEFT;
         for each(_loc7_ in this.touchEventTypes)
         {
            param2.addEventListener(_loc7_,this.onTouch,false,0,true);
         }
         param2.addEventListener(flash.events.Event.ENTER_FRAME,this.onEnterFrame,false,0,true);
         param2.addEventListener(flash.events.KeyboardEvent.KEY_DOWN,this.onKey,false,0,true);
         param2.addEventListener(flash.events.KeyboardEvent.KEY_UP,this.onKey,false,0,true);
         param2.addEventListener(flash.events.Event.RESIZE,this.onResize,false,0,true);
         param2.addEventListener(flash.events.Event.MOUSE_LEAVE,this.onMouseLeave,false,0,true);
         param4.addEventListener(flash.events.Event.CONTEXT3D_CREATE,this.onContextCreated,false,10,true);
         param4.addEventListener(ErrorEvent.ERROR,this.onStage3DError,false,10,true);
         if(this._painter.shareContext)
         {
            setTimeout(this.initialize,1);
         }
         else
         {
            if(SystemUtil.supportsDepthAndStencil)
            {
            }
            this._painter.requestContext3D(param5,param6);
         }
      }
      
      public static function get current() : Starling
      {
         return sCurrent;
      }
      
      public static function get all() : Vector.<Starling>
      {
         return sAll;
      }
      
      public static function get context() : Context3D
      {
         return sCurrent ? sCurrent.context : null;
      }
      
      public static function get juggler() : Juggler
      {
         return sCurrent ? sCurrent._juggler : null;
      }
      
      public static function get painter() : Painter
      {
         return sCurrent ? sCurrent._painter : null;
      }
      
      public static function get contentScaleFactor() : Number
      {
         return sCurrent ? Number(sCurrent.contentScaleFactor) : 1;
      }
      
      public static function get multitouchEnabled() : Boolean
      {
         return Multitouch.inputMode == MultitouchInputMode.TOUCH_POINT;
      }
      
      public static function set multitouchEnabled(param1:Boolean) : void
      {
         if(sCurrent)
         {
            throw new IllegalOperationError("\'multitouchEnabled\' must be set before Starling instance is created");
         }
         Multitouch.inputMode = param1 ? MultitouchInputMode.TOUCH_POINT : MultitouchInputMode.NONE;
      }
      
      public static function get frameID() : uint
      {
         return sCurrent ? uint(sCurrent._frameID) : 0;
      }
      
      public function dispose() : void
      {
         var numInstancesSharingThisPainter:int = 0;
         var touchEventType:String = null;
         var index:int = 0;
         this.stop(true);
         this._nativeStage.removeEventListener(flash.events.Event.ENTER_FRAME,this.onEnterFrame,false);
         this._nativeStage.removeEventListener(flash.events.KeyboardEvent.KEY_DOWN,this.onKey,false);
         this._nativeStage.removeEventListener(flash.events.KeyboardEvent.KEY_UP,this.onKey,false);
         this._nativeStage.removeEventListener(flash.events.Event.RESIZE,this.onResize,false);
         this._nativeStage.removeEventListener(flash.events.Event.MOUSE_LEAVE,this.onMouseLeave,false);
         this._nativeStage.removeChild(this._nativeOverlay);
         this.stage3D.removeEventListener(flash.events.Event.CONTEXT3D_CREATE,this.onContextCreated,false);
         this.stage3D.removeEventListener(flash.events.Event.CONTEXT3D_CREATE,this.onContextRestored,false);
         this.stage3D.removeEventListener(ErrorEvent.ERROR,this.onStage3DError,false);
         for each(touchEventType in this.touchEventTypes)
         {
            this._nativeStage.removeEventListener(touchEventType,this.onTouch,false);
         }
         index = int(sAll.indexOf(this));
         if(index != -1)
         {
            sAll.removeAt(index);
         }
         numInstancesSharingThisPainter = int(sAll.filter(function(param1:Starling, ... rest):Boolean
         {
            return param1.stage3D == stage3D;
         }).length);
         if(numInstancesSharingThisPainter == 0)
         {
            delete sPainters[this.stage3D];
            this._painter.dispose();
         }
         if(this._touchProcessor)
         {
            this._touchProcessor.dispose();
         }
         if(this._stage)
         {
            this._stage.dispose();
         }
         if(sCurrent == this)
         {
            sCurrent = null;
         }
      }
      
      private function initialize() : void
      {
         this.makeCurrent();
         this.updateViewPort(true);
         dispatchEventWith(flash.events.Event.CONTEXT3D_CREATE,false,this.context);
         this.initializeRoot();
         this._frameTimestamp = getTimer() / 1000;
      }
      
      private function initializeRoot() : void
      {
         if(this._root == null && this._rootClass != null)
         {
            this._root = new this._rootClass() as DisplayObject;
            if(this._root == null)
            {
               throw new Error("Invalid root class: " + this._rootClass);
            }
            this._stage.addChildAt(this._root,0);
            dispatchEventWith(starling.events.Event.ROOT_CREATED,false,this._root);
         }
      }
      
      private function createPainter(param1:Stage3D) : Painter
      {
         var _loc2_:Painter = null;
         if(param1 in sPainters)
         {
            return sPainters[param1];
         }
         _loc2_ = new Painter(param1);
         sPainters[param1] = _loc2_;
         return _loc2_;
      }
      
      public function nextFrame() : void
      {
         var _loc1_:Number = getTimer() / 1000;
         var _loc2_:Number = _loc1_ - this._frameTimestamp;
         this._frameTimestamp = _loc1_;
         if(_loc2_ > 1)
         {
            _loc2_ = 1;
         }
         if(_loc2_ < 0)
         {
            _loc2_ = 1 / this._nativeStage.frameRate;
         }
         this.advanceTime(_loc2_);
         this.render();
      }
      
      public function advanceTime(param1:Number) : void
      {
         if(!this.contextValid)
         {
            return;
         }
         this.makeCurrent();
         this._touchProcessor.advanceTime(param1);
         this._stage.advanceTime(param1);
         this._juggler.advanceTime(param1);
      }
      
      public function render() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Number = Number(NaN);
         var _loc3_:Number = Number(NaN);
         if(!this.contextValid)
         {
            return;
         }
         this.makeCurrent();
         this.updateViewPort();
         var _loc4_:Boolean = Boolean(this._stage.requiresRedraw) || Boolean(this.mustAlwaysRender);
         if(_loc4_)
         {
            dispatchEventWith(starling.events.Event.RENDER);
            _loc1_ = Boolean(this._painter.shareContext);
            _loc2_ = this._viewPort.width / this._stage.stageWidth;
            _loc3_ = this._viewPort.height / this._stage.stageHeight;
            this._painter.nextFrame();
            this._painter.pixelSize = 1 / this.contentScaleFactor;
            this._painter.state.setProjectionMatrix(this._viewPort.x < 0 ? -this._viewPort.x / _loc2_ : 0,this._viewPort.y < 0 ? -this._viewPort.y / _loc3_ : 0,this._clippedViewPort.width / _loc2_,this._clippedViewPort.height / _loc3_,this._stage.stageWidth,this._stage.stageHeight,this._stage.cameraPosition);
            if(!_loc1_)
            {
               this._painter.clear(this._stage.color,1);
            }
            this._stage.render(this._painter);
            this._painter.finishFrame();
            this._painter.frameID = ++this._frameID;
            if(!_loc1_)
            {
               this._painter.present();
            }
         }
         if(this._statsDisplay)
         {
            this._statsDisplay.drawCount = this._painter.drawCount;
            if(!_loc4_)
            {
               this._statsDisplay.markFrameAsSkipped();
            }
         }
      }
      
      private function updateViewPort(param1:Boolean = false) : void
      {
         var _loc2_:Number = Number(NaN);
         if(param1 || this._previousViewPort.width != this._viewPort.width || this._previousViewPort.height != this._viewPort.height || this._previousViewPort.x != this._viewPort.x || this._previousViewPort.y != this._viewPort.y)
         {
            this._previousViewPort.setTo(this._viewPort.x,this._viewPort.y,this._viewPort.width,this._viewPort.height);
            this._clippedViewPort = this._viewPort.intersection(new Rectangle(0,0,this._nativeStage.stageWidth,this._nativeStage.stageHeight));
            if(!this.shareContext)
            {
               _loc2_ = this._supportHighResolutions ? Number(this._nativeStage.contentsScaleFactor) : 1;
               this._painter.configureBackBuffer(this._clippedViewPort,_loc2_,this._antiAliasing,true);
            }
         }
      }
      
      private function updateNativeOverlay() : void
      {
         this._nativeOverlay.x = this._viewPort.x;
         this._nativeOverlay.y = this._viewPort.y;
         this._nativeOverlay.scaleX = this._viewPort.width / this._stage.stageWidth;
         this._nativeOverlay.scaleY = this._viewPort.height / this._stage.stageHeight;
      }
      
      public function stopWithFatalError(param1:String) : void
      {
         var _loc2_:Shape = new Shape();
         _loc2_.graphics.beginFill(0,0.8);
         _loc2_.graphics.drawRect(0,0,this._stage.stageWidth,this._stage.stageHeight);
         _loc2_.graphics.endFill();
         var _loc3_:TextField = new TextField();
         var _loc4_:TextFormat = new TextFormat("Verdana",14,16777215);
         _loc4_.align = TextFormatAlign.CENTER;
         _loc3_.defaultTextFormat = _loc4_;
         _loc3_.wordWrap = true;
         _loc3_.width = this._stage.stageWidth * 0.75;
         _loc3_.autoSize = TextFieldAutoSize.CENTER;
         _loc3_.text = param1;
         _loc3_.x = (this._stage.stageWidth - _loc3_.width) / 2;
         _loc3_.y = (this._stage.stageHeight - _loc3_.height) / 2;
         _loc3_.background = true;
         _loc3_.backgroundColor = 5570560;
         this.updateNativeOverlay();
         this.nativeOverlay.addChild(_loc2_);
         this.nativeOverlay.addChild(_loc3_);
         this.stop(true);
         dispatchEventWith(starling.events.Event.FATAL_ERROR,false,param1);
      }
      
      public function makeCurrent() : void
      {
         sCurrent = this;
      }
      
      public function start() : void
      {
         this._started = this._rendering = true;
         this._frameTimestamp = getTimer() / 1000;
         setTimeout(this.setRequiresRedraw,1);
      }
      
      public function stop(param1:Boolean = false) : void
      {
         this._started = false;
         this._rendering = !param1;
      }
      
      public function setRequiresRedraw() : void
      {
         this._stage.setRequiresRedraw();
      }
      
      private function onStage3DError(param1:ErrorEvent) : void
      {
         var _loc2_:String = null;
         if(param1.errorID == 3702)
         {
            _loc2_ = Capabilities.playerType == "Desktop" ? "renderMode" : "wmode";
            this.stopWithFatalError("Context3D not available! Possible reasons: wrong " + _loc2_ + " or missing device support.");
         }
         else
         {
            this.stopWithFatalError("Stage3D error: " + param1.text);
         }
      }
      
      private function onContextCreated(param1:flash.events.Event) : void
      {
         this.stage3D.removeEventListener(flash.events.Event.CONTEXT3D_CREATE,this.onContextCreated);
         this.stage3D.addEventListener(flash.events.Event.CONTEXT3D_CREATE,this.onContextRestored,false,10,true);
         this.initialize();
      }
      
      private function onContextRestored(param1:flash.events.Event) : void
      {
         this.updateViewPort(true);
         dispatchEventWith(flash.events.Event.CONTEXT3D_CREATE,false,this.context);
      }
      
      private function onEnterFrame(param1:flash.events.Event) : void
      {
         if(!this.shareContext)
         {
            if(this._started)
            {
               this.nextFrame();
            }
            else if(this._rendering)
            {
               this.render();
            }
         }
         this.updateNativeOverlay();
      }
      
      private function onKey(param1:flash.events.KeyboardEvent) : void
      {
         if(!this._started)
         {
            return;
         }
         var _loc2_:starling.events.KeyboardEvent = new starling.events.KeyboardEvent(param1.type,param1.charCode,param1.keyCode,param1.keyLocation,param1.ctrlKey,param1.altKey,param1.shiftKey);
         this.makeCurrent();
         this._stage.dispatchEvent(_loc2_);
         if(_loc2_.isDefaultPrevented())
         {
            param1.preventDefault();
         }
      }
      
      private function onResize(param1:flash.events.Event) : void
      {
         var stageWidth:int = 0;
         var stageHeight:int = 0;
         var dispatchResizeEvent:Function = null;
         var event:flash.events.Event = param1;
         stageWidth = 0;
         stageHeight = 0;
         dispatchResizeEvent = null;
         dispatchResizeEvent = function():void
         {
            makeCurrent();
            removeEventListener(flash.events.Event.CONTEXT3D_CREATE,dispatchResizeEvent);
            _stage.dispatchEvent(new ResizeEvent(flash.events.Event.RESIZE,stageWidth,stageHeight));
         };
         stageWidth = int(event.target.stageWidth);
         stageHeight = int(event.target.stageHeight);
         if(this.contextValid)
         {
            dispatchResizeEvent();
         }
         else
         {
            addEventListener(flash.events.Event.CONTEXT3D_CREATE,dispatchResizeEvent);
         }
      }
      
      private function onMouseLeave(param1:flash.events.Event) : void
      {
         this._touchProcessor.enqueueMouseLeftStage();
      }
      
      private function onTouch(param1:flash.events.Event) : void
      {
         var _loc2_:Number = Number(NaN);
         var _loc3_:Number = Number(NaN);
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:MouseEvent = null;
         var _loc7_:flash.events.TouchEvent = null;
         if(!this._started)
         {
            return;
         }
         var _loc8_:Number = 1;
         var _loc9_:Number = 1;
         var _loc10_:Number = 1;
         if(param1 is MouseEvent)
         {
            _loc6_ = param1 as MouseEvent;
            _loc2_ = _loc6_.stageX;
            _loc3_ = _loc6_.stageY;
            _loc4_ = 0;
            if(param1.type == MouseEvent.MOUSE_DOWN)
            {
               this._leftMouseDown = true;
            }
            else if(param1.type == MouseEvent.MOUSE_UP)
            {
               this._leftMouseDown = false;
            }
         }
         else
         {
            _loc7_ = param1 as TouchEvent;
            if(Boolean(Mouse.supportsCursor) && _loc7_.isPrimaryTouchPoint)
            {
               return;
            }
            _loc2_ = _loc7_.stageX;
            _loc3_ = _loc7_.stageY;
            _loc4_ = _loc7_.touchPointID;
            _loc8_ = _loc7_.pressure;
            _loc9_ = _loc7_.sizeX;
            _loc10_ = _loc7_.sizeY;
         }
         switch(param1.type)
         {
            case TouchEvent.TOUCH_BEGIN:
               _loc5_ = TouchPhase.BEGAN;
               break;
            case TouchEvent.TOUCH_MOVE:
               _loc5_ = TouchPhase.MOVED;
               break;
            case TouchEvent.TOUCH_END:
               _loc5_ = TouchPhase.ENDED;
               break;
            case MouseEvent.MOUSE_DOWN:
               _loc5_ = TouchPhase.BEGAN;
               break;
            case MouseEvent.MOUSE_UP:
               _loc5_ = TouchPhase.ENDED;
               break;
            case MouseEvent.RIGHT_MOUSE_DOWN:
               _loc5_ = TouchPhase.RIGHT_BEGAN;
               break;
            case MouseEvent.RIGHT_MOUSE_UP:
               _loc5_ = TouchPhase.RIGHT_ENDED;
               break;
            case MouseEvent.MOUSE_MOVE:
               _loc5_ = this._leftMouseDown ? TouchPhase.MOVED : TouchPhase.HOVER;
         }
         _loc2_ = this._stage.stageWidth * (_loc2_ - this._viewPort.x) / this._viewPort.width;
         _loc3_ = this._stage.stageHeight * (_loc3_ - this._viewPort.y) / this._viewPort.height;
         this._touchProcessor.enqueue(_loc4_,_loc5_,_loc2_,_loc3_,_loc8_,_loc9_,_loc10_);
         if(param1.type == MouseEvent.MOUSE_UP && Boolean(Mouse.supportsCursor))
         {
            this._touchProcessor.enqueue(_loc4_,TouchPhase.HOVER,_loc2_,_loc3_);
         }
      }
      
      private function get touchEventTypes() : Array
      {
         var _loc1_:Array = [];
         if(multitouchEnabled)
         {
            _loc1_.push(TouchEvent.TOUCH_BEGIN,TouchEvent.TOUCH_MOVE,TouchEvent.TOUCH_END);
         }
         if(!multitouchEnabled || Boolean(Mouse.supportsCursor))
         {
            _loc1_.push(MouseEvent.MOUSE_DOWN,MouseEvent.MOUSE_MOVE,MouseEvent.MOUSE_UP,MouseEvent.RIGHT_MOUSE_DOWN,MouseEvent.RIGHT_MOUSE_UP);
         }
         return _loc1_;
      }
      
      private function get mustAlwaysRender() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         if(!this._skipUnchangedFrames || Boolean(this._painter.shareContext))
         {
            return true;
         }
         if(Boolean(SystemUtil.isDesktop) && this.profile != Context3DProfile.BASELINE_CONSTRAINED)
         {
            return false;
         }
         _loc1_ = Boolean(isNativeDisplayObjectEmpty(this._nativeStage));
         _loc2_ = !_loc1_ || !this._nativeStageEmpty;
         this._nativeStageEmpty = _loc1_;
         return _loc2_;
      }
      
      public function get isStarted() : Boolean
      {
         return this._started;
      }
      
      public function get juggler() : Juggler
      {
         return this._juggler;
      }
      
      public function get painter() : Painter
      {
         return this._painter;
      }
      
      public function get context() : Context3D
      {
         return this._painter.context;
      }
      
      public function get simulateMultitouch() : Boolean
      {
         return this._touchProcessor.simulateMultitouch;
      }
      
      public function set simulateMultitouch(param1:Boolean) : void
      {
         this._touchProcessor.simulateMultitouch = param1;
      }
      
      public function get enableErrorChecking() : Boolean
      {
         return this._painter.enableErrorChecking;
      }
      
      public function set enableErrorChecking(param1:Boolean) : void
      {
         this._painter.enableErrorChecking = param1;
      }
      
      public function get antiAliasing() : int
      {
         return this._antiAliasing;
      }
      
      public function set antiAliasing(param1:int) : void
      {
         if(this._antiAliasing != param1)
         {
            this._antiAliasing = param1;
            if(this.contextValid)
            {
               this.updateViewPort(true);
            }
         }
      }
      
      public function get viewPort() : Rectangle
      {
         return this._viewPort;
      }
      
      public function set viewPort(param1:Rectangle) : void
      {
         this._viewPort = param1.clone();
      }
      
      public function get contentScaleFactor() : Number
      {
         return this._viewPort.width * this._painter.backBufferScaleFactor / this._stage.stageWidth;
      }
      
      public function get nativeOverlay() : flash.display.Sprite
      {
         return this._nativeOverlay;
      }
      
      public function get showStats() : Boolean
      {
         return this._showStats;
      }
      
      public function set showStats(param1:Boolean) : void
      {
         this._showStats = param1;
         if(param1)
         {
            if(this._statsDisplay)
            {
               this._stage.addChild(this._statsDisplay);
            }
            else
            {
               this.showStatsAt();
            }
         }
         else if(this._statsDisplay)
         {
            this._statsDisplay.removeFromParent();
         }
      }
      
      public function showStatsAt(param1:String = "left", param2:String = "top", param3:Number = 1) : void
      {
         var onRootCreated:Function = null;
         var horizontalAlign:String = param1;
         var verticalAlign:String = param2;
         var scale:Number = param3;
         onRootCreated = null;
         var stageWidth:int = 0;
         var stageHeight:int = 0;
         onRootCreated = function():void
         {
            if(_showStats)
            {
               showStatsAt(horizontalAlign,verticalAlign,scale);
            }
            removeEventListener(starling.events.Event.ROOT_CREATED,onRootCreated);
         };
         this._showStats = true;
         if(this.context == null)
         {
            addEventListener(starling.events.Event.ROOT_CREATED,onRootCreated);
         }
         else
         {
            stageWidth = int(this._stage.stageWidth);
            stageHeight = int(this._stage.stageHeight);
            if(this._statsDisplay == null)
            {
               this._statsDisplay = new StatsDisplay();
               this._statsDisplay.touchable = false;
            }
            this._stage.addChild(this._statsDisplay);
            this._statsDisplay.scaleX = this._statsDisplay.scaleY = scale;
            if(horizontalAlign == Align.LEFT)
            {
               this._statsDisplay.x = 0;
            }
            else if(horizontalAlign == Align.RIGHT)
            {
               this._statsDisplay.x = stageWidth - this._statsDisplay.width;
            }
            else
            {
               if(horizontalAlign != Align.CENTER)
               {
                  throw new ArgumentError("Invalid horizontal alignment: " + horizontalAlign);
               }
               this._statsDisplay.x = (stageWidth - this._statsDisplay.width) / 2;
            }
            if(verticalAlign == Align.TOP)
            {
               this._statsDisplay.y = 0;
            }
            else if(verticalAlign == Align.BOTTOM)
            {
               this._statsDisplay.y = stageHeight - this._statsDisplay.height;
            }
            else
            {
               if(verticalAlign != Align.CENTER)
               {
                  throw new ArgumentError("Invalid vertical alignment: " + verticalAlign);
               }
               this._statsDisplay.y = (stageHeight - this._statsDisplay.height) / 2;
            }
         }
      }
      
      public function get stage() : starling.display.Stage
      {
         return this._stage;
      }
      
      public function get stage3D() : Stage3D
      {
         return this._painter.stage3D;
      }
      
      public function get nativeStage() : flash.display.Stage
      {
         return this._nativeStage;
      }
      
      public function get root() : starling.display.DisplayObject
      {
         return this._root;
      }
      
      public function get rootClass() : Class
      {
         return this._rootClass;
      }
      
      public function set rootClass(param1:Class) : void
      {
         if(this._rootClass != null && this._root != null)
         {
            throw new Error("Root class may not change after root has been instantiated");
         }
         if(this._rootClass == null)
         {
            this._rootClass = param1;
            if(this.context)
            {
               this.initializeRoot();
            }
         }
      }
      
      public function get shareContext() : Boolean
      {
         return this._painter.shareContext;
      }
      
      public function set shareContext(param1:Boolean) : void
      {
         this._painter.shareContext = param1;
      }
      
      public function get profile() : String
      {
         return this._painter.profile;
      }
      
      public function get supportHighResolutions() : Boolean
      {
         return this._supportHighResolutions;
      }
      
      public function set supportHighResolutions(param1:Boolean) : void
      {
         if(this._supportHighResolutions != param1)
         {
            this._supportHighResolutions = param1;
            if(this.contextValid)
            {
               this.updateViewPort(true);
            }
         }
      }
      
      public function get skipUnchangedFrames() : Boolean
      {
         return this._skipUnchangedFrames;
      }
      
      public function set skipUnchangedFrames(param1:Boolean) : void
      {
         this._skipUnchangedFrames = param1;
         this._nativeStageEmpty = false;
      }
      
      public function get touchProcessor() : TouchProcessor
      {
         return this._touchProcessor;
      }
      
      public function set touchProcessor(param1:TouchProcessor) : void
      {
         if(param1 != this._touchProcessor)
         {
            this._touchProcessor.dispose();
            this._touchProcessor = param1;
         }
      }
      
      public function get frameID() : uint
      {
         return this._frameID;
      }
      
      public function get contextValid() : Boolean
      {
         return this._painter.contextValid;
      }
   }
}

import flash.display.§flash.display.DisplayObject§;
import flash.display.§flash.display.DisplayObjectContainer§;

function isNativeDisplayObjectEmpty(param1:flash.display.DisplayObject):Boolean
{
   var _loc2_:flash.display.DisplayObjectContainer = null;
   var _loc3_:int = 0;
   var _loc4_:int = 0;
   if(param1 is flash.display.DisplayObjectContainer)
   {
      _loc2_ = param1 as flash.display.DisplayObjectContainer;
      _loc3_ = _loc2_.numChildren;
      _loc4_ = 0;
      while(_loc4_ < _loc3_)
      {
         if(!isNativeDisplayObjectEmpty(_loc2_.getChildAt(_loc4_)))
         {
            return false;
         }
         _loc4_++;
      }
      return true;
   }
   return !param1.visible;
}
