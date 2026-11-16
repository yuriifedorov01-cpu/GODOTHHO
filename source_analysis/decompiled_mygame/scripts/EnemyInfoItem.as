package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1720")]
   public dynamic class EnemyInfoItem extends MovieClip
   {
      
      public var eName_txt:TextField;
      
      public var shine_mc:MovieClip;
      
      public function EnemyInfoItem()
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

