package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class LoadObjectsOutput extends Message
   {
      
      public var objects:Array = [];
      
      public var objectsDummy:BigDBObject = null;
      
      public function LoadObjectsOutput()
      {
         super();
         registerField("objects","playerio.generated.messages.BigDBObject",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,1);
      }
   }
}

