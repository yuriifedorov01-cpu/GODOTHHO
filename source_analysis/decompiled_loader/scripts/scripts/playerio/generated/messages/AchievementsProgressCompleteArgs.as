package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class AchievementsProgressCompleteArgs extends Message
   {
      
      public var achievementId:String;
      
      public function AchievementsProgressCompleteArgs(param1:String)
      {
         super();
         registerField("achievementId","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         this.achievementId = param1;
      }
   }
}

