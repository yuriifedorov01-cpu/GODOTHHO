package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class PayVaultPaymentInfoOutput extends Message
   {
      
      public var providerArguments:Array = [];
      
      public var providerArgumentsDummy:KeyValuePair = null;
      
      public function PayVaultPaymentInfoOutput()
      {
         super();
         registerField("providerArguments","playerio.generated.messages.KeyValuePair",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,1);
      }
   }
}

