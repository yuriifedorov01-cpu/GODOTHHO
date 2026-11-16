package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class CreateRoomOutput extends Message
   {
      
      public var roomId:String;
      
      public function CreateRoomOutput()
      {
         super();
         registerField("roomId","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
      }
   }
}

