package starling.events
{
   import flash.geom.*;
   import flash.utils.*;
   import starling.core.*;
   import starling.display.DisplayObject;
   import starling.display.Stage;
   
   public class TouchProcessor
   {
      
      private static var sUpdatedTouches:Vector.<Touch> = new Vector.<Touch>(0);
      
      private static var sHoveringTouchData:Vector.<Object> = new Vector.<Object>(0);
      
      private static var sHelperPoint:Point = new Point();
      
      private var _stage:Stage;
      
      private var _root:DisplayObject;
      
      private var _elapsedTime:Number;
      
      private var _lastTaps:Vector.<Touch>;
      
      private var _shiftDown:Boolean = false;
      
      private var _ctrlDown:Boolean = false;
      
      private var _multitapTime:Number = 0.3;
      
      private var _multitapDistance:Number = 25;
      
      private var _touchMarker:TouchMarker;
      
      private var _simulateMultitouch:Boolean;
      
      protected var _queue:Vector.<Array>;
      
      protected var _currentTouches:Vector.<Touch>;
      
      public function TouchProcessor(param1:Stage)
      {
         super();
         this._root = this._stage = param1;
         this._elapsedTime = 0;
         this._currentTouches = new Vector.<Touch>(0);
         this._queue = new Vector.<Array>(0);
         this._lastTaps = new Vector.<Touch>(0);
         this._stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
         this._stage.addEventListener(KeyboardEvent.KEY_UP,this.onKey);
         this.monitorInterruptions(true);
      }
      
      public function dispose() : void
      {
         this.monitorInterruptions(false);
         this._stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
         this._stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKey);
         if(this._touchMarker)
         {
            this._touchMarker.dispose();
         }
      }
      
      public function advanceTime(param1:Number) : void
      {
         var _loc2_:* = 0;
         var _loc3_:Touch = null;
         var _loc4_:Array = null;
         this._elapsedTime += param1;
         sUpdatedTouches.length = 0;
         if(this._lastTaps.length > 0)
         {
            _loc2_ = int(this._lastTaps.length - 1);
            while(_loc2_ >= 0)
            {
               if(this._elapsedTime - this._lastTaps[_loc2_].timestamp > this._multitapTime)
               {
                  this._lastTaps.removeAt(_loc2_);
               }
               _loc2_--;
            }
         }
         while(this._queue.length > 0)
         {
            for each(_loc3_ in this._currentTouches)
            {
               if(_loc3_.phase == TouchPhase.BEGAN || _loc3_.phase == TouchPhase.MOVED)
               {
                  _loc3_.phase = TouchPhase.STATIONARY;
               }
            }
            while(this._queue.length > 0 && !this.containsTouchWithID(sUpdatedTouches,this._queue[this._queue.length - 1][0]))
            {
               _loc4_ = this._queue.pop();
               _loc3_ = this.createOrUpdateTouch(_loc4_[0],_loc4_[1],_loc4_[2],_loc4_[3],_loc4_[4],_loc4_[5],_loc4_[6]);
               sUpdatedTouches[sUpdatedTouches.length] = _loc3_;
            }
            this.processTouches(sUpdatedTouches,this._shiftDown,this._ctrlDown);
            _loc2_ = int(this._currentTouches.length - 1);
            while(_loc2_ >= 0)
            {
               if(this._currentTouches[_loc2_].phase == TouchPhase.ENDED)
               {
                  this._currentTouches.removeAt(_loc2_);
               }
               _loc2_--;
            }
            sUpdatedTouches.length = 0;
         }
      }
      
      protected function processTouches(param1:Vector.<Touch>, param2:Boolean, param3:Boolean) : void
      {
         var _loc4_:Touch = null;
         var _loc5_:Object = null;
         sHoveringTouchData.length = 0;
         var _loc6_:TouchEvent = new TouchEvent(TouchEvent.TOUCH,this._currentTouches,param2,param3);
         for each(_loc4_ in param1)
         {
            if(_loc4_.phase == TouchPhase.HOVER && Boolean(_loc4_.target))
            {
               sHoveringTouchData[sHoveringTouchData.length] = {
                  "touch":_loc4_,
                  "target":_loc4_.target,
                  "bubbleChain":_loc4_.bubbleChain
               };
            }
            if(_loc4_.phase == TouchPhase.HOVER || _loc4_.phase == TouchPhase.BEGAN)
            {
               sHelperPoint.setTo(_loc4_.globalX,_loc4_.globalY);
               _loc4_.target = this._root.hitTest(sHelperPoint);
            }
         }
         for each(_loc5_ in sHoveringTouchData)
         {
            if(_loc5_.touch.target != _loc5_.target)
            {
               _loc6_.dispatch(_loc5_.bubbleChain);
            }
         }
         for each(_loc4_ in param1)
         {
            _loc4_.dispatchEvent(_loc6_);
         }
      }
      
      public function enqueue(param1:int, param2:String, param3:Number, param4:Number, param5:Number = 1, param6:Number = 1, param7:Number = 1) : void
      {
         this._queue.unshift(arguments);
         if(Boolean(this._ctrlDown) && Boolean(this._touchMarker) && param1 == 0)
         {
            this._touchMarker.moveMarker(param3,param4,this._shiftDown);
            this._queue.unshift([1,param2,this._touchMarker.mockX,this._touchMarker.mockY]);
         }
      }
      
      public function enqueueMouseLeftStage() : void
      {
         var _loc1_:Touch = this.getCurrentTouch(0);
         if(_loc1_ == null || _loc1_.phase != TouchPhase.HOVER)
         {
            return;
         }
         var _loc2_:int = 1;
         var _loc3_:Number = _loc1_.globalX;
         var _loc4_:Number = _loc1_.globalY;
         var _loc5_:Number = _loc1_.globalX;
         var _loc6_:Number = this._stage.stageWidth - _loc5_;
         var _loc7_:Number = _loc1_.globalY;
         var _loc8_:Number = this._stage.stageHeight - _loc7_;
         var _loc9_:Number = Math.min(_loc5_,_loc6_,_loc7_,_loc8_);
         if(_loc9_ == _loc5_)
         {
            _loc3_ = -_loc2_;
         }
         else if(_loc9_ == _loc6_)
         {
            _loc3_ = this._stage.stageWidth + _loc2_;
         }
         else if(_loc9_ == _loc7_)
         {
            _loc4_ = -_loc2_;
         }
         else
         {
            _loc4_ = this._stage.stageHeight + _loc2_;
         }
         this.enqueue(0,TouchPhase.HOVER,_loc3_,_loc4_);
      }
      
      public function cancelTouches() : void
      {
         var _loc1_:Touch = null;
         if(this._currentTouches.length > 0)
         {
            for each(_loc1_ in this._currentTouches)
            {
               if(_loc1_.phase == TouchPhase.BEGAN || _loc1_.phase == TouchPhase.MOVED || _loc1_.phase == TouchPhase.STATIONARY)
               {
                  _loc1_.phase = TouchPhase.ENDED;
                  _loc1_.cancelled = true;
               }
            }
            this.processTouches(this._currentTouches,this._shiftDown,this._ctrlDown);
         }
         this._currentTouches.length = 0;
         this._queue.length = 0;
      }
      
      private function createOrUpdateTouch(param1:int, param2:String, param3:Number, param4:Number, param5:Number = 1, param6:Number = 1, param7:Number = 1) : Touch
      {
         var _loc8_:Touch = this.getCurrentTouch(param1);
         if(_loc8_ == null)
         {
            _loc8_ = new Touch(param1);
            this.addCurrentTouch(_loc8_);
         }
         _loc8_.globalX = param3;
         _loc8_.globalY = param4;
         _loc8_.phase = param2;
         _loc8_.timestamp = this._elapsedTime;
         _loc8_.pressure = param5;
         _loc8_.width = param6;
         _loc8_.height = param7;
         if(param2 == TouchPhase.BEGAN)
         {
            this.updateTapCount(_loc8_);
         }
         return _loc8_;
      }
      
      private function updateTapCount(param1:Touch) : void
      {
         var _loc2_:Touch = null;
         var _loc3_:Number = Number(NaN);
         var _loc4_:Touch = null;
         var _loc5_:Number = this._multitapDistance * this._multitapDistance;
         for each(_loc2_ in this._lastTaps)
         {
            _loc3_ = Math.pow(_loc2_.globalX - param1.globalX,2) + Math.pow(_loc2_.globalY - param1.globalY,2);
            if(_loc3_ <= _loc5_)
            {
               _loc4_ = _loc2_;
               break;
            }
         }
         if(_loc4_)
         {
            param1.tapCount = _loc4_.tapCount + 1;
            this._lastTaps.removeAt(this._lastTaps.indexOf(_loc4_));
         }
         else
         {
            param1.tapCount = 1;
         }
         this._lastTaps[this._lastTaps.length] = param1.clone();
      }
      
      private function addCurrentTouch(param1:Touch) : void
      {
         var _loc2_:* = int(this._currentTouches.length - 1);
         while(_loc2_ >= 0)
         {
            if(this._currentTouches[_loc2_].id == param1.id)
            {
               this._currentTouches.removeAt(_loc2_);
            }
            _loc2_--;
         }
         this._currentTouches[this._currentTouches.length] = param1;
      }
      
      private function getCurrentTouch(param1:int) : Touch
      {
         var _loc2_:Touch = null;
         for each(_loc2_ in this._currentTouches)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function containsTouchWithID(param1:Vector.<Touch>, param2:int) : Boolean
      {
         var _loc3_:Touch = null;
         for each(_loc3_ in param1)
         {
            if(_loc3_.id == param2)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get simulateMultitouch() : Boolean
      {
         return this._simulateMultitouch;
      }
      
      public function set simulateMultitouch(param1:Boolean) : void
      {
         var target:Starling = null;
         var createTouchMarker:Function = null;
         var value:Boolean = param1;
         target = null;
         createTouchMarker = null;
         createTouchMarker = function():void
         {
            target.removeEventListener(Event.CONTEXT3D_CREATE,createTouchMarker);
            if(_touchMarker == null)
            {
               _touchMarker = new TouchMarker();
               _touchMarker.visible = false;
               _stage.addChild(_touchMarker);
            }
         };
         if(this.simulateMultitouch == value)
         {
            return;
         }
         this._simulateMultitouch = value;
         target = Starling.current;
         if(value && this._touchMarker == null)
         {
            if(Starling.current.contextValid)
            {
               createTouchMarker();
            }
            else
            {
               target.addEventListener(Event.CONTEXT3D_CREATE,createTouchMarker);
            }
         }
         else if(!value && Boolean(this._touchMarker))
         {
            this._touchMarker.removeFromParent(true);
            this._touchMarker = null;
         }
      }
      
      public function get multitapTime() : Number
      {
         return this._multitapTime;
      }
      
      public function set multitapTime(param1:Number) : void
      {
         this._multitapTime = param1;
      }
      
      public function get multitapDistance() : Number
      {
         return this._multitapDistance;
      }
      
      public function set multitapDistance(param1:Number) : void
      {
         this._multitapDistance = param1;
      }
      
      public function get root() : DisplayObject
      {
         return this._root;
      }
      
      public function set root(param1:DisplayObject) : void
      {
         this._root = param1;
      }
      
      public function get stage() : Stage
      {
         return this._stage;
      }
      
      public function get numCurrentTouches() : int
      {
         return this._currentTouches.length;
      }
      
      private function onKey(param1:KeyboardEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Touch = null;
         var _loc4_:Touch = null;
         if(param1.keyCode == 17 || param1.keyCode == 15)
         {
            _loc2_ = Boolean(this._ctrlDown);
            this._ctrlDown = param1.type == KeyboardEvent.KEY_DOWN;
            if(Boolean(this._touchMarker) && _loc2_ != this._ctrlDown)
            {
               this._touchMarker.visible = this._ctrlDown;
               this._touchMarker.moveCenter(this._stage.stageWidth / 2,this._stage.stageHeight / 2);
               _loc3_ = this.getCurrentTouch(0);
               _loc4_ = this.getCurrentTouch(1);
               if(_loc3_)
               {
                  this._touchMarker.moveMarker(_loc3_.globalX,_loc3_.globalY);
               }
               if(Boolean(_loc2_) && Boolean(_loc4_) && _loc4_.phase != TouchPhase.ENDED)
               {
                  this._queue.unshift([1,TouchPhase.ENDED,_loc4_.globalX,_loc4_.globalY]);
               }
               else if(Boolean(this._ctrlDown) && Boolean(_loc3_))
               {
                  if(_loc3_.phase == TouchPhase.HOVER || _loc3_.phase == TouchPhase.ENDED)
                  {
                     this._queue.unshift([1,TouchPhase.HOVER,this._touchMarker.mockX,this._touchMarker.mockY]);
                  }
                  else
                  {
                     this._queue.unshift([1,TouchPhase.BEGAN,this._touchMarker.mockX,this._touchMarker.mockY]);
                  }
               }
            }
         }
         else if(param1.keyCode == 16)
         {
            this._shiftDown = param1.type == KeyboardEvent.KEY_DOWN;
         }
      }
      
      private function monitorInterruptions(param1:Boolean) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         try
         {
            _loc2_ = getDefinitionByName("flash.desktop::NativeApplication");
            _loc3_ = _loc2_["nativeApplication"];
            if(param1)
            {
               _loc3_.addEventListener("deactivate",this.onInterruption,false,0,true);
            }
            else
            {
               _loc3_.removeEventListener("deactivate",this.onInterruption);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function onInterruption(param1:Object) : void
      {
         this.cancelTouches();
      }
   }
}

