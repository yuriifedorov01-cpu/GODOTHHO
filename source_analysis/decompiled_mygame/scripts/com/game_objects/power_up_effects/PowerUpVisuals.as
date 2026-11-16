package com.game_objects.power_up_effects
{
   import com.game_objects.*;
   import com.game_objects.enemies.Enemy;
   import com.gravityPackage.*;
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.math.*;
   import com.sound.*;
   import com.stats.*;
   import com.utilities.*;
   import com.visual_effects.*;
   import flash.display.*;
   import flash.geom.*;
   import flash.media.Sound;
   import starling.*;
   import starling.display.*;
   import starling.textures.*;
   
   public final class PowerUpVisuals
   {
      
      private var person:Person;
      
      private var suctionLines:SuctionLines;
      
      private var aura:Aura;
      
      private var auraBall:AuraBall;
      
      private var __poweringUp:Boolean = false;
      
      private var __unleashing:Boolean = false;
      
      private var counter:int = 0;
      
      private var wind_array:Vector.<WindSource> = new Vector.<WindSource>();
      
      private var framesSinceLastUnleash:int = 99999;
      
      public function PowerUpVisuals(param1:Person)
      {
         super();
         this.person = param1;
      }
      
      public function powerUp() : void
      {
         if(this.__unleashing == false)
         {
            if(this.__poweringUp == false)
            {
               this.suctionLines = new SuctionLines(this.person);
               SortDepths.addAt(this.suctionLines,SortDepths.REGION_1);
            }
            this.__poweringUp = true;
         }
      }
      
      public function stopPowerUp() : void
      {
         if(this.__poweringUp)
         {
            this.__poweringUp = false;
            if(this.suctionLines != null)
            {
               this.suctionLines.removeFromParent(true);
            }
         }
      }
      
      public function unleash() : void
      {
         var _loc1_:Point = null;
         var _loc2_:Shockwave = null;
         var _loc3_:Rectangle = null;
         var _loc4_:int = 0;
         var _loc5_:Number = Number(NaN);
         var _loc6_:int = 0;
         var _loc7_:WindSource = null;
         var _loc8_:WindSource = null;
         var _loc9_:WindSource = null;
         var _loc10_:WindSource = null;
         var _loc11_:WindSource = null;
         if(this.__unleashing == false && this.framesSinceLastUnleash > 9000)
         {
            if(this.person.energyController.fullTotalScale < 0.3)
            {
               SoundManager.playSound(SoundLibrary.powerUpHit1_sound,this.person.x,this.person.y,true,this.person.parent);
            }
            else if(this.person.energyController.fullTotalScale > 0.8)
            {
               SoundManager.playSound(SoundLibrary.powerUpImpact_sound,this.person.x,this.person.y,true,this.person.parent);
               SoundManager.playSound(SoundLibrary.lowDrone_sound,this.person.x,this.person.y,true,this.person.parent,true,this.person.name + "LowDrone");
            }
            SoundManager.playSound(SoundLibrary.powerUp_sound,this.person.x,this.person.y,true,this.person.parent,true,this.person.name + "PowerUp");
            this.framesSinceLastUnleash = 0;
            if(Boolean(this.person.isPlayer) && this.person.energyController.fullTotal >= 9 && Stats.missionStats["Reach High Energy Level"].started == true && Stats.missionStats["Reach High Energy Level"].completed == false)
            {
               MainStarlingStage(this.person.root).gameMain.createMissionCompleteAni("Reach High Energy Level");
            }
            this.__poweringUp = false;
            this.__unleashing = true;
            _loc1_ = new Point(this.person.x,this.person.y);
            this.person.parent.localToGlobal(_loc1_,_loc1_);
            if(MainStarlingStage(this.person.root).gameMain.stage.quality == StageQuality.HIGH.toUpperCase() && this.person.energyController.fullTotalScale > 0.4)
            {
               _loc2_ = new Shockwave(_loc1_.x,_loc1_.y,this.person.parent,30);
            }
            if(this.person.energyController.fullTotalScale > 0.5)
            {
               _loc3_ = MainStarlingStage(this.person.root).gameMain.mainStarling.viewPort;
               _loc4_ = int(CalcDist.getDistNumbers(_loc1_.x,_loc1_.y,_loc3_.x + _loc3_.width / 2,_loc3_.y + _loc3_.height / 2));
               _loc4_ += 1;
               _loc5_ = 200 / _loc4_;
               _loc5_ = _loc5_ > 1 ? 1 : _loc5_;
               MainStarlingStage(this.person.root).gameMain.createWhite(0.2,_loc5_);
            }
            if(this.suctionLines != null)
            {
               this.suctionLines.removeFromParent(true);
            }
            if(this.person.energyController.fullTotal > 0)
            {
               this.aura = new Aura(this.person);
               SortDepths.addAt(this.aura,SortDepths.REGION_1);
            }
            if(this.person.energyController.fullTotalScale > 0.38)
            {
               this.auraBall = new AuraBall(this.person);
               SortDepths.addAt(this.auraBall,SortDepths.REGION_1);
            }
            if(this.person.energyController.fullTotalScale > 0.2)
            {
               _loc6_ = this.person.energyController.fullTotalScale * 500;
               _loc7_ = new WindSource(_loc6_,0);
               _loc7_.x = this.person.x + 35;
               SortDepths.addAt(_loc7_,SortDepths.REGION_2);
               _loc8_ = new WindSource(-_loc6_,0);
               _loc8_.x = this.person.x - 35;
               _loc8_.y = _loc7_.y = this.person.y;
               SortDepths.addAt(_loc8_,SortDepths.REGION_2);
               _loc9_ = new WindSource(_loc6_,270);
               _loc9_.x = this.person.x - 25;
               SortDepths.addAt(_loc9_,SortDepths.REGION_2);
               _loc10_ = new WindSource(_loc6_,315);
               _loc10_.x = this.person.x + 35;
               SortDepths.addAt(_loc10_,SortDepths.REGION_2);
               _loc11_ = new WindSource(-_loc6_,45);
               _loc11_.x = this.person.x - 35;
               _loc11_.y = _loc10_.y = _loc9_.y = this.person.y - 50;
               SortDepths.addAt(_loc11_,SortDepths.REGION_2);
               this.wind_array.push(_loc11_,_loc10_,_loc9_,_loc8_,_loc7_);
            }
         }
         else if(this.person.isPlayer)
         {
            MainStarlingStage(this.person.root).gameMain.createAlert("Cannot unleash yet, 5 minute cool-down in between.");
         }
      }
      
      public function onEnter() : void
      {
         var _loc1_:WindSource = null;
         var _loc2_:Person = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:* = 0;
         var _loc6_:Point = null;
         var _loc7_:Shockwave = null;
         var _loc8_:int = 0;
         var _loc9_:Image = null;
         var _loc10_:Enemy = null;
         var _loc11_:uint = 0;
         var _loc12_:EnergyOrb = null;
         ++this.counter;
         ++this.framesSinceLastUnleash;
         if(this.person.energyController.charge == 0 && Boolean(this.__unleashing))
         {
            this.__unleashing = false;
            if(this.aura != null && this.aura.parent != null)
            {
               this.aura.removeFromParent(true);
            }
            if(this.auraBall != null && this.auraBall.parent != null)
            {
               this.auraBall.removeFromParent(true);
            }
            _loc3_ = 0;
            _loc4_ = 0;
            _loc5_ = int(this.wind_array.length - 1);
            while(_loc5_ >= 0)
            {
               _loc3_ = int(WindSource.wind_array.length);
               _loc4_ = 0;
               while(_loc4_ < _loc3_)
               {
                  if(WindSource.wind_array[_loc4_] == this.wind_array[_loc5_])
                  {
                     WindSource.wind_array.removeAt(_loc4_);
                     break;
                  }
                  _loc4_++;
               }
               this.wind_array.pop().removeFromParent(true);
               _loc5_--;
            }
            SoundManager.stopLoopedSound(this.person.name + "PowerUp",true);
            SoundManager.stopLoopedSound(this.person.name + "LowDrone",true);
         }
         if(this.__unleashing)
         {
            SoundManager.changeLoopedSoundPosition(this.person.name + "PowerUp",this.person.x,this.person.y);
            SoundManager.changeLoopedSoundPosition(this.person.name + "LowDrone",this.person.x,this.person.y);
         }
         for each(_loc1_ in this.wind_array)
         {
            if(_loc1_.power < 0)
            {
               _loc1_.power = -(this.person.energyController.fullTotalScale * 500);
            }
            else
            {
               _loc1_.power = this.person.energyController.fullTotalScale * 500;
            }
            _loc1_.x = this.person.x + (_loc1_.power > 0 ? 35 : -35);
            _loc1_.y = this.person.y + 15;
         }
         if(this.suctionLines != null && this.suctionLines.parent != null)
         {
            this.suctionLines.onEnter();
         }
         if(this.aura != null && this.aura.parent != null)
         {
            this.aura.onEnter();
         }
         if(this.auraBall != null && this.auraBall.parent != null)
         {
            this.auraBall.onEnter();
         }
         if(this.aura != null && this.aura.parent != null && Boolean(this.__unleashing) && this.counter % (90 - int(this.person.energyController.fullTotalScale * 45)) == 0)
         {
            Electrify.to(this.aura,this.person.energyController.fullTotalScale);
            if(this.person.energyController.fullTotalScale > 0.4)
            {
               SoundManager.playSound(SoundLibrary.electric_sound,this.person.x,this.person.y,true,this.person.parent);
            }
         }
         var _loc13_:int = 120 - this.person.energyController.fullTotalScale * 105;
         if(Boolean(this.__unleashing) && this.person.energyController.fullTotalScale > 0.6 && this.counter % _loc13_ == 0)
         {
            _loc6_ = new Point(this.person.x,this.person.y);
            this.person.parent.localToGlobal(_loc6_,_loc6_);
            if(MainStarlingStage(this.person.root).gameMain.stage.quality == StageQuality.HIGH.toUpperCase() && Boolean(CommonCalls.onScreen(_loc6_.x,_loc6_.y,false)))
            {
               _loc7_ = new Shockwave(_loc6_.x,_loc6_.y,this.person.parent,20);
            }
         }
         if(Boolean(this.__unleashing) && this.counter % 6 == 0 && this.person.energyController.fullTotalScale > 0.75)
         {
            if(this.person.gravityObject.previousX != this.person.x || this.person.gravityObject.previousY != this.person.y)
            {
               AfterImage.create(this.person,0.2);
            }
         }
         if(Boolean(this.__unleashing) && this.person.energyController.fullTotalScale > 0.83)
         {
            _loc8_ = 120 - this.person.energyController.fullTotalScale * 90;
            if(this.counter % _loc8_ == 0)
            {
               _loc9_ = new Image(Assets.powerUp_textureAtlas.getTexture("large lightning"));
               _loc9_.x = this.person.x + Math.random() * 100 * RanOne.ranOne();
               _loc9_.pivotX = 60;
               _loc9_.scale = 0.5 + this.person.energyController.fullTotalScale / 2;
               _loc9_.scaleX *= RanOne.ranOne();
               _loc9_.y = this.person.y - _loc9_.height * 0.75;
               _loc9_.textureSmoothing = TextureSmoothing.NONE;
               _loc9_.touchable = false;
               SortDepths.addAt(_loc9_,SortDepths.REGION_1);
               TweenMax.to(_loc9_,0.9,{
                  "alpha":0,
                  "delay":0.2,
                  "ease":Linear.easeNone,
                  "onComplete":_loc9_.removeFromParent,
                  "onCompleteParams":[true]
               });
               SoundManager.playSound(Math.random() > 0.5 ? SoundLibrary.thunder2_sound : SoundLibrary.thunder3_sound,_loc9_.x,_loc9_.y,true,this.person.parent);
            }
         }
         if(Boolean(this.__unleashing) && this.counter % 120 == 0 && this.person.energyController.fullTotalScale > 0.5)
         {
            for each(_loc10_ in MainStarlingStage(this.person.root).gameMain.e_array)
            {
               if(CalcDist.getDist(this.person,_loc10_) < this.person.energyController.fullTotalScale * 350)
               {
                  Electrify.to(_loc10_,0.3);
                  FlashShock.flashShockObject(_loc10_);
                  MainStarlingStage(this.person.root).gameMain.theConnection.send("dmgE",_loc10_.name,Stats.wStats[this.person.bodyAnimator.weaponString].defense > 0,"aura electric",0,0,_loc10_.x,_loc10_.y);
               }
            }
         }
         if(this.unleashing && this.counter % 30 == 0 && this.person.energyController.fullTotalScale > 0.5 && Boolean(CommonCalls.onScreen(this.person.x,this.person.y,true,true)))
         {
            _loc11_ = this.person.energyController.fullTotalScale * 7 + Shake.getMagnitude(this.person.parent);
            Shake.startShake(this.person.parent,29,_loc11_);
         }
         for each(_loc2_ in MainStarlingStage(this.person.root).gameMain.p_array)
         {
            if(_loc2_.bodyAnimator.currentLabel == "give energy" && this.person.gravityObject.counter % 20 == 0 && CalcDist.getDist(_loc2_,this.person) < 500)
            {
               _loc12_ = new EnergyOrb(this.person);
               _loc12_.x = _loc2_.x;
               _loc12_.y = _loc2_.y;
               SortDepths.addAt(_loc12_,SortDepths.REGION_2);
            }
         }
         if(this.__poweringUp)
         {
            if(this.person.isFrameLabel("standing","pet standing") == false && this.person.gravityObject.velX != 0)
            {
               this.stopPowerUp();
            }
         }
      }
      
      public function stopUnleashing() : void
      {
         this.person.energyController.charge = 0;
         this.onEnter();
      }
      
      public function get unleashing() : Boolean
      {
         return this.__unleashing;
      }
      
      public function get poweringUp() : Boolean
      {
         return this.__poweringUp;
      }
   }
}

