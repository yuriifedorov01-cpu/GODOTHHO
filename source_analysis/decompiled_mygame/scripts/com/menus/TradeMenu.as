package com.menus
{
   import com.game_objects.*;
   import com.math.*;
   import com.stats.*;
   import com.ui.*;
   import com.utilities.*;
   import feathers.controls.*;
   import feathers.controls.text.*;
   import feathers.core.ITextEditor;
   import feathers.events.*;
   import flash.display.*;
   import flash.geom.*;
   import playerio.Message;
   import starling.*;
   import starling.display.*;
   import starling.events.*;
   import starling.text.*;
   import starling.textures.*;
   
   public class TradeMenu extends ItemGameMenu implements IScrollableGameMenu
   {
      
      private var __traderName:String;
      
      public var oTicketOffer:int = 0;
      
      private var __pTicketOffer:int = 0;
      
      private var pTripleTicketOffer:int = 0;
      
      public var opponentMoneyOffer:int = 0;
      
      public var playerMoneyOffer:int = 0;
      
      public var successfullTrade:Boolean = false;
      
      public const message_txt:TextInput;
      
      private const chat_txt:TextField;
      
      private const pMoney_txt:TextField;
      
      private const oMoney_txt:TextField;
      
      private const pTickets_txt:TextField;
      
      private const oTickets_txt:TextField;
      
      public const confirm_btn:Button;
      
      private const withhold_btn:Button;
      
      private const offer_btn:Button;
      
      public const petWithhold_btn:Button;
      
      private const petOffer_btn:Button;
      
      private const moneyPlus_btn:Button;
      
      private const moneyPlusMore_btn:Button;
      
      private const moneyPlusMoreMore_btn:Button;
      
      private const moneyPlusMoreMoreMore_btn:Button;
      
      private const moneyMinus_btn:Button;
      
      private const moneyMinusMore_btn:Button;
      
      private const moneyMinusMoreMore_btn:Button;
      
      public const ticketsPlus_btn:Button;
      
      public const ticketsMinus_btn:Button;
      
      public var sure_txt:TextField;
      
      public var waiting_txt:TextField;
      
      private var pConfirmed_image:Image;
      
      private var oConfirmed_image:Image;
      
      private var pConfirmed_txt:TextField;
      
      private var oConfirmed_txt:TextField;
      
      public var yes_btn:Button;
      
      public var no_btn:Button;
      
      private const chat_array:Array;
      
      private const yourItems_array:Vector.<Item>;
      
      private const theirItems_array:Vector.<Item>;
      
      private const yourPets_array:Vector.<Pet>;
      
      private const yourPetsNames_array:Vector.<String>;
      
      private const theirPets_array:Vector.<Pet>;
      
      private const theirPetsNames_array:Vector.<String>;
      
      private const yourPetsCopy_array:Vector.<Pet>;
      
      private const yourPetsCopyNames_array:Vector.<String>;
      
      private var confirm_image:Image;
      
      private var petClone:Pet;
      
      private var gameMain:GameMain;
      
      public function TradeMenu(param1:Person, param2:Person, param3:int, param4:Vector.<String>, param5:uint)
      {
         var x_btn:Button = null;
         var title_txt:TextField = null;
         var usernameOffer_txt:TextField = null;
         var len:int = 0;
         var panel_image:Image = null;
         var _player:Person = param1;
         var _person:Person = param2;
         var _tickets:int = param3;
         var _itemArray:Vector.<String> = param4;
         var _maxItems:uint = param5;
         panel_image = null;
         var rowMultiplier:int = 0;
         var i:int = 0;
         var tempPetClone:Pet = null;
         var len2:int = 0;
         var j:int = 0;
         var listBackdrop:Image = null;
         var itemPanel:Image = null;
         var equip_image:Image = null;
         var name_txt:TextField = null;
         this.message_txt = new TextInput();
         this.chat_txt = new TextField(424,116,"",AllTextFormats.chat_textFormat);
         this.pMoney_txt = new TextField(142,20,"Money: $0",AllTextFormats.stats_textFormat);
         this.oMoney_txt = new TextField(142,20,"Money: $0",AllTextFormats.stats_textFormat);
         this.pTickets_txt = new TextField(156,21,"Tickets offered: 0",AllTextFormats.tickets_textFormat);
         this.oTickets_txt = new TextField(156,21,"Tickets offered: 0",AllTextFormats.tickets_textFormat);
         this.confirm_btn = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("confirm"));
         this.withhold_btn = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("withhold"));
         this.offer_btn = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("offer"));
         this.petWithhold_btn = new Button(this.withhold_btn.upState,"",null,this.withhold_btn.overState);
         this.petOffer_btn = new Button(this.offer_btn.upState,"",null,this.offer_btn.overState);
         this.moneyPlus_btn = new Button(CharacterMenu.charMenu_textureAtlas.getTexture("more_btn_00"),"",null,CharacterMenu.charMenu_textureAtlas.getTexture("more_btn_01"));
         this.moneyPlusMore_btn = new Button(this.moneyPlus_btn.upState,"",null,this.moneyPlus_btn.overState);
         this.moneyPlusMoreMore_btn = new Button(this.moneyPlus_btn.upState,"",null,this.moneyPlus_btn.overState);
         this.moneyPlusMoreMoreMore_btn = new Button(this.moneyPlus_btn.upState,"",null,this.moneyPlus_btn.overState);
         this.moneyMinus_btn = new Button(CharacterMenu.charMenu_textureAtlas.getTexture("less_btn_00"),"",null,CharacterMenu.charMenu_textureAtlas.getTexture("less_btn_01"));
         this.moneyMinusMore_btn = new Button(this.moneyMinus_btn.upState,"",null,this.moneyMinus_btn.overState);
         this.moneyMinusMoreMore_btn = new Button(this.moneyMinus_btn.upState,"",null,this.moneyMinus_btn.overState);
         this.ticketsPlus_btn = new Button(this.moneyPlus_btn.upState,"",null,this.moneyPlus_btn.overState);
         this.ticketsMinus_btn = new Button(this.moneyMinus_btn.upState,"",null,this.moneyMinus_btn.overState);
         this.chat_array = new Array();
         this.yourItems_array = new Vector.<Item>();
         this.theirItems_array = new Vector.<Item>();
         this.yourPets_array = new Vector.<Pet>();
         this.yourPetsNames_array = new Vector.<String>();
         this.theirPets_array = new Vector.<Pet>();
         this.theirPetsNames_array = new Vector.<String>();
         this.yourPetsCopy_array = new Vector.<Pet>();
         this.yourPetsCopyNames_array = new Vector.<String>();
         super();
         this.gameMain = MainStarlingStage(_player.root).gameMain;
         this.__traderName = _person.name;
         panel_image = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("trade panel"));
         panel_image.x = -391;
         panel_image.y = -225;
         addChild(panel_image);
         this.offer_btn.x = 280;
         this.offer_btn.y = 198;
         this.offer_btn.pivotX = 30;
         this.offer_btn.pivotY = 14;
         this.offer_btn.name = "offer_btn";
         addChild(this.offer_btn);
         this.withhold_btn.x = 311;
         this.withhold_btn.y = 197;
         this.withhold_btn.pivotX = 47;
         this.withhold_btn.pivotY = 14;
         this.withhold_btn.scaleWhenOver = this.offer_btn.scaleWhenOver = 0.95;
         this.withhold_btn.name = "withhold_btn";
         addChild(this.withhold_btn);
         this.petOffer_btn.x = 315;
         this.petOffer_btn.y = 270;
         this.petOffer_btn.pivotX = this.offer_btn.pivotX;
         this.petOffer_btn.pivotY = this.offer_btn.pivotY;
         this.petOffer_btn.name = "petOffer_btn";
         addChild(this.petOffer_btn);
         this.petWithhold_btn.x = 340;
         this.petWithhold_btn.y = 270;
         this.petWithhold_btn.pivotX = this.withhold_btn.pivotX;
         this.petWithhold_btn.pivotY = this.withhold_btn.pivotY;
         this.petWithhold_btn.name = "petWithhold_btn";
         addChild(this.petWithhold_btn);
         this.confirm_btn.x = 322;
         this.confirm_btn.y = 234;
         this.confirm_btn.pivotX = 59;
         this.confirm_btn.pivotY = 16;
         this.confirm_btn.scaleWhenOver = 0.95;
         this.confirm_btn.name = "confirm_btn";
         addChild(this.confirm_btn);
         scroll_btn.x = 229;
         scroll_btn.y = -133;
         scroll_btn.pivotX = 15;
         scroll_btn.pivotY = 19;
         scroll_btn.name = "scroll_btn";
         scroll_btn.visible = !GameMain.isMobile;
         addChild(scroll_btn);
         x_btn = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_00"),"",null,ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_01"));
         x_btn.x = 418;
         x_btn.y = -210;
         x_btn.pivotX = 30;
         x_btn.pivotY = 19;
         x_btn.name = "x_btn";
         addChild(x_btn);
         this.moneyPlus_btn.x = -139;
         this.moneyPlus_btn.name = "moneyPlus_btn";
         addChild(this.moneyPlus_btn);
         this.moneyPlusMore_btn.x = -115;
         this.moneyPlusMore_btn.name = "moneyPlusMore_btn";
         this.moneyPlusMore_btn.scaleX = this.moneyPlusMore_btn.scaleY = 1.2;
         addChild(this.moneyPlusMore_btn);
         this.moneyPlusMoreMore_btn.x = -89;
         this.moneyPlusMoreMore_btn.name = "moneyPlusMoreMore_btn";
         this.moneyPlusMoreMore_btn.scale = 1.4;
         addChild(this.moneyPlusMoreMore_btn);
         this.moneyPlusMoreMoreMore_btn.x = -60;
         this.moneyPlusMoreMoreMore_btn.y = this.moneyPlusMoreMore_btn.y = this.moneyPlusMore_btn.y = this.moneyPlus_btn.y = -112;
         this.moneyPlusMoreMoreMore_btn.pivotY = this.moneyPlusMoreMoreMore_btn.pivotX = this.moneyPlusMoreMore_btn.pivotX = this.moneyPlusMore_btn.pivotX = this.moneyPlus_btn.pivotX = this.moneyPlusMoreMore_btn.pivotY = this.moneyPlusMore_btn.pivotY = this.moneyPlus_btn.pivotY = 9;
         this.moneyPlusMoreMoreMore_btn.name = "moneyPlusMoreMoreMore_btn";
         this.moneyPlusMoreMoreMore_btn.scale = 1.7;
         addChild(this.moneyPlusMoreMoreMore_btn);
         this.moneyMinus_btn.x = -165;
         this.moneyMinus_btn.name = "moneyMinus_btn";
         addChild(this.moneyMinus_btn);
         this.moneyMinusMore_btn.x = -191;
         this.moneyMinusMore_btn.name = "moneyMinusMore_btn";
         this.moneyMinusMore_btn.scaleX = this.moneyMinusMore_btn.scaleY = 1.2;
         addChild(this.moneyMinusMore_btn);
         this.moneyMinusMoreMore_btn.x = -218;
         this.moneyMinusMoreMore_btn.y = this.moneyMinusMore_btn.y = this.moneyMinus_btn.y = -112;
         this.moneyMinusMoreMore_btn.scaleX = this.moneyMinusMoreMore_btn.scaleY = 1.4;
         this.moneyMinusMoreMore_btn.pivotX = this.moneyMinusMore_btn.pivotX = this.moneyMinus_btn.pivotX = 9;
         this.moneyMinusMoreMore_btn.pivotY = this.moneyMinusMore_btn.pivotY = this.moneyMinus_btn.pivotY = 4;
         this.moneyMinusMoreMore_btn.name = "moneyMinusMoreMore_btn";
         addChild(this.moneyMinusMoreMore_btn);
         this.ticketsPlus_btn.x = -156;
         this.ticketsPlus_btn.y = 3;
         this.ticketsPlus_btn.pivotX = this.ticketsPlus_btn.pivotY = 9;
         this.ticketsPlus_btn.name = "ticketsPlus_btn";
         addChild(this.ticketsPlus_btn);
         this.ticketsMinus_btn.x = -182;
         this.ticketsMinus_btn.y = 3;
         this.ticketsMinus_btn.pivotX = 9;
         this.ticketsMinus_btn.pivotY = 4;
         this.ticketsMinus_btn.name = "ticketsMinus_btn";
         addChild(this.ticketsMinus_btn);
         this.moneyMinus_btn.visible = this.moneyMinusMore_btn.visible = this.moneyMinusMoreMore_btn.visible = this.ticketsMinus_btn.visible = false;
         this.moneyPlus_btn.visible = _player.money > 100;
         this.moneyPlusMore_btn.visible = _player.money > 1000;
         this.moneyPlusMoreMore_btn.visible = _player.money > 10000;
         this.moneyPlusMoreMoreMore_btn.visible = _player.money > 100000;
         title_txt = new TextField(440,34,"TRADE WITH " + _person.name.toUpperCase(),AllTextFormats.title_textFormat);
         title_txt.x = -195;
         title_txt.y = -225;
         addChild(title_txt);
         usernameOffer_txt = new TextField(288,26,_person.name + "\'s offer",AllTextFormats.qualityOff_textFormat);
         usernameOffer_txt.x = -361;
         usernameOffer_txt.y = 76;
         addChild(usernameOffer_txt);
         item_txt.x = 251;
         item_txt.y = -171;
         addChild(item_txt);
         stats_txt.x = 257;
         stats_txt.y = -26;
         addChild(stats_txt);
         this.pTickets_txt.y = -8;
         addChild(this.pTickets_txt);
         this.oTickets_txt.x = this.pTickets_txt.x = -353;
         this.oTickets_txt.y = 257;
         addChild(this.oTickets_txt);
         this.pMoney_txt.y = -123;
         addChild(this.pMoney_txt);
         this.oMoney_txt.x = this.pMoney_txt.x = -361;
         this.oMoney_txt.y = 142;
         addChild(this.oMoney_txt);
         this.chat_txt.x = -379;
         this.chat_txt.y = 300;
         addChild(this.chat_txt);
         this.chat_txt.touchable = this.pMoney_txt.touchable = this.oTickets_txt.touchable = this.pTickets_txt.touchable = stats_txt.touchable = item_txt.touchable = title_txt.touchable = usernameOffer_txt.touchable = false;
         this.chat_txt.batchable = this.pMoney_txt.batchable = this.oTickets_txt.batchable = this.pTickets_txt.batchable = stats_txt.batchable = item_txt.batchable = title_txt.batchable = usernameOffer_txt.batchable = true;
         this.message_txt.x = -371;
         this.message_txt.y = 421;
         this.message_txt.width = 408;
         this.message_txt.height = 16;
         this.message_txt.name = this.message_txt.textEditorProperties.name = "tradeMessage_txt";
         this.message_txt.textEditorProperties.fontFamily = "Arial";
         addChild(this.message_txt);
         this.message_txt.addEventListener(FeathersEventType.ENTER,this.onReturnPressed);
         this.message_txt.textEditorFactory = function():ITextEditor
         {
            var _loc1_:StageTextTextEditor = new StageTextTextEditor();
            _loc1_.returnKeyLabel = "next";
            return _loc1_;
         };
         len = int(_player.pet_array.length);
         i = 0;
         while(i < len)
         {
            rowMultiplier = i < 4 ? i : int(i - 4);
            tempPetClone = new Pet(MainStarlingStage(_player.root).gameMain,"",_player.pet_array[i].type);
            tempPetClone.x = 84 + rowMultiplier * 71;
            tempPetClone.y = i < 4 ? 338 : 419;
            tempPetClone.scaleX = tempPetClone.scaleY = 0.75;
            tempPetClone.fitPreview(66,72);
            tempPetClone.touchable = true;
            tempPetClone.useHandCursor = true;
            tempPetClone.helmet_string = _player.pet_array[i].helmet_string;
            tempPetClone.shoes_string = _player.pet_array[i].shoes_string;
            tempPetClone.lvl = _player.pet_array[i].lvl;
            tempPetClone.power = _player.pet_array[i].power;
            tempPetClone.dex = _player.pet_array[i].dex;
            tempPetClone.defense = _player.pet_array[i].defense;
            tempPetClone.totalHealth = _player.pet_array[i].totalHealth;
            tempPetClone.love = _player.pet_array[i].love;
            addChild(tempPetClone);
            this.yourPetsCopy_array.push(tempPetClone);
            this.yourPetsCopyNames_array.push(_player.pet_array[i].name);
            len2 = tempPetClone.numChildren;
            j = 0;
            while(j < len2)
            {
               tempPetClone.getChildAt(j).touchable = true;
               j++;
            }
            i++;
         }
         mask_canvas.drawRectangle(-180,-194,297,456);
         list_sprite.x = 103;
         list_sprite.y = 27;
         list_sprite.mask = mask_canvas;
         list_sprite.name = "itemScrollList";
         addChild(list_sprite);
         if(GameMain.isMobile)
         {
            listBackdrop = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("dark green pixel"));
            listBackdrop.x = -140;
            listBackdrop.y = -474;
            listBackdrop.width = 250;
            listBackdrop.height = 40 * 34;
            listBackdrop.name = "listBackdrop";
            list_sprite.addChild(listBackdrop);
         }
         i = 0;
         while(i < 40)
         {
            itemPanel = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("item panel_00"));
            itemPanel.x = -140;
            itemPanel.y = -484 + i * 34;
            list_sprite.addChild(itemPanel);
            panel_array.push(itemPanel);
            equip_image = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("equip"));
            equip_image.x = 92;
            equip_image.y = -470 + i * 34;
            equip_image.pivotX = 24;
            equip_image.pivotY = 13;
            equip_image.touchable = false;
            equip_image.visible = false;
            list_sprite.addChild(equip_image);
            equipped_array.push(equip_image);
            i++;
         }
         i = 0;
         while(i < 40)
         {
            name_txt = new TextField(165,23,"(empty)",AllTextFormats.item_textFormat);
            name_txt.x = -98;
            name_txt.y = -482 + i * 34;
            name_txt.touchable = false;
            name_txt.batchable = true;
            list_sprite.addChild(name_txt);
            itemText_array.push(name_txt);
            i++;
         }
         updateMe(_maxItems,_itemArray,_player,true);
         drag_image = new Image(Texture.fromBitmapData(new BitmapData(760,36,false,16711680)));
         drag_image.x = -385;
         drag_image.y = -225;
         drag_image.name = "drag_image";
         drag_image.alpha = 0;
         addChild(drag_image);
         list_sprite.y = 320;
         mask_canvas.y = -293;
         this.deselectAll();
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
         addEventListener(Event.ENTER_FRAME,this.onEnter);
      }
      
      private function onRemoved(param1:Event) : void
      {
         this.gameMain.lastTradeCounter = 0;
         if(this.successfullTrade == false)
         {
            this.gameMain.theConnection.send("tClosed",this.traderName);
         }
         this.gameMain.theConnection.removeMessageHandler("giTradeOffer",this.newTradeOffer);
         this.gameMain.theConnection.removeMessageHandler("giTConfirm",this.showOConfirmed);
         this.gameMain.theConnection.removeMessageHandler("giTMessage",this.gameMain.newTradeMessage);
         this.gameMain.theConnection.removeMessageHandler("giTVerify",this.gameMain.tradeVerified);
         this.gameMain.theConnection.removeMessageHandler("giTClosed",this.gameMain.tradeClosed);
         this.gameMain.theConnection.removeMessageHandler("giPetOffer",this.newPetOffer);
         this.gameMain.theConnection.removeMessageHandler("giPetWithdraw",this.newPetWithdraw);
         this.gameMain.theConnection.removeMessageHandler("giTicketOffer",this.newTicketOffer);
         this.gameMain.theConnection.removeMessageHandler("tradeLock",this.tradeLocked);
         if(this.gameMain.confirmMenu != null)
         {
            this.gameMain.confirmMenu.removeFromParent(true);
         }
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
      }
      
      private function onEnter(param1:Event) : void
      {
         var _loc2_:Pet = null;
         if(this.petClone != null && this.petClone.parent != null)
         {
            this.petClone.nextFrame();
            if(this.petClone.currentLabel != "standing")
            {
               this.petClone.gotoAndPlayStanding();
            }
         }
         for each(_loc2_ in this.yourPets_array)
         {
            _loc2_.nextFrame();
            if(_loc2_.currentLabel != "standing")
            {
               _loc2_.gotoAndPlayStanding();
            }
         }
         for each(_loc2_ in this.theirPets_array)
         {
            _loc2_.nextFrame();
            if(_loc2_.currentLabel != "standing")
            {
               _loc2_.gotoAndPlayStanding();
            }
         }
         for each(_loc2_ in this.yourPetsCopy_array)
         {
            _loc2_.nextFrame();
            if(_loc2_.currentLabel != "standing")
            {
               _loc2_.gotoAndPlayStanding();
            }
         }
      }
      
      private function onReturnPressed(param1:Event) : void
      {
         if(this.message_txt.text.length > 0)
         {
            MainStarlingStage(root).gameMain.theConnection.send("tMessage",this.traderName,CussFilter.checkAndSubstitute(this.message_txt.text));
            this.addChatMessage(MainStarlingStage(root).gameMain.player.name,CussFilter.checkAndSubstitute(this.message_txt.text));
            this.message_txt.text = "";
         }
      }
      
      public function showPet(param1:Pet) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         if(item != null)
         {
            item.removeFromParent(true);
         }
         if(this.petClone != null)
         {
            this.petClone.removeFromParent(true);
         }
         this.petClone = new Pet(MainStarlingStage(root).gameMain,"",param1.type);
         this.petClone.fitPreview(220,120);
         this.petClone.x = 322;
         this.petClone.y = -88;
         this.petClone.helmet_string = param1.helmet_string;
         this.petClone.shoes_string = param1.shoes_string;
         this.petClone.lvl = param1.lvl;
         this.petClone.power = param1.power;
         this.petClone.dex = param1.dex;
         this.petClone.defense = param1.defense;
         this.petClone.totalHealth = param1.totalHealth;
         this.petClone.love = param1.love;
         addChild(this.petClone);
         this.withhold_btn.visible = this.offer_btn.visible = false;
         var _loc4_:int = int(this.yourPetsCopy_array.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(this.yourPetsCopy_array[_loc5_] == param1)
            {
               item_txt.text = this.yourPetsCopyNames_array[_loc5_];
               break;
            }
            _loc5_++;
         }
         _loc4_ = int(this.theirPets_array.length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            if(this.theirPets_array[_loc5_] == param1)
            {
               item_txt.text = this.theirPetsNames_array[_loc5_];
               break;
            }
            _loc5_++;
         }
         _loc4_ = int(this.yourPets_array.length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            if(this.yourPets_array[_loc5_] == param1)
            {
               item_txt.text = this.yourPetsNames_array[_loc5_];
            }
            _loc5_++;
         }
         if(CommonCalls.returnObject(MainStarlingStage(root).gameMain.player.pet_array,item_txt.text) != null)
         {
            _loc2_ = false;
            for each(_loc3_ in this.yourPetsNames_array)
            {
               if(_loc3_ == item_txt.text)
               {
                  _loc2_ = true;
               }
            }
            if(_loc2_)
            {
               this.petWithhold_btn.visible = true;
               this.petOffer_btn.visible = false;
            }
            else
            {
               this.petWithhold_btn.visible = false;
               this.petOffer_btn.visible = this.theirPets_array.length < 3;
            }
         }
         else
         {
            this.petOffer_btn.visible = false;
            this.petWithhold_btn.visible = false;
         }
         stats_txt.text = "Level: " + String(param1.lvl) + "\nLove: " + String(param1.love) + "\nTotal Health: " + String(param1.totalHealth) + "\nPower: " + String(param1.power) + "\nDexterity: " + String(param1.dex) + "\nDefense: " + String(param1.defense);
      }
      
      private function updateTradeItems() : void
      {
         var _loc1_:int = int(this.yourItems_array.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this.yourItems_array[_loc2_].x = -342 + _loc2_ * 48;
            _loc2_++;
         }
         _loc1_ = int(this.theirItems_array.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.theirItems_array[_loc2_].x = -342 + _loc2_ * 48;
            _loc2_++;
         }
         _loc1_ = int(this.yourPets_array.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.yourPets_array[_loc2_].x = -322 + _loc2_ * 98;
            _loc2_++;
         }
         _loc1_ = int(this.theirPets_array.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.theirPets_array[_loc2_].x = -322 + _loc2_ * 98;
            _loc2_++;
         }
      }
      
      public function get traderName() : String
      {
         return this.__traderName;
      }
      
      public function get playerOfferedItems() : String
      {
         var _loc1_:String = "";
         var _loc2_:int = int(this.yourItems_array.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ += (_loc3_ > 0 ? "," : "") + this.yourItems_array[_loc3_].type;
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function get opponentOfferedItems() : String
      {
         var _loc1_:String = "";
         var _loc2_:int = int(this.theirItems_array.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ += (_loc3_ > 0 ? "," : "") + this.theirItems_array[_loc3_].type;
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function get playerOfferedPets() : String
      {
         var _loc1_:String = "";
         var _loc2_:int = int(this.yourPets_array.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ += (_loc3_ > 0 ? "," : "") + this.yourPetsNames_array[_loc3_];
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function get opponentOfferedPets() : String
      {
         var _loc1_:String = "";
         var _loc2_:int = int(this.theirPets_array.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ += (_loc3_ > 0 ? "," : "") + this.theirPetsNames_array[_loc3_];
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function showPConfirmed() : void
      {
         this.pConfirmed_image = new Image(Texture.fromBitmapData(new BitmapData(338,230,false,0)));
         this.pConfirmed_image.alpha = 0.45;
         this.pConfirmed_image.x = -387;
         this.pConfirmed_image.y = -193;
         this.pConfirmed_image.textureSmoothing = TextureSmoothing.NONE;
         addChild(this.pConfirmed_image);
         this.pConfirmed_txt = new TextField(185,45,"CONFIRMED",AllTextFormats.confirmed_textFormat);
         this.pConfirmed_txt.x = -300;
         this.pConfirmed_txt.y = -118;
         this.pConfirmed_txt.touchable = false;
         addChild(this.pConfirmed_txt);
      }
      
      public function showOConfirmed(param1:Message) : void
      {
         if(parent != null)
         {
            this.oConfirmed_image = new Image(Texture.fromBitmapData(new BitmapData(338,230,false,0)));
            this.oConfirmed_image.alpha = 0.45;
            this.oConfirmed_image.x = -387;
            this.oConfirmed_image.y = 25;
            this.oConfirmed_image.textureSmoothing = TextureSmoothing.NONE;
            addChild(this.oConfirmed_image);
            this.oConfirmed_txt = new TextField(185,45,"CONFIRMED",AllTextFormats.confirmed_textFormat);
            this.oConfirmed_txt.x = -300;
            this.oConfirmed_txt.y = 100;
            this.oConfirmed_txt.touchable = false;
            addChild(this.oConfirmed_txt);
         }
      }
      
      public function removePConfirmed() : void
      {
         if(this.pConfirmed_image != null)
         {
            this.pConfirmed_image.removeFromParent(true);
            this.pConfirmed_txt.removeFromParent(true);
         }
      }
      
      public function removeOConfirmed() : void
      {
         if(this.oConfirmed_image != null)
         {
            this.oConfirmed_image.removeFromParent(true);
            this.oConfirmed_txt.removeFromParent(true);
         }
      }
      
      public function get pHasConfirmed() : Boolean
      {
         return this.pConfirmed_image != null && this.pConfirmed_image.parent != null;
      }
      
      public function get oHasConfirmed() : Boolean
      {
         return this.oConfirmed_image != null && this.oConfirmed_image.parent != null;
      }
      
      public function addChatMessage(param1:String, param2:String) : void
      {
         this.chat_array.push(String(param1 + ": " + param2));
         if(this.chat_array.length >= 8)
         {
            this.chat_array.removeAt(0);
         }
         var _loc3_:int = int(this.chat_array.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(_loc4_ == 0)
            {
               this.chat_txt.text = this.chat_array[_loc4_];
            }
            else
            {
               this.chat_txt.text += "\n" + this.chat_array[_loc4_];
            }
            _loc4_++;
         }
      }
      
      public function tradeNotConfirmed(param1:Message) : void
      {
         if(parent != null)
         {
            this.removeFinalConfirmMenu();
            this.moneyMinus_btn.visible = this.playerMoneyOffer >= 100;
            this.moneyMinusMore_btn.visible = this.playerMoneyOffer >= 1000;
            this.moneyMinusMoreMore_btn.visible = this.playerMoneyOffer >= 10000;
            this.moneyPlus_btn.visible = this.playerMoneyOffer + 100 < MainStarlingStage(root).gameMain.player.money;
            this.moneyPlusMore_btn.visible = this.playerMoneyOffer + 1000 < MainStarlingStage(root).gameMain.player.money;
            this.moneyPlusMoreMore_btn.visible = this.playerMoneyOffer + 10000 < MainStarlingStage(root).gameMain.player.money;
            this.moneyPlusMoreMoreMore_btn.visible = this.playerMoneyOffer + 100000 < MainStarlingStage(root).gameMain.player.money;
            MainStarlingStage(root).gameMain.theConnection.send("noTrade",this.traderName);
         }
      }
      
      public function showFinalConfirmMenu() : void
      {
         this.confirm_image = new Image(Texture.fromBitmapData(new BitmapData(462,639,false,165633)));
         this.confirm_image.x = -49;
         this.confirm_image.y = -193;
         this.confirm_image.textureSmoothing = TextureSmoothing.NONE;
         addChild(this.confirm_image);
         var _loc1_:TextFormat = new TextFormat(Assets.stats_font.name,25,16777215);
         this.sure_txt = new TextField(435,31,"Are you sure you would like to trade?",_loc1_);
         this.sure_txt.x = -36;
         this.sure_txt.y = -80;
         addChild(this.sure_txt);
         var _loc2_:TextFormat = new TextFormat(Assets.stats_font.name,18,16777215);
         this.waiting_txt = new TextField(436,26,"",_loc2_);
         this.waiting_txt.x = -36;
         this.waiting_txt.y = 26;
         addChild(this.waiting_txt);
         this.no_btn = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("no"));
         this.no_btn.x = 112;
         this.no_btn.y = -13;
         this.no_btn.name = "tradeNo_btn";
         addChild(this.no_btn);
         this.yes_btn = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("yes"));
         this.yes_btn.x = 254;
         this.yes_btn.y = -13;
         this.yes_btn.pivotX = this.no_btn.pivotX = 47;
         this.yes_btn.pivotY = this.no_btn.pivotY = 23;
         this.yes_btn.scaleWhenOver = this.no_btn.scaleWhenOver = 0.95;
         this.yes_btn.name = "tradeYes_btn";
         addChild(this.yes_btn);
      }
      
      public function removeFinalConfirmMenu() : void
      {
      }
      
      public function offerPItem() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Item = null;
         var _loc4_:int = 0;
         if(this.pHasConfirmed == false)
         {
            if(this.yourItems_array.length < 6)
            {
               _loc1_ = int(panel_array.length);
               _loc2_ = 0;
               while(_loc2_ < _loc1_)
               {
                  if(panel_array[_loc2_].texture == ItemMenu.itemMenu_textureAtlas.getTexture("item panel_01"))
                  {
                     MainStarlingStage(root).gameMain.theConnection.send("newOffer",this.traderName,item_txt.text,true,0);
                     this.removePConfirmed();
                     this.removeOConfirmed();
                     this.confirm_btn.visible = true;
                     panel_array[_loc2_].texture = ItemMenu.itemMenu_textureAtlas.getTexture("item panel_03");
                     this.offer_btn.visible = false;
                     this.withhold_btn.visible = true;
                     _loc3_ = new Item(item_txt.text,"","");
                     _loc3_.y = -136;
                     _loc3_.scaleX = _loc3_.scaleY = 0.75;
                     _loc3_.useHandCursor = _loc3_.touchable = true;
                     addChild(_loc3_);
                     this.yourItems_array.push(_loc3_);
                     this.updateTradeItems();
                     _loc4_ = 0;
                     while(_loc4_ < _loc3_.numChildren)
                     {
                        _loc3_.getChildAt(_loc4_).touchable = true;
                        _loc4_++;
                     }
                  }
                  _loc2_++;
               }
            }
            else
            {
               MainStarlingStage(root).gameMain.createAlert("Cannot offer another item");
            }
         }
         else
         {
            MainStarlingStage(root).gameMain.createAlert("You cannot offer an item after you have confirmed an offer");
         }
      }
      
      public function withholdPItem() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.pHasConfirmed == false)
         {
            _loc1_ = int(panel_array.length);
            _loc2_ = int(this.yourItems_array.length);
            _loc3_ = 0;
            while(_loc3_ < _loc1_)
            {
               if(panel_array[_loc3_].texture == ItemMenu.itemMenu_textureAtlas.getTexture("item panel_03"))
               {
                  _loc4_ = 0;
                  while(_loc4_ < _loc2_)
                  {
                     if(this.yourItems_array[_loc4_].type == item_txt.text)
                     {
                        MainStarlingStage(root).gameMain.theConnection.send("newOffer",this.traderName,item_txt.text,false,0);
                        this.yourItems_array[_loc4_].removeFromParent(true);
                        this.yourItems_array.removeAt(_loc4_);
                        this.updateTradeItems();
                        break;
                     }
                     _loc4_++;
                  }
                  this.removePConfirmed();
                  this.removeOConfirmed();
                  this.confirm_btn.visible = true;
                  this.offer_btn.visible = true;
                  this.withhold_btn.visible = false;
                  panel_array[_loc3_].texture = ItemMenu.itemMenu_textureAtlas.getTexture("item panel_00");
               }
               _loc3_++;
            }
         }
         else
         {
            MainStarlingStage(root).gameMain.createAlert("You cannot withhold an item after you have confirmed an offer");
         }
      }
      
      public function withholdPPet() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.pHasConfirmed == false)
         {
            this.removeOConfirmed();
            this.removePConfirmed();
            this.confirm_btn.visible = true;
            _loc1_ = int(this.yourPets_array.length);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               if(this.yourPetsNames_array[_loc2_] == item_txt.text)
               {
                  this.petWithhold_btn.visible = false;
                  this.petOffer_btn.visible = true;
                  this.yourPets_array[_loc2_].removeFromParent(true);
                  this.yourPets_array.removeAt(_loc2_);
                  this.yourPetsNames_array.removeAt(_loc2_);
                  this.updateTradeItems();
                  MainStarlingStage(root).gameMain.theConnection.send("withdrawPet",item_txt.text,this.traderName);
                  break;
               }
               _loc2_++;
            }
         }
         else
         {
            MainStarlingStage(root).gameMain.createAlert("You cannot withhold a pet after you have confirmed an offer");
         }
      }
      
      public function addPTicket() : void
      {
         ++this.pTicketOffer;
         this.ticketsPlus_btn.visible = this.pTicketOffer >= MainStarlingStage(root).gameMain.player.tickets ? false : true;
         this.ticketsMinus_btn.visible = true;
         this.pTickets_txt.text = "Tickets offered: " + this.pTicketOffer;
         this.removeOConfirmed();
         this.removePConfirmed();
         this.confirm_btn.visible = true;
      }
      
      public function deductPTicket() : void
      {
         --this.pTicketOffer;
         this.ticketsMinus_btn.visible = this.pTicketOffer == 0 ? false : true;
         this.ticketsPlus_btn.visible = true;
         this.pTickets_txt.text = "Tickets offered: " + this.pTicketOffer;
         this.removeOConfirmed();
         this.removePConfirmed();
         this.confirm_btn.visible = true;
      }
      
      public function offerPPet(param1:String) : void
      {
         var _loc2_:Pet = null;
         var _loc3_:Pet = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this.pHasConfirmed == false)
         {
            this.removeOConfirmed();
            this.removePConfirmed();
            this.confirm_btn.visible = true;
            for each(_loc2_ in MainStarlingStage(root).gameMain.player.pet_array)
            {
               if(_loc2_.name == item_txt.text)
               {
                  if(_loc2_.isCompanion)
                  {
                     MainStarlingStage(root).gameMain.createAlert("cannot trade companion pet");
                     return;
                  }
                  if(_loc2_.isActive)
                  {
                     MainStarlingStage(root).gameMain.createAlert("cannot trade active pet");
                     return;
                  }
               }
            }
            if(this.yourPets_array.length < 3)
            {
               _loc3_ = new Pet(MainStarlingStage(root).gameMain,"",this.petClone.type);
               _loc3_.x = -322 + this.yourPets_array.length * 100;
               _loc3_.y = -53;
               _loc3_.scaleX = _loc3_.scaleY = 0.75;
               _loc3_.fitPreview(90,72);
               _loc3_.helmet_string = this.petClone.helmet_string;
               _loc3_.shoes_string = this.petClone.shoes_string;
               _loc3_.touchable = _loc3_.useHandCursor = true;
               _loc3_.lvl = this.petClone.lvl;
               _loc3_.power = this.petClone.power;
               _loc3_.dex = this.petClone.dex;
               _loc3_.defense = this.petClone.defense;
               _loc3_.totalHealth = this.petClone.totalHealth;
               _loc3_.love = this.petClone.love;
               addChild(_loc3_);
               this.yourPets_array.push(_loc3_);
               this.yourPetsNames_array.push(param1);
               _loc4_ = _loc3_.numChildren;
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  _loc3_.getChildAt(_loc5_).touchable = true;
                  _loc5_++;
               }
               this.petOffer_btn.visible = false;
               this.petWithhold_btn.visible = false;
               MainStarlingStage(root).gameMain.theConnection.send("offerPet",item_txt.text,this.traderName);
            }
         }
         else
         {
            MainStarlingStage(root).gameMain.createAlert("You cannot offer a pet after you have confirmed an offer");
         }
      }
      
      public function changePMoney(param1:int, param2:Boolean = true) : void
      {
         if(this.pHasConfirmed == false)
         {
            if(param2)
            {
               if(this.playerMoneyOffer + param1 < MainStarlingStage(root).gameMain.player.money)
               {
                  MainStarlingStage(root).gameMain.theConnection.send("newOffer",this.traderName,"none",false,this.playerMoneyOffer + param1);
                  this.removePConfirmed();
                  this.removeOConfirmed();
                  this.confirm_btn.visible = true;
                  this.playerMoneyOffer += param1;
                  this.pMoney_txt.text = "Money: $" + CommonCalls.uintToCommaString(this.playerMoneyOffer);
               }
            }
            else if(this.playerMoneyOffer >= param1)
            {
               MainStarlingStage(root).gameMain.theConnection.send("newOffer",this.traderName,"none",false,this.playerMoneyOffer - param1);
               this.removePConfirmed();
               this.removeOConfirmed();
               this.confirm_btn.visible = true;
               this.playerMoneyOffer -= param1;
               this.pMoney_txt.text = "Money: $" + CommonCalls.uintToCommaString(this.playerMoneyOffer);
            }
            this.moneyMinus_btn.visible = this.playerMoneyOffer >= 100;
            this.moneyMinusMore_btn.visible = this.playerMoneyOffer >= 1000;
            this.moneyMinusMoreMore_btn.visible = this.playerMoneyOffer >= 10000;
            this.moneyPlus_btn.visible = this.playerMoneyOffer + 100 < MainStarlingStage(root).gameMain.player.money;
            this.moneyPlusMore_btn.visible = this.playerMoneyOffer + 1000 < MainStarlingStage(root).gameMain.player.money;
            this.moneyPlusMoreMore_btn.visible = this.playerMoneyOffer + 10000 < MainStarlingStage(root).gameMain.player.money;
            this.moneyPlusMoreMoreMore_btn.visible = this.playerMoneyOffer + 100000 < MainStarlingStage(root).gameMain.player.money;
         }
         else
         {
            MainStarlingStage(root).gameMain.createAlert("You cannot change money after you have confirmed an offer");
         }
      }
      
      public function newTicketOffer(param1:Message, param2:String, param3:int) : void
      {
         if(parent != null)
         {
            this.removeOConfirmed();
            this.removePConfirmed();
            this.confirm_btn.visible = true;
            this.oTickets_txt.text = "Tickets offered: " + String(param3);
            this.oTicketOffer = param3;
         }
      }
      
      public function newTradeOffer(param1:Message, param2:String, param3:String, param4:Boolean, param5:int) : void
      {
         var _loc6_:Item = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(parent != null)
         {
            this.removeOConfirmed();
            this.removePConfirmed();
            this.confirm_btn.visible = true;
            if(param5 == 0 && param3 != "none")
            {
               if(param4)
               {
                  if(this.theirItems_array.length < 6)
                  {
                     _loc6_ = new Item(param3,"","");
                     _loc6_.y = 123;
                     _loc6_.scaleX = _loc6_.scaleY = 0.75;
                     _loc6_.useHandCursor = _loc6_.touchable = true;
                     addChild(_loc6_);
                     this.theirItems_array.push(_loc6_);
                     this.updateTradeItems();
                     _loc7_ = 0;
                     while(_loc7_ < _loc6_.numChildren)
                     {
                        _loc6_.getChildAt(_loc7_).touchable = true;
                        _loc7_++;
                     }
                  }
               }
               else
               {
                  _loc8_ = int(this.theirItems_array.length);
                  _loc9_ = 0;
                  while(_loc9_ < _loc8_)
                  {
                     if(this.theirItems_array[_loc9_].type == param3)
                     {
                        this.theirItems_array[_loc9_].removeFromParent(true);
                        this.theirItems_array.removeAt(_loc9_);
                        this.updateTradeItems();
                        break;
                     }
                     _loc9_++;
                  }
               }
            }
            else
            {
               this.opponentMoneyOffer = param5;
               this.oMoney_txt.text = "Money: $" + CommonCalls.uintToCommaString(param5);
            }
         }
      }
      
      public function newPetOffer(param1:Message, param2:String, param3:String, param4:String, param5:int, param6:int, param7:int, param8:int, param9:int, param10:int, param11:int, param12:int) : void
      {
         var _loc13_:int = 0;
         var _loc14_:Pet = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         if(parent != null)
         {
            this.removeOConfirmed();
            this.removePConfirmed();
            this.confirm_btn.visible = true;
            _loc13_ = int(this.yourPets_array.length);
            if(this.theirPets_array.length < 3)
            {
               _loc14_ = new Pet(MainStarlingStage(root).gameMain,"",param4);
               _loc14_.y = 212;
               _loc14_.scaleX = _loc14_.scaleY = 0.75;
               _loc14_.fitPreview(90,72);
               _loc14_.helmet_uint = param5;
               _loc14_.shoes_uint = param6;
               _loc14_.scaleX = _loc14_.scaleY = 0.75;
               _loc14_.lvl = param7;
               _loc14_.power = param8;
               _loc14_.dex = param9;
               _loc14_.defense = param10;
               _loc14_.totalHealth = param11;
               _loc14_.love = param12;
               _loc14_.touchable = _loc14_.useHandCursor = true;
               addChild(_loc14_);
               this.theirPets_array.push(_loc14_);
               this.theirPetsNames_array.push(param3);
               this.updateTradeItems();
               _loc15_ = _loc14_.numChildren;
               _loc16_ = 0;
               while(_loc16_ < _loc15_)
               {
                  _loc14_.getChildAt(_loc16_).touchable = true;
                  _loc16_++;
               }
            }
         }
      }
      
      public function confirmTrade() : void
      {
         if(this.oHasConfirmed == false)
         {
            MainStarlingStage(root).gameMain.theConnection.send("tConfirm",this.traderName);
            this.showPConfirmed();
            this.confirm_btn.visible = false;
         }
         else
         {
            this.confirm_btn.visible = false;
            this.ticketsMinus_btn.visible = this.ticketsPlus_btn.visible = false;
            this.moneyPlusMoreMoreMore_btn.visible = this.moneyMinusMore_btn.visible = this.moneyMinus_btn.visible = this.moneyPlus_btn.visible = this.moneyPlusMore_btn.visible = this.moneyPlusMoreMore_btn.visible = this.moneyMinusMoreMore_btn.visible = false;
            this.showFinalConfirmMenu();
            MainStarlingStage(root).gameMain.theConnection.send("lockTrade",this.traderName);
         }
      }
      
      override public function deselectAll() : void
      {
         super.deselectAll();
         this.confirm_btn.visible = this.withhold_btn.visible = this.offer_btn.visible = this.petWithhold_btn.visible = this.petOffer_btn.visible = false;
      }
      
      override public function showItemStats(param1:String, param2:Image = null) : void
      {
         var _loc3_:Boolean = false;
         if(this.petClone != null)
         {
            this.petClone.removeFromParent(true);
         }
         this.petOffer_btn.visible = this.petWithhold_btn.visible = false;
         var _loc4_:Boolean = false;
         var _loc5_:int = int(panel_array.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            if(panel_array[_loc6_] == param2 && equipped_array[_loc6_].visible == true)
            {
               _loc4_ = true;
               break;
            }
            _loc6_++;
         }
         super.showItemStats(param1,param2);
         if(param2 != null)
         {
            _loc3_ = param2.texture == ItemMenu.itemMenu_textureAtlas.getTexture("item panel_00") || param2.texture == ItemMenu.itemMenu_textureAtlas.getTexture("item panel_01");
            this.offer_btn.visible = _loc4_ == false && _loc3_ && this.yourItems_array.length < 6 && (Stats.getItemArray(Stats.getItemType(Fish.fishNoShinyName(param1)))[Fish.fishNoShinyName(param1)].cost > 0 || Stats.getItemType(Fish.fishNoShinyName(param1)) == "accessory") ? true : false;
            this.withhold_btn.visible = false;
            if(param2.texture == ItemMenu.itemMenu_textureAtlas.getTexture("item panel_00") || param2.texture == ItemMenu.itemMenu_textureAtlas.getTexture("item panel_01"))
            {
               param2.texture = ItemMenu.itemMenu_textureAtlas.getTexture("item panel_01");
            }
            else
            {
               this.withhold_btn.visible = true;
               param2.texture = ItemMenu.itemMenu_textureAtlas.getTexture("item panel_03");
            }
         }
      }
      
      public function tradeLocked(param1:Message, param2:Boolean = true) : void
      {
         if(parent != null)
         {
            this.ticketsMinus_btn.visible = this.ticketsPlus_btn.visible = false;
            this.moneyPlusMoreMoreMore_btn.visible = this.moneyMinusMore_btn.visible = this.moneyMinus_btn.visible = this.moneyPlus_btn.visible = this.moneyPlusMore_btn.visible = this.moneyPlusMoreMore_btn.visible = this.moneyMinusMoreMore_btn.visible = false;
            this.showFinalConfirmMenu();
         }
      }
      
      public function newPetWithdraw(param1:Message, param2:String) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(parent != null)
         {
            _loc3_ = int(this.theirPets_array.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               if(this.theirPetsNames_array[_loc4_] == param2)
               {
                  this.theirPets_array[_loc4_].removeFromParent(true);
                  this.theirPets_array.removeAt(_loc4_);
                  this.theirPetsNames_array.removeAt(_loc4_);
                  this.updateTradeItems();
                  break;
               }
               _loc4_++;
            }
         }
      }
      
      public function scroll(param1:Number) : void
      {
         var _loc2_:Point = new Point(0,param1);
         _loc2_ = globalToLocal(_loc2_);
         scroll_btn.y = _loc2_.y;
         if(scroll_btn.y < -134)
         {
            scroll_btn.y = -134;
         }
         if(scroll_btn.y > 194)
         {
            scroll_btn.y = 194;
         }
         var _loc3_:Number = list_sprite.y;
         if(panel_array.length == 20)
         {
            list_sprite.y = Math.abs(CalcDist.getDistY(scroll_btn.y,194) * 0.8) + 70;
         }
         else if(panel_array.length == 40)
         {
            list_sprite.y = Math.abs(CalcDist.getDistY(scroll_btn.y,194) * 2.82) - 605;
         }
         else
         {
            list_sprite.y = Math.abs(CalcDist.getDistY(scroll_btn.y,194) * 2.82) - 600;
         }
         mask_canvas.y -= list_sprite.y - _loc3_;
      }
      
      public function scrollWheel(param1:int) : void
      {
         scroll_btn.y -= param1 * 2;
         if(scroll_btn.y < -134)
         {
            scroll_btn.y = -134;
         }
         if(scroll_btn.y > 194)
         {
            scroll_btn.y = 194;
         }
         var _loc2_:Point = new Point(scroll_btn.x,scroll_btn.y);
         _loc2_ = localToGlobal(_loc2_);
         this.scroll(_loc2_.y);
      }
      
      public function touchScroll(param1:Number) : void
      {
         var _loc2_:Number = list_sprite.y;
         list_sprite.y += param1;
         if(list_sprite.y > 315 && param1 > 0)
         {
            list_sprite.y = 315;
         }
         if(MainStarlingStage(root).gameMain.maxItems == 20)
         {
            if(list_sprite.y < 80 && param1 < 0)
            {
               list_sprite.y = 80;
            }
         }
         else if(MainStarlingStage(root).gameMain.maxItems == 40)
         {
            if(list_sprite.y < -602 && param1 < 0)
            {
               list_sprite.y = -602;
            }
         }
         else if(list_sprite.y < -263 && param1 < 0)
         {
            list_sprite.y = -263;
         }
         mask_canvas.y -= list_sprite.y - _loc2_;
      }
      
      public function set pTicketOffer(param1:int) : void
      {
         this.__pTicketOffer = param1;
         this.pTripleTicketOffer = param1 * 3;
      }
      
      public function get pTicketOffer() : int
      {
         if(this.__pTicketOffer * 3 != this.pTripleTicketOffer)
         {
            this.gameMain.player.personHackCheck.banKillPlayer();
         }
         return this.__pTicketOffer;
      }
      
      override public function dispose() : void
      {
         if(this.pConfirmed_image != null)
         {
            this.pConfirmed_image.texture.dispose();
         }
         if(this.oConfirmed_image != null)
         {
            this.oConfirmed_image.texture.dispose();
         }
         if(this.confirm_image != null)
         {
            this.confirm_image.texture.dispose();
         }
         super.dispose();
      }
   }
}

