package com.stats
{
   import flash.media.Sound;
   
   public class ItemStat
   {
      
      private var __fname:String;
      
      private var __defense:int;
      
      private var __cost:int;
      
      private var __allowHair:Boolean;
      
      private var __reqLev:int;
      
      private var __range:int;
      
      private var __magic:int;
      
      private var __power:int;
      
      private var __artillery:int;
      
      private var __minPower:int;
      
      private var __maxPower:int;
      
      private var __isRange:Boolean;
      
      private var __twoHanded:Boolean;
      
      private var __isMagic:Boolean;
      
      private var __fireDamage:int;
      
      private var __iceDamage:int;
      
      private var __shockDamage:int;
      
      private var __sRate:uint;
      
      private var __heal:int;
      
      private var __luck:int;
      
      private var __speed:int;
      
      public var frame:uint;
      
      public var sound:Sound;
      
      public var treeType:String;
      
      public var treeArea_array:Vector.<uint> = new Vector.<uint>();
      
      public var color:uint = 0;
      
      public var sColor:String = "";
      
      public var craftItems_array:Vector.<String> = new Vector.<String>();
      
      public var craftCosts_array:Vector.<int> = new Vector.<int>();
      
      public function ItemStat(param1:String, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:Boolean = false, param10:int = 0, param11:int = 0, param12:Boolean = false, param13:Boolean = false, param14:Boolean = false, param15:int = 0, param16:int = 0, param17:int = 0, param18:uint = 0, param19:int = 0, param20:int = 0, param21:int = 0)
      {
         super();
         this.__fname = param1;
         this.__defense = param2;
         this.__cost = param3;
         this.__reqLev = param4;
         this.__range = param5;
         this.__magic = param6;
         this.__power = param7;
         this.__artillery = param8;
         this.__allowHair = param9;
         this.__minPower = param10;
         this.__maxPower = param11;
         this.__isRange = param12;
         this.__twoHanded = param13;
         this.__isMagic = param14;
         this.__fireDamage = param15;
         this.__iceDamage = param17;
         this.__shockDamage = param16;
         this.__sRate = param18;
         this.__heal = param19;
         this.__luck = param20;
         this.__speed = param21;
      }
      
      public function get fname() : String
      {
         return this.__fname;
      }
      
      public function get defense() : int
      {
         return this.__defense;
      }
      
      public function get cost() : int
      {
         return this.__cost;
      }
      
      public function get allowHair() : Boolean
      {
         return this.__allowHair;
      }
      
      public function get reqLev() : int
      {
         return this.__reqLev;
      }
      
      public function get range() : int
      {
         return this.__range;
      }
      
      public function get magic() : int
      {
         return this.__magic;
      }
      
      public function get power() : int
      {
         return this.__power;
      }
      
      public function get artillery() : int
      {
         return this.__artillery;
      }
      
      public function get minPower() : int
      {
         return this.__minPower;
      }
      
      public function get maxPower() : int
      {
         return this.__maxPower;
      }
      
      public function get isRange() : Boolean
      {
         return this.__isRange;
      }
      
      public function get twoHanded() : Boolean
      {
         return this.__twoHanded;
      }
      
      public function get isMagic() : Boolean
      {
         return this.__isMagic;
      }
      
      public function get fireDamage() : int
      {
         return this.__fireDamage;
      }
      
      public function get iceDamage() : int
      {
         return this.__iceDamage;
      }
      
      public function get shockDamage() : int
      {
         return this.__shockDamage;
      }
      
      public function get sRate() : uint
      {
         return this.__sRate;
      }
      
      public function get heal() : int
      {
         return this.__heal;
      }
      
      public function get luck() : int
      {
         return this.__luck;
      }
      
      public function get speed() : int
      {
         return this.__speed;
      }
   }
}

