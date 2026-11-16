package com.apis
{
   import flash.display.*;
   
   public final class PlayerIOPublishingNetwork
   {
      
      private static var root:DisplayObject;
      
      public function PlayerIOPublishingNetwork()
      {
         super();
      }
      
      public static function init(param1:DisplayObject) : void
      {
         root = param1;
      }
      
      public static function isOnNetworkSite() : Boolean
      {
         if(LoaderInfo(root.stage.loaderInfo).parameters.onPlayerIO == undefined)
         {
            return false;
         }
         return Boolean(LoaderInfo(root.stage.loaderInfo).parameters.onPlayerIO);
      }
      
      public static function get token() : String
      {
         var _loc1_:String = null;
         if(LoaderInfo(root.stage.loaderInfo).parameters.auth == undefined)
         {
            return "";
         }
         _loc1_ = String(LoaderInfo(root.stage.loaderInfo).parameters.auth);
         return _loc1_.split("\'").join("");
      }
      
      public static function get username() : String
      {
         var _loc1_:String = null;
         if(LoaderInfo(root.stage.loaderInfo).parameters.username == undefined)
         {
            return "";
         }
         _loc1_ = String(LoaderInfo(root.stage.loaderInfo).parameters.username);
         return _loc1_.split("\'").join("");
      }
   }
}

