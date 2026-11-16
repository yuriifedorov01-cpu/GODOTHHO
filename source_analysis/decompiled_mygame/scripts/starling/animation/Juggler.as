package starling.animation
{
   import flash.utils.*;
   import starling.core.*;
   import starling.events.*;
   
   public class Juggler implements IAnimatable
   {
      
      private static var sCurrentObjectID:uint;
      
      private var _objects:Vector.<IAnimatable>;
      
      private var _objectIDs:Dictionary;
      
      private var _elapsedTime:Number;
      
      public function Juggler()
      {
         super();
         this._elapsedTime = 0;
         this._objects = new Vector.<IAnimatable>(0);
         this._objectIDs = new Dictionary(true);
      }
      
      private static function getNextID() : uint
      {
         return ++sCurrentObjectID;
      }
      
      public function add(param1:IAnimatable) : uint
      {
         return this.addWithID(param1,getNextID());
      }
      
      private function addWithID(param1:IAnimatable, param2:uint) : uint
      {
         var _loc3_:EventDispatcher = null;
         if(Boolean(param1) && !(param1 in this._objectIDs))
         {
            _loc3_ = param1 as EventDispatcher;
            if(_loc3_)
            {
               _loc3_.addEventListener(Event.REMOVE_FROM_JUGGLER,this.onRemove);
            }
            this._objects[this._objects.length] = param1;
            this._objectIDs[param1] = param2;
            return param2;
         }
         return 0;
      }
      
      public function contains(param1:IAnimatable) : Boolean
      {
         return param1 in this._objectIDs;
      }
      
      public function remove(param1:IAnimatable) : uint
      {
         var _loc2_:EventDispatcher = null;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         if(Boolean(param1) && param1 in this._objectIDs)
         {
            _loc2_ = param1 as EventDispatcher;
            if(_loc2_)
            {
               _loc2_.removeEventListener(Event.REMOVE_FROM_JUGGLER,this.onRemove);
            }
            _loc3_ = int(this._objects.indexOf(param1));
            this._objects[_loc3_] = null;
            _loc4_ = uint(this._objectIDs[param1]);
            delete this._objectIDs[param1];
         }
         return _loc4_;
      }
      
      public function removeByID(param1:uint) : uint
      {
         var _loc2_:IAnimatable = null;
         var _loc3_:* = int(this._objects.length - 1);
         while(_loc3_ >= 0)
         {
            _loc2_ = this._objects[_loc3_];
            if(this._objectIDs[_loc2_] == param1)
            {
               this.remove(_loc2_);
               return param1;
            }
            _loc3_--;
         }
         return 0;
      }
      
      public function removeTweens(param1:Object) : void
      {
         var _loc2_:Tween = null;
         if(param1 == null)
         {
            return;
         }
         var _loc3_:* = int(this._objects.length - 1);
         while(_loc3_ >= 0)
         {
            _loc2_ = this._objects[_loc3_] as Tween;
            if(Boolean(_loc2_) && _loc2_.target == param1)
            {
               _loc2_.removeEventListener(Event.REMOVE_FROM_JUGGLER,this.onRemove);
               this._objects[_loc3_] = null;
               delete this._objectIDs[_loc2_];
            }
            _loc3_--;
         }
      }
      
      public function removeDelayedCalls(param1:Function) : void
      {
         var _loc2_:DelayedCall = null;
         if(param1 == null)
         {
            return;
         }
         var _loc3_:* = int(this._objects.length - 1);
         while(_loc3_ >= 0)
         {
            _loc2_ = this._objects[_loc3_] as DelayedCall;
            if(Boolean(_loc2_) && _loc2_.callback == param1)
            {
               _loc2_.removeEventListener(Event.REMOVE_FROM_JUGGLER,this.onRemove);
               this._objects[_loc3_] = null;
               delete this._objectIDs[this.tween];
            }
            _loc3_--;
         }
      }
      
      public function containsTweens(param1:Object) : Boolean
      {
         var _loc2_:* = 0;
         var _loc3_:Tween = null;
         if(param1)
         {
            _loc2_ = int(this._objects.length - 1);
            while(_loc2_ >= 0)
            {
               _loc3_ = this._objects[_loc2_] as Tween;
               if(Boolean(_loc3_) && _loc3_.target == param1)
               {
                  return true;
               }
               _loc2_--;
            }
         }
         return false;
      }
      
      public function containsDelayedCalls(param1:Function) : Boolean
      {
         var _loc2_:* = 0;
         var _loc3_:DelayedCall = null;
         if(param1 != null)
         {
            _loc2_ = int(this._objects.length - 1);
            while(_loc2_ >= 0)
            {
               _loc3_ = this._objects[_loc2_] as DelayedCall;
               if(Boolean(_loc3_) && _loc3_.callback == param1)
               {
                  return true;
               }
               _loc2_--;
            }
         }
         return false;
      }
      
      public function purge() : void
      {
         var _loc1_:IAnimatable = null;
         var _loc2_:EventDispatcher = null;
         var _loc3_:* = int(this._objects.length - 1);
         while(_loc3_ >= 0)
         {
            _loc1_ = this._objects[_loc3_];
            _loc2_ = _loc1_ as EventDispatcher;
            if(_loc2_)
            {
               _loc2_.removeEventListener(Event.REMOVE_FROM_JUGGLER,this.onRemove);
            }
            this._objects[_loc3_] = null;
            delete this._objectIDs[_loc1_];
            _loc3_--;
         }
      }
      
      public function delayCall(param1:Function, param2:Number, ... rest) : uint
      {
         if(param1 == null)
         {
            throw new ArgumentError("call must not be null");
         }
         var _loc4_:DelayedCall = DelayedCall.starling_internal::fromPool(param1,param2,rest);
         _loc4_.addEventListener(Event.REMOVE_FROM_JUGGLER,this.onPooledDelayedCallComplete);
         return this.add(_loc4_);
      }
      
      public function repeatCall(param1:Function, param2:Number, param3:int = 0, ... rest) : uint
      {
         if(param1 == null)
         {
            throw new ArgumentError("call must not be null");
         }
         var _loc5_:DelayedCall = DelayedCall.starling_internal::fromPool(param1,param2,rest);
         _loc5_.repeatCount = param3;
         _loc5_.addEventListener(Event.REMOVE_FROM_JUGGLER,this.onPooledDelayedCallComplete);
         return this.add(_loc5_);
      }
      
      private function onPooledDelayedCallComplete(param1:Event) : void
      {
         DelayedCall.starling_internal::toPool(param1.target as DelayedCall);
      }
      
      public function tween(param1:Object, param2:Number, param3:Object) : uint
      {
         var _loc4_:String = null;
         var _loc5_:Object = null;
         if(param1 == null)
         {
            throw new ArgumentError("target must not be null");
         }
         var _loc6_:Tween = Tween.starling_internal::fromPool(param1,param2);
         for(_loc4_ in param3)
         {
            _loc5_ = param3[_loc4_];
            if(_loc6_.hasOwnProperty(_loc4_))
            {
               _loc6_[_loc4_] = _loc5_;
            }
            else
            {
               if(!param1.hasOwnProperty(Tween.getPropertyName(_loc4_)))
               {
                  throw new ArgumentError("Invalid property: " + _loc4_);
               }
               _loc6_.animate(_loc4_,_loc5_ as Number);
            }
         }
         _loc6_.addEventListener(Event.REMOVE_FROM_JUGGLER,this.onPooledTweenComplete);
         return this.add(_loc6_);
      }
      
      private function onPooledTweenComplete(param1:Event) : void
      {
         Tween.starling_internal::toPool(param1.target as Tween);
      }
      
      public function advanceTime(param1:Number) : void
      {
         var _loc2_:* = 0;
         var _loc3_:IAnimatable = null;
         var _loc4_:int = int(this._objects.length);
         var _loc5_:* = 0;
         this._elapsedTime += param1;
         if(_loc4_ == 0)
         {
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = this._objects[_loc2_];
            if(_loc3_)
            {
               if(_loc5_ != _loc2_)
               {
                  this._objects[_loc5_] = _loc3_;
                  this._objects[_loc2_] = null;
               }
               _loc3_.advanceTime(param1);
               _loc5_++;
            }
            _loc2_++;
         }
         if(_loc5_ != _loc2_)
         {
            _loc4_ = int(this._objects.length);
            while(_loc2_ < _loc4_)
            {
               this._objects[int(_loc5_++)] = this._objects[int(_loc2_++)];
            }
            this._objects.length = _loc5_;
         }
      }
      
      private function onRemove(param1:Event) : void
      {
         var _loc2_:Tween = null;
         var _loc3_:uint = this.remove(param1.target as IAnimatable);
         if(_loc3_)
         {
            _loc2_ = param1.target as Tween;
            if(Boolean(_loc2_) && _loc2_.isComplete)
            {
               this.addWithID(_loc2_.nextTween,_loc3_);
            }
         }
      }
      
      public function get elapsedTime() : Number
      {
         return this._elapsedTime;
      }
      
      protected function get objects() : Vector.<IAnimatable>
      {
         return this._objects;
      }
   }
}

