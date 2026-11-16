package starling
{
   import com.apis.*;
   import com.game_objects.*;
   import com.game_objects.enemies.*;
   import com.game_objects.extensions.*;
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.helpers.*;
   import com.math.*;
   import com.menus.*;
   import com.menus.add_ons.*;
   import com.sound.*;
   import com.stats.*;
   import com.ui.*;
   import com.utilities.*;
   import com.visual_effects.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.ui.*;
   import flash.utils.*;
   import playerio.*;
   import starling.core.*;
   import starling.display.*;
   import starling.events.*;
   
   public final class MainStarlingStage extends starling.display.Sprite
   {
      
      public var gameMain:GameMain;
      
      public var c_mc:starling.display.Sprite = new Sprite();
      
      private var clickedDownTarget:starling.display.DisplayObject;
      
      private var prevMouseOver_target:starling.display.DisplayObject;
      
      private var __focus:starling.display.DisplayObject;
      
      public var controls:Controls;
      
      private var scrollingMobileMenu:IScrollableGameMenu;
      
      private var lastDownTouch:Touch;
      
      private var lastScrollY:Number = 0;
      
      private var downTouching:Boolean = false;
      
      private var downTouchCounter:uint = 0;
      
      public var antiAutoClicker:AntiAutoClicker = new AntiAutoClicker();
      
      public function MainStarlingStage()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onClick(param1:starling.display.DisplayObject) : void
      {
         var _target:starling.display.DisplayObject = param1;
         var tempShow:Boolean = false;
         var receiverPlayer:Person = null;
         var eTotalCost:uint = 0;
         var eChargeCost:uint = 0;
         var eAbsorbedCost:uint = 0;
         var eLevelCost:uint = 0;
         var eEnemyCost:uint = 0;
         var ePvpCost:uint = 0;
         var eRandomCost:uint = 0;
         var eRageCost:uint = 0;
         var eChopCost:uint = 0;
         var eFishCost:uint = 0;
         var fullNameKey:String = null;
         var fullNameKey2:String = null;
         var fullKey:String = null;
         var tempItemType:String = null;
         var tempChild:starling.display.DisplayObject = null;
         var canActivePet:Boolean = false;
         var b:int = 0;
         var a:int = 0;
         var miscString:String = null;
         var redirect_url:URLRequest = null;
         var tempSelectedIndex:int = 0;
         var isHittingATM:Boolean = false;
         var _pet1:Pet = null;
         var selectedPet:Pet = null;
         var _pet:Pet = null;
         var tooManyPets:Boolean = false;
         var hasCompanionPet:Boolean = false;
         var _petCheck:Pet = null;
         var tempGender:String = null;
         var tempSignInObject:Object = null;
         var _removePet:Pet = null;
         var _petOrb:PetOrb = null;
         var _person:Person = null;
         var _npc:Person = null;
         var targetName:String = null;
         var fullName:String = null;
         var tempInfoArray:Vector.<DatabaseObject> = null;
         var friendFound:Boolean = false;
         var _personObject:DatabaseObject = null;
         var overLevel_string:String = null;
         var tempFocusMenu:StarlingGameMenu = null;
         var len:int = 0;
         var i:int = 0;
         if(this.gameMain.deadMenu != null && this.gameMain.deadMenu.parent != null)
         {
            return;
         }
         switch(this.clickedDownTarget.name)
         {
            case "x_btn":
               if(_target.parent is TradeMenu)
               {
                  this.gameMain.lastTradeCounter = 0;
                  this.gameMain.theConnection.send("tClosed",this.gameMain.tradeMenu.traderName);
               }
               else if(_target.parent is OptionMenu)
               {
                  this.gameMain.setButtonsMode = false;
                  i = 0;
                  while(i < GameInput.numDevices)
                  {
                     i++;
                  }
               }
               if(this.clickedDownTarget.parent is CharacterMenu && this.gameMain.tutorial != null && this.gameMain.tutorial.parent != null)
               {
                  this.gameMain.removeChild(this.gameMain.tutorial);
                  this.gameMain.allowDamage = false;
               }
               StarlingGameMenu.removeFocusMenu();
               break;
            case "etc_btn":
               tempShow = this.controls.heropedia_btn == null || this.controls.heropedia_btn.parent == null;
               this.controls.toggleButtons(tempShow,this.gameMain.player);
               if(tempShow)
               {
                  setTimeout(function():void
                  {
                     if(controls.heropedia_btn != null && controls.heropedia_btn.parent != null)
                     {
                        controls.toggleButtons(false);
                     }
                  },10000);
               }
               break;
            case "ranks_btn":
               if(GameMenu.menu_array.indexOf(this.gameMain.rankMenu) == -1)
               {
                  this.gameMain.createRankMenu();
               }
               break;
            case "energy_btn":
               this.gameMain.createEnergyMenu();
               break;
            case "debug_image":
               if(this.gameMain.debugMenu == null || this.gameMain.debugMenu.parent == null)
               {
                  this.gameMain.createDebugMenu();
                  this.gameMain.debugCommand("tellCommands");
               }
               break;
            case "shortcutKey_btn":
               this.gameMain.shortcutItem = this.gameMain.itemMenu.item_txt.text;
               this.gameMain.save_sharedObject.data.shortcutItem = this.gameMain.shortcutItem;
               try
               {
                  this.gameMain.save_sharedObject.flush();
               }
               catch(_error:Error)
               {
               }
               break;
            case "givePresent_btn":
               receiverPlayer = Person(CommonCalls.returnObject(this.gameMain.p_array,this.gameMain.cMenu.personName));
               if(this.gameMain.player.lev >= 100)
               {
                  if(StarlingGameMenu.menu_array.indexOf(this.gameMain.presentMenu) == -1)
                  {
                     if(receiverPlayer != null)
                     {
                        if(receiverPlayer.lev >= 100)
                        {
                           this.gameMain.createPresentMenu(this.gameMain.cMenu.personName);
                        }
                        else
                        {
                           this.gameMain.createAlert(receiverPlayer.name + " must be level 100 or higher to receive tickets.");
                        }
                     }
                     else
                     {
                        this.gameMain.createAlert(this.gameMain.cMenu.personName + " has left area, cannot give tickets");
                     }
                  }
                  else
                  {
                     StarlingGameMenu.focusMenu(this.gameMain.presentMenu,true);
                  }
               }
               else
               {
                  this.gameMain.createAlert("You must be above level 100 to give ticket presents.");
               }
               break;
            case "presentTicketsMinus_btn":
               this.gameMain.presentMenu.minusTicket();
               break;
            case "presentTicketsPlus_btn":
               this.gameMain.presentMenu.addTicket();
               break;
            case "presentConfirm_btn":
               if(StarlingGameMenu.menu_array.indexOf(this.gameMain.tradeMenu) == -1)
               {
                  if(CommonCalls.returnObject(this.gameMain.p_array,this.gameMain.presentMenu.receiverName) != null && this.gameMain.presentMenu.ticketsOffered > 0)
                  {
                     _target.visible = false;
                     this.gameMain.theConnection.send("givePresent",this.gameMain.presentMenu.receiverName,this.gameMain.presentMenu.ticketsOffered);
                     StarlingGameMenu.removeFocusMenu();
                     this.gameMain.player.tickets -= this.gameMain.presentMenu.ticketsOffered;
                  }
                  else if(CommonCalls.returnObject(this.gameMain.p_array,this.gameMain.presentMenu.receiverName) != null && this.gameMain.presentMenu.ticketsOffered == 0)
                  {
                     this.gameMain.createAlert("you cannot offer 0 tickets");
                  }
                  else
                  {
                     this.gameMain.createAlert(this.gameMain.presentMenu.receiverName + " is no longer present in the area");
                     StarlingGameMenu.removeFocusMenu();
                  }
               }
               else
               {
                  this.gameMain.createAlert("cannot give present while trading");
               }
               break;
            case "report_btn":
               navigateToURL(new URLRequest("http://helmet-heroes.com/forum/viewforum.php?f=10"));
               break;
            case "skills_btn":
               if(StarlingGameMenu.menu_array.indexOf(this.gameMain.skillsMenu) == -1)
               {
                  StarlingGameMenu.removeFocusMenu();
                  this.gameMain.createSkillsMenu();
               }
               else
               {
                  StarlingGameMenu.focusMenu(this.gameMain.skillsMenu,true);
               }
               break;
            case "trade_btn":
               _target.visible = false;
               this.gameMain.theConnection.send("giTRequest",this.gameMain.cMenu.personName);
               this.gameMain.createAlert("Trade request has been sent to " + this.gameMain.cMenu.personName,true);
               break;
            case "addFriend_btn":
               this.gameMain.findDBNamePrefix(this.gameMain.cMenu.personName,function(param1:String):void
               {
                  gameMain.addUserByString(param1 + gameMain.cMenu.personName,FriendMenu.FRIENDS);
               });
               this.gameMain.cMenu.add_btn.removeFromParent(true);
               break;
            case "unFriend_btn":
               this.gameMain.removeUserByString(FriendMenu.getUserFullString(this.gameMain.friendMenu.friendName_txt.text),this.gameMain.friendMenu.title_txt.text.toLowerCase());
               break;
            case "chat_btn":
               this.gameMain.checkCreatePMMenu(this.gameMain.friendMenu.friendName_txt.text,true);
               break;
            case "friendsTab_btn":
               this.gameMain.friendMenu.updateMe(this.gameMain.theClient,FriendMenu.FRIENDS,true);
               break;
            case "guildTab_btn":
               this.gameMain.friendMenu.updateMe(this.gameMain.theClient,FriendMenu.GUILD,true,this.gameMain.player.guild);
               break;
            case "fishMap_btn":
               _target.visible = false;
               this.gameMain.theClient.bigDB.loadRange("shinyFishData","serverIndex",[this.gameMain.serverName],0,0,50,this.gameMain.mapMenu.shinyFishMapLoaded);
               break;
            case "fishList_btn":
               if(GameMenu.menu_array.indexOf(this.gameMain.fishListMenu) == -1)
               {
                  this.gameMain.createFishListMenu();
               }
               break;
            case "addFriendMenu_btn":
               this.gameMain.friendMenu.showAddPanel();
               break;
            case "addFriendString_btn":
               this.gameMain.findDBNamePrefix(this.gameMain.friendMenu.enterName_txt.text,function(param1:String):void
               {
                  if(gameMain.friendMenu.enterName_txt.text.length > 0 && gameMain.friendMenu.enterName_txt.text.search(gameMain.validString) == -1)
                  {
                     gameMain.addUserByString(param1 + gameMain.friendMenu.enterName_txt.text,gameMain.friendMenu.title_txt.text.toLowerCase());
                  }
                  else
                  {
                     gameMain.createAlert("invalid username");
                  }
               });
               break;
            case "basicSkills_btn":
               this.gameMain.skillsMenu.displaySkills("basic");
               break;
            case "warriorSkills_btn":
               this.gameMain.skillsMenu.displaySkills("warrior");
               break;
            case "archerSkills_btn":
               this.gameMain.skillsMenu.displaySkills("archer");
               break;
            case "wizardSkills_btn":
               this.gameMain.skillsMenu.displaySkills("wizard");
               break;
            case "cowboySkills_btn":
               this.gameMain.skillsMenu.displaySkills("cowboy");
               break;
            case "buyMoneyItemStorage_btn":
               StarlingGameMenu.removeFocusMenu();
               this.gameMain.createPVMenu();
               break;
            case "energyTotalPlus_btn":
               eTotalCost = Math.pow(2 + this.gameMain.player.energyController.totalMax * 5,8);
               if(this.gameMain.player.money >= eTotalCost)
               {
                  this.gameMain.player.money -= eTotalCost;
                  this.gameMain.player.energyController.totalMax += 0.1;
                  this.gameMain.theConnection.send("ePoint","total");
                  this.gameMain.energyMenu.updateMe(this.gameMain.player);
               }
               else
               {
                  this.gameMain.createAlert("You do not have enough money to update your total max energy.");
               }
               break;
            case "energyChargePlus_btn":
               eChargeCost = Math.pow(2 + this.gameMain.player.energyController.chargeMax * 5,8);
               if(this.gameMain.player.money >= eChargeCost)
               {
                  this.gameMain.player.money -= eChargeCost;
                  this.gameMain.player.energyController.chargeMax += 0.1;
                  this.gameMain.theConnection.send("ePoint","charge");
                  this.gameMain.energyMenu.updateMe(this.gameMain.player);
               }
               else
               {
                  this.gameMain.createAlert("You do not have enough money to update your max charge.");
               }
               break;
            case "energyAbsorbedPlus_btn":
               eAbsorbedCost = Math.pow(2 + this.gameMain.player.energyController.absorbedMax * EnergyController.ABSORBED_WEIGHT,8);
               if(this.gameMain.player.money >= eAbsorbedCost)
               {
                  this.gameMain.player.money -= eAbsorbedCost;
                  this.gameMain.player.energyController.absorbedMax += 0.1;
                  this.gameMain.theConnection.send("ePoint","absorbed");
                  this.gameMain.energyMenu.updateMe(this.gameMain.player);
               }
               else
               {
                  this.gameMain.createAlert("You do not have enough money to update your absorbed max energy.");
               }
               break;
            case "energyLevelPlus_btn":
               eLevelCost = Math.pow(2 + this.gameMain.player.energyController.levelMax * EnergyController.LEVEL_WEIGHT,8);
               if(this.gameMain.player.money >= eLevelCost)
               {
                  this.gameMain.player.money -= eLevelCost;
                  this.gameMain.player.energyController.levelMax += 0.1;
                  this.gameMain.theConnection.send("ePoint","level");
                  this.gameMain.energyMenu.updateMe(this.gameMain.player);
               }
               else
               {
                  this.gameMain.createAlert("You do not have enough money to update your level max energy.");
               }
               break;
            case "energyEnemyPlus_btn":
               eEnemyCost = Math.pow(2 + this.gameMain.player.energyController.enemyMax * EnergyController.ENEMY_WEIGHT,8);
               if(this.gameMain.player.money >= eEnemyCost)
               {
                  this.gameMain.player.money -= eEnemyCost;
                  this.gameMain.player.energyController.enemyMax += 0.1;
                  this.gameMain.theConnection.send("ePoint","enemy");
                  this.gameMain.energyMenu.updateMe(this.gameMain.player);
               }
               else
               {
                  this.gameMain.createAlert("You do not have enough money to update your enemy max energy.");
               }
               break;
            case "energyPvpPlus_btn":
               ePvpCost = Math.pow(2 + this.gameMain.player.energyController.pvpMax * EnergyController.PVP_WEIGHT,8);
               if(this.gameMain.player.money >= ePvpCost)
               {
                  this.gameMain.player.money -= ePvpCost;
                  this.gameMain.player.energyController.pvpMax += 0.1;
                  this.gameMain.theConnection.send("ePoint","pvp");
                  this.gameMain.energyMenu.updateMe(this.gameMain.player);
               }
               else
               {
                  this.gameMain.createAlert("You do not have enough money to update your pvp max energy.");
               }
               break;
            case "energyRandomPlus_btn":
               eRandomCost = Math.pow(2 + this.gameMain.player.energyController.randomMax * EnergyController.RANDOM_WEIGHT,8);
               if(this.gameMain.player.money >= eRandomCost)
               {
                  this.gameMain.player.money -= eRandomCost;
                  this.gameMain.player.energyController.randomMax += 0.1;
                  this.gameMain.theConnection.send("ePoint","random");
                  this.gameMain.energyMenu.updateMe(this.gameMain.player);
               }
               else
               {
                  this.gameMain.createAlert("You do not have enough money to update your random max energy.");
               }
               break;
            case "energyRagePlus_btn":
               eRageCost = Math.pow(2 + this.gameMain.player.energyController.rageMax * EnergyController.RAGE_WEIGHT,8);
               if(this.gameMain.player.money >= eRageCost)
               {
                  this.gameMain.player.money -= eRageCost;
                  this.gameMain.player.energyController.rageMax += 0.1;
                  this.gameMain.theConnection.send("ePoint","rage");
                  this.gameMain.energyMenu.updateMe(this.gameMain.player);
               }
               else
               {
                  this.gameMain.createAlert("You do not have enough money to update your rage max energy.");
               }
               break;
            case "energyChopPlus_btn":
               eChopCost = Math.pow(2 + this.gameMain.player.energyController.chopMax * EnergyController.CHOP_WEIGHT,8);
               if(this.gameMain.player.money >= eChopCost)
               {
                  this.gameMain.player.money -= eChopCost;
                  this.gameMain.player.energyController.chopMax += 0.1;
                  this.gameMain.theConnection.send("ePoint","chop");
                  this.gameMain.energyMenu.updateMe(this.gameMain.player);
               }
               else
               {
                  this.gameMain.createAlert("You do not have enough money to update your chop max energy.");
               }
               break;
            case "energyFishPlus_btn":
               eFishCost = Math.pow(2 + this.gameMain.player.energyController.fishMax * EnergyController.FISH_WEIGHT,8);
               if(this.gameMain.player.money >= eFishCost)
               {
                  this.gameMain.player.money -= eFishCost;
                  this.gameMain.player.energyController.fishMax += 0.1;
                  this.gameMain.theConnection.send("ePoint","fish");
                  this.gameMain.energyMenu.updateMe(this.gameMain.player);
               }
               else
               {
                  this.gameMain.createAlert("You do not have enough money to update your fish max energy.");
               }
               break;
            case "next_btn":
               this.gameMain.handleText();
               this.gameMain.stage.focus = null;
               break;
            case "sell_btn":
               this.gameMain.talkBox.talk_txt.text = this.gameMain.talkBox.fullText_string;
               this.gameMain.handleText();
               this.gameMain.createItemMenu("sale",this.gameMain.personItem_array);
               break;
            case "shop_btn":
               this.gameMain.talkBox.talk_txt.text = this.gameMain.talkBox.fullText_string;
               this.gameMain.handleText();
               if(this.gameMain.c_mc.currentFrame == 7)
               {
                  if(TalkBox(_target.parent).personClone.name == "Sales Man")
                  {
                     this.gameMain.createItemMenu("buy",Vector.<String>(["blue beanie","red beanie","red shirt","brown shoe","blue jeans","green pants","yellow pants","paper bag","clover hat","half coconut","half ski mask","full ski mask","archer hat","red plastic sword","blue plastic sword","plastic saber","hammer","sickle","apple","small bow","bronze dagger","banana","airsoft gun","paintball gun","paper hat","koon hat","detective hat","cowboy hat","cowboy shirt","cowboy pants"]));
                  }
                  else
                  {
                     this.gameMain.createItemMenu("buy",Vector.<String>(["crumby wizard hat","brown wizard robe","brown wizard pants","red wizard robe","red wizard pants","red wizard hat","blue wizard hat","blue wizard belt hat","basic wand","star wand","basic magic staff","leaf bow","triple leaf bow","medium bow","leaf pad bow","thorn bow","elf shoe","elf bell shoe","sai","fireman hatchet","shaman wand","shaman staff","archaic helmet","archaic armor","archaic legs","archaic bow","bb gun","pirate vest","pirate pants","pirate hat"]));
                  }
               }
               else if(this.gameMain.c_mc.currentFrame == 58)
               {
                  if(TalkBox(_target.parent).personClone.name == "Sam Shoe")
                  {
                     this.gameMain.createItemMenu("buy",Vector.<String>(["blue magic shoe","cursed shoe","cowboy boot","double bell shoe","pirate boot","steel boot","magnesium boot","zinc boot","future boot","spiked dino boot","blue crystal boot","pink crystal boot","chemical boot","assault boot","imperial boot","achilles boot","relic boot","beholder boot","element boot","archaic boot","skull crusher boot","earth boot","valor boot","serpent boot","acid boot","bladed boot","mystical tribal boot"]));
                  }
                  else
                  {
                     this.gameMain.createItemMenu("buy",Vector.<String>(["hydro tech boot","atomic boot","cyro boot","magma boot","millennium boot","empowered boot","corruption boot"]));
                  }
               }
               else if(this.gameMain.c_mc.currentFrame == 20)
               {
                  this.gameMain.createItemMenu("buy",Vector.<String>(["hair flower","charm hat","cat hat","ballerina outfit","metal ballerina outfit","ballerina stockings","metal ballerina legs","metal cat helmet","pink crystal helmet","pink crystal armor","pink crystal legs","crystal heart shield","umbrella"]));
               }
               else if(this.gameMain.c_mc.currentFrame == 120)
               {
                  this.gameMain.createItemMenu("buy",Vector.<String>(["watermelon","half coconut","coconut helmet","suit","suit pants","green shoe","wooden bat","machete","rusty scimitar","coconut armor","coconut knee pads","coconut leaves helmet","wood scrap shield","short sword","sledgehammer","log splitting axe","pickaxe","leaf bow","triple leaf bow","archer shirt","archer pants","banana","element helmet","element armor","element legs","element wand","element staff","potato gun","handgun","cowboy belt hat"]));
               }
               else if(this.gameMain.c_mc.currentFrame == 123)
               {
                  this.gameMain.createItemMenu("buy",Vector.<String>(["book of power","book of magic","book of range","book of artillery","book of dexterity","book of health","book of MP","book of defense","book of skill"]));
               }
               else if(this.gameMain.c_mc.currentFrame == 121)
               {
                  this.gameMain.createItemMenu("buy",Vector.<String>(["wood scrap shield","garbage can lid","stop sign","smiley tin shield","wood metal shield","bronze shield","protector shield","stone shield","crystal heart shield","ancient shield","future shield","dino shield","robot shield","beholder shield","skull crusher shield","acid shield","kreeton shield","bladed shield","cyro shield","ultra shield","magma shield","god shield"]));
               }
               else if(this.gameMain.c_mc.currentFrame == 65)
               {
                  this.gameMain.createItemMenu("buy",Vector.<String>(["leather helmet","racing helmet","army helmet","roman helmet","blue face helmet","sugarloaf helmet","single sphere wand","blue sphere staff","sythe","single battle axe","teardrop blade","halberd","death bringer","guardians warhammer","roman robe","roman leggings","leather archer armor","archer leather legs","leather armor","leather legs","chainmail","chainmail legs"]));
               }
               else if(this.gameMain.c_mc.currentFrame == 16)
               {
                  this.gameMain.createItemMenu("buy",Vector.<String>(["meat cleaver","archer patches hat","spartan helmet","knight helmet","magician armor","magician armor legs","bronze plate armor","bronze plate legs","knight armor","knight armor legs","natures staff","nightingale wand","nightingale staff","chunk mace","two handed mace","mega sword","rich mans bow","angels wings bow","mechanic wing bow","strong basket helmet","revolver","mac10","mp5","mexican shirt","mexican pants","sombrero","koon outfit","koon pants","koon hat","masked cowboy hat"]));
               }
               else if(this.gameMain.c_mc.currentFrame == 111)
               {
                  this.gameMain.createItemMenu("buy",Vector.<String>(["wooden spear","skull spear","eagle staff","apollos helmet","apollos armor","apollos armor legs","stone helmet","stone armor","stone armor legs","gold helmet","gold plate armor","gold plate legs","witch hat","blue wizard robe","blue wizard pants","fish scale armor","fish scale legs","super hero shirt","shades","reptile wand","single godly blade","banana","apple","watermelon","alloy wolf helmet","shotgun","tommy gun","es c90","ak47","chemical mask"]));
               }
               else if(this.gameMain.c_mc.currentFrame == 79)
               {
                  if(TalkBox(_target.parent).personClone.name == "Chance")
                  {
                     this.gameMain.createItemMenu("buy",Vector.<String>(["strong full helmet","wizard hat mask","enchanted helmet","crusader helmet","ancient helmet","ancient armor","ancient legs","strong armor","strong legs","winged diamond wand","enchanted armor","enchanted legs","natures bow","heartstriker bow","night glow bow","mushroom helmet","bat wing staff","chain helmet","chain armor","chain legs","hybrid helmet","skull crusher helmet","skull crusher armor","skull crusher legs","pointed pirate hat","steel masked helmet","cowboy knight helmet"]));
                  }
                  else
                  {
                     this.gameMain.createItemMenu("buy",Vector.<String>(["demons fury","ice hammer","ancient battle axe","captains rapier","electric infuriator","axe of minions","electric katana","ice blade of gods","barbarian axe of fire","reapers scythe","crypt bow of fire","snout zinc helmet","zinc armor","zinc legs","adamantium helmet","magnesium helmet","adamantium armor","adamantium legs","magnesium armor","magnesium legs","beholder wand","beholder staff","beholder bow","beholder sword","beholder axe","small skull crusher","skull crusher","M16","sniper rifle"]));
                  }
               }
               else if(this.gameMain.c_mc.currentFrame == 83)
               {
                  this.gameMain.createItemMenu("buy",Vector.<String>(["reinforced bush armor","reinforced bush legs","flak jacket","sorcerer robe","jester shirt","sorcerer pants","jester pants","sorcerer hat and glasses","sorcerer copter hat","jester hat","ocean staff","night glow wand","tropical staff","horned helmet","green face helmet","steel helmet hat","cone helmet","ghost mask","cursed robe","cursed pants","diamond studded bow","spiked shell helmet","banana","apple","achilles armor","achilles legs","achilles helmet","relic armor","relic legs","relic helmet"]));
               }
               else if(this.gameMain.c_mc.currentFrame == 26)
               {
                  this.gameMain.createItemMenu("buy",Vector.<String>(["royal helmet","protector helmet","dino scale helmet","samurai helmet","helmet of hatred","imperial helmet","dino scale armor","royal armor","protector suit","samurai armor","armor of hatred","imperial armor","royal legs","protector legs","dino scale legs","samurai legs","legs of hatred","imperial legs","spherical staff","frosters bow","light sword","single hatred blade","blade of hatred","heated staff","dino blade","wand of blessings","fallen queens spectre","cyborg bow","frosting trident","mummified axe"]));
               }
               else if(this.gameMain.c_mc.currentFrame == 117)
               {
                  this.gameMain.createItemMenu("buy",Vector.<String>(["blue crystal helmet","future helmet","lazer shades","assault helmet","robot helmet","cyborg helmet","neon magic helmet","astro helmet","industrial helmet","mocap suit","blue crystal armor","future armor","assault armor","robot armor","neon magic suit","cyborg armor","astro suit","industrial armor","future legs","blue crystal legs","mocap pants","assault legs","robot legs","cyborg legs","neon magic legs","astro legs","industrial legs","eagle slingshot","flaming needle bow","indian wand"]));
               }
               else if(this.gameMain.c_mc.currentFrame == 74)
               {
                  this.gameMain.createItemMenu("buy",Vector.<String>(["apple","banana","watermelon","turkey","chemical armor","chemical legs","valor helmet","valor armor","valor legs","pirate helmet","pirate armor","pirate armor legs","eye patch","cowboy knight armor","cowboy knight legs"]));
               }
               else if(this.gameMain.c_mc.currentFrame == 133)
               {
                  this.gameMain.createItemMenu("buy",Vector.<String>(["harpoon bow","analytic wand","analytic staff","serpent wand","serpent staff","acidic sword","two hand acid blade","acid shield","thors hammer","deep sea helmet","earth helmet","analytic helmet","serpent helmet","titanium helmet","titanium armor","titanium legs","earth armor","earth legs","analytic armor","analytic legs","serpent armor","serpent legs","acidic helmet","acidic armor","acidic legs","xm8 rifle","machine gun","chaingun","bazooka","rayon gun"]));
               }
               else if(this.gameMain.c_mc.currentFrame == 129)
               {
                  this.gameMain.createItemMenu("buy",Vector.<String>(["pet mystical tribal helmet","pet hydro tech helmet","pet atomic helmet","pet cyro helmet"]));
               }
               else if(this.gameMain.c_mc.currentFrame == 128)
               {
                  this.gameMain.createItemMenu("buy",Vector.<String>(["pet striped beanie","pet bowtie","pet melon helmet","pet oriental hat","pet archer hat","pet crumby hat","pet cowboy hat","pet army helmet","pet wizard hat","pet witch hat","pet pirate hat","pet spartan helmet","pet stone helmet","pet apollo helmet","pet strong helmet","pet protector helmet","pet samurai helmet","pet jester hat","pet horned helmet","pet cone helmet","pet adamantium helmet","pet dino scale helmet","pet cyborg helmet","pet valor helmet","pet element helmet","pet beholder helmet","pet earth helmet","pet serpent helmet","pet acid helmet","pet pirate helmet"]));
               }
               else if(this.gameMain.c_mc.currentFrame == 39)
               {
                  this.gameMain.createItemMenu("buy",Vector.<String>(["beholder boot","beholder sword","beholder axe","kreeton helmet","kreeton armor","kreeton legs","kreeton cutter","eye of kreeton","darkane hood helmet","darkane armor","darkane legs","darkane wand","darkane staff","repguana helmet","repguana armor","repguana legs","repguana bow","bladed helmet","bladed armor","bladed legs","brooding fire axe","electric barracuda","skullcrusher gun","beholder gun","kreeton gun"]));
               }
               else if(this.gameMain.c_mc.currentFrame == 92)
               {
                  this.gameMain.createItemMenu("buy",Vector.<String>(["fishing pole"]));
               }
               break;
            case "kick_btn":
               fullNameKey = "";
               len = int(CommonCalls.returnObject(GuildMenu.guilds_array,this.gameMain.guildMemberMenu.guild).memberDisplayNames.length);
               i = 0;
               while(i < len)
               {
                  if(CommonCalls.returnObject(GuildMenu.guilds_array,this.gameMain.guildMemberMenu.guild).memberDisplayNames[i] == this.gameMain.guildMemberMenu.memberName_txt.text)
                  {
                     fullNameKey = CommonCalls.returnObject(GuildMenu.guilds_array,this.gameMain.guildMemberMenu.guild).mArray[i];
                     break;
                  }
                  i++;
               }
               this.gameMain.createAlert(this.gameMain.guildMemberMenu.memberName_txt.text + " has been kicked out of the guild");
               this.gameMain.theConnection.send("kickGMem",fullNameKey,this.gameMain.guildMemberMenu.guild);
               len = int(CommonCalls.returnObject(GuildMenu.guilds_array,this.gameMain.guildMemberMenu.guild).mArray.length);
               i = 0;
               while(i < len)
               {
                  if(CommonCalls.returnObject(GuildMenu.guilds_array,this.gameMain.guildMemberMenu.guild).mArray[i] == fullNameKey)
                  {
                     CommonCalls.returnObject(GuildMenu.guilds_array,this.gameMain.guildMemberMenu.guild).mArray.removeAt(i);
                     CommonCalls.returnObject(GuildMenu.guilds_array,this.gameMain.guildMemberMenu.guild).memberDisplayNames.removeAt(i);
                     CommonCalls.returnObject(GuildMenu.guilds_array,this.gameMain.guildMemberMenu.guild).cArray.removeAt(i);
                     break;
                  }
                  i++;
               }
               this.gameMain.guildMemberMenu.setSelectedMemberBlank();
               break;
            case "deny_btn":
               fullNameKey2 = "";
               len = int(CommonCalls.returnObject(GuildMenu.guilds_array,this.gameMain.guildMemberMenu.guild).pendingMemberDisplayNames.length);
               i = 0;
               while(i < len)
               {
                  if(CommonCalls.returnObject(GuildMenu.guilds_array,this.gameMain.guildMemberMenu.guild).pendingMemberDisplayNames[i] == this.gameMain.guildMemberMenu.memberName_txt.text)
                  {
                     fullNameKey2 = CommonCalls.returnObject(GuildMenu.guilds_array,this.gameMain.guildMemberMenu.guild).pendingMembers_array[i];
                     break;
                  }
                  i++;
               }
               this.gameMain.theConnection.send("denyGuild",fullNameKey2,this.gameMain.guildMemberMenu.guild);
               len = int(CommonCalls.returnObject(GuildMenu.guilds_array,this.gameMain.guildMemberMenu.guild).pendingMembers_array.length);
               i = 0;
               while(i < len)
               {
                  if(CommonCalls.returnObject(GuildMenu.guilds_array,this.gameMain.guildMemberMenu.guild).pendingMembers_array[i] == this.gameMain.guildMemberMenu.memberName_txt.text)
                  {
                     CommonCalls.returnObject(GuildMenu.guilds_array,this.gameMain.guildMemberMenu.guild).pendingMembers_array.removeAt(i);
                     CommonCalls.returnObject(GuildMenu.guilds_array,this.gameMain.guildMemberMenu.guild).pendingMemberDisplayNames.removeAt(i);
                     break;
                  }
                  i++;
               }
               this.gameMain.guildMemberMenu.setSelectedMemberBlank();
               break;
            case "allowJoin_btn":
               fullKey = "";
               len = int(CommonCalls.returnObject(GuildMenu.guilds_array,this.gameMain.guildMemberMenu.guild).pendingMemberDisplayNames.length);
               i = 0;
               while(i < len)
               {
                  if(Person.removeNamePrefix(CommonCalls.returnObject(GuildMenu.guilds_array,this.gameMain.guildMemberMenu.guild).pendingMemberDisplayNames[i]) == this.gameMain.guildMemberMenu.memberName_txt.text)
                  {
                     fullKey = CommonCalls.returnObject(GuildMenu.guilds_array,this.gameMain.guildMemberMenu.guild).pendingMembers_array[i];
                     break;
                  }
                  i++;
               }
               this.gameMain.theConnection.send("acceptJoin",this.gameMain.guildMemberMenu.guild,fullKey);
               CommonCalls.returnObject(GuildMenu.guilds_array,this.gameMain.guildMemberMenu.guild).mArray.push(fullKey);
               CommonCalls.returnObject(GuildMenu.guilds_array,this.gameMain.guildMemberMenu.guild).memberDisplayNames.push(this.gameMain.guildMemberMenu.memberName_txt.text);
               CommonCalls.returnObject(GuildMenu.guilds_array,this.gameMain.guildMemberMenu.guild).cArray.push(0);
               len = int(CommonCalls.returnObject(GuildMenu.guilds_array,this.gameMain.guildMemberMenu.guild).pendingMembers_array.length);
               i = 0;
               while(i < len)
               {
                  if(CommonCalls.returnObject(GuildMenu.guilds_array,this.gameMain.guildMemberMenu.guild).pendingMemberDisplayNames[i] == this.gameMain.guildMemberMenu.memberName_txt.text)
                  {
                     CommonCalls.returnObject(GuildMenu.guilds_array,this.gameMain.guildMemberMenu.guild).pendingMembers_array.removeAt(i);
                     CommonCalls.returnObject(GuildMenu.guilds_array,this.gameMain.guildMemberMenu.guild).pendingMemberDisplayNames.removeAt(i);
                     break;
                  }
                  i++;
               }
               this.gameMain.guildMemberMenu.setSelectedMemberBlank();
               if(CommonCalls.returnObject(GuildMenu.guilds_array,this.gameMain.guildMemberMenu.guild).mArray.length >= 40)
               {
                  _target.visible = false;
               }
               break;
            case "equip_btn":
               if(Stats.getItemType(this.gameMain.itemMenu.item_txt.text) != "weapon")
               {
                  this.equipCheck(true);
               }
               else if(Stats.getItemType(this.gameMain.itemMenu.item_txt.text) == "weapon" && Stats.wStats[this.gameMain.itemMenu.item_txt.text].defense == 0)
               {
                  if(Boolean(Stats.getItemType(this.gameMain.itemMenu.item_txt.text) == "weapon") && Boolean(Stats.wStats[this.gameMain.itemMenu.item_txt.text].twoHanded) && this.gameMain.player.isDualGunWeapon(this.gameMain.itemMenu.item_txt.text) == false)
                  {
                     this.equipCheck(true);
                  }
                  else if(Stats.getItemType(this.gameMain.itemMenu.item_txt.text) == "weapon")
                  {
                     this.gameMain.itemMenu.showDualWieldMenu();
                  }
               }
               else if(Stats.getItemType(this.gameMain.itemMenu.item_txt.text) == "weapon" && Stats.wStats[this.gameMain.player.bodyAnimator.weaponString].defense == 0)
               {
                  if(Stats.wStats[this.gameMain.player.bodyAnimator.weaponString].twoHanded)
                  {
                     this.gameMain.createAlert("cannot equip a shield with a two handed weapon");
                  }
                  else
                  {
                     if(this.gameMain.player.lev >= Stats.getItemArray(Stats.getItemType(this.gameMain.itemMenu.item_txt.text))[this.gameMain.itemMenu.item_txt.text].reqLev)
                     {
                        this.gameMain.equipItem(this.gameMain.player.bodyAnimator.weaponString,false);
                     }
                     this.equipCheck(true);
                  }
               }
               else if(Stats.getItemType(this.gameMain.itemMenu.item_txt.text) == "weapon" && Stats.wStats[this.gameMain.player.bodyAnimator.weaponString].defense > 0)
               {
                  this.equipCheck(true);
               }
               break;
            case "unEquip_btn":
               tempItemType = Stats.getItemType(this.gameMain.itemMenu.item_txt.text);
               if(tempItemType == "accessory" || tempItemType == "helmet" || tempItemType == "weapon" && this.gameMain.player.bodyAnimator.weaponString != "none" && this.gameMain.player.bodyAnimator.weapon2String != "none" && (Stats.wStats[this.gameMain.player.bodyAnimator.weaponString].defense == 0 || Stats.wStats[this.gameMain.itemMenu.item_txt.text].defense > 0))
               {
                  this.gameMain.theConnection.send("giUnEquip",this.gameMain.itemMenu.item_txt.text,Stats.getItemType(this.gameMain.itemMenu.item_txt.text),false);
                  this.gameMain.itemMenu.updateMe(this.gameMain.maxItems,this.gameMain.personItem_array,this.gameMain.player,true);
                  SoundManager.playSound(SoundLibrary.unEquip_sound);
               }
               else
               {
                  this.gameMain.createAlert("cannot unequip " + this.gameMain.itemMenu.item_txt.text + ": must have a " + tempItemType + " equipped at all times");
               }
               break;
            case "drop_btn":
               if(this.gameMain.itemMenu.canSellItem(this.gameMain.itemMenu.item_txt.text))
               {
                  SoundManager.playSound(SoundLibrary.itemSold_sound);
                  this.gameMain.theConnection.send("giCreNewI",this.gameMain.itemMenu.item_txt.text,this.gameMain.player.x,this.gameMain.player.y);
                  this.gameMain.arrayStringRemove(this.gameMain.personItem_array,this.gameMain.itemMenu.item_txt.text);
                  this.gameMain.itemMenu.updateMe(this.gameMain.maxItems,this.gameMain.personItem_array,this.gameMain.player,true);
               }
               else
               {
                  this.gameMain.createAlert("cannot drop this item");
               }
               break;
            case "buy_btn":
               if(this.gameMain.personItem_array.length < this.gameMain.maxItems)
               {
                  if(this.gameMain.itemMenu.menuType != "vendor")
                  {
                     this.gameMain.theConnection.send("buyItem",this.gameMain.itemMenu.item_txt.text);
                  }
                  else if(this.gameMain.itemMenu.vendorName != this.gameMain.theClient.connectUserId)
                  {
                     tempSelectedIndex = this.gameMain.itemMenu.getSelectedIndex();
                     if(this.gameMain.player.money >= VendingMachine(this.c_mc.getChildByName(this.gameMain.itemMenu.vendorKey)).costs[tempSelectedIndex])
                     {
                        this.gameMain.theConnection.addMessageHandler("boughtVItem",this.gameMain.boughtVendorItem);
                        this.gameMain.theConnection.send("buyVItem",this.gameMain.itemMenu.vendorKey,tempSelectedIndex);
                        SetHue.tintObject(this.gameMain.itemMenu,16777215);
                        _target.visible = false;
                     }
                     else
                     {
                        this.gameMain.createAlert("You do not have enough money");
                     }
                  }
                  else
                  {
                     this.gameMain.createAlert("you cannot buy from your own vending machine");
                  }
               }
               else
               {
                  this.gameMain.createAlert("max amount of items");
               }
               break;
            case "sellItem_btn":
               if(this.gameMain.itemMenu.canSellItem(this.gameMain.itemMenu.item_txt.text))
               {
                  SoundManager.playSound(SoundLibrary.cashRegister_sound);
                  this.gameMain.theConnection.send("sellI",this.gameMain.itemMenu.item_txt.text,true);
                  this.gameMain.arrayStringRemove(this.gameMain.personItem_array,this.gameMain.itemMenu.item_txt.text);
                  this.gameMain.itemMenu.updateMe(this.gameMain.maxItems,this.gameMain.personItem_array,this.gameMain.player,true);
               }
               else
               {
                  this.gameMain.createAlert("cannot sell equipped items");
               }
               break;
            case "vend_btn":
               isHittingATM = false;
               len = this.c_mc.numChildren;
               i = 0;
               while(i < len)
               {
                  if(this.c_mc.getChildAt(i) is VendingMachine && Person.removeNamePrefix(VendingMachine(this.c_mc.getChildAt(i)).sellerName) == this.gameMain.player.name && this.gameMain.player.hitTester.hit_rect.intersects(this.c_mc.getChildAt(i).getBounds(this.c_mc)))
                  {
                     this.gameMain.itemMenu.showVendorSellPanel();
                     isHittingATM = true;
                     break;
                  }
                  i++;
               }
               if(!isHittingATM)
               {
                  i = 0;
                  while(i < len)
                  {
                     if(this.c_mc.getChildAt(i) is ATM && this.gameMain.player.gravityObject.hit_rect.intersects(this.c_mc.getChildAt(i).getBounds(this.c_mc)))
                     {
                        isHittingATM = true;
                        break;
                     }
                     i++;
                  }
                  if(isHittingATM)
                  {
                     _target.visible = this.gameMain.itemMenu.drop_btn.visible = false;
                     this.gameMain.itemMenu.alpha = 0.5;
                     this.gameMain.itemMenu.touchable = false;
                     this.gameMain.theConnection.send("bankItemDep",this.gameMain.itemMenu.item_txt.text);
                     this.gameMain.theConnection.addMessageHandler("tryBankItemDep",this.gameMain.itemDepositDone);
                  }
               }
               break;
            case "primary_btn":
               this.equipCheck(true);
               break;
            case "secondary_btn":
               this.equipCheck(false);
               break;
            case "use_btn":
               this.gameMain.useItem(this.gameMain.itemMenu.item_txt.text);
               break;
            case "heroBack_btn":
               this.gameMain.heroMenu.gotoMain();
               break;
            case "addVItem_btn":
               len = this.c_mc.numChildren;
               i = 0;
               while(i < len)
               {
                  if(this.c_mc.getChildAt(i) is VendingMachine && Person.removeNamePrefix(VendingMachine(this.c_mc.getChildAt(i)).sellerName) == this.gameMain.player.name)
                  {
                     if(this.gameMain.player.hitTester.hit_rect.intersects(this.c_mc.getChildAt(i).getBounds(this.gameMain.starlingStage.c_mc)))
                     {
                        if(VendingMachine(this.c_mc.getChildAt(i)).items.length < 8 && Stats.getItemArray(Stats.getItemType(Fish.fishNoShinyName(this.gameMain.itemMenu.item_txt.text)))[Fish.fishNoShinyName(this.gameMain.itemMenu.item_txt.text)].cost > 0)
                        {
                           this.gameMain.createAlert("Your " + this.gameMain.itemMenu.item_txt.text + " has been added to the vending machine",true);
                           this.gameMain.theConnection.send("insertVItem",this.gameMain.itemMenu.item_txt.text,this.c_mc.getChildAt(i).name,uint(this.gameMain.itemMenu.itemPrice_txt.text));
                           this.gameMain.vectorStringRemove(this.gameMain.personItem_array,this.gameMain.itemMenu.item_txt.text);
                           this.gameMain.itemMenu.updateMe(this.gameMain.maxItems,this.gameMain.personItem_array,this.gameMain.player);
                           SoundManager.playSound(SoundLibrary.itemBought_sound);
                        }
                        else if(VendingMachine(this.c_mc.getChildAt(i)).items.length == 8)
                        {
                           this.gameMain.createAlert("vending machine is full, cannot insert item");
                        }
                        else
                        {
                           this.gameMain.createAlert("You cannot add this item to the machine");
                        }
                        i--;
                        break;
                     }
                  }
                  i++;
               }
               if(i == len)
               {
                  this.gameMain.createAlert("cannot insert item into vending machine");
               }
               break;
            case "vTickets_btn":
               if(uint(Number(this.gameMain.itemMenu.ticketsBuy_txt.text)) > 0)
               {
                  if(uint(this.gameMain.itemMenu.ticketsBuy_txt.text) <= VendingMachine(this.c_mc.getChildByName(this.gameMain.itemMenu.vendorKey)).tickets)
                  {
                     if(this.gameMain.player.money >= uint(this.gameMain.itemMenu.ticketsBuy_txt.text) * VendingMachine(this.c_mc.getChildByName(this.gameMain.itemMenu.vendorKey)).ticketPrice)
                     {
                        _target.visible = false;
                        this.gameMain.theConnection.send("buyVTickets",uint(this.gameMain.itemMenu.ticketsBuy_txt.text),this.gameMain.itemMenu.vendorKey);
                        StarlingGameMenu.removeFocusMenu();
                     }
                     else
                     {
                        this.gameMain.createAlert("You do not have enough money to buy " + uint(this.gameMain.itemMenu.ticketsBuy_txt.text) + " tickets");
                     }
                  }
                  else
                  {
                     this.gameMain.createAlert(uint(this.gameMain.itemMenu.ticketsBuy_txt.text) + " tickets are not available");
                  }
               }
               else
               {
                  this.gameMain.createAlert("must buy more than 1 ticket");
               }
               break;
            case "vendTickets_btn":
               if(uint(this.gameMain.itemMenu.ticketsBuy_txt.text) <= this.gameMain.player.tickets)
               {
                  VendingMachine(this.c_mc.getChildByName(this.gameMain.itemMenu.vendorKey)).tickets = VendingMachine(this.c_mc.getChildByName(this.gameMain.itemMenu.vendorKey)).tickets + uint(this.gameMain.itemMenu.ticketsBuy_txt.text);
                  VendingMachine(this.c_mc.getChildByName(this.gameMain.itemMenu.vendorKey)).ticketPrice = uint(this.gameMain.itemMenu.ticketsCost_txt.text);
                  this.gameMain.theConnection.send("vendTickets",uint(this.gameMain.itemMenu.ticketsBuy_txt.text),this.gameMain.itemMenu.vendorKey,uint(this.gameMain.itemMenu.ticketsCost_txt.text));
                  StarlingGameMenu.removeFocusMenu();
                  this.gameMain.createAlert("You have put " + this.gameMain.itemMenu.ticketsBuy_txt.text + " tickets into your vending machine",true);
               }
               else
               {
                  this.gameMain.createAlert("you do not have this many tickets");
               }
               break;
            case "petCompanion_btn":
               this.gameMain.petMenu.touchable = false;
               this.gameMain.createConfirmMenu("Are you sure you want to make " + this.gameMain.petMenu.selectedPetName + " your companion?","pet companion");
               break;
            case "petWithdraw_btn":
               _target.visible = false;
               this.gameMain.theConnection.send("togPetCon",false);
               this.gameMain.theConnection.send("petWithd",this.gameMain.petMenu.selectedPetName);
               this.controls.removePetControlBars(this.gameMain.petMenu.selectedPetName);
               break;
            case "petRelease_btn":
               this.gameMain.theConnection.send("togPetCon",false);
               this.gameMain.petMenu.touchable = false;
               this.gameMain.createConfirmMenu("Are you sure you want to release " + this.gameMain.petMenu.selectedPetName + "?  " + this.gameMain.petMenu.selectedPetName + " will be gone forever.","pet release");
               break;
            case "petMode_btn":
               if(StarlingGameMenu.menu_array.indexOf(this.gameMain.petModeMenu) == -1)
               {
                  if(DisplayObjectContainer(_target.parent) is PetMenu)
                  {
                     this.gameMain.createPetModeMenu(this.gameMain.petMenu.petClone.type,this.gameMain.petMenu.selectedPetName);
                  }
                  else
                  {
                     this.gameMain.createPetModeMenu(this.gameMain.petShopMenu.selectedType,"");
                  }
               }
               else
               {
                  StarlingGameMenu.focusMenu(this.gameMain.petModeMenu,true);
               }
               break;
            case "petEquip_btn":
               if(GameMenu.menu_array.indexOf(this.gameMain.petItemMenu) == -1)
               {
                  this.gameMain.createPetItemMenu(Pet(CommonCalls.returnObject(this.gameMain.player.pet_array,this.gameMain.petMenu.selectedPetName)));
               }
               else
               {
                  StarlingGameMenu.focusMenu(this.gameMain.petItemMenu);
                  StarlingGameMenu.removeFocusMenu();
                  this.gameMain.createPetItemMenu(Pet(CommonCalls.returnObject(this.gameMain.player.pet_array,this.gameMain.petMenu.selectedPetName)));
               }
               break;
            case "petVend_btn":
               if(GameMenu.menu_array.indexOf(this.gameMain.petVendMenu) == -1)
               {
                  for each(_pet1 in this.gameMain.player.pet_array)
                  {
                     if(_pet1.name == this.gameMain.petMenu.selectedPetName)
                     {
                        this.gameMain.createPetVendMenu(_pet1,this.gameMain.petMenu.currentVendor);
                        break;
                     }
                  }
               }
               break;
            case "petActivate_btn":
               canActivePet = true;
               if(this.gameMain.player.ridingPet != null)
               {
                  for each(_pet in this.gameMain.player.pet_array)
                  {
                     if(_pet.name == this.gameMain.petMenu.selectedPetName && _pet.mode == "m")
                     {
                        canActivePet = false;
                        this.gameMain.createAlert("Cannot activate another pet in mount mode.");
                     }
                  }
               }
               if(canActivePet)
               {
                  if(this.gameMain.player.health > 0)
                  {
                     if(Pet(CommonCalls.returnObject(this.gameMain.player.pet_array,this.gameMain.petMenu.selectedPetName)).health > 0)
                     {
                        this.gameMain.petMenu.activate_btn.visible = false;
                        this.gameMain.petMenu.vend_btn.visible = false;
                        this.gameMain.petMenu.touchable = false;
                        this.gameMain.theConnection.send("togPetCon",false);
                        this.gameMain.theConnection.send("actPet",this.gameMain.petMenu.selectedPetName);
                        this.controls.createPetControlBars(this.gameMain.petMenu.selectedPetName);
                        len = int(PetOrb.petOrb_array.length);
                        i = 0;
                        while(i < len)
                        {
                           if(PetOrb.petOrb_array[i].petName == this.gameMain.petMenu.selectedPetName)
                           {
                              PetOrb.petOrb_array[i].removeFromParent(true);
                              PetOrb.petOrb_array.removeAt(i);
                              break;
                           }
                           i++;
                        }
                     }
                     else
                     {
                        this.gameMain.createAlert("Cannot activate, this pets health is to low");
                     }
                  }
                  else
                  {
                     this.gameMain.createAlert("Cannot activate pet while dead");
                  }
               }
               break;
            case "petEquipItem_btn":
               if(Pet(CommonCalls.returnObject(this.gameMain.player.pet_array,this.gameMain.petItemMenu.selectedPet)).lvl >= Stats.getItemArray(Stats.getItemType(this.gameMain.petItemMenu.item_txt.text))[this.gameMain.petItemMenu.item_txt.text].reqLev)
               {
                  this.gameMain.theConnection.send("petIEquip",this.gameMain.petItemMenu.selectedPet,this.gameMain.petItemMenu.item_txt.text);
               }
               else
               {
                  this.gameMain.createAlert(this.gameMain.petItemMenu.selectedPet + " is not high enough level to use this item.");
               }
               break;
            case "petUnEquipItem_btn":
               if(this.gameMain.personItem_array.length < this.gameMain.maxItems)
               {
                  if(Stats.getItemType(this.gameMain.petItemMenu.item_txt.text) == "pet helmet")
                  {
                     this.gameMain.theConnection.send("petIEquip",this.gameMain.petItemMenu.selectedPet,"pet none helmet");
                  }
                  else if(Stats.getItemType(this.gameMain.petItemMenu.item_txt.text) == "shoes")
                  {
                     this.gameMain.theConnection.send("petIEquip",this.gameMain.petItemMenu.selectedPet,"none shoe");
                  }
               }
               else
               {
                  this.gameMain.createAlert("not enough room in your inventory to unequip item");
               }
               break;
            case "petUse_btn":
               if(Pet(CommonCalls.returnObject(this.gameMain.player.pet_array,this.gameMain.petItemMenu.selectedPet)).health <= 0)
               {
                  this.gameMain.createAlert("Cannot use an item on a dead pet.  Revive it first.");
                  return;
               }
               b = 0;
               a = 0;
               switch(this.gameMain.petItemMenu.item_txt.text)
               {
                  case "apple":
                     this.gameMain.theConnection.send("petHealed",50,this.gameMain.petItemMenu.selectedPet);
                     CommonCalls.returnObject(this.gameMain.player.pet_array,this.gameMain.petItemMenu.selectedPet).health = CommonCalls.returnObject(this.gameMain.player.pet_array,this.gameMain.petItemMenu.selectedPet).health + 50;
                     break;
                  case "banana":
                     this.gameMain.theConnection.send("petHealed",20,this.gameMain.petItemMenu.selectedPet);
                     CommonCalls.returnObject(this.gameMain.player.pet_array,this.gameMain.petItemMenu.selectedPet).health = CommonCalls.returnObject(this.gameMain.player.pet_array,this.gameMain.petItemMenu.selectedPet).health + 20;
                     break;
                  case "watermelon":
                     this.gameMain.theConnection.send("petHealed",200,this.gameMain.petItemMenu.selectedPet);
                     CommonCalls.returnObject(this.gameMain.player.pet_array,this.gameMain.petItemMenu.selectedPet).health = CommonCalls.returnObject(this.gameMain.player.pet_array,this.gameMain.petItemMenu.selectedPet).health + 200;
                     break;
                  case "turkey":
                     this.gameMain.theConnection.send("petHealed",400,this.gameMain.petItemMenu.selectedPet);
                     CommonCalls.returnObject(this.gameMain.player.pet_array,this.gameMain.petItemMenu.selectedPet).health = CommonCalls.returnObject(this.gameMain.player.pet_array,this.gameMain.petItemMenu.selectedPet).health + 400;
                     break;
                  case "evolution crystal":
                     b++;
                     this.gameMain.theConnection.send("useCrystal",this.gameMain.petItemMenu.selectedPet);
                     break;
                  case "book of power":
                     this.gameMain.theConnection.send("usePetScroll","book of power",this.gameMain.petItemMenu.selectedPet);
                     ++Pet(CommonCalls.returnObject(this.gameMain.player.pet_array,this.gameMain.petItemMenu.selectedPet)).power;
                     a++;
                     break;
                  case "book of dexterity":
                     this.gameMain.theConnection.send("usePetScroll","book of dexterity",this.gameMain.petItemMenu.selectedPet);
                     ++Pet(CommonCalls.returnObject(this.gameMain.player.pet_array,this.gameMain.petItemMenu.selectedPet)).dex;
                     a++;
                     break;
                  case "book of health":
                     this.gameMain.theConnection.send("usePetScroll","book of health",this.gameMain.petItemMenu.selectedPet);
                     Pet(CommonCalls.returnObject(this.gameMain.player.pet_array,this.gameMain.petItemMenu.selectedPet)).health = Pet(CommonCalls.returnObject(this.gameMain.player.pet_array,this.gameMain.petItemMenu.selectedPet)).health + 10;
                     Pet(CommonCalls.returnObject(this.gameMain.player.pet_array,this.gameMain.petItemMenu.selectedPet)).totalHealth = Pet(CommonCalls.returnObject(this.gameMain.player.pet_array,this.gameMain.petItemMenu.selectedPet)).totalHealth + 10;
                     a++;
                     break;
                  case "book of defense":
                     this.gameMain.theConnection.send("usePetScroll","book of defense",this.gameMain.petItemMenu.selectedPet);
                     ++Pet(CommonCalls.returnObject(this.gameMain.player.pet_array,this.gameMain.petItemMenu.selectedPet)).defense;
                     a++;
                     break;
                  default:
                     if(Stats.getItemType(Fish.fishNoShinyName(this.gameMain.petItemMenu.item_txt.text)) == "fish")
                     {
                        this.gameMain.theConnection.send("petHealed",Stats.fishStats[Fish.fishNoShinyName(this.gameMain.petItemMenu.item_txt.text)].heal,this.gameMain.petItemMenu.selectedPet);
                        CommonCalls.returnObject(this.gameMain.player.pet_array,this.gameMain.petItemMenu.selectedPet).health = CommonCalls.returnObject(this.gameMain.player.pet_array,this.gameMain.petItemMenu.selectedPet).health + Stats.fishStats[Fish.fishNoShinyName(this.gameMain.petItemMenu.item_txt.text)].heal;
                     }
                     else
                     {
                        b++;
                        this.gameMain.createAlert("you cannot use this item on a pet");
                     }
               }
               if(b == 0)
               {
                  if(a == 0)
                  {
                     this.gameMain.theConnection.send("sellI",this.gameMain.petItemMenu.item_txt.text,false);
                  }
                  else
                  {
                     this.gameMain.petMenu.selectPet(null,this.gameMain.petItemMenu.selectedPet);
                  }
                  this.gameMain.vectorStringRemove(this.gameMain.personItem_array,this.gameMain.petItemMenu.item_txt.text);
                  SoundManager.playSound(SoundLibrary.heal_sound);
                  this.gameMain.petItemMenu.deselectAll();
                  this.gameMain.petItemMenu.updateMe(this.gameMain.maxItems,this.gameMain.personItem_array,this.gameMain.player);
                  if(StarlingGameMenu.menu_array.indexOf(this.gameMain.petMenu) > -1)
                  {
                     this.gameMain.petMenu.updateMe();
                  }
               }
               break;
            case "closePersonChat_btn":
               this.gameMain.pmMenu.closeChat(Button(_target));
               break;
            case "blockPersonChat_btn":
               this.gameMain.pmMenu.blockChat(Button(_target));
               break;
            case "petBuy_btn":
               if(StarlingGameMenu.menu_array.indexOf(this.gameMain.petConfirmMenu) == -1)
               {
                  tooManyPets = false;
                  if(this.gameMain.player.pet_array.length == this.gameMain.maxPets)
                  {
                     tooManyPets = true;
                  }
                  hasCompanionPet = false;
                  for each(_petCheck in this.gameMain.player.pet_array)
                  {
                     if(_petCheck.isCompanion)
                     {
                        hasCompanionPet = true;
                        break;
                     }
                  }
                  if(hasCompanionPet == false && this.gameMain.player.pet_array.length == this.gameMain.maxPets - 1)
                  {
                     tooManyPets = true;
                  }
                  if(tooManyPets && hasCompanionPet == false)
                  {
                     this.gameMain.createAlert("Cannot buy pet: set a companion pet to free up one space");
                  }
                  else if(tooManyPets)
                  {
                     this.gameMain.createAlert("Max amount of pets");
                  }
                  else if(this.gameMain.player.money >= Stats.petStats[this.gameMain.petShopMenu.selectedType].cost && a == 0)
                  {
                     this.gameMain.createPetConfirmMenu(this.gameMain.petShopMenu.selectedType);
                  }
               }
               else
               {
                  StarlingGameMenu.focusMenu(this.gameMain.petConfirmMenu,true);
               }
               break;
            case "moneyPlus_btn":
               this.gameMain.tradeMenu.changePMoney(100);
               break;
            case "moneyPlusMore_btn":
               this.gameMain.tradeMenu.changePMoney(1000);
               break;
            case "moneyPlusMoreMore_btn":
               this.gameMain.tradeMenu.changePMoney(10000);
               break;
            case "moneyPlusMoreMoreMore_btn":
               this.gameMain.tradeMenu.changePMoney(100000);
               break;
            case "moneyMinus_btn":
               this.gameMain.tradeMenu.changePMoney(100,false);
               break;
            case "moneyMinusMore_btn":
               this.gameMain.tradeMenu.changePMoney(1000,false);
               break;
            case "moneyMinusMoreMore_btn":
               this.gameMain.tradeMenu.changePMoney(10000,false);
               break;
            case "ticketsPlus_btn":
               if(this.gameMain.player.lev >= 100)
               {
                  this.gameMain.tradeMenu.addPTicket();
                  this.gameMain.theConnection.send("giTTickets",this.gameMain.tradeMenu.traderName,this.gameMain.tradeMenu.pTicketOffer);
               }
               else
               {
                  this.gameMain.createAlert("You must be level 100 or above to trade tickets.");
               }
               break;
            case "ticketsMinus_btn":
               this.gameMain.tradeMenu.deductPTicket();
               this.gameMain.theConnection.send("giTTickets",this.gameMain.tradeMenu.traderName,this.gameMain.tradeMenu.pTicketOffer);
               break;
            case "confirm_btn":
               this.gameMain.tradeMenu.confirmTrade();
               break;
            case "tradeNo_btn":
               this.gameMain.tradeMenu.yes_btn.visible = this.gameMain.tradeMenu.no_btn.visible = false;
               StarlingGameMenu.removeFocusMenu();
               break;
            case "tradeYes_btn":
               if(this.gameMain.player.gravityObject.onGround == false)
               {
                  this.gameMain.createAlert("You must be standing on the ground to complete a trade");
               }
               else if(this.gameMain.player.health <= 0)
               {
                  StarlingGameMenu.removeFocusMenu();
               }
               else if(this.gameMain.tradeMenu.waiting_txt.text == "")
               {
                  this.gameMain.tradeMenu.sure_txt.text = "Waiting confirm from " + this.gameMain.tradeMenu.traderName + "...";
                  this.gameMain.tradeMenu.yes_btn.visible = this.gameMain.tradeMenu.no_btn.visible = false;
                  this.gameMain.theConnection.send("confirmFinalT",this.gameMain.tradeMenu.traderName,this.gameMain.tradeMenu.playerOfferedItems,this.gameMain.tradeMenu.opponentOfferedItems,this.gameMain.tradeMenu.playerOfferedPets,this.gameMain.tradeMenu.opponentOfferedPets,this.gameMain.tradeMenu.playerMoneyOffer,this.gameMain.tradeMenu.opponentMoneyOffer,this.gameMain.tradeMenu.pTicketOffer,this.gameMain.tradeMenu.oTicketOffer);
               }
               else
               {
                  this.gameMain.theConnection.send("verifyT",this.gameMain.tradeMenu.traderName,this.gameMain.tradeMenu.playerMoneyOffer,this.gameMain.tradeMenu.opponentMoneyOffer,this.gameMain.tradeMenu.playerOfferedItems,this.gameMain.tradeMenu.opponentOfferedItems,this.gameMain.tradeMenu.playerOfferedPets,this.gameMain.tradeMenu.opponentOfferedPets,this.gameMain.tradeMenu.pTicketOffer,this.gameMain.tradeMenu.oTicketOffer);
                  this.gameMain.tradeMenu.yes_btn.visible = this.gameMain.tradeMenu.no_btn.visible = false;
               }
               break;
            case "offer_btn":
               this.gameMain.tradeMenu.offerPItem();
               break;
            case "withhold_btn":
               this.gameMain.tradeMenu.withholdPItem();
               break;
            case "petOffer_btn":
               this.gameMain.tradeMenu.offerPPet(this.gameMain.tradeMenu.item_txt.text);
               break;
            case "petWithhold_btn":
               this.gameMain.tradeMenu.withholdPPet();
               break;
            case "modeEnable_btn":
               this.gameMain.petModeMenu.enableMode();
               break;
            case "buyPetValid_btn":
               this.gameMain.petConfirmMenu.buyPet();
               break;
            case "petVendValid_btn":
               this.gameMain.petVendMenu.vendPet();
               break;
            case "alertMenuYes_btn":
               TweenMax.to(this.gameMain.alertMenu,0.5,{
                  "x":974,
                  "ease":Back.easeOut,
                  "onComplete":this.gameMain.alertMenu.removeFromParent,
                  "onCompleteParams":[true]
               });
               this.gameMain.theConnection.send("evoPet",this.gameMain.alertMenu.petName);
               break;
            case "alertMenuNo_btn":
               TweenMax.to(this.gameMain.alertMenu,0.5,{
                  "x":974,
                  "ease":Back.easeOut,
                  "onComplete":this.gameMain.alertMenu.removeFromParent,
                  "onCompleteParams":[true]
               });
               break;
            case "vendPetInfo_btn":
               PetVendor(_target.parent).showBuyButton();
               this.gameMain.createInfoMenu("Coins: $" + PetVendor(_target.parent).coins + "\nTickets: " + PetVendor(_target.parent).tickets + "\nPet Name: " + PetVendor(_target.parent).petDBObject.key + "\nLevel: " + PetVendor(_target.parent).petDBObject.lvl + "\nLove: " + PetVendor(_target.parent).petDBObject.love + "\nHealth: " + PetVendor(_target.parent).petDBObject.totalHealth + "\nPower: " + PetVendor(_target.parent).petDBObject.power + "\nDexterity: " + PetVendor(_target.parent).petDBObject.dex + "\nDefense: " + PetVendor(_target.parent).petDBObject.def + "\nType: " + PetVendor(_target.parent).petDBObject.type + "\nSeller: " + Person.removeNamePrefix(PetVendor(_target.parent).sellerName) + "\nOriginal owner: " + PetVendor(_target.parent).petDBObject.oOwner,"big");
               break;
            case "petAdopt_btn":
               _target.visible = false;
               this.gameMain.createConfirmMenu("Are you sure you would like to buy this pet?","adopt pet");
               this.gameMain.confirmMenu.petVendor = PetVendor(_target.parent);
               break;
            case "rechooseServer_btn":
               StarlingGameMenu.removeAllMenus(false,Vector.<StarlingGameMenu>([this.gameMain.pmMenu]));
               if(this.gameMain.player.powerUpVisuals.unleashing)
               {
                  this.gameMain.createAlert("cannot change servers while unleashing energy");
               }
               else if(this.gameMain.player.health > 0)
               {
                  this.gameMain.createMMenu("servers",false);
                  this.controls.touchable = false;
               }
               else
               {
                  this.gameMain.createAlert("cannot change servers when dead");
               }
               break;
            case "lotteryTicketPlus_btn":
               this.gameMain.lotteryMenu.updateMe(1,0,this.gameMain.player.tickets,this.gameMain.player.money);
               break;
            case "lotteryTicketMinus_btn":
               this.gameMain.lotteryMenu.updateMe(-1,0,this.gameMain.player.tickets,this.gameMain.player.money);
               break;
            case "lotteryCoinPlus_btn":
               this.gameMain.lotteryMenu.updateMe(0,10000,this.gameMain.player.tickets,this.gameMain.player.money);
               break;
            case "lotteryCoinMinus_btn":
               this.gameMain.lotteryMenu.updateMe(0,-10000,this.gameMain.player.tickets,this.gameMain.player.money);
               break;
            case "lotteryBuy_btn":
               if(this.gameMain.lotteryMenu.buyTickets > 0 || this.gameMain.lotteryMenu.buyCoins > 0)
               {
                  this.gameMain.createConfirmMenu("This will cost " + this.gameMain.lotteryMenu.buyTickets + " tickets and " + this.gameMain.lotteryMenu.buyCoins + " coins.  Do you wish to purchase these lottery entries?","lottery");
               }
               else
               {
                  this.gameMain.createAlert("You must buy at least 1 ticket or coin entry");
               }
               break;
            case "buyCraft_btn":
               this.gameMain.craftingMenu.buyItem();
               break;
            case "withdrawl_btn":
               this.gameMain.lastTradeCounter = 0;
               this.gameMain.bankMenu.withdrawlMoney();
               break;
            case "deposit_btn":
               this.gameMain.lastTradeCounter = 0;
               this.gameMain.bankMenu.depositMoney();
               break;
            case "bankItemWithdraw_btn":
               this.gameMain.lastTradeCounter = 0;
               this.gameMain.bankMenu.withdrawlItem();
               break;
            case "genderLeft_btn":
               this.gameMain.charCreateMenu.changeGender();
               break;
            case "genderRight_btn":
               this.gameMain.charCreateMenu.changeGender();
               break;
            case "classLeft_btn":
               this.gameMain.charCreateMenu.classLeft();
               break;
            case "classRight_btn":
               this.gameMain.charCreateMenu.classRight();
               break;
            case "hairLeft_btn":
               this.gameMain.charCreateMenu.hairLeft();
               break;
            case "hairRight_btn":
               this.gameMain.charCreateMenu.hairRight();
               break;
            case "eyesLeft_btn":
               this.gameMain.charCreateMenu.eyesLeft();
               break;
            case "eyesRight_btn":
               this.gameMain.charCreateMenu.eyesRight();
               break;
            case "skinLeft_btn":
               this.gameMain.charCreateMenu.skinLeft();
               break;
            case "skinRight_btn":
               this.gameMain.charCreateMenu.skinRight();
               break;
            case "beardLeft_btn":
               this.gameMain.charCreateMenu.beardLeft();
               break;
            case "beardRight_btn":
               this.gameMain.charCreateMenu.beardRight();
               break;
            case "createBack_btn":
               this.gameMain.mMenu.visible = true;
               this.gameMain.charCreateMenu.removeFromParent(true);
               this.gameMain.createTransition();
               break;
            case "terms_btn":
               if(this.gameMain.updateMenu == null || this.gameMain.updateMenu.parent == null)
               {
                  this.gameMain.createUpdateMenu("terms");
               }
               break;
            case "finished_btn":
               _target.visible = false;
               if(CussFilter.checkString(this.gameMain.charCreateMenu.name_txt.text) != "" && this.gameMain.playingURL_string != "armorgames.com" && this.gameMain.playingURL_string != "kongregate.com" && this.gameMain.playingURL_string != "miniplay.com")
               {
                  this.gameMain.createAlert("cannot use profanity in username");
                  this.gameMain.charCreateMenu.finished_btn.visible = true;
               }
               else if(this.gameMain.charCreateMenu.name_txt.text.search(this.gameMain.validString) != -1)
               {
                  this.gameMain.createAlert("username contains invalid characters");
                  this.gameMain.charCreateMenu.finished_btn.visible = true;
               }
               else if(this.gameMain.charCreateMenu.name_txt.text.indexOf("facebook",0) == 0 || this.gameMain.charCreateMenu.name_txt.text.indexOf("kongregate",0) == 0 || this.gameMain.charCreateMenu.name_txt.text.indexOf("steam",0) == 0 || this.gameMain.charCreateMenu.name_txt.text.indexOf("playerio",0) == 0)
               {
                  this.gameMain.createAlert("cannot use this username");
                  this.gameMain.charCreateMenu.finished_btn.visible = true;
               }
               else if(this.gameMain.charCreateMenu.name_txt.text != "" && (this.gameMain.charCreateMenu.password_txt.text != "" || this.gameMain.charCreateMenu.password_txt.visible == false))
               {
                  tempGender = this.gameMain.charCreateMenu.personClone.bodyAnimator.gender == "girl" ? "female" : "male";
                  this.gameMain.charCreateMenu.finished_btn.visible = this.gameMain.charCreateMenu.back_btn.visible = false;
                  if(this.gameMain.connectType == "simple")
                  {
                     tempSignInObject = new Object();
                     tempSignInObject.userId = "adsfjhakf";
                     PlayerIO.authenticate(this.gameMain.stage,"hho-ygpra4ftumusohpifpdug","public",tempSignInObject,null,function(param1:Client):void
                     {
                        var _client:Client = param1;
                        gameMain.findIsFreeUsername(_client,gameMain.charCreateMenu.name_txt.text,function(param1:Boolean):void
                        {
                           var _loc2_:Object = null;
                           if(param1)
                           {
                              _loc2_ = new Object();
                              _loc2_.register = true;
                              _loc2_.username = gameMain.charCreateMenu.name_txt.text;
                              _loc2_.password = gameMain.charCreateMenu.password_txt.text;
                              if(gameMain.charCreateMenu.email_txt.text.length > 0)
                              {
                                 _loc2_.email = gameMain.charCreateMenu.email_txt.text;
                              }
                              PlayerIO.authenticate(gameMain.stage,"hho-ygpra4ftumusohpifpdug","simpleconnection",_loc2_,null,gameMain.handleConnect,gameMain.charCreateMenu.registerError);
                           }
                           else
                           {
                              gameMain.charCreateMenu.finished_btn.visible = true;
                              gameMain.createAlert("username is already taken");
                           }
                        });
                     });
                  }
                  else if(this.gameMain.playingURL_string == "armorgames.com")
                  {
                     ArmorGames.fetchSecretHash(this.gameMain.charCreateMenu.name_txt.text,function(param1:String, param2:Boolean):void
                     {
                        if(param2)
                        {
                           gameMain.player.name = gameMain.charCreateMenu.name_txt.text;
                           gameMain.player.password = param1;
                           gameMain.c_mc.gotoAndStop(1);
                           gameMain.connectToServer(gameMain.connectType);
                        }
                        else
                        {
                           gameMain.charCreateMenu.finished_btn.visible = true;
                        }
                     });
                  }
                  else if(this.gameMain.playingURL_string == "y8.com")
                  {
                     this.gameMain.y8_api.fetchSecretHash(this.gameMain.charCreateMenu.name_txt.text,function(param1:String):void
                     {
                        gameMain.player.name = gameMain.charCreateMenu.name_txt.text;
                        gameMain.player.password = param1;
                        gameMain.c_mc.gotoAndStop(1);
                        gameMain.connectToServer(gameMain.connectType);
                     });
                  }
                  else if(this.gameMain.connectType == "facebook")
                  {
                     this.gameMain.findIsFreeUsername(this.gameMain.theClient,this.gameMain.charCreateMenu.name_txt.text,function(param1:Boolean):void
                     {
                        if(param1)
                        {
                           gameMain.handleConnect(gameMain.theClient);
                        }
                        else
                        {
                           gameMain.charCreateMenu.finished_btn.visible = true;
                           gameMain.createAlert("username is already taken");
                        }
                     });
                  }
                  else if(this.gameMain.connectType == "kongregate")
                  {
                     this.gameMain.c_mc.gotoAndStop(1);
                     this.gameMain.handleConnect(this.gameMain.theClient);
                  }
                  else if(this.gameMain.connectType == "steam")
                  {
                     this.gameMain.findIsFreeUsername(this.gameMain.theClient,this.gameMain.charCreateMenu.name_txt.text,function(param1:Boolean):void
                     {
                        if(param1)
                        {
                           gameMain.c_mc.gotoAndStop(1);
                           gameMain.handleConnect(gameMain.theClient);
                        }
                        else
                        {
                           gameMain.charCreateMenu.finished_btn.visible = true;
                           gameMain.createAlert("username is already taken");
                        }
                     });
                  }
                  else if(this.gameMain.playingURL_string == "miniplay.com")
                  {
                     MiniPlay.fetchSecretHash(this.gameMain.charCreateMenu.name_txt.text,function(param1:String, param2:Boolean):void
                     {
                        if(param2)
                        {
                           gameMain.player.name = gameMain.charCreateMenu.name_txt.text;
                           gameMain.player.password = param1;
                           gameMain.c_mc.gotoAndStop(1);
                           gameMain.connectToServer(gameMain.connectType);
                        }
                        else
                        {
                           gameMain.charCreateMenu.finished_btn.visible = true;
                        }
                     });
                  }
                  else if(PlayerIOPublishingNetwork.isOnNetworkSite())
                  {
                     this.gameMain.c_mc.gotoAndStop(1);
                     this.gameMain.handleConnect(this.gameMain.theClient);
                  }
               }
               else
               {
                  this.gameMain.createAlert("must enter username and password");
                  this.gameMain.charCreateMenu.finished_btn.visible = true;
               }
               this.gameMain.charCreateMenu.setPlayerToClone(this.gameMain.player);
               switch(this.gameMain.charCreateMenu.class_txt.text)
               {
                  case "warrior":
                     this.gameMain.player.power = 4;
                     this.gameMain.player.range = 0;
                     this.gameMain.player.magic = 0;
                     this.gameMain.player.defense = 3;
                     this.gameMain.player.dex = 0;
                     this.gameMain.player.artillery = 0;
                     this.gameMain.player.bodyAnimator.weaponString = "stick";
                     break;
                  case "archer":
                     this.gameMain.player.power = 0;
                     this.gameMain.player.range = 5;
                     this.gameMain.player.magic = 0;
                     this.gameMain.player.defense = 1;
                     this.gameMain.player.dex = 1;
                     this.gameMain.player.artillery = 0;
                     this.gameMain.player.bodyAnimator.weaponString = "slingshot";
                     break;
                  case "mage":
                     this.gameMain.player.totalMP = 20;
                     this.gameMain.player.MP = this.gameMain.player.totalMP;
                     this.gameMain.player.power = 0;
                     this.gameMain.player.range = 0;
                     this.gameMain.player.magic = 3;
                     this.gameMain.player.defense = 1;
                     this.gameMain.player.dex = 0;
                     this.gameMain.player.artillery = 0;
                     this.gameMain.player.bodyAnimator.weaponString = "basic wand";
                     break;
                  case "cowboy":
                     this.gameMain.player.power = 0;
                     this.gameMain.player.range = 0;
                     this.gameMain.player.magic = 0;
                     this.gameMain.player.defense = 1;
                     this.gameMain.player.dex = 0;
                     this.gameMain.player.artillery = 6;
                     this.gameMain.player.bodyAnimator.weaponString = "airsoft gun";
               }
               break;
            case "hpMore_btn":
               this.gameMain.theConnection.send("addAbility","health");
               break;
            case "mpMore_btn":
               this.gameMain.theConnection.send("addAbility","MP");
               break;
            case "powerMore_btn":
               this.gameMain.theConnection.send("addAbility","power");
               break;
            case "dexMore_btn":
               this.gameMain.theConnection.send("addAbility","dex");
               break;
            case "defenseMore_btn":
               this.gameMain.theConnection.send("addAbility","defense");
               break;
            case "rangeMore_btn":
               this.gameMain.theConnection.send("addAbility","range");
               break;
            case "magicMore_btn":
               this.gameMain.theConnection.send("addAbility","magic");
               break;
            case "artilleryMore_btn":
               this.gameMain.theConnection.send("addAbility","artillery");
               break;
            case "pets_btn":
               if(StarlingGameMenu.menu_array.indexOf(this.gameMain.tradeMenu) == -1)
               {
                  if(StarlingGameMenu.menu_array.indexOf(this.gameMain.petMenu) == -1)
                  {
                     this.gameMain.createPetMenu();
                  }
                  else
                  {
                     StarlingGameMenu.focusMenu(this.gameMain.petMenu,true);
                  }
               }
               else
               {
                  this.gameMain.createAlert("cannot open pet menu while trading");
               }
               break;
            case "char_btn":
               this.controls.blinkCharacterButton = false;
               this.gameMain.createCMenu(this.gameMain.player);
               break;
            case "no_btn":
               if(this.gameMain.mapMenu != null)
               {
                  this.gameMain.mapMenu.hideTeleportArrow();
               }
               switch(this.gameMain.confirmMenu.shortReason)
               {
                  case "pet companion":
                     if(this.gameMain.petMenu != null && this.gameMain.petMenu.parent != null)
                     {
                        this.gameMain.petMenu.touchable = true;
                     }
                     break;
                  case "pet release":
                     if(this.gameMain.petMenu != null && this.gameMain.petMenu.parent != null)
                     {
                        this.gameMain.petMenu.touchable = true;
                     }
                     break;
                  case "adopt pet":
               }
               removeChild(this.gameMain.confirmMenu,true);
               break;
            case "yes_btn":
               switch(this.gameMain.confirmMenu.shortReason)
               {
                  case "leave guild":
                     this.gameMain.theConnection.send("leaveGuild");
                     this.gameMain.createAlert("you have been removed from the " + this.gameMain.player.guild + " guild.");
                     this.gameMain.player.guild = "";
                     GameMenu.removeFocusMenu();
                     break;
                  case "area teleport":
                     if(this.gameMain.player.powerUpVisuals.unleashing)
                     {
                        this.gameMain.createAlert("Cannot teleport while unleashing energy");
                     }
                     else if(this.gameMain.player.health > 0)
                     {
                        this.gameMain.c_mc.gotoAndStop(this.gameMain.confirmMenu.areaToTeleport);
                        i = 1;
                        while(i < 9)
                        {
                           if(Stats.levelStats[this.gameMain.confirmMenu.areaToTeleport]["portal" + String(i) + "Lead"] > 0)
                           {
                              this.gameMain.changeLevel(this.gameMain.confirmMenu.areaToTeleport,"portal" + i);
                              break;
                           }
                           i++;
                        }
                        StarlingGameMenu.removeFocusMenu();
                     }
                     else if(this.gameMain.player.health <= 0)
                     {
                        this.gameMain.createAlert("Cannot teleport when dead");
                     }
                     break;
                  case "pet companion":
                     if(this.gameMain.petMenu != null && this.gameMain.petMenu.parent != null)
                     {
                        CommonCalls.returnObject(this.gameMain.player.pet_array,this.gameMain.petMenu.selectedPetName).isCompanion = true;
                        this.gameMain.theConnection.send("petComp",this.gameMain.petMenu.selectedPetName);
                        this.gameMain.petMenu.touchable = true;
                        this.gameMain.petMenu.companion_btn.visible = false;
                        this.gameMain.createAlert("Set " + this.gameMain.petMenu.selectedPetName + " as companion pet");
                        StarlingGameMenu.removeFocusMenu();
                        this.gameMain.createAlert(this.gameMain.petMenu.selectedPetName + " has been set as your pet companion",true);
                        this.gameMain.petMenu.deselectAll();
                        this.gameMain.petMenu.panel_array[0].texture = PetMenu.petMenu_textureAtlas.getTexture("panel_01");
                     }
                     break;
                  case "pet release":
                     if(this.gameMain.petMenu != null && this.gameMain.petMenu.parent != null)
                     {
                        this.gameMain.theConnection.send("petRel",this.gameMain.petMenu.selectedPetName);
                        this.gameMain.petMenu.touchable = true;
                        this.gameMain.player.removePetFromMe(this.gameMain.petMenu.selectedPetName);
                        this.gameMain.petMenu.deselectAll();
                        StarlingGameMenu.removeFocusMenu();
                     }
                     break;
                  case "itemvendor":
                     if(this.gameMain.player.gravityObject.onGround == false)
                     {
                        this.gameMain.createAlert("Must be standing on the ground to place vendor");
                     }
                     else if(VendingMachine.canPlaceHere(this.gameMain.player.x,this.gameMain.player.y - 11,this.gameMain.player.gravityObject.groundSlope,this.c_mc) == false)
                     {
                        this.gameMain.createAlert("Cannot place here: touching another vending machine");
                     }
                     else
                     {
                        this.gameMain.theConnection.send("creIVendor",this.gameMain.player.x,this.gameMain.player.y - 11,this.gameMain.player.gravityObject.groundSlope);
                     }
                     break;
                  case "petvendor":
                     if(VendingMachine.canPlaceHere(this.gameMain.player.x,this.gameMain.player.y - 11,this.gameMain.player.gravityObject.groundSlope,this.c_mc) == false)
                     {
                        this.gameMain.createAlert("Cannot place here: touching another vending machine");
                     }
                     else
                     {
                        this.gameMain.theConnection.send("crePetVendor",this.gameMain.player.x,this.gameMain.player.y + 7,this.gameMain.player.gravityObject.groundSlope);
                     }
                     break;
                  case "lottery":
                     this.gameMain.theConnection.send("buyLotto",this.gameMain.lotteryMenu.buyTickets,this.gameMain.lotteryMenu.buyCoins);
                     if(StarlingGameMenu.menu_array.indexOf(this.gameMain.lotteryMenu) > -1)
                     {
                        StarlingGameMenu.focusMenu(this.gameMain.lotteryMenu);
                        StarlingGameMenu.removeFocusMenu();
                     }
                     break;
                  case "adopt pet":
                     if(this.gameMain.player.money >= ConfirmMenu(_target.parent).petVendor.coins && this.gameMain.player.tickets >= ConfirmMenu(_target.parent).petVendor.tickets)
                     {
                        if(this.gameMain.player.pet_array.length < this.gameMain.maxPets)
                        {
                           this.gameMain.theConnection.send("petFromVend",ConfirmMenu(_target.parent).petVendor.name);
                        }
                        else
                        {
                           this.gameMain.createAlert("You cannot hold any more pets");
                        }
                     }
                     else
                     {
                        this.gameMain.createAlert("You do not have sufficient funds to adopt this pet");
                     }
               }
               removeChild(this.gameMain.confirmMenu,true);
               break;
            case "payvault_btn":
               if(StarlingGameMenu.menu_array.indexOf(this.gameMain.tradeMenu) == -1)
               {
                  if(GameMenu.menu_array.indexOf(this.gameMain.pvMenu) == -1)
                  {
                     this.gameMain.createPVMenu();
                  }
                  else
                  {
                     GameMenu.focusMenu(this.gameMain.pvMenu,true);
                  }
               }
               else
               {
                  this.gameMain.createAlert("cannot open payvault while trading");
               }
               break;
            case "heropedia_btn":
               if(StarlingGameMenu.menu_array.indexOf(this.gameMain.tradeMenu) == -1)
               {
                  if(StarlingGameMenu.menu_array.indexOf(this.gameMain.heroMenu) == -1)
                  {
                     this.gameMain.createHeroMenu();
                     this.controls.blinkHeropediaButton = false;
                  }
                  else
                  {
                     StarlingGameMenu.focusMenu(this.gameMain.heroMenu,true);
                  }
               }
               break;
            case "friends_btn":
               if(StarlingGameMenu.menu_array.indexOf(this.gameMain.tradeMenu) == -1)
               {
                  if(StarlingGameMenu.menu_array.indexOf(this.gameMain.friendMenu) == -1)
                  {
                     this.gameMain.createFriendMenu();
                  }
                  else
                  {
                     StarlingGameMenu.focusMenu(this.gameMain.friendMenu,true);
                  }
               }
               break;
            case "missions_btn":
               this.controls.blinkMissionButton = false;
               if(StarlingGameMenu.menu_array.indexOf(this.gameMain.tradeMenu) == -1)
               {
                  if(StarlingGameMenu.menu_array.indexOf(this.gameMain.missionMenu) == -1)
                  {
                     this.gameMain.createMissionMenu();
                  }
                  else
                  {
                     StarlingGameMenu.focusMenu(this.gameMain.missionMenu,true);
                  }
               }
               break;
            case "items_btn":
               if(StarlingGameMenu.menu_array.indexOf(this.gameMain.tradeMenu) == -1 && StarlingGameMenu.menu_array.indexOf(this.gameMain.petItemMenu) == -1)
               {
                  if(StarlingGameMenu.menu_array.indexOf(this.gameMain.itemMenu) == -1)
                  {
                     this.gameMain.createItemMenu("self",this.gameMain.personItem_array);
                  }
                  else if(this.gameMain.itemMenu.parent != null)
                  {
                     StarlingGameMenu.focusMenu(this.gameMain.itemMenu,true);
                  }
               }
               else
               {
                  this.gameMain.createAlert("cannot open item menu right now");
               }
               break;
            case "map_btn":
               if(StarlingGameMenu.menu_array.indexOf(this.gameMain.tradeMenu) == -1)
               {
                  StarlingGameMenu.removeAllMenus(false,Vector.<StarlingGameMenu>([this.gameMain.pmMenu]));
                  if(StarlingGameMenu.menu_array.indexOf(this.gameMain.mapMenu) == -1)
                  {
                     this.gameMain.createMapMenu();
                  }
                  else
                  {
                     StarlingGameMenu.focusMenu(this.gameMain.mapMenu,true);
                  }
               }
               break;
            case "options_btn":
               if(StarlingGameMenu.menu_array.indexOf(this.gameMain.tradeMenu) == -1)
               {
                  if(StarlingGameMenu.menu_array.indexOf(this.gameMain.optionMenu) == -1)
                  {
                     this.gameMain.createOptionMenu();
                  }
                  else
                  {
                     StarlingGameMenu.focusMenu(this.gameMain.optionMenu,true);
                  }
               }
               break;
            case "mainMenu_btn":
               for each(_removePet in this.gameMain.pet_array)
               {
                  _removePet.removeFromParent(true);
               }
               this.gameMain.pet_array.length = 0;
               this.gameMain.player.pet_array.length = 0;
               for each(_petOrb in PetOrb.petOrb_array)
               {
                  _petOrb.removeFromParent(true);
               }
               PetOrb.petOrb_array.length = 0;
               len = this.c_mc.numChildren;
               i = len - 1;
               while(i >= 0)
               {
                  if(this.c_mc.getChildAt(i) != this.gameMain.player)
                  {
                     this.c_mc.removeChildAt(i,true);
                  }
                  i--;
               }
               len = this.gameMain.numChildren;
               i = len - 1;
               while(i >= 0)
               {
                  if(this.gameMain.getChildAt(i) is TradeRequest)
                  {
                     this.gameMain.removeChildAt(i);
                  }
                  i--;
               }
               this.gameMain.main_juggler.purge();
               SoundManager.stopAllLoops(true);
               this.gameMain.stage.removeEventListener(Event.ENTER_FRAME,this.onEnter);
               this.gameMain.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.gameMain.onKDown);
               this.gameMain.stage.removeEventListener(KeyboardEvent.KEY_UP,this.gameMain.onKUp);
               StarlingGameMenu.removeAllMenus();
               GameMenu.removeFocusMenu();
               this.controls.visible = false;
               this.gameMain.player.visible = false;
               this.gameMain.emptyGameArrays();
               this.gameMain.theConnection.disconnect();
               this.gameMain.save_sharedObject.data.userPassword = null;
               this.gameMain.createMMenu();
               this.gameMain.skillsDataHasLoaded = false;
               if(this.controls.pets_btn != null)
               {
                  this.controls.pets_btn.removeFromParent(true);
               }
               this.gameMain.c_mc.gotoAndStop(1);
               break;
            case "atmClick_image":
               if(this.gameMain.tradeMenu == null || this.gameMain.tradeMenu.parent == null)
               {
                  SoundManager.playSound(SoundLibrary.click_sound);
                  if(StarlingGameMenu.menu_array.indexOf(this.gameMain.bankMenu) == -1)
                  {
                     this.gameMain.createBankMenu();
                  }
                  else
                  {
                     StarlingGameMenu.focusMenu(this.gameMain.bankMenu,true);
                  }
               }
               break;
            case "vendorClick_btn":
               this.gameMain.createItemMenu("vendor",VendingMachine(_target.parent).items,VendingMachine(_target.parent).sellerName,VendingMachine(_target.parent).name);
               if(this.gameMain.itemMenu.ticketStats_txt != null)
               {
                  this.gameMain.itemMenu.ticketStats_txt.text = "tickets available: " + VendingMachine(_target.parent).tickets + "\ncost per ticket: $" + CommonCalls.uintToCommaString(VendingMachine(_target.parent).ticketPrice);
               }
               break;
            case "musicOff_txt":
               TweenMax.to(SoundManager.music_channel,1,{
                  "volume":0,
                  "ease":Linear.easeNone
               });
               if(SoundManager.musicOn)
               {
                  SoundManager.toggleMusic();
               }
               this.gameMain.optionMenu.updateMe(this.gameMain.stage,AreaCreator.background1,this.gameMain.save_sharedObject,this.gameMain.controllerMain);
               this.gameMain.optionMenu.updateMe(this.gameMain.stage,AreaCreator.background1,this.gameMain.save_sharedObject,this.gameMain.controllerMain);
               break;
            case "musicOn_txt":
               TweenMax.to(SoundManager.music_channel,1,{
                  "volume":1,
                  "ease":Linear.easeNone
               });
               if(SoundManager.musicOn == false)
               {
                  SoundManager.toggleMusic();
               }
               this.gameMain.optionMenu.updateMe(this.gameMain.stage,AreaCreator.background1,this.gameMain.save_sharedObject,this.gameMain.controllerMain);
               break;
            case "soundOn_txt":
               if(SoundManager.soundOn == false)
               {
                  SoundManager.toggleSound();
               }
               this.gameMain.optionMenu.updateMe(this.gameMain.stage,AreaCreator.background1,this.gameMain.save_sharedObject,this.gameMain.controllerMain);
               break;
            case "soundOff_txt":
               if(SoundManager.soundOn)
               {
                  SoundManager.toggleSound();
               }
               this.gameMain.optionMenu.updateMe(this.gameMain.stage,AreaCreator.background1,this.gameMain.save_sharedObject,this.gameMain.controllerMain);
               break;
            case "qualityLow_txt":
               if(AreaCreator.background1.parent != null)
               {
                  removeChild(AreaCreator.background1);
                  removeChild(AreaCreator.background2);
                  removeChild(AreaCreator.background3);
                  if(AreaCreator.cloud1 != null)
                  {
                     removeChild(AreaCreator.cloud1);
                     removeChild(AreaCreator.cloud2);
                  }
                  AreaCreator.sky.height = Starling.current.viewPort.height;
                  TileHandler.removeForeground();
                  len = int(GiveHealthBar.healthBar_array.length);
                  i = len - 1;
                  while(i >= 0)
                  {
                     if(GiveHealthBar.linkedObjects_array[i] is Enemy)
                     {
                        GiveHealthBar.healthBar_array[i].removeFromParent(true);
                        GiveHealthBar.healthBG_array[i].removeFromParent(true);
                        GiveHealthBar.healthBar_array.removeAt(i);
                        GiveHealthBar.healthBG_array.removeAt(i);
                        GiveHealthBar.linkedObjects_array.removeAt(i);
                     }
                     i--;
                  }
                  for each(_person in this.gameMain.p_array)
                  {
                     if(_person.bodyAnimator.shadow_image != null)
                     {
                        _person.bodyAnimator.shadow_image.removeFromParent(true);
                     }
                  }
                  for each(_npc in this.gameMain.npc_array)
                  {
                     if(_npc.bodyAnimator.shadow_image != null)
                     {
                        _npc.bodyAnimator.shadow_image.removeFromParent(true);
                     }
                  }
               }
               this.gameMain.stage.quality = StageQuality.LOW;
               this.gameMain.optionMenu.updateMe(this.gameMain.stage,AreaCreator.background1,this.gameMain.save_sharedObject,this.gameMain.controllerMain);
               break;
            case "qualityMedium_txt":
               this.gameMain.removeLowQuality();
               this.gameMain.stage.quality = StageQuality.MEDIUM;
               this.gameMain.optionMenu.updateMe(this.gameMain.stage,AreaCreator.background1,this.gameMain.save_sharedObject,this.gameMain.controllerMain);
               break;
            case "qualityHigh_txt":
               this.gameMain.removeLowQuality();
               this.gameMain.stage.quality = StageQuality.HIGH;
               this.gameMain.optionMenu.updateMe(this.gameMain.stage,AreaCreator.background1,this.gameMain.save_sharedObject,this.gameMain.controllerMain);
               break;
            case "fullscreenOff_txt":
               this.gameMain.stage.displayState = StageDisplayState.NORMAL;
               this.gameMain.optionMenu.updateMe(this.gameMain.stage,AreaCreator.background1,this.gameMain.save_sharedObject,this.gameMain.controllerMain);
               break;
            case "cutscene1_txt":
               this.gameMain.startCutScene(1);
               StarlingGameMenu.removeFocusMenu();
               break;
            case "cutscene2_txt":
               this.gameMain.startCutScene(2);
               StarlingGameMenu.removeFocusMenu();
               break;
            case "cutscene3_txt":
               this.gameMain.startCutScene(3);
               StarlingGameMenu.removeFocusMenu();
               break;
            case "cutscene4_txt":
               this.gameMain.startCutScene(4);
               StarlingGameMenu.removeFocusMenu();
               break;
            case "cutscene5_txt":
               this.gameMain.startCutScene(5);
               StarlingGameMenu.removeFocusMenu();
               break;
            case "cutscene6_txt":
               this.gameMain.startCutScene(6);
               StarlingGameMenu.removeFocusMenu();
               break;
            case "cutscene7_txt":
               this.gameMain.startCutScene(7);
               StarlingGameMenu.removeFocusMenu();
               break;
            case "cutscene8_txt":
               this.gameMain.startCutScene(8);
               StarlingGameMenu.removeFocusMenu();
               break;
            case "ignoreTradeOn_txt":
               OptionMenu.ignoreTrades = true;
               this.gameMain.optionMenu.updateMe(this.gameMain.stage,AreaCreator.background1,this.gameMain.save_sharedObject,this.gameMain.controllerMain);
               break;
            case "ignoreTradeOff_txt":
               OptionMenu.ignoreTrades = false;
               this.gameMain.optionMenu.updateMe(this.gameMain.stage,AreaCreator.background1,this.gameMain.save_sharedObject,this.gameMain.controllerMain);
               break;
            case "ignorePMsOn_txt":
               OptionMenu.ignorePMs = true;
               this.gameMain.optionMenu.updateMe(this.gameMain.stage,AreaCreator.background1,this.gameMain.save_sharedObject,this.gameMain.controllerMain);
               break;
            case "ignorePMsOff_txt":
               OptionMenu.ignorePMs = false;
               this.gameMain.optionMenu.updateMe(this.gameMain.stage,AreaCreator.background1,this.gameMain.save_sharedObject,this.gameMain.controllerMain);
               break;
            case "controllerOff_txt":
               OptionMenu.controllerOn = false;
               this.gameMain.optionMenu.updateMe(this.gameMain.stage,AreaCreator.background1,this.gameMain.save_sharedObject,this.gameMain.controllerMain);
               break;
            case "controllerOn_txt":
               OptionMenu.controllerOn = true;
               this.gameMain.optionMenu.updateMe(this.gameMain.stage,AreaCreator.background1,this.gameMain.save_sharedObject,this.gameMain.controllerMain);
               break;
            case "fullScreen_btn":
               try
               {
                  this.gameMain.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
               }
               catch(_fullError:Error)
               {
                  gameMain.mMenu.fullScreen_txt.text = "The website you are on does not support full screen games.";
               }
               break;
            case "enemySound_btn":
               SoundManager.playSound(Stats.eDescs[this.gameMain.heroMenu.selectedEnemy].sound);
               break;
            case "buyPersonaly_btn":
               miscString = "http://api.playerio.com/payvault/personaly/coinsredirect?gameid=hho-ygpra4ftumusohpifpdug";
               miscString += "&connectuserid=" + this.gameMain.theClient.connectUserId;
               miscString += "&connection=public";
               redirect_url = new URLRequest(miscString);
               navigateToURL(redirect_url,"_blank");
               break;
            case "defineButtons_btn":
               this.gameMain.setButtonsMode = true;
               this.gameMain.optionMenu.buttons_txt.text = "push a button for attack";
               break;
            case "jumpSkill_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["jump height"].required)
               {
                  ++this.gameMain.player.jumpSkillLvl;
                  this.gameMain.player.jumpPower = 20 + this.gameMain.player.jumpSkillLvl * 0.3;
                  this.gameMain.player.skillPoints -= Stats.skillStats["jump height"].required;
                  this.gameMain.theConnection.send("addSkill","jump skill");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "criticalDamage_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["critical hit"].required)
               {
                  ++this.gameMain.player.criticalLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["critical hit"].required;
                  this.gameMain.theConnection.send("addSkill","critical hit");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "lootSteal_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["loot steal"].required)
               {
                  ++this.gameMain.player.lootStealLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["loot steal"].required;
                  this.gameMain.theConnection.send("addSkill","loot steal");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "training_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["training"].required)
               {
                  ++this.gameMain.player.defense;
                  ++this.gameMain.player.power;
                  ++this.gameMain.player.range;
                  ++this.gameMain.player.magic;
                  ++this.gameMain.player.artillery;
                  this.gameMain.player.MP += 10;
                  this.gameMain.player.totalMP += 10;
                  this.gameMain.player.health += 10;
                  this.gameMain.player.totalHealth += 10;
                  ++this.gameMain.player.trainingLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["training"].required;
                  this.gameMain.theConnection.send("addSkill","training");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "selfRage_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["self rage"].required)
               {
                  ++this.gameMain.player.selfRageLvl;
                  this.gameMain.player.energyController.rage = this.gameMain.player.selfRageLvl * 0.028572;
                  this.gameMain.player.skillPoints -= Stats.skillStats["self rage"].required;
                  this.gameMain.theConnection.send("addSkill","self rage");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "guildRage_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["guild rage"].required)
               {
                  ++this.gameMain.player.guildRageLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["guild rage"].required;
                  this.gameMain.theConnection.send("addSkill","guild rage");
                  this.gameMain.skillsMenu.updateMe();
                  this.controls.setMoreMobileButtons(this.gameMain.player);
               }
               break;
            case "mpRestore_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["mp restore"].required)
               {
                  ++this.gameMain.player.mpRestoreLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["mp restore"].required;
                  this.gameMain.theConnection.send("addSkill","mp restore");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "avoidance_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["avoidability"].required)
               {
                  ++this.gameMain.player.avoidabilityLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["avoidability"].required;
                  this.gameMain.theConnection.send("addSkill","avoidability");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "dash_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["speed dash"].required)
               {
                  ++this.gameMain.player.dashLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["speed dash"].required;
                  this.gameMain.theConnection.send("addSkill","speed dash");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "accel_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["accel down"].required)
               {
                  ++this.gameMain.player.accelDownLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["accel down"].required;
                  this.gameMain.theConnection.send("addSkill","accel down");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "block_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["block"].required)
               {
                  ++this.gameMain.player.blockLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["block"].required;
                  this.gameMain.theConnection.send("addSkill","block");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "barrage_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["arrow barrage"].required)
               {
                  ++this.gameMain.player.barrageLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["arrow barrage"].required;
                  this.gameMain.theConnection.send("addSkill","arrow barrage");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "expertArcher_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["expert archer"].required)
               {
                  ++this.gameMain.player.expertArcherLvl;
                  ++this.gameMain.player.range;
                  this.gameMain.player.skillPoints -= Stats.skillStats["expert archer"].required;
                  this.gameMain.theConnection.send("addSkill","expert archer");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "tripleShot_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["triple shot"].required)
               {
                  ++this.gameMain.player.tripleShotLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["triple shot"].required;
                  this.gameMain.theConnection.send("addSkill","triple shot");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "arrowRain_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["arrow rain"].required)
               {
                  ++this.gameMain.player.arrowRainLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["arrow rain"].required;
                  this.gameMain.theConnection.send("addSkill","arrow rain");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "piercingArrow_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["piercing arrow"].required)
               {
                  ++this.gameMain.player.piercingArrowLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["piercing arrow"].required;
                  this.gameMain.theConnection.send("addSkill","piercing arrow");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "arrowKnockback_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["arrow knockback"].required)
               {
                  ++this.gameMain.player.arrowKnockbackLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["arrow knockback"].required;
                  this.gameMain.theConnection.send("addSkill","arrow knockback");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "downCrush_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["down crush"].required)
               {
                  ++this.gameMain.player.downCrushLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["down crush"].required;
                  this.gameMain.theConnection.send("addSkill","down crush");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "powerAttack_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["power attack"].required)
               {
                  ++this.gameMain.player.powerAttackLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["power attack"].required;
                  this.gameMain.theConnection.send("addSkill","power attack");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "expertWarrior_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["expert warrior"].required)
               {
                  ++this.gameMain.player.expertWarriorLvl;
                  ++this.gameMain.player.power;
                  this.gameMain.player.skillPoints -= Stats.skillStats["expert warrior"].required;
                  this.gameMain.theConnection.send("addSkill","expert warrior");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "chainDistance_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["air slash"].required)
               {
                  ++this.gameMain.player.chainDistanceLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["air slash"].required;
                  this.gameMain.theConnection.send("addSkill","air slash");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "shieldMastery_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["shield mastery"].required)
               {
                  ++this.gameMain.player.shieldMasteryLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["shield mastery"].required;
                  this.gameMain.theConnection.send("addSkill","shield mastery");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "multiAttack_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["multi attack"].required)
               {
                  ++this.gameMain.player.multiAttackLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["multi attack"].required;
                  this.gameMain.theConnection.send("addSkill","multi attack");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "meleeKnockback_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["melee knockback"].required)
               {
                  ++this.gameMain.player.meleeKnockbackLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["melee knockback"].required;
                  this.gameMain.theConnection.send("addSkill","melee knockback");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "spinAttack_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["spin attack"].required)
               {
                  ++this.gameMain.player.spinAttackLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["spin attack"].required;
                  this.gameMain.theConnection.send("addSkill","spin attack");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "magicShots_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["magic shots"].required)
               {
                  ++this.gameMain.player.magicShotsLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["magic shots"].required;
                  this.gameMain.theConnection.send("addSkill","magic shots");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "expertWizard_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["expert wizard"].required)
               {
                  ++this.gameMain.player.magic;
                  ++this.gameMain.player.expertWizardLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["expert wizard"].required;
                  this.gameMain.theConnection.send("addSkill","expert wizard");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "circularMagic_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["circular attack"].required)
               {
                  ++this.gameMain.player.lightBeamLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["circular attack"].required;
                  this.gameMain.theConnection.send("addSkill","circular attack");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "magicDistance_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["magic distance"].required)
               {
                  ++this.gameMain.player.magicDistanceLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["magic distance"].required;
                  this.gameMain.theConnection.send("addSkill","magic distance");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "thunderMagic_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["thunder attack"].required)
               {
                  ++this.gameMain.player.thunderAttackLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["thunder attack"].required;
                  this.gameMain.theConnection.send("addSkill","thunder attack");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "selfHeal_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["self heal"].required)
               {
                  ++this.gameMain.player.selfHealLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["self heal"].required;
                  this.gameMain.theConnection.send("addSkill","self heal");
                  this.gameMain.skillsMenu.updateMe();
                  this.controls.setMoreMobileButtons(this.gameMain.player);
               }
               break;
            case "guildHeal_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["guild heal"].required)
               {
                  ++this.gameMain.player.guildHealLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["guild heal"].required;
                  this.gameMain.theConnection.send("addSkill","guild heal");
                  this.gameMain.skillsMenu.updateMe();
                  this.controls.setMoreMobileButtons(this.gameMain.player);
               }
               break;
            case "grenade_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["grenade attack"].required)
               {
                  ++this.gameMain.player.grenadeLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["grenade attack"].required;
                  this.gameMain.theConnection.send("addSkill","grenade attack");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "upward_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["upward shoot"].required)
               {
                  ++this.gameMain.player.upwardShootLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["upward shoot"].required;
                  this.gameMain.theConnection.send("addSkill","upward shoot");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "expertCowboy_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["expert cowboy"].required)
               {
                  ++this.gameMain.player.artillery;
                  ++this.gameMain.player.expertCowboyLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["expert cowboy"].required;
                  this.gameMain.theConnection.send("addSkill","expert cowboy");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "bulletDistance_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["bullet distance"].required)
               {
                  ++this.gameMain.player.bulletDistanceLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["bullet distance"].required;
                  this.gameMain.theConnection.send("addSkill","bullet distance");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "shotgun_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["shotgun attack"].required)
               {
                  ++this.gameMain.player.shotgunLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["shotgun attack"].required;
                  this.gameMain.theConnection.send("addSkill","shotgun attack");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "bulletKnockback_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["bullet knockback"].required)
               {
                  ++this.gameMain.player.bulletKnockbackLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["bullet knockback"].required;
                  this.gameMain.theConnection.send("addSkill","bullet knockback");
                  this.gameMain.skillsMenu.updateMe();
               }
               break;
            case "jumpGrenade_btn":
               if(this.gameMain.player.skillPoints >= Stats.skillStats["jump grenade"].required)
               {
                  ++this.gameMain.player.jumpGrenadeLvl;
                  this.gameMain.player.skillPoints -= Stats.skillStats["jump grenade"].required;
                  this.gameMain.theConnection.send("addSkill","jump grenade");
                  this.gameMain.skillsMenu.updateMe();
               }
         }
         if(this.clickedDownTarget is Person && Person(this.clickedDownTarget).npc == false)
         {
            this.gameMain.createCMenu(Person(this.clickedDownTarget));
         }
         else if(_target is Image && Image(_target).texture == FriendMenu.friendMenu_textureAtlas.getTexture("friend slot_00"))
         {
            targetName = this.gameMain.friendMenu.panelToName(Image(_target));
            fullName = this.gameMain.friendMenu.nameToFullName(targetName);
            if(this.gameMain.friendMenu.title_txt.text != FriendMenu.ENEMIES.toUpperCase())
            {
               tempInfoArray = this.gameMain.friendMenu.title_txt.text == FriendMenu.FRIENDS.toUpperCase() ? FriendMenu.friendsInfo_array : FriendMenu.guildInfo_array;
               friendFound = false;
               for each(_personObject in tempInfoArray)
               {
                  if(Person.removeNamePrefix(_personObject.name) == targetName)
                  {
                     this.gameMain.friendMenu.showFriend(_personObject);
                     friendFound = true;
                     break;
                  }
               }
               Image(_target).texture = FriendMenu.friendMenu_textureAtlas.getTexture("friend slot_01");
               if(friendFound == false)
               {
                  this.gameMain.theClient.bigDB.load("PlayerObjects",fullName,function(param1:DatabaseObject):void
                  {
                     if(param1 != null)
                     {
                        if(param1.name == null)
                        {
                           param1.name = param1.key;
                        }
                        gameMain.friendMenu.showFriend(param1);
                     }
                  });
               }
            }
            else if(fullName.indexOf("facebook") != 0 && fullName.indexOf("kongregate") != 0 && fullName.indexOf("steam") != 0 && fullName.indexOf("playerio") != 0)
            {
               this.gameMain.theClient.bigDB.load("PlayerObjects",fullName,function(param1:DatabaseObject):void
               {
                  param1.name = param1.key;
                  gameMain.friendMenu.showFriend(param1);
                  Image(_target).texture = FriendMenu.friendMenu_textureAtlas.getTexture("friend slot_01");
               });
            }
            else
            {
               this.gameMain.theClient.bigDB.loadSingle("PlayerObjects","nameIndex",[fullName],function(param1:DatabaseObject):void
               {
                  gameMain.friendMenu.showFriend(param1);
                  Image(_target).texture = FriendMenu.friendMenu_textureAtlas.getTexture("friend slot_01");
               });
            }
         }
         else if(_target is Image && _target.name != null && _target.name.indexOf("level_") == 0)
         {
            if(this.gameMain.hasTeleport && this.gameMain.player.health > 0 && this.gameMain.player.rotation == 0 && (this.gameMain.confirmMenu == null || this.gameMain.confirmMenu.parent == null))
            {
               if(this.gameMain.player.isControllingPet == false)
               {
                  overLevel_string = "0";
                  overLevel_string = _target.name.charAt(_target.name.search(this.gameMain.numberString));
                  if(_target.name.length == 8)
                  {
                     overLevel_string += _target.name.charAt(_target.name.search(this.gameMain.numberString) + 1);
                  }
                  else if(_target.name.length == 9)
                  {
                     overLevel_string += _target.name.charAt(_target.name.search(this.gameMain.numberString) + 1);
                     overLevel_string += _target.name.charAt(_target.name.search(this.gameMain.numberString) + 2);
                  }
                  if(int(overLevel_string) != this.gameMain.c_mc.currentFrame)
                  {
                     this.gameMain.mapMenu.showTeleportArrow(int(overLevel_string));
                     this.gameMain.createConfirmMenu("Do you wish to teleport to " + Stats.levelStats[int(overLevel_string)].fname,"area teleport");
                     this.gameMain.confirmMenu.areaToTeleport = int(overLevel_string);
                  }
                  else
                  {
                     this.gameMain.createAlert("You are already in this area");
                  }
               }
               else
               {
                  this.gameMain.createAlert("You cannot teleport when controlling a pet");
               }
            }
         }
         else if(_target is Image && Image(_target).texture == GuildMemberMenu.guildMemberMenu_textureAtlas.getTexture("name panel_00"))
         {
            this.gameMain.guildMemberMenu.selectMember(_target);
         }
         else if(_target is Image && (Image(_target).texture == ItemMenu.itemMenu_textureAtlas.getTexture("item panel_00") || Image(_target).texture == ItemMenu.itemMenu_textureAtlas.getTexture("item panel_01") || Image(_target).texture == ItemMenu.itemMenu_textureAtlas.getTexture("item panel_02") || Image(_target).texture == ItemMenu.itemMenu_textureAtlas.getTexture("item panel_03")))
         {
            tempFocusMenu = StarlingGameMenu.getFocusMenu();
            if(tempFocusMenu is ItemMenu)
            {
               this.gameMain.itemMenu.clickItem(Image(_target),this.gameMain.player,this.gameMain.c_mc,this.gameMain.hasResale,this.gameMain.numberString);
            }
            else if(tempFocusMenu is PetItemMenu)
            {
               this.gameMain.petItemMenu.showItem(Image(_target));
            }
            else if(tempFocusMenu is TradeMenu)
            {
               this.gameMain.tradeMenu.clickItem(Image(_target),this.gameMain.player,this.gameMain.c_mc,this.gameMain.hasResale,this.gameMain.numberString);
            }
            else if(tempFocusMenu is BankMenu)
            {
               this.gameMain.bankMenu.clickItem(Image(_target));
            }
         }
         else if(_target is Image && Image(_target).texture == PetMenu.petMenu_textureAtlas.getTexture("panel_00"))
         {
            if(StarlingGameMenu.getFocusMenu() is PetMenu)
            {
               this.gameMain.petMenu.deselectAll();
               Image(_target).texture = PetMenu.petMenu_textureAtlas.getTexture("panel_01");
               this.gameMain.petMenu.selectPet(Image(_target));
            }
            else if(StarlingGameMenu.getFocusMenu() is PetShopMenu)
            {
               this.gameMain.petShopMenu.deselectAll();
               Image(_target).texture = PetMenu.petMenu_textureAtlas.getTexture("panel_01");
               this.gameMain.petShopMenu.selectPet(Image(_target));
            }
         }
         else if(_target is Item && Item(_target).useHandCursor == true)
         {
            this.gameMain.tradeMenu.showItemStats(Item(_target).type);
         }
         else if(_target is Pet)
         {
            if(_target.parent == this.c_mc)
            {
               this.gameMain.createCMenu(Pet(_target).owner);
            }
            else if(_target.parent is TradeMenu)
            {
               this.gameMain.tradeMenu.showPet(Pet(_target));
            }
         }
         else if(_target is Image && (Image(_target).texture == PetModeMenu.petModeMenu_textureAtlas.getTexture("mode_00") || Image(_target).texture == PetModeMenu.petModeMenu_textureAtlas.getTexture("mode_01") || Image(_target).texture == PetModeMenu.petModeMenu_textureAtlas.getTexture("mode_02")))
         {
            this.gameMain.petModeMenu.selectMode(Image(_target));
         }
         else if(_target is Image && Image(_target).texture == PetModeMenu.petModeMenu_textureAtlas.getTexture("xp_00"))
         {
            this.gameMain.petModeMenu.selectXP(Image(_target));
         }
         else if(_target is Image && Image(_target).texture == ItemMenu.itemMenu_textureAtlas.getTexture("craft item panel_00"))
         {
            this.gameMain.craftingMenu.showItemStats(this.gameMain.craftingMenu.panelToItem(Image(_target)),Image(_target));
         }
         else if(_target is TalkBubble && this.gameMain.player.health > 0)
         {
            this.gameMain.handleBubbleText(TalkBubble(_target).talkID,TalkBubble(_target).connectedPerson);
         }
         else if(_target is Image && Image(_target).texture == ItemMenu.itemMenu_textureAtlas.getTexture("mission panel_00"))
         {
            this.gameMain.missionMenu.clickPanel(Image(_target));
         }
         else if(_target is Image && Image(_target).texture == ItemMenu.itemMenu_textureAtlas.getTexture("PM person panel_00"))
         {
            this.gameMain.pmMenu.selectPanel(Image(_target));
         }
         else if(_target is Image && Image(_target).texture == HeropediaMenu.heropediaMenu_textureAtlas.getTexture("click panel 1"))
         {
            if(_target.scale == 1)
            {
               this.gameMain.heroMenu.showEStats(this.gameMain.heroMenu.panelToEnemy(Image(_target)));
            }
            else
            {
               this.gameMain.heroMenu.showFishStats(this.gameMain.heroMenu.panelToFish(Image(_target)));
            }
         }
         if(_target.useHandCursor)
         {
            SoundManager.playSound(SoundLibrary.click_sound);
         }
      }
      
      private function equipCheck(param1:Boolean) : void
      {
         if(this.gameMain.player.lev >= Stats.getItemArray(Stats.getItemType(this.gameMain.itemMenu.item_txt.text))[this.gameMain.itemMenu.item_txt.text].reqLev)
         {
            this.gameMain.equipItem(this.gameMain.itemMenu.item_txt.text,param1);
            this.gameMain.itemMenu.equip_btn.visible = false;
            this.gameMain.itemMenu.unEquip_btn.visible = true;
            this.gameMain.itemMenu.updateMe(this.gameMain.maxItems,this.gameMain.personItem_array,this.gameMain.player);
            SetHue.tintObject(this.gameMain.itemMenu,16777215);
         }
         else
         {
            this.gameMain.createAlert("Cannot equip: You are not high enough level to use this item");
         }
         this.gameMain.itemMenu.updateMe(this.gameMain.maxItems,this.gameMain.personItem_array,this.gameMain.player,false);
         this.gameMain.itemMenu.removeDualWieldMenu();
      }
      
      private function onMouseOver(param1:starling.display.DisplayObject) : void
      {
         var _loc2_:Pet = null;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:int = 0;
         var _loc15_:String = null;
         var _loc16_:String = null;
         var _loc17_:String = null;
         switch(param1.name)
         {
            case "petMoreInfo_btn":
               _loc2_ = Pet(CommonCalls.returnObject(this.gameMain.player.pet_array,this.gameMain.petMenu.selectedPetName));
               this.gameMain.createInfoMenu("Original owner: " + _loc2_.originalOwner + "\n" + "Base Power: " + Stats.petStats[_loc2_.type].power + "\n" + "Base Health: " + Stats.petStats[_loc2_.type].health + "\n" + "Base Defense: " + Stats.petStats[_loc2_.type].defense + "\n" + "Base Dexterity: " + Stats.petStats[_loc2_.type].dex + "\n" + Stats.petStats[_loc2_.type].desc,"big");
               break;
            case "mpUsage_btn":
               this.gameMain.createInfoMenu("The amount of MP you use increases as you get stronger.  Every 100 levels your character gains, you use 1x the amount of MP as stated.  For example, if you are level 320 and a skill says it uses 6 MP, it will cost you 24mp.","big");
               break;
            case "hpMore_btn":
               this.gameMain.createInfoMenu("Your current and total health. Having more health allows you to take more damage without dying.");
               break;
            case "mpMore_btn":
               this.gameMain.createInfoMenu("Current and total magic points are used for special attacks and are specially important for wizards.");
               break;
            case "powerMore_btn":
               this.gameMain.createInfoMenu("Power increases your damage you do with melee attacks.");
               break;
            case "dexMore_btn":
               this.gameMain.createInfoMenu("Dexterity increases your chance of doing a critical hit as well as increasing your movement speed.");
               break;
            case "rangeMore_btn":
               this.gameMain.createInfoMenu("Range increases the amount of damage you do with ranged attacks. (such as bows)");
               break;
            case "defenseMore_btn":
               this.gameMain.createInfoMenu("Defense helps you fend off enemy attacks. The higher your defense is, the less damage you take.");
               break;
            case "magicMore_btn":
               this.gameMain.createInfoMenu("Magic increases the damage you do with magic items such as wands and staffs.");
               break;
            case "artilleryMore_btn":
               this.gameMain.createInfoMenu("Artillery increases the damage you do with guns.");
               break;
            case "criticalInfo_btn":
               this.gameMain.createInfoMenu("Your chance of getting a critical hit. Your critical hits deal " + RoundToNearest.roundTo(10 * (2 + this.gameMain.player.criticalLvl / 8),10) * 10 + "% the amount of damage as a normal attack.");
               break;
            case "petMorePower_btn":
               _loc3_ = int(this.gameMain.petMenu.panel_array.length);
               _loc14_ = 0;
               while(_loc14_ < _loc3_)
               {
                  if(this.gameMain.petMenu.panel_array[_loc14_].texture == PetMenu.petMenu_textureAtlas.getTexture("panel_01"))
                  {
                     this.gameMain.createInfoMenu("Original owner: " + Pet(CommonCalls.returnObject(this.gameMain.player.pet_array,this.gameMain.petMenu.selectedPetName)).originalOwner + "\n" + "Base Power: " + Stats.petStats[this.gameMain.petMenu.petClone.type].power + "\n" + "Base Health: " + Stats.petStats[this.gameMain.petMenu.petClone.type].health + "\n" + "Base Defense: " + Stats.petStats[this.gameMain.petMenu.petClone.type].defense + "\n" + "Base Dexterity: " + Stats.petStats[this.gameMain.petMenu.petClone.type].dex + "\n" + Stats.petStats[this.gameMain.petMenu.petClone.type].desc,"big");
                     break;
                  }
                  _loc14_++;
               }
               break;
            case "fishingInfo_btn":
               this.gameMain.createInfoMenu("Fishing xp is gained by catching fish..  Fish that are caught can yield several benefits.  Fish can be eaten for HP by you or your pets.  " + "Shiny fish can also be eaten to gain special perks such as power, range, magic, or artillery.  Aside from being eaten, fish can also be sold for money.  Each fishing level you gain subtracts 1 from your natural reaction time for catching fish.","big");
               break;
            case "choppingInfo_btn":
               this.gameMain.createInfoMenu("Gained by chopping trees.  Having a higher chopping level allows you to chop down tree faster.  " + "The amount of damage you deal to trees is a result of your chopping level as well as your power/range/magic/artillery depending on the type of weapon you are using.","big");
               break;
            case "shortcutKey_btn":
               this.gameMain.createInfoMenu("Sets this item into your shortcut key (L key) for quick usage.");
               break;
            case "energyTotalPlus_btn":
               _loc4_ = Math.pow(2 + this.gameMain.player.energyController.totalMax * 5,8);
               this.gameMain.createInfoMenu("Cost: $" + _loc4_ + "\nIncreases the max total energy you can hold.  Your total energy is based off of all other energy meters and your charge.","big");
               break;
            case "energyChargePlus_btn":
               _loc5_ = Math.pow(2 + this.gameMain.player.energyController.chargeMax * 5,8);
               this.gameMain.createInfoMenu("Cost: $" + _loc5_ + "\nIncreases the max charge your character can power up to.  You can charge by holding down the R key.","big");
               break;
            case "energyAbsorbedPlus_btn":
               _loc6_ = Math.pow(2 + this.gameMain.player.energyController.absorbedMax * EnergyController.ABSORBED_WEIGHT,8);
               this.gameMain.createInfoMenu("Cost: $" + _loc6_ + "\nIncreases the max total absorbed energy you can hold.  Your absorbed bar can be filled by absorbing the energy of offering players.","big");
               break;
            case "energyLevelPlus_btn":
               _loc7_ = Math.pow(2 + this.gameMain.player.energyController.levelMax * EnergyController.LEVEL_WEIGHT,8);
               this.gameMain.createInfoMenu("Cost: $" + _loc7_ + "\nIncreases the max total level energy you can hold.  Your level bar is filled based on the level of your character.","big");
               break;
            case "energyEnemyPlus_btn":
               _loc8_ = Math.pow(2 + this.gameMain.player.energyController.enemyMax * EnergyController.ENEMY_WEIGHT,8);
               this.gameMain.createInfoMenu("Cost: $" + _loc8_ + "\nIncreases the max total enemy energy you can hold.  Your enemy energy bar can be filled by killing enemies.","big");
               break;
            case "energyPvpPlus_btn":
               _loc9_ = Math.pow(2 + this.gameMain.player.energyController.pvpMax * EnergyController.PVP_WEIGHT,8);
               this.gameMain.createInfoMenu("Cost: $" + _loc9_ + "\nIncreases the max total pvp energy you can hold.  Your pvp energy bar can be filled by killing players in any PVP area.","big");
               break;
            case "energyRandomPlus_btn":
               _loc10_ = Math.pow(2 + this.gameMain.player.energyController.levelMax * EnergyController.LEVEL_WEIGHT,8);
               this.gameMain.createInfoMenu("Cost: $" + _loc10_ + "\nIncreases the max total random energy you can hold.  This bar is randomly set and can not be controlled.  Consider yourself lucky if it is filled.","big");
               break;
            case "energyRagePlus_btn":
               _loc11_ = Math.pow(2 + this.gameMain.player.energyController.rageMax * EnergyController.RAGE_WEIGHT,8);
               this.gameMain.createInfoMenu("Cost: $" + _loc11_ + "\nIncreases the max total rage energy you can hold.  This bar is filled based on your rage skill.  The more skill points you have in your rage skill, the higher this bar will be filled.","big");
               break;
            case "energyChopPlus_btn":
               _loc12_ = Math.pow(2 + this.gameMain.player.energyController.chopMax * EnergyController.CHOP_WEIGHT,8);
               this.gameMain.createInfoMenu("Cost: $" + _loc12_ + "\nIncreases the max total chop energy you can hold.  Your chop energy bar can be filled by chopping more trees.","big");
               break;
            case "energyFishPlus_btn":
               _loc13_ = Math.pow(2 + this.gameMain.player.energyController.fishMax * EnergyController.FISH_WEIGHT,8);
               this.gameMain.createInfoMenu("Cost: $" + _loc13_ + "\nIncreases the max total fish energy you can hold.  Your fish energy bar can be filled by catching fish.","big");
               break;
            case "energyInfo_btn":
               this.gameMain.createInfoMenu("Displayed are your energy levels.  Use the \'R key\' to increase your charge.  When you are ready to unleash your energy, press the \'Y key\'.  To release your energy into the air or lend it so other players, hold the \'O key\'.","big");
         }
         if(param1 is Image && param1.name != null && param1.name.indexOf("level_") == 0)
         {
            _loc15_ = param1.name.charAt(param1.name.search(this.gameMain.numberString));
            if(param1.name.length == 8)
            {
               _loc15_ += param1.name.charAt(param1.name.search(this.gameMain.numberString) + 1);
            }
            else if(param1.name.length == 9)
            {
               _loc15_ += param1.name.charAt(param1.name.search(this.gameMain.numberString) + 1);
               _loc15_ += param1.name.charAt(param1.name.search(this.gameMain.numberString) + 2);
            }
            _loc16_ = Stats.levelStats[int(_loc15_)].fname + " (#" + _loc15_ + ")\n";
            if(this.gameMain.hasFishRadar)
            {
               for each(_loc17_ in MapMarker(param1).shinyFish_array)
               {
                  _loc16_ += _loc17_ + "\n";
               }
            }
            this.gameMain.createInfoMenu(_loc16_);
         }
      }
      
      private function onMouseOut(param1:starling.display.DisplayObject) : void
      {
      }
      
      private function onAddedToStage(param1:starling.events.Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addChild(AreaCreator.background3);
         addChild(AreaCreator.background2);
         addChild(AreaCreator.background1);
         addChild(this.c_mc);
         addEventListener(TouchEvent.TOUCH,this.onTouch);
         SortDepths.starlingStage = this;
      }
      
      public function startMain() : void
      {
         if(hasEventListener(Event.ENTER_FRAME) == false)
         {
            addEventListener(Event.ENTER_FRAME,this.onEnter);
         }
      }
      
      private function onEnter(param1:EnterFrameEvent) : void
      {
         var _loc2_:Pet = null;
         var _loc3_:Point = new Point(this.gameMain.player.controlledObject().creator.x,this.gameMain.player.controlledObject().creator.y);
         _loc3_ = this.c_mc.localToGlobal(_loc3_);
         if(_loc3_.x > Starling.current.viewPort.width / Starling.contentScaleFactor * 0.7)
         {
            this.scrollX(Starling.current.viewPort.width / Starling.contentScaleFactor * 0.7,_loc3_);
         }
         else if(_loc3_.x < Starling.current.viewPort.width / Starling.contentScaleFactor * 0.3)
         {
            this.scrollX(Starling.current.viewPort.width / Starling.contentScaleFactor * 0.3,_loc3_);
         }
         if(_loc3_.y > Starling.current.viewPort.height / Starling.contentScaleFactor * 0.65)
         {
            this.scrollY(Starling.current.viewPort.height / Starling.contentScaleFactor * 0.65,_loc3_);
         }
         else if(_loc3_.y < Starling.current.viewPort.height / Starling.contentScaleFactor * 0.35)
         {
            this.scrollY(Starling.current.viewPort.height / Starling.contentScaleFactor * 0.35,_loc3_);
         }
         var _loc4_:int = this.c_mc.numChildren;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(this.c_mc.getChildAt(_loc5_) is Person && Boolean(Person(this.c_mc.getChildAt(_loc5_)).npc))
            {
               if(Person(this.c_mc.getChildAt(_loc5_)).bodyAnimator.currentFrame > 47)
               {
                  Person(this.c_mc.getChildAt(_loc5_)).bodyAnimator.gotoAndPlay("standing");
               }
               Person(this.c_mc.getChildAt(_loc5_)).bodyAnimator.onEnter();
               Person(this.c_mc.getChildAt(_loc5_)).alignNameText();
            }
            _loc5_++;
         }
         if(this.scrollingMobileMenu)
         {
            this.scrollingMobileMenu.touchScroll(this.lastDownTouch.globalY - this.lastScrollY);
            this.lastScrollY = this.lastDownTouch.globalY;
         }
         this.gameMain.p_array.forEach(this.gameMain.onPerson);
         for each(_loc2_ in this.gameMain.pet_array)
         {
            _loc2_.onEnter();
         }
         if(GameMain.isMobile)
         {
            if(this.downTouching)
            {
               ++this.downTouchCounter;
               if(this.downTouchCounter > 20)
               {
                  this.onRightClick(this.lastDownTouch.target);
               }
            }
            else
            {
               this.downTouchCounter = 0;
            }
         }
      }
      
      private function scrollX(param1:Number, param2:Point) : void
      {
         var _loc3_:int = int(CalcDist.getDistX(param2.x,param1));
         this.gameMain.c_mc.x -= _loc3_;
         this.c_mc.x -= _loc3_;
         AreaCreator.background1.x -= _loc3_ / this.gameMain.SCROLL_X_MODIFIER;
         AreaCreator.background2.x -= _loc3_ / (this.gameMain.SCROLL_X_MODIFIER * 2);
         AreaCreator.background3.x -= _loc3_ / (this.gameMain.SCROLL_X_MODIFIER * 4);
         if(AreaCreator.cloud1 != null)
         {
            AreaCreator.cloud1.x -= _loc3_ / (this.gameMain.SCROLL_X_MODIFIER * 6);
         }
         AreaCreator.preventBGOffscreenX();
      }
      
      private function scrollY(param1:Number, param2:Point) : void
      {
         var _loc3_:int = int(CalcDist.getDistY(param2.y,param1));
         this.gameMain.c_mc.y += _loc3_;
         this.c_mc.y += _loc3_;
         AreaCreator.background1.y += _loc3_ / this.gameMain.SCROLL_Y_MODIFIER;
         AreaCreator.background2.y += _loc3_ / (this.gameMain.SCROLL_Y_MODIFIER * 2);
         AreaCreator.background3.y += _loc3_ / (this.gameMain.SCROLL_Y_MODIFIER * 4);
         if(AreaCreator.cloud1 != null)
         {
            AreaCreator.cloud1.y += _loc3_ / (this.gameMain.SCROLL_Y_MODIFIER * 6);
         }
         AreaCreator.preventBGOffscreenY();
      }
      
      private function onTouch(param1:starling.events.TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.BEGAN);
         var _loc3_:Touch = param1.getTouch(this,TouchPhase.HOVER);
         var _loc4_:Boolean = false;
         if(_loc2_ != null)
         {
            this.clickedDownTarget = _loc2_.target;
         }
         var _loc5_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc5_ != null && this.clickedDownTarget != null && this.clickedDownTarget.root != null && Boolean(this.clickedDownTarget.getBounds(root).contains(_loc5_.globalX,_loc5_.globalY)))
         {
            _loc4_ = true;
         }
         if(_loc2_ != null)
         {
            this.onMouseDown(_loc2_.target,_loc2_);
            this.__focus = _loc2_.target;
         }
         else if(_loc5_ != null)
         {
            this.onMouseUp(_loc5_.target);
         }
         if(_loc3_ != null && _loc3_.target != this.prevMouseOver_target)
         {
            this.onMouseOver(_loc3_.target);
         }
         if(_loc3_ == null || _loc3_.target != this.prevMouseOver_target)
         {
            this.onMouseOut(this.prevMouseOver_target);
         }
         if(_loc4_)
         {
            this.onClick(this.clickedDownTarget);
         }
         if(_loc5_ != null)
         {
            StarlingGameMenu.stopDragAll();
         }
         var _loc6_:Touch = param1.getTouch(this,TouchPhase.RIGHT_BEGAN);
         if(_loc6_ != null)
         {
            this.onRightClick(_loc6_.target);
         }
         if(param1.getTouch(this) == null)
         {
            if(this.gameMain.infoMenu != null && this.gameMain.infoMenu.parent != null)
            {
               this.gameMain.removeChild(this.gameMain.infoMenu);
            }
         }
         this.prevMouseOver_target = _loc3_ != null ? _loc3_.target : null;
      }
      
      private function onMouseDown(param1:starling.display.DisplayObject, param2:Touch) : void
      {
         this.lastDownTouch = param2;
         this.downTouching = true;
         if(param1.name == "drag_image" && param1.parent is StarlingGameMenu)
         {
            StarlingGameMenu(param1.parent).startDrag();
         }
         else if(param1.name == "scroll_btn")
         {
            this.gameMain.mDownTargetName = param1.name;
         }
         if(GameMain.isMobile)
         {
            if(param1.parent.name != null && param1.parent.name == "itemScrollList")
            {
               this.scrollingMobileMenu = IScrollableGameMenu(StarlingGameMenu.getFocusMenu());
               this.lastScrollY = param2.globalY;
            }
            else
            {
               this.scrollingMobileMenu = null;
            }
         }
         if(this.gameMain.player.health > 0)
         {
            switch(param1.name)
            {
               case "mobileAttack_btn":
                  this.controls.keyDown_event.keyCode = Keyboard.SPACE;
                  this.gameMain.onKDown(this.controls.keyDown_event);
                  break;
               case "mobileJump_btn":
                  this.controls.keyDown_event.keyCode = Keyboard.UP;
                  this.gameMain.onKDown(this.controls.keyDown_event);
                  break;
               case "mobileBlock_btn":
                  this.controls.keyDown_event.keyCode = Keyboard.V;
                  this.gameMain.onKDown(this.controls.keyDown_event);
                  break;
               case "mobileChopFish_btn":
                  this.controls.keyDown_event.keyCode = Keyboard.C;
                  this.gameMain.onKDown(this.controls.keyDown_event);
                  break;
               case "mobileUnleash_btn":
                  this.controls.keyDown_event.keyCode = Keyboard.Y;
                  this.gameMain.onKDown(this.controls.keyDown_event);
                  break;
               case "mobileGuildRage_btn":
                  this.controls.keyDown_event.keyCode = Keyboard.T;
                  this.gameMain.onKDown(this.controls.keyDown_event);
                  break;
               case "mobileHeal_btn":
                  this.controls.keyDown_event.keyCode = Keyboard.H;
                  this.gameMain.onKDown(this.controls.keyDown_event);
                  break;
               case "mobileGuildHeal_btn":
                  this.controls.keyDown_event.keyCode = Keyboard.G;
                  this.gameMain.onKDown(this.controls.keyDown_event);
                  break;
               case "mobileLoot_btn":
                  this.controls.keyDown_event.keyCode = Keyboard.E;
                  this.gameMain.onKDown(this.controls.keyDown_event);
                  break;
               case "mobileAnalog_btn":
                  this.controls.analogDown = true;
                  this.controls.analogDown_touch = param2;
            }
         }
         if(param1 is StarlingGameMenu)
         {
            StarlingGameMenu.focusMenu(StarlingGameMenu(param1));
         }
      }
      
      private function onMouseUp(param1:starling.display.DisplayObject) : void
      {
         this.scrollingMobileMenu = null;
         this.downTouching = false;
         if(this.gameMain.player.health > 0)
         {
            switch(param1.name)
            {
               case "mobileAttack_btn":
                  this.controls.keyUp_event.keyCode = Keyboard.SPACE;
                  this.gameMain.onKUp(this.controls.keyUp_event);
                  break;
               case "mobileJump_btn":
                  this.controls.keyUp_event.keyCode = Keyboard.UP;
                  this.gameMain.onKUp(this.controls.keyUp_event);
                  break;
               case "mobileBlock_btn":
                  this.controls.keyUp_event.keyCode = Keyboard.V;
                  this.gameMain.onKUp(this.controls.keyUp_event);
                  break;
               case "mobileChopFish_btn":
                  this.controls.keyUp_event.keyCode = Keyboard.C;
                  this.gameMain.onKUp(this.controls.keyUp_event);
                  break;
               case "mobileUnleash_btn":
                  this.controls.keyUp_event.keyCode = Keyboard.Y;
                  this.gameMain.onKUp(this.controls.keyUp_event);
                  break;
               case "mobileGuildRage_btn":
                  this.controls.keyUp_event.keyCode = Keyboard.T;
                  this.gameMain.onKUp(this.controls.keyUp_event);
                  break;
               case "mobileHeal_btn":
                  this.controls.keyUp_event.keyCode = Keyboard.H;
                  this.gameMain.onKUp(this.controls.keyUp_event);
                  break;
               case "mobileGuildHeal_btn":
                  this.controls.keyUp_event.keyCode = Keyboard.G;
                  this.gameMain.onKUp(this.controls.keyUp_event);
                  break;
               case "mobileLoot_btn":
                  this.controls.keyUp_event.keyCode = Keyboard.E;
                  this.gameMain.onKUp(this.controls.keyUp_event);
                  break;
               case "mobileAnalog_btn":
                  this.controls.analogDown = false;
            }
         }
      }
      
      private function onRightClick(param1:starling.display.DisplayObject) : void
      {
         if(this.gameMain.rcMenu != null && this.gameMain.rcMenu.parent != null)
         {
            this.gameMain.removeChild(this.gameMain.rcMenu);
         }
         if(param1 is IClickable)
         {
            IClickable(param1).rightClick();
         }
      }
      
      public function get focus() : starling.display.DisplayObject
      {
         return this.__focus;
      }
   }
}

