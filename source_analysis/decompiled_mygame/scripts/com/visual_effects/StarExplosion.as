package com.visual_effects
{
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.math.*;
   import com.utilities.*;
   import starling.display.*;
   
   public class StarExplosion
   {
      
      public static const DIR_ALL:String = "all";
      
      public static const DIR_UP:String = "up";
      
      public static const DIR_DOWN:String = "down";
      
      public static const DIR_RIGHT:String = "right";
      
      public static const DIR_LEFT:String = "left";
      
      public function StarExplosion()
      {
         super();
      }
      
      public static function createExplosion(param1:int, param2:int, param3:int, param4:int, param5:int, param6:DisplayObjectContainer, param7:String = "all") : void
      {
         var _loc8_:Image = null;
         _loc8_ = null;
         var _loc9_:Number = (param4 + param5) / 600;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         while(_loc12_ < param3)
         {
            _loc8_ = new Image(Assets.items_textureAtlas.getTexture("star explosion star"));
            _loc8_.x = param1 - _loc8_.width / 2;
            _loc8_.y = param2 - _loc8_.height / 2;
            _loc8_.scaleX = _loc8_.scaleY = 0.1 + Math.random() * 0.2;
            _loc8_.alpha = 0.9;
            param6.addChild(_loc8_);
            SortDepths.addAt(_loc8_,SortDepths.REGION_4);
            switch(param7)
            {
               case DIR_ALL:
                  _loc10_ = _loc8_.x + Math.random() * param4 * RanOne.ranOne();
                  _loc11_ = _loc8_.y + Math.random() * param4 * RanOne.ranOne();
                  break;
               case DIR_UP:
                  _loc10_ = _loc8_.x + Math.random() * param4 * RanOne.ranOne();
                  _loc11_ = _loc8_.y - Math.random() * param4;
                  break;
               case DIR_DOWN:
                  _loc10_ = _loc8_.x + Math.random() * param4 * RanOne.ranOne();
                  _loc11_ = _loc8_.y + Math.random() * param4;
                  break;
               case DIR_RIGHT:
                  _loc10_ = _loc8_.x + Math.random() * param4;
                  _loc11_ = _loc8_.y + Math.random() * param4 * RanOne.ranOne();
                  break;
               case DIR_LEFT:
                  _loc10_ = _loc8_.x - Math.random() * param4;
                  _loc11_ = _loc8_.y + Math.random() * param4 * RanOne.ranOne();
            }
            TweenLite.to(_loc8_,_loc9_ + Math.random() * (_loc9_ * 2),{
               "scaleX":0.5 + Math.random() * 0.2,
               "scaleY":0.5 + Math.random() * 0.2,
               "x":_loc10_,
               "y":_loc11_,
               "ease":Linear.easeNone,
               "onComplete":_loc8_.removeFromParent,
               "onCompleteParams":[true]
            });
            TweenLite.to(_loc8_,_loc9_ + Math.random() * (_loc9_ * 2),{
               "alpha":0,
               "delay":0.12,
               "ease":Linear.easeNone
            });
            _loc12_++;
         }
      }
   }
}

