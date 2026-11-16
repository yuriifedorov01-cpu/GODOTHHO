package com.menus.add_ons
{
   import com.game_objects.*;
   import com.game_objects.enemies.*;
   import com.utilities.*;
   import flash.display.*;
   import flash.ui.*;
   
   public class Cursor
   {
      
      private static var cursorDataArray:Vector.<BitmapData> = new Vector.<BitmapData>();
      
      private static var cursorData:MouseCursorData = new MouseCursorData();
      
      public function Cursor()
      {
         super();
      }
      
      public static function init() : void
      {
         cursorDataArray.push(Assets.rightClick1_data,Assets.rightClick2_data);
         cursorData.data = cursorDataArray;
         cursorData.frameRate = 2;
         Mouse.registerCursor("right click",cursorData);
      }
      
      public static function onMoveCalled(param1:Object) : void
      {
         if(param1 is IClickable)
         {
            if(param1 is Person && Person(param1).isPlayer == false && Person(param1).npc == false)
            {
               Mouse.cursor = "right click";
            }
            else if(param1 is Enemy)
            {
               Mouse.cursor = "right click";
            }
         }
         else
         {
            Mouse.cursor = MouseCursor.AUTO;
         }
      }
      
      public static function onRightClickCalled(param1:Object) : void
      {
         if(param1 is IClickable)
         {
            IClickable(param1).rightClick();
         }
      }
   }
}

