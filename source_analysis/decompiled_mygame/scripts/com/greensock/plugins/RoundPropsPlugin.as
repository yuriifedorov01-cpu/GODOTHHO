package com.greensock.plugins
{
   import com.greensock.TweenLite;
   import com.greensock.core.PropTween;
   
   public class RoundPropsPlugin extends TweenPlugin
   {
      
      public static const API:Number = 2;
      
      protected var _tween:TweenLite;
      
      public function RoundPropsPlugin()
      {
         super("roundProps",-1);
         _overwriteProps.length = 0;
      }
      
      override public function _onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         this._tween = param3;
         return true;
      }
      
      public function _onInitAllProps() : Boolean
      {
         var _loc1_:String = null;
         var _loc2_:PropTween = null;
         var _loc3_:PropTween = null;
         var _loc4_:Array = this._tween.vars.roundProps is Array ? this._tween.vars.roundProps : this._tween.vars.roundProps.split(",");
         var _loc5_:int = int(_loc4_.length);
         var _loc6_:Object = {};
         var _loc7_:PropTween = this._tween._propLookup.roundProps;
         while(--_loc5_ > -1)
         {
            _loc6_[_loc4_[_loc5_]] = 1;
         }
         _loc5_ = int(_loc4_.length);
         while(--_loc5_ > -1)
         {
            _loc1_ = _loc4_[_loc5_];
            _loc2_ = this._tween._firstPT;
            while(_loc2_)
            {
               _loc3_ = _loc2_._next;
               if(_loc2_.pg)
               {
                  _loc2_.t._roundProps(_loc6_,true);
               }
               else if(_loc2_.n == _loc1_)
               {
                  this._add(_loc2_.t,_loc1_,_loc2_.s,_loc2_.c);
                  if(_loc3_)
                  {
                     _loc3_._prev = _loc2_._prev;
                  }
                  if(_loc2_._prev)
                  {
                     _loc2_._prev._next = _loc3_;
                  }
                  else if(this._tween._firstPT == _loc2_)
                  {
                     this._tween._firstPT = _loc3_;
                  }
                  _loc2_._next = _loc2_._prev = null;
                  this._tween._propLookup[_loc1_] = _loc7_;
               }
               _loc2_ = _loc3_;
            }
         }
         return false;
      }
      
      public function _add(param1:Object, param2:String, param3:Number, param4:Number) : void
      {
         _addTween(param1,param2,param3,param3 + param4,param2,true);
         _overwriteProps[_overwriteProps.length] = param2;
      }
   }
}

