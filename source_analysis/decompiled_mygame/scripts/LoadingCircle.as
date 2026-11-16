package
{
   import flash.accessibility.*;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol689")]
   public dynamic class LoadingCircle extends MovieClip
   {
      
      public var loadingText_txt:TextField;
      
      public function LoadingCircle()
      {
         super();
         this.__setAcc_loadingText_txt_loadingcircle_circlelowalpha_0();
      }
      
      internal function __setAcc_loadingText_txt_loadingcircle_circlelowalpha_0() : *
      {
         this.loadingText_txt.accessibilityProperties = new AccessibilityProperties();
         this.loadingText_txt.accessibilityProperties.silent = true;
      }
   }
}

