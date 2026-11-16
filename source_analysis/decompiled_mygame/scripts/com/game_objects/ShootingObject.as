package com.game_objects
{
   import flash.display.MovieClip;
   
   public class ShootingObject extends MovieClip
   {
      
      public var counter:int;
      
      public var ran_int:int;
      
      private var __shootDir:int;
      
      public var blinkCounter:int;
      
      public function ShootingObject()
      {
         super();
         this.counter = 0;
         this.blinkCounter = 0;
         this.ran_int = Math.random() * 90;
         this.__shootDir = rotation == 180 ? 1 : -1;
      }
      
      public function get shootDir() : int
      {
         return this.__shootDir;
      }
   }
}

