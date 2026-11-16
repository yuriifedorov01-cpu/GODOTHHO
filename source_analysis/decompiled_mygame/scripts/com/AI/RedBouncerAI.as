package com.AI
{
   import com.game_objects.enemies.Enemy;
   
   public class RedBouncerAI extends EnemyAI
   {
      
      public function RedBouncerAI(param1:Enemy)
      {
         super(param1);
      }
      
      override public function handleAI() : void
      {
         super.basicMovement();
      }
   }
}

