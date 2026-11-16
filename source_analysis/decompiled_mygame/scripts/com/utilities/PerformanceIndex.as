package com.utilities
{
   import flash.display.*;
   import flash.utils.*;
   import starling.textures.*;
   
   public final class PerformanceIndex
   {
      
      public function PerformanceIndex()
      {
         super();
      }
      
      public static function getCPU() : uint
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = uint(getTimer());
         var _loc5_:int = int(getTimer());
         var _loc6_:int = 0;
         while(_loc6_ < 250000)
         {
            _loc1_ = Math.random() * 1000;
            _loc2_ = Math.random() * 1000;
            _loc3_ = Math.sqrt(_loc1_ * _loc1_ + _loc2_ * _loc2_);
            _loc6_++;
         }
         return getTimer() - _loc4_;
      }
      
      public static function getGPU() : uint
      {
         var _loc1_:BitmapData = new BitmapData(512,512,false,0);
         var _loc2_:uint = uint(getTimer());
         var _loc3_:Texture = Texture.fromBitmapData(_loc1_);
         var _loc4_:uint = getTimer() - _loc2_;
         _loc3_.dispose();
         return _loc4_;
      }
      
      public static function getPerformance() : uint
      {
         return getCPU() + getGPU();
      }
   }
}

