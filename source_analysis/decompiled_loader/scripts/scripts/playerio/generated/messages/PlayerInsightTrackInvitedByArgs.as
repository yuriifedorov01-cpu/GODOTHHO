package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class PlayerInsightTrackInvitedByArgs extends Message
   {
      
      public var invitingUserId:String;
      
      public var invitationChannel:String;
      
      public function PlayerInsightTrackInvitedByArgs(param1:String, param2:String)
      {
         super();
         registerField("invitingUserId","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("invitationChannel","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,2);
         this.invitingUserId = param1;
         this.invitationChannel = param2;
      }
   }
}

