package com.game_objects.enemies
{
   import com.AI.*;
   import flash.geom.*;
   import flash.ui.*;
   
   public class PurpleGoo extends Enemy
   {
      
      private var purpleGooAI:PurpleGooAI = new PurpleGooAI(this);
      
      public function PurpleGoo()
      {
         super("purple goo",new Rectangle(-14,-24,31,33),this.purpleGooAI);
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

