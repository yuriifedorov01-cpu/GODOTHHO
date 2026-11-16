package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol70")]
   public dynamic class InteractBubble extends MovieClip
   {
      
      public function InteractBubble()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         this.mouseChildren = false;
      }
   }
}

