package com.menus
{
   import com.ui.*;
   import flash.display.*;
   import playerio.DatabaseObject;
   import starling.*;
   import starling.display.*;
   import starling.text.*;
   import starling.textures.*;
   
   public final class LotteryMenu extends StarlingGameMenu
   {
      
      private const ticketMinus_btn:Button = new Button(CharacterMenu.charMenu_textureAtlas.getTexture("less_btn_00"),"",null,CharacterMenu.charMenu_textureAtlas.getTexture("less_btn_01"));
      
      private const ticketPlus_btn:Button = new Button(CharacterMenu.charMenu_textureAtlas.getTexture("more_btn_00"),"",null,CharacterMenu.charMenu_textureAtlas.getTexture("more_btn_01"));
      
      private const coinMinus_btn:Button = new Button(this.ticketMinus_btn.upState,"",null,this.ticketMinus_btn.overState);
      
      private const coinPlus_btn:Button = new Button(this.ticketPlus_btn.upState,"",null,this.ticketPlus_btn.overState);
      
      private const buy_btn:Button = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("buy_btn"));
      
      private const yourEntries_txt:TextField = new TextField(349,49,"",AllTextFormats.entries_textFormat);
      
      private const yourCosts_txt:TextField = new TextField(250,40,"",AllTextFormats.costs_textFormat);
      
      private var __buyTickets:uint;
      
      private var __buyCoins:uint;
      
      public function LotteryMenu(param1:uint, param2:uint)
      {
         var _loc3_:Image = null;
         var _loc4_:Button = null;
         var _loc7_:TextField = null;
         _loc3_ = null;
         _loc4_ = null;
         var _loc5_:Image = null;
         super();
         _loc3_ = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("lottery panel"));
         _loc3_.x = -215;
         _loc3_.y = -124;
         addChild(_loc3_);
         this.buy_btn.x = 186;
         this.buy_btn.y = 140;
         this.buy_btn.pivotX = 33;
         this.buy_btn.pivotY = 15;
         this.buy_btn.name = "lotteryBuy_btn";
         addChild(this.buy_btn);
         _loc4_ = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_00"),"",ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_01"));
         _loc4_.x = 240;
         _loc4_.y = -108;
         _loc4_.pivotX = 30;
         _loc4_.pivotY = 19;
         _loc4_.name = "x_btn";
         addChild(_loc4_);
         this.ticketMinus_btn.x = -64;
         this.ticketMinus_btn.y = 80;
         this.ticketMinus_btn.name = "lotteryTicketMinus_btn";
         addChild(this.ticketMinus_btn);
         this.ticketPlus_btn.x = -34;
         this.ticketPlus_btn.y = 80;
         this.ticketPlus_btn.name = "lotteryTicketPlus_btn";
         addChild(this.ticketPlus_btn);
         this.coinMinus_btn.x = -77;
         this.coinMinus_btn.y = 106;
         this.coinMinus_btn.pivotX = this.ticketMinus_btn.pivotX = this.ticketMinus_btn.width / 2;
         this.coinMinus_btn.pivotY = this.ticketMinus_btn.pivotY = this.ticketMinus_btn.height / 2;
         this.coinMinus_btn.name = "lotteryCoinMinus_btn";
         this.coinMinus_btn.visible = this.ticketMinus_btn.visible = false;
         addChild(this.coinMinus_btn);
         this.coinPlus_btn.x = -49;
         this.coinPlus_btn.y = 106;
         this.coinPlus_btn.pivotX = this.ticketPlus_btn.pivotX = this.ticketPlus_btn.width / 2;
         this.coinPlus_btn.pivotY = this.ticketPlus_btn.pivotY = this.ticketPlus_btn.height / 2;
         this.coinPlus_btn.name = "lotteryCoinPlus_btn";
         addChild(this.coinPlus_btn);
         var _loc6_:String = "Ticket jackpot: " + uint(param1 * 0.65) + "\nCoins jackpot: $" + uint(param2 * 0.65);
         _loc7_ = new TextField(302,49,_loc6_,AllTextFormats.entries_textFormat);
         _loc7_.y = -83;
         addChild(_loc7_);
         this.yourEntries_txt.text = "Your current ticket entries: 0" + "\nYour current coin entries: 0";
         this.yourEntries_txt.x = _loc7_.x = -201;
         this.yourEntries_txt.y = -6;
         addChild(this.yourEntries_txt);
         this.yourCosts_txt.x = -16;
         this.yourCosts_txt.y = 67;
         addChild(this.yourCosts_txt);
         this.yourCosts_txt.touchable = this.yourEntries_txt.touchable = _loc7_.touchable = false;
         this.yourCosts_txt.batchable = this.yourEntries_txt.batchable = _loc7_.batchable = true;
         _loc5_ = new Image(Texture.fromBitmapData(new BitmapData(420,36,false,16711680)));
         _loc5_.x = -215;
         _loc5_.y = -125;
         _loc5_.alpha = 0;
         _loc5_.name = "drag_image";
         addChild(_loc5_);
      }
      
      public function updateMe(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _newTickets:int = param1;
         var _newCoins:int = param2;
         var _ownedTickets:int = param3;
         var _ownedMoney:int = param4;
         this.__buyTickets += _newTickets;
         this.__buyCoins += _newCoins;
         this.ticketMinus_btn.visible = this.buyTickets > 0;
         this.coinMinus_btn.visible = this.buyCoins > 0;
         this.ticketPlus_btn.visible = this.buyTickets < _ownedTickets;
         this.coinPlus_btn.visible = this.buyCoins + 10000 < _ownedMoney;
         this.yourCosts_txt.text = "entries: " + this.buyTickets + ", cost: " + this.buyTickets + "\nentries: " + this.buyCoins / 10000 + ", cost: $" + this.buyCoins;
         MainStarlingStage(root).gameMain.theClient.bigDB.load("lotteryTable",MainStarlingStage(root).gameMain.theClient.connectUserId,function(param1:DatabaseObject):void
         {
            if(param1 != null)
            {
               param1.coins = param1.coins == undefined ? 0 : param1.coins;
               param1.tickets = param1.tickets == undefined ? 0 : param1.tickets;
               yourEntries_txt.text = "Your current ticket entries: " + param1.tickets + "\nYour current coin entries: " + param1.coins / 10000;
            }
         });
      }
      
      public function get buyTickets() : uint
      {
         return this.__buyTickets;
      }
      
      public function get buyCoins() : uint
      {
         return this.__buyCoins;
      }
   }
}

