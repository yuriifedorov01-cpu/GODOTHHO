package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1629")]
   public dynamic class GuildListItem extends MovieClip
   {
      
      public var membersAmount_txt:TextField;
      
      public var name_txt:TextField;
      
      public function GuildListItem()
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

