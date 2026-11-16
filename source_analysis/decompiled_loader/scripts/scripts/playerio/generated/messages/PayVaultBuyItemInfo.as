package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class PayVaultBuyItemInfo extends Message
   {
      
      public var itemKey:String;
      
      public var payload:Array = [];
      
      public var payloadDummy:ObjectProperty = null;
      
      public function PayVaultBuyItemInfo()
      {
         super();
         registerField("itemKey","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("payload","playerio.generated.messages.ObjectProperty",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,2);
      }
   }
}

