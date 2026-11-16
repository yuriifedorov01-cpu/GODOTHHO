package com.menus
{
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.math.*;
   import starling.*;
   import starling.core.*;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.*;
   
   public class StarlingGameMenu extends Sprite
   {
      
      public static const menu_array:Vector.<StarlingGameMenu> = new Vector.<StarlingGameMenu>();
      
      protected var drag_image:Image;
      
      private var _charac_isFocusMenu:Boolean = false;
      
      private var __isFocusMenu:Boolean;
      
      private var startDistFromMouseX:Number;
      
      private var startDistFromMouseY:Number;
      
      public function StarlingGameMenu()
      {
         super();
         menu_array.push(this);
         if(GameMain.isMobile == false)
         {
            TweenLite.from(this,0.4,{
               "alpha":0,
               "scaleX":0.2,
               "scaleY":0.2,
               "ease":Back.easeOut
            });
         }
         focusMenu(this);
      }
      
      public static function stopDragAll() : void
      {
         var _loc1_:StarlingGameMenu = null;
         for each(_loc1_ in menu_array)
         {
            _loc1_.removeEventListener(Event.ENTER_FRAME,_loc1_.onDragEnter);
         }
      }
      
      public static function focusMenu(param1:StarlingGameMenu, param2:Boolean = false) : void
      {
         unfocusMenus();
         param1.touchGroup = false;
         param1.__isFocusMenu = true;
         if(param1.parent != null)
         {
            param1.parent.setChildIndex(param1,param1.parent.numChildren - 1);
         }
         if(param2)
         {
            param1.scaleX = param1.scaleY = 1;
            TweenLite.from(param1,0.4,{
               "scaleX":1.2,
               "scaleY":1.2,
               "ease":Back.easeOut
            });
         }
      }
      
      public static function unfocusMenus() : void
      {
         var _loc1_:StarlingGameMenu = null;
         for each(_loc1_ in menu_array)
         {
            _loc1_.touchGroup = true;
            _loc1_.__isFocusMenu = false;
         }
      }
      
      public static function removeFocusMenu() : void
      {
         var _loc1_:uint = menu_array.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            if(menu_array[_loc2_].__isFocusMenu)
            {
               TweenLite.to(menu_array[_loc2_],0.4,{
                  "alpha":0,
                  "scaleX":0.2,
                  "scaleY":0.2,
                  "ease":Back.easeIn,
                  "onComplete":menu_array[_loc2_].removeFromParent,
                  "onCompleteParams":[true]
               });
               menu_array.removeAt(_loc2_);
               break;
            }
            _loc2_++;
         }
         if(menu_array.length > 0)
         {
            focusMenu(menu_array[0]);
         }
      }
      
      public static function removeAllMenus(param1:Boolean = false, param2:Vector.<StarlingGameMenu> = null) : void
      {
         var _loc3_:int = int(menu_array.length);
         var _loc4_:* = int(_loc3_ - 1);
         while(_loc4_ >= 0)
         {
            if(!(param2 != null && param2.indexOf(menu_array[_loc4_]) > -1))
            {
               if(param1 == false)
               {
                  menu_array[_loc4_].removeFromParent(true);
               }
               else
               {
                  TweenLite.to(menu_array[_loc4_],0.4,{
                     "alpha":0,
                     "scaleX":0.2,
                     "scaleY":0.2,
                     "ease":Back.easeIn,
                     "onComplete":menu_array[_loc4_].removeFromParent,
                     "onCompleteParams":[true]
                  });
               }
               menu_array.removeAt(_loc4_);
            }
            _loc4_--;
         }
      }
      
      public static function getFocusMenu() : StarlingGameMenu
      {
         var _loc1_:uint = menu_array.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            if(menu_array[_loc2_].__isFocusMenu)
            {
               return menu_array[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function startDrag() : void
      {
         this.startDistFromMouseX = CalcDist.getDistX(x,MainStarlingStage(root).gameMain.mouseX / Starling.contentScaleFactor);
         this.startDistFromMouseY = CalcDist.getDistY(y,MainStarlingStage(root).gameMain.mouseY / Starling.contentScaleFactor);
         addEventListener(Event.ENTER_FRAME,this.onDragEnter);
      }
      
      private function onDragEnter(param1:Event) : void
      {
         x = MainStarlingStage(root).gameMain.mouseX / Starling.contentScaleFactor + this.startDistFromMouseX;
         y = MainStarlingStage(root).gameMain.mouseY / Starling.contentScaleFactor - this.startDistFromMouseY;
      }
      
      override public function dispose() : void
      {
         if(this.drag_image != null && this.drag_image.texture != null)
         {
            this.drag_image.texture.dispose();
         }
         super.dispose();
      }
   }
}

