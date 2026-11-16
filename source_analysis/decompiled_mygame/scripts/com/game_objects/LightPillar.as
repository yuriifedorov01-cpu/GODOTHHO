package com.game_objects
{
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.utilities.*;
   import flash.display.*;
   import flash.geom.*;
   
   public class LightPillar extends Shape
   {
      
      public function LightPillar()
      {
         super();
         var _loc1_:Matrix = new Matrix();
         _loc1_.createGradientBox(100,150,-(Math.PI / 2),0,0);
         graphics.beginGradientFill(GradientType.LINEAR,[16777215,16777215],[1,0],[0,255],_loc1_,SpreadMethod.PAD);
         graphics.drawRect(0,0,50,150);
      }
      
      public static function createLightPiller(param1:int, param2:int, param3:DisplayObjectContainer) : void
      {
         var _loc4_:LightPillar = new LightPillar();
         _loc4_.x = param1 - _loc4_.width / 2;
         _loc4_.y = param2 - _loc4_.height + 10;
         param3.addChildAt(_loc4_,param3.getChildIndex(param3.getChildByName("indexMarker_mc")));
         TweenLite.from(_loc4_,0.1,{
            "scaleY":0.1,
            "y":_loc4_.y + 140,
            "ease":Linear.easeNone
         });
         TweenLite.to(_loc4_,0.4,{
            "alpha":0,
            "delay":0.2,
            "ease":Linear.easeNone,
            "onComplete":CommonCalls.removeObject,
            "onCompleteParams":[_loc4_]
         });
      }
   }
}

