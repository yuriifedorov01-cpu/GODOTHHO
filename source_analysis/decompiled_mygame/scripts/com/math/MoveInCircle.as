package com.math
{
   import starling.display.DisplayObject;
   
   public class MoveInCircle
   {
      
      public function MoveInCircle()
      {
         super();
      }
      
      public static function moveAround(param1:DisplayObject, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : Number
      {
         param1.x = param5 + Math.cos(param7) * param2;
         param1.y = param6 + Math.sin(param7) * param3;
         return param7 + param4;
      }
   }
}

