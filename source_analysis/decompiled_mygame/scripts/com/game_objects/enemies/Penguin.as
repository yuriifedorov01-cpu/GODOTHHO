package com.game_objects.enemies
{
   import flash.geom.*;
   
   public class Penguin extends Enemy
   {
      
      public function Penguin()
      {
         super("penguin",new Rectangle(-22,-75,45,81));
         __hasDash = true;
      }
   }
}

