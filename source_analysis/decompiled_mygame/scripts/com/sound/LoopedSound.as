package com.sound
{
   import com.math.*;
   import flash.geom.*;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import starling.display.DisplayObjectContainer;
   
   internal class LoopedSound
   {
      
      private var sound:Sound;
      
      private var soundChannel:SoundChannel;
      
      private var soundTransform:SoundTransform;
      
      internal var location_point:Point;
      
      private var globalize:Boolean;
      
      private var parent:DisplayObjectContainer;
      
      private var global_point:Point = new Point();
      
      private var __name:String = "";
      
      public function LoopedSound(param1:String, param2:Sound, param3:SoundChannel, param4:SoundTransform, param5:Point, param6:Boolean, param7:DisplayObjectContainer = null)
      {
         super();
         this.sound = param2;
         this.soundChannel = param3;
         this.soundTransform = param4;
         this.location_point = param5;
         this.globalize = param6;
         this.parent = param7;
         this.__name = param1;
      }
      
      internal function adjustVolume() : void
      {
         if(this.parent != null)
         {
            this.global_point = this.parent.localToGlobal(this.location_point);
         }
         else
         {
            this.global_point.x = this.location_point.x;
            this.global_point.y = this.location_point.y;
         }
         this.soundTransform.volume = -(CalcDist.getDistNumbers(this.global_point.x,this.global_point.y,475,350) / 700) + 1;
         this.soundTransform.pan = (this.global_point.x - 475) / 950 * 2;
         this.soundTransform.volume = this.soundTransform.volume < 0 ? 0 : Number(this.soundTransform.volume);
         this.soundChannel.soundTransform = this.soundTransform;
      }
      
      internal function stop() : void
      {
         this.soundChannel.stop();
      }
      
      internal function resume() : void
      {
         this.soundChannel = this.sound.play();
      }
      
      public function get name() : String
      {
         return this.__name;
      }
   }
}

