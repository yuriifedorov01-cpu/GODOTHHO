package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class NotificationsEndpointId extends Message
   {
      
      public var type:String;
      
      public var identifier:String;
      
      public function NotificationsEndpointId()
      {
         super();
         registerField("type","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("identifier","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,2);
      }
   }
}

