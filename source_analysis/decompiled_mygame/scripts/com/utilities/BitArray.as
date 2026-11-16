package com.utilities
{
   import flash.utils.*;
   
   public class BitArray
   {
      
      private var byte_array:ByteArray = new ByteArray();
      
      private var __length:uint = 0;
      
      private var byte_i:int;
      
      private var byteBit_i:int;
      
      private var bit:int;
      
      public function BitArray(param1:uint = 0)
      {
         super();
         if(param1 > 0)
         {
            this.byte_array.length = Math.ceil(param1 / 8);
            this.__length = param1;
         }
      }
      
      public function setBit(param1:uint, param2:Boolean) : void
      {
         this.byte_i = param1 / 8;
         this.byteBit_i = 7 - (param1 - this.byte_i * 8);
         if(param2 == true)
         {
            this.byte_array[this.byte_i] |= 1 << this.byteBit_i;
         }
         else
         {
            this.byte_array[this.byte_i] &= ~(1 << this.byteBit_i);
         }
      }
      
      public function getBit(param1:uint) : Boolean
      {
         this.byte_i = param1 / 8;
         this.byteBit_i = 7 - (param1 - this.byte_i * 8);
         this.bit = this.byte_array[this.byte_i] & 1 << this.byteBit_i;
         return Boolean(this.bit);
      }
      
      public function setAll(param1:Boolean) : void
      {
         var _loc2_:int = param1 ? 255 : 0;
         var _loc3_:int = int(this.__length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            this.byte_array[_loc4_] = _loc2_;
            _loc4_++;
         }
      }
      
      public function clear() : void
      {
         this.byte_array.clear();
      }
      
      public function set length(param1:uint) : void
      {
         this.byte_array.length = Math.ceil(param1 / 8);
         this.__length = param1;
      }
      
      public function get length() : uint
      {
         return this.__length;
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         var _loc2_:String = "";
         var _loc3_:int = int(this.__length);
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = "";
         var _loc7_:int = 0;
         while(_loc7_ < _loc3_)
         {
            _loc2_ = this.byte_array[_loc7_].toString(2);
            _loc5_ = 8 - _loc2_.length;
            _loc6_ = "";
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc6_ += "0";
               _loc4_++;
            }
            _loc2_ = _loc6_ + _loc2_;
            _loc1_ += _loc2_ + ", ";
            _loc7_++;
         }
         return _loc1_;
      }
   }
}

