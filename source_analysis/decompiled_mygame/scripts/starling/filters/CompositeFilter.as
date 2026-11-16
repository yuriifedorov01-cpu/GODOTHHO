package starling.filters
{
   import flash.geom.*;
   import starling.rendering.FilterEffect;
   import starling.rendering.Painter;
   import starling.textures.Texture;
   import starling.utils.*;
   
   public class CompositeFilter extends FragmentFilter
   {
      
      public function CompositeFilter()
      {
         super();
      }
      
      override public function process(param1:Painter, param2:IFilterHelper, param3:Texture = null, param4:Texture = null, param5:Texture = null, param6:Texture = null) : Texture
      {
         this.compositeEffect.texture = param3;
         this.compositeEffect.getLayerAt(1).texture = param4;
         this.compositeEffect.getLayerAt(2).texture = param5;
         this.compositeEffect.getLayerAt(3).texture = param6;
         if(param4)
         {
            param4.setupTextureCoordinates(vertexData,0,"texCoords1");
         }
         if(param5)
         {
            param5.setupTextureCoordinates(vertexData,0,"texCoords2");
         }
         if(param6)
         {
            param6.setupTextureCoordinates(vertexData,0,"texCoords3");
         }
         return super.process(param1,param2,param3,param4,param5,param6);
      }
      
      override protected function createEffect() : FilterEffect
      {
         return new CompositeEffect();
      }
      
      public function getOffsetAt(param1:int, param2:Point = null) : Point
      {
         if(param2 == null)
         {
            param2 = new Point();
         }
         param2.x = this.compositeEffect.getLayerAt(param1).x;
         param2.y = this.compositeEffect.getLayerAt(param1).y;
         return param2;
      }
      
      public function setOffsetAt(param1:int, param2:Number, param3:Number) : void
      {
         this.compositeEffect.getLayerAt(param1).x = param2;
         this.compositeEffect.getLayerAt(param1).y = param3;
      }
      
      public function getColorAt(param1:int) : uint
      {
         return this.compositeEffect.getLayerAt(param1).color;
      }
      
      public function setColorAt(param1:int, param2:uint, param3:Boolean = false) : void
      {
         this.compositeEffect.getLayerAt(param1).color = param2;
         this.compositeEffect.getLayerAt(param1).replaceColor = param3;
      }
      
      public function getAlphaAt(param1:int) : Number
      {
         return this.compositeEffect.getLayerAt(param1).alpha;
      }
      
      public function setAlphaAt(param1:int, param2:Number) : void
      {
         this.compositeEffect.getLayerAt(param1).alpha = MathUtil.clamp(param2,0,1);
      }
      
      private function get compositeEffect() : CompositeEffect
      {
         return this.effect as CompositeEffect;
      }
   }
}

import flash.display3D.*;
import starling.rendering.*;
import starling.textures.Texture;
import starling.utils.*;

class CompositeEffect extends FilterEffect
{
   
   public static const VERTEX_FORMAT:VertexDataFormat = FilterEffect.VERTEX_FORMAT.extend("texCoords1:float2, texCoords2:float2, texCoords3:float2");
   
   private static var sLayers:Array = [];
   
   private static var sOffset:Vector.<Number> = new <Number>[0,0,0,0];
   
   private static var sColor:Vector.<Number> = new <Number>[0,0,0,0];
   
   private var _layers:Vector.<CompositeLayer>;
   
   public function CompositeEffect(param1:int = 4)
   {
      super();
      if(param1 < 1 || param1 > 4)
      {
         throw new ArgumentError("number of layers must be between 1 and 4");
      }
      this._layers = new Vector.<CompositeLayer>(param1,true);
      var _loc2_:int = 0;
      while(_loc2_ < param1)
      {
         this._layers[_loc2_] = new CompositeLayer();
         _loc2_++;
      }
   }
   
   public function getLayerAt(param1:int) : CompositeLayer
   {
      return this._layers[param1];
   }
   
   private function getUsedLayers(param1:Array = null) : Array
   {
      var _loc2_:CompositeLayer = null;
      if(param1 == null)
      {
         param1 = [];
      }
      else
      {
         param1.length = 0;
      }
      for each(_loc2_ in this._layers)
      {
         if(_loc2_.texture)
         {
            param1[param1.length] = _loc2_;
         }
      }
      return param1;
   }
   
   override protected function createProgram() : Program
   {
      var _loc1_:int = 0;
      var _loc2_:Array = null;
      var _loc3_:CompositeLayer = null;
      var _loc4_:Array = null;
      var _loc5_:String = null;
      var _loc6_:String = null;
      var _loc7_:String = null;
      var _loc8_:Array = this.getUsedLayers(sLayers);
      var _loc9_:int = int(_loc8_.length);
      if(_loc9_)
      {
         _loc2_ = ["m44 op, va0, vc0"];
         _loc3_ = this._layers[0];
         _loc1_ = 0;
         while(_loc1_ < _loc9_)
         {
            _loc2_.push(StringUtil.format("add v{0}, va{1}, vc{2}",_loc1_,_loc1_ + 1,_loc1_ + 4));
            _loc1_++;
         }
         _loc4_ = ["seq ft5, v0, v0"];
         _loc1_ = 0;
         while(_loc1_ < _loc9_)
         {
            _loc5_ = "ft" + _loc1_;
            _loc6_ = "fc" + _loc1_;
            _loc7_ = "v" + _loc1_;
            _loc3_ = this._layers[_loc1_];
            _loc4_.push(tex(_loc5_,_loc7_,_loc1_,_loc8_[_loc1_].texture));
            if(_loc3_.replaceColor)
            {
               _loc4_.push("mul " + _loc5_ + ".w,   " + _loc5_ + ".w,   " + _loc6_ + ".w","mul " + _loc5_ + ".xyz, " + _loc6_ + ".xyz, " + _loc5_ + ".www");
            }
            else
            {
               _loc4_.push("mul " + _loc5_ + ", " + _loc5_ + ", " + _loc6_);
            }
            if(_loc1_ != 0)
            {
               _loc4_.push("sub ft4, ft5, " + _loc5_ + ".wwww","mul ft0, ft0, ft4","add ft0, ft0, " + _loc5_);
            }
            _loc1_++;
         }
         _loc4_.push("mov oc, ft0");
         return Program.fromSource(_loc2_.join("\n"),_loc4_.join("\n"));
      }
      return super.createProgram();
   }
   
   override protected function get programVariantName() : uint
   {
      var _loc1_:uint = 0;
      var _loc2_:CompositeLayer = null;
      var _loc3_:uint = 0;
      var _loc4_:Array = this.getUsedLayers(sLayers);
      var _loc5_:int = int(_loc4_.length);
      var _loc6_:int = 0;
      while(_loc6_ < _loc5_)
      {
         _loc2_ = _loc4_[_loc6_];
         _loc1_ = uint(RenderUtil.getTextureVariantBits(_loc2_.texture) | int(_loc2_.replaceColor) << 3);
         _loc3_ |= _loc1_ << _loc6_ * 4;
         _loc6_++;
      }
      return _loc3_;
   }
   
   override protected function beforeDraw(param1:Context3D) : void
   {
      var _loc2_:int = 0;
      var _loc3_:CompositeLayer = null;
      var _loc4_:Texture = null;
      var _loc5_:Number = Number(NaN);
      var _loc6_:Array = this.getUsedLayers(sLayers);
      var _loc7_:int = int(_loc6_.length);
      if(_loc7_)
      {
         _loc2_ = 0;
         while(_loc2_ < _loc7_)
         {
            _loc3_ = _loc6_[_loc2_];
            _loc4_ = _loc3_.texture;
            _loc5_ = _loc3_.replaceColor ? 1 : _loc3_.alpha;
            sOffset[0] = -_loc3_.x / (_loc4_.root.nativeWidth / _loc4_.scale);
            sOffset[1] = -_loc3_.y / (_loc4_.root.nativeHeight / _loc4_.scale);
            sColor[0] = Color.getRed(_loc3_.color) * _loc5_ / 255;
            sColor[1] = Color.getGreen(_loc3_.color) * _loc5_ / 255;
            sColor[2] = Color.getBlue(_loc3_.color) * _loc5_ / 255;
            sColor[3] = _loc3_.alpha;
            param1.setProgramConstantsFromVector(Context3DProgramType.VERTEX,_loc2_ + 4,sOffset);
            param1.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,_loc2_,sColor);
            param1.setTextureAt(_loc2_,_loc4_.base);
            RenderUtil.setSamplerStateAt(_loc2_,_loc4_.mipMapping,textureSmoothing);
            _loc2_++;
         }
         _loc2_ = 1;
         while(_loc2_ < _loc7_)
         {
            this.vertexFormat.setVertexBufferAt(_loc2_ + 1,vertexBuffer,"texCoords" + _loc2_);
            _loc2_++;
         }
      }
      super.beforeDraw(param1);
   }
   
   override protected function afterDraw(param1:Context3D) : void
   {
      var _loc2_:Array = this.getUsedLayers(sLayers);
      var _loc3_:int = int(_loc2_.length);
      var _loc4_:int = 0;
      while(_loc4_ < _loc3_)
      {
         param1.setTextureAt(_loc4_,null);
         param1.setVertexBufferAt(_loc4_ + 1,null);
         _loc4_++;
      }
      super.afterDraw(param1);
   }
   
   override public function get vertexFormat() : VertexDataFormat
   {
      return VERTEX_FORMAT;
   }
   
   public function get numLayers() : int
   {
      return this._layers.length;
   }
   
   override public function set texture(param1:Texture) : void
   {
      this._layers[0].texture = param1;
      super.texture = param1;
   }
}

class CompositeLayer
{
   
   public var texture:Texture;
   
   public var x:Number;
   
   public var y:Number;
   
   public var color:uint;
   
   public var alpha:Number;
   
   public var replaceColor:Boolean;
   
   public function CompositeLayer()
   {
      super();
      this.x = this.y = 0;
      this.alpha = 1;
      this.color = 16777215;
   }
}
