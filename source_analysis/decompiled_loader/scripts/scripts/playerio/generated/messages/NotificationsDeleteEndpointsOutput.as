package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class NotificationsDeleteEndpointsOutput extends Message
   {
      
      public var version:String;
      
      public var endpoints:Array = [];
      
      public var endpointsDummy:NotificationsEndpoint = null;
      
      public function NotificationsDeleteEndpointsOutput()
      {
         super();
         registerField("version","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("endpoints","playerio.generated.messages.NotificationsEndpoint",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,2);
      }
   }
}

