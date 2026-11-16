package com.AI
{
   import com.game_objects.enemies.Enemy;
   
   public class GreenBouncerAI extends EnemyAI
   {
      
      public function GreenBouncerAI(param1:Enemy)
      {
         super(param1);
      }
      
      override public function handleAI() : void
      {
         super.basicMovement();
      }
   }
}

