package starling.filters
{
   import starling.rendering.FilterEffect;
   import starling.rendering.Painter;
   import starling.textures.Texture;
   
   public class DisplacementMapFilter extends FragmentFilter
   {
      
      private var _mapX:Number;
      
      private var _mapY:Number;
      
      public function DisplacementMapFilter(param1:Texture, param2:uint = 0, param3:uint = 0, param4:Number = 0, param5:Number = 0)
      {
         super();
         this._mapX = this._mapY = 0;
         this.mapTexture = param1;
         this.componentX = param2;
         this.componentY = param3;
         this.scaleX = param4;
         this.scaleY = param5;
      }
      
      override public function process(param1:Painter, param2:IFilterHelper, param3:Texture = null, param4:Texture = null, param5:Texture = null, param6:Texture = null) : Texture
      {
         this.updateVertexData(param3,this.mapTexture);
         return super.process(param1,param2,param3);
      }
      
      override protected function createEffect() : FilterEffect
      {
         return new DisplacementMapEffect();
      }
      
      private function updateVertexData(param1:Texture, param2:Texture) : void
      {
         var _loc3_:Number = (this._mapX + padding.left) / param2.width;
         var _loc4_:Number = (this._mapY + padding.top) / param2.height;
         var _loc5_:Number = param1.width / param2.width;
         var _loc6_:Number = param1.height / param2.height;
         param2.setTexCoords(vertexData,0,"mapTexCoords",-_loc3_,-_loc4_);
         param2.setTexCoords(vertexData,1,"mapTexCoords",-_loc3_ + _loc5_,-_loc4_);
         param2.setTexCoords(vertexData,2,"mapTexCoords",-_loc3_,-_loc4_ + _loc6_);
         param2.setTexCoords(vertexData,3,"mapTexCoords",-_loc3_ + _loc5_,-_loc4_ + _loc6_);
      }
      
      private function updatePadding() : void
      {
         var _loc1_:Number = Math.ceil(Math.abs(this.dispEffect.scaleX) / 2);
         var _loc2_:Number = Math.ceil(Math.abs(this.dispEffect.scaleY) / 2);
         padding.setTo(_loc1_,_loc1_,_loc2_,_loc2_);
      }
      
      public function get componentX() : uint
      {
         return this.dispEffect.componentX;
      }
      
      public function set componentX(param1:uint) : void
      {
         if(this.dispEffect.componentX != param1)
         {
            this.dispEffect.componentX = param1;
            setRequiresRedraw();
         }
      }
      
      public function get componentY() : uint
      {
         return this.dispEffect.componentY;
      }
      
      public function set componentY(param1:uint) : void
      {
         if(this.dispEffect.componentY != param1)
         {
            this.dispEffect.componentY = param1;
            setRequiresRedraw();
         }
      }
      
      public function get scaleX() : Number
      {
         return this.dispEffect.scaleX;
      }
      
      public function set scaleX(param1:Number) : void
      {
         if(this.dispEffect.scaleX != param1)
         {
            this.dispEffect.scaleX = param1;
            this.updatePadding();
         }
      }
      
      public function get scaleY() : Number
      {
         return this.dispEffect.scaleY;
      }
      
      public function set scaleY(param1:Number) : void
      {
         if(this.dispEffect.scaleY != param1)
         {
            this.dispEffect.scaleY = param1;
            this.updatePadding();
         }
      }
      
      public function get mapX() : Number
      {
         return this._mapX;
      }
      
      public function set mapX(param1:Number) : void
      {
         this._mapX = param1;
         setRequiresRedraw();
      }
      
      public function get mapY() : Number
      {
         return this._mapY;
      }
      
      public function set mapY(param1:Number) : void
      {
         this._mapY = param1;
         setRequiresRedraw();
      }
      
      public function get mapTexture() : Texture
      {
         return this.dispEffect.mapTexture;
      }
      
      public function set mapTexture(param1:Texture) : void
      {
         if(this.dispEffect.mapTexture != param1)
         {
            this.dispEffect.mapTexture = param1;
            setRequiresRedraw();
         }
      }
      
      public function get mapRepeat() : Boolean
      {
         return this.dispEffect.mapRepeat;
      }
      
      public function set mapRepeat(param1:Boolean) : void
      {
         if(this.dispEffect.mapRepeat != param1)
         {
            this.dispEffect.mapRepeat = param1;
            setRequiresRedraw();
         }
      }
      
      private function get dispEffect() : DisplacementMapEffect
      {
         return this.effect as DisplacementMapEffect;
      }
   }
}

import flash.display.*;
import flash.display3D.*;
import flash.geom.*;
import starling.core.*;
import starling.rendering.*;
import starling.textures.Texture;
import starling.utils.*;

class DisplacementMapEffect extends FilterEffect
{
   
   public static const VERTEX_FORMAT:VertexDataFormat = FilterEffect.VERTEX_FORMAT.extend("mapTexCoords:float2");
   
   private static var sOffset:Vector.<Number> = new <Number>[0.5,0.5,0,0];
   
   private static var sMatrix:Matrix3D = new Matrix3D();
   
   private static var sMatrixData:Vector.<Number> = new <Number>[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
   
   private var _mapTexture:Texture;
   
   private var _mapRepeat:Boolean;
   
   private var _componentX:uint;
   
   private var _componentY:uint;
   
   private var _scaleX:Number;
   
   private var _scaleY:Number;
   
   public function DisplacementMapEffect()
   {
      super();
      this._componentX = this._componentY = 0;
      this._scaleX = this._scaleY = 0;
   }
   
   override protected function createProgram() : Program
   {
      var _loc1_:String = null;
      var _loc2_:String = null;
      if(this._mapTexture)
      {
         _loc1_ = ["m44  op, va0, vc0","mov  v0, va1","mov  v1, va2"].join("\n");
         _loc2_ = [tex("ft0","v1",1,this._mapTexture,false),"sub ft1, ft0, fc0","mul ft1.xy, ft1.xy, ft0.ww","m44 ft2, ft1, fc1","add ft3,  v0, ft2",tex("oc","ft3",0,texture)].join("\n");
         return Program.fromSource(_loc1_,_loc2_);
      }
      return super.createProgram();
   }
   
   override protected function beforeDraw(param1:Context3D) : void
   {
      super.beforeDraw(param1);
      if(this._mapTexture)
      {
         this.getMapMatrix(sMatrix);
         this.vertexFormat.setVertexBufferAt(2,vertexBuffer,"mapTexCoords");
         param1.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,sOffset);
         param1.setProgramConstantsFromMatrix(Context3DProgramType.FRAGMENT,1,sMatrix,true);
         RenderUtil.setSamplerStateAt(1,this._mapTexture.mipMapping,textureSmoothing,this._mapRepeat);
         param1.setTextureAt(1,this._mapTexture.base);
      }
   }
   
   override protected function afterDraw(param1:Context3D) : void
   {
      if(this._mapTexture)
      {
         param1.setVertexBufferAt(2,null);
         param1.setTextureAt(1,null);
      }
      super.afterDraw(param1);
   }
   
   override public function get vertexFormat() : VertexDataFormat
   {
      return VERTEX_FORMAT;
   }
   
   private function getMapMatrix(param1:Matrix3D) : Matrix3D
   {
      var _loc2_:int = 0;
      var _loc3_:int = 0;
      if(param1 == null)
      {
         param1 = new Matrix3D();
      }
      var _loc4_:Number = Number(Starling.contentScaleFactor);
      var _loc5_:Number = Number(texture.root.nativeWidth);
      var _loc6_:Number = Number(texture.root.nativeHeight);
      var _loc7_:int = 0;
      while(_loc7_ < 16)
      {
         sMatrixData[_loc7_] = 0;
         _loc7_++;
      }
      if(this._componentX == BitmapDataChannel.RED)
      {
         _loc2_ = 0;
      }
      else if(this._componentX == BitmapDataChannel.GREEN)
      {
         _loc2_ = 1;
      }
      else if(this._componentX == BitmapDataChannel.BLUE)
      {
         _loc2_ = 2;
      }
      else
      {
         _loc2_ = 3;
      }
      if(this._componentY == BitmapDataChannel.RED)
      {
         _loc3_ = 0;
      }
      else if(this._componentY == BitmapDataChannel.GREEN)
      {
         _loc3_ = 1;
      }
      else if(this._componentY == BitmapDataChannel.BLUE)
      {
         _loc3_ = 2;
      }
      else
      {
         _loc3_ = 3;
      }
      sMatrixData[int(_loc2_ * 4)] = this._scaleX * _loc4_ / _loc5_;
      sMatrixData[int(_loc3_ * 4 + 1)] = this._scaleY * _loc4_ / _loc6_;
      param1.copyRawDataFrom(sMatrixData);
      return param1;
   }
   
   public function get componentX() : uint
   {
      return this._componentX;
   }
   
   public function set componentX(param1:uint) : void
   {
      this._componentX = param1;
   }
   
   public function get componentY() : uint
   {
      return this._componentY;
   }
   
   public function set componentY(param1:uint) : void
   {
      this._componentY = param1;
   }
   
   public function get scaleX() : Number
   {
      return this._scaleX;
   }
   
   public function set scaleX(param1:Number) : void
   {
      this._scaleX = param1;
   }
   
   public function get scaleY() : Number
   {
      return this._scaleY;
   }
   
   public function set scaleY(param1:Number) : void
   {
      this._scaleY = param1;
   }
   
   public function get mapTexture() : Texture
   {
      return this._mapTexture;
   }
   
   public function set mapTexture(param1:Texture) : void
   {
      this._mapTexture = param1;
   }
   
   public function get mapRepeat() : Boolean
   {
      return this._mapRepeat;
   }
   
   public function set mapRepeat(param1:Boolean) : void
   {
      this._mapRepeat = param1;
   }
}
