package starling.textures
{
   import flash.geom.*;
   import flash.utils.*;
   import starling.utils.*;
   
   public class TextureAtlas
   {
      
      private static var sNames:Vector.<String> = new Vector.<String>(0);
      
      private var _atlasTexture:Texture;
      
      private var _subTextures:Dictionary;
      
      private var _subTextureNames:Vector.<String>;
      
      public function TextureAtlas(param1:Texture, param2:XML = null)
      {
         super();
         this._subTextures = new Dictionary();
         this._atlasTexture = param1;
         if(param2)
         {
            this.parseAtlasXml(param2);
         }
      }
      
      private static function parseBool(param1:String) : Boolean
      {
         return param1.toLowerCase() == "true";
      }
      
      public function dispose() : void
      {
         this._atlasTexture.dispose();
      }
      
      protected function parseAtlasXml(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc4_:Number = Number(NaN);
         var _loc5_:Number = Number(NaN);
         var _loc6_:Number = Number(NaN);
         var _loc7_:Number = Number(NaN);
         var _loc8_:Number = Number(NaN);
         var _loc9_:Number = Number(NaN);
         var _loc10_:Number = Number(NaN);
         var _loc11_:Number = Number(NaN);
         var _loc12_:Boolean = false;
         var _loc13_:Number = Number(this._atlasTexture.scale);
         var _loc14_:Rectangle = new Rectangle();
         var _loc15_:Rectangle = new Rectangle();
         for each(_loc2_ in param1.SubTexture)
         {
            _loc3_ = StringUtil.clean(_loc2_.@name);
            _loc4_ = parseFloat(_loc2_.@x) / _loc13_;
            _loc5_ = parseFloat(_loc2_.@y) / _loc13_;
            _loc6_ = parseFloat(_loc2_.@width) / _loc13_;
            _loc7_ = parseFloat(_loc2_.@height) / _loc13_;
            _loc8_ = parseFloat(_loc2_.@frameX) / _loc13_;
            _loc9_ = parseFloat(_loc2_.@frameY) / _loc13_;
            _loc10_ = parseFloat(_loc2_.@frameWidth) / _loc13_;
            _loc11_ = parseFloat(_loc2_.@frameHeight) / _loc13_;
            _loc12_ = Boolean(parseBool(_loc2_.@rotated));
            _loc14_.setTo(_loc4_,_loc5_,_loc6_,_loc7_);
            _loc15_.setTo(_loc8_,_loc9_,_loc10_,_loc11_);
            if(_loc10_ > 0 && _loc11_ > 0)
            {
               this.addRegion(_loc3_,_loc14_,_loc15_,_loc12_);
            }
            else
            {
               this.addRegion(_loc3_,_loc14_,null,_loc12_);
            }
         }
      }
      
      public function getTexture(param1:String) : Texture
      {
         return this._subTextures[param1];
      }
      
      public function getTextures(param1:String = "", param2:Vector.<Texture> = null) : Vector.<Texture>
      {
         var _loc3_:String = null;
         if(param2 == null)
         {
            param2 = new Vector.<Texture>(0);
         }
         for each(_loc3_ in this.getNames(param1,sNames))
         {
            param2[param2.length] = this.getTexture(_loc3_);
         }
         sNames.length = 0;
         return param2;
      }
      
      public function getNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         var _loc3_:String = null;
         if(param2 == null)
         {
            param2 = new Vector.<String>(0);
         }
         if(this._subTextureNames == null)
         {
            this._subTextureNames = new Vector.<String>(0);
            for(_loc3_ in this._subTextures)
            {
               this._subTextureNames[this._subTextureNames.length] = _loc3_;
            }
            this._subTextureNames.sort(Array.CASEINSENSITIVE);
         }
         for each(_loc3_ in this._subTextureNames)
         {
            if(_loc3_.indexOf(param1) == 0)
            {
               param2[param2.length] = _loc3_;
            }
         }
         return param2;
      }
      
      public function getRegion(param1:String) : Rectangle
      {
         var _loc2_:SubTexture = this._subTextures[param1];
         return _loc2_ ? _loc2_.region : null;
      }
      
      public function getFrame(param1:String) : Rectangle
      {
         var _loc2_:SubTexture = this._subTextures[param1];
         return _loc2_ ? _loc2_.frame : null;
      }
      
      public function getRotation(param1:String) : Boolean
      {
         var _loc2_:SubTexture = this._subTextures[param1];
         return _loc2_ ? _loc2_.rotated : false;
      }
      
      public function addRegion(param1:String, param2:Rectangle, param3:Rectangle = null, param4:Boolean = false) : void
      {
         this._subTextures[param1] = new SubTexture(this._atlasTexture,param2,false,param3,param4);
         this._subTextureNames = null;
      }
      
      public function removeRegion(param1:String) : void
      {
         var _loc2_:SubTexture = this._subTextures[param1];
         if(_loc2_)
         {
            _loc2_.dispose();
         }
         delete this._subTextures[param1];
         this._subTextureNames = null;
      }
      
      public function get texture() : Texture
      {
         return this._atlasTexture;
      }
   }
}

