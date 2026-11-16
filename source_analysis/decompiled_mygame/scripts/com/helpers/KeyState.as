package com.helpers
{
   public class KeyState
   {
      
      private var __keyCode:uint;
      
      internal var __isDown:Boolean = false;
      
      internal var __downCounter:uint = 0;
      
      public function KeyState(param1:uint)
      {
         super();
         this.__keyCode = param1;
      }
      
      public function get keyCode() : uint
      {
         return this.__keyCode;
      }
      
      public function get isDown() : Boolean
      {
         return this.__isDown;
      }
      
      public function get downCounter() : uint
      {
         return this.__downCounter;
      }
   }
}

