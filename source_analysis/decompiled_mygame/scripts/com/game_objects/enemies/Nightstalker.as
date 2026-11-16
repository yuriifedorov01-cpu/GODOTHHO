package com.game_objects.enemies
{
   import flash.geom.*;
   
   public class Nightstalker extends Enemy
   {
      
      public function Nightstalker()
      {
         super("night stalker",new Rectangle(-35,-96,80,105));
         __hasDash = true;
      }
   }
}

