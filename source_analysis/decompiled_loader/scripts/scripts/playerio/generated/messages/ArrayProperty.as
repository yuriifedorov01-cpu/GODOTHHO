package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class ArrayProperty extends Message
   {
      
      public var index:int;
      
      public var value:ValueObject;
      
      public var valueDummy:ValueObject = null;
      
      public function ArrayProperty()
      {
         super();
         registerField("index","",Descriptor.INT32,Descriptor.LABEL_OPTIONAL,1);
         registerField("value","playerio.generated.messages.ValueObject",Descriptor.MESSAGE,Descriptor.LABEL_OPTIONAL,2);
      }
   }
}

