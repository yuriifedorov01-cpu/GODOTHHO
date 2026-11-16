package com.game_objects.enemies
{
   import flash.geom.*;
   import flash.utils.*;
   
   public class Kreetus extends Enemy
   {
      
      public function Kreetus()
      {
         super("Kreetus",new Rectangle(-111,-314,211,354));
      }
      
      override public function onEnter(param1:Vector.<Enemy>, param2:int) : void
      {
         var _enemyArray:Vector.<Enemy> = param1;
         var _i:int = param2;
         super.onEnter(_enemyArray,_i);
         if(currentFrame == 24 && isPlaying)
         {
            pause();
            setTimeout(function():void
            {
               ++currentFrame;
               play();
            },2000);
         }
      }
   }
}

