package com.helpers
{
   import com.game_objects.extensions.*;
   import flash.ui.*;
   import flash.utils.*;
   
   public class KeyStates
   {
      
      private var keyStates:Vector.<KeyState> = new Vector.<KeyState>();
      
      private var keyState:KeyState;
      
      private var counter:int = 0;
      
      public var keyPress_array:Vector.<uint> = new Vector.<uint>();
      
      public var keyTime_array:Vector.<uint> = new Vector.<uint>();
      
      public var keyFrame_array:Vector.<uint> = new Vector.<uint>();
      
      public function KeyStates()
      {
         super();
         this.keyState = new KeyState(Keyboard.SPACE);
         this.keyStates.push(this.keyState);
         this.keyState = new KeyState(Keyboard.RIGHT);
         this.keyStates.push(this.keyState);
         this.keyState = new KeyState(Keyboard.LEFT);
         this.keyStates.push(this.keyState);
         this.keyState = new KeyState(Keyboard.DOWN);
         this.keyStates.push(this.keyState);
         this.keyState = new KeyState(Keyboard.UP);
         this.keyStates.push(this.keyState);
         this.keyState = new KeyState(Keyboard.V);
         this.keyStates.push(this.keyState);
         this.keyState = new KeyState(Keyboard.C);
         this.keyStates.push(this.keyState);
         this.keyState = new KeyState(Keyboard.O);
         this.keyStates.push(this.keyState);
      }
      
      public function onEnter() : void
      {
         var _loc1_:KeyState = null;
         ++this.counter;
         for each(_loc1_ in this.keyStates)
         {
            if(_loc1_.__isDown)
            {
               ++_loc1_.__downCounter;
            }
         }
      }
      
      public function getKeyState(param1:uint) : KeyState
      {
         var _loc2_:KeyState = null;
         for each(_loc2_ in this.keyStates)
         {
            if(_loc2_.keyCode == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function pressKey(param1:uint) : void
      {
         var _loc2_:KeyState = null;
         for each(_loc2_ in this.keyStates)
         {
            if(_loc2_.keyCode == param1)
            {
               _loc2_.__isDown = true;
               break;
            }
         }
         this.keyPress_array.push(param1);
         this.keyTime_array.push(getTimer());
         this.keyFrame_array.push(this.counter);
      }
      
      public function releaseKey(param1:uint) : void
      {
         var _loc2_:KeyState = null;
         for each(_loc2_ in this.keyStates)
         {
            if(_loc2_.keyCode == param1)
            {
               _loc2_.__isDown = false;
               _loc2_.__downCounter = 0;
               break;
            }
         }
      }
      
      public function releaseAll() : void
      {
         var _loc1_:KeyState = null;
         for each(_loc1_ in this.keyStates)
         {
            _loc1_.__isDown = false;
         }
      }
      
      public function timeSinceKeyPress(param1:int) : uint
      {
         return getTimer() - this.keyTime_array[param1];
      }
      
      public function framesSinceKeyPress(param1:int) : uint
      {
         return this.counter - this.keyFrame_array[param1];
      }
      
      public function simuKeyPress(param1:uint, param2:uint) : Boolean
      {
         var _loc3_:uint = this.keyPress_array.length;
         if(_loc3_ >= 2 && this.counter - this.keyFrame_array[_loc3_ - 1] <= PersonKeyHandler.KEY_TIMING_INT)
         {
            if(this.keyPress_array[_loc3_ - 1] == param1 && this.keyPress_array[_loc3_ - 2] == param2 || this.keyPress_array[_loc3_ - 1] == param2 && this.keyPress_array[_loc3_ - 2] == param1)
            {
               return this.keyFrame_array[_loc3_ - 1] - this.keyFrame_array[_loc3_ - 2] <= PersonKeyHandler.KEY_TIMING_INT;
            }
            return false;
         }
         return false;
      }
   }
}

