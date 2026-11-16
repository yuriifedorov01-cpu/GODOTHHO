package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class PayVaultCreditError extends Message
   {
      
      public var errorCode:int;
      
      public var message:String;
      
      public function PayVaultCreditError()
      {
         super();
         registerField("errorCode","",Descriptor.INT32,Descriptor.LABEL_OPTIONAL,1);
         registerField("message","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,2);
      }
   }
}

