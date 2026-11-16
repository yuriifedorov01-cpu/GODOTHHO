package com.game_objects.power_up_effects
{
   import com.game_objects.Person;
   import com.utilities.*;
   import starling.display.*;
   import starling.textures.*;
   import starling.utils.*;
   
   public class AuraBall extends Sprite
   {
      
      private var ball:Image;
      
      private var person:Person;
      
      private var pulsateCounter:int = 0;
      
      private var lightBeam_array:Vector.<Image> = new Vector.<Image>();
      
      private var counter:int = 0;
      
      public function AuraBall(param1:Person)
      {
         super();
         this.person = param1;
         this.ball = new Image(Assets.powerUp_textureAtlas.getTexture("aura ball"));
         this.ball.pivotX = this.ball.width / 2;
         this.ball.pivotY = this.ball.height / 2;
         this.ball.scale = this.person.energyController.fullTotalScale;
         this.ball.alpha = 0.5;
         this.ball.touchable = false;
         this.ball.textureSmoothing = TextureSmoothing.NONE;
         addChild(this.ball);
      }
      
      public function onEnter() : void
      {
         var _loc1_:Image = null;
         _loc1_ = null;
         ++this.counter;
         x = this.person.x;
         y = this.person.y;
         ++this.pulsateCounter;
         this.ball.scale += this.pulsateCounter < 8 ? -0.02 : 0.02;
         this.pulsateCounter = this.pulsateCounter == 14 ? 0 : int(this.pulsateCounter);
         if(this.pulsateCounter == 0)
         {
            this.ball.scale = this.person.energyController.fullTotalScale;
         }
         var _loc2_:int = 90 - this.person.energyController.fullTotalScale * 80;
         if(this.counter % 70 == 0)
         {
            _loc1_ = new Image(Assets.powerUp_textureAtlas.getTexture("light beam"));
            _loc1_.pivotX = 47;
            _loc1_.pivotY = 310;
            _loc1_.scaleX = Math.random() * 0.3;
            _loc1_.scaleY = Math.random() * 0.3;
            _loc1_.rotation = deg2rad(Math.random() * 360);
            _loc1_.touchable = false;
            _loc1_.textureSmoothing = TextureSmoothing.NONE;
            addChildAt(_loc1_,0);
            this.lightBeam_array.push(_loc1_);
         }
         var _loc3_:int = int(this.lightBeam_array.length);
         var _loc4_:* = int(_loc3_ - 1);
         while(_loc4_ >= 0)
         {
            this.lightBeam_array[_loc4_].scaleX += this.person.energyController.fullTotalScale / 30;
            this.lightBeam_array[_loc4_].scaleY += this.person.energyController.fullTotalScale / 30;
            if(this.lightBeam_array[_loc4_].scaleX > 1 || this.lightBeam_array[_loc4_].scaleY > 1)
            {
               this.lightBeam_array[_loc4_].alpha -= 0.03;
               if(this.lightBeam_array[_loc4_].alpha <= 0)
               {
                  this.lightBeam_array[_loc4_].removeFromParent(true);
                  this.lightBeam_array.removeAt(_loc4_);
               }
            }
            _loc4_--;
         }
      }
   }
}

