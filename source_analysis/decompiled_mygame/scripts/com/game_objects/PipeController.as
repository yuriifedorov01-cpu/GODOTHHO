package com.game_objects
{
   import com.greensock.*;
   import com.math.*;
   import com.sound.*;
   import com.utilities.*;
   import flash.geom.*;
   import starling.display.*;
   
   public class PipeController
   {
      
      public static const SECTION_TOP:String = "top";
      
      public static const SECTION_MID:String = "mid";
      
      public static const SECTION_BOTTOM:String = "bottom";
      
      private static const ix_array:Vector.<int> = new Vector.<int>();
      
      private static const iy_array:Vector.<int> = new Vector.<int>();
      
      private static const section_array:Vector.<String> = new Vector.<String>();
      
      private static const visualTile_array:Vector.<Image> = new Vector.<Image>();
      
      private static const sucking_array:Vector.<Person> = new Vector.<Person>();
      
      private static const suckDir_array:Vector.<int> = new Vector.<int>();
      
      public function PipeController()
      {
         super();
      }
      
      public static function startCreatePipe(param1:int, param2:int, param3:String, param4:Image) : void
      {
         if(param3 != SECTION_TOP && param3 != SECTION_MID && param3 != SECTION_BOTTOM)
         {
            throw new Error("Invalid pipe section");
         }
         ix_array.push(param1);
         iy_array.push(param2);
         section_array.push(param3);
         visualTile_array.push(param4);
      }
      
      public static function onEnterAll(param1:Vector.<Person>) : void
      {
         var _loc3_:Person = null;
         var _loc2_:* = 0;
         _loc3_ = null;
         var _loc4_:Rectangle = new Rectangle();
         var _loc5_:int = int(section_array.length);
         _loc2_ = 0;
         while(_loc2_ < _loc5_)
         {
            _loc4_.setTo(ix_array[_loc2_] * 165 + 40,iy_array[_loc2_] * 165 + 70,88,25);
            for each(_loc3_ in param1)
            {
               if(section_array[_loc2_] == SECTION_TOP && _loc3_.gravityObject.onGround && _loc4_.contains(_loc3_.x,_loc3_.y + 50))
               {
                  if(sucking_array.indexOf(_loc3_) == -1)
                  {
                     _loc3_.x = ix_array[_loc2_] * 165 + 78;
                     _loc3_.y = iy_array[_loc2_] * 165 + 76;
                     _loc3_.gravityObject.doApplyGravity = false;
                     _loc3_.visible = false;
                     sucking_array.push(_loc3_);
                     suckDir_array.push(1);
                     tweenEntirePipe(_loc3_.x,_loc3_.y);
                     SoundManager.playSound(Assets.main_assetManager.getSound("suction sound"),_loc3_.x,_loc3_.y,true,_loc3_.parent);
                  }
               }
               else if(section_array[_loc2_] == SECTION_BOTTOM && _loc3_.gravityObject.velY < 0 && _loc4_.contains(_loc3_.x,_loc3_.y - 50))
               {
                  if(sucking_array.indexOf(_loc3_) == -1)
                  {
                     _loc3_.x = ix_array[_loc2_] * 165 + 78;
                     _loc3_.y = iy_array[_loc2_] * 165 + 76;
                     _loc3_.gravityObject.doApplyGravity = false;
                     _loc3_.visible = false;
                     sucking_array.push(_loc3_);
                     suckDir_array.push(-1);
                     tweenEntirePipe(_loc3_.x,_loc3_.y);
                     SoundManager.playSound(Assets.main_assetManager.getSound("suction sound"),_loc3_.x,_loc3_.y,true,_loc3_.parent);
                  }
               }
            }
            _loc2_++;
         }
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:int = int(section_array.length);
         _loc5_ = int(suckDir_array.length);
         _loc2_ = int(_loc5_ - 1);
         while(_loc2_ >= 0)
         {
            _loc6_ = false;
            sucking_array[_loc2_].y += suckDir_array[_loc2_] * 20;
            sucking_array[_loc2_].gravityObject.hit_rect.y += suckDir_array[_loc2_] * 20;
            _loc7_ = 0;
            while(_loc7_ < _loc8_)
            {
               _loc4_.setTo(ix_array[_loc7_] * 165,iy_array[_loc7_] * 165,165,165);
               if(_loc4_.contains(sucking_array[_loc2_].x,sucking_array[_loc2_].y))
               {
                  _loc6_ = true;
               }
               _loc7_++;
            }
            if(_loc6_ == false || _loc3_.parent == null)
            {
               tweenEntirePipe(sucking_array[_loc2_].x,sucking_array[_loc2_].y);
               sucking_array[_loc2_].y += suckDir_array[_loc2_] * 10;
               sucking_array[_loc2_].gravityObject.hit_rect.y += suckDir_array[_loc2_] * 10;
               sucking_array[_loc2_].gravityObject.velY = suckDir_array[_loc2_] * 10;
               sucking_array[_loc2_].gravityObject.velX = 0;
               if(suckDir_array[_loc2_] < 0)
               {
                  sucking_array[_loc2_].gravityObject.velY = -20;
               }
               sucking_array[_loc2_].visible = true;
               sucking_array[_loc2_].gravityObject.doApplyGravity = true;
               sucking_array.removeAt(_loc2_);
               suckDir_array.removeAt(_loc2_);
               if(_loc3_.parent != null)
               {
                  SoundManager.playSound(Assets.main_assetManager.getSound("blop sound"),_loc3_.x,_loc3_.y,true,_loc3_.parent);
               }
            }
            _loc2_--;
         }
      }
      
      private static function tweenEntirePipe(param1:int, param2:int, param3:Image = null) : void
      {
         var _loc4_:Image = null;
         var _loc5_:int = int(visualTile_array.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            if(TweenMax.isTweening(visualTile_array[_loc6_]) == false && visualTile_array[_loc6_] != param3 && CalcDist.getDistNumbers(param1,param2,ix_array[_loc6_] * 165,iy_array[_loc6_] * 165) <= 200)
            {
               _loc4_ = visualTile_array[_loc6_];
               TweenMax.from(_loc4_,0.4,{
                  "x":_loc4_.x - _loc4_.width / 4,
                  "scaleX":1.5
               });
               tweenEntirePipe(ix_array[_loc6_] * 165,iy_array[_loc6_] * 165,visualTile_array[_loc6_]);
            }
            _loc6_++;
         }
      }
      
      public static function clearAllArrays() : void
      {
         ix_array.length = iy_array.length = section_array.length = sucking_array.length = suckDir_array.length = visualTile_array.length = 0;
      }
   }
}

