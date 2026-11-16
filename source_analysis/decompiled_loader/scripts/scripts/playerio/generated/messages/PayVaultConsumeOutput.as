package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class PayVaultConsumeOutput extends Message
   {
      
      public var vaultContents:PayVaultContents;
      
      public var vaultContentsDummy:PayVaultContents = null;
      
      public function PayVaultConsumeOutput()
      {
         super();
         registerField("vaultContents","playerio.generated.messages.PayVaultContents",Descriptor.MESSAGE,Descriptor.LABEL_OPTIONAL,1);
      }
   }
}

