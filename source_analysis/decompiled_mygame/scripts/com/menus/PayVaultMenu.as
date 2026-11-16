package com.menus
{
   import com.apis.*;
   import com.apis.Facebook_API.*;
   import com.game_objects.Person;
   import com.stats.*;
   import com.utilities.*;
   import flash.display.*;
   import flash.events.Event;
   import flash.text.*;
   import playerio.Client;
   import playerio.DatabaseObject;
   import playerio.PlayerIOError;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1386")]
   public final class PayVaultMenu extends GameMenu
   {
      
      public static var countryName:String = "United States";
      
      public var back2_btn:SimpleButton;
      
      public var balloonPackMoney_txt:TextField;
      
      public var balloonPackTickets_txt:TextField;
      
      public var balloonPack_btn:SimpleButton;
      
      public var butterflyMoney_txt:TextField;
      
      public var butterflyTickets_txt:TextField;
      
      public var butterfly_btn:SimpleButton;
      
      public var buyFacebook100_btn:SimpleButton;
      
      public var buyFacebook10_btn:SimpleButton;
      
      public var buyFacebook1300_btn:SimpleButton;
      
      public var buyFacebook220_btn:SimpleButton;
      
      public var buyFacebook2800_btn:SimpleButton;
      
      public var buyFacebook450_btn:SimpleButton;
      
      public var buyFacebook50_btn:SimpleButton;
      
      public var buyFacebook6000_btn:SimpleButton;
      
      public var buyGPlay100_btn:SimpleButton;
      
      public var buyGPlay10_btn:SimpleButton;
      
      public var buyGPlay1300_btn:SimpleButton;
      
      public var buyGPlay220_btn:SimpleButton;
      
      public var buyGPlay2800_btn:SimpleButton;
      
      public var buyGPlay450_btn:SimpleButton;
      
      public var buyGPlay50_btn:SimpleButton;
      
      public var buyGPlay6000_btn:SimpleButton;
      
      public var buyIOS100_btn:SimpleButton;
      
      public var buyIOS10_btn:SimpleButton;
      
      public var buyIOS1300_btn:SimpleButton;
      
      public var buyIOS220_btn:SimpleButton;
      
      public var buyIOS2800_btn:SimpleButton;
      
      public var buyIOS450_btn:SimpleButton;
      
      public var buyIOS50_btn:SimpleButton;
      
      public var buyKongregate100_btn:SimpleButton;
      
      public var buyKongregate10_btn:SimpleButton;
      
      public var buyKongregate1300_btn:SimpleButton;
      
      public var buyKongregate220_btn:SimpleButton;
      
      public var buyKongregate2800_btn:SimpleButton;
      
      public var buyKongregate450_btn:SimpleButton;
      
      public var buyKongregate50_btn:SimpleButton;
      
      public var buyKongregate6000_btn:SimpleButton;
      
      public var buyPersonaly_btn:SimpleButton;
      
      public var buyPlayerIO100_btn:SimpleButton;
      
      public var buyPlayerIO10_btn:SimpleButton;
      
      public var buyPlayerIO1300_btn:SimpleButton;
      
      public var buyPlayerIO220_btn:SimpleButton;
      
      public var buyPlayerIO2800_btn:SimpleButton;
      
      public var buyPlayerIO450_btn:SimpleButton;
      
      public var buyPlayerIO50_btn:SimpleButton;
      
      public var buyPlayerIO6000_btn:SimpleButton;
      
      public var buyPrivateServer_btn:SimpleButton;
      
      public var buySteam100_btn:SimpleButton;
      
      public var buySteam10_btn:SimpleButton;
      
      public var buySteam1300_btn:SimpleButton;
      
      public var buySteam220_btn:SimpleButton;
      
      public var buySteam2800_btn:SimpleButton;
      
      public var buySteam450_btn:SimpleButton;
      
      public var buySteam50_btn:SimpleButton;
      
      public var buySteam6000_btn:SimpleButton;
      
      public var buySuperRewards_btn:SimpleButton;
      
      public var buyTickets100_btn:SimpleButton;
      
      public var buyTickets10_btn:SimpleButton;
      
      public var buyTickets1300_btn:SimpleButton;
      
      public var buyTickets220_btn:SimpleButton;
      
      public var buyTickets2800_btn:SimpleButton;
      
      public var buyTickets450_btn:SimpleButton;
      
      public var buyTickets50_btn:SimpleButton;
      
      public var buyTickets6000_btn:SimpleButton;
      
      public var buyTrialPay_btn:SimpleButton;
      
      public var coin_mc:MovieClip;
      
      public var cost100_txt:TextField;
      
      public var cost10_txt:TextField;
      
      public var cost1300_txt:TextField;
      
      public var cost220_txt:TextField;
      
      public var cost2800_txt:TextField;
      
      public var cost450_txt:TextField;
      
      public var cost50_txt:TextField;
      
      public var cost6000_txt:TextField;
      
      public var dinoTailMoney_txt:TextField;
      
      public var dinoTailTickets_txt:TextField;
      
      public var dinoTail_btn:SimpleButton;
      
      public var enemyControl_txt:TextField;
      
      public var evilWingsMoney_txt:TextField;
      
      public var evilWingsTickets_txt:TextField;
      
      public var evilWings_btn:SimpleButton;
      
      public var getTickets_btn:SimpleButton;
      
      public var guildMembersOnly_mc:MovieClip;
      
      public var hair10_btn:BuyHairButton;
      
      public var hair10_mc:PersonHair;
      
      public var hair10_txt:TextField;
      
      public var hair11_btn:BuyHairButton;
      
      public var hair11_mc:PersonHair;
      
      public var hair11_txt:TextField;
      
      public var hair12_btn:BuyHairButton;
      
      public var hair12_mc:PersonHair;
      
      public var hair12_txt:TextField;
      
      public var hair13_btn:BuyHairButton;
      
      public var hair13_mc:PersonHair;
      
      public var hair13_txt:TextField;
      
      public var hair14_btn:BuyHairButton;
      
      public var hair14_mc:PersonHair;
      
      public var hair14_txt:TextField;
      
      public var hair15_btn:BuyHairButton;
      
      public var hair15_mc:PersonHair;
      
      public var hair15_txt:TextField;
      
      public var hair16_btn:BuyHairButton;
      
      public var hair16_mc:PersonHair;
      
      public var hair16_txt:TextField;
      
      public var hair17_btn:BuyHairButton;
      
      public var hair17_mc:PersonHair;
      
      public var hair17_txt:TextField;
      
      public var hair18_btn:BuyHairButton;
      
      public var hair18_mc:PersonHair;
      
      public var hair18_txt:TextField;
      
      public var hair19_btn:BuyHairButton;
      
      public var hair19_mc:PersonHair;
      
      public var hair19_txt:TextField;
      
      public var hair1_btn:BuyHairButton;
      
      public var hair1_mc:PersonHair;
      
      public var hair1_txt:TextField;
      
      public var hair20_btn:BuyHairButton;
      
      public var hair20_mc:PersonHair;
      
      public var hair20_txt:TextField;
      
      public var hair21_btn:BuyHairButton;
      
      public var hair21_mc:PersonHair;
      
      public var hair21_txt:TextField;
      
      public var hair22_btn:BuyHairButton;
      
      public var hair22_mc:PersonHair;
      
      public var hair22_txt:TextField;
      
      public var hair23_btn:BuyHairButton;
      
      public var hair23_mc:PersonHair;
      
      public var hair23_txt:TextField;
      
      public var hair24_btn:BuyHairButton;
      
      public var hair24_mc:PersonHair;
      
      public var hair24_txt:TextField;
      
      public var hair25_btn:BuyHairButton;
      
      public var hair25_mc:PersonHair;
      
      public var hair25_txt:TextField;
      
      public var hair26_btn:BuyHairButton;
      
      public var hair26_mc:PersonHair;
      
      public var hair26_txt:TextField;
      
      public var hair27_btn:BuyHairButton;
      
      public var hair27_mc:PersonHair;
      
      public var hair27_txt:TextField;
      
      public var hair28_btn:BuyHairButton;
      
      public var hair28_mc:PersonHair;
      
      public var hair28_txt:TextField;
      
      public var hair2_btn:BuyHairButton;
      
      public var hair2_mc:PersonHair;
      
      public var hair2_txt:TextField;
      
      public var hair3_btn:BuyHairButton;
      
      public var hair3_mc:PersonHair;
      
      public var hair3_txt:TextField;
      
      public var hair4_btn:BuyHairButton;
      
      public var hair4_mc:PersonHair;
      
      public var hair4_txt:TextField;
      
      public var hair5_btn:BuyHairButton;
      
      public var hair5_mc:PersonHair;
      
      public var hair5_txt:TextField;
      
      public var hair6_btn:BuyHairButton;
      
      public var hair6_mc:PersonHair;
      
      public var hair6_txt:TextField;
      
      public var hair7_btn:BuyHairButton;
      
      public var hair7_mc:PersonHair;
      
      public var hair7_txt:TextField;
      
      public var hair8_btn:BuyHairButton;
      
      public var hair8_mc:PersonHair;
      
      public var hair8_txt:TextField;
      
      public var hair9_btn:BuyHairButton;
      
      public var hair9_mc:PersonHair;
      
      public var hair9_txt:TextField;
      
      public var halo_mc:Halo;
      
      public var helipackMoney_txt:TextField;
      
      public var helipackTickets_txt:TextField;
      
      public var helipack_btn:SimpleButton;
      
      public var hitArea_mc:MovieClip;
      
      public var hitBox_mc:MovieClip;
      
      public var icon_mc:MovieClip;
      
      public var jetpackMoney_txt:TextField;
      
      public var jetpackTickets_txt:TextField;
      
      public var jetpack_btn:SimpleButton;
      
      public var list_mc:MovieClip;
      
      public var monkeyTailMoney_txt:TextField;
      
      public var monkeyTailTickets_txt:TextField;
      
      public var monkeyTail_btn:SimpleButton;
      
      public var name_txt:TextField;
      
      public var oldPassColon_txt:TextField;
      
      public var oldPassInfo_txt:TextField;
      
      public var oldServerPass_txt:TextField;
      
      public var paypal100_txt:TextField;
      
      public var paypal10_txt:TextField;
      
      public var paypal1300_txt:TextField;
      
      public var paypal220_txt:TextField;
      
      public var paypal2800_txt:TextField;
      
      public var paypal450_txt:TextField;
      
      public var paypal50_txt:TextField;
      
      public var paypal6000_txt:TextField;
      
      public var petControl_txt:TextField;
      
      public var pinkBalloonMoney_txt:TextField;
      
      public var pinkBalloonTickets_txt:TextField;
      
      public var pinkBalloon_btn:SimpleButton;
      
      public var players_txt:TextField;
      
      public var popBar_mc:MovieClip;
      
      public var redCapeMoney_txt:TextField;
      
      public var redCapeTickets_txt:TextField;
      
      public var redCape_btn:SimpleButton;
      
      public var saveServer_btn:SimpleButton;
      
      public var scroll_btn:SimpleButton;
      
      public var serverName_txt:TextField;
      
      public var serverPass_txt:TextField;
      
      public var timeSpan_txt:TextField;
      
      public var title_txt:TextField;
      
      public var wingsMoney_txt:TextField;
      
      public var wingsTickets_txt:TextField;
      
      public var wings_btn:SimpleButton;
      
      public var x_btn:SimpleButton;
      
      public var yourTickets_txt:TextField;
      
      private var ticketPackages_array:Vector.<uint> = new Vector.<uint>();
      
      private var costsUSD_array:Vector.<Number> = new Vector.<Number>();
      
      private var costsPHP_array:Vector.<Number> = new Vector.<Number>();
      
      private var costsCAD_array:Vector.<Number> = new Vector.<Number>();
      
      private var costsGBP_array:Vector.<Number> = new Vector.<Number>();
      
      private var __lastHairBought:uint = 1;
      
      private var gameMain:GameMain;
      
      public function PayVaultMenu(param1:GameMain)
      {
         super();
         addFrameScript(0,this.frame1);
         this.gameMain = param1;
         this.ticketPackages_array.push(10,50,100,220,450,1300,2800,6000);
         this.costsUSD_array.push(0.99,2.99,4.99,9.99,19.99,49.99,99.99,199.99);
         this.costsPHP_array.push(45,134,224,448,896,2240,4483,8966);
         this.costsCAD_array.push(1.11,3.32,5.54,11.11,22.22,55.58,111.18,222.39);
         this.costsGBP_array.push(0.62,1.86,3.1,6.21,12.43,31.08,62.18,124.36);
      }
      
      public function gotoPurchase() : void
      {
         var _loc1_:Vector.<Number> = null;
         gotoAndStop("payment methods");
         switch(this.currencyType)
         {
            case "USD":
               _loc1_ = this.costsUSD_array;
               break;
            case "PHP":
               _loc1_ = this.costsPHP_array;
               break;
            case "CAD":
               _loc1_ = this.costsCAD_array;
               break;
            case "GBP":
               _loc1_ = this.costsGBP_array;
         }
         this.paypal10_txt.text = this.ticketPackages_array[0] + " tickets for " + this.currencySymbol + _loc1_[0];
         this.paypal50_txt.text = this.ticketPackages_array[1] + " tickets for " + this.currencySymbol + _loc1_[1];
         this.paypal100_txt.text = this.ticketPackages_array[2] + " tickets for " + this.currencySymbol + _loc1_[2];
         this.paypal220_txt.text = this.ticketPackages_array[3] + " tickets for " + this.currencySymbol + _loc1_[3];
         this.paypal450_txt.text = this.ticketPackages_array[4] + " tickets for " + this.currencySymbol + _loc1_[4];
         this.paypal1300_txt.text = this.ticketPackages_array[5] + " tickets for " + this.currencySymbol + _loc1_[5];
         this.paypal2800_txt.text = this.ticketPackages_array[6] + " tickets for " + this.currencySymbol + _loc1_[6];
         this.paypal6000_txt.text = this.ticketPackages_array[7] + " tickets for " + this.currencySymbol + _loc1_[7];
      }
      
      public function gotoFacebookPurchase() : void
      {
         gotoAndStop("facebook payment");
         this.setTicketCosts();
      }
      
      public function gotoKongregatePurchase() : void
      {
         gotoAndStop("kongregate payment");
      }
      
      public function gotoSteamPurchase() : void
      {
         gotoAndStop("steam payment");
         this.setTicketCosts();
      }
      
      public function gotoPlayerIOPurchase() : void
      {
         gotoAndStop("playerio payment");
         this.setTicketCosts();
      }
      
      public function gotoGooglePlayPurchase() : void
      {
         gotoAndStop("google play payment");
         this.setTicketCosts();
      }
      
      public function gotoIOSPurchase() : void
      {
         gotoAndStop("ios payment");
         this.setTicketCosts();
      }
      
      private function setTicketCosts() : void
      {
         var _loc1_:Vector.<Number> = null;
         switch(this.currencyType)
         {
            case "USD":
               _loc1_ = this.costsUSD_array;
               break;
            case "PHP":
               _loc1_ = this.costsPHP_array;
               break;
            case "CAD":
               _loc1_ = this.costsCAD_array;
               break;
            case "GBP":
               _loc1_ = this.costsGBP_array;
         }
         this.cost10_txt.text = this.ticketPackages_array[0] + " tickets for " + this.currencySymbol + _loc1_[0];
         this.cost50_txt.text = this.ticketPackages_array[1] + " tickets for " + this.currencySymbol + _loc1_[1];
         this.cost100_txt.text = this.ticketPackages_array[2] + " tickets for " + this.currencySymbol + _loc1_[2];
         this.cost220_txt.text = this.ticketPackages_array[3] + " tickets for " + this.currencySymbol + _loc1_[3];
         this.cost450_txt.text = this.ticketPackages_array[4] + " tickets for " + this.currencySymbol + _loc1_[4];
         this.cost1300_txt.text = this.ticketPackages_array[5] + " tickets for " + this.currencySymbol + _loc1_[5];
         this.cost2800_txt.text = this.ticketPackages_array[6] + " tickets for " + this.currencySymbol + _loc1_[6];
         if(this.cost6000_txt != null && this.cost6000_txt.parent != null)
         {
            this.cost6000_txt.text = this.ticketPackages_array[7] + " tickets for " + this.currencySymbol + _loc1_[7];
         }
      }
      
      public function gotoBuyHair(param1:int, param2:int) : void
      {
         gotoAndStop("change hair");
         this.hair2_mc.gotoAndStop(2);
         this.hair3_mc.gotoAndStop(3);
         this.hair4_mc.gotoAndStop(4);
         this.hair5_mc.gotoAndStop(5);
         this.hair6_mc.gotoAndStop(6);
         this.hair7_mc.gotoAndStop(7);
         this.hair8_mc.gotoAndStop(8);
         this.hair9_mc.gotoAndStop(9);
         this.hair10_mc.gotoAndStop(10);
         this.hair11_mc.gotoAndStop(16);
         this.hair12_mc.gotoAndStop(17);
         this.hair13_mc.gotoAndStop(18);
         this.hair14_mc.gotoAndStop(19);
         this.hair15_mc.gotoAndStop(20);
         this.hair16_mc.gotoAndStop(24);
         this.hair17_mc.gotoAndStop(25);
         this.hair18_mc.gotoAndStop(26);
         this.hair27_mc.gotoAndStop(27);
         this.hair28_mc.gotoAndStop(28);
         this.hair19_mc.gotoAndStop(11);
         this.hair20_mc.gotoAndStop(12);
         this.hair21_mc.gotoAndStop(13);
         this.hair22_mc.gotoAndStop(14);
         this.hair23_mc.gotoAndStop(15);
         this.hair24_mc.gotoAndStop(21);
         this.hair25_mc.gotoAndStop(22);
         this.hair26_mc.gotoAndStop(23);
         this.hair1_txt.text = this.hair2_txt.text = this.hair3_txt.text = this.hair4_txt.text = this.hair5_txt.text = this.hair6_txt.text = this.hair7_txt.text = this.hair8_txt.text = String(param1);
         this.hair9_txt.text = this.hair10_txt.text = this.hair12_txt.text = this.hair13_txt.text = this.hair14_txt.text = this.hair15_txt.text = this.hair16_txt.text = String(param1);
         this.hair17_txt.text = this.hair18_txt.text = this.hair19_txt.text = this.hair20_txt.text = this.hair21_txt.text = this.hair22_txt.text = this.hair23_txt.text = this.hair23_txt.text = String(param1);
         this.hair24_txt.text = this.hair25_txt.text = this.hair26_txt.text = String(param1);
         this.hair11_txt.text = this.hair27_txt.text = this.hair28_txt.text = String(param2);
      }
      
      public function gotoAccessories(param1:Vector.<DatabaseObject>) : void
      {
         gotoAndStop("buy accessories");
         this.redCapeTickets_txt.text = CommonCalls.returnObject(param1,"redcape").PriceCoins;
         this.jetpackTickets_txt.text = CommonCalls.returnObject(param1,"jetpack").PriceCoins;
         this.monkeyTailTickets_txt.text = CommonCalls.returnObject(param1,"monkeytail").PriceCoins;
         this.dinoTailTickets_txt.text = CommonCalls.returnObject(param1,"dinotail").PriceCoins;
         this.wingsTickets_txt.text = CommonCalls.returnObject(param1,"wings").PriceCoins;
         this.pinkBalloonTickets_txt.text = CommonCalls.returnObject(param1,"pinkballoon").PriceCoins;
         this.balloonPackTickets_txt.text = CommonCalls.returnObject(param1,"balloonpack").PriceCoins;
         this.evilWingsTickets_txt.text = CommonCalls.returnObject(param1,"evilwings").PriceCoins;
         this.butterflyTickets_txt.text = CommonCalls.returnObject(param1,"butterflywings").PriceCoins;
         this.helipackTickets_txt.text = CommonCalls.returnObject(param1,"helipack").PriceCoins;
         this.redCapeMoney_txt.text = Stats.accStats["red cape"].cost;
         this.jetpackMoney_txt.text = Stats.accStats["jet pack"].cost;
         this.monkeyTailMoney_txt.text = Stats.accStats["monkey tail"].cost;
         this.dinoTailMoney_txt.text = Stats.accStats["dino tail"].cost;
         this.wingsMoney_txt.text = Stats.accStats["wings"].cost;
         this.pinkBalloonMoney_txt.text = Stats.accStats["pink balloon"].cost;
         this.balloonPackMoney_txt.text = Stats.accStats["balloon pack"].cost;
         this.evilWingsMoney_txt.text = Stats.accStats["evil wings"].cost;
         this.butterflyMoney_txt.text = Stats.accStats["butterfly wings"].cost;
         this.helipackMoney_txt.text = Stats.accStats["heli pack"].cost;
      }
      
      public function buyFromFacebook(param1:uint, param2:Client) : void
      {
         var _tickets:uint = param1;
         var _client:Client = param2;
         var tempCoinsObject:Object = new Object();
         tempCoinsObject.coinamount = _tickets;
         tempCoinsObject.title = _tickets.toString() + " Tickets";
         tempCoinsObject.description = "Gives you " + _tickets + " tickets to spend in the Helmet Heroes Payvault.";
         tempCoinsObject.image = "http://yuriifedorov01-cpu.github.io/hht-client/helmet_heroes_stream/FB_PV_icons/ticket.png";
         tempCoinsObject.currencies = "USD,PHP,CAD,GBP";
         _client.payVault.getBuyCoinsInfo("facebookv2",tempCoinsObject,function(param1:Object):void
         {
            var _info:Object = param1;
            FB.ui(_info,function(param1:Object):void
            {
            });
         },function(param1:PlayerIOError):void
         {
         });
      }
      
      public function buyFromKongregate(param1:uint, param2:GameMain) : void
      {
         var _tickets:uint = param1;
         var _gameMain:GameMain = param2;
         Kongregate.kongregateAPI.mtx.purchaseItems(["coins" + _tickets.toString()],function(param1:Object):void
         {
            if(param1.success)
            {
               _gameMain.createAlert("purchase successful");
            }
            else
            {
               _gameMain.createAlert("purchase unsuccessful");
            }
         });
      }
      
      public function buyFromSteam(param1:uint, param2:GameMain) : void
      {
         var _tickets:uint = param1;
         var _gameMain:GameMain = param2;
         var tempCoinsObject:Object = new Object();
         tempCoinsObject.coinamount = _tickets;
         tempCoinsObject.currency = this.currencyType;
         tempCoinsObject.steamid = Steam.steam.getUserID();
         tempCoinsObject.appid = Steam.steam.getAppID();
         tempCoinsObject.language = "EN";
         tempCoinsObject.description = _tickets + " Helmet Heroes Payvault tickets.";
         Steam.steam.removeEventListener("steamResponse",this.steamEvent);
         Steam.steam.addEventListener("steamResponse",this.steamEvent);
         _gameMain.theClient.payVault.getBuyCoinsInfo("steam",tempCoinsObject,function(param1:Object):void
         {
         },function(param1:PlayerIOError):void
         {
            _gameMain.createAlert(param1.message);
         });
      }
      
      public function buyFromPlayerIO(param1:uint, param2:GameMain) : void
      {
         var _tickets:uint = param1;
         var _gameMain:GameMain = param2;
         var tempCoinsObject:Object = new Object();
         tempCoinsObject.name = _tickets + " Tickets";
         tempCoinsObject.description = "Buy " + _tickets + " tickets for the PayVault.";
         tempCoinsObject.icon = "http://helmet-heroes.com/images/75x75-payvault-icon.png";
         tempCoinsObject.currency = "USD";
         _gameMain.theClient.publishingnetwork.payments.showBuyCoinsDialog(_tickets,tempCoinsObject,function(param1:Object):void
         {
            _gameMain.createAlert("Purchase successfull!",true);
         },function(param1:PlayerIOError):void
         {
            _gameMain.createAlert(param1.message);
         });
      }
      
      public function buyFromGooglePlay(param1:uint) : void
      {
         GooglePlay.purchaseItem("coins" + param1);
      }
      
      public function buyFromIOS(param1:uint) : void
      {
         IOS.purchaseItem(param1);
      }
      
      private function steamEvent(param1:Event) : void
      {
         var e:Event = param1;
         var successObject:Object = null;
         var micro:Object = Steam.steam.microTxnResult();
         if(micro != null && micro.authorized == false)
         {
            this.gameMain.createAlert("transaction canceled");
         }
         else if(micro != null && micro.authorized == true)
         {
            successObject = new Object();
            successObject.orderid = micro.orderID;
            this.gameMain.theClient.payVault.usePaymentInfo("steam",successObject,function(param1:Object):void
            {
               gotoAndStop(1);
            },function(param1:PlayerIOError):void
            {
               gameMain.createAlert(param1.message);
            });
         }
      }
      
      public function buyHair(param1:SimpleButton, param2:Person, param3:GameMain, param4:uint) : void
      {
         var _loc5_:uint = 0;
         if(param4 >= uint(TextField(getChildByName(param1.name.substr(0,param1.name.length - 4) + "_txt")).text))
         {
            this.__lastHairBought = uint(MovieClip(getChildByName(param1.name.substr(0,param1.name.length - 4) + "_mc")).currentFrame);
            _loc5_ = uint(MovieClip(getChildByName(param1.name.substr(0,param1.name.length - 4) + "_mc")).currentFrame);
            if(_loc5_ == 16 || _loc5_ == 27 || _loc5_ == 28)
            {
               param3.theClient.payVault.buy([{"itemKey":"redhair"}],true,param3.boughtPVSpecialHair,param3.boughtPVError);
            }
            else
            {
               param3.theClient.payVault.buy([{"itemKey":"basichair"}],true,param3.boughtPVBasicHair,param3.boughtPVError);
            }
         }
         else
         {
            param3.createAlert("you do not have enough tickets to make this purchase");
         }
      }
      
      public function get currencyType() : String
      {
         switch(countryName)
         {
            case "United States":
               return "USD";
            case "Canada":
               return "CAD";
            case "Philippines":
               return "PHP";
            case "United Kingdom":
               return "GBP";
            default:
               return "USD";
         }
      }
      
      public function get currencySymbol() : String
      {
         switch(this.currencyType)
         {
            case "USD":
               return "$";
            case "PHP":
               return "₱";
            case "CAD":
               return "$";
            case "GBP":
               return "£";
            default:
               return "";
         }
      }
      
      public function get lastHairBought() : uint
      {
         return this.__lastHairBought;
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

