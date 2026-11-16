package playerio
{
   import playerio.generated.PlayerIOError;
   
   internal class YahooProfiles
   {
      
      private var _client:Client;
      
      private var _myProfile:YahooProfile;
      
      public function YahooProfiles(param1:Client)
      {
         super();
         this._client = param1;
      }
      
      public function get myProfile() : YahooProfile
      {
         if(this._myProfile == null)
         {
            throw new playerio.generated.PlayerIOError("Cannot access profile before Yahoo has loaded. Please call client.Yahoo.Refresh() first",playerio.PlayerIOError.YahooNotLoaded.errorID);
         }
         return this._myProfile;
      }
      
      internal function _internal_refreshed(param1:YahooProfile) : void
      {
         this._myProfile = param1;
      }
      
      public function showProfile(param1:String, param2:Function) : void
      {
         Yahoo._internal_showDialog("profile",{"userId":param1},this._client.channel,param2);
      }
      
      public function loadProfiles(param1:Array, param2:Function, param3:Function) : void
      {
         this._client._internal_social.loadProfile(param1,param2,param3);
      }
   }
}

