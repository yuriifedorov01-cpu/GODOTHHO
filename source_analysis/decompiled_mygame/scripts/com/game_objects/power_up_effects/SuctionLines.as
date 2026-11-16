package com.game_objects.power_up_effects
{
   import com.game_objects.Person;
   import com.math.*;
   import com.utilities.*;
   import starling.display.*;
   import starling.textures.*;
   import starling.utils.*;
   
   public class SuctionLines extends Sprite
   {
      
      private var person:Person;
      
      private var counter:int = 0;
      
      private const lines_array:Vector.<Image> = new Vector.<Image>();
      
      public function SuctionLines(param1:Person)
      {
         super();
         this.person = param1;
         x = this.person.x;
         y = this.person.y;
      }
      
      public function onEnter() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Image = null;
         _loc1_ = 0;
         _loc2_ = null;
         ++this.counter;
         x = this.person.x;
         y = this.person.y;
         var _loc3_:int = 14 - this.person.energyController.fullTotalScale * 11;
         if(this.counter % _loc3_ == 0)
         {
            _loc2_ = new Image(Assets.powerUp_textureAtlas.getTexture("ray of light"));
            _loc2_.x = (100 + this.person.energyController.fullTotalScale * 300) * Math.random() * RanOne.ranOne();
            _loc2_.y = (75 + this.person.energyController.fullTotalScale * 200) * Math.random() * RanOne.ranOne();
            _loc2_.scaleX = 0.8 + Math.random() * 0.6;
            _loc2_.scaleY = 0.8 + Math.random() * 0.6;
            _loc2_.pivotX = 2.5;
            _loc2_.rotation = deg2rad(RotateTo.rotTo(_loc2_.x,0,_loc2_.y,0) - 90);
            _loc2_.textureSmoothing = TextureSmoothing.NONE;
            _loc2_.touchable = false;
            addChild(_loc2_);
            this.lines_array.push(_loc2_);
         }
         var _loc4_:int = 7 + this.person.energyController.fullTotalScale * 7;
         var _loc5_:int = int(this.lines_array.length);
         _loc1_ = int(_loc5_ - 1);
         while(_loc1_ >= 0)
         {
            this.lines_array[_loc1_].x += MoveTo.getDirX(_loc4_,rad2deg(this.lines_array[_loc1_].rotation));
            this.lines_array[_loc1_].y += MoveTo.getDirY(_loc4_,rad2deg(this.lines_array[_loc1_].rotation));
            this.lines_array[_loc1_].scaleX -= 0.025;
            this.lines_array[_loc1_].scaleY -= 0.025;
            if(CalcDist.getDistNumbers(this.lines_array[_loc1_].x,this.lines_array[_loc1_].y,0,0) < _loc4_ + 2)
            {
               this.lines_array[_loc1_].removeFromParent(true);
               this.lines_array.removeAt(_loc1_);
            }
            _loc1_--;
         }
      }
   }
}

