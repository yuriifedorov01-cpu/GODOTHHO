package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class AuthenticateOutput extends Message
   {
      
      public var token:String;
      
      public var userId:String;
      
      public var showBranding:Boolean;
      
      public var gameFSRedirectMap:String;
      
      public var playerInsightState:PlayerInsightState;
      
      public var playerInsightStateDummy:PlayerInsightState = null;
      
      public var startDialogs:Array = [];
      
      public var startDialogsDummy:AuthenticateStartDialog = null;
      
      public var isSocialNetworkUser:Boolean;
      
      public var newPlayCodes:Array = [];
      
      public var notificationClickPayload:String;
      
      public var isInstalledByYahoo:Boolean;
      
      public var deprecated1:Array = [];
      
      public var apiSecurity:int;
      
      public var apiServerHosts:Array = [];
      
      public function AuthenticateOutput()
      {
         super();
         registerField("token","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("userId","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,2);
         registerField("showBranding","",Descriptor.BOOL,Descriptor.LABEL_OPTIONAL,3);
         registerField("gameFSRedirectMap","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,4);
         registerField("playerInsightState","playerio.generated.messages.PlayerInsightState",Descriptor.MESSAGE,Descriptor.LABEL_OPTIONAL,5);
         registerField("startDialogs","playerio.generated.messages.AuthenticateStartDialog",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,6);
         registerField("isSocialNetworkUser","",Descriptor.BOOL,Descriptor.LABEL_OPTIONAL,7);
         registerField("newPlayCodes","",Descriptor.STRING,Descriptor.LABEL_REPEATED,8);
         registerField("notificationClickPayload","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,9);
         registerField("isInstalledByYahoo","",Descriptor.BOOL,Descriptor.LABEL_OPTIONAL,10);
         registerField("deprecated1","",Descriptor.STRING,Descriptor.LABEL_REPEATED,11);
         registerField("apiSecurity","",Descriptor.ENUM,Descriptor.LABEL_OPTIONAL,12);
         registerField("apiServerHosts","",Descriptor.STRING,Descriptor.LABEL_REPEATED,13);
      }
   }
}

