package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class PlayerInsightEvent extends Message
   {
      
      public var eventType:String;
      
      public var value:int;
      
      public function PlayerInsightEvent()
      {
         super();
         registerField("eventType","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("value","",Descriptor.INT32,Descriptor.LABEL_OPTIONAL,2);
      }
   }
}

