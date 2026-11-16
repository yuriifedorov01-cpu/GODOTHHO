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
   import flash.display.*;
   import flash.geom.*;
   import starling.*;
   import starling.core.*;
   import starling.display.*;
   import starling.text.*;
   import starling.textures.*;
   
   public final class ItemMenu extends ItemGameMenu implements IScrollableGameMenu
   {
      
      public static var itemMenu_textureAtlas:TextureAtlas;
      
      private var vend_panel:Image;
      
      private const vend_btn:Button;
      
      private const sell_btn:Button;
      
      private const buy_btn:Button;
      
      public const drop_btn:Button;
      
      private const use_btn:Button;
      
      public const equip_btn:Button;
      
      public const unEquip_btn:Button;
      
      private var shortcut_btn:Button;
      
      public var addVItem_btn:Button;
      
      public var menuType:String;
      
      public var vendorName:String;
      
      public var vendorKey:String;
      
      public var ticketStats_txt:TextField;
      
      public var ticketsBuy_txt:TextInput;
      
      public var ticketsCost_txt:TextInput;
      
      public var itemPrice_txt:TextInput;
      
      private var dualWieldPanel_image:Image;
      
      private var primary_btn:Button;
      
      private var secondary_btn:Button;
      
      private var coverUp_image:Image;
      
      public function ItemMenu(param1:String, param2:String = "", param3:String = "", param4:starling.display.Sprite = null, param5:String = "")
      {
         var panel_image:Image = null;
         var x_btn:Button = null;
         var title_txt:TextField = null;
         var i:int = 0;
         var ticketPanel_image:Image = null;
         var ticketsTitle_txt:TextField = null;
         var _menuType:String = param1;
         var _vendorName:String = param2;
         var _vendorKey:String = param3;
         var _cmc:starling.display.Sprite = param4;
         var _playerName:String = param5;
         ticketPanel_image = null;
         var vendTickets_btn:Button = null;
         var vTickets_btn:Button = null;
         ticketsTitle_txt = null;
         var ticketsDo2_txt:TextField = null;
         var ticketsDo_txt:TextField = null;
         var listBackdrop:Image = null;
         var itemPanel:Image = null;
         var equip_image:Image = null;
         var name_txt:TextField = null;
         this.vend_btn = new Button(itemMenu_textureAtlas.getTexture("vend_btn_00"));
         this.sell_btn = new Button(itemMenu_textureAtlas.getTexture("sell_btn_00"));
         this.buy_btn = new Button(itemMenu_textureAtlas.getTexture("buy_btn"));
         this.drop_btn = new Button(itemMenu_textureAtlas.getTexture("drop_btn"));
         this.use_btn = new Button(itemMenu_textureAtlas.getTexture("use_btn_00"));
         this.equip_btn = new Button(itemMenu_textureAtlas.getTexture("equip_btn"));
         this.unEquip_btn = new Button(itemMenu_textureAtlas.getTexture("unEquip_btn"));
         super();
         this.menuType = _menuType;
         this.vendorKey = _vendorKey;
         item_point = new Point(142,-97);
         panel_image = new Image(itemMenu_textureAtlas.getTexture("panel"));
         panel_image.x = -257;
         panel_image.y = -208;
         addChild(panel_image);
         if(this.menuType == "vendor" && (VendingMachine(_cmc.getChildByName(_vendorKey)).tickets > 0 || Person.removeNamePrefix(_vendorName) == _playerName))
         {
            ticketPanel_image = new Image(itemMenu_textureAtlas.getTexture("ticket panel"));
            ticketPanel_image.x = -233;
            ticketPanel_image.y = 170;
            ticketPanel_image.touchable = false;
            addChild(ticketPanel_image);
            if(Person.removeNamePrefix(_vendorName) == _playerName)
            {
               vendTickets_btn = new Button(this.sell_btn.upState);
               vendTickets_btn.x = -21;
               vendTickets_btn.y = 250;
               vendTickets_btn.pivotX = 33;
               vendTickets_btn.pivotY = 15;
               vendTickets_btn.scaleX = vendTickets_btn.scaleY = 0.65;
               vendTickets_btn.scaleWhenOver = 0.6;
               vendTickets_btn.name = "vendTickets_btn";
               addChild(vendTickets_btn);
            }
            else
            {
               vTickets_btn = new Button(this.buy_btn.upState,"",null,this.buy_btn.overState);
               vTickets_btn.x = -21;
               vTickets_btn.y = 250;
               vTickets_btn.pivotX = 33;
               vTickets_btn.pivotY = 15;
               vTickets_btn.scaleX = vTickets_btn.scaleY = 0.65;
               vTickets_btn.name = "vTickets_btn";
               addChild(vTickets_btn);
            }
         }
         x_btn = new Button(itemMenu_textureAtlas.getTexture("x_btn_00"),"",null,itemMenu_textureAtlas.getTexture("x_btn_01"));
         x_btn.x = 237;
         x_btn.y = -192;
         x_btn.pivotX = 30;
         x_btn.pivotY = 19;
         x_btn.name = "x_btn";
         addChild(x_btn);
         scroll_btn.x = 22;
         scroll_btn.y = -132;
         scroll_btn.pivotX = 15;
         scroll_btn.pivotY = 19;
         scroll_btn.name = "scroll_btn";
         scroll_btn.visible = !GameMain.isMobile;
         addChild(scroll_btn);
         this.sell_btn.x = 186;
         this.sell_btn.y = 250;
         this.sell_btn.pivotX = 33;
         this.sell_btn.pivotY = 15;
         this.sell_btn.scaleWhenOver = 0.95;
         this.sell_btn.name = "sellItem_btn";
         addChild(this.sell_btn);
         this.buy_btn.x = 184;
         this.buy_btn.y = 249;
         this.buy_btn.pivotX = 33;
         this.buy_btn.pivotY = 15;
         this.buy_btn.name = "buy_btn";
         addChild(this.buy_btn);
         this.use_btn.x = 95;
         this.use_btn.y = 248;
         this.use_btn.pivotX = 33;
         this.use_btn.pivotY = 15;
         this.use_btn.scaleWhenOver = 0.95;
         this.use_btn.name = "use_btn";
         addChild(this.use_btn);
         this.drop_btn.x = 191;
         this.drop_btn.y = 247;
         this.drop_btn.pivotX = 33;
         this.drop_btn.pivotY = 15;
         this.drop_btn.scaleWhenOver = 0.95;
         this.drop_btn.name = "drop_btn";
         addChild(this.drop_btn);
         this.vend_btn.x = 52;
         this.vend_btn.y = 248;
         this.vend_btn.pivotX = 8;
         this.vend_btn.pivotY = 15;
         this.vend_btn.scaleWhenOver = 0.95;
         this.vend_btn.name = "vend_btn";
         addChild(this.vend_btn);
         this.equip_btn.x = 91;
         this.equip_btn.y = 248;
         this.equip_btn.pivotX = 33;
         this.equip_btn.pivotY = 15;
         this.equip_btn.scaleWhenOver = 0.95;
         this.equip_btn.name = "equip_btn";
         addChild(this.equip_btn);
         this.unEquip_btn.x = 91;
         this.unEquip_btn.y = 248;
         this.unEquip_btn.pivotX = 45;
         this.unEquip_btn.pivotY = 15;
         this.unEquip_btn.scaleWhenOver = 0.95;
         this.unEquip_btn.name = "unEquip_btn";
         addChild(this.unEquip_btn);
         if(GameMain.isMobile == false)
         {
            this.shortcut_btn = new Button(itemMenu_textureAtlas.getTexture("L key icon"));
            this.shortcut_btn.x = 224;
            this.shortcut_btn.y = -160;
            this.shortcut_btn.pivotX = this.shortcut_btn.pivotY = 7;
            this.shortcut_btn.name = "shortcutKey_btn";
            addChild(this.shortcut_btn);
         }
         title_txt = new TextField(348,34,"ITEMS",AllTextFormats.title_textFormat);
         title_txt.x = -174;
         title_txt.y = -207;
         addChild(title_txt);
         item_txt.x = 52;
         item_txt.y = -173;
         addChild(item_txt);
         stats_txt.x = 58;
         stats_txt.y = -18;
         addChild(stats_txt);
         desc_txt.x = 58;
         desc_txt.y = 139;
         addChild(desc_txt);
         title_txt.touchable = item_txt.touchable = stats_txt.touchable = desc_txt.touchable = false;
         title_txt.batchable = title_txt.batchable = stats_txt.batchable = desc_txt.batchable = true;
         if(this.menuType == "vendor" && (VendingMachine(_cmc.getChildByName(_vendorKey)).tickets > 0 || Person.removeNamePrefix(_vendorName) == _playerName))
         {
            ticketsTitle_txt = new TextField(121,21,"Tickets for sale",AllTextFormats.ticketsTitle_textFormat);
            ticketsTitle_txt.x = -163;
            ticketsTitle_txt.y = 157;
            addChild(ticketsTitle_txt);
            this.ticketStats_txt = new TextField(172,36,"",AllTextFormats.ticketStats_textFormat);
            this.ticketStats_txt.x = -224;
            this.ticketStats_txt.y = 182;
            addChild(this.ticketStats_txt);
            ticketsDo2_txt = new TextField(108,19,"tickets to sell:",AllTextFormats.ticketsSell_textFormat);
            ticketsDo2_txt.x = -231;
            ticketsDo2_txt.y = 240;
            ticketsDo2_txt.batchable = true;
            ticketsDo2_txt.touchable = false;
            addChild(ticketsDo2_txt);
            this.ticketsCost_txt = new TextInput();
            this.ticketsCost_txt.x = -117;
            this.ticketsCost_txt.y = 224;
            this.ticketsCost_txt.width = 71;
            this.ticketsCost_txt.height = 18;
            this.ticketsCost_txt.restrict = "0-9";
            this.ticketsCost_txt.name = this.ticketsCost_txt.textEditorProperties.name = "ticketsCost_txt";
            this.ticketsCost_txt.textEditorProperties.fontFamily = "Arial";
            addChild(this.ticketsCost_txt);
            this.ticketsCost_txt.textEditorFactory = function():ITextEditor
            {
               var _loc1_:StageTextTextEditor = new StageTextTextEditor();
               _loc1_.returnKeyLabel = "next";
               return _loc1_;
            };
            if(_playerName == Person.removeNamePrefix(_vendorName))
            {
               ticketsDo_txt = new TextField(108,19,"price per ticket:",AllTextFormats.ticketsSell_textFormat);
               ticketsDo_txt.x = -231;
               ticketsDo_txt.y = 221;
               addChild(ticketsDo_txt);
               ticketsDo_txt.batchable = true;
               ticketsDo_txt.touchable = false;
            }
            else
            {
               ticketsDo2_txt.text = "tickets to buy:";
               this.coverUp_image = new Image(Texture.fromBitmapData(new BitmapData(91,26,false,4639268)));
               this.coverUp_image.x = -124;
               this.coverUp_image.y = 215;
               this.coverUp_image.touchable = false;
               addChildAt(this.coverUp_image,getChildIndex(this.ticketsCost_txt) - 1);
            }
            ticketsTitle_txt.batchable = this.ticketStats_txt.batchable = true;
            ticketsTitle_txt.touchable = this.ticketStats_txt.touchable = false;
            this.ticketsBuy_txt = new TextInput();
            this.ticketsBuy_txt.x = -117;
            this.ticketsBuy_txt.y = 244;
            this.ticketsBuy_txt.width = 71;
            this.ticketsBuy_txt.height = 18;
            this.ticketsBuy_txt.restrict = "0-9";
            this.ticketsBuy_txt.textEditorProperties.fontFamily = "Arial";
            this.ticketsBuy_txt.name = this.ticketsBuy_txt.textEditorProperties.name = "ticketsBuy_txt";
            addChild(this.ticketsBuy_txt);
            this.ticketsBuy_txt.textEditorFactory = function():ITextEditor
            {
               var _loc1_:StageTextTextEditor = new StageTextTextEditor();
               _loc1_.returnKeyLabel = "next";
               return _loc1_;
            };
         }
         mask_canvas.drawRectangle(-180,-194,297,448);
         list_sprite.x = -102;
         list_sprite.y = 21;
         list_sprite.mask = mask_canvas;
         list_sprite.name = "itemScrollList";
         addChild(list_sprite);
         if(GameMain.isMobile && this.menuType != "vendor")
         {
            listBackdrop = new Image(itemMenu_textureAtlas.getTexture("dark green pixel"));
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
            itemPanel = new Image(itemMenu_textureAtlas.getTexture("item panel_00"));
            itemPanel.x = -140;
            itemPanel.y = -484 + i * 34;
            list_sprite.addChild(itemPanel);
            panel_array.push(itemPanel);
            if(this.menuType != "vendor")
            {
               equip_image = new Image(itemMenu_textureAtlas.getTexture("equip"));
               equip_image.x = 92;
               equip_image.y = -470 + i * 34;
               equip_image.pivotX = 24;
               equip_image.pivotY = 13;
               equip_image.touchable = false;
               equip_image.visible = false;
               list_sprite.addChild(equip_image);
               equipped_array.push(equip_image);
            }
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
         list_sprite.y = 325;
         mask_canvas.y = -304;
         switch(this.menuType)
         {
            case "self":
               title_txt.text = "YOUR ITEMS";
               break;
            case "buy":
               title_txt.text = "SHOP";
               break;
            case "sale":
               title_txt.text = "SELL";
               break;
            case "vendor":
               title_txt.text = Person.removeNamePrefix(_vendorName) + "\'S SHOP";
               removeChild(scroll_btn);
         }
         drag_image = new Image(Texture.fromBitmapData(new BitmapData(462,36,false,16711680)));
         drag_image.x = -257;
         drag_image.y = -208;
         drag_image.name = "drag_image";
         drag_image.alpha = 0;
         addChild(drag_image);
      }
      
      override public function updateMe(param1:uint, param2:Vector.<String>, param3:Person, param4:Boolean = true) : void
      {
         if(param4)
         {
            this.removeDualWieldMenu();
            this.removeVendorSellPanel();
            this.use_btn.visible = this.buy_btn.visible = this.sell_btn.visible = this.equip_btn.visible = this.unEquip_btn.visible = this.drop_btn.visible = this.vend_btn.visible = false;
            deselectAll();
            if(GameMain.isMobile == false)
            {
               this.shortcut_btn.visible = false;
            }
         }
         CommonCalls.emptyArray(item_array,true,true);
         super.updateMe(param1,param2,param3,param4);
         var _loc5_:int = int(panel_array.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            if(this.menuType != "buy" && this.menuType != "vendor")
            {
               if(param1 == 20 && _loc6_ > 19 || param1 == 30 && _loc6_ > 29)
               {
                  panel_array[_loc6_].visible = itemText_array[_loc6_].visible = false;
               }
            }
            _loc6_++;
         }
         if(this.menuType == "vendor")
         {
            list_sprite.x += 10;
            _loc6_ = 8;
            while(_loc6_ < 40)
            {
               panel_array[_loc6_].removeFromParent(true);
               itemText_array[_loc6_].removeFromParent(true);
               if(this.menuType != "vendor")
               {
                  equipped_array[_loc6_].removeFromParent(true);
               }
               _loc6_++;
            }
         }
      }
      
      public function showVendorSellPanel() : void
      {
         if(this.vend_panel == null || this.vend_panel.parent == null)
         {
            this.vend_panel = new Image(itemMenu_textureAtlas.getTexture("vendor panel"));
            this.vend_panel.x = -40;
            this.vend_panel.y = 269;
            this.vend_panel.touchable = false;
            addChild(this.vend_panel);
            this.addVItem_btn = new Button(itemMenu_textureAtlas.getTexture("addVItem_btn_00"));
            this.addVItem_btn.x = 126;
            this.addVItem_btn.y = 296;
            this.addVItem_btn.pivotX = 23;
            this.addVItem_btn.pivotY = 11;
            this.addVItem_btn.scaleWhenOver = 0.95;
            this.addVItem_btn.name = "addVItem_btn";
            addChild(this.addVItem_btn);
            this.itemPrice_txt = new TextInput();
            this.itemPrice_txt.x = -30;
            this.itemPrice_txt.y = 288;
            this.itemPrice_txt.width = 127;
            this.itemPrice_txt.height = 20;
            this.itemPrice_txt.restrict = "0-9";
            this.itemPrice_txt.textEditorProperties.fontFamily = "Arial";
            addChild(this.itemPrice_txt);
            this.itemPrice_txt.textEditorFactory = function():ITextEditor
            {
               var _loc1_:StageTextTextEditor = new StageTextTextEditor();
               _loc1_.returnKeyLabel = "next";
               return _loc1_;
            };
            this.drop_btn.visible = false;
         }
      }
      
      public function removeVendorSellPanel() : void
      {
         if(this.vend_panel != null && this.vend_panel.parent != null)
         {
            this.vend_panel.removeFromParent(true);
            this.addVItem_btn.removeFromParent(true);
         }
      }
      
      public function showDualWieldMenu() : void
      {
         if(this.dualWieldPanel_image == null || this.dualWieldPanel_image.parent == null)
         {
            this.dualWieldPanel_image = new Image(itemMenu_textureAtlas.getTexture("small menu"));
            this.dualWieldPanel_image.x = 42;
            this.dualWieldPanel_image.y = 228;
            addChild(this.dualWieldPanel_image);
            this.primary_btn = new Button(itemMenu_textureAtlas.getTexture("primary_00"));
            this.primary_btn.x = 70;
            this.primary_btn.pivotX = 23;
            this.primary_btn.scaleWhenOver = 0.95;
            this.primary_btn.name = "primary_btn";
            addChild(this.primary_btn);
            this.secondary_btn = new Button(itemMenu_textureAtlas.getTexture("secondary_00"));
            this.secondary_btn.x = 149;
            this.secondary_btn.scaleWhenOver = 0.95;
            this.primary_btn.y = this.secondary_btn.y = 255;
            this.secondary_btn.pivotX = 25;
            this.primary_btn.pivotY = this.secondary_btn.pivotY = 11;
            this.secondary_btn.name = "secondary_btn";
            addChild(this.secondary_btn);
         }
      }
      
      public function removeDualWieldMenu() : void
      {
         if(this.dualWieldPanel_image != null && this.dualWieldPanel_image.parent != null)
         {
            this.dualWieldPanel_image.removeFromParent(true);
            this.primary_btn.removeFromParent(true);
            this.secondary_btn.removeFromParent(true);
         }
      }
      
      public function canSellItem(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(Stats.getItemArray(Stats.getItemType(Fish.fishNoShinyName(param1)))[Fish.fishNoShinyName(param1)].cost > 0)
         {
            _loc2_ = int(panel_array.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if(itemText_array[_loc3_].text == param1 && equipped_array[_loc3_].visible == false)
               {
                  return true;
               }
               _loc3_++;
            }
            return false;
         }
         return false;
      }
      
      public function itemToIndex(param1:String) : uint
      {
         var _loc2_:int = int(itemText_array.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(itemText_array[_loc3_].text == param1)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return 0;
      }
      
      public function getSelectedIndex() : int
      {
         var _loc1_:int = int(panel_array.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            if(panel_array[_loc2_].texture == ItemMenu.itemMenu_textureAtlas.getTexture("item panel_01"))
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function showItemInfo(param1:Image) : String
      {
         var _loc2_:uint = 0;
         this.removeDualWieldMenu();
         var _loc3_:int = 0;
         var _loc4_:int = int(panel_array.length);
         var _loc5_:* = 0;
         while(_loc5_ < _loc4_)
         {
            if(panel_array[_loc5_] == param1)
            {
               _loc3_ = _loc5_;
               break;
            }
            _loc5_++;
         }
         var _loc6_:starling.display.Sprite = MainStarlingStage(root).c_mc;
         var _loc7_:String = itemText_array[_loc3_].text;
         this.removeVendorSellPanel();
         if(this.menuType == "self")
         {
            this.drop_btn.visible = Stats.getItemType(Fish.fishNoShinyName(_loc7_)) != "fish";
            _loc4_ = _loc6_.numChildren;
            if(MainStarlingStage(root).gameMain.c_mc.currentFrame == 56)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  if(_loc6_.getChildAt(_loc5_) is VendingMachine && Person.removeNamePrefix(VendingMachine(_loc6_.getChildAt(_loc5_)).sellerName) == MainStarlingStage(root).gameMain.player.name)
                  {
                     if(MainStarlingStage(root).gameMain.player.hitTester.hit_rect.intersects(_loc6_.getChildAt(_loc5_).getBounds(_loc6_)))
                     {
                        _loc5_--;
                        break;
                     }
                  }
                  _loc5_++;
               }
            }
            if(MainStarlingStage(root).gameMain.c_mc.currentFrame != 56 || _loc5_ == _loc4_)
            {
               if(Stats.getItemType(_loc7_) != "item" && Stats.getItemType(_loc7_) != "pet helmet" && Stats.getItemType(Fish.fishNoShinyName(_loc7_)) != "fish")
               {
                  if(equipped_array[_loc3_].visible == true)
                  {
                     this.equip_btn.visible = false;
                     this.unEquip_btn.visible = true;
                  }
                  else
                  {
                     this.equip_btn.visible = true;
                     this.unEquip_btn.visible = false;
                  }
                  this.use_btn.visible = false;
                  if(GameMain.isMobile == false)
                  {
                     this.shortcut_btn.visible = false;
                  }
               }
               else
               {
                  this.use_btn.visible = Stats.getItemType(_loc7_) != "pet helmet";
                  this.equip_btn.visible = false;
                  this.unEquip_btn.visible = false;
                  if(GameMain.isMobile == false)
                  {
                     this.shortcut_btn.visible = this.use_btn.visible;
                  }
               }
               this.vend_btn.visible = false;
               _loc4_ = _loc6_.numChildren;
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  if(_loc6_.getChildAt(_loc5_) is ATM && Boolean(MainStarlingStage(root).gameMain.player.hitTester.hit_rect.intersects(_loc6_.getChildAt(_loc5_).getBounds(_loc6_))))
                  {
                     this.vend_btn.visible = equipped_array[_loc3_].visible == false && Boolean(MainStarlingStage(root).gameMain.hasItemStorage);
                     this.equip_btn.visible = this.use_btn.visible = false;
                     if(GameMain.isMobile == false)
                     {
                        this.shortcut_btn.visible = this.equip_btn.visible;
                     }
                     break;
                  }
                  _loc5_++;
               }
            }
            else
            {
               this.vend_btn.visible = !equipped_array[_loc3_].visible;
               this.equip_btn.visible = this.use_btn.visible = false;
               if(GameMain.isMobile == false)
               {
                  this.shortcut_btn.visible = this.equip_btn.visible;
               }
            }
         }
         else if(this.menuType == "buy" || this.menuType == "vendor")
         {
            this.buy_btn.visible = true;
         }
         else if(this.menuType == "sale")
         {
            this.sell_btn.visible = true;
         }
         if(this.menuType == "buy")
         {
            stats_txt.text += "\nCost: $" + CommonCalls.uintToCommaString(Stats.getItemArray(Stats.getItemType(_loc7_))[_loc7_].cost);
         }
         else if(this.menuType == "sale")
         {
            _loc2_ = Stats.getItemArray(Stats.getItemType(Fish.fishNoShinyName(_loc7_)))[Fish.fishNoShinyName(_loc7_)].cost * (_loc7_.indexOf("shiny") == 0 ? 10 : 1);
            if(_loc7_.indexOf("shiny") == 0)
            {
               _loc2_ *= 10;
            }
            stats_txt.text += "\nSell for $" + CommonCalls.uintToCommaString(int(_loc2_ * (MainStarlingStage(root).gameMain.hasResale == false ? 0.35 : 0.6)));
         }
         else if(this.menuType == "vendor")
         {
            stats_txt.text += "\nAuction cost: $" + CommonCalls.uintToCommaString(VendingMachine(_loc6_.getChildByName(this.vendorKey)).costs[_loc3_]);
         }
         return itemText_array[_loc3_].text;
      }
      
      public function scroll(param1:Number) : void
      {
         var _loc2_:Point = new Point(0,param1 / Starling.contentScaleFactor);
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
         if(MainStarlingStage(root).gameMain.maxItems == 20 && this.menuType != "buy")
         {
            list_sprite.y = Math.abs(CalcDist.getDistY(scroll_btn.y,194) * 0.8) + 70;
         }
         else if(MainStarlingStage(root).gameMain.maxItems == 40)
         {
            list_sprite.y = Math.abs(CalcDist.getDistY(scroll_btn.y,194) * 2.82) - 605;
         }
         else
         {
            list_sprite.y = Math.abs(CalcDist.getDistY(scroll_btn.y,194) * 1.8) - 271;
         }
         mask_canvas.y -= list_sprite.y - _loc3_;
      }
      
      public function scrollWheel(param1:int) : void
      {
         var _loc2_:Point = null;
         if(this.menuType != "vendor")
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
            _loc2_ = new Point(scroll_btn.x,scroll_btn.y);
            _loc2_ = localToGlobal(_loc2_);
            this.scroll(_loc2_.y);
         }
      }
      
      public function touchScroll(param1:Number) : void
      {
         var _loc2_:Number = list_sprite.y;
         list_sprite.y += param1;
         if(list_sprite.y > 315 && param1 > 0)
         {
            list_sprite.y = 315;
         }
         if(MainStarlingStage(root).gameMain.maxItems == 20 && this.menuType != "buy")
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
      
      override public function dispose() : void
      {
         if(this.coverUp_image != null)
         {
            this.coverUp_image.texture.dispose();
         }
         super.dispose();
      }
   }
}

