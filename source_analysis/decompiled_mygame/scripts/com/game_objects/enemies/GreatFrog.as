package com.game_objects.enemies
{
   import flash.geom.*;
   
   public class GreatFrog extends Enemy
   {
      
      public function GreatFrog()
      {
         super("great frog",new Rectangle(-32,-83,75,101));
         __hasDash = true;
      }
   }
}

