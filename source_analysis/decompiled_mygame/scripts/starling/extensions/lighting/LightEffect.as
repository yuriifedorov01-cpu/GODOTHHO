package starling.extensions.lighting
{
   import flash.display3D.*;
   import flash.geom.*;
   import starling.rendering.*;
   import starling.textures.Texture;
   import starling.utils.*;
   
   public class LightEffect extends MeshEffect
   {
      
      public static const VERTEX_FORMAT:VertexDataFormat = MeshEffect.VERTEX_FORMAT.extend("normalTexCoords:float2, material:bytes4, xAxis:float2, yAxis:float2, zScale:float1");
      
      private static const sVector:Vector.<Number> = new Vector.<Number>(4,true);
      
      private var _lights:Vector.<Light>;
      
      private var _normalTexture:Texture;
      
      private var _cameraPosition:Vector3D;
      
      public function LightEffect()
      {
         super();
         this._lights = new Vector.<Light>(0);
         this._cameraPosition = new Vector3D();
      }
      
      override protected function createProgram() : Program
      {
         var _loc1_:Light = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Array = ["mov vt0, va4","mul vt0.w, vt0.w, vc5.w","m44  op, va0, vc0","mov  v0, va0     ","mov  v1, va1     ","mul  v2, va2, vc4","mov  v3, va3     ","mov  v4, vt0     ","crs vt1.xyz, va5.xyz, va6.xyz","mul vt1.xyz, vt1.xyz, va7.xxx","mov v5.xw, va5.xw","mov v6.xw, va5.yw","mov v7.xw, va5.zw","mov v5.y, va6.x","mov v6.y, va6.y","mov v7.y, va6.z","mov v5.z, vt1.x","mov v6.z, vt1.y","mov v7.z, vt1.z"];
         var _loc6_:Array = [tex("ft0","v1",0,texture),"mul ft0, ft0, v2"];
         if(this._normalTexture)
         {
            _loc6_.push(tex("ft1","v3",1,this.normalTexture,false),"mul ft1.xy, ft1.xy, fc2.xy","sub ft1.xy, ft1.xy, fc1.xy","neg ft1.z, ft1.z","neg ft1.y, ft1.y");
         }
         else
         {
            _loc6_.push("mov ft1.xy, fc0.xy","mov ft1.zw, fc1.zw","neg ft1.z,  ft1.z");
         }
         _loc6_.push("m33 ft1.xyz, ft1.xyz, v5","nrm ft1.xyz, ft1.xyz");
         var _loc7_:int = int(MathUtil.min(this._lights.length,LightStyle.MAX_NUM_LIGHTS));
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc1_ = this._lights[_loc8_];
            _loc2_ = "fc" + (10 + 2 * _loc8_);
            _loc3_ = "fc" + (11 + 2 * _loc8_);
            if(_loc1_.type == LightSource.TYPE_AMBIENT)
            {
               _loc6_.push("mul ft2, ft0, " + _loc3_,"mul ft2, ft2, v4.xxxx");
            }
            else
            {
               _loc4_ = _loc1_.type == LightSource.TYPE_POINT ? "sub ft2, " + _loc2_ + ", v0" : "mov ft2, " + _loc2_;
               _loc6_.push(_loc4_,"nrm ft2.xyz, ft2.xyz","dp3 ft3, ft2, ft1","sat ft3, ft3","mul ft4, ft3, fc2","mul ft4, ft4, ft1","sub ft4, ft4, ft2","sub ft5, fc3, v0","nrm ft5.xyz, ft5.xyz","dp3 ft2, ft4, ft5","sat ft2, ft2","mul ft3, ft3, " + _loc3_,"mul ft3, ft3, v4.yyyy","pow ft4, ft2, v4.wwww","mul ft4, ft4, " + _loc3_,"mul ft4, ft4, v4.zzzz","mul ft4, ft4, ft0.wwww","mul ft2, ft0, ft3","add ft2, ft2, ft4");
            }
            _loc6_.push(_loc8_ == 0 ? "mov ft6, ft2" : "add ft6, ft6, ft2");
            _loc8_++;
         }
         if(_loc7_ == 0)
         {
            _loc6_.push("mov ft6, fc0");
         }
         _loc6_.push("mov ft6.w, ft0.w","mov oc, ft6");
         return Program.fromSource(_loc5_.join("\n"),_loc6_.join("\n"));
      }
      
      override protected function beforeDraw(param1:Context3D) : void
      {
         var _loc2_:Light = null;
         var _loc3_:Boolean = false;
         super.beforeDraw(param1);
         sVector[0] = sVector[1] = sVector[2] = sVector[3] = LightStyle.MAX_SHININESS;
         param1.setProgramConstantsFromVector(Context3DProgramType.VERTEX,5,sVector);
         sVector[0] = sVector[1] = sVector[2] = sVector[3] = 0;
         param1.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,sVector);
         sVector[0] = sVector[1] = sVector[2] = sVector[3] = 1;
         param1.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,1,sVector);
         sVector[0] = sVector[1] = sVector[2] = sVector[3] = 2;
         param1.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,2,sVector);
         sVector[0] = this._cameraPosition.x;
         sVector[1] = this._cameraPosition.y;
         sVector[2] = this._cameraPosition.z;
         sVector[3] = this._cameraPosition.w;
         param1.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,3,sVector);
         var _loc4_:int = 0;
         var _loc5_:int = int(this._lights.length);
         while(_loc4_ < _loc5_)
         {
            _loc2_ = this._lights[_loc4_];
            sVector[0] = _loc2_.x;
            sVector[1] = _loc2_.y;
            sVector[2] = _loc2_.z;
            sVector[3] = 1;
            param1.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,10 + 2 * _loc4_,sVector);
            Color.toVector(_loc2_.color,sVector);
            param1.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,11 + 2 * _loc4_,sVector);
            _loc4_++;
         }
         if(this._normalTexture)
         {
            _loc3_ = textureRepeat && Boolean(this._normalTexture.root.isPotTexture);
            RenderUtil.setSamplerStateAt(1,this._normalTexture.mipMapping,textureSmoothing,_loc3_);
            param1.setTextureAt(1,this._normalTexture.base);
         }
         this.vertexFormat.setVertexBufferAt(3,vertexBuffer,"normalTexCoords");
         this.vertexFormat.setVertexBufferAt(4,vertexBuffer,"material");
         this.vertexFormat.setVertexBufferAt(5,vertexBuffer,"xAxis");
         this.vertexFormat.setVertexBufferAt(6,vertexBuffer,"yAxis");
         this.vertexFormat.setVertexBufferAt(7,vertexBuffer,"zScale");
      }
      
      override protected function afterDraw(param1:Context3D) : void
      {
         param1.setTextureAt(1,null);
         param1.setVertexBufferAt(3,null);
         param1.setVertexBufferAt(4,null);
         param1.setVertexBufferAt(5,null);
         param1.setVertexBufferAt(6,null);
         param1.setVertexBufferAt(7,null);
         super.afterDraw(param1);
      }
      
      override protected function get programVariantName() : uint
      {
         var _loc1_:Light = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = uint(RenderUtil.getTextureVariantBits(this._normalTexture));
         var _loc4_:int = int(this._lights.length);
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc1_ = this._lights[_loc6_];
            switch(_loc1_.type)
            {
               case LightSource.TYPE_AMBIENT:
                  _loc2_ = 3;
                  break;
               case LightSource.TYPE_DIRECTIONAL:
                  _loc2_ = 2;
                  break;
               default:
                  _loc2_ = 1;
            }
            _loc5_ |= _loc2_ << _loc6_ * 2;
            _loc6_++;
         }
         return super.programVariantName | _loc3_ << 8 | _loc5_ << 16;
      }
      
      override public function get vertexFormat() : VertexDataFormat
      {
         return VERTEX_FORMAT;
      }
      
      public function get numLights() : int
      {
         return this._lights.length;
      }
      
      public function set numLights(param1:int) : void
      {
         var _loc2_:int = int(this._lights.length);
         var _loc3_:int = _loc2_;
         while(_loc3_ < param1)
         {
            this._lights[_loc3_] = new Light();
            _loc3_++;
         }
         this._lights.length = param1;
      }
      
      public function setLightAt(param1:int, param2:String, param3:uint, param4:Vector3D) : void
      {
         if(param1 >= this.numLights)
         {
            this.numLights = param1 + 1;
         }
         var _loc5_:Light = this._lights[param1];
         _loc5_.type = param2;
         _loc5_.color = param3;
         _loc5_.x = param4.x;
         _loc5_.y = param4.y;
         _loc5_.z = param4.z;
      }
      
      public function get cameraPosition() : Vector3D
      {
         return this._cameraPosition;
      }
      
      public function set cameraPosition(param1:Vector3D) : void
      {
         this._cameraPosition.copyFrom(param1);
      }
      
      public function get normalTexture() : Texture
      {
         return this._normalTexture;
      }
      
      public function set normalTexture(param1:Texture) : void
      {
         this._normalTexture = param1;
      }
   }
}

class Light
{
   
   public var x:Number;
   
   public var y:Number;
   
   public var z:Number;
   
   public var color:uint;
   
   public var type:String;
   
   public function Light(param1:uint = 16777215, param2:* = "point")
   {
      super();
      this.x = this.y = this.z = 0;
      this.color = param1;
      this.type = param2;
   }
}
