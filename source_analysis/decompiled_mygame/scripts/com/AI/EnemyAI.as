package com.AI
{
   import com.game_objects.Person;
   import com.game_objects.enemies.Enemy;
   import flash.ui.*;
   
   public class EnemyAI
   {
      
      protected var enemy:Enemy;
      
      public var moveCounter:int = 0;
      
      protected var __target:Person;
      
      public function EnemyAI(param1:Enemy)
      {
         super();
         this.enemy = param1;
      }
      
      public function handleAI() : void
      {
         this.basicMovement();
      }
      
      protected function basicMovement() : void
      {
         ++this.moveCounter;
         if(this.enemy.type != "bionic bird" && this.enemy.type != "titanium vulture")
         {
            if(this.moveCounter == this.enemy.dirChangeTime && this.enemy.type != "Carnelia" && this.enemy.type != "Kreetus")
            {
               if(this.enemy.moveDir == -1)
               {
                  this.enemy.keyRelease(Keyboard.LEFT);
                  this.enemy.keyPress(Keyboard.RIGHT);
               }
               else
               {
                  this.enemy.keyRelease(Keyboard.RIGHT);
                  this.enemy.keyPress(Keyboard.LEFT);
               }
            }
            else if(this.moveCounter == this.enemy.dirChangeTime * 2)
            {
               this.moveCounter = 0;
            }
            else if(this.enemy.type == "Carnelia")
            {
               this.enemy.keyPress(Keyboard.LEFT);
            }
            else if(this.enemy.type == "Kreetus")
            {
               this.enemy.keyPress(Keyboard.RIGHT);
            }
         }
      }
      
      public function set target(param1:Person) : void
      {
         this.__target = param1;
      }
   }
}

