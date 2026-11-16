package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class LoadIndexRangeOutput extends Message
   {
      
      public var objects:Array = [];
      
      public var objectsDummy:BigDBObject = null;
      
      public function LoadIndexRangeOutput()
      {
         super();
         registerField("objects","playerio.generated.messages.BigDBObject",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,1);
      }
   }
}

