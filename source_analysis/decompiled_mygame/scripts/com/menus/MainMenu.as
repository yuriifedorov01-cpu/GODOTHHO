package com.menus
{
   import com.helpers.*;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.*;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1594")]
   public class MainMenu extends MovieClip
   {
      
      public var adventure_mc:MovieClip;
      
      public var back_btn:SimpleButton;
      
      public var credits_btn:SimpleButton;
      
      public var emailChange_btn:SimpleButton;
      
      public var emailChange_txt:TextField;
      
      public var emailPassword_txt:TextField;
      
      public var emailUsernameChange_txt:TextField;
      
      public var emailVerify_txt:TextField;
      
      public var facebookSignIn_btn:SimpleButton;
      
      public var fighterArt_mc:MovieClip;
      
      public var forgotPass_btn:SimpleButton;
      
      public var fullScreen_btn:SimpleButton;
      
      public var fullScreen_txt:TextField;
      
      public var helmetBG_mc:MovieClip;
      
      public var helmetIcon_mc:MovieClip;
      
      public var helmet_mc:MovieClip;
      
      public var heroesBG_mc:MovieClip;
      
      public var heroes_mc:MovieClip;
      
      public var loadingCircle_mc:LoadingCircle;
      
      public var newPassChange_txt:TextField;
      
      public var oldPassChange_txt:TextField;
      
      public var online_txt:TextField;
      
      public var options_btn:SimpleButton;
      
      public var orb1_mc:MovieClip;
      
      public var orb2_mc:MovieClip;
      
      public var orb3_mc:MovieClip;
      
      public var passChange_btn:SimpleButton;
      
      public var passwordPanel_mc:MovieClip;
      
      public var password_txt:TextField;
      
      public var privateServer10_mc:ServerPanel;
      
      public var privateServer11_mc:ServerPanel;
      
      public var privateServer12_mc:ServerPanel;
      
      public var privateServer13_mc:ServerPanel;
      
      public var privateServer14_mc:ServerPanel;
      
      public var privateServer15_mc:ServerPanel;
      
      public var privateServer16_mc:ServerPanel;
      
      public var privateServer17_mc:ServerPanel;
      
      public var privateServer18_mc:ServerPanel;
      
      public var privateServer19_mc:ServerPanel;
      
      public var privateServer1_mc:ServerPanel;
      
      public var privateServer20_mc:ServerPanel;
      
      public var privateServer21_mc:ServerPanel;
      
      public var privateServer22_mc:ServerPanel;
      
      public var privateServer23_mc:ServerPanel;
      
      public var privateServer24_mc:ServerPanel;
      
      public var privateServer25_mc:ServerPanel;
      
      public var privateServer26_mc:ServerPanel;
      
      public var privateServer27_mc:ServerPanel;
      
      public var privateServer28_mc:ServerPanel;
      
      public var privateServer29_mc:ServerPanel;
      
      public var privateServer2_mc:ServerPanel;
      
      public var privateServer30_mc:ServerPanel;
      
      public var privateServer3_mc:ServerPanel;
      
      public var privateServer4_mc:ServerPanel;
      
      public var privateServer5_mc:ServerPanel;
      
      public var privateServer6_mc:ServerPanel;
      
      public var privateServer7_mc:ServerPanel;
      
      public var privateServer8_mc:ServerPanel;
      
      public var privateServer9_mc:ServerPanel;
      
      public var recoverEmail_txt:TextField;
      
      public var register_btn:SimpleButton;
      
      public var rememberMe_mc:MovieClip;
      
      public var rememberMe_txt:TextField;
      
      public var sendPass_btn:SimpleButton;
      
      public var server1_mc:ServerPanel;
      
      public var server2_mc:ServerPanel;
      
      public var server3_mc:ServerPanel;
      
      public var serverName_txt:TextField;
      
      public var serverPVP_mc:ServerPanel;
      
      public var serverPassConfirm_btn:SimpleButton;
      
      public var serverPass_txt:TextField;
      
      public var signInColon_txt:TextField;
      
      public var signIn_btn:SimpleButton;
      
      public var signUp_btn:SimpleButton;
      
      public var sponsor_btn:SimpleButton;
      
      public var sword_mc:MovieClip;
      
      public var usernameChange_txt:TextField;
      
      public var usernamePanel_mc:MovieClip;
      
      public var username_txt:TextField;
      
      public var valid_txt:TextField;
      
      public var version_btn:SimpleButton;
      
      public var version_txt:TextField;
      
      private var gameMain:GameMain;
      
      public var relink:Boolean = false;
      
      public function MainMenu(param1:GameMain)
      {
         super();
         addFrameScript(0,this.frame1);
         this.gameMain = param1;
         addEventListener(Event.ENTER_FRAME,this.onEnter);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
         this.gameMain.c_mc.x -= 2450;
         this.gameMain.c_mc.y += 430;
         this.gameMain.starlingStage.c_mc.x -= 2450;
         this.gameMain.starlingStage.c_mc.y += 430;
      }
      
      private function onEnter(param1:Event) : void
      {
         if(AreaCreator.cloud1 != null)
         {
            AreaCreator.cloud1.x += 1;
            AreaCreator.cloud2.x += 0.5;
            if(AreaCreator.cloud1.x > 1100)
            {
               AreaCreator.cloud1.x = -500;
            }
            if(AreaCreator.cloud2.x > 1100)
            {
               AreaCreator.cloud2.x = -500;
            }
         }
      }
      
      private function onRemoved(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnter);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
         this.gameMain.starlingStage.controls.visible = true;
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

