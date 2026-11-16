package com.stats
{
   import flash.ui.*;
   
   public class Moves
   {
      
      private static var moveStats:Vector.<MoveStat> = new Vector.<MoveStat>();
      
      public static const BASIC_ONE_WARRIOR1:String = "attack";
      
      public static const BASIC_ONE_WARRIOR2:String = "attack stab";
      
      public static const BASIC_ONE_WARRIOR3:String = "attack upward";
      
      public static const BASIC_TWO_WARRIOR1:String = "attack single";
      
      public static const BASIC_TWO_WARRIOR2:String = "attack single stab";
      
      public static const BASIC_TWO_WARRIOR3:String = "attack single multi";
      
      public static const BASIC_SHIELD_WARRIOR1:String = "attack shield";
      
      public static const BASIC_SHIELD_WARRIOR2:String = "attack shield stab";
      
      public static const BASIC_SHIELD_WARRIOR3:String = "attack shield upward";
      
      public static const BASIC_SHOOT_ARCHER:String = "shoot bow";
      
      public static const BASIC_ONE_MAGE2:String = "attack magic upward";
      
      public static const BASIC_SHOOT_COWBOY:String = "shoot gun";
      
      public static const PET_ONE_WARRIOR1:String = "pet attack";
      
      public static const PET_ONE_WARRIOR2:String = "pet attack upward";
      
      public static const PET_TWO_WARRIOR1:String = "pet attack dual";
      
      public static const PET_TWO_WARRIOR2:String = "pet attack dual 2";
      
      public static const PET_SHIELD_WARRIOR1:String = "pet attack shield";
      
      public static const PET_SHIELD_WARRIOR2:String = "pet attack shield 2";
      
      public static const PET_SHOOT_ARCHER:String = "pet shoot bow";
      
      public static const PET_SHOOT_COWBOY:String = "pet shoot gun";
      
      public static const PET_FORWARD_SUMMON:String = "pet summon forward";
      
      public static const GROUND_STAB:String = "ground stab";
      
      public static const DOWN_STAB:String = "down stab";
      
      public static const LUNGE_ATTACK:String = "lunge attack";
      
      public static const DOWN_SLASH:String = "down slash";
      
      public static const SUMMON_BEAM:String = "summon beam";
      
      public static const SPIN_ATTACK:String = "spin attack";
      
      public static const ARROW_RAIN:String = "rain attack";
      
      public static const GUN_SHOOT_UP:String = "gun shoot upward";
      
      public static const TRIPLE_SHOT:String = "triple shot";
      
      public static const SUMMON_THUNDER:String = "summon thunder";
      
      public static const DASH_ATTACK:String = "dash attack";
      
      public static const PET_DASH_ATTACK:String = "pet dash attack";
      
      public static const GRENADE_ATTACK:String = "grenade attack";
      
      private static var moveStat:MoveStat = new MoveStat(BASIC_ONE_WARRIOR1,5,85,78,81);
      
      moveStat.__hitRot = 145;
      moveStats.push(moveStat);
      moveStat = new MoveStat(BASIC_ONE_WARRIOR2,6,137,131,134);
      moveStats.push(moveStat);
      moveStat = new MoveStat(BASIC_ONE_WARRIOR3,uint.MAX_VALUE,151,141,147);
      moveStat.__hitRot = 25;
      moveStat.__knockback = 20;
      moveStats.push(moveStat);
      moveStat = new MoveStat(BASIC_TWO_WARRIOR1,10,167,157,165);
      moveStat.__hitRot = 145;
      moveStats.push(moveStat);
      moveStat = new MoveStat(BASIC_TWO_WARRIOR2,10,113,104,110);
      moveStats.push(moveStat);
      moveStat = new MoveStat(BASIC_TWO_WARRIOR3,uint.MAX_VALUE,178,169,172);
      moveStat.__hitRot = 60;
      moveStat.__knockback = 10;
      moveStats.push(moveStat);
      moveStat = new MoveStat(BASIC_SHIELD_WARRIOR1,5,124,117,120);
      moveStat.__hitRot = 132;
      moveStats.push(moveStat);
      moveStat = new MoveStat(BASIC_SHIELD_WARRIOR2,5,201,194,197);
      moveStats.push(moveStat);
      moveStat = new MoveStat(BASIC_SHIELD_WARRIOR3,uint.MAX_VALUE,189,182,185);
      moveStat.__hitRot = 15;
      moveStat.__knockback = 16;
      moveStats.push(moveStat);
      moveStat = new MoveStat(BASIC_SHOOT_ARCHER,uint.MAX_VALUE,97,0,0);
      moveStat.__knockback = 1;
      moveStats.push(moveStat);
      moveStat = new MoveStat(BASIC_SHOOT_COWBOY,uint.MAX_VALUE,758,0,0);
      moveStats.push(moveStat);
      moveStat = new MoveStat(BASIC_ONE_MAGE2,uint.MAX_VALUE,212,205,207);
      moveStat.__hitRot = 30;
      moveStat.__knockback = 12;
      moveStats.push(moveStat);
      moveStat = new MoveStat(PET_ONE_WARRIOR1,5,412,405,407,"pet standing");
      moveStats.push(moveStat);
      moveStat = new MoveStat(PET_ONE_WARRIOR2,uint.MAX_VALUE,423,415,417,"pet standing");
      moveStats.push(moveStat);
      moveStat = new MoveStat(PET_TWO_WARRIOR1,9,438,427,432,"pet standing");
      moveStats.push(moveStat);
      moveStat = new MoveStat(PET_TWO_WARRIOR2,uint.MAX_VALUE,455,443,449,"pet standing");
      moveStats.push(moveStat);
      moveStat = new MoveStat(PET_SHIELD_WARRIOR1,5,466,459,460,"pet standing");
      moveStats.push(moveStat);
      moveStat = new MoveStat(PET_SHIELD_WARRIOR2,uint.MAX_VALUE,478,470,472,"pet standing");
      moveStats.push(moveStat);
      moveStat = new MoveStat(PET_SHOOT_ARCHER,uint.MAX_VALUE,490,0,0,"pet standing");
      moveStats.push(moveStat);
      moveStat = new MoveStat(PET_SHOOT_COWBOY,uint.MAX_VALUE,605,0,0,"pet standing");
      moveStats.push(moveStat);
      moveStat = new MoveStat(PET_DASH_ATTACK,uint.MAX_VALUE,649,639,646,"pet standing");
      moveStats.push(moveStat);
      moveStat = new MoveStat(GROUND_STAB,uint.MAX_VALUE,884,872,872,"standing",866,Keyboard.SPACE);
      moveStat.__hitRot = 0;
      moveStat.__knockback = 16;
      moveStats.push(moveStat);
      moveStat = new MoveStat(DOWN_STAB,uint.MAX_VALUE,896,888,888,"standing",888);
      moveStats.push(moveStat);
      moveStat = new MoveStat(LUNGE_ATTACK,uint.MAX_VALUE,286,276,281,"standing",273,Keyboard.SPACE);
      moveStat.__hitRot = 35;
      moveStat.__knockback = 23;
      moveStats.push(moveStat);
      moveStat = new MoveStat(DOWN_SLASH,uint.MAX_VALUE,932,917,927,"standing",921);
      moveStat.__hitRot = 160;
      moveStat.__knockback = 20;
      moveStats.push(moveStat);
      moveStat = new MoveStat(SUMMON_BEAM,uint.MAX_VALUE,958,940,954);
      moveStat.__hitRot = 0;
      moveStat.__knockback = 16;
      moveStats.push(moveStat);
      moveStat = new MoveStat(SPIN_ATTACK,uint.MAX_VALUE,973,959,972);
      moveStat.__hitRot = 0;
      moveStat.__knockback = 6;
      moveStats.push(moveStat);
      moveStat = new MoveStat(ARROW_RAIN,uint.MAX_VALUE,269,0,0,"standing",261,Keyboard.SPACE);
      moveStats.push(moveStat);
      moveStat = new MoveStat(GUN_SHOOT_UP,uint.MAX_VALUE,769,0,0,"standing");
      moveStats.push(moveStat);
      moveStat = new MoveStat(TRIPLE_SHOT,uint.MAX_VALUE,251,0,0);
      moveStats.push(moveStat);
      moveStat = new MoveStat(SUMMON_THUNDER,uint.MAX_VALUE,318,0,0,"standing",309,Keyboard.SPACE);
      moveStat.__hitRot = 0;
      moveStat.__knockback = 9;
      moveStats.push(moveStat);
      moveStat = new MoveStat(DASH_ATTACK,uint.MAX_VALUE,816,795,804);
      moveStat.__hitRot = 40;
      moveStat.__knockback = 13;
      moveStats.push(moveStat);
      moveStat = new MoveStat(GRENADE_ATTACK,uint.MAX_VALUE,uint.MAX_VALUE,0,0,"standing",99,Keyboard.SPACE);
      moveStats.push(moveStat);
      moveStat = new MoveStat(PET_FORWARD_SUMMON,uint.MAX_VALUE,520,500,516,"pet standing");
      moveStats.push(moveStat);
      
      public function Moves()
      {
         super();
      }
      
      public static function moveByName(param1:String) : MoveStat
      {
         var _loc2_:MoveStat = null;
         for each(_loc2_ in moveStats)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}

