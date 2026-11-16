package com.greensock.plugins
{
   import com.greensock.TweenLite;
   
   public class HexColorsPlugin extends TweenPlugin
   {
      
      public static const API:Number = 2;
      
      protected var _colors:Array;
      
      public function HexColorsPlugin()
      {
         super("hexColors");
         _overwriteProps = [];
         this._colors = [];
      }
      
      override public function _onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         var _loc4_:String = null;
         for(_loc4_ in param2)
         {
            this._initColor(param1,_loc4_,uint(param2[_loc4_]));
         }
         return true;
      }
      
      public function _initColor(param1:Object, param2:String, param3:uint) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Boolean = typeof param1[param2] == "function";
         var _loc8_:uint = !_loc7_ ? uint(param1[param2]) : uint(param1[Boolean(param2.indexOf("set")) || !("get" + param2.substr(3) in param1) ? param2 : "get" + param2.substr(3)]());
         if(_loc8_ != param3)
         {
            _loc4_ = uint(_loc8_ >> 16);
            _loc5_ = uint(_loc8_ >> 8 & 0xFF);
            _loc6_ = uint(_loc8_ & 0xFF);
            this._colors[this._colors.length] = new ColorProp(param1,param2,_loc7_,_loc4_,(param3 >> 16) - _loc4_,_loc5_,(param3 >> 8 & 0xFF) - _loc5_,_loc6_,(param3 & 0xFF) - _loc6_);
            _overwriteProps[_overwriteProps.length] = param2;
         }
      }
      
      override public function _kill(param1:Object) : Boolean
      {
         var _loc2_:* = int(this._colors.length);
         while(_loc2_--)
         {
            if(param1[this._colors[_loc2_].p] != null)
            {
               this._colors.splice(_loc2_,1);
            }
         }
         return super._kill(param1);
      }
      
      override public function setRatio(param1:Number) : void
      {
         var _loc2_:ColorProp = null;
         var _loc3_:Number = Number(NaN);
         var _loc4_:int = int(this._colors.length);
         while(--_loc4_ > -1)
         {
            _loc2_ = this._colors[_loc4_];
            _loc3_ = _loc2_.rs + param1 * _loc2_.rc << 16 | _loc2_.gs + param1 * _loc2_.gc << 8 | _loc2_.bs + param1 * _loc2_.bc;
            if(_loc2_.f)
            {
               _loc2_.t[_loc2_.p](_loc3_);
            }
            else
            {
               _loc2_.t[_loc2_.p] = _loc3_;
            }
         }
      }
   }
}

class ColorProp
{
   
   public var t:Object;
   
   public var p:String;
   
   public var f:Boolean;
   
   public var rs:int;
   
   public var rc:int;
   
   public var gs:int;
   
   public var gc:int;
   
   public var bs:int;
   
   public var bc:int;
   
   public function ColorProp(param1:Object, param2:String, param3:Boolean, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int)
   {
      super();
      this.t = param1;
      this.p = param2;
      this.f = param3;
      this.rs = param4;
      this.rc = param5;
      this.gs = param6;
      this.gc = param7;
      this.bs = param8;
      this.bc = param9;
   }
}
