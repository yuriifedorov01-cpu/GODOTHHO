package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class SimpleGetCaptchaOutput extends Message
   {
      
      public var captchaKey:String;
      
      public var captchaImageUrl:String;
      
      public function SimpleGetCaptchaOutput()
      {
         super();
         registerField("captchaKey","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("captchaImageUrl","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,2);
      }
   }
}

