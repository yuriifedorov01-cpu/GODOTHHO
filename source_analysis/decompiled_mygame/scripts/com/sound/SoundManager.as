package com.sound
{
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.math.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import starling.core.*;
   import starling.display.DisplayObjectContainer;
   
   public class SoundManager
   {
      
      private static var s_channel:SoundChannel;
      
      public static var current_music:Sound;
      
      private static var loopedSounds_array:Vector.<LoopedSound> = new Vector.<LoopedSound>();
      
      private static var pan:Number = 0;
      
      private static var s_transform:SoundTransform = new SoundTransform(0.55);
      
      private static var vol:Number = 0;
      
      public static var music_channel:SoundChannel = new SoundChannel();
      
      public static var sounds:int = 0;
      
      private static var __soundOn:Boolean = true;
      
      private static var __musicOn:Boolean = true;
      
      public static var sound_point:Point = new Point();
      
      public function SoundManager()
      {
         super();
      }
      
      public static function playSound(param1:Sound, param2:Number = 475, param3:Number = 350, param4:Boolean = false, param5:DisplayObjectContainer = null, param6:Boolean = false, param7:String = "") : void
      {
         var _loc8_:LoopedSound = null;
         if(param4 && param5 == null)
         {
            param4 = false;
         }
         if(param6 && param7 == "")
         {
            throw new Error("Loop is set to true but sound name is not provided.");
         }
         if(param2 == 475 && param3 == 350)
         {
            param2 = Starling.current.viewPort.width / 2;
            param3 = Starling.current.viewPort.height / 2;
         }
         if(param1 != null)
         {
            if(param4)
            {
               sound_point.x = param2;
               sound_point.y = param3;
               sound_point = param5.localToGlobal(sound_point);
            }
            else
            {
               sound_point.x = param2;
               sound_point.y = param3;
            }
            if(sounds < 16 && Boolean(__soundOn) && param1.length > 0)
            {
               if(sound_point.x > -100 && sound_point.x < Starling.current.viewPort.width || param6 == true)
               {
                  vol = -CalcDist.getDistNumbers(sound_point.x,sound_point.y,Starling.current.viewPort.width / Starling.contentScaleFactor / 2,Starling.current.viewPort.height / Starling.contentScaleFactor / 2);
                  vol = vol / 700 + 1;
                  vol += Starling.current.viewPort.width / 950 / 7 - 0.143;
                  pan = (sound_point.x - Starling.current.viewPort.width / 2) / Starling.current.viewPort.width * 2;
                  if(vol > 0 || param6)
                  {
                     if(param6 && vol < 0)
                     {
                        vol = 0;
                     }
                     s_transform = new SoundTransform(vol,pan);
                     s_channel = new SoundChannel();
                     s_channel = param1.play(0,param6 == false ? 0 : int.MAX_VALUE);
                     if(s_channel != null)
                     {
                        s_channel.soundTransform = s_transform;
                        ++sounds;
                        if(param6 == false)
                        {
                           s_channel.addEventListener(Event.SOUND_COMPLETE,onSoundComplete);
                        }
                        else
                        {
                           _loc8_ = new LoopedSound(param7,param1,s_channel,s_transform,new Point(param2,param3),param4,param5);
                           loopedSounds_array.push(_loc8_);
                        }
                     }
                  }
               }
            }
         }
      }
      
      public static function onSoundComplete(param1:Event) : void
      {
         --sounds;
      }
      
      public static function changeMusic(param1:Sound, param2:Boolean = false) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(current_music == null || current_music.length != param1.length || param2)
         {
            TweenMax.to(music_channel,1.3,{
               "volume":0,
               "ease":Linear.easeNone,
               "onComplete":musicChange,
               "onCompleteParams":[param1]
            });
            current_music = param1;
         }
      }
      
      public static function fadeOutMusic() : void
      {
         TweenMax.to(music_channel,1,{
            "volume":0,
            "ease":Linear.easeNone
         });
      }
      
      private static function musicChange(param1:Sound) : void
      {
         if(Boolean(__musicOn) && param1.length > 0)
         {
            music_channel = param1.play(0,int.MAX_VALUE);
            current_music = param1;
            s_transform = new SoundTransform(0.55);
            music_channel.soundTransform = s_transform;
         }
      }
      
      public static function toggleMusic() : void
      {
         if(__musicOn)
         {
            TweenMax.to(music_channel,1,{
               "volume":0,
               "ease":Linear.easeNone
            });
         }
         else
         {
            TweenMax.to(music_channel,1,{
               "volume":0.55,
               "ease":Linear.easeNone
            });
         }
         __musicOn = __musicOn ? false : true;
      }
      
      public static function toggleSound() : void
      {
         if(__soundOn)
         {
            stopAllLoops(false);
            __soundOn = false;
         }
         else
         {
            resumeAllLoops();
            __soundOn = true;
         }
      }
      
      public static function handleLoopedSounds() : void
      {
         var _loc1_:LoopedSound = null;
         for each(_loc1_ in loopedSounds_array)
         {
            _loc1_.adjustVolume();
         }
      }
      
      public static function stopAllLoops(param1:Boolean) : void
      {
         var _loc2_:* = int(loopedSounds_array.length - 1);
         while(_loc2_ >= 0)
         {
            loopedSounds_array[_loc2_].stop();
            if(param1)
            {
               loopedSounds_array.removeAt(_loc2_);
               --sounds;
            }
            _loc2_--;
         }
      }
      
      public static function stopLoopedSound(param1:String, param2:Boolean) : void
      {
         var _loc3_:* = int(loopedSounds_array.length - 1);
         while(_loc3_ >= 0)
         {
            if(loopedSounds_array[_loc3_].name == param1)
            {
               loopedSounds_array[_loc3_].stop();
               if(param2)
               {
                  loopedSounds_array.removeAt(_loc3_);
                  --sounds;
               }
               break;
            }
            _loc3_--;
         }
      }
      
      public static function resumeAllLoops() : void
      {
         var _loc1_:LoopedSound = null;
         for each(_loc1_ in loopedSounds_array)
         {
            _loc1_.resume();
         }
      }
      
      public static function resumeLoopedSound(param1:String) : void
      {
         var _loc2_:LoopedSound = null;
         for each(_loc2_ in loopedSounds_array)
         {
            if(_loc2_.name == param1)
            {
               _loc2_.resume();
               break;
            }
         }
      }
      
      public static function changeLoopedSoundPosition(param1:String, param2:Number, param3:Number) : void
      {
         var _loc4_:LoopedSound = null;
         for each(_loc4_ in loopedSounds_array)
         {
            if(_loc4_.name == param1)
            {
               _loc4_.location_point.x = param2;
               _loc4_.location_point.y = param3;
               break;
            }
         }
      }
      
      public static function get soundOn() : Boolean
      {
         return __soundOn;
      }
      
      public static function get musicOn() : Boolean
      {
         return __musicOn;
      }
   }
}

