package starling.core
{
   import flash.system.*;
   import starling.display.*;
   import starling.events.*;
   import starling.rendering.Painter;
   import starling.styles.*;
   import starling.text.*;
   import starling.utils.*;
   
   internal class StatsDisplay extends Sprite
   {
      
      private static const UPDATE_INTERVAL:Number = 0.5;
      
      private static const B_TO_MB:Number = 1 / (1024 * 1024);
      
      private var _background:Quad;
      
      private var _labels:TextField;
      
      private var _values:TextField;
      
      private var _frameCount:int = 0;
      
      private var _totalTime:Number = 0;
      
      private var _fps:Number = 0;
      
      private var _memory:Number = 0;
      
      private var _totMemory:Number = 0;
      
      private var _gpuMemory:Number = 0;
      
      private var _drawCount:int = 0;
      
      private var _skipCount:int = 0;
      
      public function StatsDisplay()
      {
         var _loc2_:Number = NaN;
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:Number = NaN;
         var _loc1_:Number = Number(NaN);
         _loc2_ = Number(NaN);
         super();
         _loc3_ = BitmapFont.MINI;
         _loc1_ = Number(BitmapFont.NATIVE_SIZE);
         _loc4_ = 16777215;
         _loc5_ = 90;
         _loc2_ = this.supportsGpuMem ? 43 : 35;
         var _loc6_:String = this.supportsGpuMem ? "\ngpu memory:" : "";
         var _loc7_:String = "frames/sec:\nstd memory:\ntotal memory:" + _loc6_ + "\ndraw calls:";
         this._labels = new TextField(_loc5_,_loc2_,_loc7_);
         this._labels.format.setTo(_loc3_,_loc1_,_loc4_,Align.LEFT);
         this._labels.batchable = true;
         this._labels.x = 2;
         this._values = new TextField(_loc5_ - 1,_loc2_,"");
         this._values.format.setTo(_loc3_,_loc1_,_loc4_,Align.RIGHT);
         this._values.batchable = true;
         this._background = new Quad(_loc5_,_loc2_,0);
         if(this._background.style.type != MeshStyle)
         {
            this._background.style = new MeshStyle();
         }
         if(this._labels.style.type != MeshStyle)
         {
            this._labels.style = new MeshStyle();
         }
         if(this._values.style.type != MeshStyle)
         {
            this._values.style = new MeshStyle();
         }
         addChild(this._background);
         addChild(this._labels);
         addChild(this._values);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onAddedToStage() : void
      {
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._totalTime = this._frameCount = this._skipCount = 0;
         this.update();
      }
      
      private function onRemovedFromStage() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:EnterFrameEvent) : void
      {
         this._totalTime += param1.passedTime;
         ++this._frameCount;
         if(this._totalTime > UPDATE_INTERVAL)
         {
            this.update();
            this._frameCount = this._skipCount = this._totalTime = 0;
         }
      }
      
      public function update() : void
      {
         this._background.color = this._skipCount > this._frameCount / 2 ? 16128 : 0;
         this._fps = this._totalTime > 0 ? this._frameCount / this._totalTime : 0;
         this._memory = System.totalMemory * B_TO_MB;
         this._totMemory = System.privateMemory * B_TO_MB;
         this._gpuMemory = this.supportsGpuMem ? Starling.context["totalGPUMemory"] * B_TO_MB : -1;
         var _loc1_:String = this._fps.toFixed(this._fps < 100 ? 1 : 0);
         var _loc2_:String = this._memory.toFixed(this._memory < 100 ? 1 : 0);
         var _loc3_:String = this._totMemory.toFixed(this._totMemory < 100 ? 1 : 0);
         var _loc4_:String = this._gpuMemory.toFixed(this._gpuMemory < 100 ? 1 : 0);
         var _loc5_:String = (this._totalTime > 0 ? this._drawCount - 2 : this._drawCount).toString();
         this._values.text = _loc1_ + "\n" + _loc2_ + "\n" + _loc3_ + "\n" + (this._gpuMemory >= 0 ? _loc4_ + "\n" : "") + _loc5_;
      }
      
      public function markFrameAsSkipped() : void
      {
         this._skipCount += 1;
      }
      
      override public function render(param1:Painter) : void
      {
         param1.excludeFromCache(this);
         param1.finishMeshBatch();
         super.render(param1);
      }
      
      private function get supportsGpuMem() : Boolean
      {
         return "totalGPUMemory" in Starling.context;
      }
      
      public function get drawCount() : int
      {
         return this._drawCount;
      }
      
      public function set drawCount(param1:int) : void
      {
         this._drawCount = param1;
      }
      
      public function get fps() : Number
      {
         return this._fps;
      }
      
      public function set fps(param1:Number) : void
      {
         this._fps = param1;
      }
      
      public function get memory() : Number
      {
         return this._memory;
      }
      
      public function set memory(param1:Number) : void
      {
         this._memory = param1;
      }
      
      public function get gpuMemory() : Number
      {
         return this._gpuMemory;
      }
      
      public function set gpuMemory(param1:Number) : void
      {
         this._gpuMemory = param1;
      }
   }
}

