package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class SteamConnectOutput extends Message
   {
      
      public var token:String;
      
      public var userId:String;
      
      public var showBranding:Boolean;
      
      public var gameFSRedirectMap:String;
      
      public var partnerId:String;
      
      public var playerInsightState:PlayerInsightState;
      
      public var playerInsightStateDummy:PlayerInsightState = null;
      
      public function SteamConnectOutput()
      {
         super();
         registerField("token","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("userId","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,2);
         registerField("showBranding","",Descriptor.BOOL,Descriptor.LABEL_OPTIONAL,3);
         registerField("gameFSRedirectMap","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,4);
         registerField("partnerId","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,5);
         registerField("playerInsightState","playerio.generated.messages.PlayerInsightState",Descriptor.MESSAGE,Descriptor.LABEL_OPTIONAL,6);
      }
   }
}

