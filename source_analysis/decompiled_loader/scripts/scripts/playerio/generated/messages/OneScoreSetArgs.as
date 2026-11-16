package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class OneScoreSetArgs extends Message
   {
      
      public var score:int;
      
      public function OneScoreSetArgs(param1:int)
      {
         super();
         registerField("score","",Descriptor.INT32,Descriptor.LABEL_OPTIONAL,1);
         this.score = param1;
      }
   }
}

