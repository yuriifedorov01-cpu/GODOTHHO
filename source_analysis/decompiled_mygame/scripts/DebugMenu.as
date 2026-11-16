package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1727")]
   public dynamic class DebugMenu extends MovieClip
   {
      
      public var closeDebug_btn:SimpleButton;
      
      public var debugInput_txt:TextField;
      
      public var debug_txt:TextField;
      
      public function DebugMenu()
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

