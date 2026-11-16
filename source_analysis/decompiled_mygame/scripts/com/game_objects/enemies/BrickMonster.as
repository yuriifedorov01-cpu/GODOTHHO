package com.game_objects.enemies
{
   import flash.geom.*;
   
   public class BrickMonster extends Enemy
   {
      
      public function BrickMonster()
      {
         super("brick monster",new Rectangle(-68,-161,114,162));
         __hasDash = true;
      }
   }
}

