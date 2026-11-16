package com.apis
{
   import flash.display.*;
   import flash.utils.*;
   
   public final class Steam
   {
      
      public static var steam:Object;
      
      private static var __onSteam:Boolean = false;
      
      public function Steam()
      {
         super();
      }
      
      public static function init(param1:GameMain) : void
      {
         if(param1.parent.parent != null && MovieClip(param1.parent.parent).isOnSteam == true)
         {
            __onSteam = true;
            steam = MovieClip(param1.parent.parent).steam_api;
            steam.init();
         }
      }
      
      public static function get onSteam() : Boolean
      {
         return __onSteam;
      }
      
      public static function getAuthToken() : String
      {
         var _loc1_:ByteArray = new ByteArray();
         var _loc2_:int = int(steam.getAuthSessionTicket(_loc1_));
         var _loc3_:String = "";
         var _loc4_:uint = 0;
         while(_loc4_ < _loc1_.length)
         {
            _loc3_ += ("0" + _loc1_[_loc4_].toString(16)).substr(-2,2);
            _loc4_++;
         }
         return _loc3_;
      }
   }
}

