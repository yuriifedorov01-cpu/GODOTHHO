package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class NotificationsToggleEndpointsError extends Message
   {
      
      public var errorCode:int;
      
      public var message:String;
      
      public function NotificationsToggleEndpointsError()
      {
         super();
         registerField("errorCode","",Descriptor.INT32,Descriptor.LABEL_OPTIONAL,1);
         registerField("message","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,2);
      }
   }
}

