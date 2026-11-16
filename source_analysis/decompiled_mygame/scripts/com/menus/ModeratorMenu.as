package com.menus
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   public class ModeratorMenu extends MovieClip
   {
      
      public var modBanLength_txt:TextField;
      
      public var modBanIP_mc:MovieClip;
      
      public var modRemoveItems_mc:MovieClip;
      
      public var modPayingUsername_txt:TextField;
      
      public var modPayCheck_btn:SimpleButton;
      
      public var modPaying_txt:TextField;
      
      public var modBanIP_txt:TextField;
      
      public var modBanIP_btn:SimpleButton;
      
      public var modUnBanIP_btn:SimpleButton;
      
      public var modBanIPReason_txt:TextField;
      
      public var modDUsername_txt:TextField;
      
      public var modDPower_txt:TextField;
      
      public var modDDex_txt:TextField;
      
      public var modDDef_txt:TextField;
      
      public var modDRange_txt:TextField;
      
      public var modDArtillery_txt:TextField;
      
      public var modDHP_txt:TextField;
      
      public var modDMP_txt:TextField;
      
      public function ModeratorMenu()
      {
         super();
         this.modBanLength_txt.restrict = "0-9";
         this.modDPower_txt.restrict = "0-9";
         this.modDDex_txt.restrict = "0-9";
         this.modDDef_txt.restrict = "0-9";
         this.modDRange_txt.restrict = "0-9";
         this.modDArtillery_txt.restrict = "0-9";
         this.modDHP_txt.restrict = "0-9";
         this.modDMP_txt.restrict = "0-9";
      }
   }
}

