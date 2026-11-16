package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class PayVaultGiveArgs extends Message
   {
      
      public var items:Array = [];
      
      public var itemsDummy:PayVaultBuyItemInfo = null;
      
      public var targetUserId:String;
      
      public function PayVaultGiveArgs(param1:Array, param2:String)
      {
         super();
         registerField("items","playerio.generated.messages.PayVaultBuyItemInfo",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,1);
         registerField("targetUserId","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,2);
         this.items = param1;
         this.targetUserId = param2;
      }
   }
}

