package com.game_objects
{
   import com.game_objects.hit_detect.*;
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.helpers.*;
   import com.math.*;
   import com.sound.*;
   import com.utilities.*;
   import com.visual_effects.*;
   import flash.geom.*;
   import flash.utils.*;
   import starling.*;
   import starling.display.*;
   import starling.extensions.lighting.*;
   import starling.textures.*;
   import starling.utils.*;
   
   public class Fish extends Sprite implements IHitObject
   {
      
      public static var newFish_array:Vector.<Fish> = new Vector.<Fish>();
      
      public var counter:int = 0;
      
      private var animateCounter:int = 0;
      
      private var moveSpeed:Number = 2;
      
      public var velX:Number;
      
      public var velY:Number;
      
      private var originalVelX:Number;
      
      private var __shiny:Boolean = false;
      
      private var __withinBait:Boolean;
      
      private var scare_point:Point;
      
      private var __type:String;
      
      private var fish_image:Image;
      
      private var hitTester:HitTester;
      
      private var scaring:Boolean = false;
      
      public function Fish(param1:int, param2:int, param3:String)
      {
         var _frnd:Function;
         var _fh:Number = NaN;
         var _fs:Number = NaN;
         var _x:int = param1;
         var _y:int = param2;
         var _type:String = param3;
         var lightStyle:LightStyle = null;
         super();
         this.fish_image = new Image(Assets.treesFish_textureAtlas.getTexture(_type));
         this.fish_image.touchable = false;
         this.fish_image.textureSmoothing = TextureSmoothing.NONE;
         addChild(this.fish_image);
         _fh = _x * 0.6180339887 + _y * 0.4142135624 + _type.length * 0.7320508076;
         _fh -= Math.floor(_fh);
         _fs = 0;
         _frnd = function():Number
         {
            _fs += 0.6180339887;
            var _loc1_:Number = (_fh + _fs) % 1;
            return _loc1_ < 0 ? _loc1_ + 1 : _loc1_;
         };
         this.velX = (0.5 + _frnd() * this.moveSpeed) * (_frnd() < 0.5 ? -1 : 1);
         this.velY = (0.1 + _frnd() * (this.moveSpeed / 2)) * (_frnd() < 0.5 ? -1 : 1);
         this.moveSpeed = Math.abs(this.velX) + Math.abs(this.velY);
         this.originalVelX = this.velX;
         touchable = false;
         touchGroup = true;
         this.scare_point = new Point();
         this.__type = _type;
         pivotX = width / 2;
         pivotY = height / 2;
         x = _x + _frnd() * 165;
         y = _y + _frnd() * 165;
         this.hitTester = new HitTester(this,new Rectangle(0 - width / 2,0 - height / 2,width,height));
         if(GameMain.lighting)
         {
            lightStyle = new LightStyle(Assets.treeFishLighMap_textureAtlas.getTexture(_type));
            lightStyle.ambientRatio = 0.3;
            lightStyle.diffuseRatio = 0.7;
            lightStyle.specularRatio = 0.4;
            lightStyle.shininess = 9;
            lightStyle.textureSmoothing = TextureSmoothing.NONE;
            this.fish_image.style = lightStyle;
         }
      }
      
      public static function fishNoShinyName(param1:String) : String
      {
         if(param1.indexOf("shiny ") == 0)
         {
            return param1.slice(6,param1.length);
         }
         return param1;
      }
      
      public function onEnter(param1:Vector.<Person>) : void
      {
         var _loc2_:Person = null;
         var _loc3_:FishingLine = null;
         var _loc4_:Vector.<Person> = null;
         ++this.counter;
         ++this.animateCounter;
         if(this.scaring == false)
         {
            for each(_loc2_ in param1)
            {
               if(_loc2_.gravityObject.inWater && (_loc2_.gravityObject.velX != 0 || _loc2_.gravityObject.velY != 0) && _loc2_.gravityObject.counter % 30 == 0)
               {
                  this.scare(_loc2_.x,_loc2_.y);
               }
            }
         }
         if(Boolean(this.__shiny) && (this.counter + 1) % 120 == 0 && Boolean(CommonCalls.onScreen(x,y,false,true)))
         {
            ShineEffect.shineObjectNoParent(this,3);
         }
         if(this.counter % 5 == 0)
         {
            if(TileHandler.waterHit_bitmapData.getPixel(x - 25,y - 25) == 0 && this.velX < 0 || TileHandler.waterHit_bitmapData.getPixel(x + 25,y - 25) == 0 && this.velX > 0)
            {
               this.velX *= -1;
               TweenMax.killTweensOf(this);
               this.originalVelX *= -1;
               this.velX = this.originalVelX;
            }
            if(TileHandler.waterHit_bitmapData.getPixel(x - 25,y - 85) == 0 && this.velY < 0 || TileHandler.waterHit_bitmapData.getPixel(x - 25,y + 25) == 0 && this.velY > 0)
            {
               this.velY *= -1;
            }
         }
         this.__withinBait = false;
         if(this.scaring == false)
         {
            for each(_loc3_ in FishingLine.all_array)
            {
               if(_loc3_.caughtFish == null && _loc3_.stopped && CalcDist.getDistNumbers(x,y,_loc3_.global_point.x,_loc3_.global_point.y) < _loc3_.radius)
               {
                  rotation = deg2rad(RotateTo.rotTo(x,_loc3_.global_point.x,y,_loc3_.global_point.y));
                  if(Math.abs(CalcDist.getDistX(x,_loc3_.global_point.x)) > 20)
                  {
                     x += x < _loc3_.global_point.x ? this.moveSpeed : -this.moveSpeed;
                  }
                  if(Math.abs(CalcDist.getDistY(y,_loc3_.global_point.y)) > 20)
                  {
                     y += (y < _loc3_.global_point.y ? this.moveSpeed : -this.moveSpeed) * 0.75;
                  }
                  this.__withinBait = true;
                  if(Math.random() > 0.993)
                  {
                     SoundManager.playSound(SoundLibrary.chomp_sound,x,y,true,parent);
                     _loc3_.caughtFish = this;
                     _loc3_.creator.createExclaim();
                  }
                  break;
               }
            }
         }
         if(this.__withinBait == false)
         {
            x += this.velX;
            y += this.velY;
            rotation = deg2rad(RotateTo.rotTo(x,x + this.velX,y,y + this.velY));
            scaleY = this.velX > 0 ? -1 : 1;
         }
         if(this.animateCounter < 10)
         {
            scaleX -= 0.04;
            scaleY += 0.02;
         }
         else if(this.animateCounter < 19)
         {
            scaleX += 0.04;
            scaleY -= 0.02;
         }
         else
         {
            scaleX = 1;
            scaleY = this.velX > 0 ? -1 : 1;
            this.animateCounter = 0;
         }
         var _loc5_:Person = MainStarlingStage(root).gameMain.player;
         if(_loc5_.bodyAnimator.weaponString == "net")
         {
            _loc4_ = new Vector.<Person>();
            _loc4_.push(_loc5_);
            if(this.hitTester.hitCheck(_loc4_).basicType == HitType.MELEE_TYPE)
            {
               this.onMeleeHit();
            }
         }
      }
      
      public function scare(param1:int, param2:int) : void
      {
         var _x:int = param1;
         var _y:int = param2;
         this.scare_point.x = _x;
         this.scare_point.y = _y;
         if(CalcDist.getDistNumbers(x,y,this.scare_point.x,this.scare_point.y) < 60)
         {
            this.velX = this.originalVelX;
            if(x > _x && this.velX < 0)
            {
               this.velX *= -1;
               this.originalVelX *= -1;
            }
            else if(x < _x && this.velX > 0)
            {
               this.velX *= -1;
               this.originalVelX *= -1;
            }
            this.scaring = true;
            TweenMax.from(this,2,{
               "velX":this.velX * 3 + (this.velX < 0 ? -1 : 1),
               "ease":Linear.easeNone
            });
            setTimeout(function():void
            {
               scaring = false;
            },2000);
         }
      }
      
      public function get type() : String
      {
         return this.__type;
      }
      
      public function set shiny(param1:Boolean) : void
      {
         this.__shiny = param1;
         if(this.__shiny)
         {
            SetHue.setStarlingObjectHue(this,60);
         }
      }
      
      public function get shiny() : Boolean
      {
         return this.__shiny;
      }
      
      public function onMeleeHit() : void
      {
         if(MainStarlingStage(root).gameMain.personItem_array.length < MainStarlingStage(root).gameMain.maxItems)
         {
            SoundManager.playSound(SoundLibrary.fishCaught_sound,x,y,true,parent);
            MainStarlingStage(root).gameMain.theConnection.send("caughtFish",name);
            Person(this.hitTester.hitType.hitter).createExclaim("caught fish!",24);
         }
         else
         {
            Person(this.hitTester.hitType.hitter).createExclaim("inventory full",18);
         }
      }
      
      public function onProjectileHit() : void
      {
      }
      
      public function onJumpHit() : void
      {
      }
   }
}

