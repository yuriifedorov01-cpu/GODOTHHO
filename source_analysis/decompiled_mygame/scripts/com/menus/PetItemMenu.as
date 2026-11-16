package com.menus
{
   import com.game_objects.*;
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.math.*;
   import com.stats.*;
   import com.ui.*;
   import com.utilities.*;
   import flash.display.*;
   import flash.geom.*;
   import starling.*;
   import starling.display.*;
   import starling.events.*;
   import starling.text.*;
   import starling.textures.*;
   
   public final class PetItemMenu extends ItemGameMenu implements IScrollableGameMenu
   {
      
      public const use_btn:Button = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("use_btn_00"));
      
      public const equip_btn:Button = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("equip_btn"));
      
      public const unEquip_btn:Button = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("unEquip_btn"));
      
      private const petName_txt:TextField = new TextField(171,22,"",AllTextFormats.petName_textFormat);
      
      public var petClone:Pet;
      
      public function PetItemMenu(param1:Pet, param2:GameMain)
      {
         var _loc3_:Image = null;
         var _loc4_:Button = null;
         var _loc5_:Image = null;
         _loc3_ = null;
         _loc4_ = null;
         _loc5_ = null;
         var _loc6_:Image = null;
         var _loc7_:Image = null;
         var _loc8_:TextField = null;
         super();
         _loc3_ = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("pet item panel"));
         _loc3_.x = -257;
         _loc3_.y = -208;
         addChild(_loc3_);
         _loc4_ = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_00"),"",null,ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_01"));
         _loc4_.x = 238;
         _loc4_.y = -192;
         _loc4_.pivotX = 30;
         _loc4_.pivotY = 19;
         _loc4_.name = "x_btn";
         addChild(_loc4_);
         this.equip_btn.pivotX = 33;
         this.equip_btn.pivotY = 15;
         this.equip_btn.scaleWhenOver = 0.95;
         this.equip_btn.name = "petEquipItem_btn";
         addChild(this.equip_btn);
         this.unEquip_btn.x = this.equip_btn.x = 160;
         this.unEquip_btn.y = this.equip_btn.y = 200;
         this.unEquip_btn.pivotX = 45;
         this.unEquip_btn.pivotY = 15;
         this.unEquip_btn.scaleWhenOver = 0.95;
         this.unEquip_btn.name = "petUnEquipItem_btn";
         addChild(this.unEquip_btn);
         this.use_btn.x = 172;
         this.use_btn.y = 200;
         this.use_btn.pivotX = 33;
         this.use_btn.pivotY = 15;
         this.use_btn.scaleWhenOver = 0.95;
         this.use_btn.name = "petUse_btn";
         addChild(this.use_btn);
         scroll_btn.x = 22;
         scroll_btn.y = -132;
         scroll_btn.pivotX = 15;
         scroll_btn.pivotY = 19;
         scroll_btn.name = "scroll_btn";
         scroll_btn.visible = !GameMain.isMobile;
         addChild(scroll_btn);
         mask_canvas.drawRectangle(-180,-194,297,394);
         list_sprite.x = -102;
         list_sprite.y = 21;
         list_sprite.mask = mask_canvas;
         list_sprite.name = "itemScrollList";
         addChild(list_sprite);
         _loc5_ = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("dark green pixel"));
         _loc5_.x = -140;
         _loc5_.y = -474;
         _loc5_.width = 250;
         _loc5_.height = 40 * 34;
         _loc5_.name = "listBackdrop";
         list_sprite.addChild(_loc5_);
         var _loc9_:int = 0;
         while(_loc9_ < 30)
         {
            _loc6_ = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("item panel_00"));
            _loc6_.x = -140;
            _loc6_.y = -484 + _loc9_ * 34;
            list_sprite.addChild(_loc6_);
            panel_array.push(_loc6_);
            _loc7_ = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("equip"));
            _loc7_.x = 92;
            _loc7_.y = -470 + _loc9_ * 34;
            _loc7_.pivotX = 24;
            _loc7_.pivotY = 13;
            _loc7_.touchable = false;
            _loc7_.visible = false;
            list_sprite.addChild(_loc7_);
            equipped_array.push(_loc7_);
            _loc9_++;
         }
         _loc9_ = 0;
         while(_loc9_ < 30)
         {
            _loc8_ = new TextField(165,23,"(empty)",AllTextFormats.percent_textFormat);
            _loc8_.x = -98;
            _loc8_.y = -482 + _loc9_ * 34;
            _loc8_.touchable = false;
            _loc8_.batchable = true;
            list_sprite.addChild(_loc8_);
            itemText_array.push(_loc8_);
            _loc9_++;
         }
         var _loc10_:TextField = new TextField(262,33,param1.name.toUpperCase() + " ITEMS",AllTextFormats.title_textFormat);
         _loc10_.x = -139;
         _loc10_.y = -207;
         addChild(_loc10_);
         this.petName_txt.text = param1.name;
         this.petName_txt.x = 58;
         this.petName_txt.y = -174;
         addChild(this.petName_txt);
         item_txt.x = 52;
         item_txt.y = -74;
         addChild(item_txt);
         stats_txt.x = 58;
         stats_txt.y = 52;
         addChild(stats_txt);
         _loc10_.batchable = this.petName_txt.batchable = item_txt.batchable = stats_txt.batchable = true;
         this.petClone = new Pet(param2,"",param1.type);
         this.petClone.fitPreview(300,160);
         this.petClone.x = 135;
         this.petClone.y = -116;
         this.petClone.helmet_string = param1.helmet_string;
         this.petClone.shoes_string = param1.shoes_string;
         addChild(this.petClone);
         drag_image = new Image(Texture.fromBitmapData(new BitmapData(462,36,false,16711680)));
         drag_image.x = -254;
         drag_image.y = -208;
         drag_image.name = "drag_image";
         drag_image.alpha = 0;
         addChild(drag_image);
         list_sprite.y = 325;
         mask_canvas.y = -304;
         yourItem.y += 70;
         yourItem_txt.y += 70;
         yourItemStats_txt.y += 70;
         yourItemType_txt.y += 70;
         yourPanel_image.y += 70;
         this.deselectAll();
         addEventListener(Event.ENTER_FRAME,this.onEnter);
      }
      
      private function onEnter(param1:Event) : void
      {
         if(this.petClone != null && this.petClone.parent != null)
         {
            this.petClone.nextFrame();
            if(this.petClone.currentLabel != "standing")
            {
               this.petClone.gotoAndPlayStanding();
            }
         }
      }
      
      override public function updateMe(param1:uint, param2:Vector.<String>, param3:Person, param4:Boolean = true) : void
      {
         CommonCalls.emptyArray(item_array,true,true);
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = param2.length <= 30 ? int(param2.length) : 30;
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            if(Stats.getItemType(param2[_loc8_]) == "shoes" && param3.bodyAnimator.shoeString == param2[_loc8_] && _loc6_ == 0)
            {
               _loc6_++;
            }
            else if(Stats.getItemType(param2[_loc8_]) == "pet helmet" || Stats.getItemType(param2[_loc8_]) == "item" || Stats.getItemType(param2[_loc8_]) == "shoes" || Stats.getItemType(Fish.fishNoShinyName(param2[_loc8_])) == "fish")
            {
               if(!(param2[_loc8_].substr(param2[_loc8_].length - 3,param2[_loc8_].length - 1) == "log" || param2[_loc8_].substr(param2[_loc8_].length - 4,param2[_loc8_].length - 1) == "wood" || param2[_loc8_] == "robot bar"))
               {
                  itemText_array[_loc5_].text = param2[_loc8_];
                  panel_array[_loc5_].useHandCursor = true;
                  equipped_array[_loc5_].visible = false;
                  this.createItem(param2[_loc8_],_loc5_);
                  _loc5_++;
               }
            }
            _loc8_++;
         }
         if(this.petClone.helmet_string != "pet none helmet")
         {
            itemText_array[_loc5_].text = this.petClone.helmet_string;
            this.createItem(this.petClone.helmet_string,_loc5_);
            equipped_array[_loc5_].visible = true;
            panel_array[_loc5_].useHandCursor = true;
            _loc5_++;
         }
         if(this.petClone.shoes_string != "none shoe")
         {
            this.createItem(this.petClone.shoes_string,_loc5_);
            itemText_array[_loc5_].text = this.petClone.shoes_string;
            equipped_array[_loc5_].visible = true;
            panel_array[_loc5_].useHandCursor = true;
            _loc5_++;
         }
         _loc8_ = _loc5_;
         while(_loc8_ < 30)
         {
            panel_array[_loc8_].visible = itemText_array[_loc8_].visible = equipped_array[_loc8_].visible = false;
            _loc8_++;
         }
      }
      
      private function createItem(param1:String, param2:int) : void
      {
         var _loc3_:Item = new Item(param1,"","",false);
         _loc3_.x = -121;
         _loc3_.y = -469 + param2 * 34;
         _loc3_.scaleX = _loc3_.scaleY = 0.75;
         list_sprite.addChild(_loc3_);
         item_array.push(_loc3_);
      }
      
      public function showItem(param1:Image) : void
      {
         var _loc2_:String = null;
         this.deselectAll();
         param1.texture = ItemMenu.itemMenu_textureAtlas.getTexture("item panel_01");
         var _loc3_:int = int(panel_array.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(panel_array[_loc4_] == param1)
            {
               _loc2_ = itemText_array[_loc4_].text;
               break;
            }
            _loc4_++;
         }
         item_txt.text = _loc2_;
         if(item != null)
         {
            item.removeFromParent(true);
         }
         item = new Item(_loc2_,"","");
         item.x = 144;
         item.y = -13;
         addChild(item);
         if(Stats.getItemType(_loc2_) == "pet helmet")
         {
            resetItem(yourItem,this.petClone.helmet_string,true);
            this.use_btn.visible = false;
            this.equip_btn.visible = Pet(CommonCalls.returnObject(MainStarlingStage(root).gameMain.player.pet_array,this.petName_txt.text)).helmet_string != _loc2_;
            this.unEquip_btn.visible = equipped_array[_loc4_].visible;
            stats_txt.text = "Defense: " + Stats.petHelmetStats[_loc2_].defense;
            if(Stats.petHelmetStats[_loc2_].luck > 0)
            {
               stats_txt.text += "\nLuck: " + Stats.petHelmetStats[_loc2_].luck;
            }
            if(Stats.petHelmetStats[_loc2_].heal > 0)
            {
               stats_txt.text += "\nHealing: " + Stats.petHelmetStats[_loc2_].heal;
            }
            if(Stats.petHelmetStats[_loc2_].speed > 0)
            {
               stats_txt.text += "\nSpeed +" + RoundToNearest.roundTo(Stats.petHelmetStats[_loc2_].speed / 85,100) + " mph";
            }
            stats_txt.text += "\nRequired Level: " + Stats.petHelmetStats[_loc2_].reqLev;
         }
         else if(Stats.getItemType(_loc2_) == "shoes")
         {
            resetItem(yourItem,this.petClone.shoes_string,true);
            this.use_btn.visible = false;
            this.equip_btn.visible = Pet(CommonCalls.returnObject(MainStarlingStage(root).gameMain.player.pet_array,this.petName_txt.text)).shoes_string != _loc2_;
            this.unEquip_btn.visible = equipped_array[_loc4_].visible;
            stats_txt.text = "Defense: " + Stats.shoesStats[_loc2_].defense;
            if(int(Stats.shoesStats[_loc2_].magic / 2) > 0)
            {
               stats_txt.text += "\nHeal: " + int(Stats.shoesStats[_loc2_].magic / 2);
            }
            if(int(Stats.shoesStats[_loc2_].range / 3) > 0)
            {
               stats_txt.text += "\nLuck: " + int(Stats.shoesStats[_loc2_].range / 3);
            }
            if(Stats.shoesStats[_loc2_].artillery > 0)
            {
               stats_txt.text += "\nSpeed: +" + RoundToNearest.roundTo(Stats.shoesStats[_loc2_].artillery / 85,100) + " mph";
            }
            stats_txt.text += "\nRequired Level: " + Stats.shoesStats[_loc2_].reqLev;
         }
         else if(Stats.getItemType(Fish.fishNoShinyName(_loc2_)) == "fish")
         {
            this.use_btn.visible = true;
            this.equip_btn.visible = this.unEquip_btn.visible = false;
            stats_txt.text = "Heals: " + Stats.fishStats[Fish.fishNoShinyName(_loc2_)].heal + " hp";
         }
         else
         {
            if(Stats.allItemDescs[_loc2_])
            {
            }
            this.equip_btn.visible = this.unEquip_btn.visible = false;
            this.use_btn.visible = true;
         }
         if(Stats.getItemType(item_txt.text) == "pet helmet" && this.petClone.helmet_string != "pet none helmet")
         {
            yourItemType_txt.text = "current helmet";
            yourItem_txt.text = this.petClone.helmet_string;
            yourItemStats_txt.text = "Defense: " + Stats.petHelmetStats[this.petClone.helmet_string].defense;
            if(Stats.petHelmetStats[this.petClone.helmet_string].luck > 0)
            {
               yourItemStats_txt.text += "\nLuck: " + Stats.petHelmetStats[this.petClone.helmet_string].luck;
            }
            if(Stats.petHelmetStats[this.petClone.helmet_string].heal > 0)
            {
               yourItemStats_txt.text += "\nHealing: " + Stats.petHelmetStats[this.petClone.helmet_string].heal;
            }
            this.tweenOutYourInfo();
         }
         else if(Stats.getItemType(_loc2_) == "shoes" && this.petClone.shoes_string != "none shoe")
         {
            yourItemType_txt.text = "current shoes";
            yourItem_txt.text = this.petClone.shoes_string;
            yourItemStats_txt.text = "Defense: " + Stats.shoesStats[this.petClone.shoes_string].defense;
            if(int(Stats.shoesStats[this.petClone.shoes_string].magic / 2) > 0)
            {
               yourItemStats_txt.text += "\nHeal: " + int(Stats.shoesStats[this.petClone.shoes_string].magic / 2);
            }
            if(int(Stats.shoesStats[this.petClone.shoes_string].range / 3) > 0)
            {
               yourItemStats_txt.text += "\nLuck: " + int(Stats.shoesStats[this.petClone.shoes_string].range / 3);
            }
            if(Stats.shoesStats[this.petClone.shoes_string].artillery > 0)
            {
               yourItemStats_txt.text += "\nSpeed: +" + RoundToNearest.roundTo(Stats.shoesStats[this.petClone.shoes_string].artillery / 85,100) + " mph";
            }
            this.tweenOutYourInfo();
         }
         else
         {
            yourItem.visible = yourItem_txt.visible = yourItemStats_txt.visible = yourItemType_txt.visible = yourPanel_image.visible = false;
         }
      }
      
      private function tweenOutYourInfo() : void
      {
         yourItem.visible = yourItem_txt.visible = yourItemStats_txt.visible = yourItemType_txt.visible = yourPanel_image.visible = true;
         yourItem.x = 76;
         yourItem_txt.x = 88;
         yourItemStats_txt.x = 63;
         yourItemType_txt.x = 65;
         yourPanel_image.x = 4;
         TweenLite.to(yourItem,0.3,{
            "x":yourItem.x + 185,
            "ease":Back.easeOut
         });
         TweenLite.to(yourItemStats_txt,0.3,{
            "x":yourItemStats_txt.x + 185,
            "ease":Back.easeOut
         });
         TweenLite.to(yourItemType_txt,0.3,{
            "x":yourItemType_txt.x + 185,
            "ease":Back.easeOut
         });
         TweenLite.to(yourPanel_image,0.3,{
            "x":yourPanel_image.x + 185,
            "ease":Back.easeOut
         });
         TweenLite.to(yourItem_txt,0.3,{
            "x":yourItem_txt.x + 185,
            "ease":Back.easeOut
         });
      }
      
      override public function deselectAll() : void
      {
         deselectListItems();
         this.use_btn.visible = this.equip_btn.visible = this.unEquip_btn.visible = false;
         item_txt.text = stats_txt.text = "";
         if(item != null)
         {
            item.removeFromParent(true);
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
         list_sprite.y = Math.abs(CalcDist.getDistY(scroll_btn.y,194) * 2.82) - 600;
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
         if(list_sprite.y < 80 && param1 < 0)
         {
            list_sprite.y = 80;
         }
         mask_canvas.y -= list_sprite.y - _loc2_;
      }
      
      public function get selectedPet() : String
      {
         return this.petName_txt.text;
      }
   }
}

