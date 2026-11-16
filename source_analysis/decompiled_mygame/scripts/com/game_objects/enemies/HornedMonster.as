package com.game_objects.enemies
{
   import flash.geom.*;
   
   public class HornedMonster extends Enemy
   {
      
      public function HornedMonster()
      {
         super("horned monster",new Rectangle(-23,-57,40,64));
         __hasDash = true;
      }
   }
}

