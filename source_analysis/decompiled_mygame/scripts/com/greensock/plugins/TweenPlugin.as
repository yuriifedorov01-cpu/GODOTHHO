package com.greensock.plugins
{
   import com.greensock.*;
   import com.greensock.core.*;
   
   public class TweenPlugin
   {
      
      public static const version:String = "12.1.5";
      
      public static const API:Number = 2;
      
      public var _propName:String;
      
      public var _overwriteProps:Array;
      
      public var _priority:int = 0;
      
      protected var _firstPT:PropTween;
      
      public function TweenPlugin(param1:String = "", param2:int = 0)
      {
         super();
         this._overwriteProps = param1.split(",");
         this._propName = this._overwriteProps[0];
         this._priority = param2 || 0;
      }
      
      private static function _onTweenEvent(param1:String, param2:TweenLite) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:PropTween = null;
         var _loc5_:PropTween = null;
         var _loc6_:PropTween = null;
         var _loc7_:PropTween = null;
         var _loc8_:PropTween = param2._firstPT;
         if(param1 == "_onInitAllProps")
         {
            while(_loc8_)
            {
               _loc7_ = _loc8_._next;
               _loc4_ = _loc5_;
               while(Boolean(_loc4_) && _loc4_.pr > _loc8_.pr)
               {
                  _loc4_ = _loc4_._next;
               }
               if(_loc8_._prev = _loc4_ ? _loc4_._prev : _loc6_)
               {
                  _loc8_._prev._next = _loc8_;
               }
               else
               {
                  _loc5_ = _loc8_;
               }
               if(_loc8_._next = _loc4_)
               {
                  _loc4_._prev = _loc8_;
               }
               else
               {
                  _loc6_ = _loc8_;
               }
               _loc8_ = _loc7_;
            }
            _loc8_ = param2._firstPT = _loc5_;
         }
         while(_loc8_)
         {
            if(_loc8_.pg)
            {
               if(param1 in _loc8_.t)
               {
                  if(_loc8_.t[param1]())
                  {
                     _loc3_ = true;
                  }
               }
            }
            _loc8_ = _loc8_._next;
         }
         return _loc3_;
      }
      
      public static function activate(param1:Array) : Boolean
      {
         TweenLite._onPluginEvent = TweenPlugin._onTweenEvent;
         var _loc2_:int = int(param1.length);
         while(--_loc2_ > -1)
         {
            if(param1[_loc2_].API == TweenPlugin.API)
            {
               TweenLite._plugins[new (param1[_loc2_] as Class)()._propName] = param1[_loc2_];
            }
         }
         return true;
      }
      
      public function _onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         return false;
      }
      
      protected function _addTween(param1:Object, param2:String, param3:Number, param4:*, param5:String = null, param6:Boolean = false) : PropTween
      {
         var _loc7_:Number = param4 == null ? 0 : (typeof param4 === "number" || param4.charAt(1) !== "=" ? Number(param4) - param3 : int(param4.charAt(0) + "1") * Number(param4.substr(2)));
         if(_loc7_ !== 0)
         {
            this._firstPT = new PropTween(param1,param2,param3,_loc7_,param5 || param2,false,this._firstPT);
            this._firstPT.r = param6;
            return this._firstPT;
         }
         return null;
      }
      
      public function setRatio(param1:Number) : void
      {
         var _loc2_:Number = Number(NaN);
         var _loc3_:PropTween = this._firstPT;
         while(_loc3_)
         {
            _loc2_ = _loc3_.c * param1 + _loc3_.s;
            if(_loc3_.r)
            {
               _loc2_ = _loc2_ + (_loc2_ > 0 ? 0.5 : -0.5) | 0;
            }
            if(_loc3_.f)
            {
               _loc3_.t[_loc3_.p](_loc2_);
            }
            else
            {
               _loc3_.t[_loc3_.p] = _loc2_;
            }
            _loc3_ = _loc3_._next;
         }
      }
      
      public function _roundProps(param1:Object, param2:Boolean = true) : void
      {
         var _loc3_:PropTween = this._firstPT;
         while(_loc3_)
         {
            if(this._propName in param1 || _loc3_.n != null && _loc3_.n.split(this._propName + "_").join("") in param1)
            {
               _loc3_.r = param2;
            }
            _loc3_ = _loc3_._next;
         }
      }
      
      public function _kill(param1:Object) : Boolean
      {
         var _loc2_:int = 0;
         if(this._propName in param1)
         {
            this._overwriteProps = [];
         }
         else
         {
            _loc2_ = int(this._overwriteProps.length);
            while(--_loc2_ > -1)
            {
               if(this._overwriteProps[_loc2_] in param1)
               {
                  this._overwriteProps.splice(_loc2_,1);
               }
            }
         }
         var _loc3_:PropTween = this._firstPT;
         while(_loc3_)
         {
            if(_loc3_.n in param1)
            {
               if(_loc3_._next)
               {
                  _loc3_._next._prev = _loc3_._prev;
               }
               if(_loc3_._prev)
               {
                  _loc3_._prev._next = _loc3_._next;
                  _loc3_._prev = null;
               }
               else if(this._firstPT == _loc3_)
               {
                  this._firstPT = _loc3_._next;
               }
            }
            _loc3_ = _loc3_._next;
         }
         return false;
      }
   }
}

