package com.AI
{
   import com.game_objects.enemies.Enemy;
   
   public class PurpleGooAI extends EnemyAI
   {
      
      public function PurpleGooAI(param1:Enemy)
      {
         super(param1);
      }
      
      override public function handleAI() : void
      {
         super.basicMovement();
      }
   }
}

