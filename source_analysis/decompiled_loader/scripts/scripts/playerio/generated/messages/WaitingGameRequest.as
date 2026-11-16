package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class WaitingGameRequest extends Message
   {
      
      public var id:String;
      
      public var type:String;
      
      public var senderUserId:String;
      
      public var created:Number;
      
      public var data:Array = [];
      
      public var dataDummy:KeyValuePair = null;
      
      public function WaitingGameRequest()
      {
         super();
         registerField("id","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("type","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,2);
         registerField("senderUserId","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,3);
         registerField("created","",Descriptor.LONG,Descriptor.LABEL_OPTIONAL,4);
         registerField("data","playerio.generated.messages.KeyValuePair",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,5);
      }
   }
}

