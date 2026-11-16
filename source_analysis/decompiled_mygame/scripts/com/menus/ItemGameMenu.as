package com.menus
{
   import com.game_objects.*;
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.stats.*;
   import com.ui.*;
   import com.utilities.*;
   import com.visual_effects.*;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import starling.*;
   import starling.display.*;
   import starling.text.*;
   import starling.utils.*;
   
   public class ItemGameMenu extends StarlingGameMenu
   {
      
      public const item_txt:TextField = new TextField(184,24,"",AllTextFormats.petName_textFormat);
      
      protected const stats_txt:TextField = new TextField(165,138,"",AllTextFormats.stats_textFormat);
      
      protected const desc_txt:TextField = new TextField(165,82,"",AllTextFormats.desc_textFormat);
      
      protected const scroll_btn:Button = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("scroll"));
      
      public var item:Item;
      
      protected var panel_array:Vector.<Image> = new Vector.<Image>();
      
      protected var itemText_array:Vector.<TextField> = new Vector.<TextField>();
      
      protected var equipped_array:Vector.<Image> = new Vector.<Image>();
      
      protected var item_array:Vector.<Item> = new Vector.<Item>();
      
      protected var item_point:Point;
      
      protected const mask_canvas:Canvas = new Canvas();
      
      protected const list_sprite:Sprite = new Sprite();
      
      protected var yourPanel_image:Image = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("your item panel"));
      
      protected var yourPanel2_image:Image = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("your item panel"));
      
      protected var yourItemType_txt:TextField = new TextField(157,19,"",AllTextFormats.yourItemType_textFormat);
      
      protected var yourItemType2_txt:TextField = new TextField(157,19,"",AllTextFormats.yourItemType_textFormat);
      
      protected var yourItem_txt:TextField = new TextField(180,24,"",AllTextFormats.item_textFormat);
      
      protected var yourItem2_txt:TextField = new TextField(180,24,"",AllTextFormats.item_textFormat);
      
      protected var yourItemStats_txt:TextField = new TextField(165,165,"",AllTextFormats.stats_textFormat);
      
      protected var yourItemStats2_txt:TextField = new TextField(165,165,"",AllTextFormats.stats_textFormat);
      
      protected var yourItem:Item;
      
      protected var yourItem2:Item;
      
      public function ItemGameMenu()
      {
         super();
         this.yourPanel_image.x = this.yourPanel2_image.x = 4;
         this.yourPanel_image.y = -179;
         this.yourPanel2_image.y = 37;
         this.yourPanel_image.touchable = this.yourPanel2_image.touchable = false;
         addChild(this.yourPanel_image);
         addChild(this.yourPanel2_image);
         this.yourItemType_txt.x = this.yourItemType2_txt.x = 65;
         this.yourItemType_txt.y = -209;
         this.yourItemType2_txt.y = 6;
         addChild(this.yourItemType_txt);
         addChild(this.yourItemType2_txt);
         this.yourItem_txt.x = this.yourItem2_txt.x = 88;
         this.yourItem_txt.y = -192;
         this.yourItem2_txt.y = 24;
         addChild(this.yourItem_txt);
         addChild(this.yourItem2_txt);
         this.yourItemStats_txt.x = this.yourItemStats2_txt.x = 63;
         this.yourItemStats_txt.y = -161;
         this.yourItemStats2_txt.y = 53;
         addChild(this.yourItemStats_txt);
         addChild(this.yourItemStats2_txt);
         this.yourItemType_txt.batchable = this.yourItemType2_txt.batchable = this.yourItem_txt.batchable = this.yourItem2_txt.batchable = this.yourItemStats_txt.batchable = this.yourItemStats2_txt.batchable = true;
         this.yourItemType_txt.touchable = this.yourItemType2_txt.touchable = this.yourItem_txt.touchable = this.yourItem2_txt.touchable = this.yourItemStats_txt.touchable = this.yourItemStats2_txt.touchable = false;
         this.yourItem = new Item("coin","","");
         this.yourItem.x = 76;
         this.yourItem.y = -179;
         addChild(this.yourItem);
         this.yourItem2 = new Item("coin","","");
         this.yourItem2.x = this.yourItem.x;
         this.yourItem2.y = 37;
         this.yourItem.scaleX = this.yourItem.scaleY = this.yourItem2.scaleX = this.yourItem2.scaleY = 0.75;
         addChild(this.yourItem2);
      }
      
      public function clickItem(param1:Image, param2:Person, param3:flash.display.MovieClip, param4:Boolean, param5:RegExp) : void
      {
         var _loc6_:String = null;
         if(this is ItemMenu || this is TradeMenu)
         {
            this.deselectListItems();
            if(param1.texture == ItemMenu.itemMenu_textureAtlas.getTexture("item panel_00") || param1.texture == ItemMenu.itemMenu_textureAtlas.getTexture("item panel_01"))
            {
               param1.texture = ItemMenu.itemMenu_textureAtlas.getTexture("item panel_01");
            }
            else
            {
               param1.texture = ItemMenu.itemMenu_textureAtlas.getTexture("item panel_02");
            }
            _loc6_ = this.panelToItem(param1);
            this.showItemStats(_loc6_,param1);
            if(this is ItemMenu)
            {
               this.item_txt.text = ItemMenu(this).showItemInfo(param1);
            }
            else
            {
               this.item_txt.text = _loc6_;
               TradeMenu(this).showItemStats(_loc6_,param1);
            }
         }
      }
      
      public function showItemStats(param1:String, param2:Image = null) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:Object = null;
         var _loc3_:String = null;
         if(this.item != null)
         {
            this.item.removeFromParent(true);
         }
         this.item = new Item(param1,"","");
         this.item.x = this is ItemMenu ? 142 : 327;
         this.item.y = -97;
         addChild(this.item);
         if(param1.indexOf("shiny") == 0)
         {
            ShineEffect.shineObjectNoParent(this.item,4);
         }
         switch(Stats.getItemType(Fish.fishNoShinyName(param1)))
         {
            case "weapon":
               if(Stats.wStats[param1].defense == 0)
               {
                  this.stats_txt.text = "Power: " + Stats.wStats[param1].minPower + "-" + Stats.wStats[param1].maxPower;
                  this.item.rotation = 0;
                  if(Stats.wStats[param1].isRange == false)
                  {
                     this.stats_txt.text += "\nReach: " + String(RoundToNearest.roundTo(this.item.height / 20,10)) + " feet";
                  }
                  else if(Stats.wStats[param1].sRate == 0)
                  {
                     this.stats_txt.text += "\nReach: 100 feet";
                  }
                  else
                  {
                     this.stats_txt.text += "\nReach: 70 feet";
                  }
                  this.item.rotation = deg2rad(-55);
                  if(Stats.wStats[param1].isMagic)
                  {
                     this.stats_txt.text += "\nIs Magic: " + (Stats.wStats[param1].isMagic ? "yes" : "no");
                  }
                  if(Stats.wStats[param1].fireDamage > 0)
                  {
                     this.stats_txt.text += "\nFire Damage: " + Stats.wStats[param1].fireDamage;
                  }
                  if(Stats.wStats[param1].shockDamage > 0)
                  {
                     this.stats_txt.text += "\nShock Damage: " + Stats.wStats[param1].shockDamage;
                  }
                  if(Stats.wStats[param1].iceDamage > 0)
                  {
                     this.stats_txt.text += "\nIce Damage: " + Stats.wStats[param1].iceDamage;
                  }
                  if(Stats.wStats[param1].sRate > 0)
                  {
                     this.stats_txt.text += "\nShots per min: " + int(30 / Stats.wStats[param1].sRate * 60);
                  }
               }
               else
               {
                  this.stats_txt.text = "Defense: " + Stats.wStats[param1].defense;
               }
               this.stats_txt.text += "\nTwo Handed: " + (Stats.wStats[param1].twoHanded ? "yes" : "no");
               break;
            case "helmet":
               this.showYourItemStats(param1,Stats.hStats,this.stats_txt,true);
               break;
            case "shirt":
               this.showYourItemStats(param1,Stats.sStats,this.stats_txt,true);
               break;
            case "pants":
               this.showYourItemStats(param1,Stats.pStats,this.stats_txt,true);
               break;
            case "shoes":
               this.showYourItemStats(param1,Stats.shoesStats,this.stats_txt,true);
               break;
            case "item":
               if(Stats.allItemDescs[param1])
               {
                  this.stats_txt.text = "";
                  this.desc_txt.text = Stats.allItemDescs[param1].desc;
               }
               break;
            case "pet helmet":
               this.stats_txt.text = "Defense: " + Stats.petHelmetStats[param1].defense;
               if(Stats.petHelmetStats[param1].luck > 0)
               {
                  this.stats_txt.text += "\nLuck: " + Stats.petHelmetStats[param1].luck;
               }
               if(Stats.petHelmetStats[param1].heal > 0)
               {
                  this.stats_txt.text += "\nHeal: " + Stats.petHelmetStats[param1].heal;
               }
               if(Stats.petHelmetStats[param1].speed > 0)
               {
                  this.stats_txt.text += "\nSpeed: +" + RoundToNearest.roundTo(Stats.petHelmetStats[param1].speed / 85,100) + " mph";
               }
               break;
            case "fish":
               if(Stats.fishStats[Fish.fishNoShinyName(param1)] != undefined)
               {
                  this.stats_txt.text = "Heals: " + Stats.fishStats[Fish.fishNoShinyName(param1)].heal + " hp";
                  if(param1.indexOf("shiny") == 0)
                  {
                     this.showYourItemStats(Fish.fishNoShinyName(param1),Stats.fishStats,this.stats_txt,true);
                  }
               }
               break;
            case "accessory":
               this.showYourItemStats(param1,Stats.accStats,this.stats_txt,true);
         }
         var _loc4_:Person = MainStarlingStage(root).gameMain.player;
         if(Stats.getItemType(param1) != "item" && Stats.getItemType(param1) != "fish" && !(this is TradeMenu))
         {
            switch(Stats.getItemType(param1))
            {
               case "weapon":
                  this.yourItem.visible = this.yourItem_txt.visible = this.yourPanel_image.visible = this.yourItemType_txt.visible = this.yourItemStats_txt.visible = true;
                  this.resetItem(this.yourItem,_loc4_.bodyAnimator.weaponString,true);
                  this.yourItem_txt.text = _loc4_.bodyAnimator.weaponString;
                  if(Stats.wStats[_loc4_.bodyAnimator.weaponString].defense == 0)
                  {
                     this.yourItemStats_txt.text = "Power: " + Stats.wStats[_loc4_.bodyAnimator.weaponString].minPower + "-" + Stats.wStats[_loc4_.bodyAnimator.weaponString].maxPower;
                     this.yourItem.rotation = 0;
                     this.yourItemStats_txt.text += "\nReach: " + (Stats.wStats[_loc4_.bodyAnimator.weaponString].isRange == false ? String(RoundToNearest.roundTo(this.yourItem.height / 20,10)) : "100") + " feet";
                     this.yourItem.rotation = deg2rad(-55);
                     if(Stats.wStats[_loc4_.bodyAnimator.weaponString].isMagic)
                     {
                        this.yourItemStats_txt.text += "\nIs Magic: " + (Stats.wStats[_loc4_.bodyAnimator.weaponString].isMagic ? "yes" : "no");
                     }
                     if(Stats.wStats[_loc4_.bodyAnimator.weaponString].fireDamage > 0)
                     {
                        this.yourItemStats_txt.text += "\nFire Damage: " + Stats.wStats[_loc4_.bodyAnimator.weaponString].fireDamage;
                     }
                     if(Stats.wStats[_loc4_.bodyAnimator.weaponString].shockDamage > 0)
                     {
                        this.yourItemStats_txt.text += "\nShock Damage: " + Stats.wStats[_loc4_.bodyAnimator.weaponString].shockDamage;
                     }
                     if(Stats.wStats[_loc4_.bodyAnimator.weaponString].iceDamage > 0)
                     {
                        this.yourItemStats_txt.text += "\nIce Damage: " + Stats.wStats[_loc4_.bodyAnimator.weaponString].iceDamage;
                     }
                     if(Stats.wStats[_loc4_.bodyAnimator.weaponString].sRate > 0)
                     {
                        this.yourItemStats_txt.text += "\nShots per min: " + int(30 / Stats.wStats[_loc4_.bodyAnimator.weaponString].sRate * 60);
                     }
                  }
                  else
                  {
                     this.yourItemStats_txt.text = "Defense: " + Stats.wStats[_loc4_.bodyAnimator.weaponString].defense;
                  }
                  if(_loc4_.bodyAnimator.weapon2String != "none")
                  {
                     this.resetItem(this.yourItem2,_loc4_.bodyAnimator.weapon2String,false);
                     this.yourItem2_txt.text = _loc4_.bodyAnimator.weapon2String;
                     if(Stats.wStats[_loc4_.bodyAnimator.weapon2String].defense == 0)
                     {
                        this.yourItemStats2_txt.text = "Power: " + Stats.wStats[_loc4_.bodyAnimator.weapon2String].minPower + "-" + Stats.wStats[_loc4_.bodyAnimator.weapon2String].maxPower;
                        this.yourItem2.rotation = 0;
                        this.yourItemStats2_txt.text += "\nReach: " + (Stats.wStats[_loc4_.bodyAnimator.weapon2String].isRange == false ? String(RoundToNearest.roundTo(this.yourItem2.height / 20,10)) : "100") + " feet";
                        this.yourItem2.rotation = deg2rad(-55);
                        if(Stats.wStats[_loc4_.bodyAnimator.weapon2String].isMagic)
                        {
                           this.yourItemStats2_txt.text += "\nIs Magic: " + (Stats.wStats[_loc4_.bodyAnimator.weapon2String].isMagic ? "yes" : "no");
                        }
                        if(Stats.wStats[_loc4_.bodyAnimator.weapon2String].fireDamage > 0)
                        {
                           this.yourItemStats2_txt.text += "\nFire Damage: " + Stats.wStats[_loc4_.bodyAnimator.weapon2String].fireDamage;
                        }
                        if(Stats.wStats[_loc4_.bodyAnimator.weapon2String].shockDamage > 0)
                        {
                           this.yourItemStats2_txt.text += "\nShock Damage: " + Stats.wStats[_loc4_.bodyAnimator.weapon2String].shockDamage;
                        }
                        if(Stats.wStats[_loc4_.bodyAnimator.weapon2String].iceDamage > 0)
                        {
                           this.yourItemStats2_txt.text += "\nIce Damage: " + Stats.wStats[_loc4_.bodyAnimator.weapon2String].iceDamage;
                        }
                     }
                     else
                     {
                        this.yourItemStats2_txt.text = "Defense: " + Stats.wStats[_loc4_.bodyAnimator.weapon2String].defense;
                     }
                  }
                  break;
               case "helmet":
                  this.showYourItemStats(_loc4_.bodyAnimator.helmetString,Stats.hStats,this.yourItemStats_txt,true);
                  break;
               case "shirt":
                  this.showYourItemStats(_loc4_.bodyAnimator.shirtString,Stats.sStats,this.yourItemStats_txt,true);
                  break;
               case "pants":
                  this.showYourItemStats(_loc4_.bodyAnimator.pantsString,Stats.pStats,this.yourItemStats_txt,true);
                  break;
               case "shoes":
                  this.showYourItemStats(_loc4_.bodyAnimator.shoeString,Stats.shoesStats,this.yourItemStats_txt,true);
                  break;
               case "accessory":
                  this.showYourItemStats(_loc4_.bodyAnimator.accessoryString,Stats.accStats,this.yourItemStats_txt,true);
            }
            this.yourItemType_txt.text = "current " + Stats.getItemType(param1);
            this.n_tweenInOut(this.yourItem,this.yourItem_txt,this.yourItemStats_txt,this.yourItemType_txt,this.yourPanel_image);
            if(_loc4_.bodyAnimator.weapon2String != "none" && Stats.getItemType(param1) == "weapon")
            {
               this.yourItem2.visible = this.yourItemStats2_txt.visible = this.yourItemType2_txt.visible = this.yourPanel2_image.visible = this.yourItem2_txt.visible = true;
               this.yourItemType_txt.text = "primary " + Stats.getItemType(param1);
               this.yourItemType2_txt.text = "secondary " + Stats.getItemType(param1);
               this.n_tweenInOut(this.yourItem2,this.yourItem2_txt,this.yourItemStats2_txt,this.yourItemType2_txt,this.yourPanel2_image);
            }
            else
            {
               this.yourItem2.visible = this.yourItemStats2_txt.visible = this.yourItemType2_txt.visible = this.yourPanel2_image.visible = this.yourItem2_txt.visible = false;
            }
         }
         else
         {
            this.yourItem.visible = this.yourItemStats_txt.visible = this.yourItemType_txt.visible = this.yourPanel_image.visible = this.yourItem_txt.visible = false;
         }
         if(Stats.getItemType(param1) != "item" && Stats.getItemType(param1) != "pet helmet" && Stats.getItemType(Fish.fishNoShinyName(param1)) != "fish")
         {
            _loc5_ = Stats.getItemArray(Stats.getItemType(param1));
            if(_loc5_ != null && _loc5_[param1] != undefined)
            {
               this.stats_txt.text += "\nRequired Lev: " + _loc5_[param1].reqLev;
            }
            if(this is ItemMenu)
            {
               if(Stats.allItemDescs[param1])
               {
                  this.desc_txt.text = Stats.allItemDescs[param1].desc;
               }
            }
         }
         else if(Stats.getItemType(param1) == "pet helmet")
         {
            _loc6_ = Stats.getItemArray(Stats.getItemType(param1));
            if(_loc6_ != null && _loc6_[param1] != undefined)
            {
               this.stats_txt.text += "\nRequired Pet Lev: " + _loc6_[param1].reqLev;
            }
            if(this is ItemMenu)
            {
               if(Stats.allItemDescs[param1])
               {
                  this.desc_txt.text = Stats.allItemDescs[param1].desc;
               }
            }
         }
         else if(Stats.getItemType(Fish.fishNoShinyName(param1)) == "fish")
         {
            _loc7_ = Stats.fishStats[Fish.fishNoShinyName(param1)];
            if(_loc7_ != undefined && _loc7_.desc != null)
            {
               _loc3_ = _loc7_.desc.substr(0,_loc7_.desc.indexOf(".") + 1);
               this.desc_txt.text = _loc3_;
            }
         }
      }
      
      protected function resetItem(param1:Item, param2:String, param3:Boolean) : void
      {
         var _loc4_:Item = param3 ? this.yourItem : this.yourItem2;
         var _loc5_:Number = param1.x;
         var _loc6_:Number = param1.y;
         var _loc7_:Number = param1.scaleX;
         var _loc8_:int = getChildIndex(param1);
         if(param3)
         {
            if(this.yourItem != null)
            {
               this.yourItem.removeFromParent(true);
            }
            this.yourItem = new Item(param2,"","");
            this.yourItem.x = _loc5_;
            this.yourItem.y = _loc6_;
            this.yourItem.scaleX = this.yourItem.scaleY = _loc7_;
            addChildAt(this.yourItem,_loc8_);
         }
         else
         {
            if(this.yourItem2 != null)
            {
               this.yourItem2.removeFromParent(true);
            }
            this.yourItem2 = new Item(param2,"","");
            this.yourItem2.x = _loc5_;
            this.yourItem2.y = _loc6_;
            this.yourItem2.scaleX = this.yourItem2.scaleY = _loc7_;
            addChildAt(this.yourItem2,_loc8_);
         }
      }
      
      public function deselectListItems() : void
      {
         var _loc1_:Image = null;
         for each(_loc1_ in this.panel_array)
         {
            if(_loc1_.texture != ItemMenu.itemMenu_textureAtlas.getTexture("item panel_02") && _loc1_.texture != ItemMenu.itemMenu_textureAtlas.getTexture("item panel_03"))
            {
               _loc1_.texture = ItemMenu.itemMenu_textureAtlas.getTexture("item panel_00");
            }
            else
            {
               _loc1_.texture = ItemMenu.itemMenu_textureAtlas.getTexture("item panel_02");
            }
         }
      }
      
      public function deselectAll() : void
      {
         this.item_txt.text = this.stats_txt.text = this.desc_txt.text = "";
         if(this.item != null)
         {
            this.item.removeFromParent(true);
         }
         this.yourItem.visible = this.yourItem_txt.visible = this.yourPanel_image.visible = this.yourItemType_txt.visible = this.yourItemStats_txt.visible = false;
      }
      
      private function showYourItemStats(param1:String, param2:Array, param3:TextField, param4:Boolean) : void
      {
         if(param3 == this.yourItemStats_txt && param1 != "nothing" && param1 != "none")
         {
            this.resetItem(this.yourItem,param1,param4);
            this.yourItem_txt.text = param1;
            this.yourItem.visible = this.yourItem_txt.visible = this.yourPanel_image.visible = this.yourItemType_txt.visible = this.yourItemStats_txt.visible = true;
         }
         else if(param1 == "nothing" || param1 == "none")
         {
            if(param4 == true)
            {
               this.yourItem.visible = this.yourItem_txt.visible = this.yourPanel_image.visible = this.yourItemType_txt.visible = this.yourItemStats_txt.visible = false;
            }
         }
         if(param2[param1] == undefined)
         {
            return;
         }
         if(param2[param1].defense != undefined)
         {
            param3.text = "Defense: " + param2[param1].defense;
         }
         if(param2[param1].range > 0)
         {
            param3.text += "\nRange: " + param2[param1].range;
         }
         if(param2[param1].magic > 0)
         {
            param3.text += "\nMagic: " + param2[param1].magic;
         }
         if(param2[param1].power > 0)
         {
            param3.text += "\nPower: " + param2[param1].power;
         }
         if(param2[param1].artillery > 0)
         {
            param3.text += "\nArtillery: " + param2[param1].artillery;
         }
      }
      
      private function n_tweenInOut(param1:Item, param2:TextField, param3:TextField, param4:TextField, param5:Image) : void
      {
         param1.x = 76;
         param2.x = 88;
         param3.x = 63;
         param4.x = 65;
         param5.x = 4;
         TweenLite.to(param1,0.3,{
            "x":param1.x + 185,
            "ease":Back.easeOut
         });
         TweenLite.to(param3,0.3,{
            "x":param3.x + 185,
            "ease":Back.easeOut
         });
         TweenLite.to(param4,0.3,{
            "x":param4.x + 185,
            "ease":Back.easeOut
         });
         TweenLite.to(param5,0.3,{
            "x":param5.x + 185,
            "ease":Back.easeOut
         });
         TweenLite.to(param2,0.3,{
            "x":param2.x + 185,
            "ease":Back.easeOut
         });
      }
      
      public function updateMe(param1:uint, param2:Vector.<String>, param3:Person, param4:Boolean = true) : void
      {
         var _loc5_:Item = null;
         var _loc6_:int = int(this.panel_array.length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            this.itemText_array[_loc7_].text = "(empty)";
            this.panel_array[_loc7_].touchable = false;
            this.panel_array[_loc7_].useHandCursor = false;
            if(_loc7_ < this.equipped_array.length)
            {
               this.equipped_array[_loc7_].visible = false;
            }
            _loc7_++;
         }
         _loc6_ = int(param2.length);
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            this.panel_array[_loc7_].touchable = this.panel_array[_loc7_].useHandCursor = true;
            this.itemText_array[_loc7_].text = param2[_loc7_];
            _loc5_ = new Item(param2[_loc7_],"","",false);
            _loc5_.x = -121;
            _loc5_.y = -469 + _loc7_ * 34;
            _loc5_.scaleX = _loc5_.scaleY = 0.75;
            this.list_sprite.addChild(_loc5_);
            this.item_array.push(_loc5_);
            if(_loc7_ < this.equipped_array.length)
            {
               if(this.itemText_array[_loc7_].text == param3.bodyAnimator.weaponString || this.itemText_array[_loc7_].text == param3.bodyAnimator.helmetString || this.itemText_array[_loc7_].text == param3.bodyAnimator.shirtString || this.itemText_array[_loc7_].text == param3.bodyAnimator.shoeString || this.itemText_array[_loc7_].text == param3.bodyAnimator.weapon2String || this.itemText_array[_loc7_].text == param3.bodyAnimator.accessoryString || this.itemText_array[_loc7_].text == param3.bodyAnimator.pantsString)
               {
                  if(this.checkEquippedMarked(this.itemText_array[_loc7_].text) == 0 && (Stats.getItemType(this.itemText_array[_loc7_].text) != "weapon" || param3.bodyAnimator.weaponString != param3.bodyAnimator.weapon2String))
                  {
                     this.equipped_array[_loc7_].visible = true;
                  }
                  else if(this.checkEquippedMarked(this.itemText_array[_loc7_].text) < 2 && param3.bodyAnimator.weaponString == param3.bodyAnimator.weapon2String && Stats.getItemType(this.itemText_array[_loc7_].text) == "weapon")
                  {
                     this.equipped_array[_loc7_].visible = true;
                  }
               }
            }
            _loc7_++;
         }
      }
      
      private function panelToItem(param1:Image) : String
      {
         var _loc2_:int = int(this.panel_array.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.panel_array[_loc3_] == param1)
            {
               return this.itemText_array[_loc3_].text;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function checkEquippedMarked(param1:String) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = int(this.panel_array.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(this.itemText_array[_loc4_].text == param1 && this.equipped_array[_loc4_].visible == true)
            {
               _loc2_++;
            }
            _loc4_++;
         }
         return _loc2_;
      }
   }
}

