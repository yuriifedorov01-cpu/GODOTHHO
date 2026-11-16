package com.apis
{
   import com.newgrounds.*;
   import com.newgrounds.components.*;
   import starling.core.*;
   
   public final class Newgrounds
   {
      
      private static var gameMain:GameMain;
      
      public function Newgrounds()
      {
         super();
      }
      
      public static function init(param1:GameMain) : *
      {
         gameMain = param1;
         API.connect(param1.root,"32772:2owmMOOc","a4MZJPLhxq616r0mNyQNTcrYFgtF8Bpk");
      }
      
      public static function completeAchievement(param1:String) : void
      {
         var _loc2_:MedalPopup = new MedalPopup();
         _loc2_.x = Starling.current.viewPort.width / 2;
         _loc2_.y = Starling.current.viewPort.height / 2;
         gameMain.addChild(_loc2_);
         API.unlockMedal(param1);
      }
      
      public static function submitScore(param1:String, param2:uint) : void
      {
         API.postScore(param1,param2);
      }
      
      public static function get isReady() : Boolean
      {
         return API.connected;
      }
   }
}

