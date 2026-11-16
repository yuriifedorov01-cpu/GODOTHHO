package
{
   import com.apis.*;
   import com.game_objects.*;
   import com.game_objects.enemies.*;
   import com.game_objects.power_up_effects.*;
   import com.gravityPackage.*;
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.helpers.*;
   import com.lighting.*;
   import com.math.*;
   import com.menus.*;
   import com.menus.add_ons.*;
   import com.sound.*;
   import com.stats.*;
   import com.ui.*;
   import com.utilities.*;
   import com.visual_effects.*;
   import feathers.controls.text.*;
   import fl.motion.*;
   import flash.display.*;
   import flash.display3D.*;
   import flash.events.*;
   import flash.external.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import playerio.*;
   import starling.*;
   import starling.animation.*;
   import starling.core.*;
   import starling.display.*;
   import starling.events.Event;
   import starling.extensions.lighting.*;
   import starling.filters.*;
   import starling.text.*;
   import starling.textures.*;
   import starling.utils.*;
   
   [SWF(width="950", height="700", backgroundColor="#999999", frameRate="30")]
   public final class GameMain extends flash.display.MovieClip
   {
      
      public static const bright_colorTransform:ColorTransform = new ColorTransform(1,1,1,1,127,127,127);
      
      public static const normal_colorTransform:ColorTransform = new ColorTransform();
      
      private static var __isMobile:Boolean = Capabilities.cpuArchitecture == "ARM" && Capabilities.playerType == "Desktop";
      
      private static var __isIOS:Boolean = Capabilities.os.indexOf("iPhone") >= 0 || Capabilities.os.indexOf("iPad") >= 0 || Capabilities.os.indexOf("iPod") >= 0;
      
      private static var __isAmazonUnderground:Boolean = false;
      
      public static var drawGravityLines:Boolean = false;
      
      public static var lighting:Boolean = false;
      
      public var adventure_mc:flash.display.MovieClip;
      
      public var barBG_mc:flash.display.MovieClip;
      
      public var helmetBG_mc:flash.display.MovieClip;
      
      public var helmet_mc:flash.display.MovieClip;
      
      public var heroesBG_mc:flash.display.MovieClip;
      
      public var heroes_mc:flash.display.MovieClip;
      
      public var init_txt:flash.text.TextField;
      
      public var load_txt:flash.text.TextField;
      
      public var loader_mc:flash.display.MovieClip;
      
      public var nonSteam_btn:SimpleButton;
      
      public var sword_mc:flash.display.MovieClip;
      
      public var test2_txt:flash.text.TextField;
      
      public var test_txt:flash.text.TextField;
      
      public var theConnection:Connection;
      
      public var theClient:Client;
      
      public var itemMenu:ItemMenu;
      
      public var player:Person;
      
      public var charCreateMenu:CreateMenu;
      
      public var talkBox:TalkBox;
      
      public var missionMenu:MissionMenu;
      
      public var mMenu:MainMenu;
      
      private var loadScreen:LoadScreen;
      
      private var textAlert:TextAlert;
      
      public var deadMenu:DeadMenu;
      
      public var tutorial:Tutorial;
      
      private var connectMenu:ConnectMenu;
      
      public var updateMenu:UpdateMenu;
      
      public var debugMenu:DebugMenu;
      
      public var infoMenu:InfoMenu;
      
      public var optionMenu:OptionMenu;
      
      public var mapMenu:MapMenu;
      
      public var friendMenu:FriendMenu;
      
      public var tradeMenu:TradeMenu;
      
      private var tradeRequest:TradeRequest;
      
      public var pvMenu:PayVaultMenu;
      
      public var heroMenu:HeropediaMenu;
      
      private var guildMenu:GuildMenu;
      
      public var guildMemberMenu:GuildMemberMenu;
      
      public var confirmMenu:ConfirmMenu;
      
      private var membersInAreaMenu:MembersInAreaMenu;
      
      public var bankMenu:BankMenu;
      
      public var pmMenu:PMMenu;
      
      private var snow:Snow;
      
      public var skillsMenu:SkillsMenu;
      
      private var rain:Rain;
      
      private var lavaRain:LavaRain;
      
      public var petShopMenu:PetShopMenu;
      
      public var petConfirmMenu:PetConfirmMenu;
      
      public var petMenu:PetMenu;
      
      public var petModeMenu:PetModeMenu;
      
      public var energyMenu:EnergyMenu;
      
      public var fishListMenu:FishListMenu;
      
      private var localConnection:LocalConnection;
      
      public var petItemMenu:PetItemMenu;
      
      public var alertMenu:AlertMenu;
      
      private var cutscene_loader:Loader;
      
      private var loadingCircle:LoadingCircle;
      
      public var presentMenu:PresentMenu;
      
      public var rankMenu:RankMenu;
      
      public var cMenu:CharacterMenu;
      
      public var bullhornMenu:BullhornMenu;
      
      private var skipButton:SkipButton;
      
      private var cutsceneBoarder:CutsceneBoarder;
      
      public var rcMenu:RightClickMenu;
      
      public var lotteryMenu:LotteryMenu;
      
      public var controllerMain:GameInputDevice;
      
      public var craftingMenu:CraftingMenu;
      
      private var petVendor:PetVendor;
      
      public var petVendMenu:PetVendMenu;
      
      public var mainStarling:Starling;
      
      public var starlingStage:MainStarlingStage;
      
      public var y8_api:IDI;
      
      public var moderatorMenu:ModeratorMenu;
      
      public var p_array:Vector.<Person> = new Vector.<Person>();
      
      public var e_array:Vector.<Enemy> = new Vector.<Enemy>();
      
      public var item_array:Vector.<Item> = new Vector.<Item>();
      
      public var projectile_array:Vector.<Projectile> = new Vector.<Projectile>();
      
      public var npc_array:Vector.<Person> = new Vector.<Person>();
      
      private var shootingObject_array:Array = new Array();
      
      private var portal_array:Vector.<Image> = new Vector.<Image>();
      
      private var unlockedMaps_array:Vector.<uint> = new Vector.<uint>();
      
      private var magicEffect_array:Vector.<MagicEffect> = new Vector.<MagicEffect>();
      
      private var waterBubble_array:Vector.<WaterBubble> = new Vector.<WaterBubble>();
      
      private var guildsRank_array:Array = new Array();
      
      private var animation_array:Vector.<starling.display.MovieClip> = new Vector.<starling.display.MovieClip>();
      
      private var hCircle_array:Vector.<HealingCircle> = new Vector.<HealingCircle>();
      
      public var pet_array:Vector.<Pet> = new Vector.<Pet>();
      
      private var smoke_array:Vector.<Smoke> = new Vector.<Smoke>();
      
      private var pvItems_array:Vector.<DatabaseObject> = new Vector.<DatabaseObject>();
      
      private var receivedShouts_array:Vector.<String> = new Vector.<String>();
      
      public var stormCloud_array:Vector.<Cloud> = new Vector.<Cloud>();
      
      private var guildChatMembers_array:Array = new Array();
      
      private var receivedGuildMessages:Array = new Array();
      
      public var personItem_array:Vector.<String> = new Vector.<String>();
      
      public var roomCounts_array:Vector.<uint> = new Vector.<uint>(146,true);
      
      public var lightningBolt_array:Vector.<LightningBolt> = new Vector.<LightningBolt>();
      
      private var enemyList_array:Vector.<String> = new Vector.<String>();
      
      private var fishList_array:Vector.<String> = new Vector.<String>();
      
      private var serverEnemies_array:Vector.<String> = new Vector.<String>();
      
      private var serverNames_array:Vector.<String> = new Vector.<String>();
      
      private var serverPops_array:Vector.<int> = new Vector.<int>();
      
      public var main_juggler:Juggler = new Juggler();
      
      public var shortcutItem:String = "";
      
      public var mDownTargetName:String = "";
      
      private var disconnectReason:String = "Unknown";
      
      public var serverName:String = "Pve Server";
      
      private var secretHash:String = "";
      
      private var miscString:String = "";
      
      private var accessToken:String = "";
      
      public var playingURL_string:String = "noShare";
      
      public const validString:RegExp = /[^A-Za-z0-9_]/g;
      
      private const validSpaceString:RegExp = /[^A-Za-z0-9_ ]/g;
      
      public const numberString:RegExp = /[0-9]/g;
      
      public const gravity:Number = 1.1;
      
      private var serverVersion:Number = 0;
      
      private var startUpTime:Number = getTimer();
      
      private var pingStartTime:Number = 0;
      
      public const SCROLL_X_MODIFIER:int = 6;
      
      public const SCROLL_Y_MODIFIER:int = 3;
      
      public var maxPets:int = 4;
      
      private var serverCounter:int = 0;
      
      private var onlineFriendIntervalCheck:int = 600;
      
      private var guildMembersChecked:Object = {};
      
      private var lastLogOnName:String = "";
      
      private var lastLogOnTime:int = 0;
      
      private var damageDone:int = 0;
      
      private var totalGamePlayers:int = 0;
      
      public var connectType:String = "simple";
      
      public var lastEnemyNameHit:String = "";
      
      private var dupeSignInAttempts:int = 0;
      
      private var levelChangeCounter:int = 0;
      
      public var maxFriends:int = 20;
      
      private var currentLevel:int = 1;
      
      public var lastTradeCounter:int = 0;
      
      private var timesLoaded:int = 0;
      
      public var hitStopCounter:int = 1;
      
      private var hitStopFramesSkipped:int = 0;
      
      public var maxItems:int = 20;
      
      private var lastPortal:uint = 0;
      
      private var lotteryTicketJackpot:int = 0;
      
      private var lotteryCoinJackpot:uint = 0;
      
      public var skillsDataHasLoaded:Boolean = false;
      
      public var proDataHasLoaded:Boolean = false;
      
      private var hasMainEnterFrameListener:Boolean = false;
      
      private var roboInvasionActive:Boolean = false;
      
      public var setButtonsMode:* = false;
      
      private var loadedPlayerMiscSuccess:Boolean = false;
      
      public var hasResale:Boolean = false;
      
      public var hasTeleport:Boolean = false;
      
      public var maxActivePets:uint = 1;
      
      public var itemsTryLoaded:Boolean = false;
      
      public var hasItemStorage:Boolean = false;
      
      public var hasFishRadar:Boolean = false;
      
      private var playerToPortalPositionSet:Boolean = false;
      
      private var hasGuildMoney3x:Boolean = false;
      
      private var mDown:Boolean = false;
      
      public var allowDamage:Boolean = true;
      
      public var hasXPSplit:Boolean = false;
      
      private var hasDoubleDrop:Boolean = false;
      
      public var hasManualControl:Boolean = false;
      
      public var hasEnemyControl:Boolean = false;
      
      private var global_point:Point = new Point();
      
      private var global2_point:Point = new Point();
      
      private var local_point:Point = new Point();
      
      private var itemLoad:Object = new Object();
      
      private const red_colorTransform:ColorTransform = new ColorTransform(1,0,0,1,150,0,0);
      
      public var stormCloud_color:fl.motion.Color = new Color();
      
      private var color_bitmapData:BitmapData = new BitmapData(5,5,false);
      
      private var hit_rect:Rectangle = new Rectangle(1,1,1,1);
      
      private var redirect_url:URLRequest = new URLRequest();
      
      private var lotteryEndDate:Date = new Date();
      
      public var save_sharedObject:SharedObject = SharedObject.getLocal("HelmetHeroes","/");
      
      private var dbItems_sharedObject:SharedObject = SharedObject.getLocal("HH_database_items","/");
      
      private var cutscene_URLRequest:URLRequest = new URLRequest();
      
      private var paypal_url:URLRequest = new URLRequest();
      
      private var trialPay_url:URLRequest = new URLRequest();
      
      private var today_date:Date = new Date();
      
      public var c_mc:flash.display.MovieClip;
      
      private var gameInput:GameInput = new GameInput();
      
      private var basic_localConnection:LocalConnection = new LocalConnection();
      
      private var trueFullScreenWidth:int = 0;
      
      private var trueFullScreenHeight:int = 0;
      
      private var dbCacheVersion:String = "12.15";
      
      public var country:String = "";
      
      private var idleCounter:uint = 0;
      
      private var payvaultHistoryChecked:Boolean = false;
      
      public var isPayingUser:Boolean = false;
      
      private var fakeCursor:FakeCursor;
      
      public var showAds:Boolean = false;
      
      internal var counter:int = new int(0);
      
      internal var ran_num:Number = new Number(0);
      
      internal var i:int = new int(0);
      
      internal var j:int = new int(0);
      
      internal var d:int = new int(0);
      
      internal var a:int = new int(0);
      
      internal var b:int = new int(0);
      
      internal var t:int = new int(0);
      
      internal var w:int = new int(0);
      
      internal var g:int = new int(0);
      
      internal var q:int = new int(0);
      
      internal var len:int = new int(0);
      
      internal var len2:int = new int(0);
      
      internal var len3:int = new int(0);
      
      internal var len4:int = new int(0);
      
      internal var len5:int = new int(0);
      
      internal var len6:int = new int(0);
      
      internal var len7:int = new int(0);
      
      private var enterDown:Boolean = false;
      
      private var upButton_string:String = "";
      
      private var leftButton_string:String = "";
      
      private var rightButton_string:String = "";
      
      private var downButton_string:String = "";
      
      private var attackButton_string:String = "";
      
      private var lootButton_string:String = "";
      
      private var jumpButton_string:String = "";
      
      private var rageButton_string:String = "";
      
      private var guildRageButton_string:String = "";
      
      private var healButton_string:String = "";
      
      private var guildHealButton_string:String = "";
      
      private var vButton_string:String = "";
      
      private var cButton_string:String = "";
      
      private var fakeClick_string:String = "";
      
      private var scrollMenuDown:Boolean = false;
      
      private var scrollMenuUp:Boolean = false;
      
      private var downButtonDir:int = 1;
      
      public function GameMain()
      {
         super();
         addEventListener(flash.events.Event.ADDED_TO_STAGE,this.onFirstAdded);
      }
      
      public static function get isMobile() : Boolean
      {
         return __isMobile;
      }
      
      public static function get isIOS() : Boolean
      {
         return __isIOS;
      }
      
      public static function get isAmazonUnderground() : Boolean
      {
         return __isAmazonUnderground;
      }
      
      public function connectToServer(param1:String = "simple") : *
      {
         var _type:String = param1;
         var n_playerIOConnect:Function = function():void
         {
            var _loc1_:Object = new Object();
            switch(_type)
            {
               case "facebook":
                  PlayerIO.quickConnect.facebookOAuthConnectPopup(stage,"hho-ygpra4ftumusohpifpdug","_blank",[],null,null,handleConnect,handleError);
                  break;
               case "simple":
                  _loc1_.username = player.name;
                  _loc1_.password = player.password;
                  PlayerIO.authenticate(stage,"hho-ygpra4ftumusohpifpdug","simpleconnection",_loc1_,null,handleConnect,handleError);
                  break;
               case "basic":
                  _loc1_.userId = player.name;
                  _loc1_.auth = player.password;
                  PlayerIO.authenticate(stage,"hho-ygpra4ftumusohpifpdug","public",_loc1_,null,handleConnect,handleError);
                  break;
               case "kongregate":
                  _loc1_.userId = player.name;
                  _loc1_.gameAuthToken = Kongregate.token;
                  break;
               case "steam":
                  _loc1_.steamAppId = Steam.steam.getAppID();
                  _loc1_.steamSessionTicket = Steam.getAuthToken();
                  break;
               case "publishingnetwork":
                  _loc1_.userId = player.name;
                  _loc1_.userToken = PlayerIOPublishingNetwork.token;
            }
         };
         n_playerIOConnect();
      }
      
      public function handleConnect(param1:Client, param2:String = "", param3:String = "") : void
      {
         this.theClient = param1;
         if(this.charCreateMenu != null && this.charCreateMenu.parent != null)
         {
            this.player.name = this.charCreateMenu.name_txt.text;
            this.player.password = this.charCreateMenu.password_txt.text;
            this.personItem_array.push("white shirt","white shoe","green shorts");
            switch(this.charCreateMenu.class_txt.text)
            {
               case "warrior":
                  this.personItem_array.push("stick");
                  break;
               case "archer":
                  this.personItem_array.push("slingshot");
                  break;
               case "mage":
                  this.personItem_array.push("basic wand");
                  break;
               case "cowboy":
                  this.personItem_array.push("airsoft gun");
            }
            this.charCreateMenu.hideButtons();
            this.startIntro();
            SoundManager.fadeOutMusic();
            this.charCreateMenu.finished_btn.visible = false;
            this.joinRoom();
         }
         else if(this.mMenu.loadingCircle_mc.loadingText_txt.text == "connecting to service" || this.mMenu.loadingCircle_mc.loadingText_txt.text == "loaded?")
         {
            this.mMenu.loadingCircle_mc.loadingText_txt.text = "loading area info";
            this.preLogInLoad();
            this.starlingStage.startMain();
         }
      }
      
      private function joinRoom() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         var _loc4_:Pet = null;
         if(this.mMenu != null && this.mMenu.parent != null)
         {
            this.mMenu.loadingCircle_mc.loadingText_txt.text = "connecting to room";
         }
         else if(this.loadScreen != null && this.loadScreen.parent != null)
         {
            this.loadScreen.loadInfo_txt.text += "\njoining room";
         }
         var _loc5_:Object = new Object();
         if(this.mMenu != null && this.mMenu.parent != null)
         {
            _loc5_.firstJoin = true;
            _loc2_ = "web";
            if(Capabilities.cpuArchitecture == "ARM")
            {
               _loc2_ = "mobile";
            }
            else if(Capabilities.playerType == "Desktop")
            {
               _loc2_ = "desktop";
            }
         }
         if(this.mMenu != null && this.mMenu.relink == true)
         {
            _loc5_.relink = ArmorGames.uid;
            _loc5_.uid = ArmorGames.uid;
         }
         if(this.hasGuildMoney3x)
         {
            _loc5_.x3 = true;
         }
         if(this.charCreateMenu != null && this.charCreateMenu.parent != null)
         {
            _loc5_.url = this.playingURL_string;
            _loc5_.skin = this.charCreateMenu.gender_txt.text == "boy" ? this.player.bodyAnimator.skin : this.player.bodyAnimator.skin + 4;
            _loc5_.eyes = this.player.bodyAnimator.eyes;
            _loc5_.hair = this.player.bodyAnimator.hair;
            _loc5_.beard = this.player.bodyAnimator.beard;
            _loc5_.classType = this.charCreateMenu.class_txt.text;
            if(this.connectType == "facebook" || this.connectType == "kongregate" || this.connectType == "steam" || this.connectType == "publishingnetwork")
            {
               _loc5_.username = this.charCreateMenu.name_txt.text;
            }
            switch(this.playingURL_string)
            {
               case "armorgames.com":
                  _loc5_.uid = ArmorGames.uid;
                  break;
               case "kongregate.com":
                  _loc5_.uid = Kongregate.uid;
                  _loc5_.onKong = true;
                  break;
               case "y8.com":
                  _loc5_.uid = this.y8_api.userID;
                  break;
               case "miniplay.com":
                  _loc5_.uid = MiniPlay.lechuck.user.id;
                  break;
               case "steampowered.com":
                  _loc5_.onSteam = true;
                  break;
               case "playerio.com":
                  _loc5_.onPlayerIO = true;
            }
            TweenMax.to(this.charCreateMenu,2,{
               "alpha":0,
               "delay":5,
               "ease":Linear.easeNone,
               "onComplete":this.charCreateMenu.removeFromParent,
               "onCompleteParams":[true]
            });
         }
         if(this.dupeSignInAttempts > 0 && this.playingURL_string != "armorgames.com")
         {
            _loc5_.dupeSignIn = this.dupeSignInAttempts;
         }
         this.theClient.multiplayer.createJoinRoom(this.starlingStage.controls.version_txt.text + "-r" + this.currentLevel + "_" + this.serverName,"MyCode",true,{},_loc5_,this.handleJoin,this.roomConnectError);
         var _loc6_:uint = 0;
         for each(_loc1_ in Stats.missionList)
         {
            if(Stats.missionStats[_loc1_].completed)
            {
               _loc6_++;
            }
         }
         if(this.playingURL_string == "kongregate.com")
         {
            _loc3_ = 0;
            for each(_loc4_ in this.player.pet_array)
            {
               _loc3_ += _loc4_.lvl;
            }
            Kongregate.kongregateAPI.stats.submit("level",this.player.lev);
            Kongregate.kongregateAPI.stats.submit("chopping",this.player.choppingLvl);
            Kongregate.kongregateAPI.stats.submit("fishing",this.player.fishingLvl);
            Kongregate.kongregateAPI.stats.submit("petlevels",_loc3_);
            Kongregate.kongregateAPI.stats.submit("missions completed",_loc6_);
         }
         else if(Steam.onSteam)
         {
            if(this.player.lev >= 140)
            {
               Steam.steam.setAchievement("LEVEL_140");
            }
            if(this.player.lev >= 50)
            {
               Steam.steam.setAchievement("LEVEL_50");
            }
            if(this.player.lev >= 10)
            {
               Steam.steam.setAchievement("LEVEL_10");
            }
            if(this.player.money >= 1000000)
            {
               Steam.steam.setAchievement("1MILL");
            }
            else if(this.player.money >= 100000)
            {
               Steam.steam.setAchievement("100K");
            }
         }
         else if(this.playingURL_string == "ungrounded.net" && Boolean(Newgrounds.isReady))
         {
            if(this.player.lev >= 140)
            {
               Newgrounds.completeAchievement("Level 140");
            }
            else if(this.player.lev >= 50)
            {
               Newgrounds.completeAchievement("Level 50");
            }
            else if(this.player.lev >= 10)
            {
               Newgrounds.completeAchievement("Level 10");
            }
            if(this.player.money >= 1000000)
            {
               Newgrounds.completeAchievement("1,000,000 gold");
            }
            else if(this.player.money >= 100000)
            {
               Newgrounds.completeAchievement("100,000 gold");
            }
            Newgrounds.submitScore("Levels",this.player.lev);
            Newgrounds.submitScore("Fishing Levels",this.player.fishingLvl);
            Newgrounds.submitScore("Chopping Levels",this.player.choppingLvl);
         }
         else if(this.playingURL_string == "y8.com")
         {
            if(this.player.lev >= 140)
            {
               this.y8_api.achievementsSave("Level 140","efcbc0fe4c6c06a6ee0c");
            }
            else if(this.player.lev >= 50)
            {
               this.y8_api.achievementsSave("Level 50","ab812234c906d19d565f");
            }
            else if(this.player.lev >= 10)
            {
               this.y8_api.achievementsSave("Level 10","6fb24cd3ecbf1168d167");
            }
            if(this.player.money >= 1000000)
            {
               this.y8_api.achievementsSave("1,000,000 gold","a84b80e67cb78c206cbe");
            }
            else if(this.player.money >= 100000)
            {
               this.y8_api.achievementsSave("100,000 gold","017801814fdee706cb16");
            }
            this.y8_api.advancedScoreSubmit(this.player.lev,"Levels");
            this.y8_api.advancedScoreSubmit(this.player.fishingLvl,"Fishing Levels");
            this.y8_api.advancedScoreSubmit(this.player.choppingLvl,"Chopping Levels");
         }
         if(CreateMenu.charCreateMenu_textureAtlas != null)
         {
            CreateMenu.charCreateMenu_textureAtlas.dispose();
         }
      }
      
      private function handleJoin(param1:Connection) : void
      {
         this.theConnection = param1;
         param1.addDisconnectHandler(this.handleDisconnect);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKDown);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onKUp);
         this.theConnection.addMessageHandler("pJoin",this.playerJoined);
         this.theConnection.addMessageHandler("PIn",this.personInfoGot);
         this.theConnection.addMessageHandler("newP",this.singlePersonInfoGot);
         this.theConnection.addMessageHandler("newPM",this.personMiscInfoGot);
         this.theConnection.addMessageHandler("friendOnline",this.friendOnlineGot);
         this.theConnection.addMessageHandler("guildMemberOnline",this.guildMemberOnlineGot);
         this.theConnection.addMessageHandler("petIn",this.singlePetInfoGot);
         this.theConnection.addMessageHandler("orb",this.newOrbGot);
         this.theConnection.addMessageHandler("UserL",this.personDisconnect);
         this.theConnection.addMessageHandler("newE",this.newEnemyCreatedGot);
         this.theConnection.addMessageHandler("Ei",this.enemyInfoGot);
         this.theConnection.addMessageHandler("petI",this.petInfoGot);
         this.theConnection.addMessageHandler("item",this.newItemCreatedGot);
         this.theConnection.addMessageHandler("geIIn",this.itemInfoGot);
         this.theConnection.addMessageHandler("geIRe",this.itemRemovedGot);
         this.theConnection.addMessageHandler("geReAllIIn",this.singleItemInfoGot);
         this.theConnection.addMessageHandler("chat",this.newChatMessageGot);
         this.theConnection.addMessageHandler("getNewEquip",this.newEquipGot);
         this.theConnection.addMessageHandler("dmgE",this.enemyDamagedGot);
         this.theConnection.addMessageHandler("eSync",this.enemySyncGot);
         this.theConnection.addMessageHandler("XP",this.updatePersonXP);
         this.theConnection.addMessageHandler("updPetXP",this.updatePetXP);
         this.theConnection.addMessageHandler("iBoughtCheck",this.itemBought);
         this.theConnection.addMessageHandler("iSold",this.itemSold);
         this.theConnection.addMessageHandler("pointUse",this.abilityPointUsed);
         this.theConnection.addMessageHandler("dmgP",this.playerDamaged);
         this.theConnection.addMessageHandler("envDmgP",this.playerEnvDamaged);
         this.theConnection.addMessageHandler("kD",this.personKeyDown);
         this.theConnection.addMessageHandler("kU",this.personKeyUp);
         this.theConnection.addMessageHandler("geKicked",this.getKicked);
         this.theConnection.addMessageHandler("PHea",this.personHealed);
         this.theConnection.addMessageHandler("geTReq",this.tradeRequestReceived);
         this.theConnection.addMessageHandler("tDecl",this.tradeDeclined);
         this.theConnection.addMessageHandler("tAcc",this.tradeAccepted);
         this.theConnection.addMessageHandler("rageStart",this.rageStart);
         this.theConnection.addMessageHandler("rageEnd",this.rageEnd);
         this.theConnection.addMessageHandler("ping",this.pingGot);
         this.theConnection.addMessageHandler("petActi",this.petActivated);
         this.theConnection.addMessageHandler("withdPet",this.petWithdraw);
         this.theConnection.addMessageHandler("petMChange",this.petModeChanged);
         this.theConnection.addMessageHandler("petIEquip",this.petItemEquipped);
         this.theConnection.addMessageHandler("petHeal",this.petHealedGot);
         this.theConnection.addMessageHandler("dmgPet",this.petDamageGot);
         this.theConnection.addMessageHandler("checkEvo",this.checkPetEvolution);
         this.theConnection.addMessageHandler("petEvolved",this.petEvolved);
         this.theConnection.addMessageHandler("alert",this.getAlert);
         this.theConnection.addMessageHandler("PLove",this.getPetLove);
         this.theConnection.addMessageHandler("gePetConTog",this.getPetModeToggled);
         this.theConnection.addMessageHandler("singlePing",this.gotSinglePing);
         this.theConnection.addMessageHandler("geIpCheck",this.ipBanCheckGot);
         this.theConnection.addMessageHandler("proxyDetected",this.proxyDetected);
         this.theConnection.addMessageHandler("geShout",this.shoutGot);
         this.theConnection.addMessageHandler("SBall",this.spawnBallInfoGot);
         this.theConnection.addMessageHandler("fish",this.fishCreatedGot);
         this.theConnection.addMessageHandler("count",this.serverCounterGot);
         this.theConnection.addMessageHandler("fishRe",this.fishRemovedGot);
         this.theConnection.addMessageHandler("tree",this.treeGot);
         this.theConnection.addMessageHandler("tDmg",this.treeDamagedGot);
         this.theConnection.addMessageHandler("petSumFwd",this.petsSummonedForward);
         this.theConnection.addMessageHandler("eContr",this.enemyControlled);
         this.theConnection.addMessageHandler("eNoCont",this.enemyNoControl);
         this.theConnection.addMessageHandler("tile",this.singleTileGot);
         this.theConnection.addMessageHandler("portal",this.portalGot);
         this.theConnection.addMessageHandler("unleash",this.powerUnleashed);
         this.theConnection.addMessageHandler("eChar",this.energyChargeGot);
         this.theConnection.addMessageHandler("fraudCheckGot",this.fraudCheckGot);
         if(this.connectType == "facebook")
         {
            this.theConnection.addMessageHandler("noCharMade",this.noCharMade);
         }
         if(this.currentLevel == 56)
         {
            this.theConnection.addMessageHandler("newVendorSet",this.newVendorSet);
            this.theConnection.addMessageHandler("newVItemAdded",this.newVItemAdded);
            this.theConnection.addMessageHandler("boughtVTickets",this.boughtVendorTickets);
         }
         else if(this.currentLevel == 116)
         {
            this.theConnection.addMessageHandler("newBCannon",this.newBeholderCannonGot);
            this.theConnection.addMessageHandler("beCannonReGot",this.beholderCannonRemoved);
         }
         else if(this.currentLevel == 98)
         {
            this.theConnection.addMessageHandler("newPVenSet",this.newPetVendorSet);
            this.theConnection.addMessageHandler("petBoughtFromVend",this.removePetVendor);
         }
         this.theConnection.addMessageHandler("tileDefs",this.tileDefsGot);
         this.theConnection.addMessageHandler("geTiles",this.tileDataGot);
         this.theConnection.addMessageHandler("geAtm",this.geAtmGot);
         if(this.skillsDataHasLoaded == false)
         {
            this.theConnection.addMessageHandler("pLoaded",this.playerLoaded);
            this.theClient.bigDB.load("skillsData",this.player.name,this.skillsDataLoaded);
         }
         if(this.proDataHasLoaded == false)
         {
            this.theClient.bigDB.load("proficiencyTable",this.player.name,this.proDataLoaded);
         }
         if(this.mMenu != null && this.mMenu.parent != null)
         {
            this.theConnection.addMessageHandler("wrongCap",this.wrongCap);
            this.mMenu.loadingCircle_mc.loadingText_txt.text = "loading player";
         }
         if(this.mMenu != null && this.mMenu.parent != null && this.timesLoaded == 1 && this.player.password != "")
         {
            this.theClient.bigDB.deleteRange("messageTable","receiverIndex",[this.mMenu.username_txt.text],0,0);
         }
         ++this.timesLoaded;
         this.theClient.bigDB.loadRange("vendorData","playerIndex",null,null,null,200,this.vendorsLoaded);
         if(this.currentLevel == 83)
         {
            this.theClient.bigDB.loadRange("lotteryTable","ticketIndex",null,null,null,500,this.lotteryTicketsLoaded);
            this.theClient.bigDB.loadRange("lotteryTable","coinIndex",null,null,null,500,this.lotteryCoinsLoaded);
            this.theClient.bigDB.load("miscTable","lotteryWinners",this.lotteryWinnersLoaded);
            this.theClient.bigDB.load("miscTable","lotteryInfo",this.lotteryInfoLoaded);
            this.theConnection.addMessageHandler("newLotto",this.newLotteryPurchase);
         }
         else if(this.currentLevel == 98)
         {
            this.theClient.bigDB.loadRange("petVendorData","playerIndex",null,null,null,100,this.petVendorsLoaded);
         }
         else if(this.currentLevel == 30)
         {
            this.theConnection.addMessageHandler("roboInv",this.startRoboCityInvasion);
            this.theConnection.addMessageHandler("endRoboInv",this.endRoboCityInvasion);
         }
         if(Math.random() > 0.9983)
         {
            this.theClient.multiplayer.listRooms("MyCode",{},500,0,this.roomInfoGot);
         }
      }
      
      private function handleDisconnect() : void
      {
         if(this.textAlert == null || this.textAlert.parent == null)
         {
            this.createAlert("disconnected");
         }
         stage.frameRate = 0;
         stage.removeEventListener(flash.events.Event.ENTER_FRAME,this.onEnter);
      }
      
      private function roomConnectError(param1:PlayerIOError) : void
      {
         if(this.mMenu != null && this.mMenu.parent != null)
         {
            this.mMenu.loadingCircle_mc.loadingText_txt.text = "room connect error";
            this.mMenu.valid_txt.text = param1.message;
         }
      }
      
      private function handleError(param1:PlayerIOError) : void
      {
         this.createAlert("error connecting");
         if(this.charCreateMenu != null && this.charCreateMenu.parent != null)
         {
            this.createAlert("Authentication failed, try again");
            this.charCreateMenu.finished_btn.visible = true;
         }
         else if(this.mMenu != null && this.mMenu.parent != null)
         {
            this.mMenu.loadingCircle_mc.loadingText_txt.text = "main connect error";
            stage.removeEventListener(flash.events.Event.ENTER_FRAME,this.onLoadCheckEnter);
            if(this.loadScreen != null)
            {
               this.loadScreen.removeFromParent(true);
            }
            SoundManager.changeMusic(Assets.main_assetManager.getSound("main menu music"));
            this.mMenu.valid_txt.text = param1.message;
            this.mMenu.signIn_btn.visible = true;
            this.mMenu.username_txt.visible = true;
            this.mMenu.password_txt.visible = true;
            this.mMenu.usernamePanel_mc.visible = true;
            this.mMenu.passwordPanel_mc.visible = true;
            this.mMenu.loadingCircle_mc.visible = false;
            this.mMenu.usernamePanel_mc.visible = true;
            this.mMenu.passwordPanel_mc.visible = true;
            this.mMenu.rememberMe_txt.visible = true;
            this.mMenu.rememberMe_mc.visible = true;
            if(this.country != "Philippines")
            {
               this.mMenu.signUp_btn.visible = true;
            }
            this.mMenu.credits_btn.visible = true;
            this.mMenu.signInColon_txt.visible = true;
         }
         else
         {
            this.createConnectMenu();
         }
      }
      
      public function loadCheckItemAndEnemyStats(param1:Client) : void
      {
         if(this.itemsTryLoaded == false)
         {
            this.itemsTryLoaded = true;
            if(this.dbItems_sharedObject.data.dbCacheVersion != this.dbCacheVersion)
            {
               this.dbItems_sharedObject.clear();
            }
            this.dbItems_sharedObject.data.dbCacheVersion = this.dbCacheVersion;
            if(this.dbItems_sharedObject.data.wStats == null)
            {
               param1.bigDB.loadRange("weaponStats","costIndex",null,0,int.MAX_VALUE,300,this.weaponStatsLoaded);
            }
            else
            {
               this.weaponStatsLoaded(this.dbItems_sharedObject.data.wStats,true);
            }
            if(this.dbItems_sharedObject.data.hStats == null)
            {
               param1.bigDB.loadRange("helmetStats","costIndex",null,0,int.MAX_VALUE,300,this.helmetStatsLoaded);
            }
            else
            {
               this.helmetStatsLoaded(this.dbItems_sharedObject.data.hStats,true);
            }
            if(this.dbItems_sharedObject.data.shirtStats == null)
            {
               param1.bigDB.loadRange("shirtStats","costIndex",null,0,int.MAX_VALUE,300,this.shirtStatsLoaded);
            }
            else
            {
               this.shirtStatsLoaded(this.dbItems_sharedObject.data.shirtStats,true);
            }
            if(this.dbItems_sharedObject.data.legsStats == null)
            {
               param1.bigDB.loadRange("legStats","costIndex",null,0,int.MAX_VALUE,300,this.legsStatsLoaded);
            }
            else
            {
               this.legsStatsLoaded(this.dbItems_sharedObject.data.legsStats,true);
            }
            if(this.dbItems_sharedObject.data.shoeStats == null)
            {
               param1.bigDB.loadRange("shoeStats","costIndex",null,0,int.MAX_VALUE,300,this.shoeStatsLoaded);
            }
            else
            {
               this.shoeStatsLoaded(this.dbItems_sharedObject.data.shoeStats,true);
            }
            if(this.dbItems_sharedObject.data.accStats == null)
            {
               param1.bigDB.loadRange("accStats","costIndex",null,0,int.MAX_VALUE,20,this.accStatsLoaded);
            }
            else
            {
               this.accStatsLoaded(this.dbItems_sharedObject.data.accStats,true);
            }
            if(this.dbItems_sharedObject.data.itemStats == null)
            {
               param1.bigDB.loadRange("itemData","costIndex",null,0,int.MAX_VALUE,300,this.itemStatsLoaded);
            }
            else
            {
               this.itemStatsLoaded(this.dbItems_sharedObject.data.itemStats,true);
            }
            if(this.dbItems_sharedObject.data.petHelmetStats == null)
            {
               param1.bigDB.loadRange("petHelmets","costIndex",null,0,int.MAX_VALUE,300,this.petHelmetStatsLoaded);
            }
            else
            {
               this.petHelmetStatsLoaded(this.dbItems_sharedObject.data.petHelmetStats,true);
            }
            if(this.dbItems_sharedObject.data.itemDescs == null)
            {
               param1.bigDB.loadRange("itemDescs","descIndex",null,null,null,700,this.itemDescsLoaded);
            }
            else
            {
               this.itemDescsLoaded(this.dbItems_sharedObject.data.itemDescs,true);
            }
            if(this.dbItems_sharedObject.data.fishStats == null)
            {
               param1.bigDB.loadRange("fishTable","timeIndex",null,null,null,100,this.fishStatsLoaded);
            }
            else
            {
               this.fishStatsLoaded(this.dbItems_sharedObject.data.fishStats,true);
            }
            param1.bigDB.loadRange("basePetData","costIndex",null,0,int.MAX_VALUE,300,this.petStatsLoaded);
            if(this.dbItems_sharedObject.data.enemyStats == null)
            {
               param1.bigDB.loadRange("enemyStats","worthIndex",null,int.MAX_VALUE,0,50,this.enemyStatsLoaded);
            }
            else
            {
               this.enemyStatsLoaded(this.dbItems_sharedObject.data.enemyStats,true);
            }
         }
      }
      
      public function onClick(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         var tempConnectParams:Object = null;
         var urlPrefix:String = null;
         var urlLoader:URLLoader = null;
         var tempGuild:String = null;
         var urlPrefix2:String = null;
         var urlRequest:URLRequest = null;
         var urlVariables:URLVariables = null;
         var urlPrefix3:String = null;
         var tempURL:URLRequest = null;
         var tempConnectParams2:Object = null;
         var tempCurrentServer:String = null;
         var _enemy:Enemy = null;
         var _enemy2:Enemy = null;
         var n_setTicketCost:Function = function(param1:flash.display.MovieClip):void
         {
            var _loc2_:String = param1.currentLabel;
            param1.gotoAndStop(_loc2_ == "no save" ? "save" : "no save");
            if(param1.currentLabel == "save")
            {
               pvMenu.guildMembersOnly_mc.alpha = pvMenu.serverPass_txt.alpha = 0.5;
               pvMenu.guildMembersOnly_mc.mouseEnabled = pvMenu.serverPass_txt.mouseEnabled = false;
            }
            else
            {
               pvMenu.guildMembersOnly_mc.alpha = pvMenu.serverPass_txt.alpha = 1;
               pvMenu.guildMembersOnly_mc.mouseEnabled = pvMenu.serverPass_txt.mouseEnabled = true;
            }
         };
         this.idleCounter = 0;
         if(this.tutorial != null && this.tutorial.parent != null && e.target is flash.display.DisplayObject && this.tutorial.contains(e.target as flash.display.DisplayObject))
         {
            this.dismissTutorial();
            return;
         }
         if(this.deadMenu != null && this.deadMenu.parent != null && e.target.name != "revive_btn")
         {
            return;
         }
         switch(e.target.name)
         {
            case "signIn_btn":
               if(this.mMenu.valid_txt.text.toLowerCase().indexOf("ban") == -1)
               {
                  this.signInCheck(GameMain.isMobile);
               }
               break;
            case "facebookSignIn_btn":
               this.signInCheck(true,"facebook");
               break;
            case "signUp_btn":
               this.mMenu.visible = false;
               this.createCreateMenu();
               this.createTransition();
               if(this.playingURL_string == "y8.com" && Boolean(this.y8_api.idnet))
               {
                  this.y8_api.idnet.toggleInterface("registration");
               }
               break;
            case "register_btn":
               if(this.playingURL_string == "kongregate")
               {
                  Kongregate.showRegisterWindow(this);
               }
               else if(this.playingURL_string == "miniplay.com")
               {
                  MiniPlay.lechuck.user.login();
               }
               break;
            case "nonSteam_btn":
               this.playingURL_string = "noShare";
               e.target.visible = false;
               break;
            case "fullScreen_btn":
               try
               {
                  stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
               }
               catch(_fullError:Error)
               {
                  createAlert("The website you are on does not support full screen games");
               }
               break;
            case "version_btn":
               e.target.mouseEnabled = false;
               this.createUpdateMenu();
               break;
            case "closeUpdates_btn":
               if(this.mMenu != null && this.mMenu.parent != null)
               {
                  this.mMenu.version_btn.mouseEnabled = true;
               }
               this.updateMenu.mouseChildren = this.updateMenu.mouseEnabled = false;
               TweenMax.to(this.updateMenu,0.5,{
                  "alpha":0,
                  "scaleX":0.1,
                  "scaleY":0.1,
                  "ease":Back.easeIn,
                  "onComplete":CommonCalls.removeObject,
                  "onCompleteParams":[this.updateMenu]
               });
               break;
            case "x_btn":
               GameMenu.removeFocusMenu();
               stage.focus = null;
               break;
            case "credits_btn":
               this.createTransition();
               this.mMenu.gotoAndStop("credits");
               break;
            case "forgotPass_btn":
               this.mMenu.gotoAndStop("forgot password");
               break;
            case "rechooseServer_btn":
               this.createMMenu("servers",false);
               break;
            case "sendPass_btn":
               PlayerIO.quickConnect.simpleRecoverPassword("hho-ygpra4ftumusohpifpdug",this.mMenu.recoverEmail_txt.text,this.passwordSent,this.passwordSentError);
               break;
            case "passChange_btn":
               tempConnectParams = new Object();
               tempConnectParams.changepassword = true;
               tempConnectParams.username = this.mMenu.usernameChange_txt.text;
               tempConnectParams.password = this.mMenu.oldPassChange_txt.text;
               tempConnectParams.newpassword = this.mMenu.newPassChange_txt.text;
               PlayerIO.authenticate(stage,"hho-ygpra4ftumusohpifpdug","simpleconnection",tempConnectParams,null,null,this.passChangeAttempt);
               break;
            case "emailChange_btn":
               if(this.mMenu.emailChange_txt.text.indexOf("@") > -1)
               {
                  tempConnectParams2 = new Object();
                  tempConnectParams2.changeemail = true;
                  tempConnectParams2.username = this.mMenu.emailUsernameChange_txt.text;
                  tempConnectParams2.password = this.mMenu.emailPassword_txt.text;
                  tempConnectParams2.newemail = this.mMenu.emailChange_txt.text;
                  PlayerIO.authenticate(stage,"hho-ygpra4ftumusohpifpdug","simpleconnection",tempConnectParams2,null,null,this.emailChangeAttempt);
               }
               else
               {
                  this.mMenu.emailVerify_txt.text = "Invalid email address.";
               }
               break;
            case "rememberMe_mc":
               flash.display.MovieClip(e.target).gotoAndStop(flash.display.MovieClip(e.target).currentFrame == 1 ? 2 : 1);
               break;
            case "back_btn":
               if(this.hasMainEnterFrameListener == false)
               {
                  this.createTransition();
                  this.gotoMainMenuFrame(1);
                  this.mMenu.loadingCircle_mc.visible = false;
               }
               else
               {
                  removeChild(this.mMenu);
               }
               break;
            case "back2_btn":
               this.updatePVMenu();
               break;
            case "vendors_btn":
               break;
            case "viewMembers_btn":
               if(StarlingGameMenu.menu_array.indexOf(this.guildMemberMenu) > -1)
               {
                  StarlingGameMenu.focusMenu(this.guildMemberMenu,true);
               }
               this.createGuildMemberMenu(this.guildMenu.guildName_txt.text);
               break;
            case "acceptTrade_btn":
               if(this.itemMenu != null && this.itemMenu.parent != null)
               {
                  this.itemMenu.touchable = false;
               }
               StarlingGameMenu.removeAllMenus(false,Vector.<StarlingGameMenu>([this.pmMenu]));
               this.len = this.p_array.length;
               this.i = 0;
               while(this.i < this.len)
               {
                  if(this.p_array[this.i].name == e.target.parent.traderName)
                  {
                     this.theConnection.send("acceptT",e.target.parent.traderName);
                     this.createTradeMenu(this.p_array[this.i]);
                     removeChild(e.target.parent);
                     break;
                  }
                  ++this.i;
               }
               break;
            case "declineTrade_btn":
               this.theConnection.send("declineT",e.target.parent.traderName,false);
               removeChild(e.target.parent);
               break;
            case "createGuild_btn":
               if(this.player.money >= 200000)
               {
                  this.guildMenu.gotoAndStop(3);
                  this.guildMenu.guildDesc_txt.text = "";
               }
               else
               {
                  this.createAlert("you do not have enough money to create a guild");
               }
               break;
            case "createGuild2_btn":
               if(this.guildMenu.guildName_txt.text.search(this.validSpaceString) != -1 || this.guildMenu.guildName_txt.text.length == 0)
               {
                  this.guildMenu.reason_txt.text = "invalid guild name";
               }
               else if(this.guildMenu.guildDesc_txt.text.length == 0)
               {
                  this.guildMenu.reason_txt.text = "must enter a description for your guild";
               }
               else
               {
                  this.theClient.bigDB.load("guildsData",this.guildMenu.guildName_txt.text,this.guildNameCheckLoaded);
               }
               break;
            case "myGuild_btn":
               this.len = this.guildMenu.list_mc.numChildren;
               this.i = 0;
               while(this.i < this.len)
               {
                  if(flash.display.MovieClip(this.guildMenu.list_mc.getChildAt(this.i)).name_txt.text == this.player.guild)
                  {
                     this.guildMenu.selectGuild(this.player.guild,this.player,this.theClient.connectUserId,flash.display.MovieClip(this.guildMenu.list_mc.getChildAt(this.i)));
                     break;
                  }
                  ++this.i;
               }
               break;
            case "leaveGuild_btn":
               if(CommonCalls.returnObject(GuildMenu.guilds_array,this.player.guild).leader != this.player.name)
               {
                  this.createConfirmMenu("Are you sure you want to leave your current guild: \'" + this.player.guild + "\'","leave guild");
               }
               else
               {
                  this.createConfirmMenu("You are the leader of " + this.player.guild + ", leaving will delete the guild.  Are you sure you want to leave?","leave guild");
               }
               break;
            case "join_btn":
               if(CommonCalls.returnObject(GuildMenu.guilds_array,this.guildMenu.guildName_txt.text).pendingMembers_array.length < 40)
               {
                  if(this.player.guild != "")
                  {
                     this.createAlert("You  must leave your current guild first");
                  }
                  else if(this.player.lev >= CommonCalls.returnObject(GuildMenu.guilds_array,this.guildMenu.guildName_txt.text).levelReq)
                  {
                     this.createAlert("Your request to join " + this.guildMenu.guildName_txt.text + " has been sent",true);
                     this.guildMenu.miscAlert_txt.text = "awaiting approval to join";
                     this.guildMenu.join_btn.visible = false;
                     this.theConnection.send("joinGuild",this.guildMenu.guildName_txt.text);
                     CommonCalls.returnObject(GuildMenu.guilds_array,this.guildMenu.guildName_txt.text).pendingMembers_array.push(this.player.name);
                  }
                  else
                  {
                     this.createAlert("You do not meet the minimum level requirement " + CommonCalls.returnObject(GuildMenu.guilds_array,this.guildMenu.guildName_txt.text).levelReq + " to join");
                  }
               }
               else
               {
                  this.createAlert("Cannot join: too many pending members");
               }
               break;
            case "updateLevels_btn":
               e.target.visible = false;
               this.theConnection.send("updateGLevels");
               this.createAlert("Guild levels scheduled for update",true);
               break;
            case "editGuild_btn":
               this.guildMenu.gotoAndStop("edit guild");
               this.guildMenu.guildName_txt.text = CommonCalls.returnObject(GuildMenu.guilds_array,this.player.guild).name;
               this.guildMenu.guildLevelReq_txt.text = CommonCalls.returnObject(GuildMenu.guilds_array,this.player.guild).levelReq;
               this.guildMenu.guildDesc_txt.text = CommonCalls.returnObject(GuildMenu.guilds_array,this.player.guild).desc;
               this.guildMenu.guildLevelReq_txt.restrict = "0-9";
               break;
            case "pendingMembers_btn":
               if(StarlingGameMenu.menu_array.indexOf(this.guildMemberMenu) == -1)
               {
                  this.createGuildMemberMenu(this.guildMenu.guildName_txt.text,"pending members");
               }
               else
               {
                  StarlingGameMenu.focusMenu(this.guildMemberMenu,true);
               }
               break;
            case "saveGuild_btn":
               this.theConnection.send("editGuildDesc",this.guildMenu.guildDesc_txt.text,uint(this.guildMenu.guildLevelReq_txt.text));
               CommonCalls.returnObject(GuildMenu.guilds_array,this.player.guild).levelReq = uint(this.guildMenu.guildLevelReq_txt.text);
               this.guildMenu.gotoAndStop(1);
               this.guildMenu.updateMe(this.player.guild);
               this.theClient.bigDB.loadRange("guildsData","killsIndex",[],int.MAX_VALUE,0,1000,this.guildMenu.guildsLoaded);
               break;
            case "guildBack_btn":
               this.guildMenu.gotoAndStop(1);
               this.guildMenu.updateMe(this.player.guild);
               this.theClient.bigDB.loadRange("guildsData","killsIndex",[],int.MAX_VALUE,0,1000,this.guildMenu.guildsLoaded);
               break;
            case "revive_btn":
               if(e.target.parent.alpha == 1)
               {
                  this.player.y = 0;
                  this.player.rotation = 0;
                  this.theConnection.send("reviveP");
                  this.player.health = this.player.totalHealth;
                  this.player.MP = this.player.totalMP;
                  removeChild(this.deadMenu);
                  this.player.bodyAnimator.shadow_image.visible = true;
                  this.c_mc.gotoAndStop(Stats.levelStats[this.c_mc.currentFrame].closestHeal);
                  this.i = 1;
                  while(this.i < 9)
                  {
                     if(Stats.levelStats[this.c_mc.currentFrame]["portal" + String(this.i) + "Lead"] > 0)
                     {
                        this.changeLevel(this.c_mc.currentFrame,"portal" + this.i);
                        break;
                     }
                     ++this.i;
                  }
               }
               break;
            case "nextTutorial_btn":
               this.dismissTutorial();
               break;
            case "skip_btn":
               this.dismissTutorial();
               break;
            case "facebookInvite_btn":
               ExternalInterface.call("inviteFriends");
               break;
            case "ignorePM_btn":
               if(FriendMenu.enemies_array.length < this.maxFriends)
               {
                  this.findDBNamePrefix(e.target.parent.chatWith,function(param1:String):void
                  {
                     addUserByString(param1 + e.target.parent.chatWith,FriendMenu.ENEMIES);
                     if(GameMenu.menu_array.indexOf(friendMenu) > -1 && friendMenu.title_txt.text == FriendMenu.ENEMIES.toUpperCase())
                     {
                        friendMenu.updateMe(theClient,FriendMenu.ENEMIES,true,player.guild);
                     }
                  });
                  GameMenu.removeFocusMenu();
                  stage.focus = null;
               }
               else
               {
                  this.createAlert("your enemy list is full");
               }
               break;
            case "getTickets_btn":
               if(isMobile == false)
               {
                  e.target.transform.colorTransform = normal_colorTransform;
                  switch(this.playingURL_string)
                  {
                     case "facebook.com":
                        this.pvMenu.gotoFacebookPurchase();
                        break;
                     case "kongregate.com":
                        this.pvMenu.gotoKongregatePurchase();
                        break;
                     case "steampowered.com":
                        if(this.player.lev >= 200)
                        {
                           if(this.country != "Philippines")
                           {
                              this.pvMenu.gotoSteamPurchase();
                           }
                           else
                           {
                              this.createAlert("You are not permitted to buy tickets through Steam.");
                           }
                        }
                        else
                        {
                           this.createAlert("You must be level 200 or higher to purchase tickets.");
                        }
                        break;
                     case "playerio.com":
                        this.pvMenu.gotoPlayerIOPurchase();
                        break;
                     default:
                        if(Steam.onSteam)
                        {
                           if(this.player.lev >= 200)
                           {
                              if(this.country != "Philippines")
                              {
                                 this.pvMenu.gotoSteamPurchase();
                              }
                              else
                              {
                                 this.createAlert("You are not permitted to buy tickets through Steam.");
                              }
                           }
                           else
                           {
                              this.createAlert("You must be level 200 or higher to purchase tickets.");
                           }
                        }
                        else
                        {
                           this.pvMenu.gotoPurchase();
                        }
                  }
               }
               else if(this.country != "Philippines")
               {
                  if(isIOS == false)
                  {
                     this.pvMenu.gotoGooglePlayPurchase();
                  }
                  else
                  {
                     this.pvMenu.gotoIOSPurchase();
                  }
               }
               else
               {
                  this.createAlert("You are not permitted to buy tickets.");
               }
               break;
            case "buy3000_btn":
               this.itemLoad.itemKey = "3000gamemoney";
               this.theClient.payVault.buy([this.itemLoad],true,this.boughtPVMoney,this.boughtPVError);
               break;
            case "buyItems_btn":
               this.itemLoad.itemKey = "moreitems";
               this.theClient.payVault.buy([this.itemLoad],true,this.boughtPVItems,this.boughtPVError);
               break;
            case "buyItemsMore_btn":
               this.itemLoad.itemKey = "moremoreitems";
               this.theClient.payVault.buy([this.itemLoad],true,this.boughtPVItems,this.boughtPVError);
               break;
            case "buyFriends_btn":
               this.itemLoad.itemKey = "morefriends";
               this.theClient.payVault.buy([this.itemLoad],true,this.boughtPVFriends,this.boughtPVError);
               break;
            case "buyFriendsMore_btn":
               this.itemLoad.itemKey = "moremorefriends";
               this.theClient.payVault.buy([this.itemLoad],true,this.boughtPVFriends,this.boughtPVError);
               break;
            case "buyHalo_btn":
               this.itemLoad.itemKey = "halo";
               this.theClient.payVault.buy([this.itemLoad],true,this.boughtPVHalo,this.boughtPVError);
               break;
            case "changeHair_btn":
               this.pvMenu.gotoBuyHair(CommonCalls.returnObject(this.pvItems_array,"basichair").PriceCoins,CommonCalls.returnObject(this.pvItems_array,"redhair").PriceCoins);
               break;
            case "accessories_btn":
               this.pvMenu.gotoAccessories(this.pvItems_array);
               break;
            case "buy20000_btn":
               this.itemLoad.itemKey = "20000gamemoney";
               this.theClient.payVault.buy([this.itemLoad],true,this.boughtPV20Money,this.boughtPVError);
               break;
            case "buy100000_btn":
               this.itemLoad.itemKey = "100000gamemoney";
               this.theClient.payVault.buy([this.itemLoad],true,this.boughtPV100Money,this.boughtPVError);
               break;
            case "buy500000_btn":
               this.itemLoad.itemKey = "500000gamemoney";
               this.theClient.payVault.buy([this.itemLoad],true,this.boughtPV500Money,this.boughtPVError);
               break;
            case "buyAbilityPointReset_btn":
               this.itemLoad.itemKey = "abilitypointreset";
               this.theClient.payVault.buy([this.itemLoad],false,this.boughtAbilityPointReset,this.boughtPVError);
               break;
            case "buyPermSell_btn":
               this.itemLoad.itemKey = "permSale";
               this.theClient.payVault.buy([this.itemLoad],true,this.boughtPermSale,this.boughtPVError);
               break;
            case "buyTeleport_btn":
               this.itemLoad.itemKey = "teleport";
               this.theClient.payVault.buy([this.itemLoad],true,this.boughtTeleport,this.boughtPVError);
               break;
            case "buyZombie_btn":
               this.itemLoad.itemKey = "zombie";
               this.theClient.payVault.buy([this.itemLoad],true,this.boughtZombie,this.boughtPVError);
               break;
            case "buyDoubleJump_btn":
               this.itemLoad.itemKey = "doublejump";
               this.theClient.payVault.buy([this.itemLoad],true,this.boughtDoubleJump,this.boughtPVError);
               break;
            case "buyXPSplit_btn":
               this.itemLoad.itemKey = "petxp";
               this.theClient.payVault.buy([this.itemLoad],true,this.boughtPetXPSplit,this.boughtPVError);
               break;
            case "buyMorePets_btn":
               this.itemLoad.itemKey = "morepets";
               this.theClient.payVault.buy([this.itemLoad],true,this.boughtMorePets,this.boughtPVError);
               break;
            case "buyRemoveCompanion_btn":
               if(this.player.getCompanionPet() != null && this.player.pet_array.length < this.maxPets)
               {
                  this.itemLoad.itemKey = "removecompanion";
                  this.theClient.payVault.buy([this.itemLoad],true,this.boughtRemoveCompanion,this.boughtPVError);
               }
               else if(this.player.getCompanionPet() != null && this.player.pet_array.length >= this.maxPets)
               {
                  this.createAlert("You do not have enough room to remove companion pet");
               }
               else
               {
                  this.createAlert("You do not have a companion pet set");
               }
               break;
            case "buyEvolutionCrystal_btn":
               if(this.personItem_array.length < this.maxItems)
               {
                  this.itemLoad.itemKey = "evolutioncrystal";
                  this.theClient.payVault.buy([this.itemLoad],true,this.boughtEvolutionCrystal,this.boughtPVError);
               }
               else
               {
                  this.createAlert("Your inventory is full, cannot buy");
               }
               break;
            case "buyDoubleDrop_btn":
               this.itemLoad.itemKey = "doubledrop";
               this.theClient.payVault.buy([this.itemLoad],true,this.boughtDoubleDrop,this.boughtPVError);
               break;
            case "buyManualControl_btn":
               this.itemLoad.itemKey = "manualcontrol";
               this.theClient.payVault.buy([this.itemLoad],true,this.boughtManualControl,this.boughtPVError);
               break;
            case "buyEnemyControl_btn":
               this.itemLoad.itemKey = "enemycontrol";
               this.theClient.payVault.buy([this.itemLoad],true,this.boughtEnemyControl,this.boughtPVError);
               break;
            case "buyMaxEnergy_btn":
               this.itemLoad.itemKey = "maxenergy";
               this.theClient.payVault.buy([this.itemLoad],true,this.boughtMaxEnergy,this.boughtPVError);
               break;
            case "buyActivePets_btn":
               if(this.maxActivePets + 1 <= this.maxPets)
               {
                  this.itemLoad.itemKey = "pet" + (this.maxActivePets + 1);
                  this.theClient.payVault.buy([this.itemLoad],true,this.boughtActivePets,this.boughtPVError);
               }
               else
               {
                  this.createAlert("You must purchase the \'+4 Pet Capacity\' item before you can purchase this again.");
               }
               break;
            case "buyOrbFocus_btn":
               this.itemLoad.itemKey = "orbfocus";
               this.theClient.payVault.buy([this.itemLoad],true,this.boughtOrbFocus,this.boughtPVError);
               break;
            case "buyBullhorn_btn":
               if(this.personItem_array.length < this.maxItems)
               {
                  this.itemLoad.itemKey = "bullhorn";
                  this.theClient.payVault.buy([this.itemLoad],true,this.boughtBullhorn,this.boughtPVError);
               }
               else
               {
                  this.createAlert("Your inventory is full, cannot buy");
               }
               break;
            case "buyVendor_btn":
               if(this.player.lev >= 200)
               {
                  if(this.personItem_array.length < this.maxItems)
                  {
                     this.itemLoad.itemKey = "itemvendor";
                     this.theClient.payVault.buy([this.itemLoad],true,this.boughtItemVendor,this.boughtPVError);
                  }
                  else
                  {
                     this.createAlert("Your inventory is full, cannot buy");
                  }
               }
               else
               {
                  this.createAlert("You must be level 200 or higher to buy a vendor.");
               }
               break;
            case "buyGreenBall_btn":
               if(this.personItem_array.length < this.maxItems)
               {
                  this.itemLoad.itemKey = "greenspawnball";
                  this.theClient.payVault.buy([this.itemLoad],true,this.boughtGreenBall,this.boughtPVError);
               }
               else
               {
                  this.createAlert("Your inventory is full, cannot buy");
               }
               break;
            case "buyBlueBall_btn":
               if(this.personItem_array.length < this.maxItems)
               {
                  this.itemLoad.itemKey = "bluespawnball";
                  this.theClient.payVault.buy([this.itemLoad],true,this.boughtBlueBall,this.boughtPVError);
               }
               else
               {
                  this.createAlert("Your inventory is full, cannot buy");
               }
               break;
            case "buyYellowBall_btn":
               if(this.personItem_array.length < this.maxItems)
               {
                  this.itemLoad.itemKey = "yellowspawnball";
                  this.theClient.payVault.buy([this.itemLoad],true,this.boughtYellowBall,this.boughtPVError);
               }
               else
               {
                  this.createAlert("Your inventory is full, cannot buy");
               }
               break;
            case "buyOrangeBall_btn":
               if(this.personItem_array.length < this.maxItems)
               {
                  this.itemLoad.itemKey = "orangespawnball";
                  this.theClient.payVault.buy([this.itemLoad],true,this.boughtOrangeBall,this.boughtPVError);
               }
               else
               {
                  this.createAlert("Your inventory is full, cannot buy");
               }
               break;
            case "buyGuildMoney3x_btn":
               this.boughtGuildMoney3x();
               break;
            case "buyFishNet_btn":
               if(this.personItem_array.length < this.maxItems)
               {
                  this.itemLoad.itemKey = "fishnet";
                  this.theClient.payVault.buy([this.itemLoad],true,this.boughtFishNet,this.boughtPVError);
               }
               else
               {
                  this.createAlert("Your inventory is full, cannot buy");
               }
               break;
            case "buyChainsaw_btn":
               if(this.personItem_array.length < this.maxItems)
               {
                  this.itemLoad.itemKey = "chainsaw";
                  this.theClient.payVault.buy([this.itemLoad],true,this.boughtChainsaw,this.boughtPVError);
               }
               else
               {
                  this.createAlert("Your inventory is full, cannot buy");
               }
               break;
            case "buyChickenSuit_btn":
               if(this.personItem_array.length < this.maxItems - 3)
               {
                  this.itemLoad.itemKey = "chickensuit";
                  this.theClient.payVault.buy([this.itemLoad],true,this.boughtChickenSuit,this.boughtPVError);
               }
               else
               {
                  this.createAlert("You do not have enough room in your inventory for this");
               }
               break;
            case "buyFishRadar_btn":
               this.itemLoad.itemKey = "fishradar";
               this.theClient.payVault.buy([this.itemLoad],true,this.boughtFishRadar,this.boughtPVError);
               break;
            case "privateServerSetUp_btn":
               this.pvMenu.gotoAndStop("buy private server");
               this.pvMenu.guildMembersOnly_mc.buttonMode = true;
               this.pvMenu.saveServer_btn.visible = false;
               this.pvMenu.oldPassColon_txt.visible = this.pvMenu.oldServerPass_txt.visible = this.pvMenu.oldPassInfo_txt.visible = false;
               urlPrefix = isIOS ? "https" : "http";
               urlLoader = new URLLoader(new URLRequest(urlPrefix + "://yuriifedorov01-cpu.github.io/hht-client/helmet_heroes_stream/checkOwnsServer.php?player=" + this.player.name + "&" + int(Math.random() * 99999)));
               urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
               urlLoader.addEventListener(flash.events.Event.COMPLETE,function(param1:flash.events.Event):void
               {
                  if(param1.target.data.hasServer == true && GameMenu.menu_array.indexOf(pvMenu) > -1 && pvMenu.currentLabel == "buy private server")
                  {
                     pvMenu.serverName_txt.type = TextFieldType.DYNAMIC;
                     pvMenu.serverName_txt.border = pvMenu.serverName_txt.background = pvMenu.serverName_txt.selectable = false;
                     pvMenu.serverName_txt.text = param1.target.data.serverName;
                     pvMenu.guildMembersOnly_mc.gotoAndStop(param1.target.data.guild != "" ? "save" : "no save");
                     pvMenu.timeSpan_txt.text = "Created: " + param1.target.data.created;
                     pvMenu.buyPrivateServer_btn.visible = false;
                     pvMenu.saveServer_btn.visible = true;
                     pvMenu.oldPassColon_txt.visible = pvMenu.oldServerPass_txt.visible = pvMenu.oldPassInfo_txt.visible = true;
                  }
               });
               break;
            case "buyPetVendor_btn":
               this.itemLoad.itemKey = "petvendor";
               this.theClient.payVault.buy([this.itemLoad],true,this.boughtPetVendor,this.boughtPVError);
               break;
            case "saveServer_btn":
               tempGuild = this.pvMenu.guildMembersOnly_mc.currentLabel == "save" ? this.player.guild : "";
               urlPrefix2 = isIOS ? "https" : "http";
               urlRequest = new URLRequest(urlPrefix2 + "://yuriifedorov01-cpu.github.io/hht-client/helmet_heroes_stream/buyPrivateServer.php");
               urlRequest.method = URLRequestMethod.POST;
               urlVariables = new URLVariables();
               urlVariables.serverName = this.pvMenu.serverName_txt.text;
               urlVariables.guild = tempGuild;
               urlVariables.pass = this.pvMenu.serverPass_txt.text;
               urlVariables.playerName = this.player.name;
               urlVariables.oldPass = this.pvMenu.oldServerPass_txt.text;
               urlRequest.data = urlVariables;
               urlLoader = new URLLoader(urlRequest);
               GameMenu.removeFocusMenu();
               this.createAlert("Your server information has been saved",true);
               break;
            case "buyPrivateServer_btn":
               if(CussFilter.checkString(this.pvMenu.serverName_txt.text) != "")
               {
                  this.createAlert("server name cannot contain profanity");
               }
               else if(this.pvMenu.serverName_txt.text != "")
               {
                  this.itemLoad.itemKey = "privateserver";
                  this.theClient.payVault.buy([this.itemLoad],true,this.boughtPrivateServer,this.boughtPVError);
               }
               else
               {
                  this.createAlert("You must enter a server name");
               }
               break;
            case "buyBaitExtend_btn":
               this.itemLoad.itemKey = "baitextend";
               this.theClient.payVault.buy([this.itemLoad],true,this.boughtBaitExtend,this.boughtPVError);
               break;
            case "buyItemStorage_btn":
               this.itemLoad.itemKey = "bankitems";
               this.theClient.payVault.buy([this.itemLoad],true,this.boughtItemStorage,this.boughtPVError);
               break;
            case "orbFocusInfo_btn":
               this.pvMenu.gotoAndStop("orb focus info");
               break;
            case "iVendorInfo_btn":
               this.pvMenu.gotoAndStop("item vendor info");
               break;
            case "greenBallInfo_btn":
               this.pvMenu.gotoAndStop("green spawn ball info");
               break;
            case "blueBallInfo_btn":
               this.pvMenu.gotoAndStop("blue spawn ball info");
               break;
            case "yellowBallInfo_btn":
               this.pvMenu.gotoAndStop("yellow spawn ball info");
               break;
            case "orangeBallInfo_btn":
               this.pvMenu.gotoAndStop("orange spawn ball info");
               break;
            case "itemStorageInfo_btn":
               this.pvMenu.gotoAndStop("item storage info");
               break;
            case "fishRadarInfo_btn":
               this.pvMenu.gotoAndStop("fish radar info");
               break;
            case "petVendorInfo_btn":
               this.pvMenu.gotoAndStop("pet vendor info");
               break;
            case "redCape_btn":
               if(this.personItem_array.length < this.maxItems)
               {
                  if(this.player.money >= Stats.accStats["red cape"].cost)
                  {
                     this.itemLoad.itemKey = "redcape";
                     this.theClient.payVault.buy([this.itemLoad],true,this.boughtRedCape,this.boughtPVError);
                  }
                  else
                  {
                     this.createAlert("You do not have enough coins to buy this");
                  }
               }
               else
               {
                  this.createAlert("You do not have enough room in your inventory");
               }
               break;
            case "jetpack_btn":
               if(this.personItem_array.length < this.maxItems)
               {
                  if(this.player.money >= Stats.accStats["jet pack"].cost)
                  {
                     this.itemLoad.itemKey = "jetpack";
                     this.theClient.payVault.buy([this.itemLoad],true,this.boughtJetpack,this.boughtPVError);
                  }
                  else
                  {
                     this.createAlert("You do not have enough coins to buy this");
                  }
               }
               else
               {
                  this.createAlert("You do not have enough room in your inventory");
               }
               break;
            case "monkeyTail_btn":
               if(this.personItem_array.length < this.maxItems)
               {
                  if(this.player.money >= Stats.accStats["monkey tail"].cost)
                  {
                     this.itemLoad.itemKey = "monkeytail";
                     this.theClient.payVault.buy([this.itemLoad],true,this.boughtMonkeyTail,this.boughtPVError);
                  }
                  else
                  {
                     this.createAlert("You do not have enough coins to buy this");
                  }
               }
               else
               {
                  this.createAlert("You do not have enough room in your inventory");
               }
               break;
            case "dinoTail_btn":
               if(this.personItem_array.length < this.maxItems)
               {
                  if(this.player.money >= Stats.accStats["dino tail"].cost)
                  {
                     this.itemLoad.itemKey = "dinotail";
                     this.theClient.payVault.buy([this.itemLoad],true,this.boughtDinoTail,this.boughtPVError);
                  }
                  else
                  {
                     this.createAlert("You do not have enough coins to buy this");
                  }
               }
               else
               {
                  this.createAlert("You do not have enough room in your inventory");
               }
               break;
            case "wings_btn":
               if(this.personItem_array.length < this.maxItems)
               {
                  if(this.player.money >= Stats.accStats["wings"].cost)
                  {
                     this.itemLoad.itemKey = "wings";
                     this.theClient.payVault.buy([this.itemLoad],true,this.boughtWings,this.boughtPVError);
                  }
                  else
                  {
                     this.createAlert("You do not have enough coins to buy this");
                  }
               }
               else
               {
                  this.createAlert("You do not have enough room in your inventory");
               }
               break;
            case "pinkBalloon_btn":
               if(this.personItem_array.length < this.maxItems)
               {
                  if(this.player.money >= Stats.accStats["pink balloon"].cost)
                  {
                     this.itemLoad.itemKey = "pinkballoon";
                     this.theClient.payVault.buy([this.itemLoad],true,this.boughtPinkBalloon,this.boughtPVError);
                  }
                  else
                  {
                     this.createAlert("You do not have enough coins to buy this");
                  }
               }
               else
               {
                  this.createAlert("You do not have enough room in your inventory");
               }
               break;
            case "balloonPack_btn":
               if(this.personItem_array.length < this.maxItems)
               {
                  if(this.player.money >= Stats.accStats["balloon pack"].cost)
                  {
                     this.itemLoad.itemKey = "balloonpack";
                     this.theClient.payVault.buy([this.itemLoad],true,this.boughtBalloonPack,this.boughtPVError);
                  }
                  else
                  {
                     this.createAlert("You do not have enough coins to buy this");
                  }
               }
               else
               {
                  this.createAlert("You do not have enough room in your inventory");
               }
               break;
            case "evilWings_btn":
               if(this.personItem_array.length < this.maxItems)
               {
                  if(this.player.money >= Stats.accStats["evil wings"].cost)
                  {
                     this.itemLoad.itemKey = "evilwings";
                     this.theClient.payVault.buy([this.itemLoad],true,this.boughtEvilWings,this.boughtPVError);
                  }
                  else
                  {
                     this.createAlert("You do not have enough coins to buy this");
                  }
               }
               else
               {
                  this.createAlert("You do not have enough room in your inventory");
               }
               break;
            case "butterfly_btn":
               if(this.personItem_array.length < this.maxItems)
               {
                  if(this.player.money >= Stats.accStats["butterfly wings"].cost)
                  {
                     this.itemLoad.itemKey = "butterflywings";
                     this.theClient.payVault.buy([this.itemLoad],true,this.boughtButterflyWings,this.boughtPVError);
                  }
                  else
                  {
                     this.createAlert("You do not have enough room in your inventory.");
                  }
               }
               break;
            case "helipack_btn":
               if(this.personItem_array.length < this.maxItems)
               {
                  if(this.player.money >= Stats.accStats["heli pack"].cost)
                  {
                     this.itemLoad.itemKey = "helipack";
                     this.theClient.payVault.buy([this.itemLoad],true,this.boughtHelipack,this.boughtPVError);
                  }
                  else
                  {
                     this.createAlert("You do not have enough room in your inventory.");
                  }
               }
               break;
            case "buySuperRewards_btn":
               this.miscString = "http://api.playerio.com/payvault/superrewards/coinsredirect?gameid=hho-ygpra4ftumusohpifpdug";
               this.miscString += "&connectuserid=" + this.theClient.connectUserId;
               this.miscString += "&connection=public";
               this.redirect_url.url = this.miscString;
               navigateToURL(this.redirect_url,"_blank");
               this.pvMenu.gotoAndStop("redirect superrewards");
               break;
            case "buyTrialPay_btn":
               this.miscString = "http://api.playerio.com/payvault/trialpay/coinsredirect?gameid=hho-ygpra4ftumusohpifpdug&connectuserid=";
               this.miscString += this.theClient.connectUserId + "&connection=public";
               this.redirect_url.url = this.miscString;
               navigateToURL(this.redirect_url,"_blank");
               this.pvMenu.gotoAndStop("redirect trialpay");
               break;
            case "buyPersonaly_btn":
               this.miscString = "http://api.playerio.com/payvault/personaly/coinsredirect?gameid=hho-ygpra4ftumusohpifpdug";
               this.miscString += "&connectuserid=" + this.theClient.connectUserId;
               this.miscString += "&connection=public";
               this.redirect_url.url = this.miscString;
               navigateToURL(this.redirect_url,"_blank");
               this.pvMenu.gotoAndStop("redirect personaly");
               break;
            case "paypalItemStorage_btn":
               navigateToURL(this.paypal_url);
               this.pvMenu.gotoAndStop("redirect");
               break;
            case "buyTickets10_btn":
               this.miscString = "http://api.playerio.com/payvault/paypal/coinsredirect?gameID=hho-ygpra4ftumusohpifpdug";
               this.miscString += "&connectuserid=" + this.theClient.connectUserId;
               this.miscString += "&connection=public";
               this.miscString += "&coinamount=10&currency=" + this.pvMenu.currencyType;
               this.miscString += "&item_name=10 Tickets";
               this.redirect_url.url = this.miscString;
               navigateToURL(this.redirect_url,"_blank");
               this.pvMenu.gotoAndStop("redirect");
               break;
            case "buyTickets50_btn":
               this.miscString = "http://api.playerio.com/payvault/paypal/coinsredirect?gameID=hho-ygpra4ftumusohpifpdug";
               this.miscString += "&connectuserid=" + this.theClient.connectUserId;
               this.miscString += "&connection=public";
               this.miscString += "&coinamount=50&currency=" + this.pvMenu.currencyType;
               this.miscString += "&item_name=50 Tickets";
               this.redirect_url.url = this.miscString;
               navigateToURL(this.redirect_url,"_blank");
               this.pvMenu.gotoAndStop("redirect");
               break;
            case "buyTickets100_btn":
               this.miscString = "http://api.playerio.com/payvault/paypal/coinsredirect?gameID=hho-ygpra4ftumusohpifpdug";
               this.miscString += "&connectuserid=" + this.theClient.connectUserId;
               this.miscString += "&connection=public";
               this.miscString += "&coinamount=100&currency=" + this.pvMenu.currencyType;
               this.miscString += "&item_name=100 Tickets";
               this.redirect_url.url = this.miscString;
               navigateToURL(this.redirect_url,"_blank");
               this.pvMenu.gotoAndStop("redirect");
               break;
            case "buyTickets220_btn":
               this.miscString = "http://api.playerio.com/payvault/paypal/coinsredirect?gameID=hho-ygpra4ftumusohpifpdug";
               this.miscString += "&connectuserid=" + this.theClient.connectUserId;
               this.miscString += "&connection=public";
               this.miscString += "&coinamount=220&currency=" + this.pvMenu.currencyType;
               this.miscString += "&item_name=220 Tickets";
               this.redirect_url.url = this.miscString;
               navigateToURL(this.redirect_url,"_blank");
               this.pvMenu.gotoAndStop("redirect");
               break;
            case "buyTickets450_btn":
               this.miscString = "http://api.playerio.com/payvault/paypal/coinsredirect?gameID=hho-ygpra4ftumusohpifpdug";
               this.miscString += "&connectuserid=" + this.theClient.connectUserId;
               this.miscString += "&connection=public";
               this.miscString += "&coinamount=450&currency=" + this.pvMenu.currencyType;
               this.miscString += "&item_name=450 Tickets";
               this.redirect_url.url = this.miscString;
               navigateToURL(this.redirect_url,"_blank");
               this.pvMenu.gotoAndStop("redirect");
               break;
            case "buyTickets1300_btn":
               this.miscString = "http://api.playerio.com/payvault/paypal/coinsredirect?gameID=hho-ygpra4ftumusohpifpdug";
               this.miscString += "&connectuserid=" + this.theClient.connectUserId;
               this.miscString += "&connection=public";
               this.miscString += "&coinamount=1300&currency=" + this.pvMenu.currencyType;
               this.miscString += "&item_name=1300 Tickets";
               this.redirect_url.url = this.miscString;
               navigateToURL(this.redirect_url,"_blank");
               this.pvMenu.gotoAndStop("redirect");
               break;
            case "buyTickets2800_btn":
               this.miscString = "http://api.playerio.com/payvault/paypal/coinsredirect?gameID=hho-ygpra4ftumusohpifpdug";
               this.miscString += "&connectuserid=" + this.theClient.connectUserId;
               this.miscString += "&connection=public";
               this.miscString += "&coinamount=2800&currency=" + this.pvMenu.currencyType;
               this.miscString += "&item_name=2800 Tickets";
               this.redirect_url.url = this.miscString;
               navigateToURL(this.redirect_url,"_blank");
               this.pvMenu.gotoAndStop("redirect");
               break;
            case "buyTickets6000_btn":
               this.miscString = "http://api.playerio.com/payvault/paypal/coinsredirect?gameID=hho-ygpra4ftumusohpifpdug";
               this.miscString += "&connectuserid=" + this.theClient.connectUserId;
               this.miscString += "&connection=public";
               this.miscString += "&coinamount=6000&currency=" + this.pvMenu.currencyType;
               this.miscString += "&item_name=6000 Tickets";
               this.redirect_url.url = this.miscString;
               navigateToURL(this.redirect_url,"_blank");
               this.pvMenu.gotoAndStop("redirect");
               break;
            case "buyFacebook10_btn":
               this.pvMenu.buyFromFacebook(10,this.theClient);
               break;
            case "buyFacebook50_btn":
               this.pvMenu.buyFromFacebook(50,this.theClient);
               break;
            case "buyFacebook100_btn":
               this.pvMenu.buyFromFacebook(100,this.theClient);
               break;
            case "buyFacebook220_btn":
               this.pvMenu.buyFromFacebook(220,this.theClient);
               break;
            case "buyFacebook450_btn":
               this.pvMenu.buyFromFacebook(450,this.theClient);
               break;
            case "buyFacebook1300_btn":
               this.pvMenu.buyFromFacebook(1300,this.theClient);
               break;
            case "buyFacebook2800_btn":
               this.pvMenu.buyFromFacebook(2800,this.theClient);
               break;
            case "buyFacebook6000_btn":
               this.pvMenu.buyFromFacebook(6000,this.theClient);
               break;
            case "buyKongregate10_btn":
               this.pvMenu.buyFromKongregate(11,this);
               break;
            case "buyKongregate50_btn":
               this.pvMenu.buyFromKongregate(50,this);
               break;
            case "buyKongregate100_btn":
               this.pvMenu.buyFromKongregate(100,this);
               break;
            case "buyKongregate220_btn":
               this.pvMenu.buyFromKongregate(220,this);
               break;
            case "buyKongregate450_btn":
               this.pvMenu.buyFromKongregate(450,this);
               break;
            case "buyKongregate1300_btn":
               this.pvMenu.buyFromKongregate(1300,this);
               break;
            case "buyKongregate2800_btn":
               this.pvMenu.buyFromKongregate(2800,this);
               break;
            case "buyKongregate6000_btn":
               this.pvMenu.buyFromKongregate(6000,this);
               break;
            case "buySteam10_btn":
               this.pvMenu.buyFromSteam(10,this);
               break;
            case "buySteam50_btn":
               this.pvMenu.buyFromSteam(50,this);
               break;
            case "buySteam100_btn":
               this.pvMenu.buyFromSteam(100,this);
               break;
            case "buySteam220_btn":
               this.pvMenu.buyFromSteam(220,this);
               break;
            case "buySteam450_btn":
               this.pvMenu.buyFromSteam(450,this);
               break;
            case "buySteam1300_btn":
               this.pvMenu.buyFromSteam(1300,this);
               break;
            case "buySteam2800_btn":
               this.pvMenu.buyFromSteam(2800,this);
               break;
            case "buySteam6000_btn":
               this.pvMenu.buyFromSteam(6000,this);
               break;
            case "buyPlayerIO10_btn":
               this.pvMenu.buyFromPlayerIO(10,this);
               break;
            case "buyPlayerIO50_btn":
               this.pvMenu.buyFromPlayerIO(50,this);
               break;
            case "buyPlayerIO100_btn":
               this.pvMenu.buyFromPlayerIO(100,this);
               break;
            case "buyPlayerIO220_btn":
               this.pvMenu.buyFromPlayerIO(220,this);
               break;
            case "buyPlayerIO450_btn":
               this.pvMenu.buyFromSteam(450,this);
               break;
            case "buyPlayerIO1300_btn":
               this.pvMenu.buyFromPlayerIO(1300,this);
               break;
            case "buyPlayerIO2800_btn":
               this.pvMenu.buyFromPlayerIO(2800,this);
               break;
            case "buyPlayerIO6000_btn":
               this.pvMenu.buyFromPlayerIO(6000,this);
               break;
            case "buyGPlay10_btn":
               this.pvMenu.buyFromGooglePlay(10);
               break;
            case "buyGPlay50_btn":
               this.pvMenu.buyFromGooglePlay(50);
               break;
            case "buyGPlay100_btn":
               this.pvMenu.buyFromGooglePlay(100);
               break;
            case "buyGPlay220_btn":
               this.pvMenu.buyFromGooglePlay(220);
               break;
            case "buyGPlay450_btn":
               this.pvMenu.buyFromGooglePlay(450);
               break;
            case "buyGPlay1300_btn":
               this.pvMenu.buyFromGooglePlay(1300);
               break;
            case "buyGPlay2800_btn":
               this.pvMenu.buyFromGooglePlay(2800);
               break;
            case "buyGPlay6000_btn":
               this.pvMenu.buyFromGooglePlay(6000);
               break;
            case "buyIOS10_btn":
               this.pvMenu.buyFromIOS(10);
               break;
            case "buyIOS50_btn":
               this.pvMenu.buyFromIOS(50);
               break;
            case "buyIOS100_btn":
               this.pvMenu.buyFromIOS(100);
               break;
            case "buyIOS220_btn":
               this.pvMenu.buyFromIOS(220);
               break;
            case "buyIOS450_btn":
               this.pvMenu.buyFromIOS(450);
               break;
            case "buyIOS1300_btn":
               this.pvMenu.buyFromIOS(1300);
               break;
            case "buyIOS2800_btn":
               this.pvMenu.buyFromIOS(2800);
               break;
            case "buyIOS6000_btn":
               this.pvMenu.buyFromIOS(6000);
               break;
            case "sponsor_btn":
               navigateToURL(new URLRequest("http://www.helmetgames.com"));
               break;
            case "closeDebug_btn":
               this.debugCommand("removeDebugMenu");
               break;
            case "shout_btn":
               this.theConnection.send("shout",this.bullhornMenu.colorPicker.selectedColor,CussFilter.checkAndSubstitute(this.bullhornMenu.shout_txt.text));
               GameMenu.removeFocusMenu();
               this.arrayStringRemove(this.personItem_array,"bullhorn");
               break;
            case "skip_btn":
               if(e.target.alpha == 1)
               {
                  SoundMixer.stopAll();
                  try
                  {
                     flash.display.MovieClip(this.cutscene_loader.contentLoaderInfo.content).gotoAndPlay(flash.display.MovieClip(this.cutscene_loader.contentLoaderInfo.content).totalFrames - 1);
                  }
                  catch(_cutError:Error)
                  {
                     theClient.errorLog.writeError("error in skip button","cutscene_loader.contentLoaderInfo.content null: " + (cutscene_loader.contentLoaderInfo.content == null),_cutError.getStackTrace(),null);
                  }
               }
               break;
            case "guildMembersOnly_mc":
               flash.display.MovieClip(e.target).gotoAndStop(flash.display.MovieClip(e.target).currentLabel == "no save" ? "save" : "no save");
               break;
            case "serverPassConfirm_btn":
               e.target.visible = false;
               urlPrefix3 = isIOS ? "https" : "http";
               tempURL = new URLRequest(urlPrefix3 + "://yuriifedorov01-cpu.github.io/hht-client/helmet_heroes_stream/validate_server_pass.php?pass=" + this.mMenu.serverPass_txt.text + "&server=" + this.mMenu.serverName_txt.text);
               urlLoader = new URLLoader(tempURL);
               urlLoader.addEventListener(flash.events.Event.COMPLETE,this.passCheckLoaded);
               break;
            case "guildsAtoC_btn":
               this.guildMenu.gotoAndStop(1);
               this.guildMenu.updateMe(this.player.guild);
               this.theClient.bigDB.loadRange("guildsData","nameIndex",[],"a","d",1000,this.guildMenu.guildsLoaded);
               break;
            case "guildsDtoH_btn":
               this.guildMenu.gotoAndStop(1);
               this.guildMenu.updateMe(this.player.guild);
               this.theClient.bigDB.loadRange("guildsData","nameIndex",[],"d","i",1000,this.guildMenu.guildsLoaded);
               break;
            case "guildsItoL_btn":
               this.guildMenu.gotoAndStop(1);
               this.guildMenu.updateMe(this.player.guild);
               this.theClient.bigDB.loadRange("guildsData","nameIndex",[],"l","m",1000,this.guildMenu.guildsLoaded);
               break;
            case "guildsMtoS_btn":
               this.guildMenu.gotoAndStop(1);
               this.guildMenu.updateMe(this.player.guild);
               this.theClient.bigDB.loadRange("guildsData","nameIndex",[],"m","t",1000,this.guildMenu.guildsLoaded);
               break;
            case "guildsStoZ_btn":
               this.guildMenu.gotoAndStop(1);
               this.guildMenu.updateMe(this.player.guild);
               this.theClient.bigDB.loadRange("guildsData","nameIndex",[],"t","zzzzzz",1000,this.guildMenu.guildsLoaded);
               break;
            case "guildsNonAlpha_btn":
               this.guildMenu.gotoAndStop(1);
               this.guildMenu.updateMe(this.player.guild);
               this.theClient.bigDB.loadRange("guildsData","nameIndex",[],"","a",1000,this.guildMenu.guildsLoaded);
               break;
            case "guildsTopLevels_btn":
               this.guildMenu.gotoAndStop(1);
               this.guildMenu.updateMe(this.player.guild);
               this.theClient.bigDB.loadRange("guildsData","killsIndex",[],int.MAX_VALUE,0,300,this.guildMenu.guildsLoaded);
               break;
            case "guildsTopKills_btn":
               this.guildMenu.gotoAndStop(1);
               this.guildMenu.updateMe(this.player.guild);
               this.theClient.bigDB.loadRange("guildsData","killsIndex",[],int.MAX_VALUE,0,300,this.guildMenu.guildsLoaded);
               break;
            case "guildSearch_btn":
               this.theClient.bigDB.loadRange("guildsData","nameIndex",[],this.guildMenu.search_txt.text,this.guildMenu.search_txt.text,1,this.guildMenu.guildsLoaded);
               this.guildMenu.gotoAndStop(1);
               this.guildMenu.updateMe(this.player.guild);
         }
         if(e.target is BuyHairButton)
         {
            this.pvMenu.buyHair(SimpleButton(e.target),this.player,this,this.player.tickets);
         }
         if(e.target is ServerPanel && this.player.health > 0)
         {
            this.starlingStage.controls.touchable = true;
            if((ServerPanel(e.target).icon_mc.guild == "" || ServerPanel(e.target).icon_mc.guild == this.player.guild) && ServerPanel(e.target).icon_mc.currentLabel == "lock")
            {
               this.mMenu.gotoAndStop("server password");
               this.mMenu.serverName_txt.text = ServerPanel(e.target).name_txt.text;
            }
            else
            {
               tempCurrentServer = this.serverName;
               this.serverName = ServerPanel(e.target).name_txt.text;
               if(this.hasMainEnterFrameListener == false)
               {
                  this.gotoMainMenuFrame(1);
               }
               else
               {
                  ServerPanel(e.target).icon_mc.guild == "" || ServerPanel(e.target).icon_mc.guild == this.player.guild;
                  if(ServerPanel(e.target).icon_mc.guild == "" || ServerPanel(e.target).icon_mc.guild == undefined || ServerPanel(e.target).icon_mc.guild == this.player.guild)
                  {
                     this.i = 0;
                     while(this.i < 9)
                     {
                        if(Stats.levelStats[this.c_mc.currentFrame]["portal" + (this.i + 1) + "Lead"] > 0)
                        {
                           ++this.counter;
                           this.changeLevel(this.c_mc.currentFrame,"portal" + (this.i + 1),false);
                           this.len2 = PetOrb.petOrb_array.length;
                           this.j = this.len2 - 1;
                           while(this.j >= 0)
                           {
                              if(PetOrb(PetOrb.petOrb_array[this.j]).creator.isPlayer == false)
                              {
                                 PetOrb.petOrb_array[this.j].removeFromParent(true);
                                 PetOrb.petOrb_array.removeAt(this.j);
                              }
                              --this.j;
                           }
                           break;
                        }
                        ++this.i;
                     }
                     removeChild(this.mMenu);
                  }
                  else
                  {
                     this.serverName = tempCurrentServer;
                     this.createAlert("cannot join, must be guild: " + ServerPanel(e.target).icon_mc.guild);
                  }
               }
               try
               {
                  this.save_sharedObject.flush();
               }
               catch(_error:Error)
               {
               }
            }
         }
         else if(e.target is ServerPanel && this.player.health <= 0)
         {
            this.createAlert("cannot change server while dead");
         }
         if(e.target is GuildListItem)
         {
            this.guildMenu.selectGuild(flash.display.MovieClip(e.target).name_txt.text,this.player,this.theClient.connectUserId,flash.display.MovieClip(e.target));
         }
         if(e.target is SimpleButton)
         {
            SoundManager.playSound(SoundLibrary.click_sound);
         }
         if(e.target.parent != null && e.target.parent.parent != null && e.target.parent.parent is RightClickMenu)
         {
            switch(RightClickButton(e.target.parent).read_txt.text)
            {
               case "add friend":
                  if(FriendMenu.friends_array.length < this.maxFriends)
                  {
                     this.findDBNamePrefix(RightClickMenu(e.target.parent.parent).params.personName,function(param1:String):void
                     {
                        addUserByString(param1 + RightClickMenu(e.target.parent.parent).params.personName,FriendMenu.FRIENDS);
                     });
                  }
                  else
                  {
                     this.createAlert("cannot add, your friends list is full");
                  }
                  break;
               case "trade":
                  this.theConnection.send("giTRequest",RightClickMenu(e.target.parent.parent).params.personName);
                  this.createAlert("Trade request has been sent to " + RightClickMenu(e.target.parent.parent).params.personName,true);
                  break;
               case "report":
                  navigateToURL(new URLRequest("https://helmet-heroes.com/forum/viewforum.php?f=10"));
                  break;
               case "heropedia":
                  if(this.enemyList_array.indexOf(RightClickMenu(e.target.parent.parent).params.enemyType) > -1)
                  {
                     this.createHeroMenu();
                     this.heroMenu.showEStats(RightClickMenu(e.target.parent.parent).params.enemyType);
                  }
                  else
                  {
                     this.createAlert("enemy info unknown");
                  }
                  break;
               case "control me":
                  if(this.player.isControllingPet)
                  {
                     this.player.togglePetControl();
                  }
                  for each(_enemy in this.e_array)
                  {
                     if(_enemy.controlling_person == this.player)
                     {
                        _enemy.noControlMe();
                     }
                     else if(_enemy.name == RightClickMenu(e.target.parent.parent).params.enemyName)
                     {
                        _enemy.controlMe(this.player);
                        stage.focus = null;
                     }
                  }
                  this.createAlert("press the Z key to exit enemy control",true);
                  break;
               case "control pet":
                  if(this.player.isControllingEnemy)
                  {
                     for each(_enemy2 in this.e_array)
                     {
                        if(_enemy2.controlling_person == this.player)
                        {
                           _enemy2.noControlMe();
                           break;
                        }
                     }
                  }
                  if(this.player.activePets.length > 0)
                  {
                     this.player.togglePetControl();
                     stage.focus = null;
                  }
            }
            removeChild(this.rcMenu);
         }
      }
      
      private function passChangeAttempt(param1:PlayerIOError) : void
      {
         var _loc2_:String = null;
         if(this.mMenu != null && this.mMenu.parent != null)
         {
            _loc2_ = param1.message.substr(param1.message.indexOf(":") + 2);
            this.mMenu.emailVerify_txt.text = _loc2_;
         }
      }
      
      private function emailChangeAttempt(param1:PlayerIOError) : void
      {
         var _loc2_:String = null;
         if(this.mMenu != null && this.mMenu.parent != null)
         {
            _loc2_ = param1.message.substr(param1.message.indexOf(":") + 2);
            this.mMenu.emailVerify_txt.text = _loc2_;
         }
      }
      
      private function onMOver(param1:MouseEvent) : void
      {
         switch(param1.target.name)
         {
            case "createGuild_btn":
               this.createInfoMenu("It costs $200,000 to create a guild.  Money will be deducted when guild is successfully created.");
               break;
            case "populationMap_btn":
               this.createInfoMenu("Shows the population of each area on this server based on circle size.");
               break;
            case "levelReqInfo_btn":
               this.createInfoMenu("Sets the minimum level requirement for players to request entry to your guild.");
               break;
            case "buyMoneyTeleport_btn":
               this.createInfoMenu("Allows you to teleport to any area on the map whenever you want.");
               break;
            case "contributeInfo_btn":
               this.createInfoMenu("This is the total of all members contribution points.  Guild contribution points are gained from helping other members level, partaking in GVG, etc.  Guilds with higher points may suggest that they work together and have a stronger community.","big");
               break;
            case "defineButtons_btn":
               this.createInfoMenu("Allows you to customize your buttons associated with your controller.");
               break;
            case "updateLevels_btn":
               this.createInfoMenu("Recalculates the total combined levels of all members in your guild, updating your total guild levels.");
               break;
            case "buy3000_btn":
               this.createInfoMenu("Gives your character $3,000 of in-game money.");
               break;
            case "buy20000_btn":
               this.createInfoMenu("Gives your character $20,000 of in-game money.");
               break;
            case "buy100000_btn":
               this.createInfoMenu("Gives your character $100,000 of in-game money.");
               break;
            case "buy500000_btn":
               this.createInfoMenu("Gives your character $500,000 of in-game money.");
               break;
            case "buyItems_btn":
               this.createInfoMenu("Gives you the capability of holding 10 additional items in your inventory.");
               break;
            case "buyItemsMore_btn":
               this.createInfoMenu("Gives you the capability of holding 10 additional items in your inventory.");
               break;
            case "buyFriends_btn":
               this.createInfoMenu("Give you the capability to store an additional 10 friends and enemies.");
               break;
            case "buyFriendsMore_btn":
               this.createInfoMenu("Give you the capability to store an additional 10 friends and enemies.");
               break;
            case "buyHalo_btn":
               this.createInfoMenu("This gives your player a cool halo above their head and you will only lose 15% money when you die.");
               break;
            case "buyRedHair_btn":
               this.createInfoMenu("Gives your player some awesome spiked red hair.");
               break;
            case "buyAbilityPointReset_btn":
               this.createInfoMenu("Resets all of your characters stats and skills back to their original and gives your points back.");
               break;
            case "buyPermSell_btn":
               this.createInfoMenu("Enables you to re-sale items to shops for 60% instead of the default 35%.");
               break;
            case "buyTeleport_btn":
               this.createInfoMenu("Allows you to instantly teleport to any area on the map without walking there.");
               break;
            case "buyZombie_btn":
               this.createInfoMenu("Gives your character a zombie head and zombie colored skin. You will still retain your current hair.");
               break;
            case "buyDoubleJump_btn":
               this.createInfoMenu("Allows your player to double jump.  This means your player can jump twice in a row before landing.");
               break;
            case "buyXPSplit_btn":
               this.createInfoMenu("Allows you to split your XP to 10% or 70% to ANY pets you own or will ever own.");
               break;
            case "buyMorePets_btn":
               this.createInfoMenu("Allows you to hold an additional 4 pets.");
               break;
            case "buyRemoveCompanion_btn":
               this.createInfoMenu("Un-links your companion pet from being your companion without releasing them.");
               break;
            case "buyEvolutionCrystal_btn":
               this.createInfoMenu("Allows you to evolve your pet up at any level.  This item cannot be traded or dropped.");
               break;
            case "buyDoubleDrop_btn":
               this.createInfoMenu("Doubles your chance of receiving drops from enemies.  Fireflies fly around your character.");
               break;
            case "buyManualControl_btn":
               this.createInfoMenu("Allows you to control your pet using the arrow or WASD keys and spacebar to attack.");
               break;
            case "buyOrbFocus_btn":
               this.createInfoMenu("Gives your pet orbs special white rings and points gained from pet orbs are more oriented towards your class.");
               break;
            case "buyBullhorn_btn":
               this.createInfoMenu("Enables you to shout.  A shout can be seen by every player currently playing in every area of the game in a special color and in extra large text.  You can choose the color of your text so that it will stick out and grab players attention.  One shout can be given per bullhorn.","big");
               break;
            case "buyVendor_btn":
               this.createInfoMenu("Gives you an 8 slot item booth to sell your items and tickets at the cost of your choosing.  It can be seen on all servers.","big");
               break;
            case "buyGreenBall_btn":
               this.createInfoMenu("When used it will spawn green bouncers, green walkers, and purple goo.");
               break;
            case "buyBlueBall_btn":
               this.createInfoMenu("When used it will spawn mushroom balls, bouncing mushroom, and yellow puff monsters.");
               break;
            case "buyYellowBall_btn":
               this.createInfoMenu("When used it will spawn plant monster, pumpkin creeper, penguin, great frog, and sasquatches.");
               break;
            case "buyOrangeBall_btn":
               this.createInfoMenu("When used it will spawn brick monster, block bot, night stalker, bouncing mushroom, leafling, aipster, and drill bot.");
               break;
            case "buyGuildMoney3x_btn":
               if(this.player.guild != "")
               {
                  this.createInfoMenu("This is a guild based item that is bought for your guild.  This will make it so you and all members of \"" + this.player.guild + "\" receive triple the amount of money for all coins they pick up.  Buying this will also give you 50,000 guild contribution points as well as a small money icon next to your guild in the guilds list.","big");
               }
               else
               {
                  this.createInfoMenu("This gives you and everyone in your guild triple the amount of money drops from enemies.");
               }
               break;
            case "buyFishNet_btn":
               this.createInfoMenu("Enables you to catch fish quickly just by swinging the net.  This net has a 5% chance of breaking each time it is swung.  In other words, this net does not last forever, but makes catching fish much easier.  Cannot be traded.","big");
               break;
            case "buyChainsaw_btn":
               this.createInfoMenu("Gives you 10x the chopping power against trees.  It has a 2% chance of breaking each time it is swung.  NOTE: Required level is 70 to equip it.");
               break;
            case "buyChickenSuit_btn":
               this.createInfoMenu("Gives you a cool chicken suit in your inventory to wear.  You can flap through the air by hitting the down key when in the air.");
               break;
            case "buyBaitExtend_btn":
               this.createInfoMenu("Doubles the radius of your fish bait, allowing you to attract fish easier.");
               break;
            case "buyItemStorage_btn":
               this.createInfoMenu("Allows you to store 13 items in your ATM bank.  You can deposit and withdraw as you need.");
               break;
            case "buyFishRadar_btn":
               this.createInfoMenu("Enables you to use the map menu to hunt down the last seen location of shiny fish.");
               break;
            case "privateServerSetUp_btn":
               this.createInfoMenu("You can create your own private server that you and all your friends have to yourselves.");
               break;
            case "buyPetVendor_btn":
               this.createInfoMenu("Enables you to put one pet up for adoption in the Pet Adoption District enabling you to easily find a buyer for your pet.");
               break;
            case "buyEnemyControl_btn":
               this.createInfoMenu("Enables you to manually control an enemy with the arrow keys after right clicking them.");
               break;
            case "buyMaxEnergy_btn":
               this.createInfoMenu("Temporarly sets all of your energy levels (including charge) to their max.");
               break;
            case "buyActivePets_btn":
               this.createInfoMenu("Allows you to have an additional pet active, raising your current limit from " + this.maxActivePets + " to " + (this.maxActivePets + 1) + ".  Note, all pets XP split must be set to the same thing or it will default to 50%..","big");
               break;
            case "ignorePM_btn":
               this.createInfoMenu("Adds this player to your enemy list so their PMs will be ignored.");
               break;
            case "enemiesTab_btn":
               this.createInfoMenu("Adding enemies allows you to block private messsages from these users.");
               break;
            case "redCape_btn":
               this.createInfoMenu("Enables you to glide through the air by holding the up key." + "\nDefense: " + Stats.accStats["red cape"].defense + "\nRequired level: " + Stats.accStats["red cape"].reqLev);
               break;
            case "jetpack_btn":
               this.createInfoMenu("Enables you to fly vertically by holding the up key." + "\nDefense: " + Stats.accStats["jet pack"].defense + "\nRequired level: " + Stats.accStats["jet pack"].reqLev);
               break;
            case "monkeyTail_btn":
               this.createInfoMenu("Enables you to make funny fart noises with the K key." + "\nDefense: " + Stats.accStats["monkey tail"].defense + "\nRequired level: " + Stats.accStats["monkey tail"].reqLev);
               break;
            case "dinoTail_btn":
               this.createInfoMenu("Boosts your power." + "\nDefense: " + Stats.accStats["dino tail"].defense + "\nPower: " + Stats.accStats["dino tail"].power + "\nRequired level: " + Stats.accStats["dino tail"].reqLev);
               break;
            case "wings_btn":
               this.createInfoMenu("Enables you to flap your wings with the up key." + "\nDefense: " + Stats.accStats["wings"].defense + "\nRequired level: " + Stats.accStats["wings"].reqLev);
               break;
            case "pinkBalloon_btn":
               this.createInfoMenu("Gives a slight flotation, reducing gravity by 10%." + "\nDefense: " + Stats.accStats["pink balloon"].defense + "\nRequired level: " + Stats.accStats["pink balloon"].reqLev);
               break;
            case "balloonPack_btn":
               this.createInfoMenu("Gives a slight flotation, reducing gravity by 20%." + "\nDefense: " + Stats.accStats["balloon pack"].defense + "\nRequired level: " + Stats.accStats["balloon pack"].reqLev);
               break;
            case "evilWings_btn":
               this.createInfoMenu("Enables you to flap your wings with the up key." + "\nDefense: " + Stats.accStats["evil wings"].defense + "\nRequired level: " + Stats.accStats["evil wings"].reqLev);
               break;
            case "butterfly_btn":
               this.createInfoMenu("Gives you the ability to fly like a butterfly." + "\nDefense: " + Stats.accStats["butterfly wings"].defense + "\nRequired level: " + Stats.accStats["butterfly wings"].reqLev);
               break;
            case "helipack_btn":
               this.createInfoMenu("Enables you to fly and ascend vertically." + "\nDefense: " + Stats.accStats["heli pack"].defense + "\nRequired level: " + Stats.accStats["heli pack"].reqLev);
         }
         if(param1.target.name == "coin3x_mc")
         {
            this.createInfoMenu("Members of this guild receive 3 times the amount of money drops from enemies.");
         }
         else if(param1.target is EnemyInfoItem && EnemyInfoItem(param1.target).currentFrame == 1)
         {
            EnemyInfoItem(param1.target).gotoAndStop(2);
         }
         Cursor.onMoveCalled(param1.target);
      }
      
      private function tileDefsGot(param1:Message, param2:String) : void
      {
         TileDefRegistry.setPayload(param2);
      }
      
      private function tileDataGot(param1:Message, param2:uint, param3:ByteArray, param4:ByteArray, param5:ByteArray, param6:ByteArray, param7:ByteArray, param8:ByteArray) : void
      {
         this.hasMainEnterFrameListener = true;
         stage.addEventListener(flash.events.Event.ENTER_FRAME,this.onEnter);
         if(this.loadScreen != null)
         {
            this.loadScreen.removeFromParent(true);
         }
         this.focusLevel();
         TileHandler.convertAreaArt(this.c_mc.currentFrame);
         TileHandler.bytesToTileArray(param8,"art",param2);
         TileHandler.bytesToTileArray(param3,"main ground",param2);
         TileHandler.bytesToTileArray(param4,"water",param2);
         TileHandler.bytesToTileArray(param5,"ground 2",param2);
         TileHandler.bytesToTileArray(param6,"ground 3",param2);
         if(stage.quality != StageQuality.LOW.toUpperCase())
         {
            TileHandler.bytesToTileArray(param7,"foreground",param2);
         }
         TileHandler.drawTileArray(TileHandler.tileArt_array,this.c_mc.currentFrame,null,null);
         TileHandler.levelHit_bitmap = TileHandler.drawTileArray(TileHandler.tileMain_array,this.c_mc.currentFrame,TileHandler.levelHit_bitmap,TileHandler.levelHit_bitmapData);
         TileHandler.waterHit_bitmap = TileHandler.drawTileArray(TileHandler.tileWater_array,this.c_mc.currentFrame,TileHandler.waterHit_bitmap,TileHandler.waterHit_bitmapData);
         TileHandler.ground2Hit_bitmap = TileHandler.drawTileArray(TileHandler.tileGround2_array,this.c_mc.currentFrame,TileHandler.ground2Hit_bitmap,TileHandler.ground2Hit_bitmapData);
         TileHandler.ground3Hit_bitmap = TileHandler.drawTileArray(TileHandler.tileGround3_array,this.c_mc.currentFrame,TileHandler.ground3Hit_bitmap,TileHandler.ground3Hit_bitmapData);
         TileHandler.drawTileArray(TileHandler.tileForeground_array,this.c_mc.currentFrame,null,null,true);
         if(Math.random() < 0.7 && this.country == "Philippines" && this.player.lev < 400)
         {
            navigateToURL(new URLRequest("http://p255370.clksite.com/adServe/banners?tid=IF1HELMET_DIRECT&action=r"));
         }
      }
      
      private function singleTileGot(param1:Message, param2:int, param3:int, param4:int) : void
      {
         if(TileHandler.tileMain_array.length > 0)
         {
            TileHandler.createTile(param4,param2,param3,TileHandler.tileMain_array,TileHandler.levelHit_bitmapData,this.c_mc.currentFrame);
         }
      }
      
      private function portalGot(param1:Message, param2:int, param3:int, param4:uint) : void
      {
         var _loc5_:Pet = null;
         var _loc6_:Image = this.createPortal(param4,param2 + 83,param3 + 185);
         if(param4 == this.lastPortal || this.lastPortal == 0)
         {
            if(this.c_mc.currentFrame != 112 && this.c_mc.currentFrame != 113 && this.c_mc.currentFrame != 114)
            {
               this.player.x = param2 + 83;
               this.player.y = param3 + 185;
               this.playerToPortalPositionSet = true;
            }
            else
            {
               this.player.x = 825 + Math.random() * 2000;
               this.player.y = 0 + Math.random() * 800;
               this.playerToPortalPositionSet = true;
            }
         }
         else if(this.playerToPortalPositionSet == false)
         {
            this.player.x = param2 + 83;
            this.player.y = param3 + 185;
         }
         for each(_loc5_ in this.player.activePets)
         {
            if(_loc5_.mode != "m")
            {
               _loc5_.x = this.player.x;
               _loc5_.y = this.player.y;
               if(_loc5_.parent == null)
               {
                  this.pet_array.push(_loc5_);
                  SortDepths.addAt(_loc5_,SortDepths.REGION_4);
               }
            }
         }
         if(this.c_mc.currentFrame == 1 && param4 == 2)
         {
            _loc6_.visible = false;
         }
         this.player.gravityObject.applyGravity(this,1);
         this.theConnection.send("P",int(this.player.gravityObject.hit_rect.x),int(this.player.gravityObject.hit_rect.y));
      }
      
      private function personInfoGot(param1:Message, param2:String, param3:int, param4:int) : void
      {
         var _loc5_:Person = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         for each(_loc5_ in this.p_array)
         {
            if(_loc5_.name == param2)
            {
               _loc6_ = Math.abs(_loc5_.gravityObject.hit_rect.x - _loc5_.x);
               _loc7_ = Math.abs(_loc5_.gravityObject.hit_rect.y - _loc5_.y);
               _loc8_ = _loc5_.x - _loc6_;
               _loc9_ = _loc5_.y - _loc7_;
               if(_loc5_.gravityObject.onGround && CalcDist.getDistNumbers(_loc8_,_loc9_,param3,param4) > 40 || _loc5_.gravityObject.onGround == false && CalcDist.getDistNumbers(_loc8_,_loc9_,param3,param4) > 60)
               {
                  if(CalcDist.getDistNumbers(_loc5_.x,_loc5_.y,param3,param4) > 220)
                  {
                     _loc5_.x = param3;
                     _loc5_.y = param4;
                  }
                  else
                  {
                     _loc5_.x += (param3 - _loc5_.x) * 0.35;
                     _loc5_.y += (param4 - _loc5_.y) * 0.35;
                  }
               }
               break;
            }
         }
      }
      
      private function personKeyDown(param1:Message, param2:String, param3:uint, param4:int = 2147483647, param5:int = 2147483647) : void
      {
         var _loc6_:Person = null;
         for each(_loc6_ in this.p_array)
         {
            if(_loc6_.name == param2)
            {
               if(_loc6_.keyHandler.keyStates.getKeyState(param3) != null && _loc6_.keyHandler.keyStates.getKeyState(param3).isDown)
               {
                  _loc6_.keyHandler.keyRelease(param3);
               }
               switch(param3)
               {
                  case Keyboard.SPACE:
                     _loc6_.projAttackType = "basic";
                     _loc6_.keyHandler.keyPress(Keyboard.SPACE);
                     break;
                  default:
                     _loc6_.keyHandler.keyPress(param3);
               }
               if(Boolean(MoveStat.isAttackingFrame(_loc6_)) && _loc6_.ridingPet != null)
               {
                  _loc6_.bodyAnimator.pet.gotoAndPlayStanding();
               }
               if(param4 != int.MAX_VALUE && param5 != int.MAX_VALUE)
               {
                  this.personInfoGot(null,param2,param4,param5);
               }
               break;
            }
         }
      }
      
      private function personKeyUp(param1:Message, param2:String, param3:uint, param4:int = 2147483647, param5:int = 2147483647) : void
      {
         var _loc6_:Person = null;
         for each(_loc6_ in this.p_array)
         {
            if(_loc6_.name == param2 && _loc6_.name != this.player.name)
            {
               _loc6_.keyHandler.keyRelease(param3);
               if(param4 != int.MAX_VALUE && param5 != int.MAX_VALUE)
               {
                  this.personInfoGot(null,param2,param4,param5);
               }
               break;
            }
         }
      }
      
      private function singlePersonInfoGot(param1:Message, param2:String, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int, param10:int, param11:int, param12:int, param13:int, param14:int, param15:int, param16:int, param17:int, param18:int, param19:int, param20:int, param21:int, param22:int, param23:int, param24:Boolean, param25:String, param26:int, param27:Boolean, param28:Boolean, param29:int, param30:Boolean, param31:int, param32:int, param33:uint, param34:int, param35:String) : void
      {
         var _loc36_:String = param10 > 4 && param10 != 9 ? "female" : "male";
         param10 = param10 > 4 ? int(param10 - 4) : param10;
         var _loc37_:Person = this.createPerson(param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13,param14,param15,param16,param17,param18,0,param19,param20,param21,param22,param23,param32,param31);
         _loc37_.moveDir = param26;
         _loc37_.bodyAnimator.accessoryFrame = param34;
         _loc37_.bodyAnimator.hasHalo = param24;
         _loc37_.shieldMasteryLvl = param29;
         _loc37_.bodyAnimator.gender = _loc36_;
         _loc37_.fishingLvl = param33;
         _loc37_.guild = param25;
         _loc37_.role = param35;
         if(param27)
         {
            _loc37_.keyHandler.keyStates.pressKey(Keyboard.LEFT);
         }
         else
         {
            _loc37_.keyHandler.keyStates.releaseKey(Keyboard.LEFT);
         }
         if(param28)
         {
            _loc37_.keyHandler.keyStates.pressKey(Keyboard.RIGHT);
         }
         else
         {
            _loc37_.keyHandler.keyStates.releaseKey(Keyboard.RIGHT);
         }
         if(param30)
         {
            _loc37_.flyCluster = new FlyCluster(_loc37_,5);
            _loc37_.addChild(_loc37_.flyCluster);
         }
         _loc37_.checkCreateGMIcon();
      }
      
      private function personMiscInfoGot(param1:Message, param2:String, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int, param10:int, param11:int, param12:int, param13:int, param14:int, param15:Boolean, param16:int, param17:Boolean, param18:int) : void
      {
         var _loc19_:Person = null;
         for each(_loc19_ in this.p_array)
         {
            if(_loc19_.name == param2)
            {
               _loc19_.jumpSkillLvl = param3;
               _loc19_.bulletDistanceLvl = param4;
               _loc19_.magicShotsLvl = param5;
               _loc19_.magicDistanceLvl = param6;
               _loc19_.upwardShootLvl = param7;
               _loc19_.piercingArrowLvl = param8;
               _loc19_.thunderAttackLvl = param9;
               _loc19_.grenadeLvl = param10;
               _loc19_.tripleShotLvl = param11;
               _loc19_.lightBeamLvl = param12;
               _loc19_.shotgunLvl = param13;
               _loc19_.arrowRainLvl = param14;
               _loc19_.hasBaitExtend = param15;
               _loc19_.barrageLvl = param16;
               _loc19_.gravityObject.maxJumps = param17 ? 2 : 1;
               _loc19_.dashLvl = param18;
               _loc19_.jumpPower = 20 + _loc19_.jumpSkillLvl * 0.3;
               break;
            }
         }
      }
      
      private function singlePetInfoGot(param1:Message, param2:String, param3:String, param4:String, param5:int, param6:int, param7:int, param8:int, param9:int, param10:int, param11:int, param12:int, param13:int, param14:String, param15:int, param16:int, param17:int, param18:Boolean) : void
      {
         var _loc19_:Pet = null;
         if(CommonCalls.returnObject(this.p_array,param3) != null)
         {
            _loc19_ = this.createPet(true,Person(CommonCalls.returnObject(this.p_array,param3)),param2,param4,param10,param11,param9,param12,param13,0,param14,param7);
            _loc19_.x = param5;
            _loc19_.y = param6;
            _loc19_.lvl = param8;
            _loc19_.gravityObject.counter = param15 + _loc19_.owner.framesLagged();
            _loc19_.shoes_uint = param17;
            if(param18)
            {
               _loc19_.owner.togglePetControl();
            }
            if(_loc19_.mode == "m")
            {
               _loc19_.setActiveMount();
            }
            this.len = PetOrb.petOrb_array.length;
            this.i = 0;
            while(this.i < this.len)
            {
               if(PetOrb.petOrb_array[this.i].petName == param2)
               {
                  PetOrb.petOrb_array[this.i].removeFromParent(true);
                  PetOrb.petOrb_array.removeAt(this.i);
                  break;
               }
               ++this.i;
            }
         }
      }
      
      private function newOrbGot(param1:Message, param2:String, param3:String, param4:int, param5:int, param6:String, param7:Boolean) : void
      {
         this.createPetOrb(param4,param3,param2,param5,param6,param7);
      }
      
      private function personDisconnect(param1:Message, param2:String) : void
      {
         var _loc3_:Pet = null;
         this.len2 = this.p_array.length;
         this.j = 0;
         while(this.j < this.len2)
         {
            if(this.p_array[this.j].name == param2 && this.player.name != this.p_array[this.j].name)
            {
               if(StarlingGameMenu.menu_array.indexOf(this.tradeMenu) > -1 && this.tradeMenu.traderName == this.p_array[this.j].name)
               {
                  this.createAlert(this.p_array[this.j].name + " has exited the trade");
                  this.len5 = GameMenu.menu_array.length;
                  this.w = this.len5 - 1;
                  while(this.w >= 0)
                  {
                     GameMenu.menu_array[this.w].parent.removeChild(GameMenu.menu_array[this.w]);
                     GameMenu.menu_array.removeAt(this.w);
                     --this.w;
                  }
                  this.len5 = StarlingGameMenu.menu_array.length;
                  this.w = this.len5 - 1;
                  while(this.w >= 0)
                  {
                     if(!(StarlingGameMenu.menu_array[this.w] is PMMenu))
                     {
                        StarlingGameMenu.menu_array[this.w].removeFromParent(true);
                        StarlingGameMenu.menu_array.removeAt(this.w);
                     }
                     --this.w;
                  }
               }
               for each(_loc3_ in this.p_array[this.j].activePets)
               {
                  Pet.petRemove(this.pet_array,_loc3_,true);
               }
               if(this.p_array[this.j].powerUpVisuals.unleashing)
               {
                  this.p_array[this.j].powerUpVisuals.stopUnleashing();
               }
               if(this.p_array[this.j].inGuildRage)
               {
                  this.p_array[this.j].inGuildRage = false;
                  if(this.p_array[this.j].rageGlow_image != null)
                  {
                     this.p_array[this.j].rageGlow_image.removeFromParent(true);
                  }
               }
               this.p_array[this.j].removeFromParent(true);
               this.p_array.removeAt(this.j);
               break;
            }
            ++this.j;
         }
      }
      
      private function newEnemyCreatedGot(param1:Message, param2:String, param3:String, param4:int, param5:int, param6:int, param7:int, param8:int, param9:String, param10:String = "") : void
      {
         var _m:Message = param1;
         var _enemyType:String = param2;
         var _enemyName:String = param3;
         var _enemyX:int = param4;
         var _enemyY:int = param5;
         var _enemyMoveCounter:int = param6;
         var _enemyMoveDir:int = param7;
         var _enemyHealth:int = param8;
         var _targetPlayerName:String = param9;
         var _playerControl:String = param10;
         var enemy:Enemy = this.createEnemy(_enemyName,_enemyType,_enemyX,_enemyY,_enemyMoveCounter,_enemyMoveDir,_enemyHealth);
         enemy.x -= enemy.gravityObject.hitOffsetX;
         enemy.y -= enemy.gravityObject.hitOffsetY - enemy.hitTester.hit_rect.height / 2;
         if(_targetPlayerName != "")
         {
            enemy.enemyAI.target = Person(CommonCalls.returnObject(this.p_array,_targetPlayerName));
         }
         if(_playerControl != "")
         {
            setTimeout(function():void
            {
               enemyControlled(null,_enemyName,_playerControl);
            },3000);
         }
      }
      
      private function enemySyncGot(param1:Message, param2:String) : void
      {
         var _loc3_:Enemy = null;
         var _loc4_:Array = param2.length == 0 ? new Array() : param2.split(String.fromCharCode(10));
         var _loc5_:* = int(this.e_array.length - 1);
         while(_loc5_ >= 0)
         {
            _loc3_ = this.e_array[_loc5_];
            if(_loc4_.indexOf(_loc3_.name) == -1)
            {
               _loc3_.hitTester.frozen = false;
               this.main_juggler.remove(_loc3_);
               _loc3_.removeFromParent(true);
               this.e_array.removeAt(_loc5_);
            }
            _loc5_--;
         }
      }
      
      private function enemyInfoGot(param1:Message, param2:String, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:String = "") : void
      {
         var _loc10_:Enemy = null;
         this.len2 = this.e_array.length;
         for each(_loc10_ in this.e_array)
         {
            if(_loc10_.name == param2)
            {
               if(Math.abs(CalcDist.getDistX(param3 - _loc10_.gravityObject.hitOffsetX,_loc10_.x)) > 80)
               {
                  _loc10_.x = param3 - _loc10_.gravityObject.hitOffsetX;
               }
               if(Math.abs(CalcDist.getDistY(param4 - _loc10_.gravityObject.hitOffsetY - _loc10_.hitTester.hit_rect.height / 11,_loc10_.y)) > 80)
               {
                  _loc10_.y = param4 - _loc10_.gravityObject.hitOffsetY - _loc10_.hitTester.hit_rect.height / 11;
               }
               _loc10_.health = param5 > 0 ? param5 : (_loc10_.health > 0 ? 1 : 0);
               if(_loc10_.controlling_person == null)
               {
                  _loc10_.moveDir = param6;
               }
               _loc10_.enemyAI.moveCounter = param7;
               _loc10_.dirChangeTime = param8;
               if(param9 != "")
               {
                  _loc10_.enemyAI.target = Person(CommonCalls.returnObject(this.p_array,param9));
               }
               break;
            }
         }
      }
      
      private function enemyDamagedGot(param1:Message, param2:String, param3:String, param4:Boolean, param5:int, param6:int, param7:int, param8:int, param9:Boolean, param10:Boolean = false) : void
      {
         var _loc21_:int = 0;
         var _loc11_:Enemy = null;
         var _loc12_:Boolean = false;
         var _loc13_:Boolean = false;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         var _loc16_:Point = null;
         var _loc17_:FrameLabel = null;
         var _loc18_:int = 0;
         var _loc19_:Particle = null;
         var _loc20_:Person = Person(CommonCalls.returnObject(this.p_array,param3));
         if(_loc20_ is Person)
         {
            _loc12_ = param4 == false ? Boolean(ItemStat(Stats.wStats[_loc20_.bodyAnimator.weaponString]).isMagic) : Boolean(ItemStat(Stats.wStats[_loc20_.bodyAnimator.weapon2String]).isMagic);
            _loc13_ = param4 == false ? ItemStat(Stats.wStats[_loc20_.bodyAnimator.weaponString]).fireDamage > 0 : ItemStat(Stats.wStats[_loc20_.bodyAnimator.weapon2String]).fireDamage > 0;
            _loc14_ = param4 == false ? ItemStat(Stats.wStats[_loc20_.bodyAnimator.weaponString]).shockDamage > 0 : ItemStat(Stats.wStats[_loc20_.bodyAnimator.weapon2String]).shockDamage > 0;
            _loc15_ = param4 == false ? ItemStat(Stats.wStats[_loc20_.bodyAnimator.weaponString]).iceDamage > 0 : ItemStat(Stats.wStats[_loc20_.bodyAnimator.weapon2String]).iceDamage > 0;
         }
         for each(_loc11_ in this.e_array)
         {
            if(_loc11_.name == param2)
            {
               _loc16_ = new Point(_loc11_.hitTester.hit_rect.x,_loc11_.hitTester.hit_rect.y);
               _loc11_.wasCritHit = param9;
               _loc21_ = _loc11_.health;
               _loc11_.health = param7;
               if(_loc21_ == param7)
               {
                  this.createDamageText(0,_loc11_.x,_loc11_.y - _loc11_.height * (_loc11_.height < 330 ? 1 : 0.6),false,false);
               }
               if(param7 < _loc21_)
               {
                  if(_loc20_ != null && _loc20_.isPlayer && param7 <= 0)
                  {
                     this.player.energyController.enemy += 0.02;
                  }
                  for each(_loc17_ in _loc11_.currentLabels)
                  {
                     if(_loc17_.name == "hit")
                     {
                        _loc11_.gotoAndPlayLabel("hit");
                        break;
                     }
                  }
                  _loc11_.scaleY = 1;
                  _loc11_.scaleX = _loc11_.moveDir;
                  if(_loc11_.gravityObject.counter > 30)
                  {
                     TweenMax.from(_loc11_,0.5,{
                        "scaleY":1.3,
                        "ease":Bounce.easeOut,
                        "overwrite":true
                     });
                     TweenMax.from(_loc11_,0.5,{
                        "scaleX":0.7 * _loc11_.moveDir,
                        "ease":Bounce.easeOut
                     });
                  }
                  if(_loc20_ != null && _loc20_.powerUpVisuals.unleashing && param10 == false)
                  {
                     SlashEffect.create(_loc20_,_loc11_);
                     if(_loc20_.isPlayer)
                     {
                        if(ItemStat(Stats.wStats[_loc20_.bodyAnimator.weaponString]).isRange == false && _loc12_ == false)
                        {
                           if(_loc20_.energyController.fullTotalScale > 0.6)
                           {
                              SlashEffect.createBlack(_loc20_);
                           }
                           this.hitStopCounter = -3;
                        }
                        else if(ItemStat(Stats.wStats[_loc20_.bodyAnimator.weaponString]).sRate == 0)
                        {
                           if(_loc20_.energyController.fullTotalScale > 0.6)
                           {
                              SlashEffect.createBlack(_loc20_,0.1).alpha = 0.4;
                           }
                        }
                     }
                  }
               }
               _loc11_.moveDir = param8;
               _loc11_.enemyAI.moveCounter = 0;
               _loc11_.gravityObject.velX += param5;
               _loc11_.gravityObject.velY += param6;
               _loc11_.health = param7;
               if(_loc12_ == false && param10 == false)
               {
                  SoundManager.playSound(SoundLibrary.hit_sound,_loc11_.x,_loc11_.y,true,this.starlingStage.c_mc);
               }
               if(Boolean(CommonCalls.onScreen(_loc11_.x,_loc11_.y,true,true)) && AreaCreator.background1.parent != null)
               {
                  if(_loc14_ && param7 > 0 && _loc11_.type != "Carnelia" && _loc11_.type != "Kreetus")
                  {
                     FlashShock.flashShockObject(_loc11_);
                     SoundManager.playSound(SoundLibrary.electric_sound,_loc11_.x,_loc11_.y,true,this.starlingStage.c_mc);
                  }
                  if(_loc13_ && param7 > 0 && _loc11_.type != "Carnelia" && _loc11_.type != "Kreetus")
                  {
                     SoundManager.playSound(SoundLibrary.fireball_sound,_loc11_.x,_loc11_.y,true,this.starlingStage.c_mc);
                     _loc11_.hitTester.onFire = true;
                  }
                  if(_loc15_ && param7 > 0 && _loc11_.type != "Carnelia" && _loc11_.type != "Kreetus")
                  {
                     SoundManager.playSound(SoundLibrary.ice_sound,_loc11_.x,_loc11_.y,true,this.starlingStage.c_mc);
                     _loc11_.hitTester.frozen = true;
                  }
                  else if(_loc15_ && param7 <= 0 && Boolean(CommonCalls.onScreen(_loc11_.x,_loc11_.y,false,true)))
                  {
                     _loc18_ = Math.sqrt(Math.sqrt(_loc11_.width * _loc11_.height)) / 2;
                     this.i = 0;
                     while(this.i < _loc18_)
                     {
                        _loc19_ = new Particle("ice chunk");
                        _loc19_.x = _loc11_.hitTester.hit_rect.left + Math.random() * _loc11_.hitTester.hit_rect.width;
                        _loc19_.y = _loc11_.hitTester.hit_rect.top + Math.random() * _loc11_.hitTester.hit_rect.height - 30;
                        _loc19_.gravityObject.velX = Math.random() * 12 * RanOne.ranOne();
                        _loc19_.gravityObject.velY = -(Math.random() * 10);
                        SortDepths.addAt(_loc19_,SortDepths.REGION_2);
                        ++this.i;
                     }
                     SoundManager.playSound(SoundLibrary.glassBreak_sound,_loc11_.x,_loc11_.y,true,this.starlingStage.c_mc);
                  }
               }
               if(Boolean(CommonCalls.onScreen(_loc11_.x,_loc11_.y,true,true)) && param10 == false)
               {
                  if(_loc11_.type != "Carnelia" && _loc11_.type != "Kreetus")
                  {
                     if(stage.quality != StageQuality.LOW.toUpperCase())
                     {
                        if(_loc12_)
                        {
                           this.createMagicEffect(_loc11_.hitTester.hit_rect);
                        }
                        this.createHitAnimation(_loc11_.x + Math.random() * 10 * RanOne.ranOne(),_loc11_.y + Math.random() * 10 * RanOne.ranOne(),param8);
                     }
                  }
                  if(_loc11_ is Carnelia && Math.random() > 0.7)
                  {
                     SoundManager.playSound(Assets.main_assetManager.getSound("Carnelia"),_loc11_.x,_loc11_.y,true,this.starlingStage.c_mc);
                  }
                  else if(_loc11_ is Kreetus && _loc11_.currentLabel == "hit" && Math.random() > 0.7)
                  {
                     SoundManager.playSound(SoundLibrary.roar3_sound,_loc11_.x,_loc11_.y,true,this.starlingStage.c_mc);
                  }
               }
               break;
            }
         }
      }
      
      private function playerDamaged(param1:Message, param2:String, param3:int, param4:String, param5:int, param6:Boolean = false, param7:Boolean = false, param8:int = 0, param9:int = 0, param10:int = 0, param11:Boolean = false, param12:Boolean = false) : void
      {
         var _loc13_:Person = null;
         var _loc14_:* = undefined;
         var _loc15_:Person = Person(CommonCalls.returnObject(this.p_array,param2));
         if(_loc15_ != null)
         {
            this.createDamageText(-param5,_loc15_.x,_loc15_.y - 70,true,param6,param11);
            _loc15_.health = param3;
            if(_loc15_.health <= 0 && param4 == this.player.name)
            {
               this.player.energyController.pvp += 0.04;
            }
            if(param11 == false && param5 > 0)
            {
               if(CommonCalls.onScreen(_loc15_.x,_loc15_.y,false,true))
               {
                  _loc15_.bodyAnimator.tintMe();
               }
               if(param12 == false)
               {
                  SoundManager.playSound(Math.random() > 0.5 ? SoundLibrary.takeHit1_sound : SoundLibrary.takeHit2_sound,_loc15_.x,_loc15_.y,true,this.starlingStage.c_mc);
                  _loc15_.bodyAnimator.gotoAndPlay(_loc15_.ridingPet == null ? "take hit" : "pet take hit");
                  for each(_loc13_ in this.p_array)
                  {
                     if(_loc13_.name == param4)
                     {
                        if(Boolean(Stats.wStats[_loc13_.bodyAnimator.weaponString].isRange) || Boolean(Stats.wStats[_loc13_.bodyAnimator.weaponString].isMagic))
                        {
                           _loc15_.bodyAnimator.gotoAndPlayInt(_loc15_.bodyAnimator.currentFrame + 4);
                        }
                        break;
                     }
                  }
               }
               if(_loc15_.isPlayer)
               {
                  if(_loc15_.bodyAnimator.gender == "male")
                  {
                     _loc14_ = Math.random() > 0.5 ? SoundLibrary.maleGrunt1_sound : SoundLibrary.maleGrunt2_sound;
                     SoundManager.playSound(_loc14_,_loc15_.x,_loc15_.y,true,this.starlingStage.c_mc);
                  }
                  else
                  {
                     SoundManager.playSound(Math.random() > 0.5 ? SoundLibrary.femaleGrunt1_sound : SoundLibrary.femaleGrunt2_sound,_loc15_.x,_loc15_.y,true,this.starlingStage.c_mc);
                  }
               }
            }
            if(param9 > 0)
            {
               FlashShock.flashShockObject(_loc15_);
               SoundManager.playSound(SoundLibrary.electric_sound,_loc15_.x,_loc15_.y,true,this.starlingStage.c_mc);
            }
            if(param8 > 0)
            {
               SoundManager.playSound(SoundLibrary.fireball_sound,_loc15_.x,_loc15_.y,true,this.starlingStage.c_mc);
               _loc15_.hitTester.onFire = true;
            }
            if(CommonCalls.returnObject(this.e_array,param4) != null)
            {
               _loc15_.gravityObject.velX += Enemy(CommonCalls.returnObject(this.e_array,param4)).scaleX * 4;
            }
            else if(CommonCalls.returnObject(this.p_array,param4) != null)
            {
               _loc15_.gravityObject.velX += Person(CommonCalls.returnObject(this.p_array,param4)).scaleX * 4;
            }
            else if(CommonCalls.returnObject(this.pet_array,param4) != null)
            {
               _loc15_.gravityObject.velX += Pet(CommonCalls.returnObject(this.pet_array,param4)).scaleX * 4;
            }
         }
      }
      
      private function petDamageGot(param1:Message, param2:String, param3:int) : void
      {
         var _loc4_:Person = null;
         var _loc5_:Pet = null;
         loop0:
         for each(_loc4_ in this.p_array)
         {
            for each(_loc5_ in _loc4_.pet_array)
            {
               if(_loc5_.name == param2)
               {
                  if(_loc5_.isActive && _loc5_.parent != null)
                  {
                     this.createDamageText(_loc5_.health - param3,_loc5_.x,_loc5_.y,true);
                     SetHue.tintObject(_loc5_);
                  }
                  else if(_loc5_.isActive && _loc5_.mode == "m")
                  {
                     this.createDamageText(_loc5_.health - param3,this.player.x,this.player.y,true);
                  }
                  if(param3 <= 0 && _loc5_.health > 0)
                  {
                     if(_loc4_.isControllingPet)
                     {
                        _loc4_.togglePetControl();
                     }
                     if(_loc4_.name == this.player.name)
                     {
                        this.starlingStage.controls.removePetControlBars(param2);
                        this.createAlertMenu(_loc5_.name + "\'s health is 0","Your pet has been knocked out.",false,_loc5_,false);
                     }
                     if(_loc5_.mode != "m")
                     {
                        Pet.petRemove(this.pet_array,_loc5_,false);
                        _loc5_.alpha = 0.8;
                        _loc5_.isAttacking = false;
                        TweenMax.to(_loc5_,2.5,{
                           "y":_loc5_.y - 800,
                           "overwrite":true,
                           "ease":Linear.easeNone,
                           "onComplete":_loc5_.removeFromParent,
                           "onCompleteParams":[!_loc5_.owner.isPlayer]
                        });
                     }
                     else
                     {
                        _loc4_.bodyAnimator.removeMountedPet();
                     }
                     _loc5_.isActive = false;
                  }
                  _loc5_.health = param3;
                  break loop0;
               }
            }
         }
      }
      
      private function playerEnvDamaged(param1:Message, param2:String, param3:int, param4:int) : void
      {
         var _loc5_:Person = null;
         for each(_loc5_ in this.p_array)
         {
            if(_loc5_.name == param2)
            {
               this.createDamageText(-param4,_loc5_.x,_loc5_.y,true);
               _loc5_.health = param3;
               if(CommonCalls.onScreen(_loc5_.x,_loc5_.y,false,true))
               {
                  _loc5_.bodyAnimator.tintMe();
               }
               _loc5_.gravityObject.velX += _loc5_.scaleX * -1 * 3;
            }
         }
      }
      
      private function newItemCreatedGot(param1:Message, param2:String, param3:int, param4:int, param5:String, param6:int, param7:String = "", param8:Number = 0, param9:Number = -14) : void
      {
         this.createItem(param2,param3,param4,param5,param6,param7,param8,param9);
      }
      
      private function itemInfoGot(param1:Message, param2:String, param3:int, param4:int) : void
      {
         this.len2 = this.item_array.length;
         this.j = 0;
         while(this.j < this.len2)
         {
            if(this.item_array[this.j].name == param2)
            {
               this.item_array[this.j].x = param3;
               this.item_array[this.j].y = param4;
            }
            ++this.j;
         }
      }
      
      private function itemRemovedGot(param1:Message, param2:String, param3:String) : void
      {
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         this.len2 = this.item_array.length;
         this.j = 0;
         while(this.j < this.len2)
         {
            if(this.item_array[this.j].name == param2)
            {
               if(this.player.name == param3)
               {
                  if(this.item_array[this.j].type != "coin")
                  {
                     _loc4_ = "";
                     this.personItem_array.push(_loc4_ + this.item_array[this.j].type);
                     SoundManager.playSound(SoundLibrary.pickup_sound,this.player.x,this.player.y,true,this.starlingStage.c_mc);
                  }
                  else
                  {
                     _loc5_ = this.hasGuildMoney3x == false || this.item_array[this.j].worth == 300 ? 0 : uint(this.item_array[this.j].worth * 2);
                     this.starlingStage.controls.money_txt.scaleX = this.starlingStage.controls.money_txt.scaleY = 1;
                     TweenMax.from(this.starlingStage.controls.money_txt,0.2,{
                        "scaleX":1.2,
                        "scaleY":1.2,
                        "ease":Linear.easeNone
                     });
                     RiseValue.riseTo(this.starlingStage.controls.money_txt,"Money: $",this.player.money,this.player.money + this.item_array[this.j].worth + _loc5_);
                     this.player.money += this.item_array[this.j].worth + _loc5_;
                     SoundManager.playSound(SoundLibrary.coinGet_sound,this.player.x,this.player.y,true,this.starlingStage.c_mc);
                  }
               }
               if(param3 == "")
               {
                  this.item_array[this.j].removeFromParent(true);
                  this.item_array.removeAt(this.j);
               }
               else
               {
                  this.len3 = this.p_array.length;
                  this.d = 0;
                  while(this.d < this.len3)
                  {
                     if(this.p_array[this.d].name == param3)
                     {
                        TweenMax.to(this.item_array[this.j],0.6,{
                           "x":this.p_array[this.d].x,
                           "y":this.p_array[this.d].y,
                           "ease":Back.easeOut,
                           "onComplete":this.item_array[this.j].removeFromParent,
                           "onCompleteParams":[true]
                        });
                        this.item_array.removeAt(this.j);
                        break;
                     }
                     ++this.d;
                  }
               }
               break;
            }
            ++this.j;
         }
      }
      
      private function singleItemInfoGot(param1:Message, param2:String, param3:int, param4:int, param5:String, param6:int) : void
      {
         this.a = 0;
         this.len2 = this.item_array.length;
         this.j = 0;
         while(this.j < this.len2)
         {
            if(this.item_array[this.j].name == param2)
            {
               ++this.a;
            }
            ++this.j;
         }
         if(this.a == 0)
         {
            this.createItem(param2,param3,param4,param5,param6);
         }
      }
      
      private function newChatMessageGot(param1:Message, param2:String, param3:String) : void
      {
         var _loc4_:Person = null;
         var _loc5_:uint = isMobile == false ? 6 : 4;
         if(this.starlingStage.controls.chat_txt.numLines >= _loc5_)
         {
            this.starlingStage.controls.chat_txt.text = this.starlingStage.controls.chat_txt.text.slice(this.starlingStage.controls.chat_txt.text.indexOf("\n") + 1,this.starlingStage.controls.chat_txt.text.length);
         }
         this.starlingStage.controls.chat_txt.text += (this.starlingStage.controls.chat_txt.text.length == 0 ? "" : "\n") + param3 + ": " + param2;
         if(this.player.name == param3)
         {
            this.starlingStage.controls.message_txt.text = "";
         }
         for each(_loc4_ in this.p_array)
         {
            if(_loc4_.name == param3)
            {
               this.createTalkBubble(_loc4_,param2);
               break;
            }
         }
      }
      
      private function newEquipGot(param1:Message, param2:String, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int) : void
      {
         var _loc10_:Person = null;
         this.len2 = this.p_array.length;
         for each(_loc10_ in this.p_array)
         {
            if(_loc10_.name == param2)
            {
               _loc10_.bodyAnimator.shirtFrame = param4;
               _loc10_.bodyAnimator.accessoryFrame = param9;
               _loc10_.bodyAnimator.helmetFrame = param3;
               if(ItemStat(Stats.hStats[_loc10_.bodyAnimator.helmetString]).allowHair)
               {
                  _loc10_.bodyAnimator.hair = _loc10_.bodyAnimator.originalHair;
               }
               _loc10_.bodyAnimator.weapon2Frame = param8;
               _loc10_.bodyAnimator.pantsFrame = param5;
               _loc10_.bodyAnimator.weaponFrame = param6;
               _loc10_.bodyAnimator.shoeFrame = param7;
               _loc10_.bodyAnimator.gotoAndPlay(_loc10_.ridingPet == null ? "standing" : "pet standing");
               if(_loc10_.isPlayer)
               {
                  this.itemMenu.updateMe(this.maxItems,this.personItem_array,this.player,false);
               }
               if(_loc10_.isPlayer && StarlingGameMenu.menu_array.indexOf(this.tradeMenu) > -1)
               {
                  StarlingGameMenu.focusMenu(this.tradeMenu);
                  StarlingGameMenu.removeFocusMenu();
               }
               break;
            }
         }
      }
      
      private function updatePersonXP(param1:Message, param2:String, param3:uint, param4:Boolean = false) : void
      {
         var _m:Message = param1;
         var _pName:String = param2;
         var _xpEarned:uint = param3;
         var _levelUp:Boolean = param4;
         var _person:Person = null;
         var _enemy:Enemy = null;
         for each(_person in this.p_array)
         {
            if(_person.name == _pName)
            {
               if(_levelUp)
               {
                  _person.levelMeUp();
               }
               if(_person.isPlayer)
               {
                  for each(_enemy in this.e_array)
                  {
                     if(_enemy.name == this.lastEnemyNameHit && _xpEarned > 1)
                     {
                        if(this.enemyList_array.indexOf(_enemy.type) == -1)
                        {
                           this.enemyList_array.push(_enemy.type);
                           this.createNewHeroEntry(_enemy.type + " info");
                           this.starlingStage.controls.blinkHeropediaButton = true;
                           this.theClient.bigDB.load("pMiscTable",this.player.name,function(param1:DatabaseObject):void
                           {
                              if(loadedPlayerMiscSuccess)
                              {
                                 param1.enemyList = enemyList_array.toString();
                                 param1.save();
                              }
                           });
                        }
                        break;
                     }
                  }
                  this.createXPText(_xpEarned,_person.x + 70 * _person.scaleX,_person.y - 50);
               }
               _person.currentLevelXP += _xpEarned;
               break;
            }
         }
      }
      
      private function updatePetXP(param1:Message, param2:String, param3:int, param4:Boolean = false, param5:int = 0, param6:int = 0, param7:int = 0, param8:int = 0, param9:int = 0, param10:int = 0) : void
      {
         var tempPet:Pet = null;
         var _m:Message = param1;
         var _petName:String = param2;
         var _xp:int = param3;
         var _levelUp:Boolean = param4;
         var _newLvl:int = param5;
         var _newPower:int = param6;
         var _newDex:int = param7;
         var _newDefense:int = param8;
         var _newHealth:int = param9;
         var _newTotalHealth:int = param10;
         tempPet = null;
         var _person:Person = null;
         var _pet:Pet = null;
         var filterChain:FilterChain = null;
         for each(_person in this.p_array)
         {
            for each(_pet in _person.pet_array)
            {
               if(_pet.name == _petName)
               {
                  tempPet = _pet;
                  break;
               }
            }
         }
         if(tempPet == null)
         {
            return;
         }
         if(this.player.ridingPet == null)
         {
            if(_xp - tempPet.xp > 0)
            {
               this.createXPText(_xp - tempPet.xp,tempPet.x,tempPet.y - 10);
            }
         }
         else if(_xp - tempPet.xp > 0)
         {
            this.createXPText(_xp - tempPet.xp,tempPet.owner.x + 20 * tempPet.owner.scaleX,tempPet.owner.y);
         }
         tempPet.xp = _xp;
         if(_newLvl > 0)
         {
            if(_levelUp && tempPet.owner.isPlayer)
            {
               this.createAlertMenu(tempPet.name + " has hit level " + String(_newLvl) + "!","Health: +" + String(_newTotalHealth - tempPet.totalHealth) + "\n" + "Power: +" + String(_newPower - tempPet.power) + "\n" + "Defense: +" + String(_newDefense - tempPet.defense) + "\n" + "Dexterity: +" + String(_newDex - tempPet.dex),false,tempPet,false);
            }
            if(tempPet.mode != "m")
            {
               if(_levelUp && Boolean(CommonCalls.onScreen(tempPet.x,tempPet.y,false,true)))
               {
                  ShineEffect.shineObjectNoParent(tempPet,17);
                  filterChain = new FilterChain(new GlowFilter(16777215,3,8));
                  tempPet.filter = filterChain;
                  setTimeout(function():void
                  {
                     tempPet.filter = null;
                  },1500);
                  SoundManager.playSound(SoundLibrary.petEvolve_sound,tempPet.x,tempPet.y,true,this.starlingStage.c_mc);
               }
               if(_levelUp)
               {
                  SoundManager.playSound(SoundLibrary.levelUp_sound,tempPet.x,tempPet.y,true,this.starlingStage.c_mc);
               }
               tempPet.lvl = _newLvl;
               tempPet.power = _newPower;
               tempPet.dex = _newDex;
               tempPet.defense = _newDefense;
               tempPet.health = _newHealth;
               tempPet.totalHealth = _newTotalHealth;
            }
            else if(tempPet.owner.ridingPet != null)
            {
               if(_levelUp)
               {
                  SoundManager.playSound(SoundLibrary.levelUp_sound,tempPet.owner.x,tempPet.owner.y,true,this.starlingStage.c_mc);
               }
               tempPet.lvl = _newLvl;
               tempPet.power = _newPower;
               tempPet.dex = _newDex;
               tempPet.defense = _newDefense;
               tempPet.health = _newHealth;
               tempPet.totalHealth = _newTotalHealth;
            }
         }
      }
      
      private function playerLoaded(param1:Message, param2:String, param3:int, param4:uint, param5:int, param6:int, param7:int, param8:int, param9:int, param10:int, param11:int, param12:int, param13:String, param14:int, param15:int, param16:int, param17:int, param18:int, param19:int, param20:int, param21:int, param22:int, param23:int, param24:int, param25:int, param26:Boolean, param27:String, param28:int, param29:int, param30:Boolean, param31:int, param32:String) : void
      {
         var _loc33_:BitmapData = null;
         var _loc34_:Image = null;
         this.player.visible = true;
         this.player.name = param2;
         this.player.power = param3;
         this.player.money = param4;
         this.player.totalHealth = param18;
         this.player.health = param19;
         this.player.bodyAnimator.originalHair = param5;
         this.player.totalMP = param22;
         this.player.MP = param23;
         this.player.magic = param24;
         this.player.bodyAnimator.eyes = param11;
         if(this.mMenu != null && this.mMenu.parent != null)
         {
            this.player.bodyAnimator.hair = param5;
         }
         this.player.bodyAnimator.helmetFrame = param6;
         this.player.bodyAnimator.beard = param28;
         this.player.bodyAnimator.shirtFrame = param7;
         this.player.bodyAnimator.pantsFrame = param8;
         this.player.bodyAnimator.weaponFrame = param9;
         this.player.bodyAnimator.weapon2Frame = param25;
         this.player.bodyAnimator.gender = param10 > 4 && param10 != 9 ? "female" : "male";
         this.player.bodyAnimator.skin = param10 > 4 ? uint(param10 - 4) : uint(param10);
         this.player.bodyAnimator.accessoryFrame = param31;
         this.player.bodyAnimator.shoeFrame = param20;
         this.player.currentLevelXP = param17;
         this.player.lev = param12;
         this.player.abilityPoints = param14;
         this.player.dex = param15;
         this.player.moveSpeed = 7 + this.player.dex / 176;
         this.player.defense = param16;
         this.player.range = param21;
         this.player.artillery = param29;
         this.player.guild = param27;
         this.player.role = param32;
         this.personItem_array = Vector.<String>(param13.split(","));
         if(this.personItem_array.length == 1 && this.personItem_array[0] == "")
         {
            this.personItem_array.length = 0;
         }
         this.theConnection.removeMessageHandler("pLoaded",this.playerLoaded);
         this.player.bodyAnimator.hasHalo = param26;
         if(this.proDataHasLoaded == false)
         {
            this.player.energyController.levelMax = 1;
         }
         this.player.energyController.level = this.player.lev / 1500;
         if(this.mMenu != null && this.mMenu.parent != null)
         {
            this.theConnection.removeMessageHandler("wrongCap",this.wrongCap);
            removeEventListener(FocusEvent.FOCUS_IN,this.onFocused);
            stage.addEventListener(KeyboardEvent.KEY_UP,this.onKUp);
            removeChild(this.mMenu);
            this.createWhite();
            if(this.charCreateMenu != null && this.charCreateMenu.parent != null)
            {
               _loc33_ = new BitmapData(Starling.current.viewPort.width,Starling.current.viewPort.height,false,0);
               _loc34_ = new Image(Texture.fromBitmapData(_loc33_,false));
               this.starlingStage.addChildAt(_loc34_,this.starlingStage.getChildIndex(this.charCreateMenu));
               TweenMax.to(_loc34_,1,{
                  "alpha":0,
                  "delay":5,
                  "onComplete":CommonCalls.removeAndFullyDispose,
                  "onCompleteParams":[_loc34_]
               });
            }
            this.playLevelMusic(this.c_mc.currentFrame);
            if(this.mMenu.rememberMe_mc.currentLabel == "save")
            {
               this.save_sharedObject.data.username = this.player.name;
               this.save_sharedObject.data.userPassword = this.player.password;
               try
               {
                  this.save_sharedObject.flush();
               }
               catch(_error:Error)
               {
               }
            }
            else
            {
               this.save_sharedObject.clear();
            }
            this.player.password = this.mMenu.password_txt.text;
            stage.focus = null;
            this.theClient.bigDB.loadOrCreate("pMiscTable",this.player.name,this.playerMiscLoaded);
            this.theClient.bigDB.loadRange("petData","ownerIndex",[this.player.name],0,0,8,this.personPetsLoaded);
            this.loadPVPurchases();
            this.localConnection = new LocalConnection();
            this.localConnection.allowDomain("*");
            this.localConnection.client = this;
            this.localConnection.connect("_helmetHeroes-" + this.player.name);
            this.starlingStage.controls.setMoreMobileButtons(this.player);
         }
         this.hasGuildMoney3x = param30;
         this.player.checkCreateGMIcon();
         if(stage.quality == StageQuality.LOW.toUpperCase())
         {
            this.player.bodyAnimator.shadow_image.removeFromParent(true);
         }
         if(this.country == "Philippines" && this.player.lev < 150 && isMobile == true)
         {
            this.player.personHackCheck.banKillPlayer(false);
         }
         this.theConnection.send("proxyCheck");
      }
      
      private function itemBought(param1:Message, param2:String, param3:int, param4:Boolean) : void
      {
         this.player.money = param3;
         if(param4)
         {
            SoundManager.playSound(SoundLibrary.itemBought_sound);
            this.personItem_array.push(param2);
            if(this.itemMenu != null)
            {
               this.itemMenu.scaleX = this.itemMenu.scaleY = 1;
               TweenMax.from(this.itemMenu,0.2,{
                  "scaleX":1.1,
                  "scaleY":1.1,
                  "ease":Bounce.easeOut
               });
            }
         }
         else
         {
            this.createAlert("not enough money");
         }
      }
      
      private function itemSold(param1:Message, param2:int) : void
      {
         this.player.money = param2;
      }
      
      private function abilityPointUsed(param1:Message, param2:String, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int, param10:*, param11:int, param12:int, param13:int) : void
      {
         var _loc14_:Person = null;
         for each(_loc14_ in this.p_array)
         {
            if(_loc14_.name == param2)
            {
               _loc14_.totalHealth = param3;
               _loc14_.power = param5;
               _loc14_.dex = param6;
               _loc14_.defense = param7;
               _loc14_.abilityPoints = param8;
               _loc14_.range = param9;
               _loc14_.moveSpeed = 7 + _loc14_.dex / 176;
               _loc14_.totalMP = param10;
               _loc14_.MP = param11;
               _loc14_.magic = param12;
               _loc14_.artillery = param13;
               if(this.player.name == param2 && StarlingGameMenu.menu_array.indexOf(this.cMenu) > -1)
               {
                  this.cMenu.updateMe();
               }
            }
         }
      }
      
      private function getKicked(param1:Message, param2:Boolean, param3:String = "You have been logged in from somewhere else") : *
      {
         this.disconnectReason = param3;
         this.theConnection.disconnect();
      }
      
      private function playerJoined(param1:Message, param2:Number) : void
      {
         this.serverVersion = param2;
         if(Number(this.starlingStage.controls.version_txt.text) != this.serverVersion)
         {
            this.createConnectMenu(2);
            this.theConnection.disconnect();
         }
      }
      
      private function personHealed(param1:Message, param2:String, param3:int, param4:int, param5:Boolean = true) : void
      {
         var _loc6_:Person = null;
         for each(_loc6_ in this.p_array)
         {
            if(_loc6_.name == param2)
            {
               _loc6_.health = param3;
               _loc6_.MP = param4;
               if(param5 && Boolean(CommonCalls.onScreen(_loc6_.x,_loc6_.y,false,true)))
               {
                  SetHue.tintObject(_loc6_,16777215);
               }
               break;
            }
         }
      }
      
      private function playerSaved(param1:Message) : void
      {
         var _m:Message = param1;
         var n_getBGArt:Function = function():void
         {
            AreaCreator.getBGArt(c_mc.currentFrame,function():void
            {
               if(loadScreen != null && loadScreen.parent != null && Boolean(loadScreen.checkDisplayAd()))
               {
                  loadScreen.loadInfo_txt.text += "...ad";
                  setTimeout(function():void
                  {
                     loadScreen.removeAd();
                     joinRoom();
                  },5000);
               }
               else
               {
                  joinRoom();
               }
            });
         };
         this.player.awaitingSave = false;
         this.theConnection.disconnect();
         if(this.loadScreen != null && this.loadScreen.parent != null)
         {
            this.loadScreen.loadInfo_txt.text += "\nloading background";
         }
         n_getBGArt();
      }
      
      private function playerMiscLoaded(param1:DatabaseObject) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:uint = 0;
         if(param1.startedQuests == undefined)
         {
            param1.startedQuests = "";
            param1.completedQuests = "";
            param1.enemyList = "";
            param1.friends = "";
            param1.registeredURL = this.playingURL_string;
            param1.signUpTime = this.today_date.toUTCString();
            param1.save();
         }
         else
         {
            this.loadedPlayerMiscSuccess = true;
            FriendMenu.friends_array = Vector.<String>(param1.friends.split(","));
            if(FriendMenu.friends_array.length == 1 && FriendMenu.friends_array[0] == "")
            {
               FriendMenu.friends_array.length = 0;
            }
            if(param1.block != undefined)
            {
               FriendMenu.enemies_array = Vector.<String>(param1.block.split(","));
               if(FriendMenu.enemies_array.length == 1 && FriendMenu.enemies_array[0] == "")
               {
                  FriendMenu.enemies_array.length = 0;
               }
            }
            this.enemyList_array = Vector.<String>(param1.enemyList.split(","));
            if(this.enemyList_array.length == 1 && this.enemyList_array[0] == "")
            {
               this.enemyList_array.length = 0;
            }
            param1.fishList = param1.fishList == undefined ? "" : param1.fishList;
            this.fishList_array = Vector.<String>(param1.fishList.split(","));
            if(this.fishList_array.length == 1 && this.fishList_array[0] == "")
            {
               this.fishList_array.length = 0;
            }
            _loc2_ = param1.startedQuests.split(",");
            _loc3_ = param1.completedQuests.split(",");
            this.i = 0;
            while(this.i < _loc2_.length)
            {
               this.j = 0;
               while(this.j < Stats.missionList.length)
               {
                  if(_loc2_[this.i] == Stats.missionList[this.j])
                  {
                     Stats.missionStats[Stats.missionList[this.j]].started = true;
                  }
                  ++this.j;
               }
               ++this.i;
            }
            this.i = 0;
            while(this.i < _loc3_.length)
            {
               this.j = 0;
               while(this.j < Stats.missionList.length)
               {
                  if(_loc3_[this.i] == Stats.missionList[this.j])
                  {
                     Stats.missionStats[Stats.missionList[this.j]].completed = true;
                  }
                  ++this.j;
               }
               ++this.i;
            }
            if(param1.maps != undefined)
            {
               for each(_loc4_ in param1.maps)
               {
                  this.unlockedMaps_array.push(_loc4_);
               }
            }
         }
      }
      
      private function chatMessagesLoaded(param1:Array) : void
      {
         var _loc2_:DatabaseObject = null;
         var _loc3_:String = null;
         var _loc6_:int = 0;
         var _loc7_:* = undefined;
         _loc2_ = null;
         _loc3_ = null;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         if(param1 != null)
         {
            for each(_loc2_ in param1)
            {
               if(_loc2_.messages[0] != null)
               {
                  _loc6_ = 0;
                  _loc7_ = FriendMenu.enemies_array;
                  for each(_loc3_ in _loc7_)
                  {
                  }
                  if(OptionMenu.ignorePMs)
                  {
                     _loc4_ = 0;
                     for each(var _loc12_ in FriendMenu.friends_array)
                     {
                        _loc5_ = _loc12_;
                        _loc12_;
                        if(_loc2_.sender != Person.removeNamePrefix(_loc5_))
                        {
                           _loc4_++;
                        }
                     }
                     if(_loc4_ == FriendMenu.friends_array.length)
                     {
                        if(Math.random() <= 0.1)
                        {
                           this.createAlert("reminder: you have non-friend PMs blocked",true);
                        }
                        continue;
                     }
                  }
                  this.checkCreatePMMenu(_loc2_.sender,false);
                  this.len2 = _loc2_.messages.length;
                  this.j = 0;
                  while(this.j < this.len2)
                  {
                     this.pmMenu.addChatMessage(_loc2_.sender,this.player.name,_loc2_.messages[this.j]);
                     ++this.j;
                  }
               }
            }
            if(param1.length > 0)
            {
               this.theClient.bigDB.deleteRange("messageTable","receiverIndex",[this.player.name],null,null);
            }
         }
      }
      
      public function friendInfoLoaded(param1:DatabaseObject) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(param1 == null)
         {
            return;
         }
         if(param1.name == null)
         {
            param1.name = param1.key;
         }
         param1.daysSinceLogin = FriendMenu.timeFromNow(param1.login);
         var _loc4_:Boolean = false;
         for each(var _loc7_ in FriendMenu.friends_array)
         {
            _loc2_ = _loc7_;
            _loc7_;
            if(param1.name == _loc2_)
            {
               _loc4_ = true;
            }
         }
         if(_loc4_)
         {
            this.b = 0;
            this.len = FriendMenu.friendsInfo_array.length;
            _loc3_ = 0;
            while(_loc3_ < this.len)
            {
               if(FriendMenu.friendsInfo_array[_loc3_].key == param1.key && FriendMenu.friendsInfo_array[_loc3_].on != param1.on)
               {
                  ++this.b;
               }
               _loc3_++;
            }
         }
         if(_loc4_)
         {
            this.a = 0;
            this.len = FriendMenu.friendsInfo_array.length;
            _loc3_ = 0;
            while(_loc3_ < this.len)
            {
               if(FriendMenu.friendsInfo_array[_loc3_].key == param1.key)
               {
                  if(param1.on)
                  {
                     if(param1.on == true && this.b > 0)
                     {
                        this.createLogOnMenu(Person.removeNamePrefix(param1.name));
                     }
                  }
                  FriendMenu.friendsInfo_array[_loc3_] = param1;
                  break;
               }
               ++this.a;
               _loc3_++;
            }
         }
         if(this.a == this.len && _loc4_)
         {
            FriendMenu.friendsInfo_array.push(param1);
         }
         if(StarlingGameMenu.menu_array.indexOf(this.friendMenu) > -1)
         {
            this.friendMenu.friendInfoLoaded(param1);
         }
      }
      
      private function guildOnlineLoaded(param1:DatabaseObject) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:* = param1.mArray;
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = String(_loc2_[_loc3_]);
            if(!(_loc4_ == "" || Person.removeNamePrefix(_loc4_) == this.player.name))
            {
               this.theClient.bigDB.load("PlayerObjects",_loc4_,this.guildmateInfoLoaded);
            }
            _loc3_++;
         }
      }
      
      private function guildmateInfoLoaded(param1:DatabaseObject) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:String = param1.key;
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:String = param1.name != null ? Person.removeNamePrefix(String(param1.name)) : Person.removeNamePrefix(_loc2_);
         var _loc4_:Boolean = param1.on == true;
         var _loc5_:Boolean = Boolean(this.guildMembersChecked.hasOwnProperty(_loc2_));
         var _loc6_:Boolean = _loc5_ && this.guildMembersChecked[_loc2_] == true;
         if(_loc5_ && _loc4_ && !_loc6_ && _loc3_ != this.player.name)
         {
            this.createLogOnMenu(_loc3_," (guild) has logged on");
         }
         this.guildMembersChecked[_loc2_] = _loc4_;
      }
      
      private function tradeRequestReceived(param1:Message, param2:String) : void
      {
         if(OptionMenu.ignoreTrades)
         {
            this.theConnection.send("declineT",param2,false);
            if(Math.random() > 0.85)
            {
               this.createAlert("reminder: you have trades disabled in options menu",true);
            }
            return;
         }
         if(StarlingGameMenu.menu_array.indexOf(this.tradeMenu) > -1 == false)
         {
            this.len = this.p_array.length;
            this.i = 0;
            while(this.i < this.len)
            {
               if(this.p_array[this.i].name == param2)
               {
                  this.a = 0;
                  this.len2 = numChildren;
                  this.j = 0;
                  while(this.j < this.len2)
                  {
                     if(getChildAt(this.j) is TradeRequest && TradeRequest(getChildAt(this.j)).traderName == param2)
                     {
                        ++this.a;
                     }
                     ++this.j;
                  }
                  if(this.a == 0)
                  {
                     this.createTradeRequest(this.p_array[this.i]);
                  }
                  break;
               }
               ++this.i;
            }
         }
         else
         {
            this.theConnection.send("declineT",param2,true);
         }
      }
      
      private function tradeAccepted(param1:Message, param2:String) : void
      {
         if(this.itemMenu != null && this.itemMenu.parent != null)
         {
            this.itemMenu.touchable = false;
         }
         StarlingGameMenu.removeAllMenus(false,Vector.<StarlingGameMenu>([this.pmMenu]));
         this.len = this.p_array.length;
         this.i = 0;
         while(this.i < this.len)
         {
            if(this.p_array[this.i].name == param2)
            {
               this.createTradeMenu(this.p_array[this.i]);
               break;
            }
            ++this.i;
         }
      }
      
      private function tradeDeclined(param1:Message, param2:String, param3:Boolean) : void
      {
         this.len = this.p_array.length;
         this.i = 0;
         while(this.i < this.len)
         {
            if(this.p_array[this.i].name == param2)
            {
               if(param3 == false)
               {
                  this.createAlert(param2 + " has declined your trade request");
               }
               else
               {
                  this.createAlert(param2 + " cannot trade, they are already in an active trade");
               }
               break;
            }
            ++this.i;
         }
      }
      
      private function finalTradeConfirmed(param1:Message) : void
      {
         if(StarlingGameMenu.menu_array.indexOf(this.tradeMenu) > -1)
         {
            this.tradeMenu.waiting_txt.text = this.tradeMenu.traderName + " is waiting for your confirm.";
         }
      }
      
      public function newTradeMessage(param1:Message, param2:String, param3:String) : void
      {
         if(StarlingGameMenu.menu_array.indexOf(this.tradeMenu,0) > -1)
         {
            this.tradeMenu.addChatMessage(param2,param3);
         }
      }
      
      public function tradeVerified(param1:Message, param2:String, param3:String, param4:uint, param5:String = "", param6:String = "") : void
      {
         var _loc7_:Pet = null;
         if(param2 != "")
         {
            this.createAlert(param2);
         }
         else if(param3 != "")
         {
            this.player.money = param4;
            this.personItem_array = Vector.<String>(param3.split(","));
            if(this.personItem_array.length == 1 && this.personItem_array[0] == "")
            {
               this.personItem_array.length = 0;
            }
            if(param5 != "" || param6 != "")
            {
               for each(var _loc10_ in this.player.pet_array)
               {
                  _loc7_ = _loc10_;
                  _loc10_;
                  if(_loc7_.isActive)
                  {
                     this.starlingStage.controls.removePetControlBars(_loc7_.name);
                  }
               }
               CommonCalls.emptyArray(this.player.pet_array,false);
               this.i = this.pet_array.length - 1;
               while(this.i >= 0)
               {
                  if(this.pet_array[this.i].owner == this.player)
                  {
                     this.pet_array[this.i].removeFromParent(true);
                     this.pet_array.removeAt(this.i);
                  }
                  --this.i;
               }
               setTimeout(this.theClient.bigDB.loadRange,3000,"petData","ownerIndex",[this.player.name],0,0,8,this.personPetsLoaded);
            }
            if(StarlingGameMenu.menu_array.indexOf(this.tradeMenu) > -1)
            {
               this.tradeMenu.successfullTrade = true;
               this.createAlert("Trade was succesful",true);
               this.tradeMenu.touchable = false;
               StarlingGameMenu.focusMenu(this.tradeMenu);
               StarlingGameMenu.removeFocusMenu();
            }
            setTimeout(this.loadPVPurchases,3000);
         }
      }
      
      public function tradeClosed(param1:Message, param2:String) : void
      {
         this.createAlert(param2 + " has exited the trade");
         if(StarlingGameMenu.menu_array.indexOf(this.tradeMenu) > -1)
         {
            StarlingGameMenu.focusMenu(this.tradeMenu);
            StarlingGameMenu.removeFocusMenu();
         }
      }
      
      private function payvaultItemsLoaded(param1:Array) : void
      {
         var _loc2_:DatabaseObject = null;
         if(param1 != null)
         {
            this.pvItems_array = Vector.<DatabaseObject>(param1);
            for each(var _loc5_ in this.pvItems_array)
            {
               _loc2_ = _loc5_;
               _loc5_;
               _loc2_.name = _loc2_.key;
            }
            if(GameMenu.menu_array.indexOf(this.pvMenu) > -1 && (this.pvMenu.currentLabel == "loading" || this.pvMenu.currentFrame == 1))
            {
               this.pvMenu.gotoAndStop(1);
               if(this.playingURL_string != "minijuegos.com")
               {
                  this.pvMenu.list_mc.money3000_txt.text = CommonCalls.returnObject(this.pvItems_array,"3000gamemoney").PriceCoins;
                  this.pvMenu.list_mc.money20000_txt.text = CommonCalls.returnObject(this.pvItems_array,"20000gamemoney").PriceCoins;
                  this.pvMenu.list_mc.money100000_txt.text = CommonCalls.returnObject(this.pvItems_array,"100000gamemoney").PriceCoins;
                  this.pvMenu.list_mc.money500000_txt.text = CommonCalls.returnObject(this.pvItems_array,"500000gamemoney").PriceCoins;
                  this.pvMenu.list_mc.items_txt.text = CommonCalls.returnObject(this.pvItems_array,"moreitems").PriceCoins;
                  this.pvMenu.list_mc.itemsMore_txt.text = CommonCalls.returnObject(this.pvItems_array,"moremoreitems").PriceCoins;
                  this.pvMenu.list_mc.friends_txt.text = CommonCalls.returnObject(this.pvItems_array,"morefriends").PriceCoins;
                  this.pvMenu.list_mc.halo_txt.text = CommonCalls.returnObject(this.pvItems_array,"halo").PriceCoins;
                  this.pvMenu.list_mc.abilityPointReset_txt.text = CommonCalls.returnObject(this.pvItems_array,"abilitypointreset").PriceCoins;
                  this.pvMenu.list_mc.permSell_txt.text = CommonCalls.returnObject(this.pvItems_array,"permSale").PriceCoins;
                  this.pvMenu.list_mc.teleport_txt.text = CommonCalls.returnObject(this.pvItems_array,"teleport").PriceCoins;
                  this.pvMenu.list_mc.zombie_txt.text = CommonCalls.returnObject(this.pvItems_array,"zombie").PriceCoins;
                  this.pvMenu.list_mc.doubleJump_txt.text = CommonCalls.returnObject(this.pvItems_array,"doublejump").PriceCoins;
                  this.pvMenu.list_mc.xpSplit_txt.text = CommonCalls.returnObject(this.pvItems_array,"petxp").PriceCoins;
                  this.pvMenu.list_mc.morePets_txt.text = CommonCalls.returnObject(this.pvItems_array,"morepets").PriceCoins;
                  this.pvMenu.list_mc.removeCompanion_txt.text = CommonCalls.returnObject(this.pvItems_array,"removecompanion").PriceCoins;
                  this.pvMenu.list_mc.evolutionCrystal_txt.text = CommonCalls.returnObject(this.pvItems_array,"evolutioncrystal").PriceCoins;
                  this.pvMenu.list_mc.doubleDrop_txt.text = CommonCalls.returnObject(this.pvItems_array,"doubledrop").PriceCoins;
                  this.pvMenu.list_mc.manualControl_txt.text = CommonCalls.returnObject(this.pvItems_array,"manualcontrol").PriceCoins;
                  this.pvMenu.list_mc.orbFocus_txt.text = CommonCalls.returnObject(this.pvItems_array,"orbfocus").PriceCoins;
                  this.pvMenu.list_mc.bullhorn_txt.text = CommonCalls.returnObject(this.pvItems_array,"bullhorn").PriceCoins;
                  this.pvMenu.list_mc.vendor_txt.text = CommonCalls.returnObject(this.pvItems_array,"itemvendor").PriceCoins;
                  this.pvMenu.list_mc.greenBall_txt.text = CommonCalls.returnObject(this.pvItems_array,"greenspawnball").PriceCoins;
                  this.pvMenu.list_mc.blueBall_txt.text = CommonCalls.returnObject(this.pvItems_array,"bluespawnball").PriceCoins;
                  this.pvMenu.list_mc.yellowBall_txt.text = CommonCalls.returnObject(this.pvItems_array,"yellowspawnball").PriceCoins;
                  this.pvMenu.list_mc.orangeBall_txt.text = CommonCalls.returnObject(this.pvItems_array,"orangespawnball").PriceCoins;
                  this.pvMenu.list_mc.guildMoney3x_txt.text = CommonCalls.returnObject(this.pvItems_array,"guildmoney3x").PriceCoins;
                  this.pvMenu.list_mc.fishNet_txt.text = CommonCalls.returnObject(this.pvItems_array,"fishnet").PriceCoins;
                  this.pvMenu.list_mc.baitExtend_txt.text = CommonCalls.returnObject(this.pvItems_array,"baitextend").PriceCoins;
                  this.pvMenu.list_mc.itemStorage_txt.text = CommonCalls.returnObject(this.pvItems_array,"bankitems").PriceCoins;
                  this.pvMenu.list_mc.chainsaw_txt.text = CommonCalls.returnObject(this.pvItems_array,"chainsaw").PriceCoins;
                  this.pvMenu.list_mc.chickenSuit_txt.text = CommonCalls.returnObject(this.pvItems_array,"chickensuit").PriceCoins;
                  this.pvMenu.list_mc.privateServer_txt.text = CommonCalls.returnObject(this.pvItems_array,"privateserver").PriceCoins;
                  this.pvMenu.list_mc.friendsMore_txt.text = CommonCalls.returnObject(this.pvItems_array,"moremorefriends").PriceCoins;
                  this.pvMenu.list_mc.fishRadar_txt.text = CommonCalls.returnObject(this.pvItems_array,"fishradar").PriceCoins;
                  this.pvMenu.list_mc.petVendor_txt.text = CommonCalls.returnObject(this.pvItems_array,"petvendor").PriceCoins;
                  this.pvMenu.list_mc.enemyControl_txt.text = CommonCalls.returnObject(this.pvItems_array,"enemycontrol").PriceCoins;
                  this.pvMenu.list_mc.maxEnergy_txt.text = CommonCalls.returnObject(this.pvItems_array,"maxenergy").PriceCoins;
                  this.pvMenu.list_mc.maxActivePets_txt.text = CommonCalls.returnObject(this.pvItems_array,"pet2").PriceCoins;
               }
            }
         }
         this.theConnection.send("fraudCheck");
      }
      
      private function quickError(param1:PlayerIORegistrationError) : void
      {
         §§pop();
      }
      
      private function boughtPVMoney() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.player.money = this.player.money + 3000;
            this.theConnection.send("3000Bought");
            this.pvMenu.gotoAndStop("money bought");
         }
      }
      
      private function boughtPV20Money() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.player.money = this.player.money + 20000;
            this.theConnection.send("20000Bought");
            this.pvMenu.gotoAndStop("money 20 bought");
         }
      }
      
      private function boughtPV100Money() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.player.money = this.player.money + 100000;
            this.theConnection.send("100000Bought");
            this.pvMenu.gotoAndStop("money 100 bought");
         }
      }
      
      private function boughtPV500Money() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.player.money = this.player.money + 500000;
            this.theConnection.send("500000Bought");
            this.pvMenu.gotoAndStop("money 500 bought");
         }
      }
      
      private function boughtPVItems() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("items bought");
         }
      }
      
      private function boughtPVFriends() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("friends bought");
         }
      }
      
      private function boughtPVHalo() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("halo bought");
            this.player.bodyAnimator.hasHalo = true;
            this.theConnection.send("boughtHalo");
         }
      }
      
      public function boughtPVSpecialHair() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("special hair bought");
         }
         this.player.bodyAnimator.originalHair = this.pvMenu.lastHairBought;
         this.player.bodyAnimator.hair = this.pvMenu.lastHairBought;
         this.theConnection.send("boughtSpecialHair",this.pvMenu.lastHairBought);
      }
      
      public function boughtPVBasicHair() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("basic hair bought");
         }
         this.player.bodyAnimator.originalHair = this.pvMenu.lastHairBought;
         this.player.bodyAnimator.hair = this.pvMenu.lastHairBought;
         this.theConnection.send("boughtHairBasic",this.pvMenu.lastHairBought);
      }
      
      private function boughtAbilityPointReset() : void
      {
         this.player.skillPoints = this.player.lev;
         this.theClient.bigDB.load("skillsData",this.player.name,function(param1:DatabaseObject):void
         {
            if(param1.scrollsUsed != undefined)
            {
               player.skillPoints = player.skillPoints + param1.scrollsUsed;
            }
         });
         this.player.jumpSkillLvl = 1;
         this.player.criticalLvl = 1;
         this.player.lootStealLvl = 1;
         this.player.trainingLvl = 1;
         this.player.selfRageLvl = 1;
         this.player.guildRageLvl = 1;
         this.player.avoidabilityLvl = 1;
         this.player.mpRestoreLvl = 1;
         this.player.dashLvl = 1;
         this.player.accelDownLvl = 1;
         this.player.barrageLvl = 1;
         this.player.arrowKnockbackLvl = 1;
         this.player.expertArcherLvl = 1;
         this.player.tripleShotLvl = 1;
         this.player.arrowRainLvl = 1;
         this.player.piercingArrowLvl = 1;
         this.player.downCrushLvl = 1;
         this.player.powerAttackLvl = 1;
         this.player.expertWarriorLvl = 1;
         this.player.chainDistanceLvl = 1;
         this.player.shieldMasteryLvl = 1;
         this.player.multiAttackLvl = 1;
         this.player.meleeKnockbackLvl = 1;
         this.player.spinAttackLvl = 1;
         this.player.magicShotsLvl = 1;
         this.player.expertWizardLvl = 1;
         this.player.lightBeamLvl = 1;
         this.player.magicDistanceLvl = 1;
         this.player.thunderAttackLvl = 1;
         this.player.selfHealLvl = 1;
         this.player.guildHealLvl = 1;
         this.player.jumpGrenadeLvl = 1;
         this.player.energyController.rage = this.player.selfRageLvl * 0.028572;
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.theClient.bigDB.load("PlayerObjects",this.theClient.connectUserId,this.playerInfoLoadedScrolls);
         }
      }
      
      private function boughtPermSale() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("perm resale");
         }
         this.hasResale = true;
         this.theConnection.send("permSaleBought");
      }
      
      public function boughtTeleport(param1:Object = null) : void
      {
         if(param1 == null || Boolean(param1.success))
         {
            if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
            {
               this.pvMenu.gotoAndStop("teleport bought");
            }
            this.hasTeleport = true;
            this.theConnection.send("teleBought");
         }
      }
      
      private function boughtItemStorage(param1:Object = null) : void
      {
         if(param1 == null || Boolean(param1.success))
         {
            if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
            {
               this.pvMenu.gotoAndStop("item storage bought");
            }
            this.hasItemStorage = true;
            this.theConnection.send("itemStorageBought");
         }
      }
      
      private function boughtZombie() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("zombie bought");
         }
         this.theConnection.send("zombBought");
         this.player.bodyAnimator.skin = 5;
      }
      
      private function boughtDoubleJump() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("double jump bought");
         }
         this.player.gravityObject.maxJumps = 2;
      }
      
      private function boughtPetXPSplit() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("pet xp bought");
         }
         this.theConnection.send("petXPBought");
      }
      
      private function boughtMorePets() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("more pets bought");
         }
         this.maxPets = 14;
      }
      
      private function boughtRemoveCompanion() : void
      {
         var _loc1_:Pet = null;
         _loc1_ = null;
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("remove companion bought");
         }
         for each(var _loc4_ in this.player.pet_array)
         {
            _loc1_ = _loc4_;
            _loc4_;
            _loc1_.isCompanion = false;
         }
         this.theConnection.send("removeCompanion");
      }
      
      private function boughtEvolutionCrystal() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("bought evolution crystal");
         }
         this.personItem_array.push("evolution crystal");
         this.theConnection.send("giEvoCrystal");
      }
      
      private function boughtDoubleDrop() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("double drop bought");
         }
         this.player.flyCluster = new FlyCluster(this.player,5);
         this.player.addChild(this.player.flyCluster);
         this.hasDoubleDrop = true;
      }
      
      private function boughtManualControl() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("manual control bought");
            if(isMobile)
            {
               this.pvMenu.petControl_txt.text = "You can now manually control your pet using the arrow or WASD keys.  Long press on your active pet to toggle control between your character and your active pet.  Thank you for your purchase!";
            }
         }
         this.hasManualControl = true;
      }
      
      private function boughtEnemyControl() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("enemy control bought");
            if(isMobile)
            {
               this.pvMenu.enemyControl_txt.text = "You can now manually control enemies!  You can do this by long pressing on an enemy and going to \"control me\".  Thank you for your purchase!";
            }
         }
         this.hasEnemyControl = true;
      }
      
      private function boughtMaxEnergy() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("max energy bought");
         }
         this.player.energyController.charge = 1;
         this.player.energyController.absorbed = 1;
         this.player.energyController.enemy = 1;
         this.player.energyController.pvp = 1;
         this.player.energyController.random = 1;
         this.player.energyController.chop = 1;
         this.player.energyController.fish = 1;
         this.theConnection.send("maxEnergyBought",3000);
         this.createAlert("All of your energy levels are now at their max.",true);
      }
      
      private function boughtActivePets() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("active pets bought");
         }
         ++this.maxActivePets;
      }
      
      private function boughtOrbFocus() : void
      {
         var _loc1_:PetOrb = null;
         _loc1_ = null;
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("orb focus bought");
         }
         this.player.hasOrbFocus = true;
         this.theConnection.send("orbFocusBought");
         for each(var _loc4_ in PetOrb.petOrb_array)
         {
            _loc1_ = _loc4_;
            _loc4_;
            if(_loc1_.creator.isPlayer)
            {
               _loc1_.texture = Assets.items_textureAtlas.getTexture(_loc1_.color_string + " orb stroke");
            }
         }
      }
      
      private function boughtBullhorn() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("bullhorn bought");
         }
         this.personItem_array.push("bullhorn");
         this.theConnection.send("giBullhorn");
      }
      
      private function boughtItemVendor() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("item vendor bought");
         }
         this.personItem_array.push("item vendor");
         this.theConnection.send("boughtItemVendor");
      }
      
      private function boughtGreenBall() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("green spawn ball bought");
         }
         this.personItem_array.push("green spawn ball");
         this.theConnection.send("boughtGreenBall");
      }
      
      private function boughtBlueBall() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("blue spawn ball bought");
         }
         this.personItem_array.push("blue spawn ball");
         this.theConnection.send("boughtBlueBall");
      }
      
      private function boughtYellowBall() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("yellow spawn ball bought");
         }
         this.personItem_array.push("yellow spawn ball");
         this.theConnection.send("boughtYellowBall");
      }
      
      private function boughtOrangeBall() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("orange spawn ball bought");
         }
         this.personItem_array.push("orange spawn ball");
         this.theConnection.send("boughtOrangeBall");
      }
      
      private function boughtGuildMoney3x() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("bought guild triple money");
         }
         this.theConnection.send("boughtGuild3x");
         this.hasGuildMoney3x = true;
      }
      
      private function boughtFishNet() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("bought fish net");
         }
         this.personItem_array.push("net");
         this.theConnection.send("fishNetBought");
      }
      
      private function boughtChainsaw() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("chainsaw bought");
         }
         this.personItem_array.push("chainsaw");
         this.theConnection.send("chainsawBought");
      }
      
      private function boughtChickenSuit() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("chicken suit bought");
         }
         this.personItem_array.push("chicken hat");
         this.personItem_array.push("chicken outfit");
         this.personItem_array.push("chicken pants");
         this.theConnection.send("chickenBought");
      }
      
      private function boughtBaitExtend() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("bought bait extension");
         }
         this.player.hasBaitExtend = true;
      }
      
      private function boughtPrivateServer() : void
      {
         var _loc1_:String = null;
         var _loc2_:Boolean = false;
         _loc1_ = null;
         _loc2_ = false;
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            _loc1_ = this.pvMenu.serverPass_txt.alpha == 1 ? this.pvMenu.serverPass_txt.text : "";
            _loc2_ = this.pvMenu.guildMembersOnly_mc.currentLabel == "save" && this.pvMenu.guildMembersOnly_mc.alpha == 1;
            this.theConnection.send("privateServerBought",this.pvMenu.serverName_txt.text,_loc1_,_loc2_);
            this.pvMenu.gotoAndStop("private server bought");
         }
      }
      
      public function boughtFishRadar(param1:Object = null) : void
      {
         if(param1 == null || Boolean(param1.sucess))
         {
            if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
            {
               this.pvMenu.gotoAndStop("bought fish radar");
            }
            this.hasFishRadar = true;
         }
         else if(param1.paypalurl != undefined)
         {
            this.paypal_url.url = param1.paypalurl;
         }
      }
      
      private function boughtPetVendor() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("bought pet vendor");
         }
         this.personItem_array.push("pet vendor");
         this.theConnection.send("boughtPetVendor");
      }
      
      private function boughtRedCape() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("accessory bought");
         }
         this.player.money = this.player.money - Stats.accStats["red cape"].cost;
         this.personItem_array.push("red cape");
         this.theConnection.send("boughtPVAcc","red cape","redcape");
      }
      
      private function boughtJetpack() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("accessory bought");
         }
         this.player.money = this.player.money - Stats.accStats["jet pack"].cost;
         this.personItem_array.push("jet pack");
         this.theConnection.send("boughtPVAcc","jet pack","jetpack");
      }
      
      private function boughtMonkeyTail() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("accessory bought");
         }
         this.player.money = this.player.money - Stats.accStats["monkey tail"].cost;
         this.personItem_array.push("monkey tail");
         this.theConnection.send("boughtPVAcc","monkey tail","monkeytail");
      }
      
      private function boughtDinoTail() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("accessory bought");
         }
         this.player.money = this.player.money - Stats.accStats["dino tail"].cost;
         this.personItem_array.push("dino tail");
         this.theConnection.send("boughtPVAcc","dino tail","dinotail");
      }
      
      private function boughtWings() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("accessory bought");
         }
         this.player.money = this.player.money - Stats.accStats["wings"].cost;
         this.personItem_array.push("wings");
         this.theConnection.send("boughtPVAcc","wings","wings");
      }
      
      private function boughtPinkBalloon() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("accessory bought");
         }
         this.player.money = this.player.money - Stats.accStats["pink balloon"].cost;
         this.personItem_array.push("pink balloon");
         this.theConnection.send("boughtPVAcc","pink balloon","pinkballoon");
      }
      
      private function boughtBalloonPack() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("accessory bought");
         }
         this.player.money = this.player.money - Stats.accStats["balloon pack"].cost;
         this.personItem_array.push("balloon pack");
         this.theConnection.send("boughtPVAcc","balloon pack","balloonpack");
      }
      
      private function boughtEvilWings() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("accessory bought");
         }
         this.player.money = this.player.money - Stats.accStats["evil wings"].cost;
         this.personItem_array.push("evil wings");
         this.theConnection.send("boughtPVAcc","evil wings","evilwings");
      }
      
      private function boughtButterflyWings() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("accessory bought");
         }
         this.player.money = this.player.money - Stats.accStats["butterfly wings"].cost;
         this.personItem_array.push("butterfly wings");
         this.theConnection.send("boughtPVAcc","butterfly wings","butterflywings");
      }
      
      private function boughtHelipack() : void
      {
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            this.pvMenu.gotoAndStop("accessory bought");
         }
         this.player.money = this.player.money - Stats.accStats["heli pack"].cost;
         this.personItem_array.push("heli pack");
         this.theConnection.send("boughtPVAcc","heli pack","helipack");
      }
      
      public function boughtPVError(param1:PlayerIOError) : void
      {
         if(this.player.tickets > 0)
         {
            this.createAlert("You do not have enough tickets to make this purchase");
         }
         else if(GameMenu.menu_array.indexOf(this.pvMenu) > -1)
         {
            switch(this.playingURL_string)
            {
               case "facebook.com":
                  this.pvMenu.gotoFacebookPurchase();
                  break;
               case "kongregate.com":
                  this.pvMenu.gotoKongregatePurchase();
                  break;
               case "steampowered.com":
                  this.pvMenu.gotoSteamPurchase();
                  break;
               case "playerio.com":
                  this.pvMenu.gotoPlayerIOPurchase();
                  break;
               default:
                  if(Steam.onSteam)
                  {
                     this.pvMenu.gotoSteamPurchase();
                  }
                  else if(isMobile == false)
                  {
                     this.pvMenu.gotoPurchase();
                  }
                  else if(isIOS)
                  {
                     this.pvMenu.gotoIOSPurchase();
                  }
                  else
                  {
                     this.pvMenu.gotoGooglePlayPurchase();
                  }
            }
         }
      }
      
      private function enemyStatsLoaded(param1:Array, param2:Boolean = false) : void
      {
         if(param1 != null)
         {
            this.len = param1.length;
            this.i = 0;
            while(this.i < this.len)
            {
               if(param1[this.i].key != undefined)
               {
                  param1[this.i].n = param1[this.i].key;
               }
               param1[this.i].items = null;
               param1[this.i].jumpPower = param1[this.i].jump == undefined ? 0 : param1[this.i].jump;
               Stats.setNewEnemy(param1[this.i].n,param1[this.i].h,param1[this.i].d,param1[this.i].s,param1[this.i].w,param1[this.i].p,param1[this.i].jump);
               ++this.i;
            }
            if(param2 == false)
            {
               this.dbItems_sharedObject.data.enemyStats = param1;
               try
               {
                  this.dbItems_sharedObject.flush();
               }
               catch(_error:Error)
               {
               }
            }
            if(Stats.allItemsAndEnemiesLoaded)
            {
               this.init_txt.text = "";
            }
         }
      }
      
      private function playerInfoLoadedScrolls(param1:DatabaseObject) : void
      {
         this.player.power = 3;
         this.player.range = 3;
         this.player.defense = 1;
         this.player.magic = 1;
         this.player.dex = 1;
         this.player.health = 200;
         this.player.totalHealth = this.player.health;
         this.player.MP = 0;
         this.player.totalMP = this.player.MP;
         this.player.abilityPoints = this.player.lev * 3 + (param1.books != null ? param1.books : 0);
         this.player.moveSpeed = 7 + this.player.dex / 176;
         this.theConnection.send("aPointReset");
         this.pvMenu.gotoAndStop("ability point reset bought");
         this.starlingStage.controls.blinkCharacterButton = true;
      }
      
      private function guildMemberInfoLoaded(param1:DatabaseObject) : void
      {
         if(StarlingGameMenu.menu_array.indexOf(this.guildMemberMenu) > -1)
         {
            this.guildMemberMenu.guildMemberInfoLoaded(param1);
         }
      }
      
      private function guildNameCheckLoaded(param1:DatabaseObject) : void
      {
         if(this.player.money >= 200000)
         {
            if(param1 == null)
            {
               if(GameMenu.menu_array.indexOf(this.guildMenu) > -1)
               {
                  this.guildMenu.reason_txt.text = "guild name available";
                  this.theConnection.addMessageHandler("guildCre",this.guildCreatedGot);
                  this.theConnection.send("creGuild",this.guildMenu.guildName_txt.text,this.guildMenu.guildDesc_txt.text);
               }
            }
            else if(GameMenu.menu_array.indexOf(this.guildMenu) > -1 && this.guildMenu.currentFrame == 3)
            {
               this.guildMenu.reason_txt.text = "the guild name you\'ve entered is currently taken";
            }
         }
         else
         {
            this.guildMenu.reason_txt.text = "must have $25,000 to create a guild";
         }
      }
      
      private function guildCreatedGot(param1:Message, param2:String) : void
      {
         if(GameMenu.menu_array.indexOf(this.guildMenu) > -1)
         {
            this.player.money = this.player.money - 200000;
            this.player.guild = param2;
            this.hasGuildMoney3x = false;
            this.guildMenu.gotoAndStop(1);
            this.guildMenu.updateMe(this.player.guild);
            this.theClient.bigDB.loadRange("guildsData","totalLevelsIndex",[],int.MAX_VALUE,0,1000,this.guildMenu.guildsLoaded);
         }
      }
      
      private function debugStatsGot(param1:Message, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int, param10:int, param11:Boolean) : void
      {
         this.addDebugText("-----Server Info------");
         this.addDebugText("counter: " + param2);
         this.addDebugText("non-null enemies in enemy array: " + param3);
         this.addDebugText("non-null players in player array: " + param4);
         this.addDebugText("non-null items in item array: " + param5);
         this.addDebugText("non-null enemyStats in eStat array: " + param6);
         this.addDebugText("non-null itemStats in iStat array: " + param7);
         this.addDebugText("numEnemies variable: " + param9);
         this.theConnection.removeMessageHandler("debugSGot",this.debugStatsGot);
      }
      
      private function totalOnlineLoaded(param1:flash.events.Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:* = 0;
         _loc2_ = int(param1.target.data.server1);
         _loc3_ = int(param1.target.data.server2);
         _loc4_ = int(param1.target.data.server3);
         var _loc5_:int = int(param1.target.data.server4);
         _loc6_ = int(param1.target.data.serverPVP);
         this.totalGamePlayers = param1.target.data.totalPlayers;
         this.serverPops_array[this.serverNames_array.indexOf("Main Server 1")] = _loc2_;
         this.serverPops_array[this.serverNames_array.indexOf("Main Server 2")] = _loc3_;
         this.serverPops_array[this.serverNames_array.indexOf("Main Server 3")] = _loc4_;
         this.serverPops_array[this.serverNames_array.indexOf("PvP Server")] = _loc6_;
         _loc7_ = 1;
         while(param1.target.data["private" + _loc7_ + "Name"] != undefined)
         {
            _loc7_++;
            this.serverNames_array.push(param1.target.data["private" + _loc7_ + "Name"]);
            this.serverPops_array.push(param1.target.data["private" + _loc7_]);
         }
         if(this.mMenu != null && this.mMenu.parent != null)
         {
            if(this.mMenu.currentLabel == "main")
            {
               this.mMenu.online_txt.text = String(this.totalGamePlayers);
               TweenMax.from(this.mMenu.online_txt,0.3,{
                  "x":this.mMenu.online_txt.x - 80,
                  "y":this.mMenu.online_txt.y - 40,
                  "scaleX":2,
                  "scaleY":2,
                  "ease":Back.easeIn
               });
            }
            else if(this.mMenu.currentLabel == "servers")
            {
               this.mMenu.server1_mc.players_txt.text = "Players: " + _loc2_;
               this.mMenu.server2_mc.players_txt.text = "Players: " + _loc3_;
               this.mMenu.server3_mc.players_txt.text = "Players: " + _loc4_;
               this.mMenu.serverPVP_mc.players_txt.text = "Players: " + _loc6_;
               this.mMenu.server1_mc.mask_mc.scaleX = this.serverPops_array[this.serverNames_array.indexOf("Main Server 1")] / (this.c_mc.totalFrames * 6);
               this.mMenu.server2_mc.mask_mc.scaleX = this.serverPops_array[this.serverNames_array.indexOf("Main Server 2")] / (this.c_mc.totalFrames * 6);
               this.mMenu.server3_mc.mask_mc.scaleX = this.serverPops_array[this.serverNames_array.indexOf("Main Server 3")] / (this.c_mc.totalFrames * 6);
               this.mMenu.serverPVP_mc.mask_mc.scaleX = this.serverPops_array[this.serverNames_array.indexOf("PvP Server")] / (this.c_mc.totalFrames * 6);
               this.mMenu.server1_mc.name_txt.text = "Pve Server";
               this.mMenu.server1_mc.icon_mc.visible = this.mMenu.serverPVP_mc.icon_mc.visible = false;
               this.i = 0;
               while(this.i < 30)
               {
                  if(param1.target.data["private" + (this.i + 1) + "Name"] != undefined)
                  {
                     ServerPanel(this.mMenu["privateServer" + (this.i + 1) + "_mc"]).mouseChildren = false;
                     ServerPanel(this.mMenu["privateServer" + (this.i + 1) + "_mc"]).buttonMode = true;
                     ServerPanel(this.mMenu["privateServer" + (this.i + 1) + "_mc"]).name_txt.text = param1.target.data["private" + (this.i + 1) + "Name"];
                     ServerPanel(this.mMenu["privateServer" + (this.i + 1) + "_mc"]).players_txt.text = "Players: " + param1.target.data["private" + (this.i + 1)];
                     ServerPanel(this.mMenu["privateServer" + (this.i + 1) + "_mc"]).mask_mc.scaleX = param1.target.data["private" + (this.i + 1)] / (this.c_mc.totalFrames * 6);
                     ServerPanel(this.mMenu["privateServer" + (this.i + 1) + "_mc"]).icon_mc.guild = param1.target.data["private" + (this.i + 1) + "Guild"];
                     if(param1.target.data["private" + (this.i + 1) + "Pass"] != "")
                     {
                        ServerPanel(this.mMenu["privateServer" + (this.i + 1) + "_mc"]).icon_mc.gotoAndStop("lock");
                     }
                     else if(param1.target.data["private" + (this.i + 1) + "Guild"] != "")
                     {
                        ServerPanel(this.mMenu["privateServer" + (this.i + 1) + "_mc"]).icon_mc.gotoAndStop("guild");
                     }
                     else
                     {
                        ServerPanel(this.mMenu["privateServer" + (this.i + 1) + "_mc"]).icon_mc.visible = false;
                     }
                  }
                  else
                  {
                     ServerPanel(this.mMenu["privateServer" + (this.i + 1) + "_mc"]).visible = false;
                  }
                  ++this.i;
               }
            }
         }
         param1.target.removeEventListener(flash.events.Event.COMPLETE,this.totalOnlineLoaded);
      }
      
      private function ipBanCheckGot(param1:Message) : void
      {
         if(this.mMenu != null && this.mMenu.parent != null)
         {
            this.mMenu.gotoAndStop("banned");
            this.mMenu.loadingCircle_mc.visible = false;
         }
         else
         {
            this.createMMenu("banned");
         }
         this.createAlert("you have been banned");
         this.theConnection.disconnect();
         stage.removeEventListener(flash.events.Event.ENTER_FRAME,this.onEnter);
         stage.frameRate = 0;
      }
      
      private function proxyDetected(param1:Message) : void
      {
         if(this.mMenu != null && this.mMenu.parent != null)
         {
            this.mMenu.gotoAndStop("proxy");
            this.mMenu.loadingCircle_mc.visible = false;
         }
         else
         {
            this.createMMenu("proxy");
         }
         this.createAlert("Proxies disabled");
         this.theConnection.disconnect();
         stage.removeEventListener(flash.events.Event.ENTER_FRAME,this.onEnter);
         stage.frameRate = 0;
      }
      
      private function passwordSent() : void
      {
         if(this.mMenu != null && this.mMenu.parent != null && this.mMenu.currentLabel == "forgot password")
         {
            this.mMenu.emailVerify_txt.text = "An email with your password has been sent";
            this.mMenu.sendPass_btn.visible = false;
         }
      }
      
      private function passwordSentError(param1:PlayerIOError) : void
      {
         if(this.mMenu != null && this.mMenu.parent != null && this.mMenu.currentLabel == "forgot password")
         {
            this.mMenu.emailVerify_txt.text = param1.message;
         }
      }
      
      private function slotDoneGot(param1:Message, param2:int, param3:int) : void
      {
         if(this.c_mc.currentFrame == 33)
         {
            this.c_mc.slot1_mc.gotWinnings = true;
            this.c_mc.slot1_mc.roll = param2;
            this.c_mc.slot1_mc.moneyWon = param3;
         }
         this.theConnection.removeMessageHandler("slotDone",this.slotDoneGot);
      }
      
      private function itemSlotDoneGot(param1:Message, param2:String) : void
      {
         if(this.c_mc.currentFrame == 33)
         {
            this.personItem_array.push(param2);
            this.c_mc.slot2_mc.gotWinnings = true;
            this.c_mc.slot2_mc.rollString = param2;
            this.c_mc.slot2_mc.item_mc.gotoAndStop(param2);
            this.c_mc.slot2_mc.item_mc.gotoAndPlay(2);
         }
         this.theConnection.removeMessageHandler("iSlotDone",this.itemSlotDoneGot);
      }
      
      private function weaponStatsLoaded(param1:Array, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Object = null;
         var _loc12_:Vector.<String> = null;
         var _loc13_:Vector.<int> = null;
         _loc3_ = 0;
         _loc4_ = false;
         _loc5_ = false;
         _loc6_ = false;
         _loc7_ = 0;
         _loc8_ = 0;
         _loc9_ = 0;
         _loc10_ = 0;
         _loc11_ = null;
         _loc12_ = null;
         _loc13_ = null;
         if(param1 != null)
         {
            _loc3_ = 0;
            _loc4_ = false;
            _loc5_ = false;
            _loc6_ = false;
            _loc7_ = 0;
            _loc8_ = 0;
            _loc9_ = 0;
            _loc10_ = 0;
            for each(var _loc16_ in param1)
            {
               _loc11_ = _loc16_;
               _loc16_;
               if(_loc11_.key != undefined)
               {
                  _loc11_.n = _loc11_.key;
               }
               _loc4_ = _loc11_.rng == undefined ? false : Boolean(_loc11_.rng);
               _loc5_ = _loc11_.two == undefined ? false : Boolean(_loc11_.two);
               _loc6_ = _loc11_.mgc == undefined ? false : Boolean(_loc11_.mgc);
               _loc7_ = _loc11_.fire == undefined ? 0 : int(_loc11_.fire);
               _loc9_ = _loc11_.shock == undefined ? 0 : int(_loc11_.shock);
               _loc8_ = _loc11_.ice == undefined ? 0 : int(_loc11_.ice);
               _loc10_ = _loc11_.sr == undefined ? 0 : int(_loc11_.sr);
               _loc3_ = _loc11_.def == undefined ? 0 : int(_loc11_.def);
               _loc12_ = _loc11_.craftItems != undefined ? Vector.<String>(_loc11_.craftItems) : new Vector.<String>();
               _loc13_ = _loc11_.craftCosts != undefined ? Vector.<int>(_loc11_.craftCosts) : new Vector.<int>();
               Stats.setNewWeapon(_loc11_.n,_loc11_.min,_loc11_.max,_loc11_.c,_loc11_.lvl,_loc4_,_loc5_,_loc6_,_loc7_,_loc9_,_loc8_,_loc10_,_loc3_,_loc12_,_loc13_,_loc11_.f);
            }
            Stats.weaponsLoaded = true;
            if(param2 == false)
            {
               this.dbItems_sharedObject.data.wStats = param1;
               try
               {
                  this.dbItems_sharedObject.flush();
               }
               catch(_error:Error)
               {
               }
            }
            if(Stats.allItemsAndEnemiesLoaded)
            {
               this.init_txt.text = "";
            }
         }
      }
      
      private function helmetStatsLoaded(param1:Array, param2:Boolean = false) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:Vector.<String> = null;
         var _loc10_:Vector.<int> = null;
         _loc3_ = false;
         _loc4_ = 0;
         _loc5_ = 0;
         _loc6_ = 0;
         _loc7_ = 0;
         _loc8_ = null;
         _loc9_ = null;
         _loc10_ = null;
         if(param1 != null)
         {
            _loc3_ = false;
            _loc4_ = 0;
            _loc5_ = 0;
            _loc6_ = 0;
            _loc7_ = 0;
            for each(var _loc13_ in param1)
            {
               _loc8_ = _loc13_;
               _loc13_;
               if(_loc8_.key != undefined)
               {
                  _loc8_.n = _loc8_.key;
               }
               _loc3_ = _loc8_.hair == undefined ? false : Boolean(_loc8_.hair);
               _loc4_ = _loc8_.pow == undefined ? 0 : int(_loc8_.pow);
               _loc5_ = _loc8_.rng == undefined ? 0 : int(_loc8_.rng);
               _loc6_ = _loc8_.mgc == undefined ? 0 : int(_loc8_.mgc);
               _loc7_ = _loc8_.art == undefined ? 0 : int(_loc8_.art);
               _loc9_ = _loc8_.craftItems != undefined ? Vector.<String>(_loc8_.craftItems) : new Vector.<String>();
               _loc10_ = _loc8_.craftCosts != undefined ? Vector.<int>(_loc8_.craftCosts) : new Vector.<int>();
               Stats.setNewHelmet(_loc8_.n,_loc8_.f,_loc8_.def,_loc8_.c,_loc8_.lvl,_loc3_,_loc5_,_loc6_,_loc4_,_loc7_,_loc9_,_loc10_);
            }
            Stats.helmetsLoaded = true;
            if(param2 == false)
            {
               this.dbItems_sharedObject.data.hStats = param1;
               try
               {
                  this.dbItems_sharedObject.flush();
               }
               catch(_error:Error)
               {
               }
            }
            if(Stats.allItemsAndEnemiesLoaded)
            {
               this.init_txt.text = "";
            }
         }
      }
      
      private function shirtStatsLoaded(param1:Array, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:Vector.<String> = null;
         var _loc9_:Vector.<int> = null;
         _loc3_ = 0;
         _loc4_ = 0;
         _loc5_ = 0;
         _loc6_ = 0;
         _loc7_ = null;
         _loc8_ = null;
         _loc9_ = null;
         if(param1 != null)
         {
            _loc3_ = 0;
            _loc4_ = 0;
            _loc5_ = 0;
            _loc6_ = 0;
            for each(var _loc12_ in param1)
            {
               _loc7_ = _loc12_;
               _loc12_;
               if(_loc7_.key != undefined)
               {
                  _loc7_.n = _loc7_.key;
               }
               _loc3_ = _loc7_.pow == undefined ? 0 : int(_loc7_.pow);
               _loc4_ = _loc7_.rng == undefined ? 0 : int(_loc7_.rng);
               _loc5_ = _loc7_.mgc == undefined ? 0 : int(_loc7_.mgc);
               _loc6_ = _loc7_.art == undefined ? 0 : int(_loc7_.art);
               _loc8_ = _loc7_.craftItems != undefined ? Vector.<String>(_loc7_.craftItems) : new Vector.<String>();
               _loc9_ = _loc7_.craftCosts != undefined ? Vector.<int>(_loc7_.craftCosts) : new Vector.<int>();
               Stats.setNewShirt(_loc7_.n,_loc7_.def,_loc7_.lvl,_loc7_.c,_loc4_,_loc5_,_loc3_,_loc6_,_loc8_,_loc9_,_loc7_.f);
            }
            Stats.shirtsLoaded = true;
            if(param2 == false)
            {
               this.dbItems_sharedObject.data.shirtStats = param1;
               try
               {
                  this.dbItems_sharedObject.flush();
               }
               catch(_error:Error)
               {
               }
            }
            if(Stats.allItemsAndEnemiesLoaded)
            {
               this.init_txt.text = "";
            }
         }
      }
      
      private function legsStatsLoaded(param1:Array, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:Vector.<String> = null;
         var _loc9_:Vector.<int> = null;
         _loc3_ = 0;
         _loc4_ = 0;
         _loc5_ = 0;
         _loc6_ = 0;
         _loc7_ = null;
         _loc8_ = null;
         _loc9_ = null;
         if(param1 != null)
         {
            _loc3_ = 0;
            _loc4_ = 0;
            _loc5_ = 0;
            _loc6_ = 0;
            for each(var _loc12_ in param1)
            {
               _loc7_ = _loc12_;
               _loc12_;
               if(_loc7_.key != undefined)
               {
                  _loc7_.n = _loc7_.key;
               }
               _loc3_ = _loc7_.pow == undefined ? 0 : int(_loc7_.pow);
               _loc4_ = _loc7_.rng == undefined ? 0 : int(_loc7_.rng);
               _loc5_ = _loc7_.mgc == undefined ? 0 : int(_loc7_.mgc);
               _loc6_ = _loc7_.art == undefined ? 0 : int(_loc7_.art);
               _loc8_ = _loc7_.craftItems != undefined ? Vector.<String>(_loc7_.craftItems) : new Vector.<String>();
               _loc9_ = _loc7_.craftCosts != undefined ? Vector.<int>(_loc7_.craftCosts) : new Vector.<int>();
               Stats.setNewPants(_loc7_.n,_loc7_.def,_loc7_.lvl,_loc7_.c,_loc4_,_loc5_,_loc3_,_loc6_,_loc8_,_loc9_,_loc7_.f);
            }
            Stats.legsLoaded = true;
            if(param2 == false)
            {
               this.dbItems_sharedObject.data.legsStats = param1;
               try
               {
                  this.dbItems_sharedObject.flush();
               }
               catch(_error:Error)
               {
               }
            }
            if(Stats.allItemsAndEnemiesLoaded)
            {
               this.init_txt.text = "";
            }
         }
      }
      
      private function shoeStatsLoaded(param1:Array, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         _loc3_ = 0;
         _loc4_ = 0;
         _loc5_ = 0;
         _loc6_ = 0;
         _loc7_ = null;
         if(param1 != null)
         {
            _loc3_ = 0;
            _loc4_ = 0;
            _loc5_ = 0;
            _loc6_ = 0;
            for each(var _loc10_ in param1)
            {
               _loc7_ = _loc10_;
               _loc10_;
               if(_loc7_.key != undefined)
               {
                  _loc7_.n = _loc7_.key;
               }
               _loc3_ = _loc7_.pow == undefined ? 0 : int(_loc7_.pow);
               _loc4_ = _loc7_.rng == undefined ? 0 : int(_loc7_.rng);
               _loc5_ = _loc7_.mgc == undefined ? 0 : int(_loc7_.mgc);
               _loc6_ = _loc7_.art == undefined ? 0 : int(_loc7_.art);
               Stats.setNewShoes(_loc7_.n,_loc7_.def,_loc7_.lvl,_loc7_.c,_loc4_,_loc5_,_loc3_,_loc6_,_loc7_.f);
            }
            Stats.shoesLoaded = true;
            if(param2 == false)
            {
               this.dbItems_sharedObject.data.shoeStats = param1;
               try
               {
                  this.dbItems_sharedObject.flush();
               }
               catch(_error:Error)
               {
               }
            }
            if(Stats.allItemsAndEnemiesLoaded)
            {
               this.init_txt.text = "";
            }
         }
      }
      
      private function accStatsLoaded(param1:Array, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         _loc3_ = 0;
         _loc4_ = null;
         if(param1 != null)
         {
            _loc3_ = 0;
            for each(var _loc7_ in param1)
            {
               _loc4_ = _loc7_;
               _loc7_;
               if(_loc4_.key != undefined)
               {
                  _loc4_.n = _loc4_.key;
               }
               _loc3_ = _loc4_.pow == undefined ? 0 : int(_loc4_.pow);
               Stats.setNewAccessory(_loc4_.n,_loc4_.def,_loc4_.c,_loc4_.lvl,_loc3_,_loc4_.f);
            }
            Stats.accessoriesLoaded = true;
            if(param2 == false)
            {
               this.dbItems_sharedObject.data.accStats = param1;
               try
               {
                  this.dbItems_sharedObject.flush();
               }
               catch(_error:Error)
               {
               }
            }
         }
      }
      
      private function itemStatsLoaded(param1:Array, param2:Boolean = false) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Vector.<String> = null;
         var _loc5_:Vector.<int> = null;
         _loc3_ = null;
         _loc4_ = null;
         _loc5_ = null;
         if(param1 != null)
         {
            for each(var _loc8_ in param1)
            {
               _loc3_ = _loc8_;
               _loc8_;
               if(_loc3_.key != undefined)
               {
                  _loc3_.n = _loc3_.key;
               }
               _loc4_ = _loc3_.craftItems != undefined ? Vector.<String>(_loc3_.craftItems) : new Vector.<String>();
               _loc5_ = _loc3_.craftCosts != undefined ? Vector.<int>(_loc3_.craftCosts) : new Vector.<int>();
               Stats.setNewItem(_loc3_.n,_loc3_.c,_loc3_.n.indexOf("seed") == -1 ? "" : _loc3_.n.substr(0,_loc3_.key.indexOf("seed") - 1),_loc3_.areas,_loc4_,_loc5_);
            }
            Stats.itemsLoaded = true;
            if(param2 == false)
            {
               this.dbItems_sharedObject.data.itemStats = param1;
               try
               {
                  this.dbItems_sharedObject.flush();
               }
               catch(_error:Error)
               {
               }
            }
            if(Stats.allItemsAndEnemiesLoaded)
            {
               this.init_txt.text = "";
            }
         }
      }
      
      private function petHelmetStatsLoaded(param1:Array, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         _loc3_ = 0;
         _loc4_ = 0;
         _loc5_ = 0;
         _loc6_ = null;
         if(param1 != null)
         {
            _loc3_ = 0;
            _loc4_ = 0;
            _loc5_ = 0;
            for each(var _loc9_ in param1)
            {
               _loc6_ = _loc9_;
               _loc9_;
               if(_loc6_.key != undefined)
               {
                  _loc6_.n = _loc6_.key;
               }
               _loc4_ = _loc6_.h == undefined ? 0 : int(_loc6_.h);
               _loc5_ = _loc6_.spe == undefined ? 0 : int(_loc6_.spe);
               _loc3_ = _loc6_.l == undefined ? 0 : int(_loc6_.l);
               Stats.setNewPetHelmet(_loc6_.n,_loc6_.def,_loc6_.c,_loc6_.lvl,_loc3_,_loc4_,_loc5_,_loc6_.f);
            }
            Stats.petHelmetsLoaded = true;
            if(param2 == false)
            {
               this.dbItems_sharedObject.data.petHelmetStats = param1;
               try
               {
                  this.dbItems_sharedObject.flush();
               }
               catch(_error:Error)
               {
               }
            }
            if(Stats.allItemsAndEnemiesLoaded)
            {
               this.init_txt.text = "";
            }
         }
      }
      
      private function wrongCap(param1:Message, param2:String = "") : void
      {
         if(param2 == "")
         {
            param2 = "incorrect username capitalization";
         }
         if(this.mMenu != null && this.mMenu.parent != null && this.mMenu.currentFrame == 1)
         {
            this.timesLoaded = 1;
            this.mMenu.valid_txt.text = param2;
            this.mMenu.signIn_btn.visible = true;
            this.mMenu.username_txt.visible = true;
            this.mMenu.password_txt.visible = true;
            this.mMenu.usernamePanel_mc.visible = true;
            this.mMenu.passwordPanel_mc.visible = true;
            this.mMenu.loadingCircle_mc.visible = false;
            this.mMenu.usernamePanel_mc.visible = true;
            this.mMenu.passwordPanel_mc.visible = true;
            this.mMenu.rememberMe_txt.visible = true;
            this.mMenu.rememberMe_mc.visible = true;
            if(this.country != "Philippines")
            {
               this.mMenu.signUp_btn.visible = true;
            }
            this.mMenu.credits_btn.visible = true;
            this.mMenu.signInColon_txt.visible = true;
         }
         if(param2.indexOf("try again in") > -1)
         {
            this.mMenu.mouseEnabled = false;
         }
         param2 = param2.toLowerCase();
         if(param2.indexOf("ban") > -1 || Boolean(param2.indexOf("try again")))
         {
            if(this.mMenu != null)
            {
               this.mMenu.mouseChildren = this.mMenu.mouseEnabled = false;
            }
         }
      }
      
      private function roomInfoGot(param1:Array) : void
      {
         var _loc2_:RoomInfo = null;
         var _loc3_:String = null;
         var _loc4_:URLRequest = null;
         var _loc5_:URLVariables = null;
         var _loc6_:URLLoader = null;
         _loc2_ = null;
         _loc3_ = null;
         _loc4_ = null;
         _loc5_ = null;
         _loc6_ = null;
         if(param1 != null)
         {
            this.totalGamePlayers = 0;
            this.len = this.serverPops_array.length;
            this.i = 0;
            while(this.i < this.len)
            {
               this.serverPops_array[this.i] = 0;
               ++this.i;
            }
            this.len2 = this.serverNames_array.length;
            for each(var _loc9_ in param1)
            {
               _loc2_ = _loc9_;
               _loc9_;
               this.totalGamePlayers = this.totalGamePlayers + _loc2_.onlineUsers;
               this.len2 = this.serverNames_array.length;
               this.j = 0;
               while(this.j < this.len2)
               {
                  if(this.serverNames_array[this.j] == _loc2_.data.name)
                  {
                     this.serverPops_array[this.j] = this.serverPops_array[this.j] + _loc2_.onlineUsers;
                     break;
                  }
                  ++this.j;
               }
            }
            _loc3_ = isIOS ? "https" : "http";
            _loc4_ = new URLRequest(_loc3_ + "://yuriifedorov01-cpu.github.io/hht-client/includes/getTotal.php?" + String(Math.random() * 999999));
            _loc4_.method = URLRequestMethod.POST;
            _loc5_ = new URLVariables();
            _loc5_.onlineTotal = this.totalGamePlayers;
            this.len = this.serverNames_array.length;
            this.i = 0;
            while(this.i < this.len)
            {
               _loc5_["server" + (this.i + 1) + "Name"] = this.serverNames_array[this.i];
               _loc5_["server" + (this.i + 1) + "Pop"] = this.serverPops_array[this.i];
               ++this.i;
            }
            _loc4_.data = _loc5_;
            _loc6_ = new URLLoader();
            _loc6_.dataFormat = URLLoaderDataFormat.VARIABLES;
            _loc6_.load(_loc4_);
         }
      }
      
      private function skillsDataLoaded(param1:DatabaseObject) : void
      {
         if(param1 == null)
         {
            this.player.skillPoints = this.player.lev;
         }
         else
         {
            this.player.skillPoints = param1.p;
            if(param1.jum != undefined)
            {
               this.player.jumpSkillLvl = param1.jum;
            }
            if(param1.crit != undefined)
            {
               this.player.criticalLvl = param1.crit;
            }
            if(param1.loo != undefined)
            {
               this.player.lootStealLvl = param1.loo;
            }
            if(param1.trai != undefined)
            {
               this.player.trainingLvl = param1.trai;
            }
            if(param1.rag != undefined)
            {
               this.player.selfRageLvl = param1.rag;
            }
            if(param1.gRag != undefined)
            {
               this.player.guildRageLvl = param1.gRag;
            }
            if(param1.avoi != undefined)
            {
               this.player.avoidabilityLvl = param1.avoi;
            }
            if(param1.mpR != undefined)
            {
               this.player.mpRestoreLvl = param1.mpR;
            }
            if(param1.dash != undefined)
            {
               this.player.dashLvl = param1.dash;
            }
            if(param1.dAc != undefined)
            {
               this.player.accelDownLvl = param1.dAc;
            }
            if(param1.blo != undefined)
            {
               this.player.blockLvl = param1.blo;
            }
            if(param1.bar != undefined)
            {
               this.player.barrageLvl = param1.bar;
            }
            if(param1.aKn != undefined)
            {
               this.player.arrowKnockbackLvl = param1.aKn;
            }
            if(param1.exAr != undefined)
            {
               this.player.expertArcherLvl = param1.exAr;
            }
            if(param1.tSh != undefined)
            {
               this.player.tripleShotLvl = param1.tSh;
            }
            if(param1.aRai != undefined)
            {
               this.player.arrowRainLvl = param1.aRai;
            }
            if(param1.pAr != undefined)
            {
               this.player.piercingArrowLvl = param1.pAr;
            }
            if(param1.dCru != undefined)
            {
               this.player.downCrushLvl = param1.dCru;
            }
            if(param1.pAt != undefined)
            {
               this.player.powerAttackLvl = param1.pAt;
            }
            if(param1.exWar != undefined)
            {
               this.player.expertWarriorLvl = param1.exWar;
            }
            if(param1.chDis != undefined)
            {
               this.player.chainDistanceLvl = param1.chDis;
            }
            if(param1.shie != undefined)
            {
               this.player.shieldMasteryLvl = param1.shie;
            }
            if(param1.mulAt != undefined)
            {
               this.player.multiAttackLvl = param1.mulAt;
            }
            if(param1.melKn != undefined)
            {
               this.player.meleeKnockbackLvl = param1.melKn;
            }
            if(param1.spiAt != undefined)
            {
               this.player.spinAttackLvl = param1.spiAt;
            }
            if(param1.mShot != undefined)
            {
               this.player.magicShotsLvl = param1.mShot;
            }
            if(param1.exWiz != undefined)
            {
               this.player.expertWizardLvl = param1.exWiz;
            }
            if(param1.cirMa != undefined)
            {
               this.player.lightBeamLvl = param1.cirMa;
            }
            if(param1.maDis != undefined)
            {
               this.player.magicDistanceLvl = param1.maDis;
            }
            if(param1.thAt != undefined)
            {
               this.player.thunderAttackLvl = param1.thAt;
            }
            if(param1.hea != undefined)
            {
               this.player.selfHealLvl = param1.hea;
            }
            if(param1.gHea != undefined)
            {
               this.player.guildHealLvl = param1.gHea;
            }
            if(param1.gren != undefined)
            {
               this.player.grenadeLvl = param1.gren;
            }
            if(param1.upw != undefined)
            {
               this.player.upwardShootLvl = param1.upw;
            }
            if(param1.exCo != undefined)
            {
               this.player.expertCowboyLvl = param1.exCo;
            }
            if(param1.bDi != undefined)
            {
               this.player.bulletDistanceLvl = param1.bDi;
            }
            if(param1.sgun != undefined)
            {
               this.player.shotgunLvl = param1.sgun;
            }
            if(param1.bulK != undefined)
            {
               this.player.bulletKnockbackLvl = param1.bulK;
            }
            if(param1.jGre != undefined)
            {
               this.player.jumpGrenadeLvl = param1.jGre;
            }
         }
         this.player.jumpPower = 20 + this.player.jumpSkillLvl * 0.3;
         if(this.proDataHasLoaded == false)
         {
            this.player.energyController.rageMax = 1;
         }
         this.player.energyController.rage = this.player.selfRageLvl * 0.028572;
         this.skillsDataHasLoaded = true;
         this.starlingStage.controls.setMoreMobileButtons(this.player);
      }
      
      private function proDataLoaded(param1:DatabaseObject) : void
      {
         if(param1 != null)
         {
            this.player.fishingLvl = param1.fishing != undefined ? uint(param1.fishing) : 1;
            this.player.fishXP = param1.fishXP != undefined ? uint(param1.fishXP) : 0;
            this.player.choppingLvl = param1.chopping != undefined ? uint(param1.chopping) : 1;
            this.player.chopXP = param1.chopXP != undefined ? uint(param1.chopXP) : 0;
            this.player.energyController.totalMax = param1.totMax != undefined ? Number(param1.totMax) : 0.1;
            this.player.energyController.chargeMax = param1.chargeMax != undefined ? Number(param1.chargeMax) : 0.1;
            this.player.energyController.absorbedMax = param1.abMax != undefined ? Number(param1.abMax) : 0.1;
            this.player.energyController.levelMax = param1.levMax != undefined ? Number(param1.levMax) : 0.1;
            this.player.energyController.enemyMax = param1.enMax != undefined ? Number(param1.enMax) : 0.1;
            this.player.energyController.pvpMax = param1.pvpMax != undefined ? Number(param1.pvpMax) : 0.1;
            this.player.energyController.randomMax = param1.ranMax != undefined ? Number(param1.ranMax) : 0.1;
            this.player.energyController.rageMax = param1.rageMax != undefined ? Number(param1.rageMax) : 0.1;
            this.player.energyController.chopMax = param1.chopMax != undefined ? Number(param1.chopMax) : 0.1;
            this.player.energyController.fishMax = param1.fishMax != undefined ? Number(param1.fishMax) : 0.1;
         }
         this.proDataHasLoaded = true;
      }
      
      private function powerUnleashed(param1:Message, param2:String, param3:Number, param4:Number) : void
      {
         var _loc5_:Person = null;
         _loc5_ = null;
         for each(var _loc8_ in this.p_array)
         {
            _loc5_ = _loc8_;
            _loc8_;
            if(_loc5_.name == param2)
            {
               _loc5_.energyController.fakeFullTotal = param3;
               _loc5_.energyController.chargeMax = 1;
               _loc5_.energyController.charge = param4;
               _loc5_.powerUpVisuals.unleash();
               break;
            }
         }
      }
      
      private function rageStart(param1:Message, param2:String, param3:Boolean = false) : void
      {
         var _loc4_:Image = null;
         _loc4_ = null;
         this.len = this.p_array.length;
         this.i = 0;
         while(this.i < this.len)
         {
            if(this.p_array[this.i].name == param2)
            {
               SoundManager.playSound(SoundLibrary.rage_sound,this.p_array[this.i].x,this.p_array[this.i].y,true,this.starlingStage.c_mc);
               if(this.p_array[this.i].inGuildRage == false)
               {
                  _loc4_ = new Image(Assets.powerUp_textureAtlas.getTexture("rage glow"));
                  _loc4_.x = this.p_array[this.i].x;
                  _loc4_.y = this.p_array[this.i].y;
                  _loc4_.pivotX = _loc4_.width / 2;
                  _loc4_.pivotY = _loc4_.height / 2;
                  _loc4_.touchable = false;
                  _loc4_.textureSmoothing = TextureSmoothing.NONE;
                  SortDepths.addAt(_loc4_,SortDepths.REGION_1);
                  this.p_array[this.i].rageGlow_image = _loc4_;
               }
               if(param3)
               {
                  this.p_array[this.i].MP = this.p_array[this.i].MP - this.p_array[this.i].levelMP(Person.GUILD_RAGE_MP);
               }
               this.p_array[this.i].inGuildRage = true;
               break;
            }
            ++this.i;
         }
      }
      
      private function rageEnd(param1:Message, param2:String) : void
      {
         this.len = this.p_array.length;
         this.i = 0;
         while(this.i < this.len)
         {
            if(this.p_array[this.i].name == param2)
            {
               this.p_array[this.i].inGuildRage = false;
               if(this.p_array[this.i].rageGlow_image != null)
               {
                  this.p_array[this.i].rageGlow_image.removeFromParent(true);
               }
               break;
            }
            ++this.i;
         }
      }
      
      private function pingGot(param1:Message) : void
      {
         this.player.ping = getTimer() - this.pingStartTime;
         this.theConnection.send("pingDone",this.player.ping);
      }
      
      private function petStatsLoaded(param1:Array, param2:Boolean = false) : void
      {
         var _loc3_:Object = null;
         _loc3_ = null;
         if(param1 != null)
         {
            Stats.basePetStatsLoaded = true;
            for each(var _loc6_ in param1)
            {
               _loc3_ = _loc6_;
               _loc6_;
               if(_loc3_.key != undefined)
               {
                  _loc3_.n = _loc3_.key;
               }
               Stats.setPetStats(_loc3_.n,_loc3_.c,_loc3_.h,_loc3_.pow,_loc3_.dx,_loc3_.def,_loc3_.m,_loc3_.d,_loc3_.col);
            }
            if(param2 == false)
            {
               this.dbItems_sharedObject.data.petStats = param1;
               try
               {
                  this.dbItems_sharedObject.flush();
               }
               catch(_error:Error)
               {
               }
            }
         }
      }
      
      private function personPetsLoaded(param1:Array) : void
      {
         var _loc2_:DatabaseObject = null;
         _loc2_ = null;
         this.len = PetOrb.petOrb_array.length;
         this.i = this.len - 1;
         while(this.i >= 0)
         {
            if(PetOrb.petOrb_array[this.i].creator.isPlayer)
            {
               PetOrb.petOrb_array[this.i].removeFromParent(true);
               PetOrb.petOrb_array.removeAt(this.i);
            }
            --this.i;
         }
         this.a = 0;
         if(param1 != null)
         {
            for each(var _loc5_ in param1)
            {
               _loc2_ = _loc5_;
               _loc5_;
               this.createPetFromDBObject(_loc2_);
            }
         }
      }
      
      private function createPetFromDBObject(param1:DatabaseObject) : void
      {
         var _loc2_:Pet = null;
         _loc2_ = null;
         _loc2_ = this.createPet(param1.active,this.player,param1.key,param1.type,param1.health,param1.totalHealth,param1.power,param1.dex,param1.def,param1.love,param1.mode,param1.helm);
         _loc2_.isCompanion = param1.companion != undefined && param1.companion == true ? true : false;
         _loc2_.originalOwner = param1.oOwner != undefined ? param1.oOwner : param1.owner;
         _loc2_.xpSplit = param1.xpSplit / 100;
         _loc2_.xp = param1.xp;
         _loc2_.lvl = param1.lvl;
         _loc2_.shoes_uint = param1.shoe;
         if(_loc2_.mode == "m" && _loc2_.isActive)
         {
            _loc2_.setActiveMount();
         }
         this.len = PetOrb.petOrb_array.length;
         this.i = 0;
         while(this.i < this.len)
         {
            if(PetOrb.petOrb_array[this.i].petName == _loc2_.name)
            {
               PetOrb.petOrb_array[this.i].removeFromParent(true);
               PetOrb.petOrb_array.removeAt(this.i);
               break;
            }
            ++this.i;
         }
         if(_loc2_.health > 0 && _loc2_.isActive == false)
         {
            this.createPetOrb(_loc2_.getOrbBonus(),_loc2_.name,this.player.name,_loc2_.lvl,_loc2_.type,this.player.hasOrbFocus);
         }
      }
      
      private function petActivated(param1:Message, param2:String, param3:String) : void
      {
         var _loc4_:Pet = null;
         var _loc5_:int = 0;
         _loc4_ = null;
         _loc5_ = 0;
         _loc4_ = Pet(CommonCalls.returnObject(this.player.pet_array,param3));
         if(_loc4_ != null)
         {
            _loc4_.isActive = true;
            if(_loc4_.mode != "m")
            {
               _loc5_ = int(SortDepths.getLowestChildIndex(Vector.<starling.display.DisplayObject>(GiveHealthBar.healthBG_array)));
               if(_loc5_ != int.MAX_VALUE)
               {
                  this.starlingStage.c_mc.addChildAt(_loc4_,_loc5_);
               }
               else
               {
                  this.starlingStage.c_mc.addChild(_loc4_);
               }
               _loc4_.x = this.player.x;
               _loc4_.y = this.player.y;
               this.pet_array.push(_loc4_);
            }
            else
            {
               _loc4_.setActiveMount();
            }
            _loc4_.alpha = 1;
            _loc4_.isAttacking = false;
            _loc4_.filter = null;
            if(StarlingGameMenu.menu_array.indexOf(this.petMenu) > -1)
            {
               this.petMenu.withdraw_btn.visible = true;
               this.petMenu.activate_btn.visible = false;
               this.petMenu.touchable = true;
               this.petMenu.updateMe();
            }
            this.len = PetOrb.petOrb_array.length;
            this.i = 0;
            while(this.i < this.len)
            {
               if(PetOrb.petOrb_array[this.i].petName == param3)
               {
                  PetOrb.petOrb_array[this.i].removeFromParent(true);
                  PetOrb.petOrb_array.removeAt(this.i);
                  break;
               }
               ++this.i;
            }
            SoundManager.playSound(SoundLibrary.itemBought_sound);
         }
      }
      
      private function petWithdraw(param1:Message, param2:String, param3:String) : void
      {
         var _loc4_:Person = null;
         var _loc5_:Pet = null;
         _loc4_ = null;
         _loc5_ = null;
         for each(var _loc8_ in this.p_array)
         {
            _loc4_ = _loc8_;
            _loc8_;
            if(_loc4_.name == param2)
            {
               for each(var _loc10_ in _loc4_.pet_array)
               {
                  _loc5_ = _loc10_;
                  _loc10_;
                  if(_loc5_.name == param3)
                  {
                     if(_loc5_.mode == "m")
                     {
                        _loc4_.bodyAnimator.removeMountedPet();
                     }
                     if(_loc5_.owner.isControllingPet)
                     {
                        _loc5_.owner.togglePetControl();
                     }
                     if(_loc4_.isPlayer == false)
                     {
                        _loc4_.removePetFromMe(_loc5_.name);
                     }
                     else
                     {
                        _loc5_.isActive = false;
                     }
                     Pet.petRemove(this.pet_array,_loc5_,true);
                     _loc4_.bodyAnimator.gotoAndPlay("standing");
                     this.createPetOrb(_loc5_.getOrbBonus(),_loc5_.name,_loc5_.owner.name,_loc5_.lvl,_loc5_.type,_loc5_.owner.hasOrbFocus);
                     break;
                  }
               }
               break;
            }
         }
         if(_loc4_.name == this.player.name && StarlingGameMenu.menu_array.indexOf(this.petMenu) > -1)
         {
            this.petMenu.withdraw_btn.visible = false;
            this.petMenu.activate_btn.visible = true;
            this.petMenu.updateMe();
            SoundManager.playSound(SoundLibrary.itemSold_sound);
         }
      }
      
      private function petModeChanged(param1:Message, param2:String, param3:String, param4:String) : void
      {
         var _loc5_:Person = null;
         var _loc6_:Pet = null;
         var _loc7_:int = 0;
         _loc5_ = null;
         _loc6_ = null;
         _loc7_ = 0;
         for each(var _loc10_ in this.p_array)
         {
            _loc5_ = _loc10_;
            _loc10_;
            if(_loc5_.name == param2)
            {
               for each(var _loc12_ in _loc5_.pet_array)
               {
                  _loc6_ = _loc12_;
                  _loc12_;
                  if(_loc6_.name == param3)
                  {
                     if(param4 == "m" && _loc6_.isActive)
                     {
                        Pet.petRemove(this.pet_array,_loc6_,true);
                        _loc6_.setActiveMount();
                     }
                     else if(_loc6_.mode == "m" && _loc6_.isActive)
                     {
                        _loc5_.bodyAnimator.gotoAndPlay("standing");
                        _loc5_.bodyAnimator.removeMountedPet();
                        this.pet_array.push(_loc6_);
                        _loc7_ = int(SortDepths.getLowestChildIndex(Vector.<starling.display.DisplayObject>(GiveHealthBar.healthBG_array)));
                        if(_loc7_ != int.MAX_VALUE)
                        {
                           this.starlingStage.c_mc.addChildAt(_loc6_,_loc7_);
                        }
                        else
                        {
                           this.starlingStage.c_mc.addChild(_loc6_);
                        }
                     }
                     _loc6_.mode = param4;
                     _loc6_.moveMode = Stats.petModes[_loc6_.mode].moveMode;
                     break;
                  }
               }
               break;
            }
         }
         if(param2 == this.player.name)
         {
            SoundManager.playSound(SoundLibrary.itemBought_sound);
         }
      }
      
      private function petItemEquipped(param1:Message, param2:String, param3:String, param4:int, param5:int) : void
      {
         this.len = this.p_array.length;
         this.i = 0;
         while(this.i < this.len)
         {
            if(this.p_array[this.i].name == param2 && CommonCalls.returnObject(this.p_array[this.i].pet_array,param3) != null)
            {
               if(this.p_array[this.i].name == this.player.name && (param4 != 2 || param5 != 24))
               {
                  if(Pet(CommonCalls.returnObject(this.p_array[this.i].pet_array,param3)).helmet_uint != 2 && Pet(CommonCalls.returnObject(this.p_array[this.i].pet_array,param3)).helmet_uint != param4)
                  {
                     this.personItem_array.push(Pet(CommonCalls.returnObject(this.p_array[this.i].pet_array,param3)).helmet_string);
                  }
                  else if(Pet(CommonCalls.returnObject(this.p_array[this.i].pet_array,param3)).shoes_uint != 24 && Pet(CommonCalls.returnObject(this.p_array[this.i].pet_array,param3)).shoes_uint != param5)
                  {
                     this.personItem_array.push(Pet(CommonCalls.returnObject(this.p_array[this.i].pet_array,param3)).shoes_string);
                  }
                  if(Pet(CommonCalls.returnObject(this.p_array[this.i].pet_array,param3)).helmet_uint != param4)
                  {
                     Pet(CommonCalls.returnObject(this.p_array[this.i].pet_array,param3)).helmet_uint = param4;
                     this.arrayStringRemove(this.personItem_array,Pet(CommonCalls.returnObject(this.p_array[this.i].pet_array,param3)).helmet_string);
                  }
                  else if(Pet(CommonCalls.returnObject(this.p_array[this.i].pet_array,param3)).shoes_uint != param5)
                  {
                     Pet(CommonCalls.returnObject(this.p_array[this.i].pet_array,param3)).shoes_uint = param5;
                     this.arrayStringRemove(this.personItem_array,Pet(CommonCalls.returnObject(this.p_array[this.i].pet_array,param3)).shoes_string);
                  }
               }
               else if(this.p_array[this.i].name == this.player.name && (param4 == 2 || param5 == 24))
               {
                  if(Pet(CommonCalls.returnObject(this.p_array[this.i].pet_array,param3)).helmet_uint != param4 && param4 == 2)
                  {
                     this.personItem_array.push(Pet(CommonCalls.returnObject(this.p_array[this.i].pet_array,param3)).helmet_string);
                  }
                  else if(Pet(CommonCalls.returnObject(this.p_array[this.i].pet_array,param3)).shoes_uint != param5 && param5 == 24)
                  {
                     this.personItem_array.push(Pet(CommonCalls.returnObject(this.p_array[this.i].pet_array,param3)).shoes_string);
                  }
               }
               Pet(CommonCalls.returnObject(this.p_array[this.i].pet_array,param3)).helmet_uint = param4;
               Pet(CommonCalls.returnObject(this.p_array[this.i].pet_array,param3)).shoes_uint = param5;
               break;
            }
            ++this.i;
         }
         if(this.player.name == param2 && StarlingGameMenu.menu_array.indexOf(this.petItemMenu) > -1)
         {
            this.petItemMenu.petClone.helmet_uint = param4;
            this.petItemMenu.petClone.shoes_uint = param5;
            this.petItemMenu.updateMe(this.maxItems,this.personItem_array,this.player);
            SetHue.tintObject(this.petItemMenu,16777215);
            this.petItemMenu.equip_btn.visible = false;
            this.petItemMenu.unEquip_btn.visible = false;
            if(StarlingGameMenu.menu_array.indexOf(this.petMenu) > -1)
            {
               this.petMenu.updateMe();
               SetHue.tintObject(this.petMenu,16777215);
               if(this.petMenu.selectedPetName == param3)
               {
                  this.petMenu.petClone.helmet_uint = param4;
               }
               if(this.petMenu.selectedPetName == param3)
               {
                  this.petMenu.petClone.shoes_uint = param5;
               }
               SoundManager.playSound(param4 != 2 ? SoundLibrary.itemBought_sound : SoundLibrary.itemSold_sound);
            }
         }
      }
      
      private function petHealedGot(param1:Message, param2:String, param3:String, param4:int) : void
      {
         var _loc5_:Pet = null;
         var _loc6_:PetOrb = null;
         _loc5_ = null;
         _loc6_ = null;
         this.len = this.p_array.length;
         this.i = 0;
         while(this.i < this.len)
         {
            if(this.p_array[this.i].name == param2)
            {
               for each(var _loc9_ in this.p_array[this.i].pet_array)
               {
                  _loc5_ = _loc9_;
                  _loc9_;
                  if(_loc5_.name == param3)
                  {
                     this.a = 0;
                     for each(var _loc11_ in PetOrb.petOrb_array)
                     {
                        _loc6_ = _loc11_;
                        _loc11_;
                        if(_loc6_.petName == param3)
                        {
                           ++this.a;
                        }
                     }
                     if(this.a == 0 && _loc5_.isActive == false)
                     {
                        this.createPetOrb(_loc5_.getOrbBonus(),_loc5_.name,_loc5_.owner.name,_loc5_.lvl,_loc5_.type,_loc5_.owner.hasOrbFocus);
                     }
                     _loc5_.health = param4;
                     _loc5_.health = _loc5_.health > _loc5_.totalHealth ? _loc5_.totalHealth : _loc5_.health;
                     if(_loc5_.isActive && _loc5_.parent != null && _loc5_.mode != "m" && Boolean(CommonCalls.onScreen(_loc5_.x,_loc5_.y,false,true)))
                     {
                        SetHue.tintObject(_loc5_,16777215);
                     }
                     break;
                  }
               }
               break;
            }
            ++this.i;
         }
         if(param2 == this.player.name && GameMenu.menu_array.indexOf(this.petMenu) > -1)
         {
            this.petMenu.updateMe();
            this.petMenu.selectPet(null,param3);
         }
      }
      
      private function petInfoGot(param1:Message, param2:String, param3:int, param4:int) : void
      {
         var _loc5_:Person = null;
         var _loc6_:Pet = null;
         _loc5_ = null;
         _loc6_ = null;
         loop0:
         for each(var _loc9_ in this.p_array)
         {
            _loc5_ = _loc9_;
            _loc9_;
            for each(var _loc11_ in _loc5_.pet_array)
            {
               _loc6_ = _loc11_;
               _loc11_;
               if(_loc6_.name == param2 && _loc6_.mode != "m" && (_loc6_.owner.isControllingPet == false || _loc6_.owner.name != this.player.name))
               {
                  if(CalcDist.getDistNumbers(_loc6_.x,_loc6_.y,param3,param4) > 110)
                  {
                     _loc6_.x = param3 - _loc6_.width / 2 + 10;
                     _loc6_.y = param4 - _loc6_.height / 2 + 10;
                     _loc6_.gravityObject.hit_rect.x = _loc6_.x + _loc6_.gravityObject.hitOffsetX;
                     _loc6_.gravityObject.hit_rect.y = _loc6_.y + _loc6_.gravityObject.hitOffsetY;
                  }
                  break loop0;
               }
            }
         }
      }
      
      private function checkPetEvolution(param1:Message, param2:String, param3:String) : void
      {
         var _loc4_:Pet = null;
         _loc4_ = null;
         for each(var _loc7_ in this.player.pet_array)
         {
            _loc4_ = _loc7_;
            _loc7_;
            if(_loc4_.name == param2)
            {
               this.createAlertMenu(param2 + " can evolve","Your " + _loc4_.type + " would like to evolve into a " + param3 + ".",true,_loc4_,true);
               break;
            }
         }
      }
      
      private function petEvolved(param1:Message, param2:String, param3:String, param4:Boolean = false) : void
      {
         var _loc5_:Pet = null;
         var _loc6_:Pet = null;
         _loc5_ = null;
         _loc6_ = null;
         for each(var _loc9_ in this.pet_array)
         {
            _loc5_ = _loc9_;
            _loc9_;
            if(_loc5_.name == param2)
            {
               _loc5_.evolveMe(param3);
               if(_loc5_.owner.name == this.player.name)
               {
                  if(param4)
                  {
                     this.arrayStringRemove(this.personItem_array,"evolution crystal");
                  }
                  if(StarlingGameMenu.menu_array.indexOf(this.petMenu) > -1)
                  {
                     StarlingGameMenu.focusMenu(this.petMenu);
                     StarlingGameMenu.removeFocusMenu();
                  }
                  if(StarlingGameMenu.menu_array.indexOf(this.petItemMenu) > -1)
                  {
                     StarlingGameMenu.focusMenu(this.petItemMenu);
                     StarlingGameMenu.removeFocusMenu();
                  }
                  return;
               }
               break;
            }
         }
         for each(_loc9_ in this.player.pet_array)
         {
            _loc6_ = _loc9_;
            _loc9_;
            if(_loc6_.name == param2)
            {
               _loc6_.type = param3;
               SoundManager.playSound(SoundLibrary.petEvolve_sound);
               if(param4)
               {
                  this.arrayStringRemove(this.personItem_array,"evolution crystal");
               }
               if(StarlingGameMenu.menu_array.indexOf(this.petMenu) > -1)
               {
                  StarlingGameMenu.focusMenu(this.petMenu);
                  StarlingGameMenu.removeFocusMenu();
               }
               if(StarlingGameMenu.menu_array.indexOf(this.petItemMenu) > -1)
               {
                  StarlingGameMenu.focusMenu(this.petItemMenu);
                  StarlingGameMenu.removeFocusMenu();
               }
               break;
            }
         }
      }
      
      private function getPetLove(param1:Message, param2:String, param3:*) : void
      {
         if(CommonCalls.returnObject(this.player.pet_array,param2) != null)
         {
            CommonCalls.returnObject(this.player.pet_array,param2).love = param3;
         }
      }
      
      private function getAlert(param1:Message, param2:String, param3:Boolean = false, param4:Boolean = false) : void
      {
         this.createAlert(param2,param3,param4);
      }
      
      private function getPetModeToggled(param1:Message, param2:String, param3:Boolean) : void
      {
         var _loc4_:Person = null;
         _loc4_ = null;
         for each(var _loc7_ in this.p_array)
         {
            _loc4_ = _loc7_;
            _loc7_;
            if(_loc4_.name == param2)
            {
               if(param3 != _loc4_.isControllingPet)
               {
                  _loc4_.togglePetControl();
               }
               break;
            }
         }
      }
      
      private function gotSinglePing(param1:Message, param2:String, param3:int) : void
      {
         if(this.debugMenu != null && this.debugMenu.parent != null)
         {
            this.addDebugText(param2 + ": " + String(param3) + "ms");
         }
      }
      
      private function shoutGot(param1:Message, param2:uint, param3:String, param4:String) : void
      {
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         _loc5_ = false;
         _loc6_ = null;
         _loc5_ = false;
         for each(var _loc9_ in this.receivedShouts_array)
         {
            _loc6_ = _loc9_;
            _loc9_;
            if(_loc6_ == param4 + ": " + param3)
            {
               _loc5_ = true;
               break;
            }
         }
         if(_loc5_ == false)
         {
            this.starlingStage.controls.createShout(param3,param4,param2);
            this.receivedShouts_array.push(param4 + ": " + param3);
         }
      }
      
      private function itemDescsLoaded(param1:Array, param2:Boolean = false) : void
      {
         var _loc3_:Object = null;
         _loc3_ = null;
         if(param1 != null)
         {
            Stats.itemDescsLoaded = true;
            for each(var _loc6_ in param1)
            {
               _loc3_ = _loc6_;
               _loc6_;
               if(_loc3_.key != undefined)
               {
                  _loc3_.n = _loc3_.key;
               }
               Stats.allItemDescs[_loc3_.n] = {};
               Stats.allItemDescs[_loc3_.n].desc = _loc3_.d;
            }
            if(param2 == false)
            {
               this.dbItems_sharedObject.data.itemDescs = param1;
               try
               {
                  this.dbItems_sharedObject.flush();
               }
               catch(_error:Error)
               {
               }
            }
            if(Stats.allItemsAndEnemiesLoaded)
            {
               this.init_txt.text = "";
            }
         }
      }
      
      private function vendorsLoaded(param1:Array) : void
      {
         var _loc2_:DatabaseObject = null;
         var _loc3_:VendingMachine = null;
         var _loc4_:* = undefined;
         _loc2_ = null;
         _loc3_ = null;
         _loc4_ = null;
         if(param1 != null)
         {
            for each(var _loc7_ in param1)
            {
               _loc2_ = _loc7_;
               _loc7_;
               _loc4_ = _loc2_.area;
               if(_loc4_ != undefined)
               {
                  if(int(_loc4_) != int(this.c_mc.currentFrame))
                  {
                     continue;
                  }
               }
               else if(this.c_mc.currentFrame != 56)
               {
                  continue;
               }
               _loc3_ = this.createVendor(_loc2_.key,_loc2_.player,_loc2_.x,_loc2_.y,Vector.<String>(_loc2_.items),Vector.<uint>(_loc2_.costs),_loc2_.tickets,_loc2_.tPrice);
               if(_loc2_.rot != undefined)
               {
                  _loc3_.rotation = deg2rad(_loc2_.rot);
                  _loc3_.y = _loc3_.y + 8;
               }
            }
         }
      }
      
      private function petVendorsLoaded(param1:Array) : void
      {
         var _loc2_:DatabaseObject = null;
         _loc2_ = null;
         if(param1 != null && this.c_mc.currentFrame == 98)
         {
            for each(var _loc5_ in param1)
            {
               _loc2_ = _loc5_;
               _loc5_;
               _loc2_.pet = _loc2_.pet != undefined ? _loc2_.pet : "";
               this.createPetVendor(_loc2_.key,_loc2_.player,_loc2_.x,_loc2_.y,_loc2_.pet);
               if(_loc2_.coins != undefined)
               {
                  this.petVendor.coins = _loc2_.coins;
               }
               if(_loc2_.tickets != undefined)
               {
                  this.petVendor.tickets = _loc2_.tickets;
               }
               if(_loc2_.rot != undefined)
               {
                  this.petVendor.rotation = _loc2_.rot;
               }
               if(_loc2_.pet != "")
               {
                  this.theClient.bigDB.load("petData",_loc2_.pet,this.petVendorPetLoaded);
               }
            }
         }
      }
      
      public function petVendorPetLoaded(param1:DatabaseObject) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = 0;
         _loc3_ = 0;
         if(this.c_mc.currentFrame == 98 && param1 != null)
         {
            this.len = this.starlingStage.c_mc.numChildren;
            this.i = 0;
            while(this.i < this.len)
            {
               if(this.starlingStage.c_mc.getChildAt(this.i) is PetVendor && PetVendor(this.starlingStage.c_mc.getChildAt(this.i)).petName == param1.key)
               {
                  PetVendor(this.starlingStage.c_mc.getChildAt(this.i)).showPet(param1.type,param1.helm,param1.shoe);
                  PetVendor(this.starlingStage.c_mc.getChildAt(this.i)).showClickToInteract();
                  PetVendor(this.starlingStage.c_mc.getChildAt(this.i)).petDBObject = param1;
                  if(PetVendor(this.starlingStage.c_mc.getChildAt(this.i)).petClone.height > PetVendor(this.starlingStage.c_mc.getChildAt(this.i)).petClone.width)
                  {
                     _loc2_ = int(PetVendor(this.starlingStage.c_mc.getChildAt(this.i)).coins);
                     _loc3_ = int(PetVendor(this.starlingStage.c_mc.getChildAt(this.i)).tickets);
                     PetVendor(this.starlingStage.c_mc.getChildAt(this.i)).cage_image.texture = Assets.items_textureAtlas.getTexture("pet cage tall");
                     PetVendor(this.starlingStage.c_mc.getChildAt(this.i)).cage_image.readjustSize();
                     PetVendor(this.starlingStage.c_mc.getChildAt(this.i)).cage_image.x = -47;
                     PetVendor(this.starlingStage.c_mc.getChildAt(this.i)).cage_image.y = -75;
                     PetVendor(this.starlingStage.c_mc.getChildAt(this.i)).coins = _loc2_;
                     PetVendor(this.starlingStage.c_mc.getChildAt(this.i)).tickets = _loc3_;
                  }
                  break;
               }
               ++this.i;
            }
         }
      }
      
      public function boughtVendorItem(param1:Message, param2:String, param3:uint, param4:String, param5:int) : void
      {
         this.theConnection.removeMessageHandler("boughtVItem",this.boughtVendorItem);
         if(param2 != "")
         {
            this.personItem_array.push(param2);
            this.player.money = this.player.money - param3;
            this.len = this.starlingStage.c_mc.numChildren;
            this.i = 0;
            while(this.i < this.len)
            {
               if(this.starlingStage.c_mc.getChildAt(this.i).name == param4)
               {
                  VendingMachine(this.starlingStage.c_mc.getChildAt(this.i)).items.removeAt(param5);
                  VendingMachine(this.starlingStage.c_mc.getChildAt(this.i)).costs.removeAt(param5);
                  VendingMachine(this.starlingStage.c_mc.getChildAt(this.i)).updateMe();
                  break;
               }
               ++this.i;
            }
            if(StarlingGameMenu.getFocusMenu() == this.itemMenu)
            {
               StarlingGameMenu.focusMenu(this.itemMenu);
               StarlingGameMenu.removeFocusMenu();
            }
            this.createAlert(param2 + " was successfully purchased",true);
            SoundManager.playSound(SoundLibrary.cashRegister_sound);
         }
         else
         {
            this.createAlert("purchase failed: try again, if not the item may have been sold");
         }
      }
      
      private function newVendorSet(param1:Message, param2:String, param3:int, param4:int, param5:String, param6:Number) : void
      {
         var _loc7_:VendingMachine = null;
         _loc7_ = null;
         if(param5 == this.theClient.connectUserId || param5 == this.player.name)
         {
            this.createAlert("successfully created vendor",true);
            this.vectorStringRemove(this.personItem_array,"item vendor");
            this.itemMenu.updateMe(this.maxItems,this.personItem_array,this.player);
         }
         _loc7_ = this.createVendor(param2,param5,param3,param4,new Vector.<String>(),new Vector.<uint>(),0,0);
         _loc7_.rotation = deg2rad(param6);
      }
      
      private function newPetVendorSet(param1:Message, param2:String, param3:int, param4:int, param5:String, param6:Number) : void
      {
         if(param5 == this.theClient.connectUserId || param5 == this.player.name)
         {
            this.createAlert("successfully created pet vendor",true);
            this.vectorStringRemove(this.personItem_array,"pet vendor");
            this.itemMenu.updateMe(this.maxItems,this.personItem_array,this.player);
         }
         this.createPetVendor(param2,param5,param3,param4);
         this.petVendor.rotation = param6;
      }
      
      private function newVItemAdded(param1:Message, param2:String, param3:String, param4:uint) : void
      {
         this.len = this.starlingStage.c_mc.numChildren;
         this.i = 0;
         while(this.i < this.len)
         {
            if(this.starlingStage.c_mc.getChildAt(this.i) is VendingMachine && VendingMachine(this.starlingStage.c_mc.getChildAt(this.i)).name == param3)
            {
               VendingMachine(this.starlingStage.c_mc.getChildAt(this.i)).items.push(param2);
               VendingMachine(this.starlingStage.c_mc.getChildAt(this.i)).costs.push(param4);
               break;
            }
            ++this.i;
         }
      }
      
      private function boughtVendorTickets(param1:Message, param2:String, param3:uint, param4:String) : void
      {
         if(this.starlingStage.c_mc.getChildByName(param4) != null)
         {
            VendingMachine(this.starlingStage.c_mc.getChildByName(param4)).tickets = VendingMachine(this.starlingStage.c_mc.getChildByName(param4)).tickets - param3;
            Person(CommonCalls.returnObject(this.p_array,param2)).money = Person(CommonCalls.returnObject(this.p_array,param2)).money - param3 * VendingMachine(this.starlingStage.c_mc.getChildByName(param4)).ticketPrice;
            if(param2 == this.player.name)
            {
               this.createAlert(String(param3) + " tickets successfully purchased from vendor",true);
            }
         }
      }
      
      private function noCharMade(param1:Message) : void
      {
         this.theConnection.removeMessageHandler("noCharMade",this.noCharMade);
         this.mMenu.visible = false;
         this.createCreateMenu();
         this.charCreateMenu.emailNotice_txt.visible = false;
         this.charCreateMenu.passwordColon_txt.visible = this.charCreateMenu.password_txt.visible = this.charCreateMenu.emailColon_txt.visible = this.charCreateMenu.email_txt.visible = false;
         this.charCreateMenu.passBorder.removeFromParent(true);
         this.charCreateMenu.emailBorder.removeFromParent(true);
         this.charCreateMenu.password_txt.text = "facebook";
         this.createTransition();
      }
      
      private function spawnBallInfoGot(param1:Message, param2:String, param3:int, param4:int, param5:String) : void
      {
         this.createItem(param5,param3,param4,param2,0,"-none-");
      }
      
      private function fishCreatedGot(param1:Message, param2:String, param3:int, param4:int, param5:String, param6:Boolean) : void
      {
         var _loc7_:Point = null;
         _loc7_ = null;
         _loc7_ = new Point(param3,param4);
         this.starlingStage.c_mc.globalToLocal(_loc7_,_loc7_);
         _loc7_.x = _loc7_.x + this.c_mc.x;
         _loc7_.y = _loc7_.y + this.c_mc.y;
         this.createFish(_loc7_.x,_loc7_.y,param2);
         Fish.newFish_array[Fish.newFish_array.length - 1].name = param5;
         Fish.newFish_array[Fish.newFish_array.length - 1].shiny = param6;
      }
      
      private function serverCounterGot(param1:Message, param2:int) : void
      {
         this.serverCounter = param2 + this.player.ping / 2 / 33.33;
      }
      
      private function newBeholderCannonGot(param1:Message, param2:int, param3:int) : void
      {
         var _loc4_:ShootingObject = null;
         _loc4_ = null;
         if(this.c_mc.currentFrame == 116)
         {
            _loc4_ = new BeholderCannon();
            _loc4_.x = param2;
            _loc4_.y = param3;
            this.shootingObject_array.push(_loc4_);
            this.c_mc.addChildAt(_loc4_,0);
            TweenMax.from(_loc4_,0.8,{
               "x":param2 + 110,
               "ease":Linear.easeNone
            });
            TweenMax.from(_loc4_,0.06,{
               "alpha":0,
               "delay":0.6,
               "ease":Linear.easeNone
            });
         }
      }
      
      private function beholderCannonRemoved(param1:Message, param2:int) : void
      {
         this.len = this.shootingObject_array.length;
         this.i = 0;
         while(this.i < this.len)
         {
            if(this.shootingObject_array[this.i].currentLabel == "beholder cannon" && int(this.shootingObject_array[this.i].y) == param2)
            {
               TweenMax.to(this.shootingObject_array[this.i],0.7,{
                  "x":this.shootingObject_array[this.i].x + 120,
                  "ease":Linear.easeNone,
                  "onComplete":CommonCalls.removeObject,
                  "onCompleteParams":[this.shootingObject_array[this.i]]
               });
               this.shootingObject_array.removeAt(this.i);
               break;
            }
            ++this.i;
         }
      }
      
      private function lotteryTicketsLoaded(param1:Array) : void
      {
         var _loc2_:DatabaseObject = null;
         _loc2_ = null;
         if(this.c_mc.currentFrame == 83)
         {
            this.lotteryTicketJackpot = 0;
            for each(var _loc5_ in param1)
            {
               _loc2_ = _loc5_;
               _loc5_;
               this.lotteryTicketJackpot = this.lotteryTicketJackpot + _loc2_.tickets;
            }
            starling.text.TextField(this.starlingStage.c_mc.getChildByName("lotteryTickets_txt")).text = String(uint(this.lotteryTicketJackpot * 0.65));
         }
      }
      
      private function lotteryCoinsLoaded(param1:Array) : void
      {
         var _loc2_:DatabaseObject = null;
         _loc2_ = null;
         if(this.c_mc.currentFrame == 83)
         {
            this.lotteryCoinJackpot = 0;
            for each(var _loc5_ in param1)
            {
               _loc2_ = _loc5_;
               _loc5_;
               this.lotteryCoinJackpot = this.lotteryCoinJackpot + _loc2_.coins;
            }
            starling.text.TextField(this.starlingStage.c_mc.getChildByName("lotteryCoins_txt")).text = String(uint(this.lotteryCoinJackpot * 0.65));
         }
      }
      
      private function lotteryWinnersLoaded(param1:DatabaseObject) : void
      {
         if(this.c_mc.currentFrame == 83)
         {
            this.i = 0;
            while(this.i < 4)
            {
               if(param1.winners[this.i] != undefined)
               {
                  starling.text.TextField(this.starlingStage.c_mc.getChildByName("winners_txt")).text = starling.text.TextField(this.starlingStage.c_mc.getChildByName("winners_txt")).text + (param1.winners[this.i] + "\n");
                  starling.text.TextField(this.starlingStage.c_mc.getChildByName("winnings_txt")).text = starling.text.TextField(this.starlingStage.c_mc.getChildByName("winnings_txt")).text + (param1.winnings[this.i] + "\n");
               }
               ++this.i;
            }
         }
      }
      
      private function newLotteryPurchase(param1:Message, param2:uint, param3:uint, param4:String) : void
      {
         if(param4 == this.player.name)
         {
            this.createAlert("Successfully bought lottery entries",true);
            this.player.tickets = this.player.tickets - param2;
            this.player.money = this.player.money - param3;
         }
      }
      
      private function lotteryInfoLoaded(param1:DatabaseObject) : void
      {
         this.lotteryEndDate = param1.startTime;
         this.lotteryEndDate.date = this.lotteryEndDate.date + 3;
      }
      
      private function fishStatsLoaded(param1:Array, param2:Boolean = false) : void
      {
         var _loc3_:Object = null;
         _loc3_ = null;
         if(param1 != null)
         {
            Stats.fishStatsLoaded = true;
            for each(var _loc6_ in param1)
            {
               _loc3_ = _loc6_;
               _loc6_;
               if(_loc3_.key != undefined)
               {
                  _loc3_.n = _loc3_.key;
               }
               Stats.setFishStats(_loc3_.n,_loc3_.t,_loc3_.r,_loc3_.pow,_loc3_.rng,_loc3_.art,_loc3_.mgc);
            }
            if(param2 == false)
            {
               this.dbItems_sharedObject.data.fishStats = param1;
               try
               {
                  this.dbItems_sharedObject.flush();
               }
               catch(_error:Error)
               {
               }
            }
         }
      }
      
      private function fishRemovedGot(param1:Message, param2:String, param3:String) : void
      {
         var catcher:Person = null;
         var tempFishString:String = null;
         var showNewEntry:Boolean = false;
         var _fishInfo:Object = null;
         var _m:Message = param1;
         var _catcherName:String = param2;
         var _fishName:String = param3;
         catcher = null;
         tempFishString = null;
         showNewEntry = false;
         catcher = Person(CommonCalls.returnObject(this.p_array,_catcherName));
         this.len = Fish.newFish_array.length;
         this.i = 0;
         while(this.i < this.len)
         {
            if(Fish.newFish_array[this.i].name == _fishName)
            {
               _fishInfo = Stats.fishStats[Fish.newFish_array[this.i].type];
               if(catcher != null && _fishInfo != undefined)
               {
                  catcher.fishXP = catcher.fishXP + Math.ceil(_fishInfo.cost / 50);
                  this.saveProficiency();
               }
               if(catcher != null && catcher.isPlayer)
               {
                  this.player.energyController.fish = this.player.energyController.fish + 0.005;
                  tempFishString = (Fish.newFish_array[this.i].shiny == false ? "" : "shiny ") + Fish.newFish_array[this.i].type;
                  this.personItem_array.push(tempFishString);
                  this.createXPText(_fishInfo != undefined ? int(Math.ceil(_fishInfo.cost / 50)) : 0,this.player.x,this.player.y," fish ");
                  if(this.fishList_array.indexOf(tempFishString) == -1)
                  {
                     showNewEntry = false;
                     if(Fish.newFish_array[this.i].shiny == false)
                     {
                        if(this.fishList_array.indexOf("shiny " + Fish.newFish_array[this.i].type) == -1)
                        {
                           this.fishList_array.push(tempFishString);
                           showNewEntry = true;
                        }
                     }
                     else
                     {
                        this.j = 0;
                        while(this.j < this.fishList_array.length)
                        {
                           if(this.fishList_array[this.j] == Fish.newFish_array[this.i].type)
                           {
                              this.fishList_array[this.j] = tempFishString;
                              showNewEntry = true;
                              break;
                           }
                           ++this.j;
                        }
                     }
                     if(showNewEntry)
                     {
                        this.createNewHeroEntry(tempFishString + " info");
                        this.starlingStage.controls.blinkHeropediaButton = true;
                        this.theClient.bigDB.load("pMiscTable",this.player.name,function(param1:DatabaseObject):void
                        {
                           if(loadedPlayerMiscSuccess)
                           {
                              param1.fishList = fishList_array.toString();
                              param1.save();
                           }
                        });
                     }
                  }
               }
               Fish.newFish_array[this.i].removeFromParent(true);
               Fish.newFish_array.removeAt(this.i);
               break;
            }
            ++this.i;
         }
      }
      
      private function roomNameGot(param1:Message, param2:int) : void
      {
         if(this.debugMenu != null && this.debugMenu.parent != null)
         {
            this.addDebugText("Unique Room int: " + param2);
         }
         this.theConnection.removeMessageHandler("gotRoomInfo",this.roomNameGot);
      }
      
      private function treeGot(param1:Message, param2:String, param3:String, param4:int, param5:int, param6:int, param7:Boolean) : void
      {
         this.createTree(param3,param2,param4,param5,param7,param6);
      }
      
      private function treeDamagedGot(param1:Message, param2:String, param3:int, param4:String, param5:Boolean) : void
      {
         var _loc6_:Tree = null;
         _loc6_ = null;
         for each(var _loc9_ in Tree.tree_array)
         {
            _loc6_ = _loc9_;
            _loc9_;
            if(_loc6_.name == param2)
            {
               _loc6_.damageMe(this.player,param5,param3,param4);
               break;
            }
         }
         if(param4 == this.player.name)
         {
            this.player.energyController.chop = this.player.energyController.chop + 0.005;
         }
      }
      
      public function itemDepositDone(param1:Message, param2:Boolean, param3:String) : void
      {
         this.theConnection.removeMessageHandler("tryBankItemDep",this.itemDepositDone);
         if(param2)
         {
            this.arrayStringRemove(this.personItem_array,param3);
            SoundManager.playSound(SoundLibrary.itemSold_sound);
         }
         else
         {
            this.createAlert("not enough room in bank inventory");
         }
         if(StarlingGameMenu.menu_array.indexOf(this.itemMenu) > -1)
         {
            this.itemMenu.touchable = true;
            this.itemMenu.alpha = 1;
            this.itemMenu.updateMe(this.maxItems,this.personItem_array,this.player);
         }
      }
      
      private function passCheckLoaded(param1:flash.events.Event) : void
      {
         param1.target.removeEventListener(flash.events.Event.COMPLETE,this.passCheckLoaded);
         if(this.mMenu != null && this.mMenu.parent != null && this.mMenu.currentLabel == "server password")
         {
            this.mMenu.serverPassConfirm_btn.visible = true;
            if(param1.target.data == "true")
            {
               this.mMenu.valid_txt.text = "good";
               if(this.hasMainEnterFrameListener == false)
               {
                  this.gotoMainMenuFrame(1);
               }
               else
               {
                  this.serverName = this.mMenu.serverName_txt.text;
                  this.i = 0;
                  while(this.i < 9)
                  {
                     if(Stats.levelStats[this.c_mc.currentFrame]["portal" + (this.i + 1) + "Lead"] > 0)
                     {
                        ++this.counter;
                        this.changeLevel(this.c_mc.currentFrame,"portal" + (this.i + 1),false);
                        this.len2 = PetOrb.petOrb_array.length;
                        this.j = this.len2 - 1;
                        while(this.j >= 0)
                        {
                           if(PetOrb(PetOrb.petOrb_array[this.j]).creator.isPlayer == false)
                           {
                              PetOrb.petOrb_array[this.j].removeFromParent(true);
                              PetOrb.petOrb_array.removeAt(this.j);
                           }
                           --this.j;
                        }
                        break;
                     }
                     ++this.i;
                  }
                  removeChild(this.mMenu);
               }
            }
            else
            {
               this.mMenu.valid_txt.text = "invalid password";
            }
         }
      }
      
      private function removePetVendor(param1:Message, param2:String, param3:String) : void
      {
         if(this.c_mc.currentFrame == 98)
         {
            this.len2 = this.c_mc.numChildren;
            this.j = 0;
            while(this.j < this.len2)
            {
               if(this.c_mc.getChildAt(this.j) is PetVendor && PetVendor(this.c_mc.getChildAt(this.j)).name == param2)
               {
                  this.c_mc.removeChildAt(this.j);
                  if(param3 == this.player.name)
                  {
                     this.createPetFromDBObject(PetVendor(this.c_mc.getChildAt(this.j)).petDBObject);
                     this.createAlert("You have adopted " + PetVendor(this.c_mc.getChildAt(this.j)).petDBObject.key + "!",true);
                  }
                  break;
               }
               ++this.j;
            }
         }
      }
      
      private function startRoboCityInvasion(param1:Message, param2:Boolean = false) : void
      {
         var bitmap:Bitmap = null;
         var _m:Message = param1;
         var _alreadyHappening:Boolean = param2;
         var tempTweenTime:Number = Number(NaN);
         bitmap = null;
         if(this.c_mc.currentFrame == 30 && this.roboInvasionActive == false)
         {
            tempTweenTime = _alreadyHappening == false ? 5 : 0.1;
            this.roboInvasionActive = true;
            this.theConnection.removeMessageHandler("roboInvasion",this.startRoboCityInvasion);
            bitmap = new Bitmap(new BitmapData(this.mainStarling.viewPort.width,this.mainStarling.viewPort.height,false,0));
            bitmap.alpha = 0.3;
            bitmap.name = "darkOverlay_bitmap";
            addChild(bitmap);
            TweenMax.from(bitmap,1,{
               "alpha":0,
               "ease":Linear.easeNone
            });
            setTimeout(function():*
            {
               if(c_mc.currentFrame == 30)
               {
                  SoundManager.playSound(Assets.main_assetManager.getSound("sirem alarm sound"),c_mc.alarm1_mc.x,c_mc.alarm1_mc.y,true,starlingStage.c_mc,true,"siren alarm");
                  c_mc.alarm1_mc.visible = true;
                  TweenMax.to(c_mc.alarm1_mc,1.5,{"y":c_mc.alarm1_mc.y - 36});
                  c_mc.alarm2_mc.visible = true;
                  TweenMax.to(c_mc.alarm2_mc,1.5,{"y":c_mc.alarm2_mc.y - 36});
               }
            },_alreadyHappening == false ? 1000 : 10);
         }
      }
      
      private function endRoboCityInvasion(param1:Message, param2:Number = 3) : void
      {
         var n_makeInvisible:Function = null;
         var _m:Message = param1;
         var _fadeTime:Number = param2;
         n_makeInvisible = null;
         n_makeInvisible = function():void
         {
            c_mc.alarm1_mc.visible = c_mc.alarm2_mc.visible = false;
         };
         if(this.c_mc.currentFrame != 38)
         {
            this.theConnection.removeMessageHandler("endRoboInv",this.endRoboCityInvasion);
         }
         this.roboInvasionActive = false;
         SoundManager.stopLoopedSound("siren alarm",true);
         removeChild(getChildByName("darkOverlay_bitmap"));
         if(this.c_mc.currentFrame == 38)
         {
            TweenMax.to(this.c_mc.alarm1_mc,1.5,{
               "y":this.c_mc.alarm1_mc.y + 36,
               "onComplete":n_makeInvisible
            });
            TweenMax.to(this.c_mc.alarm2_mc,1.5,{"y":this.c_mc.alarm2_mc.y + 36});
         }
      }
      
      private function petsSummonedForward(param1:Message) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Person = null;
         var _loc4_:Pet = null;
         var _loc5_:int = 0;
         _loc2_ = 0;
         _loc3_ = null;
         _loc4_ = null;
         _loc5_ = 0;
         _loc2_ = uint(param1.length);
         _loc3_ = Person(CommonCalls.returnObject(this.p_array,param1.getString(0)));
         if(_loc3_ != null)
         {
            this.i = 2;
            while(this.i < _loc2_)
            {
               _loc4_ = new Pet(this,param1.getString(this.i + 2),param1.getString(this.i));
               _loc4_.x = _loc3_.x;
               _loc4_.y = _loc3_.y + 20;
               _loc4_.helmet_uint = param1.getInt(this.i + 1);
               _loc4_.shoes_uint = param1.getInt(this.i + 3);
               _loc4_.scaleX = _loc3_.scaleX;
               _loc4_.gotoAndPlayWalking();
               _loc4_.owner = _loc3_;
               _loc4_.addEventListener(flash.events.Event.ENTER_FRAME,_loc4_.onSummonPetEnter);
               _loc5_ = int(SortDepths.getLowestChildIndex(Vector.<starling.display.DisplayObject>(GiveHealthBar.healthBG_array)));
               if(_loc5_ != int.MAX_VALUE)
               {
                  this.starlingStage.c_mc.addChildAt(_loc4_,_loc5_);
               }
               else
               {
                  this.starlingStage.c_mc.addChild(_loc4_);
               }
               TweenMax.to(_loc4_,0.5,{
                  "x":_loc4_.x + 250 * _loc4_.scaleX,
                  "delay":(this.i - 2) / 20,
                  "onComplete":_loc4_.removeFromParent,
                  "onCompleteParams":[true]
               });
               setTimeout(_loc4_.doLeapAttack,(this.i - 2) * 50);
               this.i += 4;
            }
         }
      }
      
      private function enemyControlled(param1:Message, param2:String, param3:String) : void
      {
         var _loc4_:Enemy = null;
         var _loc5_:Person = null;
         if(param3 == this.player.name)
         {
            return;
         }
         _loc4_ = null;
         _loc5_ = null;
         for each(var _loc8_ in this.e_array)
         {
            _loc4_ = _loc8_;
            _loc8_;
            if(_loc4_.name == param2)
            {
               for each(var _loc10_ in this.p_array)
               {
                  _loc5_ = _loc10_;
                  _loc10_;
                  if(_loc5_.name == param3)
                  {
                     _loc4_.controlMe(_loc5_);
                     break;
                  }
               }
               break;
            }
         }
      }
      
      private function enemyNoControl(param1:Message, param2:String) : void
      {
         var _loc3_:Enemy = null;
         _loc3_ = null;
         for each(var _loc6_ in this.e_array)
         {
            _loc3_ = _loc6_;
            _loc6_;
            if(_loc3_.name == param2)
            {
               _loc3_.noControlMe();
               break;
            }
         }
      }
      
      private function energyChargeGot(param1:Message, param2:String, param3:Number, param4:Number) : void
      {
         var _loc5_:Person = null;
         _loc5_ = null;
         for each(var _loc8_ in this.p_array)
         {
            _loc5_ = _loc8_;
            _loc8_;
            if(_loc5_.name == param2)
            {
               _loc5_.energyController.fakeFullTotal = param4;
               break;
            }
         }
      }
      
      private function modPayingUserCheckDone(param1:Message, param2:uint, param3:String) : void
      {
         if(this.moderatorMenu.parent != null)
         {
            this.moderatorMenu.modPaying_txt.text = param3 + " has bought at least " + param2 + " tickets.";
         }
      }
      
      private function ipLoaded(param1:flash.events.Event) : void
      {
         this.country = param1.target.data.country;
         param1.target.removeEventListener(flash.events.Event.COMPLETE,this.ipLoaded);
      }
      
      private function fraudCheckGot(param1:Message, param2:String) : void
      {
         var _loc3_:Object = null;
         _loc3_ = null;
         _loc3_ = JSON.parse(param2);
         if(_loc3_.response.params.status == "Refunded")
         {
            this.player.personHackCheck.banKillPlayer(true,"Autobanned for Steam refund");
         }
         else if(_loc3_.response.params.country == "PH")
         {
            this.player.personHackCheck.banKillPlayer(true,"Autobanned for Steam PH purchase");
         }
      }
      
      public function handleText() : void
      {
         var _loc1_:Pet = null;
         _loc1_ = null;
         if(this.talkBox != null && this.talkBox.parent != null)
         {
            if(this.talkBox.talk_txt.text != this.talkBox.fullText_string)
            {
               TalkText.removeTextListener();
               this.talkBox.talk_txt.text = this.talkBox.fullText_string;
               return;
            }
            TweenMax.to(this.talkBox,0.3,{
               "scaleY":0.1,
               "ease":Back.easeIn,
               "onComplete":this.talkBox.removeFromParent,
               "onCompleteParams":[true]
            });
            switch(this.talkBox.talkID)
            {
               case 6:
                  if(isMobile == false)
                  {
                     this.createTutorial();
                     stage.focus = null;
                  }
                  else
                  {
                     this.allowDamage = true;
                  }
                  break;
               case 7:
                  this.createMissionAni("The Black Hooded Hatchet");
                  break;
               case 8:
                  this.createTalkBox(0,this.c_mc.dude3_mc,"If you see someone else who you would like to talk to, use the bar located at the bottom to type your message.");
                  break;
               case 9:
                  this.theConnection.send("pHealed",this.player.totalHealth - this.player.health,this.player.totalMP - this.player.MP);
                  this.theConnection.send("npcHealPets");
                  this.player.health = this.player.totalHealth;
                  this.player.MP = this.player.totalMP;
                  SetHue.tintObject(this.player,16777215);
                  this.createWhite();
                  for each(var _loc4_ in this.player.pet_array)
                  {
                     _loc1_ = _loc4_;
                     _loc4_;
                     _loc1_.health = _loc1_.totalHealth;
                  }
                  if(StarlingGameMenu.menu_array.indexOf(this.petMenu) > -1)
                  {
                     StarlingGameMenu.focusMenu(this.petMenu);
                     StarlingGameMenu.removeFocusMenu();
                  }
                  break;
               case 10:
                  this.createMissionCompleteAni("The Black Hooded Hatchet");
                  if(this.playingURL_string == "miniplay.com")
                  {
                     MiniPlay.lechuck.stat.put(null,"unlock_hooded",Stats.missionStats["The Black Hooded Hatchet"].completed);
                  }
                  else if(Steam.onSteam)
                  {
                     Steam.steam.setAchievement("BLACK_HOODED_HATCHET");
                  }
                  else if(this.playingURL_string == "ungrounded.net" && Boolean(Newgrounds.isReady))
                  {
                     Newgrounds.completeAchievement("Black Hooded Hatchet");
                  }
                  else if(this.playingURL_string == "y8.com")
                  {
                     this.y8_api.achievementsSave("Black Hooded Hatchet","4786a3a6430618a66f41");
                  }
                  break;
               case 11:
                  this.createMissionAni("Find the Cult\'s Hideout");
                  break;
               case 12:
                  this.createMissionAni("Get Hambone Apples");
                  break;
               case 13:
                  this.createMissionCompleteAni("Get Hambone Apples");
                  break;
               case 14:
                  this.createMissionAni("Get Brody a Garbage Can Lid");
                  break;
               case 15:
                  this.createMissionCompleteAni("Get Brody a Garbage Can Lid");
                  this.c_mc.dude2_mc.body_mc.weapon_mc.gotoAndStop("garbage can lid");
                  break;
               case 16:
                  this.createMissionAni("Get Jim Sanders Some Gear");
                  break;
               case 17:
                  this.createMissionCompleteAni("Get Jim Sanders Some Gear");
                  break;
               case 18:
                  this.createMissionAni("Give Cleveland His Letter");
                  this.theConnection.send("buyItem","letter to Cleveland");
                  break;
               case 19:
                  this.createMissionCompleteAni("Give Cleveland His Letter");
                  break;
               case 20:
                  this.createMissionAni("Look Like a Black Hood");
                  break;
               case 21:
                  this.createMissionCompleteAni("Look Like a Black Hood");
                  this.player.money = this.player.money + 6000;
                  break;
               case 22:
                  if(Stats.missionStats["Find the Cult\'s Hideout"].completed == false)
                  {
                     this.createMissionCompleteAni("Find the Cult\'s Hideout");
                  }
                  break;
               case 23:
                  this.createMissionAni("Get Gordon Watermelon");
                  break;
               case 24:
                  this.createMissionCompleteAni("Get Gordon Watermelon");
                  break;
               case 25:
                  this.createMissionAni("Get Pablo a Monster Skull");
                  break;
               case 26:
                  this.createMissionCompleteAni("Get Pablo a Monster Skull");
                  break;
               case 27:
                  if(GameMenu.menu_array.indexOf(this.guildMenu) == -1)
                  {
                     this.createGuildMenu();
                  }
                  else
                  {
                     GameMenu.focusMenu(this.guildMenu);
                     this.guildMenu.scaleX = this.guildMenu.scaleY = 1;
                     TweenMax.from(this.guildMenu,0.4,{
                        "scaleX":1.2,
                        "scaleY":1.2,
                        "ease":Back.easeOut
                     });
                  }
                  break;
               case 28:
                  this.createMissionAni("Show Joshua All Enemies");
                  break;
               case 29:
                  this.createMissionCompleteAni("Show Joshua All Enemies");
                  if(this.playingURL_string == "miniplay.com")
                  {
                     MiniPlay.lechuck.stat.put(null,"unlock_joshua",Stats.missionStats["Show Joshua All Enemies"].completed);
                  }
                  else if(Steam.onSteam)
                  {
                     Steam.steam.setAchievement("ALL_ENEMIES");
                  }
                  else if(this.playingURL_string == "ungrounded.net" && Boolean(Newgrounds.isReady))
                  {
                     Newgrounds.completeAchievement("All Enemies");
                  }
                  else if(this.playingURL_string == "y8.com")
                  {
                     this.y8_api.achievementsSave("All Enemies","8b2b956ebb778aedb33b");
                  }
                  break;
               case 30:
                  this.createMissionAni("Get Scarlet a Hockey Mask");
                  break;
               case 31:
                  this.createMissionCompleteAni("Get Scarlet a Hockey Mask");
                  break;
               case 32:
                  this.createMissionAni("Look Like the Lost Warrior");
                  break;
               case 33:
                  this.createMissionCompleteAni("Look Like the Lost Warrior");
                  if(this.playingURL_string == "miniplay.com")
                  {
                     MiniPlay.lechuck.stat.put(null,"unlock_lost",Stats.missionStats["Look Like the Lost Warrior"].completed);
                  }
                  else if(Steam.onSteam)
                  {
                     Steam.steam.setAchievement("LOST_WARRIOR");
                  }
                  else if(this.playingURL_string == "ungrounded.net" && Boolean(Newgrounds.isReady))
                  {
                     Newgrounds.completeAchievement("Look Like the Lost Warrior");
                  }
                  else if(this.playingURL_string == "y8.com")
                  {
                     this.y8_api.achievementsSave("Lost Warrior","4987706cbcb552a96897");
                  }
                  break;
               case 34:
                  this.createMissionAni("Solve Jimmy\'s Puzzle");
                  break;
               case 35:
                  this.createMissionCompleteAni("Solve Jimmy\'s Puzzle");
                  break;
               case 36:
                  this.createMissionAni("Complete Albert\'s Puzzle");
                  break;
               case 37:
                  this.createMissionCompleteAni("Complete Albert\'s Puzzle");
                  break;
               case 38:
                  this.createMissionAni("Get Cassie Pumpkin Helmets");
                  break;
               case 39:
                  this.createMissionCompleteAni("Get Cassie Pumpkin Helmets");
                  break;
               case 40:
                  this.createMissionAni("Complete Billbert\'s Puzzle");
                  break;
               case 41:
                  this.createMissionCompleteAni("Complete Billbert\'s Puzzle");
                  break;
               case 42:
                  this.createPetShopMenu(Vector.<String>(["Tebra","Marshy","Baby Bounce","Petri","Gibler","Fisky"]));
                  break;
               case 43:
                  this.createPetShopMenu(Vector.<String>(["Roblost","Pumpman","Chippy","Thumper","Nooter","Gobloid"]));
                  break;
               case 44:
                  this.createPetShopMenu(Vector.<String>(["Ritardo","Ozich","Topper","Bunyan","Quackster"]));
                  break;
               case 45:
                  this.createPetShopMenu(Vector.<String>(["Dwimplepike","Squatch","Stalkling","Civic"]));
                  break;
               case 46:
                  this.createMissionAni("Collect 4 Pets");
                  break;
               case 47:
                  this.createMissionCompleteAni("Collect 4 Pets");
                  break;
               case 48:
                  this.createMissionAni("Ride a Pet");
                  break;
               case 49:
                  this.createMissionCompleteAni("Ride a Pet");
                  break;
               case 50:
                  if(StarlingGameMenu.menu_array.indexOf(this.lotteryMenu) == -1)
                  {
                     this.createLotteryMenu();
                  }
                  break;
               case 51:
                  this.createMissionAni("Catch Every Fish");
                  break;
               case 52:
                  this.createMissionCompleteAni("Catch Every Fish");
                  break;
               case 53:
                  this.createCraftingMenu(Vector.<String>(["mithril helmet","mithril armor","mithril legs","phantom hood","phantom robe","phantom pants","divine helmet","divine armor","divine legs"]));
                  break;
               case 54:
                  this.createCraftingMenu(Vector.<String>(["palm tree wood","blue mushroom cube","red mushroom cube","purple sheet wood","willow wood","junk wood","colored wood","chestnut wood","pine block"]));
                  break;
               case 55:
                  this.createCraftingMenu(Vector.<String>(["robot bar","jungle wood","stacked wood","thorn wood","snow covered wood","maple wood","cloud tree wood","enforcer gun"]));
                  break;
               case 56:
                  this.createCraftingMenu(Vector.<String>(["enforcer helmet","enforcer armor","enforcer legs","frozen mithril axe","god dagger","phantom wand","phantom staff","divine bow","mithril shield"]));
                  break;
               case 57:
                  this.createCraftingMenu(Vector.<String>(["beholder helmet","beholder armor","beholder legs","ultima","spellbound wand","spellbound staff"]));
                  break;
               case 58:
                  this.createMissionAni("Solve Philbert\'s Puzzle");
                  break;
               case 59:
                  this.createMissionCompleteAni("Solve Philbert\'s Puzzle");
                  break;
               case 60:
                  this.createCraftingMenu(Vector.<String>(["cyro helmet","mystical tribal mask","hydro tech helmet","atomic helmet","cyro armor","mystical tribal armor","hydro tech suit","atomic suit","cyro legs"]));
                  break;
               case 61:
                  this.createCraftingMenu(Vector.<String>(["mystical tribal legs","hydro tech legs","atomic legs","mystic tribal bow","skull bone gun","hydro tech wand","hydro tech staff","cyro thorn blade","cyro x force"]));
                  break;
               case 62:
                  this.createCraftingMenu(Vector.<String>(["prey helmet","prey armor","prey legs","wrangler helmet","wrangler armor","wrangler legs","radiator gun","spellbound helmet","spellbound armor"]));
                  break;
               case 63:
                  this.createMissionAni("Reach High Energy Level");
                  break;
               case 64:
                  this.createCraftingMenu(Vector.<String>(["spellbound legs","ghillie helmet","ghillie armor","ghillie legs","ghillie bow","ultra helmet","ultra armor","ultra legs","ultra scimitar"]));
                  break;
               case 65:
                  this.createCraftingMenu(Vector.<String>(["magma helmet","magma armor","magma legs","millennium helmet","millennium armor","millennium legs","winged skull helmet","corruption helmet","empowered staff"]));
                  break;
               case 66:
                  this.createCraftingMenu(Vector.<String>(["corruption armor","corruption legs","empowered armor","empowered legs","inferno","coal blazer","millennium bow","corruptor","empowered wand"]));
                  break;
               case 67:
                  this.createCraftingMenu(Vector.<String>(["corruptor"]));
                  break;
               case 68:
                  this.createCraftingMenu(Vector.<String>(["god helmet","god armor","god legs","angelic helmet","angelic armor","angelic legs","gemstone helmet","gemstone armor","gemstone legs"]));
                  break;
               case 69:
                  this.createCraftingMenu(Vector.<String>(["god blade","god scimitar","angelic bow","gemstone wand","gemstone staff","neoplasti blaster","neoplasti helmet","neoplasti armor","neoplasti legs"]));
            }
         }
      }
      
      public function handleBubbleText(param1:int, param2:Person) : void
      {
         switch(param1)
         {
            case 1:
               if(Stats.missionStats["The Black Hooded Hatchet"].completed == false)
               {
                  this.createTalkBox(7,param2,"Good job!  There\'s always Green Bouncers running loose around here.  But for now you have to find the guy that cut down your platform you were on.  He was carrying a hatchet and dressed in full black, so he shouldn\'t be hard to find.  If you don\'t find him soon he\'s going to cause mischief on our village.  Go on ahead, we\'ll stay here.");
               }
               else
               {
                  this.createTalkBox(0,param2,"You\'ve found the Black Hooded Hatchet?!  Good going!  Now you must find their hideout.  We have got to stop him and their cult before they succeed in doing something purely evil.");
               }
               break;
            case 2:
               this.createTalkBox(0,param2,"Welcome to my store, please buy whatever you would like.",false,true,true);
               break;
            case 3:
               this.createTalkBox(8,param2,"Welcome to the wonderful world of Helmet Heroes!  Here you will find plenty of other people from around the world to interact with!  Watch out for monsters though!");
               break;
            case 4:
               this.createTalkBox(0,param2,"Fighting monsters makes you stronger.  As you kill monsters you gain experience and you can level up.  You can also get better weapons and armor to make you powerful.  ..Also, if you press down while on solid ground you can slide.  Practice it out on this incline.");
               break;
            case 5:
               this.createTalkBox(0,param2,"I think I\'m pretty strong, but this area next to me is pretty tough.  Make sure you got some good gear and are strong enough to fight the enemies in there.");
               break;
            case 6:
               this.createTalkBox(0,param2,"Are you getting the hang of things?  This area is what they call Mushroom Alley.  I wish I were a mushroom...  Did you know that bows are generally stronger than guns, hit vs hit?  Guns can fire at a higher rate of fire but don\'t pack as much of a punch as good old fashion arrows.  This is partially because arrows are much larger in size compared to a bullet.  Not only that, but bows are designed for the mightiest of archers.  The draw force that is required to pull back a high level bow makes them extremely powerful compared to a gun.");
               break;
            case 7:
               this.createTalkBox(0,param2,"I like to chill.  No..  I LOVE to chill.  I think I\'m a chill guy don\'t you?  If I had a coin for everytime I said the word chill, I\'d have about 1 coin in total.  Wait, that\'s not right...");
               break;
            case 8:
               this.createTalkBox(9,param2,"I\'ve got way too many potions on me.  Here, I will use one on you, it will heal you to full health.");
               break;
            case 9:
               if(Stats.missionStats["Give Cleveland His Letter"].started == false)
               {
                  if(this.personItem_array.length < 20)
                  {
                     this.createTalkBox(18,param2,"Hey man, how\'s it going?  I like just being at the beach, it\'s so relaxing.  I need to get up and go somewhere at some point though, it\'s making me so lazy.  I haven\'t seen my pal Cleveland in a few months now.  Say...  I have a letter for him, do you think you could give it to him for me?  He lives in Mushroom Village.  Thanks!");
                  }
                  else
                  {
                     this.createTalkBox(0,param2,"Hey man, how\'s it going?  I like just being at the beach, it\'s so relaxing.  I need to get up and go somewhere at some point though, it\'s making me so lazy.  I haven\'t seen my pal Cleveland in a few months now.  Say...  I have a letter for him, do you think you could give it to him for me?  ...Oh wait, you\'re carrying too many items, nevermind.");
                  }
               }
               else if(Stats.missionStats["Give Cleveland His Letter"].started == true && Stats.missionStats["Give Cleveland His Letter"].completed == false)
               {
                  this.createTalkBox(0,param2,"Take your time, no rush.  I do need Clevelend to get that letter sometime this century though.  I\'d do it myself but I\'m busy doing nothing.");
               }
               else
               {
                  this.createTalkBox(0,param2,"Thanks for delivering my letter to Cleveland!  Cleveland can be a pretty cool guy.  He loves living in Mushroom Village, but personally I like it here on the beach.");
               }
               break;
            case 10:
               if(Stats.missionStats["Give Cleveland His Letter"].started == false)
               {
                  this.createTalkBox(0,param2,"Living in Mushroom Village sure is awesome.  It\'s one of the busiest places I\'ve ever seen!  I want to join a guild one day, that way I can make some new friends.");
               }
               else if(Boolean(Stats.missionStats["Give Cleveland His Letter"].started) && Stats.missionStats["Give Cleveland His Letter"].completed == false)
               {
                  this.createTalkBox(19,param2,"You\'ve got a letter for me from Arny?  Cool, thanks!  I bet you wanted to read the letter didn\'t you?  If you would have read it, I probably would have slapped you silly!  Thanks again!");
                  this.vectorStringRemove(this.personItem_array,"letter to Cleveland");
                  this.theConnection.send("sellI","letter to Cleveland",false);
               }
               else
               {
                  this.createTalkBox(0,param2,"I love Mushroom Village.  I like to call it \'Mush Vill\' for short.  I think it sounds way cooler.  Just say it with me, \'Mush Vill\'.  Feels great doesn\'t it?  You can thank me later.");
               }
               break;
            case 11:
               this.createTalkBox(0,param2,"Welcome to Mushroom Village!  I love it here, they\'ve got weapon and armor shops, food, hotels, and even a few pretty girls.");
               break;
            case 12:
               this.createTalkBox(0,param2,"Hey man, can\'t a guy climb some boxes in peace!?  Just joking.  Do you wan\'t to buy anything?  I specialize in coconut products of all kind!",false,true,true);
               break;
            case 13:
               this.createTalkBox(0,param2,"Coconut this, coconut that..  All the boss has me do all day is make stuff out of coconuts.  All I want to do is sit around and do nothing and get paid.  Is that so much to ask?");
               break;
            case 14:
               if(Stats.missionStats["The Black Hooded Hatchet"].started == false)
               {
                  this.createTalkBox(0,param2,"Get out of here, don\'t talk to me!");
               }
               else if(Stats.missionStats["The Black Hooded Hatchet"].started == true && Stats.missionStats["The Black Hooded Hatchet"].completed == false)
               {
                  this.createTalkBox(10,param2,"...You!?  I thought that fall would have knocked you out for good.  Are you gonna try and do something about it?  I\'ll cut down whatever I want, whenever I want.  My clan already has much bigger plans than you anyway, so get lost!");
               }
               else if(Stats.missionStats["Find the Cult\'s Hideout"].started == false)
               {
                  this.createTalkBox(11,param2,"I thought I told you to get out of here!?  I\'m not going to give you any information about my clan so stop asking... Their headquarters isn far away past a beach, so you\'ll never find them, so SCRAM!");
               }
               else
               {
                  this.createTalkBox(0,param2,"Leave me alone already!");
               }
               break;
            case 15:
               this.createTalkBox(0,param2,"I like to stand right in the sunlight.  It makes me feel like I\'m cool.  I mean, even if I didn\'t stand in the sunlight, I\'d still be cool, but I\'m even cooler when I\'m in the light.");
               break;
            case 16:
               this.createTalkBox(9,param2,"Welcome to my hotel.  With a good nights sleep, we can heal you back to full health.");
               break;
            case 17:
               this.createTalkBox(0,param2,"All I want to do is watch some TV, is that so much to ask?  The stupid thing must be broke, because it\'s not turning on!");
               break;
            case 18:
               this.createTalkBox(0,param2,"I thought I had to toot once, but it was something much greater.  ...It was AWESOME!");
               break;
            case 19:
               if(Stats.missionStats["Get Hambone Apples"].completed == false)
               {
                  if(Stats.missionStats["Get Hambone Apples"].started == false)
                  {
                     this.createTalkBox(12,param2,"Yea, go ahead make fun of me because I\'m poor.  I don\'t have a lot of money, so I can never eat.  What\'s a couple of coins good for?!  I\'m really hungry, all I need is something to eat.  Do you think you could give me 6 apples?  I would be very grateful.");
                  }
                  else if(Stats.missionStats["Get Hambone Apples"].started == true)
                  {
                     if(this.countStringsInArray(this.personItem_array,"apple") == 0)
                     {
                        this.createTalkBox(0,param2,"So... Hungry... Need... Apples...");
                     }
                     else if(this.countStringsInArray(this.personItem_array,"apple") < 6)
                     {
                        this.createTalkBox(0,param2,String(this.countStringsInArray(this.personItem_array,"apple")) + " apple" + (this.countStringsInArray(this.personItem_array,"apple") == 1 ? "" : "s") + "?  What good is that amount going to do me?  I need 6 of them!");
                     }
                     else if(this.countStringsInArray(this.personItem_array,"apple") >= 6)
                     {
                        this.vectorStringRemove(this.personItem_array,"apple");
                        this.vectorStringRemove(this.personItem_array,"apple");
                        this.vectorStringRemove(this.personItem_array,"apple");
                        this.vectorStringRemove(this.personItem_array,"apple");
                        this.vectorStringRemove(this.personItem_array,"apple");
                        this.vectorStringRemove(this.personItem_array,"apple");
                        this.theConnection.send("sellI","apple",false);
                        this.theConnection.send("sellI","apple",false);
                        this.theConnection.send("sellI","apple",false);
                        this.theConnection.send("sellI","apple",false);
                        this.theConnection.send("sellI","apple",false);
                        this.theConnection.send("sellI","apple",false);
                        this.createTalkBox(13,param2,"Yum yum, apples!  Just what I needed!  I still don\'t have much money, but at least I\'m not hungry anymore.  Thanks man!");
                     }
                  }
               }
               else
               {
                  this.createTalkBox(0,param2,"Thanks for the apples, they were delicious.");
               }
               break;
            case 20:
               this.createTalkBox(0,param2,"Welcome, welcome!  I am Shane the Shield Man, or Shane Shield for short.  You came all the way to my house, surely you are interested in buying some shields?",false,true,true);
               break;
            case 21:
               if(Stats.missionStats["Get Brody a Garbage Can Lid"].started == false)
               {
                  this.createTalkBox(14,param2,"Dude, like I just want a shield.  Is that so much to ask?  Like, man...  Like I think I wanted a shield dude since I was like, a baby or something man.  Like, man...  Like I totally want a shield so bad dude.  I don\'t even care if it\'s a garbage can lid.  Ya know, I think I\'d kinda like a garbage can lid dude!");
               }
               else if(Stats.missionStats["Get Brody a Garbage Can Lid"].started == true && Stats.missionStats["Get Brody a Garbage Can Lid"].completed == false && this.countStringsInArray(this.personItem_array,"garbage can lid") == 0)
               {
                  this.createTalkBox(0,param2,"Dude man, I want a garbage can lid.  I don\'t care if it has garbage on it, maybe I like the smell of garbage dude.");
               }
               else if(Stats.missionStats["Get Brody a Garbage Can Lid"].started == true && Stats.missionStats["Get Brody a Garbage Can Lid"].completed == false && this.countStringsInArray(this.personItem_array,"garbage can lid") >= 1 && this.player.bodyAnimator.weaponString == "garbage can lid")
               {
                  this.createTalkBox(0,param2,"Dude are you trying to make me jealous or something man?  Real cool, you have a garbage can lid equipped.  Real cool dude...");
               }
               else if(Stats.missionStats["Get Brody a Garbage Can Lid"].started == true && Stats.missionStats["Get Brody a Garbage Can Lid"].completed == false && this.countStringsInArray(this.personItem_array,"garbage can lid") >= 1)
               {
                  this.vectorStringRemove(this.personItem_array,"garbage can lid");
                  this.theConnection.send("sellI","garbage can lid",false);
                  this.createTalkBox(15,param2,"Bro, nice garbage can lid dude, I think I\'ll take it!  Thanks bro, I always wanted a garbage can lid.");
               }
               else if(Stats.missionStats["Get Brody a Garbage Can Lid"].completed == true)
               {
                  if(Math.random() > 0.5)
                  {
                     this.createTalkBox(0,param2,"Bro, dude, man.  Like... I love the garbage can lid dude. Not because I like the smell of garbage or anything...  Actually dude, that\'s exactly why.");
                  }
                  else
                  {
                     this.createTalkBox(0,param2,"Man, dude, bro, man, dude... Like dude, man.  Bro?  Dude!  Bro dude man...  DUDE!  ..Oh sorry, I didn\'t see you there!");
                  }
               }
               break;
            case 22:
               if(Stats.missionStats["Get Jim Sanders Some Gear"].started == false)
               {
                  this.createTalkBox(16,param2,"I\'m just not strong enough to do anything.  Anytime I try to go anywhere I get hurt real easily. Do you think you could get me some cool new gear?  That way, maybe I would stand a chance when monsters decide to attack me.  Something like, say... A sickle would be awesome!");
               }
               else if(Stats.missionStats["Get Jim Sanders Some Gear"].started == true && Stats.missionStats["Get Jim Sanders Some Gear"].completed == false && this.countStringsInArray(this.personItem_array,"sickle") == 0)
               {
                  this.createTalkBox(0,param2,"Man, I need that sickle soon!  I\'m just not strong enough.");
               }
               else if(Stats.missionStats["Get Jim Sanders Some Gear"].started == true && Stats.missionStats["Get Jim Sanders Some Gear"].completed == false && this.countStringsInArray(this.personItem_array,"sickle") >= 1 && (this.player.bodyAnimator.weaponString == "sickle" || this.player.bodyAnimator.weapon2String == "sickle"))
               {
                  this.createTalkBox(0,param2,"If you planned on giving me that sickle, you should probably un-equip it before you give me it.");
               }
               else if(Stats.missionStats["Get Jim Sanders Some Gear"].started == true && Stats.missionStats["Get Jim Sanders Some Gear"].completed == false && this.countStringsInArray(this.personItem_array,"sickle") >= 1)
               {
                  this.vectorStringRemove(this.personItem_array,"sickle");
                  this.theConnection.send("sellI","sickle",false);
                  this.createTalkBox(17,param2,"Thanks man!  This sickle is awesome!  Now maybe I\'ll be able to attack enemies with more power");
               }
               else if(Stats.missionStats["Get Jim Sanders Some Gear"].completed == true)
               {
                  if(Math.random() > 0.3)
                  {
                     this.createTalkBox(0,param2,"Thanks again man.  The world will now fear me, for I am... JIM SANDERS - SICKLE... GUY... DUDE... Sickle... Ah, just some guy with a sickle.");
                  }
                  else
                  {
                     this.createTalkBox(0,param2,"Hey, gingers DO have souls!  ...And sickles.");
                  }
               }
               break;
            case 23:
               this.createTalkBox(0,param2,"V\'elcome my friend, to my end of the woods!  Pretty cool place I have wouldn\'t you say?  This is where I live, eating leaves and drinking dirt all day.  ...Nah, I\'m just kidding I don\'t drink dirt.  Anyway, I have some things for sale.  Maybe you would like to take a look?",false,true,true);
               break;
            case 24:
               this.createTalkBox(0,param2,"What do you want?  No you don\'t know me, but you have probably met my brother Anoop, so don\'t call me Anoop because it\'s not my name.  So what do you want?  Are you just going to stand there and look at me?  This ain\'t a nice place to be, so if you want something you better buy it or scram!",false,true,true);
               break;
            case 25:
               this.createTalkBox(0,param2,"My brother Kyle stacked all his attack, now when he gets hit by enemies he takes alot of damage.  I think he\'s dumb for doing it, I like to balance everything out.");
               break;
            case 26:
               this.createTalkBox(0,param2,"My brother Ron likes to be \'well rounded\', but I just call him \'well idiot\'. Like I always say, the best defense is a good offense!");
               break;
            case 27:
               this.createTalkBox(0,param2,"My two cousins Ron and Kyle just argue all day, it\'s really annoying.  The thing is, I\'m not sure who to agree with.  In my opinion, I like to stack my HP, that way I never die.");
               break;
            case 28:
               this.createTalkBox(0,param2,"People call us folks who live in Fairyville weird but I don\'t think we\'re weird, we\'re just odd that\'s all.  Some people even call us dumb but we ain\'t dumb, we stupid.  It doesn\'t even make me angry when people talk about us, it just makes me mad.  People need to stop.");
               break;
            case 29:
               this.createTalkBox(0,param2,"Dude, what\'s up!?  Luckily you knew where I was.  I put that \'store\' sign in my house in case anybody came in and couldn\'t find me.  It\'s what I like to call a great idea.  So do you want to buy anything?",false,true,true);
               break;
            case 30:
               this.createTalkBox(0,param2,"Be careful going into there, it\'s very dangerous.  You can be attacked by anybody in there, and if you die you will lose half of your money.  One day, I\'ll be strong enough to destroy anybody in there!  Right now, I\'m kind of scared though...  If you want to get onto the kill leaderboards, PVP kills only count in this area, NOT the sparing grounds.");
               break;
            case 31:
               this.createTalkBox(0,param2,"In the sparring ground you can be attacked by anybody, but luckily if you die no money will be taken away.  Sometimes I go in there to spar against my buddies and see who will win.");
               break;
            case 32:
               this.createTalkBox(9,param2,"Hello.  If you plan on fighting against anybody in the PVP areas then it\'s best to be at full health.  I can heal you.");
               break;
            case 33:
               this.createTalkBox(9,param2,"Weapons and healing all in one place!  Pretty handy isn\'t it?  I\'ll heal you.  Don\'t worry, I\'m a licensed professional.");
               break;
            case 34:
               this.createTalkBox(0,param2,"Come one, come all!  Weapons, armor, helmets, we\'ve got it all!  Need to take down another player?  I\'m sure some of my equipment will help you.  ..And people told me this was a bad place to open up shop, ha!",false,true,true);
               break;
            case 35:
               if(Stats.missionStats["Look Like a Black Hood"].started == false)
               {
                  this.createTalkBox(20,param2,"Hey, who are you?!  You don\'t look like you belong here.  I would suggest you get the heck out of here pronto!  Now, if you looked like one of us, maybe I could give you something cool.");
               }
               else if(Stats.missionStats["Look Like a Black Hood"].started == true && Stats.missionStats["Look Like a Black Hood"].completed == false)
               {
                  if(this.player.bodyAnimator.helmetString == "full ski mask" && this.player.bodyAnimator.shirtString == "suit" && this.player.bodyAnimator.pantsString == "suit pants")
                  {
                     this.createTalkBox(21,param2,"Oh hey " + this.player.name + "!  I didn\'t realize you were part of the cult.  Here you go, I\'ll give you $6,000 just for being one of us.  Use it for your dirty work.");
                  }
                  else if(this.player.bodyAnimator.helmetString == "full ski mask" || this.player.bodyAnimator.shirtString == "suit" || this.player.bodyAnimator.pantsString == "suit pants")
                  {
                     this.createTalkBox(0,param2,"Oh hey!...  Wait a second...  Are you trying to trick me?  Get lost punk!");
                  }
                  else
                  {
                     this.createTalkBox(0,param2,"I thought I told you to SCRAM! If you don\'t look like one of us than you \'aint!");
                  }
               }
               else
               {
                  this.createTalkBox(0,param2,"I gave you your money, so leave me alone.");
               }
               break;
            case 36:
               this.createTalkBox(0,param2,"E.V.I.L.?  You don\'t know what it stands for?  What are you dumb?  Everybody knows E.V.I.L. stands for...  it stands for... Elephant.. Violin... Image..  Lemon.  Wait, that might be a little bit off.");
               break;
            case 37:
               this.createTalkBox(0,param2,"Hey buddy, I don\'t like you.  Why?  I don\'t need a reason!  This is our hideout, and if anyone dislikes it, I will pinch them!");
               break;
            case 38:
               this.createTalkBox(22,param2,"This is the biggest, baddest, cult you will EVER find in your ENTIRE life.  We have everything you could ever need here.  Trees, ground, graves, trees and a massive 4 foot clubhouse big enough to fit at least 200 people.  Luckily I get to chill in the clubhouse all day.  ..If you are here looking for Mad Ricky, he\'s not here right now.");
               break;
            case 40:
               if(Stats.missionStats["Get Gordon Watermelon"].completed == false)
               {
                  if(Stats.missionStats["Get Gordon Watermelon"].started == false)
                  {
                     this.createTalkBox(23,param2,"Trying to start a farm is rough.  I figured this would be the best place to start a watermelon farm.  The problem is, I don\'t have any watermelon seeds!  Do you think you could get me some watermelon?  That way I could use the watermelon seeds from them to plant a farm.");
                  }
                  else if(Stats.missionStats["Get Gordon Watermelon"].started == true)
                  {
                     if(this.countStringsInArray(this.personItem_array,"watermelon") == 0)
                     {
                        this.createTalkBox(0,param2,"This watermelon farm isn\'t going very well...  Maybe if I had some watermelon I could use the seeds from them.");
                     }
                     else if(this.countStringsInArray(this.personItem_array,"watermelon") < 6)
                     {
                        this.createTalkBox(0,param2,String(this.countStringsInArray(this.personItem_array,"watermelon")) + " watermelon" + (this.countStringsInArray(this.personItem_array,"watermelon") == 1 ? "" : "s") + " aren\'t enough to start a farm!  I\'m going to need more than that.  It\'s a tough farming world out there.");
                     }
                     else if(this.countStringsInArray(this.personItem_array,"watermelon") >= 6)
                     {
                        this.vectorStringRemove(this.personItem_array,"watermelon");
                        this.vectorStringRemove(this.personItem_array,"watermelon");
                        this.vectorStringRemove(this.personItem_array,"watermelon");
                        this.vectorStringRemove(this.personItem_array,"watermelon");
                        this.vectorStringRemove(this.personItem_array,"watermelon");
                        this.vectorStringRemove(this.personItem_array,"watermelon");
                        this.theConnection.send("sellI","watermelon",false);
                        this.theConnection.send("sellI","watermelon",false);
                        this.theConnection.send("sellI","watermelon",false);
                        this.theConnection.send("sellI","watermelon",false);
                        this.theConnection.send("sellI","watermelon",false);
                        this.theConnection.send("sellI","watermelon",false);
                        this.createTalkBox(24,param2,"Wow!  Watermelon?  For me?  Thanks a lot " + this.player.name + "!  You\'re one nice fellow.  Maybe one day, you can work on my farm.  You can be a pretend goat.  ...Every farm needs one pretend goat.");
                     }
                  }
               }
               else
               {
                  this.createTalkBox(0,param2,"Thanks for the watermelons man, they were delicious.");
               }
               break;
            case 41:
               this.createTalkBox(9,param2,"This is a dangerous place around these parts.  I\'m going to take a good guess and say you could use healing.");
               break;
            case 42:
               this.createTalkBox(0,param2,"Them great frogs can be tough you know.  You have to have some of the top level equipment in order to survive against them.  You came all this way, why not buy some equipment from my shop?",false,true,true);
               break;
            case 43:
               if(Stats.missionStats["Get Pablo a Monster Skull"].started == false)
               {
                  this.createTalkBox(25,param2,"Living out here is tough.  The great frogs keep us from going outside very often.  If we do, they will hurt us or even kill us.  Some of them are friendlier than others, but I don\'t want to take my chances.  I\'ve always wanted a Monster Skull that I could put on display.  Do you think you could get me one?");
               }
               else if(Stats.missionStats["Get Pablo a Monster Skull"].started == true && Stats.missionStats["Get Pablo a Monster Skull"].completed == false && this.countStringsInArray(this.personItem_array,"monster skull") == 0)
               {
                  this.createTalkBox(0,param2,"If I had a rare Monster Skull, I\'d be famous!  Well maybe not famous, but people would think I was cool.");
               }
               else if(Stats.missionStats["Get Pablo a Monster Skull"].started == true && Stats.missionStats["Get Pablo a Monster Skull"].completed == false && this.countStringsInArray(this.personItem_array,"monster skull") >= 1 && this.player.bodyAnimator.helmetString == "monster skull")
               {
                  this.createTalkBox(0,param2,"Hey man!  You don\'t have to flaunt it!  Why don\'t you take that helmet off and give it to little ol\' me?");
               }
               else if(Stats.missionStats["Get Pablo a Monster Skull"].started == true && Stats.missionStats["Get Pablo a Monster Skull"].completed == false && this.countStringsInArray(this.personItem_array,"monster skull") >= 1)
               {
                  this.vectorStringRemove(this.personItem_array,"monster skull");
                  this.theConnection.send("sellI","monster skull",false);
                  this.createTalkBox(26,param2,"Gimme that Monster Skull!  ...Thanks!  Everyone will love me now that I have a monster skull.  This has got to be the coolest thing I\'ve ever saw!");
               }
               else if(Stats.missionStats["Get Pablo a Monster Skull"].completed == true)
               {
                  this.createTalkBox(0,param2,"I love the monster skull you got for me.  Thanks man, I love you.  ...Wow wow!  ...Not like that.");
               }
               break;
            case 44:
               this.createTalkBox(0,param2,"Welcome to my humble library.  I can sell you some books if you would like.  They say there is no power greater than knowledge.  So why not read?  You never know, it may help you out.",false,true,true);
               break;
            case 45:
               this.createTalkBox(27,param2,"Welcome, welcome!  I am the creator of the widely known \'Guild system\'!  If you would like to join or create a guild, you can do it through me.");
               break;
            case 46:
               this.createTalkBox(46,param2,"I\'ve got some top quality stuff for sale if you\'re interested.  I bet you could use it if you plan on taking down any of them frogs.",false,true,true);
               break;
            case 47:
               this.createTalkBox(0,param2,"I love it out here, it\'s so nice and peaceful by the water.  ..Do you travel alot?  I have heard there are guilds in Mushroom Village.  Is it true?  If so, I want to join one!  I think it\'d be cool to make some new friends.");
               break;
            case 48:
               if(Stats.missionStats["Show Joshua All Enemies"].started == false)
               {
                  this.createTalkBox(28,param2,"There are so many types of monsters, I which I could see them all.  Some of them are so powerful though, I\'m afraid I might get knocked out if I get too close.  Say, when you filled you Hero-Pedia up with all of the monsters info do you think you could show me?  I love to learn about all the new monsters there are!");
               }
               else if(Stats.missionStats["Show Joshua All Enemies"].started == true && Stats.missionStats["Show Joshua All Enemies"].completed == false && this.enemyList_array.length < Stats.totalEnemyTypes)
               {
                  this.createTalkBox(0,param2,"I see you have some Hero-pedia entries for some of the enemies.  That\'s cool.  I was hoping that you would have all " + String(Stats.totalEnemyTypes) + " instead of just " + String(this.enemyList_array.length) + " though.  Come back to me when you have them all.");
               }
               else if(Stats.missionStats["Show Joshua All Enemies"].started == true && Stats.missionStats["Show Joshua All Enemies"].completed == false && this.enemyList_array.length == Stats.totalEnemyTypes)
               {
                  this.createTalkBox(29,param2,"You have Hero-Pedia entries for all " + String(Stats.totalEnemyTypes) + " enemies?!  That\'s awesome!  Thanks for showing me.  You must be pretty brave to travel the world and go up against all of those strong monsters!");
               }
               else
               {
                  this.createTalkBox(0,param2,"Thanks for showing me all the Hero-Pedia enemy info.  I know it sounds crazy, but I love knowing about monsters.");
               }
               break;
            case 49:
               if(Stats.missionStats["Get Scarlet a Hockey Mask"].started == false)
               {
                  this.createTalkBox(30,param2,"Fairyville is a cool town and all, but don\'t you think it\'s a little dull?  I mean come on!  This place doesn\'t scare me at all!  It has to be the least scary place I have ever been to in my entire life.  Everyone likes a little scare don\'t they?  I thought this witch hat I had on would bring some scare, but it doesn\'t.  Say, do you think you could get me a hockey mask?  I\'m sure one of those things would creep people out.");
               }
               else if(Stats.missionStats["Get Scarlet a Hockey Mask"].started == true && Stats.missionStats["Get Scarlet a Hockey Mask"].completed == false && this.countStringsInArray(this.personItem_array,"hockey mask") == 0)
               {
                  this.createTalkBox(0,param2,"I sure do wish I had that hockey mask so I could scare people.  But a certain someone still hasn\'t gotten it for me yet.  ..Not mentioning any names.");
               }
               else if(Stats.missionStats["Get Scarlet a Hockey Mask"].started == true && Stats.missionStats["Get Scarlet a Hockey Mask"].completed == false && this.countStringsInArray(this.personItem_array,"hockey mask") >= 1 && this.player.bodyAnimator.helmetString == "hockey mask")
               {
                  this.createTalkBox(0,param2,"Are you trying to scare ME with that hockey mask?  You can\'t scare me, I\'m the queen of scare.  Now about you take it off and give me the mask?");
               }
               else if(Stats.missionStats["Get Scarlet a Hockey Mask"].started == true && Stats.missionStats["Get Scarlet a Hockey Mask"].completed == false && this.countStringsInArray(this.personItem_array,"hockey mask") >= 1)
               {
                  this.vectorStringRemove(this.personItem_array,"hockey mask");
                  this.theConnection.send("sellI","hockey mask",false);
                  this.createTalkBox(31,param2,"Thanks for the hockey mask!  Now that I have this I can start bringing some scare into this town!");
               }
               else if(Stats.missionStats["Get Scarlet a Hockey Mask"].completed == true)
               {
                  this.createTalkBox(0,param2,"Do you think now that I got this hockey mask that I can smash my head off of anything I want and it won\'t hurt?  ..Oh.  ..Well, neither did I.");
               }
               break;
            case 50:
               if(Stats.missionStats["Look Like the Lost Warrior"].started == false)
               {
                  this.createTalkBox(32,param2,"So how about my buddy told me about the legend of \'The Lost Warrior\'.  Have you ever heard about him?  Legend has it that deep in a forest somewhere around here a warrior was killed.  They say that right before he died he engraved the items he was wearing into stone.  What if you saw someone wearing his exact same items?  If I saw somebody like that, I would probably cry.  ..Not because I\'m a baby though, but because I would have something in my eye.  Both eyes.");
               }
               else if(Stats.missionStats["Look Like the Lost Warrior"].started == true && Stats.missionStats["Look Like the Lost Warrior"].completed == false)
               {
                  if(this.player.bodyAnimator.helmetString == "horned helmet" && this.player.bodyAnimator.weaponString == "bronze shield" && this.player.bodyAnimator.weapon2String == "sai")
                  {
                     this.createTalkBox(33,param2,"Y-Y-You\'re the long lost warrior!  The legend is wrong, you didn\'t die!  Oh my gosh, I can\'t stop crying!  ...I just have something in my eyes that\'s all.");
                  }
                  else if(this.player.bodyAnimator.helmetString == "horned helmet" || this.player.bodyAnimator.weapon2String == "bronze shield" || this.player.bodyAnimator.weapon2String == "sai")
                  {
                     this.createTalkBox(0,param2,"The lost warrior is that you?  Oh wait, never mind that\'s just you " + this.player.name + ".  Are you trying to trick me?");
                  }
                  else
                  {
                     this.createTalkBox(0,param2,"I wish I knew more about the Legend of the Lost Warrior.  I wish I was alive to see him in person when he died.  What if he\'s not actually dead?!  ..Naw that was hundreds of years ago, there\'s no way he\'s alive now.");
                  }
               }
               else
               {
                  this.createTalkBox(0,this.c_mc.dude1_mc,"You know, I was thinking about it..  I think you may have tricked me, there is no Lost Warrior anymore is there?  ...Or... Is there?...");
               }
               break;
            case 51:
               this.createTalkBox(0,param2,"Hey you!  Have you seen anything suspicious going on?  If you see someone who looks like they\'re not playing like a human would, like they\'re using illegal programs to automatically press their keys, then I can help you.  I sell alarms.  Use these ONLY on players who you believe are cheating.  These are very powerful items, so don\'t falsely use them to annoy players or you could end up getting yourself in trouble.  Alarms will disable players who are botting.",false,true,true);
               break;
            case 52:
               this.createTalkBox(0,param2,"Bbbrrrr..  It\'s cold out huh?  Well duh, there\'s snow on the ground, what do you expect!  I could sell you some weapons, they will help warm you right up! ...Oh, weapons don\'t warm you up?  Well buy some anyway.",false,true,true);
               break;
            case 54:
               this.createTalkBox(9,param2,"Cold, cold, cold!  You want healed young one?  I can heal you.  If you plan on going through that portal to the right you\'re going to need it.");
               break;
            case 55:
               this.createTalkBox(0,param2,"Shoes shoes shoes!  Get your shoes here!  You wanna buy some shoes man?",false,true,true);
               break;
            case 56:
               this.createTalkBox(0,param2,"Through this portal is a GVG area.  It allows guilds to fight other guilds.  If you go in there with a fellow guild member, you won\'t be able to hurt them!  This makes it easy to team up on other players from other guilds.  Like the sparing grounds, money is not lost if you die in here.  If you kill somebody in here and you are in a guild, you will add one to your guilds total kills.");
               break;
            case 57:
               if(Stats.missionStats["Solve Jimmy\'s Puzzle"].started == false)
               {
                  this.createTalkBox(34,param2,"Hehehe.  I love going around writing graffiti on stuff.  My passion is drawing items and clothing.  I\'ve been just about everywhere now.  I tell you what, I bet you can\'t find all my graffiti marks.  The only way you can prove it, is by equipping the items I drew in my graffiti.  There are two items to wear from my graffiti.  Ready, go!");
               }
               else if(Boolean(Stats.missionStats["Solve Jimmy\'s Puzzle"].started) && Stats.missionStats["Solve Jimmy\'s Puzzle"].completed == false)
               {
                  if(this.player.name.length >= 8)
                  {
                     if(this.player.bodyAnimator.helmetString == "blue beanie" && this.player.bodyAnimator.weaponString == "pickaxe")
                     {
                        this.createTalkBox(35,param2,"Good job!  You completed my puzzle!  You\'re one swell fellow you know that.  Good luck on your journey.");
                     }
                     else
                     {
                        this.createTalkBox(0,param2,"Hey, you don\'t seem to be wearing the things pictured in my graffiti art.  Go forth and find my graffiti!");
                     }
                  }
                  else if(this.player.bodyAnimator.helmetString == "coconut helmet" && this.player.bodyAnimator.weaponString == "meat cleaver")
                  {
                     this.createTalkBox(35,param2,"Good job!  You completed my puzzle!  You\'re one swell fellow you know that.  Good luck on your journey.");
                  }
                  else
                  {
                     this.createTalkBox(0,param2,"Hey, you don\'t seem to be wearing the things pictured in my graffiti art.  Go forth and find my graffiti!");
                  }
               }
               else
               {
                  this.createTalkBox(0,param2,"You know me, I love graffiti!  Hopefully I don\'t get busted for painting on random things.  ..Oh well!");
               }
               break;
            case 58:
               this.createTalkBox(0,param2,"Stop!  I know you want to buy something out of my store.  There\'s no way you came down here and risked your life NOT to buy something.  Choose from whatever you like, I have all kinds of great equipment.",false,true,true);
               break;
            case 59:
               if(Stats.missionStats["Complete Albert\'s Puzzle"].started == false)
               {
                  this.createTalkBox(36,param2,"This dungeon is a scary place isn\'t it?  I am able to take down a goo cube, but not without the help of some of my friends.  I once walked into the same room as a brick monster and the next thing I knew I was dead.  Anyway, I got a mission for you.  It\'s a bit of a puzzle.  Talk to me again, and I will give you the clues.");
               }
               else if(Stats.missionStats["Complete Albert\'s Puzzle"].completed == false)
               {
                  if(this.player.name.length < 8)
                  {
                     if(this.player.bodyAnimator.helmetString != "leather helmet")
                     {
                        this.createTalkBox(0,param2,"I will list you some people, you must find them and talk to them.  The number I give after their name is the number letter you should write down according to what they say.  Do not count punctuation.  For example if I said \'What\'s up?  How are you?\' and I have you the number #10, the resulting letter would be \'W\'.  ...Now here are your clues: Marget #3, Thomas #8, Daniel #18, Wallace #9, Ted #3, Ron Anderson #38, Michael #10.");
                     }
                     else
                     {
                        this.createTalkBox(37,param2,"Well done!  You\'ve solved my puzzle!  I love making puzzles as you can tell.  Good job, and be safe out there.");
                     }
                  }
                  else if(this.player.bodyAnimator.helmetString != "crumby wizard hat")
                  {
                     this.createTalkBox(0,param2,"I will list you some people, you must find them and talk to them.  The number I give after their name is the number letter you should write down according to what they say.  Do not count punctuation.  For example if I said \'What\'s up?  How are you?\' and I have you the number #10, the resulting letter would be \'W\'.  ...Now here are your clues: Sneed #57, Keith #34, Gary #6, Alfred #9, Travis #1, Chipper #30.");
                  }
                  else
                  {
                     this.createTalkBox(37,param2,"Well done!  You\'ve solved my puzzle!  I love making puzzles as you can tell.  Good job, and be safe out there.");
                  }
               }
               else
               {
                  this.createTalkBox(0,param2,"You\'re pretty good at solving puzzles aren\'t you?  Keep on keepin\' on!");
               }
               break;
            case 60:
               this.createTalkBox(0,param2,"Welcome to my store.  I specialize in selling equipment for girls.  You know, pink girly stuff!  If any of this stuff interests you, go ahead and buy some.",false,true,true);
               break;
            case 61:
               this.createTalkBox(9,param2,"Hello traveler.  Do you need to be healed?  I can heal you, I am a trained and licensed nurse.  Here you are, back to full health.");
               break;
            case 62:
               this.createTalkBox(0,param2,"Welcome... to the future!  Well, not really but everyone here loves robots and technology.  I am the local weapon and armor shop guy.  Can I interest you in anything?",false,true,true);
               break;
            case 63:
               this.createTalkBox(0,param2,"Welcome to Robo City home of the robos.  In Robo City electricity rules all.  If you mess with the robos or their electricity things could get ugly.");
               break;
            case 64:
               if(Stats.missionStats["Get Cassie Pumpkin Helmets"].started == false)
               {
                  this.createTalkBox(38,param2,"I LOVE robots!  I think they are the coolest thing in the whole wide world.  I tried to pet one once, but it punched me square in the face and knocked me out.  I didn\'t know some of them could be so mean!  If you see one, just be careful, they\'re not always friendly!   ...Oh hey, you look like you like to travel.  My second favorite thing is pumpkins.  Do you think you could get me two pumpkin helmets?");
               }
               else if(Boolean(Stats.missionStats["Get Cassie Pumpkin Helmets"].started) && Stats.missionStats["Get Cassie Pumpkin Helmets"].completed == false)
               {
                  if(this.countStringsInArray(this.personItem_array,"pumpkin helmet") < 2)
                  {
                     this.createTalkBox(0,param2,"Say, you don\'t seem to have the two pumpkins I asked for.  That\'s ok, I\'ll just sit here and cry and worship robots until you come back with two pumpkin helmets for little ol\' me...");
                  }
                  else if(this.countStringsInArray(this.personItem_array,"pumpkin helmet") >= 2 && this.player.bodyAnimator.helmetString == "pumpkin helmet")
                  {
                     this.createTalkBox(0,param2,"Hey, how am I supposed to take the pumpkin helmets from you if you have one of them equipped?");
                  }
                  else if(this.countStringsInArray(this.personItem_array,"pumpkin helmet") >= 2 && this.player.bodyAnimator.helmetString != "pumpkin helmet")
                  {
                     this.createTalkBox(39,param2,"Thanks for the pumpkin helmets!  Maybe now I can have something else to do instead of worship robots all day.");
                     this.c_mc.dude1_mc.body_mc.helmet_mc.gotoAndStop("pumpkin helmet");
                     this.vectorStringRemove(this.personItem_array,"pumpkin helmet");
                     this.vectorStringRemove(this.personItem_array,"pumpkin helmet");
                     this.theConnection.send("sellI","pumpkin helmet",false);
                     this.theConnection.send("sellI","pumpkin helmet",false);
                  }
               }
               else
               {
                  this.createTalkBox(0,param2,"Thanks for the pumpkin helmets, they\'re so cool looking!  Maybe if I wear it long enough, my head will BECOME a pumpkin!");
               }
               break;
            case 65:
               this.createTalkBox(0,param2,"Robo City sure is a cool place to be isn\'t it?  It\'s even cooler to live in Robo City.  I do all the paper work for the robots.  When a robot creates another robot, there is a lot paperwork that is involved.  What else would I have all of these drawers for?  They hold all my paperwork.");
               break;
            case 66:
               this.createTalkBox(0,param2,"Welcome to my tree fort.  I live out here in the rain forest away from everyone else.  It\'s peaceful out here but it can be very dangerous.  Some people come here just to see the lotus eyes, then short after they wind up in the hospital or dead.  Be careful out here, it\'s a dangerous place in the rain forest.  Say, do you need to buy anything?  I specialize in a many variety of food and potions.",false,true,true);
               break;
            case 67:
               this.createTalkBox(0,param2,"Out here in the wastelands is a scary place. Not only is it scary, but it\'s empty.  It\'s so empty I get bored just standing here.  I tell you what, sometimes I even get so bored I just punch myself in the face for fun.  Doesn\'t sound like a bad idea does it?  ...Watch yourself out here, night stalkers aren\'t friendly enemies.  One of my friends caught one and kept it as a pet.  The next day, it ate him for breakfast.  ..You better believe it.");
               break;
            case 68:
               if(Stats.missionStats["Complete Billbert\'s Puzzle"].started == false)
               {
                  this.createTalkBox(40,param2,"Hey man, how\'s it going?  Have you met my brother Albert?  He likes to spend most of his free time in the dungeon making puzzles and riddles for travelers.  He taught me how to make good puzzles too..  Talk to me again and I\'ll give you my puzzle to solve.");
               }
               else if(Stats.missionStats["Complete Billbert\'s Puzzle"].completed == false)
               {
                  if(this.player.name.length < 8)
                  {
                     if(this.player.bodyAnimator.helmetString != "clover hat")
                     {
                        this.createTalkBox(0,param2,"Here is my puzzle for you.  The number I give after their name is the number letter you should write down according to what they say.  Do not count punctuation.   Here are the clues: Blaire #29, Chad #2, Lewis #5, Cleveland #4, Barbara #2, Chipper #5.");
                     }
                     else
                     {
                        this.createTalkBox(41,param2,"Well done!  You\'ve solved my puzzle!  I love making puzzles as you can tell.  Good job, and be safe out there.");
                     }
                  }
                  else if(this.player.bodyAnimator.helmetString != "charm hat")
                  {
                     this.createTalkBox(0,param2,"Here is my puzzle for you.  The number I give after their name is the number letter you should write down according to what they say.  Do not count punctuation.   Here are the clues: Wayne #7, Snoop #6, Mitchel #10, Ralph #18, Alpipa #27.");
                  }
                  else
                  {
                     this.createTalkBox(41,param2,"Well done!  You\'ve solved my puzzle!  I love making puzzles as you can tell.  Good job, and be safe out there.");
                  }
               }
               else
               {
                  this.createTalkBox(0,param2,"Good work solving my puzzle.  And by the way, watch out for Carnelia, she\'s mean!  Along with puzzles I also like random facts.  Did you know that the skull crusher items are made from the bones of night stalkers?  The bones are then chemically infused with super strong metals to make them even tougher than beholder items.");
               }
               break;
            case 69:
               this.createTalkBox(0,param2,"I love my pets.  Even though pets can be very good fighters, you must always love them and treat them as you would like to be treated.  A loved pet also makes a stronger pet.  When a pet\'s love is high, it has a better chance of gaining more whenever it levels up.  So always make sure to keep your pet\'s love meter up.  And also, choose your companion pet wisely, you cannot remove a pet as your companion unless you permanently release him.  A pet that is your companion will feel extra loved, therefore making him potentially stronger than your other pets.");
               break;
            case 70:
               this.createTalkBox(0,param2,"Welcome to my home and shop.  I live here out in the darkness and I make a living from selling beholder and other high level items.  Dark Beholders are very very strong creatures.  It\'s an amazing thing that you\'ve made it here.  Perhaps I can interest you in some equipment?",false,true,true);
               break;
            case 71:
               this.createTalkBox(42,param2,"You are in the biggest building not only in Petropolis, but the biggest building on Elandra Island.  Here in this building we raise pets.  You can adopt them here.  Here are the ones I have ready for adoption.");
               break;
            case 72:
               this.createTalkBox(43,param2,"Pets pets pets!  You should always treat pets will love and respect.  A pet\'s base stats are indicative of their stats throughout their life as they level up.  This means, if one pet has a higher power than another, it is more likely to increase it\'s power during a level up.  ..Anyway, would you like to adopt some pets?");
               break;
            case 73:
               this.createTalkBox(44,param2,"A pet is a man\'s best friend.  Each pet has 3 different modes available to choose from.  Choose the mode that best fits your playing style.  During their 3rd form, some pets can even be ridden.  Would you like to give one of our precious pets a new home?");
               break;
            case 74:
               this.createTalkBox(45,param2,"All pets are born with the natural ability to form and travel in bubbles.  This is a unique ability they have that seperates them from the enemy world.  When a pet gets too far from you or is confused, they will often bubble to be next to you.  You can even tell the pet to bubble by pressing the Q key.  Remember that, it can often come in handy.  Aren\'t pets amazing creatures?  Would you like to adopt a new friend?");
               break;
            case 75:
               this.createTalkBox(0,param2,"I hate being on the bottom floor, why can\'t I sell stuff on the top floor?  ..Oh well.  Anyway, I specialize in selling pet helmets, are there any I could interest you in?",false,true,true);
               break;
            case 76:
               if(Stats.missionStats["Collect 4 Pets"].started == false)
               {
                  this.createTalkBox(46,param2,"Dude, I saw this guy with with a Marshraptor!  Man, those things look awesome!  Right now my Marshy has evolved, so he is a Marshruto.  I can\'t wait until he turns into a Marshraptor!  ..I tell you what, it\'s tough collecting pets.  I want to get 4 pets one day.  Do you have what it takes to get 4 pets?  I bet you can\'t.  I triple dog dare you!");
               }
               else if(Stats.missionStats["Collect 4 Pets"].completed == false && this.player.pet_array.length < 4)
               {
                  this.createTalkBox(0,param2,"You don\'t have what it takes to complete my triple dog dare?  Can\'t you collect 4 pets?  Maybe I will collect them before you do.");
               }
               else if(Stats.missionStats["Collect 4 Pets"].completed == false && this.player.pet_array.length >= 4)
               {
                  this.createTalkBox(47,param2,"Nicely done!  You got " + this.player.pet_array.length + " pets.  I didn\'t think you could do it.  Way to do man, you deserve and pat on the back, or something amazing like that.");
               }
               else
               {
                  this.createTalkBox(0,param2,"Your quite skilled you know that?  To collect 4 pets is awesome.  Me?  I guess I\'ll just sit here and cry because I\'m not as awesome as you.  That, or maybe I\'ll eat some burgers.");
               }
               break;
            case 77:
               if(Stats.missionStats["Ride a Pet"].started == false)
               {
                  this.createTalkBox(48,param2,"I used to have a Tebra a while ago...  But one day I was mad at him and I released him..  And now I miss him very badly.  I can\'t help but cry when I see a little Tebra.  I shouldn\'t have been so mad at him, he was just a little creature.  I was hoping that one day he would become a Tebrumpt and I could ride him, but he was taking too long and he made me mad.  Oh, what I wouldn\'t give just to see someone riding a pet...");
               }
               else if(Stats.missionStats["Ride a Pet"].completed == false && this.player.ridingPet == null)
               {
                  this.createTalkBox(0,param2,"Even though I know I\'ll never see my Tebra again, it sure would make me happy just to see someone with a smile on their face riding a pet they love.");
               }
               else if(Stats.missionStats["Ride a Pet"].completed == false && this.player.ridingPet != null)
               {
                  this.createTalkBox(49,param2,"Well, I can see you really love your " + this.player.ridingPet.type + ".  Cherish him and always treat him nicely.  Feed him treats and never get mad at him..  Thanks for showing me your pet mount, it made me happy.");
               }
               else
               {
                  this.createTalkBox(0,param2,"Thanks for showing me your pet mount.  It gave me hope that maybe one day I will find another pet to call my companion.");
               }
               break;
            case 78:
               this.createTalkBox(0,param2,"Weapons, armor, helmets, I\'ve got it all!  Most people come to check out Petropolis for it\'s pets, but I like to sell equipment in hopes that they\'ll spend their money with me.  Hehe!  If you buy a helmet, I\'ll give you half of a 2 year old already chewed up browny made from dirt.  Sounds like one awesome deal doesn\'t it?  ..Ok, maybe I\'m lying, but you should still buy something.",false,true,true);
               break;
            case 79:
               this.createTalkBox(0,param2,"Pets pets pets!  They\'re so awesome!  There are keys to keeping your pet happy and keeping his love up as much as possible.  Pets as you can imagine, like food.  Food can help raise their love.  Also, it\'s very mean to let a pet die.  Pets also get sad if they don\'t get used often.  You know what\'s the worst though?  Not using a pet and leaving him passed out with 0 health, that will surely lower their love fast.  A pet\'s love is a hard thing to manage, so don\'t study it too carefully because you never can tell.  Some people drive themselves MAD trying to get the pets love perfect.");
               break;
            case 80:
               this.createTalkBox(0,param2,"Just like us humans, there are many different ways to set up your pet!  Since pets don\'t have range or magic, instead they have luck, healing, and speed.  Archer based items usually increase a pets luck, magician based items usually increase its healing ability, and cowboy items increase the owner\'s movement speed.  The luck helps give the owner a better chance of receiving drops from enemies.  The healing allows the pet to heal the owner more health every so often.  Sometimes when my pet levels up it doesn\'t gain any points, which stinks.  But sometimes it gains a lot!");
               break;
            case 81:
               this.createTalkBox(0,param2,"If you buy a pet, be very careful with them.  A new pet starts at level one, so don\'t take them into areas with monsters too strong for them.  Think about it, would you try and fight strong monsters if you were level one?  No!  So don\'t be mean and make a pet fight a monster that will hurt him!   ..Also, did you know that a pet\'s feet are close to the same size as us humans?  That means they can wear the same shoes as we can!  One last thing.  A pet feels more love the more pets you have.  Pets like being with other pets, so its always good to own several pets.");
               break;
            case 82:
               this.createTalkBox(0,param2,"Did you know, that inactive pets still play an important roll?  Inactive pets that are not knocked out can use their spirit to effect their owner.  We like to call them \'pet spirit orbs\'.  The orbs grow bigger and stronger as a pet levels up.  These orbs add to a users power, range, and magic.");
               break;
            case 83:
               this.createTalkBox(50,param2,"Hello there!  How would you like to be rich beyond your wildest dreams?  Well you can be.  All you have to do is win the lottery.  We have two lotteries, the ticket lottery and the coin lottery.  Everytime somebody buys an entry for a lottery the jackpot increases.  Every entry you buy increases your chance of winning.  For those who win, they will have to check their ATM.  The next winner will be chosen on " + this.lotteryEndDate.toLocaleDateString() + ".  Perhaps I could interest you in some lottery entries?",true,false,false);
               break;
            case 84:
               this.createTalkBox(0,param2,"I\'m what they call a \'train-o-holic\'.  I think about trains all day and all night, non-stop.  I\'m constantly thinking about trains.  Infact, I wish I was a train.  I could stop if I wanted to.  There used to be a train that ran from Mushroom Village here at Aqualantis.  I sure do miss those days, and those trains.  Man do I love trains.");
               break;
            case 85:
               this.createTalkBox(0,param2,"Have you ever noticed it smells kind of weird when you\'re underwater?  It smells like strawberries down here.  If you press DOWN when you\'re near the bottom or top of a pipe, you will get sucked into the pipe.  It feels like it\'s going to rip your head off, but it doesn\'t.  Did you know simply by having a pet active it helps increase your chance of catching a fish?  By 20ms to be exact.  Hehe!");
               break;
            case 86:
               if(Stats.missionStats["Catch Every Fish"].started == false)
               {
                  this.createTalkBox(51,param2,"It\'s a nice place out here in Aqualantis.  I spend most of my time swimming.  I\'d go with a few of my buddies, but they\'re all afraid of the fish.  What a bunch of sissies.  I also like to fish.  Fish can come in handy, they can be eaten or sold for money.  How about I saw a shiny lion fish once!  It was AMAZING!  Unfortunately I wasn\'t able to catch it though, it was too quick for me.  You know what?  Do you think you could catch every type of fish, and then show me your Heropedia when you\'ve caught them all?  That would be so cool!");
               }
               else if(Stats.missionStats["Catch Every Fish"].completed == false)
               {
                  if(Stats.totalFishTypes != this.fishList_array.length)
                  {
                     this.createTalkBox(0,param2,"So have you caught every fish type yet?  No?..  It looks like you\'ve only caught " + this.fishList_array.length + " out of " + Stats.totalFishTypes + ".  You must be really bad at fishing or something.  Come on, catch all of them for me!");
                  }
                  else
                  {
                     this.createTalkBox(52,param2,"Wow, nice job!  It looks like you\'ve caught all of the different fish types.  You really are an amazing fisherman.  I... I think I might cry now at the site of all these beautiful fish.");
                  }
               }
               else
               {
                  this.createTalkBox(0,param2,"There you are.  You\'re the one that caught all of those fish!  I was telling my friends about you, they were amazed by your fishing skills.  My one friend was so amazed his jaw dropped down to the ground when I told him.  Now he has trouble eating.");
               }
               break;
            case 87:
               this.createTalkBox(0,param2,"Welcome to my fishing castle.  It\'s not a very big castle, but I still like to call it a castle.  Have you been fishing lately?  If not, you\'re going to need a fishing pole.  One pole is all you need, but you have to train your fishing skills to become better.  So how about you buy a fishing pole from me?",false,true,true);
               break;
            case 88:
               this.createTalkBox(9,param2,"Aqualantis is an amazing city.  It\'s where everyone starts their fishing journey.  It\'s a rough world out there though and you\'re always getting smashed up by monsters.  Perhaps I could heal you?");
               break;
            case 90:
               this.createTalkBox(0,param2,"Trees are a beauty of nature, they can be used for so many different things.  Cutting down trees is good for harnessing their wood but be sure to plant trees as well.  The world needs more trees!  Not only that, it\'s good for your chopping level.  Each time you plant a tree, you gain chopping experience.  On another note, the larger the tree the more logs it produces.  Each tree has three forms.  In their 1st sapling form, trees produce little to no wood when cut down.  So it\'s best to let them grow to their 3rd and fullest form.  By the way, use the C key to target trees.");
               break;
            case 91:
               this.createTalkBox(0,param2,"This is my own personal swimming hole.  Everyone I know loves swimming under the waterfall.  If your cold then swim by me, I give off a warm feeling if your near.  Not only do I have the ability to make water warmer, if I\'m in snowy flatts I also have the amazing ability to create yellow snow.  My friends call me a magician because of it.  Haha, I\'m just that awesome!");
               break;
            case 92:
               this.createTalkBox(53,param2,"Ahoy there matey, could I interest yee in wood fabrication?  I can help yee take some of em\' there logs yee might have and turn em\' intah\' some processed wood.  Ya see, wood is better for building things.  Yee can\'t build anything out of just plain logs!  Ya need a good slid chunk of wood!");
               break;
            case 93:
               this.createTalkBox(54,param2,"Do you have any logs on you?  If so, here at Pablo\'s I can refine and process those logs into ready-to-use wood.  Wood is needed to built all sorts of weapons and armor.  Now what might I help you craft?");
               break;
            case 94:
               this.createTalkBox(55,param2,"I, like my brother Wood Man Tim, also can help you craft processed wood.  You will need 10 of a log to make it into good wood that can be crafted with.  By the way, did you know fish are a vital part of crafting?  The fish don\'t get killed or smooshed into equipment, they are just needed because their scales and body contain important DNA that must be replicated when crafting weapons and armors.  That way, the fish aren\'t harmed.  Now what can I help you with?");
               break;
            case 95:
               this.createTalkBox(56,param2,"Yo yo yo!  Welcome to the crafting area.  We can help you craft items out of the materials you collect.  I have some armor perhaps I could help craft for you?  Now what can I interest you in?");
               break;
            case 96:
               this.createTalkBox(57,param2,"I like to stay in here away from the dark beholder and kreetons.  Not because I\'m scared, but because they\'re afraid of me.  I don\'t want to frighten them, you know?  Anyway, I can help you build some armor and such.  What would you like to build.");
               break;
            case 97:
               this.createTalkBox(0,param2,"Welcome to the Pet Adoption District.  Here you will find a bunch pets that other players have placed up for adoption.  These pets can range from very strong to weak.  Either way, they are in need of a loving owner and home, so please adopt them!");
               break;
            case 98:
               if(Stats.missionStats["Solve Philbert\'s Puzzle"].started == false)
               {
                  this.createTalkBox(58,param2,"It\'s a rough rough world out here.  This land here is hot, deadly, and full of death.  I reckon\' I don\'t know how much longer I can take the heat...  If the heat doesn\'t get to me, I\'m sure a magmagon will.  If only I could have one last bit of fun, like a game or puzzle.  My brothers Albert and Bilbert always liked puzzles.  You, you brave brave soul.  Could you solve my puzzle?");
               }
               else if(Stats.missionStats["Solve Philbert\'s Puzzle"].completed == false)
               {
                  if(this.player.name.length <= 10)
                  {
                     if(this.player.bodyAnimator.shirtString != "red shirt")
                     {
                        this.createTalkBox(0,param2,"Here\'s how the riddle works.  I will give you a hint, the hint will be referencing a person that you can talk to.  You must find this person and wear the same shirt as them.   Here is your hint: \'I like to chill.\'");
                     }
                     else
                     {
                        this.createTalkBox(59,param2,"Wow, nice job!  You\'ve solved my puzzle.  This is what I\'ve lived my entire life for.  All of my life has led up to this one, special, amazing moment.  What a gift you are.  My life dream has finally come true.  Seeing somebody in a red shirt.  Wow, I sure do set my goals in life high.  Occasionally I amaze even myself.  ...I take that back, I ALWAYS amaze myself!");
                     }
                  }
                  else if(this.player.bodyAnimator.shirtString != "white shirt")
                  {
                     this.createTalkBox(0,param2,"Here\'s how the riddle works.  I will give you a hint, the hint will be referencing a person that you can talk to.  You must find this person and wear the same shirt as them.   Here is your hint: \'We may be dumb, but we ain\'t stupid.  I ain\'t angry, I\'m just mad!\'");
                  }
                  else
                  {
                     this.createTalkBox(59,param2,"Wow, nice job!  You\'ve solved my puzzle.  This is what I\'ve lived my entire life for.  All of my life has led up to this one, special, amazing moment.  What a gift you are.  My life dream has finally come true.  Seeing somebody in a white shirt.  Wow, I sure do set my goals in life high.  Occasionally I amaze even myself.  ...I take that back, I ALWAYS amaze myself!");
                  }
               }
               else
               {
                  this.createTalkBox(0,param2,"I reckon\' I should thank you again for doing that puzzle of mine.  It sure was an amazing sight.  Now I\'m back to square one, sitting here roasting to death \'cause it\'s so hot.  Maybe if I spit on myself I can survive. ... *sniff*, *hock*, *spit!*");
               }
               break;
            case 99:
               this.createTalkBox(60,param2,"It\'s a hot, mean, nasty world out here.  You have to be the toughest of the tough to survive.  How about I craft some new equipment for you?  You can never go wrong with wearing the best equipment that is available, especially when your in an area as rough as this.");
               break;
            case 100:
               this.createTalkBox(61,param2,"Wooo!  It\'s hotter than a magmagon\'s rear end after eating a habanero!  I bet I could be of some help to you.  Would you like me to craft some items?");
               break;
            case 101:
               this.createTalkBox(0,param2,"You can never overprotect your pet.  Only the best of the best for my pet is what I say!  I can sell you some high level pet helmets, are you interested?",false,true,true);
               break;
            case 102:
               this.createTalkBox(62,param2,"I bet you could use some strong equipment!  There\'s no doubt you will need it in a savage place like this.  I can offer you some, but you must pay a hefty price.");
               break;
            case 103:
               this.createTalkBox(0,param2,"The trains went out of business some time ago.  Operating costs for the trains became to high, so they had to shut em\' down.  So now if you want to get to Aqualantis you\'re going to have to walk the tracks.");
               break;
            case 104:
               if(Stats.missionStats["Reach High Energy Level"].started == false)
               {
                  this.createTalkBox(63,param2,"Man, I tell ya what..  I\'ve seen some POWERFUL players walk through here.  Some of them were so powerful, they were making everything around them blow away!  It\'s my goal to one day become so powerful, that everyone talks about me and my high energy levels.  I tell ya what, I bet you can\'t reach an energy level of 9000.");
               }
               else if(Stats.missionStats["Reach High Energy Level"].completed == false)
               {
                  this.createTalkBox(0,param2,"Energy, energy, energy!  I\'m so weak right now, but I am getting stronger.  I hit a max energy level of 2,450!  That may not be super high, but it\'s high to me.  Have you worked on reaching an energy level of 9,000 yet?  I bet you can\'t!");
               }
               else
               {
                  this.createTalkBox(0,param2,"Wow!!  You hit an energy level over 9,000!  Your nuts!  I wish I could be as powerful as you...  I\'ve seen guys even higher than 9,000 though.  The strongest guy I\'ve ever seen was around 17,000.  CRAZY POWERFUL!");
               }
               break;
            case 105:
               this.createTalkBox(64,param2,"This acid is rough out here.  It burns, it\'s slippery, and it makes me trip.  It\'d make for a good addition to a weapon though.  Image you covered your weapon in acid.  Ouch!  I\'ve got some things I can sell and craft for you.  It\'s good to keep a stock of equipment out here in a dangerous place like this.");
               break;
            case 106:
               this.createTalkBox(65,param2,"I tell you what boy, it sure is a nasty world out here.  Krakens and acid are enough to drive you crazy.  You better be equipped with the best gear there is if you want to survive.  Perhaps I could interest you in some?");
               break;
            case 107:
               this.createTalkBox(66,param2,"Hello, I am Isaac Jr.  I am the son of my father.  My father is also my dad.  You must be very strong to have made your way all the way here.  I can sell you some weapons and armor to help you in your journey.");
               break;
            case 108:
               this.createTalkBox(67,param2,"This is my shack, it ain\'t half bad is it?  It\'s a rough place out here in Acid Village.  Honestly I didn\'t even want to live out here, but I travelled out here and was never able to go back because of the Krakens.  ...Anyway bro, I got this gun I stole from Isaac\'s shop.  Would you want to buy it?");
               break;
            case 109:
               if(this.player.health < this.player.totalHealth * 0.25)
               {
                  this.createTalkBox(9,param2,"Suh dude?  Running this healing shack I get quite a lot of visitors who have got rekt by krakens and bullopedes.  You look like you got owned pretty bad.  Maybe you should git good?  I\'ll heal you up so you can go pwn noobs and bullopedes.");
               }
               else
               {
                  this.createTalkBox(9,param2,"Suh?  Do you like it here in my healing shack?  A lot of folks come here who have gotten pretty shrekt by bullopedes.  I\'ve been eaten by a bullopede once, but some leet haxor person came and saved me.  I\'ll heal you incase you need to take on an almighty bullopede.");
               }
               break;
            case 110:
               this.createTalkBox(0,param2,"Shoes, let\'s get some shoes.  I love shoes.  I am Sam\'s twin brother.  We make a pretty good living off of selling shoes.  Would you like to buy some?",false,true,true);
               break;
            case 111:
               this.createTalkBox(68,param2,"Cloud Kingdom, the amazing place in the world.  You will never feel as serene as you do here.  It is a truly amazing place.  Have you managed to get past the vicious omega fluffs?  Anyway, how about I sell you some SERIOUS equipment?");
               break;
            case 112:
               this.createTalkBox(69,param2,"Weapons...  That is the only thing that will help you tackle these super wicked omega fluffs.  They may have a charming name, but let me tell you what..  They will rip you a new one!");
               break;
            case 113:
               this.createTalkBox(0,param2,"Welcome to Cloud Kingdom the most fascinating place in all of the world.  Even though it is a purely beautiful place, there still lurks the omega fluffs in all corners.");
         }
      }
      
      public function debugCommand(param1:String) : void
      {
         var _loc2_:Enemy = null;
         _loc2_ = null;
         switch(param1)
         {
            case "removeDebugMenu":
               this.removeDebugMenu();
               break;
            case "getAllInfo":
               this.addDebugText("-----Client Info------");
               this.addDebugText("enemy array length: " + this.e_array.length);
               this.addDebugText("player array length: " + this.p_array.length);
               this.addDebugText("item array length: " + this.item_array.length);
               this.addDebugText("has connection to server: " + this.theConnection.connected);
               this.addDebugText("...server stats should be listed below.");
               this.theConnection.addMessageHandler("debugSGot",this.debugStatsGot);
               this.theConnection.send("geSerStats");
               break;
            case "getNumPets":
               this.addDebugText("client pet array length: " + this.pet_array.length);
               break;
            case "tellCommands":
               this.addDebugText("Use the following commands: \"getAllInfo\", \"getNumPets\", \"getPings\", \"debugSmall\", \"debugBig\", \"getRoomInfo\", \"showRedrawRegions\", \"hideRedrawRegions\", \"showStats, \"hideStats\",\"getRenderMode\",\"getDPI\",\"getRed\"");
               break;
            case "getPings":
               this.theConnection.send("requestPings");
               this.addDebugText("users pings will be displayed below");
               break;
            case "doDevStuff":
               this.theConnection.send("doDevStuff");
               this.addDebugText("Do developer related fuunction.");
               break;
            case "debugSmall":
               this.debugMenu.gotoAndStop("small");
               break;
            case "debugBig":
               this.debugMenu.gotoAndStop("big");
               break;
            case "enemyNames":
               for each(var _loc5_ in this.e_array)
               {
                  _loc2_ = _loc5_;
                  _loc5_;
                  this.addDebugText(_loc2_.name);
               }
               break;
            case "getRoomInfo":
               this.addDebugText("RoomID: " + this.theConnection.roomId);
               this.theConnection.addMessageHandler("gotRoomInfo",this.roomNameGot);
               this.theConnection.send("geRoomInfo");
               break;
            case "exportControls":
               if(this.controllerMain != null)
               {
                  this.addDebugText("case \"" + this.controllerMain.name + "\":\n" + "upButton_string = \"" + this.upButton_string + "\";\n" + "leftButton_string = \"" + this.leftButton_string + "\";\n" + "rightButton_string = \"" + this.rightButton_string + "\";\n" + "downButton_string = \"" + this.downButton_string + "\";\n" + "attackButton_string = \"" + this.attackButton_string + "\";\n" + "lootButton_string = \"" + this.lootButton_string + "\";\n" + "jumpButton_string = \"" + this.jumpButton_string + "\";\n" + "rageButton_string = \"" + this.rageButton_string + "\";\n" + "guildRageButton_string = \"" + this.guildRageButton_string + "\";\n" + "healButton_string = \"" + this.healButton_string + "\";\n" + "guildHealButton_string = \"" + this.guildHealButton_string + "\";\n" + "downButtonDir = " + this.downButtonDir + ";\n" + "cButton_string = \"" + this.cButton_string + "\";\n" + "vButton_string = \"" + this.vButton_string + "\"");
               }
               else
               {
                  this.addDebugText("controller not set");
               }
               break;
            case "startRoboInvasion":
               if(this.player.name == "littlebob" || this.player.name == "robby" || this.player.name == "boogerBilly" || this.player.name == "coke_na_rc")
               {
                  this.theConnection.send("startRoboInvasion");
               }
               break;
            case "showRedrawRegions":
               showRedrawRegions(true,16777215);
               break;
            case "hideRedrawRegions":
               showRedrawRegions(false,16777215);
               break;
            case "showStats":
               this.mainStarling.showStats = true;
               break;
            case "hideStats":
               this.mainStarling.showStats = false;
               break;
            case "getRenderMode":
               this.addDebugText(this.mainStarling.context.driverInfo);
               break;
            case "getDPI":
               this.addDebugText("Screen DPI: " + Capabilities.screenDPI);
               break;
            case "getRes":
               this.addDebugText("Resolution: " + Capabilities.screenResolutionX + " x " + Capabilities.screenResolutionY);
               break;
            case "power100":
               if(this.player.name == "robby" || this.player.name == "boogerBilly")
               {
                  this.player.energyController.charge = 1;
                  this.player.energyController.absorbed = 1;
                  this.player.energyController.enemy = 1;
                  this.player.energyController.level = 1;
                  this.player.energyController.rage = 1;
                  this.player.energyController.pvp = 1;
                  this.player.energyController.random = 1;
                  this.player.energyController.chop = 1;
                  this.player.energyController.fish = 1;
               }
               break;
            case "power50":
               if(this.player.name == "robby" || this.player.name == "boogerBilly")
               {
                  this.player.energyController.charge = 0.5;
                  this.player.energyController.absorbed = 0.5;
                  this.player.energyController.enemy = 0.5;
                  this.player.energyController.level = 0.5;
                  this.player.energyController.rage = 0.5;
                  this.player.energyController.pvp = 0.5;
                  this.player.energyController.random = 0.5;
                  this.player.energyController.chop = 0.5;
                  this.player.energyController.fish = 0.5;
               }
               break;
            case "mod":
               if(this.player.name == "coke_na_rc" || this.player.name == "boogerBilly" || this.player.name == "testman33" || this.player.name == "robby")
               {
                  this.moderatorMenu = new ModeratorMenu();
                  this.moderatorMenu.x = 100;
                  this.moderatorMenu.y = 100;
                  addChild(this.moderatorMenu);
               }
               break;
            case "getURL":
               this.addDebugText("playingURL_string: " + this.playingURL_string);
         }
      }
      
      private function addDebugText(param1:String) : void
      {
         this.debugMenu.debug_txt.appendText(param1 + "\n");
      }
      
      private function removeDebugMenu() : void
      {
         removeChild(this.debugMenu);
      }
      
      private function createPortal(param1:uint, param2:int, param3:int) : Image
      {
         var _loc4_:Image = null;
         var _loc5_:LightStyle = null;
         _loc4_ = null;
         _loc5_ = null;
         _loc4_ = new Image(Assets.treesFish_textureAtlas.getTexture("portal"));
         _loc4_.x = param2;
         _loc4_.y = param3 - 5;
         _loc4_.pivotX = _loc4_.width / 2;
         _loc4_.pivotY = _loc4_.height;
         _loc4_.touchable = false;
         _loc4_.textureSmoothing = TextureSmoothing.NONE;
         _loc4_.name = "portal" + param1;
         this.portal_array.push(_loc4_);
         SortDepths.addAt(_loc4_,SortDepths.REGION_2);
         if(GameMain.lighting)
         {
            _loc5_ = new LightStyle(Assets.treeFishLighMap_textureAtlas.getTexture("portal"));
            _loc5_.ambientRatio = 0.2;
            _loc5_.diffuseRatio = 0.8;
            _loc5_.specularRatio = 0.4;
            _loc5_.shininess = 8;
            _loc5_.textureSmoothing = TextureSmoothing.NONE;
            _loc4_.style = _loc5_;
         }
         return _loc4_;
      }
      
      private function createATM(param1:int, param2:int, param3:int = 1) : void
      {
         var _loc4_:ATM = null;
         _loc4_ = null;
         _loc4_ = new ATM();
         _loc4_.x = param1 + 50;
         _loc4_.y = param2 + 72;
         SortDepths.addAt(_loc4_,param3 == 0 ? SortDepths.REGION_2 : SortDepths.REGION_4);
      }
      
      private function geAtmGot(param1:Message, param2:int, param3:int, param4:int) : void
      {
         this.createATM(param2 + 33,param3 + 51,param4);
      }
      
      private function buildLevel(param1:int) : void
      {
         switch(param1)
         {
            case 55:
               this.createATM(1693,694);
               break;
            case 12:
               this.createATM(863,1349);
               break;
            case 83:
               this.createATM(3534,689);
               break;
            case 30:
               this.createATM(3503,355);
               break;
            case 97:
               this.createATM(3896,364);
               break;
            case 138:
               this.createATM(3660,1182);
         }
      }
      
      public function get isPvpArea() : Boolean
      {
         return this.c_mc.currentFrame == 112 || this.c_mc.currentFrame == 113 || this.c_mc.currentFrame == 114 || this.serverName == "PvP Server";
      }
      
      public function arrayStringRemove(param1:*, param2:String, param3:Boolean = false) : Boolean
      {
         this.len5 = param1.length;
         this.w = 0;
         while(this.w < this.len5)
         {
            if(param1[this.w] == param2)
            {
               param1.removeAt(this.w);
               if(param3 == false)
               {
                  return true;
               }
            }
            ++this.w;
         }
         return false;
      }
      
      public function vectorStringRemove(param1:Vector.<String>, param2:String, param3:Boolean = false) : Boolean
      {
         this.len5 = param1.length;
         this.w = 0;
         while(this.w < this.len5)
         {
            if(param1[this.w] == param2)
            {
               param1.removeAt(this.w);
               if(param3 == false)
               {
                  return true;
               }
            }
            ++this.w;
         }
         return false;
      }
      
      private function countStringsInArray(param1:*, param2:String) : uint
      {
         this.a = 0;
         this.len3 = param1.length;
         this.b = 0;
         while(this.b < this.len3)
         {
            if(param1[this.b] == param2)
            {
               ++this.a;
            }
            ++this.b;
         }
         return this.a;
      }
      
      private function countStringsInVector(param1:Vector.<String>, param2:String) : uint
      {
         this.a = 0;
         this.len3 = param1.length;
         this.b = 0;
         while(this.b < this.len3)
         {
            if(param1[this.b] == param2)
            {
               ++this.a;
            }
            ++this.b;
         }
         return this.a;
      }
      
      public function checkParameter(param1:*, ... rest) : Boolean
      {
         var _loc3_:* = undefined;
         _loc3_ = undefined;
         for each(var _loc6_ in rest)
         {
            _loc3_ = _loc6_;
            _loc6_;
            if(param1 == _loc3_)
            {
               return true;
            }
         }
         return false;
      }
      
      private function loopArray(param1:Array, param2:Function) : void
      {
         this.len4 = param1.length;
         this.q = this.len4 - 1;
         while(this.q >= 0)
         {
            param2(param1[this.q],this.q);
            --this.q;
         }
      }
      
      private function reverseString(param1:String) : String
      {
         var _loc2_:Array = null;
         _loc2_ = null;
         var _loc3_:String = null;
         _loc2_ = param1.split("");
         _loc2_.reverse();
         return _loc2_.join("");
      }
      
      private function setMisc() : void
      {
         var tempFocusImage:Image = null;
         tempFocusImage = null;
         Assets.init(lighting);
         this.createPerson(String("FakeName" + int(Math.random() * 99999)),-350 + Math.random() * 750,-330,1,2,1,1,1,1,1,1,1,3,200,200,1,1,0,3,0,0,0,4,1,0);
         this.player = this.p_array[0];
         this.c_mc.mouseEnabled = false;
         this.createMMenu();
         this.changeLevel(1,"portal2");
         if(this.country == "Philippines" && this.playingURL_string != "helmet-heroes.com" && isMobile == false)
         {
            navigateToURL(new URLRequest("http://p255370.clksite.com/adServe/banners?tid=IF1HELMET_DIRECT&action=r"));
         }
         tempFocusImage = new Image(Assets.items_textureAtlas.getTexture("firefly"));
         tempFocusImage.x = 890 / Starling.contentScaleFactor;
         tempFocusImage.y = -643 / Starling.contentScaleFactor;
         this.focusLevel(tempFocusImage);
         tempFocusImage.removeFromParent(true);
         if(Starling.contentScaleFactor == 1)
         {
            AreaCreator.background1.x = AreaCreator.background1.x + 40 / Starling.contentScaleFactor;
            AreaCreator.background1.y = AreaCreator.background1.y - 610 / Starling.contentScaleFactor;
            AreaCreator.background2.x = AreaCreator.background2.x + 200 / Starling.contentScaleFactor;
            AreaCreator.background2.y = AreaCreator.background2.y - 300 / Starling.contentScaleFactor;
            AreaCreator.background3.x = AreaCreator.background3.x + 300 / Starling.contentScaleFactor;
            AreaCreator.background3.y = AreaCreator.background3.y - 200 / Starling.contentScaleFactor;
         }
         else
         {
            AreaCreator.background1.x = 0;
            AreaCreator.background1.y = 0;
            AreaCreator.background2.x = 0;
            AreaCreator.background2.y = 0;
            AreaCreator.background3.x = 0;
            AreaCreator.background3.y = 0;
         }
         AreaCreator.gameMain = this;
         AreaCreator.getBGArt(this.c_mc.currentFrame,function():void
         {
            starlingStage.addChildAt(AreaCreator.sky,0);
            if(GameMain.__isMobile)
            {
               adjustFullScreen(true);
            }
            if(stage.quality == StageQuality.LOW.toUpperCase())
            {
               starlingStage.removeChild(AreaCreator.background1);
               starlingStage.removeChild(AreaCreator.background2);
               starlingStage.removeChild(AreaCreator.background3);
               if(AreaCreator.cloud1 != null)
               {
                  starlingStage.removeChild(AreaCreator.cloud1);
                  starlingStage.removeChild(AreaCreator.cloud2);
               }
               AreaCreator.sky.height = Starling.current.viewPort.height;
            }
         });
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKDown);
         Cursor.init();
         if((this.fakeCursor == null || this.fakeCursor.parent == null) && GameInput.numDevices > 0)
         {
            this.fakeCursor = new FakeCursor();
            addChild(this.fakeCursor);
         }
         this.shortcutItem = this.save_sharedObject.data.shortcutItem != undefined ? this.save_sharedObject.data.shortcutItem : "";
         OptionMenu.ignoreTrades = this.save_sharedObject.data.ignoreTrades != undefined ? Boolean(this.save_sharedObject.data.ignoreTrades) : false;
         OptionMenu.ignorePMs = this.save_sharedObject.data.ignorePMs != undefined ? Boolean(this.save_sharedObject.data.ignorePMs) : false;
         stage.quality = this.save_sharedObject.data.quality != undefined ? this.save_sharedObject.data.quality.toUpperCase() : StageQuality.HIGH.toUpperCase();
         OptionMenu.controllerOn = this.save_sharedObject.data.controllerOn != undefined ? Boolean(this.save_sharedObject.data.controllerOn) : true;
         if(this.save_sharedObject.data.musicOn != undefined && this.save_sharedObject.data.musicOn != SoundManager.musicOn)
         {
            SoundManager.toggleMusic();
         }
         if(this.save_sharedObject.data.soundOn != undefined && this.save_sharedObject.data.soundOn != SoundManager.soundOn)
         {
            SoundManager.toggleSound();
         }
         if(this.save_sharedObject.data.quality == undefined)
         {
            if(PerformanceIndex.getPerformance() > 115)
            {
               stage.quality = StageQuality.LOW.toUpperCase();
            }
            else if(isMobile)
            {
               stage.quality = StageQuality.MEDIUM.toLowerCase();
            }
         }
      }
      
      public function onKDown(param1:KeyboardEvent) : void
      {
         var _loc2_:Enemy = null;
         _loc2_ = null;
         this.idleCounter = 0;
         if(this.tutorial != null && this.tutorial.parent != null)
         {
            this.dismissTutorial();
         }
         if(stage.focus == null && this.theConnection != null && this.theConnection.connected || param1.keyCode == Keyboard.ENTER)
         {
            if(this.tradeMenu != null && this.tradeMenu.parent != null)
            {
               this.createAlert("Cannot move while trading.");
               return;
            }
            switch(param1.keyCode)
            {
               case Keyboard.O:
                  this.player.keyHandler.keyPress(Keyboard.O);
                  break;
               case Keyboard.UP:
                  this.player.keyHandler.keyPress(Keyboard.UP);
                  break;
               case Keyboard.DOWN:
                  this.pressDown();
                  break;
               case Keyboard.LEFT:
                  this.player.keyHandler.keyPress(Keyboard.LEFT);
                  break;
               case Keyboard.RIGHT:
                  this.player.keyHandler.keyPress(Keyboard.RIGHT);
                  break;
               case Keyboard.A:
                  this.player.keyHandler.keyPress(Keyboard.LEFT);
                  break;
               case Keyboard.D:
                  this.player.keyHandler.keyPress(Keyboard.RIGHT);
                  break;
               case Keyboard.S:
                  this.pressDown();
                  break;
               case Keyboard.W:
                  this.player.keyHandler.keyPress(Keyboard.UP);
                  break;
               case Keyboard.B:
                  this.player.keyHandler.keyRelease(this.player.moveDir == 1 ? uint(Keyboard.RIGHT) : uint(Keyboard.LEFT));
                  this.player.keyHandler.keyPress(this.player.moveDir == 1 ? uint(Keyboard.RIGHT) : uint(Keyboard.LEFT));
                  this.player.keyHandler.keyPress(Keyboard.SPACE);
                  break;
               case Keyboard.N:
                  this.player.keyHandler.keyPress(Keyboard.DOWN);
                  this.player.keyHandler.keyPress(Keyboard.SPACE);
                  break;
               case Keyboard.M:
                  this.player.keyHandler.keyPress(Keyboard.UP);
                  this.player.keyHandler.keyPress(Keyboard.SPACE);
                  break;
               case Keyboard.C:
                  this.player.keyHandler.keyPress(param1.keyCode);
                  break;
               case 81:
                  this.player.keyHandler.keyPress(param1.keyCode);
                  break;
               case Keyboard.E:
                  this.player.keyHandler.keyPress(param1.keyCode);
                  break;
               case Keyboard.H:
                  this.player.keyHandler.keyPress(param1.keyCode);
                  break;
               case 71:
                  this.player.keyHandler.keyPress(param1.keyCode);
                  break;
               case Keyboard.R:
                  this.player.keyHandler.keyPress(param1.keyCode);
                  break;
               case Keyboard.T:
                  this.player.keyHandler.keyPress(param1.keyCode);
                  break;
               case Keyboard.K:
                  this.player.keyHandler.keyPress(param1.keyCode);
                  break;
               case Keyboard.V:
                  this.player.keyHandler.keyPress(param1.keyCode);
                  break;
               case Keyboard.Z:
                  if(this.player.isControllingEnemy)
                  {
                     for each(var _loc5_ in this.e_array)
                     {
                        _loc2_ = _loc5_;
                        _loc5_;
                        if(_loc2_.controlling_person == this.player)
                        {
                           _loc2_.noControlMe();
                           break;
                        }
                     }
                  }
                  else if(this.hasManualControl && this.player.activePets.length > 0)
                  {
                     this.player.togglePetControl();
                  }
                  break;
               case Keyboard.SPACE:
                  this.player.keyHandler.keyPress(param1.keyCode);
                  break;
               case Keyboard.ENTER:
                  this.idleCounter = 0;
                  this.enterDown = true;
                  if(stage.focus is flash.text.TextField && stage.focus.name == "password_txt" && this.mMenu.username_txt.length > 0)
                  {
                     this.signInCheck();
                  }
                  else if(stage.focus is flash.text.TextField && stage.focus.name == "debugInput_txt")
                  {
                     this.debugCommand(this.debugMenu.debugInput_txt.text);
                     this.debugMenu.debugInput_txt.text = "";
                  }
                  else if(stage.focus is flash.text.TextField && stage.focus.name == "search_txt")
                  {
                     this.theClient.bigDB.loadRange("guildsData","nameIndex",[],this.guildMenu.search_txt.text,this.guildMenu.search_txt.text,1,this.guildMenu.guildsLoaded);
                     this.guildMenu.gotoAndStop(1);
                     this.guildMenu.updateMe(this.player.guild);
                  }
                  else if(param1.altKey == true)
                  {
                     if(stage.displayState == StageDisplayState.NORMAL)
                     {
                        stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
                     }
                     else
                     {
                        stage.displayState = StageDisplayState.NORMAL;
                     }
                  }
                  break;
               case Keyboard.SHIFT:
                  if(this.mMenu == null || this.mMenu.parent == null)
                  {
                     this.starlingStage.controls.message_txt.setFocus();
                  }
                  break;
               case Keyboard.Y:
                  this.player.keyHandler.keyPress(param1.keyCode);
            }
         }
      }
      
      public function onKUp(param1:KeyboardEvent) : void
      {
         var e:KeyboardEvent = param1;
         var n_leftLift:Function = function():void
         {
            if(theConnection != null && theConnection.connected)
            {
               player.keyHandler.keyRelease(Keyboard.LEFT);
            }
         };
         var n_rightLift:Function = function():void
         {
            if(theConnection != null && theConnection.connected)
            {
               player.keyHandler.keyRelease(Keyboard.RIGHT);
            }
         };
         if(stage.focus == null && this.theConnection != null && this.theConnection.connected)
         {
            switch(e.keyCode)
            {
               case Keyboard.ENTER:
                  this.enterDown = false;
                  break;
               case Keyboard.O:
                  this.player.keyHandler.keyRelease(Keyboard.O);
                  break;
               case Keyboard.L:
                  if(stage.focus == null)
                  {
                     this.useItem(this.shortcutItem);
                  }
                  break;
               case Keyboard.UP:
                  this.player.keyHandler.keyRelease(Keyboard.UP);
                  break;
               case Keyboard.DOWN:
                  this.player.keyHandler.keyRelease(Keyboard.DOWN);
                  break;
               case Keyboard.LEFT:
                  n_leftLift();
                  break;
               case Keyboard.RIGHT:
                  n_rightLift();
                  break;
               case 65:
                  n_leftLift();
                  break;
               case 68:
                  n_rightLift();
                  break;
               case Keyboard.B:
                  this.player.keyHandler.keyRelease(this.player.moveDir == 1 ? uint(Keyboard.RIGHT) : uint(Keyboard.LEFT));
                  this.player.keyHandler.keyRelease(Keyboard.SPACE);
                  break;
               case Keyboard.N:
                  this.player.keyHandler.keyRelease(Keyboard.DOWN);
                  this.player.keyHandler.keyRelease(Keyboard.SPACE);
                  break;
               case Keyboard.M:
                  this.player.keyHandler.keyRelease(Keyboard.UP);
                  this.player.keyHandler.keyRelease(Keyboard.SPACE);
                  break;
               case Keyboard.S:
                  this.player.keyHandler.keyRelease(Keyboard.DOWN);
                  break;
               case Keyboard.W:
                  this.player.keyHandler.keyRelease(Keyboard.UP);
                  break;
               case Keyboard.E:
                  this.player.keyHandler.keyRelease(e.keyCode,false);
                  break;
               case 67:
                  this.player.keyHandler.keyRelease(Keyboard.C);
                  this.theConnection.send("ku",Keyboard.C);
                  break;
               case Keyboard.V:
                  this.player.keyHandler.keyRelease(e.keyCode);
                  break;
               case Keyboard.Q:
                  this.player.keyHandler.keyRelease(e.keyCode);
                  break;
               case Keyboard.SPACE:
                  this.player.keyHandler.keyRelease(e.keyCode);
                  break;
               case Keyboard.K:
                  this.player.keyHandler.keyRelease(e.keyCode);
                  break;
               case Keyboard.H:
                  this.player.keyHandler.keyRelease(e.keyCode);
                  break;
               case Keyboard.R:
                  this.player.keyHandler.keyRelease(e.keyCode);
                  break;
               case Keyboard.G:
                  this.player.keyHandler.keyRelease(e.keyCode);
                  break;
               case Keyboard.T:
                  this.player.keyHandler.keyRelease(e.keyCode);
                  break;
               case Keyboard.Y:
                  this.player.keyHandler.keyRelease(e.keyCode);
            }
         }
      }
      
      private function pressDown() : void
      {
         var n_testPortal:Function = function(param1:String, param2:int):void
         {
            if(param2 > 0 && a == 0)
            {
               if(starlingStage.c_mc.getChildByName(param1) != null && player.hitTester.hit_rect.intersects(starlingStage.c_mc.getChildByName(param1).getBounds(starlingStage.c_mc)) && player.gravityObject.onGround && levelChangeCounter > 120)
               {
                  if(player.powerUpVisuals.unleashing)
                  {
                     createAlert("Cannot change areas while unleashing energy");
                  }
                  else
                  {
                     SoundManager.playSound(SoundLibrary.teleport_sound,player.x,player.y,true,starlingStage.c_mc);
                     changeLevel(param2,param1);
                     lastPortal = uint(param1.replace("portal",""));
                     ++a;
                  }
               }
            }
         };
         if((this.cutscene_loader == null || this.cutscene_loader.parent == null) && this.player.fishing == false && StarlingGameMenu.menu_array.indexOf(this.tradeMenu) == -1 && this.lastTradeCounter > 300 && StarlingGameMenu.menu_array.indexOf(this.bankMenu) == -1)
         {
            if(this.player.keyHandler.keyStates.getKeyState(Keyboard.DOWN).isDown == false)
            {
               this.player.keyHandler.keyPress(Keyboard.DOWN);
               if(this.player.isControllingPet == false && this.player.isControllingEnemy == false)
               {
                  this.a = 0;
                  n_testPortal("portal1",Stats.levelStats[this.c_mc.currentFrame].portal1Lead);
                  n_testPortal("portal2",Stats.levelStats[this.c_mc.currentFrame].portal2Lead);
                  n_testPortal("portal3",Stats.levelStats[this.c_mc.currentFrame].portal3Lead);
                  n_testPortal("portal4",Stats.levelStats[this.c_mc.currentFrame].portal4Lead);
                  n_testPortal("portal5",Stats.levelStats[this.c_mc.currentFrame].portal5Lead);
                  n_testPortal("portal6",Stats.levelStats[this.c_mc.currentFrame].portal6Lead);
                  n_testPortal("portal7",Stats.levelStats[this.c_mc.currentFrame].portal7Lead);
                  n_testPortal("portal8",Stats.levelStats[this.c_mc.currentFrame].portal8Lead);
               }
            }
         }
      }
      
      private function onControllerAdded(param1:GameInputEvent) : void
      {
         var _loc2_:LogOnMenu = null;
         _loc2_ = null;
         if(this.controllerMain == null)
         {
            this.setControllerMain(GameInput.getDeviceAt(0));
         }
         if(currentFrame == 2)
         {
            _loc2_ = this.createLogOnMenu("controller detected","");
            SetHue.setObjectHue(_loc2_,140);
            SoundManager.playSound(SoundLibrary.controller_sound);
            if(StarlingGameMenu.menu_array.indexOf(this.optionMenu) > -1)
            {
               this.optionMenu.updateMe(stage,AreaCreator.background1,this.save_sharedObject,this.controllerMain);
            }
         }
         if((this.fakeCursor == null || this.fakeCursor.parent == null) && currentFrame == 2)
         {
            this.fakeCursor = new FakeCursor();
            addChild(this.fakeCursor);
            §§pop();
         }
      }
      
      private function onControllerRemoved(param1:GameInputEvent) : void
      {
         var _loc2_:LogOnMenu = null;
         _loc2_ = null;
         this.controllerMain = null;
         if(currentFrame == 2)
         {
            _loc2_ = this.createLogOnMenu("controller removed","");
            SetHue.setObjectHue(_loc2_,140);
            SoundManager.playSound(SoundLibrary.controllerDisconnect_sound);
            if(StarlingGameMenu.menu_array.indexOf(this.optionMenu) > -1)
            {
               this.optionMenu.updateMe(stage,AreaCreator.background1,this.save_sharedObject,this.controllerMain);
            }
         }
         if(GameInput.numDevices == 0)
         {
            removeChild(this.fakeCursor);
         }
      }
      
      private function onControllerError(param1:GameInputEvent) : void
      {
         var _loc2_:LogOnMenu = null;
         _loc2_ = null;
         if(currentFrame == 2)
         {
            _loc2_ = this.createLogOnMenu("controller error","");
            SetHue.setObjectHue(_loc2_,140);
            SoundManager.playSound(SoundLibrary.controllerDisconnect_sound);
         }
      }
      
      public function onControllerButtonChange(param1:flash.events.Event) : void
      {
         this.idleCounter = 0;
         if(this.player != null && this.player.health > 0 && this.setButtonsMode == false && this.theConnection != null && this.theConnection.connected && Boolean(OptionMenu.controllerOn))
         {
            if((param1.target.id == "AXIS_2" || param1.target.id == "AXIS_3") && param1.target.id != this.leftButton_string && param1.target.id != this.rightButton_string && param1.target.id != this.downButton_string)
            {
               if(this.fakeCursor != null && this.fakeCursor.parent != null)
               {
                  if(Math.abs(param1.target.value) > 0.2)
                  {
                     if(param1.target.id == "AXIS_2")
                     {
                        this.fakeCursor.startMoveX(param1.target.value);
                     }
                     else
                     {
                        this.fakeCursor.startMoveY(param1.target.value * -1);
                     }
                  }
                  else if(param1.target.id == "AXIS_2")
                  {
                     this.fakeCursor.startMoveX(0);
                  }
                  else
                  {
                     this.fakeCursor.startMoveY(0);
                  }
               }
            }
            else if(param1.target.id != this.upButton_string && param1.target.id != this.leftButton_string && param1.target.id != this.rightButton_string && param1.target.id != this.downButton_string)
            {
               if(GameInputControl(param1.target).value == 1)
               {
                  switch(GameInputControl(param1.target).id)
                  {
                     case this.attackButton_string:
                        this.player.keyHandler.keyPress(Keyboard.SPACE);
                        break;
                     case this.jumpButton_string:
                        this.player.keyHandler.keyPress(Keyboard.UP);
                        break;
                     case this.lootButton_string:
                        this.player.keyHandler.keyPress(Keyboard.E);
                        break;
                     case this.rageButton_string:
                        this.player.keyHandler.keyPress(Keyboard.R);
                        break;
                     case this.cButton_string:
                        this.player.keyHandler.keyPress(Keyboard.C);
                        break;
                     case this.vButton_string:
                        this.player.keyHandler.keyPress(Keyboard.V);
                        break;
                     case this.guildRageButton_string:
                        this.player.keyHandler.keyPress(Keyboard.T);
                        break;
                     case this.healButton_string:
                        this.player.keyHandler.keyPress(Keyboard.H);
                        break;
                     case this.guildHealButton_string:
                        this.player.keyHandler.keyPress(Keyboard.G);
                        break;
                     case this.fakeClick_string:
                        if(this.fakeCursor != null)
                        {
                           this.fakeCursor.mouseDown();
                        }
                  }
               }
               else if(GameInputControl(param1.target).value == 0)
               {
                  switch(GameInputControl(param1.target).id)
                  {
                     case this.attackButton_string:
                        this.player.keyHandler.keyRelease(Keyboard.SPACE);
                        break;
                     case this.jumpButton_string:
                        this.player.keyHandler.keyRelease(Keyboard.UP);
                        break;
                     case this.lootButton_string:
                        this.player.keyHandler.keyRelease(Keyboard.E);
                        break;
                     case this.vButton_string:
                        this.player.keyHandler.keyRelease(Keyboard.V);
                        break;
                     case this.cButton_string:
                        this.player.keyHandler.keyRelease(Keyboard.C);
                        break;
                     case this.rageButton_string:
                        this.player.keyHandler.keyRelease(Keyboard.R);
                        break;
                     case this.guildRageButton_string:
                        this.player.keyHandler.keyRelease(Keyboard.T);
                        break;
                     case this.healButton_string:
                        this.player.keyHandler.keyRelease(Keyboard.H);
                        break;
                     case this.guildHealButton_string:
                        this.player.keyHandler.keyRelease(Keyboard.G);
                        break;
                     case this.fakeClick_string:
                        if(this.fakeCursor != null)
                        {
                           this.fakeCursor.mouseUp();
                        }
                  }
               }
            }
            else if(param1.target.id == this.leftButton_string || param1.target.id == this.rightButton_string)
            {
               if(param1.target.value < -0.5 || param1.target.id == this.leftButton_string && param1.target.value == 1 && param1.target.minValue == 0)
               {
                  this.player.keyHandler.keyPress(Keyboard.LEFT);
                  if(this.player.keyHandler.keyStates.getKeyState(Keyboard.RIGHT).isDown)
                  {
                     this.player.keyHandler.keyRelease(Keyboard.RIGHT);
                  }
               }
               else if(param1.target.value > 0.5 || param1.target.id == this.rightButton_string && param1.target.value == 1 && param1.target.minValue == 0)
               {
                  this.player.keyHandler.keyPress(Keyboard.RIGHT);
                  if(this.player.keyHandler.keyStates.getKeyState(Keyboard.LEFT).isDown)
                  {
                     this.player.keyHandler.keyRelease(Keyboard.LEFT);
                  }
               }
               else
               {
                  this.player.keyHandler.keyRelease(Keyboard.LEFT);
                  this.player.keyHandler.keyRelease(Keyboard.RIGHT);
               }
            }
            else if(param1.target.id == this.upButton_string || param1.target.id == this.downButton_string)
            {
               if(Math.round(param1.target.value * 0.8) == this.downButtonDir || param1.target.value == 1 && param1.target.minValue == 0)
               {
                  this.pressDown();
                  this.scrollMenuDown = true;
               }
               else if(Math.round(param1.target.value * 0.8) == this.downButtonDir * -1 || param1.target.value == 1 && param1.target.minValue == 0)
               {
                  this.scrollMenuUp = true;
               }
               else
               {
                  this.scrollMenuDown = this.scrollMenuUp = false;
                  this.player.keyHandler.keyRelease(Keyboard.DOWN);
               }
            }
         }
         else if(this.setButtonsMode)
         {
            if(StarlingGameMenu.menu_array.indexOf(this.optionMenu) > -1 && (param1.target.value == 1 || param1.target.value == -1))
            {
               switch(this.optionMenu.buttons_txt.text)
               {
                  case "push a button for attack":
                     this.attackButton_string = param1.target.id;
                     this.optionMenu.buttons_txt.text = "push a button for jump";
                     break;
                  case "push a button for jump":
                     this.jumpButton_string = param1.target.id;
                     this.optionMenu.buttons_txt.text = "push a button for item pickup";
                     break;
                  case "push a button for item pickup":
                     this.lootButton_string = param1.target.id;
                     this.optionMenu.buttons_txt.text = "push a button for self rage";
                     break;
                  case "push a button for self rage":
                     this.rageButton_string = param1.target.id;
                     this.optionMenu.buttons_txt.text = "push a button for guild rage";
                     break;
                  case "push a button for guild rage":
                     this.guildRageButton_string = param1.target.id;
                     this.optionMenu.buttons_txt.text = "push a button for block";
                     break;
                  case "push a button for block":
                     this.vButton_string = param1.target.id;
                     this.optionMenu.buttons_txt.text = "push a button for self heal";
                     break;
                  case "push a button for self heal":
                     this.healButton_string = param1.target.id;
                     this.optionMenu.buttons_txt.text = "button for chopping/fishing";
                     break;
                  case "button for chopping/fishing":
                     this.cButton_string = param1.target.id;
                     this.optionMenu.buttons_txt.text = "press a button for guild heal";
                     break;
                  case "press a button for guild heal":
                     this.guildHealButton_string = param1.target.id;
                     this.optionMenu.buttons_txt.text = "press a button for left movement";
                     break;
                  case "press a button for left movement":
                     this.leftButton_string = param1.target.id;
                     this.optionMenu.buttons_txt.text = "press a button for right movement";
                     break;
                  case "press a button for right movement":
                     this.rightButton_string = param1.target.id;
                     this.optionMenu.buttons_txt.text = "press a button for down";
                     break;
                  case "press a button for down":
                     this.downButton_string = param1.target.id;
                     this.downButtonDir = param1.target.value;
                     this.setButtonsMode = false;
                     this.optionMenu.buttons_txt.text = "--SAVED--";
                     this.save_sharedObject.data.controllerName = this.controllerMain.name;
                     this.save_sharedObject.data.customButtons_array = new Vector.<String>();
                     this.save_sharedObject.data.customButtons_array.push(this.upButton_string);
                     this.save_sharedObject.data.customButtons_array.push(this.leftButton_string);
                     this.save_sharedObject.data.customButtons_array.push(this.rightButton_string);
                     this.save_sharedObject.data.customButtons_array.push(this.downButton_string);
                     this.save_sharedObject.data.customButtons_array.push(this.attackButton_string);
                     this.save_sharedObject.data.customButtons_array.push(this.lootButton_string);
                     this.save_sharedObject.data.customButtons_array.push(this.jumpButton_string);
                     this.save_sharedObject.data.customButtons_array.push(this.rageButton_string);
                     this.save_sharedObject.data.customButtons_array.push(this.guildRageButton_string);
                     this.save_sharedObject.data.customButtons_array.push(this.healButton_string);
                     this.save_sharedObject.data.customButtons_array.push(this.guildHealButton_string);
                     this.save_sharedObject.data.customButtons_array.push(this.vButton_string);
                     this.save_sharedObject.data.customButtons_array.push(this.cButton_string);
                     this.save_sharedObject.data.downButtonDir = this.downButtonDir;
                     try
                     {
                        this.save_sharedObject.flush();
                     }
                     catch(_error:Error)
                     {
                     }
               }
            }
            else if(StarlingGameMenu.menu_array.indexOf(this.optionMenu) == -1)
            {
               this.setButtonsMode = false;
            }
         }
      }
      
      private function setControllerMain(param1:GameInputDevice) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = false;
         _loc2_ = param1 == this.controllerMain;
         this.controllerMain = param1;
         this.controllerMain.enabled = true;
         this.i = 0;
         while(this.i < this.controllerMain.numControls)
         {
            this.controllerMain.getControlAt(this.i).addEventListener(flash.events.Event.CHANGE,this.onControllerButtonChange);
            ++this.i;
         }
         GameInputControlName.initialize(this.controllerMain);
         if(_loc2_ == false)
         {
            this.setButtonControls();
         }
         if(this.controllerMain != null && this.save_sharedObject.data.customButtons_array != undefined && this.save_sharedObject.data.controllerName == this.controllerMain.name)
         {
            this.upButton_string = this.save_sharedObject.data.customButtons_array[0];
            this.leftButton_string = this.save_sharedObject.data.customButtons_array[1];
            this.rightButton_string = this.save_sharedObject.data.customButtons_array[2];
            this.downButton_string = this.save_sharedObject.data.customButtons_array[3];
            this.attackButton_string = this.save_sharedObject.data.customButtons_array[4];
            this.lootButton_string = this.save_sharedObject.data.customButtons_array[5];
            this.jumpButton_string = this.save_sharedObject.data.customButtons_array[6];
            this.rageButton_string = this.save_sharedObject.data.customButtons_array[7];
            this.guildRageButton_string = this.save_sharedObject.data.customButtons_array[8];
            this.healButton_string = this.save_sharedObject.data.customButtons_array[9];
            this.guildHealButton_string = this.save_sharedObject.data.customButtons_array[10];
            this.vButton_string = this.save_sharedObject.data.customButtons_array[11];
            this.downButtonDir = this.save_sharedObject.data.downButtonDir;
            if(this.save_sharedObject.data.customButtons_array.length >= 15)
            {
               this.cButton_string = this.save_sharedObject.data.customButtons_array[14];
            }
         }
      }
      
      private function setButtonControls() : void
      {
         switch(this.controllerMain.name)
         {
            case "Twin USB Joystick":
               this.upButton_string = "AXIS_1";
               this.leftButton_string = "AXIS_0";
               this.rightButton_string = "AXIS_0";
               this.downButton_string = "AXIS_1";
               this.attackButton_string = "BUTTON_11";
               this.lootButton_string = "BUTTON_8";
               this.jumpButton_string = "BUTTON_10";
               this.rageButton_string = "BUTTON_9";
               this.guildRageButton_string = "BUTTON_15";
               this.healButton_string = "BUTTON_18";
               this.vButton_string = "BUTTON_12";
               break;
            case "Generic USB joystick":
               this.upButton_string = "AXIS_0";
               this.downButton_string = "AXIS_0";
               this.leftButton_string = "AXIS_1";
               this.rightButton_string = "AXIS_1";
               this.lootButton_string = "BUTTON_9";
               this.attackButton_string = "BUTTON_12";
               this.jumpButton_string = "BUTTON_11";
               this.rageButton_string = "BUTTON_10";
               this.vButton_string = "BUTTON_13";
               this.guildRageButton_string = "BUTTON_15";
               this.healButton_string = "BUTTON_19";
               this.guildHealButton_string = "BUTTON_20";
               break;
            case "Xbox 360 Controller (XInput STANDARD GAMEPAD)":
               this.upButton_string = "stickLeftY";
               this.leftButton_string = "AXIS_0";
               this.rightButton_string = "AXIS_0";
               this.downButton_string = "AXIS_1";
               this.attackButton_string = "BUTTON_6";
               this.lootButton_string = "BUTTON_9";
               this.jumpButton_string = "BUTTON_4";
               this.rageButton_string = "BUTTON_8";
               this.guildRageButton_string = "BUTTON_10";
               this.healButton_string = "BUTTON_11";
               this.guildHealButton_string = "BUTTON_14";
               this.downButtonDir = -1;
               this.cButton_string = "BUTTON_7";
               this.vButton_string = "BUTTON_5";
               this.fakeClick_string = "BUTTON_15";
         }
      }
      
      private function onFirstAdded(param1:flash.events.Event) : void
      {
         var ip_urlLoader:URLLoader = null;
         var doNoMenu:Function = null;
         var onRMDown:Function = null;
         var e:flash.events.Event = param1;
         ip_urlLoader = null;
         var npcStat:NPCStat = null;
         doNoMenu = null;
         onRMDown = null;
         removeEventListener(flash.events.Event.ADDED_TO_STAGE,this.onFirstAdded);
         if(Capabilities.playerType != "Desktop")
         {
            Security.allowDomain("*");
            Security.allowInsecureDomain("*");
         }
         stop();
         Facebook.init(root);
         PlayerIO.useSecureApiRequests = true;
         this.serverNames_array.push("Main Server 1","Main Server 2","Main Server 3","PvP Server");
         this.serverPops_array.push(0,0,0);
         stage.color = 0;
         PlayerIOPublishingNetwork.init(root);
         if(Capabilities.hasAudio == false)
         {
            if(SoundManager.musicOn)
            {
               SoundManager.toggleMusic();
            }
            if(SoundManager.soundOn)
            {
               SoundManager.toggleSound();
            }
         }
         if(parent.parent != null)
         {
            if(parent.parent.root.loaderInfo.parameters.showAds != null && (parent.parent.root.loaderInfo.parameters.showAds == "true" || parent.parent.root.loaderInfo.parameters.showAds == true))
            {
               this.showAds = true;
               if(SoundManager.musicOn)
               {
                  SoundManager.toggleMusic();
               }
               if(SoundManager.soundOn)
               {
                  SoundManager.toggleSound();
               }
            }
         }
         if(Capabilities.playerType != "Desktop")
         {
            if(parent.parent != null)
            {
               this.playingURL_string = SiteLock.getMainDomainString(flash.display.MovieClip(parent.parent).thisURL_string);
               this.test_txt.text = "You are playing from: " + this.playingURL_string;
            }
            else
            {
               this.test_txt.text = "playing directly from game file link";
            }
            if(ArmorGames.isOnArmor(root))
            {
               this.playingURL_string = "armorgames.com";
               this.test_txt.text = "playing on Armor Games";
            }
            else if(Kongregate.isOnKong(root))
            {
               this.playingURL_string = "kongregate.com";
               this.test_txt.text = "playing on Kongregate";
            }
            else if(Facebook.onFacebook)
            {
               this.playingURL_string = "facebook.com";
               this.test_txt.text = "playing on Facebook";
            }
            else if(this.playingURL_string == "miniplay.com" || this.playingURL_string == "minijuegos.com" || this.playingURL_string == "minigiochi.com" || this.playingURL_string == "minijuegos.es" || this.playingURL_string == "minijuegosgratis.com" || this.playingURL_string == "minijogos.com.br" || this.playingURL_string == "minijuegos.mx" || this.playingURL_string == "minijuegos.com.mx" || this.playingURL_string.indexOf("miniplay.com") > -1 || this.playingURL_string.indexOf("minijuegos.com") > -1 || this.playingURL_string.indexOf("minijuegos.es") > -1 || this.playingURL_string.indexOf("minijuegosgratis.com") > -1 || this.playingURL_string.indexOf("minigiochi.com") > -1 || this.playingURL_string.indexOf("minijogos.com.br") > -1 || this.playingURL_string.indexOf("minijuegos.mx") > -1 || this.playingURL_string.indexOf("minijuegos.com.mx") > -1)
            {
               this.playingURL_string = "miniplay.com";
               this.test_txt.text = "playing on MiniPlay";
            }
            else if(this.playingURL_string == "ungrounded.net")
            {
               Newgrounds.init(this);
            }
            else if(PlayerIOPublishingNetwork.isOnNetworkSite())
            {
               this.playingURL_string = "playerio.com";
               this.test_txt.text = "playing on PlayerIO publishing network";
            }
         }
         else if(Capabilities.cpuArchitecture != "ARM")
         {
            Steam.init(this);
            if(Steam.onSteam == false)
            {
               this.test_txt.text = "Playing on desktop AIR";
            }
            else
            {
               this.test_txt.text = "Playing through Steam";
               this.playingURL_string = "steampowered.com";
               this.nonSteam_btn.visible = true;
            }
         }
         else
         {
            this.test_txt.text = "Playing on mobile AIR";
            GameMain.__isMobile = true;
            if(isIOS == false)
            {
               GooglePlay.init(this);
            }
            else
            {
               IOS.init(this);
            }
            if(parent.parent != null)
            {
               this.trueFullScreenWidth = flash.display.MovieClip(parent.parent).trueFullScreenWidth;
               this.trueFullScreenHeight = flash.display.MovieClip(parent.parent).trueFullScreenHeight;
            }
         }
         TalkText.textBlip_sound.load(new URLRequest("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/text blip.mp3"));
         try
         {
            doNoMenu = function(param1:MouseEvent):void
            {
            };
            onRMDown = function(param1:MouseEvent):void
            {
            };
            addEventListener(MouseEvent.RIGHT_CLICK,doNoMenu);
            addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,onRMDown);
         }
         catch(e:Error)
         {
         }
         if(this.playingURL_string == "armorgames.com")
         {
            ArmorGames.init(root);
         }
         else if(this.playingURL_string == "kongregate.com")
         {
            Kongregate.init(root);
         }
         else if(this.playingURL_string == "y8.com" || this.playingURL_string == "pog.com" || this.playingURL_string == "gamepost.com" || this.playingURL_string == "dollmania.com" || this.playingURL_string == "id.net")
         {
            this.playingURL_string = "y8.com";
            this.y8_api = new IDI();
            addChild(this.y8_api);
         }
         else if(this.playingURL_string == "miniplay.com")
         {
            MiniPlay.init(root);
         }
         ip_urlLoader = new URLLoader(new URLRequest("https://yuriifedorov01-cpu.github.io/hht-client/includes/getIP.php?" + String(Math.random() * 999999)));
         ip_urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
         ip_urlLoader.addEventListener(flash.events.Event.COMPLETE,this.ipLoaded);
         npcStat = new NPCStat(1,"Ronald",351,747,"bald","archer hat","archer shirt","archer pants","medium bow","none",1,3);
         npcStat = new NPCStat(1,"William",506,749,"bald","blue beanie","red shirt","blue jeans","machete","none",-1,1,1,"male",1);
         npcStat = new NPCStat(1,"Ralph",5106,910,"thin black","none","green shirt","green pants","none","none",3);
         npcStat = new NPCStat(4,"Alfred",620,1406,"thin black","none","blue shirt","red pants","none","none",4,2,-1);
         npcStat = new NPCStat(4,"Jim Sanders",1824,913,"red curly","none","red shirt","green shorts","big stick","none",22,1,-1);
         npcStat = new NPCStat(6,"Chad",3602,1236,"bald","blue beanie","red shirt","blue jeans","none","none",47,4);
         npcStat = new NPCStat(6,"Joshua",2927,587,"brown","none","red shirt","chainmail legs","none","none",48,4);
         npcStat = new NPCStat(7,"Sales Man",2470,1572,"brown","none","red shirt","blue jeans","none","none",2,4);
         npcStat = new NPCStat(7,"Heath",2668,1570,"bald","clover hat","blue shirt","blue jeans","none","none",8,1,-1);
         npcStat = new NPCStat(7,"Mizon",1474,1076,"bald","full ski mask","suit","suit pants","fireman hatchet","none",14);
         npcStat = new NPCStat(7,"Anoop",3816,420,"bald","crumby wizard hat","green shirt","brown wizard pants","basic wand","none",23,1,-1);
         npcStat = new NPCStat(20,"Rita",2482,1240,"brown sag","none","leather armor","blue jeans","none","none",60,2);
         npcStat = new NPCStat(44,"Ben",1280,254,"slick black","none","red shirt","yellow pants","none","none",7);
         npcStat = new NPCStat(45,"Thomas",2576,746,"bald","red beanie","red shirt","green pants","none","none",6,4);
         npcStat = new NPCStat(58,"Sam Shoe",3240,413,"spiked blond","none","suit","blue jeans","none","none",55,5,-1);
         npcStat = new NPCStat(58,"Vlad Shoe",3387,413,"spiked blond","none","suit","blue jeans","none","none",110,5,-1);
         npcStat = new NPCStat(58,"Arny",4966,411,"bald","archer hat","white shirt","blue jeans","stick","none",9,6,-1);
         npcStat = new NPCStat(60,"Clark",1900,416,"bald","coconut helmet","coconut armor","coconut knee pads","none","none",50);
         npcStat = new NPCStat(18,"Gordon",1988,578,"bald","oriental hat","leather armor","blue jeans","pickaxe","none",40,1,-1);
         npcStat = new NPCStat(19,"Michael",3726,422,"bald","blue beanie","red shirt","blue jeans","stick","none",5);
         npcStat = new NPCStat(55,"Andrew",648,1242,"bald","half coconut","blue shirt","red pants","sickle","none",11,4,-1);
         npcStat = new NPCStat(55,"Drew",2434,916,"spiked blond","none","suit","blue jeans","none","none",15,2);
         npcStat = new NPCStat(55,"Hambone",3588,1244,"slick black","none","white shirt","green shorts","none","none",19,2,-1);
         npcStat = new NPCStat(55,"Cleveland",4048,1244,"bald","clover hat","green shirt","green shorts","hammer","none",10,2);
         npcStat = new NPCStat(55,"Brody",3248,76,"spiked blond","none","white shirt","yellow pants","short sword","none",21,1,-1);
         npcStat = new NPCStat(119,"Gellius",956,1572,"bald","none","blue shirt","suit pants","teardrop blade","none",45,4);
         npcStat = new NPCStat(120,"Gary",771,1573,"bald","half coconut","green shirt","green pants","fireman hatchet","none",13,3);
         npcStat = new NPCStat(120,"Carter",1538,1573,"bald","coconut helmet","green shirt","coconut knee pads","big stick","none",12,1,-1);
         npcStat = new NPCStat(121,"Shane Shield",974,1568,"thin black","none","suit","yellow pants","bronze shield","none",20,2);
         npcStat = new NPCStat(122,"Charles",782,1570,"fro","none","suit","suit pants","none","none",16,1,1,"male",4);
         npcStat = new NPCStat(122,"Chris",1313,1574,"red curly","none","blue shirt","red pants","none","none",17,2);
         npcStat = new NPCStat(122,"Ted",1461,1575,"mohawk","none","red shirt","blue jeans","none","none",18,6,-1);
         npcStat = new NPCStat(123,"Lewis",1058,1566,"bald","none","suit","suit pants","none","none",44,5);
         npcStat = new NPCStat(65,"Alpipa",4882,582,"bald","red wizard hat","red shirt","red pants","rusty scimitar","none",24,3,-1);
         npcStat = new NPCStat(66,"Keith",4112,1246,"bald","full ski mask","suit","suit pants","log splitting axe","none",37,3,-1);
         npcStat = new NPCStat(66,"Fredward",3746,254,"bald","full ski mask","suit","suit pants","rusty scimitar","none",35,3);
         npcStat = new NPCStat(66,"Mystic",4702,256,"bald","full ski mask","suit","suit pants","wooden spear","none",38,3);
         npcStat = new NPCStat(66,"Chucky",2986,1242,"bald","full ski mask","suit","suit pants","bronze dagger","none",36,3,-1);
         npcStat = new NPCStat(12,"Scarlet",1450,1574,"bald","witch hat","red shirt","suit pants","none","none",49,7,-1,"female");
         npcStat = new NPCStat(15,"Ron Anderson",751,1567,"bald","crumby wizard hat","red shirt","brown wizard pants","bronze dagger","none",25);
         npcStat = new NPCStat(15,"Kyle Anderson",951,1566,"red curly","none","green shirt","chainmail legs","short sword","none",26);
         npcStat = new NPCStat(15,"Brad Anderson",1520,1570,"bald","blue face helmet","blue shirt","red wizard pants","bronze dagger","none",27,1,-1);
         npcStat = new NPCStat(16,"Snoop",1286,1568,"bald","half coconut","coconut armor","blue jeans","teardrop blade","none",29,4);
         npcStat = new NPCStat(16,"Susan",1579,1569,"blonde tails","none","red shirt","red pants","none","none",33,7,-1,"female");
         npcStat = new NPCStat(17,"Wayne",1437,1574,"bald","oriental hat","white shirt","brown wizard pants","star wand","none",28,2,-1);
         npcStat = new NPCStat(111,"Barbara",1158,1734,"blonde tails","none","red shirt","red pants","none","none",32);
         npcStat = new NPCStat(111,"Tiberius",616,1731,"bald","roman helmet","coconut armor","chainmail legs","none","none",34,4);
         npcStat = new NPCStat(111,"Chipper",752,912,"fro","none","suit","blue jeans","rusty scimitar","none",30);
         npcStat = new NPCStat(111,"Daniel",2424,916,"bald","leather helmet","coconut armor","chainmail legs","medium bow","none",31,6,-1);
         npcStat = new NPCStat(111,"Howard",3738,1074,"mohawk","none","magnesium armor","magnesium legs","short sword","none",56,6,-1);
         npcStat = new NPCStat(76,"Woodman Tim",1448,1075,"brown","none","cowboy shirt","cowboy pants","fireman hatchet","fireman hatchet",93,1,-1);
         npcStat = new NPCStat(77,"Woodman Steve",4576,1076,"drooping blonde","none","cowboy shirt","cowboy pants","log splitting axe","none",94);
         npcStat = new NPCStat(79,"Tanya",1623,1568,"blonde tails","none","red shirt","red pants","stick","none",41,7,-1,"female");
         npcStat = new NPCStat(79,"Wallace",936,1568,"bald","blue face helmet","chainmail","blue jeans","machete","none",42,5);
         npcStat = new NPCStat(79,"Chance",795,1567,"bald","apollos helmet","red shirt","apollos armor legs","thorn bow","none",46,4);
         npcStat = new NPCStat(79,"Pablo",1087,1568,"bald","none","chainmail","blue jeans","sledgehammer","none",43,2);
         npcStat = new NPCStat(81,"Jimmy",2882,922,"bald","blue beanie","blue shirt","blue jeans","chunk mace","none",57,1,-1);
         npcStat = new NPCStat(83,"Lottery Man",2949,1409,"bald","detective hat","cowboy shirt","red pants","none","none",83);
         npcStat = new NPCStat(83,"Travis",3414,1408,"bald","sugarloaf helmet","red shirt","blue jeans","none","none",52);
         npcStat = new NPCStat(83,"Margret",3894,1404,"granny hair","none","red shirt","red pants","none","none",54,7,1,"female",4);
         npcStat = new NPCStat(26,"Sneed",5486,1239,"bald","sugarloaf helmet","coconut armor","chainmail legs","none","none",58,3,-1);
         npcStat = new NPCStat(23,"Albert",1115,2402,"bald","racing helmet","chainmail","blue jeans","pickaxe","none",59,6,-1);
         npcStat = new NPCStat(30,"Maxwell",4584,1239,"bald","half coconut","coconut armor","blue jeans","teardrop blade","none",63,4);
         npcStat = new NPCStat(117,"Viper",1677,1568,"slick black","none","future armor","future legs","guardians warhammer","none",62,2,-1);
         npcStat = new NPCStat(117,"Rebecca",1415,1571,"long black","none","ballerina outfit","ballerina stockings","none","stick",61,4,-1,"female");
         npcStat = new NPCStat(124,"Larry",1470,1571,"bald","none","white shirt","blue jeans","none","none",65,2,-1);
         npcStat = new NPCStat(118,"Cassie",1234,1568,"bald","cat hat","red shirt","ballerina stockings","none","none",64,7,-1,"female");
         npcStat = new NPCStat(33,"Blaire",3722,744,"bald","chain helmet","blue crystal armor","robot legs","ancient battle axe","none",67);
         npcStat = new NPCStat(74,"Geraldo",1089,1410,"bald","oriental hat","white shirt","roman leggings","machete","none",66,1,-1,"male",4);
         npcStat = new NPCStat(74,"Billbert",1623,1406,"bald","racing helmet","chainmail","blue jeans","pickaxe","none",68,6,-1);
         npcStat = new NPCStat(97,"Patrick",3431,1238,"bald","jester hat","fish scale armor","red pants","indian wand","none",77,1,-1);
         npcStat = new NPCStat(97,"Walter",5068,1075,"bald","magnesium helmet","magnesium armor","magnesium legs","none","none",79,1,-1);
         npcStat = new NPCStat(97,"Vince",5535,1078,"bald","roman helmet","blue shirt","blue jeans","none","none",82);
         npcStat = new NPCStat(97,"Samuel",4004,750,"spiked blond","none","red shirt","blue jeans","none","none",80);
         npcStat = new NPCStat(97,"Tristin",1212,1246,"bald","green face helmet","leather armor","blue jeans","bat wing staff","none",81);
         npcStat = new NPCStat(99,"Wilson",4898,916,"bald","crumby wizard hat","assault armor","brown wizard pants","fireman hatchet","none",76);
         npcStat = new NPCStat(133,"Ricardo",1358,1570,"bald","knight helmet","green shirt","zinc legs","death bringer","none",78);
         npcStat = new NPCStat(128,"Val",1456,1567,"bald","strong basket helmet","white shirt","blue jeans","none","none",75);
         npcStat = new NPCStat(129,"Leonard",904,1575,"bald","red beanie","koon outfit","fish scale legs","none","none",101);
         npcStat = new NPCStat(128,"Martin",1368,1570,"mohawk","none","suit","suit pants","element wand","none",69);
         npcStat = new NPCStat(39,"Bartholomew",1318,1574,"bald","beholder helmet","jester shirt","beholder legs","beholder bow","none",70,2,-1);
         npcStat = new NPCStat(39,"Bobby",1506,1571,"bald","kreeton helmet","beholder armor","yellow pants","skull crusher","none",96,1,-1);
         npcStat = new NPCStat(130,"Tanner",1513,1737,"mohawk","none","suit","suit pants","none","none",71,2);
         npcStat = new NPCStat(131,"Nicolas",1374,1734,"bald","none","suit","suit pants","none","none",72);
         npcStat = new NPCStat(131,"Markus",1871,1740,"thin black","none","suit","suit pants","none","none",73);
         npcStat = new NPCStat(132,"Ted",1870,1736,"blond bowl","none","suit","suit pants","none","none",74);
         npcStat = new NPCStat(126,"Train Shack Man",4004,1404,"bald","army helmet","green shirt","red pants","none","none",103);
         npcStat = new NPCStat(88,"Donald",878,1396,"bald","blue beanie","blue shirt","blue jeans","blue plastic sword","blue plastic sword",85);
         npcStat = new NPCStat(88,"Train Shack Man",2294,578,"bald","army helmet","green shirt","red pants","none","none",84);
         npcStat = new NPCStat(88,"Lamar",2704,578,"fro","none","flak jacket","zinc legs","teardrop blade","none",86,4,-1);
         npcStat = new NPCStat(92,"Betty",1622,1566,"ratty blonde","none","pink crystal armor","metal ballerina legs","none","none",88,12,-1,"female");
         npcStat = new NPCStat(92,"Milton",1066,1562,"bald","none","fish scale armor","fish scale legs","fishing pole","none",87);
         npcStat = new NPCStat(78,"Ned",3818,584,"bald","protector helmet","samurai armor","blue crystal legs","fishing pole","none",90,2,-1);
         npcStat = new NPCStat(78,"Craft-Man",5242,1074,"mohawk","eye patch","stone armor","stone armor legs","captains rapier","none",92,4,-1);
         npcStat = new NPCStat(78,"Scott",5554,1074,"bald","cone helmet","robot armor","mocap pants","fishing pole","none",95,1,-1);
         npcStat = new NPCStat(78,"Bert",4031,1407,"comb over","none","white shirt","green shorts","none","none",91,1,-1);
         npcStat = new NPCStat(98,"Christy",3970,1738,"brown ponytails","none","pink crystal armor","pink crystal legs","sai","sai",97);
         npcStat = new NPCStat(104,"Philbert",2158,746,"bald","skull crusher helmet","relic armor","titanium legs","bazooka","none",98,1,-1);
         npcStat = new NPCStat(105,"Dan",4062,414,"bald","assault helmet","analytic armor","jester pants","rayon gun","none",100);
         npcStat = new NPCStat(105,"Hubert",3752,412,"bald","ancient helmet","relic armor","zinc legs","skull crusher","none",99,1,-1);
         npcStat = new NPCStat(105,"Jenkins",392,190,"bald","helmet of hatred","samurai armor","samurai legs","harpoon bow","none",102);
         npcStat = new NPCStat(53,"Derek",2842,76,"spiked blond","none","chainmail","red pants","none","none",104);
         npcStat = new NPCStat(136,"Hamlet",3724,750,"bald","acidic helmet","acidic armor","acidic legs","ak47","none",105);
         npcStat = new NPCStat(139,"Zander",1358,1570,"fro","none","green shirt","green pants","machete","machete",108);
         npcStat = new NPCStat(140,"Tanya",1623,1568,"blonde tails","none","jester shirt","leather legs","es c90","none",109,7,-1,"female");
         npcStat = new NPCStat(141,"Isaac Sr",1358,1570,"bald","ancient helmet","samurai armor","imperial legs","heated staff","none",106);
         npcStat = new NPCStat(141,"Isaac Jr",841,1570,"bald","strong full helmet","apollos armor","fish scale legs","acid shield","acidic sword",107);
         npcStat = new NPCStat(144,"Kris",2376,1568,"bald","analytic helmet","serpent armor","kreeton legs","xm8 rifle","none",113);
         npcStat = new NPCStat(145,"Ethan",2202,1567,"bald","cowboy knight helmet","adamantium armor","protector legs","enforcer gun","none",111);
         npcStat = new NPCStat(145,"Toddwell",1301,1569,"bald","bladed helmet","blue crystal armor","assault legs","beholder bow","none",112);
         stage.addEventListener(MouseEvent.CLICK,this.onClick);
         stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onMDown);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onMUp);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMOut);
         stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMWheel);
         addEventListener(flash.events.Event.ACTIVATE,this.onActivate);
         addEventListener(flash.events.Event.DEACTIVATE,this.onDeActivate);
         this.gameInput.addEventListener(GameInputEvent.DEVICE_ADDED,this.onControllerAdded);
         this.gameInput.addEventListener(GameInputEvent.DEVICE_REMOVED,this.onControllerRemoved);
         this.gameInput.addEventListener(GameInputEvent.DEVICE_UNUSABLE,this.onControllerError);
         Starling.multitouchEnabled = true;
         this.mainStarling = new Starling(MainStarlingStage,stage,null,null,"auto",[Context3DProfile.BASELINE_EXTENDED,Context3DProfile.BASELINE,Context3DProfile.BASELINE_CONSTRAINED]);
         this.mainStarling.antiAliasing = int(!isMobile);
         this.mainStarling.start();
         this.mainStarling.addEventListener("rootCreated",this.onStarlingRootCreated);
      }
      
      private function onStarlingRootCreated(param1:*) : void
      {
         var e:* = param1;
         this.starlingStage = MainStarlingStage(this.mainStarling.root);
         this.starlingStage.gameMain = this;
         this.mainStarling.removeEventListener("rootCreated",this.onStarlingRootCreated);
         this.init_txt.text = "";
         stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.onFullScreen);
         Starling.current.addEventListener(starling.events.Event.CONTEXT3D_CREATE,this.onContext3DCreated);
         CommonCalls.starlingMain = this.starlingStage;
         Assets.main_assetManager.requiresRecache = this.dbItems_sharedObject.data.dbCacheVersion != this.dbCacheVersion;
         this.init_txt.text = "loading stats...\n";
         PlayerIO.authenticate(stage,"hho-ygpra4ftumusohpifpdug","public",{"userId":"adsfjhakf"},null,function(param1:Client):void
         {
            loadCheckItemAndEnemyStats(param1);
         });
         if(SoundManager.musicOn)
         {
            Assets.main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/Glory_Glory_full_mix.mp3","main menu music");
         }
         Assets.enqueuePreloadAssets();
         Assets.main_assetManager.loadQueue(this.onPreLoadEnter);
      }
      
      private function onContext3DCreated(param1:starling.events.Event) : void
      {
         var _loc2_:ExplosionVector = null;
         var _loc3_:YellowExplosionVector = null;
         var _loc4_:Vector.<Enemy> = null;
         var _loc5_:Enemy = null;
         _loc2_ = null;
         _loc3_ = null;
         _loc4_ = null;
         _loc5_ = null;
         TileHandler.convertAreaArt(this.c_mc.currentFrame);
         TileHandler.restoreTileTextures();
         _loc2_ = new ExplosionVector();
         Explosion.info_array = MovieClipToAtlas.createAtlas(_loc2_,"explosion_",Context3DTextureFormat.BGRA_PACKED);
         _loc3_ = new YellowExplosionVector();
         YellowExplosion.info_array = MovieClipToAtlas.createAtlas(_loc3_,"yellowExplosion_",Context3DTextureFormat.BGRA_PACKED);
         Enemy.enemyAssets_array.length = 0;
         _loc4_ = new Vector.<Enemy>();
         this.i = this.e_array.length - 1;
         while(this.i >= 0)
         {
            _loc4_.push(this.e_array[this.i]);
            this.e_array[this.i].hitTester.frozen = false;
            this.e_array[this.i].removeFromParent(true);
            this.e_array.pop();
            --this.i;
         }
         for each(var _loc8_ in _loc4_)
         {
            _loc5_ = _loc8_;
            _loc8_;
            this.createEnemy(_loc5_.name,_loc5_.type,_loc5_.x,_loc5_.y,_loc5_.enemyAI.moveCounter,_loc5_.moveDir,_loc5_.health);
         }
      }
      
      private function onFullScreen(param1:FullScreenEvent) : void
      {
         this.adjustFullScreen(param1.fullScreen);
      }
      
      private function adjustFullScreen(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc2_ = 0;
         _loc3_ = 0;
         _loc4_ = 0;
         _loc5_ = 0;
         _loc6_ = 0;
         if(currentFrame == 1)
         {
            this.test2_txt.text = "went full";
         }
         _loc2_ = this.trueFullScreenWidth == 0 ? stage.stageWidth : int(this.trueFullScreenWidth);
         _loc3_ = this.trueFullScreenHeight == 0 ? stage.stageHeight : int(this.trueFullScreenHeight);
         if(param1)
         {
            Starling.current.viewPort.width = this.starlingStage.stage.stageWidth = _loc2_;
            Starling.current.viewPort.height = this.starlingStage.stage.stageHeight = _loc3_;
            if(AreaCreator.sky != null)
            {
               AreaCreator.sky.width = _loc2_;
               AreaCreator.sky.height = _loc3_;
            }
            if(isMobile)
            {
               if(Capabilities.screenDPI > 360 || Capabilities.screenResolutionX > 1900 && Capabilities.screenResolutionY > 1000)
               {
                  Starling.current.stage.stageWidth = Starling.current.stage.stageWidth / 2;
                  Starling.current.stage.stageHeight = Starling.current.stage.stageHeight / 2;
               }
            }
            if(this.mMenu != null && this.mMenu.parent != null)
            {
               this.mMenu.x = _loc2_ / 2 - 50;
               this.mMenu.y = _loc3_ / 2;
               if(Starling.contentScaleFactor >= 2 || _loc2_ < 950 || _loc3_ < 700)
               {
                  this.mMenu.scaleX = this.mMenu.scaleY = Starling.contentScaleFactor * 0.75;
               }
               this.player.visible = false;
            }
            if(this.charCreateMenu != null && this.charCreateMenu.parent != null)
            {
               this.charCreateMenu.x = _loc2_ / 2 - 50;
               this.charCreateMenu.y = _loc3_ / 2;
            }
            AreaCreator.checkCreateMoreBG();
         }
         else
         {
            Starling.current.viewPort.width = this.starlingStage.stage.stageWidth = 950;
            Starling.current.viewPort.height = this.starlingStage.stage.stageHeight = 700;
            AreaCreator.sky.width = 950;
            AreaCreator.sky.height = 700;
            if(this.mMenu != null && this.mMenu.parent != null)
            {
               this.mMenu.x = 425;
               this.mMenu.y = 350;
            }
            if(this.charCreateMenu != null && this.charCreateMenu.parent != null)
            {
               this.charCreateMenu.x = 425;
               this.charCreateMenu.y = 350;
            }
         }
         _loc4_ = (stage.fullScreenWidth / Starling.contentScaleFactor - loaderInfo.width) * (param1 ? 1 : -1);
         _loc5_ = (stage.fullScreenHeight / Starling.contentScaleFactor - loaderInfo.height) * (param1 ? 1 : -1);
         if(this.starlingStage.controls.heropedia_btn != null && this.starlingStage.controls.heropedia_btn.parent != null)
         {
            this.starlingStage.controls.pets_btn.x = this.starlingStage.controls.pets_btn.x + _loc4_;
            this.starlingStage.controls.char_btn.x = this.starlingStage.controls.char_btn.x + _loc4_;
            this.starlingStage.controls.friends_btn.x = this.starlingStage.controls.friends_btn.x + _loc4_;
            this.starlingStage.controls.items_btn.x = this.starlingStage.controls.items_btn.x + _loc4_;
            this.starlingStage.controls.map_btn.x = this.starlingStage.controls.map_btn.x + _loc4_;
            this.starlingStage.controls.heropedia_btn.x = this.starlingStage.controls.heropedia_btn.x + _loc4_;
            this.starlingStage.controls.payvault_btn.x = this.starlingStage.controls.payvault_btn.x + _loc4_;
            this.starlingStage.controls.options_btn.x = this.starlingStage.controls.options_btn.x + _loc4_;
            this.starlingStage.controls.missions_btn.x = this.starlingStage.controls.missions_btn.x + _loc4_;
            if(this.starlingStage.controls.mainMenu_btn != null)
            {
               this.starlingStage.controls.mainMenu_btn.x = this.starlingStage.controls.mainMenu_btn.x + _loc4_;
            }
         }
         this.starlingStage.controls.chatPanel_image.x = this.starlingStage.controls.chatPanel_image.x + _loc4_ / 2;
         this.starlingStage.controls.chat_txt.x = this.starlingStage.controls.chat_txt.x + _loc4_ / 2;
         this.starlingStage.controls.message_txt.x = this.starlingStage.controls.message_txt.x + _loc4_ / 2;
         this.starlingStage.controls.chatPanel_image.y = this.starlingStage.controls.chatPanel_image.y + _loc5_;
         this.starlingStage.controls.chat_txt.y = this.starlingStage.controls.chat_txt.y + _loc5_;
         this.starlingStage.controls.message_txt.y = this.starlingStage.controls.message_txt.y + _loc5_;
         AreaCreator.background1.y = AreaCreator.background1.y + _loc5_ / 2;
         AreaCreator.background2.y = AreaCreator.background2.y + _loc5_ / 2;
         AreaCreator.background3.y = AreaCreator.background3.y + _loc5_ / 2;
         if(isMobile)
         {
            this.starlingStage.controls.etc_btn.x = Starling.current.viewPort.width / Starling.contentScaleFactor - 70;
            this.starlingStage.controls.analogStickBG_image.y = Starling.current.viewPort.height / Starling.contentScaleFactor - this.starlingStage.controls.analogStickBG_image.height / 2;
            this.starlingStage.controls.analogStick_btn.y = this.starlingStage.controls.analogStickBG_image.y;
            this.starlingStage.controls.attack_btn.x = Starling.current.viewPort.width / Starling.contentScaleFactor - this.starlingStage.controls.attack_btn.width;
            this.starlingStage.controls.jump_btn.x = this.starlingStage.controls.attack_btn.x - this.starlingStage.controls.jump_btn.width;
            this.starlingStage.controls.block_btn.x = this.starlingStage.controls.attack_btn.x - this.starlingStage.controls.block_btn.width / 1.75;
            this.starlingStage.controls.loot_btn.x = this.starlingStage.controls.attack_btn.x - this.starlingStage.controls.loot_btn.width / 2;
            this.starlingStage.controls.attack_btn.y = Starling.current.viewPort.height / Starling.contentScaleFactor - this.starlingStage.controls.attack_btn.height;
            this.starlingStage.controls.jump_btn.y = Starling.current.viewPort.height / Starling.contentScaleFactor - this.starlingStage.controls.jump_btn.height;
            this.starlingStage.controls.block_btn.y = this.starlingStage.controls.attack_btn.y - this.starlingStage.controls.block_btn.height / 1.75;
            this.starlingStage.controls.loot_btn.y = this.starlingStage.controls.attack_btn.bounds.bottom - this.starlingStage.controls.loot_btn.height;
            if(this.starlingStage.controls.chopFish_btn != null)
            {
               this.starlingStage.controls.chopFish_btn.x = Starling.current.viewPort.width / Starling.contentScaleFactor - this.starlingStage.controls.chopFish_btn.width;
               this.starlingStage.controls.unleash_btn.x = this.starlingStage.controls.chopFish_btn.x;
               this.starlingStage.controls.chopFish_btn.y = this.starlingStage.controls.attack_btn.y - this.starlingStage.controls.chopFish_btn.height + 5;
               this.starlingStage.controls.unleash_btn.y = this.starlingStage.controls.chopFish_btn.y - this.starlingStage.controls.unleash_btn.height - 1;
            }
            _loc6_ = Starling.current.viewPort.width / Starling.contentScaleFactor - 360;
            if(this.starlingStage.controls.chatPanel_image.width > _loc6_)
            {
               this.starlingStage.controls.chatPanel_image.width = _loc6_;
               this.starlingStage.controls.chat_txt.width = _loc6_;
               this.starlingStage.controls.message_txt.width = _loc6_;
            }
            this.starlingStage.controls.chatPanel_image.height = this.starlingStage.controls.chatPanel_image.height - 25;
            this.starlingStage.controls.chat_txt.height = this.starlingStage.controls.chat_txt.height - 25;
            this.starlingStage.controls.chatPanel_image.y = 0;
            this.starlingStage.controls.chatPanel_image.x = this.starlingStage.controls.etc_btn.x - this.starlingStage.controls.chatPanel_image.width;
            this.starlingStage.controls.chat_txt.x = this.starlingStage.controls.chatPanel_image.x + 9;
            this.starlingStage.controls.chat_txt.y = this.starlingStage.controls.chatPanel_image.y + 2;
            this.starlingStage.controls.message_txt.x = this.starlingStage.controls.chat_txt.x;
            this.starlingStage.controls.message_txt.y = this.starlingStage.controls.chatPanel_image.y + this.starlingStage.controls.chatPanel_image.height - 23;
            this.starlingStage.controls.message_txt.maxChars = this.starlingStage.controls.message_txt.width / 6;
         }
         this.focusLevel();
      }
      
      private function onEnter(param1:flash.events.Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Fish = null;
         var _loc4_:Tree = null;
         var _loc5_:FishingLine = null;
         _loc2_ = 0;
         _loc3_ = null;
         _loc4_ = null;
         _loc5_ = null;
         ++this.hitStopCounter;
         if(this.hitStopCounter < 0)
         {
            ++this.hitStopFramesSkipped;
            return;
         }
         if(this.hitStopFramesSkipped == 0)
         {
            this.hitStopFramesSkipped = 1;
         }
         _loc2_ = 0;
         while(_loc2_ < this.hitStopFramesSkipped)
         {
            ++this.counter;
            ++this.serverCounter;
            ++this.levelChangeCounter;
            if(this.tradeMenu == null || this.tradeMenu.parent == null)
            {
               ++this.lastTradeCounter;
            }
            this.starlingStage.controls.onEnter();
            this.controlMisc();
            this.controlPlayer();
            if(this.fakeCursor != null && this.fakeCursor.parent != null)
            {
               this.fakeCursor.onEnter();
            }
            this.len4 = this.e_array.length;
            this.q = this.len4 - 1;
            while(this.q >= 0)
            {
               this.onEnemy(this.e_array[this.q],this.q);
               --this.q;
            }
            this.len4 = this.item_array.length;
            this.q = this.len4 - 1;
            while(this.q >= 0)
            {
               this.onItem(this.item_array[this.q],this.q);
               --this.q;
            }
            this.len4 = this.projectile_array.length;
            this.q = this.len4 - 1;
            while(this.q >= 0)
            {
               this.projectile_array[this.q].onEnter(this,this.player,this.q);
               --this.q;
            }
            this.len4 = PetOrb.petOrb_array.length;
            this.q = this.len4 - 1;
            while(this.q >= 0)
            {
               PetOrb.petOrb_array[this.q].onEnter(this.q);
               --this.q;
            }
            this.len4 = CoinBox.coinBox_array.length;
            this.q = this.len4 - 1;
            while(this.q >= 0)
            {
               this.onCoinBox(CoinBox.coinBox_array[this.q],this.q);
               --this.q;
            }
            for each(var _loc8_ in Fish.newFish_array)
            {
               _loc3_ = _loc8_;
               _loc8_;
               _loc3_.onEnter(this.p_array);
            }
            this.len4 = DamageObject.damageObject_array.length;
            this.q = this.len4 - 1;
            while(this.q >= 0)
            {
               this.onDamageObject(DamageObject.damageObject_array[this.q],this.q);
               --this.q;
            }
            this.len4 = this.hCircle_array.length;
            this.q = this.len4 - 1;
            while(this.q >= 0)
            {
               this.onHealingCircle(this.hCircle_array[this.q],this.q);
               --this.q;
            }
            this.len4 = SplatParticle.particle_array.length;
            this.q = this.len4 - 1;
            while(this.q >= 0)
            {
               SplatParticle.particle_array[this.q].onEnter(this.q);
               --this.q;
            }
            this.len4 = Particle.particle_array.length;
            this.q = this.len4 - 1;
            while(this.q >= 0)
            {
               Particle.particle_array[this.q].onEnter(this.q);
               --this.q;
            }
            BulletShell.onEnterAll();
            for each(_loc8_ in Tree.tree_array)
            {
               _loc4_ = _loc8_;
               _loc8_;
               _loc4_.onEnter();
            }
            this.len4 = this.waterBubble_array.length;
            this.q = this.len4 - 1;
            while(this.q >= 0)
            {
               this.waterBubble_array[this.q].onEnter(this.waterBubble_array,this.q);
               --this.q;
            }
            this.len4 = this.smoke_array.length;
            this.q = this.len4 - 1;
            while(this.q >= 0)
            {
               this.smoke_array[this.q].onEnter(this.smoke_array,this.q);
               --this.q;
            }
            this.len4 = this.stormCloud_array.length;
            this.q = this.len4 - 1;
            while(this.q >= 0)
            {
               this.onStormCloud(this.stormCloud_array[this.q],this.q);
               --this.q;
            }
            this.len4 = Shadows.shadows_array.length;
            this.q = this.len4 - 1;
            while(this.q >= 0)
            {
               Shadows.shadows_array[this.q].onEnter(this.q);
               --this.q;
            }
            this.len4 = Leaf.leaf_array.length;
            this.q = this.len4 - 1;
            while(this.q >= 0)
            {
               Leaf.leaf_array[this.q].onEnter(this.q);
               --this.q;
            }
            this.len4 = TalkBubble.talkBubble_array.length;
            this.q = this.len4 - 1;
            while(this.q >= 0)
            {
               TalkBubble.talkBubble_array[this.q].onEnter();
               --this.q;
            }
            this.len4 = Explosion.explosion_array.length;
            this.q = this.len4 - 1;
            while(this.q >= 0)
            {
               Explosion.explosion_array[this.q].onEnter(this.q);
               --this.q;
            }
            this.len4 = BouncePad.bouncePad_array.length;
            this.q = this.len4 - 1;
            while(this.q >= 0)
            {
               BouncePad.bouncePad_array[this.q].onEnter();
               --this.q;
            }
            this.len4 = WindSource.wind_array.length;
            this.q = this.len4 - 1;
            while(this.q >= 0)
            {
               WindSource.wind_array[this.q].onEnter(this.q);
               --this.q;
            }
            for each(_loc8_ in FishingLine.all_array)
            {
               _loc5_ = _loc8_;
               _loc8_;
               _loc5_.onEnter();
            }
            this.len4 = this.magicEffect_array.length;
            this.q = this.len4 - 1;
            while(this.q >= 0)
            {
               this.onMagicEffect(this.magicEffect_array[this.q],this.q);
               --this.q;
            }
            this.len4 = Shockwave.shockwave_array.length;
            this.q = this.len4 - 1;
            while(this.q >= 0)
            {
               Shockwave.shockwave_array[this.q].onEnter(this.q);
               --this.q;
            }
            this.len4 = this.animation_array.length;
            this.q = this.len4 - 1;
            while(this.q >= 0)
            {
               this.onAnimation(this.animation_array[this.q],this.q);
               --this.q;
            }
            this.len4 = EnergyOrb.energyOrb_array.length;
            this.q = this.len4 - 1;
            while(this.q >= 0)
            {
               EnergyOrb.energyOrb_array[this.q].onEnter(this.q);
               --this.q;
            }
            this.len4 = this.lightningBolt_array.length;
            this.q = this.len4 - 1;
            while(this.q >= 0)
            {
               this.onLightningBolt(this.lightningBolt_array[this.q],this.q);
               --this.q;
            }
            CircleCreator.onEnter();
            Electrify.onEnterAll();
            Splatter.onEnterAll();
            TileHandler.onEnterAll(this.currentLevel);
            PipeController.onEnterAll(this.p_array);
            this.loopArray(this.shootingObject_array,this.onShootingObject);
            if(this.snow != null && this.snow.parent != null)
            {
               this.snow.handleSnow();
            }
            if(this.rain != null && this.rain.parent != null)
            {
               this.rain.handleRain();
            }
            if(this.lavaRain != null && this.lavaRain.parent != null)
            {
               this.lavaRain.handleRain();
            }
            Shake.shakeAll();
            SoundManager.handleLoopedSounds();
            GiveHealthBar.setPositions();
            Fire.setAllPositions();
            this.main_juggler.advanceTime(0.033);
            _loc2_++;
         }
         this.hitStopFramesSkipped = 0;
      }
      
      private function onPreLoadEnter(param1:Number) : void
      {
         var n_onWaitingForStatsLoadCheckEnter:Function = null;
         var _ratio:Number = param1;
         n_onWaitingForStatsLoadCheckEnter = null;
         this.loader_mc.scaleX = _ratio;
         this.load_txt.text = Math.floor(_ratio * 100) + "%";
         if(this.loader_mc.scaleX > 1)
         {
            this.loader_mc.scaleX = 0.1;
         }
         if(_ratio == 1)
         {
            n_onWaitingForStatsLoadCheckEnter = function(param1:flash.events.Event):void
            {
               if(Stats.allItemsAndEnemiesLoaded)
               {
                  init_txt.text = "";
                  loader_mc.scaleX = 1;
                  load_txt.text = "100%";
                  removeEventListener(flash.events.Event.ENTER_FRAME,onPreLoadEnter);
                  gotoAndStop(2);
                  setMisc();
                  TileHandler.init(starlingStage);
                  removeEventListener(flash.events.Event.ENTER_FRAME,n_onWaitingForStatsLoadCheckEnter);
               }
            };
            Assets.talk_font = starling.text.TextField.getBitmapFont("talk_font");
            AllTextFormats.init();
            Assets.assignAssets();
            Pet.petBodies_xml = Assets.main_assetManager.getXml("pet_body_locations");
            this.starlingStage.controls = new Controls();
            this.starlingStage.controls.visible = false;
            this.starlingStage.addChild(this.starlingStage.controls);
            addEventListener(flash.events.Event.ENTER_FRAME,n_onWaitingForStatsLoadCheckEnter);
         }
      }
      
      private function onLoadCheckEnter(param1:flash.events.Event) : void
      {
         if(this.theConnection.connected == true && this.player.awaitingSave == false)
         {
            stage.removeEventListener(flash.events.Event.ENTER_FRAME,this.onLoadCheckEnter);
            if(this.loadScreen != null && this.loadScreen.parent != null)
            {
               this.loadScreen.loadInfo_txt.text = this.loadScreen.loadInfo_txt.text + "\nloading tiles";
            }
         }
      }
      
      private function preLogInLoad() : void
      {
         var n_playerObjectLoaded:Function = null;
         n_playerObjectLoaded = null;
         n_playerObjectLoaded = function(param1:DatabaseObject):void
         {
            var n_loadBGJoin:Function = null;
            var tempUsername:String = null;
            var tempCharCode:int = 0;
            var n_menuBGLoadCheck:Function = null;
            var _dbObject:DatabaseObject = param1;
            tempUsername = null;
            tempCharCode = 0;
            n_menuBGLoadCheck = null;
            if(_dbObject != null)
            {
               n_loadBGJoin = function():void
               {
                  mMenu.loadingCircle_mc.loadingText_txt.text = "loading background";
                  AreaCreator.getBGArt(c_mc.currentFrame,function():void
                  {
                     if(AreaCreator.sky != null)
                     {
                        starlingStage.addChildAt(AreaCreator.sky,0);
                     }
                     joinRoom();
                  });
               };
               if(country == "Philippines" && _dbObject.lev < 400)
               {
                  mMenu.loadingCircle_mc.visible = false;
                  mMenu.gotoAndStop("region lock");
                  return;
               }
               tempUsername = Person.removeNamePrefix(_dbObject.name == undefined ? _dbObject.key : _dbObject.name);
               tempCharCode = tempUsername.charCodeAt(0);
               if(tempCharCode > 80 && tempCharCode < 90)
               {
                  serverName = "Main Server 2";
               }
               else if(tempCharCode > 90 && tempCharCode < 105)
               {
                  serverName = "Main Server 3";
               }
               if(_dbObject.stage == 51)
               {
                  _dbObject.stage = 46;
               }
               if(_dbObject.serv != undefined)
               {
                  serverName = _dbObject.serv;
               }
               c_mc.gotoAndStop(_dbObject.stage);
               len = starlingStage.c_mc.numChildren;
               i = len - 1;
               while(i >= 0)
               {
                  if(starlingStage.c_mc.getChildAt(i) != player)
                  {
                     starlingStage.c_mc.removeChildAt(i,true);
                  }
                  --i;
               }
               i = 0;
               while(i < 9)
               {
                  if(Stats.levelStats[_dbObject.stage]["portal" + (i + 1) + "Lead"] > 0)
                  {
                     ++counter;
                     changeLevel(c_mc.currentFrame,"portal" + (i + 1),true);
                     break;
                  }
                  ++i;
               }
               if(AreaCreator.sky == null)
               {
                  n_menuBGLoadCheck = function():void
                  {
                     if(AreaCreator.sky != null)
                     {
                        mMenu.removeEventListener(flash.events.Event.ENTER_FRAME,n_menuBGLoadCheck);
                        n_loadBGJoin();
                     }
                  };
                  mMenu.loadingCircle_mc.loadingText_txt.text = "loading menu BG";
                  mMenu.addEventListener(flash.events.Event.ENTER_FRAME,n_menuBGLoadCheck);
               }
               else
               {
                  n_loadBGJoin();
               }
            }
            else
            {
               mMenu.visible = false;
               createCreateMenu();
               charCreateMenu.passwordColon_txt.visible = charCreateMenu.password_txt.visible = false;
               charCreateMenu.emailColon_txt.visible = charCreateMenu.email_txt.visible = charCreateMenu.emailNotice_txt.visible = false;
               charCreateMenu.back_btn.visible = false;
               createTransition();
            }
         };
         if(this.charCreateMenu == null || this.charCreateMenu.parent == null)
         {
            this.theClient.bigDB.load("PlayerObjects",this.theClient.connectUserId,n_playerObjectLoaded);
         }
         else
         {
            this.handleConnect(this.theClient);
         }
      }
      
      private function onCutSceneEnter(param1:flash.events.Event) : void
      {
         if(Loader(param1.target).contentLoaderInfo.bytesLoaded == Loader(param1.target).contentLoaderInfo.bytesTotal && Loader(param1.target).contentLoaderInfo.content != null)
         {
            if(this.skipButton == null || this.skipButton.parent == null)
            {
               this.skipButton = new SkipButton();
               this.skipButton.x = 790;
               this.skipButton.y = 616;
               this.skipButton.name = "skip_btn";
               addChild(this.skipButton);
               TweenMax.from(this.skipButton,1,{
                  "alpha":0,
                  "delay":2,
                  "ease":Linear.easeNone
               });
               this.cutsceneBoarder = new CutsceneBoarder();
               addChild(this.cutsceneBoarder);
            }
            if(flash.display.MovieClip(Loader(param1.target).contentLoaderInfo.content).currentFrame == flash.display.MovieClip(Loader(param1.target).contentLoaderInfo.content).totalFrames)
            {
               if(SoundManager.musicOn == false)
               {
                  SoundManager.toggleMusic();
               }
               SoundManager.toggleSound();
               this.playLevelMusic(this.c_mc.currentFrame,true);
               flash.display.MovieClip(Loader(param1.target).contentLoaderInfo.content).stop();
               param1.target.removeEventListener(flash.events.Event.ENTER_FRAME,this.onCutSceneEnter);
               removeChild(flash.display.DisplayObject(param1.target));
               removeChild(getChildByName("black_bitmap"));
               removeChild(this.loadingCircle);
               removeChild(this.skipButton);
               removeChild(this.cutsceneBoarder);
               if(this.player.lev == 1 && (this.mMenu == null || this.mMenu.parent == null) && this.c_mc.currentFrame == 1)
               {
                  this.startIntroGame();
               }
            }
         }
      }
      
      private function onMDown(param1:MouseEvent) : void
      {
         this.mDown = true;
         if(this.rcMenu != null && this.rcMenu.parent != null && !(flash.display.DisplayObject(param1.target).parent is RightClickButton))
         {
            removeChild(this.rcMenu);
         }
         if(param1.target is GameMenu)
         {
            GameMenu.focusMenu(GameMenu(param1.target));
         }
         if(param1.target.name == "hitArea_mc" && param1.target.parent is GameMenu)
         {
            param1.target.parent.startDrag();
         }
         if(param1.target.name == "scroll_btn")
         {
            this.mDownTargetName = param1.target.name;
         }
         if(param1.target == stage)
         {
            stage.focus = null;
         }
      }
      
      private function onMUp(param1:MouseEvent) : void
      {
         this.mDown = false;
         this.mDownTargetName = "";
         this.len = GameMenu.menu_array.length;
         this.i = 0;
         while(this.i < this.len)
         {
            GameMenu.menu_array[this.i].stopDrag();
            this.c_mc.stopDrag();
            ++this.i;
         }
         if(param1.target.name == "sky_mc")
         {
            stage.focus = null;
         }
      }
      
      private function onMOut(param1:MouseEvent) : void
      {
         if(this.infoMenu != null && this.infoMenu.parent != null)
         {
            removeChild(this.infoMenu);
         }
         if(param1.target is EnemyInfoItem && EnemyInfoItem(param1.target).currentFrame == 2)
         {
            EnemyInfoItem(param1.target).gotoAndStop(1);
         }
         else if(param1.target is Person || param1.target is Enemy)
         {
            Cursor.onMoveCalled(null);
         }
      }
      
      private function onMWheel(param1:MouseEvent) : void
      {
         if(GameMenu.getFocusMenu() is GuildMemberMenu || GameMenu.getFocusMenu() is GuildMenu || GameMenu.getFocusMenu() is PayVaultMenu && this.pvMenu.currentFrame == 1)
         {
            if(this.maxItems == 20)
            {
               GameMenu.getFocusMenu().scroll_btn.y = GameMenu.getFocusMenu().scroll_btn.y - param1.delta * 2;
            }
            else if(GameMenu.getFocusMenu() is GuildMemberMenu)
            {
               GameMenu.getFocusMenu().scroll_btn.y = GameMenu.getFocusMenu().scroll_btn.y - param1.delta * 4;
            }
            else
            {
               GameMenu.getFocusMenu().scroll_btn.y = GameMenu.getFocusMenu().scroll_btn.y - param1.delta * 3;
            }
            if(GameMenu.getFocusMenu().scroll_btn.y < -134)
            {
               GameMenu.getFocusMenu().scroll_btn.y = -134;
            }
            if(GameMenu.getFocusMenu().scroll_btn.y > 194)
            {
               GameMenu.getFocusMenu().scroll_btn.y = 194;
            }
            if(GameMenu.getFocusMenu() is GuildMemberMenu)
            {
               GameMenu.getFocusMenu().list_mc.y = Math.abs(CalcDist.getDistY(GameMenu.getFocusMenu().scroll_btn.y,194) * 2.9) - 627;
            }
            else if(GameMenu.getFocusMenu() is GuildMenu)
            {
               GameMenu.getFocusMenu().list_mc.y = Math.abs(CalcDist.getDistY(GameMenu.getFocusMenu().scroll_btn.y,194) * 65) - 21000;
            }
            else if(GameMenu.getFocusMenu() is PayVaultMenu)
            {
               GameMenu.getFocusMenu().list_mc.y = Math.abs(CalcDist.getDistY(GameMenu.getFocusMenu().scroll_btn.y,194) * 3.6) - 875;
            }
            else
            {
               GameMenu.getFocusMenu().list_mc.y = Math.abs(CalcDist.getDistY(GameMenu.getFocusMenu().scroll_btn.y,194) * 2.82) - 600;
            }
         }
         if(StarlingGameMenu.getFocusMenu() is IScrollableGameMenu)
         {
            IScrollableGameMenu(StarlingGameMenu.getFocusMenu()).scrollWheel(param1.delta);
         }
      }
      
      private function onActivate(param1:flash.events.Event) : void
      {
         if(isMobile == false)
         {
            MouseWheel.capture();
         }
         stage.focus = null;
         if(isMobile)
         {
            if(SoundManager.soundOn == false)
            {
               SoundManager.toggleSound();
            }
            if(SoundManager.musicOn == false)
            {
               SoundManager.toggleMusic();
            }
         }
      }
      
      private function onDeActivate(param1:flash.events.Event) : void
      {
         MouseWheel.release();
         if(this.counter > 0 && this.theConnection != null && this.theConnection.connected)
         {
            this.player.keyHandler.keyRelease(Keyboard.RIGHT);
            this.player.keyHandler.keyRelease(Keyboard.LEFT);
            this.player.keyHandler.keyRelease(Keyboard.UP);
            this.player.keyHandler.keyRelease(Keyboard.DOWN);
            this.player.keyHandler.keyRelease(Keyboard.E);
            this.player.keyHandler.keyRelease(Keyboard.SPACE);
         }
         if(isMobile)
         {
            if(SoundManager.soundOn)
            {
               SoundManager.toggleSound();
            }
            if(SoundManager.musicOn)
            {
               SoundManager.toggleMusic();
            }
         }
      }
      
      private function onFocused(param1:FocusEvent) : void
      {
         if(param1.target.name == "username_txt" && flash.text.TextField(param1.target).text == "username")
         {
            flash.text.TextField(param1.target).text = "";
            flash.text.TextField(param1.target).textColor = 0;
         }
         else if(param1.target.name == "password_txt" && flash.text.TextField(param1.target).text == "password")
         {
            flash.text.TextField(param1.target).text = "";
            flash.text.TextField(param1.target).displayAsPassword = true;
            flash.text.TextField(param1.target).textColor = 0;
         }
      }
      
      private function controlPlayer() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Pet = null;
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc5_:Item = null;
         _loc1_ = false;
         _loc2_ = null;
         _loc3_ = null;
         _loc4_ = false;
         _loc5_ = null;
         this.player.onEnter();
         _loc1_ = false;
         if(this.player.health > 0 && this.player.y > TileHandler.tileMain_array.length * 165 + 500 && TileHandler.tileMain_array.length > 2)
         {
            this.theConnection.send("giDeadP","off map");
            _loc1_ = true;
            this.player.health = 0;
         }
         if(this.player.health <= 0 && (this.deadMenu == null || this.deadMenu.parent == null) && stage.hasEventListener(KeyboardEvent.KEY_DOWN))
         {
            if(this.c_mc.currentFrame != 49)
            {
               if(_loc1_ == false)
               {
                  if(this.player.bodyAnimator.hasHalo == false)
                  {
                     this.player.money = int(this.player.money / 2);
                  }
                  else
                  {
                     this.player.money = int(this.player.money * 0.85);
                  }
               }
            }
            if(_loc1_ == false && this.player.y < TileHandler.tileMain_array.length * 165 + 500)
            {
               this.theConnection.send("giDeadP");
            }
            this.createRed();
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKDown);
            stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKUp);
            this.createDeadMenu(_loc1_);
            if(StarlingGameMenu.menu_array.indexOf(this.tradeMenu) > -1)
            {
               StarlingGameMenu.focusMenu(this.tradeMenu);
               StarlingGameMenu.removeFocusMenu();
            }
         }
         if(this.counter % 12 == 0 && this.p_array.length > 1)
         {
            if(this.player.lastBroadcastX != this.player.hitTester.hit_rect.x || this.player.lastBroadcastY != this.player.hitTester.hit_rect.y || this.isPvpArea)
            {
               this.theConnection.send("P",int(this.player.gravityObject.hit_rect.x),int(this.player.gravityObject.hit_rect.y));
               this.player.lastBroadcastX = this.player.gravityObject.hit_rect.x;
               this.player.lastBroadcastY = this.player.gravityObject.hit_rect.y;
            }
         }
         var _loc6_:Boolean = false;
         if(this.isPvpArea && this.player.health > 0)
         {
            this.len = this.p_array.length;
            this.i = 0;
            while(this.i < this.len)
            {
               if(this.p_array[this.i].name != this.player.name)
               {
                  if(!(this.c_mc.currentFrame == 114 && this.p_array[this.i].guild == this.player.guild))
                  {
                     this.player.hitTester.playerAdvancedHitCheck(this.p_array[this.i]);
                     if(this.player.hitTester.hitType.hitter != null)
                     {
                        _loc3_ = "";
                        switch(this.player.hitTester.hitType.moveStat.name)
                        {
                           case Moves.GROUND_STAB:
                              StarExplosion.createExplosion(this.player.x,this.player.y + 30,7,100,150,this.starlingStage.c_mc,StarExplosion.DIR_UP);
                              LightPillar.createLightPiller(this.player.x,this.player.y + 30,this.c_mc);
                              break;
                           case Moves.LUNGE_ATTACK:
                              _loc3_ = "power";
                              break;
                           case Moves.SPIN_ATTACK:
                              _loc3_ = "spin attack";
                              break;
                           case Moves.DOWN_SLASH:
                              _loc3_ = "down slash";
                              break;
                           case Moves.DOWN_STAB:
                              _loc3_ = "down stab";
                              break;
                           case Moves.SUMMON_BEAM:
                              _loc3_ = "light beam";
                        }
                        this.p_array[this.i].canDamage = false;
                        this.theConnection.send("PdmgP",this.p_array[this.i].name,!this.player.hitTester.hitType.isPrimary,_loc3_,this.player.bodyAnimator.currentLabel == "block");
                     }
                  }
               }
               ++this.i;
            }
            for each(var _loc9_ in this.pet_array)
            {
               _loc2_ = _loc9_;
               _loc9_;
               if(_loc2_.owner != this.player)
               {
                  if(_loc2_.canDamage && _loc2_.isAttacking && _loc2_.hitTester.hit_rect.intersects(this.player.hitTester.hit_rect))
                  {
                     _loc2_.canDamage = false;
                     this.theConnection.send("petHitP",_loc2_.name);
                  }
               }
            }
         }
         if(this.c_mc.currentFrame == 56)
         {
            this.len = this.starlingStage.c_mc.numChildren;
            this.i = 0;
            while(this.i < this.len)
            {
               if(this.starlingStage.focus is StageTextTextEditor && this.starlingStage.focus.name == "ticketsBuy_txt")
               {
                  _loc4_ = false;
                  if(VendingMachine(this.starlingStage.c_mc.getChildByName(this.itemMenu.vendorKey)).sellerName == this.theClient.connectUserId || Person.removeNamePrefix(VendingMachine(this.starlingStage.c_mc.getChildByName(this.itemMenu.vendorKey)).sellerName) == this.player.name)
                  {
                     _loc4_ = true;
                  }
                  if(this.starlingStage.c_mc.getChildByName(this.itemMenu.vendorKey) != null && _loc4_ == false)
                  {
                     this.itemMenu.ticketsCost_txt.text = "$" + String(uint(StageTextTextEditor(this.starlingStage.focus).text) * VendingMachine(this.starlingStage.c_mc.getChildByName(this.itemMenu.vendorKey)).ticketPrice);
                  }
               }
               ++this.i;
            }
         }
         if(this.player.health > 0)
         {
            for each(_loc9_ in this.item_array)
            {
               _loc5_ = _loc9_;
               _loc9_;
               if(_loc5_.type == "coin" && _loc5_.alpha == 1 && this.player.hitTester.hit_rect.intersects(_loc5_.gravityObject.hit_rect))
               {
                  this.theConnection.send("giReI",_loc5_.name,int(_loc5_.gravityObject.hit_rect.x),int(_loc5_.gravityObject.hit_rect.y));
               }
            }
         }
      }
      
      private function controlMisc() : void
      {
         var _loc1_:Image = null;
         var _loc2_:Person = null;
         _loc1_ = null;
         _loc2_ = null;
         if(Boolean(this.mDown) && this.mDownTargetName == "scroll_btn" && GameMenu.getFocusMenu() != null && GameMenu.getFocusMenu().getChildByName("scroll_btn") != null)
         {
            this.local_point.x = mouseX;
            this.local_point.y = mouseY;
            this.local_point = GameMenu.getFocusMenu().globalToLocal(this.local_point);
            GameMenu.getFocusMenu().scroll_btn.y = this.local_point.y;
            if(GameMenu.getFocusMenu().scroll_btn.y < -134)
            {
               GameMenu.getFocusMenu().scroll_btn.y = -134;
            }
            if(GameMenu.getFocusMenu().scroll_btn.y > 194)
            {
               GameMenu.getFocusMenu().scroll_btn.y = 194;
            }
            if(GameMenu.getFocusMenu() is GuildMenu)
            {
               GameMenu.getFocusMenu().list_mc.y = Math.abs(CalcDist.getDistY(GameMenu.getFocusMenu().scroll_btn.y,194) * 65) - 21000;
            }
            else if(GameMenu.getFocusMenu() is PayVaultMenu)
            {
               GameMenu.getFocusMenu().list_mc.y = Math.abs(CalcDist.getDistY(GameMenu.getFocusMenu().scroll_btn.y,194) * 3.6) - 875;
            }
            else
            {
               GameMenu.getFocusMenu().list_mc.y = Math.abs(CalcDist.getDistY(GameMenu.getFocusMenu().scroll_btn.y,194) * 2.82) - 600;
            }
         }
         else if(Boolean(this.mDown) && this.mDownTargetName == "scroll_btn" && StarlingGameMenu.getFocusMenu() is IScrollableGameMenu)
         {
            IScrollableGameMenu(StarlingGameMenu.getFocusMenu()).scroll(mouseY);
         }
         if((Boolean(this.scrollMenuUp) || Boolean(this.scrollMenuDown)) && StarlingGameMenu.getFocusMenu() is IScrollableGameMenu)
         {
            if(this.scrollMenuUp)
            {
               IScrollableGameMenu(StarlingGameMenu.getFocusMenu()).scrollWheel(4);
            }
            else
            {
               IScrollableGameMenu(StarlingGameMenu.getFocusMenu()).scrollWheel(-4);
            }
         }
         if(this.starlingStage.controls.heropedia_btn != null && this.starlingStage.controls.heropedia_btn.parent != null)
         {
            this.starlingStage.controls.missions_btn.scaleX = this.starlingStage.controls.missions_btn.scaleY = this.starlingStage.controls.blinkMissionButton && this.counter % 13 == 0 ? 1.1 : 1;
            this.starlingStage.controls.char_btn.scaleX = this.starlingStage.controls.char_btn.scaleY = this.starlingStage.controls.blinkCharacterButton && this.counter % 13 == 0 ? 1.1 : 1;
            this.starlingStage.controls.heropedia_btn.scaleX = this.starlingStage.controls.heropedia_btn.scaleY = this.starlingStage.controls.blinkHeropediaButton && this.counter % 13 == 0 ? 1.1 : 1;
         }
         if(GameMenu.menu_array.indexOf(this.pvMenu) > -1 && this.pvMenu.currentFrame == 1 && this.player.tickets == 0)
         {
            this.pvMenu.getTickets_btn.transform.colorTransform = this.counter % 30 == 0 ? bright_colorTransform : normal_colorTransform;
         }
         if(this.counter % this.onlineFriendIntervalCheck == 0)
         {
            this.len = FriendMenu.friends_array.length;
            this.i = 0;
            while(this.i < this.len)
            {
               if(FriendMenu.friends_array[this.i].indexOf("facebook") != 0 && FriendMenu.friends_array[this.i].indexOf("kongregate") != 0 && FriendMenu.friends_array[this.i].indexOf("steam") != 0 && FriendMenu.friends_array[this.i].indexOf("playerio") != 0)
               {
                  this.theClient.bigDB.load("PlayerObjects",FriendMenu.friends_array[this.i],this.friendInfoLoaded);
               }
               else
               {
                  this.theClient.bigDB.loadSingle("PlayerObjects","nameIndex",[FriendMenu.friends_array[this.i]],this.friendInfoLoaded);
               }
               ++this.i;
            }
            if(this.player.guild != "")
            {
               this.theClient.bigDB.load("guildsData",this.player.guild,this.guildOnlineLoaded);
            }
         }
         if(this.theConnection.connected == true && (this.counter % 180 == 0 && (this.pmMenu != null && this.pmMenu.parent != null) || this.counter % 450 == 0 && (this.pmMenu == null || this.pmMenu.parent == null)))
         {
            this.theClient.bigDB.loadRange("messageTable","receiverIndex",[this.player.name],0,0,50,this.chatMessagesLoaded);
         }
         if(this.player.guild != "" && this.counter % 150 == 0)
         {
            this.a = 0;
            this.len = this.p_array.length;
            for each(var _loc6_ in this.p_array)
            {
               _loc2_ = _loc6_;
               _loc6_;
               if(_loc2_.name != this.player.name && _loc2_.guild == this.player.guild)
               {
                  ++this.a;
               }
            }
            if(this.a > 0 && (this.membersInAreaMenu == null || this.membersInAreaMenu.parent == null))
            {
               this.createMembersInAreaMenu(this.a);
            }
            else if(this.a > 0 && this.membersInAreaMenu != null && this.membersInAreaMenu.parent != null)
            {
               this.membersInAreaMenu.members_txt.text = String(this.a) + " guild " + (this.a == 1 ? "member" : "members") + " present";
            }
         }
         else if(this.player.guild != "" && this.counter % 100 == 0 && (this.membersInAreaMenu != null && this.membersInAreaMenu.parent != null))
         {
            this.a = 0;
            this.len = this.p_array.length;
            this.i = 0;
            while(this.i < this.len)
            {
               if(this.p_array[this.i].name != this.player.name && this.p_array[this.i].guild == this.player.guild)
               {
                  ++this.a;
               }
               ++this.i;
            }
            if(this.a == 0)
            {
               TweenMax.to(this.membersInAreaMenu,0.7,{
                  "x":-75,
                  "ease":Linear.easeNone,
                  "onComplete":CommonCalls.removeObject,
                  "onCompleteParams":[this.membersInAreaMenu]
               });
            }
         }
         if(this.cMenu != null && this.cMenu.parent != null && this.player.skillPoints > 0)
         {
            this.cMenu.skills_btn.scaleX = this.cMenu.skills_btn.scaleY = this.counter % 25 == 0 ? 1.1 : 1;
         }
         if(this.counter % 2400 == 0)
         {
            this.pingStartTime = getTimer();
            this.theConnection.send("giPing");
         }
         if(AreaCreator.cloud1 != null)
         {
            AreaCreator.cloud1.x = AreaCreator.cloud1.x + 1;
            AreaCreator.cloud2.x = AreaCreator.cloud2.x + 0.5;
            if(AreaCreator.cloud1.x > this.mainStarling.viewPort.width + 150)
            {
               AreaCreator.cloud1.x = -500;
            }
            if(AreaCreator.cloud2.x > this.mainStarling.viewPort.width + 150)
            {
               AreaCreator.cloud2.x = -500;
            }
         }
         for each(_loc6_ in this.portal_array)
         {
            _loc1_ = _loc6_;
            _loc6_;
            if(_loc1_.scaleX <= 1)
            {
               _loc1_.scaleY = _loc1_.scaleY + 0.03;
               if(_loc1_.scaleY > 1.4)
               {
                  _loc1_.scaleX = 1.01;
               }
            }
            else
            {
               _loc1_.scaleY = _loc1_.scaleY - 0.03;
               if(_loc1_.scaleY < 0.6)
               {
                  _loc1_.scaleX = 0.99;
               }
            }
         }
         ++this.idleCounter;
         var _loc3_:uint = isMobile ? 9000 : 54000;
         if(this.idleCounter > 18000)
         {
            this.theConnection.disconnect();
            if(isMobile)
            {
               flash.display.MovieClip(parent.parent).theNativeApp.exit();
            }
         }
      }
      
      private function createPerson(param1:String, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int, param10:int, param11:int, param12:int, param13:int, param14:int, param15:int, param16:int, param17:int, param18:int, param19:int, param20:int, param21:int, param22:int, param23:int, param24:int, param25:int) : Person
      {
         var _loc26_:Person = null;
         _loc26_ = null;
         _loc26_ = new Person(this,this.p_array.length == 0,param1);
         _loc26_.x = param2;
         _loc26_.y = param3;
         _loc26_.bodyAnimator.originalHair = param4;
         _loc26_.bodyAnimator.skin = param9;
         _loc26_.bodyAnimator.shirtFrame = param6;
         _loc26_.bodyAnimator.pantsFrame = param7;
         _loc26_.bodyAnimator.shoeFrame = param11;
         _loc26_.bodyAnimator.weaponFrame = param8;
         _loc26_.bodyAnimator.weapon2Frame = param23;
         _loc26_.bodyAnimator.eyes = param10;
         _loc26_.bodyAnimator.hair = param4;
         _loc26_.bodyAnimator.helmetFrame = param5;
         _loc26_.bodyAnimator.beard = param25;
         _loc26_.money = 0;
         _loc26_.lev = param12;
         _loc26_.totalHealth = param14;
         _loc26_.health = param15;
         _loc26_.totalMP = param20;
         _loc26_.MP = param21;
         _loc26_.power = param13;
         _loc26_.dex = param16;
         _loc26_.defense = param17;
         _loc26_.magic = param22;
         _loc26_.range = param19;
         _loc26_.artillery = param24;
         _loc26_.moveSpeed = 7 + _loc26_.dex / 176;
         this.p_array.push(_loc26_);
         SortDepths.addAt(_loc26_,SortDepths.REGION_4);
         if(this.isPvpArea)
         {
            GiveHealthBar.to(_loc26_);
         }
         if(CommonCalls.onScreen(_loc26_.x,_loc26_.y,false,true))
         {
            this.teleportIn(_loc26_);
         }
         return _loc26_;
      }
      
      private function createEnemy(param1:String, param2:String, param3:int, param4:int, param5:int, param6:int, param7:int) : Enemy
      {
         var _loc8_:Enemy = null;
         var _loc9_:int = 0;
         var _loc10_:Enemy = null;
         var _loc11_:int = 0;
         _loc8_ = null;
         _loc9_ = 0;
         _loc10_ = null;
         switch(param2)
         {
            case "green bouncer":
               _loc8_ = new GreenBouncer();
               break;
            case "green walker":
               _loc8_ = new GreenWalker();
               break;
            case "purple goo":
               _loc8_ = new PurpleGoo();
               break;
            case "red bouncer":
               _loc8_ = new RedBouncer();
               break;
            case "mushroom squish":
               _loc8_ = new MushroomSquish();
               break;
            case "mushroom ball":
               _loc8_ = new MushroomBall();
               break;
            case "orange crazy":
               _loc8_ = new OrangeCrazy();
               break;
            case "crab":
               _loc8_ = new Crab();
               break;
            case "plant monster":
               _loc8_ = new PlantMonster();
               break;
            case "bouncing mushroom":
               _loc8_ = new BouncingMushroom();
               break;
            case "horned monster":
               _loc8_ = new HornedMonster();
               break;
            case "pumpkin creeper":
               _loc8_ = new PumpkinCreeper();
               break;
            case "yellow hairy monster":
               _loc8_ = new YellowHairyMonster();
               break;
            case "yellow puff monster":
               _loc8_ = new YellowPuffMonster();
               break;
            case "great frog":
               _loc8_ = new GreatFrog();
               break;
            case "penguin":
               _loc8_ = new Penguin();
               break;
            case "sasquatch":
               _loc8_ = new Sasquatch();
               break;
            case "goo cube":
               _loc8_ = new GooCube();
               break;
            case "brick monster":
               _loc8_ = new BrickMonster();
               break;
            case "block bot":
               _loc8_ = new BlockBot();
               break;
            case "drill bot":
               _loc8_ = new DrillBot();
               break;
            case "night stalker":
               _loc8_ = new Nightstalker();
               break;
            case "lotus eye":
               _loc8_ = new LotusEye();
               break;
            case "dark beholder":
               _loc8_ = new Beholder();
               break;
            case "kreeton":
               _loc8_ = new Kreeton();
               break;
            case "leafling":
               _loc8_ = new Leafling();
               break;
            case "leaflet":
               _loc8_ = new Leaflet();
               break;
            case "glord":
               _loc8_ = new Glord();
               break;
            case "repguana":
               _loc8_ = new Repguana();
               break;
            case "fishurn":
               _loc8_ = new Fishurn();
               break;
            case "proteum":
               _loc8_ = new Proteum();
               break;
            case "bionic bird":
               _loc8_ = new BionicBird();
               break;
            case "titanium vulture":
               _loc8_ = new TitaniumVulture();
               break;
            case "giant goo cube":
               _loc8_ = new GiantGooCube();
               break;
            case "Kreetus":
               _loc8_ = new Kreetus();
               break;
            case "Carnelia":
               _loc8_ = new Carnelia();
               break;
            case "magmagon":
               _loc8_ = new Magmagon();
               break;
            case "aipster":
               _loc8_ = new Aipster();
               break;
            case "mongrel":
               _loc8_ = new Mongrel();
               break;
            case "kraken":
               _loc8_ = new Kraken();
               break;
            case "bullopede":
               _loc8_ = new Bullopede();
               break;
            case "flockling":
               _loc8_ = new Flockling();
               break;
            case "chirplet":
               _loc8_ = new Chirplet();
               break;
            case "kraw":
               _loc8_ = new Kraw();
               break;
            case "mushroom bird":
               _loc8_ = new MushroomBird();
               break;
            case "omega fluff":
               _loc8_ = new OmegaFluff();
         }
         _loc8_.x = param3;
         _loc8_.y = param4;
         _loc8_.enemyAI.moveCounter = param5;
         _loc8_.moveSpeed = Stats.eStats[param2].moveSpeed;
         _loc8_.jumpPower = Stats.eStats[param2].jumpPower;
         _loc8_.moveDir = param6;
         _loc8_.totalHealth = Stats.eStats[param2].health;
         _loc8_.health = param7;
         _loc8_.pastHealth = _loc8_.health;
         _loc8_.name = param1;
         this.main_juggler.add(_loc8_);
         _loc9_ = Math.min(SortDepths.getLowestChildIndex(Vector.<starling.display.DisplayObject>(GiveHealthBar.healthBG_array)),SortDepths.getLowestChildIndex(Vector.<starling.display.DisplayObject>(Fire.fire_array)),SortDepths.getLowestChildIndex(Vector.<starling.display.DisplayObject>(this.p_array)),SortDepths.getLowestChildIndex(Vector.<starling.display.DisplayObject>(this.npc_array)));
         if(_loc9_ == int.MAX_VALUE)
         {
            _loc9_ = this.starlingStage.c_mc.numChildren;
         }
         for each(var _loc14_ in this.e_array)
         {
            _loc10_ = _loc14_;
            _loc14_;
            if(_loc10_.type == param2)
            {
               _loc9_ = _loc10_.parent.getChildIndex(_loc10_);
               break;
            }
         }
         _loc11_ = this.e_array.length - 1;
         while(_loc11_ >= 0)
         {
            if(this.e_array[_loc11_].name == param1)
            {
               this.e_array[_loc11_].hitTester.frozen = false;
               this.main_juggler.remove(this.e_array[_loc11_]);
               this.e_array[_loc11_].removeFromParent(true);
               this.e_array.removeAt(_loc11_);
               break;
            }
            --_loc11_;
         }
         this.starlingStage.c_mc.addChildAt(_loc8_,_loc9_);
         this.e_array.push(_loc8_);
         if(stage.quality != StageQuality.LOW.toUpperCase())
         {
            _loc8_.healthBar_image = GiveHealthBar.to(_loc8_);
         }
         if(_loc8_.moveDir == 1)
         {
            _loc8_.keyPress(Keyboard.RIGHT);
         }
         else if(_loc8_.moveDir == -1)
         {
            _loc8_.keyPress(Keyboard.LEFT);
         }
         if(CommonCalls.onScreen(_loc8_.x,_loc8_.y,false,true))
         {
            this.teleportIn(_loc8_);
         }
         return _loc8_;
      }
      
      public function createPet(param1:Boolean, param2:Person, param3:String, param4:String, param5:int, param6:int, param7:int, param8:int, param9:int, param10:int, param11:String, param12:int) : Pet
      {
         var _loc13_:Pet = null;
         var _loc14_:* = undefined;
         var _loc15_:Pet = null;
         var _loc16_:* = undefined;
         var _loc17_:int = 0;
         var _loc18_:* = undefined;
         _loc13_ = null;
         _loc14_ = undefined;
         _loc15_ = null;
         _loc16_ = undefined;
         for each(var _loc21_ in this.pet_array)
         {
            _loc13_ = _loc21_;
            _loc21_;
            if(_loc13_.name == param3)
            {
               return _loc13_;
            }
         }
         for each(_loc21_ in this.p_array)
         {
            _loc14_ = _loc21_;
            _loc21_;
            _loc17_ = 0;
            _loc18_ = _loc14_.pet_array;
            for each(var _loc23_ in _loc18_)
            {
               _loc16_ = _loc23_;
               _loc23_;
            }
         }
         _loc15_ = new Pet(this,param3,param4);
         _loc15_.health = param5;
         _loc15_.totalHealth = param6;
         _loc15_.power = param7;
         _loc15_.dex = param8;
         _loc15_.defense = param9;
         _loc15_.love = param10;
         _loc15_.helmet_uint = param12;
         _loc15_.x = param2.x;
         _loc15_.y = param2.y;
         _loc15_.owner = param2;
         _loc15_.isActive = param1;
         _loc15_.mode = param11;
         _loc15_.moveMode = Stats.petModes[_loc15_.mode].moveMode;
         param2.pet_array.push(_loc15_);
         if(param1 && _loc15_.mode != "m")
         {
            this.pet_array.push(_loc15_);
            SortDepths.addAt(_loc15_,SortDepths.REGION_4);
         }
         if(param1 && _loc15_.owner.name == this.player.name)
         {
            this.starlingStage.controls.createPetControlBars(param3);
         }
         if(param2.name == this.player.name && this.starlingStage.controls.pets_btn != null && this.starlingStage.controls.pets_btn.parent != null)
         {
            this.starlingStage.controls.pets_btn.visible = true;
         }
         _loc15_.updateFrame();
         return _loc15_;
      }
      
      public function createItem(param1:String, param2:int, param3:int, param4:String, param5:int = 0, param6:String = "", param7:Number = 0, param8:Number = -14) : Item
      {
         var _loc9_:Item = null;
         _loc9_ = null;
         _loc9_ = new Item(param4,param6,this.player.name);
         _loc9_.name = param1;
         _loc9_.x = param2;
         _loc9_.y = param3;
         _loc9_.gravityObject.velX = param7;
         _loc9_.gravityObject.velY = param8;
         _loc9_.worth = param5;
         this.item_array.push(_loc9_);
         SortDepths.addAt(_loc9_,SortDepths.REGION_4);
         return _loc9_;
      }
      
      private function createPetOrb(param1:int, param2:String, param3:String, param4:int, param5:String, param6:Boolean) : void
      {
         var _loc7_:Person = null;
         var _loc8_:String = null;
         var _loc9_:PetOrb = null;
         _loc7_ = null;
         _loc8_ = null;
         _loc9_ = null;
         _loc7_ = Person(CommonCalls.returnObject(this.p_array,param3));
         if(_loc7_ != null)
         {
            _loc7_.hasOrbFocus = param6;
            _loc8_ = Stats.petStats[param5].sColor;
            _loc9_ = new PetOrb(_loc7_.x,_loc7_.y - 40,_loc8_,param4,_loc7_,param2,param1,param6);
            SortDepths.addAt(_loc9_,SortDepths.REGION_4);
            this.starlingStage.c_mc.addChildAt(_loc9_,this.starlingStage.c_mc.getChildIndex(_loc7_) + 1);
            PetOrb.petOrb_array.push(_loc9_);
         }
      }
      
      private function createEnvProjectile(param1:int, param2:int, param3:Number, param4:Number, param5:String) : void
      {
         var _loc6_:EnvironmentProjectile = null;
         _loc6_ = null;
         _loc6_ = new EnvironmentProjectile();
         _loc6_.y = param2;
         _loc6_.velX = param3;
         _loc6_.velY = param4;
         _loc6_.cacheAsBitmap = true;
         _loc6_.gotoAndStop(param5);
         _loc6_.x = param1 + (param3 > 0 ? _loc6_.width / 2 : -(_loc6_.width / 2));
         this.c_mc.addChild(_loc6_);
      }
      
      public function createDamageText(param1:Number, param2:int, param3:int, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false) : void
      {
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:uint = 0;
         var _loc11_:starling.text.TextFormat = null;
         var _loc12_:starling.text.TextField = null;
         _loc7_ = null;
         _loc8_ = 0;
         _loc9_ = 0;
         _loc10_ = 0;
         _loc11_ = null;
         _loc12_ = null;
         _loc7_ = CommonCalls.numberToCommaString(param1);
         _loc8_ = param5 == false ? 34 : 48;
         _loc9_ = param5 == false ? 42 : 60;
         _loc10_ = param4 == false ? 16757248 : 13434880;
         if(param6)
         {
            _loc7_ = "avoided";
            _loc10_ = 16777215;
            _loc8_ = 28;
         }
         _loc11_ = new TextFormat(Assets.damage_font.name,_loc8_,_loc10_);
         _loc12_ = new starling.text.TextField(5,_loc9_,_loc7_,_loc11_);
         _loc12_.x = param2;
         _loc12_.y = param3;
         _loc12_.autoSize = TextFieldAutoSize.HORIZONTAL;
         _loc12_.touchable = false;
         this.starlingStage.c_mc.addChild(_loc12_);
         TweenMax.to(_loc12_,1,{
            "alpha":0,
            "y":param3 - 100,
            "ease":Linear.easeNone,
            "onComplete":_loc12_.removeFromParent,
            "onCompleteParams":[true]
         });
         _loc11_ = null;
      }
      
      public function createTree(param1:String, param2:String, param3:int, param4:int, param5:Boolean, param6:int = -1) : void
      {
         var _loc7_:Tree = null;
         _loc7_ = null;
         _loc7_ = new Tree(param1,param2,param3,param4 - 21,this,param5);
         if(param6 > -1)
         {
            _loc7_.health = param6;
            _loc7_.totalHealth = param6;
         }
         Tree.tree_array.push(_loc7_);
         if(param5 == false)
         {
            SortDepths.addAt(_loc7_,SortDepths.REGION_2);
         }
         else
         {
            _loc7_.y = _loc7_.y + 10;
            this.starlingStage.c_mc.addChild(_loc7_);
         }
      }
      
      public function saveProficiency() : void
      {
         if(this.player == null || this.theConnection == null)
         {
            return;
         }
         this.theConnection.send("prof",this.player.choppingLvl,this.player.chopXP,this.player.fishingLvl,this.player.fishXP);
      }
      
      public function createYellowExplosion(param1:int, param2:int, param3:Number) : void
      {
         var _loc4_:YellowExplosion = null;
         _loc4_ = null;
         _loc4_ = new YellowExplosion(this);
         _loc4_.x = param1;
         _loc4_.y = param2;
         _loc4_.scaleX = _loc4_.scaleY = param3;
         _loc4_.loop = false;
         SortDepths.addAt(_loc4_,SortDepths.REGION_4);
         this.animation_array.push(_loc4_);
         this.main_juggler.add(_loc4_);
      }
      
      public function createXPText(param1:int, param2:int, param3:int, param4:String = "") : void
      {
         var _loc5_:starling.text.TextField = null;
         _loc5_ = null;
         _loc5_ = new starling.text.TextField(5,21,"+" + String(param1) + "xp",AllTextFormats.xp_textFormat);
         _loc5_.x = param2;
         _loc5_.y = param3;
         _loc5_.touchable = false;
         _loc5_.autoSize = TextFieldAutoSize.HORIZONTAL;
         this.starlingStage.c_mc.addChild(_loc5_);
         TweenMax.to(_loc5_,0.8,{
            "alpha":0,
            "y":param3 - 60,
            "ease":Linear.easeNone,
            "onComplete":_loc5_.removeFromParent,
            "onCompleteParams":[true]
         });
      }
      
      public function createDashCloud(param1:Number, param2:Number, param3:int, param4:uint, param5:Number = 0) : void
      {
         var _loc6_:Image = null;
         _loc6_ = null;
         _loc6_ = new Image(Assets.items_textureAtlas.getTexture("dash cloud " + param4));
         _loc6_.x = param1;
         _loc6_.y = param2;
         _loc6_.pivotX = _loc6_.width / 2;
         _loc6_.pivotY = _loc6_.height;
         _loc6_.touchable = false;
         _loc6_.rotation = deg2rad(param5);
         _loc6_.scaleX = param3;
         SortDepths.addAt(_loc6_,SortDepths.REGION_4,SortDepths.REGION_4B);
         TweenMax.to(_loc6_,1,{
            "alpha":0,
            "ease":Linear.easeNone,
            "onComplete":_loc6_.removeFromParent,
            "onCompleteParams":[true]
         });
      }
      
      public function createProjectile(param1:int, param2:int, param3:String, param4:int, param5:Boolean = false, param6:Number = 0.75, param7:Boolean = false, param8:int = 1) : Projectile
      {
         var _loc9_:String = null;
         var _loc10_:Person = null;
         var _loc11_:uint = 0;
         var _loc12_:Projectile = null;
         _loc9_ = null;
         _loc10_ = null;
         _loc11_ = 0;
         _loc12_ = null;
         _loc10_ = Person(CommonCalls.returnObject(this.p_array,param3));
         _loc11_ = _loc10_.bodyAnimator.currentFrame;
         if(param5 == false || _loc11_ == 103 || _loc11_ == 80 || _loc11_ == 157 || _loc11_ == 171 || _loc11_ == 206 || _loc11_ == 405 || _loc11_ == 415 || _loc11_ == 427 || _loc11_ == 444)
         {
            _loc9_ = Person(CommonCalls.returnObject(this.p_array,param3)).bodyAnimator.weaponString;
         }
         else if(_loc10_.bodyAnimator.weapon2String != "none")
         {
            if(Stats.wStats[Person(CommonCalls.returnObject(this.p_array,param3)).bodyAnimator.weapon2String].isMagic)
            {
               _loc9_ = Person(CommonCalls.returnObject(this.p_array,param3)).bodyAnimator.weapon2String;
            }
         }
         _loc12_ = new Projectile(_loc9_ + " proj",_loc10_);
         _loc12_.x = param1;
         _loc12_.y = param2;
         _loc12_.isMagic = param5;
         _loc12_.gravityObject.accelDownMultiplier = param5 == false ? -param6 : -0.8 - Math.random() / 3;
         _loc12_.lifeSpan = param5 ? int(4 + _loc10_.magicDistanceLvl) : _loc12_.lifeSpan;
         _loc12_.piercing = param7;
         _loc12_.isMagicSecondary = false;
         _loc12_.maxHits = param8;
         _loc12_.gravityObject.velX = (param5 == false ? 35 : 9 + Math.random() * 3) * param4;
         this.projectile_array.push(_loc12_);
         SortDepths.addAt(_loc12_,SortDepths.REGION_4);
         if(param7)
         {
            SetHue.tintObject(_loc12_,16711680);
         }
         return _loc12_;
      }
      
      public function createBulletShell(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:BulletShell = null;
         _loc5_ = null;
         _loc5_ = new BulletShell(param3);
         _loc5_.x = param1;
         _loc5_.y = param2;
         this.starlingStage.c_mc.addChildAt(_loc5_,param4);
      }
      
      public function createHitAnimation(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:String = null;
         var _loc5_:Image = null;
         _loc4_ = null;
         _loc5_ = null;
         _loc4_ = "hit animation " + Math.ceil(Math.random() * 3);
         _loc5_ = new Image(Assets.items_textureAtlas.getTexture(_loc4_));
         _loc5_.x = param1;
         _loc5_.y = param2;
         _loc5_.pivotX = Assets.items_object[_loc4_].pivotX;
         _loc5_.pivotY = Assets.items_object[_loc4_].pivotY;
         _loc5_.scaleX = param3;
         _loc5_.touchable = false;
         SortDepths.addAt(_loc5_,SortDepths.REGION_4);
         TweenMax.to(_loc5_,0.7,{
            "alpha":0,
            "ease":Linear.easeNone,
            "onComplete":_loc5_.removeFromParent,
            "onCompleteParams":[true]
         });
      }
      
      public function createAlert(param1:String, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc4_:flash.text.TextFormat = null;
         if(this.textAlert == null || this.textAlert.parent == null)
         {
            this.textAlert = new TextAlert();
            this.textAlert.x = this.mainStarling.viewPort.width / 2;
            this.textAlert.y = 150;
            this.textAlert.scaleX = this.textAlert.scaleY = Starling.contentScaleFactor;
            this.textAlert.mouseChildren = false;
            this.textAlert.mouseEnabled = false;
            if(param2)
            {
               this.textAlert.alert_txt.textColor = 16777215;
            }
            addChild(this.textAlert);
         }
         this.textAlert.alert_txt.text = param1;
         try
         {
            _loc4_ = this.textAlert.alert_txt.getTextFormat();
            if(_loc4_ == null)
            {
               _loc4_ = new flash.text.TextFormat();
            }
            _loc4_.bold = param3;
            this.textAlert.alert_txt.setTextFormat(_loc4_);
         }
         catch(alertFmtErr:Error)
         {
         }
         this.textAlert.alpha = 1;
         TweenMax.to(this.textAlert,1,{
            "alpha":0,
            "delay":2,
            "ease":Linear.easeNone,
            "onComplete":CommonCalls.removeObject,
            "onCompleteParams":[this.textAlert],
            "overwrite":true
         });
      }
      
      private function friendOnlineGot(param1:Message, param2:String) : void
      {
         this.createLogOnMenu(String(param2)," (friend) has logged on");
      }
      
      private function guildMemberOnlineGot(param1:Message, param2:String) : void
      {
         this.createLogOnMenu(String(param2)," (guild member) has logged on");
      }
      
      private function createFish(param1:int, param2:int, param3:String) : void
      {
         var _loc4_:Fish = null;
         _loc4_ = null;
         _loc4_ = new Fish(param1,param2,param3);
         Fish.newFish_array.push(_loc4_);
         SortDepths.addAt(_loc4_,SortDepths.REGION_2);
      }
      
      public function createFishingLine(param1:Person) : FishingLine
      {
         var _loc2_:FishingLine = null;
         _loc2_ = null;
         _loc2_ = new FishingLine(param1);
         SortDepths.addAt(_loc2_,SortDepths.REGION_4);
         return _loc2_;
      }
      
      private function createHealingCircle(param1:int, param2:int, param3:starling.display.DisplayObject) : void
      {
         var _loc4_:HealingCircle = null;
         _loc4_ = null;
         _loc4_ = new HealingCircle(param3);
         _loc4_.x = param1;
         _loc4_.y = param2;
         this.hCircle_array.push(_loc4_);
         this.c_mc.addChild(_loc4_);
      }
      
      private function createTalkBubble(param1:Person, param2:String, param3:int = 0) : void
      {
         var _loc4_:TalkBubble = null;
         var _loc5_:TalkBubble = null;
         _loc4_ = null;
         _loc5_ = null;
         this.a = 0;
         for each(var _loc8_ in TalkBubble.talkBubble_array)
         {
            _loc4_ = _loc8_;
            _loc8_;
            if(_loc4_.connectedPerson == param1)
            {
               ++this.a;
               _loc4_.connectedTalk_txt.text = param2;
               _loc4_.scaleX = _loc4_.scaleY = 1;
               _loc4_.height = 15 + _loc4_.connectedTalk_txt.height * 1.15;
               if(param1.npc == false)
               {
                  TweenMax.to(_loc4_,0,{
                     "delay":param2.length / 8 + 2.9,
                     "overwrite":true,
                     "onComplete":_loc4_.removeFromParent,
                     "onCompleteParams":[true]
                  });
               }
               TweenMax.from(_loc4_,0.2,{
                  "scaleX":0.1,
                  "scaleY":0.1,
                  "ease":Back.easeOut
               });
               break;
            }
         }
         if(this.a == 0)
         {
            _loc5_ = new TalkBubble(param2,param1,param3);
            _loc5_.x = param1.x;
            _loc5_.y = param1.y - 35;
            this.starlingStage.c_mc.addChildAt(_loc5_,param1.parent.getChildIndex(param1) + 1);
            TweenMax.from(_loc5_,0.2,{
               "scaleX":0.1,
               "scaleY":0.1,
               "ease":Back.easeOut
            });
            _loc5_.connectedTalk_txt.x = param1.y;
            _loc5_.connectedTalk_txt.y = param1.y - 35;
            _loc5_.touchable = param1.npc;
            this.starlingStage.c_mc.addChild(_loc5_.connectedTalk_txt);
            if(param1.npc == false)
            {
               TweenMax.to(_loc5_,0,{
                  "delay":param2.length / 8 + 2.9,
                  "onComplete":_loc5_.removeFromParent,
                  "onCompleteParams":[true]
               });
            }
         }
      }
      
      public function createWaterBubble(param1:int, param2:int, param3:starling.display.DisplayObject = null) : void
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:WaterBubble = null;
         _loc4_ = 0;
         _loc5_ = null;
         _loc6_ = null;
         if(AreaCreator.background1.parent != null)
         {
            _loc4_ = param3 == null ? int(this.starlingStage.c_mc.getChildIndex(this.player) + 1) : int(this.starlingStage.c_mc.getChildIndex(param3) + 1);
            if(Stats.levelStats[this.c_mc.currentFrame].waterTint != "")
            {
               _loc5_ = Stats.levelStats[this.c_mc.currentFrame].waterTint;
            }
            _loc6_ = new WaterBubble(_loc5_);
            _loc6_.x = param1;
            _loc6_.y = param2;
            this.waterBubble_array.push(_loc6_);
            this.starlingStage.c_mc.addChildAt(_loc6_,_loc4_);
            _loc6_.zeroBounds = _loc6_.getBounds(this.starlingStage.c_mc);
         }
      }
      
      public function createSmoke(param1:int, param2:int) : Smoke
      {
         var _loc3_:Smoke = null;
         _loc3_ = null;
         if(this.smoke_array.length < 30)
         {
            _loc3_ = new Smoke();
            _loc3_.scaleX = _loc3_.scaleY = 0.25;
            _loc3_.x = param1 - _loc3_.width / 2;
            _loc3_.y = param2 - _loc3_.height / 2;
            this.smoke_array.push(_loc3_);
            SortDepths.addAt(_loc3_,SortDepths.REGION_4);
            return _loc3_;
         }
         return null;
      }
      
      private function createMagicEffect(param1:Rectangle) : void
      {
         var _loc2_:MagicEffect = null;
         _loc2_ = null;
         _loc2_ = new MagicEffect(param1,3);
         _loc2_.x = param1.x;
         _loc2_.y = param1.y;
         this.magicEffect_array.push(_loc2_);
         SortDepths.addAt(_loc2_,SortDepths.REGION_4);
         SoundManager.playSound(SoundLibrary.magic_sound,_loc2_.x,_loc2_.y,true,this.starlingStage.c_mc);
      }
      
      public function createSplash(param1:int, param2:int) : void
      {
         var _loc3_:starling.display.MovieClip = null;
         var _loc4_:LightStyle = null;
         _loc3_ = null;
         _loc4_ = null;
         _loc3_ = new starling.display.MovieClip(Assets.treesFish_textureAtlas.getTextures("splash_"),30);
         _loc3_.x = param1;
         _loc3_.y = param2;
         _loc3_.pivotX = 54;
         _loc3_.pivotY = 71;
         _loc3_.textureSmoothing = TextureSmoothing.NONE;
         _loc3_.touchable = false;
         _loc3_.loop = false;
         SortDepths.addAt(_loc3_,SortDepths.REGION_2);
         this.main_juggler.add(_loc3_);
         this.animation_array.push(_loc3_);
         if(Stats.levelStats[this.c_mc.currentFrame].waterTint != 0)
         {
            SetHue.setStarlingObjectHue(_loc3_,Stats.levelStats[this.c_mc.currentFrame].waterTintInt);
         }
         if(GameMain.lighting)
         {
            _loc4_ = new LightStyle(Assets.treeFishLighMap_textureAtlas.getTexture("splash_"));
            _loc4_.ambientRatio = 0.3;
            _loc4_.diffuseRatio = 0.7;
            _loc4_.specularRatio = 0.6;
            _loc4_.shininess = 17;
            _loc4_.textureSmoothing = TextureSmoothing.NONE;
            _loc3_.style = _loc4_;
         }
      }
      
      private function createExplosion(param1:int, param2:int, param3:String) : void
      {
         var _loc4_:Point = null;
         var _loc5_:Explosion = null;
         _loc4_ = null;
         _loc5_ = null;
         var _loc6_:Shockwave = null;
         _loc4_ = new Point(param1,param2);
         _loc4_ = this.starlingStage.c_mc.localToGlobal(_loc4_);
         if(stage.quality == StageQuality.HIGH.toUpperCase() && Boolean(CommonCalls.onScreen(param1,param2,false,true)))
         {
            _loc6_ = new Shockwave(_loc4_.x,_loc4_.y,this.starlingStage.c_mc,25);
         }
         _loc5_ = new Explosion(param3,this);
         _loc5_.x = param1;
         _loc5_.y = param2;
         Explosion.explosion_array.push(_loc5_);
         this.main_juggler.add(_loc5_);
         SortDepths.addAt(_loc5_,SortDepths.REGION_4);
         SoundManager.playSound(SoundLibrary.explosion_sound,param1,param2,true,this.starlingStage.c_mc);
      }
      
      private function createVendor(param1:String, param2:String, param3:int, param4:int, param5:Vector.<String>, param6:Vector.<uint>, param7:uint, param8:uint) : VendingMachine
      {
         var _loc9_:VendingMachine = null;
         _loc9_ = null;
         _loc9_ = new VendingMachine(param2,param1,param5,param6,param7,param8);
         _loc9_.x = param3;
         _loc9_.y = param4;
         SortDepths.addAt(_loc9_,SortDepths.REGION_4,SortDepths.REGION_4B);
         return _loc9_;
      }
      
      private function createPetVendor(param1:String, param2:String, param3:int, param4:int, param5:String = "") : void
      {
         var _loc6_:int = 0;
         _loc6_ = 0;
         this.petVendor = new PetVendor(param2,param1,param5);
         this.petVendor.x = param3;
         this.petVendor.y = param4 - 20;
         _loc6_ = Math.min(SortDepths.getLowestChildIndex(Vector.<starling.display.DisplayObject>(this.e_array)),SortDepths.getLowestChildIndex(Vector.<starling.display.DisplayObject>(this.p_array)));
         if(_loc6_ == int.MAX_VALUE)
         {
            this.starlingStage.c_mc.addChild(this.petVendor);
         }
         else
         {
            this.starlingStage.c_mc.addChildAt(this.petVendor,_loc6_);
         }
      }
      
      public function createWhite(param1:Number = 0.2, param2:Number = 1) : void
      {
         var _loc3_:Image = null;
         _loc3_ = null;
         _loc3_ = new Image(Texture.fromBitmapData(new BitmapData(this.mainStarling.viewPort.width,this.mainStarling.viewPort.height,false,16777215)));
         _loc3_.alpha = param2;
         this.starlingStage.addChild(_loc3_);
         TweenMax.to(_loc3_,1,{
            "alpha":0,
            "delay":param1,
            "ease":Linear.easeNone,
            "onComplete":CommonCalls.removeAndFullyDispose,
            "onCompleteParams":[_loc3_]
         });
      }
      
      private function createBlack() : void
      {
         var _loc1_:Image = null;
         _loc1_ = null;
         _loc1_ = new Image(Texture.fromBitmapData(new BitmapData(this.mainStarling.viewPort.width,this.mainStarling.viewPort.height,false,0)));
         this.starlingStage.addChild(_loc1_);
         TweenMax.to(_loc1_,1,{
            "alpha":0,
            "ease":Linear.easeNone,
            "onComplete":CommonCalls.removeAndFullyDispose,
            "onCompleteParams":[_loc1_]
         });
      }
      
      private function createRed() : void
      {
         var _loc1_:Bitmap = null;
         _loc1_ = null;
         _loc1_ = new Bitmap(new BitmapData(this.mainStarling.viewPort.width,this.mainStarling.viewPort.height,false,13369344));
         addChild(_loc1_);
         TweenMax.to(_loc1_,0.6,{
            "alpha":0,
            "delay":0.8,
            "ease":Linear.easeNone,
            "onComplete":CommonCalls.removeObject,
            "onCompleteParams":[_loc1_]
         });
      }
      
      public function createTransition() : void
      {
         this.createWhite(0.6);
      }
      
      private function createTalkBox(param1:int, param2:Person, param3:String, param4:Boolean = true, param5:Boolean = false, param6:Boolean = false) : void
      {
         if((this.talkBox == null || this.talkBox.parent == null) && (this.tradeMenu == null || this.tradeMenu.parent == null) || (this.talkBox == null || this.talkBox.parent == null))
         {
            if(param2 == null)
            {
               return;
            }
            this.talkBox = new TalkBox(this,param3,param1,param2,param4,param5,param6);
            this.talkBox.x = Starling.current.viewPort.width / Starling.contentScaleFactor / 2;
            this.talkBox.y = Starling.current.viewPort.height / Starling.contentScaleFactor / 2 - 50;
            this.starlingStage.addChild(this.talkBox);
         }
      }
      
      public function createItemMenu(param1:String, param2:Vector.<String>, param3:String = "", param4:String = "") : void
      {
         if(StarlingGameMenu.menu_array.indexOf(this.tradeMenu) == -1 && StarlingGameMenu.menu_array.indexOf(this.itemMenu) == -1)
         {
            this.itemMenu = new ItemMenu(param1,param3,param4,this.starlingStage.c_mc,this.player.name);
            this.itemMenu.x = Starling.current.viewPort.width / Starling.contentScaleFactor / 2;
            this.itemMenu.y = Starling.current.viewPort.height / Starling.contentScaleFactor / 2 - 50;
            this.starlingStage.addChild(this.itemMenu);
            this.itemMenu.updateMe(this.maxItems,param2,this.player,true);
         }
         if(this.confirmMenu != null && this.confirmMenu.parent != null)
         {
            this.confirmMenu.removeFromParent(true);
         }
         if(this.mapMenu != null && this.mapMenu.parent != null)
         {
            StarlingGameMenu.focusMenu(this.mapMenu);
            StarlingGameMenu.removeFocusMenu();
         }
      }
      
      private function createCraftingMenu(param1:Vector.<String>) : void
      {
         if(StarlingGameMenu.menu_array.indexOf(this.craftingMenu) == -1)
         {
            this.craftingMenu = new CraftingMenu(param1);
            this.craftingMenu.x = 400;
            this.craftingMenu.y = 280;
            this.starlingStage.addChild(this.craftingMenu);
         }
      }
      
      public function createEnergyMenu() : void
      {
         if(StarlingGameMenu.menu_array.indexOf(this.energyMenu) == -1)
         {
            this.energyMenu = new EnergyMenu(this.player);
            this.energyMenu.x = 450;
            this.energyMenu.y = 260;
            this.starlingStage.addChild(this.energyMenu);
         }
      }
      
      public function createRankMenu() : void
      {
         this.rankMenu = new RankMenu(this.player,this.enemyList_array,this.fishList_array,this.theConnection);
         addChild(this.rankMenu);
         this.theConnection.send("getRanks");
         this.theConnection.addMessageHandler("ranksGot",this.rankMenu.ranksGot);
      }
      
      public function createMissionMenu() : void
      {
         this.missionMenu = new MissionMenu();
         this.missionMenu.x = Starling.current.viewPort.width / Starling.contentScaleFactor / 2;
         this.missionMenu.y = Starling.current.viewPort.height / Starling.contentScaleFactor / 2 - 50;
         this.starlingStage.addChild(this.missionMenu);
      }
      
      private function createCreateMenu() : void
      {
         var n_createMenu:Function = function():void
         {
            charCreateMenu = new CreateMenu(GameMain(root));
            charCreateMenu.x = Starling.current.viewPort.width / Starling.contentScaleFactor / 2;
            charCreateMenu.y = Starling.current.viewPort.height / Starling.contentScaleFactor / 2;
            charCreateMenu.name_txt.text = "";
            if(Starling.contentScaleFactor >= 2 || 950 > Starling.current.viewPort.width || 700 > Starling.current.viewPort.height)
            {
               charCreateMenu.scale = 0.7;
            }
            starlingStage.addChild(charCreateMenu);
         };
         if(CreateMenu.charCreateMenu_textureAtlas == null)
         {
            Assets.main_assetManager.textureFormat = Context3DTextureFormat.BGRA_PACKED;
            Assets.main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/char create menu.png");
            Assets.main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/char create menu.xml");
            Assets.main_assetManager.loadQueue(function(param1:Number):void
            {
               if(param1 == 1)
               {
                  CreateMenu.charCreateMenu_textureAtlas = Assets.main_assetManager.getTextureAtlas("char create menu");
                  n_createMenu();
               }
            });
         }
         else
         {
            n_createMenu();
         }
      }
      
      private function createMissionAni(param1:String) : void
      {
         var newMissionAni:NewMissionAnimation = null;
         var tempStartedMissions_array:Array = null;
         var _missionName:String = param1;
         newMissionAni = null;
         tempStartedMissions_array = null;
         if(Stats.missionStats[_missionName].started == false)
         {
            SoundManager.playSound(SoundLibrary.newMission_sound);
            newMissionAni = new NewMissionAnimation();
            newMissionAni.x = 475;
            newMissionAni.y = 168;
            newMissionAni.mission_txt.text = _missionName;
            newMissionAni.mission = _missionName;
            addChild(newMissionAni);
            newMissionAni.addEventListener(flash.events.Event.ENTER_FRAME,this.onMissionAniEnter);
            Stats.missionStats[_missionName].started = true;
            this.starlingStage.controls.blinkMissionButton = true;
            this.theConnection.send("qStart",_missionName);
            tempStartedMissions_array = new Array();
            this.i = 0;
            while(this.i < Stats.missionList.length)
            {
               if(Stats.missionStats[Stats.missionList[this.i]].started)
               {
                  tempStartedMissions_array.push(Stats.missionList[this.i]);
               }
               ++this.i;
            }
            this.theClient.bigDB.load("pMiscTable",this.player.name,function(param1:DatabaseObject):*
            {
               if(param1 != null && Boolean(loadedPlayerMiscSuccess))
               {
                  param1.startedQuests = tempStartedMissions_array.toString();
                  param1.save();
               }
            });
         }
      }
      
      public function createMissionCompleteAni(param1:String) : void
      {
         var missionCompleteAni:MissionCompleteAnimation = null;
         var tempCompletedMissions_array:Array = null;
         var _missionName:String = param1;
         missionCompleteAni = null;
         tempCompletedMissions_array = null;
         if(Stats.missionStats[_missionName].completed == false)
         {
            SoundManager.playSound(SoundLibrary.newMission_sound);
            missionCompleteAni = new MissionCompleteAnimation();
            missionCompleteAni.x = 475;
            missionCompleteAni.y = 168;
            missionCompleteAni.mission_txt.text = _missionName;
            missionCompleteAni.mission = _missionName;
            addChild(missionCompleteAni);
            missionCompleteAni.addEventListener(flash.events.Event.ENTER_FRAME,this.onMissionAniEnter);
            Stats.missionStats[_missionName].completed = true;
            this.starlingStage.controls.blinkMissionButton = true;
            tempCompletedMissions_array = new Array();
            this.i = 0;
            while(this.i < Stats.missionList.length)
            {
               if(Stats.missionStats[Stats.missionList[this.i]].completed)
               {
                  tempCompletedMissions_array.push(Stats.missionList[this.i]);
               }
               ++this.i;
            }
            this.theClient.bigDB.load("pMiscTable",this.player.name,function(param1:DatabaseObject):*
            {
               if(param1 != null && Boolean(loadedPlayerMiscSuccess))
               {
                  param1.completedQuests = tempCompletedMissions_array.toString();
                  param1.save();
               }
            });
            this.theConnection.send("qComplete",_missionName,Stats.missionStats[_missionName].worth);
            this.player.currentLevelXP = this.player.currentLevelXP + Stats.missionStats[_missionName].worth;
            this.createXPText(Stats.missionStats[_missionName].worth,this.player.x,this.player.y);
            if(this.player.currentLevelXP >= int(this.player.lev * (this.player.lev * 1.1 + 50)))
            {
               this.player.levelMeUp();
               this.starlingStage.controls.blinkCharacterButton = true;
            }
         }
      }
      
      private function createLoadScreen() : void
      {
         if(this.loadScreen == null || this.loadScreen.parent == null)
         {
            this.loadScreen = new LoadScreen(this);
            this.starlingStage.addChild(this.loadScreen);
            TweenMax.from(this.loadScreen,0.5,{
               "alpha":0,
               "ease":Linear.easeNone
            });
         }
      }
      
      private function createTutorial() : void
      {
         this.tutorial = new Tutorial();
         this.tutorial.x = 950 / 2;
         this.tutorial.y = 700 / 2;
         addChild(this.tutorial);
         TweenMax.from(this.tutorial,1,{
            "alpha":0,
            "ease":Linear.easeNone
         });
      }
      
      private function dismissTutorial() : void
      {
         if(this.tutorial != null)
         {
            if(this.tutorial.parent != null)
            {
               this.tutorial.parent.removeChild(this.tutorial);
            }
            this.tutorial = null;
         }
         this.allowDamage = true;
         stage.focus = null;
      }
      
      public function createCMenu(param1:Person) : void
      {
         var _loc2_:StarlingGameMenu = null;
         _loc2_ = null;
         for each(var _loc5_ in StarlingGameMenu.menu_array)
         {
            _loc2_ = _loc5_;
            _loc5_;
            if(_loc2_ is CharacterMenu)
            {
               StarlingGameMenu.focusMenu(_loc2_);
               StarlingGameMenu.removeFocusMenu();
            }
         }
         this.cMenu = new CharacterMenu(param1);
         this.cMenu.x = Starling.current.viewPort.width / Starling.contentScaleFactor / 2 + 200;
         this.cMenu.y = Starling.current.viewPort.height / Starling.contentScaleFactor / 2 + 100;
         this.starlingStage.addChild(this.cMenu);
         this.cMenu.updateMe();
      }
      
      private function createDeadMenu(param1:Boolean = false) : void
      {
         this.deadMenu = new DeadMenu();
         this.deadMenu.x = Starling.current.viewPort.width / 2;
         this.deadMenu.y = Starling.current.viewPort.height / 2;
         this.deadMenu.scaleX = this.deadMenu.scaleY = Starling.contentScaleFactor;
         addChild(this.deadMenu);
         TweenMax.from(this.deadMenu,1,{
            "alpha":0,
            "ease":Linear.easeNone
         });
         if(param1 == false)
         {
            if(this.c_mc.currentFrame != 112 && this.c_mc.currentFrame != 113 && this.c_mc.currentFrame != 114)
            {
               this.deadMenu.death_txt.text = "You have lost " + (this.player.bodyAnimator.hasHalo == false ? "half" : "15%") + " of your money and will be taken back to the closest shelter.";
            }
            else if(this.c_mc.currentFrame == 113)
            {
               this.deadMenu.death_txt.text = "You have been slain by another player and have lost " + (this.player.bodyAnimator.hasHalo == false ? "half" : "15%") + " of your money. You will be taken back to shelter.";
            }
            else if(this.c_mc.currentFrame == 113 || this.c_mc.currentFrame == 114)
            {
               this.deadMenu.death_txt.text = "You have been defeated by another player.  No money has been lost. You will be taken back to shelter.";
            }
         }
         else
         {
            this.deadMenu.death_txt.text = "You have not lost any money from falling off the map.  You will be taken back to the closest shelter.";
         }
         if(this.talkBox != null && this.talkBox.parent != null)
         {
            this.talkBox.removeFromParent(true);
         }
         StarlingGameMenu.removeAllMenus(false,Vector.<StarlingGameMenu>([this.pmMenu]));
      }
      
      public function createLogOnMenu(param1:String, param2:String = " has logged on") : LogOnMenu
      {
         var _loc3_:LogOnMenu = null;
         if(this.lastLogOnName == param1 && getTimer() - this.lastLogOnTime < 15000)
         {
            return null;
         }
         this.lastLogOnName = param1;
         this.lastLogOnTime = getTimer();
         _loc3_ = null;
         this.t = 0;
         this.len2 = numChildren;
         this.j = 0;
         while(this.j < this.len2)
         {
            if(getChildAt(this.j) is LogOnMenu)
            {
               ++this.j;
            }
            ++this.j;
         }
         _loc3_ = new LogOnMenu();
         _loc3_.x = this.mainStarling.viewPort.width - 105;
         _loc3_.y = 120 + (this.t * _loc3_.height + 10);
         _loc3_.mouseChildren = false;
         _loc3_.mouseEnabled = false;
         _loc3_.logOn_txt.text = param1 + param2;
         addChild(_loc3_);
         TweenMax.from(_loc3_,0.6,{
            "x":this.mainStarling.viewPort.width + 150,
            "ease":Back.easeOut
         });
         TweenMax.to(_loc3_,0.7,{
            "x":this.mainStarling.viewPort.width + 150,
            "delay":1.5,
            "ease":Linear.easeNone,
            "onComplete":CommonCalls.removeObject,
            "onCompleteParams":[_loc3_]
         });
         if(param2 == " has logged on")
         {
            SoundManager.playSound(SoundLibrary.newSignOn_sound);
         }
         return _loc3_;
      }
      
      private function createMembersInAreaMenu(param1:int) : void
      {
         this.membersInAreaMenu = new MembersInAreaMenu();
         this.membersInAreaMenu.x = 106;
         this.membersInAreaMenu.y = 230;
         this.membersInAreaMenu.members_txt.text = String(param1) + " guild " + (this.a == 1 ? "member" : "members") + " present";
         addChild(this.membersInAreaMenu);
         TweenMax.from(this.membersInAreaMenu,0.6,{
            "x":-75,
            "ease":Back.easeOut
         });
      }
      
      private function createTradeRequest(param1:Person) : void
      {
         this.tradeRequest = new TradeRequest();
         this.tradeRequest.x = Starling.current.viewPort.width / Starling.contentScaleFactor / 2;
         this.tradeRequest.y = 65;
         this.tradeRequest.scaleX = this.tradeRequest.scaleY = Starling.contentScaleFactor;
         this.tradeRequest.traderName = param1.name;
         this.tradeRequest.trade_txt.text = param1.name + " would like to trade";
         addChild(this.tradeRequest);
         TweenMax.from(this.tradeRequest,0.5,{
            "scaleX":0.1,
            "scaleY":0.1,
            "alpha":0,
            "ease":Back.easeOut
         });
         TweenMax.from(this.tradeRequest.acceptTrade_btn,0.3,{
            "scaleX":0.1,
            "scaleY":0.1,
            "alpha":0,
            "delay":0.6,
            "ease":Back.easeOut
         });
         TweenMax.from(this.tradeRequest.declineTrade_btn,0.3,{
            "scaleX":0.1,
            "scaleY":0.1,
            "alpha":0,
            "delay":0.8,
            "ease":Back.easeOut
         });
         SoundManager.playSound(SoundLibrary.tradeRequest_sound);
      }
      
      private function createNewHeroEntry(param1:String) : void
      {
         var _loc2_:HeroEntry = null;
         _loc2_ = null;
         _loc2_ = new HeroEntry();
         _loc2_.x = this.starlingStage.controls.heropedia_btn.x;
         _loc2_.y = 83;
         _loc2_.entry_txt.text = param1;
         addChild(_loc2_);
         TweenMax.from(_loc2_,0.6,{
            "y":_loc2_.y - 150,
            "ease":Back.easeOut,
            "onComplete":this.tweenOut,
            "onCompleteParams":[_loc2_]
         });
         TweenMax.from(_loc2_.entry_txt,0.4,{
            "y":_loc2_.entry_txt.y - 50,
            "ease":Back.easeOut
         });
         SoundManager.playSound(SoundLibrary.newEntry_sound);
      }
      
      public function createInfoMenu(param1:String, param2:String = "small") : void
      {
         if(this.infoMenu == null || this.infoMenu.parent == null)
         {
            this.infoMenu = new InfoMenu();
            this.infoMenu.x = mouseX;
            this.infoMenu.y = mouseY;
            this.infoMenu.gotoAndStop(param2);
            this.infoMenu.mouseChildren = this.infoMenu.mouseEnabled = false;
            this.infoMenu.info_txt.text = param1;
            addChild(this.infoMenu);
         }
         else
         {
            this.infoMenu.x = mouseX;
            this.infoMenu.y = mouseY;
            this.infoMenu.gotoAndStop(param2);
            this.infoMenu.info_txt.text = param1;
         }
      }
      
      public function checkCreatePMMenu(param1:String, param2:Boolean) : void
      {
         if(this.pmMenu == null || this.pmMenu.parent == null)
         {
            this.pmMenu = new PMMenu();
            this.pmMenu.x = 797 / Starling.contentScaleFactor;
            this.pmMenu.y = 143;
            this.starlingStage.addChild(this.pmMenu);
            this.pmMenu.addChatUser(param1,true);
         }
         else
         {
            this.pmMenu.addChatUser(param1,param2);
            StarlingGameMenu.focusMenu(this.pmMenu);
         }
      }
      
      private function createConnectMenu(param1:int = 1) : void
      {
         this.connectMenu = new ConnectMenu();
         this.connectMenu.x = 475;
         this.connectMenu.y = 350;
         this.connectMenu.gotoAndStop(param1);
         if(currentFrame == 3 && param1 == 1)
         {
            this.connectMenu.reason_txt.text = "reason: " + this.disconnectReason;
         }
         else if(param1 == 2)
         {
            this.connectMenu.reason_txt.text = "Client Version: " + this.starlingStage.controls.version_txt.text + "\nServerVersion: " + String(this.serverVersion);
         }
         addChild(this.connectMenu);
      }
      
      public function createUpdateMenu(param1:String = "updates") : void
      {
         this.updateMenu = new UpdateMenu();
         this.updateMenu.x = 413;
         this.updateMenu.y = 334;
         if(Starling.contentScaleFactor > 1)
         {
            this.updateMenu.scaleX = this.updateMenu.scaleY = 1.5;
            this.updateMenu.x = this.updateMenu.x + 200;
            this.updateMenu.y = this.updateMenu.y + 200;
         }
         this.updateMenu.gotoAndStop(param1);
         addChild(this.updateMenu);
         TweenMax.from(this.updateMenu,0.5,{
            "scaleX":0.1,
            "scaleY":0.1,
            "alpha":0,
            "ease":Back.easeOut
         });
         if(this.updateMenu.currentLabel == "terms")
         {
            this.updateMenu.agreement_scrollBar.scrollTarget = this.updateMenu.agreement_txt;
         }
      }
      
      public function createDebugMenu(param1:int = 23, param2:int = 150) : void
      {
         this.debugMenu = new DebugMenu();
         this.debugMenu.x = param1;
         this.debugMenu.y = param2;
         this.debugMenu.scaleX = this.debugMenu.scaleY = Starling.contentScaleFactor;
         addChild(this.debugMenu);
      }
      
      public function createOptionMenu() : void
      {
         this.optionMenu = new OptionMenu();
         this.optionMenu.x = Starling.current.viewPort.width / Starling.contentScaleFactor / 2;
         this.optionMenu.y = Starling.current.viewPort.height / Starling.contentScaleFactor / 2 - 75;
         this.starlingStage.addChild(this.optionMenu);
         this.optionMenu.updateMe(stage,AreaCreator.background1,this.save_sharedObject,this.controllerMain);
      }
      
      public function createMapMenu() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         _loc1_ = undefined;
         _loc2_ = 0;
         _loc1_ = this.serverNames_array.indexOf(this.serverName);
         _loc2_ = _loc1_ > -1 && _loc1_ < this.serverPops_array.length ? int(this.serverPops_array[_loc1_]) : 0;
         this.mapMenu = new MapMenu(this.hasFishRadar,this.c_mc.currentFrame,this.totalGamePlayers,this.serverName,_loc2_,FriendMenu.friendsInfo_array,this.unlockedMaps_array);
         this.mapMenu.x = Starling.current.viewPort.width / Starling.contentScaleFactor - 20 - 529;
         this.mapMenu.y = 40 + 173;
         this.starlingStage.addChild(this.mapMenu);
      }
      
      public function createFriendMenu() : void
      {
         this.friendMenu = new FriendMenu(this);
         this.friendMenu.x = Starling.current.viewPort.width / Starling.contentScaleFactor / 2 + 75;
         this.friendMenu.y = Starling.current.viewPort.height / Starling.contentScaleFactor / 2 - 25;
         this.starlingStage.addChild(this.friendMenu);
         this.friendMenu.updateMe(this.theClient,FriendMenu.FRIENDS);
      }
      
      private function createTradeMenu(param1:Person) : void
      {
         if(this.deadMenu != null && this.deadMenu.parent != null)
         {
            return;
         }
         this.lastTradeCounter = 0;
         this.tradeMenu = new TradeMenu(this.player,param1,this.player.tickets,this.personItem_array,this.maxItems);
         this.tradeMenu.x = 450;
         this.tradeMenu.y = 242;
         this.starlingStage.addChild(this.tradeMenu);
         if(this.tradeMenu.width > Starling.current.viewPort.width || this.tradeMenu.height > Starling.current.viewPort.height)
         {
            this.tradeMenu.scale = 0.7;
            this.tradeMenu.x = 325;
            this.tradeMenu.y = 164;
         }
         this.loadPVPurchases();
         this.theConnection.addMessageHandler("giTradeOffer",this.tradeMenu.newTradeOffer);
         this.theConnection.addMessageHandler("giTConfirm",this.tradeMenu.showOConfirmed);
         this.theConnection.addMessageHandler("giTMessage",this.newTradeMessage);
         this.theConnection.addMessageHandler("giTVerify",this.tradeVerified);
         this.theConnection.addMessageHandler("giTClosed",this.tradeClosed);
         this.theConnection.addMessageHandler("giPetOffer",this.tradeMenu.newPetOffer);
         this.theConnection.addMessageHandler("giPetWithdraw",this.tradeMenu.newPetWithdraw);
         this.theConnection.addMessageHandler("giTicketOffer",this.tradeMenu.newTicketOffer);
         this.theConnection.addMessageHandler("tradeLock",this.tradeMenu.tradeLocked);
         this.theConnection.addMessageHandler("finalTConfirm",this.finalTradeConfirmed);
         if(this.mMenu != null && this.mMenu.parent != null)
         {
            removeChild(this.mMenu);
         }
         if(this.confirmMenu != null && this.confirmMenu.parent != null)
         {
            this.confirmMenu.removeFromParent(true);
         }
         if(this.talkBox != null && this.talkBox.parent != null)
         {
            this.talkBox.removeFromParent(true);
         }
         if(this.deadMenu != null && this.deadMenu.parent != null)
         {
            this.deadMenu.removeFromParent(true);
         }
         this.theClient.bigDB.loadRange("PayVaultItems","costIndex",null,0,int.MAX_VALUE,80,this.payvaultItemsLoaded);
      }
      
      public function createPVMenu() : void
      {
         this.pvMenu = new PayVaultMenu(this);
         this.pvMenu.x = 119 + Starling.contentScaleFactor * 250;
         this.pvMenu.y = 21 + Starling.contentScaleFactor * 250;
         addChild(this.pvMenu);
         this.hidePrivateServerTile();
         TweenMax.delayedCall(0.3,this.hidePrivateServerTile);
         TweenMax.delayedCall(1,this.hidePrivateServerTile);
         this.updatePVMenu();
      }
      
      private function mcHasChildNamed(param1:flash.display.DisplayObjectContainer, param2:String) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:flash.display.DisplayObject = null;
         _loc3_ = 0;
         _loc4_ = null;
         _loc3_ = 0;
         while(_loc3_ < param1.numChildren)
         {
            _loc4_ = param1.getChildAt(_loc3_);
            if(_loc4_ != null)
            {
               if(_loc4_.name == param2)
               {
                  return true;
               }
               if(_loc4_ is flash.display.DisplayObjectContainer && Boolean(this.mcHasChildNamed(_loc4_ as flash.display.DisplayObjectContainer,param2)))
               {
                  return true;
               }
            }
            _loc3_++;
         }
         return false;
      }
      
      private function findChildNamed(param1:flash.display.DisplayObjectContainer, param2:String) : flash.display.DisplayObject
      {
         var _loc3_:int = 0;
         var _loc4_:flash.display.DisplayObject = null;
         var _loc5_:flash.display.DisplayObject = null;
         _loc3_ = 0;
         _loc4_ = null;
         _loc5_ = null;
         _loc3_ = 0;
         while(_loc3_ < param1.numChildren)
         {
            _loc4_ = param1.getChildAt(_loc3_);
            if(_loc4_ != null)
            {
               if(_loc4_.name == param2)
               {
                  return _loc4_;
               }
               if(_loc4_ is flash.display.DisplayObjectContainer)
               {
                  _loc5_ = this.findChildNamed(_loc4_ as flash.display.DisplayObjectContainer,param2);
                  if(_loc5_ != null)
                  {
                     return _loc5_;
                  }
               }
            }
            _loc3_++;
         }
         return null;
      }
      
      private function hidePrivateServerTile() : void
      {
         var _loc1_:flash.display.DisplayObjectContainer = null;
         var _loc2_:flash.display.DisplayObject = null;
         try
         {
            if(this.pvMenu == null || this.pvMenu.list_mc == null)
            {
               return;
            }
            _loc1_ = this.pvMenu.list_mc;
            if(this.pvMenu.getChildByName("buyPrivateServer_btn") != null)
            {
               this.pvMenu.getChildByName("buyPrivateServer_btn").visible = false;
            }
            _loc2_ = this.findChildNamed(_loc1_,"privateServerSetUp_btn");
            if(_loc2_ != null)
            {
               _loc2_.visible = false;
            }
         }
         catch(__psErr:Error)
         {
         }
      }
      
      public function createHeroMenu() : void
      {
         this.heroMenu = new HeropediaMenu(this.enemyList_array,this.fishList_array);
         this.heroMenu.x = Starling.current.viewPort.width / Starling.contentScaleFactor / 2 - 75;
         this.heroMenu.y = Starling.current.viewPort.height / Starling.contentScaleFactor / 2 - 50;
         this.starlingStage.addChild(this.heroMenu);
      }
      
      private function createGuildMenu() : void
      {
         this.guildMenu = new GuildMenu();
         this.guildMenu.gotoAndStop("sort");
         addChild(this.guildMenu);
      }
      
      private function createGuildMemberMenu(param1:String, param2:String = "members") : void
      {
         this.guildMemberMenu = new GuildMemberMenu(this,param1,param2);
         this.guildMemberMenu.x = 520;
         this.guildMemberMenu.y = 330;
         this.guildMemberMenu.updateMe();
         this.starlingStage.addChild(this.guildMemberMenu);
      }
      
      public function createConfirmMenu(param1:String, param2:String) : void
      {
         if(this.confirmMenu == null || this.confirmMenu.parent == null)
         {
            this.confirmMenu = new ConfirmMenu(param1,param2);
            this.confirmMenu.x = this.mainStarling.viewPort.width / Starling.contentScaleFactor / 2;
            this.confirmMenu.y = this.mainStarling.viewPort.height / Starling.contentScaleFactor / 2;
            this.starlingStage.addChild(this.confirmMenu);
            TweenMax.from(this.confirmMenu,0.4,{
               "scaleX":4,
               "scaleY":4,
               "alpha":0,
               "ease":Back.easeOut
            });
         }
      }
      
      public function createBankMenu() : void
      {
         this.bankMenu = new BankMenu(this.player.money,this.hasItemStorage,this);
         this.bankMenu.x = 430;
         this.bankMenu.y = 265;
         this.starlingStage.addChild(this.bankMenu);
         this.bankMenu.updateMe();
         this.theClient.bigDB.load("bankData",this.player.name,this.bankMenu.bankInfoLoadedOrCreated);
      }
      
      public function createSkillsMenu() : void
      {
         this.skillsMenu = new SkillsMenu(this.theClient);
         this.skillsMenu.x = 450;
         this.skillsMenu.y = 230;
         this.starlingStage.addChild(this.skillsMenu);
         this.skillsMenu.displaySkills("basic");
      }
      
      public function createPetConfirmMenu(param1:String) : void
      {
         this.petConfirmMenu = new PetConfirmMenu(param1,this);
         this.petConfirmMenu.x = 400;
         this.petConfirmMenu.y = 270;
         this.starlingStage.addChild(this.petConfirmMenu);
      }
      
      private function createAlertMenu(param1:String, param2:String, param3:Boolean, param4:Pet, param5:Boolean) : void
      {
         var _loc6_:Boolean = false;
         _loc6_ = false;
         _loc6_ = new Boolean(this.alertMenu != null && this.alertMenu.parent != null);
         this.alertMenu = new AlertMenu(param1,param2,param4,this,param5);
         this.alertMenu.x = this.mainStarling.viewPort.width - 109;
         this.alertMenu.y = 127 + (_loc6_ ? this.alertMenu.height : 0);
         this.starlingStage.addChild(this.alertMenu);
         TweenMax.from(this.alertMenu,0.5,{
            "x":this.mainStarling.viewPort.width + 120,
            "ease":Linear.easeOut
         });
         if(param3 == false)
         {
            TweenMax.to(this.alertMenu,0.5,{
               "x":this.mainStarling.viewPort.width + 120,
               "ease":Back.easeOut,
               "delay":10,
               "onComplete":this.alertMenu.removeFromParent,
               "onCompleteParams":[true]
            });
         }
         SoundManager.playSound(SoundLibrary.alertMenu_sound);
      }
      
      private function createPetShopMenu(param1:Vector.<String>) : void
      {
         if(GameMenu.menu_array.indexOf(this.petShopMenu) == -1)
         {
            this.petShopMenu = new PetShopMenu(param1,this);
            this.petShopMenu.x = 460;
            this.petShopMenu.y = 270;
            this.starlingStage.addChild(this.petShopMenu);
         }
      }
      
      public function createPetModeMenu(param1:String, param2:String = "") : void
      {
         this.petModeMenu = new PetModeMenu(param1,param2,this.player,this.hasXPSplit);
         this.petModeMenu.x = 450;
         this.petModeMenu.y = 285;
         this.starlingStage.addChild(this.petModeMenu);
      }
      
      public function createPetItemMenu(param1:Pet) : void
      {
         if(StarlingGameMenu.menu_array.indexOf(this.itemMenu) > -1)
         {
            StarlingGameMenu.focusMenu(this.itemMenu);
            StarlingGameMenu.removeFocusMenu();
         }
         this.petItemMenu = new PetItemMenu(param1,this);
         this.petItemMenu.x = Starling.current.viewPort.width / Starling.contentScaleFactor / 2 + 40;
         this.petItemMenu.y = Starling.current.viewPort.height / Starling.contentScaleFactor / 2 + 60;
         this.starlingStage.addChild(this.petItemMenu);
         this.petItemMenu.updateMe(this.maxItems,this.personItem_array,this.player);
      }
      
      public function createPetMenu() : void
      {
         this.petMenu = new PetMenu(this.maxPets,this.player);
         this.petMenu.x = 475;
         this.petMenu.y = 325;
         this.starlingStage.addChild(this.petMenu);
         this.petMenu.updateMe();
      }
      
      public function createPetVendMenu(param1:Pet, param2:PetVendor) : void
      {
         this.petVendMenu = new PetVendMenu(param1,param2,this);
         this.petVendMenu.x = 325;
         this.petVendMenu.y = 350;
         this.starlingStage.addChild(this.petVendMenu);
      }
      
      public function createPresentMenu(param1:String) : void
      {
         this.presentMenu = new PresentMenu(this.player.tickets,param1);
         this.presentMenu.x = 450;
         this.presentMenu.y = 300;
         this.starlingStage.addChild(this.presentMenu);
         this.theClient.bigDB.loadRange("PayVaultItems","costIndex",null,0,int.MAX_VALUE,80,this.payvaultItemsLoaded);
      }
      
      public function createBullhornMenu() : void
      {
         this.bullhornMenu = new BullhornMenu();
         addChild(this.bullhornMenu);
      }
      
      private function createLotteryMenu() : void
      {
         this.lotteryMenu = new LotteryMenu(this.lotteryTicketJackpot,this.lotteryCoinJackpot * 0.65);
         this.lotteryMenu.x = this.lotteryMenu.x + 350;
         this.lotteryMenu.y = this.lotteryMenu.y + 300;
         this.starlingStage.addChild(this.lotteryMenu);
         this.lotteryMenu.updateMe(0,0,this.player.tickets,this.player.money);
      }
      
      public function createMMenu(param1:String = "main", param2:Boolean = true) : void
      {
         var _loc3_:String = null;
         var _loc4_:URLLoader = null;
         var _loc5_:LogOnMenu = null;
         _loc3_ = null;
         _loc4_ = null;
         _loc5_ = null;
         this.mMenu = new MainMenu(this);
         this.mMenu.x = Starling.current.viewPort.width / 2 - 50;
         this.mMenu.y = Starling.current.viewPort.height / 2;
         if(Starling.contentScaleFactor >= 2)
         {
            this.mMenu.scaleX = this.mMenu.scaleY = Starling.contentScaleFactor * 0.75;
         }
         this.mMenu.gotoAndStop(param1);
         this.mMenu.version_txt.text = this.starlingStage.controls.version_txt.text;
         this.mMenu.version_txt.mouseEnabled = false;
         addChild(this.mMenu);
         if(param1 == "main")
         {
            this.gotoMainMenuFrame(1);
         }
         else if(param1 == "servers")
         {
            this.gotoMainMenuFrame(6);
         }
         if(param2)
         {
            SoundManager.changeMusic(Assets.main_assetManager.getSound("main menu music"));
         }
         _loc3_ = isIOS ? "https" : "http";
         _loc4_ = new URLLoader(new URLRequest(_loc3_ + "://yuriifedorov01-cpu.github.io/hht-client/includes/getTotal.php?" + String(Math.random() * 999999)));
         _loc4_.dataFormat = URLLoaderDataFormat.VARIABLES;
         _loc4_.addEventListener(flash.events.Event.COMPLETE,this.totalOnlineLoaded);
         if(this.controllerMain != null)
         {
            _loc5_ = this.createLogOnMenu("controller detected","");
            SetHue.setObjectHue(_loc5_,140);
            SoundManager.playSound(SoundLibrary.controller_sound);
         }
         if(Capabilities.isDebugger == false && Capabilities.playerType == "Desktop" && this.counter == 0)
         {
            stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
         }
      }
      
      public function createFishListMenu() : void
      {
         this.fishListMenu = new FishListMenu();
         this.fishListMenu.x = 380;
         this.fishListMenu.y = 250;
         this.starlingStage.addChild(this.fishListMenu);
         this.theClient.bigDB.loadRange("shinyFishData","timeIndex",[],null,null,15,this.fishListMenu.shinyFishLoaded);
      }
      
      public function createRCMenu(param1:Vector.<String>, param2:Object = null) : void
      {
         this.rcMenu = new RightClickMenu(param1,param2);
         this.rcMenu.x = mouseX;
         this.rcMenu.y = mouseY;
         this.rcMenu.scaleX = this.rcMenu.scaleY = Starling.contentScaleFactor;
         addChild(this.rcMenu);
      }
      
      public function onPerson(param1:Person, param2:int, param3:Vector.<Person>) : void
      {
         var _loc4_:Smoke = null;
         var _loc5_:Smoke = null;
         _loc4_ = null;
         _loc5_ = null;
         ++param1.gravityObject.counter;
         if(param1.name != this.player.name)
         {
            param1.onEnter();
         }
         if(CommonCalls.onScreen(param1.x,param1.y,true,true))
         {
            if(param1.bodyAnimator.weaponString != "none" && (param1.gravityObject.counter % 11 == 0 && Stats.wStats[param1.bodyAnimator.weaponString].fireDamage > 0 || param1.gravityObject.counter % 35 == 0 && Stats.wStats[param1.bodyAnimator.weaponString].iceDamage > 0))
            {
               this.global2_point.x = param1.bodyAnimator.weaponLeft_sprite.x;
               this.global2_point.y = param1.bodyAnimator.weaponLeft_sprite.y;
               this.global2_point = param1.localToGlobal(this.global2_point);
               this.global2_point = this.c_mc.globalToLocal(this.global2_point);
               _loc4_ = this.createSmoke(this.global2_point.x - Math.random() * 15 * RanOne.ranOne(),this.global2_point.y);
               if(Stats.wStats[param1.bodyAnimator.weaponString].iceDamage > 0 && _loc4_ != null)
               {
                  _loc4_.scaleSpeed = _loc4_.scaleSpeed * 2;
                  _loc4_.fadeSpeed = _loc4_.fadeSpeed * 2;
               }
            }
            if(param1.bodyAnimator.weapon2String != "none" && (param1.gravityObject.counter % 14 == 0 && Stats.wStats[param1.bodyAnimator.weapon2String].fireDamage > 0 || param1.gravityObject.counter % 40 == 0 && Stats.wStats[param1.bodyAnimator.weapon2String].iceDamage > 0))
            {
               this.global2_point.x = param1.bodyAnimator.weaponRight_sprite.x;
               this.global2_point.y = param1.bodyAnimator.weaponRight_sprite.y;
               this.global2_point = param1.localToGlobal(this.global2_point);
               this.global2_point = this.c_mc.globalToLocal(this.global2_point);
               _loc5_ = this.createSmoke(this.global2_point.x - Math.random() * 15 * RanOne.ranOne(),this.global2_point.y);
               if(Stats.wStats[param1.bodyAnimator.weapon2String].iceDamage > 0)
               {
                  _loc5_.scaleSpeed = _loc5_.scaleSpeed * 2;
                  _loc5_.fadeSpeed = _loc5_.fadeSpeed * 2;
               }
            }
         }
      }
      
      private function onEnemy(param1:Enemy, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:ShootingObject = null;
         _loc3_ = 0;
         _loc4_ = null;
         param1.onEnter(this.e_array,param2);
         if(param1.gravityObject.counter % 32 == 0 && this.player.health > 0 && param1.hitTester.hit_rect.intersects(this.player.hitTester.hit_rect) && this.allowDamage)
         {
            this.theConnection.send("dmgP",param1.name,this.player.bodyAnimator.currentLabel == "block");
         }
         if((this.c_mc.currentFrame == 27 || this.c_mc.currentFrame == 72) && (param1.type != "Carnelia" || param1.type != "giant goo cube") && param1.gravityObject.counter % 18 == 0 && Math.random() > 0.93)
         {
            this.len = this.e_array.length;
            this.i = 0;
            while(this.i < this.len)
            {
               if(this.e_array[this.i].type == "Carnelia" || this.e_array[this.i].type == "giant goo cube")
               {
                  this.createHealingCircle(param1.x,param1.y,this.e_array[this.i]);
                  break;
               }
               ++this.i;
            }
         }
         if(this.c_mc.currentFrame == 72 && param1.type == "Carnelia")
         {
            param1.health = param1.health + (this.e_array.length - 1) * 120;
            param1.health = param1.health > param1.totalHealth ? param1.totalHealth : param1.health;
         }
         else if(this.c_mc.currentFrame == 27 && param1.type == "giant goo cube")
         {
            param1.health = param1.health + (this.e_array.length - 1) * 150;
            param1.health = param1.health > param1.totalHealth ? param1.totalHealth : param1.health;
         }
         else if(this.currentLevel == 116 && param1.type == "Kreetus")
         {
            _loc3_ = 0;
            for each(var _loc7_ in this.shootingObject_array)
            {
               _loc4_ = _loc7_;
               _loc7_;
               _loc3_ = _loc3_ + (_loc4_.currentLabel == "beholder cannon" ? 1 : 0);
            }
            param1.health = param1.health + _loc3_ * 500;
            param1.health = param1.health > param1.totalHealth ? param1.totalHealth : param1.health;
         }
         if(param1.gravityObject.inWater && Boolean(CommonCalls.onScreen(param1.x,param1.y,false,true)) && param1.gravityObject.counter % 10 == 0 && Math.random() > 0.65)
         {
            this.createWaterBubble(param1.x,param1.y - 7);
         }
      }
      
      private function onCoinBox(param1:CoinBox, param2:int) : void
      {
         param1.onEnter(this.p_array,this.projectile_array);
      }
      
      private function onItem(param1:Item, param2:int) : void
      {
         param1.onEnter(this.player);
         if(param1.type == "grenade" && param1.gravityObject.counter > 40 && Math.random() > 0.95)
         {
            if(param1.gravityObject.onGround)
            {
               Splatter.tryCreate(true,param1.x,param1.y,"explosion mark");
            }
            if(CommonCalls.onScreen(param1.x,param1.y,true,true))
            {
               this.createExplosion(param1.x,param1.y,param1.creatorName);
            }
            param1.removeFromParent(true);
            this.item_array.removeAt(param2);
            return;
         }
      }
      
      private function onDamageObject(param1:DamageObject, param2:int) : void
      {
         param1.onEnter(this.e_array,param2);
         param1.transform.colorTransform = param1.blinkCounter % 33 == 0 || param1.blinkCounter % 38 == 0 ? this.red_colorTransform : normal_colorTransform;
         if(this.player.health > 0 && param1.counter % param1.damageTime == 0 && param1.hitArea_mc.getBounds(this.c_mc).intersects(this.player.hitTester.hit_rect))
         {
            this.theConnection.send("envDmgP",param1.power);
         }
      }
      
      private function onHealingCircle(param1:HealingCircle, param2:int) : void
      {
         var _loc3_:Enemy = null;
         _loc3_ = null;
         ++param1.counter;
         param1.gotoTarget();
         if(param1.healTarget == null || param1.healTarget.parent == null)
         {
            this.c_mc.removeChild(param1);
            this.hCircle_array.removeAt(param2);
            return;
         }
         if(CalcDist.getDistNumbers(param1.x,param1.y,param1.healTarget.x,param1.healTarget.y) < 120)
         {
            for each(var _loc6_ in this.e_array)
            {
               _loc3_ = _loc6_;
               _loc6_;
               if(_loc3_.type == "Carnelia" || _loc3_.type == "giant goo cube")
               {
                  SetHue.tintObject(_loc3_,6417494);
                  break;
               }
            }
            this.ran_num = Math.random();
            if(this.ran_num > 0.5)
            {
               if(this.ran_num > 0.66)
               {
                  SoundManager.playSound(Assets.main_assetManager.getSound("heal low pitch sound"),param1.x,param1.y,true,this.starlingStage.c_mc);
               }
               else if(this.ran_num > 0.33)
               {
                  SoundManager.playSound(Assets.main_assetManager.getSound("heal mid pitch sound"),param1.x,param1.y,true,this.starlingStage.c_mc);
               }
               else
               {
                  SoundManager.playSound(Assets.main_assetManager.getSound("heal high pitch sound"),param1.x,param1.y,true,this.starlingStage.c_mc);
               }
            }
            this.c_mc.removeChild(param1);
            this.hCircle_array.removeAt(param2);
         }
      }
      
      private function onMagicEffect(param1:MagicEffect, param2:int) : void
      {
         param1.onMagicEffect();
         if(param1.numChildren == 0)
         {
            param1.removeFromParent(true);
            this.magicEffect_array.removeAt(param2);
            return;
         }
      }
      
      private function onAnimation(param1:starling.display.MovieClip, param2:int) : void
      {
         if(param1.isComplete || param1.parent == null)
         {
            this.main_juggler.remove(param1);
            param1.stop();
            param1.removeFromParent(true);
            this.animation_array.removeAt(param2);
            return;
         }
      }
      
      private function onMissionAniEnter(param1:flash.events.Event) : void
      {
         if(flash.display.MovieClip(param1.target).mission_txt != null)
         {
            flash.display.MovieClip(param1.target).mission_txt.text = flash.display.MovieClip(param1.target).mission;
         }
         if(flash.display.MovieClip(param1.target).currentFrame == flash.display.MovieClip(param1.target).totalFrames)
         {
            param1.target.removeEventListener(flash.events.Event.ENTER_FRAME,this.onMissionAniEnter);
            removeChild(flash.display.MovieClip(param1.target));
         }
      }
      
      private function onStormCloud(param1:Cloud, param2:int) : void
      {
         ++param1.counter;
         if(Math.random() > 0.8 && param1.counter < 14)
         {
            param1.transform.colorTransform = bright_colorTransform;
         }
         else
         {
            param1.transform.colorTransform = this.stormCloud_color;
         }
         if(param1.targetObject != null && Object(param1.targetObject).health > 0)
         {
            param1.x = param1.targetObject.x;
         }
         if(param1.counter > 20)
         {
            this.stormCloud_array.removeAt(param2);
            this.c_mc.removeChild(param1);
            return;
         }
      }
      
      private function onLightningBolt(param1:LightningBolt, param2:int) : void
      {
         ++param1.counter;
         if(param1.targetEnemy != null && param1.targetEnemy.health > 0)
         {
            param1.x = param1.targetEnemy.x;
            param1.y = param1.targetEnemy.y;
         }
         if(param1.counter > 20)
         {
            this.lightningBolt_array.removeAt(param2);
            this.c_mc.removeChild(param1);
            return;
         }
      }
      
      private function onShootingObject(param1:ShootingObject, param2:int) : void
      {
         var _loc3_:Person = null;
         _loc3_ = null;
         ++param1.counter;
         ++param1.blinkCounter;
         param1.transform.colorTransform = param1.blinkCounter % 33 == 0 || param1.blinkCounter % 38 == 0 ? this.red_colorTransform : normal_colorTransform;
         if(param1.blinkCounter > 38)
         {
            param1.blinkCounter = 0;
         }
         if((this.serverCounter + param1.ran_int) % 60 == 0)
         {
            this.createEnvProjectile(param1.x,param1.y,10 * param1.shootDir,0,param1.currentLabel);
            SoundManager.playSound(Stats.envStats[param1.currentLabel].sound,param1.x,param1.y,true,this.starlingStage.c_mc);
            param1.play();
         }
         if(param1 is BeholderCannon)
         {
            for each(var _loc6_ in this.p_array)
            {
               _loc3_ = _loc6_;
               _loc6_;
               if(_loc3_.y + 20 > param1.y && _loc3_.canDamage && Boolean(MoveStat.isAttackingFrame(_loc3_)) && (_loc3_.bodyAnimator.weaponLeft_sprite.getBounds(_loc3_.root).intersects(param1.getBounds(root)) || _loc3_.bodyAnimator.weaponRight_sprite.getBounds(_loc3_.root).intersects(param1.getBounds(root))))
               {
                  SoundManager.playSound(SoundLibrary.metal1_sound,param1.x,param1.y,true,this.starlingStage.c_mc);
                  _loc3_.canDamage = false;
                  this.createHitAnimation(param1.x + CalcDist.getDistX(_loc3_.x,param1.x) / 4,param1.y + CalcDist.getDistY(param1.y,_loc3_.y) / 2,this.player.x > param1.x ? 1 : -1);
                  this.theConnection.send("beCannonRe",int(param1.y));
                  TweenMax.to(param1,0.7,{
                     "x":param1.x + 110,
                     "ease":Linear.easeNone,
                     "onComplete":CommonCalls.removeObject,
                     "onCompleteParams":[param1]
                  });
                  TweenMax.to(param1,0.06,{
                     "alpha":0,
                     "delay":0.33,
                     "ease":Linear.easeNone
                  });
                  this.shootingObject_array.removeAt(param2);
                  return;
               }
            }
            this.len = this.projectile_array.length;
            this.i = this.len - 1;
            while(this.i >= 0)
            {
               if(this.projectile_array[this.i].getBounds(this.projectile_array[this.i].root).intersects(param1.getBounds(param1.root)))
               {
                  SoundManager.playSound(SoundLibrary.metal1_sound,param1.x,param1.y,true,this.starlingStage.c_mc);
                  this.createHitAnimation(this.projectile_array[this.i].x,this.projectile_array[this.i].y,this.projectile_array[this.i].x > param1.x ? 1 : -1);
                  this.projectile_array[this.i].removeFromParent(true);
                  this.projectile_array.removeAt(this.i);
                  this.theConnection.send("beCannonRe",int(param1.y));
                  TweenMax.to(param1,1,{
                     "x":param1 + 110,
                     "ease":Linear.easeNone,
                     "onComplete":CommonCalls.removeObject,
                     "onCompleteParams":[param1]
                  });
                  TweenMax.to(param1,0.06,{
                     "alpha":0,
                     "delay":0.33,
                     "ease":Linear.easeNone
                  });
                  this.shootingObject_array.removeAt(param2);
                  return;
               }
               --this.i;
            }
         }
      }
      
      public function equipItem(param1:String, param2:Boolean) : void
      {
         this.player.bodyAnimator.gotoAndPlay(this.player.ridingPet == null ? "standing" : "pet standing");
         this.theConnection.send("giNewEquip",param1,Stats.getItemType(param1),param2);
         this.starlingStage.controls.setMoreMobileButtons(this.player);
         SoundManager.playSound(SoundLibrary.itemBought_sound);
      }
      
      public function changeLevel(param1:int, param2:String, param3:Boolean = false) : void
      {
         var tempWeapon1:uint = 0;
         var tempWeapon2:uint = 0;
         var tempAcc:uint = 0;
         var _pet:Pet = null;
         var _npc:NPCStat = null;
         var areaAlreadyUnlocked:Boolean = false;
         var _unlockedArea:uint = 0;
         var person:Person = null;
         var bubbleWords:String = null;
         var lotteryTickets_txt:starling.text.TextField = null;
         var lotteryCoins_txt:starling.text.TextField = null;
         var winners_txt:starling.text.TextField = null;
         var winnings_txt:starling.text.TextField = null;
         var _rainPiece:starling.display.MovieClip = null;
         var _lev:int = param1;
         var _portalName:String = param2;
         var _noDisconnect:Boolean = param3;
         tempWeapon1 = 0;
         tempWeapon2 = 0;
         tempAcc = 0;
         _pet = null;
         _npc = null;
         areaAlreadyUnlocked = false;
         _unlockedArea = 0;
         person = null;
         bubbleWords = null;
         lotteryTickets_txt = null;
         lotteryCoins_txt = null;
         winners_txt = null;
         winnings_txt = null;
         _rainPiece = null;
         stage.focus = null;
         this.playerToPortalPositionSet = false;
         if(this.loadedPlayerMiscSuccess)
         {
            areaAlreadyUnlocked = false;
            for each(var _loc7_ in this.unlockedMaps_array)
            {
               _unlockedArea = _loc7_;
               _loc7_;
               if(_unlockedArea == _lev)
               {
                  areaAlreadyUnlocked = true;
                  break;
               }
            }
            if(areaAlreadyUnlocked == false)
            {
               this.unlockedMaps_array.push(_lev);
               this.theClient.bigDB.load("pMiscTable",this.player.name,function(param1:DatabaseObject):void
               {
                  if(param1 != null)
                  {
                     if(param1.maps == undefined)
                     {
                        param1.maps = new Array();
                        param1.maps.push(1);
                     }
                     else
                     {
                        param1.maps.push(_lev);
                     }
                     param1.save();
                  }
               });
            }
         }
         SoundManager.stopAllLoops(true);
         this.player.isControllingEnemy = false;
         this.player.inGuildRage = false;
         if(this.player.rageGlow_image != null)
         {
            this.player.rageGlow_image.removeFromParent(true);
         }
         if(this.talkBox != null)
         {
            this.starlingStage.removeChild(this.talkBox);
         }
         if(this.starlingStage.controls.chat_txt.text.length > 1)
         {
            this.newChatMessageGot(null,"[changed area] :","");
         }
         StarlingGameMenu.removeAllMenus(false,Vector.<StarlingGameMenu>([this.pmMenu]));
         this.main_juggler.purge();
         tempWeapon1 = this.player.bodyAnimator.weaponFrame;
         tempWeapon2 = this.player.bodyAnimator.weapon2Frame;
         tempAcc = this.player.bodyAnimator.accessoryFrame;
         this.player.bodyAnimator.weaponFrame = 1;
         this.player.bodyAnimator.weaponFrame = tempWeapon1;
         this.player.bodyAnimator.weapon2Frame = 1;
         this.player.bodyAnimator.weapon2Frame = tempWeapon2;
         this.player.bodyAnimator.accessoryFrame = tempAcc;
         this.len = numChildren;
         this.i = this.len - 1;
         while(this.i >= 0)
         {
            if(getChildAt(this.i) is TradeRequest)
            {
               removeChildAt(this.i);
            }
            --this.i;
         }
         this.levelChangeCounter = 0;
         if(_noDisconnect == false)
         {
            this.createWhite();
         }
         if(this.playingURL_string == "miniplay.com" && Math.random() > 0.4 && this.counter > 0)
         {
            MiniPlay.lechuck.stat.put(null,"level",this.player.lev);
            MiniPlay.lechuck.stat.put(null,"money",this.player.money);
            MiniPlay.lechuck.stat.put(null,"unlock_hooded",Stats.missionStats["The Black Hooded Hatchet"].completed);
            MiniPlay.lechuck.stat.put(null,"unlock_lost",Stats.missionStats["Look Like the Lost Warrior"].completed);
            MiniPlay.lechuck.stat.put(null,"unlock_joshua",Stats.missionStats["Show Joshua All Enemies"].completed);
         }
         this.emptyGameArrays();
         if(TileHandler.mainArt_textureAtlas != null)
         {
            TileHandler.mainArt_textureAtlas.dispose();
            if(TileHandler.foregroundArt_textureAtlas != null)
            {
               TileHandler.foregroundArt_textureAtlas.dispose();
            }
         }
         this.len = this.starlingStage.c_mc.numChildren;
         this.i = 0;
         while(this.i < this.len)
         {
            if(this.starlingStage.c_mc.getChildAt(this.i).name != null && this.starlingStage.c_mc.getChildAt(this.i).name.indexOf("mainArt") > -1 && Image(this.starlingStage.c_mc.getChildAt(this.i)).texture != null)
            {
               Image(this.starlingStage.c_mc.getChildAt(this.i)).texture.dispose();
            }
            ++this.i;
         }
         this.player.gravityObject.dropThroughCounter = 500;
         TileHandler.clearAllTileData();
         this.c_mc.gotoAndStop("blank level");
         this.c_mc.gotoAndStop(_lev);
         this.len = this.starlingStage.c_mc.numChildren;
         this.i = this.len - 1;
         while(this.i >= 0)
         {
            if(this.starlingStage.c_mc.getChildAt(this.i) != this.player)
            {
               this.starlingStage.c_mc.removeChildAt(this.i,true);
            }
            --this.i;
         }
         this.player.removeFromParent(false);
         this.buildLevel(_lev);
         this.starlingStage.c_mc.addChild(this.player);
         this.currentLevel = _lev;
         if(lighting)
         {
            Lighting.initArea(_lev,this.starlingStage);
         }
         this.len = PetOrb.petOrb_array.length;
         this.i = this.len - 1;
         while(this.i >= 0)
         {
            if(PetOrb.petOrb_array[this.i].creator.isPlayer)
            {
               PetOrb.petOrb_array[this.i].removeFromParent(true);
               PetOrb.petOrb_array.removeAt(this.i);
            }
            --this.i;
         }
         for each(_loc7_ in this.player.pet_array)
         {
            _pet = _loc7_;
            _loc7_;
            if(_pet.isActive == false)
            {
               this.createPetOrb(_pet.getOrbBonus(),_pet.name,this.player.name,_pet.lvl,_pet.type,this.player.hasOrbFocus);
            }
         }
         if(this.roboInvasionActive)
         {
            this.endRoboCityInvasion(null,0.1);
         }
         if(this.counter > 0)
         {
            this.player.keyHandler.keyStates.releaseKey(Keyboard.LEFT);
            this.player.keyHandler.keyStates.releaseKey(Keyboard.RIGHT);
            this.player.keyHandler.keyStates.releaseKey(Keyboard.DOWN);
            this.player.keyHandler.keyStates.releaseKey(Keyboard.UP);
            stage.removeEventListener(flash.events.Event.ENTER_FRAME,this.onEnter);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKDown);
            stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKUp);
            if(_noDisconnect == false)
            {
               this.createLoadScreen();
               this.loadScreen.loadInfo_txt.text = "saving player data";
               stage.addEventListener(flash.events.Event.ENTER_FRAME,this.onLoadCheckEnter);
               this.theConnection.addMessageHandler("pSaved",this.playerSaved);
               this.theConnection.send("chLvl",this.c_mc.currentFrame);
               this.player.awaitingSave = true;
            }
         }
         for each(_loc7_ in NPCStat.NPC_array)
         {
            _npc = _loc7_;
            _loc7_;
            if(_npc.area == this.c_mc.currentFrame)
            {
               person = new Person(this,false,_npc.name);
               person.x = _npc.x;
               person.y = _npc.y + 50;
               person.npc = true;
               person.bodyAnimator.eyes = _npc.eyeFrame;
               person.bodyAnimator.helmetString = _npc.helmet;
               person.bodyAnimator.hairString = _npc.hair;
               person.bodyAnimator.shirtString = _npc.shirt;
               person.bodyAnimator.pantsString = _npc.legs;
               person.bodyAnimator.weaponString = _npc.weapon1;
               person.bodyAnimator.weapon2String = _npc.weapon2;
               person.bodyAnimator.skin = _npc.skin;
               person.scaleX = _npc.scaleX;
               SortDepths.addAt(person,SortDepths.REGION_4);
               this.npc_array.push(person);
               if(_npc.talkTrigger > -1)
               {
                  bubbleWords = !isMobile ? "click to talk" : "touch to talk";
                  this.createTalkBubble(person,bubbleWords,_npc.talkTrigger);
               }
            }
         }
         switch(_lev)
         {
            case 1:
               if(this.getNPC("William") != null)
               {
                  this.getNPC("William").rotation = deg2rad(-90);
               }
               if(this.getNPC("William") != null)
               {
                  this.getNPC("William").y = this.getNPC("William").y + 30;
               }
               break;
            case 18:
               if(Boolean(Stats.missionStats["Solve Jimmy\'s Puzzle"].started) && Stats.missionStats["Solve Jimmy\'s Puzzle"].completed == false)
               {
                  if(this.player.name.length >= 8)
                  {
                     this.c_mc.graffiti_mc.gotoAndStop("pickaxe");
                  }
                  else
                  {
                     this.c_mc.graffiti_mc.gotoAndStop("meat cleaver");
                  }
               }
               else
               {
                  this.c_mc.removeChild(this.c_mc.graffiti_mc);
               }
               break;
            case 55:
               if(Stats.missionStats["Get Brody a Garbage Can Lid"].completed)
               {
                  if(this.getNPC("Brody") != null)
                  {
                     this.getNPC("Brody").bodyAnimator.weaponString = "garbage can lid";
                  }
               }
               break;
            case 64:
               if(Boolean(Stats.missionStats["Solve Jimmy\'s Puzzle"].started) && Stats.missionStats["Solve Jimmy\'s Puzzle"].completed == false)
               {
                  if(this.player.name.length >= 8)
                  {
                     this.c_mc.graffiti_mc.gotoAndStop("blue beanie");
                  }
                  else
                  {
                     this.c_mc.graffiti_mc.gotoAndStop("coconut helmet");
                  }
               }
               else
               {
                  this.c_mc.removeChild(this.c_mc.graffiti_mc);
               }
               break;
            case 83:
               lotteryTickets_txt = new starling.text.TextField(205,56,"0",AllTextFormats.lotteryTickets_textFormat);
               lotteryTickets_txt.x = 2728;
               lotteryTickets_txt.y = 1248;
               lotteryTickets_txt.name = "lotteryTickets_txt";
               this.starlingStage.c_mc.addChild(lotteryTickets_txt);
               lotteryCoins_txt = new starling.text.TextField(197,53,"0",AllTextFormats.lotteryCoins_textFormat);
               lotteryCoins_txt.x = 2730;
               lotteryCoins_txt.y = 1349;
               lotteryCoins_txt.batchable = lotteryTickets_txt.batchable = true;
               lotteryCoins_txt.touchable = lotteryTickets_txt.touchable = false;
               lotteryCoins_txt.name = "lotteryCoins_txt";
               this.starlingStage.c_mc.addChild(lotteryCoins_txt);
               winners_txt = new starling.text.TextField(110,57,"",AllTextFormats.chalkLeft_textFormat);
               winners_txt.x = 2387;
               winners_txt.name = "winners_txt";
               this.starlingStage.c_mc.addChild(winners_txt);
               winnings_txt = new starling.text.TextField(86,57,"",AllTextFormats.chalkRight_textFormat);
               winnings_txt.x = 2473;
               winnings_txt.y = winners_txt.y = 1373;
               winnings_txt.touchable = winners_txt.touchable = false;
               winnings_txt.batchable = winners_txt.batchable = true;
               winnings_txt.name = "winnings_txt";
               this.starlingStage.c_mc.addChild(winnings_txt);
               break;
            case 30:
               this.c_mc.alarm1_mc.visible = false;
               this.c_mc.alarm2_mc.visible = false;
               break;
            case 42:
               if(Stats.missionStats["Get Cassie Pumpkin Helmets"].completed)
               {
                  if(this.getNPC("Cassie") != null)
                  {
                     this.getNPC("Cassie").bodyAnimator.helmetString = "pumpkin helmet";
                  }
               }
         }
         if(_lev != 37 && this.c_mc.getChildByName("sign5_mc") != null)
         {
            this.c_mc.removeChild(this.c_mc.getChildByName("sign5_mc"));
            this.c_mc.removeChild(this.c_mc.getChildByName("sign4_mc"));
            this.c_mc.removeChild(this.c_mc.getChildByName("sign3_mc"));
            this.c_mc.removeChild(this.c_mc.getChildByName("sign2_mc"));
            this.c_mc.removeChild(this.c_mc.getChildByName("sign1_mc"));
         }
         if(_noDisconnect == false)
         {
            this.playLevelMusic(_lev);
         }
         if(Stats.missionStats["The Black Hooded Hatchet"].started == true && isMobile == false)
         {
            if(this.c_mc.currentFrame == 7 && Stats.missionStats["The Black Hooded Hatchet"].completed == false)
            {
               this.startCutScene(2);
            }
            else if(this.c_mc.currentFrame == 60 && Stats.missionStats["Look Like the Lost Warrior"].started == false)
            {
               this.startCutScene(3);
            }
            else if(this.c_mc.currentFrame == 97 && Stats.missionStats["Ride a Pet"].started == false)
            {
               this.startCutScene(4);
            }
            else if(this.c_mc.currentFrame == 66 && Stats.missionStats["Find the Cult\'s Hideout"].started == true && Stats.missionStats["Find the Cult\'s Hideout"].completed == false)
            {
               this.startCutScene(5);
            }
            else if(this.c_mc.currentFrame == 88 && Stats.missionStats["Catch Every Fish"].started == false)
            {
               this.startCutScene(6);
            }
            else if(this.c_mc.currentFrame == 105 && Stats.missionStats["Solve Philbert\'s Puzzle"].started == false)
            {
               this.startCutScene(7);
            }
            else if(this.c_mc.currentFrame == 53 && Stats.missionStats["Reach High Energy Level"].started == false)
            {
               this.startCutScene(8);
            }
         }
         if(AreaCreator.getAreaTheme(_lev) == 9)
         {
            if(this.snow == null || this.snow.parent == null)
            {
               this.snow = new Snow(stage,25);
               this.starlingStage.addChild(this.snow);
            }
         }
         else if(this.snow != null)
         {
            this.snow.removeFromParent(true);
         }
         if(AreaCreator.getAreaTheme(_lev) == 7)
         {
            SoundManager.playSound(Assets.main_assetManager.getSound("rain sound"),475,350,false,null,true,"rain");
            if(this.rain == null || this.rain.parent == null)
            {
               this.rain = new Rain(stage,20);
               this.starlingStage.addChild(this.rain);
            }
         }
         else if(this.rain != null)
         {
            this.rain.removeFromParent(true);
         }
         if(AreaCreator.getAreaTheme(_lev) == 17)
         {
            if(this.lavaRain == null || this.lavaRain.parent == null)
            {
               this.lavaRain = new LavaRain(stage,25);
               this.starlingStage.addChild(this.lavaRain);
            }
         }
         else if(this.lavaRain != null)
         {
            this.lavaRain.removeFromParent(true);
            for each(_loc7_ in this.lavaRain.rain_array)
            {
               _rainPiece = _loc7_;
               _loc7_;
               Starling.juggler.remove(_rainPiece);
            }
         }
         if(_lev == 27 || _lev == 72 || _lev == 116)
         {
            this.starlingStage.controls.createBossHealth();
         }
         else
         {
            this.starlingStage.controls.removeBossHealth();
         }
      }
      
      public function focusLevel(param1:starling.display.DisplayObject = null) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         param1 = param1 == null ? this.player : param1;
         this.starlingStage.c_mc.x = this.c_mc.x = 475;
         this.starlingStage.c_mc.y = this.c_mc.y = 400;
         _loc2_ = this.mainStarling.viewPort.height - loaderInfo.height;
         AreaCreator.background1.x = 310 / Starling.contentScaleFactor;
         AreaCreator.background1.y = (690 + _loc2_ / 2) / Starling.contentScaleFactor;
         AreaCreator.background2.x = -100 / Starling.contentScaleFactor;
         AreaCreator.background2.y = (400 + _loc2_ / 2) / Starling.contentScaleFactor;
         AreaCreator.background3.x = -100 / Starling.contentScaleFactor;
         AreaCreator.background3.y = (280 + _loc2_ / 2) / Starling.contentScaleFactor;
         this.global_point.x = param1.x;
         this.global_point.y = param1.y;
         this.global_point = this.c_mc.localToGlobal(this.global_point);
         this.c_mc.x = this.c_mc.x - (this.global_point.x - 475);
         this.c_mc.y = this.c_mc.y - (this.global_point.y - 449);
         this.starlingStage.c_mc.x = this.starlingStage.c_mc.x - (this.global_point.x - 475);
         this.starlingStage.c_mc.y = this.starlingStage.c_mc.y - (this.global_point.y - 449);
         AreaCreator.background1.x = AreaCreator.background1.x - (this.global_point.x - 475) / this.SCROLL_X_MODIFIER;
         AreaCreator.background1.y = AreaCreator.background1.y - (this.global_point.y - 449) / this.SCROLL_Y_MODIFIER / Starling.contentScaleFactor;
         AreaCreator.background2.x = AreaCreator.background2.x - (this.global_point.x - 475) / (this.SCROLL_X_MODIFIER * 2);
         AreaCreator.background2.y = AreaCreator.background2.y - (this.global_point.y - 449) / (this.SCROLL_Y_MODIFIER * 2) / Starling.contentScaleFactor;
         AreaCreator.background3.x = AreaCreator.background3.x - (this.global_point.x - 475) / (this.SCROLL_X_MODIFIER * 4);
         AreaCreator.background3.y = AreaCreator.background3.y - (this.global_point.y - 449) / (this.SCROLL_Y_MODIFIER * 4) / Starling.contentScaleFactor;
         if(this.counter > 0)
         {
            AreaCreator.preventBGOffscreenX();
            AreaCreator.preventBGOffscreenY();
         }
      }
      
      private function loadPVPurchases() : void
      {
         this.theClient.payVault.refresh(function():void
         {
            var _orb:PetOrb = null;
            _orb = null;
            if(Math.random() > 0.7 && (playingURL_string != "noShare" || isMobile))
            {
               theConnection.send("cheRevSha",playingURL_string);
            }
            player.tickets = theClient.payVault.coins;
            if(theClient.payVault.has("moreitems") && theClient.payVault.has("moremoreitems"))
            {
               maxItems = 40;
            }
            else if(theClient.payVault.has("moreitems") || theClient.payVault.has("moremoreitems"))
            {
               maxItems = 30;
            }
            else
            {
               maxItems = 20;
            }
            maxFriends = 20;
            maxFriends = maxFriends + (theClient.payVault.has("morefriends") ? 10 : 0);
            maxFriends = maxFriends + (theClient.payVault.has("moremorefriends") ? 10 : 0);
            hasResale = theClient.payVault.has("permSale");
            hasTeleport = theClient.payVault.has("teleport");
            hasXPSplit = theClient.payVault.has("petxp");
            maxPets = theClient.payVault.has("morepets") ? 8 : 4;
            hasDoubleDrop = theClient.payVault.has("doubledrop");
            hasManualControl = theClient.payVault.has("manualcontrol");
            hasEnemyControl = theClient.payVault.has("enemycontrol");
            hasItemStorage = theClient.payVault.has("bankitems");
            hasFishRadar = theClient.payVault.has("fishradar");
            player.gravityObject.maxJumps = theClient.payVault.has("doublejump") ? 2 : 1;
            player.hasOrbFocus = theClient.payVault.has("orbfocus");
            player.hasBaitExtend = theClient.payVault.has("baitextend");
            maxActivePets = 1;
            maxActivePets = maxActivePets + theClient.payVault.has("pet2");
            maxActivePets = maxActivePets + theClient.payVault.has("pet3");
            maxActivePets = maxActivePets + theClient.payVault.has("pet4");
            maxActivePets = maxActivePets + theClient.payVault.has("pet5");
            maxActivePets = maxActivePets + theClient.payVault.has("pet6");
            maxActivePets = maxActivePets + theClient.payVault.has("pet7");
            maxActivePets = maxActivePets + theClient.payVault.has("pet8");
            if(isAmazonUnderground)
            {
               maxItems = 40;
               maxFriends = 40;
               hasResale = true;
               hasTeleport = true;
               hasXPSplit = true;
               maxPets = 8;
               hasDoubleDrop = true;
               hasManualControl = true;
               hasEnemyControl = true;
               hasItemStorage = true;
               hasFishRadar = true;
               player.gravityObject.maxJumps = 2;
               player.hasOrbFocus = true;
               player.hasBaitExtend = true;
               maxActivePets = 8;
            }
            if(player.hasOrbFocus)
            {
               for each(var _loc4_ in PetOrb.petOrb_array)
               {
                  _orb = _loc4_;
                  _loc4_;
                  if(_orb.creator == player && _orb.isFocus == false && _orb.texture != Assets.items_textureAtlas.getTexture(_orb.color_string + " orb stroke"))
                  {
                     _orb.texture = Assets.items_textureAtlas.getTexture(_orb.color_string + " orb stroke");
                     _orb.width = _orb.width + 6;
                     _orb.height = _orb.height + 6;
                  }
               }
            }
            if(Boolean(hasDoubleDrop) && player.flyCluster == null)
            {
               player.flyCluster = new FlyCluster(player,5);
               player.addChild(player.flyCluster);
            }
            if(GameMenu.menu_array.indexOf(pvMenu) > -1 && (pvMenu.currentLabel == "loading" || pvMenu.currentFrame == 1))
            {
               pvMenu.gotoAndStop(1);
               pvMenu.yourTickets_txt.text = "Your Tickets: " + String(player.tickets);
               pvMenu.list_mc.buyItems_btn.visible = !theClient.payVault.has("moreitems");
               pvMenu.list_mc.buyItemsMore_btn.visible = !theClient.payVault.has("moremoreitems");
               pvMenu.list_mc.buyFriends_btn.visible = !theClient.payVault.has("morefriends");
               pvMenu.list_mc.buyHalo_btn.visible = !theClient.payVault.has("halo");
               pvMenu.list_mc.buyPermSell_btn.visible = !theClient.payVault.has("permSale");
               pvMenu.list_mc.buyTeleport_btn.visible = !theClient.payVault.has("teleport");
               pvMenu.list_mc.buyZombie_btn.visible = !theClient.payVault.has("zombie");
               pvMenu.list_mc.buyDoubleJump_btn.visible = !theClient.payVault.has("doublejump");
               pvMenu.list_mc.buyXPSplit_btn.visible = !theClient.payVault.has("petxp");
               pvMenu.list_mc.buyMorePets_btn.visible = !theClient.payVault.has("morepets");
               pvMenu.list_mc.buyDoubleDrop_btn.visible = !theClient.payVault.has("doubledrop");
               pvMenu.list_mc.buyManualControl_btn.visible = !theClient.payVault.has("manualcontrol");
               pvMenu.list_mc.buyOrbFocus_btn.visible = !theClient.payVault.has("orbfocus");
               pvMenu.list_mc.buyGuildMoney3x_btn.visible = !(Boolean(hasGuildMoney3x) || player.guild == "");
               pvMenu.list_mc.buyBaitExtend_btn.visible = !theClient.payVault.has("baitextend");
               pvMenu.list_mc.buyItemStorage_btn.visible = !theClient.payVault.has("bankitems");
               pvMenu.list_mc.buyChickenSuit_btn.visible = !theClient.payVault.has("chickensuit");
               pvMenu.list_mc.buyFriendsMore_btn.visible = !theClient.payVault.has("moremorefriends");
               pvMenu.list_mc.buyFishRadar_btn.visible = !theClient.payVault.has("fishradar");
               pvMenu.list_mc.buyEnemyControl_btn.visible = !theClient.payVault.has("enemycontrol");
               pvMenu.list_mc.buyActivePets_btn.visible = !theClient.payVault.has("pet8");
               pvMenu.list_mc.itemsBought_txt.visible = theClient.payVault.has("moreitems");
               pvMenu.list_mc.itemsMoreBought_txt.visible = theClient.payVault.has("moremoreitems");
               pvMenu.list_mc.friendsBought_txt.visible = theClient.payVault.has("morefriends");
               pvMenu.list_mc.haloBought_txt.visible = theClient.payVault.has("halo");
               pvMenu.list_mc.permSellBought_txt.visible = theClient.payVault.has("permSale");
               pvMenu.list_mc.teleportBought_txt.visible = theClient.payVault.has("teleport");
               pvMenu.list_mc.zombieBought_txt.visible = theClient.payVault.has("zombie");
               pvMenu.list_mc.doubleJumpBought_txt.visible = theClient.payVault.has("doublejump");
               pvMenu.list_mc.xpSplitBought_txt.visible = theClient.payVault.has("petxp");
               pvMenu.list_mc.morePetsBought_txt.visible = theClient.payVault.has("morepets");
               pvMenu.list_mc.doubleDropBought_txt.visible = theClient.payVault.has("doubledrop");
               pvMenu.list_mc.manualControlBought_txt.visible = theClient.payVault.has("manualcontrol");
               pvMenu.list_mc.orbFocusBought_txt.visible = theClient.payVault.has("orbfocus");
               pvMenu.list_mc.guildMoney3xBought_txt.visible = hasGuildMoney3x;
               pvMenu.list_mc.baitExtendBought_txt.visible = theClient.payVault.has("baitextend");
               pvMenu.list_mc.itemStorageBought_txt.visible = theClient.payVault.has("bankitems");
               pvMenu.list_mc.chickenSuitBought_txt.visible = theClient.payVault.has("chickensuit");
               pvMenu.list_mc.friendsMoreBought_txt.visible = theClient.payVault.has("moremorefriends");
               pvMenu.list_mc.fishRadarBought_txt.visible = theClient.payVault.has("fishradar");
               pvMenu.list_mc.enemyControlBought_txt.visible = theClient.payVault.has("enemycontrol");
               pvMenu.list_mc.activePetsBought_txt.visible = theClient.payVault.has("pet8");
            }
            if(payvaultHistoryChecked == false)
            {
               theClient.payVault.readHistory(1,60,function(param1:Array):void
               {
                  var _loc2_:PayVaultHistoryEntry = null;
                  _loc2_ = null;
                  payvaultHistoryChecked = true;
                  for each(var _loc5_ in param1)
                  {
                     _loc2_ = _loc5_;
                     _loc5_;
                     if(_loc2_.providerTransactionId != "" && _loc2_.amount > 9)
                     {
                        isPayingUser = true;
                     }
                  }
               });
            }
         });
      }
      
      private function getNPC(param1:String) : Person
      {
         var _loc2_:Person = null;
         _loc2_ = null;
         for each(var _loc5_ in this.npc_array)
         {
            _loc2_ = _loc5_;
            _loc5_;
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function teleportIn(param1:starling.display.DisplayObject) : void
      {
         var brightness_filter:ColorMatrixFilter = null;
         var filterChain:FilterChain = null;
         var n_tweenDone:Function = null;
         var _object:starling.display.DisplayObject = param1;
         brightness_filter = null;
         filterChain = null;
         n_tweenDone = null;
         n_tweenDone = function(param1:starling.display.DisplayObject):void
         {
            param1.filter = null;
            if(_object is Person)
            {
               Person(_object).isTweeningFilter = false;
            }
         };
         _object.scaleY = 1;
         TweenMax.from(_object,0.2,{
            "scaleY":0.1,
            "ease":Back.easeOut,
            "onComplete":n_tweenDone,
            "onCompleteParams":[_object]
         });
         brightness_filter = new ColorMatrixFilter();
         filterChain = new FilterChain(brightness_filter);
         _object.filter = filterChain;
         brightness_filter.adjustBrightness(1);
         if(_object is Person)
         {
            Person(_object).isTweeningFilter = true;
         }
      }
      
      private function startIntroGame(param1:Boolean = true) : void
      {
         if(param1)
         {
            this.changeLevel(1,"portal2");
            this.starlingStage.startMain();
            SoundManager.changeMusic(Assets.main_assetManager.getSound("theme 1 music"));
            this.player.awaitingSave = false;
         }
         this.createBlack();
         TweenMax.from(stage,1,{
            "delay":2,
            "onComplete":this.createTalkBox,
            "onCompleteParams":[6,this.getNPC("Ronald"),this.player.name + "! Help!  They\'re going to attack William!  Fight off those green bouncing things, quick!"]
         });
         this.allowDamage = false;
      }
      
      private function startIntro(param1:Number = 1, param2:Boolean = false) : void
      {
         if(param2 == false)
         {
            if(param1 >= 0)
            {
               SoundManager.playSound(SoundLibrary.woodSplit_sound);
               Shake.startShake(this.charCreateMenu.woodPlatform_image);
               Shake.startShake(this.charCreateMenu.personClone);
               TweenMax.to(this.charCreateMenu,0.2,{
                  "delay":param1,
                  "onComplete":this.startIntro,
                  "onCompleteParams":[param1 - 0.2]
               });
            }
            else
            {
               SoundManager.playSound(SoundLibrary.treeFall_sound);
               TweenMax.to(this.charCreateMenu.woodPlatform_image,1,{
                  "rotation":deg2rad(67),
                  "x":50,
                  "y":453,
                  "ease":Sine.easeIn,
                  "onComplete":this.startIntro,
                  "onCompleteParams":[0,true]
               });
               TweenMax.to(this.charCreateMenu.personClone,1,{
                  "rotation":deg2rad(60),
                  "x":385,
                  "y":388,
                  "ease":Sine.easeIn
               });
            }
         }
         else
         {
            if(isMobile == false)
            {
               this.startCutScene(1);
            }
            else
            {
               this.startIntroGame();
            }
            this.player.password = this.charCreateMenu.password_txt.text;
         }
      }
      
      private function transitionComplete(param1:flash.display.MovieClip) : void
      {
         TweenMax.to(param1,0.3,{
            "scaleX":27,
            "scaleY":27,
            "delay":0.3,
            "ease":Linear.easeNone,
            "onComplete":CommonCalls.removeObject,
            "onCompleteParams":[param1]
         });
      }
      
      public function addUserByString(param1:String, param2:String) : void
      {
         var n_friendNameLoaded:Function = null;
         var _friendName:String = param1;
         var _type:String = param2;
         n_friendNameLoaded = null;
         n_friendNameLoaded = function(param1:DatabaseObject):void
         {
            var _dbObject:DatabaseObject = param1;
            if(_dbObject != null)
            {
               if(_type == FriendMenu.FRIENDS)
               {
                  if(_dbObject.name == null)
                  {
                     _dbObject.name = _dbObject.key;
                  }
                  FriendMenu.friends_array.push(_friendName);
                  FriendMenu.friendsInfo_array.push(_dbObject);
               }
               else
               {
                  FriendMenu.enemies_array.push(_friendName);
               }
               if(StarlingGameMenu.menu_array.indexOf(friendMenu) > -1)
               {
                  friendMenu.updateMe(theClient,FriendMenu.FRIENDS);
                  friendMenu.friendInfoLoaded(_dbObject);
               }
               theClient.bigDB.load("pMiscTable",player.name,function(param1:DatabaseObject):*
               {
                  if(param1 != null && Boolean(loadedPlayerMiscSuccess))
                  {
                     param1.friends = FriendMenu.friends_array.toString();
                     param1.block = FriendMenu.enemies_array.toString();
                     param1.save();
                     createAlert(Person.removeNamePrefix(_friendName) + " has been added to your " + _type + " list",true);
                     theConnection.send("fAdd",_friendName,_type);
                  }
               });
            }
            else
            {
               createAlert(Person.removeNamePrefix(_friendName) + " is not a valid player name");
            }
         };
         if(_type == FriendMenu.ENEMIES && FriendMenu.friends_array.indexOf(_friendName) > -1)
         {
            this.createAlert("this person is your friend, cannot make enemy");
         }
         else if(_type == FriendMenu.FRIENDS && FriendMenu.enemies_array.indexOf(_friendName) > -1)
         {
            this.createAlert("this person is your enemy, cannot make friend");
         }
         else if(_type == FriendMenu.FRIENDS && FriendMenu.friends_array.indexOf(_friendName) > -1)
         {
            this.createAlert("this person is already your friend");
         }
         else if(_type == FriendMenu.ENEMIES && FriendMenu.enemies_array.indexOf(_friendName) > -1)
         {
            this.createAlert("ths person is already your enemy");
         }
         else if(_friendName == this.theClient.connectUserId)
         {
            this.createAlert("cannot add yourself");
         }
         else
         {
            if(_friendName.indexOf("facebook") != 0 && _friendName.indexOf("kongregate") != 0 && _friendName.indexOf("steam") != 0 && _friendName.indexOf("playerio") != 0)
            {
               this.theClient.bigDB.load("PlayerObjects",_friendName,n_friendNameLoaded);
            }
            else
            {
               this.theClient.bigDB.loadSingle("PlayerObjects","nameIndex",[_friendName],n_friendNameLoaded);
            }
            if(this.friendMenu != null && this.friendMenu.parent != null)
            {
               this.friendMenu.removeAddPanel();
            }
         }
      }
      
      public function removeUserByString(param1:String, param2:String) : void
      {
         var _username:String = param1;
         var _type:String = param2;
         if(_type == FriendMenu.FRIENDS)
         {
            this.arrayStringRemove(FriendMenu.friends_array,_username);
            this.len2 = FriendMenu.friendsInfo_array.length;
            this.j = 0;
            while(this.j < this.len2)
            {
               if(FriendMenu.friendsInfo_array[this.j].name == _username)
               {
                  FriendMenu.friendsInfo_array.removeAt(this.j);
                  break;
               }
               ++this.j;
            }
            this.friendMenu.updateMe(this.theClient,FriendMenu.FRIENDS);
         }
         else
         {
            this.arrayStringRemove(FriendMenu.enemies_array,_username);
            this.friendMenu.updateMe(this.theClient,FriendMenu.ENEMIES);
         }
         this.theClient.bigDB.load("pMiscTable",this.player.name,function(param1:DatabaseObject):*
         {
            if(param1 != null && Boolean(loadedPlayerMiscSuccess))
            {
               param1.friends = FriendMenu.friends_array.toString();
               param1.block = FriendMenu.enemies_array.toString();
               param1.save();
            }
         });
         this.theConnection.send("fRem",_username,_type);
      }
      
      private function tweenOut(param1:flash.display.DisplayObject) : void
      {
         TweenMax.to(param1,0.8,{
            "alpha":0,
            "delay":4,
            "onComplete":CommonCalls.removeObject,
            "onCompleteParams":[param1]
         });
      }
      
      public function gotoMainMenuFrame(param1:int) : void
      {
         var n_trySteamAuth:Function = null;
         var tempLoginObject:Object = null;
         var tempNumTries:int = 0;
         var _frame:int = param1;
         tempLoginObject = null;
         tempNumTries = 0;
         var tempPastFrameLabel:String = this.mMenu.currentLabel;
         this.mMenu.gotoAndStop(_frame);
         if(hasEventListener(FocusEvent.FOCUS_IN) == false)
         {
            addEventListener(FocusEvent.FOCUS_IN,this.onFocused);
         }
         if(_frame == 1)
         {
            if(Capabilities.playerType == "Desktop")
            {
               this.mMenu.facebookSignIn_btn.visible = false;
               this.mMenu.forgotPass_btn.y = this.mMenu.forgotPass_btn.y - this.mMenu.facebookSignIn_btn.height;
            }
            if(GameMain.isMobile)
            {
               this.mMenu.removeChild(this.mMenu.fullScreen_btn);
               this.mMenu.fighterArt_mc.stop();
               this.mMenu.orb1_mc.stop();
               this.mMenu.orb2_mc.stop();
               this.mMenu.orb3_mc.stop();
               this.mMenu.fighterArt_mc.cacheAsBitmap = this.mMenu.orb1_mc.cacheAsBitmap = this.mMenu.orb2_mc.cacheAsBitmap = this.mMenu.orb3_mc.cacheAsBitmap = true;
            }
            this.mMenu.version_btn.visible = !isMobile;
            this.mMenu.signIn_btn.tabEnabled = false;
            this.mMenu.rememberMe_mc.mouseChildren = false;
            this.mMenu.rememberMe_mc.buttonMode = true;
            this.mMenu.loadingCircle_mc.visible = false;
            this.mMenu.online_txt.text = String(this.totalGamePlayers);
            TweenMax.from(this.mMenu.helmet_mc,0.7,{
               "scaleX":5,
               "scaleY":5,
               "ease":Back.easeOut
            });
            TweenMax.from(this.mMenu.heroes_mc,0.7,{
               "scaleX":5,
               "scaleY":5,
               "delay":0.2,
               "ease":Back.easeOut
            });
            TweenMax.from(this.mMenu.adventure_mc,0.5,{
               "y":-370,
               "delay":0.5,
               "ease":Back.easeOut
            });
            TweenMax.from(this.mMenu.helmetIcon_mc,0.5,{
               "scaleX":0.1,
               "scaleY":0.1,
               "delay":0.9,
               "ease":Back.easeOut
            });
            TweenMax.from(this.mMenu.sword_mc,0.5,{
               "x":520,
               "delay":1.1
            });
            TweenMax.from(this.mMenu.fighterArt_mc,0.45,{
               "x":750,
               "delay":1
            });
            TweenMax.from(this.mMenu.orb1_mc,0.6,{
               "x":-500,
               "y":-400,
               "delay":1.2,
               "ease":Back.easeOut
            });
            TweenMax.from(this.mMenu.orb2_mc,0.6,{
               "x":-500,
               "y":-400,
               "delay":1.25,
               "ease":Back.easeOut
            });
            TweenMax.from(this.mMenu.orb3_mc,0.6,{
               "x":-500,
               "y":-400,
               "delay":1.33,
               "ease":Back.easeOut
            });
            if(this.save_sharedObject.data.username != null && this.save_sharedObject.data.userPassword != null)
            {
               this.mMenu.rememberMe_mc.gotoAndStop("save");
               this.mMenu.username_txt.text = this.save_sharedObject.data.username;
               this.mMenu.password_txt.text = this.save_sharedObject.data.userPassword;
               this.mMenu.username_txt.textColor = this.mMenu.password_txt.textColor = 0;
               this.mMenu.password_txt.displayAsPassword = true;
               if(isMobile && this.save_sharedObject.data.username != undefined && this.save_sharedObject.data.userPassword != undefined)
               {
                  this.signInCheck(true);
                  this.mMenu.rememberMe_txt.visible = this.mMenu.rememberMe_mc.visible = true;
               }
            }
            if(this.country == "Philippines")
            {
               this.mMenu.signUp_btn.visible = false;
            }
            if(this.playingURL_string == "armorgames.com" || this.playingURL_string == "facebook.com" || this.playingURL_string == "kongregate.com" || this.playingURL_string == "y8.com" || this.playingURL_string == "miniplay.com" || this.playingURL_string == "steampowered.com" || Boolean(PlayerIOPublishingNetwork.isOnNetworkSite()))
            {
               this.mMenu.signInColon_txt.visible = this.mMenu.username_txt.visible = this.mMenu.usernamePanel_mc.visible = this.mMenu.password_txt.visible = this.mMenu.signUp_btn.visible = false;
               this.mMenu.passwordPanel_mc.visible = this.mMenu.signIn_btn.visible = this.mMenu.forgotPass_btn.visible = this.mMenu.rememberMe_mc.visible = this.mMenu.rememberMe_txt.visible = false;
               this.mMenu.credits_btn.visible = this.mMenu.facebookSignIn_btn.visible = false;
               this.mMenu.loadingCircle_mc.visible = true;
               this.mMenu.loadingCircle_mc.loadingText_txt.text = "connecting to service";
               tempLoginObject = new Object();
               if(this.playingURL_string == "facebook.com")
               {
                  this.mMenu.loadingCircle_mc.loadingText_txt.text = "authenticating";
                  PlayerIO.quickConnect.facebookOAuthConnect(stage,"hho-ygpra4ftumusohpifpdug",Facebook.token,null,null,function(param1:Client, param2:String):void
                  {
                     var _client:Client = param1;
                     var _userID:String = param2;
                     connectType = "facebook";
                     theClient = _client;
                     mMenu.loadingCircle_mc.loadingText_txt.text = "searching for account";
                     _client.bigDB.loadMyPlayerObject(function(param1:DatabaseObject):void
                     {
                        var n_onCharCreateMenuReady:Function = null;
                        var _myPlayerObject:DatabaseObject = param1;
                        n_onCharCreateMenuReady = null;
                        mMenu.loadingCircle_mc.loadingText_txt.text = "loaded?";
                        if(_myPlayerObject.pow == undefined)
                        {
                           n_onCharCreateMenuReady = function(param1:flash.events.Event):*
                           {
                              if(charCreateMenu != null)
                              {
                                 removeEventListener(flash.events.Event.ENTER_FRAME,n_onCharCreateMenuReady);
                                 charCreateMenu.passwordColon_txt.visible = charCreateMenu.password_txt.visible = false;
                                 charCreateMenu.emailColon_txt.visible = charCreateMenu.email_txt.visible = charCreateMenu.emailNotice_txt.visible = false;
                                 charCreateMenu.passBorder.removeFromParent(true);
                                 charCreateMenu.emailBorder.removeFromParent(true);
                                 charCreateMenu.back_btn.visible = false;
                                 createTransition();
                              }
                           };
                           mMenu.visible = false;
                           createCreateMenu();
                           addEventListener(flash.events.Event.ENTER_FRAME,n_onCharCreateMenuReady);
                        }
                        else
                        {
                           player.name = Person.removeNamePrefix(_myPlayerObject.name);
                           handleConnect(theClient);
                        }
                     });
                  },function(param1:PlayerIOError):void
                  {
                     mMenu.loadingCircle_mc.loadingText_txt.text = "error connecting";
                  });
               }
               else if(this.playingURL_string == "armorgames.com")
               {
                  tempLoginObject.userId = "adsfjhakf";
                  PlayerIO.authenticate(stage,"hho-ygpra4ftumusohpifpdug","public",tempLoginObject,null,function(param1:Client):void
                  {
                     var _client:Client = param1;
                     mMenu.loadingCircle_mc.loadingText_txt.text = "searching for account";
                     _client.bigDB.load("linkedUsers",ArmorGames.uid,function(param1:DatabaseObject):void
                     {
                        var _dbObject:DatabaseObject = param1;
                        mMenu.loadingCircle_mc.loadingText_txt.text = "loaded?";
                        if(_dbObject == null)
                        {
                           mMenu.loadingCircle_mc.loadingText_txt.text = "fetching AG info";
                           ArmorGames.fetchObject(ArmorGames.uid,function(param1:Object):void
                           {
                              var _armorObject:Object = param1;
                              mMenu.loadingCircle_mc.loadingText_txt.text = "checking for PObject";
                              _client.bigDB.load("PlayerObjects",_armorObject.payload.username,function(param1:DatabaseObject):void
                              {
                                 var _playerObject:DatabaseObject = param1;
                                 mMenu.loadingCircle_mc.loadingText_txt.text = "loaded PO";
                                 if(_playerObject == null)
                                 {
                                    mMenu.loadingCircle_mc.loadingText_txt.text = "creating username";
                                    findFreeUsername(_client,_armorObject.payload.username,function(param1:String):void
                                    {
                                       var n_onCharCreateMenuReady:Function = null;
                                       var _freeName:String = param1;
                                       n_onCharCreateMenuReady = null;
                                       n_onCharCreateMenuReady = function(param1:flash.events.Event):*
                                       {
                                          if(charCreateMenu != null)
                                          {
                                             removeEventListener(flash.events.Event.ENTER_FRAME,n_onCharCreateMenuReady);
                                             charCreateMenu.name_txt.text = _freeName;
                                             charCreateMenu.nameBorder.removeFromParent(true);
                                             charCreateMenu.name_txt.isSelectable = charCreateMenu.name_txt.isEditable = false;
                                             charCreateMenu.passwordColon_txt.visible = charCreateMenu.password_txt.visible = false;
                                             charCreateMenu.emailColon_txt.visible = charCreateMenu.email_txt.visible = false;
                                             charCreateMenu.emailNotice_txt.visible = charCreateMenu.back_btn.visible = false;
                                             charCreateMenu.passBorder.removeFromParent(true);
                                             charCreateMenu.emailBorder.removeFromParent(true);
                                             createTransition();
                                          }
                                       };
                                       mMenu.visible = false;
                                       connectType = "basic";
                                       createCreateMenu();
                                       addEventListener(flash.events.Event.ENTER_FRAME,n_onCharCreateMenuReady);
                                    });
                                 }
                                 else
                                 {
                                    mMenu.loadingCircle_mc.loadingText_txt.text = "re-authenticating";
                                    mMenu.username_txt.text = _playerObject.key;
                                    ArmorGames.fetchSecretHash(_playerObject.key,function(param1:String, param2:Boolean):void
                                    {
                                       if(param2)
                                       {
                                          mMenu.password_txt.text = param1;
                                          mMenu.relink = true;
                                          signInCheck(false,"basic");
                                       }
                                       else
                                       {
                                          mMenu.loadingCircle_mc.visible = false;
                                          mMenu.valid_txt.text = "Authenticate failed. Try refreshing.";
                                       }
                                    });
                                 }
                              });
                           });
                        }
                        else
                        {
                           mMenu.loadingCircle_mc.loadingText_txt.text = "authenticating";
                           mMenu.username_txt.text = _dbObject.username;
                           ArmorGames.fetchSecretHash(_dbObject.username,function(param1:String, param2:Boolean):void
                           {
                              if(param2)
                              {
                                 mMenu.password_txt.text = param1;
                                 signInCheck(false,"basic");
                              }
                              else
                              {
                                 mMenu.loadingCircle_mc.visible = false;
                                 mMenu.valid_txt.text = "Authenticate failed. Try refreshing.";
                              }
                           });
                        }
                     },function(param1:PlayerIOError):void
                     {
                        mMenu.loadingCircle_mc.loadingText_txt.text = param1.message;
                     });
                  });
               }
               else if(this.playingURL_string == "y8.com")
               {
                  if(this.y8_api.isLoggedIn)
                  {
                     tempLoginObject.userId = "adsfjhakf";
                     PlayerIO.authenticate(stage,"hho-ygpra4ftumusohpifpdug","public",tempLoginObject,null,function(param1:Client):void
                     {
                        var _client:Client = param1;
                        mMenu.loadingCircle_mc.loadingText_txt.text = "searching for account";
                        _client.bigDB.load("linkedUsers",y8_api.userID,function(param1:DatabaseObject):void
                        {
                           var _dbObject:DatabaseObject = param1;
                           if(_dbObject == null)
                           {
                              mMenu.loadingCircle_mc.loadingText_txt.text = "creating username";
                              findFreeUsername(_client,y8_api.username,function(param1:String):void
                              {
                                 var n_onCharCreateMenuReady:Function = null;
                                 var _freeName:String = param1;
                                 n_onCharCreateMenuReady = null;
                                 n_onCharCreateMenuReady = function(param1:flash.events.Event):*
                                 {
                                    if(charCreateMenu != null)
                                    {
                                       removeEventListener(flash.events.Event.ENTER_FRAME,n_onCharCreateMenuReady);
                                       charCreateMenu.name_txt.text = _freeName;
                                       charCreateMenu.nameBorder.removeFromParent(true);
                                       charCreateMenu.name_txt.isSelectable = charCreateMenu.name_txt.isEditable = false;
                                       charCreateMenu.passwordColon_txt.visible = charCreateMenu.password_txt.visible = false;
                                       charCreateMenu.emailColon_txt.visible = charCreateMenu.email_txt.visible = false;
                                       charCreateMenu.emailNotice_txt.visible = charCreateMenu.back_btn.visible = false;
                                       charCreateMenu.passBorder.removeFromParent(true);
                                       charCreateMenu.emailBorder.removeFromParent(true);
                                       createTransition();
                                    }
                                 };
                                 mMenu.visible = false;
                                 connectType = "basic";
                                 createCreateMenu();
                                 addEventListener(flash.events.Event.ENTER_FRAME,n_onCharCreateMenuReady);
                              });
                           }
                           else
                           {
                              mMenu.loadingCircle_mc.loadingText_txt.text = "authenticating";
                              mMenu.username_txt.text = _dbObject.username;
                              y8_api.fetchSecretHash(_dbObject.username,function(param1:String):void
                              {
                                 mMenu.password_txt.text = param1;
                                 signInCheck(false,"basic");
                              });
                           }
                        });
                     });
                  }
                  else
                  {
                     this.mMenu.loadingCircle_mc.loadingText_txt.text = "waiting for registration";
                     this.y8_api.idnet.toggleInterface("login");
                  }
               }
               else if(this.playingURL_string == "miniplay.com")
               {
                  if(MiniPlay.lechuck.user.isGuest() == false)
                  {
                     tempLoginObject.userId = "adsfjhakf";
                     PlayerIO.authenticate(stage,"hho-ygpra4ftumusohpifpdug","public",tempLoginObject,null,function(param1:Client):void
                     {
                        var _client:Client = param1;
                        mMenu.loadingCircle_mc.loadingText_txt.text = "searching for account";
                        _client.bigDB.load("linkedUsers",MiniPlay.lechuck.user.id,function(param1:DatabaseObject):void
                        {
                           var _dbObject:DatabaseObject = param1;
                           if(_dbObject == null)
                           {
                              mMenu.loadingCircle_mc.loadingText_txt.text = "creating username";
                              findFreeUsername(_client,MiniPlay.lechuck.user.uid,function(param1:String):void
                              {
                                 var n_onCharCreateMenuReady:Function = null;
                                 var _freeName:String = param1;
                                 n_onCharCreateMenuReady = null;
                                 n_onCharCreateMenuReady = function(param1:flash.events.Event):*
                                 {
                                    if(charCreateMenu != null)
                                    {
                                       removeEventListener(flash.events.Event.ENTER_FRAME,n_onCharCreateMenuReady);
                                       charCreateMenu.name_txt.text = _freeName.split(".").join("_");
                                       charCreateMenu.nameBorder.removeFromParent(true);
                                       charCreateMenu.name_txt.isSelectable = charCreateMenu.name_txt.isEditable = false;
                                       charCreateMenu.passwordColon_txt.visible = charCreateMenu.password_txt.visible = false;
                                       charCreateMenu.emailColon_txt.visible = charCreateMenu.email_txt.visible = false;
                                       charCreateMenu.emailNotice_txt.visible = charCreateMenu.back_btn.visible = false;
                                       charCreateMenu.passBorder.removeFromParent(true);
                                       charCreateMenu.emailBorder.removeFromParent(true);
                                       createTransition();
                                    }
                                 };
                                 mMenu.visible = false;
                                 connectType = "basic";
                                 createCreateMenu();
                                 addEventListener(flash.events.Event.ENTER_FRAME,n_onCharCreateMenuReady);
                              });
                           }
                           else
                           {
                              mMenu.loadingCircle_mc.loadingText_txt.text = "authenticating";
                              mMenu.username_txt.text = _dbObject.username;
                              MiniPlay.fetchSecretHash(_dbObject.username,function(param1:String, param2:Boolean):void
                              {
                                 if(param2)
                                 {
                                    mMenu.password_txt.text = param1;
                                    signInCheck(false,"basic");
                                 }
                                 else
                                 {
                                    mMenu.loadingCircle_mc.visible = false;
                                    mMenu.valid_txt.text = "Authenticate failed. Try refreshing.";
                                    mMenu.valid_txt.text = param1;
                                 }
                              });
                           }
                        });
                     });
                  }
                  else
                  {
                     this.mMenu.gotoAndStop("please sign in");
                     this.mMenu.loadingCircle_mc.visible = false;
                  }
               }
               else if(this.playingURL_string == "kongregate.com")
               {
                  if(Kongregate.isGuest == false)
                  {
                     Kongregate.kongregateAPI.stats.submit("loaded",1);
                     tempLoginObject.userId = Kongregate.uid;
                     tempLoginObject.gameAuthToken = Kongregate.token;
                     PlayerIO.authenticate(stage,"hho-ygpra4ftumusohpifpdug","kongregateconnection",tempLoginObject,null,function(param1:Client):void
                     {
                        var _client:Client = param1;
                        connectType = "kongregate";
                        theClient = _client;
                        mMenu.loadingCircle_mc.loadingText_txt.text = "searching for account";
                        _client.bigDB.loadMyPlayerObject(function(param1:DatabaseObject):void
                        {
                           var _myPlayerObject:DatabaseObject = param1;
                           if(_myPlayerObject.pow == undefined)
                           {
                              mMenu.loadingCircle_mc.loadingText_txt.text = "creating username";
                              findFreeUsername(_client,Kongregate.username,function(param1:String):void
                              {
                                 var n_onCharCreateMenuReady:Function = null;
                                 var _freeName:String = param1;
                                 n_onCharCreateMenuReady = null;
                                 n_onCharCreateMenuReady = function(param1:flash.events.Event):*
                                 {
                                    if(charCreateMenu != null)
                                    {
                                       removeEventListener(flash.events.Event.ENTER_FRAME,n_onCharCreateMenuReady);
                                       charCreateMenu.name_txt.text = _freeName;
                                       charCreateMenu.password_txt.text = Kongregate.token;
                                       charCreateMenu.nameBorder.removeFromParent(true);
                                       charCreateMenu.name_txt.isSelectable = charCreateMenu.name_txt.isEditable = false;
                                       charCreateMenu.passwordColon_txt.visible = charCreateMenu.password_txt.visible = false;
                                       charCreateMenu.emailColon_txt.visible = charCreateMenu.email_txt.visible = false;
                                       charCreateMenu.emailNotice_txt.visible = charCreateMenu.back_btn.visible = false;
                                       charCreateMenu.passBorder.removeFromParent(true);
                                       charCreateMenu.emailBorder.removeFromParent(true);
                                       createTransition();
                                    }
                                 };
                                 mMenu.visible = false;
                                 createCreateMenu();
                                 addEventListener(flash.events.Event.ENTER_FRAME,n_onCharCreateMenuReady);
                              });
                           }
                           else
                           {
                              mMenu.loadingCircle_mc.loadingText_txt.text = "authenticating";
                              mMenu.username_txt.text = Person.removeNamePrefix(_myPlayerObject.name);
                              player.name = mMenu.username_txt.text;
                              signInCheck(false,"kongregate");
                           }
                        });
                     },function(param1:PlayerIOError):void
                     {
                        mMenu.loadingCircle_mc.loadingText_txt.text = param1.message;
                     });
                  }
                  else
                  {
                     this.mMenu.gotoAndStop("please sign in");
                     this.mMenu.loadingCircle_mc.visible = false;
                  }
               }
               else if(PlayerIOPublishingNetwork.isOnNetworkSite())
               {
                  tempLoginObject.userToken = PlayerIOPublishingNetwork.token;
                  this.playingURL_string = "playerio.com";
                  PlayerIO.authenticate(stage,"hho-ygpra4ftumusohpifpdug","publishingnetwork",tempLoginObject,null,function(param1:Client):void
                  {
                     var _client:Client = param1;
                     connectType = "publishingnetwork";
                     theClient = _client;
                     mMenu.loadingCircle_mc.loadingText_txt.text = "searching for account";
                     _client.bigDB.loadMyPlayerObject(function(param1:DatabaseObject):void
                     {
                        var usernameNoSpaces:String = null;
                        var _myPlayerObject:DatabaseObject = param1;
                        usernameNoSpaces = null;
                        if(_myPlayerObject.pow == undefined)
                        {
                           mMenu.loadingCircle_mc.loadingText_txt.text = "creating username";
                           usernameNoSpaces = PlayerIOPublishingNetwork.username.split(" ").join("_");
                           findFreeUsername(_client,usernameNoSpaces,function(param1:String):void
                           {
                              var n_onCharCreateMenuReady:Function = null;
                              var _freeName:String = param1;
                              n_onCharCreateMenuReady = null;
                              n_onCharCreateMenuReady = function(param1:flash.events.Event):*
                              {
                                 if(charCreateMenu != null)
                                 {
                                    removeEventListener(flash.events.Event.ENTER_FRAME,n_onCharCreateMenuReady);
                                    if(PlayerIOPublishingNetwork.username != "unnamed player" && PlayerIOPublishingNetwork.username != "unknown player")
                                    {
                                       charCreateMenu.name_txt.isSelectable = charCreateMenu.name_txt.isEditable = false;
                                       charCreateMenu.nameBorder.removeFromParent(true);
                                    }
                                    charCreateMenu.name_txt.text = _freeName;
                                    charCreateMenu.password_txt.text = PlayerIOPublishingNetwork.token;
                                    charCreateMenu.passwordColon_txt.visible = charCreateMenu.password_txt.visible = false;
                                    charCreateMenu.emailColon_txt.visible = charCreateMenu.email_txt.visible = false;
                                    charCreateMenu.emailNotice_txt.visible = charCreateMenu.back_btn.visible = false;
                                    charCreateMenu.passBorder.removeFromParent(true);
                                    charCreateMenu.emailBorder.removeFromParent(true);
                                    createTransition();
                                 }
                              };
                              mMenu.visible = false;
                              createCreateMenu();
                              addEventListener(flash.events.Event.ENTER_FRAME,n_onCharCreateMenuReady);
                           });
                        }
                        else
                        {
                           mMenu.loadingCircle_mc.loadingText_txt.text = "authenticating";
                           mMenu.username_txt.text = Person.removeNamePrefix(_myPlayerObject.name);
                           player.name = mMenu.username_txt.text;
                           signInCheck(false,"publishingnetwork");
                        }
                     });
                  },function(param1:PlayerIOError):void
                  {
                     mMenu.fullScreen_txt.text = PlayerIOPublishingNetwork.token;
                     mMenu.loadingCircle_mc.loadingText_txt.text = param1.message;
                  });
               }
               else if(this.playingURL_string == "steampowered.com")
               {
                  n_trySteamAuth = function():void
                  {
                     tempLoginObject.steamAppId = Steam.steam.getAppID();
                     tempLoginObject.steamSessionTicket = Steam.getAuthToken();
                     PlayerIO.authenticate(stage,"hho-ygpra4ftumusohpifpdug","steamconnection",tempLoginObject,null,function(param1:Client):void
                     {
                        var _client:Client = param1;
                        connectType = "steam";
                        theClient = _client;
                        mMenu.loadingCircle_mc.loadingText_txt.text = "searching for account";
                        _client.bigDB.loadMyPlayerObject(function(param1:DatabaseObject):void
                        {
                           var n_onCharCreateMenuReady:Function = null;
                           var _myPlayerObject:DatabaseObject = param1;
                           n_onCharCreateMenuReady = null;
                           if(_myPlayerObject.pow == undefined)
                           {
                              n_onCharCreateMenuReady = function(param1:flash.events.Event):*
                              {
                                 if(charCreateMenu != null)
                                 {
                                    removeEventListener(flash.events.Event.ENTER_FRAME,n_onCharCreateMenuReady);
                                    charCreateMenu.password_txt.text = tempLoginObject.steamSessionTicket;
                                    charCreateMenu.passwordColon_txt.visible = charCreateMenu.password_txt.visible = false;
                                    charCreateMenu.emailColon_txt.visible = charCreateMenu.email_txt.visible = false;
                                    charCreateMenu.emailNotice_txt.visible = charCreateMenu.back_btn.visible = false;
                                    charCreateMenu.passBorder.removeFromParent(true);
                                    charCreateMenu.emailBorder.removeFromParent(true);
                                    createTransition();
                                 }
                              };
                              mMenu.visible = false;
                              createCreateMenu();
                              addEventListener(flash.events.Event.ENTER_FRAME,n_onCharCreateMenuReady);
                           }
                           else
                           {
                              mMenu.loadingCircle_mc.loadingText_txt.text = "connecting to service";
                              mMenu.username_txt.text = Person.removeNamePrefix(_myPlayerObject.name);
                              player.name = mMenu.username_txt.text;
                              handleConnect(theClient);
                           }
                        });
                     },function(param1:PlayerIOError):void
                     {
                        ++tempNumTries;
                        if(tempNumTries < 5)
                        {
                           mMenu.loadingCircle_mc.loadingText_txt.text = "retrying";
                           n_trySteamAuth();
                        }
                        else
                        {
                           mMenu.loadingCircle_mc.loadingText_txt.text = String(param1.message);
                           mMenu.loadingCircle_mc.loadingText_txt.text = "error, retry";
                        }
                     });
                  };
                  tempNumTries = 0;
                  n_trySteamAuth();
               }
            }
         }
         else if(_frame == 6)
         {
            this.mMenu.loadingCircle_mc.visible = false;
            this.mMenu.server1_mc.buttonMode = this.mMenu.server2_mc.buttonMode = this.mMenu.server3_mc.buttonMode = this.mMenu.serverPVP_mc.buttonMode = true;
            this.mMenu.server1_mc.mouseChildren = this.mMenu.server2_mc.mouseChildren = this.mMenu.server3_mc.mouseChildren = this.mMenu.serverPVP_mc.mouseChildren = false;
            this.mMenu.server2_mc.visible = false;
            this.mMenu.server3_mc.visible = false;
            this.mMenu.serverPVP_mc.name_txt.text = "PvP Server";
            this.mMenu.server1_mc.name_txt.text = "Pve Server";
            this.mMenu.server1_mc.icon_mc.visible = this.mMenu.serverPVP_mc.icon_mc.visible = false;
         }
      }
      
      private function findFreeUsername(param1:Client, param2:String, param3:Function, param4:int = 0) : void
      {
         var _client:Client = param1;
         var _name:String = param2;
         var _callback:Function = param3;
         var _suffix:int = param4;
         _client.bigDB.load("pMiscTable",_name + (_suffix > 0 ? "_" + _suffix : ""),function(param1:DatabaseObject):void
         {
            if(param1 == null)
            {
               _callback(_name + (_suffix > 0 ? String("_" + _suffix) : ""));
            }
            else
            {
               findFreeUsername(_client,_name,_callback,_suffix + 1);
            }
         });
      }
      
      public function findIsFreeUsername(param1:Client, param2:String, param3:Function) : void
      {
         var _client:Client = param1;
         var _name:String = param2;
         var _callback:Function = param3;
         _client.bigDB.load("pMiscTable",_name,function(param1:DatabaseObject):void
         {
            _callback(param1 == null);
         });
      }
      
      public function findDBNamePrefix(param1:String, param2:Function) : void
      {
         var _basicUsername:String = param1;
         var _callback:Function = param2;
         this.theClient.bigDB.load("PlayerObjects","simple" + _basicUsername,function(param1:DatabaseObject):void
         {
            var _simpleDBObject:DatabaseObject = param1;
            if(_simpleDBObject != null)
            {
               _callback("simple");
            }
            else
            {
               theClient.bigDB.loadSingle("PlayerObjects","nameIndex",["facebook" + _basicUsername],function(param1:DatabaseObject):void
               {
                  var _facebookDBObject:DatabaseObject = param1;
                  if(_facebookDBObject != null)
                  {
                     _callback("facebook");
                  }
                  else
                  {
                     theClient.bigDB.loadSingle("PlayerObjects","nameIndex",["kongregate" + _basicUsername],function(param1:DatabaseObject):void
                     {
                        var _kongDBObject:DatabaseObject = param1;
                        if(_kongDBObject != null)
                        {
                           _callback("kongregate");
                        }
                        else
                        {
                           theClient.bigDB.loadSingle("PlayerObjects","nameIndex",["steam" + _basicUsername],function(param1:DatabaseObject):void
                           {
                              var _steamDBObject:DatabaseObject = param1;
                              if(_steamDBObject != null)
                              {
                                 _callback("steam");
                              }
                              else
                              {
                                 theClient.bigDB.loadSingle("PlayerObjects","nameIndex",["playerio" + _basicUsername],function(param1:DatabaseObject):void
                                 {
                                    if(param1 != null)
                                    {
                                       _callback("playerio");
                                    }
                                    else
                                    {
                                       _callback("");
                                    }
                                 });
                              }
                           });
                        }
                     });
                  }
               });
            }
         });
      }
      
      private function hideMainMenuItemsForSite() : void
      {
         this.mMenu.usernamePanel_mc.visible = false;
         this.mMenu.username_txt.selectable = false;
         this.mMenu.username_txt.type = "dynamic";
         this.mMenu.rememberMe_txt.visible = false;
         this.mMenu.rememberMe_mc.visible = false;
         this.mMenu.forgotPass_btn.visible = false;
         this.mMenu.signUp_btn.visible = false;
      }
      
      public function setPersonCopy(param1:Person, param2:DatabaseObject) : void
      {
         param1.bodyAnimator.eyes = param2.eye;
         param1.bodyAnimator.beard = param2.beard;
         param1.bodyAnimator.helmetFrame = param2.helm;
         if(ItemStat(Stats.hStats[param1.bodyAnimator.helmetString]).allowHair)
         {
            param1.bodyAnimator.hair = param2.hair;
         }
         param1.bodyAnimator.shirtFrame = param2.shirt;
         param1.bodyAnimator.pantsFrame = param2.leg;
         param1.bodyAnimator.weaponFrame = param2.weap;
         param1.bodyAnimator.weapon2Frame = param2.weap2;
         param1.bodyAnimator.skin = param2.skin > 4 ? uint(param2.skin - 4) : uint(param2.skin);
         param1.bodyAnimator.shoeFrame = param2.shoe;
         param1.bodyAnimator.accessoryFrame = param2.acc != undefined ? uint(param2.acc) : 0;
         param1.hasHalo = param2.hasHalo != undefined && param2.hasHalo == true ? Boolean(param2.hasHalo) : false;
      }
      
      private function signInCheck(param1:Boolean = false, param2:String = "simple") : void
      {
         this.connectType = param2;
         if(this.mMenu.username_txt.length > 0 && this.mMenu.username_txt.text.search(this.validString) == -1 || param2 == "facebook" || param2 == "kongregate" || param2 == "publishingnetwork")
         {
            if(param1 == false)
            {
               this.localConnection = new LocalConnection();
               this.localConnection.allowDomain("*");
               this.localConnection.client = this;
               this.localConnection.connect("_HHReceive");
               this.localConnection.addEventListener(StatusEvent.STATUS,this.onLCStatusEvent);
               this.localConnection.send("_helmetHeroes-" + this.mMenu.username_txt.text,"signOnDupeCheck",this.mMenu.username_txt.text);
            }
            else
            {
               if(this.country != "Philippines")
               {
                  this.mMenu.signUp_btn.visible = true;
               }
               this.mMenu.signIn_btn.visible = this.mMenu.username_txt.visible = this.mMenu.password_txt.visible = this.mMenu.usernamePanel_mc.visible = false;
               this.mMenu.passwordPanel_mc.visible = this.mMenu.rememberMe_txt.visible = this.mMenu.rememberMe_mc.visible = false;
               this.mMenu.credits_btn.visible = this.mMenu.signInColon_txt.visible = this.mMenu.forgotPass_btn.visible = false;
               this.mMenu.facebookSignIn_btn.visible = false;
               this.mMenu.loadingCircle_mc.visible = true;
               this.mMenu.loadingCircle_mc.loadingText_txt.text = "connecting to service";
               if(param2 != "kongregate" && param2 != "publishingnetwork")
               {
                  this.player.name = this.mMenu.username_txt.text;
                  this.player.password = this.mMenu.password_txt.text;
                  this.connectToServer(param2);
               }
               else
               {
                  this.handleConnect(this.theClient);
               }
            }
         }
         else if(param2 != "facebook" && param2 != "kongregate" && param2 != "publishingnetwork")
         {
            this.mMenu.valid_txt.text = "invalid username";
         }
      }
      
      public function getXPToLevel(param1:int) : int
      {
         return param1 * (param1 * 1.1 + 50);
      }
      
      private function playLevelMusic(param1:int, param2:Boolean = false) : void
      {
         var tempTheme:uint = 0;
         var loadLowQuality:Boolean = false;
         var urlPreString:String = null;
         var _lev:int = param1;
         var _forceRestart:Boolean = param2;
         tempTheme = 0;
         loadLowQuality = false;
         urlPreString = null;
         tempTheme = uint(AreaCreator.getAreaTheme(_lev));
         if(Boolean(SoundManager.musicOn) && (this.mMenu == null || this.mMenu.parent == null))
         {
            loadLowQuality = this.country == "Philippines" && this.player.lev < 800;
            urlPreString = "https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/";
            if(loadLowQuality)
            {
               urlPreString = urlPreString + "very_low_quality/";
            }
            switch(tempTheme)
            {
               case 1:
                  Assets.main_assetManager.enqueueWithName(urlPreString + "spread your wings.mp3","theme 1 music");
                  break;
               case 2:
                  Assets.main_assetManager.enqueueWithName(urlPreString + "mushroom_music.mp3","theme 2 music");
                  break;
               case 5:
                  Assets.main_assetManager.enqueueWithName(urlPreString + "beach-music.mp3","theme 5 music");
                  break;
               case 15:
                  Assets.main_assetManager.enqueueWithName(urlPreString + "windmill-music.mp3","theme 15 music");
                  break;
               case 7:
                  Assets.main_assetManager.enqueueWithName(urlPreString + "Dance_Of_The_Dragons_full_mix.mp3","theme 7 music");
                  Assets.main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/rain loop.mp3","rain sound");
                  break;
               case 3:
                  Assets.main_assetManager.enqueueWithName(urlPreString + "Picket_Fences_full_mix.mp3","theme 3 music");
                  break;
               case 14:
                  Assets.main_assetManager.enqueueWithName(urlPreString + "Suite_Trip_full_mix.mp3","theme 14 music");
                  break;
               case 4:
                  Assets.main_assetManager.enqueueWithName(urlPreString + "Cutie_Pie_full_mix.mp3","theme 4 music");
                  break;
               case 6:
                  Assets.main_assetManager.enqueueWithName(urlPreString + "Bringing_Faith_full_mix.mp3","theme 6 music");
                  break;
               case 8:
                  Assets.main_assetManager.enqueueWithName(urlPreString + "Forgotten_Time_full_mix.mp3","theme 8 music");
                  break;
               case 9:
                  Assets.main_assetManager.enqueueWithName(urlPreString + "/Mister_Magician_full_mix.mp3","theme 9 music");
                  break;
               case 18:
                  Assets.main_assetManager.enqueueWithName(urlPreString + "Here_To_Forever_full_mix_mp3.mp3","theme 18 music");
                  break;
               case 10:
                  Assets.main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/siren alarm.mp3","siren alarm sound");
                  Assets.main_assetManager.enqueueWithName(urlPreString + "Tomorrow_Here_full_mix_mp3.mp3","theme 10 music");
                  break;
               case 11:
                  Assets.main_assetManager.enqueueWithName(urlPreString + "Modern_Warriors_full_mix.mp3","theme 11 music");
                  break;
               case 12:
                  Assets.main_assetManager.enqueueWithName(urlPreString + "Times_Of_Change_full_mix 2.mp3","theme 12 music");
                  break;
               case 16:
                  Assets.main_assetManager.enqueueWithName(urlPreString + "Surreal_State_full_mix.mp3","theme 16 music");
                  break;
               case 13:
                  Assets.main_assetManager.enqueueWithName(urlPreString + "Survivors_full_mix.mp3","theme 13 music");
                  Assets.main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/suction.mp3","suction sound");
                  Assets.main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/blop.mp3","blop sound");
                  break;
               case 17:
                  Assets.main_assetManager.enqueueWithName(urlPreString + "Raise_Me_Up_full_mix.mp3","theme 17 music");
                  break;
               case 21:
                  Assets.main_assetManager.enqueueWithName(urlPreString + "Art_Of_The_East_full_mix.mp3","theme 21 music");
                  break;
               case 29:
                  Assets.main_assetManager.enqueueWithName(urlPreString + "150413_Our_World_Alive-free_download.mp3","theme 29 music");
            }
            if(_lev == 27 || _lev == 72 || _lev == 116)
            {
               Assets.main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/wind heal sound low pitch.mp3","heal low pitch sound");
               Assets.main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/wind heal sound.mp3","heal mid pitch sound");
               Assets.main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/wind heal sound high pitch.mp3","heal high pitch sound");
            }
            Assets.main_assetManager.loadQueue(function(param1:Number):void
            {
               if(param1 == 1 && Assets.main_assetManager.getSound("theme " + tempTheme + " music") != null)
               {
                  SoundManager.changeMusic(Assets.main_assetManager.getSound("theme " + tempTheme + " music"),_forceRestart);
               }
            });
         }
      }
      
      public function startCutScene(param1:int) : void
      {
         if(param1 == 1)
         {
            this.startIntroGame();
         }
      }
      
      public function emptyGameArrays() : void
      {
         var _loc1_:Pet = null;
         var _loc2_:Array = null;
         _loc1_ = null;
         _loc2_ = null;
         CommonCalls.emptyArray(this.e_array,true,true);
         CommonCalls.emptyArray(this.pet_array,true);
         CommonCalls.emptyArray(this.item_array,true,true);
         CommonCalls.emptyArray(DamageObject.damageObject_array,true);
         CommonCalls.emptyArray(SplatParticle.particle_array,true,true);
         CommonCalls.emptyArray(Particle.particle_array,true,true);
         CommonCalls.emptyArray(this.shootingObject_array,true);
         CommonCalls.emptyArray(CoinBox.coinBox_array,true,true);
         CommonCalls.emptyArray(Fish.newFish_array,true,true);
         CommonCalls.emptyArray(Tree.tree_array,true,true);
         CommonCalls.emptyArray(this.npc_array,true,true);
         CommonCalls.emptyArray(BouncePad.bouncePad_array,true,true);
         this.portal_array.length = 0;
         WindSource.wind_array.length = 0;
         this.player.keyHandler.emptyKeyPressArrays();
         this.starlingStage.controls.sentChat_array.length = 0;
         PipeController.clearAllArrays();
         this.len = this.p_array.length;
         this.i = this.len - 1;
         while(this.i >= 0)
         {
            if(this.p_array[this.i].name != this.player.name)
            {
               this.p_array[this.i].removeFromParent(true);
               this.p_array.removeAt(this.i);
            }
            --this.i;
         }
         for each(var _loc5_ in this.player.pet_array)
         {
            _loc1_ = _loc5_;
            _loc5_;
            _loc1_.emptyKeyPressArrays();
         }
         for each(_loc5_ in Enemy.enemyAssets_array)
         {
            _loc2_ = _loc5_;
            _loc5_;
            TextureAtlas(_loc2_[0]).dispose();
            if(_loc2_.length > 4)
            {
               TextureAtlas(_loc2_[4]).dispose();
            }
            if(_loc2_.length > 5)
            {
               TextureAtlas(_loc2_[5]).dispose();
            }
         }
         Enemy.enemyAssets_array.length = 0;
      }
      
      private function onLCStatusEvent(param1:StatusEvent) : void
      {
         if(param1.level == "error")
         {
            this.signInCheck(true,this.connectType);
            this.localConnection.close();
         }
      }
      
      public function signOnDupeCheck(param1:String) : void
      {
         this.localConnection.send("_HHReceive","dupeConfirm",this.player.name);
      }
      
      public function dupeConfirm(param1:String) : void
      {
         this.mMenu.valid_txt.text = "Warning: already signed on";
         ++this.dupeSignInAttempts;
         this.localConnection.close();
      }
      
      private function returnObjectFromUID(param1:Array, param2:String) : Object
      {
         this.len6 = param1.length;
         this.g = 0;
         while(this.g < this.len6)
         {
            if(param1[this.g].uid == param2)
            {
               return param1[this.g];
            }
            ++this.g;
         }
         return undefined;
      }
      
      public function useItem(param1:String) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         var _loc10_:Item = null;
         var _loc11_:Item = null;
         var _loc12_:Item = null;
         var _loc13_:Item = null;
         _loc2_ = false;
         _loc3_ = null;
         _loc4_ = 0;
         _loc5_ = 0;
         _loc6_ = 0;
         _loc7_ = 0;
         _loc8_ = 0;
         _loc9_ = 0;
         _loc10_ = null;
         _loc11_ = null;
         _loc12_ = null;
         _loc13_ = null;
         _loc2_ = false;
         for each(var _loc16_ in this.personItem_array)
         {
            _loc3_ = _loc16_;
            _loc16_;
            if(_loc3_ == param1)
            {
               _loc2_ = true;
               break;
            }
         }
         if(_loc2_ == false || param1 == "")
         {
            if(param1 != "")
            {
               this.createAlert("You do not have any more " + param1 + "s available");
            }
            return;
         }
         if(this.player.health > 0)
         {
            _loc4_ = 0;
            _loc5_ = 0;
            switch(param1)
            {
               case "apple":
                  this.theConnection.send("pHealed",50);
                  this.player.health = this.player.health + 50;
                  break;
               case "banana":
                  this.theConnection.send("pHealed",20,100);
                  this.player.health = this.player.health + 20;
                  this.player.MP = this.player.MP + 100;
                  break;
               case "watermelon":
                  this.theConnection.send("pHealed",200,50);
                  this.player.health = this.player.health + 200;
                  this.player.MP = this.player.MP + 50;
                  break;
               case "turkey":
                  this.theConnection.send("pHealed",400,100);
                  this.player.health = this.player.health + 400;
                  this.player.MP = this.player.MP + 100;
                  break;
               case "book of power":
                  this.theConnection.send("useScroll","book of power");
                  ++this.player.power;
                  _loc5_++;
                  break;
               case "book of magic":
                  this.theConnection.send("useScroll","book of magic");
                  ++this.player.magic;
                  _loc5_++;
                  break;
               case "book of range":
                  this.theConnection.send("useScroll","book of range");
                  ++this.player.range;
                  _loc5_++;
                  break;
               case "book of artillery":
                  this.theConnection.send("useScroll","book of artillery");
                  ++this.player.artillery;
                  _loc5_++;
                  break;
               case "book of dexterity":
                  if(this.player.dex < 300)
                  {
                     this.theConnection.send("useScroll","book of dexterity");
                     ++this.player.dex;
                  }
                  else
                  {
                     this.createAlert("You cannot use anymore dexterity books");
                  }
                  _loc5_++;
                  break;
               case "book of health":
                  this.theConnection.send("useScroll","book of health");
                  this.player.health = this.player.health + 10;
                  this.player.totalHealth = this.player.totalHealth + 10;
                  _loc5_++;
                  break;
               case "book of MP":
                  this.theConnection.send("useScroll","book of MP");
                  this.player.MP = this.player.MP + 10;
                  this.player.totalMP = this.player.totalMP + 10;
                  _loc5_++;
                  break;
               case "book of defense":
                  this.theConnection.send("useScroll","book of defense");
                  ++this.player.defense;
                  _loc5_++;
                  break;
               case "book of skill":
                  this.theConnection.send("useScroll","book of skill");
                  ++this.player.skillPoints;
                  _loc5_++;
                  break;
               case "evolution crystal":
                  _loc4_++;
                  this.createAlert("must be used from the pet item menu");
                  break;
               case "bullhorn":
                  _loc4_++;
                  GameMenu.removeFocusMenu();
                  if(GameMenu.menu_array.indexOf(this.bullhornMenu) == -1)
                  {
                     this.createBullhornMenu();
                  }
                  break;
               case "item vendor":
                  if(this.player.gravityObject.onGround)
                  {
                     this.createConfirmMenu("Are you sure you would like to set this item vendor? It cannot be withdrawn after it has been placed.","itemvendor");
                  }
                  else
                  {
                     this.createAlert("You must be standing on the ground to use this");
                  }
                  _loc4_++;
                  break;
               case "pet vendor":
                  if(this.c_mc.currentFrame == 98 && this.player.gravityObject.onGround)
                  {
                     this.createConfirmMenu("Are you sure you would like to set this pet vendor? It cannot be withdrawn after it has been placed.","petvendor");
                  }
                  else if(this.player.gravityObject.onGround == false)
                  {
                     this.createAlert("You must be standing on the ground to use this");
                  }
                  else if(this.c_mc.currentFrame != 98)
                  {
                     this.createAlert("You must be in the Pet Adoption District to use this item");
                  }
                  _loc4_++;
                  break;
               case "green spawn ball":
                  _loc6_ = 0;
                  for each(_loc16_ in this.item_array)
                  {
                     _loc10_ = _loc16_;
                     _loc16_;
                     if(_loc10_.type == "green spawn ball")
                     {
                        _loc6_++;
                     }
                  }
                  if(_loc6_ >= 2)
                  {
                     this.createAlert("Only a max of 2 spawn balls can be used per area at once.");
                     _loc4_++;
                  }
                  if(this.player.gravityObject.onGround && _loc4_ == 0)
                  {
                     this.theConnection.send("useSpawnBall","green spawn ball");
                  }
                  else if(_loc4_ == 0)
                  {
                     _loc4_++;
                     this.createAlert("you must be on the ground to use");
                  }
                  break;
               case "blue spawn ball":
                  _loc7_ = 0;
                  for each(_loc16_ in this.item_array)
                  {
                     _loc11_ = _loc16_;
                     _loc16_;
                     if(_loc11_.type == "blue spawn ball")
                     {
                        _loc7_++;
                     }
                  }
                  if(_loc7_ >= 2)
                  {
                     this.createAlert("Only a max of 2 spawn balls can be used per area at once.");
                     _loc4_++;
                  }
                  if(this.player.gravityObject.onGround && _loc4_ == 0)
                  {
                     this.theConnection.send("useSpawnBall","blue spawn ball");
                  }
                  else if(_loc4_ == 0)
                  {
                     _loc4_++;
                     this.createAlert("you must be on the ground to use");
                  }
                  break;
               case "yellow spawn ball":
                  _loc8_ = 0;
                  for each(_loc16_ in this.item_array)
                  {
                     _loc12_ = _loc16_;
                     _loc16_;
                     if(_loc12_.type == "yellow spawn ball")
                     {
                        _loc8_++;
                     }
                  }
                  if(_loc8_ >= 2)
                  {
                     this.createAlert("Only a max of 2 spawn balls can be used per area at once.");
                     _loc4_++;
                  }
                  if(this.player.gravityObject.onGround && _loc4_ == 0)
                  {
                     this.theConnection.send("useSpawnBall","yellow spawn ball");
                  }
                  else if(_loc4_ == 0)
                  {
                     _loc4_++;
                     this.createAlert("you must be on the ground to use");
                  }
                  break;
               case "orange spawn ball":
                  _loc9_ = 0;
                  for each(_loc16_ in this.item_array)
                  {
                     _loc13_ = _loc16_;
                     _loc16_;
                     if(_loc13_.type == "orange spawn ball")
                     {
                        _loc9_++;
                     }
                  }
                  if(_loc9_ >= 2 && _loc4_ == 0)
                  {
                     this.createAlert("Only a max of 2 spawn balls can be used per area at once.");
                     _loc4_++;
                  }
                  if(this.player.gravityObject.onGround && _loc4_ == 0)
                  {
                     this.theConnection.send("useSpawnBall","orange spawn ball");
                  }
                  else if(_loc4_ == 0)
                  {
                     _loc4_++;
                     this.createAlert("you must be on the ground to use");
                  }
                  break;
               default:
                  if(Stats.getItemType(Fish.fishNoShinyName(param1)) == "fish")
                  {
                     this.theConnection.send("useFish",param1);
                     _loc5_++;
                  }
                  else
                  {
                     this.createAlert("this item has no way to be used");
                     _loc4_++;
                  }
            }
            if(_loc4_ == 0)
            {
               SetHue.tintObject(this.player,16777215);
               if(this.player.health > this.player.totalHealth)
               {
                  this.player.health = this.player.totalHealth;
               }
               if(this.player.MP > this.player.totalMP)
               {
                  this.player.MP = this.player.totalMP;
               }
               if(_loc5_ == 0)
               {
                  this.theConnection.send("sellI",param1,false);
               }
               this.arrayStringRemove(this.personItem_array,param1);
               if(this.itemMenu != null && this.itemMenu.parent != null && this.itemMenu.menuType == "self")
               {
                  this.itemMenu.updateMe(this.maxItems,this.personItem_array,this.player);
               }
               SoundManager.playSound(SoundLibrary.heal_sound);
            }
         }
         else
         {
            this.createAlert("You cannot use items when dead");
         }
      }
      
      public function removeLowQuality() : void
      {
         if(AreaCreator.background1.parent == null)
         {
            this.starlingStage.addChildAt(AreaCreator.background3,1);
            this.starlingStage.addChildAt(AreaCreator.background2,2);
            this.starlingStage.addChildAt(AreaCreator.background1,3);
            AreaCreator.sky.height = Starling.current.viewPort.height;
         }
      }
      
      public function updatePVMenu() : void
      {
         this.pvMenu.gotoAndStop("loading");
         this.loadPVPurchases();
         if(isMobile && isIOS == false)
         {
            GooglePlay.checkRestore();
         }
         this.theClient.bigDB.loadRange("PayVaultItems","costIndex",null,0,int.MAX_VALUE,80,this.payvaultItemsLoaded);
      }
   }
}

