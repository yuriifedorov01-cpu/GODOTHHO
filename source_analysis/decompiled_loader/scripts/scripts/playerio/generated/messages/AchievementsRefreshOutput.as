package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class AchievementsRefreshOutput extends Message
   {
      
      public var version:String;
      
      public var achievements:Array = [];
      
      public var achievementsDummy:Achievement = null;
      
      public function AchievementsRefreshOutput()
      {
         super();
         registerField("version","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("achievements","playerio.generated.messages.Achievement",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,2);
      }
   }
}

