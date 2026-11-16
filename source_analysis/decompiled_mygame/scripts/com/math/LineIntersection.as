package com.math
{
   import flash.geom.*;
   
   public final class LineIntersection
   {
      
      public function LineIntersection()
      {
         super();
      }
      
      public static function lineIntersectsRect(param1:Point, param2:Point, param3:Rectangle) : Boolean
      {
         return Boolean(lineIntersectsLine(param1,param2,new Point(param3.x,param3.y),new Point(param3.x + param3.width,param3.y))) || Boolean(lineIntersectsLine(param1,param2,new Point(param3.x + param3.width,param3.y),new Point(param3.x + param3.width,param3.y + param3.height))) || Boolean(lineIntersectsLine(param1,param2,new Point(param3.x + param3.width,param3.y + param3.height),new Point(param3.x,param3.y + param3.height))) || Boolean(lineIntersectsLine(param1,param2,new Point(param3.x,param3.y + param3.height),new Point(param3.x,param3.y))) || param3.containsPoint(param1) && param3.containsPoint(param2);
      }
      
      private static function lineIntersectsLine(param1:Point, param2:Point, param3:Point, param4:Point) : Boolean
      {
         var _loc5_:Number = (param1.y - param3.y) * (param4.x - param3.x) - (param1.x - param3.x) * (param4.y - param3.y);
         var _loc6_:Number = (param2.x - param1.x) * (param4.y - param3.y) - (param2.y - param1.y) * (param4.x - param3.x);
         if(_loc6_ == 0)
         {
            return false;
         }
         var _loc7_:Number = _loc5_ / _loc6_;
         _loc5_ = (param1.y - param3.y) * (param2.x - param1.x) - (param1.x - param3.x) * (param2.y - param1.y);
         var _loc8_:Number = _loc5_ / _loc6_;
         if(_loc7_ < 0 || _loc7_ > 1 || _loc8_ < 0 || _loc8_ > 1)
         {
            return false;
         }
         return true;
      }
   }
}

