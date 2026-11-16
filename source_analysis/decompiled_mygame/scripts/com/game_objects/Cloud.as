package com.game_objects
{
   import flash.display.MovieClip;
   import starling.display.DisplayObject;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1832")]
   public class Cloud extends MovieClip
   {
      
      public var counter:int = 0;
      
      public var targetObject:DisplayObject;
      
      public function Cloud()
      {
         super();
         cacheAsBitmap = true;
         mouseChildren = false;
         mouseEnabled = false;
         gotoAndStop(Math.ceil(Math.random() * 3));
      }
   }
}

