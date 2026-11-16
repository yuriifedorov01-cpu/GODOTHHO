package com.lighting
{
   import starling.MainStarlingStage;
   import starling.extensions.lighting.*;
   
   public final class Lighting
   {
      
      public static var ambientLight:LightSource;
      
      public static const lightSources_array:Vector.<LightSource> = new Vector.<LightSource>();
      
      public function Lighting()
      {
         super();
      }
      
      public static function initArea(param1:uint, param2:MainStarlingStage) : void
      {
         var _loc5_:LightSource = null;
         var _loc3_:int = int(lightSources_array.length);
         var _loc4_:* = int(_loc3_ - 1);
         while(_loc4_ >= 0)
         {
            lightSources_array[_loc4_].removeFromParent(true);
            lightSources_array.removeAt(_loc4_);
            _loc4_--;
         }
         ambientLight = LightSource.createAmbientLight(16777215,1);
         ambientLight.x = 655;
         ambientLight.y = 1000;
         ambientLight.z = -50;
         ambientLight.showLightBulb = true;
         ambientLight.name = "lightSource" + int(Math.random() * int.MAX_VALUE);
         param2.c_mc.addChild(ambientLight);
         lightSources_array.push(ambientLight);
         _loc5_ = LightSource.createPointLight(16777215,1);
         _loc5_.x = 900;
         _loc5_.y = 1000;
         _loc5_.z = -50;
         _loc5_.showLightBulb = true;
         _loc5_.name = "lightSource" + int(Math.random() * int.MAX_VALUE);
         param2.c_mc.addChild(_loc5_);
         lightSources_array.push(_loc5_);
      }
   }
}

