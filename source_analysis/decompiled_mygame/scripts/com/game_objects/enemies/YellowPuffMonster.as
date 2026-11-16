package com.game_objects.enemies
{
   import flash.geom.*;
   
   public class YellowPuffMonster extends Enemy
   {
      
      public function YellowPuffMonster()
      {
         super("yellow puff monster",new Rectangle(-26,-81,62,89));
         __hasDash = true;
      }
   }
}

