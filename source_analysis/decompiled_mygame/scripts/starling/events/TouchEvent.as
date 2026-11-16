package starling.events
{
   import starling.core.starling_internal;
   import starling.display.DisplayObject;
   
   use namespace starling_internal;
   
   public class TouchEvent extends Event
   {
      
      public static const TOUCH:String = "touch";
      
      private static var sTouches:Vector.<Touch> = new Vector.<Touch>(0);
      
      private var _shiftKey:Boolean;
      
      private var _ctrlKey:Boolean;
      
      private var _timestamp:Number;
      
      private var _visitedObjects:Vector.<EventDispatcher>;
      
      public function TouchEvent(param1:String, param2:Vector.<Touch>, param3:Boolean = false, param4:Boolean = false, param5:Boolean = true)
      {
         super(param1,param5,param2);
         this._shiftKey = param3;
         this._ctrlKey = param4;
         this._timestamp = -1;
         this._visitedObjects = new Vector.<EventDispatcher>(0);
         var _loc6_:int = int(param2.length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            if(param2[_loc7_].timestamp > this._timestamp)
            {
               this._timestamp = param2[_loc7_].timestamp;
            }
            _loc7_++;
         }
      }
      
      public function getTouches(param1:DisplayObject, param2:String = null, param3:Vector.<Touch> = null) : Vector.<Touch>
      {
         var _loc4_:Touch = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         if(param3 == null)
         {
            param3 = new Vector.<Touch>(0);
         }
         var _loc7_:Vector.<Touch> = data as Vector.<Touch>;
         var _loc8_:int = int(_loc7_.length);
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_)
         {
            _loc4_ = _loc7_[_loc9_];
            _loc5_ = _loc4_.isTouching(param1);
            _loc6_ = param2 == null || param2 == _loc4_.phase;
            if(_loc5_ && _loc6_)
            {
               param3[param3.length] = _loc4_;
            }
            _loc9_++;
         }
         return param3;
      }
      
      public function getTouch(param1:DisplayObject, param2:String = null, param3:int = -1) : Touch
      {
         var _loc4_:Touch = null;
         var _loc5_:int = 0;
         this.getTouches(param1,param2,sTouches);
         var _loc6_:int = int(sTouches.length);
         if(_loc6_ > 0)
         {
            _loc4_ = null;
            if(param3 < 0)
            {
               _loc4_ = sTouches[0];
            }
            else
            {
               _loc5_ = 0;
               while(_loc5_ < _loc6_)
               {
                  if(sTouches[_loc5_].id == param3)
                  {
                     _loc4_ = sTouches[_loc5_];
                     break;
                  }
                  _loc5_++;
               }
            }
            sTouches.length = 0;
            return _loc4_;
         }
         return null;
      }
      
      public function interactsWith(param1:DisplayObject) : Boolean
      {
         var _loc2_:Boolean = false;
         this.getTouches(param1,null,sTouches);
         var _loc3_:* = int(sTouches.length - 1);
         while(_loc3_ >= 0)
         {
            if(sTouches[_loc3_].phase != TouchPhase.ENDED)
            {
               _loc2_ = true;
               break;
            }
            _loc3_--;
         }
         sTouches.length = 0;
         return _loc2_;
      }
      
      internal function dispatch(param1:Vector.<EventDispatcher>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:EventDispatcher = null;
         var _loc4_:int = 0;
         var _loc5_:EventDispatcher = null;
         var _loc6_:Boolean = false;
         if(Boolean(param1) && Boolean(param1.length))
         {
            _loc2_ = bubbles ? int(param1.length) : 1;
            _loc3_ = target;
            setTarget(param1[0] as EventDispatcher);
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc5_ = param1[_loc4_] as EventDispatcher;
               if(this._visitedObjects.indexOf(_loc5_) == -1)
               {
                  _loc6_ = _loc5_.invokeEvent(this);
                  this._visitedObjects[this._visitedObjects.length] = _loc5_;
                  if(_loc6_)
                  {
                     break;
                  }
               }
               _loc4_++;
            }
            setTarget(_loc3_);
         }
      }
      
      public function get timestamp() : Number
      {
         return this._timestamp;
      }
      
      public function get touches() : Vector.<Touch>
      {
         return (data as Vector.<Touch>).concat();
      }
      
      public function get shiftKey() : Boolean
      {
         return this._shiftKey;
      }
      
      public function get ctrlKey() : Boolean
      {
         return this._ctrlKey;
      }
   }
}

