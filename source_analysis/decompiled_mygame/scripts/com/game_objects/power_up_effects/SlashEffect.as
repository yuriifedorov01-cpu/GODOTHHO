package com.game_objects.power_up_effects
{
   import com.game_objects.Person;
   import com.game_objects.enemies.Enemy;
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.sound.*;
   import com.stats.*;
   import com.utilities.*;
   import flash.display.*;
   import flash.geom.*;
   import starling.core.*;
   import starling.display.*;
   import starling.textures.*;
   import starling.utils.*;
   
   public final class SlashEffect
   {
      
      public function SlashEffect()
      {
         super();
      }
      
      public static function create(param1:Person, param2:Enemy) : void
      {
         var _loc3_:Image = null;
         var _loc5_:int = 0;
         _loc3_ = null;
         var _loc4_:String = "slash 1";
         _loc5_ = 0;
         switch(param1.bodyAnimator.currentLabel)
         {
            case Moves.BASIC_ONE_WARRIOR1:
               _loc4_ = "slash 2";
               _loc5_ = 136;
               break;
            case Moves.BASIC_ONE_WARRIOR2:
               _loc5_ = 90;
               break;
            case Moves.BASIC_ONE_WARRIOR3:
               _loc4_ = "slash 2";
               _loc5_ = -135;
               break;
            case Moves.BASIC_SHIELD_WARRIOR1:
               _loc4_ = "slash 2";
               _loc5_ = 125;
               break;
            case Moves.BASIC_SHIELD_WARRIOR2:
               _loc5_ = 90;
               break;
            case Moves.BASIC_SHIELD_WARRIOR3:
               _loc4_ = "slash 2";
               _loc5_ = -135;
               break;
            case Moves.BASIC_TWO_WARRIOR1:
               _loc4_ = "slash 2";
               _loc5_ = 136;
               break;
            case Moves.BASIC_TWO_WARRIOR2:
               _loc5_ = 90;
               break;
            case Moves.BASIC_TWO_WARRIOR3:
               _loc4_ = "slash 3";
               break;
            case Moves.SPIN_ATTACK:
               _loc4_ = "slash 3";
               break;
            case Moves.DASH_ATTACK:
               _loc5_ = 90;
               break;
            case Moves.LUNGE_ATTACK:
               _loc4_ = "slash 2";
               _loc5_ = -135;
               break;
            case Moves.GROUND_STAB:
               return;
            default:
               _loc4_ = "slash 3";
         }
         if(param1.scaleX == -1)
         {
            _loc5_ *= -1;
         }
         _loc3_ = new Image(Assets.powerUp_textureAtlas.getTexture(_loc4_));
         _loc3_.x = param2.x;
         _loc3_.y = param2.y;
         _loc3_.pivotX = _loc3_.width / 2;
         _loc3_.pivotY = _loc3_.height / 2;
         _loc3_.scaleX = param1.scaleX * (0.5 + param1.energyController.fullTotalScale / 2);
         _loc3_.rotation = deg2rad(_loc5_);
         _loc3_.touchable = false;
         _loc3_.textureSmoothing = TextureSmoothing.NONE;
         SortDepths.addAt(_loc3_,SortDepths.REGION_1);
         TweenMax.to(_loc3_,0.5,{
            "alpha":0,
            "delay":0.2,
            "ease":Linear.easeNone,
            "onComplete":_loc3_.removeFromParent,
            "onCompleteParams":[true]
         });
         SoundManager.playSound(SoundLibrary.epicHit1_sound,_loc3_.x,_loc3_.y,true,_loc3_.parent);
      }
      
      public static function createBlack(param1:Person, param2:Number = 0.2) : Image
      {
         var _loc3_:Point = new Point(0,0);
         param1.parent.globalToLocal(_loc3_,_loc3_);
         var _loc4_:Image = new Image(Texture.fromBitmapData(new BitmapData(1,1,false,0)));
         _loc4_.x = _loc3_.x - 200;
         _loc4_.y = _loc3_.y - 200;
         _loc4_.width = Starling.current.viewPort.width + 400;
         _loc4_.height = Starling.current.viewPort.height + 400;
         _loc4_.alpha = 0.6;
         _loc4_.touchable = false;
         _loc4_.textureSmoothing = TextureSmoothing.NONE;
         param1.parent.addChildAt(_loc4_,param1.parent.getChildIndex(param1));
         TweenMax.to(_loc4_,param2,{
            "alpha":0,
            "delay":param2,
            "ease":Linear.easeNone,
            "onComplete":CommonCalls.removeAndFullyDispose,
            "onCompleteParams":[_loc4_]
         });
         return _loc4_;
      }
   }
}

