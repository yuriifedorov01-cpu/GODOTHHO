package com.game_objects.hit_detect
{
   import com.stats.MoveStat;
   import flash.geom.Point;
   import starling.display.DisplayObject;
   
   public class HitType
   {
      
      public static const MELEE_TYPE:String = "melee";
      
      public static const PROJ_TYPE:String = "projectile";
      
      public static const JUMP_TYPE:String = "jump";
      
      public var isPrimary:Boolean = true;
      
      public var moveStat:MoveStat;
      
      private var __basicType:String;
      
      private var __hitter:DisplayObject;
      
      internal var __centerPoint:Point;
      
      public function HitType()
      {
         super();
      }
      
      public function set basicType(param1:String) : void
      {
         if(param1 == MELEE_TYPE || param1 == PROJ_TYPE || param1 == JUMP_TYPE)
         {
            this.__basicType = param1;
            return;
         }
         throw new Error("Basic type has been set to an invalid value: " + param1 + ".");
      }
      
      public function get basicType() : String
      {
         return this.__basicType;
      }
      
      public function get hitter() : DisplayObject
      {
         return this.__hitter;
      }
      
      public function set hitter(param1:DisplayObject) : void
      {
         this.__hitter = param1;
      }
      
      public function get centerPoint() : Point
      {
         return this.__centerPoint;
      }
      
      public function resetAll() : void
      {
         this.moveStat = null;
         this.__basicType = "";
         this.__hitter = null;
      }
   }
}

