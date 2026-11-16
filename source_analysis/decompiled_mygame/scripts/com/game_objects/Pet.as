package com.game_objects
{
   import com.AI.*;
   import com.game_objects.enemies.Enemy;
   import com.game_objects.hit_detect.*;
   import com.gravityPackage.*;
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.helpers.*;
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
   import playerio.*;
   import starling.*;
   import starling.display.*;
   import starling.events.*;
   import starling.filters.*;
   import starling.text.*;
   import starling.utils.*;
   
   public class Pet extends Sprite implements IClickable
   {
      
      public static var petBodies_xml:XML;
      
      private static var helmetOffsetFrameX_array:Vector.<int> = new Vector.<int>();
      
      private static var helmetOffsetFrameY_array:Vector.<int> = new Vector.<int>();
      
      helmetOffsetFrameX_array.push(3,0,-3,0,5,2,4,7,8,6,9,8,11,9,8,7,5,2,2,6,5,4,6,13,7,2,8,4,5,6,6,5,12,9,12);
      helmetOffsetFrameY_array.push(0,0,3,-8,-3,4,-3,1,-3,-10,-21,-1,4,0,-4,-4,-6,-6,-23,0,-4,-5,-1,-9,-11,-5,-1,-8,-10,-12,-5,0,-1,-1,0);
      
      public var head_image:Image;
      
      public var helmet_image:Image;
      
      public var leftLeg_image:Image;
      
      public var rightLeg_image:Image;
      
      public var body_image:Image;
      
      public var shoeLeft_image:Image;
      
      public var shoeRight_image:Image;
      
      private var leftLeg_sprite:Sprite;
      
      private var rightLeg_sprite:Sprite;
      
      private var headX_array:Vector.<Number> = new Vector.<Number>();
      
      private var headY_array:Vector.<Number> = new Vector.<Number>();
      
      private var leftLegX_array:Vector.<Number> = new Vector.<Number>();
      
      private var leftLegY_array:Vector.<Number> = new Vector.<Number>();
      
      private var rightLegX_array:Vector.<Number> = new Vector.<Number>();
      
      private var rightLegY_array:Vector.<Number> = new Vector.<Number>();
      
      private var bodyX_array:Vector.<Number> = new Vector.<Number>();
      
      private var bodyY_array:Vector.<Number> = new Vector.<Number>();
      
      private var leftLegRotation_array:Vector.<Number> = new Vector.<Number>();
      
      private var rightLegRotation_array:Vector.<Number> = new Vector.<Number>();
      
      private var bodyScaleX_array:Vector.<Number> = new Vector.<Number>();
      
      private var bodyScaleY_array:Vector.<Number> = new Vector.<Number>();
      
      private var bodyFrameNames:Array = null;
      
      private var __currentFrame:uint = 0;
      
      private var __currentLabel:String = "standing";
      
      private var __totalFrames:uint = 0;
      
      private var __helmet_string:String = "pet none helmet";
      
      private var __helmet_uint:uint = 2;
      
      private var __shoes_string:String = "none shoe";
      
      private var __shoes_uint:uint = 24;
      
      public var originalOwner:String = "";
      
      public var mode:String = "n";
      
      public var moveMode:String = "follow";
      
      public var lvl:int = 1;
      
      public var dex:int = 0;
      
      public var defense:int = 0;
      
      public var power:int = 0;
      
      public var love:int = 0;
      
      public var len:int = 0;
      
      private var i:int = 0;
      
      public var xp:uint = 0;
      
      public var xpSplit:Number;
      
      public var isCompanion:Boolean = false;
      
      public var moveDir:int = 1;
      
      public var isActive:Boolean = false;
      
      public var isAttacking:Boolean = false;
      
      private var attackCounter:uint = 0;
      
      public var owner:Person;
      
      private var __dashing:Boolean = false;
      
      private var __bubbling:Boolean = false;
      
      private var bubbleRotation:int = 0;
      
      private var gameMain:GameMain;
      
      public var canDamage:Boolean = false;
      
      public var health:int = 0;
      
      public var totalHealth:int = 0;
      
      private var petAI:PetAI;
      
      public var keyStates:KeyStates;
      
      public var gravityObject:GravityObject;
      
      public var hitTester:HitTester;
      
      private var jumpPower:uint = 20;
      
      private var moveSpeed:uint = 9;
      
      private var __type:String;
      
      private var firstWalkFrame:uint = 0;
      
      private var helmetOffset_point:Point;
      
      private var name_txt:TextField;
      
      private var __isPlaying:Boolean = false;
      
      public var isManualControlling:Boolean = false;
      
      public function Pet(param1:GameMain, param2:String, param3:String)
      {
         super();
         name = param2;
         this.moveSpeed = 9;
         this.jumpPower = 20;
         this.gameMain = param1;
         this.keyStates = new KeyStates();
         touchGroup = true;
         this.petAI = new PetAI(this,param1);
         this.__type = param3;
         this.type = param3;
         this.updateFrame();
         var _loc4_:Rectangle = new Rectangle(getBounds(this).x,getBounds(this).y,width,height);
         this.gravityObject = new GravityObject(this,_loc4_);
         this.gravityObject.maxJumps = 2;
         this.hitTester = new HitTester(this,_loc4_);
         addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
      }
      
      public static function petRemove(param1:Vector.<Pet>, param2:Pet, param3:Boolean) : Boolean
      {
         if(param2.owner.isControllingPet)
         {
            param2.owner.togglePetControl();
         }
         var _loc4_:int = int(param1.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(param1[_loc5_] == param2)
            {
               if(param3)
               {
                  param1[_loc5_].removeFromParent(!param1[_loc5_].owner.isPlayer);
               }
               if(param1[_loc5_].owner.isPlayer)
               {
                  param1[_loc5_].addEventListener(Event.ADDED_TO_STAGE,param1[_loc5_].onAdded);
                  param1[_loc5_].addEventListener(Event.REMOVED_FROM_STAGE,param1[_loc5_].onRemoved);
               }
               param1.removeAt(_loc5_);
               return true;
            }
            _loc5_++;
         }
         return false;
      }
      
      public static function isCarType(param1:String) : Boolean
      {
         var _loc2_:String = String(param1).toLowerCase().replace(/\s+/g,"");
         return _loc2_ == "civic" || _loc2_ == "s2000" || _loc2_ == "nsx";
      }
      
      public function onEnter() : void
      {
         var _loc1_:Enemy = null;
         var _loc2_:Person = null;
         var _loc3_:Message = null;
         ++this.gravityObject.counter;
         if(this.owner.isControllingPet == false)
         {
            this.petAI.handleAI();
         }
         if(this.__bubbling == false)
         {
            if(this.keyStates.getKeyState(Keyboard.RIGHT).isDown)
            {
               this.gravityObject.velX += (this.__dashing == false ? this.moveSpeed : this.moveSpeed * 1.5) / (this.gravityObject.onGround ? 6.5 : 22);
               this.moveDir = 1;
            }
            else if(this.keyStates.getKeyState(Keyboard.LEFT).isDown)
            {
               this.gravityObject.velX -= (this.__dashing == false ? this.moveSpeed : this.moveSpeed * 1.5) / (this.gravityObject.onGround ? 6.5 : 22);
               this.moveDir = -1;
            }
         }
         if(this.owner.isPlayer && this.gravityObject.counter % 210 == 0)
         {
            this.gameMain.theConnection.send("petIn",this.gravityObject.hit_rect.x,this.gravityObject.hit_rect.y,this.moveDir,name);
         }
         scaleX = this.moveDir;
         if(this.__bubbling == false)
         {
            this.gravityObject.applyGravity(this.gameMain,this.gameMain.gravity);
         }
         else
         {
            this.handleBubble();
         }
         if(this.owner.isPlayer && this.gravityObject.counter % 30 == 0 && this.__bubbling == false)
         {
            for each(_loc1_ in this.gameMain.e_array)
            {
               if(this.gravityObject.hit_rect.intersects(_loc1_.hitTester.hit_rect))
               {
                  this.gameMain.theConnection.send("dmgPet",_loc1_.name,name);
               }
            }
         }
         if(this.gravityObject.velX != 0 && this.__currentFrame < this.firstWalkFrame + 1 && this.__bubbling == false)
         {
            this.gotoAndPlayWalking();
         }
         else if(this.gravityObject.velX == 0 && this.__currentFrame >= this.firstWalkFrame - 1 || Boolean(this.__bubbling))
         {
            this.gotoAndPlayStanding();
         }
         if(Boolean(this.__dashing) && this.currentLabel == "walking")
         {
            this.nextFrame();
            this.nextFrame();
            if(this.gravityObject.onGround && this.gravityObject.counter % 10 == 0)
            {
               SoundManager.playSound(SoundLibrary.running_sound,x,y,true,parent);
               this.gameMain.createDashCloud(this.gravityObject.previousX,this.gravityObject.previousY + 30,scaleX * -1,2,this.gravityObject.groundSlope);
            }
         }
         if(this.isVehicle)
         {
            rotation = 0;
         }
         else if(this.gravityObject.velY != 0 && this.__bubbling == false)
         {
            rotation += deg2rad(25 * this.moveDir);
         }
         else
         {
            rotation = 0;
         }
         this.handleAttacks();
         var _loc4_:Boolean = false;
         if(this.owner.isPlayer && Boolean(this.gameMain.isPvpArea))
         {
            for each(_loc2_ in this.gameMain.p_array)
            {
               if(_loc2_.isPlayer == false)
               {
                  this.hitTester.playerAdvancedHitCheck(_loc2_);
                  if(this.hitTester.hitType.hitter != null)
                  {
                     this.gameMain.lastEnemyNameHit = name;
                     _loc2_.canDamage = false;
                     _loc3_ = new Message("PdmgPet",_loc2_.name,name,!this.hitTester.hitType.isPrimary);
                     switch(this.hitTester.hitType.moveStat.name)
                     {
                        case Moves.GROUND_STAB:
                           StarExplosion.createExplosion(x,y,7,100,150,MainStarlingStage(root).c_mc,StarExplosion.DIR_UP);
                           LightPillar.createLightPiller(x,y,MainStarlingStage(root).gameMain.c_mc);
                           break;
                        case Moves.DOWN_SLASH:
                           _loc3_.add("down slash");
                           break;
                        case Moves.DOWN_STAB:
                           _loc3_.add("down stab");
                           break;
                        case Moves.SUMMON_BEAM:
                           _loc3_.add("light beam");
                           break;
                        case Moves.SPIN_ATTACK:
                           _loc3_.add("spin attack");
                     }
                     this.gameMain.theConnection.sendMessage(_loc3_);
                  }
               }
            }
         }
         if(Boolean(CommonCalls.onScreen(x,y,false,true)) && this.gravityObject.inWater && this.gravityObject.counter % 10 == 0 && Math.random() > 0.65)
         {
            this.gameMain.createWaterBubble(x,y - 7,this);
         }
         this.name_txt.x = x + parent.x - 60;
         this.name_txt.y = this.gravityObject.hit_rect.y + this.gravityObject.hit_rect.height + parent.y - 5;
         if(this.__isPlaying)
         {
            this.nextFrame();
         }
      }
      
      public function keyPress(param1:int) : void
      {
         var _loc2_:Item = null;
         switch(param1)
         {
            case Keyboard.RIGHT:
               if(this.gravityObject.onGround && this.keyStates.keyPress_array.length > 0 && this.keyStates.keyPress_array[this.keyStates.keyPress_array.length - 1] == Keyboard.RIGHT)
               {
                  if(this.keyStates.timeSinceKeyPress(this.keyStates.keyTime_array.length - 1) < 300)
                  {
                     this.__dashing = true;
                  }
               }
               break;
            case Keyboard.LEFT:
               if(this.gravityObject.onGround && this.keyStates.keyPress_array.length > 0 && this.keyStates.keyPress_array[this.keyStates.keyPress_array.length - 1] == Keyboard.LEFT)
               {
                  if(this.keyStates.timeSinceKeyPress(this.keyStates.keyTime_array.length - 1) < 300)
                  {
                     this.__dashing = true;
                  }
               }
               break;
            case Keyboard.UP:
               if(this.__bubbling == false)
               {
                  if(this.gravityObject.onGround || this.gravityObject.jumps < this.gravityObject.maxJumps)
                  {
                     this.gravityObject.velY = this.gravityObject.jumps == 0 ? -this.jumpPower : -this.jumpPower * 0.8;
                     ++this.gravityObject.jumps;
                  }
               }
               break;
            case Keyboard.DOWN:
               this.gravityObject.dropThroughCheck();
               break;
            case Keyboard.SPACE:
               this.doLeapAttack();
               if(this.owner.isPlayer && this.owner.isControllingPet && this.gameMain.p_array.length > 1)
               {
                  this.gameMain.theConnection.send("kd",param1);
               }
               break;
            case Keyboard.E:
               for each(_loc2_ in this.gameMain.item_array)
               {
                  if(getBounds(root).intersects(_loc2_.getBounds(_loc2_.root)) && (this.gameMain.personItem_array.length < this.gameMain.maxItems || _loc2_.type == "coin"))
                  {
                     if(_loc2_.playerDibs != "-none-" && _loc2_.alpha == 1)
                     {
                        this.gameMain.theConnection.send("giReI",_loc2_.name,int(_loc2_.gravityObject.hit_rect.x),int(_loc2_.gravityObject.hit_rect.y));
                     }
                     break;
                  }
               }
         }
         this.keyStates.pressKey(param1);
      }
      
      public function keyRelease(param1:uint) : void
      {
         switch(param1)
         {
            case Keyboard.RIGHT:
               if(this.__dashing)
               {
                  this.gotoAndPlayWalking();
               }
               this.__dashing = false;
               break;
            case Keyboard.LEFT:
               if(this.__dashing)
               {
                  this.gotoAndPlayWalking();
               }
               this.__dashing = false;
         }
         this.keyStates.releaseKey(param1);
      }
      
      public function attackFullyDone() : void
      {
         this.isAttacking = false;
      }
      
      public function doLeapAttack() : void
      {
         if(this.isAttacking == false)
         {
            this.gravityObject.velX = 25 * scaleX;
            this.isAttacking = true;
            this.attackCounter = 0;
            if(CommonCalls.onScreen(x,y,true,true))
            {
               this.createWolfMouth();
            }
            this.canDamage = true;
            if(this.lvl >= 60)
            {
               SoundManager.playSound(SoundLibrary.bigDogBark_sound,x,y,true,parent);
            }
            else if(this.lvl >= 30)
            {
               SoundManager.playSound(SoundLibrary.mediumDogBark_sound,x,y,true,parent);
            }
            else
            {
               SoundManager.playSound(SoundLibrary.littleDogBark_sound,x,y,true,parent);
            }
         }
      }
      
      public function handleAttacks() : void
      {
         ++this.attackCounter;
         if(this.isAttacking)
         {
            ++this.attackCounter;
            if(this.attackCounter < 8)
            {
               this.gravityObject.velX = scaleX * 25;
            }
            else if(this.attackCounter > 20)
            {
               this.isAttacking = false;
            }
         }
      }
      
      public function startBubble() : void
      {
         this.__bubbling = true;
         var _loc1_:Image = new Image(Assets.items_textureAtlas.getTexture("pet bubble"));
         _loc1_.alpha = 0.7;
         _loc1_.x -= 50;
         _loc1_.y -= 50;
         _loc1_.touchable = false;
         _loc1_.name = "bubble_image";
         addChild(_loc1_);
      }
      
      public function endBubble() : void
      {
         this.__bubbling = false;
         removeChild(getChildByName("bubble_image"),true);
         if(parent != null)
         {
            SoundManager.playSound(SoundLibrary.bubblePop_sound,x,y,true,parent);
         }
      }
      
      public function handleBubble() : void
      {
         this.bubbleRotation = RotateTo.rotTo(x,this.owner.x,y,this.owner.y) - 90;
         x += MoveTo.getDirX(25,this.bubbleRotation);
         y += MoveTo.getDirY(25,this.bubbleRotation);
         this.gravityObject.hit_rect.y += MoveTo.getDirY(10,this.bubbleRotation);
         scaleX = x < this.owner.x ? 1 : -1;
         if(CalcDist.getDistNumbers(x,y,this.owner.x,this.owner.y) < 20)
         {
            this.endBubble();
         }
      }
      
      public function findTarget(param1:Vector.<DisplayObject>, param2:int = 500, param3:Vector.<String> = null) : DisplayObject
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:String = null;
         var _loc6_:DisplayObject = null;
         var _loc7_:int = int.MAX_VALUE;
         for each(_loc4_ in param1)
         {
            if(param3 != null)
            {
               for each(_loc5_ in param3)
               {
                  if(_loc4_.name == _loc5_)
                  {
                  }
               }
            }
            if(_loc4_.name != _loc5_ && CalcDist.getDistNumbers(x,y,_loc4_.x,_loc4_.y) < _loc7_ && CalcDist.getDistNumbers(x,y,_loc4_.x,_loc4_.y) < param2 && Math.abs(CalcDist.getDistY(getBounds(parent).y + height,_loc4_.getBounds(_loc4_.parent).y + _loc4_.height)) < 80)
            {
               _loc7_ = int(CalcDist.getDistNumbers(x,y,_loc4_.x,_loc4_.y));
               _loc6_ = _loc4_;
            }
         }
         return _loc6_;
      }
      
      public function setActiveMount() : void
      {
         if(this.bubbling)
         {
            this.endBubble();
         }
         x = 2;
         y = 20;
         rotation = 0;
         scaleX = 1;
         scaleY = 1;
         if(this.body_image != null)
         {
            this.body_image.scaleX = this.bodyScaleX_array.length > 0 ? Number(this.bodyScaleX_array[0]) : 1;
            this.body_image.scaleY = this.bodyScaleY_array.length > 0 ? Number(this.bodyScaleY_array[0]) : 1;
         }
         this.visible = true;
         this.alpha = 1;
         this.owner.bodyAnimator.pet = this;
         this.owner.bodyAnimator.addMountedPet();
         this.name_txt.removeFromParent();
      }
      
      public function get attackRate() : int
      {
         switch(this.mode)
         {
            case "fept":
               return 72;
            case "fpt":
               return 50;
            case "fa":
               return 22;
            case "qa":
               return 16;
            case "hlha":
               return 72;
            case "hfhea":
               return 126;
            case "qptqa":
               return 50;
            case "hcptqa":
               return 72;
            case "hdha":
               return 72;
            default:
               return 250;
         }
      }
      
      public function getOrbBonus() : int
      {
         return Math.ceil((this.power + this.defense + this.dex + this.totalHealth / 15) / 20);
      }
      
      public function emptyKeyPressArrays() : void
      {
         this.keyStates.keyPress_array.length = 0;
         this.keyStates.keyTime_array.length = 0;
      }
      
      public function get dashing() : Boolean
      {
         return this.__dashing;
      }
      
      public function createWolfMouth() : void
      {
         var _loc1_:Image = new Image(Assets.items_textureAtlas.getTexture("pet wolf teeth"));
         _loc1_.y -= 50;
         _loc1_.alpha = 0.9;
         _loc1_.touchable = false;
         addChild(_loc1_);
         TweenMax.to(_loc1_,0.2,{
            "alpha":0,
            "delay":0.35,
            "ease":Linear.easeNone,
            "onComplete":_loc1_.removeFromParent,
            "onCompleteParams":[true]
         });
      }
      
      public function get bubbling() : Boolean
      {
         return this.__bubbling;
      }
      
      public function onSummonPetEnter(param1:Event) : void
      {
         var _loc2_:Enemy = null;
         this.name_txt.visible = false;
         if(this.owner.isPlayer && this.canDamage)
         {
            for each(_loc2_ in this.gameMain.e_array)
            {
               this.gravityObject.hit_rect.x = x + this.gravityObject.hitOffsetX;
               this.gravityObject.hit_rect.y = y + this.gravityObject.hitOffsetY;
               if(this.gravityObject.hit_rect.intersects(_loc2_.gravityObject.hit_rect))
               {
                  this.canDamage = false;
                  this.gameMain.theConnection.send("petHitE",name,_loc2_.name);
               }
            }
         }
         else if(this.owner.isPlayer == false && this.canDamage && this.owner.health > 0 && Boolean(this.gameMain.isPvpArea))
         {
            if(this.isAttacking && this.gravityObject.hit_rect.intersects(this.gameMain.player.hitTester.hit_rect))
            {
               this.canDamage = false;
               this.gameMain.theConnection.send("petHitP",name);
            }
         }
      }
      
      public function get type() : String
      {
         return this.__type;
      }
      
      public function set type(param1:String) : void
      {
         var _loc2_:String = param1.toLowerCase();
         this.rightLeg_sprite = new Sprite();
         this.rightLeg_sprite.touchable = false;
         this.rightLeg_sprite.touchGroup = true;
         addChild(this.rightLeg_sprite);
         if(this.rightLeg_image == null)
         {
            this.rightLeg_image = new Image(Assets.items_textureAtlas.getTexture(_loc2_ + " leg"));
            this.rightLeg_sprite.addChild(this.rightLeg_image);
         }
         else
         {
            this.rightLeg_image.texture = Assets.items_textureAtlas.getTexture(_loc2_ + " leg");
            this.rightLeg_image.readjustSize();
         }
         this.shoeRight_image = new Image(Assets.items_textureAtlas.getTexture(this.__shoes_string));
         this.shoeRight_image.scaleX = -1;
         this.rightLeg_sprite.addChild(this.shoeRight_image);
         if(Assets.items_textureAtlas.getTexture(_loc2_ + " body") != null)
         {
            if(this.body_image == null || this.body_image.parent == null)
            {
               this.body_image = new Image(Assets.items_textureAtlas.getTexture(_loc2_ + " body"));
               addChild(this.body_image);
            }
            else
            {
               this.body_image.texture = Assets.items_textureAtlas.getTexture(_loc2_ + " body");
               this.body_image.readjustSize();
            }
         }
         else if(this.body_image != null)
         {
            this.body_image.removeFromParent(true);
         }
         if(this.leftLeg_sprite == null)
         {
            this.leftLeg_sprite = new Sprite();
            this.leftLeg_sprite.touchable = false;
            this.leftLeg_sprite.touchGroup = true;
            addChild(this.leftLeg_sprite);
            this.leftLeg_image = new Image(this.rightLeg_image.texture);
            this.leftLeg_sprite.addChild(this.leftLeg_image);
         }
         else
         {
            this.leftLeg_image.texture = this.rightLeg_image.texture;
            this.leftLeg_image.readjustSize();
         }
         if(this.shoeLeft_image == null)
         {
            this.shoeLeft_image = new Image(this.shoeRight_image.texture);
            this.shoeLeft_image.scaleX = -1;
            this.leftLeg_sprite.addChild(this.shoeLeft_image);
         }
         if(this.head_image == null)
         {
            this.head_image = new Image(Assets.items_textureAtlas.getTexture(_loc2_ + " head"));
            addChild(this.head_image);
         }
         else
         {
            this.head_image.texture = Assets.items_textureAtlas.getTexture(_loc2_ + " head");
            this.head_image.readjustSize();
         }
         if(this.helmet_image == null)
         {
            this.helmet_image = new Image(Assets.items_textureAtlas.getTexture(this.__helmet_string));
            addChild(this.helmet_image);
         }
         this.leftLeg_image.touchable = this.rightLeg_image.touchable = this.shoeRight_image.touchable = this.shoeLeft_image.touchable = false;
         var _loc3_:RegExp = /[\s\r\n]+/gim;
         _loc2_ = _loc2_.replace(_loc3_,"");
         this.headX_array = Vector.<Number>(Pet.petBodies_xml[_loc2_].headX.toString().split(",") as Array);
         this.headY_array = Vector.<Number>(Pet.petBodies_xml[_loc2_].headY.toString().split(",") as Array);
         this.leftLegX_array = Vector.<Number>(Pet.petBodies_xml[_loc2_].leftLegX.toString().split(",") as Array);
         this.leftLegY_array = Vector.<Number>(Pet.petBodies_xml[_loc2_].leftLegY.toString().split(",") as Array);
         this.rightLegX_array = Vector.<Number>(Pet.petBodies_xml[_loc2_].rightLegX.toString().split(",") as Array);
         this.rightLegY_array = Vector.<Number>(Pet.petBodies_xml[_loc2_].rightLegY.toString().split(",") as Array);
         this.bodyX_array = Vector.<Number>(Pet.petBodies_xml[_loc2_].bodyX.toString().split(",") as Array);
         this.bodyY_array = Vector.<Number>(Pet.petBodies_xml[_loc2_].bodyY.toString().split(",") as Array);
         this.leftLegRotation_array = Vector.<Number>(Pet.petBodies_xml[_loc2_].leftLegRotation.toString().split(",") as Array);
         this.rightLegRotation_array = Vector.<Number>(Pet.petBodies_xml[_loc2_].rightLegRotation.toString().split(",") as Array);
         this.bodyScaleX_array = Vector.<Number>(Pet.petBodies_xml[_loc2_].bodyScaleX.toString().split(",") as Array);
         this.bodyScaleY_array = Vector.<Number>(Pet.petBodies_xml[_loc2_].bodyScaleY.toString().split(",") as Array);
         this.firstWalkFrame = uint(Pet.petBodies_xml[_loc2_].walkFrame - 1);
         this.helmetOffset_point = new Point(int(Pet.petBodies_xml[_loc2_].helmetOffsetX),int(Pet.petBodies_xml[_loc2_].helmetOffsetY));
         this.shoeLeft_image.x = int(Pet.petBodies_xml[_loc2_].shoePlaceX) + 7;
         this.shoeLeft_image.y = int(Pet.petBodies_xml[_loc2_].shoePlaceY) - 3;
         this.shoeRight_image.x = this.shoeLeft_image.x;
         this.shoeRight_image.y = this.shoeLeft_image.y;
         this.helmet_image.scaleX = this.helmet_image.scaleY = Number(Pet.petBodies_xml[_loc2_].helmetScale);
         this.__totalFrames = this.headX_array.length;
         this.bodyFrameNames = null;
         if(Pet.petBodies_xml[_loc2_].bodyFrames.length() > 0)
         {
            this.bodyFrameNames = String(Pet.petBodies_xml[_loc2_].bodyFrames).split(",");
            this.head_image.visible = false;
            this.helmet_image.visible = false;
            this.leftLeg_sprite.visible = false;
            this.rightLeg_sprite.visible = false;
         }
         _loc2_ = param1.toLocaleLowerCase();
         this.head_image.pivotX = Assets.items_object[_loc2_ + " head"].pivotX;
         this.head_image.pivotY = Assets.items_object[_loc2_ + " head"].pivotY;
         this.helmet_image.pivotX = Assets.items_object[this.helmet_string].pivotX;
         this.helmet_image.pivotY = Assets.items_object[this.helmet_string].pivotY;
         this.leftLeg_image.pivotX = Assets.items_object[_loc2_ + " leg"].pivotX;
         this.leftLeg_image.pivotY = Assets.items_object[_loc2_ + " leg"].pivotY;
         this.rightLeg_image.pivotX = Assets.items_object[_loc2_ + " leg"].pivotX;
         this.rightLeg_image.pivotY = Assets.items_object[_loc2_ + " leg"].pivotY;
         this.shoeRight_image.pivotX = this.shoeLeft_image.pivotX = Assets.items_object[this.shoes_string].pivotX;
         this.shoeRight_image.pivotY = this.shoeLeft_image.pivotY = Assets.items_object[this.shoes_string].pivotY;
         if(this.body_image != null)
         {
            this.body_image.pivotX = Assets.items_object[_loc2_ + " body"].pivotX;
            this.body_image.pivotY = Assets.items_object[_loc2_ + " body"].pivotY;
         }
         this.__type = param1;
      }
      
      public function get helmet_string() : String
      {
         return this.__helmet_string;
      }
      
      public function set helmet_string(param1:String) : void
      {
         this.__helmet_string = param1;
         if(Stats.petHelmetStats[this.__helmet_string] != undefined)
         {
            this.__helmet_uint = Stats.petHelmetStats[this.__helmet_string].frame;
         }
         this.helmet_image.texture = Assets.items_textureAtlas.getTexture(this.__helmet_string);
         this.helmet_image.readjustSize();
         this.helmet_image.pivotX = Assets.items_object[this.__helmet_string].pivotX;
         this.helmet_image.pivotY = Assets.items_object[this.__helmet_string].pivotY;
      }
      
      public function get helmet_uint() : uint
      {
         return this.__helmet_uint;
      }
      
      public function set helmet_uint(param1:uint) : void
      {
         var _loc2_:String = null;
         this.__helmet_uint = param1;
         for each(_loc2_ in Stats.itemList)
         {
            if(Stats.petHelmetStats[_loc2_] != undefined && Stats.petHelmetStats[_loc2_].frame == this.__helmet_uint)
            {
               this.helmet_string = _loc2_;
               break;
            }
         }
      }
      
      public function get shoes_string() : String
      {
         return this.__shoes_string;
      }
      
      public function set shoes_string(param1:String) : void
      {
         this.__shoes_string = param1;
         if(Stats.shoesStats[this.__shoes_string] != undefined)
         {
            this.__shoes_uint = Stats.shoesStats[this.__shoes_string].frame;
         }
         this.shoeLeft_image.texture = this.shoeRight_image.texture = Assets.items_textureAtlas.getTexture(this.__shoes_string);
         this.shoeLeft_image.readjustSize();
         this.shoeRight_image.readjustSize();
      }
      
      public function get shoes_uint() : uint
      {
         return this.__shoes_uint;
      }
      
      public function set shoes_uint(param1:uint) : void
      {
         var _loc2_:String = null;
         this.__shoes_uint = param1;
         for each(_loc2_ in Stats.itemList)
         {
            if(Stats.shoesStats[_loc2_] != undefined && Stats.shoesStats[_loc2_].frame == this.__shoes_uint)
            {
               this.shoes_string = _loc2_;
               break;
            }
         }
      }
      
      public function get isVehicle() : Boolean
      {
         return Pet.isCarType(this.__type);
      }
      
      public function fitPreview(param1:Number, param2:Number) : void
      {
         var _loc3_:Rectangle = this.getBounds(this);
         var _loc4_:Number = _loc3_.width * Math.abs(this.scaleX);
         var _loc5_:Number = _loc3_.height * Math.abs(this.scaleY);
         if(_loc4_ <= 0 || _loc5_ <= 0 || param1 <= 0 || param2 <= 0)
         {
            return;
         }
         var _loc6_:Number = Math.min(param1 / _loc4_,param2 / _loc5_);
         if(_loc6_ >= 1)
         {
            return;
         }
         this.scaleX *= _loc6_;
         this.scaleY *= _loc6_;
      }
      
      public function nextFrame() : void
      {
         if(this.__currentFrame < this.__totalFrames - 1)
         {
            ++this.__currentFrame;
         }
         else
         {
            this.__currentFrame = 0;
         }
         this.updateFrame();
      }
      
      public function get currentLabel() : String
      {
         return this.__currentFrame < this.firstWalkFrame ? "standing" : "walking";
      }
      
      public function get currentFrame() : uint
      {
         return this.__currentFrame;
      }
      
      public function get totalFrames() : uint
      {
         return this.__totalFrames;
      }
      
      public function get isPlaying() : Boolean
      {
         return this.__isPlaying;
      }
      
      public function gotoAndPlayWalking() : void
      {
         this.__currentFrame = this.firstWalkFrame;
         this.updateFrame();
         this.__isPlaying = true;
      }
      
      public function gotoAndPlayStanding() : void
      {
         this.__currentFrame = 0;
         this.updateFrame();
         this.__isPlaying = true;
      }
      
      public function stop() : void
      {
         this.__isPlaying = false;
      }
      
      public function play() : void
      {
         this.__isPlaying = true;
      }
      
      public function gotoAndStop(param1:uint) : void
      {
         this.__currentFrame = param1 < this.__totalFrames ? param1 : 0;
         this.__isPlaying = false;
         this.updateFrame();
      }
      
      public function gotoAndPlay(param1:uint) : void
      {
         this.__currentFrame = param1 < this.__totalFrames ? param1 : 0;
         this.__isPlaying = true;
         this.updateFrame();
      }
      
      public function updateFrame() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Object = null;
         if(this.__currentFrame >= this.__totalFrames || this.__currentFrame >= this.headX_array.length)
         {
            this.__currentFrame = 0;
         }
         this.head_image.x = this.headX_array[this.__currentFrame];
         this.head_image.y = this.headY_array[this.__currentFrame];
         this.helmet_image.x = this.head_image.x + this.helmetOffset_point.x + Pet.helmetOffsetFrameX_array[this.helmet_uint - 1] + 2;
         this.helmet_image.y = this.head_image.y + this.helmetOffset_point.y + Pet.helmetOffsetFrameY_array[this.helmet_uint - 1] - 2;
         this.leftLeg_sprite.x = this.leftLegX_array[this.__currentFrame];
         this.leftLeg_sprite.y = this.leftLegY_array[this.__currentFrame];
         this.leftLeg_sprite.rotation = deg2rad(this.leftLegRotation_array[this.__currentFrame]);
         this.rightLeg_sprite.x = this.rightLegX_array[this.__currentFrame];
         this.rightLeg_sprite.y = this.rightLegY_array[this.__currentFrame];
         this.rightLeg_sprite.rotation = deg2rad(this.rightLegRotation_array[this.__currentFrame]);
         if(this.body_image != null)
         {
            _loc1_ = this.__currentFrame < this.bodyX_array.length ? int(this.__currentFrame) : 0;
            this.body_image.x = this.bodyX_array.length > _loc1_ ? Number(this.bodyX_array[_loc1_]) : 0;
            this.body_image.y = this.bodyY_array.length > _loc1_ ? Number(this.bodyY_array[_loc1_]) : 0;
            this.body_image.scaleX = this.bodyScaleX_array.length > _loc1_ ? Number(this.bodyScaleX_array[_loc1_]) : 1;
            this.body_image.scaleY = this.bodyScaleY_array.length > _loc1_ ? Number(this.bodyScaleY_array[_loc1_]) : 1;
         }
         if(this.bodyFrameNames != null && this.bodyFrameNames.length > 0 && this.body_image != null)
         {
            _loc2_ = 0;
            if(this.owner != null && this.owner.ridingPet == this && this.owner.gravityObject != null)
            {
               _loc5_ = this.owner.gravityObject.velX;
               if(_loc5_ < 0)
               {
                  _loc5_ = -_loc5_;
               }
               if(this.owner.bodyAnimator != null && this.owner.bodyAnimator.currentLabel == "pet dashing")
               {
                  _loc2_ = 2;
               }
               else if(_loc5_ > 0.4)
               {
                  _loc2_ = 1;
               }
               else
               {
                  _loc2_ = 0;
               }
            }
            else
            {
               _loc6_ = this.gravityObject != null ? this.gravityObject.velX : 0;
               if(_loc6_ < 0)
               {
                  _loc6_ = -_loc6_;
               }
               if(Boolean(this.__dashing) || _loc6_ > 6)
               {
                  _loc2_ = 2;
               }
               else if(_loc6_ > 0.4)
               {
                  _loc2_ = 1;
               }
               else
               {
                  _loc2_ = 0;
               }
            }
            if(_loc2_ > this.bodyFrameNames.length - 1)
            {
               _loc2_ = this.bodyFrameNames.length - 1;
            }
            _loc3_ = String(this.bodyFrameNames[_loc2_]).replace(/^\s+|\s+$/g,"");
            _loc4_ = Assets.items_textureAtlas.getTexture(_loc3_);
            if(_loc4_ != null && this.body_image.texture != _loc4_)
            {
               this.body_image.texture = _loc4_;
               this.body_image.readjustSize();
               if(this.bodyX_array.length > 1)
               {
                  this.body_image.scaleX = this.bodyScaleX_array[this.__currentFrame];
                  this.body_image.scaleY = this.bodyScaleY_array[this.__currentFrame];
               }
               _loc7_ = Assets.items_object[_loc3_];
               if(_loc7_ != null)
               {
                  this.body_image.pivotX = _loc7_.pivotX;
                  this.body_image.pivotY = _loc7_.pivotY;
               }
            }
         }
      }
      
      private function onAdded(param1:Event) : void
      {
         this.name_txt = new TextField(113,27,name,AllTextFormats.name_textFormat);
         this.name_txt.x = x - 60;
         this.name_txt.y = this.gravityObject.hit_rect.y + this.gravityObject.hit_rect.height - 5;
         this.name_txt.touchGroup = true;
         this.name_txt.touchable = false;
         this.name_txt.batchable = true;
         this.gameMain.starlingStage.addChildAt(this.name_txt,this.gameMain.starlingStage.getChildIndex(this.gameMain.starlingStage.controls));
         if(name != "" && this.owner.isPlayer == false)
         {
            removeEventListener(Event.ADDED_TO_STAGE,this.onAdded);
         }
      }
      
      private function onRemoved(param1:Event) : void
      {
         this.name_txt.removeFromParent(true);
      }
      
      public function evolveMe(param1:String) : void
      {
         var _newType:String = param1;
         this.type = _newType;
         if(CommonCalls.onScreen(x,y,false,true))
         {
            ShineEffect.shineObjectNoParent(this,17);
            filter = new GlowFilter(16777215,3,8);
            setTimeout(function():void
            {
               filter = null;
            },1500);
            SoundManager.playSound(SoundLibrary.petEvolve_sound,x,y,true,parent);
         }
      }
      
      public function rightClick() : void
      {
         var _loc1_:Vector.<String> = null;
         if(MainStarlingStage(root).gameMain.hasManualControl)
         {
            _loc1_ = new Vector.<String>();
            if(Boolean(MainStarlingStage(root).gameMain.hasManualControl) && MainStarlingStage(root).gameMain.player.isControllingEnemy == false)
            {
               _loc1_.push("control pet");
            }
            MainStarlingStage(root).gameMain.createRCMenu(_loc1_,{
               "petName":name,
               "enemyType":this.type
            });
         }
      }
   }
}

