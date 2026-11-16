package starling.text
{
   import flash.geom.*;
   import flash.utils.*;
   import starling.display.*;
   import starling.textures.*;
   import starling.utils.*;
   
   public class BitmapFont implements ITextCompositor
   {
      
      public static const NATIVE_SIZE:int = -1;
      
      public static const MINI:String = "mini";
      
      private static const CHAR_SPACE:int = 32;
      
      private static const CHAR_TAB:int = 9;
      
      private static const CHAR_NEWLINE:int = 10;
      
      private static const CHAR_CARRIAGE_RETURN:int = 13;
      
      private static var sLines:Array = [];
      
      private static var sDefaultOptions:TextOptions = new TextOptions();
      
      private var _texture:Texture;
      
      private var _chars:Dictionary;
      
      private var _name:String;
      
      private var _size:Number;
      
      private var _lineHeight:Number;
      
      private var _baseline:Number;
      
      private var _offsetX:Number;
      
      private var _offsetY:Number;
      
      private var _helperImage:Image;
      
      public function BitmapFont(param1:Texture = null, param2:XML = null)
      {
         super();
         if(param1 == null && param2 == null)
         {
            param1 = MiniBitmapFont.texture;
            param2 = MiniBitmapFont.xml;
         }
         else if(param1 != null && param2 == null)
         {
            throw new ArgumentError("fontXml cannot be null!");
         }
         this._name = "unknown";
         this._lineHeight = this._size = this._baseline = 14;
         this._offsetX = this._offsetY = 0;
         this._texture = param1;
         this._chars = new Dictionary();
         this._helperImage = new Image(param1);
         this.parseFontXml(param2);
      }
      
      public function dispose() : void
      {
         if(this._texture)
         {
            this._texture.dispose();
         }
      }
      
      private function parseFontXml(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:XML = null;
         var _loc4_:int = 0;
         var _loc5_:Number = Number(NaN);
         var _loc6_:Number = Number(NaN);
         var _loc7_:Number = Number(NaN);
         var _loc8_:Rectangle = null;
         var _loc9_:Texture = null;
         var _loc10_:BitmapChar = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Number = Number(NaN);
         var _loc14_:Number = Number(this._texture.scale);
         var _loc15_:Rectangle = this._texture.frame;
         var _loc16_:Number = _loc15_ ? _loc15_.x : 0;
         var _loc17_:Number = _loc15_ ? _loc15_.y : 0;
         this._name = StringUtil.clean(param1.info.@face);
         this._size = parseFloat(param1.info.@size) / _loc14_;
         this._lineHeight = parseFloat(param1.common.@lineHeight) / _loc14_;
         this._baseline = parseFloat(param1.common.@base) / _loc14_;
         if(param1.info.@smooth.toString() == "0")
         {
            this.smoothing = TextureSmoothing.NONE;
         }
         if(this._size <= 0)
         {
            this._size = this._size == 0 ? 16 : this._size * -1;
         }
         for each(_loc2_ in param1.chars.char)
         {
            _loc4_ = int(parseInt(_loc2_.@id));
            _loc5_ = parseFloat(_loc2_.@xoffset) / _loc14_;
            _loc6_ = parseFloat(_loc2_.@yoffset) / _loc14_;
            _loc7_ = parseFloat(_loc2_.@xadvance) / _loc14_;
            _loc8_ = new Rectangle();
            _loc8_.x = parseFloat(_loc2_.@x) / _loc14_ + _loc16_;
            _loc8_.y = parseFloat(_loc2_.@y) / _loc14_ + _loc17_;
            _loc8_.width = parseFloat(_loc2_.@width) / _loc14_;
            _loc8_.height = parseFloat(_loc2_.@height) / _loc14_;
            _loc9_ = Texture.fromTexture(this._texture,_loc8_);
            _loc10_ = new BitmapChar(_loc4_,_loc9_,_loc5_,_loc6_,_loc7_);
            this.addChar(_loc4_,_loc10_);
         }
         for each(_loc3_ in param1.kernings.kerning)
         {
            _loc11_ = int(parseInt(_loc3_.@first));
            _loc12_ = int(parseInt(_loc3_.@second));
            _loc13_ = parseFloat(_loc3_.@amount) / _loc14_;
            if(_loc12_ in this._chars)
            {
               this.getChar(_loc12_).addKerning(_loc11_,_loc13_);
            }
         }
      }
      
      public function getChar(param1:int) : BitmapChar
      {
         return this._chars[param1];
      }
      
      public function addChar(param1:int, param2:BitmapChar) : void
      {
         this._chars[param1] = param2;
      }
      
      public function getCharIDs(param1:Vector.<int> = null) : Vector.<int>
      {
         var _loc2_:* = undefined;
         if(param1 == null)
         {
            param1 = new Vector.<int>(0);
         }
         for(_loc2_ in this._chars)
         {
            param1[param1.length] = int(_loc2_);
         }
         return param1;
      }
      
      public function hasChars(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         if(param1 == null)
         {
            return true;
         }
         var _loc3_:int = param1.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1.charCodeAt(_loc4_);
            if(_loc2_ != CHAR_SPACE && _loc2_ != CHAR_TAB && _loc2_ != CHAR_NEWLINE && _loc2_ != CHAR_CARRIAGE_RETURN && this.getChar(_loc2_) == null)
            {
               return false;
            }
            _loc4_++;
         }
         return true;
      }
      
      public function createSprite(param1:Number, param2:Number, param3:String, param4:TextFormat, param5:TextOptions = null) : Sprite
      {
         var _loc6_:CharLocation = null;
         var _loc7_:Image = null;
         var _loc8_:Vector.<CharLocation> = this.arrangeChars(param1,param2,param3,param4,param5);
         var _loc9_:int = int(_loc8_.length);
         var _loc10_:Sprite = new Sprite();
         var _loc11_:int = 0;
         while(_loc11_ < _loc9_)
         {
            _loc6_ = _loc8_[_loc11_];
            _loc7_ = _loc6_.char.createImage();
            _loc7_.x = _loc6_.x;
            _loc7_.y = _loc6_.y;
            _loc7_.scale = _loc6_.scale;
            _loc7_.color = param4.color;
            _loc10_.addChild(_loc7_);
            _loc11_++;
         }
         CharLocation.rechargePool();
         return _loc10_;
      }
      
      public function fillMeshBatch(param1:MeshBatch, param2:Number, param3:Number, param4:String, param5:TextFormat, param6:TextOptions = null) : void
      {
         var _loc7_:CharLocation = null;
         var _loc8_:Vector.<CharLocation> = this.arrangeChars(param2,param3,param4,param5,param6);
         var _loc9_:int = int(_loc8_.length);
         this._helperImage.color = param5.color;
         var _loc10_:int = 0;
         while(_loc10_ < _loc9_)
         {
            _loc7_ = _loc8_[_loc10_];
            this._helperImage.texture = _loc7_.char.texture;
            this._helperImage.readjustSize();
            this._helperImage.x = _loc7_.x;
            this._helperImage.y = _loc7_.y;
            this._helperImage.scale = _loc7_.scale;
            param1.addMesh(this._helperImage);
            _loc10_++;
         }
         CharLocation.rechargePool();
      }
      
      public function clearMeshBatch(param1:MeshBatch) : void
      {
         param1.clear();
      }
      
      private function arrangeChars(param1:Number, param2:Number, param3:String, param4:TextFormat, param5:TextOptions) : Vector.<CharLocation>
      {
         var _loc6_:CharLocation = null;
         var _loc7_:int = 0;
         var _loc8_:Number = Number(NaN);
         var _loc9_:Number = Number(NaN);
         var _loc10_:Number = Number(NaN);
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:Number = Number(NaN);
         var _loc16_:Number = Number(NaN);
         var _loc17_:Vector.<CharLocation> = null;
         var _loc18_:Boolean = false;
         var _loc19_:int = 0;
         var _loc20_:BitmapChar = null;
         var _loc21_:int = 0;
         var _loc22_:Vector.<CharLocation> = null;
         var _loc23_:int = 0;
         var _loc24_:CharLocation = null;
         var _loc25_:Number = Number(NaN);
         var _loc26_:int = 0;
         if(param3 == null || param3.length == 0)
         {
            return CharLocation.vectorFromPool();
         }
         if(param5 == null)
         {
            param5 = sDefaultOptions;
         }
         var _loc27_:Boolean = param4.kerning;
         var _loc28_:Number = param4.leading;
         var _loc29_:String = param4.horizontalAlign;
         var _loc30_:String = param4.verticalAlign;
         var _loc31_:Number = param4.size;
         var _loc32_:Boolean = param5.autoScale;
         var _loc33_:Boolean = param5.wordWrap;
         var _loc34_:Boolean = false;
         if(_loc31_ < 0)
         {
            _loc31_ *= -this._size;
         }
         while(!_loc34_)
         {
            sLines.length = 0;
            _loc10_ = _loc31_ / this._size;
            _loc8_ = param1 / _loc10_;
            _loc9_ = param2 / _loc10_;
            if(this._lineHeight <= _loc9_)
            {
               _loc13_ = -1;
               _loc14_ = -1;
               _loc15_ = 0;
               _loc16_ = 0;
               _loc17_ = CharLocation.vectorFromPool();
               _loc7_ = param3.length;
               _loc11_ = 0;
               while(_loc11_ < _loc7_)
               {
                  _loc18_ = false;
                  _loc19_ = param3.charCodeAt(_loc11_);
                  _loc20_ = this.getChar(_loc19_);
                  if(_loc19_ == CHAR_NEWLINE || _loc19_ == CHAR_CARRIAGE_RETURN)
                  {
                     _loc18_ = true;
                  }
                  else if(_loc20_ != null)
                  {
                     if(_loc19_ == CHAR_SPACE || _loc19_ == CHAR_TAB)
                     {
                        _loc13_ = _loc11_;
                     }
                     if(_loc27_)
                     {
                        _loc15_ += _loc20_.getKerning(_loc14_);
                     }
                     _loc6_ = CharLocation.instanceFromPool(_loc20_);
                     _loc6_.x = _loc15_ + _loc20_.xOffset;
                     _loc6_.y = _loc16_ + _loc20_.yOffset;
                     _loc17_[_loc17_.length] = _loc6_;
                     _loc15_ += _loc20_.xAdvance;
                     _loc14_ = _loc19_;
                     if(_loc6_.x + _loc20_.width > _loc8_)
                     {
                        if(_loc33_)
                        {
                           if(_loc32_ && _loc13_ == -1)
                           {
                              break;
                           }
                           _loc21_ = _loc13_ == -1 ? 1 : int(_loc11_ - _loc13_);
                           _loc12_ = 0;
                           while(_loc12_ < _loc21_)
                           {
                              _loc17_.pop();
                              _loc12_++;
                           }
                           if(_loc17_.length == 0)
                           {
                              break;
                           }
                           _loc11_ -= _loc21_;
                        }
                        else
                        {
                           if(_loc32_)
                           {
                              break;
                           }
                           _loc17_.pop();
                           while(_loc11_ < _loc7_ - 1 && param3.charCodeAt(_loc11_) != CHAR_NEWLINE)
                           {
                              _loc11_++;
                           }
                        }
                        _loc18_ = true;
                     }
                  }
                  if(_loc11_ == _loc7_ - 1)
                  {
                     sLines[sLines.length] = _loc17_;
                     _loc34_ = true;
                  }
                  else if(_loc18_)
                  {
                     sLines[sLines.length] = _loc17_;
                     if(_loc13_ == _loc11_)
                     {
                        _loc17_.pop();
                     }
                     if(_loc16_ + _loc28_ + 2 * this._lineHeight > _loc9_)
                     {
                        break;
                     }
                     _loc17_ = CharLocation.vectorFromPool();
                     _loc15_ = 0;
                     _loc16_ += this._lineHeight + _loc28_;
                     _loc13_ = -1;
                     _loc14_ = -1;
                  }
                  _loc11_++;
               }
            }
            if(_loc32_ && !_loc34_ && _loc31_ > 3)
            {
               _loc31_--;
            }
            else
            {
               _loc34_ = true;
            }
         }
         var _loc35_:Vector.<CharLocation> = CharLocation.vectorFromPool();
         var _loc36_:int = int(sLines.length);
         var _loc37_:Number = _loc16_ + this._lineHeight;
         var _loc38_:int = 0;
         if(_loc30_ == Align.BOTTOM)
         {
            _loc38_ = _loc9_ - _loc37_;
         }
         else if(_loc30_ == Align.CENTER)
         {
            _loc38_ = (_loc9_ - _loc37_) / 2;
         }
         var _loc39_:int = 0;
         while(_loc39_ < _loc36_)
         {
            _loc22_ = sLines[_loc39_];
            _loc7_ = int(_loc22_.length);
            if(_loc7_ != 0)
            {
               _loc23_ = 0;
               _loc24_ = _loc22_[_loc22_.length - 1];
               _loc25_ = _loc24_.x - _loc24_.char.xOffset + _loc24_.char.xAdvance;
               if(_loc29_ == Align.RIGHT)
               {
                  _loc23_ = _loc8_ - _loc25_;
               }
               else if(_loc29_ == Align.CENTER)
               {
                  _loc23_ = (_loc8_ - _loc25_) / 2;
               }
               _loc26_ = 0;
               while(_loc26_ < _loc7_)
               {
                  _loc6_ = _loc22_[_loc26_];
                  _loc6_.x = _loc10_ * (_loc6_.x + _loc23_ + this._offsetX);
                  _loc6_.y = _loc10_ * (_loc6_.y + _loc38_ + this._offsetY);
                  _loc6_.scale = _loc10_;
                  if(_loc6_.char.width > 0 && _loc6_.char.height > 0)
                  {
                     _loc35_[_loc35_.length] = _loc6_;
                  }
                  _loc26_++;
               }
            }
            _loc39_++;
         }
         return _loc35_;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get size() : Number
      {
         return this._size;
      }
      
      public function get lineHeight() : Number
      {
         return this._lineHeight;
      }
      
      public function set lineHeight(param1:Number) : void
      {
         this._lineHeight = param1;
      }
      
      public function get smoothing() : String
      {
         return this._helperImage.textureSmoothing;
      }
      
      public function set smoothing(param1:String) : void
      {
         this._helperImage.textureSmoothing = param1;
      }
      
      public function get baseline() : Number
      {
         return this._baseline;
      }
      
      public function set baseline(param1:Number) : void
      {
         this._baseline = param1;
      }
      
      public function get offsetX() : Number
      {
         return this._offsetX;
      }
      
      public function set offsetX(param1:Number) : void
      {
         this._offsetX = param1;
      }
      
      public function get offsetY() : Number
      {
         return this._offsetY;
      }
      
      public function set offsetY(param1:Number) : void
      {
         this._offsetY = param1;
      }
      
      public function get texture() : Texture
      {
         return this._texture;
      }
   }
}

import starling.text.BitmapChar;

class CharLocation
{
   
   private static var sInstancePool:Vector.<CharLocation> = new Vector.<CharLocation>(0);
   
   private static var sVectorPool:Array = [];
   
   private static var sInstanceLoan:Vector.<CharLocation> = new Vector.<CharLocation>(0);
   
   private static var sVectorLoan:Array = [];
   
   public var char:BitmapChar;
   
   public var scale:Number;
   
   public var x:Number;
   
   public var y:Number;
   
   public function CharLocation(param1:BitmapChar)
   {
      super();
      this.reset(param1);
   }
   
   public static function instanceFromPool(param1:BitmapChar) : CharLocation
   {
      var _loc2_:CharLocation = sInstancePool.length > 0 ? sInstancePool.pop() : new CharLocation(param1);
      _loc2_.reset(param1);
      sInstanceLoan[sInstanceLoan.length] = _loc2_;
      return _loc2_;
   }
   
   public static function vectorFromPool() : Vector.<CharLocation>
   {
      var _loc1_:Vector.<CharLocation> = sVectorPool.length > 0 ? sVectorPool.pop() : new Vector.<CharLocation>(0);
      _loc1_.length = 0;
      sVectorLoan[sVectorLoan.length] = _loc1_;
      return _loc1_;
   }
   
   public static function rechargePool() : void
   {
      var _loc1_:CharLocation = null;
      var _loc2_:Vector.<CharLocation> = null;
      while(sInstanceLoan.length > 0)
      {
         _loc1_ = sInstanceLoan.pop();
         _loc1_.char = null;
         sInstancePool[sInstancePool.length] = _loc1_;
      }
      while(sVectorLoan.length > 0)
      {
         _loc2_ = sVectorLoan.pop();
         _loc2_.length = 0;
         sVectorPool[sVectorPool.length] = _loc2_;
      }
   }
   
   private function reset(param1:BitmapChar) : CharLocation
   {
      this.char = param1;
      return this;
   }
}
