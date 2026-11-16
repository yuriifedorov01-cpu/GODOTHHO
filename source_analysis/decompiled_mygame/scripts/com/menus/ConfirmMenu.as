package com.menus
{
   import com.game_objects.PetVendor;
   import com.ui.*;
   import starling.display.*;
   import starling.text.*;
   import starling.textures.*;
   
   public class ConfirmMenu extends Sprite
   {
      
      public var areaToTeleport:int = 1;
      
      public var petVendor:PetVendor;
      
      private var __shortReason:String;
      
      public function ConfirmMenu(param1:String, param2:String)
      {
         var _loc3_:Button = null;
         var _loc4_:Button = null;
         var _loc5_:TextField = null;
         var _loc6_:Image = null;
         _loc3_ = null;
         _loc4_ = null;
         _loc5_ = null;
         super();
         this.__shortReason = param2;
         _loc6_ = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("confirm backdrop"));
         _loc6_.x = -214;
         _loc6_.y = -82;
         _loc6_.textureSmoothing = TextureSmoothing.NONE;
         _loc6_.touchable = false;
         addChild(_loc6_);
         _loc3_ = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("no"));
         _loc3_.x = -82;
         _loc3_.y = 30;
         _loc3_.pivotX = 47;
         _loc3_.pivotY = 23;
         _loc3_.name = "no_btn";
         _loc3_.textureSmoothing = TextureSmoothing.NONE;
         addChild(_loc3_);
         _loc4_ = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("yes"));
         _loc4_.x = 87;
         _loc4_.y = 30;
         _loc4_.pivotX = 47;
         _loc4_.pivotY = 23;
         _loc4_.name = "yes_btn";
         _loc4_.textureSmoothing = TextureSmoothing.NONE;
         addChild(_loc4_);
         _loc5_ = new TextField(428,51,param1 + "?",AllTextFormats.confirm_textFormat);
         _loc5_.x = -215;
         _loc5_.y = -64;
         _loc5_.touchable = false;
         addChild(_loc5_);
      }
      
      public function get shortReason() : String
      {
         return this.__shortReason;
      }
   }
}

