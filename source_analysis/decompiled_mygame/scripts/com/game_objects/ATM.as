package com.game_objects
{
   import com.utilities.*;
   import starling.display.*;
   import starling.extensions.lighting.*;
   import starling.textures.*;
   
   public class ATM extends Sprite
   {
      
      public function ATM()
      {
         var _loc1_:Image = null;
         var _loc4_:Image = null;
         _loc1_ = null;
         var _loc2_:LightStyle = null;
         var _loc3_:LightStyle = null;
         super();
         _loc4_ = new Image(Assets.treesFish_textureAtlas.getTexture("atm"));
         _loc4_.x = -47;
         _loc4_.y = -78;
         _loc4_.touchable = false;
         _loc4_.textureSmoothing = TextureSmoothing.NONE;
         addChild(_loc4_);
         _loc1_ = new Image(Assets.treesFish_textureAtlas.getTexture("click to interact"));
         _loc1_.x = -4;
         _loc1_.y = -92;
         _loc1_.pivotX = _loc1_.width / 2;
         _loc1_.pivotY = _loc1_.height / 2;
         _loc1_.textureSmoothing = TextureSmoothing.NONE;
         _loc1_.name = "atmClick_image";
         addChild(_loc1_);
         if(GameMain.lighting)
         {
            _loc2_ = new LightStyle(Assets.itemsPetsLightMap_textureAtlas.getTexture("atm"));
            _loc2_.ambientRatio = 0.3;
            _loc2_.diffuseRatio = 0.7;
            _loc2_.specularRatio = 0.4;
            _loc2_.shininess = 12;
            _loc2_.textureSmoothing = TextureSmoothing.NONE;
            _loc4_.style = _loc2_;
            _loc3_ = new LightStyle(Assets.itemsPetsLightMap_textureAtlas.getTexture("click to interact"));
            _loc3_.ambientRatio = 0.3;
            _loc3_.diffuseRatio = 0.7;
            _loc3_.specularRatio = 0.4;
            _loc3_.shininess = 12;
            _loc3_.textureSmoothing = TextureSmoothing.NONE;
            _loc1_.style = _loc3_;
         }
      }
   }
}

