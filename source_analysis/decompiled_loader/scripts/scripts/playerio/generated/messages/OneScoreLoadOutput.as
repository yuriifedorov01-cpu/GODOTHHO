package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class OneScoreLoadOutput extends Message
   {
      
      public var oneScores:Array = [];
      
      public var oneScoresDummy:OneScoreValue = null;
      
      public function OneScoreLoadOutput()
      {
         super();
         registerField("oneScores","playerio.generated.messages.OneScoreValue",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,1);
      }
   }
}

