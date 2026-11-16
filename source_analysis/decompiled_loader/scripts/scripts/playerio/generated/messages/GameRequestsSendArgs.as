package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class GameRequestsSendArgs extends Message
   {
      
      public var requestType:String;
      
      public var requestData:Array = [];
      
      public var requestDataDummy:KeyValuePair = null;
      
      public var requestRecipients:Array = [];
      
      public function GameRequestsSendArgs(param1:String, param2:Array, param3:Array)
      {
         super();
         registerField("requestType","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("requestData","playerio.generated.messages.KeyValuePair",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,2);
         registerField("requestRecipients","",Descriptor.STRING,Descriptor.LABEL_REPEATED,3);
         this.requestType = param1;
         this.requestData = param2;
         this.requestRecipients = param3;
      }
   }
}

