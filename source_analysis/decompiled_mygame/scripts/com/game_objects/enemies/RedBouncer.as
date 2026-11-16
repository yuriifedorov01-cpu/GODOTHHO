package com.game_objects.enemies
{
   import com.AI.*;
   import flash.geom.*;
   import flash.ui.*;
   
   public class RedBouncer extends Enemy
   {
      
      private var redBouncerAI:RedBouncerAI = new RedBouncerAI(this);
      
      public function RedBouncer()
      {
         super("red bouncer",new Rectangle(-16,-20,38,29),this.redBouncerAI);
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

