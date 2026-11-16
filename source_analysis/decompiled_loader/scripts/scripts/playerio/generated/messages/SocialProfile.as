package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class SocialProfile extends Message
   {
      
      public var userId:String;
      
      public var displayName:String;
      
      public var avatarUrl:String;
      
      public var lastOnline:Number;
      
      public var countryCode:String;
      
      public var userToken:String;
      
      public function SocialProfile()
      {
         super();
         registerField("userId","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("displayName","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,2);
         registerField("avatarUrl","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,3);
         registerField("lastOnline","",Descriptor.LONG,Descriptor.LABEL_OPTIONAL,4);
         registerField("countryCode","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,5);
         registerField("userToken","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,6);
      }
   }
}

