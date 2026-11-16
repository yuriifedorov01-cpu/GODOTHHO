package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class DeleteObjectsError extends Message
   {
      
      public var errorCode:int;
      
      public var message:String;
      
      public function DeleteObjectsError()
      {
         super();
         registerField("errorCode","",Descriptor.INT32,Descriptor.LABEL_OPTIONAL,1);
         registerField("message","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,2);
      }
   }
}

