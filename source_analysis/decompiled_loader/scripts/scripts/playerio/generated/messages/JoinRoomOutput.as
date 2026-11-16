package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class JoinRoomOutput extends Message
   {
      
      public var joinKey:String;
      
      public var endpoints:Array = [];
      
      public var endpointsDummy:ServerEndpoint = null;
      
      public function JoinRoomOutput()
      {
         super();
         registerField("joinKey","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("endpoints","playerio.generated.messages.ServerEndpoint",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,2);
      }
   }
}

