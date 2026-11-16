package com.visual_effects
{
   import flash.geom.*;
   import starling.display.*;
   
   public class Shake
   {
      
      private static var shake_array:Vector.<DisplayObject> = new Vector.<DisplayObject>();
      
      private static var origin_array:Vector.<Point> = new Vector.<Point>();
      
      private static var counter_array:Vector.<int> = new Vector.<int>();
      
      private static var duration_array:Vector.<uint> = new Vector.<uint>();
      
      private static var magnitude_array:Vector.<uint> = new Vector.<uint>();
      
      private static var complete_array:Vector.<Function> = new Vector.<Function>();
      
      private static var len:int = 0;
      
      private static var i:int = 0;
      
      public function Shake()
      {
         super();
      }
      
      public static function startShake(param1:DisplayObject, param2:uint = 11, param3:uint = 3, param4:Function = null) : void
      {
         if(shake_array.indexOf(param1) == -1)
         {
            shake_array.push(param1);
            origin_array.push(new Point(param1.x,param1.y));
            counter_array.push(0);
            duration_array.push(param2);
            magnitude_array.push(param3);
         }
         else
         {
            len = shake_array.length;
            i = 0;
            while(i < len)
            {
               if(shake_array[i] == param1)
               {
                  counter_array[i] = 0;
                  duration_array[i] = param2;
                  magnitude_array[i] = param3;
                  shake_array[i].x = origin_array[i].x;
                  shake_array[i].y = origin_array[i].y;
                  break;
               }
               ++i;
            }
         }
      }
      
      public static function shakeAll() : void
      {
         len = shake_array.length;
         i = len - 1;
         while(i >= 0)
         {
            ++counter_array[i];
            shake_array[i].x += int(counter_array[i] % 2 == 0 ? magnitude_array[i] : -magnitude_array[i]);
            shake_array[i].y += int(counter_array[i] % 2 == 0 ? magnitude_array[i] : -magnitude_array[i]);
            if(counter_array[i] > duration_array[i])
            {
               counter_array.removeAt(i);
               shake_array.removeAt(i);
               origin_array.removeAt(i);
               duration_array.removeAt(i);
               magnitude_array.removeAt(i);
            }
            --i;
         }
      }
      
      public static function isShaking(param1:DisplayObject) : Boolean
      {
         var _loc2_:Object = null;
         for each(_loc2_ in shake_array)
         {
            if(_loc2_ == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function getMagnitude(param1:DisplayObject) : uint
      {
         var _loc2_:int = int(shake_array.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(shake_array[_loc3_] == param1)
            {
               return magnitude_array[_loc3_];
            }
            _loc3_++;
         }
         return 0;
      }
   }
}

