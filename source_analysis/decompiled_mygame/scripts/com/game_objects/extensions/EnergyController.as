package com.game_objects.extensions
{
   import com.game_objects.Person;
   
   public final class EnergyController
   {
      
      public static const ABSORBED_WEIGHT:uint = 5;
      
      public static const LEVEL_WEIGHT:uint = 5;
      
      public static const ENEMY_WEIGHT:uint = 3;
      
      public static const PVP_WEIGHT:uint = 2;
      
      public static const RANDOM_WEIGHT:uint = 2;
      
      public static const RAGE_WEIGHT:uint = 2;
      
      public static const CHOP_WEIGHT:uint = 1;
      
      public static const FISH_WEIGHT:uint = 1;
      
      private var person:Person;
      
      public var totalMax:Number = 0.1;
      
      public var chargeMax:Number = 0.1;
      
      public var absorbedMax:Number = 0.1;
      
      public var levelMax:Number = 0.1;
      
      public var enemyMax:Number = 0.1;
      
      public var pvpMax:Number = 0.1;
      
      public var randomMax:Number = 0.1;
      
      public var rageMax:Number = 0.1;
      
      public var chopMax:Number = 0.1;
      
      public var fishMax:Number = 0.1;
      
      private var __charge:Number = 0;
      
      private var __absorbed:Number = 0;
      
      private var __level:Number = 0;
      
      private var __enemy:Number = 0;
      
      private var __pvp:Number = 0;
      
      public var random:Number = Math.random();
      
      private var __rage:Number = 0;
      
      private var __chop:Number = 0;
      
      private var __fish:Number = 0;
      
      private var enemyTimeCounter:int = 0;
      
      private var pvpTimeCounter:int = 0;
      
      private var chopTimeCounter:int = 0;
      
      private var fishTimeCounter:int = 0;
      
      private var absorbedTimeCounter:int = 0;
      
      private var unleashingCounter:int = 0;
      
      public var fakeFullTotal:Number = 0;
      
      private const ENERGY_DECREASE_FRAMES:uint = 5400;
      
      public function EnergyController(param1:Person)
      {
         super();
         this.person = param1;
      }
      
      public static function get fullTotalPossible() : Number
      {
         return ABSORBED_WEIGHT + LEVEL_WEIGHT + ENEMY_WEIGHT + PVP_WEIGHT + RANDOM_WEIGHT + RAGE_WEIGHT + CHOP_WEIGHT + FISH_WEIGHT;
      }
      
      public function onEnter() : void
      {
         ++this.enemyTimeCounter;
         ++this.pvpTimeCounter;
         ++this.chopTimeCounter;
         ++this.fishTimeCounter;
         if(this.enemyTimeCounter > this.ENERGY_DECREASE_FRAMES)
         {
            this.enemy -= 0.00009255;
         }
         if(this.pvpTimeCounter > this.ENERGY_DECREASE_FRAMES)
         {
            this.pvp -= 0.00009255;
         }
         if(this.chopTimeCounter > this.ENERGY_DECREASE_FRAMES)
         {
            this.chop -= 0.00009255;
         }
         if(this.fishTimeCounter > this.ENERGY_DECREASE_FRAMES)
         {
            this.fish -= 0.00009255;
         }
         if(this.absorbedTimeCounter > this.ENERGY_DECREASE_FRAMES)
         {
            this.absorbed -= 0.00009255;
         }
         if(this.person.powerUpVisuals.poweringUp)
         {
            this.charge += 0.0003702;
         }
         if(this.person.powerUpVisuals.unleashing)
         {
            ++this.unleashingCounter;
            if(this.unleashingCounter > 600)
            {
               this.charge -= 0.0008;
               this.fakeFullTotal -= 0.0008 * 21;
            }
         }
         else
         {
            this.unleashingCounter = 0;
         }
         if(this.person.bodyAnimator.currentLabel == "give energy")
         {
            this.charge -= 0.00046275;
         }
      }
      
      public function get fullTotal() : Number
      {
         if(this.person.isPlayer)
         {
            return this.__charge * (this.fullAbsorbed + this.fullLevel + this.fullEnemy + this.fullPvp + this.fullRandom + this.fullRage + this.fullChop + this.fullFish);
         }
         return this.fakeFullTotal;
      }
      
      public function get fullTotalScale() : Number
      {
         return this.fullTotal / fullTotalPossible;
      }
      
      public function get total() : Number
      {
         var _loc1_:int = ABSORBED_WEIGHT + LEVEL_WEIGHT + ENEMY_WEIGHT + PVP_WEIGHT + RANDOM_WEIGHT + RAGE_WEIGHT + CHOP_WEIGHT + FISH_WEIGHT;
         return this.fullTotal / _loc1_;
      }
      
      public function get charge() : Number
      {
         return this.__charge;
      }
      
      public function set charge(param1:Number) : void
      {
         param1 = param1 < 0 ? 0 : param1;
         this.__charge = param1 > this.chargeMax ? this.chargeMax : param1;
      }
      
      public function get absorbed() : Number
      {
         return this.__absorbed;
      }
      
      public function set absorbed(param1:Number) : void
      {
         param1 = param1 < 0 ? 0 : param1;
         this.__absorbed = param1 > this.absorbedMax ? this.absorbedMax : param1;
         this.absorbedTimeCounter = param1 > this.__absorbed ? 0 : int(this.absorbedTimeCounter);
      }
      
      public function get fullAbsorbed() : Number
      {
         return this.__absorbed * ABSORBED_WEIGHT;
      }
      
      public function get level() : Number
      {
         return this.__level;
      }
      
      public function set level(param1:Number) : void
      {
         this.__level = param1 > this.levelMax ? this.levelMax : param1;
      }
      
      public function get fullLevel() : Number
      {
         return this.__level * LEVEL_WEIGHT;
      }
      
      public function get enemy() : Number
      {
         return this.__enemy;
      }
      
      public function set enemy(param1:Number) : void
      {
         param1 = param1 < 0 ? 0 : param1;
         this.enemyTimeCounter = param1 > this.__enemy ? 0 : int(this.enemyTimeCounter);
         this.__enemy = param1 > this.enemyMax ? this.enemyMax : param1;
      }
      
      public function get fullEnemy() : Number
      {
         return this.__enemy * ENEMY_WEIGHT;
      }
      
      public function get pvp() : Number
      {
         return this.__pvp;
      }
      
      public function set pvp(param1:Number) : void
      {
         param1 = param1 < 0 ? 0 : param1;
         this.pvpTimeCounter = param1 > this.__pvp ? 0 : int(this.pvpTimeCounter);
         this.__pvp = param1 > this.pvpMax ? this.pvpMax : param1;
      }
      
      public function get fullPvp() : Number
      {
         return this.__pvp * PVP_WEIGHT;
      }
      
      public function get fullRandom() : Number
      {
         return this.random * RANDOM_WEIGHT;
      }
      
      public function get rage() : Number
      {
         return this.__rage;
      }
      
      public function set rage(param1:Number) : void
      {
         this.__rage = param1 > this.rageMax ? this.rageMax : param1;
      }
      
      public function get fullRage() : Number
      {
         return this.__rage * RAGE_WEIGHT;
      }
      
      public function get chop() : Number
      {
         return this.__chop;
      }
      
      public function set chop(param1:Number) : void
      {
         param1 = param1 < 0 ? 0 : param1;
         this.chopTimeCounter = param1 > this.__chop ? 0 : int(this.chopTimeCounter);
         this.__chop = param1 > this.chopMax ? this.chopMax : param1;
      }
      
      public function get fullChop() : Number
      {
         return this.__chop * CHOP_WEIGHT;
      }
      
      public function get fish() : Number
      {
         return this.__fish;
      }
      
      public function set fish(param1:Number) : void
      {
         param1 = param1 < 0 ? 0 : param1;
         this.fishTimeCounter = param1 > this.__fish ? 0 : int(this.fishTimeCounter);
         this.__fish = param1 > this.fishMax ? this.fishMax : param1;
      }
      
      public function get fullFish() : Number
      {
         return this.__chop * CHOP_WEIGHT;
      }
   }
}

