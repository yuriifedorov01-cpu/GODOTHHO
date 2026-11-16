package com.game_objects.enemies
{
   import flash.geom.*;
   
   public class YellowHairyMonster extends Enemy
   {
      
      public function YellowHairyMonster()
      {
         super("yellow hairy monster",new Rectangle(-16,-37,33,43));
         __hasDash = true;
      }
   }
}

