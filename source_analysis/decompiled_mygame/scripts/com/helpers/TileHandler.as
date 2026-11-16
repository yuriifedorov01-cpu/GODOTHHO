package com.helpers
{
   import com.game_objects.*;
   import com.utilities.*;
   import flash.display.*;
   import flash.display3D.*;
   import flash.geom.*;
   import flash.utils.ByteArray;
   import starling.MainStarlingStage;
   import starling.display.*;
   import starling.extensions.lighting.*;
   import starling.textures.*;
   
   public final class TileHandler
   {
      
      private static var block2_data:BitBitmapData;
      
      private static var block6_data:BitBitmapData;
      
      private static var block7_data:BitBitmapData;
      
      private static var block8_data:BitBitmapData;
      
      private static var block9_data:BitBitmapData;
      
      private static var block10_data:BitBitmapData;
      
      private static var block11_data:BitBitmapData;
      
      private static var block12_data:BitBitmapData;
      
      private static var block17_data:BitBitmapData;
      
      private static var block18_data:BitBitmapData;
      
      public static var mainArt_textureAtlas:TextureAtlas;
      
      public static var foregroundArt_textureAtlas:TextureAtlas;
      
      public static var levelHit_bitmap:Bitmap;
      
      public static var ground2Hit_bitmap:Bitmap;
      
      public static var ground3Hit_bitmap:Bitmap;
      
      public static var waterHit_bitmap:Bitmap;
      
      public static var starlingMain:MainStarlingStage;
      
      private static var blueMushArea_mc:BlueMushroomAreaTiles = new BlueMushroomAreaTiles();
      
      private static var redMushArea_mc:RedMushroomTiles = new RedMushroomTiles();
      
      private static var fairyArea_mc:FairyAreaTiles = new FairyAreaTiles();
      
      private static var greenArea_mc:GreenAreaTiles = new GreenAreaTiles();
      
      private static var beholderArea_mc:BeholderAreaTiles = new BeholderAreaTiles();
      
      private static var aqualantisArea_mc:OceanAreaTiles = new OceanAreaTiles();
      
      private static var beachArea_mc:BeachAreaTiles = new BeachAreaTiles();
      
      private static var dungeonArea_mc:DungeonAreaTiles = new DungeonAreaTiles();
      
      private static var pineForestArea_mc:ForestAreaTiles = new ForestAreaTiles();
      
      private static var hauntedArea_mc:HauntedTiles = new HauntedTiles();
      
      private static var houseArea_mc:HouseTiles = new HouseTiles();
      
      private static var jungleArea_mc:JungleTiles = new JungleTiles();
      
      private static var lavaArea_mc:LavaTiles = new LavaTiles();
      
      private static var petIslandArea_mc:PetAreaTiles = new PetAreaTiles();
      
      private static var pvpArea_mc:PVPTiles = new PVPTiles();
      
      private static var repguanaArea_mc:RepguanaAreaTiles = new RepguanaAreaTiles();
      
      private static var robotArea_mc:RobotAreaTiles = new RobotAreaTiles();
      
      private static var snowArea_mc:SnowAreaTiles = new SnowAreaTiles();
      
      private static var towerArea_mc:TowerAreaTiles = new TowerAreaTiles();
      
      private static var windmillArea_mc:WindmillAreaTiles = new WindmillAreaTiles();
      
      private static var acidArea_mc:AcidAreaTiles = new AcidAreaTiles();
      
      private static var mushIndoor_mc:MushroomHouseTiles = new MushroomHouseTiles();
      
      private static var fairyIndoor_mc:FairyHouseTiles = new FairyHouseTiles();
      
      private static var robotIndoor_mc:RobotHouseTiles = new RobotHouseTiles();
      
      private static var beholderIndoor_mc:BeholderHouseTiles = new BeholderHouseTiles();
      
      private static var barnArea_mc:BarnTiles = new BarnTiles();
      
      private static var acidHouse_mc:AcidHouseTiles = new AcidHouseTiles();
      
      private static var aquaHouse_mc:AquaHouseTiles = new AquaHouseTiles();
      
      private static var cloudArea_mc:CloudAreaTiles = new CloudAreaTiles();
      
      private static var cloudHouse_mc:CloudHouseTiles = new CloudHouseTiles();
      
      private static var blueMushFG_mc:BlueMushroomForegroundTiles = new BlueMushroomForegroundTiles();
      
      private static var redMushFG_mc:RedMushForegroundTiles = new RedMushForegroundTiles();
      
      private static var fairyFG_mc:FairyForegroundTiles = new FairyForegroundTiles();
      
      private static var greenFG_mc:flash.display.MovieClip = new GreenAreaForegroundTiles();
      
      private static var beholderAreaFG_mc:BeholderForegroundTiles = new BeholderForegroundTiles();
      
      private static var aqualantisFG_mc:AquaForegroundTiles = new AquaForegroundTiles();
      
      private static var beachFG_mc:BeachForegroundTiles = new BeachForegroundTiles();
      
      private static var dungeonFG_mc:DungeonForegroundTiles = new DungeonForegroundTiles();
      
      private static var pineForestFG_mc:ForestForegroundTiles = new ForestForegroundTiles();
      
      private static var hauntedFG_mc:HauntedForegroundTiles = new HauntedForegroundTiles();
      
      private static var houseFG_mc:HouseForegroundTiles = new HouseForegroundTiles();
      
      private static var jungleFG_mc:JungleForegroundTiles = new JungleForegroundTiles();
      
      private static var lavaFG_mc:LavaForegroundTiles = new LavaForegroundTiles();
      
      private static var petIslandFG_mc:PetForegroundTiles = new PetForegroundTiles();
      
      private static var pvpForestFG_mc:PVPForegroundTiles = new PVPForegroundTiles();
      
      private static var repguanaFG_mc:RepguanaForegroundTiles = new RepguanaForegroundTiles();
      
      private static var robotFG_mc:RoboForegroundTiles = new RoboForegroundTiles();
      
      private static var snowFG_mc:SnowForegroundTiles = new SnowForegroundTiles();
      
      private static var windmillFG_mc:WindmillForegroundTiles = new WindmillForegroundTiles();
      
      private static var acidFG_mc:AcidForegroundTiles = new AcidForegroundTiles();
      
      private static var mushIndoorFG_mc:MushroomHouseForegroundTiles = new MushroomHouseForegroundTiles();
      
      private static var fairyIndoorFG_mc:FairyHouseForegroundTiles = new FairyHouseForegroundTiles();
      
      private static var robotIndoorFG_mc:RobotHouseForegroundTiles = new RobotHouseForegroundTiles();
      
      private static var beholderIndoorFG_mc:BeholderHouseForegroundTiles = new BeholderHouseForegroundTiles();
      
      private static var barnFG_mc:BarnForegroundTiles = new BarnForegroundTiles();
      
      private static var acidHouseFG_mc:AcidHouseForegroundTiles = new AcidHouseForegroundTiles();
      
      private static var aquaHouseFG_mc:AquaHouseForegroundTiles = new AquaHouseForegroundTiles();
      
      private static var cloudFG_mc:CloudForegroundTiles = new CloudForegroundTiles();
      
      private static var cloudHouseFG_mc:CloudHouseForegroundTiles = new CloudHouseForegroundTiles();
      
      public static var levelHit_bitmapData:BitBitmapData = new BitBitmapData(1,1);
      
      public static var waterHit_bitmapData:BitBitmapData = new BitBitmapData(1,1);
      
      public static var ground2Hit_bitmapData:BitBitmapData = new BitBitmapData(1,1);
      
      public static var ground3Hit_bitmapData:BitBitmapData = new BitBitmapData(1,1);
      
      public static var tileMain_array:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
      
      public static var tileGround2_array:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
      
      public static var tileGround3_array:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
      
      public static var tileWater_array:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
      
      public static var tileForeground_array:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
      
      public static var tileArt_array:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
      
      private static var waterAnimateTile_array:Vector.<Image> = new Vector.<Image>();
      
      private static var beholderCopterTile_array:Vector.<Image> = new Vector.<Image>();
      
      private static const visualTile_array:Vector.<Image> = new Vector.<Image>();
      
      private static const visualTileNumber_array:Vector.<uint> = new Vector.<uint>();
      
      private static const visualTileLayer_array:Vector.<int> = new Vector.<int>();
      
      private static var threeFrameCounter:uint = 1;
      
      private static var highestArtIndex:int = -1;
      
      public static var debug:Boolean = false;
      
      private static var counter:int = 0;
      
      public function TileHandler()
      {
         super();
      }
      
      public static function bytesToTileArray(param1:ByteArray, param2:String, param3:uint) : void
      {
         var _loc4_:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(param1.length / param3,true);
         var _loc5_:int = int(_loc4_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_[_loc6_] = new Vector.<int>(param3,true);
            _loc6_++;
         }
         _loc5_ = int(param1.length);
         var _loc7_:uint = 0;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = uint(int(_loc6_ / param3));
            _loc4_[_loc7_][_loc6_ - _loc7_ * param3] = param1[_loc6_] < 255 ? int(param1[_loc6_]) : -1;
            _loc6_++;
         }
         switch(param2)
         {
            case "main ground":
               tileMain_array = _loc4_;
               levelHit_bitmapData = new BitBitmapData(param3 * 165,_loc4_.length * 165);
               break;
            case "ground 2":
               tileGround2_array = _loc4_;
               ground2Hit_bitmapData = new BitBitmapData(param3 * 165,_loc4_.length * 165);
               break;
            case "ground 3":
               tileGround3_array = _loc4_;
               ground3Hit_bitmapData = new BitBitmapData(param3 * 165,_loc4_.length * 165);
               break;
            case "water":
               tileWater_array = _loc4_;
               waterHit_bitmapData = new BitBitmapData(param3 * 165,_loc4_.length * 165);
               break;
            case "foreground":
               tileForeground_array = _loc4_;
               break;
            case "art":
               tileArt_array = _loc4_;
         }
      }
      
      public static function drawTileArray(param1:Vector.<Vector.<int>>, param2:uint, param3:Bitmap, param4:BitBitmapData, param5:Boolean = false) : Bitmap
      {
         var _loc6_:* = undefined;
         var _loc7_:int = 0;
         if(param1.length < 2)
         {
            return null;
         }
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = int(param1[0].length);
         var _loc11_:int = int(param1.length);
         var _loc12_:int = 0;
         while(_loc12_ < _loc11_)
         {
            _loc10_ = int(param1[_loc12_].length);
            _loc7_ = 0;
            while(_loc7_ < _loc10_)
            {
               if(param1[_loc12_][_loc7_] > -1)
               {
                  createTile(param1[_loc12_][_loc7_],_loc7_,_loc12_,param1,param4,param2,param5);
               }
               _loc7_++;
            }
            _loc12_++;
         }
         return null;
      }
      
      public static function createTile(param1:int, param2:int, param3:int, param4:Vector.<Vector.<int>>, param5:BitBitmapData, param6:uint, param7:Boolean = false) : void
      {
         var _loc8_:Texture = null;
         var _loc9_:Image = null;
         var _loc10_:int = 0;
         var _loc11_:TextureAtlas = null;
         var _loc12_:LightStyle = null;
         var _loc13_:Boolean = false;
         var _loc14_:uint = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:BitBitmapData = null;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:BitBitmapData = null;
         var _loc25_:int = -1;
         if(GameMain.isMobile && param6 == 1 && (param1 == 113 || param1 == 114 || param1 == 115 || param1 == 125 || param1 == 126 || param1 == 127 || param1 == 137 || param1 == 139))
         {
            return;
         }
         highestArtIndex = -1;
         var _loc26_:int = int(AreaCreator.getAreaTheme(param6));
         if(param1 > -1)
         {
            if(param7 == false)
            {
               _loc8_ = mainArt_textureAtlas.getTexture("tile_" + param1);
            }
            else
            {
               _loc8_ = foregroundArt_textureAtlas.getTexture("tile_" + param1);
            }
            if(_loc8_ == null)
            {
               _loc8_ = param7 == false ? mainArt_textureAtlas.getTexture("tile_0") : foregroundArt_textureAtlas.getTexture("tile_0");
            }
            _loc10_ = param1;
            _loc25_ = int(TileDefRegistry.aliasBase(param1,param7));
            if(_loc25_ >= 0)
            {
               if(param7 == false)
               {
                  _loc8_ = mainArt_textureAtlas.getTexture("tile_" + _loc25_);
               }
               else
               {
                  _loc8_ = foregroundArt_textureAtlas.getTexture("tile_" + _loc25_);
               }
               if(TileDefRegistry.aliasFlip(param1,param7))
               {
                  _loc9_ = mirroredTile(_loc8_);
               }
               else
               {
                  _loc9_ = new Image(_loc8_);
               }
            }
            else if(param7 == false)
            {
               switch(param1)
               {
                  case 10:
                     _loc10_ = 9;
                     break;
                  case 4:
                     _loc10_ = 2;
                     break;
                  case 16:
                     _loc10_ = 14;
                     break;
                  case 20:
                     if(_loc26_ != 16)
                     {
                        _loc10_ = 18;
                     }
                     else
                     {
                        _loc9_ = new Image(_loc8_);
                     }
                     break;
                  case 21:
                     _loc10_ = 55;
                     break;
                  case 22:
                     _loc10_ = 54;
                     break;
                  case 33:
                     _loc10_ = 67;
                     break;
                  case 42:
                     _loc10_ = 62;
                     break;
                  case 50:
                     _loc10_ = 48;
                     break;
                  case 64:
                     _loc10_ = 52;
                     break;
                  case 77:
                     _loc10_ = 75;
                     break;
                  case 78:
                     _loc10_ = 73;
                     break;
                  case 30:
                     if(_loc26_ == 2 || _loc26_ == 4)
                     {
                        _loc9_ = new BouncePad(mainArt_textureAtlas);
                        starlingMain.gameMain.main_juggler.add(BouncePad(_loc9_));
                     }
                     else
                     {
                        _loc9_ = new Image(_loc8_);
                     }
                     break;
                  case 31:
                     _loc9_ = new CoinBox(_loc8_);
                     CoinBox(_loc9_).originalX = param2 * 165;
                     CoinBox(_loc9_).originalY = param3 * 165;
                     break;
                  default:
                     _loc9_ = new Image(_loc8_);
               }
               if(_loc9_ == null)
               {
                  _loc9_ = mirroredTile(mainArt_textureAtlas.getTexture("tile_" + _loc10_));
               }
            }
            else
            {
               _loc9_ = new Image(_loc8_);
            }
            _loc9_.x = param2 * 165;
            _loc9_.y = param3 * 165;
            _loc9_.setVertexPosition(0,0,0);
            _loc9_.setVertexPosition(1,166,0);
            _loc9_.setVertexPosition(2,0,166);
            _loc9_.setVertexPosition(3,166,166);
            _loc9_.name = (param7 ? "FG" : "") + "mainArt" + visualTile_array.length;
            _loc9_.touchable = false;
            Image(_loc9_).textureSmoothing = TextureSmoothing.NONE;
            visualTile_array.push(_loc9_);
            visualTileNumber_array.push(_loc10_);
            visualTileLayer_array.push(arrayToLayerNum(param4));
            if(param7 == false)
            {
               starlingMain.c_mc.addChildAt(_loc9_,0);
            }
            else
            {
               starlingMain.c_mc.addChild(_loc9_);
            }
            if(GameMain.lighting)
            {
               _loc11_ = param7 ? Assets.greenAreaFGLightMap_textureAtlas : Assets.greenAreaLightMap_textureAtlas;
               _loc12_ = new LightStyle(_loc11_.getTexture("tile_" + _loc10_));
               _loc12_.ambientRatio = 0.3;
               _loc12_.diffuseRatio = 0.7;
               _loc12_.specularRatio = 0.1;
               _loc12_.shininess = 1;
               _loc12_.textureSmoothing = TextureSmoothing.NONE;
               _loc9_.style = _loc12_;
            }
            if(param7)
            {
               _loc13_ = false;
               switch(_loc26_)
               {
                  case 1:
                     if(param1 == 19)
                     {
                        _loc13_ = true;
                     }
                     break;
                  case 2:
                     if(param1 == 14)
                     {
                        _loc13_ = true;
                     }
                     break;
                  case 3:
                     if(param1 == 9)
                     {
                        _loc13_ = true;
                     }
                     break;
                  case 4:
                     if(param1 == 14)
                     {
                        _loc13_ = true;
                     }
                     break;
                  case 5:
                     if(param1 == 14)
                     {
                        _loc13_ = true;
                     }
                     break;
                  case 7:
                     if(param1 == 14)
                     {
                        _loc13_ = true;
                     }
                     break;
                  case 8:
                     if(param1 == 14)
                     {
                        _loc13_ = true;
                     }
                     break;
                  case 9:
                     if(param1 == 14)
                     {
                        _loc13_ = true;
                     }
                     break;
                  case 10:
                     if(param1 == 4)
                     {
                        _loc13_ = true;
                     }
                     break;
                  case 11:
                     if(param1 == 24)
                     {
                        _loc13_ = true;
                     }
                     break;
                  case 12:
                     if(param1 == 9)
                     {
                        _loc13_ = true;
                     }
                     break;
                  case 13:
                     if(param1 == 14)
                     {
                        _loc13_ = true;
                     }
                     break;
                  case 14:
                     if(param1 == 14)
                     {
                        _loc13_ = true;
                     }
                     break;
                  case 15:
                     if(param1 == 14)
                     {
                        _loc13_ = true;
                     }
                     break;
                  case 16:
                     if(param1 == 14)
                     {
                        _loc13_ = true;
                     }
                     break;
                  case 17:
                     if(param1 == 14)
                     {
                        _loc13_ = true;
                     }
                     break;
                  case 21:
                     if(param1 == 14)
                     {
                        _loc13_ = true;
                     }
               }
            }
            if(param7 == false && param1 == 25 || param7 == true && _loc13_)
            {
               waterAnimateTile_array.push(_loc9_);
            }
            if(_loc26_ == 11 && param1 == 30)
            {
               beholderCopterTile_array.push(_loc9_);
            }
         }
         else
         {
            _loc14_ = uint(arrayToLayerNum(param4));
            _loc15_ = int(visualTile_array.length);
            _loc16_ = 0;
            while(_loc16_ < _loc15_)
            {
               if(visualTileLayer_array[_loc16_] == _loc14_)
               {
                  if(visualTile_array[_loc16_] is CoinBox)
                  {
                     visualTile_array[_loc16_].x = CoinBox(visualTile_array[_loc16_]).originalX;
                     visualTile_array[_loc16_].y = CoinBox(visualTile_array[_loc16_]).originalY;
                  }
                  if(Math.round(visualTile_array[_loc16_].x) == Math.round(param2 * 165) && Math.round(visualTile_array[_loc16_].y) == Math.round(param3 * 165))
                  {
                     if(visualTile_array[_loc16_] is CoinBox)
                     {
                        _loc17_ = int(CoinBox.coinBox_array.length);
                        _loc18_ = 0;
                        while(_loc18_ < _loc17_)
                        {
                           if(visualTile_array[_loc16_] == CoinBox.coinBox_array[_loc18_])
                           {
                              CoinBox.coinBox_array.removeAt(_loc18_);
                              break;
                           }
                           _loc18_++;
                        }
                     }
                     visualTile_array[_loc16_].removeFromParent(true);
                     visualTile_array.removeAt(_loc16_);
                     visualTileLayer_array.removeAt(_loc16_);
                     break;
                  }
               }
               _loc16_++;
            }
         }
         if(param7 == false && param5 != null)
         {
            _loc20_ = 0;
            _loc21_ = 0;
            _loc22_ = 0;
            _loc23_ = 0;
            param4[param3][param2] = param1;
            if(param1 == 36 || param1 == 44 || param1 == 19 || param1 == 78 || param1 == 73)
            {
               _loc20_ = 165;
               _loc21_ = 140;
               _loc23_ = 25;
            }
            else if(param1 == 14 || param1 == 18)
            {
               _loc20_ = _loc21_ = 140;
               _loc22_ = _loc23_ = 25;
            }
            else if(param1 == 16 || param1 == 20)
            {
               _loc20_ = _loc21_ = 140;
               _loc23_ = 25;
            }
            else if(param1 == 30)
            {
               _loc20_ = 115;
               _loc21_ = 140;
               _loc22_ = 25;
               _loc23_ = 25;
            }
            if(param4 == tileMain_array || param4 == tileWater_array)
            {
               if(param1 == 38 || param1 == 40 || param1 == 72 || param1 == 75 || param1 == 77)
               {
                  _loc20_ = _loc21_ = 165;
               }
               else if(param1 == 48)
               {
                  _loc20_ = 140;
                  _loc21_ = 165;
               }
               else if(param1 == 64)
               {
                  _loc20_ = 140;
                  _loc21_ = 165;
               }
               else if(param1 == 50)
               {
                  _loc20_ = 140;
                  _loc21_ = 165;
                  _loc22_ = 25;
               }
               else if(param1 == 52)
               {
                  _loc20_ = 140;
                  _loc21_ = 165;
                  _loc22_ = 25;
               }
               else if(param1 == 62)
               {
                  _loc19_ = block9_data;
               }
               else if(param1 == 42)
               {
                  _loc19_ = block2_data;
               }
               else if(param1 == 54 || param1 == 10)
               {
                  _loc19_ = block6_data;
                  _loc23_ = 25;
               }
               else if(param1 == 55)
               {
                  _loc19_ = block7_data;
                  _loc23_ = 107;
               }
               else if(param1 == 67)
               {
                  _loc19_ = block8_data;
               }
               else if(param1 == 22 || param1 == 9)
               {
                  _loc19_ = block11_data;
                  _loc23_ = 25;
               }
               else if(param1 == 21)
               {
                  _loc19_ = block10_data;
                  _loc22_ = 49;
                  _loc23_ = 107;
               }
               else if(param1 == 33)
               {
                  _loc19_ = block12_data;
               }
               else if(param1 == 0 || param1 == 25)
               {
                  _loc20_ = _loc21_ = 165;
               }
               else if(param1 == 31)
               {
                  _loc20_ = 50;
                  _loc21_ = 45;
                  _loc22_ = 56;
                  _loc23_ = 61;
               }
               else if(AreaCreator.getAreaTheme(param6) == 13)
               {
                  switch(param1)
                  {
                     case 95:
                        _loc19_ = block17_data;
                        _loc22_ = 40;
                        _loc23_ = 80;
                        PipeController.startCreatePipe(param2,param3,PipeController.SECTION_TOP,Image(_loc9_));
                        break;
                     case 107:
                        _loc20_ = 60;
                        _loc21_ = 165;
                        _loc22_ = 55;
                        PipeController.startCreatePipe(param2,param3,PipeController.SECTION_MID,Image(_loc9_));
                        break;
                     case 119:
                        _loc19_ = block18_data;
                        _loc22_ = 40;
                        PipeController.startCreatePipe(param2,param3,PipeController.SECTION_BOTTOM,Image(_loc9_));
                  }
               }
            }
            if(_loc19_ != null || _loc20_ > 0 && _loc21_ > 0)
            {
               if(_loc19_ != null)
               {
                  param5.drawBitmap(_loc19_,param2 * 165 + _loc22_,param3 * 165 + _loc23_);
               }
               else
               {
                  param5.setPixels(param2 * 165 + _loc22_,param3 * 165 + _loc23_,_loc20_,_loc21_,true);
               }
            }
            else if(param1 == -1)
            {
               _loc24_ = new BitBitmapData(165,165);
               param5.drawBitmap(_loc24_,param2 * 165,param3 * 165);
               _loc24_.clearAll();
            }
            if(TileDefRegistry.has(param1,param7))
            {
               TileDefRegistry.applyMask(param5,param1,param2,param3,param7);
            }
         }
      }
      
      private static function mirroredTile(param1:*) : Image
      {
         var _loc2_:Image = new Image(param1);
         _loc2_.scaleX = -1;
         _loc2_.pivotX = _loc2_.width;
         return _loc2_;
      }
      
      private static function arrayToLayerNum(param1:Vector.<Vector.<int>>) : uint
      {
         if(param1 == tileMain_array)
         {
            return 1;
         }
         if(param1 == tileGround2_array)
         {
            return 2;
         }
         if(param1 == tileGround3_array)
         {
            return 3;
         }
         if(param1 == tileWater_array)
         {
            return 4;
         }
         if(param1 == tileArt_array)
         {
            return 5;
         }
         return 6;
      }
      
      public static function clearAllTileData() : void
      {
         tileMain_array.splice(0,tileMain_array.length);
         tileGround2_array.splice(0,tileGround2_array.length);
         tileGround3_array.splice(0,tileGround3_array.length);
         tileWater_array.splice(0,tileWater_array.length);
         tileForeground_array.splice(0,tileForeground_array.length);
         tileArt_array.splice(0,tileArt_array.length);
         levelHit_bitmapData.clearAll();
         ground2Hit_bitmapData.clearAll();
         ground3Hit_bitmapData.clearAll();
         waterHit_bitmapData.clearAll();
         if(levelHit_bitmap != null)
         {
            starlingMain.gameMain.c_mc.removeChild(levelHit_bitmap);
         }
         if(ground2Hit_bitmap != null)
         {
            starlingMain.gameMain.c_mc.removeChild(ground2Hit_bitmap);
         }
         if(ground3Hit_bitmap != null)
         {
            starlingMain.gameMain.c_mc.removeChild(ground3Hit_bitmap);
         }
         if(waterHit_bitmap != null)
         {
            starlingMain.gameMain.c_mc.removeChild(waterHit_bitmap);
         }
         CommonCalls.emptyArray(visualTile_array,true,true);
         visualTileNumber_array.length = visualTileLayer_array.length = waterAnimateTile_array.length = beholderCopterTile_array.length = 0;
         highestArtIndex = -1;
      }
      
      public static function init(param1:MainStarlingStage) : void
      {
         starlingMain = param1;
         setBoolTiles();
      }
      
      public static function convertAreaArt(param1:uint) : void
      {
         var _loc2_:uint = uint(AreaCreator.getAreaTheme(param1));
         switch(_loc2_)
         {
            case 1:
               convertArtPiece(greenArea_mc,_loc2_,true);
               convertArtPiece(greenFG_mc,1,false);
               break;
            case 2:
               convertArtPiece(redMushArea_mc,_loc2_,true);
               convertArtPiece(redMushFG_mc,_loc2_,false);
               mainArt_textureAtlas.addRegion("bounce pad 1",new Rectangle(990,330,165,165),new Rectangle(0,0,166,233));
               mainArt_textureAtlas.addRegion("bounce pad 2",new Rectangle(0,1297,165,187),new Rectangle(0,22,166,233));
               mainArt_textureAtlas.addRegion("bounce pad 3",new Rectangle(165,1274,165,210),new Rectangle(0,45,166,233));
               mainArt_textureAtlas.addRegion("bounce pad 4",new Rectangle(330,1252,165,233),new Rectangle(0,67,166,233));
               break;
            case 3:
               convertArtPiece(blueMushArea_mc,_loc2_,true);
               convertArtPiece(blueMushFG_mc,_loc2_,false);
               break;
            case 4:
               convertArtPiece(fairyArea_mc,_loc2_,true);
               convertArtPiece(fairyFG_mc,_loc2_,false);
               mainArt_textureAtlas.addRegion("bounce pad 1",new Rectangle(990,330,165,165),new Rectangle(0,0,166,233));
               mainArt_textureAtlas.addRegion("bounce pad 2",new Rectangle(0,1297,165,187),new Rectangle(0,22,166,233));
               mainArt_textureAtlas.addRegion("bounce pad 3",new Rectangle(165,1274,165,210),new Rectangle(0,45,166,233));
               mainArt_textureAtlas.addRegion("bounce pad 4",new Rectangle(330,1252,165,233),new Rectangle(0,67,166,233));
               break;
            case 5:
               convertArtPiece(beachArea_mc,_loc2_,true);
               convertArtPiece(beachFG_mc,_loc2_,false);
               break;
            case 6:
               convertArtPiece(pvpArea_mc,_loc2_,true);
               convertArtPiece(pvpForestFG_mc,_loc2_,false);
               break;
            case 7:
               convertArtPiece(jungleArea_mc,_loc2_,true);
               convertArtPiece(jungleFG_mc,_loc2_,false);
               break;
            case 8:
               convertArtPiece(pineForestArea_mc,_loc2_,true);
               convertArtPiece(pineForestFG_mc,_loc2_,false);
               break;
            case 9:
               convertArtPiece(snowArea_mc,_loc2_,true);
               convertArtPiece(snowFG_mc,_loc2_,false);
               break;
            case 10:
               convertArtPiece(robotArea_mc,_loc2_,true);
               convertArtPiece(robotFG_mc,_loc2_,false);
               break;
            case 11:
               convertArtPiece(beholderArea_mc,_loc2_,true);
               convertArtPiece(beholderAreaFG_mc,_loc2_,false);
               break;
            case 12:
               convertArtPiece(petIslandArea_mc,_loc2_,true);
               convertArtPiece(petIslandFG_mc,_loc2_,false);
               break;
            case 13:
               convertArtPiece(aqualantisArea_mc,_loc2_,true);
               convertArtPiece(aqualantisFG_mc,_loc2_,false);
               break;
            case 14:
               convertArtPiece(hauntedArea_mc,_loc2_,true);
               convertArtPiece(hauntedFG_mc,_loc2_,false);
               break;
            case 15:
               convertArtPiece(windmillArea_mc,_loc2_,true);
               convertArtPiece(windmillFG_mc,_loc2_,false);
               break;
            case 16:
               convertArtPiece(repguanaArea_mc,_loc2_,true);
               convertArtPiece(repguanaFG_mc,_loc2_,false);
               break;
            case 17:
               convertArtPiece(lavaArea_mc,_loc2_,true);
               convertArtPiece(lavaFG_mc,_loc2_,false);
               break;
            case 18:
               convertArtPiece(dungeonArea_mc,_loc2_,true);
               convertArtPiece(dungeonFG_mc,_loc2_,false);
               break;
            case 19:
               convertArtPiece(houseArea_mc,_loc2_,true);
               convertArtPiece(houseFG_mc,_loc2_,false);
               break;
            case 20:
               convertArtPiece(towerArea_mc,_loc2_,true);
               break;
            case 21:
               convertArtPiece(acidArea_mc,_loc2_,true);
               convertArtPiece(acidFG_mc,_loc2_,false);
               break;
            case 22:
               convertArtPiece(mushIndoor_mc,_loc2_,true);
               convertArtPiece(mushIndoorFG_mc,_loc2_,false);
               break;
            case 23:
               convertArtPiece(fairyIndoor_mc,_loc2_,true);
               convertArtPiece(fairyIndoorFG_mc,_loc2_,false);
               break;
            case 24:
               convertArtPiece(robotIndoor_mc,_loc2_,true);
               convertArtPiece(robotIndoorFG_mc,_loc2_,false);
               break;
            case 25:
               convertArtPiece(beholderIndoor_mc,_loc2_,true);
               convertArtPiece(beholderIndoorFG_mc,_loc2_,false);
               break;
            case 26:
               convertArtPiece(barnArea_mc,_loc2_,true);
               convertArtPiece(barnFG_mc,_loc2_,false);
               break;
            case 27:
               convertArtPiece(acidHouse_mc,_loc2_,true);
               convertArtPiece(acidHouseFG_mc,_loc2_,false);
               break;
            case 28:
               convertArtPiece(aquaHouse_mc,_loc2_,true);
               convertArtPiece(aquaHouseFG_mc,_loc2_,false);
               break;
            case 29:
               convertArtPiece(cloudArea_mc,_loc2_,true);
               convertArtPiece(cloudFG_mc,_loc2_,false);
               break;
            case 30:
               convertArtPiece(cloudHouse_mc,_loc2_,true);
               convertArtPiece(cloudHouseFG_mc,_loc2_,false);
         }
      }
      
      private static function convertArtPiece(param1:flash.display.MovieClip, param2:uint, param3:Boolean) : void
      {
         var _loc4_:uint = param3 == true ? 1980 : 825;
         var _loc5_:uint = param3 == true ? 1980 : 1485;
         var _loc6_:BitmapData = new BitmapData(_loc4_,_loc5_,true,0);
         if(GameMain.isMobile)
         {
            _loc6_.drawWithQuality(param1,null,null,null,null,false,StageQuality.MEDIUM);
         }
         else
         {
            _loc6_.draw(param1);
         }
         var _loc7_:XML = createTileAtlasXML(_loc4_,_loc5_);
         var _loc8_:String = GameMain.isMobile ? Context3DTextureFormat.BGRA_PACKED : Context3DTextureFormat.BGRA;
         var _loc9_:Texture = Texture.fromBitmapData(_loc6_,false,false,1,_loc8_);
         var _loc10_:TextureAtlas = new TextureAtlas(_loc9_,_loc7_);
         if(param3)
         {
            mainArt_textureAtlas = _loc10_;
            mainArt_textureAtlas.texture.root.onRestore = null;
         }
         else
         {
            foregroundArt_textureAtlas = _loc10_;
            foregroundArt_textureAtlas.texture.root.onRestore = null;
         }
         _loc6_.dispose();
      }
      
      public static function createTileAtlasXML(param1:uint, param2:uint) : XML
      {
         var _loc3_:int = 0;
         var _loc4_:uint = param1 / 165;
         var _loc5_:uint = param2 / 165;
         var _loc6_:XML = XML(<TextureAtlas imagePath=""/>);
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         while(_loc8_ < _loc5_)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc6_.appendChild(<SubTexture name={"tile_" + _loc7_} x={165 * _loc3_} y={165 * _loc8_} width="165" height="165"/>);
               _loc7_++;
               _loc3_++;
            }
            _loc8_++;
         }
         return _loc6_;
      }
      
      public static function getTileRegion(param1:Vector.<Vector.<int>>, param2:Rectangle) : int
      {
         if(param2.y <= 0 || param2.x <= 0 || param2.y + param2.height >= TileHandler.tileMain_array.length * 165 || param2.x + param2.width >= TileHandler.tileMain_array[0].length * 165)
         {
            return -1;
         }
         return param1[int((param2.y + param2.height) / 165)][int(param2.x / 165)];
      }
      
      public static function tileSlope(param1:int) : Number
      {
         var _loc2_:int = 0;
         if(TileDefRegistry.has(param1,false))
         {
            return TileDefRegistry.slopeOf(param1,false);
         }
         if(param1 == 54 || param1 == 55 || param1 == 67 || param1 == 10)
         {
            _loc2_ = 27;
         }
         else if(param1 == 21 || param1 == 22 || param1 == 33 || param1 == 9)
         {
            _loc2_ = -27;
         }
         return _loc2_;
      }
      
      public static function onEnterAll(param1:int) : void
      {
         var _loc2_:Image = null;
         var _loc3_:Texture = null;
         var _loc4_:Texture = null;
         var _loc5_:Texture = null;
         var _loc6_:* = undefined;
         ++counter;
         if(counter % 5 == 0)
         {
            for each(_loc2_ in waterAnimateTile_array)
            {
               _loc2_.scaleX *= -1;
               _loc2_.x -= 165 * _loc2_.scaleX;
            }
         }
         if(AreaCreator.getAreaTheme(param1) == 11 && counter % 2 == 0)
         {
            _loc3_ = mainArt_textureAtlas.getTexture("tile_" + 30);
            _loc4_ = mainArt_textureAtlas.getTexture("tile_" + 114);
            _loc5_ = mainArt_textureAtlas.getTexture("tile_" + 126);
            ++threeFrameCounter;
            for each(_loc6_ in beholderCopterTile_array)
            {
               if(_loc6_.texture == _loc3_)
               {
                  _loc6_.texture = _loc4_;
               }
               else if(_loc6_.texture == _loc4_ && threeFrameCounter == 2)
               {
                  _loc6_.texture = _loc5_;
               }
               else if(_loc6_.texture == _loc5_)
               {
                  _loc6_.texture = _loc4_;
               }
               else if(_loc6_.texture == _loc4_)
               {
                  _loc6_.texture = _loc3_;
                  threeFrameCounter = 0;
               }
            }
         }
      }
      
      public static function getHighestMainArtIndex() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(highestArtIndex == -1)
         {
            _loc1_ = -1;
            _loc2_ = -1;
            _loc3_ = int(visualTile_array.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc2_ = starlingMain.c_mc.getChildIndex(visualTile_array[_loc4_]);
               if(foregroundArt_textureAtlas != null && visualTile_array[_loc4_].texture.base != foregroundArt_textureAtlas.texture.base && _loc2_ >= _loc1_)
               {
                  _loc1_ = _loc2_;
               }
               _loc4_++;
            }
            highestArtIndex = _loc1_;
            return highestArtIndex;
         }
         return highestArtIndex;
      }
      
      public static function removeForeground() : void
      {
         var _loc1_:int = int(visualTile_array.length);
         var _loc2_:* = int(_loc1_ - 1);
         while(_loc2_ >= 0)
         {
            if(visualTile_array[_loc2_].name.indexOf("FG") == 0)
            {
               visualTile_array[_loc2_].removeFromParent(true);
               visualTile_array.removeAt(_loc2_);
            }
            _loc2_--;
         }
      }
      
      private static function setBoolTiles() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         block2_data = new BitBitmapData(165,165,true);
         block2_data.setPixels(0,0,25,25,false);
         block6_data = createSlopedTile(165,140);
         block7_data = createSlopedTile(116,58);
         block8_data = new BitBitmapData(165,165,false);
         var _loc3_:uint = 0;
         while(_loc3_ < 165)
         {
            _loc1_ = 0;
            while(_loc1_ < _loc3_ * 2)
            {
               block8_data.setPixel(115 + _loc1_,_loc3_,true);
               _loc1_++;
            }
            _loc3_++;
         }
         var _loc4_:uint = 0;
         while(_loc4_ < 115)
         {
            _loc2_ = 0;
            while(_loc2_ < 165)
            {
               block8_data.setPixel(_loc4_,_loc2_,true);
               _loc2_++;
            }
            _loc4_++;
         }
         block9_data = new BitBitmapData(165,165,true);
         block9_data.setPixels(140,0,25,25,false);
         block10_data = new BitBitmapData(116,58);
         block10_data.drawBitmap(block7_data,0,0);
         block10_data.flipHorizontally();
         block11_data = new BitBitmapData(166,140);
         block11_data.drawBitmap(block6_data,0,0);
         block11_data.flipHorizontally();
         block12_data = new BitBitmapData(165,165);
         block12_data.drawBitmap(block8_data,0,0);
         block12_data.flipHorizontally();
         block17_data = new BitBitmapData(89,91);
         block17_data.setPixels(15,0,61,37,true);
         block17_data.setPixels(0,36,89,55,true);
         block18_data = new BitBitmapData(89,91);
         block18_data.setPixels(15,0,61,37,true);
         block18_data.setPixels(0,36,89,55,true);
      }
      
      private static function createSlopedTile(param1:uint, param2:uint) : BitBitmapData
      {
         var _loc3_:uint = 0;
         var _loc4_:BitBitmapData = new BitBitmapData(param1,param2,false);
         var _loc5_:uint = 0;
         while(_loc5_ < param2)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc5_ * 2)
            {
               _loc4_.setPixel(_loc3_,_loc5_,true);
               _loc3_++;
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public static function restoreTileTextures() : void
      {
         var _loc1_:int = int(visualTile_array.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            if(visualTileLayer_array[_loc2_] != 6)
            {
               visualTile_array[_loc2_].texture = mainArt_textureAtlas.getTexture("tile_" + visualTileNumber_array[_loc2_]);
            }
            else
            {
               visualTile_array[_loc2_].texture = foregroundArt_textureAtlas.getTexture("tile_" + visualTileNumber_array[_loc2_]);
            }
            _loc2_++;
         }
      }
   }
}

