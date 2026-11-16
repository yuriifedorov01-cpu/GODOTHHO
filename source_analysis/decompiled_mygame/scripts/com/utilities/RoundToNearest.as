package com.utilities
{
   public class RoundToNearest
   {
      
      private static var temp_num:Number;
      
      public function RoundToNearest()
      {
         super();
      }
      
      public static function roundTo(param1:Number, param2:int) : Number
      {
         temp_num = new Number(param1);
         temp_num *= param2;
         temp_num = Math.round(temp_num);
         temp_num /= param2;
         return temp_num;
      }
   }
}

