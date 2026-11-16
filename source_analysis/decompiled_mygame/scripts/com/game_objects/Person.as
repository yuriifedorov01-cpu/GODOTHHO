package com.game_objects
{
   import com.apis.*;
   import com.game_objects.enemies.Enemy;
   import com.game_objects.extensions.*;
   import com.game_objects.hit_detect.*;
   import com.game_objects.power_up_effects.*;
   import com.gravityPackage.*;
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.lighting.*;
   import com.math.*;
   import com.menus.add_ons.*;
   import com.sound.*;
   import com.stats.*;
   import com.ui.*;
   import com.utilities.*;
   import com.visual_effects.*;
   import flash.geom.*;
   import flash.ui.*;
   import flash.utils.*;
   import starling.*;
   import starling.display.*;
   import starling.events.*;
   import starling.filters.*;
   import starling.text.*;
   import starling.textures.Texture;
   import starling.utils.*;
   
   public final class Person extends Sprite implements IClickable, IGravityObject
   {
      
      public static const BLOCK_MP:int = 2;
      
      public static const RAGE_MP:int = 35;
      
      public static const GUILD_RAGE_MP:int = 45;
      
      public static const ARROW_BARRAGE_MP:int = 7;
      
      public static const ARROW_TRIPLE_MP:int = 8;
      
      public static const ARROW_RAIN_MP:int = 9;
      
      public static const ARROW_PIERCE_MP:int = 6;
      
      public static const DOWN_CRUSH_MP:int = 3;
      
      public static const POWER_ATTACK_MP:int = 6;
      
      public static const MULTI_ATTACK_MP:int = 8;
      
      public static const AIR_SLASH_MP:int = 6;
      
      public static const SPIN_ATTACK_MP:int = 5;
      
      public static const LIGHT_BEAM_MP:* = 10;
      
      public static const THUNDER_MP:int = 23;
      
      public static const HEAL_MP:int = 15;
      
      public static const GUILD_HEAL_MP:int = 19;
      
      public static const GRENADE_MP:int = 50;
      
      public static const GUN_UPWARD_MP:int = 2;
      
      public static const SHOTGUN_MP:int = 50;
      
      public static const JUMP_GRENADE_MP:int = 5;
      
      public static const SUMMON_PET_FWD:int = 15;
      
      public static const DASH_MP:int = 3;
      
      public static const ATTACK_RESET_TIME:int = 22;
      
      private static const DUAL_GUNS_array:Vector.<String> = new <String>["airsoft gun","paintball gun","handgun","revolver","mac10","mp5","tommy gun","es c90","beholder gun","corruptor"];
      
      public var fishingLine:FishingLine;
      
      private var global_point:Point = new Point();
      
      public var pet_array:Vector.<Pet> = new Vector.<Pet>();
      
      public var password:String = "";
      
      private var __guild:String = "";
      
      public var role:String = "";
      
      public var projAttackType:String = "basic";
      
      public var lastAttack:String = "";
      
      public var canDamage:Boolean = true;
      
      public var awaitingSave:Boolean = false;
      
      public var inGuildRage:Boolean = false;
      
      public var hasHalo:Boolean = false;
      
      public var npc:Boolean = false;
      
      public var hasOrbFocus:Boolean = false;
      
      private var __isControllingPet:Boolean = false;
      
      public var isControllingEnemy:Boolean = false;
      
      private var __isPlayer:Boolean = false;
      
      public var jumpedWhileDashing:Boolean = false;
      
      public var attackCounter:int = 0;
      
      public var flaps:int = 0;
      
      public var bottomY:int = 0;
      
      public var dex:int = 0;
      
      public var defense:int = 0;
      
      public var range:int = 0;
      
      public var artillery:int = 0;
      
      public var magic:int = 0;
      
      public var skillPoints:int = 0;
      
      public var lev:int = 1;
      
      public var money:uint = 0;
      
      public var currentLevelXP:int = 0;
      
      public var abilityPoints:int = 0;
      
      public var ping:int = 0;
      
      public var power:int = 0;
      
      public var lastBroadcastX:Number = 0;
      
      public var lastBroadcastY:Number = 0;
      
      public var distanceFromCaster:int = 0;
      
      private var i:int = 0;
      
      public var arrowCharge:Number = 0;
      
      public var flyCluster:FlyCluster;
      
      public var bodyAnimator:BodyAnimator;
      
      public var conBulletsShot:uint = 0;
      
      private var __fishing:Boolean;
      
      public var fishingLvl:uint = 1;
      
      public var choppingLvl:uint = 1;
      
      private var __fishXP:uint;
      
      private var __chopXP:uint;
      
      public var hasBaitExtend:Boolean = false;
      
      private var gameMain:GameMain;
      
      public var frameHandler:PersonFrameHandler;
      
      public var keyHandler:PersonKeyHandler;
      
      public var guardSymbol:GuardSymbol;
      
      public var personHackCheck:PersonHackCheck;
      
      private var __gravityObject:GravityObject;
      
      public var hitTester:HitTester;
      
      public var moveDir:int = 1;
      
      public var jumpPower:int = 10;
      
      public var moveSpeed:Number = 10;
      
      private var name_txt:TextField;
      
      public var isTweeningFilter:Boolean = false;
      
      public var energyController:EnergyController;
      
      public var powerUpVisuals:PowerUpVisuals;
      
      public var rageGlow_image:Image;
      
      private var shadow:Shadows;
      
      public var jumpSkillLvl:int = 1;
      
      public var criticalLvl:int = 1;
      
      public var lootStealLvl:int = 1;
      
      public var trainingLvl:int = 1;
      
      public var selfRageLvl:int = 1;
      
      public var guildRageLvl:int = 1;
      
      public var avoidabilityLvl:int = 1;
      
      public var mpRestoreLvl:int = 1;
      
      public var dashLvl:int = 1;
      
      public var accelDownLvl:int = 1;
      
      public var blockLvl:int = 1;
      
      public var barrageLvl:int = 1;
      
      public var arrowKnockbackLvl:int = 1;
      
      public var expertArcherLvl:int = 1;
      
      public var tripleShotLvl:int = 1;
      
      public var arrowRainLvl:int = 1;
      
      public var piercingArrowLvl:int = 1;
      
      public var downCrushLvl:int = 1;
      
      public var powerAttackLvl:int = 1;
      
      public var expertWarriorLvl:int = 1;
      
      public var chainDistanceLvl:int = 1;
      
      public var shieldMasteryLvl:int = 1;
      
      public var multiAttackLvl:int = 1;
      
      public var meleeKnockbackLvl:int = 1;
      
      public var spinAttackLvl:int = 1;
      
      public var magicShotsLvl:int = 1;
      
      public var expertWizardLvl:int = 1;
      
      public var lightBeamLvl:int = 1;
      
      public var magicDistanceLvl:int = 1;
      
      public var thunderAttackLvl:int = 1;
      
      public var selfHealLvl:int = 1;
      
      public var guildHealLvl:int = 1;
      
      public var grenadeLvl:int = 1;
      
      public var upwardShootLvl:int = 1;
      
      public var expertCowboyLvl:int = 1;
      
      public var bulletDistanceLvl:int = 1;
      
      public var shotgunLvl:int = 1;
      
      public var bulletKnockbackLvl:int = 1;
      
      public var jumpGrenadeLvl:int = 1;
      
      public function Person(param1:GameMain, param2:Boolean, param3:String)
      {
         var _loc4_:Image = null;
         super();
         this.gameMain = param1;
         this.__isPlayer = param2;
         this.personHackCheck = new PersonHackCheck(param1);
         if(param3 == "robby")
         {
            _loc4_ = new Image(Assets.items_textureAtlas.getTexture("gamemaster icon"));
            _loc4_.pivotX = _loc4_.width / 2;
            _loc4_.pivotY = _loc4_.height / 2;
            _loc4_.y = 70;
            _loc4_.touchable = false;
            addChild(_loc4_);
         }
         this.name = param3;
         var _loc5_:Rectangle = new Rectangle(-23,-36,54,84);
         this.frameHandler = new PersonFrameHandler(this,param1);
         this.keyHandler = new PersonKeyHandler(this,param1);
         this.bodyAnimator = new BodyAnimator(this,this.gameMain);
         this.__gravityObject = new GravityObject(this,_loc5_);
         this.hitTester = new HitTester(this,_loc5_);
         this.energyController = new EnergyController(this);
         this.powerUpVisuals = new PowerUpVisuals(this);
         touchGroup = true;
         addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
      }
      
      public static function removeNamePrefix(param1:String) : String
      {
         if(param1.indexOf("simple") == 0)
         {
            return param1.slice(6,param1.length);
         }
         if(param1.indexOf("facebook") == 0)
         {
            return param1.slice(8,param1.length);
         }
         if(param1.indexOf("kongregate") == 0)
         {
            return param1.slice(10,param1.length);
         }
         if(param1.indexOf("steam") == 0)
         {
            return param1.slice(5,param1.length);
         }
         if(param1.indexOf("playerio") == 0)
         {
            return param1.slice(8,param1.length);
         }
         return param1;
      }
      
      private function onAdded(param1:Event) : void
      {
         this.name_txt = new TextField(113,27,"",AllTextFormats.name_textFormat);
         this.name = name;
         this.alignNameText();
         this.name_txt.touchGroup = true;
         this.name_txt.touchable = false;
         this.name_txt.batchable = true;
         this.gameMain.starlingStage.addChildAt(this.name_txt,this.gameMain.starlingStage.getChildIndex(this.gameMain.starlingStage.controls));
         if(GameMain.lighting)
         {
            this.shadow = new Shadows(this,this.gravityObject);
         }
      }
      
      public function isDualGunWeapon(param1:String) : Boolean
      {
         return DUAL_GUNS_array.indexOf(param1) > -1;
      }
      
      private function onRemoved(param1:Event) : void
      {
         this.stopFishing();
         if(this.isPlayer)
         {
            addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
            addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
            this.name_txt.removeFromParent(true);
         }
         else
         {
            this.name_txt.removeFromParent(true);
         }
         this.bodyAnimator.onRemoved();
      }
      
      public function onEnter() : void
      {
         var _loc10_:Projectile = null;
         var _loc1_:Number = Number(NaN);
         var _loc2_:Pet = null;
         var _loc3_:Projectile = null;
         var _loc4_:Projectile = null;
         var _loc5_:Projectile = null;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         if(this.shadow != null)
         {
            this.shadow.forceHidden = this.isRidingCar();
         }
         ++this.attackCounter;
         this.hitTester.onEnterMisc();
         this.bodyAnimator.onEnter();
         this.frameHandler.onEnter();
         this.energyController.onEnter();
         this.powerUpVisuals.onEnter();
         if(this.health < 0)
         {
            this.health = 0;
         }
         if(this.isPlayer == false && Boolean(MainStarlingStage(root).gameMain.isPvpArea))
         {
            GiveHealthBar.getBarLinkedTo(this).scaleX = this.health / this.totalHealth;
         }
         if(this.isControllingPet == false && this.isControllingEnemy == false && this.isFrameLabel("ducking","take hit","pet take hit","block") == false)
         {
            _loc1_ = 0;
            for each(_loc2_ in this.activePets)
            {
               _loc1_ += Stats.petHelmetStats[_loc2_.helmet_string].speed / 115;
               _loc1_ += Stats.shoesStats[_loc2_.shoes_string].artillery / 115;
            }
            if(this.isFrameLabel("dashing","pet dashing") || this.jumpedWhileDashing)
            {
               _loc1_ += this.moveSpeed * (0.4 + this.dashLvl / 10);
            }
            if(this.keyHandler.keyStates.getKeyState(Keyboard.RIGHT).isDown && (MoveStat.isAttackingFrame(this) == false || this.__gravityObject.onGround == false && this.bodyAnimator.currentLabel != "dash attack" && this.bodyAnimator.currentLabel != "pet dash attack"))
            {
               this.moveDir = 1;
               if(this.__gravityObject.onGround)
               {
                  this.__gravityObject.velX += (this.moveSpeed + _loc1_) / 6.5;
               }
               else if(this.__gravityObject.velX < 15)
               {
                  this.__gravityObject.velX += (this.moveSpeed + _loc1_) / 13;
               }
            }
            else if(this.keyHandler.keyStates.getKeyState(Keyboard.LEFT).isDown && (MoveStat.isAttackingFrame(this) == false || this.__gravityObject.onGround == false && this.bodyAnimator.currentLabel != "dash attack" && this.bodyAnimator.currentLabel != "pet dash attack"))
            {
               this.moveDir = -1;
               if(this.__gravityObject.onGround)
               {
                  this.__gravityObject.velX -= (this.moveSpeed + _loc1_) / 6.5;
               }
               else if(this.__gravityObject.velX > -15)
               {
                  this.__gravityObject.velX -= (this.moveSpeed + _loc1_) / 13;
               }
            }
         }
         if(this.bodyAnimator.currentLabel == "attack" && this.bodyAnimator.currentFrame < 80 && this.keyHandler.cKeyDown == false || this.bodyAnimator.currentLabel == "pet attack" && this.bodyAnimator.currentFrame < 407 && this.keyHandler.cKeyDown == false || this.bodyAnimator.currentLabel == "pet attack upward" && this.bodyAnimator.currentFrame < 418 || this.bodyAnimator.currentLabel == "pet attack dual" && this.bodyAnimator.currentFrame < 432 || this.bodyAnimator.currentLabel == "pet attack dual 2" && this.bodyAnimator.currentFrame < 449 || this.bodyAnimator.currentLabel == "pet attack shield" && this.bodyAnimator.currentFrame < 461 || this.bodyAnimator.currentLabel == "pet attack shield 2" && this.bodyAnimator.currentFrame < 472 || this.bodyAnimator.currentLabel == "attack stab" && this.bodyAnimator.currentFrame < 139 || this.bodyAnimator.currentLabel == "attack upward" && this.bodyAnimator.currentFrame < 149 || this.bodyAnimator.currentLabel == "attack single" && this.bodyAnimator.currentFrame < 163 || this
         .bodyAnimator.currentLabel == "attack single stab" && this.bodyAnimator.currentFrame < 108 || this.bodyAnimator.currentLabel == "attack shield" && this.bodyAnimator.currentFrame < 121 || this.bodyAnimator.currentLabel == "attack shield upward" && this.bodyAnimator.currentFrame < 188 || this.bodyAnimator.currentLabel == "attack shield stab" && this.bodyAnimator.currentFrame < 198 || this.bodyAnimator.currentLabel == "attack magic upward" && this.bodyAnimator.currentFrame < 209 || this.bodyAnimator.currentLabel == "power attack" && this.bodyAnimator.currentFrame < 277)
         {
            this.__gravityObject.velX = scaleX * 4;
         }
         if(this.bodyAnimator.accessoryString != "pink balloon" && this.bodyAnimator.accessoryString != "balloon pack")
         {
            this.__gravityObject.applyGravity(this.gameMain,this.gameMain.gravity);
         }
         else if(this.bodyAnimator.accessoryString == "pink balloon")
         {
            this.__gravityObject.applyGravity(this.gameMain,this.gameMain.gravity * 0.9);
         }
         else if(this.bodyAnimator.accessoryString == "balloon pack")
         {
            this.__gravityObject.applyGravity(this.gameMain,this.gameMain.gravity * 0.8);
         }
         if((this.bodyAnimator.currentLabel == "ducking" || this.ridingPet != null) && this.isControllingPet == false && this.keyHandler.keyStates.getKeyState(Keyboard.DOWN).isDown && this.keyHandler.keyStates.keyPress_array[this.keyHandler.keyStates.keyPress_array.length - 1] == Keyboard.DOWN && this.keyHandler.keyStates.keyFrame_array[this.keyHandler.keyStates.keyFrame_array.length - 1] < this.__gravityObject.counter - PersonKeyHandler.KEY_TIMING_INT)
         {
            this.__gravityObject.dropThroughCheck();
         }
         scaleX = this.moveDir;
         if(getChildByName("gmIcon") != null)
         {
            getChildByName("gmIcon").scaleX = scaleX;
         }
         var _loc8_:Boolean = false;
         var _loc9_:* = this.isFrameLabel("running","dashing","pet walking","pet dashing","standing","pet standing","wall push","pet wall push","wall slide","pet wall slide");
         if(Boolean(this.__gravityObject.onGround) && Boolean(this.__gravityObject.onWall) && (this.keyHandler.keyStates.getKeyState(Keyboard.LEFT).isDown || this.keyHandler.keyStates.getKeyState(Keyboard.RIGHT).isDown) && Boolean(_loc9_))
         {
            if(this.ridingPet == null && this.bodyAnimator.currentLabel != "wall push")
            {
               this.bodyAnimator.gotoAndPlay("wall push");
            }
            else if(this.ridingPet != null && this.bodyAnimator.currentLabel != "pet wall push")
            {
               this.bodyAnimator.gotoAndPlay("pet wall push");
               this.bodyAnimator.pet.gotoAndPlayWalking();
            }
            _loc8_ = true;
         }
         if(this.__gravityObject.onGround == false)
         {
            if(this.bodyAnimator.currentLabel != "jumping" && this.isFrameLabel("standing","running","ducking","dashing","wall push","wall slide","block") && this.ridingPet == null)
            {
               this.bodyAnimator.gotoAndPlay("jumping");
            }
            else if(this.bodyAnimator.currentLabel != "pet jumping" && this.isFrameLabel("pet standing","pet walking","pet dashing","pet wall push","pet wall slide") && this.ridingPet != null)
            {
               this.bodyAnimator.gotoAndStop("pet jumping");
               this.bodyAnimator.pet.gotoAndStop(44);
            }
            if(this.isFrameLabel("jumping","pet jumping") && Boolean(this.__gravityObject.onWall) && this.__gravityObject.velY > 0 && this.__gravityObject.onWallCounter > 4)
            {
               if(this.keyHandler.keyStates.getKeyState(Keyboard.LEFT).isDown || this.keyHandler.keyStates.getKeyState(Keyboard.RIGHT).isDown)
               {
                  if(this.isFrameLabel("wall slide","pet wall slide") == false)
                  {
                     this.__gravityObject.jumps = this.__gravityObject.maxJumps - 1;
                  }
                  this.bodyAnimator.gotoAndStop(this.ridingPet == null ? "wall slide" : "pet wall slide");
                  this.__gravityObject.accelDownMultiplier = 0;
               }
            }
            if(this.isFrameLabel("wall slide","pet wall slide"))
            {
               this.__gravityObject.velY /= 1.2;
               if(this.__gravityObject.counter % 10 == 0 && Boolean(this.__gravityObject.onWall))
               {
                  if(scaleX == -1)
                  {
                     this.gameMain.createDashCloud(x - 25,y,-1,1,90);
                  }
                  else
                  {
                     this.gameMain.createDashCloud(x + 32,y,1,1,-90);
                  }
               }
            }
         }
         else if(this.keyHandler.keyStates.getKeyState(Keyboard.DOWN).isDown && this.ridingPet == null)
         {
            if(MoveStat.isAttackingFrame(this) == false && this.isControllingPet == false)
            {
               this.bodyAnimator.gotoAndStop("ducking");
            }
         }
         else if((this.keyHandler.keyStates.getKeyState(Keyboard.LEFT).isDown || this.keyHandler.keyStates.getKeyState(Keyboard.RIGHT).isDown) && this.isFrameLabel("running","dashing","block") == false && (this.isFrameLabel("wall push","pet wall push") == false && this.__gravityObject.onWall == false) && MoveStat.isAttackingFrame(this) == false)
         {
            if(this.ridingPet == null && this.bodyAnimator.currentLabel != "take hit")
            {
               this.bodyAnimator.gotoAndPlay("running");
            }
            else if(this.isFrameLabel("pet walking","pet dashing","pet take hit") == false && this.ridingPet != null)
            {
               this.bodyAnimator.gotoAndPlay("pet walking");
               this.bodyAnimator.pet.gotoAndPlayWalking();
            }
         }
         else if(this.keyHandler.keyStates.getKeyState(Keyboard.LEFT).isDown == false && this.keyHandler.keyStates.getKeyState(Keyboard.RIGHT).isDown == false && MoveStat.isAttackingFrame(this) == false && this.bodyAnimator.currentLabel != "take hit" && this.bodyAnimator.currentLabel != "pet take hit" && this.bodyAnimator.currentLabel != "block" && _loc8_ == false)
         {
            if(this.isFrameLabel("standing","fart","give energy") == false && this.ridingPet == null)
            {
               this.bodyAnimator.gotoAndPlay("standing");
            }
            else if(this.bodyAnimator.currentLabel != "pet standing" && this.ridingPet != null)
            {
               this.bodyAnimator.gotoAndPlay("pet standing");
               this.bodyAnimator.pet.gotoAndPlayStanding();
            }
         }
         else if(this.bodyAnimator.currentLabel == "block")
         {
            if(this.keyHandler.keyStates.getKeyState(Keyboard.V).isDown && this.bodyAnimator.currentFrame == this.bodyAnimator.BLOCK_FRAME)
            {
               this.bodyAnimator.stop();
            }
            else
            {
               this.bodyAnimator.play();
            }
         }
         if(this.bodyAnimator.currentLabel == "pet dashing")
         {
            this.bodyAnimator.pet.nextFrame();
            this.bodyAnimator.pet.nextFrame();
            if(this.bodyAnimator.pet.currentLabel != "walking")
            {
               this.bodyAnimator.pet.gotoAndPlayWalking();
            }
         }
         if(this.ridingPet != null && !this.isRidingCar())
         {
            if(this.bodyAnimator.currentLabel == "pet standing" && this.bodyAnimator.pet.currentLabel == "walking")
            {
               this.bodyAnimator.pet.gotoAndPlayStanding();
            }
            else if(this.bodyAnimator.currentLabel == "pet walking" && this.bodyAnimator.pet.currentLabel == "standing")
            {
               this.bodyAnimator.pet.gotoAndPlayWalking();
            }
         }
         this.keyHandler.checkDoUnDoneKey();
         if(this.isControllingPet == false)
         {
            this.keyHandler.onEnter();
         }
         if(this.bodyAnimator.currentFrame == 238 || this.bodyAnimator.currentFrame == 242 || this.bodyAnimator.currentFrame == 246)
         {
            _loc3_ = this.gameMain.createProjectile(x,y,name,scaleX,false,0.92);
            _loc3_.gravityObject.velX = 40 * scaleX;
            _loc3_.lifeSpan = 7 + this.tripleShotLvl * 2;
            if(this.bodyAnimator.currentFrame == 238)
            {
               this.MP -= this.levelMP(ARROW_TRIPLE_MP);
               if(this.__isPlayer)
               {
                  this.gameMain.theConnection.send("useMP",this.levelMP(ARROW_TRIPLE_MP));
               }
            }
            SoundManager.playSound(SoundLibrary.bow_sound,x,y,true,parent);
         }
         if((this.bodyAnimator.currentFrame > 749 && this.bodyAnimator.currentFrame < 758 || this.bodyAnimator.currentFrame > 596 && this.bodyAnimator.currentFrame < 605) && this.conBulletsShot < 25)
         {
            if(this.keyHandler.keyStates.getKeyState(Keyboard.SPACE).isDown || this.keyHandler.keyStates.getKeyState(Keyboard.C).isDown)
            {
               if(this.__gravityObject.counter % Stats.wStats[this.bodyAnimator.weaponString].sRate == 0)
               {
                  this.bodyAnimator.play();
               }
               else if(this.ridingPet == null && this.bodyAnimator.currentFrame > 754 || this.ridingPet != null && this.bodyAnimator.currentFrame > 601)
               {
                  this.bodyAnimator.gotoAndStopInt(this.ridingPet == null ? 752 : 599);
               }
            }
            else if(this.__gravityObject.counter % Stats.wStats[this.bodyAnimator.weaponString].sRate == 0)
            {
               this.bodyAnimator.play();
            }
            if(this.bodyAnimator.currentFrame == 753 || this.bodyAnimator.currentFrame == 600)
            {
               ++this.conBulletsShot;
               this.i = 0;
               while(this.i < (this.projAttackType == "basic" || this.MP < SHOTGUN_MP * this.shotgunLvl ? 1 : this.shotgunLvl))
               {
                  if(this.projAttackType == "shotgun" && this.i == 1)
                  {
                     this.MP -= SHOTGUN_MP * this.shotgunLvl;
                     if(this.__isPlayer)
                     {
                        this.gameMain.theConnection.send("useMP",SHOTGUN_MP * this.shotgunLvl);
                     }
                  }
                  this.__gravityObject.velX -= this.moveDir * 1;
                  _loc4_ = this.gameMain.createProjectile(x + (this.bodyAnimator.weaponLeft_sprite.width - 10) * scaleX,y - (this.ridingPet == null ? 8 : 18),name,scaleX,false,1,false,1);
                  _loc4_.gravityObject.velX *= 1.5;
                  _loc4_.lifeSpan *= 0.25 + this.bulletDistanceLvl / 180;
                  if(this.bodyAnimator.weapon2String != "none" && Stats.wStats[this.bodyAnimator.weapon2String].sRate > 0 && this.isDualGunWeapon(this.bodyAnimator.weapon2String))
                  {
                     _loc10_ = this.gameMain.createProjectile(x + (this.bodyAnimator.weaponRight_sprite.width - 10) * scaleX,y - (this.ridingPet == null ? 8 : 18),name,scaleX,false,1,false,1);
                     _loc10_.texture = Assets.items_textureAtlas.getTexture(Stats.wStats[this.bodyAnimator.weapon2String].fname + " proj");
                     _loc10_.isSecondaryShot = true;
                     _loc10_.gravityObject.velX *= 1.5;
                     _loc10_.lifeSpan *= 0.25 + this.bulletDistanceLvl / 180;
                  }
                  switch(this.i)
                  {
                     case 1:
                        _loc4_.gravityObject.velY = -10;
                        break;
                     case 2:
                        _loc4_.gravityObject.velY = -6;
                        break;
                     case 3:
                        _loc4_.gravityObject.velY = 3;
                        break;
                     case 4:
                        _loc4_.gravityObject.velY = 5;
                  }
                  if(CommonCalls.onScreen(x,y,false,true))
                  {
                     this.gameMain.createBulletShell(x,y,this.moveDir * -1,parent.getChildIndex(this) + 1);
                  }
                  SoundManager.playSound(Stats.wStats[this.bodyAnimator.weaponString].sound,x,y,true,parent);
                  ++this.i;
               }
            }
         }
         else if(this.bodyAnimator.weaponString == "fishing pole" && (this.bodyAnimator.currentFrame == 79 || this.bodyAnimator.currentFrame == 406) && Boolean(this.__gravityObject.onGround))
         {
            if(this.keyHandler.cKeyDown && (Boolean(FishingLine.checkSpot(getBounds(parent).x + (this.moveDir > 0 ? width - 5 : 5),y + 15,MainStarlingStage(root))) || Boolean(FishingLine.checkSpot(getBounds(parent).x + (this.moveDir > 0 ? width - 5 : 5),y + 100,MainStarlingStage(root)))))
            {
               this.bodyAnimator.stop();
               this.__gravityObject.velX = this.__gravityObject.velY = 0;
               if(this.__fishing == false)
               {
                  this.startFishing();
               }
            }
         }
         if(this.MP >= this.levelMP(2))
         {
            if(Boolean(Stats.wStats[this.bodyAnimator.weaponString].isMagic) && Boolean(this.bodyAnimator.currentFrame == 80 || this.bodyAnimator.currentFrame == 103 || this.bodyAnimator.currentFrame == 157 || this.bodyAnimator.currentFrame == 171 || this.bodyAnimator.currentFrame == 206 || this.bodyAnimator.currentFrame == 405 || this.bodyAnimator.currentFrame == 415 || this.bodyAnimator.currentFrame == 427 || this.bodyAnimator.currentFrame == 444) || Boolean(this.bodyAnimator.weapon2String != "none" && Stats.wStats[this.bodyAnimator.weapon2String].isMagic) && Boolean(this.bodyAnimator.currentFrame == 118 || this.bodyAnimator.currentFrame == 107 || this.bodyAnimator.currentFrame == 161 || this.bodyAnimator.currentFrame == 170 || this.bodyAnimator.currentFrame == 184 || this.bodyAnimator.currentFrame == 195 || this.bodyAnimator.currentFrame == 431 || this.bodyAnimator.currentFrame == 448 || this.bodyAnimator.currentFrame == 459 || this.bodyAnimator.currentFrame == 470))
            {
               if(Boolean(Stats.wStats[this.bodyAnimator.weaponString].isMagic) || Boolean(Stats.wStats[this.bodyAnimator.weapon2String] != "none") && Boolean(Stats.wStats[this.bodyAnimator.weapon2String].isMagic))
               {
                  this.MP -= this.levelMP(2);
                  this.MP = this.MP > 0 ? this.MP : 0;
                  if(this.__isPlayer)
                  {
                     this.gameMain.theConnection.send("useMP",this.levelMP(2));
                  }
               }
               this.i = 0;
               while(this.i < this.magicShotsLvl + 1)
               {
                  _loc5_ = this.gameMain.createProjectile(x + (this.i * 15 + 10) * scaleX,y + this.i * 8,name,this.bodyAnimator.currentFrame != 171 ? int(scaleX) : int(scaleX * -1),true);
                  if(this.bodyAnimator.currentFrame == 118 || this.bodyAnimator.currentFrame == 195 || this.bodyAnimator.currentFrame == 184 || this.bodyAnimator.currentFrame == 107 || this.bodyAnimator.currentFrame == 161 || this.bodyAnimator.currentFrame == 170 || this.bodyAnimator.currentFrame == 431 || this.bodyAnimator.currentFrame == 448 || this.bodyAnimator.currentFrame == 459 || this.bodyAnimator.currentFrame == 470)
                  {
                     _loc5_.isMagicSecondary = true;
                  }
                  ++this.i;
               }
               SoundManager.playSound(SoundLibrary.magicSwing_sound,x,y,true,parent);
            }
         }
         if(this.flyCluster != null)
         {
            this.flyCluster.controlFlies();
         }
         if(this.bodyAnimator.currentLabel != "ducking" && this.bodyAnimator.currentLabel != "dash attack" && this.bodyAnimator.currentLabel != "pet dash attack")
         {
            this.__gravityObject.endSlide();
         }
         else if(Boolean(this.__gravityObject.onGround) || this.bodyAnimator.currentLabel == "dash attack" || this.bodyAnimator.currentLabel == "pet dash attack")
         {
            this.__gravityObject.slide(0.96);
         }
         this.flaps = this.__gravityObject.onGround ? 0 : this.flaps;
         if(Boolean(this.__gravityObject.inWater) && Boolean(CommonCalls.onScreen(x,y,false,true)) && this.__gravityObject.counter % 10 == 0 && Math.random() > 0.65)
         {
            this.gameMain.createWaterBubble(x,y - 7,this);
         }
         if(this.isFrameLabel("dashing","pet dashing"))
         {
            if(this.__gravityObject.counter % 10 == 0 && Math.abs(CalcDist.getDistX(x,this.__gravityObject.previousX)) > 4)
            {
               _loc6_ = 1;
               if(this.dashLvl >= 12)
               {
                  _loc6_ = 4;
               }
               else if(this.dashLvl >= 8)
               {
                  _loc6_ = 3;
               }
               else if(this.dashLvl >= 4)
               {
                  _loc6_ = 2;
               }
               this.gameMain.createDashCloud(this.__gravityObject.previousX,this.__gravityObject.previousY + 45,scaleX * -1,_loc6_,this.__gravityObject.groundSlope);
            }
            if(this.__gravityObject.counter % 10 == 0)
            {
               SoundManager.playSound(SoundLibrary.running_sound,x,y,true,parent);
            }
         }
         if(this.isFrameLabel("dashing","pet dashing") == false && (Boolean(this.__gravityObject.onGround) || Boolean(this.__gravityObject.onWall)))
         {
            this.jumpedWhileDashing = false;
         }
         if(this.bodyAnimator.shadow_image != null)
         {
            this.bodyAnimator.shadow_image.visible = this.__gravityObject.onGround;
         }
         if(this.health <= 0 && rotation == 0)
         {
            rotation = deg2rad(-90);
            this.keyHandler.keyStates.releaseAll();
            this.energyController.charge = 0;
            this.inGuildRage = false;
            if(this.rageGlow_image != null)
            {
               this.rageGlow_image.removeFromParent(true);
            }
         }
         else if(this.health <= 0)
         {
            this.bodyAnimator.gotoAndStopInt(1);
            if(this.bodyAnimator.shadow_image != null)
            {
               this.bodyAnimator.shadow_image.visible = false;
            }
            this.moveDir = scaleX = 1;
            _loc7_ = numChildren;
            this.i = 0;
            while(this.i < _loc7_)
            {
               if((getChildAt(this.i).name == null || getChildAt(this.i).name != "shadow" && getChildAt(this.i).name != "charge ball") && !(getChildAt(this.i) is FlyCluster) && !(getChildAt(this.i) is Pet))
               {
                  getChildAt(this.i).x = getChildAt(this.i).x - 20;
               }
               ++this.i;
            }
         }
         this.alignNameText();
         if(Boolean(CommonCalls.onScreen(x,y,false,true)) && this.inGuildRage)
         {
            if(this.inGuildRage)
            {
               this.rageGlow_image.x = x;
               this.rageGlow_image.y = y;
            }
         }
         else if(this.isTweeningFilter == false)
         {
            filter = null;
         }
      }
      
      public function alignNameText() : void
      {
         this.name_txt.x = x + parent.x - 58;
         this.name_txt.y = y + parent.y + 37;
      }
      
      public function get activePets() : Vector.<Pet>
      {
         var _loc1_:Pet = null;
         var _loc2_:Vector.<Pet> = new Vector.<Pet>();
         for each(_loc1_ in this.pet_array)
         {
            if(_loc1_.isActive)
            {
               _loc2_.push(_loc1_);
            }
         }
         return _loc2_;
      }
      
      public function getCompanionPet() : Pet
      {
         var _loc1_:Pet = null;
         for each(_loc1_ in this.pet_array)
         {
            if(_loc1_.isCompanion)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function get ridingPet() : Pet
      {
         var _loc1_:Pet = null;
         for each(_loc1_ in this.activePets)
         {
            if(_loc1_.mode == "m")
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function isRidingCar() : Boolean
      {
         var _p:Pet = null;
         var _low:String = null;
         try
         {
            _p = this.ridingPet;
            if(_p == null)
            {
               return false;
            }
            _low = _p.type.toLowerCase().replace(/\s+/g,"");
            return Pet.petBodies_xml[_low].bodyFrames.length() > 0;
         }
         catch(_e:Error)
         {
            return false;
         }
      }
      
      public function deactivatePets(param1:Vector.<Pet>) : void
      {
         var _loc2_:Pet = null;
         for each(_loc2_ in this.activePets)
         {
            Pet.petRemove(param1,_loc2_,true);
            if(this.__isPlayer == false)
            {
            }
            if(_loc2_.mode == "m")
            {
               this.bodyAnimator.gotoAndPlay("standing");
            }
            _loc2_.isActive = false;
         }
      }
      
      public function isFrameLabel(... rest) : Boolean
      {
         var _loc2_:String = null;
         for each(_loc2_ in rest)
         {
            if(this.bodyAnimator.currentLabel == _loc2_)
            {
               return true;
            }
         }
         return false;
      }
      
      public function framesLagged() : int
      {
         return Math.round(this.ping / 2 / 33.33);
      }
      
      public function controlledObject() : GravityObject
      {
         var _loc1_:Pet = null;
         var _loc2_:Enemy = null;
         if(this.isControllingPet)
         {
            for each(_loc1_ in this.pet_array)
            {
               if(_loc1_.isManualControlling)
               {
                  return _loc1_.gravityObject;
               }
            }
         }
         else if(this.isControllingEnemy)
         {
            for each(_loc2_ in this.gameMain.e_array)
            {
               if(_loc2_.controlling_person == this)
               {
                  return _loc2_.gravityObject;
               }
            }
         }
         return this.__gravityObject;
      }
      
      public function startFishing() : void
      {
         if(this.__fishing == false)
         {
            this.fishingLine = this.gameMain.createFishingLine(this);
            this.__fishing = true;
            return;
         }
         throw new Error("call to startFishing when person is already fishing.");
      }
      
      public function stopFishing() : void
      {
         var _loc1_:Date = null;
         var _loc2_:int = 0;
         var _loc3_:Pet = null;
         if(this.__fishing)
         {
            this.fishingLine.removeFromParent(true);
            this.__fishing = false;
            if(this.fishingLine.caughtFish != null && this.isPlayer)
            {
               _loc1_ = new Date();
               _loc2_ = _loc1_.time - this.fishingLine.bite_date.time;
               for each(_loc3_ in this.activePets)
               {
                  if(_loc2_ > 0)
                  {
                     _loc2_ -= 20;
                  }
               }
               if(this.gameMain.personItem_array.length == this.gameMain.maxItems)
               {
                  this.createExclaim("inventory full",18);
               }
               else if(_loc2_ - this.fishingLvl < Stats.fishStats[this.fishingLine.caughtFish.type].time)
               {
                  SoundManager.playSound(SoundLibrary.fishCaught_sound,x,y,true,parent);
                  this.gameMain.theConnection.send("caughtFish",this.fishingLine.caughtFish.name);
                  this.createExclaim("caught fish!",24);
               }
               else
               {
                  this.fishingLine.caughtFish = null;
                  this.createExclaim("fish got away...",18);
               }
            }
            this.fishingLine = null;
            this.bodyAnimator.play();
         }
      }
      
      public function togglePetControl() : void
      {
         var _loc1_:Pet = null;
         var _loc2_:Pet = null;
         var _loc3_:Pet = null;
         if(this.activePets.length > 0)
         {
            _loc1_ = this.activePets[0];
         }
         for each(_loc3_ in this.activePets)
         {
            if(_loc3_.isManualControlling)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         this.keyHandler.keyRelease(Keyboard.LEFT);
         this.keyHandler.keyRelease(Keyboard.RIGHT);
         if(_loc1_ != null)
         {
            if(this.isControllingPet == false && this.ridingPet == null)
            {
               this.__isControllingPet = true;
               _loc1_.isManualControlling = true;
               _loc1_.keyRelease(Keyboard.LEFT);
               _loc1_.keyRelease(Keyboard.RIGHT);
               if(this.__isPlayer)
               {
                  this.gameMain.focusLevel(_loc1_);
                  this.gameMain.theConnection.send("togPetCon",true);
               }
            }
            else if(this.isControllingPet == false && this.ridingPet != null)
            {
               if(this.__isPlayer)
               {
                  this.gameMain.createAlert("You cannot control a pet in mount mode");
               }
            }
            else if(this.isControllingPet)
            {
               _loc2_.isManualControlling = false;
               this.__isControllingPet = false;
               if(this.__isPlayer)
               {
                  this.gameMain.focusLevel();
                  this.gameMain.theConnection.send("togPetCon",false);
               }
            }
         }
         else if(_loc1_ == null)
         {
            if(this.__isPlayer)
            {
               this.gameMain.createAlert("A pet must be active to control it");
            }
         }
      }
      
      public function getClass() : String
      {
         if(this.power > this.range && this.power > this.magic && this.power > this.artillery)
         {
            return "warrior";
         }
         if(this.range > this.power && this.range > this.magic && this.range > this.artillery)
         {
            return "archer";
         }
         if(this.magic > this.power && this.magic > this.range && this.magic > this.artillery)
         {
            return "wizard";
         }
         return "cowboy";
      }
      
      public function createExclaim(param1:String = "!", param2:int = 68) : void
      {
         var _loc3_:TextField = new TextField(5,82,param1,new TextFormat(Assets.stats_font.name,param2,15658734));
         _loc3_.x = x - 15;
         _loc3_.y = y - 115;
         _loc3_.touchable = false;
         _loc3_.autoSize = TextFieldAutoSize.HORIZONTAL;
         parent.addChild(_loc3_);
         TweenMax.to(_loc3_,0.4,{
            "alpha":0,
            "delay":0.6,
            "ease":Linear.easeNone,
            "onComplete":_loc3_.removeFromParent,
            "onCompleteParams":[true]
         });
      }
      
      public function rightClick() : void
      {
         if(this.__isPlayer == false && this.npc == false)
         {
            this.gameMain.createRCMenu(Vector.<String>(["add friend","trade","report"]),{"personName":name});
         }
      }
      
      public function getAllOrbBonuses(param1:Vector.<PetOrb>) : int
      {
         var _loc2_:PetOrb = null;
         var _loc3_:int = 0;
         for each(_loc2_ in param1)
         {
            if(_loc2_.creator.name == name)
            {
               _loc3_ += _loc2_.bonus;
            }
         }
         return _loc3_;
      }
      
      public function get fishing() : Boolean
      {
         return this.__fishing;
      }
      
      public function get fishXP() : uint
      {
         return this.__fishXP;
      }
      
      public function set fishXP(param1:uint) : void
      {
         this.__fishXP = param1;
         if(this.__fishXP >= CommonCalls.getTotalXPToReachLevel(this.fishingLvl + 1))
         {
            this.__fishXP = CommonCalls.getTotalXPToReachLevel(this.fishingLvl + 1);
            ++this.fishingLvl;
            SoundManager.playSound(SoundLibrary.proLevelUp_sound,x,y,true,parent);
         }
      }
      
      public function get chopXP() : uint
      {
         return this.__chopXP;
      }
      
      public function set chopXP(param1:uint) : void
      {
         this.__chopXP = param1;
         if(this.__chopXP >= CommonCalls.getTotalXPToReachLevel(this.choppingLvl + 1))
         {
            this.__chopXP = CommonCalls.getTotalXPToReachLevel(this.choppingLvl + 1);
            ++this.choppingLvl;
            ShineEffect.shineObjectNoParent(this,10);
            SoundManager.playSound(SoundLibrary.proLevelUp_sound,x,y,true,parent);
         }
      }
      
      public function get isPlayer() : Boolean
      {
         return this.__isPlayer;
      }
      
      public function levelMeUp() : void
      {
         this.currentLevelXP = 0;
         ++this.lev;
         this.abilityPoints += 3;
         ++this.skillPoints;
         SoundManager.playSound(SoundLibrary.levelUp_sound,x,y,true,parent);
         if(this.isPlayer && this.gameMain.playingURL_string == "miniplay.com")
         {
            MiniPlay.lechuck.stat.put(null,"level",this.lev);
         }
         if(CommonCalls.onScreen(x,y,false,true))
         {
            ShineEffect.shineObjectNoParent(this,17);
            filter = new GlowFilter(15658734,3,8);
            this.isTweeningFilter = true;
            setTimeout(function():void
            {
               filter = null;
               isTweeningFilter = false;
            },1500);
         }
      }
      
      public function levelMP(param1:uint) : int
      {
         return param1 * Math.ceil(this.lev / 100);
      }
      
      public function removePetFromMe(param1:String) : Pet
      {
         var _loc2_:Pet = null;
         var _loc3_:int = int(this.pet_array.length);
         this.i = 0;
         while(this.i < _loc3_)
         {
            if(this.pet_array[this.i].name == param1)
            {
               _loc2_ = this.pet_array[this.i];
               this.pet_array.removeAt(this.i);
               return _loc2_;
            }
            ++this.i;
         }
         return null;
      }
      
      public function get isDamageableFrame() : Boolean
      {
         var _loc1_:MoveStat = Moves.moveByName(this.bodyAnimator.currentLabel);
         if(_loc1_ != null && this.bodyAnimator.currentFrame >= _loc1_.startDmgFrame && this.bodyAnimator.currentFrame <= _loc1_.endDmgFrame)
         {
            return true;
         }
         return false;
      }
      
      public function get MP() : int
      {
         return this.personHackCheck.MP;
      }
      
      public function set MP(param1:int) : void
      {
         this.personHackCheck.MP = param1;
      }
      
      public function get health() : int
      {
         return this.personHackCheck.health;
      }
      
      public function set health(param1:int) : void
      {
         this.personHackCheck.health = param1;
      }
      
      public function get totalHealth() : int
      {
         return this.personHackCheck.totalHealth;
      }
      
      public function set totalHealth(param1:int) : void
      {
         this.personHackCheck.totalHealth = param1;
      }
      
      public function get totalMP() : int
      {
         return this.personHackCheck.totalMP;
      }
      
      public function set totalMP(param1:int) : void
      {
         this.personHackCheck.totalMP = param1;
      }
      
      public function get tickets() : int
      {
         return this.personHackCheck.tickets;
      }
      
      public function set tickets(param1:int) : void
      {
         this.personHackCheck.tickets = param1;
      }
      
      public function get isControllingPet() : Boolean
      {
         return this.__isControllingPet;
      }
      
      public function get guild() : String
      {
         return this.__guild;
      }
      
      public function set guild(param1:String) : void
      {
         this.__guild = param1;
         if(this.name_txt != null)
         {
            if(this.guild != "")
            {
               this.name_txt.height = 60;
               this.name_txt.text = name + "\n" + this.guild;
            }
            else
            {
               this.name_txt.height = 27;
               this.name_txt.text = name;
            }
         }
      }
      
      override public function set name(param1:String) : void
      {
         super.name = param1;
         if(this.name_txt != null)
         {
            if(this.guild != "")
            {
               this.name_txt.height = 60;
               this.name_txt.text = name + "\n" + this.guild;
            }
            else
            {
               this.name_txt.height = 27;
               this.name_txt.text = name;
            }
         }
      }
      
      public function get gravityObject() : GravityObject
      {
         return this.__gravityObject;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         if(this.name_txt != null)
         {
            this.name_txt.visible = param1;
         }
      }
      
      public function checkCreateGMIcon() : void
      {
         var _loc1_:Texture = null;
         var _loc2_:Image = null;
         switch(this.role)
         {
            case "admin":
               _loc1_ = Assets.items_textureAtlas.getTexture("gamemaster icon");
               break;
            case "mod":
               _loc1_ = Assets.items_textureAtlas.getTexture("moderator icon");
               break;
            case "tester":
               _loc1_ = Assets.items_textureAtlas.getTexture("community assistant icon");
               break;
            default:
               switch(name)
               {
                  case "robby":
                     _loc1_ = Assets.items_textureAtlas.getTexture("gamemaster icon");
                     break;
                  case "coke_na_rc":
                     _loc1_ = Assets.items_textureAtlas.getTexture("moderator icon");
                     break;
                  case "osculord":
                     _loc1_ = Assets.items_textureAtlas.getTexture("gamemaster icon");
               }
         }
         if(_loc1_ != null && getChildByName("gmIcon") == null)
         {
            _loc2_ = new Image(_loc1_);
            _loc2_.pivotX = _loc2_.width / 2;
            _loc2_.pivotY = _loc2_.height / 2;
            _loc2_.y = this.__guild != null && this.__guild != "" ? 98 : 68;
            _loc2_.touchable = false;
            _loc2_.name = "gmIcon";
            addChild(_loc2_);
         }
      }
   }
}

