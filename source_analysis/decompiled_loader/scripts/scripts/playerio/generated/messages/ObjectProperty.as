package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class ObjectProperty extends Message
   {
      
      public var name:String;
      
      public var value:ValueObject;
      
      public var valueDummy:ValueObject = null;
      
      public function ObjectProperty()
      {
         super();
         registerField("name","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("value","playerio.generated.messages.ValueObject",Descriptor.MESSAGE,Descriptor.LABEL_OPTIONAL,2);
      }
   }
}

