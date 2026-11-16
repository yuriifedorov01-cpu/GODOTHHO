package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class PlayerInsightTrackEventsArgs extends Message
   {
      
      public var events:Array = [];
      
      public var eventsDummy:PlayerInsightEvent = null;
      
      public function PlayerInsightTrackEventsArgs(param1:Array)
      {
         super();
         registerField("events","playerio.generated.messages.PlayerInsightEvent",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,1);
         this.events = param1;
      }
   }
}

