package com.game_objects
{
   [Embed(source="/_assets/assets.swf", symbol="symbol1827")]
   public class BushShooter extends ShootingObject
   {
      
      public function BushShooter()
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

