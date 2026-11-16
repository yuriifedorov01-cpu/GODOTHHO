package com.game_objects.enemies
{
   import flash.geom.*;
   
   public class Fishurn extends Enemy
   {
      
      public function Fishurn()
      {
         super("fishurn",new Rectangle(-21,-58,47,65));
         __hasDash = true;
      }
   }
}

