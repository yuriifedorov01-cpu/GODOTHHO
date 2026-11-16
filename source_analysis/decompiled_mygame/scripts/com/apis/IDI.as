package com.apis
{
   import com.adobe.crypto.*;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   
   public final class IDI extends Sprite
   {
      
      public var idnet:*;
      
      private var appID:String = "55538d489c5292a0fa000662";
      
      private var verbose:Boolean = true;
      
      private var showPreloader:* = false;
      
      private var protection:* = false;
      
      private var request_urlLoader:URLLoader;
      
      private var gameMain:GameMain;
      
      public function IDI()
      {
         super();
         Security.allowInsecureDomain("*");
         Security.allowDomain("*");
         addEventListener(Event.ADDED_TO_STAGE,this.onStage);
      }
      
      private function handleIDNET(param1:Event) : *
      {
         var _loc2_:* = undefined;
         if(this.idnet.type == "login")
         {
            this.log("hello " + this.idnet.userData.nickname + " your pid is " + this.idnet.userData.pid);
            if(this.gameMain.mMenu != null && this.gameMain.mMenu.parent != null)
            {
               this.gameMain.gotoMainMenuFrame(1);
               this.idnet.toggleInterface(null);
               this.gameMain.playingURL_string = "y8.com";
            }
         }
         if(this.idnet.type == "submit")
         {
            this.log("data submitted. status is " + this.idnet.data.status);
         }
         if(this.idnet.type == "retrieve")
         {
            if(this.idnet.data.hasOwnProperty("error") === false)
            {
               this.log("LOG: data retrieved. key is " + this.idnet.data.key + " data is " + this.idnet.data.jsondata);
               _loc2_ = JSON.parse(this.idnet.data.jsondata);
            }
            else
            {
               this.log("Error: " + this.idnet.data.error);
            }
         }
         if(this.idnet.type == "delete")
         {
            this.log("deleted data " + this.idnet.data);
         }
         if(this.idnet.type == "advancedScoreListPlayer")
         {
            this.log("player score: " + this.idnet.data.scores[0].points);
         }
         if(this.idnet.type == "achievementsSave")
         {
            if(this.idnet.data.errorcode == 0)
            {
               this.log("achievement unlocked");
            }
         }
         if(this.idnet.type == "mapSave")
         {
            this.log("map saved. levelid is " + this.idnet.data.level.levelid);
         }
         if(this.idnet.type == "mapLoad")
         {
            this.log(this.idnet.data.level.name + " loaded");
         }
         if(this.idnet.type == "mapRate")
         {
            this.log("rating added");
         }
      }
      
      private function log(param1:*) : *
      {
      }
      
      private function onStage(param1:Event) : void
      {
         var _loc2_:LoaderContext = new LoaderContext();
         _loc2_.applicationDomain = ApplicationDomain.currentDomain;
         if(Security.sandboxType != "localTrusted")
         {
            _loc2_.securityDomain = SecurityDomain.currentDomain;
         }
         var _loc3_:String = "https://www.id.net/swf/idnet-client.swc?=" + new Date().getTime();
         var _loc4_:URLRequest = new URLRequest(_loc3_);
         var _loc5_:Loader = new Loader();
         _loc5_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loadComplete,false,0,true);
         _loc5_.load(_loc4_,_loc2_);
         this.gameMain = GameMain(root);
      }
      
      private function loadComplete(param1:Event) : void
      {
         this.idnet = param1.currentTarget.content;
         this.idnet.addEventListener("IDNET",this.handleIDNET);
         stage.addChild(this.idnet);
         this.idnet.init(stage,this.appID,"",this.verbose,this.showPreloader,this.protection);
      }
      
      public function fetchSecretHash(param1:String, param2:Function) : void
      {
         var _hhUsername:String = param1;
         var _callback:Function = param2;
         var md5Name:String = MD5.hash(_hhUsername);
         var token_url:URLRequest = new URLRequest("http://yuriifedorov01-cpu.github.io/hht-client/includes/secretHash_y8.php?HHusername=" + _hhUsername + "&hashUsername=" + md5Name + "&ran=" + int(Math.random() * 99999));
         this.request_urlLoader = new URLLoader();
         this.request_urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
         this.request_urlLoader.load(token_url);
         this.request_urlLoader.addEventListener(Event.COMPLETE,function(param1:Event):void
         {
            _callback(param1.target.data.auth);
         });
      }
      
      public function achievementsSave(param1:String, param2:String) : void
      {
         this.idnet.achievementsSave(param1,param2);
      }
      
      public function advancedScoreSubmit(param1:uint, param2:String) : void
      {
         this.idnet.advancedScoreSubmit(param1,param2,this.username);
      }
      
      public function get userID() : String
      {
         return this.idnet.userData.pid;
      }
      
      public function get username() : String
      {
         return this.idnet.userData.nickname;
      }
      
      public function get sessionKey() : String
      {
         return this.idnet.userData.sessionKey;
      }
      
      public function get isLoggedIn() : Boolean
      {
         return this.idnet.isLoggedIn;
      }
   }
}

