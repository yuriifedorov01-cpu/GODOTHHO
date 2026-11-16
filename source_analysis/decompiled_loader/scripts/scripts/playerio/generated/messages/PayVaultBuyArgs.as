package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class PayVaultBuyArgs extends Message
   {
      
      public var items:Array = [];
      
      public var itemsDummy:PayVaultBuyItemInfo = null;
      
      public var storeItems:Boolean;
      
      public var targetUserId:String;
      
      public function PayVaultBuyArgs(param1:Array, param2:Boolean, param3:String)
      {
         super();
         registerField("items","playerio.generated.messages.PayVaultBuyItemInfo",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,1);
         registerField("storeItems","",Descriptor.BOOL,Descriptor.LABEL_OPTIONAL,2);
         registerField("targetUserId","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,3);
         this.items = param1;
         this.storeItems = param2;
         this.targetUserId = param3;
      }
   }
}

