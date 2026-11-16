package com.game_objects.enemies
{
   import com.AI.*;
   import flash.geom.*;
   import flash.ui.*;
   
   public class GreenBouncer extends Enemy
   {
      
      private var greenBouncerAI:GreenBouncerAI = new GreenBouncerAI(this);
      
      public function GreenBouncer()
      {
         super("green bouncer",new Rectangle(-16,-32,34,31),this.greenBouncerAI);
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

