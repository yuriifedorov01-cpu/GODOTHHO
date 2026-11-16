package com.ui
{
   import com.game_objects.Person;
   import com.game_objects.Pet;
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.stats.*;
   import com.utilities.*;
   import feathers.controls.*;
   import feathers.controls.text.*;
   import feathers.core.ITextEditor;
   import feathers.events.*;
   import flash.events.*;
   import flash.ui.*;
   import flash.utils.*;
   import starling.*;
   import starling.core.*;
   import starling.display.*;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.text.*;
   import starling.textures.TextureAtlas;
   
   public final class Controls extends Sprite
   {
      
      public static var controls_textureAtlas:TextureAtlas;
      
      private static var health_textFormat:TextFormat;
      
      private static var MP_XP_textFormat:TextFormat;
      
      private static var money_textFormat:TextFormat;
      
      private static var hpColon_textFormat:TextFormat;
      
      private static var MP_level_textFormat:TextFormat;
      
      private static var version_textFormat:TextFormat;
      
      private static var chat_textFormat:TextFormat;
      
      private static var petName_textFormat:TextFormat;
      
      private var lastSentMessageTime:uint = 0;
      
      public var blinkCharacterButton:Boolean = false;
      
      public var blinkHeropediaButton:Boolean = false;
      
      public var blinkMissionButton:Boolean = false;
      
      private var shoutText_array:Vector.<TextField>;
      
      public const sentChat_array:Vector.<String>;
      
      public var analogDown:Boolean = false;
      
      public const keyDown_event:KeyboardEvent;
      
      public const keyUp_event:KeyboardEvent;
      
      private var analogWasRight:Boolean = false;
      
      private var analogWasLeft:Boolean = false;
      
      private var analogWasDown:Boolean = false;
      
      private var analogWasUp:Boolean = false;
      
      public var analogDown_touch:Touch;
      
      private var healthBG_image:Image;
      
      private var healthBar_image:Image;
      
      private var mpBG_image:Image;
      
      private var mpBar_image:Image;
      
      private var xpBG_image:Image;
      
      private var xpBar_image:Image;
      
      private var coin_image:Image;
      
      private var petPanel_images:Vector.<Image>;
      
      private var petHealthBar_images:Vector.<Image>;
      
      private var petXPBar_images:Vector.<Image>;
      
      private var bossBG_image:Image;
      
      private var bossBar_image:Image;
      
      public var analogStickBG_image:Image;
      
      public var analogStick_btn:Button;
      
      public var attack_btn:Button;
      
      public var jump_btn:Button;
      
      public var block_btn:Button;
      
      public var chopFish_btn:Button;
      
      public var heal_btn:Button;
      
      public var guildHeal_btn:Button;
      
      public var unleash_btn:Button;
      
      public var guildRage_btn:Button;
      
      public var loot_btn:Button;
      
      public var etc_btn:Button;
      
      private var health_txt:TextField;
      
      private var mp_txt:TextField;
      
      private var xp_txt:TextField;
      
      public var money_txt:TextField;
      
      private var hpColon_txt:TextField;
      
      private var mpColon_txt:TextField;
      
      private var level_txt:TextField;
      
      public var version_txt:TextField;
      
      public var chat_txt:TextField;
      
      private var petName_txts:Vector.<TextField>;
      
      private var boss_txt:TextField;
      
      public const message_txt:TextInput;
      
      public var pets_btn:Button;
      
      public var missions_btn:Button;
      
      public var char_btn:Button;
      
      public var friends_btn:Button;
      
      public var items_btn:Button;
      
      public var map_btn:Button;
      
      public var heropedia_btn:Button;
      
      public var payvault_btn:Button;
      
      public var options_btn:Button;
      
      public var mainMenu_btn:Button;
      
      public var chatPanel_image:Image;
      
      public function Controls()
      {
         this.shoutText_array = new Vector.<TextField>();
         this.sentChat_array = new Vector.<String>();
         this.keyDown_event = new KeyboardEvent(KeyboardEvent.KEY_DOWN,false,false,0,Keyboard.SPACE);
         this.keyUp_event = new KeyboardEvent(KeyboardEvent.KEY_UP,false,false,0,Keyboard.SPACE);
         this.petPanel_images = new Vector.<Image>();
         this.petHealthBar_images = new Vector.<Image>();
         this.petXPBar_images = new Vector.<Image>();
         this.petName_txts = new Vector.<TextField>();
         this.message_txt = new TextInput();
         super();
         health_textFormat = new TextFormat(Assets.stats_font.name,20,16777215,"left");
         MP_XP_textFormat = new TextFormat(Assets.stats_font.name,14,16777215,"left");
         money_textFormat = new TextFormat(Assets.stats_font.name,20,16777215,"left");
         hpColon_textFormat = new TextFormat(Assets.stats_font.name,32,16777215,"left");
         MP_level_textFormat = new TextFormat(Assets.stats_font.name,22,16777215,"left");
         version_textFormat = new TextFormat(Assets.talk_font.name,9,16777215,"left");
         chat_textFormat = new TextFormat(Assets.talk_font.name,11,16777215,"left","top");
         petName_textFormat = new TextFormat(Assets.stats_font.name,13,16777215,"left");
         this.chat_txt = new TextField(908,88,"",chat_textFormat);
         this.health_txt = new TextField(200,25,"",health_textFormat);
         this.mp_txt = new TextField(160,19,"",MP_XP_textFormat);
         this.xp_txt = new TextField(225,19,"",MP_XP_textFormat);
         this.money_txt = new TextField(213,25,"",money_textFormat);
         this.hpColon_txt = new TextField(45,38,"HP",hpColon_textFormat);
         this.mpColon_txt = new TextField(36,27,"MP",MP_level_textFormat);
         this.level_txt = new TextField(95,27,"",MP_level_textFormat);
         this.version_txt = new TextField(32,13,"9.50",version_textFormat);
         this.healthBG_image = new Image(controls_textureAtlas.getTexture("health BG"));
         this.healthBar_image = new Image(controls_textureAtlas.getTexture("health bar"));
         this.mpBG_image = new Image(controls_textureAtlas.getTexture("MP BG"));
         this.mpBar_image = new Image(controls_textureAtlas.getTexture("MP bar"));
         this.xpBG_image = new Image(controls_textureAtlas.getTexture("XP BG"));
         this.xpBar_image = new Image(controls_textureAtlas.getTexture("XP bar"));
         this.coin_image = new Image(controls_textureAtlas.getTexture("coin"));
         this.pets_btn = new Button(controls_textureAtlas.getTexture("pets"));
         this.missions_btn = new Button(controls_textureAtlas.getTexture("missions"));
         this.char_btn = new Button(controls_textureAtlas.getTexture("character"));
         this.friends_btn = new Button(controls_textureAtlas.getTexture("social"));
         this.items_btn = new Button(controls_textureAtlas.getTexture("items"));
         this.map_btn = new Button(controls_textureAtlas.getTexture("map"));
         this.heropedia_btn = new Button(controls_textureAtlas.getTexture("heropedia"));
         this.payvault_btn = new Button(controls_textureAtlas.getTexture("payvault"));
         this.options_btn = new Button(controls_textureAtlas.getTexture("options"));
         if(GameMain.isAmazonUnderground)
         {
            this.mainMenu_btn = new Button(controls_textureAtlas.getTexture("main menu"));
         }
         this.chatPanel_image = new Image(controls_textureAtlas.getTexture("chat"));
         this.healthBG_image.x = 11;
         this.healthBG_image.y = 23;
         addChild(this.healthBG_image);
         this.healthBar_image.x = 24;
         this.healthBar_image.y = 28;
         this.healthBar_image.touchable = this.healthBG_image.touchable = false;
         addChild(this.healthBar_image);
         this.mpBG_image.x = 22;
         this.mpBG_image.y = 65;
         addChild(this.mpBG_image);
         this.mpBar_image.x = 32;
         this.mpBar_image.y = 68;
         addChild(this.mpBar_image);
         this.xpBG_image.x = 49;
         this.xpBG_image.y = 96;
         addChild(this.xpBG_image);
         this.xpBar_image.x = 59;
         this.xpBar_image.y = 99;
         this.xpBar_image.touchable = this.xpBG_image.touchable = this.mpBar_image.touchable = this.mpBG_image.touchable = false;
         addChild(this.xpBar_image);
         this.coin_image.x = 15;
         this.coin_image.y = 128;
         this.coin_image.touchable = false;
         addChild(this.coin_image);
         this.chatPanel_image.x = 11;
         this.chatPanel_image.y = 577;
         this.chatPanel_image.touchable = false;
         addChild(this.chatPanel_image);
         this.toggleButtons(!GameMain.isMobile);
         if(GameMain.isMobile)
         {
            this.analogStickBG_image = new Image(controls_textureAtlas.getTexture("analog stick base"));
            this.analogStickBG_image.x += this.analogStickBG_image.width / 2;
            this.analogStickBG_image.y = this.chatPanel_image.y - this.analogStickBG_image.width / 2;
            this.analogStickBG_image.pivotX = this.analogStickBG_image.pivotY = this.analogStickBG_image.width / 2;
            this.analogStickBG_image.touchable = false;
            addChild(this.analogStickBG_image);
            this.analogStick_btn = new Button(controls_textureAtlas.getTexture("analog stick top"));
            this.analogStick_btn.x = this.analogStickBG_image.x;
            this.analogStick_btn.y = this.analogStickBG_image.y;
            this.analogStick_btn.pivotX = this.analogStick_btn.pivotY = this.analogStick_btn.width / 2;
            this.analogStick_btn.scaleWhenOver = 0.95;
            this.analogStick_btn.name = "mobileAnalog_btn";
            addChild(this.analogStick_btn);
            this.attack_btn = new Button(controls_textureAtlas.getTexture("attack button"));
            this.attack_btn.scale = 0.9;
            this.attack_btn.x = Starling.current.viewPort.width - this.attack_btn.width;
            this.attack_btn.y = this.chatPanel_image.y - this.attack_btn.height;
            this.attack_btn.name = "mobileAttack_btn";
            addChild(this.attack_btn);
            this.jump_btn = new Button(controls_textureAtlas.getTexture("jump button"));
            this.jump_btn.scale = 0.8;
            this.jump_btn.x = this.attack_btn.x - this.jump_btn.width;
            this.jump_btn.y = this.chatPanel_image.y - this.jump_btn.height;
            this.jump_btn.name = "mobileJump_btn";
            addChild(this.jump_btn);
            this.block_btn = new Button(controls_textureAtlas.getTexture("block button"));
            this.block_btn.scale = 0.5;
            this.block_btn.x = this.attack_btn.x - this.block_btn.width / 1.75;
            this.block_btn.y = this.attack_btn.y - this.block_btn.height / 1.75;
            this.block_btn.name = "mobileBlock_btn";
            addChild(this.block_btn);
            this.loot_btn = new Button(controls_textureAtlas.getTexture("loot button"));
            this.loot_btn.x = this.attack_btn.x - this.loot_btn.width / 2;
            this.loot_btn.y = this.attack_btn.bounds.bottom - this.loot_btn.height;
            this.loot_btn.name = "mobileLoot_btn";
            this.loot_btn.scaleWhenDown = this.block_btn.scaleWhenDown = this.jump_btn.scaleWhenDown = this.attack_btn.scaleWhenDown = 0.9;
            this.loot_btn.scaleWhenOver = this.block_btn.scaleWhenOver = this.jump_btn.scaleWhenOver = this.attack_btn.scaleWhenOver = 0.95;
            this.loot_btn.useHandCursor = this.block_btn.useHandCursor = this.jump_btn.useHandCursor = this.attack_btn.useHandCursor = this.analogStick_btn.useHandCursor = false;
            addChild(this.loot_btn);
            this.etc_btn = new Button(controls_textureAtlas.getTexture("etc button"));
            this.etc_btn.x = Starling.current.viewPort.width - 70;
            this.etc_btn.y = 30;
            this.etc_btn.name = "etc_btn";
            addChild(this.etc_btn);
            this.message_txt.textEditorFactory = function():ITextEditor
            {
               var _loc1_:StageTextTextEditor = new StageTextTextEditor();
               _loc1_.returnKeyLabel = "next";
               return _loc1_;
            };
         }
         this.health_txt.x = 60;
         this.health_txt.y = 10;
         addChild(this.health_txt);
         this.mp_txt.x = 53;
         this.mp_txt.y = 58;
         addChild(this.mp_txt);
         this.xp_txt.x = 93;
         this.xp_txt.y = 89;
         addChild(this.xp_txt);
         this.money_txt.x = 38;
         this.money_txt.y = 126;
         addChild(this.money_txt);
         this.money_txt.batchable = this.xp_txt.batchable = this.mp_txt.batchable = this.health_txt.batchable = true;
         this.money_txt.touchable = this.xp_txt.touchable = this.mp_txt.touchable = this.health_txt.touchable = false;
         this.hpColon_txt.x = 10;
         this.hpColon_txt.y = 17;
         addChild(this.hpColon_txt);
         this.mpColon_txt.x = 12;
         this.mpColon_txt.y = 60;
         addChild(this.mpColon_txt);
         this.level_txt.x = 9;
         this.level_txt.y = 94;
         addChild(this.level_txt);
         this.level_txt.batchable = this.mpColon_txt.batchable = this.hpColon_txt.batchable = true;
         this.level_txt.touchable = this.mpColon_txt.touchable = this.hpColon_txt.touchable = false;
         if(GameMain.isMobile == false)
         {
            this.version_txt.x = 5;
            this.version_txt.y = 4;
            this.version_txt.touchable = false;
            this.version_txt.batchable = true;
            addChild(this.version_txt);
         }
         this.chat_txt.x = this.chatPanel_image.x + 9;
         this.chat_txt.y = this.chatPanel_image.y + 2;
         addChild(this.chat_txt);
         this.chat_txt.touchable = false;
         this.chat_txt.batchable = true;
         this.message_txt.width = 906;
         this.message_txt.height = 20;
         this.message_txt.x = this.chat_txt.x;
         this.message_txt.y = this.chatPanel_image.y + this.chatPanel_image.height - 27;
         this.message_txt.maxChars = this.message_txt.width / 6;
         this.message_txt.textEditorProperties.fontFamily = "Arial";
         this.message_txt.textEditorProperties.fontSize = 14;
         this.message_txt.addEventListener(FeathersEventType.ENTER,this.onReturnPressed);
         addChild(this.message_txt);
      }
      
      public function setMoreMobileButtons(param1:Person) : void
      {
         if(GameMain.isMobile)
         {
            if(param1.lev > 3)
            {
               if(this.chopFish_btn == null || this.chopFish_btn.parent == null)
               {
                  this.chopFish_btn = new Button(controls_textureAtlas.getTexture("chop/fish button"));
                  this.chopFish_btn.x = Starling.current.viewPort.width / Starling.contentScaleFactor - this.chopFish_btn.width;
                  this.chopFish_btn.y = this.attack_btn.y - this.chopFish_btn.height + 5;
                  this.chopFish_btn.name = "mobileChopFish_btn";
                  addChildAt(this.chopFish_btn,getChildIndex(this.attack_btn));
                  this.unleash_btn = new Button(controls_textureAtlas.getTexture("unleash button"));
                  this.unleash_btn.x = this.chopFish_btn.x;
                  this.unleash_btn.y = this.chopFish_btn.y - this.unleash_btn.height - 1;
                  this.unleash_btn.name = "mobileUnleash_btn";
                  this.unleash_btn.scaleWhenDown = this.chopFish_btn.scaleWhenDown = 0.9;
                  this.unleash_btn.scaleWhenOver = this.chopFish_btn.scaleWhenOver = 0.95;
                  this.unleash_btn.useHandCursor = this.chopFish_btn.useHandCursor = false;
                  addChildAt(this.unleash_btn,getChildIndex(this.attack_btn));
               }
               if(param1.guildRageLvl > 1 && (this.guildRage_btn == null || this.guildRage_btn.parent == null))
               {
                  this.guildRage_btn = new Button(controls_textureAtlas.getTexture("guild rage button"));
                  this.guildRage_btn.x = this.chopFish_btn.x;
                  this.guildRage_btn.y = this.unleash_btn.y - this.guildRage_btn.height - 1;
                  this.guildRage_btn.name = "mobileGuildRage_btn";
                  this.guildRage_btn.scaleWhenDown = 0.9;
                  this.guildRage_btn.scaleWhenOver = 0.95;
                  this.guildRage_btn.useHandCursor = false;
                  addChildAt(this.guildRage_btn,getChildIndex(this.attack_btn));
               }
               if(ItemStat(Stats.wStats[param1.bodyAnimator.weaponString]).isMagic > 0)
               {
                  if(param1.selfHealLvl > 1 && (this.heal_btn == null || this.heal_btn.parent == null))
                  {
                     this.heal_btn = new Button(controls_textureAtlas.getTexture("heal button"));
                     this.heal_btn.x = this.chopFish_btn.x - this.heal_btn.width + 8;
                     this.heal_btn.y = this.chopFish_btn.y - this.heal_btn.height / 2;
                     this.heal_btn.name = "mobileHeal_btn";
                     this.heal_btn.scaleWhenDown = 0.9;
                     this.heal_btn.scaleWhenOver = 0.95;
                     this.heal_btn.useHandCursor = false;
                     addChildAt(this.heal_btn,getChildIndex(this.attack_btn));
                  }
                  if(param1.guildHealLvl > 1 && (this.guildHeal_btn == null || this.guildHeal_btn.parent == null))
                  {
                     this.guildHeal_btn = new Button(controls_textureAtlas.getTexture("guild heal button"));
                     this.guildHeal_btn.x = this.chopFish_btn.x - this.guildHeal_btn.width + 8;
                     this.guildHeal_btn.y = this.chopFish_btn.y - this.guildHeal_btn.height * 1.5;
                     this.guildHeal_btn.name = "mobileGuildHeal_btn";
                     this.guildHeal_btn.scaleWhenDown = 0.9;
                     this.guildHeal_btn.scaleWhenOver = 0.95;
                     this.guildHeal_btn.useHandCursor = false;
                     addChildAt(this.guildHeal_btn,getChildIndex(this.attack_btn));
                  }
               }
               else
               {
                  if(this.heal_btn != null && this.heal_btn.parent != null)
                  {
                     this.heal_btn.removeFromParent(true);
                  }
                  if(this.guildHeal_btn != null && this.guildHeal_btn.parent != null)
                  {
                     this.guildHeal_btn.removeFromParent(true);
                  }
               }
            }
         }
      }
      
      public function toggleButtons(param1:Boolean, param2:Person = null) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1 && (this.heropedia_btn == null || this.heropedia_btn.parent == null))
         {
            _loc3_ = getChildIndex(this.coin_image);
            this.pets_btn.x = 289 + this.pets_btn.width / 2;
            this.pets_btn.y = 8 + this.pets_btn.height / 2;
            this.pets_btn.pivotX = this.pets_btn.width / 2;
            this.pets_btn.pivotY = this.pets_btn.height / 2;
            this.pets_btn.name = "pets_btn";
            this.pets_btn.visible = param2 != null && param2.pet_array.length > 0;
            addChildAt(this.pets_btn,_loc3_);
            this.missions_btn.x = 381 + this.missions_btn.width / 2;
            this.missions_btn.y = 10 + this.missions_btn.height / 2;
            this.missions_btn.pivotX = this.missions_btn.width / 2;
            this.missions_btn.pivotY = this.missions_btn.height / 2;
            this.missions_btn.name = "missions_btn";
            addChildAt(this.missions_btn,_loc3_);
            this.char_btn.x = 510 + this.char_btn.width / 2;
            this.char_btn.y = -1 + this.char_btn.height / 2;
            this.char_btn.pivotX = this.char_btn.width / 2;
            this.char_btn.pivotY = this.char_btn.height / 2;
            this.char_btn.name = "char_btn";
            addChildAt(this.char_btn,_loc3_);
            this.friends_btn.x = 654 + this.friends_btn.width / 2;
            this.friends_btn.y = 0 + this.friends_btn.height / 2;
            this.friends_btn.pivotX = this.friends_btn.width / 2;
            this.friends_btn.pivotY = this.friends_btn.height / 2;
            this.friends_btn.name = "friends_btn";
            addChildAt(this.friends_btn,_loc3_);
            this.items_btn.x = 766 + this.items_btn.width / 2;
            this.items_btn.y = 7 + this.items_btn.height / 2;
            this.items_btn.pivotX = this.items_btn.width / 2;
            this.items_btn.pivotY = this.items_btn.height / 2;
            this.items_btn.name = "items_btn";
            addChildAt(this.items_btn,_loc3_);
            this.map_btn.x = 868 + this.map_btn.width / 2;
            this.map_btn.y = 10 + this.map_btn.height / 2;
            this.map_btn.pivotX = this.map_btn.width / 2;
            this.map_btn.pivotY = this.map_btn.height / 2;
            this.map_btn.name = "map_btn";
            addChildAt(this.map_btn,_loc3_);
            this.heropedia_btn.x = 510 + this.heropedia_btn.width / 2;
            this.heropedia_btn.y = 43 + this.heropedia_btn.height / 2;
            this.heropedia_btn.pivotX = this.heropedia_btn.width / 2;
            this.heropedia_btn.pivotY = this.heropedia_btn.height / 2;
            this.heropedia_btn.name = "heropedia_btn";
            addChildAt(this.heropedia_btn,_loc3_);
            this.payvault_btn.x = 679 + this.payvault_btn.width / 2;
            this.payvault_btn.y = 39 + this.payvault_btn.height / 2;
            this.payvault_btn.pivotX = this.payvault_btn.width / 2;
            this.payvault_btn.pivotY = this.payvault_btn.height / 2;
            this.payvault_btn.name = "payvault_btn";
            addChildAt(this.payvault_btn,_loc3_);
            this.options_btn.x = 823 + this.options_btn.width / 2;
            this.options_btn.y = 41 + this.options_btn.height / 2;
            this.options_btn.pivotX = this.options_btn.width / 2;
            this.options_btn.pivotY = this.options_btn.height / 2;
            this.options_btn.name = "options_btn";
            addChildAt(this.options_btn,_loc3_);
            if(GameMain.isAmazonUnderground)
            {
               this.mainMenu_btn.x = 436;
               this.mainMenu_btn.y = 59;
               this.mainMenu_btn.pivotX = this.mainMenu_btn.width / 2;
               this.mainMenu_btn.pivotY = this.mainMenu_btn.height / 2;
               this.mainMenu_btn.name = "mainMenu_btn";
               this.mainMenu_btn.scaleWhenOver = 0.95;
               addChildAt(this.mainMenu_btn,_loc3_);
               this.payvault_btn.visible = false;
            }
            this.pets_btn.scaleWhenOver = this.options_btn.scaleWhenOver = this.payvault_btn.scaleWhenOver = this.heropedia_btn.scaleWhenOver = this.map_btn.scaleWhenOver = this.items_btn.scaleWhenOver = this.friends_btn.scaleWhenOver = this.char_btn.scaleWhenOver = this.missions_btn.scaleWhenOver = 0.95;
            if(this.etc_btn != null)
            {
               this.etc_btn.y = 85;
            }
            if(parent != null)
            {
               _loc4_ = Starling.current.viewPort.width / Starling.contentScaleFactor - MainStarlingStage(root).gameMain.loaderInfo.width;
               this.pets_btn.x += _loc4_;
               this.char_btn.x += _loc4_;
               this.friends_btn.x += _loc4_;
               this.items_btn.x += _loc4_;
               this.map_btn.x += _loc4_;
               this.heropedia_btn.x += _loc4_;
               this.payvault_btn.x += _loc4_;
               this.options_btn.x += _loc4_;
               this.missions_btn.x += _loc4_;
               if(this.mainMenu_btn != null)
               {
                  this.mainMenu_btn.x += _loc4_;
               }
            }
            if(GameMain.isMobile)
            {
               this.chatPanel_image.visible = this.chat_txt.visible = this.message_txt.visible = false;
            }
         }
         else if(param1 == false && this.heropedia_btn != null && this.heropedia_btn.parent != null)
         {
            if(this.pets_btn != null && this.pets_btn.parent != null)
            {
               removeChild(this.pets_btn);
            }
            removeChild(this.missions_btn);
            removeChild(this.char_btn);
            removeChild(this.friends_btn);
            removeChild(this.items_btn);
            removeChild(this.map_btn);
            removeChild(this.heropedia_btn);
            removeChild(this.payvault_btn);
            removeChild(this.options_btn);
            if(this.etc_btn != null)
            {
               this.etc_btn.y = 30;
            }
            if(GameMain.isMobile)
            {
               this.chatPanel_image.visible = this.chat_txt.visible = this.message_txt.visible = true;
            }
         }
      }
      
      public function onEnter() : void
      {
         var _loc1_:Pet = null;
         var _loc2_:GameMain = MainStarlingStage(root).gameMain;
         this.healthBar_image.scaleX = _loc2_.player.health / _loc2_.player.totalHealth;
         this.mpBar_image.scaleX = _loc2_.player.MP / _loc2_.player.totalMP;
         this.xpBar_image.scaleX = _loc2_.player.currentLevelXP / int(_loc2_.player.lev * (_loc2_.player.lev * 1.1 + 50));
         this.health_txt.text = _loc2_.player.health >= 0 ? _loc2_.player.health + " / " + _loc2_.player.totalHealth : String(0);
         this.mp_txt.text = _loc2_.player.MP + " / " + _loc2_.player.totalMP;
         this.xp_txt.text = _loc2_.player.currentLevelXP + " / " + int(_loc2_.player.lev * (_loc2_.player.lev * 1.1 + 50)) + " (" + String(RoundToNearest.roundTo(this.xpBar_image.scaleX * 100,10)) + "%)";
         this.money_txt.text = "Money: $" + CommonCalls.uintToCommaString(_loc2_.player.money);
         this.level_txt.text = "Lvl " + _loc2_.player.lev;
         var _loc3_:int = int(this.petPanel_images.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            for each(_loc1_ in _loc2_.player.pet_array)
            {
               if(_loc1_.name == this.petName_txts[_loc4_].text)
               {
                  this.petHealthBar_images[_loc4_].scaleX = _loc1_.health / _loc1_.totalHealth;
                  this.petXPBar_images[_loc4_].scaleX = (_loc1_.xp - CommonCalls.getTotalXPToReachLevel(_loc1_.lvl)) / (CommonCalls.getTotalXPToReachLevel(_loc1_.lvl + 1) - CommonCalls.getTotalXPToReachLevel(_loc1_.lvl));
                  break;
               }
            }
            _loc4_++;
         }
         if(_loc2_.player.totalMP > 0)
         {
            this.mpBG_image.visible = this.mpBar_image.visible = this.mp_txt.visible = this.mpColon_txt.visible = true;
            this.level_txt.y = 94;
            this.xpBG_image.y = 96;
            this.xpBar_image.y = 99;
            this.coin_image.y = 128;
            this.xp_txt.y = 89;
            this.money_txt.y = 126;
         }
         else if(_loc2_.player.totalMP == 0)
         {
            this.mpBG_image.visible = this.mpBar_image.visible = this.mp_txt.visible = this.mpColon_txt.visible = false;
            this.level_txt.y = 94 - 32;
            this.xpBG_image.y = 96 - 32;
            this.xpBar_image.y = 99 - 32;
            this.coin_image.y = 128 - 32;
            this.xp_txt.y = 89 - 32;
            this.money_txt.y = 126 - 32;
         }
         var _loc5_:Boolean = false;
         if(this.boss_txt != null && this.boss_txt.parent != null)
         {
            _loc3_ = int(_loc2_.e_array.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               if(_loc2_.e_array[_loc4_].type == "Carnelia" || _loc2_.e_array[_loc4_].type == "giant goo cube" || _loc2_.e_array[_loc4_].type == "Kreetus")
               {
                  _loc5_ = true;
                  break;
               }
               _loc4_++;
            }
            if(_loc5_ == false)
            {
               switch(_loc2_.c_mc.currentFrame)
               {
                  case 72:
                     this.boss_txt.text = "Carnelia\'s Health: 0 / " + Stats.eStats["Carnelia"].health;
                     break;
                  case 27:
                     this.boss_txt.text = "Giant Goo Cube\'s Health: 0 / " + Stats.eStats["giant goo cube"].health;
                     break;
                  case 116:
                     this.boss_txt.text = "Kreetus\'s Health: 0 / " + Stats.eStats["Kreetus"].health;
               }
               this.bossBar_image.scaleX = 0;
            }
            else
            {
               switch(_loc2_.c_mc.currentFrame)
               {
                  case 72:
                     this.boss_txt.text = "Carnelia\'s Health: " + String(_loc2_.e_array[_loc4_].health) + " / " + String(_loc2_.e_array[_loc4_].totalHealth);
                     break;
                  case 27:
                     this.boss_txt.text = "Giant Goo Cube\'s Health: " + String(_loc2_.e_array[_loc4_].health) + " / " + String(_loc2_.e_array[_loc4_].totalHealth);
                     break;
                  case 116:
                     this.boss_txt.text = "Kreetus\'s Health: " + String(_loc2_.e_array[_loc4_].health) + " / " + String(_loc2_.e_array[_loc4_].totalHealth);
               }
               this.bossBar_image.scaleX = _loc2_.e_array[_loc4_].health / _loc2_.e_array[_loc4_].totalHealth;
            }
         }
         if(this.analogStick_btn != null && this.analogStick_btn.parent != null)
         {
            if(this.analogDown)
            {
               this.analogStick_btn.x = this.analogDown_touch.globalX;
               if(this.analogDown_touch.globalX > this.analogStickBG_image.x + 50)
               {
                  this.analogStick_btn.x = this.analogStickBG_image.x + 50;
               }
               else if(this.analogDown_touch.globalX < this.analogStickBG_image.x - 50)
               {
                  this.analogStick_btn.x = this.analogStickBG_image.x - 50;
               }
               this.analogStick_btn.y = this.analogDown_touch.globalY;
               if(this.analogDown_touch.globalY > this.analogStickBG_image.y + 50)
               {
                  this.analogStick_btn.y = this.analogStickBG_image.y + 50;
               }
               else if(this.analogDown_touch.globalY < this.analogStickBG_image.y - 50)
               {
                  this.analogStick_btn.y = this.analogStickBG_image.y - 50;
               }
               if(this.analogStick_btn.x > this.analogStickBG_image.x + 25)
               {
                  this.keyDown_event.keyCode = Keyboard.RIGHT;
                  if(this.analogWasRight == false)
                  {
                     _loc2_.onKDown(this.keyDown_event);
                  }
                  this.analogWasRight = true;
               }
               else
               {
                  this.keyUp_event.keyCode = Keyboard.RIGHT;
                  if(this.analogWasRight)
                  {
                     MainStarlingStage(root).gameMain.onKUp(this.keyUp_event);
                  }
                  this.analogWasRight = false;
               }
               if(this.analogStick_btn.x < this.analogStickBG_image.x - 25)
               {
                  this.keyDown_event.keyCode = Keyboard.LEFT;
                  if(this.analogWasLeft == false)
                  {
                     _loc2_.onKDown(this.keyDown_event);
                  }
                  this.analogWasLeft = true;
               }
               else
               {
                  this.keyUp_event.keyCode = Keyboard.LEFT;
                  if(this.analogWasLeft)
                  {
                     _loc2_.onKUp(this.keyUp_event);
                  }
                  this.analogWasLeft = false;
               }
               if(this.analogStick_btn.y > this.analogStickBG_image.y + 40)
               {
                  this.keyDown_event.keyCode = Keyboard.DOWN;
                  if(this.analogWasDown == false)
                  {
                     _loc2_.onKDown(this.keyDown_event);
                  }
                  this.analogWasDown = true;
               }
               else
               {
                  this.keyUp_event.keyCode = Keyboard.DOWN;
                  if(this.analogWasDown)
                  {
                     _loc2_.onKUp(this.keyUp_event);
                  }
                  this.analogWasDown = false;
               }
               if(this.analogStick_btn.y < this.analogStickBG_image.y - 40)
               {
                  if(this.analogWasUp == false && _loc2_.player.keyHandler.keyStates.getKeyState(Keyboard.LEFT).isDown == false && _loc2_.player.keyHandler.keyStates.getKeyState(Keyboard.RIGHT).isDown == false)
                  {
                     this.keyDown_event.keyCode = this.keyUp_event.keyCode = Keyboard.UP;
                     _loc2_.onKDown(this.keyDown_event);
                     _loc2_.onKUp(this.keyUp_event);
                  }
                  this.analogWasUp = true;
               }
               else
               {
                  this.analogWasUp = false;
               }
            }
            else
            {
               if(this.analogWasRight)
               {
                  this.keyUp_event.keyCode = Keyboard.RIGHT;
                  MainStarlingStage(root).gameMain.onKUp(this.keyUp_event);
               }
               if(this.analogWasLeft)
               {
                  this.keyUp_event.keyCode = Keyboard.LEFT;
                  MainStarlingStage(root).gameMain.onKUp(this.keyUp_event);
               }
               if(this.analogWasDown)
               {
                  this.keyUp_event.keyCode = Keyboard.DOWN;
                  MainStarlingStage(root).gameMain.onKUp(this.keyDown_event);
               }
               this.analogStick_btn.x = this.analogStickBG_image.x;
               this.analogStick_btn.y = this.analogStickBG_image.y;
               this.analogWasLeft = this.analogWasRight = this.analogWasDown = this.analogWasUp = false;
            }
         }
      }
      
      private function onReturnPressed(param1:starling.events.Event) : void
      {
         var _loc2_:int = 0;
         if(this.message_txt.text == "showDebug")
         {
            MainStarlingStage(root).gameMain.createDebugMenu();
            return;
         }
         if(this.message_txt.text != "")
         {
            if(this.sentChat_array.length >= 3 && this.checkForSpam(this.sentChat_array[this.sentChat_array.length - 1],this.message_txt.text) == false && this.checkForSpam(this.sentChat_array[this.sentChat_array.length - 2],this.message_txt.text) == false && this.checkForSpam(this.sentChat_array[this.sentChat_array.length - 3],this.message_txt.text) == false || this.sentChat_array.length < 3)
            {
               _loc2_ = getTimer() - this.lastSentMessageTime;
               if(_loc2_ > 3170)
               {
                  this.lastSentMessageTime = getTimer();
                  MainStarlingStage(root).gameMain.theConnection.send("giChat",CussFilter.checkAndSubstitute(this.message_txt.text),MainStarlingStage(root).gameMain.player.name);
                  this.sentChat_array.push(this.message_txt.text);
               }
               else
               {
                  MainStarlingStage(root).gameMain.createAlert("Spam prevention, please wait a few seconds and try again");
               }
            }
            else
            {
               this.message_txt.text = "";
               MainStarlingStage(root).gameMain.createAlert("Spamming is prohibited");
            }
         }
      }
      
      public function createShout(param1:String, param2:String, param3:uint) : void
      {
         var _loc4_:TextFormat = new TextFormat(Assets.talk_font.name,15,param3,"left");
         var _loc5_:TextField = new TextField(893,20,param2 + ": " + param1,_loc4_);
         _loc5_.x = this.chatPanel_image.x + 9;
         if(GameMain.isMobile == false)
         {
            _loc5_.y = this.chatPanel_image.y - 17 - 23 * this.shoutText_array.length;
         }
         else
         {
            _loc5_.y = this.chatPanel_image.y + this.chatPanel_image.height + 23 * this.shoutText_array.length;
         }
         _loc5_.touchable = false;
         addChild(_loc5_);
         this.shoutText_array.push(_loc5_);
         TweenLite.to(_loc5_,2,{
            "alpha":0,
            "delay":90,
            "ease":Linear.easeNone,
            "onComplete":this.shoutDone
         });
      }
      
      private function shoutDone() : void
      {
         this.shoutText_array.shift().removeFromParent(true);
      }
      
      private function checkForSpam(param1:String, param2:String) : Boolean
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         if(param1.length >= 20 && param2.length >= 20)
         {
            _loc3_ = param1.substring(2,8);
            _loc4_ = param1.substring(9,15);
            _loc5_ = param1.substr(14,18);
            if(param2.indexOf(_loc3_) > -1 && param2.indexOf(_loc4_) > -1 && Boolean(param2.indexOf(_loc5_)))
            {
               return true;
            }
         }
         return false;
      }
      
      public function createPetControlBars(param1:String) : void
      {
         var _loc2_:int = int(this.petPanel_images.length);
         var _loc3_:Image = new Image(controls_textureAtlas.getTexture("pet bars BG"));
         _loc3_.x = 3;
         _loc3_.y = 170 + 48 * _loc2_;
         addChildAt(_loc3_,0);
         this.petPanel_images.push(_loc3_);
         var _loc4_:Image = new Image(controls_textureAtlas.getTexture("pet health bar"));
         _loc4_.y = 172 + 48 * _loc2_;
         addChildAt(_loc4_,1);
         this.petHealthBar_images.push(_loc4_);
         var _loc5_:Image = new Image(controls_textureAtlas.getTexture("pet xp bar"));
         _loc5_.x = _loc4_.x = 26;
         _loc5_.y = 184 + 48 * _loc2_;
         addChildAt(_loc5_,1);
         this.petXPBar_images.push(_loc5_);
         var _loc6_:TextField = new TextField(111,17,param1,petName_textFormat);
         _loc6_.x = 27;
         _loc6_.y = 153 + 48 * _loc2_;
         _loc6_.touchable = _loc5_.touchable = _loc4_.touchable = _loc3_.touchable = false;
         _loc6_.batchable = true;
         addChildAt(_loc6_,getChildIndex(this.money_txt));
         this.petName_txts.push(_loc6_);
      }
      
      public function removePetControlBars(param1:String) : void
      {
         var _loc2_:int = int(this.petName_txts.length);
         var _loc3_:* = int(_loc2_ - 1);
         while(_loc3_ >= 0)
         {
            if(this.petName_txts[_loc3_].text == param1)
            {
               this.petPanel_images[_loc3_].removeFromParent(true);
               this.petHealthBar_images[_loc3_].removeFromParent(true);
               this.petXPBar_images[_loc3_].removeFromParent(true);
               this.petName_txts[_loc3_].removeFromParent(true);
               this.petPanel_images.removeAt(_loc3_);
               this.petHealthBar_images.removeAt(_loc3_);
               this.petXPBar_images.removeAt(_loc3_);
               this.petName_txts.removeAt(_loc3_);
               break;
            }
            _loc3_--;
         }
         _loc2_ = int(this.petName_txts.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.petPanel_images[_loc3_].y = 170 + 48 * _loc3_;
            this.petHealthBar_images[_loc3_].y = 172 + 48 * _loc3_;
            this.petXPBar_images[_loc3_].y = 184 + 48 * _loc3_;
            this.petName_txts[_loc3_].y = 153 + 48 * _loc3_;
            _loc3_++;
         }
      }
      
      public function createBossHealth() : void
      {
         if(this.bossBG_image == null || this.bossBG_image.parent == null)
         {
            this.bossBar_image = new Image(controls_textureAtlas.getTexture("boss bar"));
            this.bossBar_image.x = 380;
            this.bossBar_image.y = 97;
            addChildAt(this.bossBar_image,0);
            this.bossBG_image = new Image(controls_textureAtlas.getTexture("boss BG"));
            this.bossBG_image.x = 378;
            this.bossBG_image.y = 95;
            addChildAt(this.bossBG_image,0);
            this.boss_txt = new TextField(288,19,"",MP_XP_textFormat);
            this.boss_txt.x = 380;
            this.boss_txt.y = 78;
            this.boss_txt.touchable = this.bossBG_image.touchable = this.bossBar_image.touchable = false;
            this.boss_txt.batchable = true;
            addChildAt(this.boss_txt,getChildIndex(this.money_txt));
         }
      }
      
      public function removeBossHealth() : void
      {
         if(this.bossBG_image != null)
         {
            this.bossBG_image.removeFromParent(true);
            this.bossBar_image.removeFromParent(true);
            this.boss_txt.removeFromParent(true);
         }
      }
   }
}

