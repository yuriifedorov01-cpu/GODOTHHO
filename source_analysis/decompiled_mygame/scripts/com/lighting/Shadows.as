package com.lighting
{
   import com.gravityPackage.GravityObject;
   import com.math.*;
   import com.utilities.*;
   import starling.display.*;
   import starling.extensions.lighting.LightSource;
   import starling.utils.*;
   
   public class Shadows extends Sprite
   {
      
      public static const shadows_array:Vector.<Shadows> = new Vector.<Shadows>();
      
      private var caster:DisplayObject;
      
      private var gravityObject:GravityObject;
      
      private var originalHeight:uint = 0;
      
      public var forceHidden:Boolean = false;
      
      public function Shadows(param1:DisplayObject, param2:GravityObject)
      {
         super();
         this.caster = param1;
         this.gravityObject = param2;
         SortDepths.addAt(this,SortDepths.REGION_4);
         shadows_array.push(this);
      }
      
      public function onEnter(param1:int) : void
      {
         var _loc2_:LightSource = null;
         var _loc3_:int = 0;
         var _loc4_:* = 0;
         var _loc5_:Image = null;
         var _loc6_:Boolean = false;
         var _loc7_:Image = null;
         var _loc8_:Number = Number(NaN);
         var _loc9_:int = 0;
         var _loc10_:Number = Number(NaN);
         var _loc11_:Number = Number(NaN);
         var _loc12_:uint = 0;
         x = this.gravityObject.hit_rect.x;
         y = this.gravityObject.hit_rect.y + this.gravityObject.hit_rect.height;
         visible = Boolean(this.gravityObject.onGround) && this.forceHidden == false;
         for each(_loc2_ in Lighting.lightSources_array)
         {
            if(getChildByName(_loc2_.name + "_shadow") == null)
            {
               _loc5_ = new Image(Assets.treesFish_textureAtlas.getTexture("black pixel"));
               _loc5_.width = this.gravityObject.hit_rect.width;
               _loc5_.height = this.gravityObject.hit_rect.height / 20;
               _loc5_.pivotX = _loc5_.width / 2;
               _loc5_.name = _loc2_.name + "_shadow";
               addChild(_loc5_);
               this.originalHeight = _loc5_.height;
            }
         }
         _loc3_ = numChildren - 1;
         _loc4_ = _loc3_;
         while(_loc4_ >= 0)
         {
            _loc6_ = false;
            for each(_loc2_ in Lighting.lightSources_array)
            {
               if(getChildAt(_loc4_).name == _loc2_.name + "_shadow")
               {
                  _loc6_ = true;
               }
            }
            if(_loc6_ == false)
            {
               removeChildAt(_loc4_,true);
            }
            _loc4_--;
         }
         for each(_loc2_ in Lighting.lightSources_array)
         {
            _loc7_ = Image(getChildByName(_loc2_.name + "_shadow"));
            _loc7_.skewX = deg2rad(RotateTo.rotTo(x,_loc2_.x,y,_loc2_.y) - 90);
            _loc8_ = Number(rad2deg(_loc7_.skewX));
            _loc9_ = int(CalcDist.getDistNumbers(_loc2_.x,_loc2_.y,x,y));
            _loc10_ = _loc9_ / 50;
            _loc7_.scaleY = this.originalHeight / _loc10_;
            _loc7_.alpha = 0.85 - _loc9_ / (_loc2_.brightness * Math.abs(_loc2_.z) * 35) - Lighting.ambientLight.brightness / 3;
            if(_loc8_ <= -90 || _loc8_ >= 90)
            {
               if(_loc8_ > 0)
               {
                  _loc11_ = Math.abs(_loc8_ - 180);
               }
               else
               {
                  _loc11_ = Math.abs(_loc8_ + 180);
               }
            }
            else
            {
               _loc11_ = Math.abs(_loc8_);
            }
            _loc12_ = (1 - _loc11_ / 90) * _loc7_.height;
            if(_loc12_ > 17)
            {
               _loc7_.height *= 23 / _loc12_;
            }
         }
         if(this.caster.parent == null)
         {
            removeFromParent(true);
         }
      }
   }
}

