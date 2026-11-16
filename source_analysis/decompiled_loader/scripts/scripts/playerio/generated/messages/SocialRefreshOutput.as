package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class SocialRefreshOutput extends Message
   {
      
      public var myProfile:SocialProfile;
      
      public var myProfileDummy:SocialProfile = null;
      
      public var friends:Array = [];
      
      public var friendsDummy:SocialProfile = null;
      
      public var blocked:Array = [];
      
      public function SocialRefreshOutput()
      {
         super();
         registerField("myProfile","playerio.generated.messages.SocialProfile",Descriptor.MESSAGE,Descriptor.LABEL_OPTIONAL,1);
         registerField("friends","playerio.generated.messages.SocialProfile",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,2);
         registerField("blocked","",Descriptor.STRING,Descriptor.LABEL_REPEATED,3);
      }
   }
}

