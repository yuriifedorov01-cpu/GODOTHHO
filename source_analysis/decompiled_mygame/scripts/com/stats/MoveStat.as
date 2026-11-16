package com.stats
{
   import com.game_objects.Person;
   
   public class MoveStat
   {
      
      private static var attackingFrames_array:Vector.<String> = new Vector.<String>();
      
      private var __name:String;
      
      private var __earliestCombo:uint;
      
      private var __endFrame:uint;
      
      private var __startDmgFrame:uint;
      
      private var __endDmgFrame:uint;
      
      private var __resetFrameString:String;
      
      private var __chargeFrame:uint;
      
      private var __key1:uint;
      
      internal var __hitRot:int = 90;
      
      internal var __knockback:int = 2;
      
      public function MoveStat(param1:String, param2:uint, param3:uint, param4:uint, param5:uint, param6:String = "standing", param7:uint = 0, param8:uint = 0)
      {
         super();
         this.__name = param1;
         this.__earliestCombo = param2;
         this.__endFrame = param3;
         this.__startDmgFrame = param4;
         this.__endDmgFrame = param5;
         this.__resetFrameString = param6;
         this.__chargeFrame = param7;
         this.__key1 = param8;
         MoveStat.attackingFrames_array.push(param1);
      }
      
      public static function isAttackingFrame(param1:Person) : Boolean
      {
         var _loc2_:String = null;
         for each(_loc2_ in attackingFrames_array)
         {
            if(param1.bodyAnimator.currentLabel == _loc2_)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get name() : String
      {
         return this.__name;
      }
      
      public function get earliestCombo() : uint
      {
         return this.__earliestCombo;
      }
      
      public function get endFrame() : uint
      {
         return this.__endFrame;
      }
      
      public function get startDmgFrame() : uint
      {
         return this.__startDmgFrame;
      }
      
      public function get endDmgFrame() : uint
      {
         return this.__endDmgFrame;
      }
      
      public function get resetFrameString() : String
      {
         return this.__resetFrameString;
      }
      
      public function get chargeFrame() : uint
      {
         return this.__chargeFrame;
      }
      
      public function get key1() : uint
      {
         return this.__key1;
      }
      
      public function get hitRot() : int
      {
         return this.__hitRot;
      }
      
      public function get knockback() : int
      {
         return this.__knockback;
      }
   }
}

