package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class PayVaultPaymentInfoArgs extends Message
   {
      
      public var provider:String;
      
      public var purchaseArguments:Array = [];
      
      public var purchaseArgumentsDummy:KeyValuePair = null;
      
      public var items:Array = [];
      
      public var itemsDummy:PayVaultBuyItemInfo = null;
      
      public function PayVaultPaymentInfoArgs(param1:String, param2:Array, param3:Array)
      {
         super();
         registerField("provider","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("purchaseArguments","playerio.generated.messages.KeyValuePair",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,2);
         registerField("items","playerio.generated.messages.PayVaultBuyItemInfo",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,3);
         this.provider = param1;
         this.purchaseArguments = param2;
         this.items = param3;
      }
   }
}

