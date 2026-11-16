package starling.display
{
   import flash.geom.Matrix;
   import starling.rendering.*;
   import starling.styles.*;
   import starling.utils.*;
   
   public class MeshBatch extends Mesh
   {
      
      public static const MAX_NUM_VERTICES:int = 65535;
      
      private static var sFullMeshSubset:MeshSubset = new MeshSubset();
      
      private var _effect:MeshEffect;
      
      private var _batchable:Boolean;
      
      private var _vertexSyncRequired:Boolean;
      
      private var _indexSyncRequired:Boolean;
      
      public function MeshBatch()
      {
         var _loc1_:VertexData = new VertexData();
         var _loc2_:IndexData = new IndexData();
         super(_loc1_,_loc2_);
      }
      
      override public function dispose() : void
      {
         if(this._effect)
         {
            this._effect.dispose();
         }
         super.dispose();
      }
      
      private function setVertexAndIndexDataChanged() : void
      {
         this._vertexSyncRequired = this._indexSyncRequired = true;
      }
      
      private function syncVertexBuffer() : void
      {
         this._effect.uploadVertexData(_vertexData);
         this._vertexSyncRequired = false;
      }
      
      private function syncIndexBuffer() : void
      {
         this._effect.uploadIndexData(_indexData);
         this._indexSyncRequired = false;
      }
      
      public function clear() : void
      {
         _vertexData.numVertices = 0;
         _indexData.numIndices = 0;
         this._vertexSyncRequired = true;
         this._indexSyncRequired = true;
      }
      
      public function addMesh(param1:Mesh, param2:Matrix = null, param3:Number = 1, param4:MeshSubset = null, param5:Boolean = false) : void
      {
         if(param5)
         {
            param2 = null;
         }
         else if(param2 == null)
         {
            param2 = param1.transformationMatrix;
         }
         if(param4 == null)
         {
            param4 = sFullMeshSubset;
         }
         var _loc6_:int = _vertexData.numVertices;
         var _loc7_:int = _indexData.numIndices;
         var _loc8_:starling.styles.MeshStyle = param1._style;
         if(_loc6_ == 0)
         {
            this.setupFor(param1);
         }
         _loc8_.batchVertexData(_style,_loc6_,param2,param4.vertexID,param4.numVertices);
         _loc8_.batchIndexData(_style,_loc7_,_loc6_ - param4.vertexID,param4.indexID,param4.numIndices);
         if(param3 != 1)
         {
            _vertexData.scaleAlphas("color",param3,_loc6_,param4.numVertices);
         }
         if(this._batchable)
         {
            setRequiresRedraw();
         }
         this._indexSyncRequired = this._vertexSyncRequired = true;
      }
      
      public function addMeshAt(param1:Mesh, param2:int, param3:int) : void
      {
         var _loc4_:int = param1.numIndices;
         var _loc5_:int = param1.numVertices;
         var _loc6_:Matrix = param1.transformationMatrix;
         var _loc7_:starling.styles.MeshStyle = param1._style;
         if(_vertexData.numVertices == 0)
         {
            this.setupFor(param1);
         }
         _loc7_.batchVertexData(_style,param3,_loc6_,0,_loc5_);
         _loc7_.batchIndexData(_style,param2,param3,0,_loc4_);
         if(alpha != 1)
         {
            _vertexData.scaleAlphas("color",alpha,param3,_loc5_);
         }
         if(this._batchable)
         {
            setRequiresRedraw();
         }
         this._indexSyncRequired = this._vertexSyncRequired = true;
      }
      
      private function setupFor(param1:Mesh) : void
      {
         var _loc2_:starling.styles.MeshStyle = param1._style;
         var _loc3_:Class = _loc2_.type;
         if(_style.type != _loc3_)
         {
            this.setStyle(new _loc3_() as MeshStyle,false);
         }
         _style.copyFrom(_loc2_);
      }
      
      public function canAddMesh(param1:Mesh, param2:int = -1) : Boolean
      {
         var _loc3_:int = _vertexData.numVertices;
         if(_loc3_ == 0)
         {
            return true;
         }
         if(param2 < 0)
         {
            param2 = param1.numVertices;
         }
         if(param2 == 0)
         {
            return true;
         }
         if(param2 + _loc3_ > MAX_NUM_VERTICES)
         {
            return false;
         }
         return _style.canBatchWith(param1._style);
      }
      
      override public function render(param1:Painter) : void
      {
         if(_vertexData.numVertices == 0)
         {
            return;
         }
         if(_pixelSnapping)
         {
            MatrixUtil.snapToPixels(param1.state.modelviewMatrix,param1.pixelSize);
         }
         if(this._batchable)
         {
            param1.batchMesh(this);
         }
         else
         {
            param1.finishMeshBatch();
            param1.drawCount += 1;
            param1.prepareToDraw();
            param1.excludeFromCache(this);
            if(this._vertexSyncRequired)
            {
               this.syncVertexBuffer();
            }
            if(this._indexSyncRequired)
            {
               this.syncIndexBuffer();
            }
            _style.updateEffect(this._effect,param1.state);
            this._effect.render(0,_indexData.numTriangles);
         }
      }
      
      override public function setStyle(param1:starling.styles.MeshStyle = null, param2:Boolean = true) : void
      {
         super.setStyle(param1,param2);
         if(this._effect)
         {
            this._effect.dispose();
         }
         this._effect = style.createEffect();
         this._effect.onRestore = this.setVertexAndIndexDataChanged;
      }
      
      public function set numVertices(param1:int) : void
      {
         _vertexData.numVertices = param1;
         this._vertexSyncRequired = true;
      }
      
      public function set numIndices(param1:int) : void
      {
         _indexData.numIndices = param1;
         this._indexSyncRequired = true;
      }
      
      public function get batchable() : Boolean
      {
         return this._batchable;
      }
      
      public function set batchable(param1:Boolean) : void
      {
         this._batchable = param1;
         setRequiresRedraw();
      }
   }
}

