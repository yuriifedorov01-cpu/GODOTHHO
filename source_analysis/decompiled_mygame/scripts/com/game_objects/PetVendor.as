package com.game_objects
{
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.menus.*;
   import com.utilities.*;
   import playerio.DatabaseObject;
   import starling.*;
   import starling.display.*;
   import starling.events.*;
   
   public class PetVendor extends Sprite
   {
      
      private var __sellerName:String;
      
      private var __petName:String;
      
      public var cage_image:Image;
      
      public var petClone:Pet;
      
      public var coins:uint = 0;
      
      public var tickets:uint = 0;
      
      public var petDBObject:DatabaseObject;
      
      public var click_btn:Button;
      
      private var buy_btn:Button;
      
      public function PetVendor(param1:String, param2:String, param3:String = "")
      {
         super();
         this.__sellerName = param1;
         this.__petName = param3;
         name = param2;
         this.cage_image = new Image(Assets.items_textureAtlas.getTexture("pet cage wide"));
         this.cage_image.x = -57;
         this.cage_image.y = -43;
         this.cage_image.touchable = false;
         addChild(this.cage_image);
      }
      
      public function showPet(param1:String, param2:uint, param3:uint) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:* = 0;
         var _loc7_:int = 0;
         if(this.petClone == null)
         {
            this.petClone = new Pet(MainStarlingStage(root).gameMain,"",param1);
            this.petClone.x = -200;
            this.petClone.y = 150;
            this.petClone.scaleX = -1;
            this.petClone.fitPreview(110,86);
            this.petClone.helmet_uint = param2;
            this.petClone.shoes_uint = param3;
            this.petClone.touchable = false;
            addChildAt(this.petClone,0);
            addEventListener(Event.ENTER_FRAME,this.onEnter);
            _loc4_ = this.petClone.getBounds(this).x;
            _loc5_ = this.cage_image.getBounds(this).x + 20;
            while(_loc4_ < _loc5_)
            {
               ++this.petClone.x;
               _loc4_++;
            }
            _loc6_ = int(this.petClone.getBounds(this).y + this.petClone.height);
            _loc7_ = this.cage_image.getBounds(this).y + this.cage_image.height;
            while(_loc6_ > _loc7_ - 10)
            {
               --this.petClone.y;
               _loc6_--;
            }
         }
      }
      
      private function onEnter(param1:Event) : void
      {
         if(this.petClone != null && this.petClone.parent != null)
         {
            this.petClone.nextFrame();
            if(this.petClone.currentLabel != "standing")
            {
               this.petClone.gotoAndPlayStanding();
            }
         }
      }
      
      public function showClickToInteract() : void
      {
         this.click_btn = new Button(Assets.items_textureAtlas.getTexture("click to interact"));
         this.click_btn.x = 1;
         this.click_btn.y = -85;
         this.click_btn.pivotX = Assets.items_object["click to interact"].pivotX;
         this.click_btn.pivotY = Assets.items_object["click to interact"].pivotY;
         this.click_btn.name = "vendPetInfo_btn";
         this.click_btn.useHandCursor = false;
         addChild(this.click_btn);
      }
      
      public function showBuyButton() : void
      {
         if(this.buy_btn == null || this.buy_btn.parent == null)
         {
            this.buy_btn = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("buy_btn"));
            this.buy_btn.x = -3;
            this.buy_btn.y = -110;
            this.buy_btn.pivotX = 33;
            this.buy_btn.pivotY = 15;
            this.buy_btn.scaleX = this.buy_btn.scaleY = 0.75;
            this.buy_btn.scale = 0.95;
            this.buy_btn.name = "petAdopt_btn";
            addChild(this.buy_btn);
            TweenLite.to(this.buy_btn,2,{
               "alpha":0,
               "delay":15,
               "ease":Linear.easeNone,
               "onComplete":this.buy_btn.removeFromParent,
               "onCompleteParams":[true]
            });
         }
      }
      
      public function get sellerName() : String
      {
         return this.__sellerName;
      }
      
      public function get petName() : String
      {
         return this.__petName;
      }
   }
}

