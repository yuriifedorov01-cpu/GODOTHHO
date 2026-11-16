package com.math
{
   public class MoveTo
   {
      
      public function MoveTo()
      {
         super();
      }
      
      public static function getDirX(param1:Number, param2:Number) : Number
      {
         return param1 * Math.sin(Math.PI / 180 * param2);
      }
      
      public static function getDirY(param1:Number, param2:Number) : Number
      {
         return -param1 * Math.cos(Math.PI / 180 * param2);
      }
   }
}

