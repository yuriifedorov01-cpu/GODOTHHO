package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class AchievementsProgressMaxArgs extends Message
   {
      
      public var achievementId:String;
      
      public var progress:int;
      
      public function AchievementsProgressMaxArgs(param1:String, param2:int)
      {
         super();
         registerField("achievementId","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("progress","",Descriptor.INT32,Descriptor.LABEL_OPTIONAL,2);
         this.achievementId = param1;
         this.progress = param2;
      }
   }
}

