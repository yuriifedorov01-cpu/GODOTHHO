package com.game_objects.enemies
{
   import com.AI.*;
   import com.game_objects.*;
   import com.game_objects.hit_detect.*;
   import com.gravityPackage.*;
   import com.helpers.*;
   import com.math.*;
   import com.menus.add_ons.*;
   import com.sound.*;
   import com.stats.*;
   import com.utilities.*;
   import com.visual_effects.*;
   import flash.display.*;
   import flash.display3D.*;
   import flash.geom.Rectangle;
   import flash.media.Sound;
   import flash.ui.*;
   import playerio.*;
   import starling.*;
   import starling.display.Image;
   import starling.display.MovieClip;
   import starling.extensions.lighting.*;
   import starling.textures.*;
   
   public class Enemy extends starling.display.MovieClip implements IClickable, IGravityObject
   {
      
      public static const enemyAssets_array:Vector.<Array> = new Vector.<Array>();
      
      public var dirChangeTime:int = 2147483647;
      
      public var pastHealth:int = 0;
      
      public var damageJustDone:int = 0;
      
      public var distanceFromCaster:int = 0;
      
      public var wasCritHit:Boolean = false;
      
      public var playerControl:Person;
      
      private var particle:SplatParticle;
      
      public var type:String;
      
      public var health:int = 0;
      
      public var totalHealth:int = 0;
      
      public var keyStates:KeyStates;
      
      public var enemyAI:EnemyAI;
      
      public var controlling_person:Person;
      
      private var __dashing:Boolean = false;
      
      protected var __hasDash:Boolean = false;
      
      protected var moveType:String = "ground";
      
      private var __gravityObject:GravityObject;
      
      public var moveDir:int = 1;
      
      public var moveSpeed:Number = 5;
      
      public var jumpPower:Number = 15;
      
      public var hitTester:HitTester;
      
      private var lastWalkFrame:uint = 4294967295;
      
      private var lastJumpFrame:uint = 4294967295;
      
      public var healthBar_image:Image;
      
      public function Enemy(param1:String, param2:Rectangle, param3:EnemyAI = null)
      {
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Vector.<Texture> = null;
         var _loc7_:Texture = null;
         var _loc8_:Texture = null;
         var _loc9_:LightStyle = null;
         for each(_loc5_ in Enemy.enemyAssets_array)
         {
            if(TextureAtlas(_loc5_[0]).getTextures(param1 + "_").length > 0)
            {
               _loc4_ = _loc5_;
               break;
            }
         }
         if(_loc4_ == null)
         {
            _loc4_ = MovieClipToAtlas.createAtlas(Assets.getEnemyArt(param1),param1,Context3DTextureFormat.BGRA_PACKED);
            Enemy.enemyAssets_array.push(_loc4_);
         }
         var _loc10_:Vector.<Texture> = TextureAtlas(_loc4_[0]).getTextures(param1 + "_");
         if(_loc4_.length > 4)
         {
            _loc6_ = TextureAtlas(_loc4_[4]).getTextures(param1 + "_");
            for each(_loc7_ in _loc6_)
            {
               _loc10_.push(_loc7_);
            }
            if(_loc4_.length > 5)
            {
               _loc6_ = TextureAtlas(_loc4_[5]).getTextures(param1 + "_");
               for each(_loc8_ in _loc6_)
               {
                  _loc10_.push(_loc8_);
               }
            }
         }
         super(_loc10_,30);
         pivotX = _loc4_[1];
         pivotY = _loc4_[2];
         currentLabels = _loc4_[3];
         this.type = param1;
         this.keyStates = new KeyStates();
         this.enemyAI = param3 == null ? new EnemyAI(this) : param3;
         this.__gravityObject = new GravityObject(this,param2);
         this.hitTester = new HitTester(this,param2);
         this.__gravityObject.doApplyGravity = Stats.eStats[param1].applyGravity;
         this.setLastFrames();
         if(GameMain.lighting)
         {
            switch(param1)
            {
               case "green bouncer":
                  _loc9_ = new LightStyle(Assets.greenBouncerLightMap_textureAtlas.getTexture(param1 + "0000"));
                  _loc9_.ambientRatio = 0.3;
                  _loc9_.diffuseRatio = 0.7;
                  _loc9_.specularRatio = 0.2;
                  _loc9_.shininess = 7;
                  _loc9_.textureSmoothing = TextureSmoothing.NONE;
                  style = _loc9_;
            }
         }
      }
      
      public function onEnter(param1:Vector.<Enemy>, param2:int) : void
      {
         var _loc3_:Pet = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Rectangle = null;
         var _loc8_:Person = MainStarlingStage(root).gameMain.player;
         ++this.__gravityObject.counter;
         this.hitTester.onEnterMisc();
         this.keyStates.onEnter();
         if(this.controlling_person == null)
         {
            this.enemyAI.handleAI();
         }
         if(this.keyStates.getKeyState(Keyboard.LEFT).isDown == false && this.keyStates.getKeyState(Keyboard.RIGHT).isDown == false)
         {
            this.moveDir = 0;
         }
         if(this.pastHealth > this.health)
         {
            this.damageJustDone = this.pastHealth - this.health;
            _loc4_ = y - height / 2;
            if(this.type == "magmagon")
            {
               _loc4_ = y;
            }
            MainStarlingStage(root).gameMain.createDamageText(this.damageJustDone,x,_loc4_,false,this.wasCritHit);
            this.wasCritHit = false;
         }
         this.pastHealth = this.health;
         if(this.healthBar_image != null)
         {
            this.healthBar_image.scaleX = this.health / this.totalHealth;
         }
         if(this.health <= 0)
         {
            if(this.controlling_person != null)
            {
               this.noControlMe();
            }
            if(Math.random() > 0.5)
            {
               SoundManager.playSound(Stats.eDescs[this.type].sound,x,y,true,parent);
            }
            if(this.healthBar_image != null)
            {
               this.healthBar_image.scaleX = 0;
            }
            SoundManager.playSound(Math.random() > 0.5 ? SoundLibrary.crunch_sound : SoundLibrary.crunch2_sound,x,y,true,parent);
            if(MainStarlingStage(root).gameMain.stage.quality != StageQuality.LOW.toUpperCase() && Boolean(CommonCalls.onScreen(x,y,true,true)))
            {
               _loc5_ = Math.sqrt(Math.sqrt(width * height)) / 2;
               _loc6_ = 0;
               while(_loc6_ < _loc5_)
               {
                  this.particle = new SplatParticle(Stats.eDescs[this.type].colorString);
                  this.particle.x = this.__gravityObject.hit_rect.x + Math.random() * this.__gravityObject.hit_rect.width;
                  this.particle.y = this.__gravityObject.hit_rect.y + Math.random() * this.__gravityObject.hit_rect.height;
                  SortDepths.addAt(this.particle,SortDepths.REGION_2);
                  _loc6_++;
               }
            }
            param1.removeAt(param2);
            MainStarlingStage(root).gameMain.main_juggler.remove(this);
            removeFromParent(true);
            this.hitTester.frozen = false;
            return;
         }
         if(this.dirChangeTime == int.MAX_VALUE && Boolean(this.__gravityObject.onGround))
         {
            this.setDirTime();
         }
         if(this.controlling_person == null && this.__gravityObject.counter % 5 == 0 && Boolean(this.__gravityObject.onWall))
         {
            this.moveDir *= -1;
            x += this.moveDir * 5;
         }
         this.__gravityObject.applyGravity(MainStarlingStage(root).gameMain,MainStarlingStage(root).gameMain.gravity);
         if(currentLabel != "hit" && currentLabel != "open chest")
         {
            if(this.moveType == "flying" && currentLabel != "walk")
            {
               gotoAndPlayLabel("walk");
            }
            else if(this.__gravityObject.onGround == false && this.jumpPower > 0 && currentLabel != "jump")
            {
               gotoAndPlayLabel("jump");
            }
            else if(Boolean(this.__gravityObject.onGround) && (currentLabel != "walk" || isPlaying == false) && (this.keyStates.getKeyState(Keyboard.LEFT).isDown || this.keyStates.getKeyState(Keyboard.RIGHT).isDown))
            {
               gotoAndPlayLabel("walk");
            }
            else if((currentLabel != "jump" || Boolean(this.__gravityObject.onGround)) && this.keyStates.getKeyState(Keyboard.LEFT).isDown == false && this.keyStates.getKeyState(Keyboard.RIGHT).isDown == false)
            {
               gotoAndStopLabel("walk");
            }
         }
         if(Boolean(this.__dashing) && currentLabel == "walk")
         {
            ++currentFrame;
            this.handleExitFrames();
            ++currentFrame;
            if(Boolean(this.__gravityObject.onGround) && this.__gravityObject.counter % 10 == 0)
            {
               SoundManager.playSound(SoundLibrary.running_sound,x,y,true,parent);
               _loc7_ = getBounds(parent);
               MainStarlingStage(root).gameMain.createDashCloud(this.__gravityObject.previousX,_loc7_.y + _loc7_.height,scaleX * -1,2,this.gravityObject.groundSlope);
            }
         }
         if(this.hitTester.frozen == false && this.moveType != "flying")
         {
            if(this.__gravityObject.onGround)
            {
               this.__gravityObject.velX += (this.__dashing == false ? this.moveSpeed : this.moveSpeed * 2) * this.moveDir;
            }
            else if(Math.abs(this.__gravityObject.velX) < 15)
            {
               this.__gravityObject.velX += (this.__dashing == false ? this.moveSpeed : this.moveSpeed * 2) * this.moveDir / 2;
            }
         }
         else if(this.moveType == "flying" && this.hitTester.frozen == false)
         {
            if(this.keyStates.getKeyState(Keyboard.DOWN).isDown)
            {
               this.__gravityObject.velY += this.moveSpeed / 3;
            }
            else if(this.keyStates.getKeyState(Keyboard.UP).isDown)
            {
               this.__gravityObject.velY -= this.moveSpeed / 3;
            }
            if(this.keyStates.getKeyState(Keyboard.RIGHT).isDown)
            {
               this.__gravityObject.velX += this.moveSpeed / 3;
            }
            else if(this.keyStates.getKeyState(Keyboard.LEFT).isDown)
            {
               this.__gravityObject.velX -= this.moveSpeed / 3;
            }
            this.__gravityObject.velX *= this.__gravityObject.airFriction * (this.__gravityObject.inWater ? 0.95 : 1);
            this.__gravityObject.velY *= this.__gravityObject.airFriction * (this.__gravityObject.inWater ? 0.95 : 1);
            x += this.__gravityObject.velX;
            y += this.__gravityObject.velY;
         }
         if(this.moveDir != 0)
         {
            scaleX = this.moveDir;
         }
         this.hitTester.playerAdvancedHitCheck(_loc8_);
         if(this.hitTester.hitType.hitter != null)
         {
            this.onHit();
         }
         for each(_loc3_ in _loc8_.activePets)
         {
            if(_loc3_.canDamage)
            {
               this.hitTester.petAdvancedHitCheck(_loc3_);
               if(this.hitTester.hitType.hitter != null)
               {
                  _loc3_.canDamage = false;
                  MainStarlingStage(root).gameMain.theConnection.send("petHitE",_loc3_.name,name);
               }
            }
         }
         this.handleExitFrames();
      }
      
      public function keyPress(param1:uint) : void
      {
         switch(param1)
         {
            case Keyboard.LEFT:
               this.moveDir = -1;
               if(this.__hasDash)
               {
                  if(Boolean(this.__gravityObject.onGround) && this.keyStates.keyPress_array.length > 0 && this.keyStates.keyPress_array[this.keyStates.keyPress_array.length - 1] == Keyboard.LEFT)
                  {
                     if(this.keyStates.framesSinceKeyPress(this.keyStates.keyTime_array.length - 1) <= 9)
                     {
                        this.__dashing = true;
                     }
                  }
               }
               break;
            case Keyboard.RIGHT:
               this.moveDir = 1;
               if(this.__hasDash)
               {
                  if(Boolean(this.__gravityObject.onGround) && this.keyStates.keyPress_array.length > 0 && this.keyStates.keyPress_array[this.keyStates.keyPress_array.length - 1] == Keyboard.RIGHT)
                  {
                     if(this.keyStates.framesSinceKeyPress(this.keyStates.keyTime_array.length - 1) <= 9)
                     {
                        this.__dashing = true;
                     }
                  }
               }
               break;
            case Keyboard.UP:
               if(Boolean(this.__gravityObject.onGround) && this.jumpPower > 0 && this.moveType == "ground")
               {
                  this.__gravityObject.velY = -this.jumpPower;
               }
               break;
            case Keyboard.DOWN:
               if(this.moveType == "ground")
               {
                  this.__gravityObject.dropThroughCheck();
               }
         }
         this.keyStates.pressKey(param1);
      }
      
      public function keyRelease(param1:uint) : void
      {
         switch(param1)
         {
            case Keyboard.LEFT:
               if(this.__dashing)
               {
                  gotoAndPlayLabel("walk");
               }
               this.__dashing = false;
               break;
            case Keyboard.RIGHT:
               if(this.__dashing)
               {
                  gotoAndPlayLabel("walk");
               }
               this.__dashing = false;
         }
         this.keyStates.releaseKey(param1);
      }
      
      private function onHit() : void
      {
         var _loc1_:Message = null;
         MainStarlingStage(root).gameMain.lastEnemyNameHit = name;
         MainStarlingStage(root).gameMain.player.canDamage = false;
         _loc1_ = new Message("dmgE",name,!this.hitTester.hitType.isPrimary);
         var _loc2_:int = 0;
         switch(this.hitTester.hitType.moveStat.name)
         {
            case Moves.GROUND_STAB:
               StarExplosion.createExplosion(x,y,7,100,150,MainStarlingStage(root).c_mc,StarExplosion.DIR_UP);
               LightPillar.createLightPiller(x,y,MainStarlingStage(root).gameMain.c_mc);
               _loc1_.add("");
               break;
            case Moves.DOWN_SLASH:
               _loc1_.add("down slash");
               break;
            case Moves.DOWN_STAB:
               _loc1_.add("down stab");
               break;
            case Moves.SUMMON_BEAM:
               _loc1_.add("light beam");
               break;
            case Moves.SPIN_ATTACK:
               _loc1_.add("spin attack");
               break;
            case Moves.LUNGE_ATTACK:
               _loc1_.add("power");
               _loc2_ += Person(this.hitTester.hitType.hitter).frameHandler.releasedCharge / 5;
               break;
            default:
               _loc1_.add("");
         }
         if(this.hitTester.hitType.hitter is Person)
         {
            _loc2_ += Person(this.hitTester.hitType.hitter).keyHandler.moveStarter.getWeaponSkillKnockback(this.hitTester.hitType.isPrimary);
         }
         var _loc3_:Number = Number(MoveTo.getDirX(this.hitTester.hitType.moveStat.knockback + _loc2_,this.hitTester.hitType.moveStat.hitRot + (Person(this.hitTester.hitType.hitter).scaleX == -1 ? 180 : 0)));
         var _loc4_:Number = Number(MoveTo.getDirY(this.hitTester.hitType.moveStat.knockback + _loc2_,this.hitTester.hitType.moveStat.hitRot));
         _loc3_ = Number(this.__gravityObject.getWeightEffectVel(_loc3_));
         _loc4_ = Number(this.__gravityObject.getWeightEffectVel(_loc4_));
         this.__gravityObject.velX += _loc3_;
         this.__gravityObject.velY += _loc4_;
         _loc1_.add(_loc3_,_loc4_,this.x,this.y);
         MainStarlingStage(root).gameMain.theConnection.sendMessage(_loc1_);
      }
      
      public function setDirTime() : void
      {
         var _loc1_:int = this.__gravityObject.hit_rect.x + this.__gravityObject.hit_rect.width / 2;
         var _loc2_:int = this.__gravityObject.hit_rect.y + this.__gravityObject.hit_rect.height + 2;
         var _loc3_:int = 0;
         while(this.__gravityObject.currentGroundBitmapData.getPixel(_loc1_,_loc2_) > 0 && this.__gravityObject.currentGroundBitmapData.getPixel(_loc1_,_loc2_ - 100) == 0)
         {
            _loc1_ += 100;
            _loc3_ += 100;
         }
         _loc1_ = this.__gravityObject.hit_rect.x + this.__gravityObject.hit_rect.width / 2;
         while(this.__gravityObject.currentGroundBitmapData.getPixel(_loc1_,_loc2_) > 0 && this.__gravityObject.currentGroundBitmapData.getPixel(_loc1_,_loc2_ - 100) == 0)
         {
            _loc1_ -= 100;
            _loc3_ += 100;
         }
         _loc3_ = _loc3_ < 50 ? 200 : _loc3_;
         this.dirChangeTime = _loc3_ / (this.moveSpeed * 15);
      }
      
      public function rightClick() : void
      {
         var _loc1_:Vector.<String> = new Vector.<String>();
         _loc1_.push("heropedia");
         if(Boolean(MainStarlingStage(root).gameMain.hasEnemyControl) && MainStarlingStage(root).gameMain.player.isControllingPet == false)
         {
            _loc1_.push("control me");
         }
         MainStarlingStage(root).gameMain.createRCMenu(_loc1_,{
            "enemyName":name,
            "enemyType":this.type
         });
      }
      
      public function controlMe(param1:Person) : void
      {
         if(this.controlling_person == param1)
         {
            return;
         }
         this.controlling_person = param1;
         param1.isControllingEnemy = true;
         param1.keyHandler.keyRelease(Keyboard.LEFT);
         param1.keyHandler.keyRelease(Keyboard.RIGHT);
         this.keyRelease(Keyboard.LEFT);
         this.keyRelease(Keyboard.RIGHT);
         if(param1.isPlayer)
         {
            MainStarlingStage(root).gameMain.theConnection.send("controlEnemy",name);
         }
      }
      
      public function noControlMe() : void
      {
         if(this.controlling_person == null)
         {
            return;
         }
         this.moveDir = RanOne.ranOne();
         if(this.moveDir == 1)
         {
            this.keyRelease(Keyboard.LEFT);
            this.keyPress(Keyboard.RIGHT);
         }
         else
         {
            this.keyRelease(Keyboard.RIGHT);
            this.keyPress(Keyboard.LEFT);
         }
         if(this.controlling_person.isPlayer)
         {
            MainStarlingStage(root).gameMain.theConnection.send("noControlEnemy",this.moveDir);
         }
         this.controlling_person.isControllingEnemy = false;
         this.controlling_person = null;
      }
      
      public function get hasDash() : Boolean
      {
         return this.__hasDash;
      }
      
      public function get gravityObject() : GravityObject
      {
         return this.__gravityObject;
      }
      
      private function setLastFrames() : void
      {
         var _loc1_:FrameLabel = null;
         for each(_loc1_ in currentLabels)
         {
            if(_loc1_.name == "walk")
            {
               this.lastWalkFrame = _loc1_.frame;
            }
            else if(_loc1_.name == "jump")
            {
               this.lastJumpFrame = _loc1_.frame;
            }
         }
      }
      
      private function handleExitFrames() : void
      {
         if(this.gravityObject.counter % 10 == 0)
         {
            if(CommonCalls.onScreen(x,y,true,true) == false)
            {
               stop();
            }
            else
            {
               play();
            }
         }
         if(isPlaying)
         {
            if(currentFrame == this.lastWalkFrame - 1)
            {
               gotoAndPlayLabel("walk");
            }
            else if(currentFrame == this.lastJumpFrame - 1)
            {
               gotoAndPlayLabel("jump");
            }
         }
      }
   }
}

