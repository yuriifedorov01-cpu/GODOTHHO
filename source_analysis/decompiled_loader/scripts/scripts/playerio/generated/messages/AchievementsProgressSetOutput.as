package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class AchievementsProgressSetOutput extends Message
   {
      
      public var achievement:Achievement;
      
      public var achievementDummy:Achievement = null;
      
      public var completedNow:Boolean;
      
      public function AchievementsProgressSetOutput()
      {
         super();
         registerField("achievement","playerio.generated.messages.Achievement",Descriptor.MESSAGE,Descriptor.LABEL_OPTIONAL,1);
         registerField("completedNow","",Descriptor.BOOL,Descriptor.LABEL_OPTIONAL,2);
      }
   }
}

