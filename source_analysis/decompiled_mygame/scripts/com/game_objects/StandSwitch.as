package com.game_objects
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1816")]
   public dynamic class StandSwitch extends MovieClip
   {
      
      public function StandSwitch()
      {
         super();
         addFrameScript(4,this.frame5);
      }
      
      internal function frame5() : *
      {
         stop();
      }
   }
}

