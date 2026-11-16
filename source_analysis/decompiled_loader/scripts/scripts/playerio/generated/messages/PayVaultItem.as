package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class PayVaultItem extends Message
   {
      
      public var id:String;
      
      public var itemKey:String;
      
      public var purchaseDate:Number;
      
      public var properties:Array = [];
      
      public var propertiesDummy:ObjectProperty = null;
      
      public function PayVaultItem()
      {
         super();
         registerField("id","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("itemKey","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,2);
         registerField("purchaseDate","",Descriptor.LONG,Descriptor.LABEL_OPTIONAL,3);
         registerField("properties","playerio.generated.messages.ObjectProperty",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,4);
      }
   }
}

