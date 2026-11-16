package com.AI
{
   import com.game_objects.enemies.Enemy;
   import flash.ui.*;
   
   public class BionicBirdAI extends EnemyAI
   {
      
      public function BionicBirdAI(param1:Enemy)
      {
         super(param1);
      }
      
      override public function handleAI() : void
      {
         if(__target != null)
         {
            if(__target.x < enemy.x)
            {
               enemy.keyRelease(Keyboard.RIGHT);
               enemy.keyPress(Keyboard.LEFT);
            }
            else
            {
               enemy.keyRelease(Keyboard.LEFT);
               enemy.keyPress(Keyboard.RIGHT);
            }
            if(moveCounter % 30 == 0)
            {
               if(__target.y < enemy.y)
               {
                  enemy.keyRelease(Keyboard.DOWN);
                  enemy.keyPress(Keyboard.UP);
               }
               else
               {
                  enemy.keyRelease(Keyboard.UP);
                  enemy.keyPress(Keyboard.DOWN);
               }
            }
         }
      }
   }
}

