package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class UserAchievements extends Message
   {
      
      public var userId:String;
      
      public var achievements:Array = [];
      
      public var achievementsDummy:Achievement = null;
      
      public function UserAchievements()
      {
         super();
         registerField("userId","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("achievements","playerio.generated.messages.Achievement",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,2);
      }
   }
}

