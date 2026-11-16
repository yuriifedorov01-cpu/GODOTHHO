package com.visual_effects
{
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.utilities.*;
   import starling.display.*;
   import starling.utils.*;
   
   public class ShineEffect
   {
      
      public function ShineEffect()
      {
         super();
      }
      
      public static function shineObjectNoParent(param1:DisplayObject, param2:uint) : void
      {
         var _loc3_:Image = null;
         _loc3_ = null;
         var _loc4_:int = 0;
         while(_loc4_ < param2)
         {
            _loc3_ = new Image(Assets.items_textureAtlas.getTexture("shine"));
            _loc3_.x = param1.getBounds(param1.parent).x + Math.random() * param1.width;
            _loc3_.y = param1.getBounds(param1.parent).y + Math.random() * param1.height;
            _loc3_.pivotX = _loc3_.width / 2;
            _loc3_.pivotY = _loc3_.height / 2;
            _loc3_.scaleX = _loc3_.scaleY = 0.3 + Math.random();
            _loc3_.rotation = deg2rad(Math.random() * 360);
            param1.parent.addChild(_loc3_);
            TweenMax.to(_loc3_,0.3,{
               "alpha":0,
               "rotation":deg2rad(Math.random() * 540),
               "delay":0.4,
               "ease":Linear.easeNone,
               "onComplete":_loc3_.removeFromParent,
               "onCompleteParams":[true]
            });
            _loc4_++;
         }
      }
   }
}

