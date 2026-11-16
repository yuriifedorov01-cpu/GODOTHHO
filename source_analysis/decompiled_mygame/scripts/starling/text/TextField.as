package starling.text
{
   import flash.display3D.*;
   import flash.geom.*;
   import flash.utils.*;
   import starling.core.*;
   import starling.display.*;
   import starling.events.*;
   import starling.rendering.Painter;
   import starling.styles.MeshStyle;
   import starling.utils.*;
   
   public class TextField extends DisplayObjectContainer
   {
      
      private static const BITMAP_FONT_DATA_NAME:String = "starling.display.TextField.BitmapFonts";
      
      private static var sMatrix:Matrix = new Matrix();
      
      private static var sTrueTypeCompositor:TrueTypeCompositor = new TrueTypeCompositor();
      
      private static var sDefaultTextureFormat:String = Context3DTextureFormat.BGRA_PACKED;
      
      private static var sStringCache:Dictionary = new Dictionary();
      
      private var _text:String;
      
      private var _options:TextOptions;
      
      private var _format:TextFormat;
      
      private var _autoSize:String;
      
      private var _textBounds:Rectangle;
      
      private var _hitArea:Rectangle;
      
      private var _compositor:ITextCompositor;
      
      private var _requiresRecomposition:Boolean;
      
      private var _border:DisplayObjectContainer;
      
      private var _meshBatch:MeshBatch;
      
      private var _style:MeshStyle;
      
      private var _helperFormat:TextFormat = new TextFormat();
      
      public function TextField(param1:int, param2:int, param3:String = "", param4:TextFormat = null)
      {
         super();
         this._text = param3 ? param3 : "";
         this._autoSize = TextFieldAutoSize.NONE;
         this._hitArea = new Rectangle(0,0,param1,param2);
         this._requiresRecomposition = true;
         this._compositor = sTrueTypeCompositor;
         this._options = new TextOptions();
         this._format = param4 ? param4.clone() : new TextFormat();
         this._format.addEventListener(Event.CHANGE,this.setRequiresRecomposition);
         this._meshBatch = new MeshBatch();
         this._meshBatch.touchable = false;
         this._meshBatch.pixelSnapping = true;
         addChild(this._meshBatch);
      }
      
      public static function get defaultTextureFormat() : String
      {
         return sDefaultTextureFormat;
      }
      
      public static function set defaultTextureFormat(param1:String) : void
      {
         sDefaultTextureFormat = param1;
      }
      
      public static function updateEmbeddedFonts() : void
      {
         TrueTypeCompositor.updateEmbeddedFonts();
      }
      
      public static function registerBitmapFont(param1:BitmapFont, param2:String = null) : String
      {
         if(param2 == null)
         {
            param2 = param1.name;
         }
         bitmapFonts[convertToLowerCase(param2)] = param1;
         return param2;
      }
      
      public static function unregisterBitmapFont(param1:String, param2:Boolean = true) : void
      {
         param1 = convertToLowerCase(param1);
         if(param2 && bitmapFonts[param1] != undefined)
         {
            bitmapFonts[param1].dispose();
         }
         delete bitmapFonts[param1];
      }
      
      public static function getBitmapFont(param1:String) : BitmapFont
      {
         return bitmapFonts[convertToLowerCase(param1)];
      }
      
      private static function get bitmapFonts() : Dictionary
      {
         var _loc1_:Dictionary = Starling.painter.sharedData[BITMAP_FONT_DATA_NAME] as Dictionary;
         if(_loc1_ == null)
         {
            _loc1_ = new Dictionary();
            Starling.painter.sharedData[BITMAP_FONT_DATA_NAME] = _loc1_;
         }
         return _loc1_;
      }
      
      private static function convertToLowerCase(param1:String) : String
      {
         var _loc2_:String = sStringCache[param1];
         if(_loc2_ == null)
         {
            _loc2_ = param1.toLowerCase();
            sStringCache[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      override public function dispose() : void
      {
         this._format.removeEventListener(Event.CHANGE,this.setRequiresRecomposition);
         this._compositor.clearMeshBatch(this._meshBatch);
         super.dispose();
      }
      
      override public function render(param1:Painter) : void
      {
         if(this._requiresRecomposition)
         {
            this.recompose();
         }
         super.render(param1);
      }
      
      private function recompose() : void
      {
         var _loc1_:String = null;
         var _loc2_:BitmapFont = null;
         if(this._requiresRecomposition)
         {
            this._compositor.clearMeshBatch(this._meshBatch);
            _loc1_ = this._format.font;
            _loc2_ = getBitmapFont(_loc1_);
            if(_loc2_ == null && _loc1_ == BitmapFont.MINI)
            {
               _loc2_ = new BitmapFont();
               registerBitmapFont(_loc2_);
            }
            this._compositor = _loc2_ ? _loc2_ : sTrueTypeCompositor;
            this.updateText();
            this.updateBorder();
            this._requiresRecomposition = false;
         }
      }
      
      private function updateText() : void
      {
         var _loc1_:Number = Number(this._hitArea.width);
         var _loc2_:Number = Number(this._hitArea.height);
         var _loc3_:TextFormat = this._helperFormat;
         _loc3_.copyFrom(this._format);
         if(Boolean(this.isHorizontalAutoSize) && !this._options.isHtmlText)
         {
            _loc1_ = 100000;
         }
         if(this.isVerticalAutoSize)
         {
            _loc2_ = 100000;
         }
         this._meshBatch.x = this._meshBatch.y = 0;
         this._options.textureScale = Starling.contentScaleFactor;
         this._options.textureFormat = sDefaultTextureFormat;
         this._compositor.fillMeshBatch(this._meshBatch,_loc1_,_loc2_,this._text,_loc3_,this._options);
         if(this._style)
         {
            this._meshBatch.style = this._style;
         }
         if(this._autoSize != TextFieldAutoSize.NONE)
         {
            this._textBounds = this._meshBatch.getBounds(this._meshBatch,this._textBounds);
            if(this.isHorizontalAutoSize)
            {
               this._meshBatch.x = this._textBounds.x = -this._textBounds.x;
               this._hitArea.width = this._textBounds.width;
               this._textBounds.x = 0;
            }
            if(this.isVerticalAutoSize)
            {
               this._meshBatch.y = this._textBounds.y = -this._textBounds.y;
               this._hitArea.height = this._textBounds.height;
               this._textBounds.y = 0;
            }
         }
         else
         {
            this._textBounds = null;
         }
      }
      
      private function updateBorder() : void
      {
         if(this._border == null)
         {
            return;
         }
         var _loc1_:Number = Number(this._hitArea.width);
         var _loc2_:Number = Number(this._hitArea.height);
         var _loc3_:Quad = this._border.getChildAt(0) as Quad;
         var _loc4_:Quad = this._border.getChildAt(1) as Quad;
         var _loc5_:Quad = this._border.getChildAt(2) as Quad;
         var _loc6_:Quad = this._border.getChildAt(3) as Quad;
         _loc3_.width = _loc1_;
         _loc3_.height = 1;
         _loc5_.width = _loc1_;
         _loc5_.height = 1;
         _loc6_.width = 1;
         _loc6_.height = _loc2_;
         _loc4_.width = 1;
         _loc4_.height = _loc2_;
         _loc4_.x = _loc1_ - 1;
         _loc5_.y = _loc2_ - 1;
         _loc3_.color = _loc4_.color = _loc5_.color = _loc6_.color = this._format.color;
      }
      
      protected function setRequiresRecomposition() : void
      {
         this._requiresRecomposition = true;
         setRequiresRedraw();
      }
      
      private function get isHorizontalAutoSize() : Boolean
      {
         return this._autoSize == TextFieldAutoSize.HORIZONTAL || this._autoSize == TextFieldAutoSize.BOTH_DIRECTIONS;
      }
      
      private function get isVerticalAutoSize() : Boolean
      {
         return this._autoSize == TextFieldAutoSize.VERTICAL || this._autoSize == TextFieldAutoSize.BOTH_DIRECTIONS;
      }
      
      public function get textBounds() : Rectangle
      {
         if(this._requiresRecomposition)
         {
            this.recompose();
         }
         if(this._textBounds == null)
         {
            this._textBounds = this._meshBatch.getBounds(this);
         }
         return this._textBounds.clone();
      }
      
      override public function getBounds(param1:DisplayObject, param2:Rectangle = null) : Rectangle
      {
         if(this._requiresRecomposition)
         {
            this.recompose();
         }
         getTransformationMatrix(param1,sMatrix);
         return RectangleUtil.getBounds(this._hitArea,sMatrix,param2);
      }
      
      override public function hitTest(param1:Point) : DisplayObject
      {
         if(!visible || !touchable || !hitTestMask(param1))
         {
            return null;
         }
         if(this._hitArea.containsPoint(param1))
         {
            return this;
         }
         return null;
      }
      
      override public function set width(param1:Number) : void
      {
         this._hitArea.width = param1 / (scaleX || 1);
         this.setRequiresRecomposition();
      }
      
      override public function set height(param1:Number) : void
      {
         this._hitArea.height = param1 / (scaleY || 1);
         this.setRequiresRecomposition();
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(param1:String) : void
      {
         if(param1 == null)
         {
            param1 = "";
         }
         if(this._text != param1)
         {
            this._text = param1;
            this.setRequiresRecomposition();
         }
      }
      
      public function get format() : TextFormat
      {
         return this._format;
      }
      
      public function set format(param1:TextFormat) : void
      {
         if(param1 == null)
         {
            throw new ArgumentError("format cannot be null");
         }
         this._format.copyFrom(param1);
      }
      
      public function get border() : Boolean
      {
         return this._border != null;
      }
      
      public function set border(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         if(param1 && this._border == null)
         {
            this._border = new Sprite();
            addChild(this._border);
            _loc2_ = 0;
            while(_loc2_ < 4)
            {
               this._border.addChild(new Quad(1,1));
               _loc2_++;
            }
            this.updateBorder();
         }
         else if(!param1 && this._border != null)
         {
            this._border.removeFromParent(true);
            this._border = null;
         }
      }
      
      public function get autoScale() : Boolean
      {
         return this._options.autoScale;
      }
      
      public function set autoScale(param1:Boolean) : void
      {
         if(this._options.autoScale != param1)
         {
            this._options.autoScale = param1;
            this.setRequiresRecomposition();
         }
      }
      
      public function get autoSize() : String
      {
         return this._autoSize;
      }
      
      public function set autoSize(param1:String) : void
      {
         if(this._autoSize != param1)
         {
            this._autoSize = param1;
            this.setRequiresRecomposition();
         }
      }
      
      public function get wordWrap() : Boolean
      {
         return this._options.wordWrap;
      }
      
      public function set wordWrap(param1:Boolean) : void
      {
         if(param1 != this._options.wordWrap)
         {
            this._options.wordWrap = param1;
            this.setRequiresRecomposition();
         }
      }
      
      public function get batchable() : Boolean
      {
         return this._meshBatch.batchable;
      }
      
      public function set batchable(param1:Boolean) : void
      {
         this._meshBatch.batchable = param1;
      }
      
      public function get isHtmlText() : Boolean
      {
         return this._options.isHtmlText;
      }
      
      public function set isHtmlText(param1:Boolean) : void
      {
         if(this._options.isHtmlText != param1)
         {
            this._options.isHtmlText = param1;
            this.setRequiresRecomposition();
         }
      }
      
      public function get pixelSnapping() : Boolean
      {
         return this._meshBatch.pixelSnapping;
      }
      
      public function set pixelSnapping(param1:Boolean) : void
      {
         this._meshBatch.pixelSnapping = param1;
      }
      
      public function get style() : MeshStyle
      {
         return this._meshBatch.style;
      }
      
      public function set style(param1:MeshStyle) : void
      {
         this._style = param1;
         this.setRequiresRecomposition();
      }
      
      public function get numLines() : int
      {
         return this.text.split("\n").length;
      }
   }
}

