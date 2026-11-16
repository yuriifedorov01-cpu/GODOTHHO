package com.gravityPackage
{
   import com.game_objects.hit_detect.*;
   import com.helpers.*;
   import com.sound.*;
   import com.utilities.BitBitmapData;
   import flash.geom.*;
   import starling.display.DisplayObject;
   
   public final class GravityObject
   {
      
      public var velX:Number = 0;
      
      public var velY:Number = 0;
      
      private var groundFriction:Number = 0.83;
      
      public const airFriction:Number = 0.96;
      
      public var doApplyGravity:Boolean = true;
      
      public var doHitChecks:Boolean = true;
      
      private var originalFriction:Number = this.groundFriction;
      
      public var onGround:Boolean = false;
      
      public var inWater:Boolean = false;
      
      private var __onWall:Boolean = false;
      
      private var prevFrameOnWall:Boolean = false;
      
      private var maxFallSpeed:int = 25;
      
      public var dropThroughCounter:int = 500;
      
      public const MIN_VELX:Number = new Number(0.3);
      
      private var previousPoint:Point;
      
      private var prev_rect:Rectangle = new Rectangle();
      
      public var creator:DisplayObject;
      
      public var hit_rect:Rectangle;
      
      private var __hitOffsetX:int = 0;
      
      private var __hitOffsetY:int = 0;
      
      public var jumps:int = 0;
      
      public var counter:int = 0;
      
      public var maxJumps:uint = 1;
      
      private var lastGravHitType:HitType = new HitType();
      
      private var changeVert_point:Point = new Point();
      
      private var changeHor_point:Point = new Point();
      
      public var __onWallCounter:int = 0;
      
      private var offWallCounter:int = 0;
      
      public var accelDownMultiplier:Number = 0;
      
      private var maxGap:int = 20;
      
      private var wasInWater:Boolean = false;
      
      private var prevZeroBounds:Rectangle = new Rectangle(0,int.MAX_VALUE,0,0);
      
      private var __currentGroundBitmapData:BitBitmapData;
      
      private var zeroBoundsRight:Rectangle = new Rectangle();
      
      public function GravityObject(param1:DisplayObject, param2:Rectangle)
      {
         super();
         this.creator = param1;
         this.__hitOffsetX = param2.x;
         this.__hitOffsetY = param2.y;
         param2.setTo(this.creator.x + this.__hitOffsetX,this.creator.y + this.__hitOffsetY,param2.width,param2.height);
         this.hit_rect = param2;
         this.previousPoint = new Point(this.creator.x,this.creator.y);
      }
      
      public function applyGravity(param1:GameMain, param2:Number) : void
      {
         var _loc3_:Number = Number(NaN);
         var _loc4_:Boolean = false;
         var _loc5_:WindSource = null;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Vector.<Rectangle> = null;
         var _loc11_:int = 0;
         var _loc12_:Rectangle = null;
         var _loc13_:Rectangle = null;
         var _loc14_:Rectangle = null;
         if(this.doApplyGravity)
         {
            _loc3_ = param2;
            _loc4_ = this.onGround;
            this.__currentGroundBitmapData = null;
            this.hit_rect.x = this.creator.x + this.hitOffsetX;
            this.hit_rect.y = this.creator.y + this.hitOffsetY;
            this.prev_rect = this.hit_rect;
            this.prevFrameOnWall = this.__onWall;
            if(this.inWater)
            {
               _loc3_ *= 0.7;
            }
            if(this.wasInWater != this.inWater && this.onGround == false)
            {
               _loc9_ = 165 * int(this.hit_rect.y / 165);
               _loc9_ += 165 + 40;
               if(this.creator.width > 40 && this.creator.height > 40)
               {
                  param1.createSplash(this.creator.x,_loc9_ + 10);
                  SoundManager.playSound(SoundLibrary.waterSwish_sound,this.creator.x,this.creator.y,true,this.creator.parent);
               }
            }
            for each(_loc5_ in WindSource.wind_array)
            {
               _loc5_.applyWind(this);
            }
            ++this.dropThroughCounter;
            this.previousPoint.setTo(this.creator.x,this.creator.y);
            this.velY += _loc3_ + this.accelDownMultiplier * _loc3_;
            this.velX *= (this.onGround ? this.groundFriction : this.airFriction) * (this.inWater ? 0.95 : 1);
            this.creator.x += this.velX;
            this.creator.y += this.velY;
            this.onGround = false;
            this.__onWall = false;
            this.hit_rect.x = this.creator.x + this.hitOffsetX;
            this.hit_rect.y = this.creator.y + this.hitOffsetY;
            _loc6_ = false;
            if(Math.abs(this.velX) > this.maxGap || Math.abs(this.velY) > this.maxGap)
            {
               _loc10_ = this.interpolate(this.prevZeroBounds,this.hit_rect,this.maxGap);
               _loc11_ = int(_loc10_.length);
               _loc12_ = new Rectangle();
               for each(_loc13_ in _loc10_)
               {
                  _loc12_.setTo(_loc13_.x,_loc13_.y,_loc13_.width,_loc13_.height);
                  _loc14_ = this.testRect(_loc13_,TileHandler.levelHit_bitmapData,true,"solid",Math.abs(this.velX) > this.maxGap,Math.abs(this.velY) > this.maxGap);
                  if(this.velY > this.maxGap)
                  {
                     _loc14_ = this.testRect(this.hit_rect,TileHandler.ground2Hit_bitmapData,true,"platform",false);
                     _loc14_ = this.testRect(this.hit_rect,TileHandler.ground3Hit_bitmapData,true,"platform",false);
                  }
                  _loc12_.y = Math.ceil(_loc12_.y);
                  if(_loc12_.equals(_loc14_) == false)
                  {
                     this.creator.x = _loc14_.x - this.hitOffsetX;
                     this.creator.y = _loc14_.y - this.hitOffsetY;
                     this.hit_rect.x = _loc14_.x;
                     this.hit_rect.y = _loc14_.y;
                     break;
                  }
               }
            }
            this.zeroBoundsRight.setTo(this.hit_rect.x + 90,this.hit_rect.y,this.hit_rect.width,this.hit_rect.height);
            _loc7_ = int(TileHandler.getTileRegion(TileHandler.tileMain_array,this.hit_rect));
            _loc8_ = int(TileHandler.getTileRegion(TileHandler.tileMain_array,this.zeroBoundsRight));
            if((_loc7_ == 21 || _loc7_ == 22 || _loc7_ == 33 || _loc7_ == 9 || _loc8_ == 21 || _loc8_ == 22 || _loc8_ == 33 || _loc8_ == 9) && this.velX < 0 && _loc4_)
            {
               if(Math.round(this.creator.y - this.previousPoint.y) == Math.round(_loc3_))
               {
                  this.hit_rect.y += 30;
               }
            }
            else if((_loc7_ == 54 || _loc7_ == 55 || _loc7_ == 67 || _loc7_ == 10 || _loc8_ == 54 || _loc8_ == 55 || _loc8_ == 67 || _loc8_ == 10) && this.velX > 0 && _loc4_)
            {
               if(Math.round(this.creator.y - this.previousPoint.y) == Math.round(_loc3_))
               {
                  this.hit_rect.y += 30;
               }
            }
            this.hit_rect = this.testRect(this.hit_rect,TileHandler.levelHit_bitmapData);
            this.hit_rect = this.testRect(this.hit_rect,TileHandler.ground2Hit_bitmapData,true,"platform");
            this.hit_rect = this.testRect(this.hit_rect,TileHandler.ground3Hit_bitmapData,true,"platform");
            this.prevZeroBounds.setTo(this.hit_rect.x,this.hit_rect.y,this.hit_rect.width,this.hit_rect.height);
            this.wasInWater = this.inWater;
            if(this.hit_rect.x < 0 || this.hit_rect.y < 0 || this.hit_rect.right > TileHandler.waterHit_bitmapData.width || this.hit_rect.y + this.hit_rect.height > TileHandler.waterHit_bitmapData.height)
            {
               this.inWater = false;
            }
            else if(TileHandler.waterHit_bitmapData.getPixel(this.hit_rect.x,this.hit_rect.y) > 0 || TileHandler.waterHit_bitmapData.getPixel(this.hit_rect.x + this.hit_rect.width,this.hit_rect.y) > 0 || TileHandler.waterHit_bitmapData.getPixel(this.hit_rect.x,this.hit_rect.y + this.hit_rect.height) > 0 || TileHandler.waterHit_bitmapData.getPixel(this.hit_rect.x + this.hit_rect.width,this.hit_rect.y + this.hit_rect.height) > 0)
            {
               this.inWater = true;
            }
            else
            {
               this.inWater = false;
            }
            this.creator.x = this.hit_rect.x - this.__hitOffsetX;
            this.creator.y = this.hit_rect.y - this.__hitOffsetY;
            this.velX = this.velX < this.MIN_VELX && this.velX > -this.MIN_VELX ? 0 : this.velX;
            this.velY = this.velY < this.maxFallSpeed ? this.velY : (this.inWater == false ? Number(this.maxFallSpeed) : this.maxFallSpeed / 4);
            this.hit_rect.x = this.creator.x + this.hitOffsetX;
            this.hit_rect.y = this.creator.y + this.hitOffsetY;
            if(this.onGround)
            {
               this.jumps = 0;
               this.accelDownMultiplier = 0;
            }
            if(this.onWall)
            {
               ++this.__onWallCounter;
            }
         }
      }
      
      public function get currentGroundBitmapData() : BitBitmapData
      {
         return this.__currentGroundBitmapData;
      }
      
      private function testRect(param1:Rectangle, param2:BitBitmapData, param3:Boolean = true, param4:String = "solid", param5:Boolean = true, param6:Boolean = true) : Rectangle
      {
         param1.y = Math.ceil(param1.y);
         var _loc7_:* = int(165 * int((param1.y + param1.height) / 165));
         if(param6)
         {
            if(param4 == "solid" || this.velY > 0 && this.prevZeroBounds.y <= _loc7_ && this.dropThroughCounter > 10)
            {
               while(param2.getPixel(param1.x + param1.width / 2,param1.y + param1.height) > 0)
               {
                  --param1.y;
                  _loc7_--;
                  this.velY = 0;
                  this.onGround = param3 ? true : this.onGround;
                  this.__currentGroundBitmapData = param3 ? param2 : this.__currentGroundBitmapData;
               }
            }
         }
         if(param4 == "solid")
         {
            if(param6)
            {
               while(param2.getPixel(param1.x + param1.width / 2,param1.y) > 0)
               {
                  ++param1.y;
                  this.velY = 0;
               }
            }
            if(param5)
            {
               while(param2.getPixel(param1.x,param1.y + param1.height / 2) > 0)
               {
                  ++param1.x;
                  this.velX = 0;
                  this.__onWall = param3 ? true : this.onGround;
               }
               while(param2.getPixel(param1.x + param1.width,param1.y + param1.height / 2) > 0)
               {
                  --param1.x;
                  this.velX = 0;
                  this.__onWall = param3 ? true : this.onGround;
               }
            }
         }
         if(param1.width > this.maxGap * 2)
         {
            if(param6)
            {
               if(param4 == "solid" || this.velY > 0 && this.prevZeroBounds.y <= _loc7_ && this.dropThroughCounter > 10)
               {
                  while(param2.getPixel(param1.x + this.maxGap,param1.y + param1.height) > 0)
                  {
                     --param1.y;
                     _loc7_--;
                     this.velY = 0;
                     this.onGround = param3 ? true : this.onGround;
                     this.__currentGroundBitmapData = param3 ? param2 : this.__currentGroundBitmapData;
                  }
                  while(param2.getPixel(param1.x + param1.width - this.maxGap,param1.y + param1.height) > 0)
                  {
                     --param1.y;
                     _loc7_--;
                     this.velY = 0;
                     this.onGround = param3 ? true : this.onGround;
                     this.__currentGroundBitmapData = param3 ? param2 : this.__currentGroundBitmapData;
                  }
               }
            }
            if(param4 == "solid")
            {
               if(param6)
               {
                  while(param2.getPixel(param1.x + this.maxGap,param1.y) > 0)
                  {
                     ++param1.y;
                     this.velY = 0;
                  }
                  while(param2.getPixel(param1.x + param1.width - this.maxGap,param1.y) > 0)
                  {
                     ++param1.y;
                     this.velY = 0;
                  }
               }
            }
         }
         if(param1.height > this.maxGap * 2)
         {
            if(param4 == "solid")
            {
               if(param5)
               {
                  while(param2.getPixel(param1.x,param1.y + param1.height - this.maxGap) > 0)
                  {
                     ++param1.x;
                     this.velX = 0;
                     this.__onWall = param3 ? true : this.onGround;
                  }
                  while(param2.getPixel(param1.x,param1.y + this.maxGap) > 0)
                  {
                     ++param1.x;
                     this.velX = 0;
                     this.__onWall = param3 ? true : this.onGround;
                  }
                  while(param2.getPixel(param1.x + param1.width,param1.y + param1.height - this.maxGap) > 0)
                  {
                     --param1.x;
                     this.velX = 0;
                     this.__onWall = param3 ? true : this.onGround;
                  }
                  while(param2.getPixel(param1.x + param1.width,param1.y + this.maxGap) > 0)
                  {
                     --param1.x;
                     this.velX = 0;
                     this.__onWall = param3 ? true : this.onGround;
                  }
               }
            }
         }
         return param1;
      }
      
      private function interpolate(param1:Rectangle, param2:Rectangle, param3:int) : Vector.<Rectangle>
      {
         var _loc4_:Rectangle = null;
         var _loc5_:Vector.<Rectangle> = new Vector.<Rectangle>();
         var _loc6_:int = Math.max(Math.abs(param2.x - param1.x),Math.abs(param2.y - param1.y));
         var _loc7_:int = Math.ceil(_loc6_ / param3);
         if(_loc7_ > 100)
         {
            return _loc5_;
         }
         var _loc8_:int = 1;
         while(_loc8_ < _loc7_)
         {
            _loc4_ = new Rectangle(0,0,param1.width,param1.height);
            _loc4_.x = param1.x + (param2.x - param1.x) / _loc7_ * _loc8_;
            _loc4_.y = param1.y + (param2.y - param1.y) / _loc7_ * _loc8_;
            _loc5_.push(_loc4_);
            _loc8_++;
         }
         return _loc5_;
      }
      
      public function slide(param1:Number = 0.98) : void
      {
         if(this.groundFriction != param1)
         {
            this.originalFriction = this.groundFriction;
         }
         this.groundFriction = param1;
         if(this.onGround)
         {
            this.velX += this.groundSlope * 0.03;
         }
      }
      
      public function endSlide() : void
      {
         this.groundFriction = this.originalFriction;
      }
      
      public function dropThroughCheck() : Boolean
      {
         if(this.onGround)
         {
            this.dropThroughCounter = this.inWater == false ? 0 : -5;
            return true;
         }
         return false;
      }
      
      public function get groundSlope() : Number
      {
         return TileHandler.tileSlope(TileHandler.getTileRegion(TileHandler.tileMain_array,this.hit_rect));
      }
      
      public function get onWall() : Boolean
      {
         if(this.__onWall)
         {
            return true;
         }
         if(this.prevFrameOnWall)
         {
            return true;
         }
         return false;
      }
      
      public function get previousX() : Number
      {
         return this.previousPoint.x;
      }
      
      public function get previousY() : Number
      {
         return this.previousPoint.y;
      }
      
      public function get onWallCounter() : int
      {
         return this.__onWallCounter;
      }
      
      public function get hitOffsetX() : int
      {
         return this.__hitOffsetX;
      }
      
      public function get hitOffsetY() : int
      {
         return this.__hitOffsetY;
      }
      
      public function getWeightEffectVel(param1:Number) : Number
      {
         var _loc2_:Number = Math.sqrt(Math.sqrt(this.hit_rect.width * this.hit_rect.height));
         return param1 * 7 / _loc2_;
      }
   }
}

