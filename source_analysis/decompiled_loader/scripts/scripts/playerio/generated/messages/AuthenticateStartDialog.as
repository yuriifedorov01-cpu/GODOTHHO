package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class AuthenticateStartDialog extends Message
   {
      
      public var name:String;
      
      public var arguments:Array = [];
      
      public var argumentsDummy:KeyValuePair = null;
      
      public function AuthenticateStartDialog()
      {
         super();
         registerField("name","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("arguments","playerio.generated.messages.KeyValuePair",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,2);
      }
   }
}

