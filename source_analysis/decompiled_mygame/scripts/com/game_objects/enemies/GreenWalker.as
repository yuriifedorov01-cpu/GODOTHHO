package com.game_objects.enemies
{
   import flash.geom.*;
   
   public class GreenWalker extends Enemy
   {
      
      public function GreenWalker()
      {
         super("green walker",new Rectangle(-22,-34,51,42));
         __hasDash = true;
      }
   }
}

