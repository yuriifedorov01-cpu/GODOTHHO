package com.ui
{
   import com.utilities.*;
   import flash.geom.Rectangle;
   import starling.display.*;
   import starling.extensions.lighting.*;
   import starling.textures.*;
   
   public class GiveHealthBar
   {
      
      public static var healthBG_array:Vector.<Image> = new Vector.<Image>();
      
      public static var healthBar_array:Vector.<Image> = new Vector.<Image>();
      
      public static var linkedObjects_array:Vector.<DisplayObject> = new Vector.<DisplayObject>();
      
      private static var distToTop_array:Vector.<int> = new Vector.<int>();
      
      private static var distToCenter_array:Vector.<int> = new Vector.<int>();
      
      public function GiveHealthBar()
      {
         super();
      }
      
      public static function setPositions() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = 0;
         var _loc2_:Rectangle = null;
         var _loc3_:int = int(linkedObjects_array.length);
         _loc1_ = int(_loc3_ - 1);
         while(_loc1_ >= 0)
         {
            if(linkedObjects_array[_loc1_].parent == null || healthBar_array[_loc1_].parent == null || healthBG_array[_loc1_].parent == null)
            {
               healthBG_array[_loc1_].removeFromParent(true);
               healthBar_array[_loc1_].removeFromParent(true);
               healthBG_array.removeAt(_loc1_);
               healthBar_array.removeAt(_loc1_);
               distToTop_array.removeAt(_loc1_);
               distToCenter_array.removeAt(_loc1_);
               linkedObjects_array.removeAt(_loc1_);
            }
            else
            {
               _loc2_ = linkedObjects_array[_loc1_].getBounds(linkedObjects_array[_loc1_].parent);
               healthBG_array[_loc1_].x = linkedObjects_array[_loc1_].x + distToCenter_array[_loc1_] - 17.5;
               healthBG_array[_loc1_].y = linkedObjects_array[_loc1_].y + distToTop_array[_loc1_] - 9;
               healthBar_array[_loc1_].x = healthBG_array[_loc1_].x + 1;
               healthBar_array[_loc1_].y = healthBG_array[_loc1_].y + 1;
            }
            _loc1_--;
         }
      }
      
      public static function to(param1:DisplayObject) : Image
      {
         var _loc2_:Image = null;
         var _loc4_:LightStyle = null;
         var _loc5_:Image = null;
         _loc2_ = null;
         var _loc3_:LightStyle = null;
         _loc4_ = null;
         _loc2_ = new Image(Assets.items_textureAtlas.getTexture("small health bar BG"));
         _loc2_.x = param1.getBounds(param1.parent).x + param1.width / 2 - 17.5;
         _loc2_.y = param1.getBounds(param1.parent).y - 6 - param1.height / 20 - 3;
         _loc2_.touchable = false;
         healthBG_array.push(_loc2_);
         _loc5_ = new Image(Assets.items_textureAtlas.getTexture("small health bar"));
         _loc5_.x = _loc2_.x + 1;
         _loc5_.y = _loc2_.y + 1;
         _loc5_.touchable = false;
         healthBar_array.push(_loc5_);
         SortDepths.addAt(_loc5_,SortDepths.REGION_4);
         _loc5_.parent.addChildAt(_loc2_,_loc5_.parent.getChildIndex(_loc5_));
         linkedObjects_array.push(param1);
         distToTop_array.push(param1.getBounds(param1.parent).y - param1.y);
         distToCenter_array.push(param1.getBounds(param1.parent).x + param1.width / 2 - param1.x);
         if(GameMain.lighting)
         {
            _loc3_ = new LightStyle(Assets.treeFishLighMap_textureAtlas.getTexture("small health bar BG"));
            _loc3_.ambientRatio = 0.3;
            _loc3_.diffuseRatio = 0.7;
            _loc3_.specularRatio = 0.1;
            _loc3_.shininess = 1;
            _loc3_.textureSmoothing = TextureSmoothing.NONE;
            _loc4_ = new LightStyle(Assets.treeFishLighMap_textureAtlas.getTexture("small health bar"));
            _loc4_.ambientRatio = 0.3;
            _loc4_.diffuseRatio = 0.7;
            _loc4_.specularRatio = 0.1;
            _loc4_.shininess = 1;
            _loc4_.textureSmoothing = TextureSmoothing.NONE;
            _loc2_.style = _loc3_;
            _loc5_.style = _loc4_;
         }
         return _loc5_;
      }
      
      public static function getBarLinkedTo(param1:DisplayObject) : Image
      {
         var _loc2_:int = int(linkedObjects_array.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(linkedObjects_array[_loc3_] == param1)
            {
               return healthBar_array[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public static function getBarBGLinkedTo(param1:DisplayObject) : Image
      {
         var _loc2_:int = int(linkedObjects_array.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(linkedObjects_array[_loc3_] == param1)
            {
               return healthBG_array[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
   }
}

