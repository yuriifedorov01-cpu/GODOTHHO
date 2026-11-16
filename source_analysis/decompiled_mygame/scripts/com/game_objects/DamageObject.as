package com.game_objects
{
   import com.game_objects.enemies.*;
   import com.sound.*;
   import com.stats.*;
   import com.utilities.*;
   import com.visual_effects.*;
   import flash.display.MovieClip;
   import flash.events.*;
   
   public dynamic class DamageObject extends MovieClip
   {
      
      public static var damageObject_array:Vector.<DamageObject> = new Vector.<DamageObject>();
      
      public var hitArea_mc:MovieClip;
      
      public var counter:int = 0;
      
      public var blinkCounter:int = 0;
      
      public var power:int;
      
      public var dir:int = 1;
      
      public var damageTime:int = 10;
      
      public var velX:Number = 0;
      
      private var ran_num:Number = 0;
      
      public function DamageObject()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
      }
      
      private function onAdded(param1:Event) : void
      {
         this.power = new int(Stats.envStats[currentLabel].power);
         damageObject_array.push(this);
         removeEventListener(Event.ADDED_TO_STAGE,this.onAdded);
      }
      
      public function onEnter(param1:Vector.<Enemy>, param2:int) : void
      {
         var _loc3_:Enemy = null;
         ++this.counter;
         ++this.blinkCounter;
         if(this.blinkCounter > 38)
         {
            this.blinkCounter = 0;
         }
         if(this.velX != 0 && this.velX != 0)
         {
            x += this.velX;
            if(currentLabel == "beholder cannon")
            {
               for each(_loc3_ in param1)
               {
                  if(_loc3_ is Kreetus)
                  {
                     if(x < _loc3_.x + 50)
                     {
                        this.ran_num = Math.random();
                        if(this.ran_num > 0.5)
                        {
                           if(this.ran_num > 0.66)
                           {
                              SoundManager.playSound(Assets.main_assetManager.getSound("heal low pitch sound"),x,y,true,GameMain(root).starlingStage.c_mc);
                           }
                           else if(this.ran_num > 0.33)
                           {
                              SoundManager.playSound(Assets.main_assetManager.getSound("heal mid pitch sound"),x,y,true,GameMain(root).starlingStage.c_mc);
                           }
                           else
                           {
                              SoundManager.playSound(Assets.main_assetManager.getSound("heal high pitch sound"),x,y,true,GameMain(root).starlingStage.c_mc);
                           }
                        }
                        SetHue.tintObject(_loc3_,10386924);
                        parent.removeChild(this);
                        damageObject_array.removeAt(param2);
                        return;
                     }
                     break;
                  }
               }
            }
            if(this.counter > 240)
            {
               damageObject_array.removeAt(param2);
               parent.removeChild(this);
               return;
            }
         }
      }
   }
}

