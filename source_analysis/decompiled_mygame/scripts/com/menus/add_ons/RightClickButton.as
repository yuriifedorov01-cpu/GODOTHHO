package com.menus.add_ons
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol603")]
   public class RightClickButton extends MovieClip
   {
      
      public var read_txt:TextField;
      
      public var panel_btn:SimpleButton;
      
      public function RightClickButton(param1:String)
      {
         super();
         this.read_txt.text = param1;
         this.read_txt.mouseEnabled = false;
      }
   }
}

