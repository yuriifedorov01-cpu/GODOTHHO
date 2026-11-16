package com.game_objects
{
   import com.utilities.*;
   import flash.geom.Rectangle;
   import starling.display.*;
   import starling.utils.*;
   
   public class MagicEffect extends Sprite
   {
      
      private const oval_array:Vector.<Image> = new Vector.<Image>();
      
      private const fadeSpeed_array:Vector.<Number> = new Vector.<Number>();
      
      private var i:int = new int(0);
      
      private var len:int = new int(0);
      
      public function MagicEffect(param1:Rectangle, param2:* = 4)
      {
         var _loc3_:Image = null;
         _loc3_ = null;
         super();
         this.i = 0;
         while(this.i < param2)
         {
            _loc3_ = new Image(Assets.items_textureAtlas.getTexture("magic oval"));
            _loc3_.x = Math.random() * param1.width;
            _loc3_.y = Math.random() * param1.height;
            _loc3_.pivotX = 12;
            _loc3_.pivotY = 5;
            _loc3_.rotation = deg2rad(Math.random() * 360);
            _loc3_.touchable = false;
            addChild(_loc3_);
            this.oval_array.push(_loc3_);
            this.fadeSpeed_array.push(0.018 + Math.random() / 15);
            ++this.i;
         }
         touchable = false;
      }
      
      public function onMagicEffect() : void
      {
         this.len = this.oval_array.length;
         this.i = this.len - 1;
         while(this.i >= 0)
         {
            this.oval_array[this.i].rotation += 13;
            this.oval_array[this.i].alpha -= this.fadeSpeed_array[this.i];
            if(this.oval_array[this.i].alpha <= 0)
            {
               this.oval_array[this.i].removeFromParent(true);
               this.oval_array.removeAt(this.i);
               this.fadeSpeed_array.removeAt(this.i);
            }
            --this.i;
         }
      }
   }
}

