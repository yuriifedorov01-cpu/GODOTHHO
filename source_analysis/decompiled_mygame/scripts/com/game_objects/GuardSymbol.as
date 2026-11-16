package com.game_objects
{
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.utilities.*;
   import starling.display.*;
   import starling.utils.*;
   
   public class GuardSymbol extends Sprite
   {
      
      private var piece1_image:Image;
      
      private var piece2_image:Image;
      
      private var piece3_image:Image;
      
      public function GuardSymbol()
      {
         super();
         this.piece1_image = new Image(Assets.items_textureAtlas.getTexture("guard symbol"));
         this.piece1_image.x = -26;
         this.piece1_image.y = -18;
         this.piece1_image.rotation = deg2rad(11);
         addChild(this.piece1_image);
         this.piece2_image = new Image(this.piece1_image.texture);
         this.piece2_image.x = 31;
         this.piece2_image.y = -12;
         this.piece2_image.rotation = deg2rad(134);
         addChild(this.piece2_image);
         this.piece3_image = new Image(this.piece1_image.texture);
         this.piece3_image.x = -1;
         this.piece3_image.y = 32;
         this.piece3_image.rotation = deg2rad(-108);
         addChild(this.piece3_image);
         this.piece1_image.pivotX = this.piece2_image.pivotX = this.piece3_image.pivotX = Assets.items_object["guard symbol"].pivotX;
         this.piece1_image.pivotY = this.piece2_image.pivotY = this.piece3_image.pivotY = Assets.items_object["guard symbol"].pivotY;
         this.piece1_image.touchable = this.piece2_image.touchable = this.piece3_image.touchable = false;
      }
      
      public static function createGuard(param1:int, param2:int, param3:DisplayObjectContainer) : GuardSymbol
      {
         var _loc4_:GuardSymbol = new GuardSymbol();
         _loc4_.x = param1;
         _loc4_.y = param2;
         param3.addChild(_loc4_);
         TweenLite.from(_loc4_.piece1_image,0.4,{
            "x":_loc4_.piece1_image.x - 25,
            "y":_loc4_.piece1_image.y - 25,
            "alpha":0,
            "ease":Back.easeOut
         });
         TweenLite.from(_loc4_.piece2_image,0.4,{
            "x":_loc4_.piece2_image.x + 25,
            "y":_loc4_.piece2_image.y - 25,
            "alpha":0,
            "ease":Back.easeOut
         });
         TweenLite.from(_loc4_.piece3_image,0.4,{
            "x":_loc4_.piece3_image.x - 7,
            "y":_loc4_.piece3_image.y + 35,
            "alpha":0,
            "ease":Back.easeOut
         });
         return _loc4_;
      }
      
      public function tweenOut() : void
      {
         TweenLite.to(this.piece1_image,0.4,{
            "x":this.piece1_image.x - 25,
            "y":this.piece1_image.y - 25,
            "alpha":0,
            "ease":Back.easeOut
         });
         TweenLite.to(this.piece2_image,0.4,{
            "x":this.piece2_image.x + 25,
            "y":this.piece2_image.y - 25,
            "alpha":0,
            "ease":Back.easeOut
         });
         TweenLite.to(this.piece3_image,0.4,{
            "x":this.piece3_image.x - 7,
            "y":this.piece3_image.y + 35,
            "alpha":0,
            "ease":Back.easeOut,
            "onComplete":removeFromParent,
            "onCompleteParams":[true]
         });
      }
   }
}

