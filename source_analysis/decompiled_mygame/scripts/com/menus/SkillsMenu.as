package com.menus
{
   import com.game_objects.*;
   import com.math.*;
   import com.stats.*;
   import com.ui.*;
   import com.utilities.*;
   import com.visual_effects.*;
   import flash.display.*;
   import flash.geom.*;
   import playerio.Client;
   import starling.*;
   import starling.core.*;
   import starling.display.*;
   import starling.text.*;
   import starling.textures.*;
   import starling.utils.*;
   
   public final class SkillsMenu extends StarlingGameMenu implements IScrollableGameMenu
   {
      
      public static var skillsMenu_textureAtlas:TextureAtlas;
      
      private static const assetManager:AssetManager = new AssetManager();
      
      private const boxBG_texture:Texture = Texture.fromBitmapData(new BitmapData(257,134,false,3355443));
      
      private const scroll_btn:Button = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("scroll"));
      
      private const skillPoints_txt:TextField = new TextField(92,48,"",AllTextFormats.skillPoints_textFormat);
      
      private const scrollArea:starling.display.Sprite = new Sprite();
      
      private var currentDisplay:String = "basic";
      
      private const mask_canvas:Canvas = new Canvas();
      
      private const jump_btn:Button = new Button(CharacterMenu.charMenu_textureAtlas.getTexture("more_btn_00"));
      
      private const critical_btn:Button = new Button(this.jump_btn.upState);
      
      private const loot_btn:Button = new Button(this.jump_btn.upState);
      
      private const training_btn:Button = new Button(this.jump_btn.upState);
      
      private const rage_btn:Button = new Button(this.jump_btn.upState);
      
      private const guildRage_btn:Button = new Button(this.jump_btn.upState);
      
      private const mpRestore_btn:Button = new Button(this.jump_btn.upState);
      
      private const avoidance_btn:Button = new Button(this.jump_btn.upState);
      
      private const dash_btn:Button = new Button(this.jump_btn.upState);
      
      private const accel_btn:Button = new Button(this.jump_btn.upState);
      
      private const block_btn:Button = new Button(this.jump_btn.upState);
      
      private const power_btn:Button = new Button(this.jump_btn.upState);
      
      private const expertWarrior_btn:Button = new Button(this.jump_btn.upState);
      
      private const multiAttack_btn:Button = new Button(this.jump_btn.upState);
      
      private const chainDist_btn:Button = new Button(this.jump_btn.upState);
      
      private const shield_btn:Button = new Button(this.jump_btn.upState);
      
      private const melee_btn:Button = new Button(this.jump_btn.upState);
      
      private const spinAttack_btn:Button = new Button(this.jump_btn.upState);
      
      private const barrage_btn:Button = new Button(this.jump_btn.upState);
      
      private const arrowKnockback_btn:Button = new Button(this.jump_btn.upState);
      
      private const expertArcher_btn:Button = new Button(this.jump_btn.upState);
      
      private const tripleShot_btn:Button = new Button(this.jump_btn.upState);
      
      private const arrowRain_btn:Button = new Button(this.jump_btn.upState);
      
      private const piercingArrow_btn:Button = new Button(this.jump_btn.upState);
      
      private const downCrush_btn:Button = new Button(this.jump_btn.upState);
      
      private const magicShots_btn:Button = new Button(this.jump_btn.upState);
      
      private const expertWizard_btn:Button = new Button(this.jump_btn.upState);
      
      private const lightBeam_btn:Button = new Button(this.jump_btn.upState);
      
      private const magicDistance_btn:Button = new Button(this.jump_btn.upState);
      
      private const thunder_btn:Button = new Button(this.jump_btn.upState);
      
      private const selfHeal_btn:Button = new Button(this.jump_btn.upState);
      
      private const guildHeal_btn:Button = new Button(this.jump_btn.upState);
      
      private const grenade_btn:Button = new Button(this.jump_btn.upState);
      
      private const upward_btn:Button = new Button(this.jump_btn.upState);
      
      private const expertCowboy_btn:Button = new Button(this.jump_btn.upState);
      
      private const bulletDistance_btn:Button = new Button(this.jump_btn.upState);
      
      private const shotgun_btn:Button = new Button(this.jump_btn.upState);
      
      private const bulletKnockback_btn:Button = new Button(this.jump_btn.upState);
      
      private const jumpGrenade_btn:Button = new Button(this.jump_btn.upState);
      
      private const jumpLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const criticalLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const lootLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const trainingLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const rageLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const guildRageLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const mpRestoreLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const avoidabilityLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const dashLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const accelLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const blockLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const powerLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const expertWarriorLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const multiAttackLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const chainDistLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const shieldLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const meleeLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const spinningLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const barrageLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const arrowKnockbackLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const expertArcherLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const tripleShotLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const arrowRainLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const piercingArrowLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const downCrushLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const magicShotsLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const expertWizardLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const lightBeamLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const magicDistanceLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const thunderLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const selfHealLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const guildHealLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const grenadeLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const upwardLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const expertCowboyLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const bulletDistanceLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const shotgunLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const bulletKnockbackLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const jumpGrenadeLvl_txt:TextField = new TextField(52,19,"",AllTextFormats.skill_textFormat);
      
      private const jumpRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const criticalRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const lootRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const trainingRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const rageRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const guildRageRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const mpRestoreRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const avoidabilityRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const dashRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const accelRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const blockRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const powerRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const expertWarriorRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const multiAttackRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const chainDistRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const shieldRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const meleeRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const spinningRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const barrageRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const arrowKnockbackRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const expertArcherRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const tripleShotRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const arrowRainRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const piercingArrowRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const downCrushRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const magicShotsRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const expertWizardRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const lightBeamRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const magicDistanceRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const thunderRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const selfHealRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const guildHealRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const grenadeRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const upwardRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const expertCowboyRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const bulletDistanceRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const shotgunRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const bulletKnockbackRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const jumpGrenadeRequired_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      private const jumpMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const criticalMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const lootMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const trainingMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const rageMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const guildRageMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const mpRestoreMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const avoidabilityMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const dashMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const accelMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const blockMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const powerMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const expertWarriorMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const multiAttackMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const chainDistMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const shieldMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const meleeMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const spinningMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const barrageMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const arrowKnockbackMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const expertArcherMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const tripleShotMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const arrowRainMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const piercingArrowMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const downCrushMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const magicShotsMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const expertWizardMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const lightBeamMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const magicDistanceMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const thunderMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const selfHealMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const guildHealMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const grenadeMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const upwardMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const expertCowboyMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const bulletDistanceMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const shotgunMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const bulletKnockbackMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const jumpGrenadeMax_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const jumpHeight_txt:TextField = new TextField(188,19,"",AllTextFormats.skill_textFormat);
      
      private const criticalDamage_txt:TextField = new TextField(190,19,"",AllTextFormats.skill_textFormat);
      
      private const lootTime_txt:TextField = new TextField(170,19,"",AllTextFormats.skill_textFormat);
      
      private const rage_txt:TextField = new TextField(137,19,"",AllTextFormats.skill_textFormat);
      
      private const guildRage_txt:TextField = new TextField(143,19,"",AllTextFormats.skill_textFormat);
      
      private const mpRestore_txt:TextField = new TextField(124,19,"",AllTextFormats.skill_textFormat);
      
      private const avoidability_txt:TextField = new TextField(131,19,"",AllTextFormats.skill_textFormat);
      
      private const dash_txt:TextField = new TextField(180,19,"",AllTextFormats.skill_textFormat);
      
      private const accel_txt:TextField = new TextField(167,19,"",AllTextFormats.skill_textFormat);
      
      private const block_txt:TextField = new TextField(164,19,"",AllTextFormats.skill_textFormat);
      
      private const power_txt:TextField = new TextField(105,19,"",AllTextFormats.skill_textFormat);
      
      private const multiAttack_txt:TextField = new TextField(126,19,"",AllTextFormats.skill_textFormat);
      
      private const chainDistance_txt:TextField = new TextField(175,19,"",AllTextFormats.skill_textFormat);
      
      private const shield_txt:TextField = new TextField(118,19,"",AllTextFormats.skill_textFormat);
      
      private const meleeKnockback_txt:TextField = new TextField(125,19,"",AllTextFormats.skill_textFormat);
      
      private const spinning_txt:TextField = new TextField(133,19,"",AllTextFormats.skill_textFormat);
      
      private const barrage_txt:TextField = new TextField(128,19,"",AllTextFormats.skill_textFormat);
      
      private const arrowKnockback_txt:TextField = new TextField(135,19,"",AllTextFormats.skill_textFormat);
      
      private const tripleShot_txt:TextField = new TextField(164,19,"",AllTextFormats.skill_textFormat);
      
      private const arrowRain_txt:TextField = new TextField(134,19,"",AllTextFormats.skill_textFormat);
      
      private const piercingArrow_txt:TextField = new TextField(150,19,"",AllTextFormats.skill_textFormat);
      
      private const downCrush_txt:TextField = new TextField(156,19,"",AllTextFormats.skill_textFormat);
      
      private const magicShots_txt:TextField = new TextField(85,19,"",AllTextFormats.skill_textFormat);
      
      private const lightBeam_txt:TextField = new TextField(76,19,"",AllTextFormats.skill_textFormat);
      
      private const magicDistance_txt:TextField = new TextField(124,19,"",AllTextFormats.skill_textFormat);
      
      private const thunder_txt:TextField = new TextField(120,19,"",AllTextFormats.skill_textFormat);
      
      private const selfHeal_txt:TextField = new TextField(125,19,"",AllTextFormats.skill_textFormat);
      
      private const guildHeal_txt:TextField = new TextField(118,19,"",AllTextFormats.skill_textFormat);
      
      private const grenade_txt:TextField = new TextField(105,19,"",AllTextFormats.skill_textFormat);
      
      private const bulletDistance_txt:TextField = new TextField(127,19,"",AllTextFormats.skill_textFormat);
      
      private const shotgun_txt:TextField = new TextField(131,19,"",AllTextFormats.skill_textFormat);
      
      private const bulletKnockback_txt:TextField = new TextField(126,19,"",AllTextFormats.skill_textFormat);
      
      private const jumpGrenade_txt:TextField = new TextField(130,19,"",AllTextFormats.skill_textFormat);
      
      public function SkillsMenu(param1:Client)
      {
         super();
         var _loc2_:Image = new Image(skillsMenu_textureAtlas.getTexture("panel"));
         _loc2_.x = -431;
         _loc2_.y = -205;
         addChild(_loc2_);
         var _loc3_:Button = new Button(skillsMenu_textureAtlas.getTexture("basicSkills_btn"));
         _loc3_.x = -254;
         _loc3_.pivotX = 50;
         _loc3_.pivotY = 16;
         _loc3_.name = "basicSkills_btn";
         addChild(_loc3_);
         var _loc4_:Button = new Button(skillsMenu_textureAtlas.getTexture("warriorSkills_btn"));
         _loc4_.x = -153;
         _loc4_.pivotX = 54;
         _loc4_.pivotY = 17;
         _loc4_.name = "warriorSkills_btn";
         addChild(_loc4_);
         var _loc5_:Button = new Button(skillsMenu_textureAtlas.getTexture("archerSkills_btn"));
         _loc5_.x = -30;
         _loc5_.pivotX = 60;
         _loc5_.pivotY = 16;
         _loc5_.name = "archerSkills_btn";
         addChild(_loc5_);
         var _loc6_:Button = new Button(skillsMenu_textureAtlas.getTexture("wizardSkills_btn"));
         _loc6_.x = 78;
         _loc6_.pivotX = 52;
         _loc6_.pivotY = 24;
         _loc6_.name = "wizardSkills_btn";
         addChild(_loc6_);
         var _loc7_:Button = new Button(skillsMenu_textureAtlas.getTexture("cowboySkills_btn"));
         _loc7_.x = 191;
         _loc7_.pivotX = 50;
         _loc7_.pivotY = 17;
         _loc7_.name = "cowboySkills_btn";
         addChild(_loc7_);
         _loc3_.y = _loc4_.y = _loc5_.y = _loc6_.y = _loc7_.y = -149;
         _loc3_.scaleWhenOver = _loc4_.scaleWhenOver = _loc5_.scaleWhenOver = _loc6_.scaleWhenOver = _loc7_.scaleWhenOver = 0.95;
         this.mask_canvas.drawRectangle(-212,-22,603,357);
         this.scrollArea.x = -96;
         this.scrollArea.y = -105;
         this.scrollArea.mask = this.mask_canvas;
         this.scrollArea.name = "itemScrollList";
         addChild(this.scrollArea);
         var _loc8_:Button = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_00"),"",ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_01"));
         _loc8_.x = 301;
         _loc8_.y = -191;
         _loc8_.pivotX = 30;
         _loc8_.pivotY = 19;
         _loc8_.name = "x_btn";
         _loc8_.scaleWhenOver = 1.05;
         addChild(_loc8_);
         this.scroll_btn.x = 277;
         this.scroll_btn.y = -128;
         this.scroll_btn.pivotX = 15;
         this.scroll_btn.pivotY = 19;
         this.scroll_btn.name = "scroll_btn";
         this.scroll_btn.visible = !GameMain.isMobile;
         addChild(this.scroll_btn);
         var _loc9_:Button = new Button(CharacterMenu.charMenu_textureAtlas.getTexture("info_btn"));
         _loc9_.x = -336;
         _loc9_.y = -110;
         _loc9_.pivotX = _loc9_.pivotY = 9;
         _loc9_.name = "mpUsage_btn";
         addChild(_loc9_);
         this.skillPoints_txt.x = -418;
         this.skillPoints_txt.touchable = false;
         addChild(this.skillPoints_txt);
         var _loc10_:Image = new Image(Texture.fromBitmapData(new BitmapData(573,36,false,16711680)));
         _loc10_.x = -311;
         _loc10_.y = -209;
         _loc10_.alpha = 0;
         _loc10_.name = "drag_image";
         addChild(_loc10_);
         if(assetManager.getTextureAtlas("skill images") == null)
         {
            assetManager.verbose = true;
            assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/skill images.png");
            assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/skill images.xml");
            assetManager.loadQueue(this.onProgress);
         }
      }
      
      private function onProgress(param1:Number) : void
      {
         if(param1 == 1)
         {
            this.updateSkillImages();
         }
      }
      
      public function updateMe() : void
      {
         var _loc1_:Person = MainStarlingStage(root).gameMain.player;
         this.skillPoints_txt.text = String(_loc1_.skillPoints);
         switch(this.currentDisplay)
         {
            case "basic":
               this.setSkillText(this.jumpHeight_txt,this.jumpRequired_txt,this.jumpLvl_txt,this.jumpMax_txt,_loc1_.jumpSkillLvl,"jump height","Jump height: " + RoundToNearest.roundTo(_loc1_.jumpPower / 2,100) + " feet");
               this.setSkillText(this.criticalDamage_txt,this.criticalRequired_txt,this.criticalLvl_txt,this.criticalMax_txt,_loc1_.criticalLvl,"critical hit","Current critical damage: " + Math.round(100 * (2 + _loc1_.criticalLvl / 8)) + "%");
               this.setSkillText(this.lootTime_txt,this.lootRequired_txt,this.lootLvl_txt,this.lootMax_txt,_loc1_.lootStealLvl,"loot steal","Time Delay: " + RoundToNearest.roundTo((210 - _loc1_.lootStealLvl * 2) / 30,100) + " seconds");
               this.setSkillText(null,this.trainingRequired_txt,this.trainingLvl_txt,this.trainingMax_txt,_loc1_.trainingLvl,"training","");
               this.setSkillText(this.rage_txt,this.rageRequired_txt,this.rageLvl_txt,this.rageMax_txt,_loc1_.selfRageLvl,"self rage","Energy: " + _loc1_.selfRageLvl * 57);
               this.setSkillText(this.guildRage_txt,this.guildRageRequired_txt,this.guildRageLvl_txt,this.guildRageMax_txt,_loc1_.guildRageLvl,"guild rage","Duration: " + (_loc1_.guildRageLvl + 3) + " seconds");
               this.setSkillText(this.mpRestore_txt,this.mpRestoreRequired_txt,this.mpRestoreLvl_txt,this.mpRestoreMax_txt,_loc1_.mpRestoreLvl,"mp restore","MP restored: " + (_loc1_.mpRestoreLvl > 1 ? _loc1_.mpRestoreLvl * 3 : 0));
               this.setSkillText(this.avoidability_txt,this.avoidabilityRequired_txt,this.avoidabilityLvl_txt,this.avoidabilityMax_txt,_loc1_.avoidabilityLvl,"avoidability","Avoidability: " + _loc1_.avoidabilityLvl + "%");
               this.setSkillText(this.dash_txt,this.dashRequired_txt,this.dashLvl_txt,this.dashMax_txt,_loc1_.dashLvl,"speed dash","Speed: " + RoundToNearest.roundTo(1.5 + _loc1_.dashLvl / 10,10) + "x walking speed");
               this.setSkillText(this.accel_txt,this.accelRequired_txt,this.accelLvl_txt,this.accelMax_txt,_loc1_.accelDownLvl,"accel down","Down accel: " + Math.round((1.4 + _loc1_.accelDownLvl / 10) * 100) + "% & " + Math.round((2 + _loc1_.accelDownLvl / 10) * 100) + "%");
               this.setSkillText(this.block_txt,this.blockRequired_txt,this.blockLvl_txt,this.blockMax_txt,_loc1_.blockLvl,"block","Damage reduction: " + int(50 + _loc1_.blockLvl) + "%");
               this.setSkillButton(this.jump_btn,_loc1_.jumpSkillLvl,"jump height");
               this.setSkillButton(this.critical_btn,_loc1_.criticalLvl,"critical hit");
               this.setSkillButton(this.loot_btn,_loc1_.lootStealLvl,"loot steal");
               this.setSkillButton(this.training_btn,_loc1_.trainingLvl,"training");
               this.setSkillButton(this.rage_btn,_loc1_.selfRageLvl,"self rage");
               this.setSkillButton(this.guildRage_btn,_loc1_.guildRageLvl,"guild rage");
               this.setSkillButton(this.mpRestore_btn,_loc1_.mpRestoreLvl,"mp restore");
               this.setSkillButton(this.avoidance_btn,_loc1_.avoidabilityLvl,"avoidability");
               this.setSkillButton(this.dash_btn,_loc1_.dashLvl,"speed dash");
               this.setSkillButton(this.accel_btn,_loc1_.accelDownLvl,"accel down");
               this.setSkillButton(this.block_btn,_loc1_.blockLvl,"block");
               break;
            case "warrior":
               this.setSkillText(this.power_txt,this.powerRequired_txt,this.powerLvl_txt,this.powerMax_txt,_loc1_.powerAttackLvl,"power attack","Damage: " + (200 + _loc1_.powerAttackLvl * 2) + "%");
               this.setSkillText(null,this.expertWarriorRequired_txt,this.expertWarriorLvl_txt,this.expertWarriorMax_txt,_loc1_.expertWarriorLvl,"expert warrior","");
               this.setSkillText(this.chainDistance_txt,this.chainDistRequired_txt,this.chainDistLvl_txt,this.chainDistMax_txt,_loc1_.chainDistanceLvl,"air slash","Damage: " + int((1.3 + _loc1_.chainDistanceLvl / 33) * 100) + "%");
               this.setSkillText(this.shield_txt,this.shieldRequired_txt,this.shieldLvl_txt,this.shieldMax_txt,_loc1_.shieldMasteryLvl,"shield mastery","Shield Bonus: " + (100 + _loc1_.shieldMasteryLvl * 2) + "%");
               this.setSkillText(this.multiAttack_txt,this.multiAttackRequired_txt,this.multiAttackLvl_txt,this.multiAttackMax_txt,_loc1_.multiAttackLvl,"multi attack","Chained enemies: " + _loc1_.multiAttackLvl);
               this.setSkillText(this.meleeKnockback_txt,this.meleeRequired_txt,this.meleeLvl_txt,this.meleeMax_txt,_loc1_.meleeKnockbackLvl,"melee knockback","Knockback: " + RoundToNearest.roundTo((23 + _loc1_.meleeKnockbackLvl) / 30,100) + " feet");
               this.setSkillText(this.spinning_txt,this.spinningRequired_txt,this.spinningLvl_txt,this.spinningMax_txt,_loc1_.spinAttackLvl,"spin attack","Damage: " + (15 + _loc1_.spinAttackLvl) + "%");
               this.setSkillButton(this.power_btn,_loc1_.powerAttackLvl,"power attack");
               this.setSkillButton(this.expertWarrior_btn,_loc1_.expertWarriorLvl,"expert warrior");
               this.setSkillButton(this.chainDist_btn,_loc1_.chainDistanceLvl,"air slash");
               this.setSkillButton(this.shield_btn,_loc1_.shieldMasteryLvl,"shield mastery");
               this.setSkillButton(this.multiAttack_btn,_loc1_.multiAttackLvl,"multi attack");
               this.setSkillButton(this.melee_btn,_loc1_.meleeKnockbackLvl,"melee knockback");
               this.setSkillButton(this.spinAttack_btn,_loc1_.spinAttackLvl,"spin attack");
               break;
            case "archer":
               this.setSkillText(this.barrage_txt,this.barrageRequired_txt,this.barrageLvl_txt,this.barrageMax_txt,_loc1_.barrageLvl,"arrow barrage","Arrows: " + _loc1_.barrageLvl);
               this.setSkillText(this.arrowKnockback_txt,this.arrowKnockbackRequired_txt,this.arrowKnockbackLvl_txt,this.arrowKnockbackMax_txt,_loc1_.arrowKnockbackLvl,"arrow knockback","Knockback: " + RoundToNearest.roundTo((8 + _loc1_.arrowKnockbackLvl) / 30,100) + " feet");
               this.setSkillText(null,this.expertArcherRequired_txt,this.expertArcherLvl_txt,this.expertArcherMax_txt,_loc1_.expertArcherLvl,"expert archer","");
               this.setSkillText(this.tripleShot_txt,this.tripleShotRequired_txt,this.tripleShotLvl_txt,this.tripleShotMax_txt,_loc1_.tripleShotLvl,"triple shot","Shooting distance: " + (6 + _loc1_.tripleShotLvl) + " feet");
               this.setSkillText(this.arrowRain_txt,this.arrowRainRequired_txt,this.arrowRainLvl_txt,this.arrowRainMax_txt,_loc1_.arrowRainLvl,"arrow rain","Number of arrows: " + _loc1_.arrowRainLvl);
               this.setSkillText(this.piercingArrow_txt,this.piercingArrowRequired_txt,this.piercingArrowLvl_txt,this.piercingArrowMax_txt,_loc1_.piercingArrowLvl,"piercing arrow","Penetrating enemies: " + _loc1_.piercingArrowLvl);
               this.setSkillText(this.downCrush_txt,this.downCrushRequired_txt,this.downCrushLvl_txt,this.downCrushMax_txt,_loc1_.downCrushLvl,"down crush","Damage: " + int((1 + _loc1_.downCrushLvl / 33) * 100) + "%");
               this.setSkillButton(this.barrage_btn,_loc1_.barrageLvl,"arrow barrage");
               this.setSkillButton(this.arrowKnockback_btn,_loc1_.arrowKnockbackLvl,"arrow knockback");
               this.setSkillButton(this.expertArcher_btn,_loc1_.expertArcherLvl,"expert archer");
               this.setSkillButton(this.tripleShot_btn,_loc1_.tripleShotLvl,"triple shot");
               this.setSkillButton(this.arrowRain_btn,_loc1_.arrowRainLvl,"arrow rain");
               this.setSkillButton(this.piercingArrow_btn,_loc1_.piercingArrowLvl,"piercing arrow");
               this.setSkillButton(this.downCrush_btn,_loc1_.downCrushLvl,"down crush");
               break;
            case "wizard":
               this.setSkillText(this.magicShots_txt,this.magicShotsRequired_txt,this.magicShotsLvl_txt,this.magicShotsMax_txt,_loc1_.magicShotsLvl,"magic shots","Projectiles: " + _loc1_.magicShotsLvl);
               this.setSkillText(null,this.expertWizardRequired_txt,this.expertWizardLvl_txt,this.expertWizardMax_txt,_loc1_.expertWizardLvl,"expert wizard","");
               this.setSkillText(this.lightBeam_txt,this.lightBeamRequired_txt,this.lightBeamLvl_txt,this.lightBeamMax_txt,_loc1_.lightBeamLvl,"circular attack","Height: " + _loc1_.lightBeamLvl * 5);
               this.setSkillText(this.magicDistance_txt,this.magicDistanceRequired_txt,this.magicDistanceLvl_txt,this.magicDistanceMax_txt,_loc1_.magicDistanceLvl,"magic distance","Distance: " + (7 + _loc1_.magicDistanceLvl) + " feet");
               this.setSkillText(this.thunder_txt,this.thunderRequired_txt,this.thunderLvl_txt,this.thunderMax_txt,_loc1_.thunderAttackLvl,"thunder attack","Max storm clouds: " + _loc1_.thunderAttackLvl);
               this.setSkillText(this.selfHeal_txt,this.selfHealRequired_txt,this.selfHealLvl_txt,this.selfHealMax_txt,_loc1_.selfHealLvl,"self heal","Health healed: " + (30 + _loc1_.selfHealLvl * 5));
               this.setSkillText(this.guildHeal_txt,this.guildHealRequired_txt,this.guildHealLvl_txt,this.guildHealMax_txt,_loc1_.guildHealLvl,"guild heal","Health healed: " + (20 + _loc1_.guildHealLvl * 5));
               this.setSkillButton(this.magicShots_btn,_loc1_.magicShotsLvl,"magic shots");
               this.setSkillButton(this.expertWizard_btn,_loc1_.expertWizardLvl,"expert wizard");
               this.setSkillButton(this.lightBeam_btn,_loc1_.lightBeamLvl,"circular attack");
               this.setSkillButton(this.magicDistance_btn,_loc1_.magicDistanceLvl,"magic distance");
               this.setSkillButton(this.thunder_btn,_loc1_.thunderAttackLvl,"thunder attack");
               this.setSkillButton(this.selfHeal_btn,_loc1_.selfHealLvl,"self heal");
               this.setSkillButton(this.guildHeal_btn,_loc1_.guildHealLvl,"guild heal");
               break;
            case "cowboy":
               this.setSkillText(this.grenade_txt,this.grenadeRequired_txt,this.grenadeLvl_txt,this.grenadeMax_txt,_loc1_.grenadeLvl,"grenade attack","Grenades: " + (_loc1_.grenadeLvl - 1));
               this.setSkillText(null,this.upwardRequired_txt,this.upwardLvl_txt,this.upwardMax_txt,_loc1_.upwardShootLvl,"upward shoot","");
               this.setSkillText(null,this.expertCowboyRequired_txt,this.expertCowboyLvl_txt,this.expertCowboyMax_txt,_loc1_.expertCowboyLvl,"expert cowboy","");
               this.setSkillText(this.bulletDistance_txt,this.bulletDistanceRequired_txt,this.bulletDistanceLvl_txt,this.bulletDistanceMax_txt,_loc1_.bulletDistanceLvl,"bullet distance","Distance: " + (69 + _loc1_.bulletDistanceLvl) + " feet");
               this.setSkillText(this.shotgun_txt,this.shotgunRequired_txt,this.shotgunLvl_txt,this.shotgunMax_txt,_loc1_.shotgunLvl,"shotgun attack","Bullets: " + _loc1_.shotgunLvl);
               this.setSkillText(this.bulletKnockback_txt,this.bulletKnockbackRequired_txt,this.bulletKnockbackLvl_txt,this.bulletKnockbackMax_txt,_loc1_.bulletKnockbackLvl,"bullet knockback","Knockback: " + RoundToNearest.roundTo((8 + _loc1_.bulletKnockbackLvl) / 30,100) + " feet");
               this.setSkillText(this.jumpGrenade_txt,this.jumpGrenadeRequired_txt,this.jumpGrenadeLvl_txt,this.jumpGrenadeMax_txt,_loc1_.jumpGrenadeLvl,"jump grenade","Damage: " + int(100 + 10 * _loc1_.jumpGrenadeLvl) + "%");
               this.setSkillButton(this.grenade_btn,_loc1_.grenadeLvl,"grenade attack");
               this.setSkillButton(this.upward_btn,_loc1_.upwardShootLvl,"upward shoot");
               this.setSkillButton(this.expertCowboy_btn,_loc1_.expertCowboyLvl,"expert cowboy");
               this.setSkillButton(this.bulletDistance_btn,_loc1_.bulletDistanceLvl,"bullet distance");
               this.setSkillButton(this.shotgun_btn,_loc1_.shotgunLvl,"shotgun attack");
               this.setSkillButton(this.bulletKnockback_btn,_loc1_.bulletKnockbackLvl,"bullet knockback");
               this.setSkillButton(this.jumpGrenade_btn,_loc1_.jumpGrenadeLvl,"jump grenade");
         }
      }
      
      public function displaySkills(param1:String) : void
      {
         var _loc2_:Person = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc38_:TextField = null;
         var _loc39_:TextField = null;
         var _loc40_:TextField = null;
         var _loc64_:String = null;
         var _loc65_:TextField = null;
         var _loc66_:TextField = null;
         var _loc67_:String = null;
         var _loc68_:TextField = null;
         var _loc69_:TextField = null;
         var _loc70_:String = null;
         var _loc71_:TextField = null;
         var _loc72_:TextField = null;
         var _loc73_:String = null;
         var _loc83_:TextField = null;
         var _loc84_:TextField = null;
         var _loc85_:TextField = null;
         var _loc86_:TextField = null;
         var _loc87_:TextField = null;
         var _loc88_:TextField = null;
         var _loc89_:TextField = null;
         var _loc90_:TextField = null;
         var _loc91_:TextField = null;
         var _loc92_:TextField = null;
         var _loc93_:TextField = null;
         var _loc94_:TextField = null;
         var _loc95_:TextField = null;
         var _loc96_:TextField = null;
         var _loc97_:TextField = null;
         var _loc98_:TextField = null;
         var _loc99_:TextField = null;
         var _loc100_:TextField = null;
         var _loc101_:TextField = null;
         var _loc102_:String = null;
         var _loc103_:String = null;
         var _loc104_:String = null;
         var _loc105_:String = null;
         var _loc106_:String = null;
         var _loc112_:TextField = null;
         var _loc113_:TextField = null;
         var _loc114_:TextField = null;
         var _loc115_:TextField = null;
         var _loc116_:TextField = null;
         var _loc117_:TextField = null;
         var _loc118_:TextField = null;
         var _loc119_:String = null;
         var _loc120_:String = null;
         var _loc121_:String = null;
         var _loc122_:String = null;
         var _loc123_:String = null;
         var _loc124_:String = null;
         var _loc125_:String = null;
         var _loc126_:TextField = null;
         var _loc127_:TextField = null;
         var _loc128_:TextField = null;
         var _loc129_:TextField = null;
         var _loc130_:TextField = null;
         var _loc131_:TextField = null;
         var _loc132_:TextField = null;
         var _loc133_:TextField = null;
         var _loc134_:TextField = null;
         var _loc135_:TextField = null;
         var _loc136_:TextField = null;
         var _loc137_:String = null;
         var _loc138_:String = null;
         var _loc139_:String = null;
         var _loc140_:String = null;
         var _loc141_:TextField = null;
         var _loc142_:TextField = null;
         var _loc143_:TextField = null;
         var _loc144_:TextField = null;
         var _loc145_:TextField = null;
         var _loc146_:TextField = null;
         var _loc147_:TextField = null;
         var _loc148_:TextField = null;
         var _loc149_:TextField = null;
         var _loc150_:TextField = null;
         var _loc151_:TextField = null;
         var _loc152_:TextField = null;
         var _loc153_:TextField = null;
         var _loc154_:TextField = null;
         var _loc155_:TextField = null;
         var _loc156_:String = null;
         var _loc157_:String = null;
         var _loc158_:String = null;
         var _loc159_:String = null;
         var _loc160_:String = null;
         var _loc161_:String = null;
         var _loc162_:String = null;
         var _loc163_:TextField = null;
         var _loc164_:TextField = null;
         var _loc165_:TextField = null;
         var _loc166_:TextField = null;
         var _loc167_:TextField = null;
         var _loc168_:TextField = null;
         var _loc169_:TextField = null;
         var _loc170_:String = null;
         var _loc171_:String = null;
         var _loc172_:String = null;
         var _loc173_:String = null;
         var _loc174_:TextField = null;
         var _loc175_:TextField = null;
         var _loc176_:TextField = null;
         var _loc177_:TextField = null;
         _loc2_ = null;
         _loc3_ = 0;
         _loc4_ = 0;
         var _loc5_:TextField = null;
         var _loc6_:TextField = null;
         var _loc7_:TextField = null;
         var _loc8_:TextField = null;
         var _loc9_:TextField = null;
         var _loc10_:TextField = null;
         var _loc11_:TextField = null;
         var _loc12_:TextField = null;
         var _loc13_:TextField = null;
         var _loc14_:TextField = null;
         var _loc15_:TextField = null;
         var _loc16_:String = null;
         var _loc17_:TextField = null;
         var _loc18_:String = null;
         var _loc19_:TextField = null;
         var _loc20_:String = null;
         var _loc21_:TextField = null;
         var _loc22_:String = null;
         var _loc23_:TextField = null;
         var _loc24_:String = null;
         var _loc25_:TextField = null;
         var _loc26_:String = null;
         var _loc27_:TextField = null;
         var _loc28_:String = null;
         var _loc29_:TextField = null;
         var _loc30_:String = null;
         var _loc31_:TextField = null;
         var _loc32_:String = null;
         var _loc33_:TextField = null;
         var _loc34_:String = null;
         var _loc35_:TextField = null;
         var _loc36_:String = null;
         var _loc37_:TextField = null;
         _loc38_ = null;
         _loc39_ = null;
         _loc40_ = null;
         var _loc41_:TextField = null;
         var _loc42_:TextField = null;
         var _loc43_:TextField = null;
         var _loc44_:TextField = null;
         var _loc45_:TextField = null;
         var _loc46_:TextField = null;
         var _loc47_:TextField = null;
         var _loc48_:TextField = null;
         var _loc49_:TextField = null;
         var _loc50_:String = null;
         var _loc51_:TextField = null;
         var _loc52_:String = null;
         var _loc53_:TextField = null;
         var _loc54_:String = null;
         var _loc55_:TextField = null;
         var _loc56_:String = null;
         var _loc57_:TextField = null;
         var _loc58_:String = null;
         var _loc59_:TextField = null;
         var _loc60_:String = null;
         var _loc61_:TextField = null;
         var _loc62_:String = null;
         var _loc63_:TextField = null;
         _loc64_ = null;
         _loc65_ = null;
         _loc66_ = null;
         _loc67_ = null;
         _loc68_ = null;
         _loc69_ = null;
         _loc70_ = null;
         _loc71_ = null;
         _loc72_ = null;
         _loc73_ = null;
         var _loc74_:TextField = null;
         var _loc75_:TextField = null;
         var _loc76_:String = null;
         var _loc77_:String = null;
         var _loc78_:String = null;
         var _loc79_:String = null;
         var _loc80_:String = null;
         var _loc81_:String = null;
         var _loc82_:String = null;
         _loc83_ = null;
         _loc84_ = null;
         _loc85_ = null;
         _loc86_ = null;
         _loc87_ = null;
         _loc88_ = null;
         _loc89_ = null;
         _loc90_ = null;
         _loc91_ = null;
         _loc92_ = null;
         _loc93_ = null;
         _loc94_ = null;
         _loc95_ = null;
         _loc96_ = null;
         _loc97_ = null;
         _loc98_ = null;
         _loc99_ = null;
         _loc100_ = null;
         _loc101_ = null;
         _loc102_ = null;
         _loc103_ = null;
         _loc104_ = null;
         _loc105_ = null;
         _loc106_ = null;
         var _loc107_:TextField = null;
         var _loc108_:TextField = null;
         var _loc109_:TextField = null;
         var _loc110_:TextField = null;
         var _loc111_:TextField = null;
         _loc112_ = null;
         _loc113_ = null;
         _loc114_ = null;
         _loc115_ = null;
         _loc116_ = null;
         _loc117_ = null;
         _loc118_ = null;
         _loc119_ = null;
         _loc120_ = null;
         _loc121_ = null;
         _loc122_ = null;
         _loc123_ = null;
         _loc124_ = null;
         _loc125_ = null;
         _loc126_ = null;
         _loc127_ = null;
         _loc128_ = null;
         _loc129_ = null;
         _loc130_ = null;
         _loc131_ = null;
         _loc132_ = null;
         _loc133_ = null;
         _loc134_ = null;
         _loc135_ = null;
         _loc136_ = null;
         _loc137_ = null;
         _loc138_ = null;
         _loc139_ = null;
         _loc140_ = null;
         _loc141_ = null;
         _loc142_ = null;
         _loc143_ = null;
         _loc144_ = null;
         _loc145_ = null;
         _loc146_ = null;
         _loc147_ = null;
         _loc148_ = null;
         _loc149_ = null;
         _loc150_ = null;
         _loc151_ = null;
         _loc152_ = null;
         _loc153_ = null;
         _loc154_ = null;
         _loc155_ = null;
         _loc156_ = null;
         _loc157_ = null;
         _loc158_ = null;
         _loc159_ = null;
         _loc160_ = null;
         _loc161_ = null;
         _loc162_ = null;
         _loc163_ = null;
         _loc164_ = null;
         _loc165_ = null;
         _loc166_ = null;
         _loc167_ = null;
         _loc168_ = null;
         _loc169_ = null;
         _loc170_ = null;
         _loc171_ = null;
         _loc172_ = null;
         _loc173_ = null;
         _loc174_ = null;
         _loc175_ = null;
         _loc176_ = null;
         _loc177_ = null;
         var _loc178_:TextField = null;
         var _loc179_:TextField = null;
         this.currentDisplay = param1;
         this.scrollArea.removeChildren(0,-1,false);
         _loc2_ = MainStarlingStage(root).gameMain.player;
         _loc3_ = 0;
         _loc4_ = 0;
         switch(param1)
         {
            case "basic":
               this.createBackdrop(6);
               this.jump_btn.y = 151;
               this.jump_btn.name = "jumpSkill_btn";
               this.scrollArea.addChild(this.jump_btn);
               this.critical_btn.y = 360;
               this.critical_btn.name = "criticalDamage_btn";
               this.scrollArea.addChild(this.critical_btn);
               this.loot_btn.y = 575;
               this.loot_btn.name = "lootSteal_btn";
               this.scrollArea.addChild(this.loot_btn);
               this.training_btn.y = 795;
               this.training_btn.name = "training_btn";
               this.scrollArea.addChild(this.training_btn);
               this.rage_btn.y = 995;
               this.rage_btn.name = "selfRage_btn";
               this.scrollArea.addChild(this.rage_btn);
               this.guildRage_btn.y = 1210;
               this.guildRage_btn.name = "guildRage_btn";
               this.scrollArea.addChild(this.guildRage_btn);
               this.mpRestore_btn.y = 1422;
               this.mpRestore_btn.name = "mpRestore_btn";
               this.scrollArea.addChild(this.mpRestore_btn);
               this.avoidance_btn.y = 1632;
               this.avoidance_btn.name = "avoidance_btn";
               this.scrollArea.addChild(this.avoidance_btn);
               this.dash_btn.y = 1844;
               this.dash_btn.name = "dash_btn";
               this.scrollArea.addChild(this.dash_btn);
               this.accel_btn.y = 2056;
               this.accel_btn.name = "accel_btn";
               this.scrollArea.addChild(this.accel_btn);
               this.block_btn.y = 2266;
               this.block_btn.name = "block_btn";
               this.scrollArea.addChild(this.block_btn);
               this.jump_btn.x = this.critical_btn.x = this.loot_btn.x = this.training_btn.x = this.rage_btn.x = this.guildRage_btn.x = this.mpRestore_btn.x = this.avoidance_btn.x = this.dash_btn.x = this.accel_btn.x = this.block_btn.x = -145;
               this.jump_btn.pivotX = this.critical_btn.pivotX = this.loot_btn.pivotX = this.training_btn.pivotX = this.rage_btn.pivotX = this.guildRage_btn.pivotX = this.mpRestore_btn.pivotX = this.avoidance_btn.pivotX = this.dash_btn.pivotX = this.accel_btn.pivotX = this.block_btn.pivotX = 8;
               this.jump_btn.pivotY = this.critical_btn.pivotY = this.loot_btn.pivotY = this.training_btn.pivotY = this.rage_btn.pivotY = this.guildRage_btn.pivotY = this.mpRestore_btn.pivotY = this.avoidance_btn.pivotY = this.dash_btn.pivotY = this.accel_btn.pivotY = this.block_btn.pivotY = 8;
               _loc5_ = new TextField(177,24,"Increased Jump Height",AllTextFormats.showBasic_textFormat);
               _loc5_.y = -17;
               this.scrollArea.addChild(_loc5_);
               _loc6_ = new TextField(191,24,"Increase Critical Damage",AllTextFormats.showBasic_textFormat);
               _loc6_.y = 195;
               this.scrollArea.addChild(_loc6_);
               _loc7_ = new TextField(99,24,"Loot Stealer",AllTextFormats.showBasic_textFormat);
               _loc7_.y = 406;
               this.scrollArea.addChild(_loc7_);
               _loc8_ = new TextField(155,24,"Rigorous Training",AllTextFormats.showBasic_textFormat);
               _loc8_.y = 628;
               this.scrollArea.addChild(_loc8_);
               _loc9_ = new TextField(77,24,"Rage Energy",AllTextFormats.showBasic_textFormat);
               _loc9_.y = 829;
               this.scrollArea.addChild(_loc9_);
               _loc10_ = new TextField(93,24,"Guild Rage",AllTextFormats.showBasic_textFormat);
               _loc10_.y = 1043;
               this.scrollArea.addChild(_loc10_);
               _loc11_ = new TextField(120,24,"MP Restoration",AllTextFormats.showBasic_textFormat);
               _loc11_.y = 1256;
               this.scrollArea.addChild(_loc11_);
               _loc12_ = new TextField(130,24,"Quick Avoidance",AllTextFormats.showBasic_textFormat);
               _loc12_.y = 1467;
               this.scrollArea.addChild(_loc12_);
               _loc13_ = new TextField(92,24,"Speed Dash",AllTextFormats.showBasic_textFormat);
               _loc13_.y = 1677;
               this.scrollArea.addChild(_loc13_);
               _loc14_ = new TextField(183,24,"Downward Acceleration",AllTextFormats.showBasic_textFormat);
               _loc14_.y = 1890;
               this.scrollArea.addChild(_loc14_);
               _loc15_ = new TextField(53,24,"Block",AllTextFormats.showBasic_textFormat);
               _loc15_.y = 2100;
               this.scrollArea.addChild(_loc15_);
               _loc5_.x = _loc6_.x = _loc7_.x = _loc8_.x = _loc9_.x = _loc10_.x = _loc11_.x = _loc12_.x = _loc13_.x = _loc14_.x = _loc15_.x = -203;
               _loc16_ = "Increases your overall jump height by approximately 0.12 feet.";
               _loc17_ = new TextField(302,40,_loc16_,AllTextFormats.info_textFormat);
               _loc17_.y = 2;
               this.scrollArea.addChild(_loc17_);
               _loc18_ = "Increases the amount of damage done from critical hits by approximately 12%.";
               _loc19_ = new TextField(302,41,_loc18_,AllTextFormats.info_textFormat);
               _loc19_.y = 214;
               this.scrollArea.addChild(_loc19_);
               _loc20_ = "Decreases the amount of time by approximately .07 seconds that you must wait before stealing someones loot.";
               _loc21_ = new TextField(302,58,_loc20_,AllTextFormats.info_textFormat);
               _loc21_.y = 424;
               this.scrollArea.addChild(_loc21_);
               _loc22_ = "Increases your strength, magic, range, artillery, and defense by 1 and increases your HP and Key by 10.";
               _loc23_ = new TextField(302,48,_loc22_,AllTextFormats.info_textFormat);
               _loc23_.y = 647;
               this.scrollArea.addChild(_loc23_);
               _loc24_ = "Increases the \"rage energy\" you get when unleashing energy.  The higher this is the slightly higher your total unleashing energy will be, making more powerful when unleashing.";
               _loc25_ = new TextField(302,126,_loc24_,AllTextFormats.info_textFormat);
               _loc25_.y = 849;
               this.scrollArea.addChild(_loc25_);
               _loc26_ = "Boosts power, range, and magic of all guild members present (including you) by 25%  Increases by 1 second. \n \n note: Stat bonuses from guild rage can stack with those from self rage.  Use T to initiate.";
               _loc27_ = new TextField(302,108,_loc26_,AllTextFormats.info_textFormat);
               _loc27_.y = 1061;
               this.scrollArea.addChild(_loc27_);
               _loc28_ = "Restores MP every 30 seconds.  2 points increases Key that is restored by 3.";
               _loc29_ = new TextField(302,58,_loc28_,AllTextFormats.info_textFormat);
               _loc29_.y = 1272;
               this.scrollArea.addChild(_loc29_);
               _loc30_ = "Avoidance is the chance that you will dodge an attack.  Two skill points will increase this by 1%.";
               _loc31_ = new TextField(302,41,_loc30_,AllTextFormats.info_textFormat);
               _loc31_.y = 1490;
               this.scrollArea.addChild(_loc31_);
               _loc32_ = "Speed dash is activated by double tapping the directional keys.  Each point increases your speed by .1.";
               _loc33_ = new TextField(302,58,_loc32_,AllTextFormats.info_textFormat);
               _loc33_.y = 1705;
               this.scrollArea.addChild(_loc33_);
               _loc34_ = "Accelerates your drop speed by pressing down in the air.  If you press down while your player is falling rather than rising, the downward acceleration is even greater (as noted by the first and second values).  Each level increase the effectiveness by 10%.";
               _loc35_ = new TextField(302,125,_loc34_,AllTextFormats.info_textFormat);
               _loc35_.y = 1907;
               this.scrollArea.addChild(_loc35_);
               _loc36_ = "Enables your character to withstand damage.  When an attack is dealt while you are blocking, the damage is reduced by the amount shown below.  An additional 10% is added when using a shield.  Each level increases the percent by one.";
               _loc37_ = new TextField(302,125,_loc36_,AllTextFormats.info_textFormat);
               _loc37_.y = 2120;
               this.scrollArea.addChild(_loc37_);
               _loc17_.x = _loc19_.x = _loc21_.x = _loc23_.x = _loc25_.x = _loc27_.x = _loc29_.x = _loc31_.x = _loc33_.x = _loc35_.x = _loc37_.x = 60;
               this.jumpLvl_txt.y = this.jumpRequired_txt.y = this.jumpMax_txt.y = 142;
               this.scrollArea.addChild(this.jumpLvl_txt);
               this.scrollArea.addChild(this.jumpRequired_txt);
               this.scrollArea.addChild(this.jumpMax_txt);
               this.criticalLvl_txt.y = this.criticalRequired_txt.y = this.criticalMax_txt.y = 352;
               this.scrollArea.addChild(this.criticalLvl_txt);
               this.scrollArea.addChild(this.criticalRequired_txt);
               this.scrollArea.addChild(this.criticalMax_txt);
               this.lootLvl_txt.y = this.lootRequired_txt.y = this.lootMax_txt.y = 565;
               this.scrollArea.addChild(this.lootLvl_txt);
               this.scrollArea.addChild(this.lootRequired_txt);
               this.scrollArea.addChild(this.lootMax_txt);
               this.trainingLvl_txt.y = this.trainingRequired_txt.y = this.trainingMax_txt.y = 785;
               this.scrollArea.addChild(this.trainingLvl_txt);
               this.scrollArea.addChild(this.trainingRequired_txt);
               this.scrollArea.addChild(this.trainingMax_txt);
               this.rageLvl_txt.y = this.rageRequired_txt.y = this.rageMax_txt.y = 987;
               this.scrollArea.addChild(this.rageLvl_txt);
               this.scrollArea.addChild(this.rageRequired_txt);
               this.scrollArea.addChild(this.rageMax_txt);
               this.guildRageLvl_txt.y = this.guildRageRequired_txt.y = this.guildRageMax_txt.y = 1202;
               this.scrollArea.addChild(this.guildRageLvl_txt);
               this.scrollArea.addChild(this.guildRageRequired_txt);
               this.scrollArea.addChild(this.guildRageMax_txt);
               this.mpRestoreLvl_txt.y = this.mpRestoreRequired_txt.y = this.mpRestoreMax_txt.y = 1413;
               this.scrollArea.addChild(this.mpRestoreLvl_txt);
               this.scrollArea.addChild(this.mpRestoreRequired_txt);
               this.scrollArea.addChild(this.mpRestoreMax_txt);
               this.avoidabilityLvl_txt.y = this.avoidabilityRequired_txt.y = this.avoidabilityMax_txt.y = 1622;
               this.scrollArea.addChild(this.avoidabilityLvl_txt);
               this.scrollArea.addChild(this.avoidabilityRequired_txt);
               this.scrollArea.addChild(this.avoidabilityMax_txt);
               this.dashLvl_txt.y = this.dashRequired_txt.y = this.dashMax_txt.y = 1836;
               this.scrollArea.addChild(this.dashLvl_txt);
               this.scrollArea.addChild(this.dashRequired_txt);
               this.scrollArea.addChild(this.dashMax_txt);
               this.accelLvl_txt.y = this.accelRequired_txt.y = this.accelMax_txt.y = 2046;
               this.scrollArea.addChild(this.accelLvl_txt);
               this.scrollArea.addChild(this.accelRequired_txt);
               this.scrollArea.addChild(this.accelMax_txt);
               this.blockLvl_txt.y = this.blockRequired_txt.y = this.blockMax_txt.y = 2258;
               this.scrollArea.addChild(this.blockLvl_txt);
               this.scrollArea.addChild(this.blockRequired_txt);
               this.scrollArea.addChild(this.blockMax_txt);
               this.jumpLvl_txt.x = this.criticalLvl_txt.x = this.lootLvl_txt.x = this.trainingLvl_txt.x = this.rageLvl_txt.x = this.guildRageLvl_txt.x = this.mpRestoreLvl_txt.x = this.avoidabilityLvl_txt.x = this.dashLvl_txt.x = this.accelLvl_txt.x = this.blockLvl_txt.x = -201;
               this.jumpRequired_txt.x = this.criticalRequired_txt.x = this.lootRequired_txt.x = this.trainingRequired_txt.x = this.rageRequired_txt.x = this.guildRageRequired_txt.x = this.mpRestoreRequired_txt.x = this.avoidabilityRequired_txt.x = this.dashRequired_txt.x = this.accelRequired_txt.x = this.blockRequired_txt.x = 22;
               this.jumpMax_txt.x = this.criticalMax_txt.x = this.lootMax_txt.x = this.trainingMax_txt.x = this.rageMax_txt.x = this.guildRageMax_txt.x = this.mpRestoreMax_txt.x = this.avoidabilityMax_txt.x = this.dashMax_txt.x = this.accelMax_txt.x = this.blockMax_txt.x = 232;
               this.jumpHeight_txt.y = 162;
               this.scrollArea.addChild(this.jumpHeight_txt);
               this.criticalDamage_txt.y = 369;
               this.scrollArea.addChild(this.criticalDamage_txt);
               this.lootTime_txt.y = 585;
               this.scrollArea.addChild(this.lootTime_txt);
               this.rage_txt.y = 1006;
               this.scrollArea.addChild(this.rage_txt);
               this.scrollArea.addChild(this.guildRage_txt);
               this.mpRestore_txt.y = 1434;
               this.scrollArea.addChild(this.mpRestore_txt);
               this.avoidability_txt.y = 1644;
               this.scrollArea.addChild(this.avoidability_txt);
               this.scrollArea.addChild(this.dash_txt);
               this.accel_txt.y = 2068;
               this.scrollArea.addChild(this.accel_txt);
               this.scrollArea.addChild(this.block_txt);
               this.jumpHeight_txt.x = this.criticalDamage_txt.x = this.lootTime_txt.x = this.rage_txt.x = this.guildRage_txt.x = this.mpRestore_txt.x = this.avoidability_txt.x = this.dash_txt.x = this.accel_txt.x = this.block_txt.x = -202;
               _loc38_ = new TextField(53,21,"MP: " + _loc2_.levelMP(Person.GUILD_RAGE_MP),AllTextFormats.skill_textFormat);
               this.scrollArea.addChild(_loc38_);
               _loc39_ = new TextField(53,21,"MP: 0",AllTextFormats.skill_textFormat);
               this.scrollArea.addChild(_loc39_);
               _loc40_ = new TextField(53,21,"MP: " + _loc2_.levelMP(Person.BLOCK_MP),AllTextFormats.skill_textFormat);
               this.scrollArea.addChild(_loc40_);
               _loc40_.x = _loc39_.x = _loc38_.x = 22;
               if(GameMain.isMobile == false)
               {
                  _loc178_ = new TextField(82,19,"use: T key",AllTextFormats.skill_textFormat);
                  _loc178_.x = this.guildRageMax_txt.x;
                  this.guildRage_txt.y = _loc38_.y = _loc178_.y = 1220;
                  this.scrollArea.addChild(_loc178_);
                  _loc179_ = new TextField(73,19,"use: V key",AllTextFormats.skill_textFormat);
                  _loc179_.x = this.blockMax_txt.x;
                  _loc40_.y = _loc179_.y = this.block_txt.y = 2278;
                  this.scrollArea.addChild(_loc179_);
               }
               _loc41_ = new TextField(157,19,"use: double tap forward",AllTextFormats.skill_textFormat);
               _loc41_.x = this.dashMax_txt.x;
               _loc41_.y = _loc39_.y = this.dash_txt.y = 1856;
               this.scrollArea.addChild(_loc41_);
               _loc42_ = new TextField(148,19,"use: press down in air",AllTextFormats.skill_textFormat);
               _loc42_.x = this.accelMax_txt.x;
               _loc42_.y = this.accel_txt.y;
               this.scrollArea.addChild(_loc42_);
               break;
            case "warrior":
               this.createBackdrop(4);
               this.power_btn.y = 150;
               this.power_btn.name = "powerAttack_btn";
               this.scrollArea.addChild(this.power_btn);
               this.expertWarrior_btn.y = 371;
               this.expertWarrior_btn.name = "expertWarrior_btn";
               this.scrollArea.addChild(this.expertWarrior_btn);
               this.multiAttack_btn.y = 574;
               this.multiAttack_btn.name = "multiAttack_btn";
               this.scrollArea.addChild(this.multiAttack_btn);
               this.chainDist_btn.y = 788;
               this.chainDist_btn.name = "chainDistance_btn";
               this.scrollArea.addChild(this.chainDist_btn);
               this.shield_btn.y = 997;
               this.shield_btn.name = "shieldMastery_btn";
               this.scrollArea.addChild(this.shield_btn);
               this.melee_btn.y = 1209;
               this.melee_btn.name = "meleeKnockback_btn";
               this.scrollArea.addChild(this.melee_btn);
               this.spinAttack_btn.y = 1423;
               this.spinAttack_btn.name = "spinAttack_btn";
               this.scrollArea.addChild(this.spinAttack_btn);
               this.spinAttack_btn.x = this.melee_btn.x = this.shield_btn.x = this.multiAttack_btn.x = this.chainDist_btn.x = this.expertWarrior_btn.x = this.power_btn.x = -146;
               this.spinAttack_btn.pivotX = this.melee_btn.pivotX = this.shield_btn.pivotX = this.multiAttack_btn.pivotX = this.expertWarrior_btn.pivotX = this.power_btn.pivotX = 8;
               this.spinAttack_btn.pivotY = this.melee_btn.pivotY = this.shield_btn.pivotY = this.multiAttack_btn.pivotY = this.expertWarrior_btn.pivotY = this.power_btn.pivotY = 8;
               _loc43_ = new TextField(115,24,"Power Attack",AllTextFormats.showWarrior_textFormat);
               _loc43_.y = -16;
               this.scrollArea.addChild(_loc43_);
               _loc44_ = new TextField(135,24,"Expert Warrior",AllTextFormats.showWarrior_textFormat);
               _loc44_.y = 207;
               this.scrollArea.addChild(_loc44_);
               _loc45_ = new TextField(109,24,"Multi-Attack",AllTextFormats.showWarrior_textFormat);
               _loc45_.y = 409;
               this.scrollArea.addChild(_loc45_);
               _loc46_ = new TextField(126,24,"Air Power Slash",AllTextFormats.showWarrior_textFormat);
               _loc46_.y = 623;
               this.scrollArea.addChild(_loc46_);
               _loc47_ = new TextField(113,24,"Shield Mastery",AllTextFormats.showWarrior_textFormat);
               _loc47_.y = 831;
               this.scrollArea.addChild(_loc47_);
               _loc48_ = new TextField(129,25,"Melee Knockback",AllTextFormats.showWarrior_textFormat);
               _loc48_.y = 1043;
               this.scrollArea.addChild(_loc48_);
               _loc49_ = new TextField(126,24,"Spinning Cutter",AllTextFormats.showWarrior_textFormat);
               _loc49_.y = 1253;
               this.scrollArea.addChild(_loc49_);
               _loc49_.x = _loc48_.x = _loc47_.x = _loc46_.x = _loc45_.x = _loc44_.x = _loc43_.x = -202;
               _loc50_ = "A single attack that damages an enemy more than a normal attack. One point increases damage 2%.";
               _loc51_ = new TextField(302,58,_loc50_,AllTextFormats.info_textFormat);
               _loc51_.y = 7;
               this.scrollArea.addChild(_loc51_);
               _loc52_ = "Increase your power stat by one.";
               _loc53_ = new TextField(302,24,_loc52_,AllTextFormats.info_textFormat);
               _loc53_.y = 229;
               this.scrollArea.addChild(_loc53_);
               _loc54_ = "A special attack that pounds your weapon into the ground damaging nearby grounded enemies.  Each level increases the amount of possible chained enemies by 1.  (80 foot radius)";
               _loc55_ = new TextField(302,92,_loc54_,AllTextFormats.info_textFormat);
               _loc55_.y = 434;
               this.scrollArea.addChild(_loc55_);
               _loc56_ = "Creates a powerful swing thrusting your weapon and body downward onto enemies.  Each level increases the damage by 3%.";
               _loc57_ = new TextField(302,58,_loc56_,AllTextFormats.info_textFormat);
               _loc57_.y = 643;
               this.scrollArea.addChild(_loc57_);
               _loc58_ = "Increases the effectiveness of shields by multiplying the defense of the shield by the \"shield bonus\".  1 point increases bonus by 2%.";
               _loc59_ = new TextField(302,58,_loc58_,AllTextFormats.info_textFormat);
               _loc59_.y = 852;
               this.scrollArea.addChild(_loc59_);
               _loc60_ = "Increases the distance that enemies are knocked back from melee attacks by 0.03 feet per point.";
               _loc61_ = new TextField(302,58,_loc60_,AllTextFormats.info_textFormat);
               _loc61_.y = 1063;
               this.scrollArea.addChild(_loc61_);
               _loc62_ = "An upward spinning attack that can cause multiple damage to one or several enemies.  Each point increases the amount of damage by 1%.  This percent is the amount of damage one hit from this attack does as compared to a normal melee attack.";
               _loc63_ = new TextField(302,108,_loc62_,AllTextFormats.info_textFormat);
               _loc63_.y = 1275;
               this.scrollArea.addChild(_loc63_);
               _loc63_.x = _loc61_.x = _loc59_.x = _loc57_.x = _loc55_.x = _loc53_.x = _loc51_.x = 55;
               this.powerLvl_txt.y = this.powerRequired_txt.y = this.powerMax_txt.y = 142;
               this.scrollArea.addChild(this.powerLvl_txt);
               this.scrollArea.addChild(this.powerRequired_txt);
               this.scrollArea.addChild(this.powerMax_txt);
               _loc64_ = GameMain.isMobile ? "use: Forward + attack" : "use: Forward + space or B";
               _loc65_ = new TextField(53,19,"MP: " + _loc2_.levelMP(Person.POWER_ATTACK_MP),AllTextFormats.skill_textFormat);
               _loc66_ = new TextField(165,19,_loc64_,AllTextFormats.skill_textFormat);
               _loc65_.y = _loc66_.y = this.power_txt.y = 163;
               this.scrollArea.addChild(_loc65_);
               this.scrollArea.addChild(this.power_txt);
               this.scrollArea.addChild(_loc66_);
               this.expertWarriorLvl_txt.y = this.expertWarriorRequired_txt.y = this.expertWarriorMax_txt.y = 361;
               this.scrollArea.addChild(this.expertWarriorLvl_txt);
               this.scrollArea.addChild(this.expertWarriorRequired_txt);
               this.scrollArea.addChild(this.expertWarriorMax_txt);
               _loc67_ = GameMain.isMobile ? "use: down + attack" : "use: down + space or N";
               _loc68_ = new TextField(66,19,"MP: " + _loc2_.levelMP(Person.MULTI_ATTACK_MP),AllTextFormats.skill_textFormat);
               _loc69_ = new TextField(155,19,_loc67_,AllTextFormats.skill_textFormat);
               this.multiAttack_txt.y = _loc68_.y = _loc69_.y = 585;
               this.scrollArea.addChild(_loc68_);
               this.scrollArea.addChild(_loc69_);
               this.scrollArea.addChild(this.multiAttack_txt);
               this.multiAttackLvl_txt.y = this.multiAttackRequired_txt.y = this.multiAttackMax_txt.y = 566;
               this.scrollArea.addChild(this.multiAttackLvl_txt);
               this.scrollArea.addChild(this.multiAttackRequired_txt);
               this.scrollArea.addChild(this.multiAttackMax_txt);
               this.chainDistLvl_txt.y = this.chainDistRequired_txt.y = this.chainDistMax_txt.y = 778;
               this.scrollArea.addChild(this.chainDistLvl_txt);
               this.scrollArea.addChild(this.chainDistRequired_txt);
               this.scrollArea.addChild(this.chainDistMax_txt);
               _loc70_ = GameMain.isMobile ? "use: down + attack (air)" : "use: space + down or N (air)";
               _loc71_ = new TextField(62,19,"MP: " + _loc2_.levelMP(Person.AIR_SLASH_MP),AllTextFormats.skill_textFormat);
               _loc72_ = new TextField(175,19,_loc70_,AllTextFormats.skill_textFormat);
               _loc71_.y = _loc72_.y = this.chainDistance_txt.y = 798;
               this.scrollArea.addChild(_loc71_);
               this.scrollArea.addChild(_loc72_);
               this.scrollArea.addChild(this.chainDistance_txt);
               this.shieldLvl_txt.y = this.shieldRequired_txt.y = this.shieldMax_txt.y = 990;
               this.scrollArea.addChild(this.shieldLvl_txt);
               this.scrollArea.addChild(this.shieldRequired_txt);
               this.scrollArea.addChild(this.shieldMax_txt);
               this.shield_txt.y = 1008;
               this.scrollArea.addChild(this.shield_txt);
               this.meleeKnockback_txt.y = 1220;
               this.scrollArea.addChild(this.meleeKnockback_txt);
               this.meleeLvl_txt.y = this.meleeRequired_txt.y = this.meleeMax_txt.y = 1199;
               this.scrollArea.addChild(this.meleeLvl_txt);
               this.scrollArea.addChild(this.meleeRequired_txt);
               this.scrollArea.addChild(this.meleeMax_txt);
               this.spinningLvl_txt.y = this.spinningRequired_txt.y = this.spinningMax_txt.y = 1413;
               this.scrollArea.addChild(this.spinningLvl_txt);
               this.scrollArea.addChild(this.spinningRequired_txt);
               this.scrollArea.addChild(this.spinningMax_txt);
               _loc73_ = GameMain.isMobile ? "use: up + attack" : "use: space + up or M";
               _loc74_ = new TextField(53,19,"MP: " + _loc2_.levelMP(Person.SPIN_ATTACK_MP),AllTextFormats.skill_textFormat);
               _loc75_ = new TextField(140,19,_loc73_,AllTextFormats.skill_textFormat);
               _loc75_.y = _loc74_.y = this.spinning_txt.y = 1434;
               this.scrollArea.addChild(_loc75_);
               this.scrollArea.addChild(this.spinning_txt);
               this.scrollArea.addChild(_loc74_);
               this.power_txt.x = this.multiAttack_txt.x = this.chainDistance_txt.x = this.shield_txt.x = this.meleeKnockback_txt.x = this.spinning_txt.x = 22;
               _loc74_.x = _loc65_.x = _loc68_.x = _loc71_.x = 22;
               _loc66_.x = _loc69_.x = _loc72_.x = _loc75_.x = 202;
               this.powerLvl_txt.x = this.expertWarriorLvl_txt.x = this.multiAttackLvl_txt.x = this.chainDistLvl_txt.x = this.shieldLvl_txt.x = this.meleeLvl_txt.x = this.spinningLvl_txt.x = -202;
               this.powerRequired_txt.x = this.expertWarriorRequired_txt.x = this.multiAttackRequired_txt.x = this.chainDistRequired_txt.x = this.shieldRequired_txt.x = this.meleeRequired_txt.x = this.spinningRequired_txt.x = 22;
               this.powerMax_txt.x = this.expertWarriorMax_txt.x = this.multiAttackMax_txt.x = this.chainDistMax_txt.x = this.shieldMax_txt.x = this.meleeMax_txt.x = this.spinningMax_txt.x = 202;
               this.power_txt.x = this.multiAttack_txt.x = this.chainDistance_txt.x = this.shield_txt.x = this.meleeKnockback_txt.x = this.spinning_txt.x = -201;
               break;
            case "archer":
               this.createBackdrop(4);
               this.barrage_btn.y = 152;
               this.arrowKnockback_btn.y = 364;
               this.expertArcher_btn.y = 586;
               this.tripleShot_btn.y = 783;
               this.arrowRain_btn.y = 997;
               this.piercingArrow_btn.y = 1206;
               this.downCrush_btn.y = 1420;
               this.barrage_btn.name = "barrage_btn";
               this.arrowKnockback_btn.name = "arrowKnockback_btn";
               this.expertArcher_btn.name = "expertArcher_btn";
               this.tripleShot_btn.name = "tripleShot_btn";
               this.arrowRain_btn.name = "arrowRain_btn";
               this.piercingArrow_btn.name = "piercingArrow_btn";
               this.downCrush_btn.name = "downCrush_btn";
               this.scrollArea.addChild(this.barrage_btn);
               this.scrollArea.addChild(this.arrowKnockback_btn);
               this.scrollArea.addChild(this.expertArcher_btn);
               this.scrollArea.addChild(this.tripleShot_btn);
               this.scrollArea.addChild(this.arrowRain_btn);
               this.scrollArea.addChild(this.piercingArrow_btn);
               this.scrollArea.addChild(this.downCrush_btn);
               _loc76_ = "Increases the amount of arrows you shoot when fully charged by one.";
               _loc77_ = "Increases the distance that enemies are knocked back from ranged attacks by approximately .03 feet. \n \n note: Arrow knockback bonuses are NOT applied when attacking other players in PVP.";
               _loc78_ = "Increases your range stat by one.";
               _loc79_ = "Shoots 3 arrows one after another.  Two points increases the distance by 1 foot.";
               _loc80_ = "An attack that rains arrows down on enemies.  Four points increases the number of arrows 1.";
               _loc81_ = "An attack that forces the arrow to travel through multiple enemies.  3 points increases enemies by 1.";
               _loc82_ = "A downward air attack, it sends your plummeting towards the ground launching four arrows outward upon impact.  You slam your bow and arrow into enemies dealing greater damage than a normal attack.  Each level increases the damage by 3%.";
               _loc83_ = new TextField(188,24,"Charged Arrow Barrage",AllTextFormats.showArcher_textFormat);
               _loc84_ = new TextField(185,24,"Arrow Knockback",AllTextFormats.showArcher_textFormat);
               _loc85_ = new TextField(114,24,"Expert Archer",AllTextFormats.showArcher_textFormat);
               _loc86_ = new TextField(144,24,"Triple Shot Attack",AllTextFormats.showArcher_textFormat);
               _loc87_ = new TextField(153,24,"Arrow Rain Attack",AllTextFormats.showArcher_textFormat);
               _loc88_ = new TextField(177,24,"Piercing Arrow Attack",AllTextFormats.showArcher_textFormat);
               _loc89_ = new TextField(177,24,"Down Crush",AllTextFormats.showArcher_textFormat);
               _loc90_ = new TextField(302,41,_loc76_,AllTextFormats.info_textFormat);
               _loc91_ = new TextField(302,108,_loc77_,AllTextFormats.info_textFormat);
               _loc92_ = new TextField(302,24,_loc78_,AllTextFormats.info_textFormat);
               _loc93_ = new TextField(302,41,_loc79_,AllTextFormats.info_textFormat);
               _loc94_ = new TextField(302,41,_loc80_,AllTextFormats.info_textFormat);
               _loc95_ = new TextField(302,58,_loc81_,AllTextFormats.info_textFormat);
               _loc96_ = new TextField(302,108,_loc82_,AllTextFormats.info_textFormat);
               _loc83_.y = -14;
               _loc84_.y = 199;
               _loc85_.y = 420;
               _loc86_.y = 619;
               _loc87_.y = 833;
               _loc88_.y = 1041;
               _loc89_.y = 1256;
               _loc90_.y = 8;
               _loc91_.y = 219;
               _loc92_.y = 442;
               _loc93_.y = 640;
               _loc94_.y = 853;
               _loc95_.y = 1062;
               _loc96_.y = 1278;
               this.scrollArea.addChild(_loc83_);
               this.scrollArea.addChild(_loc84_);
               this.scrollArea.addChild(_loc85_);
               this.scrollArea.addChild(_loc86_);
               this.scrollArea.addChild(_loc87_);
               this.scrollArea.addChild(_loc88_);
               this.scrollArea.addChild(_loc89_);
               this.scrollArea.addChild(_loc90_);
               this.scrollArea.addChild(_loc91_);
               this.scrollArea.addChild(_loc92_);
               this.scrollArea.addChild(_loc93_);
               this.scrollArea.addChild(_loc94_);
               this.scrollArea.addChild(_loc95_);
               this.scrollArea.addChild(_loc96_);
               this.scrollArea.addChild(this.barrageLvl_txt);
               this.scrollArea.addChild(this.barrageRequired_txt);
               this.scrollArea.addChild(this.barrageMax_txt);
               this.scrollArea.addChild(this.barrage_txt);
               this.scrollArea.addChild(this.arrowKnockbackLvl_txt);
               this.scrollArea.addChild(this.arrowKnockbackRequired_txt);
               this.scrollArea.addChild(this.arrowKnockbackMax_txt);
               this.scrollArea.addChild(this.arrowKnockback_txt);
               this.scrollArea.addChild(this.expertArcherLvl_txt);
               this.scrollArea.addChild(this.expertArcherRequired_txt);
               this.scrollArea.addChild(this.expertArcherMax_txt);
               this.scrollArea.addChild(this.tripleShotLvl_txt);
               this.scrollArea.addChild(this.tripleShotRequired_txt);
               this.scrollArea.addChild(this.tripleShotMax_txt);
               this.scrollArea.addChild(this.tripleShot_txt);
               this.scrollArea.addChild(this.arrowRainLvl_txt);
               this.scrollArea.addChild(this.arrowRainRequired_txt);
               this.scrollArea.addChild(this.arrowRainMax_txt);
               this.scrollArea.addChild(this.arrowRain_txt);
               this.scrollArea.addChild(this.piercingArrowLvl_txt);
               this.scrollArea.addChild(this.piercingArrowRequired_txt);
               this.scrollArea.addChild(this.piercingArrowMax_txt);
               this.scrollArea.addChild(this.piercingArrow_txt);
               this.scrollArea.addChild(this.downCrushLvl_txt);
               this.scrollArea.addChild(this.downCrushRequired_txt);
               this.scrollArea.addChild(this.downCrushMax_txt);
               this.scrollArea.addChild(this.downCrush_txt);
               _loc97_ = new TextField(59,19,"MP: " + _loc2_.levelMP(Person.ARROW_BARRAGE_MP),AllTextFormats.skill_textFormat);
               _loc98_ = new TextField(59,19,"MP: " + _loc2_.levelMP(Person.ARROW_TRIPLE_MP),AllTextFormats.skill_textFormat);
               _loc99_ = new TextField(59,19,"MP: " + _loc2_.levelMP(Person.ARROW_RAIN_MP),AllTextFormats.skill_textFormat);
               _loc100_ = new TextField(59,19,"MP: " + _loc2_.levelMP(Person.ARROW_PIERCE_MP),AllTextFormats.skill_textFormat);
               _loc101_ = new TextField(59,19,"MP: " + _loc2_.levelMP(Person.DOWN_CRUSH_MP),AllTextFormats.skill_textFormat);
               _loc102_ = GameMain.isMobile ? "use: hold attack" : "use: hold space";
               _loc103_ = GameMain.isMobile ? "use: down + attack" : "use: space + down or N";
               _loc104_ = GameMain.isMobile ? "use: up + attack" : "use: space + up or M";
               _loc105_ = GameMain.isMobile ? "use: forward + attack" : "use: space + forward or B";
               _loc106_ = GameMain.isMobile ? "use: down + attack (air)" : "use: space + down or M (air)";
               _loc107_ = new TextField(107,19,_loc102_,AllTextFormats.skill_textFormat);
               _loc108_ = new TextField(153,19,_loc103_,AllTextFormats.skill_textFormat);
               _loc109_ = new TextField(145,19,_loc104_,AllTextFormats.skill_textFormat);
               _loc110_ = new TextField(166,19,_loc105_,AllTextFormats.skill_textFormat);
               _loc111_ = new TextField(174,19,_loc106_,AllTextFormats.skill_textFormat);
               this.scrollArea.addChild(_loc97_);
               this.scrollArea.addChild(_loc98_);
               this.scrollArea.addChild(_loc99_);
               this.scrollArea.addChild(_loc100_);
               this.scrollArea.addChild(_loc101_);
               this.scrollArea.addChild(_loc107_);
               this.scrollArea.addChild(_loc108_);
               this.scrollArea.addChild(_loc109_);
               this.scrollArea.addChild(_loc110_);
               this.scrollArea.addChild(_loc111_);
               this.barrageLvl_txt.y = this.barrageRequired_txt.y = this.barrageMax_txt.y = 142;
               this.barrage_txt.y = _loc97_.y = _loc107_.y = 162;
               this.arrowKnockbackLvl_txt.y = this.arrowKnockbackRequired_txt.y = this.arrowKnockbackMax_txt.y = 354;
               this.arrowKnockback_txt.y = 375;
               this.expertArcherLvl_txt.y = this.expertArcherRequired_txt.y = this.expertArcherMax_txt.y = 576;
               this.tripleShotLvl_txt.y = this.tripleShotRequired_txt.y = this.tripleShotMax_txt.y = 773;
               this.tripleShot_txt.y = _loc98_.y = _loc108_.y = 795;
               this.arrowRainLvl_txt.y = this.arrowRainRequired_txt.y = this.arrowRainMax_txt.y = 988;
               this.arrowRain_txt.y = _loc99_.y = _loc109_.y = 1009;
               this.piercingArrowLvl_txt.y = this.piercingArrowRequired_txt.y = this.piercingArrowMax_txt.y = 1196;
               this.piercingArrow_txt.y = _loc100_.y = _loc110_.y = 1217;
               this.downCrushLvl_txt.y = this.downCrushRequired_txt.y = this.downCrushMax_txt.y = 1411;
               this.downCrush_txt.y = _loc101_.y = _loc111_.y = 1432;
               this.barrage_btn.pivotX = this.arrowKnockback_btn.pivotX = this.expertArcher_btn.pivotX = this.tripleShot_btn.pivotX = this.arrowRain_btn.pivotX = this.piercingArrow_btn.pivotX = this.downCrush_btn.pivotX = 8;
               this.barrage_btn.pivotY = this.arrowKnockback_btn.pivotY = this.expertArcher_btn.pivotY = this.tripleShot_btn.pivotY = this.arrowRain_btn.pivotY = this.piercingArrow_btn.pivotY = this.downCrush_btn.pivotY = 8;
               this.barrage_btn.x = this.arrowKnockback_btn.x = this.expertArcher_btn.x = this.tripleShot_btn.x = this.arrowRain_btn.x = this.piercingArrow_btn.x = this.downCrush_btn.x = -147;
               _loc83_.x = _loc84_.x = _loc85_.x = _loc86_.x = _loc87_.x = _loc88_.x = _loc89_.x = -207;
               _loc90_.x = _loc91_.x = _loc92_.x = _loc93_.x = _loc94_.x = _loc95_.x = _loc96_.x = 56;
               this.barrageLvl_txt.x = this.arrowKnockbackLvl_txt.x = this.expertArcherLvl_txt.x = this.tripleShotLvl_txt.x = this.arrowRainLvl_txt.x = this.piercingArrowLvl_txt.x = this.downCrushLvl_txt.x = -204;
               this.barrageRequired_txt.x = this.arrowKnockbackRequired_txt.x = this.expertArcherRequired_txt.x = this.tripleShotRequired_txt.x = this.arrowRainRequired_txt.x = this.piercingArrowRequired_txt.x = this.downCrushRequired_txt.x = 22;
               this.barrageMax_txt.x = this.arrowKnockbackMax_txt.x = this.expertArcherMax_txt.x = this.tripleShotMax_txt.x = this.arrowRainRequired_txt.x = this.piercingArrowMax_txt.x = this.downCrushMax_txt.x = 202;
               this.barrage_txt.x = this.arrowKnockback_txt.x = this.tripleShot_txt.x = this.arrowRain_txt.x = this.piercingArrow_txt.x = this.downCrush_txt.x = -204;
               _loc97_.x = _loc98_.x = _loc100_.x = _loc101_.x = 22;
               _loc107_.x = _loc108_.x = _loc109_.x = _loc110_.x = _loc111_.x = 202;
               break;
            case "wizard":
               this.createBackdrop(4);
               this.magicShots_btn.name = "magicShots_btn";
               this.expertWizard_btn.name = "expertWizard_btn";
               this.lightBeam_btn.name = "circularMagic_btn";
               this.magicDistance_btn.name = "magicDistance_btn";
               this.thunder_btn.name = "thunderMagic_btn";
               this.selfHeal_btn.name = "selfHeal_btn";
               this.guildHeal_btn.name = "guildHeal_btn";
               this.magicShots_btn.y = 153;
               this.expertWizard_btn.y = 372;
               this.lightBeam_btn.y = 574;
               this.magicDistance_btn.y = 788;
               this.thunder_btn.y = 995;
               this.selfHeal_btn.y = 1208;
               this.guildHeal_btn.y = 1422;
               this.scrollArea.addChild(this.magicShots_btn);
               this.scrollArea.addChild(this.expertWizard_btn);
               this.scrollArea.addChild(this.lightBeam_btn);
               this.scrollArea.addChild(this.magicDistance_btn);
               this.scrollArea.addChild(this.thunder_btn);
               this.scrollArea.addChild(this.selfHeal_btn);
               this.scrollArea.addChild(this.guildHeal_btn);
               _loc112_ = new TextField(120,24,"Magic Shots",AllTextFormats.showWizard_textFormat);
               _loc113_ = new TextField(119,24,"Expert Wizard",AllTextFormats.showWizard_textFormat);
               _loc114_ = new TextField(91,24,"Light Beam",AllTextFormats.showWizard_textFormat);
               _loc115_ = new TextField(123,24,"Magic Distance",AllTextFormats.showWizard_textFormat);
               _loc116_ = new TextField(136,24,"Thunder Attack",AllTextFormats.showWizard_textFormat);
               _loc117_ = new TextField(74,24,"Self Heal",AllTextFormats.showWizard_textFormat);
               _loc118_ = new TextField(112,24,"Pet/Guild Heal",AllTextFormats.showWizard_textFormat);
               this.scrollArea.addChild(_loc112_);
               this.scrollArea.addChild(_loc113_);
               this.scrollArea.addChild(_loc114_);
               this.scrollArea.addChild(_loc115_);
               this.scrollArea.addChild(_loc116_);
               this.scrollArea.addChild(_loc117_);
               this.scrollArea.addChild(_loc118_);
               _loc119_ = "Increases the amount of magic projectiles released when attacking by one. \n\n note: Magic shots deal 70% the damage as a direct hit from your magical weapon.";
               _loc120_ = "Increase your magic stat by one.";
               _loc121_ = "Each level increases the height of your light beam by 5 feet .  Deals 200% the damage of a normal attack.";
               _loc122_ = "Increases the flying distance of your magic projectiles by 1 foot per point used.";
               _loc123_ = "A special attack that summons lightning that attacks nearby enemies.  One cloud per enemy. \n\n note: Each lightning deals 150% the damage of your primary magic weapon (secondary if shield equipped).";
               _loc124_ = "An ability that allows you to heal your health.  1 point increases the amount healed by 5.";
               _loc125_ = "Heals present pet and guild members health (includes yourself).  One point increases the amount healed by 5.";
               _loc126_ = new TextField(302,91,_loc119_,AllTextFormats.info_textFormat);
               _loc127_ = new TextField(302,24,_loc120_,AllTextFormats.info_textFormat);
               _loc128_ = new TextField(302,57,_loc121_,AllTextFormats.info_textFormat);
               _loc129_ = new TextField(302,42,_loc122_,AllTextFormats.info_textFormat);
               _loc130_ = new TextField(302,108,_loc123_,AllTextFormats.info_textFormat);
               _loc131_ = new TextField(302,41,_loc124_,AllTextFormats.info_textFormat);
               _loc132_ = new TextField(302,58,_loc125_,AllTextFormats.info_textFormat);
               this.scrollArea.addChild(_loc126_);
               this.scrollArea.addChild(_loc127_);
               this.scrollArea.addChild(_loc128_);
               this.scrollArea.addChild(_loc129_);
               this.scrollArea.addChild(_loc130_);
               this.scrollArea.addChild(_loc131_);
               this.scrollArea.addChild(_loc132_);
               _loc112_.y = -15;
               _loc113_.y = 203;
               _loc114_.y = 408;
               _loc115_.y = 620;
               _loc116_.y = 829;
               _loc117_.y = 1041;
               _loc118_.y = 1256;
               _loc126_.y = 11;
               _loc127_.y = 231;
               _loc128_.y = 432;
               _loc129_.y = 648;
               _loc130_.y = 854;
               _loc131_.y = 1071;
               _loc132_.y = 1282;
               _loc133_ = new TextField(65,19,"MP: " + _loc2_.levelMP(Person.LIGHT_BEAM_MP),AllTextFormats.skill_textFormat);
               _loc134_ = new TextField(65,19,"MP: " + _loc2_.levelMP(Person.THUNDER_MP),AllTextFormats.skill_textFormat);
               _loc135_ = new TextField(65,19,"MP: " + _loc2_.levelMP(Person.HEAL_MP),AllTextFormats.skill_textFormat);
               _loc136_ = new TextField(65,19,"MP: " + _loc2_.levelMP(Person.GUILD_HEAL_MP),AllTextFormats.skill_textFormat);
               _loc137_ = GameMain.isMobile ? "use: up + attack" : "use: up + space or M";
               _loc138_ = GameMain.isMobile ? "use: down + attack (hold)" : "use down + space or N (hold)";
               _loc139_ = GameMain.isMobile ? "" : "use: H key";
               _loc140_ = GameMain.isMobile ? "" : "use: G key";
               _loc141_ = new TextField(139,19,_loc137_,AllTextFormats.skill_textFormat);
               _loc142_ = new TextField(184,19,_loc138_,AllTextFormats.skill_textFormat);
               _loc143_ = new TextField(75,19,_loc139_,AllTextFormats.skill_textFormat);
               _loc144_ = new TextField(75,19,_loc140_,AllTextFormats.skill_textFormat);
               this.scrollArea.addChild(this.magicShotsLvl_txt);
               this.scrollArea.addChild(this.expertWizardLvl_txt);
               this.scrollArea.addChild(this.lightBeamLvl_txt);
               this.scrollArea.addChild(this.magicDistanceLvl_txt);
               this.scrollArea.addChild(this.thunderLvl_txt);
               this.scrollArea.addChild(this.selfHealLvl_txt);
               this.scrollArea.addChild(this.guildHealLvl_txt);
               this.scrollArea.addChild(this.magicShotsRequired_txt);
               this.scrollArea.addChild(this.expertWizardRequired_txt);
               this.scrollArea.addChild(this.lightBeamRequired_txt);
               this.scrollArea.addChild(this.magicDistanceRequired_txt);
               this.scrollArea.addChild(this.thunderRequired_txt);
               this.scrollArea.addChild(this.selfHealRequired_txt);
               this.scrollArea.addChild(this.guildHealRequired_txt);
               this.scrollArea.addChild(this.magicShotsMax_txt);
               this.scrollArea.addChild(this.expertWizardMax_txt);
               this.scrollArea.addChild(this.lightBeamMax_txt);
               this.scrollArea.addChild(this.magicDistanceMax_txt);
               this.scrollArea.addChild(this.thunderMax_txt);
               this.scrollArea.addChild(this.selfHealMax_txt);
               this.scrollArea.addChild(this.guildHealMax_txt);
               this.scrollArea.addChild(_loc133_);
               this.scrollArea.addChild(_loc134_);
               this.scrollArea.addChild(_loc135_);
               this.scrollArea.addChild(_loc136_);
               this.scrollArea.addChild(_loc141_);
               this.scrollArea.addChild(_loc142_);
               this.scrollArea.addChild(_loc143_);
               this.scrollArea.addChild(_loc144_);
               this.scrollArea.addChild(this.magicShots_txt);
               this.scrollArea.addChild(this.lightBeam_txt);
               this.scrollArea.addChild(this.magicDistance_txt);
               this.scrollArea.addChild(this.thunder_txt);
               this.scrollArea.addChild(this.selfHeal_txt);
               this.scrollArea.addChild(this.guildHeal_txt);
               this.magicShotsLvl_txt.y = this.magicShotsRequired_txt.y = this.magicShotsMax_txt.y = 143;
               this.expertWizardLvl_txt.y = this.expertWizardRequired_txt.y = this.expertWizardMax_txt.y = 362;
               this.lightBeamLvl_txt.y = this.lightBeamRequired_txt.y = this.lightBeamMax_txt.y = 564;
               this.magicDistanceLvl_txt.y = this.magicDistanceRequired_txt.y = this.magicDistanceMax_txt.y = 778;
               this.thunderLvl_txt.y = this.thunderRequired_txt.y = this.thunderMax_txt.y = 985;
               this.selfHealLvl_txt.y = this.selfHealRequired_txt.y = this.selfHealMax_txt.y = 1198;
               this.guildHealLvl_txt.y = this.guildHealRequired_txt.y = this.guildHealMax_txt.y = 1412;
               this.magicShots_txt.y = 164;
               this.lightBeam_txt.y = _loc133_.y = _loc141_.y = 583;
               this.magicDistance_txt.y = 799;
               this.thunder_txt.y = _loc134_.y = _loc142_.y = 1006;
               this.selfHeal_txt.y = _loc135_.y = _loc143_.y = 1219;
               this.guildHeal_txt.y = _loc136_.y = _loc144_.y = 1434;
               this.magicShots_btn.pivotX = this.expertWizard_btn.pivotX = this.lightBeam_btn.pivotX = this.magicDistance_btn.pivotX = this.thunder_btn.pivotX = this.selfHeal_btn.pivotX = this.guildHeal_btn.pivotX = 8;
               this.magicShots_btn.pivotY = this.expertWizard_btn.pivotY = this.lightBeam_btn.pivotY = this.magicDistance_btn.pivotY = this.thunder_btn.pivotY = this.selfHeal_btn.pivotY = this.guildHeal_btn.pivotY = 8;
               this.magicShots_btn.x = this.expertWizard_btn.x = this.lightBeam_btn.x = this.magicDistance_btn.x = this.thunder_btn.x = this.selfHeal_btn.x = this.guildHeal_btn.x = -150;
               this.magicShotsLvl_txt.x = this.expertWizardLvl_txt.x = this.lightBeamLvl_txt.x = this.magicDistanceLvl_txt.x = this.thunderLvl_txt.x = this.selfHealLvl_txt.x = this.guildHealLvl_txt.x = -206;
               this.magicShotsRequired_txt.x = this.expertWizardRequired_txt.x = this.lightBeamRequired_txt.x = this.magicDistanceRequired_txt.x = this.thunderRequired_txt.x = this.selfHealRequired_txt.x = this.guildHealRequired_txt.x = 10;
               this.magicShotsMax_txt.x = this.expertWizardMax_txt.x = this.lightBeamMax_txt.x = this.magicDistanceMax_txt.x = this.thunderMax_txt.x = this.selfHealMax_txt.x = this.guildHealMax_txt.x = 202;
               this.magicShots_txt.x = this.lightBeam_txt.x = this.magicDistance_txt.x = this.thunder_txt.x = this.selfHeal_txt.x = this.guildHeal_txt.x = -206;
               _loc133_.x = _loc134_.x = _loc135_.x = _loc136_.x = 10;
               _loc141_.x = _loc142_.x = _loc143_.x = _loc144_.x = 202;
               _loc112_.x = _loc113_.x = _loc114_.x = _loc115_.x = _loc116_.x = _loc117_.x = _loc118_.x = -203;
               _loc126_.x = _loc127_.x = _loc128_.x = _loc129_.x = _loc130_.x = _loc131_.x = _loc132_.x = 58;
               break;
            case "cowboy":
               this.createBackdrop(4);
               this.grenade_btn.name = "grenade_btn";
               this.upward_btn.name = "upward_btn";
               this.expertCowboy_btn.name = "expertCowboy_btn";
               this.bulletDistance_btn.name = "bulletDistance_btn";
               this.shotgun_btn.name = "shotgun_btn";
               this.bulletKnockback_btn.name = "bulletKnockback_btn";
               this.jumpGrenade_btn.name = "jumpGrenade_btn";
               this.grenade_btn.y = 153;
               this.upward_btn.y = 363;
               this.expertCowboy_btn.y = 585;
               this.bulletDistance_btn.y = 786;
               this.shotgun_btn.y = 999;
               this.bulletKnockback_btn.y = 1210;
               this.jumpGrenade_btn.y = 1421;
               this.scrollArea.addChild(this.grenade_btn);
               this.scrollArea.addChild(this.upward_btn);
               this.scrollArea.addChild(this.expertCowboy_btn);
               this.scrollArea.addChild(this.bulletDistance_btn);
               this.scrollArea.addChild(this.shotgun_btn);
               this.scrollArea.addChild(this.bulletKnockback_btn);
               this.scrollArea.addChild(this.jumpGrenade_btn);
               _loc145_ = new TextField(53,19,"MP: " + _loc2_.levelMP(Person.GRENADE_MP),AllTextFormats.skill_textFormat);
               _loc146_ = new TextField(70,19,"",AllTextFormats.skill_textFormat);
               _loc147_ = new TextField(53,19,"MP: " + _loc2_.levelMP(Person.SHOTGUN_MP),AllTextFormats.skill_textFormat);
               _loc148_ = new TextField(53,19,"MP: " + _loc2_.levelMP(Person.JUMP_GRENADE_MP),AllTextFormats.skill_textFormat);
               _loc149_ = new TextField(131,24,"Grenade Attack",AllTextFormats.showCowboy_textFormat);
               _loc150_ = new TextField(123,24,"Upward Shoot",AllTextFormats.showCowboy_textFormat);
               _loc151_ = new TextField(127,24,"Expert Cowboy",AllTextFormats.showCowboy_textFormat);
               _loc152_ = new TextField(129,24,"Bullet Distance",AllTextFormats.showCowboy_textFormat);
               _loc153_ = new TextField(132,24,"Shotgun Attack",AllTextFormats.showCowboy_textFormat);
               _loc154_ = new TextField(137,24,"Bullet Knockback",AllTextFormats.showCowboy_textFormat);
               _loc155_ = new TextField(126,24,"Jump Grenade",AllTextFormats.showCowboy_textFormat);
               _loc156_ = "Throws grenades that deal heavy damage to enemies.  Each level of this skill increases the amount of grenades by one.  The amount of damage that each grenade deals is relative to your Jump Grenade skill level.";
               _loc157_ = "Allows you to point and shoot your gun straight up in the air.  Useful for attacking enemies above you.";
               _loc158_ = "Increases artillery by 1.";
               _loc159_ = "Increases the distance that your bullet will travel.  1 point increases the distance by 1 foot.";
               _loc160_ = "Shoots your gun and sprays a fury of bullets into the air.";
               _loc161_ = "Increases the distance that enemies are knocked back from gun attacks by 0.03 feet per 2 points.";
               _loc162_ = "While in the air, it drops one grenade below you damaging enemies on impact.  Each point increases the amount of damage a grenade does by 10%.";
               _loc163_ = new TextField(302,103,_loc156_,AllTextFormats.info_textFormat);
               _loc164_ = new TextField(302,228,_loc157_,AllTextFormats.info_textFormat);
               _loc165_ = new TextField(302,24,_loc158_,AllTextFormats.info_textFormat);
               _loc166_ = new TextField(302,43,_loc159_,AllTextFormats.info_textFormat);
               _loc167_ = new TextField(302,43,_loc160_,AllTextFormats.info_textFormat);
               _loc168_ = new TextField(302,64,_loc161_,AllTextFormats.info_textFormat);
               _loc169_ = new TextField(302,85,_loc162_,AllTextFormats.info_textFormat);
               _loc149_.y = -12;
               _loc150_.y = 198;
               _loc151_.y = 420;
               _loc152_.y = 622;
               _loc153_.y = 834;
               _loc154_.y = 1046;
               _loc155_.y = 1257;
               _loc163_.y = 14;
               _loc164_.y = 225;
               _loc165_.y = 447;
               _loc166_.y = 645;
               _loc167_.y = 860;
               _loc168_.y = 1071;
               _loc169_.y = 1282;
               this.scrollArea.addChild(_loc149_);
               this.scrollArea.addChild(_loc150_);
               this.scrollArea.addChild(_loc151_);
               this.scrollArea.addChild(_loc152_);
               this.scrollArea.addChild(_loc153_);
               this.scrollArea.addChild(_loc154_);
               this.scrollArea.addChild(_loc155_);
               this.scrollArea.addChild(_loc163_);
               this.scrollArea.addChild(_loc164_);
               this.scrollArea.addChild(_loc165_);
               this.scrollArea.addChild(_loc166_);
               this.scrollArea.addChild(_loc167_);
               this.scrollArea.addChild(_loc168_);
               this.scrollArea.addChild(_loc169_);
               this.scrollArea.addChild(_loc145_);
               this.scrollArea.addChild(_loc146_);
               this.scrollArea.addChild(_loc147_);
               this.scrollArea.addChild(_loc148_);
               _loc170_ = GameMain.isMobile ? "use: down + attack" : "use: down + space or N";
               _loc171_ = GameMain.isMobile ? "use: up + attack" : "use: space + up or M";
               _loc172_ = GameMain.isMobile ? "use: forward + space" : "use: forward + space or B";
               _loc173_ = GameMain.isMobile ? "use: down + attack (air)" : "use: space + down or N (air)";
               _loc174_ = new TextField(156,19,_loc170_,AllTextFormats.skill_textFormat);
               _loc175_ = new TextField(143,19,_loc171_,AllTextFormats.skill_textFormat);
               _loc176_ = new TextField(165,19,_loc172_,AllTextFormats.skill_textFormat);
               _loc177_ = new TextField(180,19,_loc173_,AllTextFormats.skill_textFormat);
               this.scrollArea.addChild(this.grenadeLvl_txt);
               this.scrollArea.addChild(this.upwardLvl_txt);
               this.scrollArea.addChild(this.expertCowboyLvl_txt);
               this.scrollArea.addChild(this.bulletDistanceLvl_txt);
               this.scrollArea.addChild(this.shotgunLvl_txt);
               this.scrollArea.addChild(this.bulletKnockbackLvl_txt);
               this.scrollArea.addChild(this.jumpGrenadeLvl_txt);
               this.scrollArea.addChild(this.grenadeRequired_txt);
               this.scrollArea.addChild(this.upwardRequired_txt);
               this.scrollArea.addChild(this.expertCowboyRequired_txt);
               this.scrollArea.addChild(this.bulletDistanceRequired_txt);
               this.scrollArea.addChild(this.shotgunRequired_txt);
               this.scrollArea.addChild(this.bulletKnockbackRequired_txt);
               this.scrollArea.addChild(this.jumpGrenadeRequired_txt);
               this.scrollArea.addChild(this.grenadeMax_txt);
               this.scrollArea.addChild(this.upwardMax_txt);
               this.scrollArea.addChild(this.expertCowboyMax_txt);
               this.scrollArea.addChild(this.bulletDistanceMax_txt);
               this.scrollArea.addChild(this.shotgunMax_txt);
               this.scrollArea.addChild(this.bulletKnockbackMax_txt);
               this.scrollArea.addChild(this.jumpGrenadeMax_txt);
               this.scrollArea.addChild(this.grenade_txt);
               this.scrollArea.addChild(this.bulletDistance_txt);
               this.scrollArea.addChild(this.shotgun_txt);
               this.scrollArea.addChild(this.bulletKnockback_txt);
               this.scrollArea.addChild(this.jumpGrenade_txt);
               this.scrollArea.addChild(_loc174_);
               this.scrollArea.addChild(_loc175_);
               this.scrollArea.addChild(_loc176_);
               this.scrollArea.addChild(_loc177_);
               this.grenade_btn.pivotX = this.upward_btn.pivotX = this.expertCowboy_btn.pivotX = this.bulletDistance_btn.pivotX = this.shotgun_btn.pivotX = this.bulletKnockback_btn.pivotX = this.jumpGrenade_btn.pivotX = 8;
               this.grenade_btn.pivotY = this.upward_btn.pivotY = this.expertCowboy_btn.pivotY = this.bulletDistance_btn.pivotY = this.shotgun_btn.pivotY = this.bulletKnockback_btn.pivotY = this.jumpGrenade_btn.pivotY = 8;
               this.grenade_btn.x = this.upward_btn.x = this.expertCowboy_btn.x = this.bulletDistance_btn.x = this.shotgun_btn.x = this.bulletKnockback_btn.x = this.jumpGrenade_btn.x = -140;
               this.grenadeLvl_txt.x = this.upwardLvl_txt.x = this.expertCowboyLvl_txt.x = this.bulletDistanceLvl_txt.x = this.shotgunLvl_txt.x = this.bulletKnockbackLvl_txt.x = this.jumpGrenadeLvl_txt.x = -201;
               _loc145_.x = _loc146_.x = _loc147_.x = _loc148_.x = this.grenadeRequired_txt.x = this.upwardRequired_txt.x = this.expertCowboyRequired_txt.x = this.bulletDistanceRequired_txt.x = this.shotgunRequired_txt.x = this.bulletKnockbackRequired_txt.x = this.jumpGrenadeRequired_txt.x = 24;
               this.grenadeMax_txt.x = this.upwardMax_txt.x = this.expertCowboyMax_txt.x = this.bulletDistanceMax_txt.x = this.shotgunMax_txt.x = this.bulletKnockbackMax_txt.x = this.jumpGrenadeMax_txt.x = 202;
               this.grenade_txt.x = this.bulletDistance_txt.x = this.shotgun_txt.x = this.bulletKnockback_txt.x = this.jumpGrenade_txt.x = -201;
               _loc145_.x = _loc146_.x = _loc147_.x = _loc148_.x = 24;
               _loc174_.x = _loc175_.x = _loc176_.x = _loc177_.x = 202;
               _loc149_.x = _loc150_.x = _loc151_.x = _loc152_.x = _loc153_.x = _loc154_.x = _loc155_.x = -201;
               _loc163_.x = _loc164_.x = _loc165_.x = _loc166_.x = _loc167_.x = _loc168_.x = _loc169_.x = 53;
               this.grenadeLvl_txt.y = this.grenadeRequired_txt.y = this.grenadeMax_txt.y = 143;
               this.grenade_txt.y = _loc145_.y = _loc174_.y = 164;
               this.upwardLvl_txt.y = this.upwardRequired_txt.y = this.upwardMax_txt.y = 353;
               _loc146_.y = _loc175_.y = 373;
               this.expertCowboyLvl_txt.y = this.expertCowboyRequired_txt.y = this.expertCowboyMax_txt.y = 577;
               this.bulletDistanceLvl_txt.y = this.bulletDistanceRequired_txt.y = this.bulletDistanceMax_txt.y = 776;
               this.bulletDistance_txt.y = 799;
               this.shotgunLvl_txt.y = this.shotgunRequired_txt.y = this.shotgunMax_txt.y = 989;
               this.shotgun_txt.y = _loc147_.y = _loc176_.y = 1010;
               this.bulletKnockbackLvl_txt.y = this.bulletKnockbackRequired_txt.y = this.bulletKnockbackMax_txt.y = 1200;
               this.bulletKnockback_txt.y = 1221;
               this.jumpGrenadeLvl_txt.y = this.jumpGrenadeRequired_txt.y = this.jumpGrenadeMax_txt.y = 1411;
               this.jumpGrenade_txt.y = _loc148_.y = _loc177_.y = 1432;
         }
         _loc3_ = int(this.scrollArea.numChildren);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            if(this.scrollArea.getChildAt(_loc4_) is TextField)
            {
               TextField(this.scrollArea.getChildAt(_loc4_)).touchable = false;
               TextField(this.scrollArea.getChildAt(_loc4_)).batchable = true;
            }
            _loc4_++;
         }
         if(assetManager.getTextureAtlas("skill images") != null)
         {
            this.updateSkillImages();
         }
         this.updateMe();
      }
      
      private function updateSkillImages() : void
      {
         var _loc1_:Image = null;
         var _loc2_:Image = null;
         var _loc3_:Image = null;
         var _loc4_:Image = null;
         var _loc5_:Image = null;
         var _loc6_:Image = null;
         var _loc7_:Image = null;
         var _loc8_:Image = null;
         var _loc9_:Image = null;
         var _loc10_:Image = null;
         var _loc11_:Image = null;
         var _loc12_:Image = null;
         var _loc13_:Image = null;
         var _loc14_:Image = null;
         var _loc15_:Image = null;
         var _loc16_:Image = null;
         var _loc17_:Image = null;
         var _loc18_:Image = null;
         var _loc19_:Image = null;
         var _loc20_:Image = null;
         var _loc21_:Image = null;
         var _loc22_:Image = null;
         var _loc23_:Image = null;
         var _loc24_:Image = null;
         var _loc25_:Image = null;
         var _loc26_:Image = null;
         var _loc27_:Image = null;
         var _loc28_:Image = null;
         var _loc29_:Image = null;
         var _loc30_:Image = null;
         var _loc31_:Image = null;
         var _loc32_:Image = null;
         var _loc33_:Image = null;
         var _loc34_:Image = null;
         var _loc35_:Image = null;
         var _loc36_:Image = null;
         var _loc37_:Image = null;
         var _loc38_:Image = null;
         var _loc39_:Image = null;
         _loc1_ = null;
         _loc2_ = null;
         _loc3_ = null;
         _loc4_ = null;
         _loc5_ = null;
         _loc6_ = null;
         _loc7_ = null;
         _loc8_ = null;
         _loc9_ = null;
         _loc10_ = null;
         _loc11_ = null;
         _loc12_ = null;
         _loc13_ = null;
         _loc14_ = null;
         _loc15_ = null;
         _loc16_ = null;
         _loc17_ = null;
         _loc18_ = null;
         _loc19_ = null;
         _loc20_ = null;
         _loc21_ = null;
         _loc22_ = null;
         _loc23_ = null;
         _loc24_ = null;
         _loc25_ = null;
         _loc26_ = null;
         _loc27_ = null;
         _loc28_ = null;
         _loc29_ = null;
         _loc30_ = null;
         _loc31_ = null;
         _loc32_ = null;
         _loc33_ = null;
         _loc34_ = null;
         _loc35_ = null;
         _loc36_ = null;
         _loc37_ = null;
         _loc38_ = null;
         _loc39_ = null;
         switch(this.currentDisplay)
         {
            case "basic":
               _loc1_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("jump-height"));
               _loc1_.y = 10;
               this.scrollArea.addChild(_loc1_);
               _loc2_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("critical"));
               _loc2_.y = 221;
               this.scrollArea.addChild(_loc2_);
               _loc3_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("loot"));
               _loc3_.y = 434;
               this.scrollArea.addChild(_loc3_);
               _loc4_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("training"));
               _loc4_.y = 655;
               this.scrollArea.addChild(_loc4_);
               _loc5_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("rage"));
               _loc5_.y = 855;
               this.scrollArea.addChild(_loc5_);
               _loc6_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("guild-rage"));
               _loc6_.y = 1070;
               this.scrollArea.addChild(_loc6_);
               _loc7_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("mp-restore"));
               _loc7_.y = 1282;
               this.scrollArea.addChild(_loc7_);
               _loc8_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("avoidance"));
               _loc8_.y = 1491;
               this.scrollArea.addChild(_loc8_);
               _loc9_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("dash"));
               _loc9_.y = 1704;
               this.scrollArea.addChild(_loc9_);
               _loc10_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("accel-down"));
               _loc10_.y = 1916;
               this.scrollArea.addChild(_loc10_);
               _loc11_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("block"));
               _loc11_.y = 2126;
               this.scrollArea.addChild(_loc11_);
               _loc11_.x = _loc10_.x = _loc9_.x = _loc8_.x = _loc7_.x = _loc6_.x = _loc5_.x = _loc4_.x = _loc3_.x = _loc2_.x = _loc1_.x = -202;
               _loc11_.touchable = _loc10_.touchable = _loc9_.touchable = _loc8_.touchable = _loc7_.touchable = _loc6_.touchable = _loc5_.touchable = _loc4_.touchable = _loc3_.touchable = _loc2_.touchable = _loc1_.touchable = false;
               this.createImageBG(_loc1_);
               this.createImageBG(_loc2_);
               this.createImageBG(_loc3_);
               this.createImageBG(_loc4_);
               this.createImageBG(_loc5_);
               this.createImageBG(_loc6_);
               this.createImageBG(_loc7_);
               this.createImageBG(_loc8_);
               this.createImageBG(_loc9_);
               this.createImageBG(_loc10_);
               this.createImageBG(_loc11_);
               break;
            case "warrior":
               _loc12_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("power-attack"));
               _loc12_.y = 11;
               this.scrollArea.addChild(_loc12_);
               _loc13_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("expert-warrior"));
               _loc13_.y = 232;
               this.scrollArea.addChild(_loc13_);
               _loc14_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("multi-attack"));
               _loc14_.y = 435;
               this.scrollArea.addChild(_loc14_);
               _loc15_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("multi-attack-distance"));
               _loc15_.y = 650;
               this.scrollArea.addChild(_loc15_);
               _loc16_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("shield-mastery"));
               _loc16_.y = 857;
               this.scrollArea.addChild(_loc16_);
               _loc17_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("melee-knockback"));
               _loc17_.y = 1069;
               this.scrollArea.addChild(_loc17_);
               _loc18_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("spin-attack"));
               _loc18_.y = 1281;
               this.scrollArea.addChild(_loc18_);
               _loc18_.x = _loc17_.x = _loc16_.x = _loc15_.x = _loc14_.x = _loc13_.x = _loc12_.x = -202;
               _loc18_.touchable = _loc17_.touchable = _loc16_.touchable = _loc15_.touchable = _loc14_.touchable = _loc13_.touchable = _loc12_.touchable = false;
               this.createImageBG(_loc12_);
               this.createImageBG(_loc13_);
               this.createImageBG(_loc14_);
               this.createImageBG(_loc15_);
               this.createImageBG(_loc16_);
               this.createImageBG(_loc17_);
               this.createImageBG(_loc18_);
               break;
            case "archer":
               _loc19_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("arrow-barrage"));
               _loc19_.y = 12;
               this.scrollArea.addChild(_loc19_);
               _loc20_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("arrow-knockback"));
               _loc20_.y = 224;
               this.scrollArea.addChild(_loc20_);
               _loc21_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("expert-archer"));
               _loc21_.y = 446;
               this.scrollArea.addChild(_loc21_);
               _loc22_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("arrow-triple-shot"));
               _loc22_.y = 643;
               this.scrollArea.addChild(_loc22_);
               _loc23_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("arrow-rain"));
               _loc23_.y = 858;
               this.scrollArea.addChild(_loc23_);
               _loc24_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("piercing-arrow"));
               _loc24_.y = 1067;
               this.scrollArea.addChild(_loc24_);
               _loc25_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("archer-down"));
               _loc25_.y = 1282;
               this.scrollArea.addChild(_loc25_);
               _loc25_.touchable = _loc24_.touchable = _loc23_.touchable = _loc22_.touchable = _loc21_.touchable = _loc20_.touchable = _loc19_.touchable = false;
               _loc25_.x = _loc24_.x = _loc23_.x = _loc22_.x = _loc21_.x = _loc20_.x = _loc19_.x = -202;
               this.createImageBG(_loc19_);
               this.createImageBG(_loc20_);
               this.createImageBG(_loc21_);
               this.createImageBG(_loc22_);
               this.createImageBG(_loc23_);
               this.createImageBG(_loc24_);
               this.createImageBG(_loc25_);
               break;
            case "wizard":
               _loc26_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("magic-projectiles"));
               _loc26_.y = 11;
               this.scrollArea.addChild(_loc26_);
               _loc27_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("expert-wizard"));
               _loc27_.y = 230;
               this.scrollArea.addChild(_loc27_);
               _loc28_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("light-beam"));
               _loc28_.y = 432;
               this.scrollArea.addChild(_loc28_);
               _loc29_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("magic-distance"));
               _loc29_.y = 648;
               this.scrollArea.addChild(_loc29_);
               _loc30_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("thunder-attack"));
               _loc30_.y = 855;
               this.scrollArea.addChild(_loc30_);
               _loc31_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("self-heal"));
               _loc31_.y = 1068;
               this.scrollArea.addChild(_loc31_);
               _loc32_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("pet-guild-heal"));
               _loc32_.y = 1282;
               this.scrollArea.addChild(_loc32_);
               _loc26_.touchable = _loc27_.touchable = _loc28_.touchable = _loc29_.touchable = _loc30_.touchable = _loc31_.touchable = _loc32_.touchable = false;
               _loc26_.x = _loc27_.x = _loc28_.x = _loc29_.x = _loc30_.x = _loc31_.x = _loc32_.x = -202;
               this.createImageBG(_loc26_);
               this.createImageBG(_loc27_);
               this.createImageBG(_loc28_);
               this.createImageBG(_loc29_);
               this.createImageBG(_loc30_);
               this.createImageBG(_loc31_);
               this.createImageBG(_loc32_);
               break;
            case "cowboy":
               _loc33_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("grenades"));
               _loc33_.y = 13;
               this.scrollArea.addChild(_loc33_);
               _loc34_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("upward-shoot"));
               _loc34_.y = 225;
               this.scrollArea.addChild(_loc34_);
               _loc35_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("expert-cowboy"));
               _loc35_.y = 447;
               this.scrollArea.addChild(_loc35_);
               _loc36_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("bullet-distance"));
               _loc36_.y = 646;
               this.scrollArea.addChild(_loc36_);
               _loc37_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("shotgun-attack"));
               _loc37_.y = 860;
               this.scrollArea.addChild(_loc37_);
               _loc38_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("bullet-knockback"));
               _loc38_.y = 1071;
               this.scrollArea.addChild(_loc38_);
               _loc39_ = new Image(assetManager.getTextureAtlas("skill images").getTexture("jump-grenade"));
               _loc39_.y = 1282;
               this.scrollArea.addChild(_loc39_);
               _loc33_.touchable = _loc34_.touchable = _loc35_.touchable = _loc36_.touchable = _loc37_.touchable = _loc38_.touchable = _loc39_.touchable = false;
               _loc33_.x = _loc34_.x = _loc35_.x = _loc36_.x = _loc37_.x = _loc38_.x = _loc39_.x = -203;
               this.createImageBG(_loc33_);
               this.createImageBG(_loc34_);
               this.createImageBG(_loc35_);
               this.createImageBG(_loc36_);
               this.createImageBG(_loc37_);
               this.createImageBG(_loc38_);
               this.createImageBG(_loc39_);
         }
      }
      
      private function createImageBG(param1:Image) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Image = null;
         _loc2_ = 0;
         _loc3_ = 0;
         _loc4_ = 0;
         _loc5_ = null;
         _loc2_ = 0;
         _loc3_ = int(this.scrollArea.numChildren);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            if(this.scrollArea.getChildAt(_loc4_) is Image && Image(this.scrollArea.getChildAt(_loc4_)).texture == skillsMenu_textureAtlas.getTexture("skills backdrop"))
            {
               if(_loc4_ > _loc2_)
               {
                  _loc2_ = uint(_loc4_);
               }
            }
            _loc4_++;
         }
         _loc5_ = new Image(this.boxBG_texture);
         _loc5_.x = param1.x - 3;
         _loc5_.y = param1.y - 3;
         _loc5_.touchable = false;
         this.scrollArea.addChildAt(_loc5_,_loc2_ + 1);
      }
      
      private function createBackdrop(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Image = null;
         _loc2_ = 0;
         _loc3_ = null;
         _loc2_ = 0;
         while(_loc2_ < param1)
         {
            _loc3_ = new Image(skillsMenu_textureAtlas.getTexture("skills backdrop"));
            _loc3_.x = -222;
            _loc3_.y = -23 + _loc2_ * 423;
            _loc3_.name = "listBackdrop";
            this.scrollArea.addChild(_loc3_);
            switch(this.currentDisplay)
            {
               case "warrior":
                  SetHue.tintObject(_loc3_,16711680,false,0.7);
                  break;
               case "archer":
                  SetHue.tintObject(_loc3_,65280,false,0.9);
                  break;
               case "wizard":
                  SetHue.tintObject(_loc3_,3311095,false,1);
                  break;
               case "cowboy":
                  SetHue.tintObject(_loc3_,16230706,false);
            }
            _loc2_++;
         }
      }
      
      private function setSkillText(param1:TextField, param2:TextField, param3:TextField, param4:TextField, param5:int, param6:String, param7:String) : void
      {
         if(param7 != "")
         {
            param1.text = param7;
         }
         param2.text = "Points required: " + Stats.skillStats[param6].required;
         param3.text = "lvl: " + String(param5);
         param4.text = "Max lvl: " + (Stats.skillStats[param6].maxLvl < int.MAX_VALUE ? Stats.skillStats[param6].maxLvl : "infinite");
      }
      
      private function setSkillButton(param1:Button, param2:int, param3:String) : void
      {
         if(param2 < Stats.skillStats[param3].maxLvl && MainStarlingStage(root).gameMain.player.skillPoints >= Stats.skillStats[param3].required)
         {
            param1.visible = true;
         }
         else
         {
            param1.visible = false;
         }
      }
      
      public function scroll(param1:Number) : void
      {
         var _loc2_:Point = null;
         var _loc3_:Number = NaN;
         _loc2_ = null;
         _loc3_ = Number(NaN);
         _loc2_ = new Point(0,param1 / Starling.contentScaleFactor);
         _loc2_ = globalToLocal(_loc2_);
         this.scroll_btn.y = _loc2_.y;
         if(this.scroll_btn.y < -134)
         {
            this.scroll_btn.y = -134;
         }
         if(this.scroll_btn.y > 194)
         {
            this.scroll_btn.y = 194;
         }
         _loc3_ = Number(this.scrollArea.y);
         switch(this.currentDisplay)
         {
            case "basic":
               this.scrollArea.y = Math.abs(CalcDist.getDistY(this.scroll_btn.y,194) * 6.2) - 2168;
               break;
            case "warrior":
               this.scrollArea.y = Math.abs(CalcDist.getDistY(this.scroll_btn.y,194) * 3.6) - 1280;
               break;
            case "archer":
               this.scrollArea.y = Math.abs(CalcDist.getDistY(this.scroll_btn.y,194) * 3.75) - 1320;
               break;
            case "wizard":
               this.scrollArea.y = Math.abs(CalcDist.getDistY(this.scroll_btn.y,194) * 3.8) - 1350;
               break;
            case "cowboy":
               this.scrollArea.y = Math.abs(CalcDist.getDistY(this.scroll_btn.y,194) * 3.75) - 1340;
         }
         this.mask_canvas.y -= this.scrollArea.y - _loc3_;
      }
      
      public function scrollWheel(param1:int) : void
      {
         var _loc2_:Point = null;
         _loc2_ = null;
         this.scroll_btn.y -= param1 * 2;
         if(this.scroll_btn.y < -134)
         {
            this.scroll_btn.y = -134;
         }
         if(this.scroll_btn.y > 194)
         {
            this.scroll_btn.y = 194;
         }
         _loc2_ = new Point(this.scroll_btn.x,this.scroll_btn.y);
         _loc2_ = localToGlobal(_loc2_);
         this.scroll(_loc2_.y);
      }
      
      public function touchScroll(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = Number(NaN);
         _loc2_ = Number(this.scrollArea.y);
         this.scrollArea.y += param1;
         if(this.scrollArea.y > -109 && param1 > 0)
         {
            this.scrollArea.y = -109;
         }
         if(this.currentDisplay == "basic")
         {
            if(this.scrollArea.y < -2089 && param1 < 0)
            {
               this.scrollArea.y = -2089;
            }
         }
         else if(this.scrollArea.y < -1244 && param1 < 0)
         {
            this.scrollArea.y = -1244;
         }
         this.mask_canvas.y -= this.scrollArea.y - _loc2_;
      }
      
      override public function dispose() : void
      {
         this.boxBG_texture.dispose();
         super.dispose();
      }
   }
}

