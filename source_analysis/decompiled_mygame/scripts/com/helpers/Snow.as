package com.helpers
{
   import com.math.*;
   import flash.display.Stage;
   import flash.display3D.*;
   import starling.display.*;
   import starling.textures.*;
   
   public class Snow extends Sprite
   {
      
      private static const SnowflakeXML:Class = Snow_SnowflakeXML;
      
      private static const SnowflakePNG:Class = Snow_SnowflakePNG;
      
      private static const snowflake_xml:XML = XML(new SnowflakeXML());
      
      private static const snowflake_texture:Texture = Texture.fromEmbeddedAsset(SnowflakePNG,false,false,1,Context3DTextureFormat.BGRA_PACKED);
      
      public static const snowflake_textureAtlas:TextureAtlas = new TextureAtlas(snowflake_texture,snowflake_xml);
      
      public var sprite:Sprite;
      
      public var mainStage:flash.display.Stage;
      
      public var snow_array:Vector.<Image> = new Vector.<Image>();
      
      public var fallSpeed_array:Vector.<Number> = new Vector.<Number>();
      
      public var xSpeed_array:Vector.<Number> = new Vector.<Number>();
      
      public function Snow(param1:flash.display.Stage, param2:int = 20)
      {
         super();
         this.mainStage = param1;
         touchable = false;
         var _loc3_:int = 0;
         while(_loc3_ < param2)
         {
            this.createSnowPiece();
            _loc3_++;
         }
      }
      
      public function createSnowPiece() : void
      {
         var _loc1_:Image = null;
         _loc1_ = null;
         _loc1_ = new Image(snowflake_textureAtlas.getTexture("snowflake"));
         _loc1_.x = Math.random() * this.mainStage.stageWidth;
         _loc1_.y = Math.random() * this.mainStage.stageHeight;
         _loc1_.touchable = false;
         _loc1_.textureSmoothing = TextureSmoothing.NONE;
         _loc1_.scaleX = _loc1_.scaleY = 0.4 + Math.random() * 0.6;
         addChild(_loc1_);
         this.snow_array.push(_loc1_);
         this.fallSpeed_array.push(2.5 + Math.random() * 2);
         this.xSpeed_array.push(Math.random() * 2.5 * RanOne.ranOne());
      }
      
      public function handleSnow() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         var _loc2_:int = int(this.snow_array.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.snow_array[_loc1_].x += this.xSpeed_array[_loc1_];
            this.snow_array[_loc1_].y += this.fallSpeed_array[_loc1_];
            if(this.snow_array[_loc1_].y > this.mainStage.stageHeight + 20)
            {
               this.snow_array[_loc1_].x = Math.random() * this.mainStage.stageWidth;
               this.snow_array[_loc1_].y = -20;
            }
            _loc1_++;
         }
      }
   }
}

