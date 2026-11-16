package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class KeyValuePair extends Message
   {
      
      public var key:String;
      
      public var value:String;
      
      public function KeyValuePair()
      {
         super();
         registerField("key","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("value","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,2);
      }
   }
}

