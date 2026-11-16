package com.game_objects
{
   import starling.display.MovieClip;
   import starling.textures.*;
   
   public class YellowExplosion extends MovieClip
   {
      
      public static var info_array:Array;
      
      private var gameMain:GameMain;
      
      public function YellowExplosion(param1:GameMain)
      {
         this.gameMain = param1;
         super(TextureAtlas(info_array[0]).getTextures("yellowExplosion_"),30);
         pivotX = info_array[1];
         pivotY = info_array[2];
         touchable = false;
         textureSmoothing = TextureSmoothing.NONE;
      }
   }
}

