package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class BigDBObject extends Message
   {
      
      public var key:String;
      
      public var version:String;
      
      public var properties:Array = [];
      
      public var propertiesDummy:ObjectProperty = null;
      
      public var creator:uint;
      
      public function BigDBObject()
      {
         super();
         registerField("key","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("version","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,2);
         registerField("properties","playerio.generated.messages.ObjectProperty",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,3);
         registerField("creator","",Descriptor.UINT,Descriptor.LABEL_OPTIONAL,4);
      }
   }
}

