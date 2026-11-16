package com.AI
{
   import com.game_objects.enemies.Enemy;
   import flash.ui.*;
   
   public class MushroomBallAI extends EnemyAI
   {
      
      public function MushroomBallAI(param1:Enemy)
      {
         super(param1);
      }
      
      override public function handleAI() : void
      {
         super.basicMovement();
         if(moveCounter % 180 == 0)
         {
            enemy.keyPress(Keyboard.UP);
            enemy.keyRelease(Keyboard.UP);
         }
      }
   }
}

