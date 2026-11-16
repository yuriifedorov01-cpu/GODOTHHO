package com.menus
{
   import com.game_objects.*;
   import com.math.*;
   import com.sound.*;
   import com.stats.*;
   import com.ui.*;
   import com.utilities.*;
   import flash.display.*;
   import flash.geom.*;
   import playerio.Message;
   import starling.*;
   import starling.display.*;
   import starling.text.*;
   import starling.textures.*;
   
   public class CraftingMenu extends ItemGameMenu implements IScrollableGameMenu
   {
      
      private const buy_btn:Button = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("buy_btn"));
      
      public function CraftingMenu(param1:Vector.<String>)
      {
         var _loc2_:Button = null;
         var _loc6_:Item = null;
         var _loc8_:TextField = null;
         var _loc9_:TextField = null;
         var _loc10_:Image = null;
         _loc2_ = null;
         var _loc3_:int = 0;
         var _loc4_:Image = null;
         var _loc5_:Image = null;
         _loc6_ = null;
         var _loc7_:Item = null;
         _loc8_ = null;
         _loc9_ = null;
         super();
         _loc10_ = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("crafting panel"));
         _loc10_.x = -257;
         _loc10_.y = -208;
         addChild(_loc10_);
         _loc2_ = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_00"),"",ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_01"));
         _loc2_.x = 238;
         _loc2_.y = -192;
         _loc2_.pivotX = 30;
         _loc2_.pivotY = 19;
         _loc2_.name = "x_btn";
         addChild(_loc2_);
         scroll_btn.x = 22;
         scroll_btn.y = -132;
         scroll_btn.pivotX = 15;
         scroll_btn.pivotY = 19;
         scroll_btn.name = "scroll_btn";
         scroll_btn.visible = !GameMain.isMobile;
         addChild(scroll_btn);
         this.buy_btn.x = 184;
         this.buy_btn.y = 309;
         this.buy_btn.pivotX = 33;
         this.buy_btn.pivotY = 15;
         this.buy_btn.name = "buyCraft_btn";
         addChild(this.buy_btn);
         mask_canvas.drawRectangle(-210,-190,316,389);
         list_sprite.x = -102;
         list_sprite.y = 21;
         list_sprite.mask = mask_canvas;
         list_sprite.name = "itemScrollList";
         addChild(list_sprite);
         if(GameMain.isMobile)
         {
            _loc4_ = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("dark green pixel"));
            _loc4_.x = -140;
            _loc4_.y = -474;
            _loc4_.width = 250;
            _loc4_.height = 105 * param1.length;
            _loc4_.name = "listBackdrop";
            list_sprite.addChild(_loc4_);
         }
         var _loc11_:String = "";
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = int(param1.length);
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < _loc14_)
         {
            _loc5_ = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("craft item panel_00"));
            _loc5_.x = -145;
            _loc5_.y = -370 + _loc3_ * 93;
            _loc5_.useHandCursor = true;
            list_sprite.addChild(_loc5_);
            panel_array.push(_loc5_);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc14_)
         {
            _loc6_ = new Item(param1[_loc3_],"","");
            _loc6_.x = -117;
            _loc6_.y = -329 + _loc3_ * 93;
            _loc6_.scaleX = _loc6_.scaleY = 0.75;
            list_sprite.addChild(_loc6_);
            item_array.push(_loc6_);
            _loc15_ = int(Stats.getItemArray(Stats.getItemType(param1[_loc3_]))[param1[_loc3_]].craftItems_array.length);
            _loc13_ = 0;
            while(_loc13_ < 6)
            {
               if(_loc13_ < _loc15_)
               {
                  _loc16_ = _loc13_ < 3 ? _loc13_ : int(_loc13_ - 3);
                  _loc11_ = Stats.getItemArray(Stats.getItemType(param1[_loc3_]))[param1[_loc3_]].craftItems_array[_loc13_];
                  _loc7_ = new Item(_loc11_,"","");
                  _loc7_.x = -74 + _loc16_ * 66;
                  _loc7_.y = (_loc13_ < 3 ? -329 : -304) + _loc3_ * 93;
                  _loc7_.scaleX = _loc7_.scaleY = 0.6;
                  list_sprite.addChild(_loc7_);
               }
               _loc13_++;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc14_)
         {
            _loc12_ = int(Stats.getItemArray(Stats.getItemType(param1[_loc3_]))[param1[_loc3_]].cost);
            _loc8_ = new TextField(116,21,"$" + String(_loc12_),AllTextFormats.cost_textFormat);
            _loc8_.x = -68;
            _loc8_.y = -367 + _loc3_ * 93;
            _loc8_.batchable = true;
            _loc8_.touchable = false;
            list_sprite.addChild(_loc8_);
            _loc15_ = int(Stats.getItemArray(Stats.getItemType(param1[_loc3_]))[param1[_loc3_]].craftItems_array.length);
            _loc13_ = 0;
            while(_loc13_ < 6)
            {
               if(_loc13_ < _loc15_)
               {
                  _loc11_ = Stats.getItemArray(Stats.getItemType(param1[_loc3_]))[param1[_loc3_]].craftItems_array[_loc13_];
                  _loc12_ = int(Stats.getItemArray(Stats.getItemType(param1[_loc3_]))[param1[_loc3_]].craftCosts_array[_loc13_]);
                  _loc16_ = _loc13_ < 3 ? _loc13_ : int(_loc13_ - 3);
                  _loc9_ = new TextField(32,21,"x" + String(_loc12_),AllTextFormats.cost_textFormat);
                  _loc9_.x = -60 + _loc16_ * 66;
                  _loc9_.y = (_loc13_ < 3 ? -341 : -316) + _loc3_ * 93;
                  _loc9_.batchable = true;
                  _loc9_.touchable = false;
                  list_sprite.addChild(_loc9_);
               }
               _loc13_++;
            }
            _loc3_++;
         }
         item_txt.x = 52;
         item_txt.y = -173;
         addChild(item_txt);
         stats_txt.x = 59;
         stats_txt.y = -33;
         stats_txt.height = 317;
         addChild(stats_txt);
         stats_txt.touchable = item_txt.touchable = false;
         stats_txt.batchable = item_txt.batchable = true;
         var _loc17_:Image = new Image(Texture.fromBitmapData(new BitmapData(462,36,false,16711680)));
         _loc17_.x = -257;
         _loc17_.y = -208;
         _loc17_.alpha = 0;
         _loc17_.name = "drag_image";
         addChild(_loc17_);
         list_sprite.y = 212;
         mask_canvas.y = -191;
         this.deselectAll();
      }
      
      override public function showItemStats(param1:String, param2:Image = null) : void
      {
         this.deselectAll();
         param2.texture = ItemMenu.itemMenu_textureAtlas.getTexture("craft item panel_01");
         super.showItemStats(param1,param2);
         item_txt.text = param1;
         item.x = 142;
         item.y = -105;
         this.buy_btn.visible = true;
         var _loc3_:ItemStat = Stats.getItemArray(Stats.getItemType(param1))[param1];
         stats_txt.text += "\n\nCRAFTING REQUIREMENTS";
         var _loc4_:int = int(_loc3_.craftItems_array.length);
         var _loc5_:int = 0;
         while(_loc5_ < 6)
         {
            if(_loc5_ < _loc4_)
            {
               stats_txt.text += "\n" + _loc3_.craftItems_array[_loc5_] + ": " + _loc3_.craftCosts_array[_loc5_];
            }
            _loc5_++;
         }
      }
      
      public function buyItem() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = int(panel_array.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(panel_array[_loc3_].texture == ItemMenu.itemMenu_textureAtlas.getTexture("craft item panel_01"))
            {
               _loc1_ = this.craftCheck(MainStarlingStage(root).gameMain.player.money,MainStarlingStage(root).gameMain.personItem_array,_loc3_);
               if(_loc1_ == "good")
               {
                  this.buy_btn.visible = false;
                  MainStarlingStage(root).gameMain.theConnection.send("craftItem",item_txt.text);
                  MainStarlingStage(root).gameMain.theConnection.removeMessageHandler("itemCrafted",this.itemCraftedGot);
                  MainStarlingStage(root).gameMain.theConnection.addMessageHandler("itemCrafted",this.itemCraftedGot);
               }
               else
               {
                  MainStarlingStage(root).gameMain.createAlert(_loc1_);
               }
               break;
            }
            _loc3_++;
         }
      }
      
      public function panelToItem(param1:Image) : String
      {
         var _loc2_:int = int(panel_array.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(panel_array[_loc3_] == param1)
            {
               return item_array[_loc3_].type;
            }
            _loc3_++;
         }
         return "";
      }
      
      override public function deselectAll() : void
      {
         var _loc1_:Image = null;
         this.buy_btn.visible = false;
         super.deselectAll();
         for each(_loc1_ in panel_array)
         {
            _loc1_.texture = ItemMenu.itemMenu_textureAtlas.getTexture("craft item panel_00");
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
         list_sprite.y = Math.abs(CalcDist.getDistY(scroll_btn.y,194) * 1.5) - 280;
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
         if(list_sprite.y > 203 && param1 > 0)
         {
            list_sprite.y = 203;
         }
         if(list_sprite.y < -240 && param1 < 0)
         {
            list_sprite.y = -240;
         }
         mask_canvas.y -= list_sprite.y - _loc2_;
      }
      
      public function craftCheck(param1:int, param2:Vector.<String>, param3:int) : String
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:ItemStat = Stats.getItemArray(Stats.getItemType(item_array[param3].type))[item_array[param3].type];
         if(param1 >= _loc8_.cost)
         {
            _loc5_ = 0;
            _loc7_ = int(_loc8_.craftItems_array.length);
            _loc6_ = 0;
            while(_loc6_ < 6)
            {
               if(_loc6_ < _loc7_)
               {
                  _loc4_ = _loc8_.craftItems_array[_loc6_];
                  if(CommonCalls.countString(param2,_loc4_) >= _loc8_.craftCosts_array[_loc6_])
                  {
                     _loc5_++;
                  }
               }
               else
               {
                  _loc5_++;
               }
               _loc6_++;
            }
            if(_loc5_ < 6)
            {
               return "you do not have all of the needed materials";
            }
            return "good";
         }
         return "you do not have enough money";
      }
      
      public function itemCraftedGot(param1:Message, param2:String) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = int(Stats.getItemArray(Stats.getItemType(param2))[param2].craftItems_array.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = 0;
            while(_loc3_ < Stats.getItemArray(Stats.getItemType(param2))[param2].craftCosts_array[_loc5_])
            {
               MainStarlingStage(root).gameMain.arrayStringRemove(MainStarlingStage(root).gameMain.personItem_array,Stats.getItemArray(Stats.getItemType(param2))[param2].craftItems_array[_loc5_]);
               _loc3_++;
            }
            _loc5_++;
         }
         MainStarlingStage(root).gameMain.personItem_array.push(param2);
         MainStarlingStage(root).gameMain.player.money = MainStarlingStage(root).gameMain.player.money - Stats.getItemArray(Stats.getItemType(param2))[param2].cost;
         SoundManager.playSound(SoundLibrary.cashRegister_sound);
         if(parent != null)
         {
            this.deselectAll();
         }
      }
   }
}

