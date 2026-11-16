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
   
   public final class PetMenu extends StarlingGameMenu
   {
      
      public static var petMenu_textureAtlas:TextureAtlas;
      
      private const equip_btn:Button = new Button(petMenu_textureAtlas.getTexture("equip_00"));
      
      public const withdraw_btn:Button = new Button(petMenu_textureAtlas.getTexture("withdraw_00"));
      
      public const vend_btn:Button = new Button(petMenu_textureAtlas.getTexture("vend_00"));
      
      private const mode_btn:Button = new Button(petMenu_textureAtlas.getTexture("mode_00"));
      
      public const activate_btn:Button = new Button(petMenu_textureAtlas.getTexture("activate_00"));
      
      public const companion_btn:Button = new Button(petMenu_textureAtlas.getTexture("companion"));
      
      private const info_btn:Button = new Button(petMenu_textureAtlas.getTexture("info"));
      
      private const release_btn:Button = new Button(petMenu_textureAtlas.getTexture("release"));
      
      private var companion_image:Image;
      
      private var active_images:Vector.<Image> = new Vector.<Image>();
      
      private const name_txt:TextField = new TextField(213,29,"",AllTextFormats.petName_textFormat);
      
      private const type_txt:TextField = new TextField(188,23,"",AllTextFormats.petType_textFormat);
      
      private const stats_txt:TextField = new TextField(223,153,"",AllTextFormats.stats2_textFormat);
      
      private const orbLeftTotal_txt:TextField = new TextField(120,44,"",AllTextFormats.stats2_textFormat);
      
      private const orbRightTotal_txt:TextField = new TextField(120,44,"",AllTextFormats.stats2_textFormat);
      
      public const panel_array:Vector.<Image> = new Vector.<Image>();
      
      private const petText_array:Vector.<TextField> = new Vector.<TextField>();
      
      private const petLvlText_array:Vector.<TextField> = new Vector.<TextField>();
      
      private const petClone_array:Vector.<Pet> = new Vector.<Pet>();
      
      private const healthBar_array:Vector.<Image> = new Vector.<Image>();
      
      private const healthBG_array:Vector.<Image> = new Vector.<Image>();
      
      public var petClone:Pet;
      
      private var __currentVendor:PetVendor;
      
      private const loveBG_image:Image = new Image(petMenu_textureAtlas.getTexture("dark pixel"));
      
      private const healthBG_image:Image = new Image(petMenu_textureAtlas.getTexture("dark pixel"));
      
      private const xpBG_image:Image = new Image(petMenu_textureAtlas.getTexture("dark pixel"));
      
      private const loveBar_image:Image = new Image(petMenu_textureAtlas.getTexture("pink pixel"));
      
      private const healthBar_image:Image = new Image(petMenu_textureAtlas.getTexture("red pixel"));
      
      private const xpBar_image:Image = new Image(petMenu_textureAtlas.getTexture("yellow pixel"));
      
      private const fullBarLength:int = 96;
      
      public function PetMenu(param1:uint, param2:Person)
      {
         var _loc14_:Button = null;
         var _loc3_:int = 0;
         var _loc4_:Pet = null;
         var _loc5_:Image = null;
         var _loc6_:TextField = null;
         var _loc7_:TextField = null;
         var _loc8_:Pet = null;
         var _loc9_:Image = null;
         var _loc10_:Image = null;
         super();
         var _loc11_:int = int(param2.pet_array.length);
         var _loc12_:int = 0;
         while(_loc12_ < _loc11_)
         {
            if(param2.pet_array[_loc12_].isCompanion && _loc12_ > 0)
            {
               _loc4_ = param2.pet_array[0];
               param2.pet_array[0] = param2.pet_array[_loc12_];
               param2.pet_array[_loc12_] = _loc4_;
               break;
            }
            _loc12_++;
         }
         var _loc13_:Image = new Image(petMenu_textureAtlas.getTexture(param1 == 4 ? "small panel" : "big panel"));
         _loc13_.x = -384;
         _loc13_.y = -226;
         addChild(_loc13_);
         if(param2.pet_array[0].isCompanion)
         {
            this.companion_image = new Image(petMenu_textureAtlas.getTexture("companion icon"));
            this.companion_image.x = -299;
            this.companion_image.y = 44;
            this.companion_image.pivotX = 65;
            this.companion_image.pivotY = 76;
            this.companion_image.touchable = false;
            addChild(this.companion_image);
         }
         _loc14_ = new Button(petMenu_textureAtlas.getTexture("x_btn_00"),"",null,petMenu_textureAtlas.getTexture("x_btn_01"));
         _loc14_.x = 391;
         _loc14_.y = -213;
         _loc14_.pivotX = 30;
         _loc14_.pivotY = 19;
         _loc14_.name = "x_btn";
         addChild(_loc14_);
         this.equip_btn.x = 330;
         this.equip_btn.y = -172;
         this.equip_btn.pivotX = 33;
         this.equip_btn.pivotY = 15;
         this.equip_btn.name = "petEquip_btn";
         addChild(this.equip_btn);
         this.withdraw_btn.x = 279;
         this.withdraw_btn.y = -135;
         this.withdraw_btn.pivotX = 38;
         this.withdraw_btn.pivotY = 15;
         this.withdraw_btn.scaleWhenOver = 0.95;
         this.withdraw_btn.name = "petWithdraw_btn";
         addChild(this.withdraw_btn);
         this.vend_btn.x = 333;
         this.vend_btn.y = -135;
         this.vend_btn.pivotX = 36;
         this.vend_btn.pivotY = 16;
         this.vend_btn.name = "petVend_btn";
         addChild(this.vend_btn);
         this.mode_btn.x = 322;
         this.mode_btn.y = -98;
         this.mode_btn.pivotX = 49;
         this.mode_btn.pivotY = 15;
         this.mode_btn.name = "petMode_btn";
         addChild(this.mode_btn);
         this.activate_btn.x = 296;
         this.activate_btn.y = -61;
         this.activate_btn.pivotX = 73;
         this.activate_btn.pivotY = 15;
         this.activate_btn.scaleWhenOver = 0.95;
         this.activate_btn.name = "petActivate_btn";
         addChild(this.activate_btn);
         this.companion_btn.x = 140;
         this.companion_btn.y = -101;
         this.companion_btn.pivotX = 43;
         this.companion_btn.pivotY = 10;
         this.companion_btn.name = "petCompanion_btn";
         addChild(this.companion_btn);
         this.info_btn.x = 128;
         this.info_btn.y = -78;
         this.info_btn.pivotX = 21;
         this.info_btn.pivotY = 10;
         this.info_btn.name = "petMoreInfo_btn";
         addChild(this.info_btn);
         this.release_btn.x = 154;
         this.release_btn.y = -56;
         this.release_btn.pivotX = 32;
         this.release_btn.pivotY = 10;
         this.release_btn.scaleWhenOver = this.info_btn.scaleWhenOver = this.companion_btn.scaleWhenOver = this.mode_btn.scaleWhenOver = this.vend_btn.scaleWhenOver = this.equip_btn.scaleWhenOver = 0.95;
         this.release_btn.name = "petRelease_btn";
         addChild(this.release_btn);
         this.loveBG_image.y = -168;
         addChild(this.loveBG_image);
         this.healthBG_image.y = -148;
         addChild(this.healthBG_image);
         this.xpBG_image.y = -126;
         addChild(this.xpBG_image);
         this.xpBG_image.x = this.healthBG_image.x = this.loveBG_image.x = 54;
         this.xpBG_image.width = this.healthBG_image.width = this.loveBG_image.width = 102;
         this.xpBG_image.height = this.healthBG_image.height = this.loveBG_image.height = 21;
         this.xpBG_image.touchable = this.healthBG_image.touchable = this.loveBG_image.touchable = false;
         this.loveBar_image.y = -165;
         addChild(this.loveBar_image);
         this.healthBar_image.y = -145;
         addChild(this.healthBar_image);
         this.xpBar_image.y = -123;
         addChild(this.xpBar_image);
         this.xpBar_image.x = this.healthBar_image.x = this.loveBar_image.x = 57;
         this.xpBar_image.width = this.healthBar_image.width = this.loveBar_image.width = this.fullBarLength;
         this.xpBar_image.height = this.healthBar_image.height = this.loveBar_image.height = 15;
         this.xpBar_image.touchable = this.healthBar_image.touchable = this.loveBar_image.touchable = false;
         _loc12_ = 0;
         while(_loc12_ < param1)
         {
            _loc3_ = _loc12_ < 4 ? _loc12_ : int(_loc12_ - 4);
            _loc5_ = new Image(petMenu_textureAtlas.getTexture("panel_00"));
            _loc5_.x = -343 + _loc3_ * 141;
            _loc5_.y = _loc12_ < 4 ? -5 : 118;
            _loc5_.touchable = _loc5_.useHandCursor = _loc12_ < param2.pet_array.length ? true : false;
            addChild(_loc5_);
            this.panel_array.push(_loc5_);
            _loc12_++;
         }
         this.name_txt.x = -348;
         this.name_txt.y = -193;
         addChild(this.name_txt);
         this.type_txt.x = -336;
         this.type_txt.y = -56;
         addChild(this.type_txt);
         this.stats_txt.x = -111;
         this.stats_txt.y = -188;
         addChild(this.stats_txt);
         this.orbLeftTotal_txt.x = 183;
         addChild(this.orbLeftTotal_txt);
         this.orbRightTotal_txt.x = 263;
         this.orbRightTotal_txt.y = this.orbLeftTotal_txt.y = param1 == 4 ? 71 : 180;
         addChild(this.orbRightTotal_txt);
         this.stats_txt.batchable = this.name_txt.batchable = this.type_txt.batchable = this.orbRightTotal_txt.batchable = this.orbLeftTotal_txt.batchable = true;
         this.stats_txt.touchable = this.name_txt.touchable = this.type_txt.touchable = this.orbRightTotal_txt.touchable = this.orbLeftTotal_txt.touchable = false;
         _loc12_ = 0;
         while(_loc12_ < param1)
         {
            if(_loc12_ <= param2.pet_array.length - 1)
            {
               _loc3_ = _loc12_ < 4 ? _loc12_ : int(_loc12_ - 4);
               _loc6_ = new TextField(121,21,param2.pet_array[_loc12_].name,AllTextFormats.petLvl_textFormat);
               _loc6_.x = -361 + _loc3_ * 141;
               _loc6_.y = _loc12_ < 4 ? -12 : 110;
               addChild(_loc6_);
               this.petText_array.push(_loc6_);
               _loc7_ = new TextField(65,21,"Lvl: " + param2.pet_array[_loc12_].lvl,AllTextFormats.petLvl_textFormat);
               _loc7_.x = -331 + _loc3_ * 141;
               _loc7_.y = _loc12_ < 4 ? 79 : 202;
               _loc7_.touchable = _loc6_.touchable = false;
               _loc7_.batchable = _loc6_.batchable = true;
               addChild(_loc7_);
               this.petLvlText_array.push(_loc7_);
            }
            _loc12_++;
         }
         _loc12_ = 0;
         while(_loc12_ < param1)
         {
            if(_loc12_ <= param2.pet_array.length - 1)
            {
               _loc3_ = _loc12_ < 4 ? _loc12_ : int(_loc12_ - 4);
               _loc8_ = new Pet(MainStarlingStage(param2.root).gameMain,"",param2.pet_array[_loc12_].type);
               _loc8_.fitPreview(120,96);
               _loc8_.x = -306 + _loc3_ * 141;
               _loc8_.y = _loc12_ < 4 ? 54 : 177;
               _loc8_.helmet_string = param2.pet_array[_loc12_].helmet_string;
               _loc8_.shoes_string = param2.pet_array[_loc12_].shoes_string;
               _loc8_.totalHealth = param2.pet_array[_loc12_].totalHealth;
               _loc8_.health = param2.pet_array[_loc12_].health;
               _loc8_.touchable = false;
               addChild(_loc8_);
               this.petClone_array.push(_loc8_);
            }
            _loc12_++;
         }
         _loc12_ = 0;
         while(_loc12_ < param1)
         {
            if(_loc12_ <= param2.pet_array.length - 1)
            {
               _loc3_ = _loc12_ < 4 ? _loc12_ : int(_loc12_ - 4);
               _loc9_ = new Image(petMenu_textureAtlas.getTexture("small health BG"));
               _loc9_.x = -317 + _loc3_ * 141;
               _loc9_.y = _loc12_ < 4 ? 10 : 133;
               addChild(_loc9_);
               this.healthBG_array.push(_loc9_);
               _loc10_ = new Image(petMenu_textureAtlas.getTexture("small health bar"));
               _loc10_.x = _loc9_.x + 1;
               _loc10_.y = _loc9_.y + 1;
               _loc10_.scaleX = this.petClone_array[_loc12_].health / this.petClone_array[_loc12_].totalHealth;
               _loc10_.touchable = _loc9_.touchable = false;
               addChild(_loc10_);
               this.healthBar_array.push(_loc10_);
            }
            _loc12_++;
         }
         drag_image = new Image(Texture.fromBitmapData(new BitmapData(735,36,false,16711680)));
         drag_image.x = -377;
         drag_image.y = -226;
         drag_image.name = "drag_image";
         drag_image.alpha = 0;
         addChild(drag_image);
         addEventListener(Event.ENTER_FRAME,this.onEnter);
         this.deselectAll();
      }
      
      public function selectPet(param1:Image, param2:String = "") : void
      {
         var _loc3_:Pet = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Pet = null;
         var _loc7_:int = 0;
         for each(_loc3_ in MainStarlingStage(root).gameMain.player.pet_array)
         {
            if(_loc3_.isCompanion)
            {
               _loc7_++;
            }
         }
         _loc4_ = int(this.petClone_array.length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            this.healthBar_array[_loc5_].scaleX = this.petClone_array[_loc5_].health / this.petClone_array[_loc5_].totalHealth;
            _loc5_++;
         }
         _loc4_ = int(this.panel_array.length);
         _loc5_ = 0;
         if(param2 == "")
         {
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               if(this.panel_array[_loc5_] == param1)
               {
                  _loc6_ = Pet(CommonCalls.returnObject(MainStarlingStage(root).gameMain.player.pet_array,this.petText_array[_loc5_].text));
                  break;
               }
               _loc5_++;
            }
         }
         else
         {
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               if(this.petText_array[_loc5_].text == param2)
               {
                  _loc6_ = Pet(CommonCalls.returnObject(MainStarlingStage(root).gameMain.player.pet_array,this.petText_array[_loc5_].text));
                  break;
               }
               _loc5_++;
            }
         }
         if(this.petClone != null)
         {
            this.petClone.removeFromParent(true);
         }
         this.petClone = new Pet(MainStarlingStage(root).gameMain,"",_loc6_.type);
         this.petClone.fitPreview(220,130);
         this.petClone.x = -246;
         this.petClone.y = -101;
         addChild(this.petClone);
         this.name_txt.text = this.petText_array[_loc5_].text;
         this.type_txt.text = "type: " + _loc6_.type;
         this.vend_btn.visible = false;
         this.__currentVendor = null;
         this.petClone.type = _loc6_.type;
         this.petClone.helmet_string = _loc6_.helmet_string;
         this.petClone.shoes_string = _loc6_.shoes_string;
         this.loveBar_image.scaleX = _loc6_.love / 100 * this.fullBarLength;
         this.healthBar_image.scaleX = _loc6_.health / _loc6_.totalHealth * this.fullBarLength;
         this.xpBar_image.scaleX = (_loc6_.xp - CommonCalls.getTotalXPToReachLevel(_loc6_.lvl)) / (CommonCalls.getTotalXPToReachLevel(_loc6_.lvl + 1) - CommonCalls.getTotalXPToReachLevel(_loc6_.lvl)) * this.fullBarLength;
         this.loveBG_image.visible = this.healthBG_image.visible = this.xpBG_image.visible = this.loveBar_image.visible = this.healthBar_image.visible = this.xpBar_image.visible = true;
         this.equip_btn.visible = true;
         this.withdraw_btn.visible = _loc6_.isActive;
         this.release_btn.visible = Pet(_loc6_).isActive == false && Pet(_loc6_).isCompanion == false;
         this.mode_btn.visible = true;
         this.activate_btn.visible = !_loc6_.isActive && MainStarlingStage(root).gameMain.player.activePets.length < MainStarlingStage(root).gameMain.maxActivePets;
         this.info_btn.visible = true;
         this.companion_btn.visible = _loc7_ == 0;
         this.stats_txt.text = "Level: " + _loc6_.lvl + "\nLove: " + _loc6_.love + " / 100" + "\nHealth: " + _loc6_.health + " / " + _loc6_.totalHealth + "\nXP: " + (_loc6_.xp - CommonCalls.getTotalXPToReachLevel(_loc6_.lvl)) + " / " + (CommonCalls.getTotalXPToReachLevel(_loc6_.lvl + 1) - CommonCalls.getTotalXPToReachLevel(_loc6_.lvl)) + "\nPower: " + _loc6_.power + "\nDexterity: " + _loc6_.dex + "\nDefense: " + (_loc6_.defense + (Stats.petHelmetStats[_loc6_.helmet_string].defense + Stats.shoesStats[_loc6_.shoes_string].defense));
         if(MainStarlingStage(root).gameMain.c_mc.currentFrame == 98 && this.withdraw_btn.visible == false && Pet(_loc6_).isCompanion == false)
         {
            _loc4_ = int(MainStarlingStage(root).c_mc.numChildren);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               if(MainStarlingStage(root).c_mc.getChildAt(_loc5_) is PetVendor && Person.removeNamePrefix(PetVendor(MainStarlingStage(root).c_mc.getChildAt(_loc5_)).sellerName) == MainStarlingStage(root).gameMain.player.name)
               {
                  if(MainStarlingStage(root).gameMain.player.hitTester.hit_rect.intersects(MainStarlingStage(root).c_mc.getChildAt(_loc5_).getBounds(MainStarlingStage(root).c_mc)))
                  {
                     this.vend_btn.visible = true;
                     this.__currentVendor = PetVendor(MainStarlingStage(root).c_mc.getChildAt(_loc5_));
                     break;
                  }
               }
               _loc5_++;
            }
         }
      }
      
      public function updateMe() : void
      {
         var _loc1_:Pet = null;
         var _loc2_:int = 0;
         var _loc3_:Image = null;
         var _loc4_:Number = Number(NaN);
         var _loc5_:String = null;
         var _loc6_:Image = null;
         var _loc7_:int = 0;
         var _loc8_:Pet = null;
         var _loc9_:uint = 0;
         var _loc10_:int = 0;
         var _loc11_:Boolean = false;
         CommonCalls.emptyArray(this.active_images,true,true);
         for each(_loc1_ in MainStarlingStage(root).gameMain.player.pet_array)
         {
            _loc9_ = _loc10_ < 4 ? uint(_loc10_) : uint(_loc10_ - 4);
            if(_loc1_.isActive)
            {
               _loc3_ = new Image(petMenu_textureAtlas.getTexture("active icon"));
               _loc3_.x = -300 + _loc9_ * 141;
               _loc3_.y = _loc10_ < 4 ? 39 : 162;
               _loc3_.pivotX = 52;
               _loc3_.pivotY = 71;
               _loc3_.touchable = false;
               addChildAt(_loc3_,1);
               this.active_images.push(_loc3_);
               _loc11_ = true;
            }
            _loc10_++;
         }
         _loc2_ = int(this.petClone_array.length);
         _loc10_ = 0;
         while(_loc10_ < _loc2_)
         {
            this.petClone_array[_loc10_].helmet_string = MainStarlingStage(root).gameMain.player.pet_array[_loc10_].helmet_string;
            this.petClone_array[_loc10_].shoes_string = MainStarlingStage(root).gameMain.player.pet_array[_loc10_].shoes_string;
            this.petClone_array[_loc10_].health = MainStarlingStage(root).gameMain.player.pet_array[_loc10_].health;
            _loc10_++;
         }
         var _loc12_:int = numChildren;
         var _loc13_:* = int(_loc12_ - 1);
         while(_loc13_ >= 0)
         {
            if(getChildAt(_loc13_).name != null && getChildAt(_loc13_).name == "petOrb")
            {
               removeChildAt(_loc13_);
            }
            _loc13_--;
         }
         var _loc14_:Person = MainStarlingStage(root).gameMain.player;
         for each(_loc1_ in _loc14_.pet_array)
         {
            if(_loc1_.isActive == false && _loc1_.health > 0)
            {
               _loc4_ = 2 + _loc1_.lvl / 20;
               _loc4_ = _loc4_ < 10 ? _loc4_ : 10;
               _loc5_ = Stats.petStats[_loc1_.type].sColor + " orb" + (_loc14_.hasOrbFocus ? " stroke" : "");
               _loc6_ = new Image(Assets.items_textureAtlas.getTexture(_loc5_));
               _loc6_.name = "petOrb";
               _loc6_.width = _loc6_.height = _loc4_ * 2;
               _loc6_.width += _loc14_.hasOrbFocus ? 6 : 0;
               _loc6_.height += _loc14_.hasOrbFocus ? 6 : 0;
               _loc6_.x = 200 + Math.random() * 100;
               _loc6_.y = -10 + Math.random() * 60;
               addChild(_loc6_);
            }
         }
         if(_loc14_.hasOrbFocus == false)
         {
            this.orbLeftTotal_txt.text = "Power: +" + String(_loc14_.getAllOrbBonuses(PetOrb.petOrb_array)) + "\nMagic: +" + String(_loc14_.getAllOrbBonuses(PetOrb.petOrb_array));
            this.orbRightTotal_txt.text = "Range: +" + String(_loc14_.getAllOrbBonuses(PetOrb.petOrb_array)) + "\nArtillery: +" + String(_loc14_.getAllOrbBonuses(PetOrb.petOrb_array));
         }
         else
         {
            _loc7_ = 0;
            for each(_loc8_ in _loc14_.pet_array)
            {
               if(_loc8_.isActive == false && _loc8_.health > 0)
               {
                  _loc7_ += Math.ceil(_loc8_.getOrbBonus() * 4 * 0.7);
               }
            }
            switch(_loc14_.getClass())
            {
               case "warrior":
                  this.orbLeftTotal_txt.text = "Power: +";
                  break;
               case "archer":
                  this.orbLeftTotal_txt.text = "Range: +";
                  break;
               case "wizard":
                  this.orbLeftTotal_txt.text = "Magic: +";
                  break;
               case "cowboy":
                  this.orbLeftTotal_txt.text = "Artillery: +";
            }
            this.orbLeftTotal_txt.text += String(_loc7_);
            this.orbRightTotal_txt.text = "";
         }
      }
      
      public function deselectAll() : void
      {
         var _loc1_:Image = null;
         this.vend_btn.visible = this.equip_btn.visible = this.release_btn.visible = this.mode_btn.visible = this.activate_btn.visible = false;
         this.info_btn.visible = this.companion_btn.visible = this.withdraw_btn.visible = false;
         this.loveBG_image.visible = this.healthBG_image.visible = this.xpBG_image.visible = this.loveBar_image.visible = this.healthBar_image.visible = this.xpBar_image.visible = false;
         this.name_txt.text = this.type_txt.text = this.stats_txt.text = "";
         if(this.petClone != null)
         {
            this.petClone.removeFromParent(true);
         }
         for each(_loc1_ in this.panel_array)
         {
            _loc1_.texture = petMenu_textureAtlas.getTexture("panel_00");
         }
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
      
      public function get selectedPetName() : String
      {
         return this.name_txt.text;
      }
      
      public function get currentVendor() : PetVendor
      {
         return this.__currentVendor;
      }
   }
}

