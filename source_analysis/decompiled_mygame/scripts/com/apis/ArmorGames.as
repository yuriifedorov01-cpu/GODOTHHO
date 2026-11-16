package com.apis
{
   import flash.display.*;
   import flash.events.*;
   import flash.external.*;
   import flash.net.*;
   
   public final class ArmorGames
   {
      
      private static var root:DisplayObject;
      
      private static var __token:String = "";
      
      private static var __AGObject:Object = null;
      
      private static var __uid:String = "";
      
      public function ArmorGames()
      {
         super();
      }
      
      public static function init(param1:DisplayObject) : void
      {
         root = param1;
         __uid = uid;
         __token = token;
      }
      
      private static function JS_gotUID(param1:String, param2:String) : void
      {
         __uid = param1;
         __token = param2;
         ExternalInterface.addCallback("JSarmorCall",null);
      }
      
      public static function get AGObject() : Object
      {
         return __AGObject;
      }
      
      public static function fetchObject(param1:String, param2:Function) : void
      {
         var _uid:String = param1;
         var _function:Function = param2;
         var request_url:URLRequest = null;
         var request_urlLoader:URLLoader = null;
         if(_uid != "")
         {
            request_url = new URLRequest("https://services.armorgames.com/services/rest/v1/users/" + _uid + ".json");
            request_url.requestHeaders = [new URLRequestHeader("Content-Type","application/json")];
            request_url.method = URLRequestMethod.GET;
            request_urlLoader = new URLLoader(request_url);
            request_urlLoader.addEventListener(Event.COMPLETE,function(param1:Event):void
            {
               if(_uid == __uid)
               {
                  __AGObject = JSON.parse(param1.target.data);
               }
               _function(JSON.parse(param1.target.data));
            });
            return;
         }
         throw new Error("uid must not be blank");
      }
      
      public static function isOnArmor(param1:DisplayObject) : Boolean
      {
         if(LoaderInfo(param1.loaderInfo).parameters.onArmor == undefined)
         {
            return false;
         }
         return Boolean(LoaderInfo(param1.loaderInfo).parameters.onArmor);
      }
      
      public static function get uid() : String
      {
         if(LoaderInfo(root.stage.loaderInfo).parameters.userID == undefined)
         {
            return "";
         }
         return String(LoaderInfo(root.stage.loaderInfo).parameters.userID);
      }
      
      public static function get token() : String
      {
         if(LoaderInfo(root.stage.loaderInfo).parameters.auth == undefined)
         {
            return "";
         }
         return String(LoaderInfo(root.stage.loaderInfo).parameters.auth);
      }
      
      public static function fetchSecretHash(param1:String, param2:Function) : void
      {
         var token_url:URLRequest = null;
         var request_urlLoader:URLLoader = null;
         var _hhUsername:String = param1;
         var _callback:Function = param2;
         if(__uid == "" || __token == "")
         {
            throw new Error("UID and token must be set before fetching secret hash");
         }
         token_url = new URLRequest("http://yuriifedorov01-cpu.github.io/hht-client/includes/secretHash.php?HHusername=" + _hhUsername + "&userID=" + __uid + "&authToken=" + __token);
         request_urlLoader = new URLLoader();
         request_urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
         request_urlLoader.load(token_url);
         request_urlLoader.addEventListener(Event.COMPLETE,function(param1:Event):void
         {
            _callback(param1.target.data.auth,param1.target.data.success);
         });
      }
   }
}

