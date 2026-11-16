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
   
   public final class CharacterMenu extends StarlingGameMenu
   {
      
      public static var charMenu_textureAtlas:TextureAtlas;
      
      private var thePerson:Person;
      
      private var personClone:Person;
      
      private var petClone:Pet;
      
      private var __personName:String;
      
      public const skills_btn:Button = new Button(charMenu_textureAtlas.getTexture("skills_btn"));
      
      private const hpMore_btn:Button = new Button(charMenu_textureAtlas.getTexture("more_btn_00"),"",null,charMenu_textureAtlas.getTexture("more_btn_01"));
      
      private const mpMore_btn:Button = new Button(this.hpMore_btn.upState,"",null,this.hpMore_btn.overState);
      
      private const dexMore_btn:Button = new Button(this.hpMore_btn.upState,"",null,this.hpMore_btn.overState);
      
      private const powerMore_btn:Button = new Button(this.hpMore_btn.upState,"",null,this.hpMore_btn.overState);
      
      private const rangeMore_btn:Button = new Button(this.hpMore_btn.upState,"",null,this.hpMore_btn.overState);
      
      private const magicMore_btn:Button = new Button(this.hpMore_btn.upState,"",null,this.hpMore_btn.overState);
      
      private const artilleryMore_btn:Button = new Button(this.hpMore_btn.upState,"",null,this.hpMore_btn.overState);
      
      private const defenseMore_btn:Button = new Button(this.hpMore_btn.upState,"",null,this.hpMore_btn.overState);
      
      public const add_btn:Button = new Button(charMenu_textureAtlas.getTexture("addFriend_btn"));
      
      private const aPoints_txt:TextField = new TextField(85,54,"0",new TextFormat(Assets.stats_font.name,42,16777215));
      
      private const hp_txt:TextField = new TextField(192,25,"HP",new TextFormat(Assets.stats_font.name,18,16777215,"left","top"));
      
      private const mp_txt:TextField = new TextField(192,25,"MP",this.hp_txt.format);
      
      private const dex_txt:TextField = new TextField(192,25,"Dexterity",this.hp_txt.format);
      
      private const power_txt:TextField = new TextField(192,25,"Power",this.hp_txt.format);
      
      private const range_txt:TextField = new TextField(192,25,"Range",this.hp_txt.format);
      
      private const magic_txt:TextField = new TextField(192,25,"Magic",this.hp_txt.format);
      
      private const artillery_txt:TextField = new TextField(192,25,"Artillery",this.hp_txt.format);
      
      private const defense_txt:TextField = new TextField(192,25,"Defense",this.hp_txt.format);
      
      private const damageSpan_txt:TextField = new TextField(209,26,"0 - 0",AllTextFormats.qualityOff_textFormat);
      
      private const defenseSpan_txt:TextField = new TextField(209,26,"0 - 0",this.damageSpan_txt.format);
      
      private var skills_txt:TextField;
      
      private const critical_txt:TextField = new TextField(142,23,"critical",AllTextFormats.xp_textFormat);
      
      private const speed_txt:TextField = new TextField(142,23,"speed",AllTextFormats.xp_textFormat);
      
      public function CharacterMenu(param1:Person)
      {
         var _loc2_:Image = null;
         var _loc3_:Image = null;
         var _loc4_:Image = null;
         var _loc5_:Image = null;
         var _loc6_:Button = null;
         var _loc7_:Button = null;
         var _loc8_:Button = null;
         var _loc9_:Button = null;
         var _loc10_:Button = null;
         var _loc11_:Button = null;
         var _loc12_:Button = null;
         var _loc13_:Button = null;
         var _loc14_:TextField = null;
         var _loc15_:TextField = null;
         var _loc16_:TextField = null;
         var _loc17_:TextField = null;
         var _loc18_:String = null;
         var _loc19_:TextField = null;
         var _loc20_:String = null;
         var _loc21_:TextField = null;
         var _loc22_:Image = null;
         var _loc23_:TextField = null;
         var _loc24_:TextField = null;
         var _loc25_:TextField = null;
         var _loc26_:TextField = null;
         var _loc27_:TextField = null;
         var _loc28_:TextField = null;
         var _loc29_:int = 0;
         var _loc30_:TextField = null;
         var _loc31_:Image = null;
         super();
         pivotX = 100;
         pivotY = 80;
         this.thePerson = param1;
         this.__personName = param1.name;
         var _loc32_:Image = new Image(charMenu_textureAtlas.getTexture("character menu"));
         _loc32_.x = -371;
         _loc32_.y = -202;
         addChild(_loc32_);
         if(this.thePerson.isPlayer)
         {
            _loc2_ = new Image(charMenu_textureAtlas.getTexture("dark pixel"));
            _loc2_.y = 48;
            addChild(_loc2_);
            _loc3_ = new Image(charMenu_textureAtlas.getTexture("dark pixel"));
            _loc3_.x = _loc2_.x = 18;
            _loc3_.y = 102;
            _loc3_.width = _loc2_.width = 192;
            _loc3_.height = _loc2_.height = 28;
            addChild(_loc3_);
            _loc4_ = new Image(charMenu_textureAtlas.getTexture("greenish pixel"));
            _loc4_.y = 51;
            _loc4_.width = (this.thePerson.fishXP - CommonCalls.getTotalXPToReachLevel(this.thePerson.fishingLvl)) / (CommonCalls.getTotalXPToReachLevel(this.thePerson.fishingLvl + 1) - CommonCalls.getTotalXPToReachLevel(this.thePerson.fishingLvl)) * 184;
            addChild(_loc4_);
            _loc5_ = new Image(charMenu_textureAtlas.getTexture("greenish pixel"));
            _loc5_.x = _loc4_.x = 22;
            _loc5_.y = 105;
            _loc5_.width = (this.thePerson.chopXP - CommonCalls.getTotalXPToReachLevel(this.thePerson.choppingLvl)) / (CommonCalls.getTotalXPToReachLevel(this.thePerson.choppingLvl + 1) - CommonCalls.getTotalXPToReachLevel(this.thePerson.choppingLvl)) * 184;
            _loc5_.height = _loc4_.height = 22;
            _loc5_.touchable = _loc4_.touchable = _loc3_.touchable = _loc2_.touchable = false;
            addChild(_loc5_);
         }
         var _loc33_:Button = new Button(charMenu_textureAtlas.getTexture("close button_00"),"",null,charMenu_textureAtlas.getTexture("close button_01"));
         _loc33_.name = "x_btn";
         _loc33_.x = 229;
         _loc33_.y = -191;
         _loc33_.pivotX = 30;
         _loc33_.pivotY = 19;
         addChild(_loc33_);
         if(this.thePerson.isPlayer == false)
         {
            if(FriendMenu.friends_array.length < MainStarlingStage(this.thePerson.root).gameMain.maxFriends && FriendMenu.friends_array.indexOf(this.thePerson.name) == -1)
            {
               this.add_btn.name = "addFriend_btn";
               this.add_btn.x = -323;
               this.add_btn.y = 36;
               this.add_btn.pivotX = 28;
               this.add_btn.pivotY = 13;
               this.add_btn.scaleWhenOver = 0.95;
               addChild(this.add_btn);
            }
            _loc6_ = new Button(charMenu_textureAtlas.getTexture("givePresent_btn"));
            _loc6_.name = "givePresent_btn";
            _loc6_.x = -241;
            _loc6_.y = 95;
            _loc6_.pivotX = 113;
            _loc6_.pivotY = 19;
            _loc6_.scaleWhenOver = 0.95;
            addChild(_loc6_);
            _loc7_ = new Button(charMenu_textureAtlas.getTexture("trade_btn"));
            _loc7_.name = "trade_btn";
            _loc7_.x = -316;
            _loc7_.y = 66;
            _loc7_.pivotX = 36;
            _loc7_.pivotY = 13;
            addChild(_loc7_);
            _loc8_ = new Button(charMenu_textureAtlas.getTexture("report_btn"));
            _loc8_.name = "report_btn";
            _loc8_.x = 185;
            _loc8_.y = 118;
            _loc8_.pivotX = 52;
            _loc8_.pivotY = 14;
            _loc8_.scaleWhenOver = 0.95;
            addChild(_loc8_);
         }
         else
         {
            if(this.thePerson.lev > 3)
            {
               _loc9_ = new Button(charMenu_textureAtlas.getTexture("ranks_btn"));
               _loc9_.name = "ranks_btn";
               _loc9_.x = -290;
               _loc9_.y = 124;
               _loc9_.pivotX = 69;
               _loc9_.pivotY = 14;
               _loc9_.scaleWhenOver = 0.95;
               addChild(_loc9_);
               _loc10_ = new Button(charMenu_textureAtlas.getTexture("energy_btn"));
               _loc10_.x = -304;
               _loc10_.y = 94;
               _loc10_.pivotX = 49;
               _loc10_.pivotY = 28;
               _loc10_.scaleWhenOver = 0.95;
               _loc10_.name = "energy_btn";
               addChild(_loc10_);
            }
            this.skills_btn.x = -309;
            this.skills_btn.y = 166;
            this.skills_btn.pivotX = 42;
            this.skills_btn.pivotY = 15;
            this.skills_btn.scaleWhenOver = 0.95;
            this.skills_btn.name = "skills_btn";
            addChild(this.skills_btn);
         }
         this.hpMore_btn.name = "hpMore_btn";
         this.hpMore_btn.y = -113;
         addChild(this.hpMore_btn);
         this.mpMore_btn.name = "mpMore_btn";
         this.mpMore_btn.y = -80;
         addChild(this.mpMore_btn);
         this.dexMore_btn.name = "dexMore_btn";
         this.dexMore_btn.y = -46;
         addChild(this.dexMore_btn);
         this.powerMore_btn.name = "powerMore_btn";
         this.powerMore_btn.y = -11;
         addChild(this.powerMore_btn);
         this.rangeMore_btn.name = "rangeMore_btn";
         this.rangeMore_btn.y = 23;
         addChild(this.rangeMore_btn);
         this.magicMore_btn.name = "magicMore_btn";
         this.magicMore_btn.y = 56;
         addChild(this.magicMore_btn);
         this.artilleryMore_btn.name = "artilleryMore_btn";
         this.artilleryMore_btn.y = 90;
         addChild(this.artilleryMore_btn);
         this.defenseMore_btn.name = "defenseMore_btn";
         this.defenseMore_btn.y = 123;
         addChild(this.defenseMore_btn);
         this.hpMore_btn.pivotX = this.mpMore_btn.pivotX = this.dexMore_btn.pivotX = this.powerMore_btn.pivotX = this.rangeMore_btn.pivotX = this.magicMore_btn.pivotX = this.artilleryMore_btn.pivotX = this.defenseMore_btn.pivotX = 9;
         this.hpMore_btn.pivotY = this.mpMore_btn.pivotY = this.dexMore_btn.pivotY = this.powerMore_btn.pivotY = this.rangeMore_btn.pivotY = this.magicMore_btn.pivotY = this.artilleryMore_btn.pivotY = this.defenseMore_btn.pivotY = 9;
         this.hpMore_btn.x = this.mpMore_btn.x = this.dexMore_btn.x = this.powerMore_btn.x = this.rangeMore_btn.x = this.magicMore_btn.x = this.artilleryMore_btn.x = this.defenseMore_btn.x = -22;
         if(this.thePerson.isPlayer)
         {
            _loc11_ = new Button(charMenu_textureAtlas.getTexture("info_btn"));
            _loc11_.name = "criticalInfo_btn";
            _loc11_.x = 152;
            _loc11_.y = -44;
            addChild(_loc11_);
            _loc12_ = new Button(_loc11_.upState);
            _loc12_.y = 37;
            _loc12_.name = "fishingInfo_btn";
            addChild(_loc12_);
            _loc13_ = new Button(_loc11_.upState);
            _loc13_.x = _loc12_.x = 177;
            _loc13_.y = 90;
            _loc13_.pivotX = _loc13_.pivotY = _loc12_.pivotX = _loc12_.pivotY = _loc11_.pivotX = _loc11_.pivotY = 9;
            _loc13_.name = "choppingInfo_btn";
            addChild(_loc13_);
         }
         var _loc34_:TextField = new TextField(180,25,this.thePerson.name,new TextFormat(Assets.stats_font.name,18,16777215));
         _loc34_.x = -359;
         _loc34_.y = -168;
         addChild(_loc34_);
         if(this.thePerson.isPlayer)
         {
            _loc14_ = new TextField(143,25,"Ability Points:",_loc34_.format);
            _loc14_.x = -347;
            _loc14_.y = 31;
            _loc14_.touchable = false;
            _loc14_.batchable = true;
            addChild(_loc14_);
            this.aPoints_txt.x = -306;
            this.aPoints_txt.y = 48;
            this.aPoints_txt.touchable = false;
            this.aPoints_txt.batchable = true;
            addChild(this.aPoints_txt);
         }
         var _loc35_:TextField = new TextField(248,34,this.thePerson.name.toUpperCase() + " INFO",AllTextFormats.title_textFormat);
         _loc35_.x = -173;
         _loc35_.y = -203;
         addChild(_loc35_);
         this.hp_txt.y = -122;
         this.hp_txt.autoSize = TextFieldAutoSize.HORIZONTAL;
         addChild(this.hp_txt);
         this.mp_txt.y = -89;
         addChild(this.mp_txt);
         this.dex_txt.y = -55;
         addChild(this.dex_txt);
         this.power_txt.y = -20;
         addChild(this.power_txt);
         this.range_txt.y = 13;
         addChild(this.range_txt);
         this.magic_txt.y = 47;
         addChild(this.magic_txt);
         this.artillery_txt.y = 81;
         addChild(this.artillery_txt);
         this.defense_txt.y = 116;
         addChild(this.defense_txt);
         this.damageSpan_txt.y = -149;
         addChild(this.damageSpan_txt);
         this.defenseSpan_txt.x = this.damageSpan_txt.x = 5;
         this.defenseSpan_txt.y = -101;
         addChild(this.defenseSpan_txt);
         if(this.thePerson.guild != "")
         {
            _loc15_ = new TextField(174,20,this.thePerson.guild,AllTextFormats.ticketsTitle_textFormat);
            _loc15_.x = -361;
            _loc15_.y = 5;
            _loc15_.touchable = false;
            _loc15_.batchable = true;
            addChild(_loc15_);
         }
         if(this.thePerson.isPlayer)
         {
            this.skills_txt = new TextField(184,25,"skill points",AllTextFormats.ability_textFormat);
            this.skills_txt.x = -265;
            this.skills_txt.y = 156;
            this.skills_txt.touchable = false;
            this.skills_txt.batchable = true;
            addChild(this.skills_txt);
         }
         if(this.thePerson.isPlayer)
         {
            _loc16_ = new TextField(106,21,"Fishing lvl: " + this.thePerson.fishingLvl,AllTextFormats.xp_textFormat);
            _loc16_.y = 30;
            addChild(_loc16_);
            _loc17_ = new TextField(140,21,"Chopping lvl: " + this.thePerson.choppingLvl,_loc16_.format);
            _loc17_.x = _loc16_.x = 18;
            _loc17_.y = 84;
            _loc17_.touchable = _loc16_.touchable = false;
            _loc17_.batchable = _loc16_.batchable = true;
            addChild(_loc17_);
            _loc18_ = this.thePerson.fishXP - CommonCalls.getTotalXPToReachLevel(this.thePerson.fishingLvl) + " / " + (CommonCalls.getTotalXPToReachLevel(this.thePerson.fishingLvl + 1) - CommonCalls.getTotalXPToReachLevel(this.thePerson.fishingLvl));
            _loc19_ = new TextField(180,23,_loc18_,AllTextFormats.petName_textFormat);
            _loc19_.y = 50;
            addChild(_loc19_);
            _loc20_ = this.thePerson.chopXP - CommonCalls.getTotalXPToReachLevel(this.thePerson.choppingLvl) + " / " + (CommonCalls.getTotalXPToReachLevel(this.thePerson.choppingLvl + 1) - CommonCalls.getTotalXPToReachLevel(this.thePerson.choppingLvl));
            _loc21_ = new TextField(180,23,_loc20_,_loc19_.format);
            _loc21_.x = _loc19_.x = 23;
            _loc21_.y = 104;
            _loc21_.touchable = _loc19_.touchable = false;
            _loc21_.batchable = _loc19_.batchable = true;
            addChild(_loc21_);
         }
         var _loc36_:Pet = param1.activePets.length > 0 ? param1.activePets[0] : null;
         if(_loc36_ != null)
         {
            _loc22_ = new Image(charMenu_textureAtlas.getTexture("pet panel"));
            _loc22_.touchable = false;
            _loc22_.x = -480;
            _loc22_.y = -8;
            _loc22_.pivotX = 110;
            _loc22_.pivotY = 142;
            addChildAt(_loc22_,0);
            _loc23_ = new TextField(183,23,_loc36_.name,AllTextFormats.petName_textFormat);
            _loc23_.x = -572;
            _loc23_.y = -138;
            addChild(_loc23_);
            _loc24_ = new TextField(175,18,"type: " + _loc36_.type,AllTextFormats.petType_textFormat);
            _loc24_.y = -26;
            addChild(_loc24_);
            _loc25_ = new TextField(176,21,"Level: " + _loc36_.lvl,AllTextFormats.xp_textFormat);
            _loc25_.y = -6;
            addChild(_loc25_);
            _loc26_ = new TextField(176,21,"HP: " + _loc36_.health + "/" + _loc36_.totalHealth,AllTextFormats.xp_textFormat);
            _loc26_.y = 20;
            addChild(_loc26_);
            _loc27_ = new TextField(176,21,"Power: " + _loc36_.power,AllTextFormats.xp_textFormat);
            _loc27_.y = 47;
            addChild(_loc27_);
            _loc28_ = new TextField(176,21,"Dexterity: " + _loc36_.dex,AllTextFormats.xp_textFormat);
            _loc28_.y = 73;
            addChild(_loc28_);
            _loc29_ = _loc36_.defense + ItemStat(Stats.petHelmetStats[_loc36_.helmet_string]).defense + ItemStat(Stats.shoesStats[_loc36_.shoes_string]).defense;
            _loc30_ = new TextField(176,21,"Defense: " + _loc29_,AllTextFormats.xp_textFormat);
            _loc30_.y = 100;
            addChild(_loc30_);
            _loc23_.touchable = _loc25_.touchable = _loc26_.touchable = _loc27_.touchable = _loc28_.touchable = _loc30_.touchable = false;
            _loc24_.x = _loc25_.x = _loc26_.x = _loc27_.x = _loc28_.x = _loc30_.x = -567;
            _loc23_.batchable = _loc24_.batchable = _loc25_.batchable = _loc26_.batchable = _loc27_.batchable = _loc28_.batchable = _loc30_.batchable = true;
         }
         _loc35_.touchable = _loc34_.touchable = this.hp_txt.touchable = this.mp_txt.touchable = this.dex_txt.touchable = this.power_txt.touchable = this.range_txt.touchable = this.magic_txt.touchable = this.artillery_txt.touchable = this.defense_txt.touchable = this.damageSpan_txt.touchable = this.defenseSpan_txt.touchable = false;
         this.hp_txt.x = this.mp_txt.x = this.dex_txt.x = this.power_txt.x = this.range_txt.x = this.magic_txt.x = this.artillery_txt.x = this.defense_txt.x = -181;
         _loc35_.batchable = _loc34_.batchable = this.hp_txt.batchable = this.mp_txt.batchable = this.dex_txt.batchable = this.power_txt.batchable = this.range_txt.batchable = this.magic_txt.batchable = this.artillery_txt.batchable = this.defense_txt.batchable = this.damageSpan_txt.batchable = this.defenseSpan_txt.batchable = true;
         this.critical_txt.y = -54;
         addChild(this.critical_txt);
         this.speed_txt.y = -26;
         addChild(this.speed_txt);
         var _loc37_:TextField = new TextField(133,33,"Level: " + this.thePerson.lev,AllTextFormats.level_textFormat);
         _loc37_.x = this.hp_txt.x;
         _loc37_.y = -163;
         addChild(_loc37_);
         _loc37_.touchable = this.critical_txt.touchable = this.speed_txt.touchable = false;
         this.critical_txt.x = this.speed_txt.x = 18;
         _loc37_.batchable = this.critical_txt.batchable = this.speed_txt.batchable = true;
         if(this.thePerson.isPlayer)
         {
            _loc31_ = new Image(CharacterMenu.charMenu_textureAtlas.getTexture("skills panel"));
            _loc31_.pivotX = 207;
            _loc31_.pivotY = 25;
            _loc31_.touchable = false;
            _loc31_.x = -156;
            _loc31_.y = 167;
            addChildAt(_loc31_,0);
         }
         this.personClone = new Person(MainStarlingStage(this.thePerson.root).gameMain,false,"");
         this.personClone.x = -282;
         this.personClone.y = -35;
         this.personClone.touchable = false;
         addChild(this.personClone);
         if(_loc36_ != null)
         {
            this.petClone = new Pet(MainStarlingStage(this.thePerson.root).gameMain,"",_loc36_.type);
            this.petClone.fitPreview(180,120);
            this.petClone.x = -485;
            this.petClone.y = -58;
            this.petClone.touchable = false;
            this.petClone.helmet_string = _loc36_.helmet_string;
            this.petClone.shoes_string = _loc36_.shoes_string;
            addChild(this.petClone);
            this.petClone.nextFrame();
         }
         addEventListener(Event.ENTER_FRAME,this.onEnter);
         drag_image = new Image(Texture.fromBitmapData(new BitmapData(560,30,false,16711680)));
         drag_image.x = -371;
         drag_image.y = -205;
         drag_image.name = "drag_image";
         drag_image.alpha = 0;
         addChild(drag_image);
      }
      
      private function onEnter(param1:Event) : void
      {
         this.personClone.bodyAnimator.onEnter();
         if(this.personClone.bodyAnimator.currentLabel != "standing")
         {
            this.personClone.bodyAnimator.gotoAndPlayInt(0);
         }
         if(this.petClone != null)
         {
            this.petClone.nextFrame();
            if(this.petClone.currentLabel != "standing")
            {
               this.petClone.gotoAndPlayStanding();
            }
         }
      }
      
      public function updateMe() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Pet = null;
         this.personClone.bodyAnimator.beard = this.thePerson.bodyAnimator.beard;
         this.personClone.bodyAnimator.helmetFrame = this.thePerson.bodyAnimator.helmetFrame;
         this.personClone.bodyAnimator.hair = this.thePerson.bodyAnimator.hair;
         this.personClone.bodyAnimator.shirtFrame = this.thePerson.bodyAnimator.shirtFrame;
         this.personClone.bodyAnimator.pantsFrame = this.thePerson.bodyAnimator.pantsFrame;
         this.personClone.bodyAnimator.shoeFrame = this.thePerson.bodyAnimator.shoeFrame;
         this.personClone.bodyAnimator.eyes = this.thePerson.bodyAnimator.eyes;
         this.personClone.bodyAnimator.skin = this.thePerson.bodyAnimator.skin;
         this.personClone.bodyAnimator.weaponFrame = this.thePerson.bodyAnimator.weaponFrame;
         this.personClone.bodyAnimator.weapon2Frame = this.thePerson.bodyAnimator.weapon2Frame;
         this.personClone.bodyAnimator.accessoryFrame = this.thePerson.bodyAnimator.accessoryFrame;
         var _loc3_:Pet = this.thePerson.isControllingPet ? Pet(this.thePerson.controlledObject().creator) : null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(this.thePerson.hasOrbFocus == false)
         {
            _loc5_ = _loc4_ = _loc6_ = _loc7_ = int(this.thePerson.getAllOrbBonuses(PetOrb.petOrb_array));
         }
         else
         {
            _loc1_ = 0;
            for each(_loc2_ in this.thePerson.pet_array)
            {
               if(_loc2_.isActive == false && _loc2_.health > 0)
               {
                  _loc1_ += Math.ceil(_loc2_.getOrbBonus() * 4 * 0.7);
               }
            }
            switch(this.thePerson.getClass())
            {
               case "warrior":
                  _loc4_ = _loc1_;
                  break;
               case "archer":
                  _loc5_ = _loc1_;
                  break;
               case "wizard":
                  _loc6_ = _loc1_;
                  break;
               case "cowboy":
                  _loc7_ = _loc1_;
            }
         }
         var _loc8_:int = this.thePerson.ridingPet != null ? int(this.thePerson.ridingPet.power * 0.4) : 0;
         this.hp_txt.text = "HP: " + this.thePerson.health + "/" + this.thePerson.totalHealth;
         this.mp_txt.text = "MP: " + this.thePerson.MP + "/" + this.thePerson.totalMP;
         this.dex_txt.text = "Dexterity: " + (this.thePerson.dex + (_loc3_ != null && (_loc3_.mode == "ipd" || _loc3_.mode == "b") ? int(_loc3_.dex * 0.15) : 0));
         this.defense_txt.text = "Defense: " + this.thePerson.defense;
         this.power_txt.text = "Power: " + (this.thePerson.power + _loc4_ + _loc8_);
         this.range_txt.text = "Range: " + (this.thePerson.range + _loc5_ + _loc8_);
         this.magic_txt.text = "Magic: " + (this.thePerson.magic + _loc6_ + _loc8_);
         this.artillery_txt.text = "Artillery: " + (this.thePerson.artillery + _loc7_ + _loc8_);
         this.critical_txt.text = "Critical hit: " + String(RoundToNearest.roundTo((this.thePerson.dex + (_loc3_ != null && (_loc3_.mode == "ipd" || _loc3_.mode == "b") ? int(_loc3_.dex * 0.15) : 0)) / 300 * 100,10)) + "%";
         var _loc9_:int = ItemStat(Stats.hStats[this.thePerson.bodyAnimator.helmetString]).range + ItemStat(Stats.sStats[this.thePerson.bodyAnimator.shirtString]).range + ItemStat(Stats.pStats[this.thePerson.bodyAnimator.pantsString]).range + ItemStat(Stats.shoesStats[this.thePerson.bodyAnimator.shoeString]).range;
         var _loc10_:int = ItemStat(Stats.hStats[this.thePerson.bodyAnimator.helmetString]).magic + ItemStat(Stats.sStats[this.thePerson.bodyAnimator.shirtString]).magic + ItemStat(Stats.pStats[this.thePerson.bodyAnimator.pantsString]).magic + ItemStat(Stats.shoesStats[this.thePerson.bodyAnimator.shoeString]).magic;
         var _loc11_:int = ItemStat(Stats.hStats[this.thePerson.bodyAnimator.helmetString]).power + ItemStat(Stats.sStats[this.thePerson.bodyAnimator.shirtString]).power + ItemStat(Stats.pStats[this.thePerson.bodyAnimator.pantsString]).power + ItemStat(Stats.shoesStats[this.thePerson.bodyAnimator.shoeString]).power;
         var _loc12_:int = ItemStat(Stats.hStats[this.thePerson.bodyAnimator.helmetString]).artillery + ItemStat(Stats.sStats[this.thePerson.bodyAnimator.shirtString]).artillery + ItemStat(Stats.pStats[this.thePerson.bodyAnimator.pantsString]).artillery + ItemStat(Stats.shoesStats[this.thePerson.bodyAnimator.shoeString]).artillery;
         var _loc13_:int = ItemStat(Stats.hStats[this.thePerson.bodyAnimator.helmetString]).defense + ItemStat(Stats.sStats[this.thePerson.bodyAnimator.shirtString]).defense + ItemStat(Stats.pStats[this.thePerson.bodyAnimator.pantsString]).defense + ItemStat(Stats.shoesStats[this.thePerson.bodyAnimator.shoeString]).defense + ItemStat(Stats.accStats[this.thePerson.bodyAnimator.accessoryString]).defense;
         var _loc14_:ItemStat = ItemStat(Stats.wStats[this.thePerson.bodyAnimator.weaponString]);
         var _loc15_:ItemStat = ItemStat(Stats.wStats[this.thePerson.bodyAnimator.weapon2String]);
         var _loc16_:uint = 0;
         var _loc17_:uint = 0;
         if(_loc14_.defense > 0)
         {
            if(_loc14_.sRate > 0)
            {
               _loc16_ = (this.thePerson.artillery + _loc7_ + _loc8_) * (_loc15_.minPower + _loc12_);
               _loc17_ = (this.thePerson.artillery + _loc7_ + _loc8_) * (_loc15_.maxPower + _loc12_);
            }
            else if(_loc14_.isMagic > 0)
            {
               _loc16_ = (this.thePerson.magic + _loc6_ + _loc8_) * (_loc15_.minPower + _loc10_);
               _loc17_ = (this.thePerson.magic + _loc6_ + _loc8_) * (_loc15_.maxPower + _loc10_);
            }
            else if(_loc14_.isRange)
            {
               _loc16_ = (this.thePerson.range + _loc5_ + _loc8_) * (_loc15_.minPower + _loc9_);
               _loc17_ = (this.thePerson.range + _loc5_ + _loc8_) * (_loc15_.maxPower + _loc9_);
            }
            else
            {
               _loc16_ = (this.thePerson.power + _loc4_ + _loc8_) * (_loc15_.minPower + _loc11_);
               _loc17_ = (this.thePerson.power + _loc4_ + _loc8_) * (_loc15_.maxPower + _loc11_);
            }
         }
         else if(_loc14_.sRate > 0)
         {
            _loc16_ = (this.thePerson.artillery + _loc7_ + _loc8_) * (_loc14_.minPower + _loc12_);
            _loc17_ = (this.thePerson.artillery + _loc7_ + _loc8_) * (_loc14_.maxPower + _loc12_);
         }
         else if(_loc14_.isMagic > 0)
         {
            _loc16_ = (this.thePerson.magic + _loc6_ + _loc8_) * (_loc14_.minPower + _loc10_);
            _loc17_ = (this.thePerson.magic + _loc6_ + _loc8_) * (_loc14_.maxPower + _loc10_);
         }
         else if(_loc14_.isRange)
         {
            _loc16_ = (this.thePerson.range + _loc5_ + _loc8_) * (_loc14_.minPower + _loc9_);
            _loc17_ = (this.thePerson.range + _loc5_ + _loc8_) * (_loc14_.maxPower + _loc9_);
         }
         else
         {
            _loc16_ = (this.thePerson.power + _loc4_ + _loc8_) * (_loc14_.minPower + _loc11_);
            _loc17_ = (this.thePerson.power + _loc4_ + _loc8_) * (_loc14_.maxPower + _loc11_);
         }
         _loc16_ /= 2;
         _loc17_ /= 2;
         this.damageSpan_txt.text = _loc16_ + "-" + _loc17_;
         var _loc18_:int = ItemStat(Stats.wStats[this.thePerson.bodyAnimator.weaponString]).defense * (this.thePerson.shieldMasteryLvl / 50 + 1);
         _loc13_ += _loc18_;
         this.defenseSpan_txt.text = String(int(this.thePerson.defense + _loc13_));
         var _loc19_:Number = 0;
         if(_loc3_ != null)
         {
            _loc19_ += Stats.petHelmetStats[_loc3_.helmet_string].speed / 115;
            _loc19_ += Stats.shoesStats[_loc3_.shoes_string].artillery / 115;
         }
         this.speed_txt.text = "Speed: " + String(RoundToNearest.roundTo(this.thePerson.moveSpeed + _loc19_,100)) + " mph";
         if(this.thePerson.isPlayer)
         {
            this.aPoints_txt.text = String(this.thePerson.abilityPoints);
         }
         if(this.thePerson.isPlayer == false || this.thePerson.abilityPoints == 0)
         {
            this.hpMore_btn.visible = this.rangeMore_btn.visible = this.magicMore_btn.visible = this.artilleryMore_btn.visible = false;
            this.mpMore_btn.visible = this.powerMore_btn.visible = this.dexMore_btn.visible = this.defenseMore_btn.visible = false;
         }
         else if(Boolean(this.thePerson.isPlayer) && this.thePerson.abilityPoints > 0)
         {
            this.dexMore_btn.visible = this.thePerson.dex < 300;
         }
         if(this.thePerson.isPlayer)
         {
            this.skills_txt.text = "Special Skill points: " + this.thePerson.skillPoints;
         }
      }
      
      public function get personName() : String
      {
         return this.__personName;
      }
   }
}

