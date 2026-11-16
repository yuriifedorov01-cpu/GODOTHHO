package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class NotificationsRefreshArgs extends Message
   {
      
      public var lastVersion:String;
      
      public function NotificationsRefreshArgs(param1:String)
      {
         super();
         registerField("lastVersion","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         this.lastVersion = param1;
      }
   }
}

