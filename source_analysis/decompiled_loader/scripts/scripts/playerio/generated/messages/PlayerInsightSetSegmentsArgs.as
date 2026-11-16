package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class PlayerInsightSetSegmentsArgs extends Message
   {
      
      public var segments:Array = [];
      
      public function PlayerInsightSetSegmentsArgs(param1:Array)
      {
         super();
         registerField("segments","",Descriptor.STRING,Descriptor.LABEL_REPEATED,1);
         this.segments = param1;
      }
   }
}

