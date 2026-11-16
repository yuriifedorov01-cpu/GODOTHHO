package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class PayVaultReadHistoryOutput extends Message
   {
      
      public var entries:Array = [];
      
      public var entriesDummy:PayVaultHistoryEntry = null;
      
      public function PayVaultReadHistoryOutput()
      {
         super();
         registerField("entries","playerio.generated.messages.PayVaultHistoryEntry",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,1);
      }
   }
}

