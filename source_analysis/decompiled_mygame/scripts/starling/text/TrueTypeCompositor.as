package starling.text
{
   import flash.geom.*;
   import flash.text.*;
   import starling.display.*;
   import starling.textures.*;
   import starling.utils.*;
   
   internal class TrueTypeCompositor implements ITextCompositor
   {
      
      private static var sHelperMatrix:Matrix = new Matrix();
      
      private static var sHelperQuad:Quad = new Quad(100,100);
      
      private static var sNativeTextField:flash.text.TextField = new flash.text.TextField();
      
      private static var sNativeFormat:flash.text.TextFormat = new flash.text.TextFormat();
      
      private static var sEmbeddedFonts:Array = null;
      
      public function TrueTypeCompositor()
      {
         super();
      }
      
      public static function updateEmbeddedFonts() : void
      {
         sEmbeddedFonts = null;
      }
      
      private static function isEmbeddedFont(param1:starling.text.TextFormat) : Boolean
      {
         var _loc2_:Font = null;
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         if(sEmbeddedFonts == null)
         {
            sEmbeddedFonts = Font.enumerateFonts(false);
         }
         for each(_loc2_ in sEmbeddedFonts)
         {
            _loc3_ = _loc2_.fontStyle;
            _loc4_ = _loc3_ == FontStyle.BOLD || _loc3_ == FontStyle.BOLD_ITALIC;
            _loc5_ = _loc3_ == FontStyle.ITALIC || _loc3_ == FontStyle.BOLD_ITALIC;
            if(param1.font == _loc2_.fontName && param1.italic == _loc5_ && param1.bold == _loc4_)
            {
               return true;
            }
         }
         return false;
      }
      
      public function fillMeshBatch(param1:MeshBatch, param2:Number, param3:Number, param4:String, param5:starling.text.TextFormat, param6:TextOptions = null) : void
      {
         var textureFormat:String = null;
         var texture:Texture = null;
         var bitmapData:BitmapDataEx = null;
         var meshBatch:MeshBatch = param1;
         var width:Number = param2;
         var height:Number = param3;
         var text:String = param4;
         var format:starling.text.TextFormat = param5;
         var options:TextOptions = param6;
         texture = null;
         bitmapData = null;
         if(text == null || text == "")
         {
            return;
         }
         textureFormat = options.textureFormat;
         bitmapData = this.renderText(width,height,text,format,options);
         texture = Texture.fromBitmapData(bitmapData,false,false,bitmapData.scale,textureFormat);
         texture.root.onRestore = function():void
         {
            bitmapData = renderText(width,height,text,format,options);
            texture.root.uploadBitmapData(bitmapData);
            bitmapData.dispose();
            bitmapData = null;
         };
         bitmapData.dispose();
         bitmapData = null;
         sHelperQuad.texture = texture;
         sHelperQuad.readjustSize();
         if(format.horizontalAlign == Align.LEFT)
         {
            sHelperQuad.x = 0;
         }
         else if(format.horizontalAlign == Align.CENTER)
         {
            sHelperQuad.x = int((width - texture.width) / 2);
         }
         else
         {
            sHelperQuad.x = width - texture.width;
         }
         if(format.verticalAlign == Align.TOP)
         {
            sHelperQuad.y = 0;
         }
         else if(format.verticalAlign == Align.CENTER)
         {
            sHelperQuad.y = int((height - texture.height) / 2);
         }
         else
         {
            sHelperQuad.y = height - texture.height;
         }
         meshBatch.addMesh(sHelperQuad);
         sHelperQuad.texture = null;
      }
      
      public function clearMeshBatch(param1:MeshBatch) : void
      {
         param1.clear();
         if(param1.texture)
         {
            param1.texture.dispose();
         }
      }
      
      private function renderText(param1:Number, param2:Number, param3:String, param4:starling.text.TextFormat, param5:TextOptions) : BitmapDataEx
      {
         var _loc6_:BitmapDataEx = null;
         var _loc7_:Number = param1 * param5.textureScale;
         var _loc8_:Number = param2 * param5.textureScale;
         var _loc9_:String = param4.horizontalAlign;
         param4.toNativeFormat(sNativeFormat);
         sNativeFormat.size = Number(sNativeFormat.size) * param5.textureScale;
         sNativeTextField.embedFonts = isEmbeddedFont(param4);
         sNativeTextField.defaultTextFormat = sNativeFormat;
         sNativeTextField.width = _loc7_;
         sNativeTextField.height = _loc8_;
         sNativeTextField.antiAliasType = AntiAliasType.ADVANCED;
         sNativeTextField.selectable = false;
         sNativeTextField.multiline = true;
         sNativeTextField.wordWrap = param5.wordWrap;
         if(param5.isHtmlText)
         {
            sNativeTextField.htmlText = param3;
         }
         else
         {
            sNativeTextField.text = param3;
         }
         if(param5.autoScale)
         {
            this.autoScaleNativeTextField(sNativeTextField,param3,param5.isHtmlText);
         }
         var _loc10_:Number = Number(sNativeTextField.textWidth);
         var _loc11_:Number = Number(sNativeTextField.textHeight);
         var _loc12_:int = Math.ceil(_loc10_) + 4;
         var _loc13_:int = Math.ceil(_loc11_) + 4;
         var _loc14_:int = int(Texture.maxSize);
         var _loc15_:int = 1;
         var _loc16_:Number = 0;
         if(param5.isHtmlText)
         {
            _loc10_ = _loc12_ = _loc7_;
         }
         if(_loc12_ < _loc15_)
         {
            _loc12_ = 1;
         }
         if(_loc13_ < _loc15_)
         {
            _loc13_ = 1;
         }
         if(_loc13_ > _loc14_ || _loc12_ > _loc14_)
         {
            param5.textureScale *= _loc14_ / Math.max(_loc12_,_loc13_);
            return this.renderText(param1,param2,param3,param4,param5);
         }
         if(!param5.isHtmlText)
         {
            if(_loc9_ == Align.RIGHT)
            {
               _loc16_ = _loc7_ - _loc10_ - 4;
            }
            else if(_loc9_ == Align.CENTER)
            {
               _loc16_ = (_loc7_ - _loc10_ - 4) / 2;
            }
         }
         _loc6_ = new BitmapDataEx(_loc12_,_loc13_);
         sHelperMatrix.setTo(1,0,0,1,-_loc16_,0);
         _loc6_.draw(sNativeTextField,sHelperMatrix);
         _loc6_.scale = param5.textureScale;
         sNativeTextField.text = "";
         return _loc6_;
      }
      
      private function autoScaleNativeTextField(param1:flash.text.TextField, param2:String, param3:Boolean) : void
      {
         var _loc4_:flash.text.TextFormat = param1.defaultTextFormat;
         var _loc5_:int = param1.width - 4;
         var _loc6_:int = param1.height - 4;
         var _loc7_:Number = Number(_loc4_.size);
         while(param1.textWidth > _loc5_ || param1.textHeight > _loc6_)
         {
            if(_loc7_ <= 4)
            {
               break;
            }
            _loc4_.size = _loc7_--;
            param1.defaultTextFormat = _loc4_;
            if(param3)
            {
               param1.htmlText = param2;
            }
            else
            {
               param1.text = param2;
            }
         }
      }
   }
}

import flash.display.BitmapData;

class BitmapDataEx extends BitmapData
{
   
   private var _scale:Number = 1;
   
   public function BitmapDataEx(param1:int, param2:int, param3:Boolean = true, param4:uint = 0)
   {
      super(param1,param2,param3,param4);
   }
   
   public function get scale() : Number
   {
      return this._scale;
   }
   
   public function set scale(param1:Number) : void
   {
      this._scale = param1;
   }
}
