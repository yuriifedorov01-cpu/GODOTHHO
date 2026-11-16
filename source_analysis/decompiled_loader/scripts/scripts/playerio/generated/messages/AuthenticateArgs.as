package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class AuthenticateArgs extends Message
   {
      
      public var gameId:String;
      
      public var connectionId:String;
      
      public var authenticationArguments:Array = [];
      
      public var authenticationArgumentsDummy:KeyValuePair = null;
      
      public var playerInsightSegments:Array = [];
      
      public var clientAPI:String;
      
      public var clientInfo:Array = [];
      
      public var clientInfoDummy:KeyValuePair = null;
      
      public var playCodes:Array = [];
      
      public function AuthenticateArgs(param1:String, param2:String, param3:Array, param4:Array, param5:String, param6:Array, param7:Array)
      {
         super();
         registerField("gameId","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("connectionId","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,2);
         registerField("authenticationArguments","playerio.generated.messages.KeyValuePair",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,3);
         registerField("playerInsightSegments","",Descriptor.STRING,Descriptor.LABEL_REPEATED,4);
         registerField("clientAPI","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,5);
         registerField("clientInfo","playerio.generated.messages.KeyValuePair",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,6);
         registerField("playCodes","",Descriptor.STRING,Descriptor.LABEL_REPEATED,7);
         this.gameId = param1;
         this.connectionId = param2;
         this.authenticationArguments = param3;
         this.playerInsightSegments = param4;
         this.clientAPI = param5;
         this.clientInfo = param6;
         this.playCodes = param7;
      }
   }
}

