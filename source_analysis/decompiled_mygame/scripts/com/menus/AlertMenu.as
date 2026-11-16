package com.menus
{
   import com.game_objects.*;
   import com.ui.*;
   import starling.display.*;
   import starling.events.*;
   import starling.text.*;
   
   public class AlertMenu extends Sprite
   {
      
      private var petClone:Pet;
      
      private var __petName:String;
      
      public function AlertMenu(param1:String, param2:String, param3:Pet, param4:GameMain, param5:Boolean)
      {
         var _loc6_:Button = null;
         var _loc7_:Button = null;
         var _loc9_:Image = null;
         var _loc10_:TextField = null;
         _loc6_ = null;
         _loc7_ = null;
         var _loc8_:TextField = null;
         super();
         _loc9_ = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("alert panel"));
         _loc9_.x = -99;
         _loc9_.y = -16;
         addChild(_loc9_);
         _loc6_ = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("yes"));
         _loc6_.x = -33;
         _loc6_.y = 90;
         _loc6_.name = "alertMenuYes_btn";
         addChild(_loc6_);
         _loc7_ = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("no"));
         _loc7_.x = 42;
         _loc7_.y = 90;
         _loc7_.pivotX = _loc6_.pivotX = 47;
         _loc7_.pivotY = _loc6_.pivotY = 23;
         _loc7_.scaleX = _loc7_.scaleY = _loc6_.scaleX = _loc6_.scaleY = 0.6;
         _loc7_.scaleWhenOver = _loc6_.scaleWhenOver = 0.95;
         _loc7_.name = "alertMenuNo_btn";
         addChild(_loc7_);
         _loc6_.visible = _loc7_.visible = param5;
         if(param3 != null)
         {
            this.petClone = new Pet(param4,"",param3.type);
            this.petClone.x = 58;
            this.petClone.y = 44;
            this.petClone.scaleX = -0.8;
            this.petClone.scaleY = 0.8;
            this.petClone.fitPreview(200,100);
            this.petClone.helmet_string = param3.helmet_string;
            this.petClone.shoes_string = param3.shoes_string;
            this.petClone.touchable = false;
            addChild(this.petClone);
            addEventListener(Event.ENTER_FRAME,this.onEnter);
            this.__petName = param3.name;
         }
         _loc10_ = new TextField(191,19,param1,AllTextFormats.headline_textFormat);
         _loc10_.x = -97;
         _loc10_.y = -8;
         addChild(_loc10_);
         _loc8_ = new TextField(142,61,param2,AllTextFormats.desc_textFormat);
         _loc8_.x = -93;
         _loc8_.y = 16;
         _loc8_.touchable = _loc10_.touchable = false;
         _loc8_.batchable = _loc10_.batchable = true;
         addChild(_loc8_);
      }
      
      private function onEnter(param1:Event) : void
      {
         this.petClone.nextFrame();
         if(this.petClone.currentLabel != "standing")
         {
            this.petClone.gotoAndPlayStanding();
         }
      }
      
      public function get petName() : String
      {
         return this.__petName;
      }
   }
}

