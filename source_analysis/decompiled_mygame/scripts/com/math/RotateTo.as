package com.math
{
   public class RotateTo
   {
      
      private static var rotX:Number;
      
      private static var rotY:Number;
      
      private static var rotSum:Number;
      
      private static var rotResult:Number;
      
      public function RotateTo()
      {
         super();
      }
      
      public static function rotTo(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         rotX = param1 - param2;
         rotY = param3 - param4;
         rotSum = Math.atan2(rotY,rotX);
         rotResult = rotSum * 180 / Math.PI;
         return rotResult;
      }
   }
}

