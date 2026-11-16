package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class OneScoreRefreshOutput extends Message
   {
      
      public var oneScore:OneScoreValue;
      
      public var oneScoreDummy:OneScoreValue = null;
      
      public function OneScoreRefreshOutput()
      {
         super();
         registerField("oneScore","playerio.generated.messages.OneScoreValue",Descriptor.MESSAGE,Descriptor.LABEL_OPTIONAL,1);
      }
   }
}

