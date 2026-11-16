package com.game_objects
{
   import com.utilities.*;
   import starling.display.DisplayObject;
   import starling.display.MovieClip;
   
   public class Fire extends MovieClip
   {
      
      public static var fire_array:Vector.<Fire> = new Vector.<Fire>();
      
      private var linkedObject:DisplayObject;
      
      public var offPlaceX:int = 0;
      
      public var offPlaceY:int = 0;
      
      public function Fire(param1:DisplayObject)
      {
         this.linkedObject = param1;
         super(Assets.items_textureAtlas.getTextures("fire_"),30);
         pivotX = 27;
         pivotY = 23;
         touchable = false;
         Fire.fire_array.push(this);
      }
      
      public static function setAllPositions() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = int(fire_array.length);
         _loc1_ = int(_loc2_ - 1);
         while(_loc1_ >= 0)
         {
            if(fire_array[_loc1_].linkedObject.parent == null || fire_array[_loc1_].parent == null)
            {
               fire_array[_loc1_].removeFromParent(true);
               fire_array.removeAt(_loc1_);
            }
            else
            {
               fire_array[_loc1_].x = fire_array[_loc1_].linkedObject.x + fire_array[_loc1_].offPlaceX * fire_array[_loc1_].linkedObject.scaleX;
               fire_array[_loc1_].y = fire_array[_loc1_].linkedObject.y + fire_array[_loc1_].offPlaceY;
            }
            _loc1_--;
         }
      }
   }
}

