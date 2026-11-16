package com.newgrounds
{
   import flash.display.*;
   import flash.events.*;
   
   internal class APIEventDispatcher extends EventDispatcher
   {
      
      private static var _globalDispatcher:EventDispatcher;
      
      private static var _ticker:Sprite;
      
      private static var _eventQueue:Array = initEventQueue();
      
      public function APIEventDispatcher()
      {
         super();
      }
      
      public static function get globalDispatcher() : EventDispatcher
      {
         return _globalDispatcher;
      }
      
      public static function set globalDispatcher(param1:EventDispatcher) : void
      {
         _globalDispatcher = param1;
      }
      
      private static function initEventQueue() : Array
      {
         _ticker = new Sprite();
         _ticker.addEventListener(Event.ENTER_FRAME,runEventQueue);
         return [];
      }
      
      private static function runEventQueue(param1:*) : void
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         var _loc5_:uint = uint(_eventQueue.length);
         if(_loc5_)
         {
            _loc2_ = _eventQueue;
            _eventQueue = [];
            _loc3_ = 0;
            while(_loc3_ < _loc5_)
            {
               _loc4_ = _loc2_[_loc3_];
               _loc4_.dispatcher.actualDispatchEvent(_loc4_.event);
               _loc3_++;
            }
         }
      }
      
      override public function dispatchEvent(param1:Event) : Boolean
      {
         _eventQueue.push({
            "dispatcher":this,
            "event":param1
         });
         return true;
      }
      
      private function actualDispatchEvent(param1:Event) : void
      {
         var _loc2_:Boolean = super.dispatchEvent(param1);
         if(Boolean(_globalDispatcher) && this != _globalDispatcher)
         {
            _globalDispatcher.dispatchEvent(param1);
         }
      }
   }
}

