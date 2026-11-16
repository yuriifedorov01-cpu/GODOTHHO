package com.helpers
{
   import flash.utils.*;
   
   public class AntiAutoClicker
   {
      
      private var clickTimes:Vector.<uint> = new Vector.<uint>();
      
      private var buttonPresses:Vector.<uint> = new Vector.<uint>();
      
      public function AntiAutoClicker()
      {
         super();
      }
      
      public function clickDown(param1:GameMain) : void
      {
         this.clickTimes.push(getTimer());
         if(this.numPressesWithinTime(1000,this.clickTimes) >= 20)
         {
            if(GameMain.isMobile == false)
            {
               param1.player.personHackCheck.banKillPlayer(true,"Autobanned for autoclicker");
            }
         }
      }
      
      public function buttonPress(param1:GameMain) : void
      {
         this.buttonPresses.push(getTimer());
         if(this.numPressesWithinTime(1000,this.buttonPresses) >= 120)
         {
            if(GameMain.isMobile == false)
            {
               param1.player.personHackCheck.banKillPlayer(true,"Autobanned for autopresser");
            }
         }
      }
      
      private function numPressesWithinTime(param1:uint, param2:Vector.<uint>) : uint
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:int = int(getTimer());
         for each(_loc3_ in param2)
         {
            if(_loc3_ > _loc5_ - param1)
            {
               _loc4_++;
            }
         }
         return _loc4_;
      }
   }
}

