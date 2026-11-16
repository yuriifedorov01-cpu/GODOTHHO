package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class GameRequestsRefreshArgs extends Message
   {
      
      public var playCodes:Array = [];
      
      public function GameRequestsRefreshArgs(param1:Array)
      {
         super();
         registerField("playCodes","",Descriptor.STRING,Descriptor.LABEL_REPEATED,1);
         this.playCodes = param1;
      }
   }
}

