package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class ServerEndpoint extends Message
   {
      
      public var address:String;
      
      public var port:int;
      
      public function ServerEndpoint()
      {
         super();
         registerField("address","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("port","",Descriptor.INT32,Descriptor.LABEL_OPTIONAL,2);
      }
   }
}

