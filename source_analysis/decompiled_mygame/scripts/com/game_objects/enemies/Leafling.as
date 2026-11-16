package com.game_objects.enemies
{
   import flash.geom.*;
   
   public class Leafling extends Enemy
   {
      
      public function Leafling()
      {
         super("leafling",new Rectangle(-29,-98,58,104));
         __hasDash = true;
      }
   }
}

