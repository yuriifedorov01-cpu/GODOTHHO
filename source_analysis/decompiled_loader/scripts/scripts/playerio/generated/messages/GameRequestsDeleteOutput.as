package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class GameRequestsDeleteOutput extends Message
   {
      
      public var requests:Array = [];
      
      public var requestsDummy:WaitingGameRequest = null;
      
      public var moreRequestsWaiting:Boolean;
      
      public function GameRequestsDeleteOutput()
      {
         super();
         registerField("requests","playerio.generated.messages.WaitingGameRequest",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,1);
         registerField("moreRequestsWaiting","",Descriptor.BOOL,Descriptor.LABEL_OPTIONAL,2);
      }
   }
}

