package playerio
{
   import playerio.generated.Social;
   import playerio.generated.messages.*;
   import playerio.utils.*;
   
   internal class Social extends playerio.generated.Social
   {
      
      public function Social(param1:HTTPChannel, param2:Client)
      {
         super(param1,param2);
      }
      
      public function refresh(param1:Function, param2:Function) : void
      {
         var callback:Function = param1;
         var errorCallback:Function = param2;
         _socialRefresh(function(param1:SocialProfile, param2:Array, param3:Array):void
         {
            if(callback != null)
            {
               callback(param1,param2,param3);
            }
         },errorCallback);
      }
      
      public function loadProfile(param1:Array, param2:Function, param3:Function) : void
      {
         var userIds:Array = param1;
         var callback:Function = param2;
         var errorCallback:Function = param3;
         if(callback != null)
         {
            _socialLoadProfiles(userIds,function(param1:Array):void
            {
               var i:int = 0;
               var found:SocialProfile = null;
               var yp:PublishingNetworkProfile = null;
               var profiles:Array = param1;
               var resultProfile:Array = [];
               i = 0;
               while(i < userIds.length)
               {
                  found = (profiles != null ? Utilities.find(profiles,function(param1:SocialProfile):Boolean
                  {
                     return param1.userId == userIds[i];
                  }) : null) as SocialProfile;
                  if(found != null)
                  {
                     yp = new PublishingNetworkProfile();
                     yp._internal_initialize(found);
                     resultProfile.push(yp);
                  }
                  else
                  {
                     resultProfile.push(null);
                  }
                  i += 1;
               }
               callback(resultProfile);
            },errorCallback);
         }
         else
         {
            callback([]);
         }
      }
   }
}

