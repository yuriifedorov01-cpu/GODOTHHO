package com.utilities
{
   import flash.net.*;
   import flash.system.*;
   import flash.utils.ByteArray;
   import starling.textures.TextureOptions;
   import starling.utils.AssetManager;
   
   public final class AssetManagerExtended extends AssetManager
   {
      
      private var airExtender:AssetManagerFileChecker;
      
      private var isAIR:Boolean = Capabilities.playerType == "Desktop";
      
      public var requiresRecache:Boolean = false;
      
      public function AssetManagerExtended(param1:Number = 1, param2:Boolean = false)
      {
         super(param1,param2);
         if(this.isAIR)
         {
            this.airExtender = new AssetManagerFileChecker();
         }
      }
      
      override public function enqueue(... rest) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         if(this.isAIR)
         {
            _loc3_ = int(rest.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               if(rest[_loc4_] is String || rest[_loc4_] is URLRequest)
               {
                  _loc5_ = rest[_loc4_] is String ? rest[_loc4_] : URLRequest(rest[_loc4_]).url;
                  _loc6_ = getBasenameFromUrl(_loc5_) + "." + getExtensionFromUrl(_loc5_);
                  if(this.airExtender.fileExists(_loc6_) == true && this.requiresRecache == false)
                  {
                     rest[_loc4_] = this.airExtender.getFile(_loc6_);
                  }
               }
               _loc4_++;
            }
         }
         for each(_loc2_ in rest)
         {
            super.enqueue(_loc2_);
         }
      }
      
      override public function enqueueWithName(param1:Object, param2:String = null, param3:TextureOptions = null) : String
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         if(Boolean(this.isAIR) && (param1 is String || param1 is URLRequest) && this.requiresRecache == false)
         {
            _loc4_ = param1 is String ? String(param1) : URLRequest(param1).url;
            _loc5_ = getBasenameFromUrl(_loc4_) + "." + getExtensionFromUrl(_loc4_);
            if(this.airExtender.fileExists(_loc5_) == true)
            {
               param1 = this.airExtender.getFile(_loc5_);
            }
         }
         return super.enqueueWithName(param1,param2,param3);
      }
      
      override protected function transformData(param1:ByteArray, param2:String) : ByteArray
      {
         var _loc3_:String = null;
         if(this.isAIR)
         {
            _loc3_ = getBasenameFromUrl(param2) + "." + getExtensionFromUrl(param2);
            if(this.airExtender.fileExists(_loc3_) == false || this.requiresRecache)
            {
               this.airExtender.saveFile(_loc3_,param1);
            }
         }
         return super.transformData(param1,param2);
      }
   }
}

