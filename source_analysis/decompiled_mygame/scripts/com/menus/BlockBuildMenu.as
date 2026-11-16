package com.menus
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1801")]
   public dynamic class BlockBuildMenu extends MovieClip
   {
      
      public var block_txt:TextField;
      
      public var craftBlock_btn:SimpleButton;
      
      public var hitArea_mc:MovieClip;
      
      public var scrollBG_mc:MovieClip;
      
      public var scroll_btn:SimpleButton;
      
      public var stats_txt:TextField;
      
      public var title_txt:TextField;
      
      public var x_btn:SimpleButton;
      
      public function BlockBuildMenu()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

