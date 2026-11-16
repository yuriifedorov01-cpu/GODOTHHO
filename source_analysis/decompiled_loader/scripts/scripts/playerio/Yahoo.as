package playerio
{
   import flash.events.EventDispatcher;
   import playerio.generated.messages.SocialProfile;
   import playerio.utils.HTTPChannel;
   
   public class Yahoo extends EventDispatcher
   {
      
      private var _client:Client;
      
      private var _profiles:YahooProfiles;
      
      private var _payments:YahooPayments;
      
      private var _relations:YahooRelations;
      
      private var _userToken:String;
      
      public function Yahoo(param1:Client)
      {
         super();
         this._client = param1;
         this._profiles = new YahooProfiles(param1);
         this._relations = new YahooRelations(param1,this);
         this._payments = new YahooPayments(param1);
         this._userToken = null;
      }
      
      internal static function _internal_showDialog(param1:String, param2:Object, param3:HTTPChannel, param4:Function) : void
      {
         YahooDialog.showDialog(param1,param2,param3,param4);
      }
      
      public function get profiles() : YahooProfiles
      {
         return this._profiles;
      }
      
      public function get payments() : YahooPayments
      {
         return this._payments;
      }
      
      public function get relations() : YahooRelations
      {
         return this._relations;
      }
      
      public function get userToken() : String
      {
         return this._userToken;
      }
      
      public function refresh(param1:Function, param2:Function) : void
      {
         var callback:Function = param1;
         var errorCallback:Function = param2;
         this._client._internal_social.refresh(function(param1:SocialProfile, param2:Array, param3:Array):void
         {
            var _loc4_:YahooProfile = new YahooProfile();
            _loc4_._internal_initialize(param1);
            _profiles._internal_refreshed(_loc4_);
            _relations._internal_refreshed(param1,param2,param3);
            _userToken = param1.userToken;
            if(callback != null)
            {
               callback();
            }
         },errorCallback);
      }
   }
}

