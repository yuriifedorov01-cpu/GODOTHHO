package starling.textures
{
   import flash.display3D.textures.TextureBase;
   import flash.errors.*;
   import flash.geom.*;
   import flash.utils.Dictionary;
   import starling.core.*;
   import starling.display.*;
   import starling.filters.FragmentFilter;
   import starling.rendering.Painter;
   import starling.rendering.RenderState;
   import starling.utils.*;
   
   public class RenderTexture extends SubTexture
   {
      
      private static const USE_DOUBLE_BUFFERING_DATA_NAME:String = "starling.textures.RenderTexture.useDoubleBuffering";
      
      private static var sClipRect:Rectangle = new Rectangle();
      
      private var _activeTexture:Texture;
      
      private var _bufferTexture:Texture;
      
      private var _helperImage:Image;
      
      private var _drawing:Boolean;
      
      private var _bufferReady:Boolean;
      
      private var _isPersistent:Boolean;
      
      public function RenderTexture(param1:int, param2:int, param3:Boolean = true, param4:Number = -1, param5:String = "bgra")
      {
         this._isPersistent = param3;
         this._activeTexture = Texture.empty(param1,param2,true,false,true,param4,param5);
         this._activeTexture.root.onRestore = this._activeTexture.root.clear;
         super(this._activeTexture,new Rectangle(0,0,param1,param2),true,null,false);
         if(param3 && useDoubleBuffering)
         {
            this._bufferTexture = Texture.empty(param1,param2,true,false,true,param4,param5);
            this._bufferTexture.root.onRestore = this._bufferTexture.root.clear;
            this._helperImage = new Image(this._bufferTexture);
            this._helperImage.textureSmoothing = TextureSmoothing.NONE;
         }
      }
      
      public static function get useDoubleBuffering() : Boolean
      {
         var _loc1_:Painter = null;
         var _loc2_:Dictionary = null;
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         if(Starling.current)
         {
            _loc1_ = Starling.painter;
            _loc2_ = _loc1_.sharedData;
            if(USE_DOUBLE_BUFFERING_DATA_NAME in _loc2_)
            {
               return _loc2_[USE_DOUBLE_BUFFERING_DATA_NAME];
            }
            _loc3_ = _loc1_.profile ? _loc1_.profile : "baseline";
            _loc4_ = _loc3_ == "baseline" || _loc3_ == "baselineConstrained";
            _loc2_[USE_DOUBLE_BUFFERING_DATA_NAME] = _loc4_;
            return _loc4_;
         }
         return false;
      }
      
      public static function set useDoubleBuffering(param1:Boolean) : void
      {
         if(Starling.current == null)
         {
            throw new IllegalOperationError("Starling not yet initialized");
         }
         Starling.painter.sharedData[USE_DOUBLE_BUFFERING_DATA_NAME] = param1;
      }
      
      override public function dispose() : void
      {
         this._activeTexture.dispose();
         if(this.isDoubleBuffered)
         {
            this._bufferTexture.dispose();
            this._helperImage.dispose();
         }
         super.dispose();
      }
      
      public function draw(param1:DisplayObject, param2:Matrix = null, param3:Number = 1, param4:int = 0) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(this._drawing)
         {
            this.render(param1,param2,param3);
         }
         else
         {
            this.renderBundled(this.render,param1,param2,param3,param4);
         }
      }
      
      public function drawBundled(param1:Function, param2:int = 0) : void
      {
         this.renderBundled(param1,null,null,1,param2);
      }
      
      private function render(param1:DisplayObject, param2:Matrix = null, param3:Number = 1) : void
      {
         var _loc4_:Painter = Starling.painter;
         var _loc5_:RenderState = _loc4_.state;
         var _loc6_:FragmentFilter = param1.filter;
         var _loc7_:DisplayObject = param1.mask;
         _loc4_.pushState();
         _loc5_.alpha *= param3;
         _loc5_.setModelviewMatricesToIdentity();
         _loc5_.blendMode = param1.blendMode == BlendMode.AUTO ? BlendMode.NORMAL : param1.blendMode;
         if(param2)
         {
            _loc5_.transformModelviewMatrix(param2);
         }
         else
         {
            _loc5_.transformModelviewMatrix(param1.transformationMatrix);
         }
         if(_loc7_)
         {
            _loc4_.drawMask(_loc7_);
         }
         if(_loc6_)
         {
            _loc6_.render(_loc4_);
         }
         else
         {
            param1.render(_loc4_);
         }
         if(_loc7_)
         {
            _loc4_.eraseMask(_loc7_);
         }
         _loc4_.popState();
      }
      
      private function renderBundled(param1:Function, param2:DisplayObject = null, param3:Matrix = null, param4:Number = 1, param5:int = 0) : void
      {
         var rootTexture:Texture = null;
         var renderBlock:Function = param1;
         var object:DisplayObject = param2;
         var matrix:Matrix = param3;
         var alpha:Number = param4;
         var antiAliasing:int = param5;
         var tmpTexture:Texture = null;
         var painter:Painter = Starling.painter;
         var state:RenderState = painter.state;
         if(!Starling.current.contextValid)
         {
            return;
         }
         if(this.isDoubleBuffered)
         {
            tmpTexture = this._activeTexture;
            this._activeTexture = this._bufferTexture;
            this._bufferTexture = tmpTexture;
            this._helperImage.texture = this._bufferTexture;
         }
         painter.pushState();
         rootTexture = this._activeTexture.root;
         state.setProjectionMatrix(0,0,rootTexture.width,rootTexture.height,width,height);
         sClipRect.setTo(0,0,this._activeTexture.width,this._activeTexture.height);
         state.clipRect = sClipRect;
         state.setRenderTarget(this._activeTexture,true,antiAliasing);
         painter.prepareToDraw();
         if(Boolean(this.isDoubleBuffered) || !this.isPersistent || !this._bufferReady)
         {
            painter.clear();
         }
         if(Boolean(this.isDoubleBuffered) && Boolean(this._bufferReady))
         {
            this._helperImage.render(painter);
         }
         else
         {
            this._bufferReady = true;
         }
         try
         {
            this._drawing = true;
            execute(renderBlock,object,matrix,alpha);
         }
         finally
         {
            this._drawing = false;
            painter.popState();
         }
      }
      
      public function clear(param1:uint = 0, param2:Number = 0) : void
      {
         this._activeTexture.root.clear(param1,param2);
         this._bufferReady = true;
      }
      
      private function get isDoubleBuffered() : Boolean
      {
         return this._bufferTexture != null;
      }
      
      public function get isPersistent() : Boolean
      {
         return this._isPersistent;
      }
      
      override public function get base() : TextureBase
      {
         return this._activeTexture.base;
      }
      
      override public function get root() : ConcreteTexture
      {
         return this._activeTexture.root;
      }
   }
}

