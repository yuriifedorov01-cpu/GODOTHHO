package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class PlayerInsightState extends Message
   {
      
      public var playersOnline:int;
      
      public var segments:Array = [];
      
      public var segmentsDummy:KeyValuePair = null;
      
      public function PlayerInsightState()
      {
         super();
         registerField("playersOnline","",Descriptor.INT32,Descriptor.LABEL_OPTIONAL,1);
         registerField("segments","playerio.generated.messages.KeyValuePair",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,2);
      }
   }
}

