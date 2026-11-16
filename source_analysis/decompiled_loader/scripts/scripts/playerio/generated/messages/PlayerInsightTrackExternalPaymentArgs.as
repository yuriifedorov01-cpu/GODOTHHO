package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class PlayerInsightTrackExternalPaymentArgs extends Message
   {
      
      public var currency:String;
      
      public var amount:int;
      
      public function PlayerInsightTrackExternalPaymentArgs(param1:String, param2:int)
      {
         super();
         registerField("currency","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("amount","",Descriptor.INT32,Descriptor.LABEL_OPTIONAL,2);
         this.currency = param1;
         this.amount = param2;
      }
   }
}

