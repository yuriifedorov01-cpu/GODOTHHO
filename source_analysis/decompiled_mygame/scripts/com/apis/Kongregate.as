package com.apis
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   
   public final class Kongregate
   {
      
      private static var __root:DisplayObject;
      
      private static var param_object:Object;
      
      private static var apiPath:String;
      
      private static var __kongregateAPI:*;
      
      private static var gameMain:GameMain;
      
      public function Kongregate()
      {
         super();
      }
      
      public static function init(param1:DisplayObject) : void
      {
         __root = param1;
         param_object = LoaderInfo(param1.loaderInfo).parameters;
         apiPath = param_object.kongregate_api_path || "https://cdn1.kongregate.com/flash/API_AS3_Local.swf";
         Security.allowDomain(apiPath);
         Security.allowInsecureDomain(apiPath);
         var _loc2_:URLRequest = new URLRequest(apiPath);
         var _loc3_:Loader = new Loader();
         _loc3_.contentLoaderInfo.addEventListener(Event.COMPLETE,onAPILoadComplete);
         _loc3_.load(_loc2_);
         param1.stage.addChild(_loc3_);
      }
      
      private static function onAPILoadComplete(param1:Event) : void
      {
         __kongregateAPI = param1.target.content;
         __kongregateAPI.services.connect();
         Security.allowDomain(__kongregateAPI.loaderInfo.url);
         param1.target.removeEventListener(Event.COMPLETE,onAPILoadComplete);
         if(gameMain != null && gameMain.mMenu != null && gameMain.mMenu.currentLabel == "please sign in")
         {
            gameMain.gotoMainMenuFrame(1);
         }
      }
      
      public static function isOnKong(param1:DisplayObject) : Boolean
      {
         if(LoaderInfo(param1.loaderInfo).parameters.onKong == undefined)
         {
            return false;
         }
         return Boolean(LoaderInfo(param1.loaderInfo).parameters.onKong);
      }
      
      public static function showRegisterWindow(param1:GameMain) : void
      {
         gameMain = param1;
         __kongregateAPI.services.showRegistrationBox();
         __kongregateAPI.services.addEventListener("login",onAPILoadComplete);
      }
      
      public static function get uid() : String
      {
         return __kongregateAPI.services.getUserId();
      }
      
      public static function get username() : String
      {
         return __kongregateAPI.services.getUsername();
      }
      
      public static function get token() : String
      {
         return __kongregateAPI.services.getGameAuthToken();
      }
      
      public static function get isGuest() : Boolean
      {
         return __kongregateAPI.services.isGuest();
      }
      
      public static function get kongregateAPI() : *
      {
         return __kongregateAPI;
      }
   }
}

