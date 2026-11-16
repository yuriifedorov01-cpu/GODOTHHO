package com.game_objects.extensions
{
   import com.game_objects.*;
   import com.game_objects.enemies.*;
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.math.*;
   import com.sound.*;
   import com.stats.*;
   import com.utilities.*;
   import com.visual_effects.*;
   import flash.display.*;
   import flash.geom.*;
   import starling.*;
   
   public class MoveHandler
   {
      
      private static const lightBeam_data:LightBeamData = new LightBeamData();
      
      private var person:Person;
      
      private var gameMain:GameMain;
      
      public var chainedEnemies:uint = 0;
      
      public var lightBeam_bitmap:Bitmap;
      
      public function MoveHandler(param1:Person, param2:GameMain)
      {
         super();
         this.person = param1;
         this.gameMain = param2;
      }
      
      public function get isIdleOrJumping() : Boolean
      {
         return this.person.isFrameLabel("standing","running","jumping","pet standing","pet walking","pet jumping");
      }
      
      private function resetAttack() : void
      {
         this.person.attackCounter = 0;
         this.person.lastAttack = this.person.bodyAnimator.currentLabel;
         this.chainedEnemies = 0;
      }
      
      public function doWarriorOneWeapon() : Boolean
      {
         if(Boolean(MoveStat.isAttackingFrame(this.person)) && this.person.isFrameLabel(Moves.BASIC_ONE_WARRIOR1,Moves.BASIC_ONE_WARRIOR2,Moves.BASIC_ONE_WARRIOR3,Moves.PET_ONE_WARRIOR1,Moves.PET_ONE_WARRIOR2) == false)
         {
            return false;
         }
         if(this.person.attackCounter > Person.ATTACK_RESET_TIME)
         {
            if(this.person.ridingPet == null)
            {
               this.person.bodyAnimator.gotoAndPlay(Moves.BASIC_ONE_WARRIOR1);
            }
            else
            {
               this.person.bodyAnimator.gotoAndPlay(Moves.PET_ONE_WARRIOR1);
               if(this.person.bodyAnimator.pet.currentLabel != "standing")
               {
                  this.person.bodyAnimator.pet.gotoAndPlayStanding();
               }
            }
            this.resetAttack();
            SoundManager.playSound(SoundLibrary.swoosh1_sound,this.person.x,this.person.y,true,this.person.parent);
         }
         else if(this.person.lastAttack == Moves.BASIC_ONE_WARRIOR1 && this.person.attackCounter >= Moves.moveByName(Moves.BASIC_ONE_WARRIOR1).earliestCombo || this.person.lastAttack == Moves.PET_ONE_WARRIOR1 && this.person.attackCounter >= Moves.moveByName(Moves.PET_ONE_WARRIOR1).earliestCombo)
         {
            if(this.person.ridingPet == null)
            {
               if(Stats.wStats[this.person.bodyAnimator.weaponString].isMagic == false)
               {
                  this.person.bodyAnimator.gotoAndPlay(Moves.BASIC_ONE_WARRIOR2);
               }
               else
               {
                  this.person.bodyAnimator.gotoAndPlay(Moves.BASIC_ONE_MAGE2);
               }
            }
            else
            {
               this.person.bodyAnimator.gotoAndPlay(Moves.PET_ONE_WARRIOR2);
               if(this.person.bodyAnimator.pet.currentLabel != "standing")
               {
                  this.person.bodyAnimator.pet.gotoAndPlayStanding();
               }
            }
            this.resetAttack();
            SoundManager.playSound(SoundLibrary.swoosh2_sound,this.person.x,this.person.y,true,this.person.parent);
         }
         else
         {
            if(!(this.person.lastAttack == Moves.BASIC_ONE_WARRIOR2 && this.person.attackCounter >= Moves.moveByName(Moves.BASIC_ONE_WARRIOR2).earliestCombo))
            {
               return false;
            }
            this.person.bodyAnimator.gotoAndPlay(Moves.BASIC_ONE_WARRIOR3);
            this.person.gravityObject.velY -= 13;
            this.resetAttack();
            SoundManager.playSound(SoundLibrary.swoosh3_sound,this.person.x,this.person.y,true,this.person.parent);
         }
         return true;
      }
      
      public function doWarriorTwoWeapons() : Boolean
      {
         if(Boolean(MoveStat.isAttackingFrame(this.person)) && this.person.isFrameLabel(Moves.BASIC_TWO_WARRIOR1,Moves.BASIC_TWO_WARRIOR2,Moves.BASIC_TWO_WARRIOR3,Moves.PET_TWO_WARRIOR1,Moves.PET_TWO_WARRIOR2) == false)
         {
            return false;
         }
         if(this.person.attackCounter > Person.ATTACK_RESET_TIME)
         {
            if(this.person.ridingPet == null)
            {
               this.person.bodyAnimator.gotoAndPlay(Moves.BASIC_TWO_WARRIOR1);
            }
            else
            {
               this.person.bodyAnimator.gotoAndPlay(Moves.PET_TWO_WARRIOR1);
               this.person.bodyAnimator.pet.gotoAndPlayStanding();
            }
            this.resetAttack();
            SoundManager.playSound(SoundLibrary.swoosh1_sound,this.person.x,this.person.y,true,this.person.parent);
         }
         else if(this.person.lastAttack == Moves.BASIC_TWO_WARRIOR1 && this.person.attackCounter >= Moves.moveByName(Moves.BASIC_TWO_WARRIOR1).earliestCombo || this.person.lastAttack == Moves.PET_TWO_WARRIOR1 && this.person.attackCounter >= Moves.moveByName(Moves.PET_TWO_WARRIOR1).earliestCombo)
         {
            if(this.person.ridingPet == null)
            {
               this.person.bodyAnimator.gotoAndPlay(Moves.BASIC_TWO_WARRIOR2);
            }
            else
            {
               this.person.bodyAnimator.gotoAndPlay(Moves.PET_TWO_WARRIOR2);
               this.person.bodyAnimator.pet.gotoAndPlayStanding();
            }
            this.resetAttack();
            SoundManager.playSound(SoundLibrary.swoosh2_sound,this.person.x,this.person.y,true,this.person.parent);
         }
         else
         {
            if(!(this.person.lastAttack == Moves.BASIC_TWO_WARRIOR2 && this.person.attackCounter >= Moves.moveByName(Moves.BASIC_TWO_WARRIOR2).earliestCombo))
            {
               return false;
            }
            this.person.bodyAnimator.gotoAndPlay(Moves.BASIC_TWO_WARRIOR3);
            this.resetAttack();
            SoundManager.playSound(SoundLibrary.swoosh3_sound,this.person.x,this.person.y,true,this.person.parent);
         }
         return true;
      }
      
      public function doWarriorShield() : Boolean
      {
         if(Boolean(MoveStat.isAttackingFrame(this.person)) && this.person.isFrameLabel(Moves.BASIC_SHIELD_WARRIOR1,Moves.BASIC_SHIELD_WARRIOR2,Moves.BASIC_SHIELD_WARRIOR3,Moves.PET_SHIELD_WARRIOR1,Moves.PET_SHIELD_WARRIOR2) == false)
         {
            return false;
         }
         if(this.person.attackCounter > Person.ATTACK_RESET_TIME)
         {
            if(this.person.ridingPet == null)
            {
               this.person.bodyAnimator.gotoAndPlay(Moves.BASIC_SHIELD_WARRIOR1);
            }
            else
            {
               this.person.bodyAnimator.gotoAndPlay(Moves.PET_SHIELD_WARRIOR1);
               this.person.bodyAnimator.pet.gotoAndPlayStanding();
            }
            this.resetAttack();
            SoundManager.playSound(SoundLibrary.swoosh2_sound,this.person.x,this.person.y,true,this.person.parent);
         }
         else if(this.person.lastAttack == Moves.BASIC_SHIELD_WARRIOR1 && this.person.attackCounter >= Moves.moveByName(Moves.BASIC_SHIELD_WARRIOR1).earliestCombo || this.person.lastAttack == Moves.PET_SHIELD_WARRIOR1 && this.person.attackCounter >= Moves.moveByName(Moves.PET_SHIELD_WARRIOR1).earliestCombo)
         {
            if(this.person.ridingPet == null)
            {
               this.person.bodyAnimator.gotoAndPlay(Moves.BASIC_SHIELD_WARRIOR2);
            }
            else
            {
               this.person.bodyAnimator.gotoAndPlay(Moves.PET_SHIELD_WARRIOR2);
               this.person.bodyAnimator.pet.gotoAndPlayStanding();
            }
            this.resetAttack();
            SoundManager.playSound(SoundLibrary.swoosh3_sound,this.person.x,this.person.y,true,this.person.parent);
         }
         else
         {
            if(!(this.person.lastAttack == Moves.BASIC_SHIELD_WARRIOR2 && this.person.attackCounter >= Moves.moveByName(Moves.BASIC_SHIELD_WARRIOR2).earliestCombo))
            {
               return false;
            }
            this.person.bodyAnimator.gotoAndPlay(Moves.BASIC_SHIELD_WARRIOR3);
            this.resetAttack();
            SoundManager.playSound(SoundLibrary.swoosh1_sound,this.person.x,this.person.y,true,this.person.parent);
         }
         return true;
      }
      
      public function doArcherShoot() : Boolean
      {
         if(MoveStat.isAttackingFrame(this.person))
         {
            return false;
         }
         this.person.projAttackType = "basic";
         if(this.person.ridingPet == null)
         {
            this.person.bodyAnimator.gotoAndPlay("shoot bow");
         }
         else
         {
            this.person.bodyAnimator.gotoAndPlay("pet shoot bow");
            if(this.person.bodyAnimator.pet.currentLabel != "standing")
            {
               this.person.bodyAnimator.pet.gotoAndPlayStanding();
            }
         }
         this.resetAttack();
         return true;
      }
      
      public function doShootGun() : Boolean
      {
         if(MoveStat.isAttackingFrame(this.person))
         {
            return false;
         }
         if(this.person.ridingPet == null)
         {
            this.person.bodyAnimator.gotoAndPlay(Moves.BASIC_SHOOT_COWBOY);
         }
         else
         {
            this.person.bodyAnimator.gotoAndPlay(Moves.PET_SHOOT_COWBOY);
            this.person.bodyAnimator.pet.gotoAndPlayStanding();
         }
         this.person.projAttackType = "basic";
         this.resetAttack();
         return true;
      }
      
      public function doGroundStab() : Boolean
      {
         if(MoveStat.isAttackingFrame(this.person) == false || this.person.attackCounter < 3)
         {
            this.person.MP -= this.person.levelMP(Person.MULTI_ATTACK_MP);
            if(this.person.isPlayer)
            {
               this.gameMain.theConnection.send("useMP",this.person.levelMP(Person.MULTI_ATTACK_MP));
            }
            this.person.gravityObject.velY = 0;
            this.person.y = this.person.gravityObject.previousY;
            this.person.bodyAnimator.gotoAndPlay("ground stab");
            this.resetAttack();
            return true;
         }
         return false;
      }
      
      public function doGroundStabDone(param1:GameMain) : void
      {
         if(CommonCalls.onScreen(this.person.x,this.person.y,true,true))
         {
            param1.createYellowExplosion(this.person.x,this.person.y + 51,0.2 + this.person.frameHandler.releasedCharge / 40);
            StarExplosion.createExplosion(this.person.x,this.person.y + 51,8,100 + this.person.frameHandler.releasedCharge * 4,100 + this.person.frameHandler.releasedCharge * 5,MainStarlingStage(this.person.root).c_mc,StarExplosion.DIR_UP);
            Shake.startShake(this.gameMain.starlingStage.c_mc,11,4);
            SoundManager.playSound(SoundLibrary.sciFiExplosion_sound,this.person.x,this.person.y,true,this.person.parent);
         }
      }
      
      public function doMagicUpAttack() : Boolean
      {
         if(MoveStat.isAttackingFrame(this.person) == false || this.person.attackCounter < 3)
         {
            if(this.person.bodyAnimator.currentLabel != Moves.SUMMON_BEAM)
            {
               this.person.MP -= this.person.levelMP(Person.LIGHT_BEAM_MP);
               if(this.person.isPlayer)
               {
                  this.gameMain.theConnection.send("useMP",this.person.levelMP(Person.LIGHT_BEAM_MP));
               }
            }
            this.person.gravityObject.velY = 0;
            this.person.y = this.person.gravityObject.previousY;
            this.person.bodyAnimator.gotoAndPlay(Moves.SUMMON_BEAM);
            this.resetAttack();
            return true;
         }
         return false;
      }
      
      public function doWarriorUpAttack() : Boolean
      {
         if(this.person.gravityObject.jumps - 1 < this.person.gravityObject.maxJumps && (MoveStat.isAttackingFrame(this.person) == false || this.person.attackCounter < 3))
         {
            if(this.person.bodyAnimator.currentLabel != Moves.SPIN_ATTACK)
            {
               this.person.MP -= this.person.levelMP(Person.SPIN_ATTACK_MP);
               if(this.person.isPlayer)
               {
                  this.gameMain.theConnection.send("useMP",this.person.levelMP(Person.SPIN_ATTACK_MP));
               }
            }
            ++this.person.gravityObject.jumps;
            this.person.gravityObject.velY = -13;
            this.person.bodyAnimator.gotoAndPlay(Moves.SPIN_ATTACK);
            this.resetAttack();
            return true;
         }
         return false;
      }
      
      public function doArcherRainAttack() : Boolean
      {
         if(MoveStat.isAttackingFrame(this.person) == false || this.person.attackCounter < 3)
         {
            this.person.gravityObject.velY = 0;
            this.person.y = this.person.gravityObject.previousY;
            this.person.bodyAnimator.gotoAndPlay(Moves.ARROW_RAIN);
            this.resetAttack();
            return true;
         }
         return false;
      }
      
      public function doCowboyUpShoot() : Boolean
      {
         if(MoveStat.isAttackingFrame(this.person) == false || this.person.attackCounter < 3)
         {
            if(this.person.bodyAnimator.currentLabel != Moves.GUN_SHOOT_UP)
            {
               this.person.MP -= this.person.levelMP(Person.GUN_UPWARD_MP);
               if(this.person.isPlayer)
               {
                  this.gameMain.theConnection.send("useMP",this.person.levelMP(Person.GUN_UPWARD_MP));
               }
            }
            this.person.gravityObject.velY = 0;
            this.person.y = this.person.gravityObject.previousY;
            this.person.bodyAnimator.gotoAndPlay(Moves.GUN_SHOOT_UP);
            this.resetAttack();
            this.person.conBulletsShot = 0;
            return true;
         }
         return false;
      }
      
      public function doArcherDownStab() : Boolean
      {
         if(MoveStat.isAttackingFrame(this.person) == false || this.person.attackCounter < 3)
         {
            this.person.MP -= this.person.levelMP(Person.DOWN_CRUSH_MP);
            if(this.person.isPlayer)
            {
               this.gameMain.theConnection.send("useMP",this.person.levelMP(Person.DOWN_CRUSH_MP));
            }
            this.person.bodyAnimator.gotoAndPlay(Moves.DOWN_STAB);
            this.person.gravityObject.accelDownMultiplier = 4;
            SoundManager.playSound(SoundLibrary.swoosh3_sound,this.person.x,this.person.y,true,this.person.parent);
            this.resetAttack();
            return true;
         }
         return false;
      }
      
      public function doWarriorDownSlash() : Boolean
      {
         if(MoveStat.isAttackingFrame(this.person) == false || this.person.attackCounter < 3)
         {
            this.person.MP -= this.person.levelMP(Person.AIR_SLASH_MP);
            if(this.person.isPlayer)
            {
               this.gameMain.theConnection.send("useMP",this.person.levelMP(Person.AIR_SLASH_MP));
            }
            this.person.bodyAnimator.gotoAndPlay(Moves.DOWN_SLASH);
            this.person.gravityObject.accelDownMultiplier = 4;
            this.resetAttack();
            return true;
         }
         return false;
      }
      
      public function archerDownStabDone() : void
      {
         this.person.bodyAnimator.play();
         if(CommonCalls.onScreen(this.person.x,this.person.y,false,true))
         {
            this.gameMain.createProjectile(this.person.x,this.person.y,this.person.name,-1);
            this.gameMain.createProjectile(this.person.x,this.person.y,this.person.name,1);
            this.gameMain.createProjectile(this.person.x,this.person.y,this.person.name,-1,false,0.4).gravityObject.velY = -10;
            this.gameMain.createProjectile(this.person.x,this.person.y,this.person.name,1,false,0.4).gravityObject.velY = -10;
            Shake.startShake(this.gameMain.starlingStage.c_mc,11,3);
            StarExplosion.createExplosion(this.person.x,this.person.y + 51,6,100,100,MainStarlingStage(this.person.root).c_mc,StarExplosion.DIR_UP);
            SoundManager.playSound(SoundLibrary.sciFiExplosion_sound,this.person.x,this.person.y,true,this.person.parent);
         }
      }
      
      public function warriorDownSlashDone() : void
      {
         this.person.bodyAnimator.play();
         if(CommonCalls.onScreen(this.person.x,this.person.y,false,true))
         {
            Shake.startShake(this.gameMain.starlingStage.c_mc,11,3);
            StarExplosion.createExplosion(this.person.x + this.person.scaleX * 75,this.person.y + 51,6,100,100,MainStarlingStage(this.person.root).c_mc,StarExplosion.DIR_UP);
            SoundManager.playSound(SoundLibrary.sciFiExplosion_sound,this.person.x,this.person.y,true,this.person.parent);
         }
      }
      
      public function doWarriorForwardCharge() : Boolean
      {
         if(MoveStat.isAttackingFrame(this.person) == false || this.person.attackCounter < 3)
         {
            if(this.person.bodyAnimator.currentLabel != Moves.LUNGE_ATTACK)
            {
               this.person.MP -= this.person.levelMP(Person.POWER_ATTACK_MP);
               if(this.person.isPlayer)
               {
                  this.gameMain.theConnection.send("useMP",this.person.levelMP(Person.POWER_ATTACK_MP));
               }
            }
            this.person.bodyAnimator.gotoAndPlay(Moves.LUNGE_ATTACK);
            this.resetAttack();
            return true;
         }
         return false;
      }
      
      public function doCowbowAirGrenade() : Boolean
      {
         var _loc1_:Item = null;
         if(this.person.gravityObject.jumps < this.person.gravityObject.maxJumps + 1)
         {
            ++this.person.gravityObject.jumps;
            this.person.MP -= this.person.levelMP(Person.JUMP_GRENADE_MP);
            if(this.person.isPlayer)
            {
               this.gameMain.theConnection.send("useMP",this.person.levelMP(Person.JUMP_GRENADE_MP));
            }
            _loc1_ = this.gameMain.createItem("grenade" + int(Math.random() * 99999),this.person.x,this.person.y,"grenade",0,"-none-");
            _loc1_.creatorName = this.person.name;
            this.person.bodyAnimator.gotoAndPlay("jumping");
            this.person.gravityObject.accelDownMultiplier = 0;
            this.person.gravityObject.velY = -10;
            this.resetAttack();
         }
         return true;
      }
      
      public function doPiercingArrow() : Boolean
      {
         if(MoveStat.isAttackingFrame(this.person) == false || this.person.attackCounter < 3)
         {
            this.person.projAttackType = "piercing";
            this.person.bodyAnimator.gotoAndPlay(Moves.BASIC_SHOOT_ARCHER);
            this.resetAttack();
            return true;
         }
         return false;
      }
      
      public function doTripleArrow() : Boolean
      {
         if(MoveStat.isAttackingFrame(this.person) == false || this.person.attackCounter < 3)
         {
            this.person.bodyAnimator.gotoAndPlay("triple shot");
            this.resetAttack();
            return true;
         }
         return false;
      }
      
      public function doShotgunAttack() : Boolean
      {
         if(MoveStat.isAttackingFrame(this.person) == false || this.person.attackCounter < 3)
         {
            this.person.projAttackType = "shotgun";
            this.person.bodyAnimator.gotoAndPlay(Moves.BASIC_SHOOT_COWBOY);
            this.resetAttack();
            return true;
         }
         return false;
      }
      
      public function doGrenadeAttack() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:Item = null;
         if(MoveStat.isAttackingFrame(this.person) == false || this.person.attackCounter < 3)
         {
            this.person.MP -= this.person.levelMP(Person.GRENADE_MP);
            if(this.person.isPlayer)
            {
               this.gameMain.theConnection.send("useMP",this.person.levelMP(Person.GRENADE_MP));
            }
            _loc1_ = 0;
            while(_loc1_ < this.person.grenadeLvl - 1)
            {
               _loc2_ = this.gameMain.createItem("grenade" + int(Math.random() * 99999),this.person.x,this.person.y,"grenade",0,"-none-");
               _loc2_.creatorName = this.person.name;
               switch(_loc1_)
               {
                  case 0:
                     _loc2_.gravityObject.velX = this.person.moveDir * 15;
                     _loc2_.gravityObject.velY = -20;
                     break;
                  case 1:
                     _loc2_.gravityObject.velX = -this.person.moveDir * 15;
                     _loc2_.gravityObject.velY = -20;
                     break;
                  case 2:
                     _loc2_.gravityObject.velX = this.person.moveDir * 8;
                     _loc2_.gravityObject.velY = -13;
                     break;
                  case 3:
                     _loc2_.gravityObject.velX = -this.person.moveDir * 8;
                     _loc2_.gravityObject.velY = -13;
                     break;
                  case 4:
                     _loc2_.gravityObject.velX = this.person.moveDir * 4;
                     _loc2_.gravityObject.velY = -10;
                     break;
                  case 5:
                     _loc2_.gravityObject.velX = -this.person.moveDir * 4;
                     _loc2_.gravityObject.velY = -10;
               }
               _loc1_++;
            }
            this.person.bodyAnimator.play();
            this.resetAttack();
            return true;
         }
         return false;
      }
      
      public function doSummonLightning() : Boolean
      {
         if(MoveStat.isAttackingFrame(this.person) == false || this.person.attackCounter < 3)
         {
            this.person.MP -= this.person.levelMP(Person.THUNDER_MP);
            if(this.person.isPlayer)
            {
               this.gameMain.theConnection.send("useMP",this.person.levelMP(Person.THUNDER_MP));
            }
            this.person.bodyAnimator.gotoAndPlay(Moves.SUMMON_THUNDER);
            this.resetAttack();
            return true;
         }
         return false;
      }
      
      public function doPetSummonFoward() : Boolean
      {
         if(MoveStat.isAttackingFrame(this.person) == false || this.person.attackCounter < 3)
         {
            if(Boolean(this.person.isPlayer) && this.person.bodyAnimator.currentLabel != Moves.PET_FORWARD_SUMMON)
            {
               this.gameMain.theConnection.send("doSummonPetFwd");
            }
            this.person.bodyAnimator.gotoAndPlay(Moves.PET_FORWARD_SUMMON);
            this.person.bodyAnimator.pet.gotoAndPlayStanding();
            this.resetAttack();
            return true;
         }
         return false;
      }
      
      public function summonThunderMagic() : void
      {
         var _loc1_:Enemy = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Person = null;
         var _loc5_:Cloud = null;
         var _loc6_:LightningBolt = null;
         var _loc7_:Number = Number(NaN);
         var _loc8_:Number = Number(NaN);
         var _loc9_:Array = new Array();
         if(this.gameMain.isPvpArea)
         {
            for each(_loc4_ in this.gameMain.p_array)
            {
               if(_loc4_.health > 0)
               {
                  _loc9_.push(_loc4_);
               }
            }
            for each(_loc1_ in this.gameMain.e_array)
            {
               _loc9_.push(_loc1_);
            }
         }
         else
         {
            for each(_loc1_ in this.gameMain.e_array)
            {
               _loc9_.push(_loc1_);
            }
         }
         _loc2_ = int(_loc9_.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc9_[_loc3_].distanceFromCaster = CalcDist.getDistNumbers(_loc9_[_loc3_].x,_loc9_[_loc3_].y,this.person.x,this.person.y);
            _loc3_++;
         }
         _loc9_.sortOn("distanceFromCaster");
         var _loc10_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(_loc10_ < Math.ceil(this.person.thunderAttackLvl * (this.person.frameHandler.releasedCharge / 40)) && CalcDist.getDistNumbers(_loc9_[_loc3_].x,_loc9_[_loc3_].y,this.person.x,this.person.y) < 500 && _loc9_[_loc3_].name != this.person.name)
            {
               if(!(this.gameMain.c_mc.currentFrame == 114 && _loc9_[_loc3_] is Person && _loc9_[_loc3_].guild == this.person.guild))
               {
                  _loc10_++;
                  this.gameMain.stormCloud_color.brightness = -0.65;
                  _loc5_ = new Cloud();
                  _loc5_.x = _loc9_[_loc3_].x;
                  _loc5_.y = _loc9_[_loc3_].y - 160;
                  _loc5_.scaleX = _loc5_.scaleY = 0.7;
                  _loc5_.cacheAsBitmap = true;
                  _loc5_.mouseChildren = false;
                  _loc5_.mouseEnabled = false;
                  _loc5_.gotoAndStop(Math.ceil(Math.random() * 3));
                  _loc5_.transform.colorTransform = this.gameMain.stormCloud_color;
                  _loc5_.alpha = 0.9;
                  _loc5_.counter = 0;
                  _loc5_.targetObject = _loc9_[_loc3_];
                  this.gameMain.stormCloud_array.push(_loc5_);
                  MainStarlingStage(this.person.root).gameMain.c_mc.addChild(_loc5_);
                  _loc6_ = new LightningBolt();
                  _loc6_.x = _loc9_[_loc3_].x;
                  _loc6_.y = _loc9_[_loc3_].y;
                  _loc6_.mouseChildren = false;
                  _loc6_.mouseEnabled = false;
                  _loc6_.counter = 0;
                  _loc6_.targetEnemy = _loc9_[_loc3_];
                  this.gameMain.lightningBolt_array.push(_loc6_);
                  MainStarlingStage(this.person.root).gameMain.c_mc.addChildAt(_loc6_,MainStarlingStage(this.person.root).gameMain.c_mc.getChildIndex(_loc5_) - 1);
                  if(CommonCalls.onScreen(_loc9_[_loc3_].x,_loc9_[_loc3_].y,false,true))
                  {
                     FlashShock.flashShockObject(_loc9_[_loc3_]);
                  }
                  if(_loc10_ < 2)
                  {
                     SoundManager.playSound(SoundLibrary.electric_sound,_loc9_[_loc3_].x,_loc9_[_loc3_].y,true,this.person.parent);
                  }
                  if(_loc9_[_loc3_] is Enemy)
                  {
                     if(this.person.isPlayer)
                     {
                        _loc7_ = Number(MoveTo.getDirX(Moves.moveByName(Moves.SUMMON_THUNDER).knockback,Moves.moveByName(Moves.SUMMON_THUNDER).hitRot));
                        _loc8_ = Number(MoveTo.getDirY(Moves.moveByName(Moves.SUMMON_THUNDER).knockback,Moves.moveByName(Moves.SUMMON_THUNDER).hitRot));
                        if(_loc9_[_loc3_] is Person)
                        {
                           _loc7_ = Number(_loc9_[_loc3_].getWeightEffectVel(_loc7_));
                           _loc8_ = Number(_loc9_[_loc3_].getWeightEffectVel(_loc8_));
                           _loc9_[_loc3_].velX += _loc7_;
                           _loc9_[_loc3_].velY += _loc8_;
                        }
                        else
                        {
                           _loc7_ = Number(_loc9_[_loc3_].gravityObject.getWeightEffectVel(_loc7_));
                           _loc8_ = Number(_loc9_[_loc3_].gravityObject.getWeightEffectVel(_loc8_));
                           _loc9_[_loc3_].gravityObject.velX += _loc7_;
                           _loc9_[_loc3_].gravityObject.velY += _loc8_;
                        }
                        this.gameMain.theConnection.send("dmgE",_loc9_[_loc3_].name,Stats.wStats[this.person.bodyAnimator.weaponString].defense > 0,"thunder",_loc7_,_loc8_,_loc9_[_loc3_].x,_loc9_[_loc3_].y);
                        this.gameMain.lastEnemyNameHit = _loc9_[_loc3_].name;
                     }
                  }
                  else if(_loc9_[_loc3_] is Person && Boolean(Person(_loc9_[_loc3_]).isPlayer) && _loc9_[_loc3_].health > 0)
                  {
                     this.gameMain.theConnection.send("PdmgP",this.person.name,Stats.wStats[this.person.bodyAnimator.weaponString].defense > 0,"thunder",this.gameMain.player.bodyAnimator.currentLabel == "block");
                  }
               }
            }
            _loc3_++;
         }
         var _loc11_:Point = new Point(this.person.x,this.person.y);
         _loc11_ = this.person.parent.localToGlobal(_loc11_);
         var _loc12_:DarknessBall = new DarknessBall();
         _loc12_.x = _loc11_.x;
         _loc12_.y = _loc11_.y;
         _loc12_.scaleX = _loc12_.scaleY = this.person.thunderAttackLvl / Stats.skillStats["thunder attack"].maxLvl * (this.person.frameHandler.releasedCharge / 40);
         _loc12_.mouseChildren = false;
         _loc12_.mouseEnabled = false;
         _loc12_.cacheAsBitmap = true;
         this.gameMain.addChildAt(_loc12_,this.gameMain.getChildIndex(this.gameMain.c_mc) + 1);
         TweenMax.to(_loc12_,1,{
            "alpha":0,
            "delay":0.7,
            "onComplete":CommonCalls.removeObject,
            "onCompleteParams":[_loc12_]
         });
         if(_loc10_ > 0)
         {
            SoundManager.playSound(SoundLibrary.thunder_sound,this.person.x,this.person.y,true,this.person.parent);
         }
      }
      
      public function summonLightBeam() : void
      {
         if(CommonCalls.onScreen(this.person.x,this.person.y,true,true))
         {
            this.lightBeam_bitmap = new Bitmap(MoveHandler.lightBeam_data);
            this.lightBeam_bitmap.scaleY = this.person.lightBeamLvl / 6;
            this.lightBeam_bitmap.x = this.person.x - this.lightBeam_bitmap.width / 2;
            this.lightBeam_bitmap.y = this.person.y - this.lightBeam_bitmap.height + 45;
            MainStarlingStage(this.person.root).gameMain.c_mc.addChild(this.lightBeam_bitmap);
            TweenLite.to(this.lightBeam_bitmap,1,{
               "alpha":0,
               "delay":0.2,
               "ease":Linear.easeNone,
               "onComplete":CommonCalls.removeObject,
               "onCompleteParams":[this.lightBeam_bitmap]
            });
            SoundManager.playSound(SoundLibrary.lightBeam_sound,this.person.x,this.person.y,true,this.person.parent);
         }
      }
      
      public function createArrowRain() : void
      {
         var _loc1_:Projectile = null;
         var _loc2_:Projectile = null;
         var _loc3_:Projectile = null;
         var _loc4_:Projectile = null;
         var _loc5_:Projectile = null;
         var _loc6_:Projectile = null;
         var _loc7_:int = 0;
         while(_loc7_ < Math.ceil(this.person.arrowRainLvl * (this.person.frameHandler.releasedCharge / 40)))
         {
            switch(_loc7_)
            {
               case 0:
                  _loc1_ = this.gameMain.createProjectile(this.person.x,this.person.y,this.person.name,this.person.scaleX,false,0.16);
                  _loc1_.gravityObject.velY = -23;
                  _loc1_.gravityObject.velX /= 9;
                  _loc1_.lifeSpan += 30;
                  break;
               case 1:
                  _loc2_ = this.gameMain.createProjectile(this.person.x,this.person.y,this.person.name,this.person.scaleX,false,0.2);
                  _loc2_.gravityObject.velY = -19;
                  _loc2_.gravityObject.velX /= 1.8;
                  _loc2_.lifeSpan += 30;
                  break;
               case 2:
                  _loc3_ = this.gameMain.createProjectile(this.person.x,this.person.y,this.person.name,this.person.scaleX,false,0.18);
                  _loc3_.gravityObject.velY = -21;
                  _loc3_.gravityObject.velX /= 3.5;
                  _loc3_.lifeSpan += 30;
                  break;
               case 3:
                  _loc4_ = this.gameMain.createProjectile(this.person.x,this.person.y,this.person.name,this.person.scaleX,false,0.2);
                  _loc4_.gravityObject.velY = -19;
                  _loc4_.gravityObject.velX /= 1.8 * -1;
                  _loc4_.lifeSpan += 30;
                  break;
               case 4:
                  _loc5_ = this.gameMain.createProjectile(this.person.x,this.person.y,this.person.name,this.person.scaleX,false,0.18);
                  _loc5_.gravityObject.velY = -21;
                  _loc5_.gravityObject.velX /= 3.5 * -1;
                  _loc5_.lifeSpan += 30;
                  break;
               case 5:
                  _loc6_ = this.gameMain.createProjectile(this.person.x,this.person.y,this.person.name,this.person.scaleX,false,0.16);
                  _loc6_.gravityObject.velY = -23;
                  _loc6_.gravityObject.velX /= 9 * -1;
                  _loc6_.lifeSpan += 30;
            }
            _loc7_++;
         }
      }
      
      public function getWeaponSkillKnockback(param1:Boolean = true) : uint
      {
         if(param1)
         {
            if(Stats.wStats[this.person.bodyAnimator.weaponString].isMagic)
            {
               return this.person.magicDistanceLvl;
            }
            if(Stats.wStats[this.person.bodyAnimator.weaponString].sRate > 0)
            {
               return this.person.bulletKnockbackLvl;
            }
            if(Stats.wStats[this.person.bodyAnimator.weaponString].isRange)
            {
               return this.person.arrowKnockbackLvl;
            }
            return this.person.meleeKnockbackLvl;
         }
         if(Stats.wStats[this.person.bodyAnimator.weapon2String].isMagic)
         {
            return this.person.magicDistanceLvl;
         }
         if(Stats.wStats[this.person.bodyAnimator.weapon2String].sRate > 0)
         {
            return this.person.bulletKnockbackLvl;
         }
         if(Stats.wStats[this.person.bodyAnimator.weapon2String].isRange)
         {
            return this.person.arrowKnockbackLvl;
         }
         return this.person.meleeKnockbackLvl;
      }
   }
}

