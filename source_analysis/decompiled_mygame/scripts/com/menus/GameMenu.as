package com.menus
{
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.utilities.*;
   import fl.motion.*;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import starling.core.*;
   
   public dynamic class GameMenu extends MovieClip
   {
      
      public static var menu_array:Vector.<GameMenu> = new Vector.<GameMenu>();
      
      private static var dark_color:Color = new Color();
      
      private static var blank_color:Color = new Color();
      
      dark_color.brightness = -0.3;
      
      public var canTint:Boolean;
      
      public var isFocusMenu:Boolean;
      
      private var currentParent:DisplayObjectContainer;
      
      public function GameMenu()
      {
         super();
         this.canTint = true;
         this.isFocusMenu = false;
         x = Starling.current.viewPort.width / 2 - 50;
         y = Starling.current.viewPort.height / 2 - 50;
         scaleX = scaleY = Starling.contentScaleFactor;
         menu_array.push(this);
         TweenMax.from(this,0.4,{
            "alpha":0,
            "scaleX":0.2,
            "scaleY":0.2,
            "ease":Back.easeOut
         });
         focusMenu(this);
      }
      
      public static function unfocusMenus() : void
      {
         var _loc1_:GameMenu = null;
         _loc1_ = null;
         for each(_loc1_ in GameMenu.menu_array)
         {
            _loc1_.mouseChildren = false;
            _loc1_.isFocusMenu = false;
            _loc1_.transform.colorTransform = dark_color;
         }
      }
      
      public static function focusMenu(param1:GameMenu, param2:Boolean = false) : void
      {
         unfocusMenus();
         param1.mouseChildren = true;
         param1.isFocusMenu = true;
         if(param1.parent != null)
         {
            param1.parent.setChildIndex(param1,param1.parent.numChildren - 1);
         }
         param1.transform.colorTransform = blank_color;
         if(param2)
         {
            param1.scaleX = param1.scaleY = 1;
            TweenMax.from(param1,0.4,{
               "scaleX":1.2,
               "scaleY":1.2,
               "ease":Back.easeOut
            });
         }
      }
      
      public static function removeFocusMenu() : void
      {
         var _loc1_:uint = menu_array.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            if(menu_array[_loc2_].isFocusMenu)
            {
               TweenMax.to(menu_array[_loc2_],0.4,{
                  "alpha":0,
                  "scaleX":0.2,
                  "scaleY":0.2,
                  "ease":Back.easeIn,
                  "onComplete":CommonCalls.removeObject,
                  "onCompleteParams":[menu_array[_loc2_]]
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
      
      public static function getFocusMenu() : GameMenu
      {
         var _loc1_:uint = menu_array.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            if(menu_array[_loc2_].isFocusMenu)
            {
               return menu_array[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
   }
}

