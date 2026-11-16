package com.game_objects.extensions
{
   import flash.display.*;
   import flash.utils.*;
   
   public final class PersonHackCheck
   {
      
      private var __money:uint = 0;
      
      private var __MP:int = 0;
      
      private var tripleMP:int = 0;
      
      private var __totalMP:int = 0;
      
      private var tripleTotalMP:int = 0;
      
      private var __health:int = 0;
      
      private var tripleHealth:int = 0;
      
      private var __totalHealth:int = 0;
      
      private var tripleTotalHealth:int = 0;
      
      private var gameMain:GameMain;
      
      private var banSent:Boolean = false;
      
      private var __tickets:int = 0;
      
      private var tripleTickets:int = 0;
      
      public function PersonHackCheck(param1:GameMain)
      {
         super();
         this.gameMain = param1;
      }
      
      public function get MP() : int
      {
         if(this.tripleMP != this.__MP * 3)
         {
            this.banKillPlayer();
         }
         return this.__MP;
      }
      
      public function set MP(param1:int) : void
      {
         this.__MP = param1;
         this.tripleMP = this.__MP * 3;
      }
      
      public function get health() : int
      {
         if(this.tripleHealth != this.__health * 3)
         {
            this.banKillPlayer();
         }
         return this.__health;
      }
      
      public function set health(param1:int) : void
      {
         this.__health = param1;
         this.tripleHealth = this.__health * 3;
      }
      
      public function get totalHealth() : int
      {
         if(this.tripleTotalHealth != this.__totalHealth * 3)
         {
            this.banKillPlayer();
         }
         return this.__totalHealth;
      }
      
      public function set totalHealth(param1:int) : void
      {
         this.__totalHealth = param1;
         this.tripleTotalHealth = this.__totalHealth * 3;
      }
      
      public function get totalMP() : int
      {
         if(this.tripleTotalMP != this.__totalMP * 3)
         {
            this.banKillPlayer();
         }
         return this.__totalMP;
      }
      
      public function set totalMP(param1:int) : void
      {
         this.__totalMP = param1;
         this.tripleTotalMP = this.__totalMP * 3;
      }
      
      public function set tickets(param1:int) : void
      {
         this.__tickets = param1;
         this.tripleTickets = this.__tickets * 3;
      }
      
      public function get tickets() : int
      {
         if(this.tripleTickets != this.__tickets * 3)
         {
            this.banKillPlayer();
         }
         return this.__tickets;
      }
      
      public function banKillPlayer(param1:Boolean = true, param2:String = "") : void
      {
         var _ban:Boolean = param1;
         var _reason:String = param2;
         if(this.banSent == false && this.gameMain.theConnection != null && Boolean(this.gameMain.theConnection.connected))
         {
            this.banSent = true;
            if(_ban)
            {
               this.gameMain.theConnection.send("ban",_reason);
            }
            setTimeout(function():void
            {
               gameMain.theConnection.disconnect();
               setTimeout(function():void
               {
                  var _loc1_:MovieClip = null;
                  while(1)
                  {
                     _loc1_ = new MovieClip();
                     _loc1_.graphics.beginFill(Math.random() * 16777215,Math.random());
                     _loc1_.graphics.drawRect(Math.random() * 950,Math.random() * 700,200,100);
                     _loc1_.graphics.endFill();
                     gameMain.addChild(_loc1_);
                  }
               },1000);
            },2000);
         }
      }
   }
}

