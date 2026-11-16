package com.visual_effects
{
   import flash.display.*;
   import flash.display3D.*;
   import starling.display.DisplayObject;
   import starling.filters.*;
   import starling.textures.*;
   
   public class Shockwave
   {
      
      private static const DMap:Class = Shockwave_DMap;
      
      public static const shockwave_array:Vector.<Shockwave> = new Vector.<Shockwave>();
      
      private static const displaceTexture_array:Vector.<Texture> = new Vector.<Texture>();
      
      private static var i:int = 0;
      
      displaceTexture_array[0] = Texture.fromEmbeddedAsset(DMap,false,false,1,Context3DTextureFormat.BGRA_PACKED);
      i = 1;
      while(i <= 15)
      {
         displaceTexture_array.push(Texture.fromTexture(displaceTexture_array[0],null,null,false,1 - i / 15));
         ++i;
      }
      
      private var dMap:DisplacementMapFilter;
      
      private var counter:int = 0;
      
      private var originalX:int = 0;
      
      private var originalY:int = 0;
      
      private var effectedObject:starling.display.DisplayObject;
      
      public function Shockwave(param1:int, param2:int, param3:starling.display.DisplayObject, param4:int)
      {
         var _loc5_:FilterChain = null;
         super();
         this.originalX = param1;
         this.originalY = param2;
         this.effectedObject = param3;
         this.dMap = new DisplacementMapFilter(displaceTexture_array[0],BitmapDataChannel.RED,BitmapDataChannel.RED,param4,param4);
         this.dMap.mapX = param1 - 100 / 2;
         this.dMap.mapY = param2 - 100 / 2;
         if(param3.filter == null)
         {
            _loc5_ = new FilterChain(this.dMap);
            param3.filter = _loc5_;
         }
         else if(param3.filter is FilterChain)
         {
            FilterChain(param3.filter).addFilter(this.dMap);
         }
         shockwave_array.push(this);
      }
      
      public function onEnter(param1:int) : void
      {
         ++this.counter;
         if(this.counter < displaceTexture_array.length)
         {
            this.dMap.mapTexture = displaceTexture_array[this.counter];
            this.dMap.mapX = this.originalX - this.dMap.mapTexture.width / 2;
            this.dMap.mapY = this.originalY - this.dMap.mapTexture.height / 2;
         }
         else
         {
            if(this.effectedObject.filter is FilterChain)
            {
               FilterChain(this.effectedObject.filter).removeFilter(this.dMap);
               if(FilterChain(this.effectedObject.filter).numFilters == 0)
               {
                  this.effectedObject.filter = null;
               }
            }
            this.dMap.dispose();
            shockwave_array.removeAt(param1);
         }
      }
   }
}

