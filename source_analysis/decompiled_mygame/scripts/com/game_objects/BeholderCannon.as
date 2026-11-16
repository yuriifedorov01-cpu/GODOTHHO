package com.game_objects
{
   [Embed(source="/_assets/assets.swf", symbol="symbol1837")]
   public class BeholderCannon extends ShootingObject
   {
      
      public function BeholderCannon()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

