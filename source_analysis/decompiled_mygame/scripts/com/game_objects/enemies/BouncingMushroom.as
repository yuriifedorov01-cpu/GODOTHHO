package com.game_objects.enemies
{
   import com.AI.*;
   import flash.geom.*;
   import flash.ui.*;
   
   public class BouncingMushroom extends Enemy
   {
      
      private var bouncingMushroomAI:BouncingMushroomAI = new BouncingMushroomAI(this);
      
      public function BouncingMushroom()
      {
         super("bouncing mushroom",new Rectangle(-29,-100,52,111),this.bouncingMushroomAI);
      }
      
      override public function onEnter(param1:Vector.<Enemy>, param2:int) : void
      {
         super.onEnter(param1,param2);
         if(gravityObject.velX != 0)
         {
            keyPress(Keyboard.UP);
            keyRelease(Keyboard.UP);
         }
         gravityObject.velX *= 0.95;
      }
   }
}

