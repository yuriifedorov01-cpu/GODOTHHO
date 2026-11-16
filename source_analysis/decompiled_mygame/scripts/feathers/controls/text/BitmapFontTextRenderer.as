package feathers.controls.text
{
   import feathers.core.*;
   import feathers.events.*;
   import feathers.skins.IStyleProvider;
   import feathers.text.*;
   import flash.geom.*;
   import flash.text.*;
   import starling.display.*;
   import starling.events.Event;
   import starling.rendering.Painter;
   import starling.text.*;
   import starling.textures.Texture;
   import starling.utils.*;
   
   public class BitmapFontTextRenderer extends FeathersControl implements ITextRenderer, IStateObserver
   {
      
      private static var HELPER_IMAGE:Image;
      
      private static var CHARACTER_BUFFER:Vector.<FeathersCharLocation>;
      
      private static var CHAR_LOCATION_POOL:Vector.<FeathersCharLocation>;
      
      public static var globalStyleProvider:IStyleProvider;
      
      private static const HELPER_POINT:Point = new Point();
      
      private static const CHARACTER_ID_SPACE:int = 32;
      
      private static const CHARACTER_ID_TAB:int = 9;
      
      private static const CHARACTER_ID_LINE_FEED:int = 10;
      
      private static const CHARACTER_ID_CARRIAGE_RETURN:int = 13;
      
      private static const FUZZY_MAX_WIDTH_PADDING:Number = 0.000001;
      
      protected var _characterBatch:MeshBatch;
      
      protected var _batchX:Number = 0;
      
      protected var currentTextFormat:BitmapFontTextFormat;
      
      protected var _textFormatForState:Object;
      
      protected var _textFormat:BitmapFontTextFormat;
      
      protected var _disabledTextFormat:BitmapFontTextFormat;
      
      protected var _selectedTextFormat:BitmapFontTextFormat;
      
      protected var _text:String = null;
      
      protected var _textureSmoothing:String = "bilinear";
      
      protected var _wordWrap:Boolean = false;
      
      protected var _truncateToFit:Boolean = true;
      
      protected var _truncationText:String = "...";
      
      protected var _useSeparateBatch:Boolean = true;
      
      protected var _stateContext:IStateContext;
      
      public function BitmapFontTextRenderer()
      {
         super();
         if(!CHAR_LOCATION_POOL)
         {
            CHAR_LOCATION_POOL = new Vector.<FeathersCharLocation>(0);
         }
         if(!CHARACTER_BUFFER)
         {
            CHARACTER_BUFFER = new Vector.<FeathersCharLocation>(0);
         }
         this.isQuickHitAreaEnabled = true;
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return BitmapFontTextRenderer.globalStyleProvider;
      }
      
      public function get textFormat() : BitmapFontTextFormat
      {
         return this._textFormat;
      }
      
      public function set textFormat(param1:BitmapFontTextFormat) : void
      {
         if(this._textFormat == param1)
         {
            return;
         }
         this._textFormat = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get disabledTextFormat() : BitmapFontTextFormat
      {
         return this._disabledTextFormat;
      }
      
      public function set disabledTextFormat(param1:BitmapFontTextFormat) : void
      {
         if(this._disabledTextFormat == param1)
         {
            return;
         }
         this._disabledTextFormat = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get selectedTextFormat() : BitmapFontTextFormat
      {
         return this._selectedTextFormat;
      }
      
      public function set selectedTextFormat(param1:BitmapFontTextFormat) : void
      {
         if(this._selectedTextFormat == param1)
         {
            return;
         }
         this._selectedTextFormat = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(param1:String) : void
      {
         if(this._text == param1)
         {
            return;
         }
         this._text = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get textureSmoothing() : String
      {
         return this._textureSmoothing;
      }
      
      public function set textureSmoothing(param1:String) : void
      {
         if(this._textureSmoothing == param1)
         {
            return;
         }
         this._textureSmoothing = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get wordWrap() : Boolean
      {
         return this._wordWrap;
      }
      
      public function set wordWrap(param1:Boolean) : void
      {
         if(this._wordWrap == param1)
         {
            return;
         }
         this._wordWrap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get truncateToFit() : Boolean
      {
         return this._truncateToFit;
      }
      
      public function set truncateToFit(param1:Boolean) : void
      {
         if(this._truncateToFit == param1)
         {
            return;
         }
         this._truncateToFit = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get truncationText() : String
      {
         return this._truncationText;
      }
      
      public function set truncationText(param1:String) : void
      {
         if(this._truncationText == param1)
         {
            return;
         }
         this._truncationText = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get useSeparateBatch() : Boolean
      {
         return this._useSeparateBatch;
      }
      
      public function set useSeparateBatch(param1:Boolean) : void
      {
         if(this._useSeparateBatch == param1)
         {
            return;
         }
         this._useSeparateBatch = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get baseline() : Number
      {
         if(!this._textFormat)
         {
            return 0;
         }
         var _loc1_:BitmapFont = this._textFormat.font;
         var _loc2_:Number = this._textFormat.size;
         var _loc3_:Number = _loc2_ / _loc1_.size;
         if(_loc3_ !== _loc3_)
         {
            _loc3_ = 1;
         }
         var _loc4_:Number = _loc1_.baseline;
         this.doNothing();
         if(_loc4_ !== _loc4_)
         {
            return _loc1_.lineHeight * _loc3_;
         }
         return _loc4_ * _loc3_;
      }
      
      public function get stateContext() : IStateContext
      {
         return this._stateContext;
      }
      
      public function set stateContext(param1:IStateContext) : void
      {
         if(this._stateContext === param1)
         {
            return;
         }
         if(this._stateContext)
         {
            this._stateContext.removeEventListener(FeathersEventType.STATE_CHANGE,this.stateContext_stateChangeHandler);
         }
         this._stateContext = param1;
         if(this._stateContext)
         {
            this._stateContext.addEventListener(FeathersEventType.STATE_CHANGE,this.stateContext_stateChangeHandler);
         }
         this.invalidate(INVALIDATION_FLAG_STATE);
      }
      
      override public function dispose() : void
      {
         this.stateContext = null;
         super.dispose();
      }
      
      override public function render(param1:Painter) : void
      {
         this._characterBatch.x = this._batchX;
         super.render(param1);
      }
      
      public function measureText(param1:Point = null) : Point
      {
         var _loc2_:int = 0;
         var _loc3_:BitmapChar = null;
         var _loc4_:Number = Number(NaN);
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         if(!param1)
         {
            param1 = new Point();
         }
         var _loc7_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc8_:Boolean = this._explicitHeight !== this._explicitHeight;
         if(!_loc7_ && !_loc8_)
         {
            param1.x = this._explicitWidth;
            param1.y = this._explicitHeight;
            return param1;
         }
         if(this.isInvalid(INVALIDATION_FLAG_STYLES) || this.isInvalid(INVALIDATION_FLAG_STATE))
         {
            this.refreshTextFormat();
         }
         if(!this.currentTextFormat || this._text === null)
         {
            param1.setTo(0,0);
            return param1;
         }
         var _loc9_:BitmapFont = this.currentTextFormat.font;
         var _loc10_:Number = this.currentTextFormat.size;
         var _loc11_:Number = this.currentTextFormat.letterSpacing;
         var _loc12_:Boolean = this.currentTextFormat.isKerningEnabled;
         var _loc13_:Number = _loc10_ / _loc9_.size;
         if(_loc13_ !== _loc13_)
         {
            _loc13_ = 1;
         }
         var _loc14_:Number = _loc9_.lineHeight * _loc13_ + this.currentTextFormat.leading;
         var _loc15_:Number = this._explicitWidth;
         if(_loc15_ !== _loc15_)
         {
            _loc15_ = this._maxWidth;
         }
         var _loc16_:Number = 0;
         var _loc17_:Number = 0;
         var _loc18_:Number = 0;
         var _loc19_:Number = Number(NaN);
         var _loc20_:int = this._text.length;
         var _loc21_:Number = 0;
         var _loc22_:Number = 0;
         var _loc23_:int = 0;
         var _loc24_:String = "";
         var _loc25_:String = "";
         var _loc26_:int = 0;
         while(_loc26_ < _loc20_)
         {
            _loc2_ = this._text.charCodeAt(_loc26_);
            if(_loc2_ == CHARACTER_ID_LINE_FEED || _loc2_ == CHARACTER_ID_CARRIAGE_RETURN)
            {
               _loc17_ -= _loc11_;
               if(_loc17_ < 0)
               {
                  _loc17_ = 0;
               }
               if(_loc16_ < _loc17_)
               {
                  _loc16_ = _loc17_;
               }
               _loc19_ = Number(NaN);
               _loc17_ = 0;
               _loc18_ += _loc14_;
               _loc21_ = 0;
               _loc23_ = 0;
               _loc22_ = 0;
            }
            else
            {
               _loc3_ = _loc9_.getChar(_loc2_);
               if(_loc3_)
               {
                  if(_loc12_ && _loc19_ === _loc19_)
                  {
                     _loc17_ += _loc3_.getKerning(_loc19_) * _loc13_;
                  }
                  _loc4_ = _loc3_.xAdvance * _loc13_;
                  if(this._wordWrap)
                  {
                     _loc5_ = _loc2_ == CHARACTER_ID_SPACE || _loc2_ == CHARACTER_ID_TAB;
                     _loc6_ = _loc19_ == CHARACTER_ID_SPACE || _loc19_ == CHARACTER_ID_TAB;
                     if(_loc5_)
                     {
                        if(!_loc6_)
                        {
                           _loc22_ = 0;
                        }
                        _loc22_ += _loc4_;
                     }
                     else if(_loc6_)
                     {
                        _loc21_ = _loc17_;
                        _loc23_++;
                        _loc24_ += _loc25_;
                        _loc25_ = "";
                     }
                     if(!_loc5_ && _loc23_ > 0 && _loc17_ + _loc4_ > _loc15_)
                     {
                        _loc22_ = _loc21_ - _loc22_;
                        if(_loc16_ < _loc22_)
                        {
                           _loc16_ = _loc22_;
                        }
                        _loc19_ = Number(NaN);
                        _loc17_ -= _loc21_;
                        _loc18_ += _loc14_;
                        _loc21_ = 0;
                        _loc22_ = 0;
                        _loc23_ = 0;
                        _loc24_ = "";
                     }
                  }
                  _loc17_ += _loc4_ + _loc11_;
                  _loc19_ = _loc2_;
                  _loc25_ += String.fromCharCode(_loc2_);
               }
            }
            _loc26_++;
         }
         _loc17_ -= _loc11_;
         if(_loc17_ < 0)
         {
            _loc17_ = 0;
         }
         if(this._wordWrap)
         {
            while(_loc17_ > _loc15_ && !MathUtil.isEquivalent(_loc17_,_loc15_))
            {
               _loc17_ -= _loc15_;
               _loc18_ += _loc14_;
            }
         }
         if(_loc16_ < _loc17_)
         {
            _loc16_ = _loc17_;
         }
         param1.x = _loc16_;
         param1.y = _loc18_ + _loc14_ - this.currentTextFormat.leading;
         return param1;
      }
      
      public function setTextFormatForState(param1:String, param2:BitmapFontTextFormat) : void
      {
         if(param2)
         {
            if(!this._textFormatForState)
            {
               this._textFormatForState = {};
            }
            this._textFormatForState[param1] = param2;
         }
         else
         {
            delete this._textFormatForState[param1];
         }
         if(Boolean(this._stateContext) && this._stateContext.currentState === param1)
         {
            this.invalidate(INVALIDATION_FLAG_STATE);
         }
      }
      
      override protected function initialize() : void
      {
         if(!this._characterBatch)
         {
            this._characterBatch = new MeshBatch();
            this._characterBatch.touchable = false;
            this.addChild(this._characterBatch);
         }
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         if(_loc2_ || _loc4_)
         {
            this.refreshTextFormat();
         }
         if(_loc1_ || _loc2_ || _loc3_ || _loc4_)
         {
            this._characterBatch.batchable = !this._useSeparateBatch;
            this._characterBatch.clear();
            if(!this.currentTextFormat || this._text === null)
            {
               this.setSizeInternal(0,0,false);
               return;
            }
            this.layoutCharacters(HELPER_POINT);
            this.setSizeInternal(HELPER_POINT.x,HELPER_POINT.y,false);
         }
      }
      
      protected function layoutCharacters(param1:Point = null) : Point
      {
         var _loc2_:int = 0;
         var _loc3_:BitmapChar = null;
         var _loc4_:Number = Number(NaN);
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:FeathersCharLocation = null;
         var _loc8_:String = null;
         if(!param1)
         {
            param1 = new Point();
         }
         var _loc9_:BitmapFont = this.currentTextFormat.font;
         var _loc10_:Number = this.currentTextFormat.size;
         var _loc11_:Number = this.currentTextFormat.letterSpacing;
         var _loc12_:Boolean = this.currentTextFormat.isKerningEnabled;
         var _loc13_:Number = _loc10_ / _loc9_.size;
         if(_loc13_ !== _loc13_)
         {
            _loc13_ = 1;
         }
         var _loc14_:Number = _loc9_.lineHeight * _loc13_ + this.currentTextFormat.leading;
         var _loc15_:Number = _loc9_.offsetX * _loc13_;
         var _loc16_:Number = _loc9_.offsetY * _loc13_;
         var _loc17_:Boolean = this._explicitWidth === this._explicitWidth;
         var _loc18_:Boolean = this.currentTextFormat.align != TextFormatAlign.LEFT;
         var _loc19_:Number = _loc17_ ? this._explicitWidth : this._maxWidth;
         if(_loc18_ && _loc19_ == Number.POSITIVE_INFINITY)
         {
            this.measureText(HELPER_POINT);
            _loc19_ = Number(HELPER_POINT.x);
         }
         var _loc20_:String = this._text;
         if(this._truncateToFit)
         {
            _loc20_ = this.getTruncatedText(_loc19_);
         }
         CHARACTER_BUFFER.length = 0;
         var _loc21_:Number = 0;
         var _loc22_:Number = 0;
         var _loc23_:Number = 0;
         var _loc24_:Number = Number(NaN);
         var _loc25_:Boolean = false;
         var _loc26_:Number = 0;
         var _loc27_:Number = 0;
         var _loc28_:int = 0;
         var _loc29_:int = 0;
         var _loc30_:int = _loc20_ ? _loc20_.length : 0;
         var _loc31_:int = 0;
         while(_loc31_ < _loc30_)
         {
            _loc25_ = false;
            _loc2_ = _loc20_.charCodeAt(_loc31_);
            if(_loc2_ == CHARACTER_ID_LINE_FEED || _loc2_ == CHARACTER_ID_CARRIAGE_RETURN)
            {
               _loc22_ -= _loc11_;
               if(_loc22_ < 0)
               {
                  _loc22_ = 0;
               }
               if(this._wordWrap || _loc18_)
               {
                  this.alignBuffer(_loc19_,_loc22_,0);
                  this.addBufferToBatch(0);
               }
               if(_loc21_ < _loc22_)
               {
                  _loc21_ = _loc22_;
               }
               _loc24_ = Number(NaN);
               _loc22_ = 0;
               _loc23_ += _loc14_;
               _loc26_ = 0;
               _loc27_ = 0;
               _loc28_ = 0;
               _loc29_ = 0;
            }
            else
            {
               _loc3_ = _loc9_.getChar(_loc2_);
               if(_loc3_)
               {
                  if(_loc12_ && _loc24_ === _loc24_)
                  {
                     _loc22_ += _loc3_.getKerning(_loc24_) * _loc13_;
                  }
                  _loc4_ = _loc3_.xAdvance * _loc13_;
                  if(this._wordWrap)
                  {
                     _loc5_ = _loc2_ == CHARACTER_ID_SPACE || _loc2_ == CHARACTER_ID_TAB;
                     _loc6_ = _loc24_ == CHARACTER_ID_SPACE || _loc24_ == CHARACTER_ID_TAB;
                     if(_loc5_)
                     {
                        if(!_loc6_)
                        {
                           _loc27_ = 0;
                        }
                        _loc27_ += _loc4_;
                     }
                     else if(_loc6_)
                     {
                        _loc26_ = _loc22_;
                        _loc28_ = 0;
                        _loc29_++;
                        _loc25_ = true;
                     }
                     if(_loc25_ && !_loc18_)
                     {
                        this.addBufferToBatch(0);
                     }
                     if(!_loc5_ && _loc29_ > 0 && _loc22_ + _loc4_ - _loc19_ > FUZZY_MAX_WIDTH_PADDING)
                     {
                        if(_loc18_)
                        {
                           this.trimBuffer(_loc28_);
                           this.alignBuffer(_loc19_,_loc26_ - _loc27_,_loc28_);
                           this.addBufferToBatch(_loc28_);
                        }
                        this.moveBufferedCharacters(-_loc26_,_loc14_,0);
                        _loc27_ = _loc26_ - _loc27_;
                        if(_loc21_ < _loc27_)
                        {
                           _loc21_ = _loc27_;
                        }
                        _loc24_ = Number(NaN);
                        _loc22_ -= _loc26_;
                        _loc23_ += _loc14_;
                        _loc26_ = 0;
                        _loc27_ = 0;
                        _loc28_ = 0;
                        _loc25_ = false;
                        _loc29_ = 0;
                     }
                  }
                  if(this._wordWrap || _loc18_)
                  {
                     _loc7_ = CHAR_LOCATION_POOL.length > 0 ? CHAR_LOCATION_POOL.shift() : new FeathersCharLocation();
                     _loc7_.char = _loc3_;
                     _loc7_.x = _loc22_ + _loc15_ + _loc3_.xOffset * _loc13_;
                     _loc7_.y = _loc23_ + _loc16_ + _loc3_.yOffset * _loc13_;
                     _loc7_.scale = _loc13_;
                     CHARACTER_BUFFER[CHARACTER_BUFFER.length] = _loc7_;
                     _loc28_++;
                  }
                  else
                  {
                     this.addCharacterToBatch(_loc3_,_loc22_ + _loc15_ + _loc3_.xOffset * _loc13_,_loc23_ + _loc16_ + _loc3_.yOffset * _loc13_,_loc13_);
                  }
                  _loc22_ += _loc4_ + _loc11_;
                  _loc24_ = _loc2_;
               }
            }
            _loc31_++;
         }
         _loc22_ -= _loc11_;
         if(_loc22_ < 0)
         {
            _loc22_ = 0;
         }
         if(this._wordWrap || _loc18_)
         {
            this.alignBuffer(_loc19_,_loc22_,0);
            this.addBufferToBatch(0);
         }
         if(this._wordWrap)
         {
            while(_loc22_ > _loc19_ && !MathUtil.isEquivalent(_loc22_,_loc19_))
            {
               _loc22_ -= _loc19_;
               _loc23_ += _loc14_;
            }
         }
         if(_loc21_ < _loc22_)
         {
            _loc21_ = _loc22_;
         }
         if(_loc18_ && !_loc17_)
         {
            _loc8_ = this._textFormat.align;
            if(_loc8_ == TextFormatAlign.CENTER)
            {
               this._batchX = (_loc21_ - _loc19_) / 2;
            }
            else if(_loc8_ == TextFormatAlign.RIGHT)
            {
               this._batchX = _loc21_ - _loc19_;
            }
         }
         else
         {
            this._batchX = 0;
         }
         this._characterBatch.x = this._batchX;
         param1.x = _loc21_;
         param1.y = _loc23_ + _loc14_ - this.currentTextFormat.leading;
         return param1;
      }
      
      protected function trimBuffer(param1:int) : void
      {
         var _loc2_:FeathersCharLocation = null;
         var _loc3_:BitmapChar = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = CHARACTER_BUFFER.length - param1;
         var _loc7_:* = int(_loc6_ - 1);
         while(_loc7_ >= 0)
         {
            _loc2_ = CHARACTER_BUFFER[_loc7_];
            _loc3_ = _loc2_.char;
            _loc4_ = _loc3_.charID;
            if(!(_loc4_ == CHARACTER_ID_SPACE || _loc4_ == CHARACTER_ID_TAB))
            {
               break;
            }
            _loc5_++;
            _loc7_--;
         }
         if(_loc5_ > 0)
         {
            CHARACTER_BUFFER.splice(_loc7_ + 1,_loc5_);
         }
      }
      
      protected function alignBuffer(param1:Number, param2:Number, param3:int) : void
      {
         var _loc4_:String = this.currentTextFormat.align;
         if(_loc4_ == TextFormatAlign.CENTER)
         {
            this.moveBufferedCharacters(Math.round((param1 - param2) / 2),0,param3);
         }
         else if(_loc4_ == TextFormatAlign.RIGHT)
         {
            this.moveBufferedCharacters(param1 - param2,0,param3);
         }
      }
      
      protected function addBufferToBatch(param1:int) : void
      {
         var _loc2_:FeathersCharLocation = null;
         var _loc3_:int = CHARACTER_BUFFER.length - param1;
         var _loc4_:int = int(CHAR_LOCATION_POOL.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc2_ = CHARACTER_BUFFER.shift();
            this.addCharacterToBatch(_loc2_.char,_loc2_.x,_loc2_.y,_loc2_.scale);
            _loc2_.char = null;
            CHAR_LOCATION_POOL[_loc4_] = _loc2_;
            _loc4_++;
            _loc5_++;
         }
      }
      
      protected function moveBufferedCharacters(param1:Number, param2:Number, param3:int) : void
      {
         var _loc4_:FeathersCharLocation = null;
         var _loc5_:int = CHARACTER_BUFFER.length - param3;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ = CHARACTER_BUFFER[_loc6_];
            _loc4_.x += param1;
            _loc4_.y += param2;
            _loc6_++;
         }
      }
      
      protected function addCharacterToBatch(param1:BitmapChar, param2:Number, param3:Number, param4:Number, param5:Painter = null) : void
      {
         var _loc6_:Texture = param1.texture;
         var _loc7_:Rectangle = _loc6_.frame;
         if(_loc7_)
         {
            if(_loc7_.width === 0 || _loc7_.height === 0)
            {
               return;
            }
         }
         else if(_loc6_.width === 0 || _loc6_.height === 0)
         {
            return;
         }
         if(!HELPER_IMAGE)
         {
            HELPER_IMAGE = new Image(_loc6_);
         }
         else
         {
            HELPER_IMAGE.texture = _loc6_;
            HELPER_IMAGE.readjustSize();
         }
         HELPER_IMAGE.scaleX = HELPER_IMAGE.scaleY = param4;
         HELPER_IMAGE.x = param2;
         HELPER_IMAGE.y = param3;
         HELPER_IMAGE.color = this.currentTextFormat.color;
         HELPER_IMAGE.textureSmoothing = this._textureSmoothing;
         if(!param5)
         {
            this._characterBatch.addMesh(HELPER_IMAGE);
         }
      }
      
      protected function refreshTextFormat() : void
      {
         var _loc1_:BitmapFontTextFormat = null;
         var _loc2_:String = null;
         if(Boolean(this._stateContext) && Boolean(this._textFormatForState))
         {
            _loc2_ = this._stateContext.currentState;
            if(_loc2_ in this._textFormatForState)
            {
               _loc1_ = BitmapFontTextFormat(this._textFormatForState[_loc2_]);
            }
         }
         if(!_loc1_ && !this._isEnabled && Boolean(this._disabledTextFormat))
         {
            _loc1_ = this._disabledTextFormat;
         }
         if(Boolean(!_loc1_ && this._selectedTextFormat) && Boolean(this._stateContext is IToggle) && Boolean(IToggle(this._stateContext).isSelected))
         {
            _loc1_ = this._selectedTextFormat;
         }
         if(!_loc1_)
         {
            if(!this._textFormat)
            {
               if(!TextField.getBitmapFont(BitmapFont.MINI))
               {
                  TextField.registerBitmapFont(new BitmapFont());
               }
               this._textFormat = new BitmapFontTextFormat(BitmapFont.MINI,NaN,0);
            }
            _loc1_ = this._textFormat;
         }
         this.currentTextFormat = _loc1_;
      }
      
      protected function getTruncatedText(param1:Number) : String
      {
         var _loc2_:int = 0;
         var _loc3_:BitmapChar = null;
         var _loc4_:Number = Number(NaN);
         var _loc5_:Number = Number(NaN);
         if(!this._text)
         {
            return "";
         }
         if(param1 == Number.POSITIVE_INFINITY || this._wordWrap || this._text.indexOf(String.fromCharCode(CHARACTER_ID_LINE_FEED)) >= 0 || this._text.indexOf(String.fromCharCode(CHARACTER_ID_CARRIAGE_RETURN)) >= 0)
         {
            return this._text;
         }
         var _loc6_:BitmapFont = this.currentTextFormat.font;
         var _loc7_:Number = this.currentTextFormat.size;
         var _loc8_:Number = this.currentTextFormat.letterSpacing;
         var _loc9_:Boolean = this.currentTextFormat.isKerningEnabled;
         var _loc10_:Number = _loc7_ / _loc6_.size;
         if(_loc10_ !== _loc10_)
         {
            _loc10_ = 1;
         }
         var _loc11_:Number = 0;
         var _loc12_:Number = Number(NaN);
         var _loc13_:int = this._text.length;
         var _loc14_:int = -1;
         var _loc15_:* = 0;
         while(_loc15_ < _loc13_)
         {
            _loc2_ = this._text.charCodeAt(_loc15_);
            _loc3_ = _loc6_.getChar(_loc2_);
            if(_loc3_)
            {
               _loc4_ = 0;
               if(_loc9_ && _loc12_ === _loc12_)
               {
                  _loc4_ = _loc3_.getKerning(_loc12_) * _loc10_;
               }
               _loc11_ += _loc4_ + _loc3_.xAdvance * _loc10_;
               if(_loc11_ > param1)
               {
                  _loc5_ = Math.abs(_loc11_ - param1);
                  if(_loc5_ > FUZZY_MAX_WIDTH_PADDING)
                  {
                     _loc14_ = _loc15_;
                     break;
                  }
               }
               _loc11_ += _loc8_;
               _loc12_ = _loc2_;
            }
            _loc15_++;
         }
         if(_loc14_ >= 0)
         {
            _loc13_ = this._truncationText.length;
            _loc15_ = 0;
            while(_loc15_ < _loc13_)
            {
               _loc2_ = this._truncationText.charCodeAt(_loc15_);
               _loc3_ = _loc6_.getChar(_loc2_);
               if(_loc3_)
               {
                  _loc4_ = 0;
                  if(_loc9_ && _loc12_ === _loc12_)
                  {
                     _loc4_ = _loc3_.getKerning(_loc12_) * _loc10_;
                  }
                  _loc11_ += _loc4_ + _loc3_.xAdvance * _loc10_ + _loc8_;
                  _loc12_ = _loc2_;
               }
               _loc15_++;
            }
            _loc11_ -= _loc8_;
            _loc15_ = _loc14_;
            while(_loc15_ >= 0)
            {
               _loc2_ = this._text.charCodeAt(_loc15_);
               _loc12_ = _loc15_ > 0 ? this._text.charCodeAt(_loc15_ - 1) : Number(NaN);
               _loc3_ = _loc6_.getChar(_loc2_);
               if(_loc3_)
               {
                  _loc4_ = 0;
                  if(_loc9_ && _loc12_ === _loc12_)
                  {
                     _loc4_ = _loc3_.getKerning(_loc12_) * _loc10_;
                  }
                  _loc11_ -= _loc4_ + _loc3_.xAdvance * _loc10_ + _loc8_;
                  if(_loc11_ <= param1)
                  {
                     return this._text.substr(0,_loc15_) + this._truncationText;
                  }
               }
               _loc15_--;
            }
            return this._truncationText;
         }
         return this._text;
      }
      
      protected function stateContext_stateChangeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_STATE);
      }
      
      protected function doNothing() : void
      {
      }
   }
}

import starling.text.BitmapChar;

class FeathersCharLocation
{
   
   public var char:BitmapChar;
   
   public var scale:Number;
   
   public var x:Number;
   
   public var y:Number;
   
   public function FeathersCharLocation()
   {
      super();
   }
}
