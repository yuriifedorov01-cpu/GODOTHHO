package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   import flash.utils.ByteArray;
   
   public final class SimpleUserGetSecureLoginInfoOutput extends Message
   {
      
      public var publicKey:ByteArray;
      
      public var nonce:String;
      
      public function SimpleUserGetSecureLoginInfoOutput()
      {
         super();
         registerField("publicKey","",Descriptor.BYTEARRAY,Descriptor.LABEL_OPTIONAL,1);
         registerField("nonce","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,2);
      }
   }
}

