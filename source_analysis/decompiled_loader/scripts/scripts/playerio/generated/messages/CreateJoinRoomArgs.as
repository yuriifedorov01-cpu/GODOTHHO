package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class CreateJoinRoomArgs extends Message
   {
      
      public var roomId:String;
      
      public var roomType:String;
      
      public var visible:Boolean;
      
      public var roomData:Array = [];
      
      public var roomDataDummy:KeyValuePair = null;
      
      public var joinData:Array = [];
      
      public var joinDataDummy:KeyValuePair = null;
      
      public var isDevRoom:Boolean;
      
      public function CreateJoinRoomArgs(param1:String, param2:String, param3:Boolean, param4:Array, param5:Array, param6:Boolean)
      {
         super();
         registerField("roomId","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("roomType","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,2);
         registerField("visible","",Descriptor.BOOL,Descriptor.LABEL_OPTIONAL,3);
         registerField("roomData","playerio.generated.messages.KeyValuePair",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,4);
         registerField("joinData","playerio.generated.messages.KeyValuePair",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,5);
         registerField("isDevRoom","",Descriptor.BOOL,Descriptor.LABEL_OPTIONAL,6);
         this.roomId = param1;
         this.roomType = param2;
         this.visible = param3;
         this.roomData = param4;
         this.joinData = param5;
         this.isDevRoom = param6;
      }
   }
}

