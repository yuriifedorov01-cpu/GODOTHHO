package com.gravityPackage
{
   import com.math.*;
   import com.utilities.*;
   import flash.geom.*;
   import starling.display.*;
   import starling.textures.*;
   import starling.utils.*;
   
   public class WindSource extends Sprite
   {
      
      public static const wind_array:Vector.<WindSource> = new Vector.<WindSource>();
      
      private const image_array:Vector.<Image> = new Vector.<Image>();
      
      private const counter_array:Vector.<int> = new Vector.<int>();
      
      public var power:int = 0;
      
      private var counter:int = 0;
      
      public function WindSource(param1:int, param2:int)
      {
         super();
         this.power = param1;
         wind_array.push(this);
         this.counter = Math.random() * 100;
         rotation = deg2rad(param2);
      }
      
      public function applyWind(param1:GravityObject) : void
      {
         var _loc2_:int = rad2deg(rotation) + 90;
         var _loc3_:Point = new Point(x,y);
         var _loc4_:Point = new Point(x + MoveTo.getDirX(this.power,_loc2_),y + MoveTo.getDirY(this.power,_loc2_));
         if(LineIntersection.lineIntersectsRect(_loc3_,_loc4_,param1.hit_rect))
         {
            param1.velX += param1.getWeightEffectVel(MoveTo.getDirX(this.power - CalcDist.getDistX(param1.hit_rect.x,x),_loc2_) / 200);
            param1.velY += param1.getWeightEffectVel(MoveTo.getDirY(this.power - CalcDist.getDistY(param1.hit_rect.y,y),_loc2_) / 200);
         }
      }
      
      public function onEnter(param1:int) : void
      {
         var _loc2_:* = undefined;
         _loc2_ = 0;
         var _loc3_:Image = null;
         ++this.counter;
         var _loc4_:int = int(this.image_array.length);
         _loc2_ = int(_loc4_ - 1);
         while(_loc2_ >= 0)
         {
            this.image_array[_loc2_].x += this.counter_array[_loc2_];
            this.image_array[_loc2_].width -= 0.5;
            this.image_array[_loc2_].alpha -= this.image_array[_loc2_].width / 4000;
            --this.counter_array[_loc2_];
            if(this.power > 0 && this.counter_array[_loc2_] <= 0 || this.power < 0 && this.counter_array[_loc2_] >= 0)
            {
               this.image_array[_loc2_].removeFromParent(true);
               this.counter_array.removeAt(_loc2_);
               this.image_array.removeAt(_loc2_);
            }
            _loc2_--;
         }
         if(this.counter % 15 == 0)
         {
            _loc3_ = new Image(Assets.treesFish_textureAtlas.getTexture("white pixel"));
            _loc3_.width = Math.abs(this.power) / 5 + Math.random() * (Math.abs(this.power) / 5);
            _loc3_.pivotX = this.power < 0 ? 1 : 0;
            _loc3_.y = Math.random() * 25 * RanOne.ranOne();
            _loc3_.height = 2;
            _loc3_.alpha = Math.abs(this.power) / 850 - 0.1;
            _loc3_.textureSmoothing = TextureSmoothing.NONE;
            _loc3_.touchable = false;
            addChild(_loc3_);
            this.image_array.push(_loc3_);
            this.counter_array.push(this.power / 10);
         }
      }
   }
}

