package starling.filters
{
   import starling.rendering.FilterEffect;
   import starling.rendering.Painter;
   import starling.textures.Texture;
   
   public class BlurFilter extends FragmentFilter
   {
      
      private var _blurX:Number;
      
      private var _blurY:Number;
      
      public function BlurFilter(param1:Number = 1, param2:Number = 1, param3:Number = 1)
      {
         super();
         this._blurX = param1;
         this._blurY = param2;
         this.resolution = param3;
      }
      
      override public function process(param1:Painter, param2:IFilterHelper, param3:Texture = null, param4:Texture = null, param5:Texture = null, param6:Texture = null) : Texture
      {
         var _loc7_:Texture = null;
         var _loc8_:BlurEffect = this.effect as BlurEffect;
         if(this._blurX == 0 && this._blurY == 0)
         {
            _loc8_.strength = 0;
            return super.process(param1,param2,param3);
         }
         var _loc9_:Number = Math.abs(this._blurX);
         var _loc10_:Number = Math.abs(this._blurY);
         var _loc11_:Texture = param3;
         _loc8_.direction = BlurEffect.HORIZONTAL;
         while(_loc9_ > 0)
         {
            _loc8_.strength = Math.min(1,_loc9_);
            _loc9_ -= _loc8_.strength;
            _loc7_ = _loc11_;
            _loc11_ = super.process(param1,param2,_loc7_);
            if(_loc7_ != param3)
            {
               param2.putTexture(_loc7_);
            }
         }
         _loc8_.direction = BlurEffect.VERTICAL;
         while(_loc10_ > 0)
         {
            _loc8_.strength = Math.min(1,_loc10_);
            _loc10_ -= _loc8_.strength;
            _loc7_ = _loc11_;
            _loc11_ = super.process(param1,param2,_loc7_);
            if(_loc7_ != param3)
            {
               param2.putTexture(_loc7_);
            }
         }
         return _loc11_;
      }
      
      override protected function createEffect() : FilterEffect
      {
         return new BlurEffect();
      }
      
      override public function set resolution(param1:Number) : void
      {
         super.resolution = param1;
         this.updatePadding();
      }
      
      override public function get numPasses() : int
      {
         return int(Math.ceil(this._blurX) + Math.ceil(this._blurY)) || 1;
      }
      
      private function updatePadding() : void
      {
         var _loc1_:Number = (this._blurX ? Math.ceil(Math.abs(this._blurX)) + 3 : 1) / resolution;
         var _loc2_:Number = (this._blurY ? Math.ceil(Math.abs(this._blurY)) + 3 : 1) / resolution;
         padding.setTo(_loc1_,_loc1_,_loc2_,_loc2_);
      }
      
      public function get blurX() : Number
      {
         return this._blurX;
      }
      
      public function set blurX(param1:Number) : void
      {
         this._blurX = param1;
         this.updatePadding();
      }
      
      public function get blurY() : Number
      {
         return this._blurY;
      }
      
      public function set blurY(param1:Number) : void
      {
         this._blurY = param1;
         this.updatePadding();
      }
   }
}

import flash.display3D.*;
import starling.rendering.*;
import starling.utils.*;

class BlurEffect extends FilterEffect
{
   
   public static const HORIZONTAL:String = "horizontal";
   
   public static const VERTICAL:String = "vertical";
   
   private static const MAX_SIGMA:Number = 2;
   
   private var _strength:Number;
   
   private var _direction:String;
   
   private var _offsets:Vector.<Number> = new <Number>[0,0,0,0];
   
   private var _weights:Vector.<Number> = new <Number>[0,0,0,0];
   
   private var sTmpWeights:Vector.<Number> = new Vector.<Number>(5,true);
   
   public function BlurEffect(param1:String = "horizontal", param2:Number = 1)
   {
      super();
      this.strength = param2;
      this.direction = param1;
   }
   
   override protected function createProgram() : Program
   {
      if(this._strength == 0)
      {
         return super.createProgram();
      }
      var _loc1_:String = ["m44 op, va0, vc0     ","mov v0, va1          ","sub v1, va1, vc4.zwxx","sub v2, va1, vc4.xyxx","add v3, va1, vc4.xyxx","add v4, va1, vc4.zwxx"].join("\n");
      var _loc2_:String = [tex("ft0","v0",0,texture),"mul ft5, ft0, fc0.xxxx       ",tex("ft1","v1",0,texture),"mul ft1, ft1, fc0.zzzz       ","add ft5, ft5, ft1            ",tex("ft2","v2",0,texture),"mul ft2, ft2, fc0.yyyy       ","add ft5, ft5, ft2            ",tex("ft3","v3",0,texture),"mul ft3, ft3, fc0.yyyy       ","add ft5, ft5, ft3            ",tex("ft4","v4",0,texture),"mul ft4, ft4, fc0.zzzz       ","add  oc, ft5, ft4            "].join("\n");
      return Program.fromSource(_loc1_,_loc2_);
   }
   
   override protected function beforeDraw(param1:Context3D) : void
   {
      super.beforeDraw(param1);
      if(this._strength)
      {
         this.updateParameters();
         param1.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,this._offsets);
         param1.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,this._weights);
      }
   }
   
   override protected function get programVariantName() : uint
   {
      return super.programVariantName | (this._strength ? 1 << 4 : 0);
   }
   
   private function updateParameters() : void
   {
      var _loc1_:Number = Number(NaN);
      var _loc2_:Number = Number(NaN);
      var _loc3_:Number = Number(NaN);
      if(this._direction == HORIZONTAL)
      {
         _loc1_ = this._strength * MAX_SIGMA;
         _loc2_ = 1 / texture.root.width;
      }
      else
      {
         _loc1_ = this._strength * MAX_SIGMA;
         _loc2_ = 1 / texture.root.height;
      }
      _loc3_ = 2 * _loc1_ * _loc1_;
      var _loc4_:Number = 1 / Math.sqrt(_loc3_ * Math.PI);
      var _loc5_:int = 0;
      while(_loc5_ < 5)
      {
         this.sTmpWeights[_loc5_] = _loc4_ * Math.exp(-_loc5_ * _loc5_ / _loc3_);
         _loc5_++;
      }
      this._weights[0] = this.sTmpWeights[0];
      this._weights[1] = this.sTmpWeights[1] + this.sTmpWeights[2];
      this._weights[2] = this.sTmpWeights[3] + this.sTmpWeights[4];
      var _loc6_:Number = this._weights[0] + 2 * this._weights[1] + 2 * this._weights[2];
      var _loc7_:Number = 1 / _loc6_;
      this._weights[0] *= _loc7_;
      this._weights[1] *= _loc7_;
      this._weights[2] *= _loc7_;
      var _loc8_:Number = (_loc2_ * this.sTmpWeights[1] + 2 * _loc2_ * this.sTmpWeights[2]) / this._weights[1];
      var _loc9_:Number = (3 * _loc2_ * this.sTmpWeights[3] + 4 * _loc2_ * this.sTmpWeights[4]) / this._weights[2];
      if(this._direction == HORIZONTAL)
      {
         this._offsets[0] = _loc8_;
         this._offsets[1] = 0;
         this._offsets[2] = _loc9_;
         this._offsets[3] = 0;
      }
      else
      {
         this._offsets[0] = 0;
         this._offsets[1] = _loc8_;
         this._offsets[2] = 0;
         this._offsets[3] = _loc9_;
      }
   }
   
   public function get direction() : String
   {
      return this._direction;
   }
   
   public function set direction(param1:String) : void
   {
      this._direction = param1;
   }
   
   public function get strength() : Number
   {
      return this._strength;
   }
   
   public function set strength(param1:Number) : void
   {
      this._strength = MathUtil.clamp(param1,0,1);
   }
}
