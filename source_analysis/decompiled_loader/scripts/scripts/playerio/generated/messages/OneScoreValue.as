package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class OneScoreValue extends Message
   {
      
      public var userId:String;
      
      public var score:int;
      
      public var percentile:Number;
      
      public var topRank:int;
      
      public function OneScoreValue()
      {
         super();
         registerField("userId","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("score","",Descriptor.INT32,Descriptor.LABEL_OPTIONAL,2);
         registerField("percentile","",Descriptor.FLOAT,Descriptor.LABEL_OPTIONAL,3);
         registerField("topRank","",Descriptor.INT32,Descriptor.LABEL_OPTIONAL,4);
      }
   }
}

