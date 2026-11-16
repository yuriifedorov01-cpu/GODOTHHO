package com.menus
{
   import fl.controls.ColorPicker;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1789")]
   public final class BullhornMenu extends GameMenu
   {
      
      public var colorPicker:ColorPicker;
      
      public var hitArea_mc:MovieClip;
      
      public var shout_btn:SimpleButton;
      
      public var shout_txt:TextField;
      
      public var title_txt:TextField;
      
      public var x_btn:SimpleButton;
      
      public function BullhornMenu()
      {
         super();
         addFrameScript(0,this.frame1);
         this.colorPicker.colors = [16711680,65280,8421504,8388608,8388736,16711935,32768,8421376,16776960,26367,32896,13421568,16737792,3394611,65433,3394815,10040319];
         this.colorPicker.setSize(40,40);
         this.colorPicker.setStyle("swatchWidth",20);
         this.colorPicker.setStyle("swatchHeight",20);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

