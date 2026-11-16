package starling.rendering
{
   import flash.display.Stage3D;
   import flash.display3D.*;
   import flash.display3D.textures.TextureBase;
   import flash.errors.*;
   import flash.geom.*;
   import flash.utils.*;
   import starling.core.starling_internal;
   import starling.display.*;
   import starling.events.*;
   import starling.textures.Texture;
   import starling.utils.*;
   
   use namespace starling_internal;
   
   public class Painter
   {
      
      private static var sMatrix:Matrix = new Matrix();
      
      private static var sPoint3D:Vector3D = new Vector3D();
      
      private static var sClipRect:Rectangle = new Rectangle();
      
      private static var sBufferRect:Rectangle = new Rectangle();
      
      private static var sScissorRect:Rectangle = new Rectangle();
      
      private static var sMeshSubset:MeshSubset = new MeshSubset();
      
      private var _stage3D:Stage3D;
      
      private var _context:Context3D;
      
      private var _shareContext:Boolean;
      
      private var _programs:Dictionary;
      
      private var _data:Dictionary;
      
      private var _drawCount:int;
      
      private var _frameID:uint;
      
      private var _pixelSize:Number;
      
      private var _enableErrorChecking:Boolean;
      
      private var _stencilReferenceValues:Dictionary;
      
      private var _clipRectStack:Vector.<Rectangle>;
      
      private var _batchProcessor:BatchProcessor;
      
      private var _batchCache:BatchProcessor;
      
      private var _batchCacheExclusions:Vector.<DisplayObject>;
      
      private var _actualRenderTarget:TextureBase;
      
      private var _actualCulling:String;
      
      private var _actualBlendMode:String;
      
      private var _backBufferWidth:Number;
      
      private var _backBufferHeight:Number;
      
      private var _backBufferScaleFactor:Number;
      
      private var _state:RenderState;
      
      private var _stateStack:Vector.<RenderState>;
      
      private var _stateStackPos:int;
      
      private var _stateStackLength:int;
      
      public function Painter(param1:Stage3D)
      {
         super();
         this._stage3D = param1;
         this._stage3D.addEventListener(Event.CONTEXT3D_CREATE,this.onContextCreated,false,10,true);
         this._context = this._stage3D.context3D;
         this._shareContext = Boolean(this._context) && this._context.driverInfo != "Disposed";
         this._backBufferWidth = this._context ? Number(this._context.backBufferWidth) : 0;
         this._backBufferHeight = this._context ? Number(this._context.backBufferHeight) : 0;
         this._backBufferScaleFactor = this._pixelSize = 1;
         this._stencilReferenceValues = new Dictionary(true);
         this._clipRectStack = new Vector.<Rectangle>(0);
         this._programs = new Dictionary();
         this._data = new Dictionary();
         this._batchProcessor = new BatchProcessor();
         this._batchProcessor.onBatchComplete = this.drawBatch;
         this._batchCache = new BatchProcessor();
         this._batchCache.onBatchComplete = this.drawBatch;
         this._batchCacheExclusions = new Vector.<DisplayObject>();
         this._state = new RenderState();
         this._state.onDrawRequired = this.finishMeshBatch;
         this._stateStack = new Vector.<RenderState>(0);
         this._stateStackPos = -1;
         this._stateStackLength = 0;
      }
      
      public function dispose() : void
      {
         var _loc1_:Program = null;
         this._batchProcessor.dispose();
         this._batchCache.dispose();
         if(!this._shareContext)
         {
            this._context.dispose(false);
         }
         for each(_loc1_ in this._programs)
         {
            _loc1_.dispose();
         }
      }
      
      public function requestContext3D(param1:String, param2:*) : void
      {
         RenderUtil.requestContext3D(this._stage3D,param1,param2);
      }
      
      private function onContextCreated(param1:Object) : void
      {
         this._context = this._stage3D.context3D;
         this._context.enableErrorChecking = this._enableErrorChecking;
         this._actualBlendMode = null;
         this._actualCulling = null;
      }
      
      public function configureBackBuffer(param1:Rectangle, param2:Number, param3:int, param4:Boolean) : void
      {
         param4 &&= Boolean(SystemUtil.supportsDepthAndStencil);
         if(this._context.profile == "baselineConstrained")
         {
            this._context.configureBackBuffer(32,32,param3,param4);
         }
         if(param1.width * param2 > this._context.maxBackBufferWidth || param1.height * param2 > this._context.maxBackBufferHeight)
         {
            param2 = 1;
         }
         this._stage3D.x = param1.x;
         this._stage3D.y = param1.y;
         this._context.configureBackBuffer(param1.width,param1.height,param3,param4,param2 != 1);
         this._backBufferWidth = param1.width;
         this._backBufferHeight = param1.height;
         this._backBufferScaleFactor = param2;
      }
      
      public function registerProgram(param1:String, param2:Program) : void
      {
         this.deleteProgram(param1);
         this._programs[param1] = param2;
      }
      
      public function deleteProgram(param1:String) : void
      {
         var _loc2_:Program = this.getProgram(param1);
         if(_loc2_)
         {
            _loc2_.dispose();
            delete this._programs[param1];
         }
      }
      
      public function getProgram(param1:String) : Program
      {
         if(param1 in this._programs)
         {
            return this._programs[param1];
         }
         return null;
      }
      
      public function hasProgram(param1:String) : Boolean
      {
         return param1 in this._programs;
      }
      
      public function pushState(param1:BatchToken = null) : void
      {
         ++this._stateStackPos;
         if(this._stateStackLength < this._stateStackPos + 1)
         {
            this._stateStack[this._stateStackLength++] = new RenderState();
         }
         if(param1)
         {
            this._batchProcessor.fillToken(param1);
         }
         this._stateStack[this._stateStackPos].copyFrom(this._state);
      }
      
      public function setStateTo(param1:Matrix, param2:Number = 1, param3:String = "auto") : void
      {
         if(param1)
         {
            MatrixUtil.prependMatrix(this._state._modelviewMatrix,param1);
         }
         if(param2 != 1)
         {
            this._state._alpha *= param2;
         }
         if(param3 != BlendMode.AUTO)
         {
            this._state.blendMode = param3;
         }
      }
      
      public function popState(param1:BatchToken = null) : void
      {
         if(this._stateStackPos < 0)
         {
            throw new IllegalOperationError("Cannot pop empty state stack");
         }
         this._state.copyFrom(this._stateStack[this._stateStackPos]);
         --this._stateStackPos;
         if(param1)
         {
            this._batchProcessor.fillToken(param1);
         }
      }
      
      public function drawMask(param1:DisplayObject, param2:DisplayObject = null) : void
      {
         if(this._context == null)
         {
            return;
         }
         this.finishMeshBatch();
         if(this.isRectangularMask(param1,sMatrix))
         {
            param1.getBounds(param1,sClipRect);
            RectangleUtil.getBounds(sClipRect,sMatrix,sClipRect);
            this.pushClipRect(sClipRect);
         }
         else
         {
            this._context.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK,Context3DCompareMode.EQUAL,Context3DStencilAction.INCREMENT_SATURATE);
            this.renderMask(param1);
            ++this.stencilReferenceValue;
            this._context.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK,Context3DCompareMode.EQUAL,Context3DStencilAction.KEEP);
         }
         this.excludeFromCache(param2);
      }
      
      public function eraseMask(param1:DisplayObject) : void
      {
         if(this._context == null)
         {
            return;
         }
         this.finishMeshBatch();
         if(this.isRectangularMask(param1,sMatrix))
         {
            this.popClipRect();
         }
         else
         {
            this._context.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK,Context3DCompareMode.EQUAL,Context3DStencilAction.DECREMENT_SATURATE);
            this.renderMask(param1);
            --this.stencilReferenceValue;
            this._context.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK,Context3DCompareMode.EQUAL,Context3DStencilAction.KEEP);
         }
      }
      
      private function renderMask(param1:DisplayObject) : void
      {
         this.pushState();
         this._state.alpha = 0;
         if(param1.stage)
         {
            param1.getTransformationMatrix(null,this._state.modelviewMatrix);
         }
         else
         {
            this._state.transformModelviewMatrix(param1.transformationMatrix);
         }
         param1.render(this);
         this.finishMeshBatch();
         this.popState();
      }
      
      private function pushClipRect(param1:Rectangle) : void
      {
         var _loc2_:Vector.<Rectangle> = this._clipRectStack;
         var _loc3_:uint = _loc2_.length;
         var _loc4_:Rectangle = Pool.getRectangle();
         if(_loc3_)
         {
            RectangleUtil.intersect(_loc2_[_loc3_ - 1],param1,_loc4_);
         }
         else
         {
            _loc4_.copyFrom(param1);
         }
         _loc2_[_loc3_] = _loc4_;
         this._state.clipRect = _loc4_;
      }
      
      private function popClipRect() : void
      {
         var _loc1_:Vector.<Rectangle> = this._clipRectStack;
         var _loc2_:uint = _loc1_.length;
         if(_loc2_ == 0)
         {
            throw new Error("Trying to pop from empty clip rectangle stack");
         }
         _loc2_--;
         Pool.putRectangle(_loc1_.pop());
         this._state.clipRect = _loc2_ ? _loc1_[_loc2_ - 1] : null;
      }
      
      private function isRectangularMask(param1:DisplayObject, param2:Matrix) : Boolean
      {
         var _loc3_:Quad = param1 as Quad;
         if(Boolean(_loc3_) && Boolean(!_loc3_.is3D) && _loc3_.texture == null)
         {
            if(param1.stage)
            {
               param1.getTransformationMatrix(null,param2);
            }
            else
            {
               param2.copyFrom(param1.transformationMatrix);
               param2.concat(this._state.modelviewMatrix);
            }
            return Boolean(MathUtil.isEquivalent(param2.a,0)) && Boolean(MathUtil.isEquivalent(param2.d,0)) || Boolean(MathUtil.isEquivalent(param2.b,0)) && Boolean(MathUtil.isEquivalent(param2.c,0));
         }
         return false;
      }
      
      public function batchMesh(param1:Mesh, param2:MeshSubset = null) : void
      {
         this._batchProcessor.addMesh(param1,this._state,param2);
      }
      
      public function finishMeshBatch() : void
      {
         this._batchProcessor.finishBatch();
      }
      
      public function finishFrame() : void
      {
         if(this._frameID % 99 == 0)
         {
            this._batchProcessor.trim();
         }
         this._batchProcessor.finishBatch();
         this.swapBatchProcessors();
         this._batchProcessor.clear();
         this.processCacheExclusions();
      }
      
      private function swapBatchProcessors() : void
      {
         var _loc1_:BatchProcessor = this._batchProcessor;
         this._batchProcessor = this._batchCache;
         this._batchCache = _loc1_;
      }
      
      private function processCacheExclusions() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = int(this._batchCacheExclusions.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this._batchCacheExclusions[_loc1_].excludeFromCache();
            _loc1_++;
         }
         this._batchCacheExclusions.length = 0;
      }
      
      public function nextFrame() : void
      {
         this.stencilReferenceValue = 0;
         this._clipRectStack.length = 0;
         this._drawCount = 0;
         this._stateStackPos = -1;
         this._batchProcessor.clear();
         this._context.setDepthTest(false,Context3DCompareMode.ALWAYS);
         this._state.reset();
      }
      
      public function drawFromCache(param1:BatchToken, param2:BatchToken) : void
      {
         var _loc3_:MeshBatch = null;
         var _loc4_:int = 0;
         var _loc5_:MeshSubset = sMeshSubset;
         if(!param1.equals(param2))
         {
            this.pushState();
            _loc4_ = param1.batchID;
            while(_loc4_ <= param2.batchID)
            {
               _loc3_ = this._batchCache.getBatchAt(_loc4_);
               _loc5_.setTo();
               if(_loc4_ == param1.batchID)
               {
                  _loc5_.vertexID = param1.vertexID;
                  _loc5_.indexID = param1.indexID;
                  _loc5_.numVertices = _loc3_.numVertices - _loc5_.vertexID;
                  _loc5_.numIndices = _loc3_.numIndices - _loc5_.indexID;
               }
               if(_loc4_ == param2.batchID)
               {
                  _loc5_.numVertices = param2.vertexID - _loc5_.vertexID;
                  _loc5_.numIndices = param2.indexID - _loc5_.indexID;
               }
               if(_loc5_.numVertices)
               {
                  this._state.alpha = 1;
                  this._state.blendMode = _loc3_.blendMode;
                  this._batchProcessor.addMesh(_loc3_,this._state,_loc5_,true);
               }
               _loc4_++;
            }
            this.popState();
         }
      }
      
      public function rewindCacheTo(param1:BatchToken) : void
      {
         this._batchProcessor.rewindTo(param1);
      }
      
      public function excludeFromCache(param1:DisplayObject) : void
      {
         if(param1)
         {
            this._batchCacheExclusions[this._batchCacheExclusions.length] = param1;
         }
      }
      
      private function drawBatch(param1:MeshBatch) : void
      {
         this.pushState();
         this.state.blendMode = param1.blendMode;
         this.state.modelviewMatrix.identity();
         this.state.alpha = 1;
         param1.render(this);
         this.popState();
      }
      
      public function prepareToDraw() : void
      {
         this.applyBlendMode();
         this.applyRenderTarget();
         this.applyClipRect();
         this.applyCulling();
      }
      
      public function clear(param1:uint = 0, param2:Number = 0) : void
      {
         this.applyRenderTarget();
         this.stencilReferenceValue = 0;
         RenderUtil.clear(param1,param2);
      }
      
      public function present() : void
      {
         this._state.renderTarget = null;
         this._actualRenderTarget = null;
         this._context.present();
      }
      
      private function applyBlendMode() : void
      {
         var _loc1_:String = this._state.blendMode;
         if(_loc1_ != this._actualBlendMode)
         {
            BlendMode.get(this._state.blendMode).activate();
            this._actualBlendMode = _loc1_;
         }
      }
      
      private function applyCulling() : void
      {
         var _loc1_:String = this._state.culling;
         if(_loc1_ != this._actualCulling)
         {
            this._context.setCulling(_loc1_);
            this._actualCulling = _loc1_;
         }
      }
      
      private function applyRenderTarget() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:TextureBase = this._state.renderTargetBase;
         if(_loc3_ != this._actualRenderTarget)
         {
            if(_loc3_)
            {
               _loc1_ = int(this._state.renderTargetAntiAlias);
               _loc2_ = Boolean(this._state.renderTargetSupportsDepthAndStencil);
               this._context.setRenderToTexture(_loc3_,_loc2_,_loc1_);
            }
            else
            {
               this._context.setRenderToBackBuffer();
            }
            this._context.setStencilReferenceValue(this.stencilReferenceValue);
            this._actualRenderTarget = _loc3_;
         }
      }
      
      private function applyClipRect() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Matrix3D = null;
         var _loc4_:Texture = null;
         var _loc5_:Rectangle = this._state.clipRect;
         if(_loc5_)
         {
            _loc3_ = this._state.projectionMatrix3D;
            _loc4_ = this._state.renderTarget;
            if(_loc4_)
            {
               _loc1_ = _loc4_.root.nativeWidth;
               _loc2_ = _loc4_.root.nativeHeight;
            }
            else
            {
               _loc1_ = int(this._backBufferWidth);
               _loc2_ = int(this._backBufferHeight);
            }
            MatrixUtil.transformCoords3D(_loc3_,_loc5_.x,_loc5_.y,0,sPoint3D);
            sPoint3D.project();
            sClipRect.x = (sPoint3D.x * 0.5 + 0.5) * _loc1_;
            sClipRect.y = (0.5 - sPoint3D.y * 0.5) * _loc2_;
            MatrixUtil.transformCoords3D(_loc3_,_loc5_.right,_loc5_.bottom,0,sPoint3D);
            sPoint3D.project();
            sClipRect.right = (sPoint3D.x * 0.5 + 0.5) * _loc1_;
            sClipRect.bottom = (0.5 - sPoint3D.y * 0.5) * _loc2_;
            sBufferRect.setTo(0,0,_loc1_,_loc2_);
            RectangleUtil.intersect(sClipRect,sBufferRect,sScissorRect);
            if(sScissorRect.width < 1 || sScissorRect.height < 1)
            {
               sScissorRect.setTo(0,0,1,1);
            }
            this._context.setScissorRectangle(sScissorRect);
         }
         else
         {
            this._context.setScissorRectangle(null);
         }
      }
      
      public function get drawCount() : int
      {
         return this._drawCount;
      }
      
      public function set drawCount(param1:int) : void
      {
         this._drawCount = param1;
      }
      
      public function get stencilReferenceValue() : uint
      {
         var _loc1_:Object = this._state.renderTarget ? this._state.renderTargetBase : this;
         if(_loc1_ in this._stencilReferenceValues)
         {
            return this._stencilReferenceValues[_loc1_];
         }
         return 0;
      }
      
      public function set stencilReferenceValue(param1:uint) : void
      {
         var _loc2_:Object = this._state.renderTarget ? this._state.renderTargetBase : this;
         this._stencilReferenceValues[_loc2_] = param1;
         if(this.contextValid)
         {
            this._context.setStencilReferenceValue(param1);
         }
      }
      
      public function get state() : RenderState
      {
         return this._state;
      }
      
      public function get stage3D() : Stage3D
      {
         return this._stage3D;
      }
      
      public function get context() : Context3D
      {
         return this._context;
      }
      
      public function get frameID() : uint
      {
         return this._frameID;
      }
      
      public function set frameID(param1:uint) : void
      {
         this._frameID = param1;
      }
      
      public function get pixelSize() : Number
      {
         return this._pixelSize;
      }
      
      public function set pixelSize(param1:Number) : void
      {
         this._pixelSize = param1;
      }
      
      public function get shareContext() : Boolean
      {
         return this._shareContext;
      }
      
      public function set shareContext(param1:Boolean) : void
      {
         this._shareContext = param1;
      }
      
      public function get enableErrorChecking() : Boolean
      {
         return this._enableErrorChecking;
      }
      
      public function set enableErrorChecking(param1:Boolean) : void
      {
         this._enableErrorChecking = param1;
         if(this._context)
         {
            this._context.enableErrorChecking = param1;
         }
      }
      
      public function get backBufferWidth() : int
      {
         return this._backBufferWidth;
      }
      
      public function get backBufferHeight() : int
      {
         return this._backBufferHeight;
      }
      
      public function get backBufferScaleFactor() : Number
      {
         return this._backBufferScaleFactor;
      }
      
      public function get contextValid() : Boolean
      {
         var _loc1_:String = null;
         if(this._context)
         {
            _loc1_ = this._context.driverInfo;
            return _loc1_ != null && _loc1_ != "" && _loc1_ != "Disposed";
         }
         return false;
      }
      
      public function get profile() : String
      {
         if(this._context)
         {
            return this._context.profile;
         }
         return null;
      }
      
      public function get sharedData() : Dictionary
      {
         return this._data;
      }
   }
}

