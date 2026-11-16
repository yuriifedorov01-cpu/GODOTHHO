package com.game_objects.extensions
{
   import com.game_objects.*;
   import com.game_objects.enemies.*;
   import com.helpers.*;
   import com.math.*;
   import com.sound.*;
   import com.stats.*;
   import flash.media.Sound;
   import flash.ui.*;
   import flash.utils.*;
   
   public class PersonKeyHandler
   {
      
      public static const KEY_TIMING_INT:uint = 1;
      
      private var person:Person;
      
      public var cKeyDown:Boolean = false;
      
      private var gameMain:GameMain;
      
      public var keyStates:KeyStates;
      
      private var downKeys:Dictionary = new Dictionary();
      
      public var moveStarter:MoveHandler;
      
      private var unDoneKeyCode:uint = 0;
      
      private var unDoneKeyTime:uint = 0;
      
      public function PersonKeyHandler(param1:Person, param2:GameMain)
      {
         super();
         this.person = param1;
         this.gameMain = param2;
         this.keyStates = new KeyStates();
         this.moveStarter = new MoveHandler(param1,param2);
      }
      
      public function onEnter() : void
      {
         this.keyStates.onEnter();
         this.twoKeysChecker();
      }
      
      public function twoKeysChecker() : void
      {
         if(this.person.ridingPet == null)
         {
            if(this.person.gravityObject.onGround == false)
            {
               if(this.keyStates.simuKeyPress(Keyboard.DOWN,Keyboard.SPACE))
               {
                  if(Stats.wStats[this.person.bodyAnimator.weaponString].sRate > 0)
                  {
                     if(this.person.MP >= this.person.levelMP(Person.JUMP_GRENADE_MP))
                     {
                        this.moveStarter.doCowbowAirGrenade();
                     }
                  }
                  else if(Stats.wStats[this.person.bodyAnimator.weaponString].isRange)
                  {
                     if(this.person.MP >= this.person.levelMP(Person.DOWN_CRUSH_MP))
                     {
                        this.moveStarter.doArcherDownStab();
                     }
                  }
                  else if(Stats.wStats[this.person.bodyAnimator.weaponString].isMagic == false)
                  {
                     if(this.person.MP >= this.person.levelMP(Person.AIR_SLASH_MP))
                     {
                        this.moveStarter.doWarriorDownSlash();
                     }
                  }
               }
            }
            else if(this.keyStates.simuKeyPress(Keyboard.DOWN,Keyboard.SPACE))
            {
               if(Stats.wStats[this.person.bodyAnimator.weaponString].sRate > 0)
               {
                  if(this.person.ridingPet == null)
                  {
                     this.person.bodyAnimator.gotoAndStop("ducking");
                  }
               }
               else if(Stats.wStats[this.person.bodyAnimator.weaponString].isRange)
               {
                  if(this.person.MP >= this.person.levelMP(Person.ARROW_TRIPLE_MP))
                  {
                     this.moveStarter.doTripleArrow();
                  }
               }
               else if(Stats.wStats[this.person.bodyAnimator.weaponString].isMagic == false)
               {
                  if(this.person.MP >= this.person.levelMP(Person.MULTI_ATTACK_MP))
                  {
                     this.moveStarter.doGroundStab();
                  }
                  else if(this.person.MP < this.person.levelMP(Person.MULTI_ATTACK_MP) && Boolean(this.person.isPlayer))
                  {
                     this.gameMain.createAlert("not enough MP");
                  }
               }
               else if(this.person.MP >= this.person.levelMP(Person.THUNDER_MP))
               {
                  this.moveStarter.doSummonLightning();
               }
            }
         }
         if(this.person.moveDir == 1 && this.keyStates.simuKeyPress(Keyboard.RIGHT,Keyboard.SPACE) || this.person.moveDir == -1 && this.keyStates.simuKeyPress(Keyboard.LEFT,Keyboard.SPACE))
         {
            if(this.person.ridingPet == null)
            {
               if(Stats.wStats[this.person.bodyAnimator.weaponString].sRate > 0)
               {
                  if(this.person.MP >= this.person.levelMP(Person.SHOTGUN_MP))
                  {
                     this.moveStarter.doShotgunAttack();
                  }
               }
               else if(Stats.wStats[this.person.bodyAnimator.weaponString].isRange)
               {
                  if(this.person.MP >= this.person.levelMP(Person.ARROW_PIERCE_MP))
                  {
                     this.moveStarter.doPiercingArrow();
                  }
               }
               else if(Stats.wStats[this.person.bodyAnimator.weaponString].isMagic == false)
               {
                  if(this.person.MP >= this.person.levelMP(Person.POWER_ATTACK_MP))
                  {
                     this.moveStarter.doWarriorForwardCharge();
                  }
               }
            }
            else
            {
               this.moveStarter.doPetSummonFoward();
            }
         }
         if(this.keyStates.simuKeyPress(Keyboard.UP,Keyboard.SPACE))
         {
            if(this.person.ridingPet == null)
            {
               if(Boolean(Stats.wStats[this.person.bodyAnimator.weaponString].isMagic) || Boolean(this.person.bodyAnimator.weapon2String != "none" && Stats.wStats[this.person.bodyAnimator.weapon2String].isMagic) && Boolean(Stats.wStats[this.person.bodyAnimator.weaponString].defense > 0))
               {
                  if(this.person.MP >= this.person.levelMP(Person.LIGHT_BEAM_MP))
                  {
                     this.moveStarter.doMagicUpAttack();
                  }
               }
               else if(Stats.wStats[this.person.bodyAnimator.weaponString].sRate > 0)
               {
                  if(this.person.upwardShootLvl > 1 && this.person.MP >= this.person.levelMP(Person.GUN_UPWARD_MP))
                  {
                     this.moveStarter.doCowboyUpShoot();
                  }
                  else if(Boolean(this.person.isPlayer) && this.person.upwardShootLvl == 1)
                  {
                     this.gameMain.createAlert("your upward shoot skill is not high enough level to use");
                  }
                  else if(Boolean(this.person.isPlayer) && this.person.MP < this.person.levelMP(Person.GUN_UPWARD_MP))
                  {
                     this.gameMain.createAlert("not enough MP");
                  }
               }
               else if(Stats.wStats[this.person.bodyAnimator.weaponString].isRange)
               {
                  if(this.person.arrowRainLvl > 1 && this.person.MP >= this.person.levelMP(Person.ARROW_RAIN_MP))
                  {
                     this.moveStarter.doArcherRainAttack();
                  }
                  else if(this.person.MP < 5 && Boolean(this.person.isPlayer))
                  {
                     this.gameMain.createAlert("not enough MP");
                  }
               }
               else if(this.person.MP >= this.person.levelMP(Person.SPIN_ATTACK_MP))
               {
                  this.moveStarter.doWarriorUpAttack();
               }
            }
         }
      }
      
      public function get lastNonDirKey() : uint
      {
         var _loc1_:* = int(this.keyStates.keyPress_array.length - 1);
         while(_loc1_ >= 0)
         {
            if(this.keyStates.keyPress_array[_loc1_] != Keyboard.LEFT && this.keyStates.keyPress_array[_loc1_] != Keyboard.RIGHT && this.keyStates.keyPress_array[_loc1_] != Keyboard.DOWN && this.keyStates.keyPress_array[_loc1_] != Keyboard.UP)
            {
               return this.keyStates.keyPress_array[_loc1_];
            }
            _loc1_--;
         }
         return Keyboard.SPACE;
      }
      
      public function emptyKeyPressArrays() : void
      {
         this.keyStates.keyPress_array.length = 0;
         this.keyStates.keyFrame_array.length = 0;
      }
      
      public function keyPress(param1:uint) : void
      {
         var _loc2_:Pet = null;
         var _loc3_:Pet = null;
         var _loc4_:Item = null;
         var _loc5_:Number = Number(NaN);
         if(!this.downKeys[param1])
         {
            this.downKeys[param1] = true;
            switch(param1)
            {
               case Keyboard.O:
                  if(this.gameMain.p_array.length > 1 && this.person.ridingPet == null && this.person.bodyAnimator.currentLabel == "standing" && (this.person.energyController.fullTotal > 0 || this.person.isPlayer == false))
                  {
                     this.person.bodyAnimator.gotoAndPlay("give energy");
                     if(this.person.isPlayer)
                     {
                        this.gameMain.theConnection.send("kd",Keyboard.O);
                     }
                  }
                  break;
               case Keyboard.LEFT:
                  if(this.person.isControllingPet == false && this.person.isControllingEnemy == false)
                  {
                     this.person.jumpedWhileDashing = false;
                     if(Boolean(this.person.gravityObject.onGround) && Boolean(this.person.isFrameLabel("running","pet walking","standing","pet standing")) && this.keyStates.keyPress_array.length > 0 && this.keyStates.keyPress_array[this.keyStates.keyPress_array.length - 1] == Keyboard.LEFT)
                     {
                        if(this.keyStates.framesSinceKeyPress(this.keyStates.keyFrame_array.length - 1) < 9)
                        {
                           if(this.person.MP >= this.person.levelMP(3))
                           {
                              this.person.bodyAnimator.gotoAndPlay(this.person.ridingPet == null ? "dashing" : "pet dashing");
                           }
                           else if(this.person.isPlayer)
                           {
                              this.gameMain.createAlert("not enough MP");
                           }
                        }
                     }
                     if(Boolean(this.person.isPlayer) && this.person.fishing == false && (this.gameMain.p_array.length > 1 || this.gameMain.pet_array.length > 0))
                     {
                        this.gameMain.theConnection.send("kd",Keyboard.LEFT,2,int(this.person.gravityObject.hit_rect.x),int(this.person.gravityObject.hit_rect.y));
                     }
                  }
                  else if(this.person.isControllingPet)
                  {
                     Pet(this.person.controlledObject().creator).keyPress(param1);
                     if(this.person.isPlayer)
                     {
                        this.gameMain.theConnection.send("kd",Keyboard.LEFT);
                     }
                  }
                  else
                  {
                     Enemy(this.person.controlledObject().creator).keyPress(Keyboard.LEFT);
                     if(this.person.isPlayer)
                     {
                        this.gameMain.theConnection.send("kd",Keyboard.LEFT);
                     }
                  }
                  break;
               case Keyboard.RIGHT:
                  if(this.person.isControllingPet == false && this.person.isControllingEnemy == false)
                  {
                     this.person.jumpedWhileDashing = false;
                     if(Boolean(this.person.gravityObject.onGround) && Boolean(this.person.isFrameLabel("running","pet walking","standing","pet standing")) && this.keyStates.keyPress_array.length > 0 && this.keyStates.keyPress_array[this.keyStates.keyPress_array.length - 1] == Keyboard.RIGHT)
                     {
                        if(this.keyStates.framesSinceKeyPress(this.keyStates.keyFrame_array.length - 1) < 9)
                        {
                           if(this.person.MP >= this.person.levelMP(3))
                           {
                              this.person.bodyAnimator.gotoAndPlay(this.person.ridingPet == null ? "dashing" : "pet dashing");
                           }
                           else if(this.person.isPlayer)
                           {
                              this.gameMain.createAlert("not enough MP");
                           }
                        }
                     }
                     if(Boolean(this.person.isPlayer) && this.person.fishing == false && (this.gameMain.p_array.length > 1 || this.gameMain.pet_array.length > 0))
                     {
                        this.gameMain.theConnection.send("kd",Keyboard.RIGHT,2,int(this.person.gravityObject.hit_rect.x),int(this.person.gravityObject.hit_rect.y));
                     }
                  }
                  else if(this.person.isControllingPet)
                  {
                     Pet(this.person.controlledObject().creator).keyPress(param1);
                     if(this.person.isPlayer)
                     {
                        this.gameMain.theConnection.send("kd",Keyboard.RIGHT);
                     }
                  }
                  else
                  {
                     Enemy(this.person.controlledObject().creator).keyPress(Keyboard.RIGHT);
                     if(this.person.isPlayer)
                     {
                        this.gameMain.theConnection.send("kd",Keyboard.RIGHT);
                     }
                  }
                  break;
               case Keyboard.UP:
                  if(this.person.isPlayer)
                  {
                     this.gameMain.theConnection.send("kd",Keyboard.UP,2,int(this.person.gravityObject.hit_rect.x),int(this.person.gravityObject.hit_rect.y));
                  }
                  if(this.person.isControllingPet == false && this.person.isControllingEnemy == false)
                  {
                     if(this.person.gravityObject.jumps < this.person.gravityObject.maxJumps && MoveStat.isAttackingFrame(this.person) == false)
                     {
                        this.person.jumpedWhileDashing = this.person.bodyAnimator.currentLabel == "dashing" || this.person.bodyAnimator.currentLabel == "pet dashing" || Boolean(this.person.jumpedWhileDashing);
                        if(this.person.isFrameLabel("wall slide","pet wall slide") == false || Boolean(this.person.gravityObject.onGround))
                        {
                           this.person.gravityObject.velY = this.person.gravityObject.jumps == 0 ? -this.person.jumpPower : -this.person.jumpPower * 0.8;
                        }
                        else
                        {
                           this.person.gravityObject.velY = -this.person.jumpPower * 0.9;
                           this.person.gravityObject.velX = -this.person.jumpPower * 0.8 * this.person.scaleX;
                        }
                        SoundManager.playSound(Math.random() > 0.5 ? SoundLibrary.jump_sound : SoundLibrary.jump2_sound,this.person.x,this.person.y,true,this.person.parent);
                        ++this.person.controlledObject().jumps;
                     }
                  }
                  else if(this.person.isControllingPet)
                  {
                     Pet(this.person.controlledObject().creator).keyPress(param1);
                  }
                  else
                  {
                     Enemy(this.person.controlledObject().creator).keyPress(param1);
                  }
                  break;
               case Keyboard.DOWN:
                  if(this.person.isControllingPet == false && this.person.isControllingEnemy == false)
                  {
                     if(this.person.gravityObject.onGround == false && !(this.person.bodyAnimator.helmetString == "chicken hat" && this.person.bodyAnimator.shirtString == "chicken outfit" && this.person.bodyAnimator.pantsString == "chicken pants"))
                     {
                        if(this.person.gravityObject.velY < 0)
                        {
                           this.person.gravityObject.accelDownMultiplier = 0.4 + this.person.accelDownLvl / 10;
                        }
                        else
                        {
                           this.person.gravityObject.accelDownMultiplier = 1 + this.person.accelDownLvl / 10;
                        }
                     }
                     if(this.person.bodyAnimator.currentLabel != "take hit" && this.person.bodyAnimator.currentLabel != "pet take hit" && MoveStat.isAttackingFrame(this.person) == false)
                     {
                        if(this.person.gravityObject.onGround == false && this.person.flaps < 5 && this.person.bodyAnimator.helmetString == "chicken hat" && this.person.bodyAnimator.shirtString == "chicken outfit" && this.person.bodyAnimator.pantsString == "chicken pants")
                        {
                           if(this.person.bodyAnimator.currentLabel == "jumping")
                           {
                              this.person.gravityObject.velY = -13;
                              this.person.bodyAnimator.gotoAndPlay("flap");
                              ++this.person.flaps;
                              SoundManager.playSound(SoundLibrary.wingFlap_sound,this.person.x,this.person.y,true,this.person.parent);
                           }
                           else if(this.person.bodyAnimator.currentLabel == "pet jumping")
                           {
                              this.person.gravityObject.velY -= 11;
                              this.person.bodyAnimator.gotoAndPlay("pet flap");
                              ++this.person.flaps;
                              SoundManager.playSound(SoundLibrary.wingFlap_sound,this.person.x,this.person.y,true,this.person.parent);
                           }
                        }
                     }
                  }
                  else if(this.person.isControllingPet)
                  {
                     Pet(this.person.controlledObject().creator).keyPress(param1);
                  }
                  else
                  {
                     Enemy(this.person.controlledObject().creator).keyPress(param1);
                  }
                  if(this.person.isPlayer)
                  {
                     this.gameMain.theConnection.send("kd",param1,-2);
                  }
                  break;
               case Keyboard.C:
                  switch(this.person.bodyAnimator.weaponString)
                  {
                     case "fishing pole":
                        if(MoveStat.isAttackingFrame(this.person) == false && this.cKeyDown == false && this.person.isControllingPet == false && this.person.bodyAnimator.currentLabel != "ducking")
                        {
                           if(this.person.ridingPet == null)
                           {
                              this.person.bodyAnimator.gotoAndPlay("attack");
                           }
                           else
                           {
                              this.person.bodyAnimator.gotoAndPlay("pet attack");
                              this.person.bodyAnimator.pet.gotoAndPlayStanding();
                           }
                           if(this.person.isPlayer)
                           {
                              this.person.lastAttack = this.person.bodyAnimator.currentLabel;
                              this.person.attackCounter = 0;
                           }
                           SoundManager.playSound(SoundLibrary.swoosh1_sound,this.person.x,this.person.y,true,this.person.parent);
                        }
                        if(this.person.isPlayer)
                        {
                           this.gameMain.theConnection.send("kd",Keyboard.C,this.person.bodyAnimator.currentFrame);
                        }
                        break;
                     default:
                        this.pressSpace(param1);
                  }
                  this.cKeyDown = true;
                  break;
               case Keyboard.SPACE:
                  if(this.person.isControllingPet == false && this.person.isControllingEnemy == false)
                  {
                     if(this.person.fishing)
                     {
                        this.person.fishingLine.stopSink = true;
                     }
                     this.pressSpace();
                  }
                  else if(this.person.isControllingPet)
                  {
                     Pet(this.person.controlledObject().creator).keyPress(param1);
                  }
                  break;
               case Keyboard.H:
                  if(this.person.isPlayer)
                  {
                     if(Boolean(Stats.wStats[this.person.bodyAnimator.weaponString].isMagic || this.person.bodyAnimator.weapon2String != "none" && Stats.wStats[this.person.bodyAnimator.weapon2String].isMagic) && Boolean(this.person.MP >= this.person.levelMP(Person.HEAL_MP)) && this.person.health > 0)
                     {
                        this.person.MP -= this.person.levelMP(Person.HEAL_MP);
                        this.gameMain.theConnection.send("useMP",this.person.levelMP(Person.HEAL_MP));
                        this.gameMain.theConnection.send("pHealed",35 + this.person.selfHealLvl * 5);
                        SoundManager.playSound(SoundLibrary.heal_sound,this.person.x,this.person.y,true,this.person.parent);
                     }
                     else if(this.person.MP < this.person.levelMP(Person.HEAL_MP))
                     {
                        this.gameMain.createAlert("not enough MP");
                     }
                     else
                     {
                        this.gameMain.createAlert("you must have a magic weapon equipped to cast heal");
                     }
                  }
                  break;
               case Keyboard.T:
                  if(Boolean(this.person.isPlayer) && this.person.guild != "")
                  {
                     if(this.person.guildRageLvl > 1)
                     {
                        if(this.person.MP >= this.person.levelMP(Person.GUILD_RAGE_MP))
                        {
                           this.gameMain.theConnection.send("guildRage");
                           this.gameMain.theConnection.send("useMP",this.person.levelMP(Person.GUILD_RAGE_MP));
                        }
                        else
                        {
                           this.gameMain.createAlert("not enough MP");
                        }
                     }
                     else
                     {
                        this.gameMain.createAlert("Guild rage level must be higher than level 1 to use");
                     }
                  }
                  break;
               case Keyboard.R:
                  if(this.person.bodyAnimator.currentLabel == "standing" || this.person.bodyAnimator.currentLabel == "pet standing")
                  {
                     this.person.powerUpVisuals.powerUp();
                     if(this.person.isPlayer)
                     {
                        this.gameMain.theConnection.send("kd",Keyboard.R);
                        this.gameMain.theConnection.send("energy",this.person.energyController.charge,this.person.energyController.fullTotal);
                     }
                  }
                  break;
               case Keyboard.Q:
                  for each(_loc2_ in this.person.activePets)
                  {
                     if(_loc2_.mode != "m" && _loc2_.bubbling == false && CalcDist.getDistNumbers(this.person.x,this.person.y,_loc2_.x,_loc2_.y) > 200)
                     {
                        if(this.person.isPlayer)
                        {
                           this.gameMain.theConnection.send("kd",Keyboard.Q);
                        }
                        _loc2_.startBubble();
                     }
                  }
                  break;
               case Keyboard.G:
                  if(this.person.isPlayer)
                  {
                     if(Boolean(Stats.wStats[this.person.bodyAnimator.weaponString].isMagic || this.person.bodyAnimator.weapon2String != "none" && Stats.wStats[this.person.bodyAnimator.weapon2String].isMagic) && Boolean(this.person.MP >= Person.GUILD_HEAL_MP) && this.person.health > 0)
                     {
                        this.person.MP -= Person.GUILD_HEAL_MP;
                        this.gameMain.theConnection.send("useMP",Person.GUILD_HEAL_MP);
                        this.gameMain.theConnection.send("pHealed",20 + this.person.guildHealLvl * 5,0,true);
                        for each(_loc3_ in this.person.activePets)
                        {
                           this.gameMain.theConnection.send("petHealed",20 + this.person.guildHealLvl * 5,_loc3_.name);
                        }
                        SoundManager.playSound(SoundLibrary.heal_sound,this.person.x,this.person.y,true,this.person.parent);
                     }
                     else if(this.person.MP < 32)
                     {
                        this.gameMain.createAlert("not enough MP");
                     }
                     else
                     {
                        this.gameMain.createAlert("you must have a magic weapon equipped to cast guild heal");
                     }
                  }
                  break;
               case Keyboard.Y:
                  this.person.powerUpVisuals.unleash();
                  if(Boolean(this.person.isPlayer) && this.person.energyController.fullTotalScale > 0)
                  {
                     this.gameMain.theConnection.send("unleash",this.person.energyController.fullTotal,this.person.energyController.charge);
                  }
                  break;
               case Keyboard.E:
                  if(this.person.isControllingPet == false && this.person.health > 0)
                  {
                     for each(_loc4_ in this.gameMain.item_array)
                     {
                        if(_loc4_.type.indexOf("spawn ball") == -1)
                        {
                           if(_loc4_.alpha == 1 && Boolean(this.person.getBounds(this.person.root).intersects(_loc4_.getBounds(_loc4_.root))) && (this.gameMain.personItem_array.length < this.gameMain.maxItems || _loc4_.type == "coin"))
                           {
                              if(_loc4_.playerDibs != "-none-")
                              {
                                 this.gameMain.theConnection.send("giReI",_loc4_.name,int(_loc4_.gravityObject.hit_rect.x),int(_loc4_.gravityObject.hit_rect.y));
                              }
                              break;
                           }
                        }
                     }
                  }
                  else
                  {
                     Pet(this.person.controlledObject().creator).keyPress(param1);
                  }
                  break;
               case Keyboard.K:
                  if(this.person.bodyAnimator.accessoryString == "monkey tail" && this.person.bodyAnimator.currentLabel == "standing")
                  {
                     this.person.bodyAnimator.gotoAndPlay("fart");
                     _loc5_ = Math.random();
                     if(_loc5_ < 0.5)
                     {
                        SoundManager.playSound(SoundLibrary.fart1_sound,this.person.x,this.person.y,true,this.person.parent);
                     }
                     else if(_loc5_ < 0.93)
                     {
                        SoundManager.playSound(SoundLibrary.fart2_sound,this.person.x,this.person.y,true,this.person.parent);
                     }
                     else
                     {
                        this.person.createExclaim("!",42);
                        SoundManager.playSound(SoundLibrary.fart3_sound,this.person.x,this.person.y,true,this.person.parent);
                     }
                     if(this.person.isPlayer)
                     {
                        this.gameMain.theConnection.send("kd",Keyboard.K,1);
                     }
                  }
            }
            if(this.person.isControllingPet == false && this.person.isControllingEnemy == false)
            {
               this.keyStates.pressKey(param1);
            }
            return;
         }
      }
      
      public function keyRelease(param1:uint, param2:Boolean = true) : void
      {
         delete this.downKeys[param1];
         switch(param1)
         {
            case Keyboard.LEFT:
               if(this.person.isControllingPet == false && this.person.isControllingEnemy == false)
               {
                  if(this.person.bodyAnimator.currentLabel == "dashing")
                  {
                     this.person.bodyAnimator.gotoAndPlay("running");
                  }
                  else if(this.person.bodyAnimator.currentLabel == "pet dashing")
                  {
                     this.person.bodyAnimator.gotoAndPlay("pet walking");
                     this.person.bodyAnimator.pet.gotoAndPlayWalking();
                  }
               }
               else if(this.person.isControllingPet)
               {
                  Pet(this.person.controlledObject().creator).keyRelease(param1);
               }
               else
               {
                  Enemy(this.person.controlledObject().creator).keyRelease(param1);
               }
               break;
            case Keyboard.RIGHT:
               if(this.person.isControllingPet == false && this.person.isControllingEnemy == false)
               {
                  if(this.person.bodyAnimator.currentLabel == "dashing")
                  {
                     this.person.bodyAnimator.gotoAndPlay("running");
                  }
                  else if(this.person.bodyAnimator.currentLabel == "pet dashing")
                  {
                     this.person.bodyAnimator.gotoAndPlay("pet walking");
                     this.person.bodyAnimator.pet.gotoAndPlayWalking();
                  }
               }
               else if(this.person.controlledObject().creator is Pet)
               {
                  Pet(this.person.controlledObject().creator).keyRelease(param1);
               }
               else
               {
                  Enemy(this.person.controlledObject().creator).keyRelease(param1);
               }
               break;
            case Keyboard.SPACE:
               this.person.conBulletsShot = 0;
               break;
            case Keyboard.C:
               this.keyRelease(Keyboard.SPACE);
               this.cKeyDown = false;
               this.person.stopFishing();
               break;
            case Keyboard.UP:
               if(this.person.isControllingEnemy == false)
               {
                  if(this.person.gravityObject.velY < -(this.person.jumpPower / 1.5))
                  {
                     this.person.gravityObject.velY = -(this.person.jumpPower / 1.5);
                  }
                  if(this.person.bodyAnimator.currentLabel == "gliding")
                  {
                     this.person.gravityObject.accelDownMultiplier = 0;
                     this.person.bodyAnimator.gotoAndPlay("jumping");
                  }
               }
               else
               {
                  Enemy(this.person.controlledObject().creator).keyRelease(param1);
               }
               break;
            case Keyboard.DOWN:
               if(Boolean(this.person.isControllingPet) && this.person.isControllingEnemy == false)
               {
                  Pet(this.person.controlledObject().creator).keyRelease(param1);
               }
               else if(this.person.isControllingEnemy)
               {
                  Enemy(this.person.controlledObject().creator).keyRelease(param1);
               }
               break;
            case Keyboard.R:
               this.person.powerUpVisuals.stopPowerUp();
         }
         if(this.person.isPlayer)
         {
            if(param1 != Keyboard.LEFT && param1 != Keyboard.RIGHT && param1 != Keyboard.UP)
            {
               this.gameMain.theConnection.send("ku",param1);
            }
            else
            {
               this.gameMain.theConnection.send("ku",param1,int(this.person.gravityObject.hit_rect.x),int(this.person.gravityObject.hit_rect.y));
            }
         }
         this.keyStates.releaseKey(param1);
      }
      
      public function pressSpace(param1:uint = 32) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Boolean = false;
         if(Boolean(this.person.isPlayer) && (this.person.bodyAnimator.currentFrame == 79 || this.person.bodyAnimator.currentFrame == 406))
         {
            this.gameMain.theConnection.send("kd",param1,this.person.bodyAnimator.currentFrame);
         }
         if(this.person.fishing)
         {
            return;
         }
         if(Boolean(this.person.isPlayer) && Stats.wStats[this.person.bodyAnimator.weaponString].sRate > 0 && this.gameMain.p_array.length > 1)
         {
            if(this.person.isPlayer)
            {
               this.gameMain.theConnection.send("kd",param1,-this.person.bodyAnimator.currentFrame);
            }
         }
         if(this.person.isControllingPet == false && this.person.isFrameLabel("ducking","dashing","pet dashing","take hit","pet take hit","gliding") == false)
         {
            if(Stats.wStats[this.person.bodyAnimator.weaponString].sRate > 0)
            {
               _loc3_ = this.moveStarter.doShootGun();
            }
            else if(Stats.wStats[this.person.bodyAnimator.weaponString].defense > 0)
            {
               _loc3_ = this.moveStarter.doWarriorShield();
            }
            else if(Stats.wStats[this.person.bodyAnimator.weaponString].isRange == false && this.person.bodyAnimator.weapon2String != "none")
            {
               _loc3_ = this.moveStarter.doWarriorTwoWeapons();
            }
            else if(Stats.wStats[this.person.bodyAnimator.weaponString].isRange == false)
            {
               if(Boolean(this.person.isPlayer) && this.person.bodyAnimator.weaponString == "net" && Math.random() > 0.99)
               {
                  this.gameMain.arrayStringRemove(this.gameMain.personItem_array,"net");
                  this.person.createExclaim("net broken!",18);
                  this.gameMain.theConnection.send("breakNet");
                  SoundManager.playSound(SoundLibrary.stickBreak_sound,this.person.x,this.person.y,true,this.person.parent);
               }
               else if(Boolean(this.person.isPlayer) && this.person.bodyAnimator.weaponString == "chainsaw" && Math.random() > 0.99)
               {
                  this.gameMain.arrayStringRemove(this.gameMain.personItem_array,"chainsaw");
                  this.person.createExclaim("chainsaw broke!",18);
                  this.gameMain.theConnection.send("breakChainsaw");
                  SoundManager.playSound(SoundLibrary.stickBreak_sound,this.person.x,this.person.y,true,this.person.parent);
               }
               _loc3_ = this.moveStarter.doWarriorOneWeapon();
            }
            else
            {
               _loc3_ = this.moveStarter.doArcherShoot();
            }
            if(this.gameMain.p_array.length > 1)
            {
               if(Stats.wStats[this.person.bodyAnimator.weaponString].isMagic == false && this.person.bodyAnimator.weapon2String != "none" && Stats.wStats[this.person.bodyAnimator.weapon2String].isMagic == false)
               {
                  if(this.person.isPlayer)
                  {
                     this.gameMain.theConnection.send("kd",param1,this.person.bodyAnimator.currentFrame);
                  }
               }
               else if(Stats.wStats[this.person.bodyAnimator.weaponString].sRate == 0)
               {
                  _loc2_ = Stats.wStats[this.person.bodyAnimator.weaponString].isRange == false ? this.person.bodyAnimator.currentFrame : -this.person.bodyAnimator.currentFrame;
                  if(this.person.isPlayer)
                  {
                     this.gameMain.theConnection.send("kd",param1,_loc2_);
                  }
               }
            }
         }
         else if(this.person.bodyAnimator.currentLabel == "dashing" || this.person.bodyAnimator.currentLabel == "pet dashing")
         {
            if(this.person.ridingPet == null)
            {
               this.person.bodyAnimator.gotoAndPlay(Moves.DASH_ATTACK);
               SoundManager.playSound(SoundLibrary.swoosh1_sound,this.person.x,this.person.y,true,this.person.parent);
            }
            else
            {
               this.person.bodyAnimator.gotoAndPlay("pet dash attack");
               SoundManager.playSound(SoundLibrary.swoosh1_sound,this.person.x,this.person.y,true,this.person.parent);
            }
            _loc3_ = true;
            if(Boolean(this.person.isPlayer) && this.gameMain.p_array.length > 1)
            {
               this.gameMain.theConnection.send("kd",param1,this.person.bodyAnimator.currentFrame);
            }
            this.person.gravityObject.velY -= 11;
         }
         if(_loc3_)
         {
            this.person.canDamage = true;
         }
         if(Stats.wStats[this.person.bodyAnimator.weaponString].sRate == 0 && _loc3_ == false)
         {
            this.unDoneKeyCode = param1;
            this.unDoneKeyTime = this.person.gravityObject.counter;
         }
      }
      
      public function checkDoUnDoneKey() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:MoveStat = Moves.moveByName(this.person.bodyAnimator.currentLabel);
         if(_loc2_ != null && this.person.attackCounter >= _loc2_.earliestCombo)
         {
            _loc1_ = true;
         }
         if(this.unDoneKeyCode > 0 && !this.downKeys[this.unDoneKeyCode] && this.person.gravityObject.counter - this.unDoneKeyTime < 9 && (Boolean(this.person.isFrameLabel("standing","pet standing","running","pet walking")) || _loc1_))
         {
            this.keyPress(this.unDoneKeyCode);
            this.keyRelease(this.unDoneKeyCode);
            this.unDoneKeyCode = 0;
         }
      }
   }
}

