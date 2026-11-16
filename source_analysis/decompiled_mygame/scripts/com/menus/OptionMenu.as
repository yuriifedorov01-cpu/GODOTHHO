package com.menus
{
   import com.helpers.*;
   import com.sound.*;
   import com.stats.*;
   import com.ui.*;
   import flash.display.*;
   import flash.events.*;
   import flash.net.SharedObject;
   import flash.ui.GameInputDevice;
   import starling.*;
   import starling.core.*;
   import starling.display.*;
   import starling.events.*;
   import starling.text.*;
   import starling.textures.*;
   
   public final class OptionMenu extends StarlingGameMenu
   {
      
      public static var ignoreTrades:Boolean = false;
      
      public static var ignorePMs:Boolean = false;
      
      public static var controllerOn:Boolean = true;
      
      private const musicOff_txt:TextField = new TextField(38,30,"OFF",AllTextFormats.toggleOff_textFormat);
      
      private const musicOn_txt:TextField = new TextField(34,27,"ON",AllTextFormats.toggleOff_textFormat);
      
      private const soundOff_txt:TextField = new TextField(38,30,"OFF",AllTextFormats.toggleOff_textFormat);
      
      private const soundOn_txt:TextField = new TextField(34,27,"ON",AllTextFormats.toggleOff_textFormat);
      
      private const fullscreenOff_txt:TextField = new TextField(38,30,"OFF",AllTextFormats.toggleOff_textFormat);
      
      private const fullscreenOn_txt:TextField = new TextField(34,27,"ON",AllTextFormats.toggleOff_textFormat);
      
      private const ignoreTradeOff_txt:TextField = new TextField(38,30,"OFF",AllTextFormats.toggleOff_textFormat);
      
      private const ignoreTradeOn_txt:TextField = new TextField(34,27,"ON",AllTextFormats.toggleOff_textFormat);
      
      private const ignorePMsOff_txt:TextField = new TextField(38,30,"OFF",AllTextFormats.toggleOff_textFormat);
      
      private const ignorePMsOn_txt:TextField = new TextField(34,27,"ON",AllTextFormats.toggleOff_textFormat);
      
      private const controllerOff_txt:TextField = new TextField(38,30,"OFF",AllTextFormats.toggleOff_textFormat);
      
      private const controllerOn_txt:TextField = new TextField(34,27,"ON",AllTextFormats.toggleOff_textFormat);
      
      private const cutscene1_txt:TextField = new TextField(20,25,"1",AllTextFormats.toggleOff_textFormat);
      
      private const cutscene2_txt:TextField = new TextField(20,25,"2",AllTextFormats.toggleOff_textFormat);
      
      private const cutscene3_txt:TextField = new TextField(20,25,"3",AllTextFormats.toggleOff_textFormat);
      
      private const cutscene4_txt:TextField = new TextField(20,25,"4",AllTextFormats.toggleOff_textFormat);
      
      private const cutscene5_txt:TextField = new TextField(20,25,"5",AllTextFormats.toggleOff_textFormat);
      
      private const cutscene6_txt:TextField = new TextField(20,25,"6",AllTextFormats.toggleOff_textFormat);
      
      private const cutscene7_txt:TextField = new TextField(20,25,"7",AllTextFormats.toggleOff_textFormat);
      
      private const cutscene8_txt:TextField = new TextField(20,25,"8",AllTextFormats.toggleOff_textFormat);
      
      private const qualityLow_txt:TextField = new TextField(44,25,"LOW",AllTextFormats.qualityOff_textFormat);
      
      private const qualityMedium_txt:TextField = new TextField(75,25,"MEDIUM",AllTextFormats.qualityOff_textFormat);
      
      private const qualityHigh_txt:TextField = new TextField(46,25,"HIGH",AllTextFormats.qualityOn_textFormat);
      
      private const controller_txt:TextField = new TextField(364,20,"",AllTextFormats.money2_textFormat);
      
      public const buttons_txt:TextField = new TextField(265,19,"",AllTextFormats.buttons_textFormat);
      
      private const defineButtons_btn:Button = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("defineButtons"));
      
      public function OptionMenu()
      {
         super();
         var _loc1_:Image = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("options panel"));
         _loc1_.x = -215;
         _loc1_.y = -164;
         addChild(_loc1_);
         var _loc2_:Button = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_00"),"",null,ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_01"));
         _loc2_.x = 235;
         _loc2_.y = -148;
         _loc2_.pivotX = 30;
         _loc2_.pivotY = 19;
         _loc2_.name = "x_btn";
         addChild(_loc2_);
         this.defineButtons_btn.x = -135;
         this.defineButtons_btn.y = 248;
         this.defineButtons_btn.pivotX = 62;
         this.defineButtons_btn.pivotY = 11;
         this.defineButtons_btn.name = "defineButtons_btn";
         this.defineButtons_btn.scaleWhenOver = 0.95;
         addChild(this.defineButtons_btn);
         if(GameMain.isMobile == false)
         {
            this.cutscene1_txt.x = -28;
            this.cutscene1_txt.name = "cutscene1_txt";
            addChild(this.cutscene1_txt);
            this.cutscene2_txt.x = 5;
            this.cutscene2_txt.name = "cutscene2_txt";
            addChild(this.cutscene2_txt);
            this.cutscene3_txt.x = 41;
            this.cutscene3_txt.name = "cutscene3_txt";
            addChild(this.cutscene3_txt);
            this.cutscene4_txt.x = 72;
            this.cutscene4_txt.name = "cutscene4_txt";
            addChild(this.cutscene4_txt);
            this.cutscene5_txt.x = 106;
            this.cutscene5_txt.name = "cutscene5_txt";
            addChild(this.cutscene5_txt);
            this.cutscene6_txt.x = 144;
            this.cutscene6_txt.name = "cutscene6_txt";
            addChild(this.cutscene6_txt);
            this.cutscene7_txt.x = 175;
            this.cutscene7_txt.name = "cutscene7_txt";
            addChild(this.cutscene7_txt);
            this.cutscene8_txt.x = 206;
            this.cutscene8_txt.name = "cutscene8_txt";
            addChild(this.cutscene8_txt);
         }
         this.musicOff_txt.x = 98;
         this.musicOff_txt.name = "musicOff_txt";
         addChild(this.musicOff_txt);
         this.musicOn_txt.x = 187;
         this.musicOn_txt.y = this.musicOff_txt.y = -126;
         this.musicOn_txt.name = "musicOn_txt";
         addChild(this.musicOn_txt);
         this.soundOff_txt.x = 99;
         this.soundOff_txt.name = "soundOff_txt";
         addChild(this.soundOff_txt);
         this.soundOn_txt.x = 186;
         this.soundOn_txt.y = this.soundOff_txt.y = -88;
         this.soundOn_txt.name = "soundOn_txt";
         addChild(this.soundOn_txt);
         if(GameMain.isMobile == false)
         {
            this.fullscreenOff_txt.x = 98;
            this.fullscreenOff_txt.name = "fullscreenOff_txt";
            addChild(this.fullscreenOff_txt);
            this.fullscreenOn_txt.x = 185;
            this.fullscreenOn_txt.y = this.fullscreenOff_txt.y = -47;
            this.fullscreenOn_txt.name = "fullscreenOn_txt";
            this.fullscreenOn_txt.useHandCursor = this.fullscreenOff_txt.useHandCursor = true;
            addChild(this.fullscreenOn_txt);
         }
         this.ignoreTradeOff_txt.x = 94;
         this.ignoreTradeOff_txt.name = "ignoreTradeOff_txt";
         addChild(this.ignoreTradeOff_txt);
         this.ignoreTradeOn_txt.x = 181;
         this.ignoreTradeOn_txt.y = this.ignoreTradeOff_txt.y = 108;
         this.ignoreTradeOn_txt.name = "ignoreTradeOn_txt";
         addChild(this.ignoreTradeOn_txt);
         this.ignorePMsOff_txt.x = 94;
         this.ignorePMsOff_txt.name = "ignorePMsOff_txt";
         addChild(this.ignorePMsOff_txt);
         this.ignorePMsOn_txt.x = 180;
         this.ignorePMsOn_txt.y = this.ignorePMsOff_txt.y = 135;
         this.ignorePMsOn_txt.name = "ignorePMsOn_txt";
         addChild(this.ignorePMsOn_txt);
         this.controllerOff_txt.x = 94;
         this.controllerOff_txt.name = "controllerOff_txt";
         addChild(this.controllerOff_txt);
         this.controllerOn_txt.x = 181;
         this.controllerOn_txt.y = this.controllerOff_txt.y = 170;
         this.controllerOn_txt.name = "controllerOn_txt";
         addChild(this.controllerOn_txt);
         this.soundOn_txt.useHandCursor = this.soundOff_txt.useHandCursor = this.musicOn_txt.useHandCursor = this.musicOff_txt.useHandCursor = true;
         this.ignoreTradeOff_txt.useHandCursor = this.ignoreTradeOn_txt.useHandCursor = this.ignorePMsOff_txt.useHandCursor = this.ignorePMsOn_txt.useHandCursor = this.controllerOff_txt.useHandCursor = this.controllerOn_txt.useHandCursor = true;
         this.cutscene1_txt.y = this.cutscene2_txt.y = this.cutscene3_txt.y = this.cutscene4_txt.y = this.cutscene5_txt.y = this.cutscene6_txt.y = this.cutscene7_txt.y = this.cutscene8_txt.y = 33;
         this.cutscene1_txt.useHandCursor = this.cutscene2_txt.useHandCursor = this.cutscene3_txt.useHandCursor = this.cutscene4_txt.useHandCursor = this.cutscene5_txt.useHandCursor = this.cutscene6_txt.useHandCursor = this.cutscene7_txt.useHandCursor = this.cutscene8_txt.useHandCursor = true;
         this.qualityLow_txt.x = 26;
         this.qualityLow_txt.y = 75;
         this.qualityLow_txt.name = "qualityLow_txt";
         addChild(this.qualityLow_txt);
         this.qualityMedium_txt.x = 89;
         this.qualityMedium_txt.y = 75;
         this.qualityMedium_txt.name = "qualityMedium_txt";
         addChild(this.qualityMedium_txt);
         this.qualityHigh_txt.x = 178;
         this.qualityHigh_txt.y = 75;
         this.qualityHigh_txt.name = "qualityHigh_txt";
         addChild(this.qualityHigh_txt);
         this.qualityLow_txt.useHandCursor = this.qualityMedium_txt.useHandCursor = this.qualityHigh_txt.useHandCursor = true;
         this.controller_txt.x = -137;
         this.controller_txt.y = 209;
         addChild(this.controller_txt);
         this.buttons_txt.x = -45;
         this.buttons_txt.y = 238;
         this.buttons_txt.batchable = this.controller_txt.batchable = true;
         this.buttons_txt.touchable = this.controller_txt.touchable = false;
         addChild(this.buttons_txt);
         var _loc3_:Image = new Image(Texture.fromBitmapData(new BitmapData(421,36,false,16711680)));
         _loc3_.x = -216;
         _loc3_.y = -165;
         _loc3_.alpha = 0;
         _loc3_.name = "drag_image";
         addChild(_loc3_);
         this.fullscreenOn_txt.addEventListener(TouchEvent.TOUCH,this.onFullTouch);
      }
      
      private function onFullTouch(param1:starling.events.TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this);
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.phase == TouchPhase.BEGAN)
         {
            Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_UP,this.fullScreen);
         }
      }
      
      private function fullScreen(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         Starling.current.nativeStage.removeEventListener(MouseEvent.MOUSE_UP,this.fullScreen);
         try
         {
            MainStarlingStage(root).gameMain.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
            this.updateMe(MainStarlingStage(root).gameMain.stage,AreaCreator.background1,MainStarlingStage(root).gameMain.save_sharedObject,MainStarlingStage(root).gameMain.controllerMain);
         }
         catch(_fullError:Error)
         {
            MainStarlingStage(root).gameMain.createAlert("The website you are on does not support full screen games");
         }
      }
      
      public function updateMe(param1:flash.display.Stage, param2:starling.display.Sprite, param3:SharedObject, param4:GameInputDevice) : void
      {
         var _loc5_:TextField = null;
         this.musicOn_txt.format = SoundManager.musicOn ? AllTextFormats.toggleOn_textFormat : AllTextFormats.toggleOff_textFormat;
         this.musicOff_txt.format = SoundManager.musicOn ? AllTextFormats.toggleOff_textFormat : AllTextFormats.toggleOn_textFormat;
         this.soundOn_txt.format = SoundManager.soundOn ? AllTextFormats.toggleOn_textFormat : AllTextFormats.toggleOff_textFormat;
         this.soundOff_txt.format = SoundManager.soundOn ? AllTextFormats.toggleOff_textFormat : AllTextFormats.toggleOn_textFormat;
         this.qualityLow_txt.format = param1.quality == StageQuality.LOW.toUpperCase() ? AllTextFormats.qualityOn_textFormat : AllTextFormats.qualityOff_textFormat;
         this.qualityMedium_txt.format = param1.quality == StageQuality.MEDIUM.toUpperCase() ? AllTextFormats.qualityOn_textFormat : AllTextFormats.qualityOff_textFormat;
         this.qualityHigh_txt.format = param1.quality == StageQuality.HIGH.toUpperCase() ? AllTextFormats.qualityOn_textFormat : AllTextFormats.qualityOff_textFormat;
         this.ignoreTradeOn_txt.format = ignoreTrades ? AllTextFormats.toggleOn_textFormat : AllTextFormats.toggleOff_textFormat;
         this.ignoreTradeOff_txt.format = ignoreTrades ? AllTextFormats.toggleOff_textFormat : AllTextFormats.toggleOn_textFormat;
         this.ignorePMsOn_txt.format = ignorePMs ? AllTextFormats.toggleOn_textFormat : AllTextFormats.toggleOff_textFormat;
         this.ignorePMsOff_txt.format = ignorePMs ? AllTextFormats.toggleOff_textFormat : AllTextFormats.toggleOn_textFormat;
         this.controllerOff_txt.format = controllerOn ? AllTextFormats.toggleOff_textFormat : AllTextFormats.toggleOn_textFormat;
         this.controllerOn_txt.format = controllerOn ? AllTextFormats.toggleOn_textFormat : AllTextFormats.toggleOff_textFormat;
         this.controller_txt.text = param4 == null ? "not found" : param4.name;
         this.defineButtons_btn.visible = this.controller_txt.text != "not found";
         this.fullscreenOff_txt.format = param1.displayState != StageDisplayState.FULL_SCREEN_INTERACTIVE ? AllTextFormats.toggleOn_textFormat : AllTextFormats.toggleOff_textFormat;
         this.fullscreenOn_txt.format = param1.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE ? AllTextFormats.toggleOn_textFormat : AllTextFormats.toggleOff_textFormat;
         if(Stats.missionStats["The Black Hooded Hatchet"].completed == false)
         {
            this.cutscene2_txt.useHandCursor = this.cutscene2_txt.touchable = false;
            this.cutscene2_txt.alpha = 0.5;
         }
         if(Stats.missionStats["Look Like the Lost Warrior"].started == false)
         {
            this.cutscene3_txt.useHandCursor = this.cutscene3_txt.touchable = false;
            this.cutscene3_txt.alpha = 0.5;
         }
         if(Stats.missionStats["Ride a Pet"].started == false)
         {
            this.cutscene4_txt.useHandCursor = this.cutscene4_txt.touchable = false;
            this.cutscene4_txt.alpha = 0.5;
         }
         if(Stats.missionStats["Find the Cult\'s Hideout"].started == false)
         {
            this.cutscene5_txt.useHandCursor = this.cutscene5_txt.touchable = false;
            this.cutscene5_txt.alpha = 0.5;
         }
         if(Stats.missionStats["Catch Every Fish"].started == false)
         {
            this.cutscene6_txt.useHandCursor = this.cutscene6_txt.touchable = false;
            this.cutscene6_txt.alpha = 0.5;
         }
         if(Stats.missionStats["Solve Philbert\'s Puzzle"].started == false)
         {
            this.cutscene7_txt.useHandCursor = this.cutscene7_txt.touchable = false;
            this.cutscene7_txt.alpha = 0.5;
         }
         if(Stats.missionStats["Reach High Energy Level"].started == false)
         {
            this.cutscene8_txt.useHandCursor = this.cutscene8_txt.touchable = false;
            this.cutscene8_txt.alpha = 0.5;
         }
         param3.data.ignoreTrades = ignoreTrades;
         param3.data.ignorePMs = ignorePMs;
         param3.data.quality = param1.quality;
         param3.data.musicOn = SoundManager.musicOn;
         param3.data.soundOn = SoundManager.soundOn;
         param3.data.controllerOn = controllerOn;
         var _loc6_:Vector.<TextField> = new Vector.<TextField>();
         var _loc7_:int = numChildren;
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            if(getChildAt(_loc8_) is TextField)
            {
               TextField(getChildAt(_loc8_)).batchable = true;
               if(TextField(getChildAt(_loc8_)).format.color == 16776960)
               {
                  _loc6_.push(TextField(getChildAt(_loc8_)));
               }
            }
            _loc8_++;
         }
         for each(_loc5_ in _loc6_)
         {
            setChildIndex(_loc5_,numChildren - 1);
         }
         try
         {
            param3.flush();
         }
         catch(_error:Error)
         {
         }
      }
   }
}

