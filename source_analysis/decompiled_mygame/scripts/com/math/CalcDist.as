package com.math
{
   import starling.display.DisplayObject;
   
   public class CalcDist
   {
      
      private static var disX:Number = 0;
      
      private static var disY:Number = 0;
      
      private static var disTotal:Number = 0;
      
      public function CalcDist()
      {
         super();
      }
      
      public static function getDist(param1:DisplayObject, param2:DisplayObject) : Number
      {
         disX = param2.x - param1.x;
         disY = param2.y - param1.y;
         disTotal = Math.sqrt(disX * disX + disY * disY);
         return disTotal;
      }
      
      public static function getDistNumbers(param1:int, param2:int, param3:int, param4:int) : Number
      {
         disX = param3 - param1;
         disY = param4 - param2;
         disTotal = Math.sqrt(disX * disX + disY * disY);
         return disTotal;
      }
      
      public static function getDistX(param1:int, param2:int) : Number
      {
         disX = param1 - param2;
         return disX;
      }
      
      public static function getDistY(param1:int, param2:int) : Number
      {
         disY = param2 - param1;
         return disY;
      }
   }
}

