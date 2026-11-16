package com.game_objects.enemies
{
   import flash.geom.*;
   
   public class PumpkinCreeper extends Enemy
   {
      
      public function PumpkinCreeper()
      {
         super("pumpkin creeper",new Rectangle(-31,-53,67,59));
         __hasDash = true;
      }
   }
}

