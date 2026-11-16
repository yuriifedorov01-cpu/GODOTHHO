package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class NotificationsEndpoint extends Message
   {
      
      public var type:String;
      
      public var identifier:String;
      
      public var configuration:Array = [];
      
      public var configurationDummy:KeyValuePair = null;
      
      public var enabled:Boolean;
      
      public function NotificationsEndpoint()
      {
         super();
         registerField("type","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("identifier","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,2);
         registerField("configuration","playerio.generated.messages.KeyValuePair",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,3);
         registerField("enabled","",Descriptor.BOOL,Descriptor.LABEL_OPTIONAL,4);
      }
   }
}

