package com.visual_effects
{
   import com.greensock.*;
   import com.greensock.easing.*;
   import flash.geom.Rectangle;
   import starling.display.*;
   import starling.textures.*;
   
   public final class AfterImage
   {
      
      public function AfterImage()
      {
         super();
      }
      
      public static function create(param1:DisplayObject, param2:Number = 0.1) : void
      {
         var _loc3_:Image = null;
         var _loc6_:Number = NaN;
         _loc3_ = null;
         var _loc4_:Rectangle = param1.getBounds(param1);
         var _loc5_:Number = param1.x;
         _loc6_ = param1.y;
         param1.x = _loc4_.x * -1;
         param1.y = _loc4_.y * -1;
         var _loc7_:RenderTexture = new RenderTexture(param1.width,param1.height,false,1);
         _loc7_.draw(param1);
         _loc3_ = new Image(_loc7_);
         _loc3_.x = _loc5_ + _loc4_.x;
         _loc3_.y = _loc6_ + _loc4_.y;
         _loc3_.alpha = 0.6;
         _loc3_.touchable = false;
         _loc3_.textureSmoothing = TextureSmoothing.NONE;
         param1.parent.addChildAt(_loc3_,param1.parent.getChildIndex(param1) - 1);
         param1.x = _loc5_;
         param1.y = _loc6_;
         TweenMax.to(_loc3_,0.45,{
            "alpha":0,
            "delay":param2,
            "ease":Linear.easeNone,
            "onComplete":_loc3_.removeFromParent,
            "onCompleteParams":[true]
         });
      }
   }
}

