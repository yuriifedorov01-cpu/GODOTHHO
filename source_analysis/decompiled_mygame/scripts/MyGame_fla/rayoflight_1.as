package MyGame_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1417")]
   public dynamic class rayoflight_1 extends MovieClip
   {
      
      public function rayoflight_1()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         this.mouseChildren = false;
         this.mouseEnabled = false;
      }
   }
}

