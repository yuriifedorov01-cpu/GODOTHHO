package com.helpers
{
   import com.utilities.*;
   import flash.display.*;
   import flash.display3D.*;
   import starling.core.*;
   import starling.display.*;
   import starling.textures.*;
   
   public class AreaCreator
   {
      
      private static var callback:Function;
      
      private static var bgCallback:Function;
      
      public static var cloud1:Image;
      
      public static var cloud2:Image;
      
      public static var sky:Image;
      
      public static var gameMain:GameMain;
      
      private static var lastRequestedArea:uint = 1;
      
      private static var __previousRequestedArea:uint = 1;
      
      public static var background1:starling.display.Sprite = new Sprite();
      
      public static var background2:starling.display.Sprite = new Sprite();
      
      public static var background3:starling.display.Sprite = new Sprite();
      
      private static var __background1Width:uint = 0;
      
      private static var __background2Width:uint = 0;
      
      private static var __background3Width:uint = 0;
      
      private static var __background1Height:uint = 0;
      
      private static var __background2Height:uint = 0;
      
      private static var __background3Height:uint = 0;
      
      public function AreaCreator()
      {
         super();
      }
      
      public static function getBGArt(param1:uint, param2:Function = null) : Boolean
      {
         bgCallback = param2;
         __previousRequestedArea = lastRequestedArea;
         lastRequestedArea = param1;
         if(getAreaTheme(param1) != 18 && getAreaTheme(param1) != 19 && getAreaTheme(param1) != 20)
         {
            if(Assets.main_assetManager.getTextureAtlas("backgrounds" + getAreaTheme(param1)) == null)
            {
               Assets.main_assetManager.textureFormat = Context3DTextureFormat.BGRA_PACKED;
               Assets.main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/backgrounds/backgrounds" + getAreaTheme(param1) + ".png?cb=2");
               Assets.main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/backgrounds/backgrounds" + getAreaTheme(param1) + ".xml?cb=2");
               Assets.main_assetManager.loadQueue(onAssetsProgress);
               return false;
            }
            onAssetsProgress(1);
            return true;
         }
         bgCallback();
         return true;
      }
      
      private static function onAssetsProgress(param1:Number) : void
      {
         var _loc3_:Image = null;
         var _loc2_:int = 0;
         _loc3_ = null;
         var _loc4_:Image = null;
         var _loc5_:Image = null;
         var _loc6_:Image = null;
         var _loc7_:Image = null;
         var _loc8_:Image = null;
         if(param1 == 1)
         {
            _loc2_ = int(getAreaTheme(lastRequestedArea));
            if(getAreaTheme(__previousRequestedArea) != _loc2_ || sky == null)
            {
               background1.removeChildren(0,-1,true);
               background2.removeChildren(0,-1,true);
               background3.removeChildren(0,-1,true);
               if(Assets.main_assetManager.getTextureAtlas("backgrounds" + _loc2_) == null)
               {
                  _loc2_ = 1;
               }
               _loc3_ = new Image(Assets.main_assetManager.getTextureAtlas("backgrounds" + _loc2_).getTexture("background 1"));
               _loc3_.x -= 250;
               background1.addChild(_loc3_);
               _loc4_ = new Image(Assets.main_assetManager.getTextureAtlas("backgrounds" + _loc2_).getTexture("background 1"));
               _loc4_.x += _loc4_.width * 2 - 250;
               _loc4_.scaleX = -1;
               background1.addChild(_loc4_);
               _loc5_ = new Image(Assets.main_assetManager.getTextureAtlas("backgrounds" + _loc2_).getTexture("background 2"));
               _loc5_.x -= 300;
               background2.addChild(_loc5_);
               _loc6_ = new Image(Assets.main_assetManager.getTextureAtlas("backgrounds" + _loc2_).getTexture("background 2"));
               _loc6_.scaleX = -1;
               _loc6_.x += _loc6_.width * 2 - 300;
               background2.addChild(_loc6_);
               _loc7_ = new Image(Assets.main_assetManager.getTextureAtlas("backgrounds" + _loc2_).getTexture("background 3"));
               _loc7_.x -= 200;
               background3.addChild(_loc7_);
               _loc8_ = new Image(Assets.main_assetManager.getTextureAtlas("backgrounds" + _loc2_).getTexture("background 3"));
               _loc8_.x += _loc8_.width * 2 - 200;
               _loc8_.scaleX = -1;
               background3.addChild(_loc8_);
               if(cloud1 != null && cloud1.parent != null)
               {
                  cloud1.removeFromParent(true);
                  cloud2.removeFromParent(true);
               }
               if(Assets.main_assetManager.getTextureAtlas("backgrounds" + _loc2_).getTexture("cloud") != null)
               {
                  cloud1 = new Image(Assets.main_assetManager.getTextureAtlas("backgrounds" + _loc2_).getTexture("cloud"));
                  cloud1.x = -600 + Math.random() * 700;
                  cloud1.y = Math.random() * 150;
                  cloud1.touchable = false;
                  cloud1.textureSmoothing = TextureSmoothing.NONE;
                  cloud2 = new Image(Assets.main_assetManager.getTextureAtlas("backgrounds" + _loc2_).getTexture("cloud"));
                  cloud2.x = -600 + Math.random() * 700;
                  cloud2.y = Math.random() * 150;
                  cloud2.touchable = false;
                  cloud2.textureSmoothing = TextureSmoothing.NONE;
                  gameMain.starlingStage.addChildAt(cloud1,sky == null ? 0 : 1);
                  gameMain.starlingStage.addChildAt(cloud2,sky == null ? 0 : 1);
               }
               if(sky == null)
               {
                  sky = new Image(Assets.main_assetManager.getTextureAtlas("backgrounds" + _loc2_).getTexture("sky"));
               }
               else
               {
                  sky.texture = Assets.main_assetManager.getTextureAtlas("backgrounds" + _loc2_).getTexture("sky");
                  sky.readjustSize();
               }
               if(gameMain.stage.quality == StageQuality.LOW.toUpperCase())
               {
                  sky.height = Starling.current.viewPort.height;
               }
               else
               {
                  sky.height = Starling.current.viewPort.height;
               }
               sky.width = Starling.current.viewPort.width;
               _loc3_.textureSmoothing = _loc4_.textureSmoothing = _loc5_.textureSmoothing = _loc6_.textureSmoothing = _loc7_.textureSmoothing = _loc8_.textureSmoothing = sky.textureSmoothing = TextureSmoothing.NONE;
               _loc3_.touchable = _loc4_.touchable = _loc5_.touchable = _loc6_.touchable = _loc7_.touchable = _loc8_.touchable = sky.touchable = false;
               background1.touchable = background2.touchable = background3.touchable = false;
               checkCreateMoreBG();
            }
            if(bgCallback != null)
            {
               bgCallback();
            }
         }
      }
      
      public static function checkCreateMoreBG() : void
      {
         var _loc1_:Image = null;
         var _loc2_:Image = null;
         _loc1_ = null;
         _loc2_ = null;
         var _loc3_:Image = null;
         var _loc4_:Image = null;
         var _loc5_:Image = null;
         var _loc6_:Image = null;
         if(Assets.main_assetManager.getTextureAtlas("backgrounds" + getAreaTheme(lastRequestedArea)) != null)
         {
            if(Starling.current.viewPort.width > 1300 && background1.numChildren < 3)
            {
               _loc1_ = new Image(Assets.main_assetManager.getTextureAtlas("backgrounds" + getAreaTheme(lastRequestedArea)).getTexture("background 1"));
               _loc1_.x += _loc1_.width * 2 - 256;
               background1.addChild(_loc1_);
            }
            if(Starling.current.viewPort.width > 1700 && background1.numChildren < 4)
            {
               _loc2_ = new Image(Assets.main_assetManager.getTextureAtlas("backgrounds" + getAreaTheme(lastRequestedArea)).getTexture("background 1"));
               _loc2_.x += _loc2_.width * 4 - 256;
               _loc2_.scaleX = -1;
               background1.addChild(_loc2_);
            }
            if(Starling.current.viewPort.width > 1300 && background2.numChildren < 3)
            {
               _loc3_ = new Image(Assets.main_assetManager.getTextureAtlas("backgrounds" + getAreaTheme(lastRequestedArea)).getTexture("background 2"));
               _loc3_.x += _loc3_.width * 2 - 305;
               background2.addChild(_loc3_);
            }
            if(Starling.current.viewPort.width > 1700 && background2.numChildren < 4)
            {
               _loc4_ = new Image(Assets.main_assetManager.getTextureAtlas("backgrounds" + getAreaTheme(lastRequestedArea)).getTexture("background 2"));
               _loc4_.x += _loc4_.width * 4 - 305;
               _loc4_.scaleX = -1;
               background2.addChild(_loc4_);
            }
            if(Starling.current.viewPort.width > 1300 && background3.numChildren < 3)
            {
               _loc5_ = new Image(Assets.main_assetManager.getTextureAtlas("backgrounds" + getAreaTheme(lastRequestedArea)).getTexture("background 3"));
               _loc5_.x += _loc5_.width * 2 - 205;
               background3.addChild(_loc5_);
            }
            if(Starling.current.viewPort.width > 1700 && background3.numChildren < 4)
            {
               _loc6_ = new Image(Assets.main_assetManager.getTextureAtlas("backgrounds" + getAreaTheme(lastRequestedArea)).getTexture("background 3"));
               _loc6_.x += _loc6_.width * 4 - 205;
               _loc6_.scaleX = -1;
               background3.addChild(_loc6_);
            }
            __background1Width = background1.width;
            __background1Height = background1.height;
            __background2Width = background2.width;
            __background2Height = background2.height;
            __background3Width = background3.width;
            __background3Height = background3.height;
         }
      }
      
      public static function getAreaTheme(param1:uint) : uint
      {
         if(param1 == 139 || param1 == 140 || param1 == 141 || param1 == 139 || param1 == 140 || param1 == 141 || param1 == 119 || param1 == 120 || param1 == 121 || param1 == 122 || param1 == 123 || param1 == 15 || param1 == 16 || param1 == 17 || param1 == 124 || param1 == 117 || param1 == 118 || param1 == 39 || param1 == 128 || param1 == 129 || param1 == 133 || param1 == 130 || param1 == 131 || param1 == 132 || param1 == 92 || param1 == 74 || param1 == 79)
         {
            if(param1 == 119 || param1 == 120 || param1 == 121 || param1 == 122 || param1 == 123)
            {
               return 22;
            }
            if(param1 == 15 || param1 == 16 || param1 == 17)
            {
               return 23;
            }
            if(param1 == 124 || param1 == 117 || param1 == 118)
            {
               return 24;
            }
            if(param1 == 39)
            {
               return 25;
            }
            if(param1 == 128 || param1 == 129 || param1 == 130 || param1 == 131 || param1 == 132 || param1 == 133)
            {
               return 26;
            }
            if(param1 == 139 || param1 == 140 || param1 == 141)
            {
               return 27;
            }
            if(param1 == 92)
            {
               return 28;
            }
            if(param1 == 145)
            {
               return 30;
            }
            return 19;
         }
         if(param1 == 93 || param1 == 94)
         {
            return 20;
         }
         if(param1 == 1 || param1 == 2 || param1 == 3 || param1 == 4 || param1 == 5 || param1 == 6 || param1 == 7 || param1 == 8)
         {
            return 1;
         }
         if(param1 == 44 || param1 == 45 || param1 == 46 || param1 == 47 || param1 == 48 || param1 == 49 || param1 == 50)
         {
            return 2;
         }
         if(param1 == 52 || param1 == 53 || param1 == 54 || param1 == 55 || param1 == 56 || param1 == 57 || param1 == 64 || param1 == 119 || param1 == 120 || param1 == 121 || param1 == 122 || param1 == 123 || param1 == 127 || param1 == 126 || param1 == 110)
         {
            return 3;
         }
         if(param1 == 9 || param1 == 10 || param1 == 11 || param1 == 12 || param1 == 13 || param1 == 14 || param1 == 15 || param1 == 16 || param1 == 17)
         {
            return 4;
         }
         if(param1 == 58 || param1 == 59 || param1 == 60 || param1 == 61 || param1 == 62)
         {
            return 5;
         }
         if(param1 == 111 || param1 == 112 || param1 == 113 || param1 == 114)
         {
            return 6;
         }
         if(param1 == 109 || param1 == 28 || param1 == 29 || param1 == 30 || param1 == 31 || param1 == 32 || param1 == 124 || param1 == 117 || param1 == 118)
         {
            return 10;
         }
         if(param1 == 67 || param1 == 68 || param1 == 69 || param1 == 70 || param1 == 71 || param1 == 72 || param1 == 73 || param1 == 74)
         {
            return 7;
         }
         if(param1 == 75 || param1 == 76 || param1 == 77 || param1 == 78 || param1 == 79 || param1 == 80)
         {
            return 8;
         }
         if(param1 == 81 || param1 == 82 || param1 == 83 || param1 == 84 || param1 == 85)
         {
            return 9;
         }
         if(param1 == 33 || param1 == 34 || param1 == 35 || param1 == 36 || param1 == 37 || param1 == 38 || param1 == 39 || param1 == 40 || param1 == 116)
         {
            return 11;
         }
         if(param1 == 63 || param1 == 115 || param1 == 65 || param1 == 66)
         {
            return 14;
         }
         if(param1 == 101 || param1 == 102 || param1 == 103 || param1 == 95 || param1 == 96 || param1 == 97 || param1 == 98 || param1 == 99 || param1 == 100 || param1 == 109 || param1 == 110 || param1 == 111 || param1 == 112 || param1 == 113)
         {
            return 12;
         }
         if(param1 == 86 || param1 == 87 || param1 == 88 || param1 == 89 || param1 == 90 || param1 == 91 || param1 == 92)
         {
            return 13;
         }
         if(param1 == 18 || param1 == 19 || param1 == 20)
         {
            return 15;
         }
         if(param1 == 41 || param1 == 42 || param1 == 43)
         {
            return 16;
         }
         if(param1 == 104 || param1 == 105 || param1 == 106 || param1 == 107 || param1 == 108)
         {
            return 17;
         }
         if(param1 == 21 || param1 == 22 || param1 == 23 || param1 == 24 || param1 == 25 || param1 == 26 || param1 == 27 || param1 == 125)
         {
            return 18;
         }
         if(param1 == 134 || param1 == 135 || param1 == 136 || param1 == 137 || param1 == 138)
         {
            return 21;
         }
         if(param1 == 142 || param1 == 143 || param1 == 144)
         {
            return 29;
         }
         if(param1 == 145)
         {
            return 30;
         }
         return 1;
      }
      
      public static function preventBGOffscreenX() : void
      {
         if(background1.x + background1Width - 250 < Starling.current.viewPort.width / Starling.contentScaleFactor)
         {
            background1.x = Starling.current.viewPort.width - background1Width + 250;
         }
         else if(AreaCreator.background1.x - 250 > 0)
         {
            AreaCreator.background1.x = 250;
         }
         if(background2.x + background2Width - 300 < Starling.current.viewPort.width / Starling.contentScaleFactor)
         {
            background2.x = Starling.current.viewPort.width - background2Width + 300;
         }
         else if(background2.x - 300 > 0)
         {
            background2.x = 300;
         }
         if(background3.x + background3Width - 300 < Starling.current.viewPort.width / Starling.contentScaleFactor)
         {
            background3.x = Starling.current.viewPort.width - background3Width + 200;
         }
         else if(background3.x - 200 > 0)
         {
            background3.x = 200;
         }
      }
      
      public static function preventBGOffscreenY() : void
      {
         if(background1.y + background1Height < Starling.current.viewPort.height / Starling.contentScaleFactor)
         {
            background1.y = Starling.current.viewPort.height / Starling.contentScaleFactor - background1Height;
         }
         if(background2.y + background2Height < Starling.current.viewPort.height / Starling.contentScaleFactor - 100)
         {
            background2.y = Starling.current.viewPort.height / Starling.contentScaleFactor - background2Height - 100;
         }
         if(background3.y + background3Height < Starling.current.viewPort.height / Starling.contentScaleFactor - 200)
         {
            background3.y = Starling.current.viewPort.height / Starling.contentScaleFactor - background3Height - 200;
         }
      }
      
      public static function previousRequestedArea() : uint
      {
         return __previousRequestedArea;
      }
      
      public static function get background1Width() : uint
      {
         return __background1Width;
      }
      
      public static function get background2Width() : uint
      {
         return __background2Width;
      }
      
      public static function get background3Width() : uint
      {
         return __background3Width;
      }
      
      public static function get background1Height() : uint
      {
         return __background1Height;
      }
      
      public static function get background2Height() : uint
      {
         return __background2Height;
      }
      
      public static function get background3Height() : uint
      {
         return __background3Height;
      }
   }
}

