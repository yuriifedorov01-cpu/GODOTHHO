package com.game_objects.enemies
{
   import flash.geom.*;
   
   public class OrangeCrazy extends Enemy
   {
      
      public function OrangeCrazy()
      {
         super("orange crazy",new Rectangle(-22,-50,50,60));
         __hasDash = true;
      }
   }
}

