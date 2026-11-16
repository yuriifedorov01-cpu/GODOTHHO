package com.menus
{
   import com.game_objects.*;
   import com.sound.*;
   import com.stats.*;
   import com.ui.*;
   import com.utilities.*;
   import flash.display.*;
   import starling.*;
   import starling.display.*;
   import starling.events.*;
   import starling.text.*;
   import starling.textures.*;
   
   public final class PetModeMenu extends StarlingGameMenu
   {
      
      public static var petModeMenu_textureAtlas:TextureAtlas;
      
      private var __isPreview:Boolean = false;
      
      private var __selectedPet:String;
      
      private const enable_btn:Button = new Button(petModeMenu_textureAtlas.getTexture("enable_00"));
      
      private const name_txt:TextField = new TextField(257,23,"",AllTextFormats.name2_textFormat);
      
      private const desc_txt:TextField = new TextField(335,100,"",AllTextFormats.desc3_textFormat);
      
      private const panel_array:Vector.<Image> = new Vector.<Image>();
      
      private const modeText_array:Vector.<TextField> = new Vector.<TextField>();
      
      private const xpPanel_array:Vector.<Image> = new Vector.<Image>();
      
      private const xpText_array:Vector.<TextField> = new Vector.<TextField>();
      
      private var petClone:Pet;
      
      public function PetModeMenu(param1:String, param2:String, param3:Person, param4:Boolean)
      {
         var _loc15_:Image = null;
         var _loc5_:int = 0;
         var _loc6_:Texture = null;
         var _loc7_:Image = null;
         var _loc8_:Texture = null;
         var _loc9_:Boolean = false;
         var _loc10_:Pet = null;
         var _loc11_:Image = null;
         var _loc12_:TextField = null;
         var _loc13_:TextField = null;
         var _loc14_:TextField = null;
         super();
         this.__selectedPet = param2;
         this.__isPreview = param2 == "";
         _loc15_ = new Image(petModeMenu_textureAtlas.getTexture("panel"));
         _loc15_.x = -365;
         _loc15_.y = -110;
         addChild(_loc15_);
         this.enable_btn.x = 269;
         this.enable_btn.y = 127;
         this.enable_btn.pivotX = 26;
         this.enable_btn.pivotY = 15;
         this.enable_btn.visible = false;
         this.enable_btn.scaleWhenOver = 0.95;
         this.enable_btn.name = "modeEnable_btn";
         addChild(this.enable_btn);
         _loc5_ = 0;
         while(_loc5_ < 4)
         {
            _loc6_ = petModeMenu_textureAtlas.getTexture("mode_00");
            if(this.__isPreview == false && CommonCalls.returnObject(param3.pet_array,param2).mode == Stats.petStats[param1].modes[_loc5_])
            {
               _loc6_ = petModeMenu_textureAtlas.getTexture("mode_02");
            }
            _loc7_ = new Image(_loc6_);
            _loc7_.x = -350;
            _loc7_.y = -69 + _loc5_ * 34;
            _loc7_.useHandCursor = true;
            addChild(_loc7_);
            this.panel_array.push(_loc7_);
            _loc5_++;
         }
         if(this.__isPreview == false)
         {
            _loc5_ = 0;
            while(_loc5_ < 5)
            {
               _loc8_ = petModeMenu_textureAtlas.getTexture("xp_00");
               _loc9_ = true;
               if(MainStarlingStage(param3.root).gameMain.hasXPSplit == false && (_loc5_ == 0 || _loc5_ == 4))
               {
                  _loc8_ = petModeMenu_textureAtlas.getTexture("xp_02");
                  _loc9_ = false;
               }
               _loc10_ = Pet(CommonCalls.returnObject(param3.pet_array,param2));
               if(_loc10_.xpSplit == 0.1 && _loc5_ == 0 || _loc10_.xpSplit == 0.25 && _loc5_ == 1 || _loc10_.xpSplit == 0.4 && _loc5_ == 2 || _loc10_.xpSplit == 0.55 && _loc5_ == 3 || _loc10_.xpSplit == 0.7 && _loc5_ == 4)
               {
                  _loc8_ = petModeMenu_textureAtlas.getTexture("xp_01");
               }
               _loc11_ = new Image(_loc8_);
               _loc11_.x = -361 + _loc5_ * 71;
               _loc11_.y = 78;
               _loc11_.useHandCursor = _loc11_.touchable = _loc9_;
               addChild(_loc11_);
               this.xpPanel_array.push(_loc11_);
               _loc5_++;
            }
         }
         var _loc16_:Button = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_00"),"",null,ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_01"));
         _loc16_.x = 381;
         _loc16_.y = -96;
         _loc16_.pivotX = 30;
         _loc16_.pivotY = 19;
         _loc16_.name = "x_btn";
         addChild(_loc16_);
         this.name_txt.x = 22;
         this.name_txt.y = -50;
         addChild(this.name_txt);
         if(this.__isPreview == false)
         {
            _loc12_ = new TextField(236,23,"Percentage of XP given to pet",AllTextFormats.percent_textFormat);
            _loc12_.x = -297;
            _loc12_.y = 68;
            _loc12_.batchable = true;
            _loc12_.touchable = false;
            addChild(_loc12_);
         }
         _loc5_ = 0;
         while(_loc5_ < 4)
         {
            _loc13_ = new TextField(342,23,Stats.petModes[Stats.petStats[param1].modes[_loc5_]].dname,AllTextFormats.memberName_textFormat);
            _loc13_.x = -342;
            _loc13_.y = -66 + _loc5_ * 34;
            _loc13_.batchable = true;
            _loc13_.touchable = false;
            addChild(_loc13_);
            this.modeText_array.push(_loc13_);
            _loc5_++;
         }
         if(this.__isPreview == false)
         {
            _loc5_ = 0;
            while(_loc5_ < 5)
            {
               _loc14_ = new TextField(70,38,10 + _loc5_ * 15 + "%",AllTextFormats.xpSplit_textFormat);
               _loc14_.x = -352 + _loc5_ * 71;
               _loc14_.y = 93;
               _loc14_.batchable = true;
               _loc14_.touchable = false;
               addChild(_loc14_);
               this.xpText_array.push(_loc14_);
               _loc5_++;
            }
         }
         this.desc_txt.x = 24;
         this.desc_txt.y = 2;
         addChild(this.desc_txt);
         this.name_txt.batchable = true;
         this.name_txt.touchable = this.desc_txt.touchable = false;
         this.petClone = new Pet(MainStarlingStage(param3.root).gameMain,"",param1);
         this.petClone.fitPreview(240,140);
         this.petClone.x = 322;
         this.petClone.y = -37;
         this.petClone.scaleX = -1;
         this.petClone.touchable = false;
         if(param2 != "")
         {
            this.petClone.helmet_string = Pet(CommonCalls.returnObject(param3.pet_array,param2)).helmet_string;
            this.petClone.shoes_string = Pet(CommonCalls.returnObject(param3.pet_array,param2)).shoes_string;
         }
         addChild(this.petClone);
         drag_image = new Image(Texture.fromBitmapData(new BitmapData(462,36,false,16711680)));
         drag_image.x = -360;
         drag_image.y = -110;
         drag_image.name = "drag_image";
         drag_image.alpha = 0;
         addChild(drag_image);
         addEventListener(Event.ENTER_FRAME,this.onEnter);
      }
      
      public function updateMe(param1:String, param2:Person, param3:Boolean) : void
      {
      }
      
      public function selectMode(param1:Image) : void
      {
         var _loc2_:Image = null;
         var _loc3_:int = 0;
         while(_loc3_ < 4)
         {
            if(this.panel_array[_loc3_] == param1)
            {
               break;
            }
            _loc3_++;
         }
         for each(_loc2_ in this.panel_array)
         {
            if(_loc2_.texture != petModeMenu_textureAtlas.getTexture("mode_02"))
            {
               _loc2_.texture = petModeMenu_textureAtlas.getTexture("mode_00");
            }
         }
         if(param1.texture != PetModeMenu.petModeMenu_textureAtlas.getTexture("mode_02"))
         {
            param1.texture = PetModeMenu.petModeMenu_textureAtlas.getTexture("mode_01");
         }
         this.name_txt.text = this.modeText_array[_loc3_].text;
         this.desc_txt.text = Stats.petModes[Stats.returnModeAbrv(this.name_txt.text)].desc;
         this.enable_btn.visible = !this.isPreview;
         this.enable_btn.visible = this.isPreview == false && param1.texture != petModeMenu_textureAtlas.getTexture("mode_02");
      }
      
      public function selectXP(param1:Image) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            if(this.xpPanel_array[_loc2_] == param1)
            {
               break;
            }
            _loc2_++;
         }
         var _loc3_:Person = MainStarlingStage(root).gameMain.player;
         MainStarlingStage(root).gameMain.theConnection.send("xpSplitCh",this.selectedPet,10 + _loc2_ * 15);
         Pet(CommonCalls.returnObject(_loc3_.pet_array,this.selectedPet)).xpSplit = (10 + _loc2_ * 15) / 100;
         this.updateMe(this.selectedPet,_loc3_,MainStarlingStage(root).gameMain.hasXPSplit);
         SoundManager.playSound(SoundLibrary.itemBought_sound);
         if(this.isPreview == false)
         {
            this.xpPanel_array[0].texture = MainStarlingStage(root).gameMain.hasXPSplit ? (Pet(CommonCalls.returnObject(_loc3_.pet_array,this.selectedPet)).xpSplit != 0.1 ? petModeMenu_textureAtlas.getTexture("xp_00") : petModeMenu_textureAtlas.getTexture("xp_01")) : petModeMenu_textureAtlas.getTexture("xp_02");
            this.xpPanel_array[1].texture = Pet(CommonCalls.returnObject(_loc3_.pet_array,this.selectedPet)).xpSplit != 0.25 ? petModeMenu_textureAtlas.getTexture("xp_00") : petModeMenu_textureAtlas.getTexture("xp_01");
            this.xpPanel_array[2].texture = Pet(CommonCalls.returnObject(_loc3_.pet_array,this.selectedPet)).xpSplit != 0.4 ? petModeMenu_textureAtlas.getTexture("xp_00") : petModeMenu_textureAtlas.getTexture("xp_01");
            this.xpPanel_array[3].texture = Pet(CommonCalls.returnObject(_loc3_.pet_array,this.selectedPet)).xpSplit != 0.55 ? petModeMenu_textureAtlas.getTexture("xp_00") : petModeMenu_textureAtlas.getTexture("xp_01");
            this.xpPanel_array[4].texture = MainStarlingStage(root).gameMain.hasXPSplit ? (Pet(CommonCalls.returnObject(_loc3_.pet_array,this.selectedPet)).xpSplit != 0.7 ? petModeMenu_textureAtlas.getTexture("xp_00") : petModeMenu_textureAtlas.getTexture("xp_01")) : petModeMenu_textureAtlas.getTexture("xp_02");
         }
      }
      
      public function enableMode() : void
      {
         if(this.name_txt.text == "Mount mode" && MainStarlingStage(root).gameMain.player.ridingPet != null)
         {
            MainStarlingStage(root).gameMain.createAlert("Another pet is already being ridden.");
            return;
         }
         this.enable_btn.visible = false;
         var _loc1_:int = 0;
         while(_loc1_ < this.panel_array.length)
         {
            this.panel_array[_loc1_].texture = petModeMenu_textureAtlas.getTexture("mode_00");
            if(this.modeText_array[_loc1_].text == this.name_txt.text)
            {
               this.panel_array[_loc1_].texture = petModeMenu_textureAtlas.getTexture("mode_02");
            }
            _loc1_++;
         }
         MainStarlingStage(root).gameMain.theConnection.send("modeEnable",this.selectedPet,Stats.returnModeAbrv(this.name_txt.text));
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
      
      public function get selectedPet() : String
      {
         return this.__selectedPet;
      }
      
      public function get isPreview() : Boolean
      {
         return this.__isPreview;
      }
   }
}

