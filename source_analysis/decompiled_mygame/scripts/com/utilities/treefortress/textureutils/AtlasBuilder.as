package com.utilities.treefortress.textureutils
{
   import com.visual_effects.*;
   import flash.display.*;
   import flash.geom.*;
   import starling.textures.*;
   
   public class AtlasBuilder
   {
      
      public static var packTime:int;
      
      public static var atlasBitmap:BitmapData;
      
      public static var atlasXml:XML;
      
      public function AtlasBuilder()
      {
         super();
      }
      
      public static function containerToTextureAtlas(param1:DisplayObjectContainer, param2:uint, param3:uint, param4:String = "bgra") : TextureAtlas
      {
         var _loc5_:DisplayObject = null;
         var _loc6_:Bitmap = null;
         var _loc7_:Rectangle = null;
         var _loc8_:Rectangle = null;
         var _loc9_:int = 0;
         var _loc10_:Bitmap = null;
         var _loc11_:uint = 0;
         var _loc12_:String = "";
         var _loc13_:Vector.<Bitmap> = new Vector.<Bitmap>();
         var _loc14_:Vector.<uint> = new Vector.<uint>();
         var _loc15_:Vector.<uint> = new Vector.<uint>();
         var _loc16_:Vector.<int> = new Vector.<int>();
         var _loc17_:Vector.<int> = new Vector.<int>();
         var _loc18_:int = param1.numChildren;
         var _loc19_:int = 0;
         while(_loc19_ < _loc18_)
         {
            _loc5_ = param1.getChildAt(_loc19_);
            if(!(_loc5_ is Bitmap))
            {
               _loc12_ = _loc5_.name.split("__").join(" ");
               if(_loc5_ is MovieClip && MovieClip(_loc5_).totalFrames > 1)
               {
                  MovieClip(_loc5_).gotoAndStop(1);
                  _loc8_ = new Rectangle();
                  _loc11_ = uint(MovieClip(_loc5_).totalFrames);
                  _loc9_ = 0;
                  while(_loc9_ < _loc11_)
                  {
                     _loc7_ = _loc5_.getBounds(_loc5_);
                     if(_loc7_.x < _loc8_.x)
                     {
                        _loc8_.x = _loc7_.x;
                     }
                     if(_loc7_.y < _loc8_.y)
                     {
                        _loc8_.y = _loc7_.y;
                     }
                     if(_loc7_.right > _loc8_.right)
                     {
                        _loc8_.right = _loc7_.right;
                     }
                     if(_loc7_.bottom > _loc8_.bottom)
                     {
                        _loc8_.bottom = _loc7_.bottom;
                     }
                     MovieClip(_loc5_).nextFrame();
                     _loc9_++;
                  }
                  MovieClip(_loc5_).gotoAndStop(1);
                  _loc9_ = 0;
                  while(_loc9_ < _loc11_)
                  {
                     _loc12_ = _loc5_.name.split("__").join(" ") + _loc9_;
                     _loc13_.push(DrawToBitmap.drawAsBitmap(_loc5_,_loc12_,false,null,-1,false));
                     DrawToBitmap.cropTransparentPixels(_loc13_[_loc19_]);
                     _loc7_ = _loc5_.getBounds(_loc5_);
                     _loc16_.push(-Math.abs(Math.round(_loc7_.x - _loc8_.x)));
                     _loc17_.push(-Math.abs(Math.round(_loc7_.y - _loc8_.y)));
                     _loc15_.push(Math.round(_loc8_.width));
                     _loc14_.push(Math.round(_loc8_.height));
                     MovieClip(_loc5_).nextFrame();
                     _loc9_++;
                  }
               }
               else
               {
                  _loc10_ = DrawToBitmap.drawAsBitmap(_loc5_,_loc12_,false,null,-1,false);
                  _loc13_.push(_loc10_);
                  DrawToBitmap.cropTransparentPixels(_loc10_);
                  _loc15_.push(Math.round(_loc10_.width));
                  _loc14_.push(Math.round(_loc10_.height));
                  _loc16_.push(0);
                  _loc17_.push(0);
               }
            }
            else
            {
               _loc13_.push(_loc5_);
               _loc16_.push(0);
               _loc17_.push(0);
               _loc15_.push(_loc5_.width);
               _loc14_.push(_loc5_.height);
            }
            _loc19_++;
         }
         var _loc20_:TextureAtlas = AtlasBuilder.build(_loc13_,_loc15_,_loc14_,_loc16_,_loc17_,param2,param3,param4);
         for each(_loc6_ in _loc13_)
         {
            _loc6_.bitmapData.dispose();
            _loc6_ = null;
         }
         _loc13_.length = 0;
         return _loc20_;
      }
      
      private static function build(param1:Vector.<Bitmap>, param2:Vector.<uint>, param3:Vector.<uint>, param4:Vector.<int>, param5:Vector.<int>, param6:int = 2048, param7:int = 2048, param8:String = "bgra") : TextureAtlas
      {
         var _loc9_:Bitmap = null;
         var _loc10_:String = null;
         var _loc11_:Rectangle = null;
         var _loc12_:String = null;
         atlasBitmap = new BitmapData(param6,param7,true,0);
         var _loc13_:MaxRectPacker = new MaxRectPacker(param6,param7);
         var _loc14_:String = "";
         var _loc15_:Matrix = new Matrix();
         var _loc16_:int = 0;
         while(_loc16_ < param1.length)
         {
            _loc9_ = param1[_loc16_];
            _loc10_ = param1[_loc16_].name;
            _loc11_ = _loc13_.quickInsert(_loc9_.width,_loc9_.height);
            if(_loc11_)
            {
               _loc15_.identity();
               _loc15_.translate(_loc11_.x,_loc11_.y);
               atlasBitmap.draw(param1[_loc16_],_loc15_);
               _loc12_ = "<SubTexture name=\"" + _loc10_ + "\" " + "x=\"" + _loc11_.x + "\" y=\"" + _loc11_.y + "\" width=\"" + _loc11_.width + "\" height=\"" + _loc11_.height + "\" frameX=\"" + param4[_loc16_] + "\" frameY=\"" + param5[_loc16_] + "\" " + "frameWidth=\"" + param2[_loc16_] + "\" frameHeight=\"" + param3[_loc16_] + "\"/>";
               _loc14_ += _loc12_;
            }
            _loc16_++;
         }
         _loc14_ = "<TextureAtlas imagePath=\"atlas.png\">" + _loc14_ + "</TextureAtlas>";
         atlasXml = new XML(_loc14_);
         var _loc17_:Texture = Texture.fromBitmapData(atlasBitmap,false,false,1,param8);
         return new TextureAtlas(_loc17_,atlasXml);
      }
   }
}

