package com.game_objects
{
   import com.helpers.*;
   import com.math.*;
   import com.utilities.*;
   import flash.geom.Rectangle;
   import starling.display.Image;
   import starling.extensions.lighting.*;
   import starling.textures.*;
   
   public class WaterBubble extends Image
   {
      
      private var velY:Number;
      
      private var velX:Number;
      
      public var zeroBounds:Rectangle;
      
      public function WaterBubble(param1:String = "blue")
      {
         var _loc2_:LightStyle = null;
         super(Assets.items_textureAtlas.getTexture(param1 + " water bubble"));
         pivotX += width / 2;
         pivotY += height / 2;
         this.velX = Math.random() * RanOne.ranOne();
         this.velY = 1 + Math.random() * 2;
         scaleX = scaleY = 0.4 + (Math.random() - 0.4);
         touchable = false;
         if(GameMain.lighting)
         {
            _loc2_ = new LightStyle(Assets.itemsPetsLightMap_textureAtlas.getTexture(param1 + " water bubble"));
            _loc2_.ambientRatio = 0.3;
            _loc2_.diffuseRatio = 0.7;
            _loc2_.specularRatio = 0.7;
            _loc2_.shininess = 20;
            _loc2_.textureSmoothing = TextureSmoothing.NONE;
            style = _loc2_;
         }
      }
      
      public function onEnter(param1:Vector.<WaterBubble>, param2:int) : void
      {
         if(this.rise() == true)
         {
            removeFromParent(true);
            param1.removeAt(param2);
            return;
         }
      }
      
      public function rise() : Boolean
      {
         x -= this.velX;
         y -= this.velY;
         this.zeroBounds.x -= this.velX;
         this.zeroBounds.y -= this.velY;
         if(TileHandler.waterHit_bitmapData.getPixel(this.zeroBounds.x,this.zeroBounds.y) > 0)
         {
            return false;
         }
         return true;
      }
   }
}

