package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class CreateJoinRoomOutput extends Message
   {
      
      public var roomId:String;
      
      public var joinKey:String;
      
      public var endpoints:Array = [];
      
      public var endpointsDummy:ServerEndpoint = null;
      
      public function CreateJoinRoomOutput()
      {
         super();
         registerField("roomId","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("joinKey","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,2);
         registerField("endpoints","playerio.generated.messages.ServerEndpoint",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,3);
      }
   }
}

