package starling.events
{
   import flash.utils.*;
   import starling.core.starling_internal;
   import starling.display.*;
   
   use namespace starling_internal;
   
   public class EventDispatcher
   {
      
      private static var sBubbleChains:Array = [];
      
      private var _eventListeners:Dictionary;
      
      public function EventDispatcher()
      {
         super();
      }
      
      public function addEventListener(param1:String, param2:Function) : void
      {
         if(this._eventListeners == null)
         {
            this._eventListeners = new Dictionary();
         }
         var _loc3_:Vector.<Function> = this._eventListeners[param1] as Vector.<Function>;
         if(_loc3_ == null)
         {
            this._eventListeners[param1] = new <Function>[param2];
         }
         else if(_loc3_.indexOf(param2) == -1)
         {
            _loc3_[_loc3_.length] = param2;
         }
      }
      
      public function removeEventListener(param1:String, param2:Function) : void
      {
         var _loc3_:Vector.<Function> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<Function> = null;
         var _loc7_:int = 0;
         if(this._eventListeners)
         {
            _loc3_ = this._eventListeners[param1] as Vector.<Function>;
            _loc4_ = _loc3_ ? int(_loc3_.length) : 0;
            if(_loc4_ > 0)
            {
               _loc5_ = _loc3_.indexOf(param2);
               if(_loc5_ != -1)
               {
                  _loc6_ = _loc3_.slice(0,_loc5_);
                  _loc7_ = _loc5_ + 1;
                  while(_loc7_ < _loc4_)
                  {
                     _loc6_[_loc7_ - 1] = _loc3_[_loc7_];
                     _loc7_++;
                  }
                  this._eventListeners[param1] = _loc6_;
               }
            }
         }
      }
      
      public function removeEventListeners(param1:String = null) : void
      {
         if(Boolean(param1) && Boolean(this._eventListeners))
         {
            delete this._eventListeners[param1];
         }
         else
         {
            this._eventListeners = null;
         }
      }
      
      public function dispatchEvent(param1:Event) : void
      {
         var _loc2_:Boolean = param1.bubbles;
         if(!_loc2_ && (this._eventListeners == null || !(param1.type in this._eventListeners)))
         {
            return;
         }
         var _loc3_:EventDispatcher = param1.target;
         param1.setTarget(this);
         if(_loc2_ && this is DisplayObject)
         {
            this.bubbleEvent(param1);
         }
         else
         {
            this.invokeEvent(param1);
         }
         if(_loc3_)
         {
            param1.setTarget(_loc3_);
         }
      }
      
      internal function invokeEvent(param1:Event) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:Function = null;
         var _loc4_:int = 0;
         var _loc5_:Vector.<Function> = this._eventListeners ? this._eventListeners[param1.type] as Vector.<Function> : null;
         var _loc6_:int = _loc5_ == null ? 0 : int(_loc5_.length);
         if(_loc6_)
         {
            param1.setCurrentTarget(this);
            _loc2_ = 0;
            while(_loc2_ < _loc6_)
            {
               _loc3_ = _loc5_[_loc2_] as Function;
               _loc4_ = _loc3_.length;
               if(_loc4_ == 0)
               {
                  _loc3_();
               }
               else if(_loc4_ == 1)
               {
                  _loc3_(param1);
               }
               else
               {
                  _loc3_(param1,param1.data);
               }
               if(param1.stopsImmediatePropagation)
               {
                  return true;
               }
               _loc2_++;
            }
            return param1.stopsPropagation;
         }
         return false;
      }
      
      internal function bubbleEvent(param1:Event) : void
      {
         var _loc2_:Vector.<EventDispatcher> = null;
         var _loc3_:Boolean = false;
         var _loc4_:DisplayObject = this as DisplayObject;
         var _loc5_:* = 1;
         if(sBubbleChains.length > 0)
         {
            _loc2_ = sBubbleChains.pop();
            _loc2_[0] = _loc4_;
         }
         else
         {
            _loc2_ = new <EventDispatcher>[_loc4_];
         }
         while(true)
         {
            _loc4_ = _loc4_.parent;
            if(_loc4_ == null)
            {
               break;
            }
            _loc2_[int(_loc5_++)] = _loc4_;
         }
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc3_ = _loc2_[_loc6_].invokeEvent(param1);
            if(_loc3_)
            {
               break;
            }
            _loc6_++;
         }
         _loc2_.length = 0;
         sBubbleChains[sBubbleChains.length] = _loc2_;
      }
      
      public function dispatchEventWith(param1:String, param2:Boolean = false, param3:Object = null) : void
      {
         var _loc4_:Event = null;
         if(param2 || this.hasEventListener(param1))
         {
            _loc4_ = Event.fromPool(param1,param2,param3);
            this.dispatchEvent(_loc4_);
            Event.toPool(_loc4_);
         }
      }
      
      public function hasEventListener(param1:String, param2:Function = null) : Boolean
      {
         var _loc3_:Vector.<Function> = this._eventListeners ? this._eventListeners[param1] : null;
         if(_loc3_ == null)
         {
            return false;
         }
         if(param2 != null)
         {
            return _loc3_.indexOf(param2) != -1;
         }
         return _loc3_.length != 0;
      }
   }
}

