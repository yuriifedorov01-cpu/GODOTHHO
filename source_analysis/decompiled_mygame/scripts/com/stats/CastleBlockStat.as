package com.stats
{
   public class CastleBlockStat
   {
      
      private var __cost:int = 0;
      
      private var __type:String = "";
      
      private var __materials_array:Vector.<String>;
      
      private var __costs_array:Vector.<int>;
      
      public function CastleBlockStat(param1:String, param2:int, param3:Vector.<String>, param4:Vector.<int>)
      {
         super();
         this.__type = param1;
         this.__cost = param2;
         this.__materials_array = param3;
         this.__costs_array = param4;
      }
      
      public function get type() : String
      {
         return this.__type;
      }
      
      public function get cost() : int
      {
         return this.__cost;
      }
      
      public function get materials_array() : Vector.<String>
      {
         return this.__materials_array;
      }
      
      public function get costs_array() : Vector.<int>
      {
         return this.__costs_array;
      }
   }
}

