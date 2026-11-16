package com.game_objects
{
   import com.math.*;
   import com.utilities.*;
   import starling.display.Image;
   
   public class Smoke extends Image
   {
      
      public var counter:int = 0;
      
      public var fadeSpeed:Number;
      
      public var scaleSpeed:Number;
      
      public var speedX:Number;
      
      public var riseSpeed:Number = 2.5;
      
      public function Smoke()
      {
         super(Assets.items_textureAtlas.getTexture("smoke"));
         this.fadeSpeed = (6 + Math.random() * 7) / 1000;
         this.scaleSpeed = (1 + Math.random() * 4) / 900;
         this.speedX = Math.random() / 1.6 * RanOne.ranOne();
         this.riseSpeed = 0.5 + Math.random() * 3.5;
         touchable = false;
      }
      
      public function onEnter(param1:Vector.<Smoke>, param2:int) : void
      {
         y -= 2;
         scaleX = scaleY = scaleY + this.scaleSpeed;
         alpha -= this.fadeSpeed;
         x += this.speedX;
         if(alpha <= 0)
         {
            param1.removeAt(param2);
            removeFromParent(true);
            return;
         }
      }
   }
}

