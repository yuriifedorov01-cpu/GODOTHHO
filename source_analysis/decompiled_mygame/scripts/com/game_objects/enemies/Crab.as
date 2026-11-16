package com.game_objects.enemies
{
   import flash.geom.*;
   
   public class Crab extends Enemy
   {
      
      public function Crab()
      {
         super("crab",new Rectangle(-26,-35,59,43));
         __hasDash = true;
      }
   }
}

