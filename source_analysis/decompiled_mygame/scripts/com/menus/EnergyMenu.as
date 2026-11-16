package com.menus
{
   import com.game_objects.Person;
   import com.game_objects.extensions.*;
   import com.menus.add_ons.*;
   import com.ui.*;
   import flash.display.*;
   import starling.display.*;
   import starling.text.*;
   import starling.textures.*;
   import starling.utils.*;
   
   public final class EnergyMenu extends StarlingGameMenu
   {
      
      public static var energyMenu_textureAtlas:TextureAtlas;
      
      private const info_txt:TextField = new TextField(214,54,"---",AllTextFormats.energyInfo_textFormat);
      
      private const total_txt:TextField = new TextField(74,21,"0",AllTextFormats.petLvl_textFormat);
      
      private const charge_txt:TextField = new TextField(74,21,"0",AllTextFormats.petLvl_textFormat);
      
      private const absorbed_txt:TextField = new TextField(74,21,"0",AllTextFormats.petLvl_textFormat);
      
      private const level_txt:TextField = new TextField(74,21,"0",AllTextFormats.petLvl_textFormat);
      
      private const enemy_txt:TextField = new TextField(74,21,"0",AllTextFormats.petLvl_textFormat);
      
      private const pvp_txt:TextField = new TextField(74,21,"0",AllTextFormats.petLvl_textFormat);
      
      private const random_txt:TextField = new TextField(74,21,"0",AllTextFormats.petLvl_textFormat);
      
      private const rage_txt:TextField = new TextField(74,21,"0",AllTextFormats.petLvl_textFormat);
      
      private const chop_txt:TextField = new TextField(74,21,"0",AllTextFormats.petLvl_textFormat);
      
      private const fish_txt:TextField = new TextField(74,21,"0",AllTextFormats.petLvl_textFormat);
      
      private const totalInfo_txt:TextField = new TextField(200,28,"total energy",AllTextFormats.toggleOff_textFormat);
      
      private const chargeInfo_txt:TextField = new TextField(100,28,"charge",AllTextFormats.toggleOff_textFormat);
      
      private const absorbedInfo_txt:TextField = new TextField(190,26,"absorbed energy",AllTextFormats.qualityOff_textFormat);
      
      private const levelInfo_txt:TextField = new TextField(160,26,"level energy",AllTextFormats.qualityOff_textFormat);
      
      private const enemyInfo_txt:TextField = new TextField(150,22,"enemy energy",AllTextFormats.ticketsTitle_textFormat);
      
      private const pvpInfo_txt:TextField = new TextField(160,20,"pvp energy",AllTextFormats.yourItemType_textFormat);
      
      private const randomInfo_txt:TextField = new TextField(140,20,"random energy",AllTextFormats.yourItemType_textFormat);
      
      private const rageInfo_txt:TextField = new TextField(130,20,"rage energy",AllTextFormats.yourItemType_textFormat);
      
      private const chopInfo_txt:TextField = new TextField(120,18,"chop energy",AllTextFormats.petType_textFormat);
      
      private const fishInfo_txt:TextField = new TextField(120,18,"fish energy",AllTextFormats.petType_textFormat);
      
      private const totalPlus_btn:Button = new Button(CharacterMenu.charMenu_textureAtlas.getTexture("more_btn_00"),"",null,CharacterMenu.charMenu_textureAtlas.getTexture("more_btn_01"));
      
      private const chargePlus_btn:Button = new Button(this.totalPlus_btn.upState,"",null,this.totalPlus_btn.overState);
      
      private const absorbedPlus_btn:Button = new Button(this.totalPlus_btn.upState,"",null,this.totalPlus_btn.overState);
      
      private const levelPlus_btn:Button = new Button(this.totalPlus_btn.upState,"",null,this.totalPlus_btn.overState);
      
      private const enemyPlus_btn:Button = new Button(this.totalPlus_btn.upState,"",null,this.totalPlus_btn.overState);
      
      private const pvpPlus_btn:Button = new Button(this.totalPlus_btn.upState,"",null,this.totalPlus_btn.overState);
      
      private const randomPlus_btn:Button = new Button(this.totalPlus_btn.upState,"",null,this.totalPlus_btn.overState);
      
      private const ragePlus_btn:Button = new Button(this.totalPlus_btn.upState,"",null,this.totalPlus_btn.overState);
      
      private const chopPlus_btn:Button = new Button(this.totalPlus_btn.upState,"",null,this.totalPlus_btn.overState);
      
      private const fishPlus_btn:Button = new Button(this.totalPlus_btn.upState,"",null,this.totalPlus_btn.overState);
      
      private const totalBar:EnergyBar = new EnergyBar();
      
      private const chargeBar:EnergyBar = new EnergyBar(true);
      
      private const absorbedBar:EnergyBar = new EnergyBar();
      
      private const levelBar:EnergyBar = new EnergyBar();
      
      private const enemyBar:EnergyBar = new EnergyBar();
      
      private const pvpBar:EnergyBar = new EnergyBar();
      
      private const randomBar:EnergyBar = new EnergyBar();
      
      private const rageBar:EnergyBar = new EnergyBar();
      
      private const chopBar:EnergyBar = new EnergyBar();
      
      private const fishBar:EnergyBar = new EnergyBar();
      
      public function EnergyMenu(param1:Person)
      {
         var _loc2_:Image = null;
         super();
         _loc2_ = new Image(energyMenu_textureAtlas.getTexture("panel"));
         _loc2_.x = -306;
         _loc2_.y = -110;
         addChild(_loc2_);
         var _loc3_:Button = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_00"),"",null,ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_01"));
         _loc3_.x = 369;
         _loc3_.y = -97;
         _loc3_.pivotX = 30;
         _loc3_.pivotY = 19;
         _loc3_.name = "x_btn";
         addChild(_loc3_);
         this.totalBar.x = -231;
         this.chargeBar.x = -141;
         this.absorbedBar.x = -63;
         this.levelBar.x = 9;
         this.enemyBar.x = 73;
         this.pvpBar.x = 128;
         this.randomBar.x = 183;
         this.rageBar.x = 240;
         this.chopBar.x = 295;
         this.fishBar.x = 346;
         this.absorbedBar.scale = 1 - (6 - EnergyController.ABSORBED_WEIGHT) / 10;
         this.levelBar.scale = 1 - (6 - EnergyController.LEVEL_WEIGHT) / 10;
         this.enemyBar.scale = 1 - (6 - EnergyController.ENEMY_WEIGHT) / 10;
         this.pvpBar.scale = 1 - (6 - EnergyController.PVP_WEIGHT) / 10;
         this.randomBar.scale = 1 - (6 - EnergyController.RANDOM_WEIGHT) / 10;
         this.rageBar.scale = 1 - (6 - EnergyController.RAGE_WEIGHT) / 10;
         this.chopBar.scale = 1 - (6 - EnergyController.CHOP_WEIGHT) / 10;
         this.fishBar.scale = 1 - (6 - EnergyController.FISH_WEIGHT) / 10;
         addChild(this.totalBar);
         addChild(this.chargeBar);
         addChild(this.absorbedBar);
         addChild(this.levelBar);
         addChild(this.enemyBar);
         addChild(this.pvpBar);
         addChild(this.randomBar);
         addChild(this.rageBar);
         addChild(this.chopBar);
         addChild(this.fishBar);
         this.totalBar.barSize = 40;
         this.totalBar.maxSize = 60;
         this.totalBar.y = this.chargeBar.y = this.absorbedBar.y = this.levelBar.y = this.enemyBar.y = this.pvpBar.y = this.randomBar.y = this.rageBar.y = this.chopBar.y = this.fishBar.y = 209;
         this.info_txt.x = 145;
         this.info_txt.y = -70;
         this.total_txt.x = -295;
         this.charge_txt.x = -204;
         this.absorbed_txt.x = -122;
         this.level_txt.x = -48;
         this.enemy_txt.x = 21;
         this.pvp_txt.x = 78;
         this.random_txt.x = 134;
         this.rage_txt.x = 192;
         this.chop_txt.x = 246;
         this.fish_txt.x = 299;
         addChild(this.info_txt);
         addChild(this.total_txt);
         addChild(this.charge_txt);
         addChild(this.absorbed_txt);
         addChild(this.level_txt);
         addChild(this.enemy_txt);
         addChild(this.pvp_txt);
         addChild(this.random_txt);
         addChild(this.rage_txt);
         addChild(this.chop_txt);
         addChild(this.fish_txt);
         this.fish_txt.y = this.chop_txt.y = this.rage_txt.y = this.random_txt.y = this.pvp_txt.y = this.enemy_txt.y = this.level_txt.y = this.absorbed_txt.y = this.charge_txt.y = this.total_txt.y = 210;
         this.fish_txt.batchable = this.chop_txt.batchable = this.rage_txt.batchable = this.random_txt.batchable = this.pvp_txt.batchable = this.enemy_txt.batchable = this.level_txt.batchable = this.absorbed_txt.batchable = this.charge_txt.batchable = this.total_txt.batchable = true;
         this.fish_txt.touchable = this.chop_txt.touchable = this.rage_txt.touchable = this.random_txt.touchable = this.pvp_txt.touchable = this.enemy_txt.touchable = this.level_txt.touchable = this.absorbed_txt.touchable = this.charge_txt.touchable = this.total_txt.touchable = false;
         this.totalInfo_txt.rotation = this.chargeInfo_txt.rotation = this.absorbedInfo_txt.rotation = this.levelInfo_txt.rotation = this.enemyInfo_txt.rotation = this.pvpInfo_txt.rotation = this.randomInfo_txt.rotation = this.rageInfo_txt.rotation = this.chopInfo_txt.rotation = this.fishInfo_txt.rotation = deg2rad(-90);
         this.totalInfo_txt.batchable = this.chargeInfo_txt.batchable = this.absorbedInfo_txt.batchable = this.levelInfo_txt.batchable = this.enemyInfo_txt.batchable = this.pvpInfo_txt.batchable = this.randomInfo_txt.batchable = this.rageInfo_txt.batchable = this.chopInfo_txt.batchable = this.fishInfo_txt.batchable = true;
         this.totalInfo_txt.touchable = this.chargeInfo_txt.touchable = this.absorbedInfo_txt.touchable = this.levelInfo_txt.touchable = this.enemyInfo_txt.touchable = this.pvpInfo_txt.touchable = this.randomInfo_txt.touchable = this.rageInfo_txt.touchable = this.chopInfo_txt.touchable = this.fishInfo_txt.touchable = false;
         this.totalInfo_txt.x = this.totalBar.x - 68;
         this.chargeInfo_txt.x = this.chargeBar.x - 68;
         this.absorbedInfo_txt.x = this.absorbedBar.x - 60;
         this.levelInfo_txt.x = this.levelBar.x - 60;
         this.enemyInfo_txt.x = this.enemyBar.x - 49;
         this.pvpInfo_txt.x = this.pvpBar.x - 41;
         this.randomInfo_txt.x = this.randomBar.x - 40;
         this.rageInfo_txt.x = this.rageBar.x - 38;
         this.chopInfo_txt.x = this.chopBar.x - 36;
         this.fishInfo_txt.x = this.fishBar.x - 33;
         addChild(this.totalInfo_txt);
         addChild(this.chargeInfo_txt);
         addChild(this.absorbedInfo_txt);
         addChild(this.levelInfo_txt);
         addChild(this.enemyInfo_txt);
         addChild(this.pvpInfo_txt);
         addChild(this.randomInfo_txt);
         addChild(this.rageInfo_txt);
         addChild(this.chopInfo_txt);
         addChild(this.fishInfo_txt);
         this.totalPlus_btn.x = this.totalBar.x - 33;
         this.chargePlus_btn.x = this.chargeBar.x - 33;
         this.absorbedPlus_btn.x = this.absorbedBar.x - 35;
         this.levelPlus_btn.x = this.levelBar.x - 35;
         this.enemyPlus_btn.x = this.enemyBar.x - 28;
         this.pvpPlus_btn.x = this.pvpBar.x - 26;
         this.randomPlus_btn.x = this.randomBar.x - 26;
         this.ragePlus_btn.x = this.rageBar.x - 23;
         this.chopPlus_btn.x = this.chopBar.x - 23;
         this.fishPlus_btn.x = this.fishBar.x - 23;
         this.totalPlus_btn.name = "energyTotalPlus_btn";
         this.chargePlus_btn.name = "energyChargePlus_btn";
         this.absorbedPlus_btn.name = "energyAbsorbedPlus_btn";
         this.levelPlus_btn.name = "energyLevelPlus_btn";
         this.enemyPlus_btn.name = "energyEnemyPlus_btn";
         this.pvpPlus_btn.name = "energyPvpPlus_btn";
         this.randomPlus_btn.name = "energyRandomPlus_btn";
         this.ragePlus_btn.name = "energyRagePlus_btn";
         this.chopPlus_btn.name = "energyChopPlus_btn";
         this.fishPlus_btn.name = "energyFishPlus_btn";
         addChild(this.totalPlus_btn);
         addChild(this.chargePlus_btn);
         addChild(this.absorbedPlus_btn);
         addChild(this.levelPlus_btn);
         addChild(this.enemyPlus_btn);
         addChild(this.pvpPlus_btn);
         addChild(this.randomPlus_btn);
         addChild(this.ragePlus_btn);
         addChild(this.chopPlus_btn);
         addChild(this.fishPlus_btn);
         var _loc4_:Button = new Button(energyMenu_textureAtlas.getTexture("info button"));
         _loc4_.x = 154;
         _loc4_.y = -63;
         _loc4_.pivotX = _loc4_.pivotY = 10;
         _loc4_.name = "energyInfo_btn";
         addChild(_loc4_);
         this.updateMe(param1);
         var _loc5_:Image = new Image(Texture.fromBitmapData(new BitmapData(644,32,false,16711680)));
         _loc5_.x = -305;
         _loc5_.y = -110;
         _loc5_.alpha = 0;
         _loc5_.name = "drag_image";
         addChild(_loc5_);
      }
      
      public function updateMe(param1:Person) : void
      {
         this.totalBar.maxSize = param1.energyController.totalMax;
         this.chargeBar.maxSize = param1.energyController.chargeMax;
         this.absorbedBar.maxSize = param1.energyController.absorbedMax;
         this.levelBar.maxSize = param1.energyController.levelMax;
         this.enemyBar.maxSize = param1.energyController.enemyMax;
         this.pvpBar.maxSize = param1.energyController.pvpMax;
         this.randomBar.maxSize = param1.energyController.randomMax;
         this.rageBar.maxSize = param1.energyController.rageMax;
         this.chopBar.maxSize = param1.energyController.chopMax;
         this.fishBar.maxSize = param1.energyController.fishMax;
         this.totalBar.barSize = param1.energyController.fullTotalScale;
         this.chargeBar.barSize = param1.energyController.charge;
         this.absorbedBar.barSize = param1.energyController.absorbed;
         this.levelBar.barSize = param1.energyController.level;
         this.enemyBar.barSize = param1.energyController.enemy;
         this.pvpBar.barSize = param1.energyController.pvp;
         this.randomBar.barSize = param1.energyController.random;
         this.rageBar.barSize = param1.energyController.rage;
         this.chopBar.barSize = param1.energyController.chop;
         this.fishBar.barSize = param1.energyController.fish;
         this.setLocations(this.totalPlus_btn,this.totalBar,this.totalInfo_txt);
         this.setLocations(this.chargePlus_btn,this.chargeBar,this.chargeInfo_txt);
         this.setLocations(this.absorbedPlus_btn,this.absorbedBar,this.absorbedInfo_txt);
         this.setLocations(this.levelPlus_btn,this.levelBar,this.levelInfo_txt);
         this.setLocations(this.enemyPlus_btn,this.enemyBar,this.enemyInfo_txt);
         this.setLocations(this.pvpPlus_btn,this.pvpBar,this.pvpInfo_txt);
         this.setLocations(this.randomPlus_btn,this.randomBar,this.randomInfo_txt);
         this.setLocations(this.ragePlus_btn,this.rageBar,this.rageInfo_txt);
         this.setLocations(this.chopPlus_btn,this.chopBar,this.chopInfo_txt);
         this.setLocations(this.fishPlus_btn,this.fishBar,this.fishInfo_txt);
         this.info_txt.text = "Energy stage: " + int(param1.energyController.fullTotal) + "\nTotal energy: " + param1.energyController.fullTotal * 1000;
         this.total_txt.text = String(int(param1.energyController.fullTotal * 1000));
         this.charge_txt.text = int(param1.energyController.charge * 100) + "%";
         this.absorbed_txt.text = String(int(param1.energyController.fullAbsorbed * 1000));
         this.level_txt.text = String(int(param1.energyController.fullLevel * 1000));
         this.enemy_txt.text = String(int(param1.energyController.fullEnemy * 1000));
         this.pvp_txt.text = String(int(param1.energyController.fullPvp * 1000));
         this.random_txt.text = String(int(param1.energyController.fullRandom * 1000));
         this.rage_txt.text = String(int(param1.energyController.fullRage * 1000));
         this.chop_txt.text = String(int(param1.energyController.fullChop * 1000));
         this.fish_txt.text = String(int(param1.energyController.fullFish * 1000));
      }
      
      private function setLocations(param1:Button, param2:EnergyBar, param3:TextField) : void
      {
         param1.y = param2.y - param2.maxSize * 245 * param2.scale - 30;
         param3.y = param2.y;
         if(param2.maxSize == 1)
         {
            param1.removeFromParent(true);
         }
      }
   }
}

