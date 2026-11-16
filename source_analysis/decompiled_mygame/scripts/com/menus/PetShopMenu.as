package com.menus
{
   import com.game_objects.*;
   import com.stats.*;
   import com.ui.*;
   import com.utilities.*;
   import flash.display.*;
   import starling.*;
   import starling.display.*;
   import starling.events.*;
   import starling.text.*;
   import starling.textures.*;
   
   public final class PetShopMenu extends StarlingGameMenu
   {
      
      private const panel_array:Vector.<Image> = new Vector.<Image>();
      
      private const petClone_array:Vector.<Pet> = new Vector.<Pet>();
      
      private const typeText_array:Vector.<TextField> = new Vector.<TextField>();
      
      private const levelText_array:Vector.<TextField> = new Vector.<TextField>();
      
      private const type_txt:TextField = new TextField(196,32,"",AllTextFormats.type2_textFormat);
      
      private const cost_txt:TextField = new TextField(188,23,"",AllTextFormats.cost2_textFormat);
      
      private const stats_txt:TextField = new TextField(210,149,"",AllTextFormats.stats_textFormat);
      
      private const desc_txt:TextField = new TextField(424,58,"",AllTextFormats.desc_textFormat);
      
      private const buy_btn:Button = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("buy_btn"));
      
      private const mode_btn:Button = new Button(PetMenu.petMenu_textureAtlas.getTexture("mode_00"),"",null,PetMenu.petMenu_textureAtlas.getTexture("mode_01"));
      
      private var petClone:Pet;
      
      public function PetShopMenu(param1:Vector.<String>, param2:GameMain)
      {
         var _loc8_:Image = null;
         var _loc9_:Button = null;
         var _loc11_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Image = null;
         var _loc5_:TextField = null;
         var _loc6_:TextField = null;
         var _loc7_:Pet = null;
         super();
         _loc8_ = new Image(PetMenu.petMenu_textureAtlas.getTexture("pet shop panel"));
         _loc8_.x = -404;
         _loc8_.y = -67;
         addChild(_loc8_);
         _loc9_ = new Button(PetMenu.petMenu_textureAtlas.getTexture("x_btn_00"),"",null,ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_01"));
         _loc9_.x = 386;
         _loc9_.y = -53;
         _loc9_.pivotX = 30;
         _loc9_.pivotY = 19;
         _loc9_.name = "x_btn";
         addChild(_loc9_);
         this.mode_btn.x = 335;
         this.mode_btn.y = 91;
         this.mode_btn.pivotX = 49;
         this.mode_btn.pivotY = 15;
         this.mode_btn.scaleX = this.mode_btn.scaleY = 0.7;
         this.mode_btn.scaleWhenOver = 0.95;
         this.mode_btn.name = "petMode_btn";
         addChild(this.mode_btn);
         var _loc10_:int = int(param1.length);
         _loc11_ = 0;
         while(_loc11_ < _loc10_)
         {
            _loc3_ = _loc11_ < 3 ? _loc11_ : int(_loc11_ - 3);
            _loc4_ = new Image(PetMenu.petMenu_textureAtlas.getTexture("panel_00"));
            _loc4_.x = -381 + _loc3_ * 109;
            _loc4_.y = _loc11_ < 3 ? -17 : 97;
            _loc4_.useHandCursor = true;
            addChild(_loc4_);
            this.panel_array.push(_loc4_);
            _loc11_++;
         }
         _loc11_ = 0;
         while(_loc11_ < _loc10_)
         {
            _loc3_ = _loc11_ < 3 ? _loc11_ : int(_loc11_ - 3);
            _loc5_ = new TextField(121,21,param1[_loc11_],AllTextFormats.petLvl_textFormat);
            _loc5_.x = -398 + _loc3_ * 109;
            _loc5_.y = _loc11_ < 3 ? -24 : 90;
            _loc5_.touchable = false;
            _loc5_.batchable = true;
            addChild(_loc5_);
            this.typeText_array.push(_loc5_);
            _loc6_ = new TextField(65,21,"Lvl: 1",AllTextFormats.petType_textFormat);
            _loc6_.x = -369 + _loc3_ * 109;
            _loc6_.y = _loc11_ < 3 ? 68 : 182;
            _loc6_.touchable = false;
            _loc6_.batchable = true;
            addChild(_loc6_);
            this.levelText_array.push(_loc6_);
            _loc11_++;
         }
         this.type_txt.x = -45;
         this.type_txt.y = -12;
         addChild(this.type_txt);
         this.cost_txt.x = -41;
         this.cost_txt.y = 120;
         addChild(this.cost_txt);
         this.stats_txt.x = 168;
         this.stats_txt.y = -15;
         addChild(this.stats_txt);
         this.desc_txt.x = -49;
         this.desc_txt.y = 149;
         addChild(this.desc_txt);
         this.type_txt.batchable = this.cost_txt.batchable = this.stats_txt.batchable = true;
         this.desc_txt.touchable = this.type_txt.touchable = this.cost_txt.touchable = this.stats_txt.touchable = false;
         this.buy_btn.x = 333;
         this.buy_btn.y = 120;
         this.buy_btn.pivotX = 33;
         this.buy_btn.pivotY = 15;
         this.buy_btn.name = "petBuy_btn";
         this.buy_btn.scaleWhenOver = 0.95;
         addChild(this.buy_btn);
         drag_image = new Image(Texture.fromBitmapData(new BitmapData(756,36,false,16711680)));
         drag_image.x = -401;
         drag_image.y = -69;
         drag_image.name = "drag_image";
         drag_image.alpha = 0;
         addChild(drag_image);
         _loc11_ = 0;
         while(_loc11_ < _loc10_)
         {
            _loc3_ = _loc11_ < 3 ? _loc11_ : int(_loc11_ - 3);
            _loc7_ = new Pet(param2,"",param1[_loc11_]);
            _loc7_.fitPreview(92,96);
            _loc7_.x = -343 + _loc3_ * 109;
            _loc7_.y = _loc11_ < 3 ? 39 : 152;
            _loc7_.touchable = false;
            addChild(_loc7_);
            this.petClone_array.push(_loc7_);
            _loc11_++;
         }
         this.deselectAll();
         addEventListener(Event.ENTER_FRAME,this.onEnter);
      }
      
      public function deselectAll() : void
      {
         var _loc1_:Image = null;
         for each(_loc1_ in this.panel_array)
         {
            _loc1_.texture = PetMenu.petMenu_textureAtlas.getTexture("panel_00");
         }
         this.cost_txt.text = this.type_txt.text = this.stats_txt.text = this.desc_txt.text = "";
         this.buy_btn.visible = this.mode_btn.visible = false;
      }
      
      public function selectPet(param1:Image) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = int(this.panel_array.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(this.panel_array[_loc4_] == param1)
            {
               _loc2_ = this.typeText_array[_loc4_].text;
               break;
            }
            _loc4_++;
         }
         this.type_txt.text = _loc2_;
         this.cost_txt.text = "$" + CommonCalls.uintToCommaString(Stats.petStats[_loc2_].cost);
         this.desc_txt.text = Stats.petStats[_loc2_].desc;
         this.mode_btn.visible = this.buy_btn.visible = true;
         this.stats_txt.text = "Level: 1" + "\nHealth: " + Stats.petStats[_loc2_].health + " / " + Stats.petStats[_loc2_].health + "\nPower: " + Stats.petStats[_loc2_].power + "\nDexterity: " + Stats.petStats[_loc2_].dex + "\nDefense: " + Stats.petStats[_loc2_].defense;
         if(this.petClone != null)
         {
            this.petClone.removeFromParent(true);
         }
         this.petClone = new Pet(MainStarlingStage(root).gameMain,"",_loc2_);
         this.petClone.fitPreview(260,110);
         this.petClone.x = 46;
         this.petClone.y = 74;
         addChild(this.petClone);
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
         for each(_loc2_ in this.petClone_array)
         {
            _loc2_.nextFrame();
            if(_loc2_.currentLabel != "standing")
            {
               _loc2_.gotoAndPlayStanding();
            }
         }
      }
      
      public function get selectedType() : String
      {
         return this.type_txt.text;
      }
   }
}

