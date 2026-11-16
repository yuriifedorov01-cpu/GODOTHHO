package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class SaveObjectChangesOutput extends Message
   {
      
      public var versions:Array = [];
      
      public function SaveObjectChangesOutput()
      {
         super();
         registerField("versions","",Descriptor.STRING,Descriptor.LABEL_REPEATED,1);
      }
   }
}

