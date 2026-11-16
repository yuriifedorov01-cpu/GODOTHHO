package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class PayVaultCreditArgs extends Message
   {
      
      public var amount:uint;
      
      public var reason:String;
      
      public var targetUserId:String;
      
      public function PayVaultCreditArgs(param1:uint, param2:String, param3:String)
      {
         super();
         registerField("amount","",Descriptor.UINT,Descriptor.LABEL_OPTIONAL,1);
         registerField("reason","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,2);
         registerField("targetUserId","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,3);
         this.amount = param1;
         this.reason = param2;
         this.targetUserId = param3;
      }
   }
}

