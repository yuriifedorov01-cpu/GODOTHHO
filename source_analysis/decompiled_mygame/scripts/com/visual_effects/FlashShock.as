package com.visual_effects
{
   import flash.display.*;
   import flash.events.*;
   import starling.display.*;
   import starling.filters.*;
   
   public class FlashShock
   {
      
      private static var shock_array:Vector.<starling.display.DisplayObject> = new Vector.<DisplayObject>();
      
      private static var counter_array:Vector.<int> = new Vector.<int>();
      
      private static var i:int = new int(0);
      
      private static var len:int = new int(0);
      
      private static var white_filter:ColorMatrixFilter = new ColorMatrixFilter();
      
      private static var dumby_movieclip:flash.display.MovieClip = new MovieClip();
      
      white_filter.tint(16777215,5);
      
      public function FlashShock()
      {
         super();
      }
      
      public static function flashShockObject(param1:starling.display.DisplayObject) : void
      {
         shock_array.push(param1);
         counter_array.push(0);
         if(dumby_movieclip.hasEventListener(Event.ENTER_FRAME) == false)
         {
            dumby_movieclip.addEventListener(Event.ENTER_FRAME,onEnter);
         }
      }
      
      private static function onEnter(param1:Event) : void
      {
         var _loc2_:FilterChain = null;
         len = shock_array.length;
         i = len - 1;
         while(i >= 0)
         {
            ++counter_array[i];
            if(counter_array[i] % 2 == 0 && Math.random() > 0.5)
            {
               _loc2_ = new FilterChain(white_filter);
               shock_array[i].filter = _loc2_;
            }
            else
            {
               shock_array[i].filter = null;
            }
            if(counter_array[i] > 35)
            {
               shock_array[i].filter = null;
               counter_array.removeAt(i);
               shock_array.removeAt(i);
               if(counter_array.length == 0)
               {
                  dumby_movieclip.removeEventListener(Event.ENTER_FRAME,onEnter);
               }
            }
            --i;
         }
      }
   }
}

