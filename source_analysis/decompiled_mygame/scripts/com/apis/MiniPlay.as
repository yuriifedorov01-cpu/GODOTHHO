package com.apis
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   
   public final class MiniPlay
   {
      
      public static var lechuck:*;
      
      private static var root:DisplayObject;
      
      public function MiniPlay()
      {
         super();
      }
      
      public static function init(param1:DisplayObject) : void
      {
         root = param1;
         var _loc2_:Object = LoaderInfo(param1.root.loaderInfo).parameters;
         var _loc3_:String = _loc2_.mp_api_as3_url || "https://ssl.minijuegosgratis.com/lechuck/as3/latest.swf";
         Security.allowDomain(_loc3_);
         Security.allowInsecureDomain(_loc3_);
         var _loc4_:LoaderContext = new LoaderContext(false,null,SecurityDomain.currentDomain);
         var _loc5_:URLRequest = new URLRequest(_loc3_);
         var _loc6_:Loader = new Loader();
         _loc6_.contentLoaderInfo.addEventListener(Event.COMPLETE,onApiLoadComplete);
         _loc6_.load(_loc5_);
         DisplayObjectContainer(param1).addChild(_loc6_);
      }
      
      private static function onApiLoadComplete(param1:Event) : void
      {
         var token:String = null;
         var event:Event = param1;
         lechuck = event.target.content;
         token = lechuck.isDevel ? "6eb19e00b1260ddb491c16fd420438ff" : "0fd05e76654f0710b0ee5efe255af02d";
         lechuck.connect(token,function():void
         {
            if(lechuck.isConnected)
            {
               if(lechuck.user.isGuest())
               {
               }
            }
         });
      }
      
      public static function get token() : String
      {
         if(LoaderInfo(root.stage.loaderInfo).parameters.mp_api_user_token == undefined)
         {
            return "";
         }
         return String(LoaderInfo(root.stage.loaderInfo).parameters.mp_api_user_token);
      }
      
      public static function fetchSecretHash(param1:String, param2:Function) : void
      {
         var _hhUsername:String = param1;
         var _callback:Function = param2;
         var token_url:URLRequest = new URLRequest("https://yuriifedorov01-cpu.github.io/hht-client/includes/secretHash_miniplay.php?HHusername=" + _hhUsername + "&userID=" + lechuck.user.id + "&authToken=" + token);
         var request_urlLoader:URLLoader = new URLLoader();
         request_urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
         request_urlLoader.load(token_url);
         request_urlLoader.addEventListener(Event.COMPLETE,function(param1:Event):void
         {
            _callback(param1.target.data.auth,param1.target.data.success);
         });
      }
   }
}

