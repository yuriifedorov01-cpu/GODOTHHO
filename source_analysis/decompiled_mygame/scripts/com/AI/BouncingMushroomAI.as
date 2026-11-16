package com.AI
{
   import com.game_objects.enemies.Enemy;
   
   public class BouncingMushroomAI extends EnemyAI
   {
      
      public function BouncingMushroomAI(param1:Enemy)
      {
         super(param1);
      }
      
      override public function handleAI() : void
      {
         super.basicMovement();
      }
   }
}

