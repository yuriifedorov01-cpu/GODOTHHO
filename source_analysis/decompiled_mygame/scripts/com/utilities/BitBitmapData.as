package com.utilities
{
   public class BitBitmapData
   {
      
      private var pixels:BitArray;
      
      private var __width:uint = 0;
      
      private var __height:uint = 0;
      
      public function BitBitmapData(param1:uint, param2:uint, param3:Boolean = false)
      {
         super();
         this.__width = param1;
         this.__height = param2;
         this.pixels = new BitArray(uint(this.__width * this.__height));
         if(param3 == true)
         {
            this.pixels.setAll(true);
         }
      }
      
      public function getPixel(param1:uint, param2:uint) : Boolean
      {
         if(param1 < this.__width && param2 < this.__height)
         {
            return this.pixels.getBit(uint(param2 * this.__width + param1));
         }
         return false;
      }
      
      public function setPixel(param1:uint, param2:uint, param3:Boolean) : void
      {
         if(param2 < this.__height && param1 < this.__width)
         {
            this.pixels.setBit(uint(param2 * this.__width + param1),param3);
         }
      }
      
      public function setPixels(param1:uint, param2:uint, param3:uint, param4:uint, param5:Boolean) : void
      {
         var _loc6_:uint = 0;
         var _loc7_:uint = param2;
         while(_loc7_ < param4 + param2)
         {
            _loc6_ = param1;
            while(_loc6_ < param3 + param1)
            {
               this.pixels.setBit(uint(_loc7_ * this.__width + _loc6_),param5);
               _loc6_++;
            }
            _loc7_++;
         }
      }
      
      public function drawBitmap(param1:BitBitmapData, param2:uint, param3:uint) : *
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = param3;
         while(_loc7_ < param1.height + param3)
         {
            _loc4_ = param2;
            while(_loc4_ < param1.width + param2)
            {
               this.pixels.setBit(uint(_loc7_ * this.__width + _loc4_),param1.getPixel(_loc5_,_loc6_));
               _loc5_++;
               _loc4_++;
            }
            _loc6_++;
            _loc5_ = 0;
            _loc7_++;
         }
      }
      
      public function flipHorizontally() : void
      {
         var _loc1_:int = 0;
         var _loc2_:BitArray = new BitArray(uint(this.__width * this.__height));
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < this.__height)
         {
            _loc1_ = 0;
            while(_loc1_ < this.__width)
            {
               _loc3_ = int(uint(this.__width - _loc1_ - 1));
               _loc4_ = _loc5_;
               _loc2_.setBit(uint(_loc4_ * this.__width + _loc3_),this.pixels.getBit(uint(_loc5_ * this.__width + _loc1_)));
               _loc1_++;
            }
            _loc5_++;
         }
         this.pixels = _loc2_;
      }
      
      public function clearAll() : void
      {
         this.pixels.clear();
      }
      
      public function get width() : uint
      {
         return this.__width;
      }
      
      public function get height() : uint
      {
         return this.__height;
      }
   }
}

