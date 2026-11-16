package com.stats
{
   public class NPCStat
   {
      
      public static const NPC_array:Vector.<NPCStat> = new Vector.<NPCStat>();
      
      public var name:String = "";
      
      public var area:uint;
      
      public var x:int = 0;
      
      public var y:int = 0;
      
      public var hair:String;
      
      public var helmet:String;
      
      public var shirt:String;
      
      public var legs:String;
      
      public var weapon1:String;
      
      public var weapon2:String;
      
      public var talkTrigger:int;
      
      public var eyeFrame:int;
      
      public var gender:String = "male";
      
      public var scaleX:int = 1;
      
      public var skin:uint = 2;
      
      public function NPCStat(param1:uint, param2:String, param3:int, param4:int, param5:String, param6:String, param7:String, param8:String, param9:String, param10:String, param11:int = -1, param12:int = 1, param13:int = 1, param14:String = "male", param15:int = 2)
      {
         super();
         this.name = param2;
         this.area = param1;
         this.x = param3;
         this.y = param4;
         this.hair = param5;
         this.helmet = param6;
         this.shirt = param7;
         this.legs = param8;
         this.weapon1 = param9;
         this.weapon2 = param10;
         this.talkTrigger = param11;
         this.eyeFrame = param12;
         this.gender = param14;
         this.scaleX = param13;
         this.skin = param15;
         NPC_array.push(this);
      }
   }
}

