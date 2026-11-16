package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol581")]
   public dynamic class Tutorial extends MovieClip
   {
      
      public var nextTutorial_btn:SimpleButton;
      
      public function Tutorial()
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

