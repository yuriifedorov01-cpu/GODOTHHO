package com.game_objects.extensions
{
   import com.game_objects.*;
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.sound.*;
   import com.stats.*;
   import com.utilities.*;
   import com.visual_effects.*;
   import flash.ui.*;
   import starling.display.*;
   
   public class PersonFrameHandler
   {
      
      private var person:Person;
      
      private var currentMove:MoveStat;
      
      private var gameMain:GameMain;
      
      private var chargeAmount:int = 0;
      
      private var __releasedCharge:int = 0;
      
      private var flyCounter:uint = 0;
      
      public var offGroundCounter:uint = 0;
      
      public function PersonFrameHandler(param1:Person, param2:GameMain)
      {
         super();
         this.person = param1;
         this.gameMain = param2;
      }
      
      public function onEnter() : void
      {
         this.currentMove = Moves.moveByName(this.person.bodyAnimator.currentLabel);
         if(this.currentMove != null)
         {
            if(this.person.bodyAnimator.currentFrame == this.currentMove.endFrame)
            {
               this.person.bodyAnimator.gotoAndPlay(this.currentMove.resetFrameString);
            }
         }
         this.offGroundCounter = this.person.gravityObject.onGround == false ? uint(this.offGroundCounter + 1) : 0;
         this.handleDownAccel();
         this.handleGrenade();
         this.handleChargePlayer();
         this.handleDualWieldDamageable();
         this.handleArcherDownStab();
         this.handleWarriorDownSlash();
         this.handleLungeAttack();
         this.handleArrowRain();
         this.handleGunUpwards();
         this.handlePowerAttack();
         this.handleSummonLightning();
         this.handleJetpack();
         this.handleCape();
         this.handleBlock();
         this.handleArrowShoot();
         this.handleGiveEnergy();
         this.handleLoopFrames();
         if(this.person.gravityObject.onGround)
         {
            this.flyCounter = 0;
         }
         if(this.person.bodyAnimator.currentFrame == 873)
         {
            this.person.keyHandler.moveStarter.doGroundStabDone(this.gameMain);
         }
         else if(this.person.bodyAnimator.currentFrame == 944)
         {
            this.person.keyHandler.moveStarter.summonLightBeam();
         }
         if(this.person.bodyAnimator.currentLabel != "block" && this.person.guardSymbol != null)
         {
            this.person.guardSymbol.tweenOut();
            this.person.guardSymbol = null;
         }
      }
      
      private function handleDownAccel() : void
      {
         var _loc3_:Image = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc3_ = null;
         if(this.person.gravityObject.accelDownMultiplier > 0 && this.person.gravityObject.counter % 7 == 0 && Boolean(CommonCalls.onScreen(this.person.x,this.person.y,false,true)))
         {
            _loc1_ = 0;
            _loc2_ = 0;
            while(_loc2_ < (this.person.gravityObject.accelDownMultiplier > 1.1 ? 3 : 2))
            {
               _loc1_ = 0 - 25 + Math.random() * 50;
               _loc3_ = new Image(Assets.items_textureAtlas.getTexture("white pixel"));
               _loc3_.x = this.person.x + _loc1_;
               _loc3_.y = this.person.y - Math.random() * 40;
               _loc3_.height = 30 + Math.random() * 70;
               _loc3_.alpha = 0.9;
               _loc3_.touchable = false;
               this.gameMain.starlingStage.c_mc.addChildAt(_loc3_,this.person.parent.getChildIndex(this.person));
               TweenMax.to(_loc3_,0.7,{
                  "alpha":0,
                  "delay":0.3,
                  "ease":Linear.easeNone,
                  "onComplete":_loc3_.removeFromParent,
                  "onCompleteParams":[true]
               });
               _loc2_++;
            }
         }
      }
      
      private function handleDualWieldDamageable() : void
      {
         var _loc1_:int = 0;
         if(this.person.bodyAnimator.weapon2String != "none" && Stats.wStats[this.person.bodyAnimator.weaponString].defense == 0 && this.currentMove != null)
         {
            _loc1_ = this.currentMove.endDmgFrame - Math.floor((this.currentMove.endDmgFrame - this.currentMove.startDmgFrame) / 2);
            if(this.person.bodyAnimator.currentFrame == _loc1_)
            {
               this.person.canDamage = true;
               SoundManager.playSound(SoundLibrary.swoosh2_sound,this.person.x,this.person.y,true,this.person.parent);
            }
         }
         if(this.person.bodyAnimator.currentFrame == 962 || this.person.bodyAnimator.currentFrame == 966 || this.person.bodyAnimator.currentFrame == 969 || this.person.bodyAnimator.currentFrame == 972)
         {
            this.person.canDamage = true;
         }
      }
      
      private function handleChargePlayer() : void
      {
         if(this.currentMove != null && this.person.bodyAnimator.currentFrame == this.currentMove.chargeFrame && this.currentMove.key1 > 0)
         {
            if(this.person.keyHandler.keyStates.getKeyState(this.currentMove.key1).isDown)
            {
               this.person.bodyAnimator.stop();
            }
            else
            {
               this.person.bodyAnimator.play();
            }
            if(this.chargeAmount < 40)
            {
               ++this.chargeAmount;
               if(Shake.isShaking(this.person) == false)
               {
                  Shake.startShake(this.person,10,1);
               }
            }
            else if(Shake.isShaking(this.person) == false && Boolean(CommonCalls.onScreen(this.person.x,this.person.y,true,true)))
            {
               Shake.startShake(this.person,11,2);
            }
            this.__releasedCharge = this.chargeAmount;
         }
         else
         {
            this.chargeAmount = 0;
            this.person.bodyAnimator.weaponLeft_sprite.filter = null;
         }
      }
      
      private function handleArcherDownStab() : void
      {
         if(this.person.bodyAnimator.currentFrame == Moves.moveByName(Moves.DOWN_STAB).chargeFrame)
         {
            if(this.person.gravityObject.onGround == false)
            {
               this.person.bodyAnimator.stop();
               if(this.person.gravityObject.counter % 2 == 0 && Boolean(CommonCalls.onScreen(this.person.x,this.person.y,false,true)))
               {
                  AfterImage.create(this.person);
               }
            }
            else
            {
               this.person.keyHandler.moveStarter.archerDownStabDone();
            }
         }
      }
      
      private function handleWarriorDownSlash() : void
      {
         if(this.person.bodyAnimator.currentFrame == Moves.moveByName(Moves.DOWN_SLASH).chargeFrame)
         {
            if(this.person.gravityObject.onGround == false)
            {
               this.person.bodyAnimator.stop();
            }
            else
            {
               this.person.keyHandler.moveStarter.warriorDownSlashDone();
            }
         }
      }
      
      private function handleLungeAttack() : void
      {
         if(this.person.bodyAnimator.currentFrame >= 277 && this.person.bodyAnimator.currentFrame <= 283)
         {
            if(this.person.bodyAnimator.currentFrame == 277)
            {
               this.person.gravityObject.velX += this.__releasedCharge * 3 * this.person.scaleX;
            }
            if(this.person.gravityObject.counter % 3 == 0 && this.__releasedCharge >= 20)
            {
               this.gameMain.createDashCloud(this.person.x,this.person.y + 45,this.person.scaleX * -1,4,this.person.gravityObject.groundSlope);
            }
         }
      }
      
      private function handleArrowRain() : void
      {
         if(this.person.bodyAnimator.currentFrame == 264 || this.person.bodyAnimator.currentFrame == 527)
         {
            this.person.MP -= this.person.levelMP(Person.ARROW_RAIN_MP);
            if(this.person.isPlayer)
            {
               this.gameMain.theConnection.send("useMP",this.person.levelMP(Person.ARROW_RAIN_MP));
            }
            SoundManager.playSound(SoundLibrary.bow_sound,this.person.x,this.person.y,true,this.person.parent);
            this.person.keyHandler.moveStarter.createArrowRain();
         }
      }
      
      private function handleGunUpwards() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Projectile = null;
         if((this.person.bodyAnimator.currentFrame > 760 && this.person.bodyAnimator.currentFrame < 770 || this.person.bodyAnimator.currentFrame > 607 && this.person.bodyAnimator.currentFrame < 617) && this.person.conBulletsShot < 25)
         {
            if(this.person.keyHandler.keyStates.getKeyState(Keyboard.SPACE).isDown)
            {
               if(this.person.gravityObject.counter % Stats.wStats[this.person.bodyAnimator.weaponString].sRate == 0)
               {
                  this.person.bodyAnimator.play();
               }
               else if(this.person.ridingPet == null && this.person.bodyAnimator.currentFrame > 766 || this.person.ridingPet != null && this.person.bodyAnimator.currentFrame > 613)
               {
                  this.person.bodyAnimator.gotoAndStopInt(this.person.ridingPet == null ? 764 : 611);
               }
            }
            else
            {
               this.person.bodyAnimator.play();
            }
            if(this.person.ridingPet == null && this.person.bodyAnimator.currentFrame == 765 || this.person.ridingPet != null && this.person.bodyAnimator.currentFrame == 612)
            {
               ++this.person.conBulletsShot;
               _loc1_ = 0;
               if(this.person.ridingPet == null)
               {
                  _loc1_ = this.person.moveDir > 0 ? -10 : 10;
               }
               else
               {
                  _loc1_ = this.person.moveDir > 0 ? -20 : 20;
               }
               _loc2_ = this.gameMain.createProjectile(this.person.x + _loc1_,this.person.y,this.person.name,1,false,0.75);
               _loc2_.gravityObject.velX = 0;
               _loc2_.gravityObject.velY = -30;
               SoundManager.playSound(Stats.wStats[this.person.bodyAnimator.weaponString].sound,this.person.x,this.person.y,true,this.person.parent);
            }
         }
      }
      
      public function handlePowerAttack() : void
      {
         if(this.person.gravityObject.counter % 2 == 0 && this.__releasedCharge > 30 && this.person.gravityObject.velX != 0 && this.person.bodyAnimator.currentLabel == Moves.LUNGE_ATTACK && Boolean(CommonCalls.onScreen(this.person.x,this.person.y,false,true)))
         {
            AfterImage.create(this.person);
         }
      }
      
      public function handleSummonLightning() : void
      {
         if(this.person.bodyAnimator.currentFrame == Moves.moveByName(Moves.SUMMON_THUNDER).chargeFrame + 1 || this.person.bodyAnimator.currentFrame == 556)
         {
            this.person.keyHandler.moveStarter.summonThunderMagic();
         }
      }
      
      public function handleJetpack() : void
      {
         var _loc1_:int = this.person.bodyAnimator.accessoryString == "jet pack" ? 80 : 300;
         if(this.person.ridingPet == null && (this.person.bodyAnimator.accessoryString == "jet pack" || this.person.bodyAnimator.accessoryString == "heli pack"))
         {
            if(this.offGroundCounter > 10 && this.flyCounter < _loc1_ && MoveStat.isAttackingFrame(this.person) == false)
            {
               if(this.person.keyHandler.keyStates.getKeyState(Keyboard.UP).isDown)
               {
                  if(this.person.bodyAnimator.accessoryString == "heli pack")
                  {
                     MovieClip(this.person.bodyAnimator.accessory_object).fps = 30;
                  }
                  if(this.person.gravityObject.velY < -10)
                  {
                     this.person.gravityObject.velY = -10;
                  }
                  this.person.gravityObject.velY -= this.person.bodyAnimator.accessoryString == "jet pack" ? 1.2 : 1.05;
                  this.person.bodyAnimator.gotoAndStop("jumping");
                  ++this.flyCounter;
                  MovieClip(this.person.bodyAnimator.accessory_object).play();
                  if(this.person.gravityObject.counter % 10 == 0 && this.person.bodyAnimator.accessoryString == "jet pack")
                  {
                     this.gameMain.createSmoke(this.person.x,this.person.y + 20);
                  }
               }
               else
               {
                  this.person.bodyAnimator.play();
                  MovieClip(this.person.bodyAnimator.accessory_object).stop();
               }
            }
            else
            {
               MovieClip(this.person.bodyAnimator.accessory_object).stop();
            }
         }
      }
      
      public function handleCape() : void
      {
         if(this.person.ridingPet == null)
         {
            if(this.person.bodyAnimator.accessoryString == "red cape" || this.person.bodyAnimator.accessoryString == "wings" || this.person.bodyAnimator.accessoryString == "evil wings" || this.person.bodyAnimator.accessoryString == "butterfly wings")
            {
               if(this.person.gravityObject.velY > 0)
               {
                  if(Boolean(this.person.keyHandler.keyStates.getKeyState(Keyboard.UP).isDown) && MoveStat.isAttackingFrame(this.person) == false)
                  {
                     if(this.person.bodyAnimator.currentLabel != "gliding")
                     {
                        this.person.bodyAnimator.gotoAndStop("gliding");
                     }
                     this.person.gravityObject.accelDownMultiplier = -0.8;
                     ++this.flyCounter;
                     if(this.person.bodyAnimator.accessoryString == "wings" || this.person.bodyAnimator.accessoryString == "evil wings" || this.person.bodyAnimator.accessoryString == "butterfly wings")
                     {
                        if(this.person.gravityObject.counter % 10 == 0)
                        {
                           this.person.gravityObject.velY -= 2;
                        }
                        MovieClip(this.person.bodyAnimator.accessory_object).play();
                     }
                  }
               }
            }
         }
         if((this.person.bodyAnimator.accessoryString == "wings" || this.person.bodyAnimator.accessoryString == "evil wings" || this.person.bodyAnimator.accessoryString == "butterfly wings") && this.person.bodyAnimator.currentLabel != "gliding")
         {
            MovieClip(this.person.bodyAnimator.accessory_object).stop();
         }
      }
      
      public function get releasedCharge() : int
      {
         return this.__releasedCharge;
      }
      
      public function handleBlock() : void
      {
         if(this.person.attackCounter > 5 && Boolean(this.person.keyHandler.keyStates.getKeyState(Keyboard.V).isDown) && MoveStat.isAttackingFrame(this.person) == false && this.person.ridingPet == null && this.person.isFrameLabel("block") == false)
         {
            this.person.bodyAnimator.gotoAndPlay("block");
            if(this.person.isPlayer)
            {
               this.gameMain.theConnection.send("kd",Keyboard.V,this.person.bodyAnimator.currentFrame);
            }
            if(this.person.guardSymbol == null)
            {
               this.person.guardSymbol = GuardSymbol.createGuard(0,0,this.person);
            }
         }
      }
      
      public function handleGrenade() : void
      {
         if(Stats.wStats[this.person.bodyAnimator.weaponString].sRate > 0 && this.person.bodyAnimator.currentLabel == "ducking" && Boolean(this.person.keyHandler.keyStates.getKeyState(Keyboard.DOWN).isDown) && Boolean(this.person.keyHandler.keyStates.getKeyState(Keyboard.SPACE).isDown))
         {
            this.currentMove = Moves.moveByName(Moves.GRENADE_ATTACK);
            if(this.chargeAmount == 40 && this.person.MP >= this.person.levelMP(Person.GRENADE_MP))
            {
               this.person.keyHandler.moveStarter.doGrenadeAttack();
               this.chargeAmount = 0;
            }
         }
      }
      
      public function handleArrowShoot() : void
      {
         var _loc1_:Projectile = null;
         var _loc2_:Number = Number(NaN);
         var _loc3_:int = 0;
         if(this.person.bodyAnimator.currentFrame > 88 && this.person.bodyAnimator.currentFrame < 93 || this.person.bodyAnimator.currentFrame > 482 && this.person.bodyAnimator.currentFrame < 486)
         {
            if(this.person.bodyAnimator.currentFrame == 92 || this.person.bodyAnimator.currentFrame == 485)
            {
               if(this.person.keyHandler.keyStates.getKeyState(Keyboard.SPACE).isDown)
               {
                  this.person.bodyAnimator.stop();
                  if(this.person.projAttackType == "basic")
                  {
                     if(this.person.bodyAnimator.chargeBall_image == null || this.person.bodyAnimator.chargeBall_image.parent == null)
                     {
                        this.person.bodyAnimator.createChargingBall();
                     }
                     else if(this.person.bodyAnimator.chargeBall_image.scaleX < 2.7)
                     {
                        this.person.bodyAnimator.chargeBall_image.scaleX = this.person.bodyAnimator.chargeBall_image.scaleY = this.person.bodyAnimator.chargeBall_image.scaleY + 0.11;
                     }
                  }
               }
               else
               {
                  this.person.bodyAnimator.play();
                  if(this.person.bodyAnimator.chargeBall_image != null && this.person.bodyAnimator.chargeBall_image.parent != null)
                  {
                     this.person.arrowCharge = this.person.bodyAnimator.chargeBall_image.scaleX / 12;
                     this.person.bodyAnimator.chargeBall_image.removeFromParent(true);
                  }
                  else
                  {
                     this.person.arrowCharge = 0;
                  }
               }
            }
         }
         if(this.person.bodyAnimator.currentFrame == 96 || this.person.bodyAnimator.currentFrame == this.person.bodyAnimator.PET_ARROW_SHOOT_FRAME)
         {
            _loc1_ = this.gameMain.createProjectile(this.person.x,this.person.y,this.person.name,this.person.scaleX,false,this.person.projAttackType == "basic" ? 0.78 + this.person.arrowCharge : 0.9,this.person.projAttackType == "piercing" ? true : false,this.person.projAttackType == "piercing" ? int(this.person.piercingArrowLvl) : 1);
            _loc1_.lifeSpan = 30;
            _loc1_.gravityObject.velX = 45 * this.person.scaleX;
            this.person.gravityObject.velX -= this.person.scaleX;
            if(this.person.projAttackType == "piercing")
            {
               this.person.MP -= this.person.levelMP(Person.ARROW_PIERCE_MP);
               if(this.person.isPlayer)
               {
                  this.gameMain.theConnection.send("useMP",this.person.levelMP(Person.ARROW_PIERCE_MP));
               }
            }
            if(this.person.arrowCharge > 0.2299)
            {
               if(this.person.MP >= this.person.levelMP(Person.ARROW_BARRAGE_MP))
               {
                  if(this.person.isPlayer)
                  {
                     this.gameMain.theConnection.send("useMP",this.person.levelMP(Person.ARROW_BARRAGE_MP));
                  }
                  this.person.MP -= this.person.levelMP(Person.ARROW_BARRAGE_MP);
                  _loc3_ = 0;
                  while(_loc3_ < this.person.barrageLvl - 1)
                  {
                     switch(_loc3_)
                     {
                        case 0:
                           _loc2_ = Number(RoundToNearest.roundTo(0.9 + this.person.arrowCharge,1000));
                           _loc1_ = this.gameMain.createProjectile(this.person.x,this.person.y,this.person.name,this.person.scaleX,false,_loc2_);
                           _loc1_.gravityObject.velY = -10;
                           _loc1_.gravityObject.accelDownMultiplier = -0.4;
                           _loc1_.gravityObject.velX /= 1.05;
                           _loc1_.lifeSpan = 35;
                           break;
                        case 1:
                           _loc2_ = Number(RoundToNearest.roundTo(1.1 + this.person.arrowCharge,1000));
                           _loc1_ = this.gameMain.createProjectile(this.person.x,this.person.y,this.person.name,this.person.scaleX,false,_loc2_);
                           _loc1_.gravityObject.velY = -12;
                           _loc1_.gravityObject.accelDownMultiplier = -0.4;
                           _loc1_.gravityObject.velX /= 1.2;
                           _loc1_.lifeSpan += 7;
                           _loc1_.lifeSpan = 35;
                           break;
                        case 2:
                           _loc2_ = Number(RoundToNearest.roundTo(1.3 + this.person.arrowCharge,1000));
                           _loc1_ = this.gameMain.createProjectile(this.person.x,this.person.y,this.person.name,this.person.scaleX,false,_loc2_);
                           _loc1_.gravityObject.velY = -16;
                           _loc1_.gravityObject.accelDownMultiplier = -0.4;
                           _loc1_.gravityObject.velX /= 2;
                           _loc1_.lifeSpan += 22;
                           _loc1_.lifeSpan = 42;
                           break;
                        case 3:
                           _loc2_ = Number(RoundToNearest.roundTo(0.8 + this.person.arrowCharge,1000));
                           _loc1_ = this.gameMain.createProjectile(this.person.x,this.person.y,this.person.name,this.person.scaleX,false,_loc2_);
                           _loc1_.gravityObject.velY = -11;
                           _loc1_.gravityObject.accelDownMultiplier = -0.4;
                           _loc1_.gravityObject.velX /= 1.1;
                           _loc1_.lifeSpan = 35;
                           break;
                        case 4:
                           _loc2_ = Number(RoundToNearest.roundTo(0.7 + this.person.arrowCharge,1000));
                           _loc1_ = this.gameMain.createProjectile(this.person.x,this.person.y,this.person.name,this.person.scaleX,false,_loc2_);
                           _loc1_.gravityObject.velY = -13;
                           _loc1_.gravityObject.accelDownMultiplier = -0.4;
                           _loc1_.gravityObject.velX /= 1.3;
                           _loc1_.lifeSpan = 30;
                     }
                     _loc3_++;
                  }
               }
               else if(this.person.isPlayer)
               {
                  this.gameMain.createAlert("not enough MP");
               }
            }
            SoundManager.playSound(SoundLibrary.bow_sound,this.person.x,this.person.y,true,this.person.parent);
         }
      }
      
      public function handleGiveEnergy() : void
      {
         if(this.person.bodyAnimator.currentLabel == "give energy" && this.person.bodyAnimator.currentFrame == 999)
         {
            if(Boolean(this.person.keyHandler.keyStates.getKeyState(Keyboard.O).isDown) && (this.person.energyController.fullTotal > 0 || this.person.isPlayer == false))
            {
               this.person.bodyAnimator.stop();
            }
            else
            {
               this.person.bodyAnimator.play();
               if(this.person.isPlayer)
               {
                  this.gameMain.theConnection.send("ku",Keyboard.O);
               }
            }
         }
      }
      
      public function handleLoopFrames() : void
      {
         switch(this.person.bodyAnimator.currentFrame)
         {
            case 74:
               this.person.bodyAnimator.gotoAndPlay("running");
               break;
            case 229:
               this.person.bodyAnimator.gotoAndPlay("jumping");
               break;
            case 636:
               this.person.bodyAnimator.gotoAndPlay("pet dashing");
               break;
            case 659:
               this.person.bodyAnimator.gotoAndPlay("pet standing");
               break;
            case 793:
               this.person.bodyAnimator.gotoAndPlay("dashing");
               break;
            case 816:
               this.person.bodyAnimator.gotoAndPlay("standing");
               break;
            case 826:
               this.person.bodyAnimator.gotoAndPlay("standing");
               break;
            case 860:
               this.person.bodyAnimator.gotoAndPlay("standing");
               break;
            case 896:
               this.person.bodyAnimator.gotoAndPlay("standing");
               break;
            case 932:
               this.person.bodyAnimator.gotoAndPlay("standing");
         }
      }
   }
}

