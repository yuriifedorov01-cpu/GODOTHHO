package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class NotificationsToggleEndpointsArgs extends Message
   {
      
      public var lastVersion:String;
      
      public var endpoints:Array = [];
      
      public var endpointsDummy:NotificationsEndpointId = null;
      
      public var enabled:Boolean;
      
      public function NotificationsToggleEndpointsArgs(param1:String, param2:Array, param3:Boolean)
      {
         super();
         registerField("lastVersion","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("endpoints","playerio.generated.messages.NotificationsEndpointId",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,2);
         registerField("enabled","",Descriptor.BOOL,Descriptor.LABEL_OPTIONAL,3);
         this.lastVersion = param1;
         this.endpoints = param2;
         this.enabled = param3;
      }
   }
}

