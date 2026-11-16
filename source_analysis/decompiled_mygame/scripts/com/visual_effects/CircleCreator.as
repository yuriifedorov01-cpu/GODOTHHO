package com.visual_effects
{
   import com.utilities.*;
   import starling.display.*;
   import starling.extensions.lighting.*;
   import starling.textures.*;
   
   public final class CircleCreator
   {
      
      private static const circle_array:Vector.<Image> = new Vector.<Image>();
      
      public function CircleCreator()
      {
         super();
      }
      
      public static function createCircle(param1:int, param2:int, param3:int = 1) : void
      {
         var _loc4_:Image = null;
         _loc4_ = null;
         var _loc5_:LightStyle = null;
         var _loc6_:int = 0;
         while(_loc6_ < param3)
         {
            _loc4_ = new Image(Assets.treesFish_textureAtlas.getTexture("white circle"));
            _loc4_.x = param1;
            _loc4_.y = param2;
            _loc4_.pivotX = _loc4_.pivotX = 16;
            _loc4_.scale = 0.2;
            _loc4_.alpha = 0.7;
            _loc4_.touchable = false;
            _loc4_.textureSmoothing = TextureSmoothing.NONE;
            SortDepths.addAt(_loc4_,SortDepths.REGION_2);
            circle_array.push(_loc4_);
            if(GameMain.lighting)
            {
               _loc5_ = new LightStyle(Assets.treeFishLighMap_textureAtlas.getTexture("white circle"));
               _loc5_.ambientRatio = 0.2;
               _loc5_.diffuseRatio = 0.8;
               _loc5_.specularRatio = 0.1;
               _loc5_.shininess = 1;
               _loc5_.textureSmoothing = TextureSmoothing.NONE;
               _loc4_.style = _loc5_;
            }
            _loc6_++;
         }
      }
      
      public static function onEnter() : void
      {
         var _loc1_:int = int(circle_array.length);
         var _loc2_:* = int(_loc1_ - 1);
         while(_loc2_ >= 0)
         {
            circle_array[_loc2_].alpha -= 0.04;
            if(circle_array[_loc2_].alpha <= 0)
            {
               circle_array[_loc2_].removeFromParent(true);
               circle_array.removeAt(_loc2_);
            }
            _loc2_--;
         }
      }
   }
}

