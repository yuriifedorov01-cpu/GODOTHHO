package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class GameRequestsRefreshOutput extends Message
   {
      
      public var requests:Array = [];
      
      public var requestsDummy:WaitingGameRequest = null;
      
      public var moreRequestsWaiting:Boolean;
      
      public var newPlayCodes:Array = [];
      
      public function GameRequestsRefreshOutput()
      {
         super();
         registerField("requests","playerio.generated.messages.WaitingGameRequest",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,1);
         registerField("moreRequestsWaiting","",Descriptor.BOOL,Descriptor.LABEL_OPTIONAL,2);
         registerField("newPlayCodes","",Descriptor.STRING,Descriptor.LABEL_REPEATED,3);
      }
   }
}

