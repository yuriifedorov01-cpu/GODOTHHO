package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class AchievementsLoadArgs extends Message
   {
      
      public var userIds:Array = [];
      
      public function AchievementsLoadArgs(param1:Array)
      {
         super();
         registerField("userIds","",Descriptor.STRING,Descriptor.LABEL_REPEATED,1);
         this.userIds = param1;
      }
   }
}

