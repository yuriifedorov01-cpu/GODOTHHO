package starling.text
{
   import flash.display3D.*;
   import starling.core.*;
   
   public class TextOptions
   {
      
      private var _wordWrap:Boolean;
      
      private var _autoScale:Boolean;
      
      private var _isHtmlText:Boolean;
      
      private var _textureScale:Number;
      
      private var _textureFormat:String;
      
      public function TextOptions(param1:Boolean = true, param2:Boolean = false)
      {
         super();
         this._wordWrap = param1;
         this._autoScale = param2;
         this._textureScale = Starling.contentScaleFactor;
         this._textureFormat = Context3DTextureFormat.BGR_PACKED;
         this._isHtmlText = false;
      }
      
      public function copyFrom(param1:TextOptions) : void
      {
         this._wordWrap = param1._wordWrap;
         this._autoScale = param1._autoScale;
         this._isHtmlText = param1._isHtmlText;
         this._textureScale = param1._textureScale;
         this._textureFormat = param1._textureFormat;
      }
      
      public function clone() : TextOptions
      {
         var _loc1_:TextOptions = new TextOptions();
         _loc1_.copyFrom(this);
         return _loc1_;
      }
      
      public function get wordWrap() : Boolean
      {
         return this._wordWrap;
      }
      
      public function set wordWrap(param1:Boolean) : void
      {
         this._wordWrap = param1;
      }
      
      public function get autoScale() : Boolean
      {
         return this._autoScale;
      }
      
      public function set autoScale(param1:Boolean) : void
      {
         this._autoScale = param1;
      }
      
      public function get isHtmlText() : Boolean
      {
         return this._isHtmlText;
      }
      
      public function set isHtmlText(param1:Boolean) : void
      {
         this._isHtmlText = param1;
      }
      
      public function get textureScale() : Number
      {
         return this._textureScale;
      }
      
      public function set textureScale(param1:Number) : void
      {
         this._textureScale = param1;
      }
      
      public function get textureFormat() : String
      {
         return this._textureFormat;
      }
      
      public function set textureFormat(param1:String) : void
      {
         this._textureFormat = param1;
      }
   }
}

