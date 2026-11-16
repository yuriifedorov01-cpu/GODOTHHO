package com.menus
{
   import com.game_objects.*;
   import com.game_objects.enemies.*;
   import com.stats.*;
   import com.ui.*;
   import com.utilities.*;
   import flash.geom.*;
   import starling.display.*;
   import starling.text.*;
   import starling.textures.TextureAtlas;
   
   public class HeropediaMenu extends StarlingGameMenu
   {
      
      public static var heropediaMenu_textureAtlas:TextureAtlas;
      
      private var panel_image:Image;
      
      private var __selectedEnemy:String;
      
      private var enemyList:Vector.<String>;
      
      private var fishList:Vector.<String>;
      
      private var enemyPanel_array:Vector.<Image> = new Vector.<Image>();
      
      private var fishPanel_array:Vector.<Image> = new Vector.<Image>();
      
      private var fishTextfield_array:Vector.<TextField> = new Vector.<TextField>();
      
      public function HeropediaMenu(param1:Vector.<String>, param2:Vector.<String>)
      {
         var _loc3_:Button = null;
         _loc3_ = null;
         super();
         this.enemyList = param1;
         this.fishList = param2;
         this.panel_image = new Image(heropediaMenu_textureAtlas.getTexture("panel 1"));
         this.panel_image.x = -336;
         this.panel_image.y = -208;
         addChild(this.panel_image);
         _loc3_ = new Button(heropediaMenu_textureAtlas.getTexture("x btn"));
         _loc3_.x = 477;
         _loc3_.y = -193;
         _loc3_.pivotX = 30;
         _loc3_.pivotY = 19;
         _loc3_.name = "x_btn";
         addChild(_loc3_);
         this.gotoMain();
      }
      
      public function gotoMain() : void
      {
         var _loc1_:uint = 0;
         var _loc7_:Image = null;
         _loc1_ = 0;
         var _loc2_:Image = null;
         var _loc3_:Image = null;
         var _loc4_:TextField = null;
         var _loc5_:TextField = null;
         var _loc6_:String = null;
         _loc7_ = null;
         this.panel_image.texture = heropediaMenu_textureAtlas.getTexture("panel 1");
         this.panel_image.readjustSize();
         this.enemyPanel_array.length = this.fishPanel_array.length = this.fishTextfield_array.length = 0;
         this.__selectedEnemy = "";
         var _loc8_:int = numChildren;
         var _loc9_:* = int(_loc8_ - 1);
         while(_loc9_ >= 2)
         {
            removeChildAt(_loc9_);
            _loc9_--;
         }
         var _loc10_:uint = 0;
         _loc1_ = 0;
         _loc9_ = 0;
         while(_loc9_ < Stats.totalEnemyTypes)
         {
            if(_loc9_ % 3 == 0 && _loc9_ > 0)
            {
               _loc1_++;
               _loc10_ = 0;
            }
            _loc2_ = new Image(heropediaMenu_textureAtlas.getTexture("click panel 1"));
            _loc2_.x = -216 + _loc10_ * 146;
            _loc2_.y = -106 + _loc1_ * 27;
            _loc2_.pivotX = 105;
            _loc2_.pivotY = 14;
            _loc2_.useHandCursor = true;
            addChild(_loc2_);
            this.enemyPanel_array.push(_loc2_);
            _loc10_++;
            _loc9_++;
         }
         _loc10_ = _loc1_ = 0;
         _loc9_ = 0;
         while(_loc9_ < Stats.totalFishTypes)
         {
            if(_loc9_ % 3 == 0 && _loc9_ > 0)
            {
               _loc1_++;
               _loc10_ = 0;
            }
            _loc3_ = new Image(heropediaMenu_textureAtlas.getTexture("click panel 1"));
            _loc3_.x = 207 + _loc10_ * 117;
            _loc3_.y = -104 + _loc1_ * 24;
            _loc3_.pivotX = 105;
            _loc3_.pivotY = 14;
            _loc3_.scale = 0.8;
            _loc3_.useHandCursor = true;
            addChild(_loc3_);
            this.fishPanel_array.push(_loc3_);
            _loc10_++;
            _loc9_++;
         }
         _loc10_ = _loc1_ = 0;
         var _loc11_:String = "";
         _loc9_ = 0;
         while(_loc9_ < Stats.totalEnemyTypes)
         {
            if(_loc9_ % 3 == 0 && _loc9_ > 0)
            {
               _loc1_++;
               _loc10_ = 0;
            }
            _loc11_ = _loc9_ < this.enemyList.length ? this.enemyList[_loc9_] : "??????";
            _loc4_ = new TextField(130,20,_loc11_,AllTextFormats.xp2_textFormat);
            _loc4_.x = -316 + _loc10_ * 146;
            _loc4_.y = -119 + _loc1_ * 27;
            _loc4_.touchable = false;
            _loc4_.batchable = true;
            addChild(_loc4_);
            if(_loc11_ == "??????")
            {
               this.enemyPanel_array[_loc9_].texture = heropediaMenu_textureAtlas.getTexture("click panel 3");
               this.enemyPanel_array[_loc9_].touchable = false;
            }
            _loc10_++;
            _loc9_++;
         }
         _loc10_ = _loc1_ = 0;
         var _loc12_:String = "";
         _loc9_ = 0;
         while(_loc9_ < Stats.totalFishTypes)
         {
            if(_loc9_ % 3 == 0 && _loc9_ > 0)
            {
               _loc1_++;
               _loc10_ = 0;
            }
            _loc12_ = _loc9_ < this.fishList.length ? this.fishList[_loc9_] : "??????";
            _loc5_ = new TextField(130,20,Fish.fishNoShinyName(_loc12_),AllTextFormats.desc_textFormat);
            _loc5_.x = 125 + _loc10_ * 117;
            _loc5_.y = -114 + _loc1_ * 24;
            _loc5_.touchable = false;
            _loc5_.batchable = true;
            addChild(_loc5_);
            this.fishTextfield_array.push(_loc5_);
            if(_loc12_ == "??????")
            {
               this.fishPanel_array[_loc9_].texture = heropediaMenu_textureAtlas.getTexture("click panel 3");
               this.fishPanel_array[_loc9_].touchable = false;
            }
            else
            {
               for each(_loc6_ in this.fishList)
               {
                  if(_loc6_.indexOf("shiny") == 0 && _loc6_.indexOf(_loc12_) > -1)
                  {
                     _loc7_ = new Image(heropediaMenu_textureAtlas.getTexture("shine"));
                     _loc7_.x = 229 + _loc10_ * 117;
                     _loc7_.y = -106 + _loc1_ * 24;
                     _loc7_.pivotX = _loc7_.pivotY = 10;
                     _loc7_.touchable = false;
                     _loc7_.scale = 0.92;
                     addChild(_loc7_);
                     break;
                  }
               }
            }
            _loc10_++;
            _loc9_++;
         }
      }
      
      public function showEStats(param1:String) : void
      {
         var _loc2_:TextField = null;
         this.__selectedEnemy = param1;
         this.panel_image.texture = heropediaMenu_textureAtlas.getTexture("panel 2");
         this.panel_image.readjustSize();
         this.enemyPanel_array.length = this.fishPanel_array.length = this.fishTextfield_array.length = 0;
         var _loc3_:int = numChildren;
         var _loc4_:* = int(_loc3_ - 1);
         while(_loc4_ >= 2)
         {
            removeChildAt(_loc4_);
            _loc4_--;
         }
         var _loc5_:Button = new Button(heropediaMenu_textureAtlas.getTexture("back btn"));
         _loc5_.x = -279;
         _loc5_.y = 239;
         _loc5_.pivotX = 36;
         _loc5_.pivotY = 17;
         _loc5_.scaleWhenOver = 0.95;
         _loc5_.name = "heroBack_btn";
         addChild(_loc5_);
         var _loc6_:Button = new Button(heropediaMenu_textureAtlas.getTexture("sound btn"));
         _loc6_.x = -106;
         _loc6_.y = 19;
         _loc6_.pivotX = _loc6_.width / 2;
         _loc6_.pivotY = _loc6_.height / 2;
         _loc6_.name = "enemySound_btn";
         addChild(_loc6_);
         var _loc7_:Enemy = new Enemy(param1,new Rectangle(0,0,1,1));
         _loc7_.x = 252;
         _loc7_.y = 44;
         _loc7_.scale = 0.5;
         addChild(_loc7_);
         _loc2_ = new TextField(250,28,param1,AllTextFormats.guildChat_textFormat);
         _loc2_.y = -164;
         addChild(_loc2_);
         var _loc8_:String = "Health: " + Stats.eStats[param1].health + "\n" + "Defense: " + Stats.eStats[param1].defense + "\n" + "Speed: " + String(RoundToNearest.roundTo(Stats.eStats[param1].moveSpeed * 8,10)) + " mph\n" + "XP: " + Stats.eStats[param1].worth * 3 + "\n" + "Worth: $" + Stats.eStats[param1].worth + "\n" + "Height: " + String(RoundToNearest.roundTo(_loc7_.height / 7,10)) + " feet\n" + "Power: " + Stats.eStats[param1].power;
         var _loc9_:TextField = new TextField(224,142,_loc8_,AllTextFormats.item3_textFormat);
         _loc9_.y = -125;
         _loc9_.batchable = _loc2_.batchable = true;
         addChild(_loc9_);
         var _loc10_:TextField = new TextField(768,148,Stats.eStats[param1].desc,AllTextFormats.classDesc_textFormat);
         _loc10_.x = _loc9_.x = _loc2_.x = -310;
         _loc10_.y = 63;
         _loc10_.touchable = _loc9_.touchable = _loc2_.touchable = false;
         addChild(_loc10_);
         if(param1 == "mongrel")
         {
            _loc7_.y -= 170;
         }
         else if(param1 == "omega fluff")
         {
            _loc7_.y -= 37;
         }
      }
      
      public function showFishStats(param1:String) : void
      {
         var _loc2_:Fish = null;
         var _loc3_:TextField = null;
         this.panel_image.texture = heropediaMenu_textureAtlas.getTexture("panel 3");
         this.panel_image.readjustSize();
         this.enemyPanel_array.length = this.fishPanel_array.length = this.fishTextfield_array.length = 0;
         var _loc4_:int = numChildren;
         var _loc5_:* = int(_loc4_ - 1);
         while(_loc5_ >= 2)
         {
            removeChildAt(_loc5_);
            _loc5_--;
         }
         var _loc6_:Fish = new Fish(0,0,param1);
         _loc6_.x = 72;
         _loc6_.y = -104;
         addChild(_loc6_);
         var _loc7_:Fish = new Fish(0,0,param1);
         _loc7_.x = 354;
         _loc7_.y = -58;
         _loc7_.scale = 1.5;
         addChild(_loc7_);
         var _loc8_:Button = new Button(heropediaMenu_textureAtlas.getTexture("back btn"));
         _loc8_.x = -279;
         _loc8_.y = 239;
         _loc8_.pivotX = 36;
         _loc8_.pivotY = 17;
         _loc8_.scaleWhenOver = 0.95;
         _loc8_.name = "heroBack_btn";
         addChild(_loc8_);
         if(this.fishList.indexOf("shiny " + param1) > -1)
         {
            _loc2_ = new Fish(0,0,param1);
            _loc2_.x = _loc6_.x;
            _loc2_.y = 0;
            _loc2_.shiny = true;
            addChild(_loc2_);
         }
         else
         {
            _loc3_ = new TextField(93,57,"?",AllTextFormats.confirmed_textFormat);
            _loc3_.x = 30;
            _loc3_.y = -30;
            _loc3_.batchable = true;
            _loc3_.touchable = false;
            addChild(_loc3_);
         }
         var _loc9_:TextField = new TextField(250,28,param1,AllTextFormats.guildChat_textFormat);
         _loc9_.y = -164;
         addChild(_loc9_);
         var _loc10_:String = "common";
         if(Stats.fishStats[param1].rare < 15)
         {
            _loc10_ = "rare";
         }
         else if(Stats.fishStats[param1].rare < 50)
         {
            _loc10_ = "uncommon";
         }
         var _loc11_:String = "Bite speed: " + Stats.fishStats[param1].time + " ms" + "\nWorth: $" + Stats.fishStats[param1].cost + "\nHeal: " + Stats.fishStats[param1].heal + " hp" + "\nOccurance: " + _loc10_ + "\nLength: " + String(RoundToNearest.roundTo(_loc6_.width / 27,100)) + " feet\n";
         var _loc12_:TextField = new TextField(224,142,_loc11_,AllTextFormats.item3_textFormat);
         _loc12_.y = -145;
         _loc12_.batchable = _loc9_.batchable = true;
         addChild(_loc12_);
         var _loc13_:TextField = new TextField(768,148,Stats.fishStats[param1].desc,AllTextFormats.classDesc_textFormat);
         _loc13_.x = _loc12_.x = _loc9_.x = -310;
         _loc13_.y = 63;
         _loc13_.touchable = _loc12_.touchable = _loc9_.touchable = false;
         addChild(_loc13_);
      }
      
      public function panelToEnemy(param1:Image) : String
      {
         var _loc2_:int = int(this.enemyList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.enemyPanel_array[_loc3_] == param1)
            {
               return this.enemyList[_loc3_];
            }
            _loc3_++;
         }
         return "";
      }
      
      public function panelToFish(param1:Image) : String
      {
         var _loc2_:int = int(this.fishList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.fishPanel_array[_loc3_] == param1)
            {
               return this.fishTextfield_array[_loc3_].text;
            }
            _loc3_++;
         }
         return "";
      }
      
      public function get selectedEnemy() : String
      {
         return this.__selectedEnemy;
      }
   }
}

