package com.helpers
{
   import flash.display.Stage;
   import flash.display3D.*;
   import starling.display.*;
   import starling.textures.*;
   import starling.utils.*;
   
   public class Rain extends Sprite
   {
      
      private static const RainDropXML:Class = Rain_RainDropXML;
      
      private static const RainDropPNG:Class = Rain_RainDropPNG;
      
      private static const rainDrop_xml:XML = XML(new RainDropXML());
      
      private static const rainDrop_texture:Texture = Texture.fromEmbeddedAsset(RainDropPNG,false,false,1,Context3DTextureFormat.BGRA_PACKED);
      
      public static const rainDrop_textureAtlas:TextureAtlas = new TextureAtlas(rainDrop_texture,rainDrop_xml);
      
      public var mainStage:flash.display.Stage;
      
      public var rain_array:Vector.<Image> = new Vector.<Image>();
      
      public function Rain(param1:flash.display.Stage, param2:int)
      {
         super();
         this.mainStage = param1;
         touchable = false;
         var _loc3_:int = 0;
         while(_loc3_ < param2)
         {
            this.createRainDrop();
            _loc3_++;
         }
      }
      
      public function createRainDrop() : void
      {
         var _loc1_:Image = null;
         _loc1_ = null;
         _loc1_ = new Image(rainDrop_textureAtlas.getTexture("rain drop"));
         _loc1_.x = -200 + Math.random() * (this.mainStage.stageWidth + 200);
         _loc1_.y = Math.random() * this.mainStage.stageHeight;
         _loc1_.touchable = false;
         _loc1_.textureSmoothing = TextureSmoothing.NONE;
         _loc1_.rotation = deg2rad(65);
         _loc1_.alpha = 0.8;
         _loc1_.scaleX = _loc1_.scaleY = 0.4 + Math.random() * 0.6;
         addChild(_loc1_);
         this.rain_array.push(_loc1_);
      }
      
      public function handleRain() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         var _loc2_:int = int(this.rain_array.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.rain_array[_loc1_].x += 18 * this.rain_array[_loc1_].scaleX;
            this.rain_array[_loc1_].y += 48 * this.rain_array[_loc1_].scaleY;
            if(this.rain_array[_loc1_].y > this.mainStage.stageHeight + 30)
            {
               this.rain_array[_loc1_].x = -200 + Math.random() * (this.mainStage.stageWidth + 200);
               this.rain_array[_loc1_].y = -35;
            }
            _loc1_++;
         }
      }
   }
}

