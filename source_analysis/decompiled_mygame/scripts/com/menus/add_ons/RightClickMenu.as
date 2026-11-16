package com.menus.add_ons
{
   import flash.display.Sprite;
   
   public class RightClickMenu extends Sprite
   {
      
      private var rcButton:RightClickButton;
      
      public var params:Object;
      
      public function RightClickMenu(param1:Vector.<String>, param2:Object)
      {
         super();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            this.rcButton = new RightClickButton(param1[_loc3_]);
            this.rcButton.y = _loc3_ * this.rcButton.height + 15;
            this.params = param2;
            addChild(this.rcButton);
            _loc3_++;
         }
      }
   }
}

