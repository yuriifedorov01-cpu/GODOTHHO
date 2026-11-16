package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class NotificationsRegisterEndpointsArgs extends Message
   {
      
      public var lastVersion:String;
      
      public var endpoints:Array = [];
      
      public var endpointsDummy:NotificationsEndpoint = null;
      
      public function NotificationsRegisterEndpointsArgs(param1:String, param2:Array)
      {
         super();
         registerField("lastVersion","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("endpoints","playerio.generated.messages.NotificationsEndpoint",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,2);
         this.lastVersion = param1;
         this.endpoints = param2;
      }
   }
}

