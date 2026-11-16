package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class PayVaultContents extends Message
   {
      
      public var version:String;
      
      public var coins:int;
      
      public var items:Array = [];
      
      public var itemsDummy:PayVaultItem = null;
      
      public function PayVaultContents()
      {
         super();
         registerField("version","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("coins","",Descriptor.INT32,Descriptor.LABEL_OPTIONAL,2);
         registerField("items","playerio.generated.messages.PayVaultItem",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,3);
      }
   }
}

