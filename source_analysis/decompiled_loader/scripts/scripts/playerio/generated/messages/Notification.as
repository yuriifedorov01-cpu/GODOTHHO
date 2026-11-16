package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class Notification extends Message
   {
      
      public var recipient:String;
      
      public var endpointType:String;
      
      public var oldKeyValueData:Array = [];
      
      public var oldKeyValueDataDummy:KeyValuePair = null;
      
      public var data:Array = [];
      
      public var dataDummy:ObjectProperty = null;
      
      public function Notification()
      {
         super();
         registerField("recipient","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("endpointType","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,2);
         registerField("oldKeyValueData","playerio.generated.messages.KeyValuePair",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,3);
         registerField("data","playerio.generated.messages.ObjectProperty",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,4);
      }
   }
}

