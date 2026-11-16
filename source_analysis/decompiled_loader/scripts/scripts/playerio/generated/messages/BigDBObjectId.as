package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class BigDBObjectId extends Message
   {
      
      public var table:String;
      
      public var keys:Array = [];
      
      public function BigDBObjectId()
      {
         super();
         registerField("table","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("keys","",Descriptor.STRING,Descriptor.LABEL_REPEATED,2);
      }
   }
}

