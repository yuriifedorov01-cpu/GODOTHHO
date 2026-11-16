package com.math
{
   public class RanOne
   {
      
      public function RanOne()
      {
         super();
      }
      
      public static function ranOne() : int
      {
         return Math.random() > 0.5 ? 1 : -1;
      }
   }
}

