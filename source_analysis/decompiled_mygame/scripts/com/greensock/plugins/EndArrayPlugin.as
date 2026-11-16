package com.greensock.plugins
{
   import com.greensock.TweenLite;
   
   public class EndArrayPlugin extends TweenPlugin
   {
      
      public static const API:Number = 2;
      
      protected var _a:Array;
      
      protected var _round:Boolean;
      
      protected var _info:Array = [];
      
      public function EndArrayPlugin()
      {
         super("endArray");
      }
      
      override public function _onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         if(!(param1 is Array) || !(param2 is Array))
         {
            return false;
         }
         this._init(param1 as Array,param2);
         return true;
      }
      
      public function _init(param1:Array, param2:Array) : void
      {
         var _loc5_:Number = NaN;
         this._a = param1;
         var _loc3_:int = int(param2.length);
         var _loc4_:* = 0;
         while(--_loc3_ > -1)
         {
            if(param1[_loc3_] != param2[_loc3_] && param1[_loc3_] != null)
            {
               this._info[_loc5_ = _loc4_++] = new ArrayTweenInfo(_loc3_,this._a[_loc3_],param2[_loc3_] - this._a[_loc3_]);
            }
         }
      }
      
      override public function _roundProps(param1:Object, param2:Boolean = true) : void
      {
         if("endArray" in param1)
         {
            this._round = param2;
         }
      }
      
      override public function setRatio(param1:Number) : void
      {
         var _loc2_:ArrayTweenInfo = null;
         var _loc3_:Number = Number(NaN);
         var _loc4_:int = int(this._info.length);
         if(this._round)
         {
            while(--_loc4_ > -1)
            {
               _loc2_ = this._info[_loc4_];
               this._a[_loc2_.i] = (_loc3_ = _loc2_.c * param1 + _loc2_.s) > 0 ? _loc3_ + 0.5 >> 0 : _loc3_ - 0.5 >> 0;
            }
         }
         else
         {
            while(--_loc4_ > -1)
            {
               _loc2_ = this._info[_loc4_];
               this._a[_loc2_.i] = _loc2_.c * param1 + _loc2_.s;
            }
         }
      }
   }
}

class ArrayTweenInfo
{
   
   public var i:uint;
   
   public var s:Number;
   
   public var c:Number;
   
   public function ArrayTweenInfo(param1:uint, param2:Number, param3:Number)
   {
      super();
      this.i = param1;
      this.s = param2;
      this.c = param3;
   }
}
