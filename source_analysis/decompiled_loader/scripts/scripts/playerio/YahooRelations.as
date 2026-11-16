package playerio
{
   import playerio.generated.PlayerIOError;
   import playerio.generated.messages.SocialProfile;
   import playerio.utils.Utilities;
   
   internal class YahooRelations
   {
      
      private var _client:Client;
      
      private var _friends:Array;
      
      private var _friendLookup:Object;
      
      private var _blockedLookup:Object;
      
      private var _yahoo:Yahoo;
      
      public function YahooRelations(param1:Client, param2:Yahoo)
      {
         super();
         this._client = param1;
         this._yahoo = param2;
      }
      
      internal function _internal_refreshed(param1:SocialProfile, param2:Array, param3:Array) : void
      {
         var friend:YahooProfile = null;
         var ignored:String = null;
         var myProfile:SocialProfile = param1;
         var friends:Array = param2;
         var blocked:Array = param3;
         this._friends = Utilities.converter(friends,function(param1:SocialProfile):YahooProfile
         {
            var _loc2_:* = new YahooProfile();
            _loc2_._internal_initialize(param1);
            return _loc2_;
         });
         this._friendLookup = {};
         for each(friend in this._friends)
         {
            this._friendLookup[friend.userId] = true;
         }
         this._blockedLookup = {};
         if(blocked != null)
         {
            for each(ignored in blocked)
            {
               this._blockedLookup[ignored] = true;
            }
         }
      }
      
      public function get friends() : Array
      {
         if(this._friends == null)
         {
            throw new playerio.generated.PlayerIOError("Cannot access friends before Yahoo has loaded. Please call client.Yahoo.Refresh() first.",playerio.PlayerIOError.YahooNotLoaded.errorID);
         }
         return this._friends;
      }
      
      public function isFiend(param1:String) : Boolean
      {
         if(this._friendLookup == null)
         {
            throw new playerio.generated.PlayerIOError("Cannot access friends before Yahoo has loaded. Please call client.Yahoo.Refresh() first.",playerio.PlayerIOError.YahooNotLoaded.errorID);
         }
         return this._friendLookup[param1] != undefined;
      }
      
      public function isBlocked(param1:String) : Boolean
      {
         if(this._blockedLookup == null)
         {
            throw new playerio.generated.PlayerIOError("Cannot access friends before Yahoo has loaded. Please call client.Yahoo.Refresh() first.",playerio.PlayerIOError.YahooNotLoaded.errorID);
         }
         return this._blockedLookup[param1] != undefined;
      }
      
      public function showRequestFriendshipDialog(param1:String, param2:Function) : void
      {
         var userId:String = param1;
         var closedCallback:Function = param2;
         Yahoo._internal_showDialog("requestfriendship",{"userId":userId},this._client.channel,function():void
         {
            if(closedCallback != null)
            {
               closedCallback();
            }
         });
      }
      
      public function showRequestBlockUserDialog(param1:String, param2:Function) : void
      {
         var userId:String = param1;
         var closedCallback:Function = param2;
         Yahoo._internal_showDialog("requestblockuser",{"userId":userId},this._client.channel,function():void
         {
            _yahoo.refresh(function():void
            {
               if(closedCallback != null)
               {
                  closedCallback();
               }
            },function():void
            {
               if(closedCallback != null)
               {
                  closedCallback();
               }
            });
         });
      }
      
      public function showFriendsManager(param1:Function) : void
      {
         var closedCallback:Function = param1;
         Yahoo._internal_showDialog("friendsmanager",{},this._client.channel,function(param1:Object):void
         {
            var result:Object = param1;
            if(result["updated"] != undefined)
            {
               _yahoo.refresh(function():void
               {
                  if(closedCallback != null)
                  {
                     closedCallback();
                  }
               },function():void
               {
                  if(closedCallback != null)
                  {
                     closedCallback();
                  }
               });
            }
            else if(closedCallback != null)
            {
               closedCallback();
            }
         });
      }
      
      public function showBlockedUsersManager(param1:Function) : void
      {
         var closedCallback:Function = param1;
         Yahoo._internal_showDialog("blockedusersmanager",{},this._client.channel,function(param1:Object):void
         {
            var result:Object = param1;
            if(result["updated"] != undefined)
            {
               _yahoo.refresh(function():void
               {
                  if(closedCallback != null)
                  {
                     closedCallback();
                  }
               },function():void
               {
                  if(closedCallback != null)
                  {
                     closedCallback();
                  }
               });
            }
            else if(closedCallback != null)
            {
               closedCallback();
            }
         });
      }
   }
}

