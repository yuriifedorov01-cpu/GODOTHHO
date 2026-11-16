package com.game_objects.power_up_effects
{
   import com.math.*;
   import com.utilities.*;
   import starling.*;
   import starling.display.*;
   import starling.textures.*;
   import starling.utils.*;
   
   public final class Electrify
   {
      
      private static const electric_array:Vector.<Sprite> = new Vector.<Sprite>();
      
      private static const followers_array:Vector.<DisplayObject> = new Vector.<DisplayObject>();
      
      public function Electrify()
      {
         super();
      }
      
      public static function to(param1:DisplayObject, param2:Number) : void
      {
         var _loc3_:Sprite = null;
         var _loc5_:MovieClip = null;
         _loc3_ = null;
         var _loc4_:String = null;
         _loc5_ = null;
         param2 = param2 <= 1 ? param2 : 1;
         _loc3_ = new Sprite();
         _loc3_.x = param1.x;
         _loc3_.y = param1.y;
         _loc3_.touchable = false;
         _loc3_.touchGroup = true;
         SortDepths.addAt(_loc3_,SortDepths.REGION_1);
         var _loc6_:int = Math.sqrt(100 * 100 / 250);
         _loc6_ *= param2;
         var _loc7_:int = 0;
         while(_loc7_ < param2 * 10)
         {
            _loc4_ = "electric " + (Math.random() * 3 < param2 ? "bolt" : "shard");
            _loc5_ = new MovieClip(Assets.powerUp_textureAtlas.getTextures(_loc4_));
            _loc5_.x = Math.random() * (param1.width / 2) * RanOne.ranOne();
            _loc5_.y = -(Math.random() * (param1.height / 2)) + 50;
            _loc5_.pivotX = _loc5_.width / 2;
            _loc5_.pivotY = _loc5_.height / 2;
            _loc5_.rotation = deg2rad(Math.random() * 360);
            _loc5_.textureSmoothing = TextureSmoothing.NONE;
            _loc5_.touchable = false;
            _loc5_.play();
            _loc5_.loop = false;
            MainStarlingStage(param1.root).gameMain.main_juggler.add(_loc5_);
            _loc3_.addChild(_loc5_);
            electric_array.push(_loc3_);
            followers_array.push(param1);
            _loc7_++;
         }
      }
      
      public static function onEnterAll() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = int(electric_array.length);
         var _loc3_:int = 0;
         var _loc4_:* = int(_loc2_ - 1);
         while(_loc4_ >= 0)
         {
            if(followers_array[_loc4_].parent == null)
            {
               electric_array[_loc4_].removeFromParent(true);
               electric_array.removeAt(_loc4_);
               followers_array.removeAt(_loc4_);
            }
            else
            {
               electric_array[_loc4_].x = followers_array[_loc4_].x;
               electric_array[_loc4_].y = followers_array[_loc4_].y;
               _loc3_ = int(electric_array[_loc4_].numChildren);
               _loc1_ = int(_loc3_ - 1);
               while(_loc1_ >= 0)
               {
                  if(MovieClip(electric_array[_loc4_].getChildAt(_loc1_)).isComplete)
                  {
                     MainStarlingStage(electric_array[_loc4_].root).gameMain.main_juggler.remove(MovieClip(electric_array[_loc4_].getChildAt(_loc1_)));
                     electric_array[_loc4_].getChildAt(_loc1_).removeFromParent(true);
                  }
                  _loc1_--;
               }
               if(electric_array[_loc4_].numChildren == 0)
               {
                  electric_array[_loc4_].removeFromParent(true);
                  electric_array.removeAt(_loc4_);
                  followers_array.removeAt(_loc4_);
               }
            }
            _loc4_--;
         }
      }
   }
}

