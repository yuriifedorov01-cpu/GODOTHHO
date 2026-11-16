package starling.filters
{
   import starling.rendering.Painter;
   import starling.textures.Texture;
   
   public class GlowFilter extends FragmentFilter
   {
      
      private var _blurFilter:BlurFilter;
      
      private var _compositeFilter:CompositeFilter;
      
      public function GlowFilter(param1:uint = 16776960, param2:Number = 1, param3:Number = 1, param4:Number = 0.5)
      {
         super();
         this._compositeFilter = new CompositeFilter();
         this._blurFilter = new BlurFilter(param3,param3,param4);
         this.color = param1;
         this.alpha = param2;
         this.updatePadding();
      }
      
      override public function dispose() : void
      {
         this._blurFilter.dispose();
         this._compositeFilter.dispose();
         super.dispose();
      }
      
      override public function process(param1:Painter, param2:IFilterHelper, param3:Texture = null, param4:Texture = null, param5:Texture = null, param6:Texture = null) : Texture
      {
         var _loc7_:Texture = this._blurFilter.process(param1,param2,param3);
         var _loc8_:Texture = this._compositeFilter.process(param1,param2,_loc7_,param3);
         param2.putTexture(_loc7_);
         return _loc8_;
      }
      
      override public function get numPasses() : int
      {
         return this._blurFilter.numPasses + this._compositeFilter.numPasses;
      }
      
      private function updatePadding() : void
      {
         padding.copyFrom(this._blurFilter.padding);
      }
      
      public function get color() : uint
      {
         return this._compositeFilter.getColorAt(0);
      }
      
      public function set color(param1:uint) : void
      {
         if(this.color != param1)
         {
            this._compositeFilter.setColorAt(0,param1,true);
            setRequiresRedraw();
         }
      }
      
      public function get alpha() : Number
      {
         return this._compositeFilter.getAlphaAt(0);
      }
      
      public function set alpha(param1:Number) : void
      {
         if(this.alpha != param1)
         {
            this._compositeFilter.setAlphaAt(0,param1);
            setRequiresRedraw();
         }
      }
      
      public function get blur() : Number
      {
         return this._blurFilter.blurX;
      }
      
      public function set blur(param1:Number) : void
      {
         if(this.blur != param1)
         {
            this._blurFilter.blurX = this._blurFilter.blurY = param1;
            this.updatePadding();
         }
      }
      
      override public function get resolution() : Number
      {
         return this._blurFilter.resolution;
      }
      
      override public function set resolution(param1:Number) : void
      {
         if(this.resolution != param1)
         {
            this._blurFilter.resolution = param1;
            this.updatePadding();
         }
      }
   }
}

