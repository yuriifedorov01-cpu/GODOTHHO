package com.helpers
{
   import com.utilities.BitBitmapData;
   
   public final class TileDefRegistry
   {
      
      public static var theme:int = -1;
      
      private static var defs:Object = {};
      
      private static var count:int = 0;
      
      public function TileDefRegistry()
      {
         super();
      }
      
      public static function get size() : int
      {
         return count;
      }
      
      private static function key(param1:int, param2:Boolean) : int
      {
         return param1 + (param2 ? 1000 : 0);
      }
      
      public static function clear() : void
      {
         defs = {};
         count = 0;
         theme = -1;
      }
      
      public static function setPayload(param1:String) : void
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:Vector.<int> = null;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         var _loc11_:Array = null;
         clear();
         if(param1 == null || param1.length == 0)
         {
            return;
         }
         var _loc2_:Array = param1.split(";");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            if(_loc4_.length != 0)
            {
               _loc5_ = _loc4_.split("|");
               if(_loc5_.length >= 5)
               {
                  theme = int(_loc5_[0]);
                  _loc6_ = int(_loc5_[1]);
                  _loc7_ = (_loc5_.length > 7 ? int(_loc5_[7]) : 0) != 0;
                  _loc8_ = new Vector.<int>();
                  _loc9_ = String(_loc5_[4]).split(",");
                  _loc10_ = 0;
                  while(_loc10_ < _loc9_.length)
                  {
                     _loc11_ = String(_loc9_[_loc10_]).split(":");
                     if(_loc11_.length >= 3)
                     {
                        _loc8_.push(int(_loc11_[0]),int(_loc11_[1]),int(_loc11_[2]));
                     }
                     _loc10_++;
                  }
                  defs[key(_loc6_,_loc7_)] = {
                     "mode":String(_loc5_[2]),
                     "slope":int(_loc5_[3]),
                     "runs":_loc8_,
                     "base":(_loc5_.length > 5 ? int(_loc5_[5]) : -1),
                     "flip":(_loc5_.length > 6 ? int(_loc5_[6]) : 0)
                  };
                  ++count;
               }
            }
            _loc3_++;
         }
      }
      
      public static function has(param1:int, param2:Boolean = false) : Boolean
      {
         return defs[key(param1,param2)] !== undefined;
      }
      
      public static function get(param1:int, param2:Boolean = false) : Object
      {
         return defs[key(param1,param2)];
      }
      
      public static function slopeOf(param1:int, param2:Boolean = false) : Number
      {
         var _loc3_:Object = defs[key(param1,param2)];
         return _loc3_ == null ? 0 : Number(int(_loc3_.slope));
      }
      
      public static function aliasBase(param1:int, param2:Boolean = false) : int
      {
         var _loc3_:Object = defs[key(param1,param2)];
         return _loc3_ == null || _loc3_.base == undefined ? -1 : int(_loc3_.base);
      }
      
      public static function aliasFlip(param1:int, param2:Boolean = false) : Boolean
      {
         var _loc3_:Object = defs[key(param1,param2)];
         return _loc3_ != null && int(_loc3_.flip) != 0;
      }
      
      public static function applyMask(param1:BitBitmapData, param2:int, param3:int, param4:int, param5:Boolean = false) : void
      {
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc6_:Object = defs[key(param2,param5)];
         if(_loc6_ == null || param1 == null)
         {
            return;
         }
         var _loc7_:int = param3 * 165;
         var _loc8_:int = param4 * 165;
         param1.setPixels(_loc7_,_loc8_,165,165,false);
         var _loc9_:Vector.<int> = _loc6_.runs;
         var _loc10_:int = 0;
         while(_loc10_ < _loc9_.length)
         {
            _loc11_ = _loc9_[_loc10_];
            _loc12_ = _loc9_[_loc10_ + 1];
            _loc13_ = _loc9_[_loc10_ + 2];
            if(_loc13_ > _loc12_)
            {
               param1.setPixels(_loc7_ + _loc12_,_loc8_ + _loc11_,_loc13_ - _loc12_,1,true);
            }
            _loc10_ += 3;
         }
      }
   }
}

