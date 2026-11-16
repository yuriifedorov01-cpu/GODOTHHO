package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class PayVaultUsePaymentInfoArgs extends Message
   {
      
      public var provider:String;
      
      public var providerArguments:Array = [];
      
      public var providerArgumentsDummy:KeyValuePair = null;
      
      public function PayVaultUsePaymentInfoArgs(param1:String, param2:Array)
      {
         super();
         registerField("provider","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("providerArguments","playerio.generated.messages.KeyValuePair",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,2);
         this.provider = param1;
         this.providerArguments = param2;
      }
   }
}

