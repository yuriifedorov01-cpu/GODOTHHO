package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1623")]
   public dynamic class InfoMenu extends MovieClip
   {
      
      public var info_txt:TextField;
      
      public function InfoMenu()
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

