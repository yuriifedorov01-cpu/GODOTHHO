package starling.textures
{
   import flash.display.*;
   import flash.display3D.textures.Texture;
   import flash.display3D.textures.TextureBase;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.ByteArray;
   import starling.core.*;
   import starling.utils.*;
   
   internal class ConcretePotTexture extends ConcreteTexture
   {
      
      private static var sMatrix:Matrix = new Matrix();
      
      private static var sRectangle:Rectangle = new Rectangle();
      
      private static var sOrigin:Point = new Point();
      
      private var _textureReadyCallback:Function;
      
      public function ConcretePotTexture(param1:flash.display3D.textures.Texture, param2:String, param3:int, param4:int, param5:Boolean, param6:Boolean, param7:Boolean = false, param8:Number = 1)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8);
         if(param3 != MathUtil.getNextPowerOfTwo(param3))
         {
            throw new ArgumentError("width must be a power of two");
         }
         if(param4 != MathUtil.getNextPowerOfTwo(param4))
         {
            throw new ArgumentError("height must be a power of two");
         }
      }
      
      override public function dispose() : void
      {
         base.removeEventListener(Event.TEXTURE_READY,this.onTextureReady);
         super.dispose();
      }
      
      override protected function createBase() : TextureBase
      {
         return Starling.context.createTexture(nativeWidth,nativeHeight,format,optimizedForRenderTexture);
      }
      
      override public function uploadBitmapData(param1:BitmapData) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = 0;
         var _loc5_:BitmapData = null;
         var _loc6_:Rectangle = null;
         var _loc7_:Matrix = null;
         this.potBase.uploadFromBitmapData(param1);
         var _loc8_:BitmapData = null;
         if(param1.width != nativeWidth || param1.height != nativeHeight)
         {
            _loc8_ = new BitmapData(nativeWidth,nativeHeight,true,0);
            _loc8_.copyPixels(param1,param1.rect,sOrigin);
            param1 = _loc8_;
         }
         if(mipMapping && param1.width > 1 && param1.height > 1)
         {
            _loc2_ = param1.width >> 1;
            _loc3_ = param1.height >> 1;
            _loc4_ = 1;
            _loc5_ = new BitmapData(_loc2_,_loc3_,true,0);
            _loc6_ = sRectangle;
            _loc7_ = sMatrix;
            _loc7_.setTo(0.5,0,0,0.5,0,0);
            while(_loc2_ >= 1 || _loc3_ >= 1)
            {
               _loc6_.setTo(0,0,_loc2_,_loc3_);
               _loc5_.fillRect(_loc6_,0);
               _loc5_.draw(param1,_loc7_,null,null,null,true);
               this.potBase.uploadFromBitmapData(_loc5_,_loc4_++);
               _loc7_.scale(0.5,0.5);
               _loc2_ >>= 1;
               _loc3_ >>= 1;
            }
            _loc5_.dispose();
         }
         if(_loc8_)
         {
            _loc8_.dispose();
         }
         setDataUploaded();
      }
      
      override public function get isPotTexture() : Boolean
      {
         return true;
      }
      
      override public function uploadAtfData(param1:ByteArray, param2:int = 0, param3:* = null) : void
      {
         var _loc4_:Boolean = param3 is Function || param3 === true;
         if(param3 is Function)
         {
            this._textureReadyCallback = param3 as Function;
            base.addEventListener(Event.TEXTURE_READY,this.onTextureReady);
         }
         this.potBase.uploadCompressedTextureFromByteArray(param1,param2,_loc4_);
         setDataUploaded();
      }
      
      private function onTextureReady(param1:Event) : void
      {
         base.removeEventListener(Event.TEXTURE_READY,this.onTextureReady);
         execute(this._textureReadyCallback,this);
         this._textureReadyCallback = null;
      }
      
      private function get potBase() : flash.display3D.textures.Texture
      {
         return base as flash.display3D.textures.Texture;
      }
   }
}

