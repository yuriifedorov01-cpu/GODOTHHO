package com.game_objects
{
   import com.helpers.*;
   import com.math.*;
   import com.utilities.*;
   import flash.geom.*;
   import starling.display.*;
   import starling.extensions.lighting.*;
   import starling.textures.*;
   import starling.utils.*;
   
   public class Splatter
   {
      
      private static const splatter_array:Vector.<Image> = new Vector.<Image>();
      
      private static const counter_array:Vector.<int> = new Vector.<int>();
      
      public function Splatter()
      {
         super();
      }
      
      public static function tryCreate(param1:Boolean, param2:int, param3:int, param4:String) : void
      {
         var _loc6_:int = 0;
         var _loc7_:Image = null;
         var _loc5_:int = 0;
         _loc6_ = 0;
         _loc7_ = null;
         var _loc8_:LightStyle = null;
         var _loc9_:int = 0;
         _loc5_ = 0;
         var _loc10_:Rectangle = new Rectangle(param2 - 20,param3 - 20,40,40);
         _loc6_ = int(TileHandler.tileSlope(TileHandler.getTileRegion(TileHandler.tileMain_array,_loc10_)));
         if(param1)
         {
            if(_loc6_ == 0)
            {
               if(TileHandler.levelHit_bitmapData.getPixel(param2 + 45,param3 - 35) > 0 || TileHandler.levelHit_bitmapData.getPixel(param2 - 45,param3 - 35) > 0)
               {
                  return;
               }
               if(!((TileHandler.levelHit_bitmapData.getPixel(param2 + 40,param3 + 35) > 0 || TileHandler.ground2Hit_bitmapData.getPixel(param2 + 40,param3 + 35) > 0 || TileHandler.ground3Hit_bitmapData.getPixel(param2 + 40,param3 + 35) > 0) && (TileHandler.levelHit_bitmapData.getPixel(param2 - 40,param3 + 35) > 0 || TileHandler.ground2Hit_bitmapData.getPixel(param2 - 40,param3 + 35) > 0 || TileHandler.ground3Hit_bitmapData.getPixel(param2 - 40,param3 + 35) > 0)))
               {
                  return;
               }
            }
            _loc5_ = 12 + Math.random() * 10 * RanOne.ranOne();
         }
         else if(TileHandler.levelHit_bitmapData.getPixel(param2 + 45,param3) > 0)
         {
            if(TileHandler.levelHit_bitmapData.getPixel(param2 + 45,param3 - 50) == 0)
            {
               return;
            }
            if(TileHandler.levelHit_bitmapData.getPixel(param2 - 50,param3 + 45) > 0)
            {
               return;
            }
            _loc6_ = 90;
            _loc9_ = 30 + Math.random() * 10 * RanOne.ranOne();
         }
         else
         {
            if(TileHandler.levelHit_bitmapData.getPixel(param2 - 45,param3 - 50) == 0)
            {
               return;
            }
            if(TileHandler.levelHit_bitmapData.getPixel(param2 + 50,param3 + 45) > 0)
            {
               return;
            }
            _loc6_ = -90;
            _loc9_ = -20 + Math.random() * 10 * RanOne.ranOne();
         }
         _loc7_ = new Image(Assets.treesFish_textureAtlas.getTexture(param4));
         _loc7_.x = param2 + _loc9_;
         _loc7_.y = param3 + _loc5_;
         _loc7_.scale = 0.6 + Math.random() * 0.4;
         _loc7_.pivotX = _loc7_.width / 2;
         _loc7_.pivotY = _loc7_.height / 2;
         _loc7_.rotation = deg2rad(_loc6_);
         _loc7_.touchable = false;
         _loc7_.textureSmoothing = TextureSmoothing.NONE;
         SortDepths.addAt(_loc7_,SortDepths.REGION_2);
         splatter_array.push(_loc7_);
         counter_array.push(0);
         if(GameMain.lighting)
         {
            _loc8_ = new LightStyle(Assets.treeFishLighMap_textureAtlas.getTexture(param4));
            _loc8_.ambientRatio = 0.3;
            _loc8_.diffuseRatio = 0.7;
            _loc8_.specularRatio = 0.1;
            _loc8_.shininess = 1;
            _loc8_.textureSmoothing = TextureSmoothing.NONE;
            _loc7_.style = _loc8_;
         }
      }
      
      public static function onEnterAll() : void
      {
         var _loc1_:int = int(splatter_array.length);
         var _loc2_:* = int(_loc1_ - 1);
         while(_loc2_ >= 0)
         {
            ++counter_array[_loc2_];
            if(counter_array[_loc2_] > 1200)
            {
               splatter_array[_loc2_].alpha -= 0.04;
               if(splatter_array[_loc2_].alpha <= 0 || splatter_array[_loc2_].parent == null)
               {
                  splatter_array[_loc2_].removeFromParent(true);
                  splatter_array.removeAt(_loc2_);
                  counter_array.removeAt(_loc2_);
               }
            }
            _loc2_--;
         }
      }
   }
}

