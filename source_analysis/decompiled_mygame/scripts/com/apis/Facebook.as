package com.apis
{
   import flash.display.*;
   import flash.net.URLRequest;
   import flash.system.*;
   
   public final class Facebook
   {
      
      private static var mainRoot:DisplayObject;
      
      private static var loader:Loader;
      
      private static var urlRequest:URLRequest;
      
      private static var __uid:String = "";
      
      private static var __token:String = "";
      
      private static var __onFacebook:Boolean = false;
      
      public function Facebook()
      {
         super();
      }
      
      public static function init(param1:DisplayObject) : void
      {
         Security.loadPolicyFile("https://fbcdn-profile-a.akamaihd.net/crossdomain.xml");
         mainRoot = param1;
         if(LoaderInfo(mainRoot.loaderInfo).parameters.onFacebook == undefined)
         {
            __onFacebook = false;
         }
         else
         {
            __onFacebook = Boolean(LoaderInfo(mainRoot.loaderInfo).parameters.onFacebook);
         }
         if(LoaderInfo(mainRoot.loaderInfo).parameters.token == undefined)
         {
            __token = "";
         }
         else
         {
            __token = String(LoaderInfo(mainRoot.loaderInfo).parameters.token);
         }
         if(__onFacebook)
         {
            __uid = String(LoaderInfo(mainRoot.loaderInfo).parameters.userID);
         }
      }
      
      public static function get onFacebook() : Boolean
      {
         return __onFacebook;
      }
      
      public static function get uid() : String
      {
         return __uid;
      }
      
      public static function get token() : String
      {
         return __token;
      }
   }
}

