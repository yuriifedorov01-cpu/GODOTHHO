package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class SimpleRecoverPasswordArgs extends Message
   {
      
      public var gameId:String;
      
      public var usernameOrEmail:String;
      
      public function SimpleRecoverPasswordArgs(param1:String, param2:String)
      {
         super();
         registerField("gameId","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("usernameOrEmail","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,2);
         this.gameId = param1;
         this.usernameOrEmail = param2;
      }
   }
}

