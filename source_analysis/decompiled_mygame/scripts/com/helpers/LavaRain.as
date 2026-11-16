package com.helpers
{
   import flash.display.Stage;
   import flash.display3D.*;
   import starling.core.*;
   import starling.display.*;
   import starling.textures.*;
   
   public class LavaRain extends Sprite
   {
      
      private static const FlameDropXML:Class = LavaRain_FlameDropXML;
      
      private static const FlameDropPNG:Class = LavaRain_FlameDropPNG;
      
      private static const flameDrop_xml:XML = XML(new FlameDropXML());
      
      private static const flameDrop_texture:Texture = Texture.fromEmbeddedAsset(FlameDropPNG,false,false,1,Context3DTextureFormat.BGRA_PACKED);
      
      public static const flameDrop_textureAtlas:TextureAtlas = new TextureAtlas(flameDrop_texture,flameDrop_xml);
      
      public var mainStage:flash.display.Stage;
      
      public var rain_array:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      public function LavaRain(param1:flash.display.Stage, param2:int)
      {
         super();
         this.mainStage = param1;
         touchable = false;
         var _loc3_:int = 0;
         while(_loc3_ < param2)
         {
            this.createFlameDrop();
            _loc3_++;
         }
      }
      
      public function createFlameDrop() : void
      {
         var _loc1_:MovieClip = null;
         _loc1_ = null;
         _loc1_ = new MovieClip(flameDrop_textureAtlas.getTextures("fire rain"),15);
         _loc1_.x = -300 + Math.random() * (this.mainStage.stageWidth + 300);
         _loc1_.y = Math.random() * this.mainStage.stageHeight;
         _loc1_.touchable = false;
         _loc1_.textureSmoothing = TextureSmoothing.NONE;
         _loc1_.scaleX = _loc1_.scaleY = 0.7 + Math.random() * 0.3;
         addChild(_loc1_);
         this.rain_array.push(_loc1_);
         Starling.juggler.add(_loc1_);
      }
      
      public function handleRain() : void
      {
         var _loc1_:int = int(this.rain_array.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this.rain_array[_loc2_].x += 14 * this.rain_array[_loc2_].scaleX;
            this.rain_array[_loc2_].y += 22 * this.rain_array[_loc2_].scaleY;
            if(this.rain_array[_loc2_].y > this.mainStage.stageHeight + 30)
            {
               this.rain_array[_loc2_].x = -300 + Math.random() * (this.mainStage.stageWidth + 300);
               this.rain_array[_loc2_].y = -35;
            }
            _loc2_++;
         }
      }
   }
}

