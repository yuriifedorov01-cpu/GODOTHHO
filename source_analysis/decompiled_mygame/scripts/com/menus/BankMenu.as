package com.menus
{
   import com.game_objects.*;
   import com.sound.*;
   import com.ui.*;
   import com.utilities.*;
   import feathers.controls.*;
   import flash.display.*;
   import playerio.DatabaseObject;
   import playerio.Message;
   import starling.*;
   import starling.display.*;
   import starling.text.*;
   import starling.textures.*;
   
   public final class BankMenu extends StarlingGameMenu
   {
      
      private const withdrawl_btn:Button = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("withdrawl_00"));
      
      private const deposit_btn:Button = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("deposit_00"));
      
      private const itemWithdrawl_btn:Button = new Button(this.withdrawl_btn.upState,"",null,this.withdrawl_btn.overState);
      
      private const money_txt:TextField = new TextField(337,53,"",AllTextFormats.money_textFormat);
      
      private const withdrawl_txt:TextInput = new TextInput();
      
      private const deposit_txt:TextInput = new TextInput();
      
      private const panel_array:Vector.<Image> = new Vector.<Image>();
      
      private const itemClone_array:Vector.<Item> = new Vector.<Item>();
      
      private const itemText_array:Vector.<TextField> = new Vector.<TextField>();
      
      private var item_array:Vector.<String> = new Vector.<String>();
      
      private var hasStorage:Boolean = false;
      
      private var bankMoney:uint = 0;
      
      private var gameMain:GameMain;
      
      private var storageCoverUp_image:Image;
      
      public function BankMenu(param1:int, param2:Boolean, param3:GameMain)
      {
         var _loc4_:Image = null;
         var _loc5_:Button = null;
         var _loc9_:TextField = null;
         _loc4_ = null;
         _loc5_ = null;
         var _loc6_:int = 0;
         var _loc7_:Image = null;
         var _loc8_:TextField = null;
         _loc9_ = null;
         var _loc10_:Button = null;
         super();
         this.gameMain = param3;
         this.hasStorage = param2;
         _loc4_ = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("bank panel"));
         _loc4_.x = -314;
         _loc4_.y = -187;
         addChild(_loc4_);
         _loc5_ = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_00"),"",ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_01"));
         _loc5_.x = 330;
         _loc5_.y = -106;
         _loc5_.pivotX = 30;
         _loc5_.pivotY = 19;
         _loc5_.name = "x_btn";
         addChild(_loc5_);
         this.withdrawl_btn.x = 6;
         this.withdrawl_btn.y = 141;
         this.withdrawl_btn.pivotX = 43;
         this.withdrawl_btn.pivotY = 15;
         this.withdrawl_btn.name = "withdrawl_btn";
         addChild(this.withdrawl_btn);
         this.deposit_btn.x = 222;
         this.deposit_btn.y = 141;
         this.deposit_btn.pivotX = 38;
         this.deposit_btn.pivotY = 15;
         this.deposit_btn.scaleWhenOver = this.withdrawl_btn.scaleWhenOver = 0.95;
         this.deposit_btn.name = "deposit_btn";
         addChild(this.deposit_btn);
         if(param2)
         {
            this.itemWithdrawl_btn.x = -202;
            this.itemWithdrawl_btn.y = 274;
            this.itemWithdrawl_btn.pivotX = this.withdrawl_btn.pivotX;
            this.itemWithdrawl_btn.pivotY = this.withdrawl_btn.pivotY;
            this.itemWithdrawl_btn.name = "bankItemWithdraw_btn";
            this.itemWithdrawl_btn.visible = false;
            addChild(this.itemWithdrawl_btn);
         }
         _loc6_ = 0;
         while(_loc6_ < 13)
         {
            _loc7_ = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("item panel_00"));
            _loc7_.x = -297;
            _loc7_.y = -172 + _loc6_ * 33;
            addChild(_loc7_);
            this.panel_array.push(_loc7_);
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < 13)
         {
            _loc8_ = new TextField(196,23,"(empty)",AllTextFormats.item_textFormat);
            _loc8_.x = -256;
            _loc8_.y = -170 + _loc6_ * 33;
            _loc8_.touchable = false;
            _loc8_.batchable = true;
            addChild(_loc8_);
            this.itemText_array.push(_loc8_);
            _loc6_++;
         }
         this.money_txt.x = -33;
         this.money_txt.y = -74;
         this.money_txt.touchable = false;
         addChild(this.money_txt);
         if(param2 == false)
         {
            this.storageCoverUp_image = new Image(Texture.fromBitmapData(new BitmapData(259,472,false,3248664)));
            this.storageCoverUp_image.alpha = 0.8;
            this.storageCoverUp_image.x = -303;
            this.storageCoverUp_image.y = -176;
            this.storageCoverUp_image.touchable = false;
            this.storageCoverUp_image.textureSmoothing = TextureSmoothing.NONE;
            addChild(this.storageCoverUp_image);
            _loc9_ = new TextField(160,33,"Item Storage",AllTextFormats.itemStorage_textFormat);
            _loc9_.x = -245;
            _loc9_.y = -119;
            _loc9_.touchable = false;
            _loc9_.batchable = this.money_txt.batchable = true;
            addChild(_loc9_);
            _loc10_ = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("storage_00"));
            _loc10_.x = -122;
            _loc10_.y = -62;
            _loc10_.pivotX = 146;
            _loc10_.pivotY = 18;
            _loc10_.scaleWhenOver = 0.95;
            _loc10_.name = "buyMoneyItemStorage_btn";
            addChild(_loc10_);
         }
         this.withdrawl_txt.x = -32;
         this.withdrawl_txt.y = 92;
         this.withdrawl_txt.width = 135;
         this.withdrawl_txt.height = 28;
         this.withdrawl_txt.restrict = "0-9";
         this.withdrawl_txt.maxChars = 9;
         this.withdrawl_txt.name = this.withdrawl_txt.textEditorProperties.name = "withdrawl_txt";
         this.withdrawl_txt.textEditorProperties.fontFamily = "arial";
         this.withdrawl_txt.textEditorProperties.fontSize = 20;
         addChild(this.withdrawl_txt);
         this.deposit_txt.x = 159;
         this.deposit_txt.y = 91;
         this.deposit_txt.width = 135;
         this.deposit_txt.height = 28;
         this.deposit_txt.restrict = "0-9";
         this.deposit_txt.maxChars = 9;
         this.deposit_txt.name = this.deposit_txt.textEditorProperties.name = "deposit_txt";
         this.deposit_txt.textEditorProperties.fontFamily = "arial";
         this.deposit_txt.textEditorProperties.fontSize = 20;
         addChild(this.deposit_txt);
         drag_image = new Image(Texture.fromBitmapData(new BitmapData(327,33,false,16711680)));
         drag_image.x = -28;
         drag_image.y = -122;
         drag_image.name = "drag_image";
         drag_image.alpha = 0;
         addChild(drag_image);
      }
      
      public function updateMe() : void
      {
         var _loc2_:int = 0;
         var _loc1_:Item = null;
         this.deselectList();
         this.money_txt.text = "Money in bank: $" + CommonCalls.uintToCommaString(this.bankMoney) + "\n" + "Carrying money: $" + CommonCalls.uintToCommaString(MainStarlingStage(root).gameMain.player.money);
         CommonCalls.emptyArray(this.itemClone_array,true,true);
         _loc2_ = 0;
         while(_loc2_ < 13)
         {
            if(_loc2_ < this.item_array.length)
            {
               this.itemText_array[_loc2_].text = this.item_array[_loc2_];
               this.panel_array[_loc2_].touchable = this.panel_array[_loc2_].useHandCursor = true;
               _loc1_ = new Item(this.item_array[_loc2_],"","");
               _loc1_.x = -279;
               _loc1_.y = -157 + _loc2_ * 33;
               _loc1_.scaleX = _loc1_.scaleY = 0.75;
               addChild(_loc1_);
               this.itemClone_array.push(_loc1_);
            }
            else
            {
               this.itemText_array[_loc2_].text = "(empty)";
               this.panel_array[_loc2_].touchable = this.panel_array[_loc2_].useHandCursor = false;
            }
            _loc2_++;
         }
      }
      
      public function clickItem(param1:Image) : void
      {
         this.deselectList();
         param1.texture = ItemMenu.itemMenu_textureAtlas.getTexture("item panel_01");
         this.itemWithdrawl_btn.visible = true;
      }
      
      public function deselectList() : void
      {
         var _loc1_:Image = null;
         if(this.itemWithdrawl_btn != null)
         {
            this.itemWithdrawl_btn.visible = false;
         }
         for each(_loc1_ in this.panel_array)
         {
            _loc1_.texture = ItemMenu.itemMenu_textureAtlas.getTexture("item panel_00");
         }
      }
      
      public function depositMoney() : void
      {
         if(this.deposit_txt.text == "0" || this.deposit_txt.text == "")
         {
            this.gameMain.createAlert("You must enter an amount to deposit");
         }
         else if(int(this.deposit_txt.text) <= MainStarlingStage(root).gameMain.player.money)
         {
            this.gameMain.theConnection.addMessageHandler("bankDone",this.bankTransferDone);
            this.gameMain.theConnection.send("bankD",uint(this.deposit_txt.text));
            this.deposit_btn.visible = this.withdrawl_btn.visible = false;
         }
         else
         {
            this.gameMain.createAlert("You cannot deposit more money than you have");
         }
      }
      
      public function withdrawlMoney() : void
      {
         if(this.withdrawl_txt.text == "0" || this.withdrawl_txt.text == "")
         {
            this.gameMain.createAlert("You must enter an amount to withdrawl");
         }
         else if(int(this.withdrawl_txt.text) <= this.bankMoney)
         {
            this.gameMain.theConnection.addMessageHandler("bankDone",this.bankTransferDone);
            this.gameMain.theConnection.send("bankW",uint(this.withdrawl_txt.text));
            this.deposit_btn.visible = this.withdrawl_btn.visible = false;
         }
         else
         {
            this.gameMain.createAlert("You cannot withdrawl more than is available");
         }
      }
      
      public function withdrawlItem() : void
      {
         var _loc1_:int = 0;
         if(MainStarlingStage(root).gameMain.personItem_array.length < MainStarlingStage(root).gameMain.maxItems)
         {
            _loc1_ = 0;
            while(_loc1_ < 13)
            {
               if(this.panel_array[_loc1_].texture == ItemMenu.itemMenu_textureAtlas.getTexture("item panel_01"))
               {
                  this.gameMain.theConnection.send("bankItem",this.itemText_array[_loc1_].text);
                  this.gameMain.personItem_array.push(this.itemText_array[_loc1_].text);
                  this.gameMain.arrayStringRemove(this.item_array,this.itemText_array[_loc1_].text);
                  this.updateMe();
                  SoundManager.playSound(SoundLibrary.itemBought_sound);
                  break;
               }
               _loc1_++;
            }
         }
         else
         {
            this.gameMain.createAlert("not enough room in your inventory");
         }
      }
      
      public function bankTransferDone(param1:Message, param2:int, param3:Boolean = false) : void
      {
         if(parent != null)
         {
            if(param3 == false)
            {
               this.gameMain.player.money += param2;
               StarlingGameMenu.removeFocusMenu();
               this.gameMain.createAlert("Bank transfer is complete",true);
            }
            else
            {
               this.gameMain.createAlert("You cannot do that");
            }
         }
         this.gameMain.theConnection.removeMessageHandler("bankDone",this.bankTransferDone);
      }
      
      public function bankInfoLoadedOrCreated(param1:DatabaseObject) : void
      {
         if(parent != null)
         {
            if(param1 != null && param1.money != undefined)
            {
               this.bankMoney = param1.money;
               if(param1.items != undefined)
               {
                  this.item_array = Vector.<String>(param1.items);
               }
               this.updateMe();
            }
         }
      }
      
      override public function dispose() : void
      {
         if(this.storageCoverUp_image != null)
         {
            this.storageCoverUp_image.texture.dispose();
         }
         super.dispose();
      }
   }
}

