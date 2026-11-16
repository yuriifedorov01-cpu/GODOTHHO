package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class SocialLoadProfilesOutput extends Message
   {
      
      public var profiles:Array = [];
      
      public var profilesDummy:SocialProfile = null;
      
      public function SocialLoadProfilesOutput()
      {
         super();
         registerField("profiles","playerio.generated.messages.SocialProfile",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,1);
      }
   }
}

