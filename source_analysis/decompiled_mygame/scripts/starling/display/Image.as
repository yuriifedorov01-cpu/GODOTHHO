package starling.display
{
   import flash.geom.*;
   import starling.rendering.IndexData;
   import starling.rendering.VertexData;
   import starling.textures.Texture;
   import starling.utils.*;
   
   public class Image extends Quad
   {
      
      private static var sPadding:Padding = new Padding();
      
      private static var sBounds:Rectangle = new Rectangle();
      
      private static var sBasCols:Vector.<Number> = new Vector.<Number>(3,true);
      
      private static var sBasRows:Vector.<Number> = new Vector.<Number>(3,true);
      
      private static var sPosCols:Vector.<Number> = new Vector.<Number>(3,true);
      
      private static var sPosRows:Vector.<Number> = new Vector.<Number>(3,true);
      
      private static var sTexCols:Vector.<Number> = new Vector.<Number>(3,true);
      
      private static var sTexRows:Vector.<Number> = new Vector.<Number>(3,true);
      
      private var _scale9Grid:Rectangle;
      
      private var _tileGrid:Rectangle;
      
      public function Image(param1:Texture)
      {
         super(100,100);
         this.texture = param1;
         readjustSize();
      }
      
      public function get scale9Grid() : Rectangle
      {
         return this._scale9Grid;
      }
      
      public function set scale9Grid(param1:Rectangle) : void
      {
         if(param1)
         {
            if(this._scale9Grid == null)
            {
               this._scale9Grid = param1.clone();
            }
            else
            {
               this._scale9Grid.copyFrom(param1);
            }
            readjustSize();
            this._tileGrid = null;
         }
         else
         {
            this._scale9Grid = null;
         }
         this.setupVertices();
      }
      
      public function get tileGrid() : Rectangle
      {
         return this._tileGrid;
      }
      
      public function set tileGrid(param1:Rectangle) : void
      {
         if(param1)
         {
            if(this._tileGrid == null)
            {
               this._tileGrid = param1.clone();
            }
            else
            {
               this._tileGrid.copyFrom(param1);
            }
            this._scale9Grid = null;
         }
         else
         {
            this._tileGrid = null;
         }
         this.setupVertices();
      }
      
      override protected function setupVertices() : void
      {
         if(Boolean(texture) && Boolean(this._scale9Grid))
         {
            this.setupScale9Grid();
         }
         else if(Boolean(texture) && Boolean(this._tileGrid))
         {
            this.setupTileGrid();
         }
         else
         {
            super.setupVertices();
         }
      }
      
      override public function set scaleX(param1:Number) : void
      {
         super.scaleX = param1;
         if(Boolean(texture) && (Boolean(this._scale9Grid) || Boolean(this._tileGrid)))
         {
            this.setupVertices();
         }
      }
      
      override public function set scaleY(param1:Number) : void
      {
         super.scaleY = param1;
         if(Boolean(texture) && (Boolean(this._scale9Grid) || Boolean(this._tileGrid)))
         {
            this.setupVertices();
         }
      }
      
      override public function set texture(param1:Texture) : void
      {
         if(param1 != texture)
         {
            super.texture = param1;
            if(Boolean(this._scale9Grid) && Boolean(param1))
            {
               readjustSize();
            }
         }
      }
      
      private function setupScale9Grid() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Number = Number(NaN);
         var _loc4_:uint = 0;
         var _loc5_:Number = Number(NaN);
         var _loc6_:Texture = this.texture;
         var _loc7_:Rectangle = _loc6_.frame;
         var _loc8_:Number = scaleX > 0 ? scaleX : -scaleX;
         var _loc9_:Number = scaleY > 0 ? scaleY : -scaleY;
         var _loc10_:Number = 1 / _loc8_;
         var _loc11_:Number = 1 / _loc9_;
         var _loc12_:VertexData = this.vertexData;
         var _loc13_:IndexData = this.indexData;
         var _loc14_:int = _loc12_.numVertices;
         var _loc15_:Rectangle = Pool.getRectangle();
         var _loc16_:Rectangle = Pool.getRectangle();
         var _loc17_:Rectangle = Pool.getRectangle();
         var _loc18_:Rectangle = Pool.getRectangle();
         _loc15_.copyFrom(this._scale9Grid);
         _loc16_.setTo(0,0,_loc6_.frameWidth,_loc6_.frameHeight);
         if(_loc7_)
         {
            _loc17_.setTo(-_loc7_.x,-_loc7_.y,_loc6_.width,_loc6_.height);
         }
         else
         {
            _loc17_.copyFrom(_loc16_);
         }
         RectangleUtil.intersect(_loc15_,_loc17_,_loc18_);
         sBasCols[0] = sBasCols[2] = 0;
         sBasRows[0] = sBasRows[2] = 0;
         sBasCols[1] = _loc18_.width;
         sBasRows[1] = _loc18_.height;
         if(_loc17_.x < _loc15_.x)
         {
            sBasCols[0] = _loc15_.x - _loc17_.x;
         }
         if(_loc17_.y < _loc15_.y)
         {
            sBasRows[0] = _loc15_.y - _loc17_.y;
         }
         if(_loc17_.right > _loc15_.right)
         {
            sBasCols[2] = _loc17_.right - _loc15_.right;
         }
         if(_loc17_.bottom > _loc15_.bottom)
         {
            sBasRows[2] = _loc17_.bottom - _loc15_.bottom;
         }
         if(_loc17_.x < _loc15_.x)
         {
            sPadding.left = _loc17_.x * _loc10_;
         }
         else
         {
            sPadding.left = _loc15_.x * _loc10_ + _loc17_.x - _loc15_.x;
         }
         if(_loc17_.right > _loc15_.right)
         {
            sPadding.right = (_loc16_.width - _loc17_.right) * _loc10_;
         }
         else
         {
            sPadding.right = (_loc16_.width - _loc15_.right) * _loc10_ + _loc15_.right - _loc17_.right;
         }
         if(_loc17_.y < _loc15_.y)
         {
            sPadding.top = _loc17_.y * _loc11_;
         }
         else
         {
            sPadding.top = _loc15_.y * _loc11_ + _loc17_.y - _loc15_.y;
         }
         if(_loc17_.bottom > _loc15_.bottom)
         {
            sPadding.bottom = (_loc16_.height - _loc17_.bottom) * _loc11_;
         }
         else
         {
            sPadding.bottom = (_loc16_.height - _loc15_.bottom) * _loc11_ + _loc15_.bottom - _loc17_.bottom;
         }
         sPosCols[0] = sBasCols[0] * _loc10_;
         sPosCols[2] = sBasCols[2] * _loc10_;
         sPosCols[1] = _loc16_.width - sPadding.left - sPadding.right - sPosCols[0] - sPosCols[2];
         sPosRows[0] = sBasRows[0] * _loc11_;
         sPosRows[2] = sBasRows[2] * _loc11_;
         sPosRows[1] = _loc16_.height - sPadding.top - sPadding.bottom - sPosRows[0] - sPosRows[2];
         if(sPosCols[1] < 0)
         {
            _loc3_ = _loc16_.width / (_loc16_.width - _loc15_.width) * _loc8_;
            sPadding.left *= _loc3_;
            sPosCols[0] *= _loc3_;
            sPosCols[1] = 0.0001;
            sPosCols[2] *= _loc3_;
         }
         if(sPosRows[1] < 0)
         {
            _loc3_ = _loc16_.height / (_loc16_.height - _loc15_.height) * _loc9_;
            sPadding.top *= _loc3_;
            sPosRows[0] *= _loc3_;
            sPosRows[1] = 0.0001;
            sPosRows[2] *= _loc3_;
         }
         _loc1_ = int(this.setupScale9GridAttributes(sPadding.left,sPadding.top,sPosCols,sPosRows,this.setupScale9GridVertexPosition));
         sTexCols[0] = sBasCols[0] / _loc17_.width;
         sTexCols[2] = sBasCols[2] / _loc17_.width;
         sTexCols[1] = 1 - sTexCols[0] - sTexCols[2];
         sTexRows[0] = sBasRows[0] / _loc17_.height;
         sTexRows[2] = sBasRows[2] / _loc17_.height;
         sTexRows[1] = 1 - sTexRows[0] - sTexRows[2];
         this.setupScale9GridAttributes(0,0,sTexCols,sTexRows,this.setupScale9GridVertexTexCoords);
         _loc2_ = _loc1_ / 4;
         _loc12_.numVertices = _loc1_;
         _loc13_.numIndices = 0;
         var _loc19_:int = 0;
         while(_loc19_ < _loc2_)
         {
            _loc13_.addQuad(_loc19_ * 4,_loc19_ * 4 + 1,_loc19_ * 4 + 2,_loc19_ * 4 + 3);
            _loc19_++;
         }
         if(_loc1_ != _loc14_)
         {
            _loc4_ = _loc14_ ? _loc12_.getColor(0) : 16777215;
            _loc5_ = _loc14_ ? _loc12_.getAlpha(0) : 1;
            _loc12_.colorize("color",_loc4_,_loc5_);
         }
         Pool.putRectangle(_loc16_);
         Pool.putRectangle(_loc17_);
         Pool.putRectangle(_loc15_);
         Pool.putRectangle(_loc18_);
         setRequiresRedraw();
      }
      
      private function setupScale9GridVertexPosition(param1:VertexData, param2:Texture, param3:int, param4:Number, param5:Number) : void
      {
         param1.setPoint(param3,"position",param4,param5);
      }
      
      private function setupScale9GridVertexTexCoords(param1:VertexData, param2:Texture, param3:int, param4:Number, param5:Number) : void
      {
         param2.setTexCoords(param1,param3,"texCoords",param4,param5);
      }
      
      private function setupScale9GridAttributes(param1:Number, param2:Number, param3:Vector.<Number>, param4:Vector.<Number>, param5:Function) : int
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Number = Number(NaN);
         var _loc9_:Number = Number(NaN);
         var _loc10_:VertexData = this.vertexData;
         var _loc11_:Texture = this.texture;
         var _loc12_:Number = param1;
         var _loc13_:Number = param2;
         var _loc14_:* = 0;
         _loc6_ = 0;
         while(_loc6_ < 3)
         {
            _loc9_ = param4[_loc6_];
            if(_loc9_ > 0)
            {
               _loc7_ = 0;
               while(_loc7_ < 3)
               {
                  _loc8_ = param3[_loc7_];
                  if(_loc8_ > 0)
                  {
                     param5(_loc10_,_loc11_,_loc14_++,_loc12_,_loc13_);
                     param5(_loc10_,_loc11_,_loc14_++,_loc12_ + _loc8_,_loc13_);
                     param5(_loc10_,_loc11_,_loc14_++,_loc12_,_loc13_ + _loc9_);
                     param5(_loc10_,_loc11_,_loc14_++,_loc12_ + _loc8_,_loc13_ + _loc9_);
                     _loc12_ += _loc8_;
                  }
                  _loc7_++;
               }
               _loc13_ += _loc9_;
            }
            _loc12_ = param1;
            _loc6_++;
         }
         return _loc14_;
      }
      
      private function setupTileGrid() : void
      {
         var _loc1_:Number = Number(NaN);
         var _loc2_:Number = Number(NaN);
         var _loc3_:Number = Number(NaN);
         var _loc4_:Number = Number(NaN);
         var _loc5_:Number = Number(NaN);
         var _loc6_:Number = Number(NaN);
         var _loc7_:Number = Number(NaN);
         var _loc8_:Number = Number(NaN);
         var _loc9_:Number = Number(NaN);
         var _loc10_:Texture = this.texture;
         var _loc11_:Rectangle = _loc10_.frame;
         var _loc12_:VertexData = this.vertexData;
         var _loc13_:IndexData = this.indexData;
         var _loc14_:Rectangle = getBounds(this,sBounds);
         var _loc15_:int = _loc12_.numVertices;
         var _loc16_:uint = _loc15_ ? _loc12_.getColor(0) : 16777215;
         var _loc17_:Number = _loc15_ ? _loc12_.getAlpha(0) : 1;
         var _loc18_:Number = scaleX > 0 ? 1 / scaleX : -1 / scaleX;
         var _loc19_:Number = scaleY > 0 ? 1 / scaleY : -1 / scaleY;
         var _loc20_:Number = this._tileGrid.width > 0 ? Number(this._tileGrid.width) : _loc10_.frameWidth;
         var _loc21_:Number = this._tileGrid.height > 0 ? Number(this._tileGrid.height) : _loc10_.frameHeight;
         _loc20_ *= _loc18_;
         _loc21_ *= _loc19_;
         var _loc22_:Number = _loc11_ ? -_loc11_.x * (_loc20_ / _loc11_.width) : 0;
         var _loc23_:Number = _loc11_ ? -_loc11_.y * (_loc21_ / _loc11_.height) : 0;
         var _loc24_:Number = _loc10_.width * (_loc20_ / _loc10_.frameWidth);
         var _loc25_:Number = _loc10_.height * (_loc21_ / _loc10_.frameHeight);
         var _loc26_:Number = this._tileGrid.x * _loc18_ % _loc20_;
         var _loc27_:Number = this._tileGrid.y * _loc19_ % _loc21_;
         if(_loc26_ < 0)
         {
            _loc26_ += _loc20_;
         }
         if(_loc27_ < 0)
         {
            _loc27_ += _loc21_;
         }
         var _loc28_:Number = _loc26_ + _loc22_;
         var _loc29_:Number = _loc27_ + _loc23_;
         if(_loc28_ > _loc20_ - _loc24_)
         {
            _loc28_ -= _loc20_;
         }
         if(_loc29_ > _loc21_ - _loc25_)
         {
            _loc29_ -= _loc21_;
         }
         var _loc30_:String = "position";
         var _loc31_:String = "texCoords";
         var _loc32_:Number = _loc29_;
         var _loc33_:int = 0;
         _loc13_.numIndices = 0;
         while(_loc32_ < _loc14_.height)
         {
            _loc9_ = _loc28_;
            while(_loc9_ < _loc14_.width)
            {
               _loc13_.addQuad(_loc33_,_loc33_ + 1,_loc33_ + 2,_loc33_ + 3);
               _loc1_ = _loc9_ < 0 ? 0 : _loc9_;
               _loc3_ = _loc32_ < 0 ? 0 : _loc32_;
               _loc2_ = _loc9_ + _loc24_ > _loc14_.width ? _loc14_.width : _loc9_ + _loc24_;
               _loc4_ = _loc32_ + _loc25_ > _loc14_.height ? _loc14_.height : _loc32_ + _loc25_;
               _loc12_.setPoint(_loc33_,_loc30_,_loc1_,_loc3_);
               _loc12_.setPoint(_loc33_ + 1,_loc30_,_loc2_,_loc3_);
               _loc12_.setPoint(_loc33_ + 2,_loc30_,_loc1_,_loc4_);
               _loc12_.setPoint(_loc33_ + 3,_loc30_,_loc2_,_loc4_);
               _loc5_ = (_loc1_ - _loc9_) / _loc24_;
               _loc7_ = (_loc3_ - _loc32_) / _loc25_;
               _loc6_ = (_loc2_ - _loc9_) / _loc24_;
               _loc8_ = (_loc4_ - _loc32_) / _loc25_;
               _loc10_.setTexCoords(_loc12_,_loc33_,_loc31_,_loc5_,_loc7_);
               _loc10_.setTexCoords(_loc12_,_loc33_ + 1,_loc31_,_loc6_,_loc7_);
               _loc10_.setTexCoords(_loc12_,_loc33_ + 2,_loc31_,_loc5_,_loc8_);
               _loc10_.setTexCoords(_loc12_,_loc33_ + 3,_loc31_,_loc6_,_loc8_);
               _loc9_ += _loc20_;
               _loc33_ += 4;
            }
            _loc32_ += _loc21_;
         }
         _loc12_.numVertices = _loc33_;
         var _loc34_:int = _loc15_;
         while(_loc34_ < _loc33_)
         {
            _loc12_.setColor(_loc34_,"color",_loc16_);
            _loc12_.setAlpha(_loc34_,"color",_loc17_);
            _loc34_++;
         }
         setRequiresRedraw();
      }
   }
}

