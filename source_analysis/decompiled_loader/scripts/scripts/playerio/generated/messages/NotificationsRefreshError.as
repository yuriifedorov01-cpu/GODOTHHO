package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class NotificationsRefreshError extends Message
   {
      
      public var errorCode:int;
      
      public var message:String;
      
      public function NotificationsRefreshError()
      {
         super();
         registerField("errorCode","",Descriptor.INT32,Descriptor.LABEL_OPTIONAL,1);
         registerField("message","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,2);
      }
   }
}

