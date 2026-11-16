package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class PayVaultReadHistoryArgs extends Message
   {
      
      public var page:uint;
      
      public var pageSize:uint;
      
      public var targetUserId:String;
      
      public function PayVaultReadHistoryArgs(param1:uint, param2:uint, param3:String)
      {
         super();
         registerField("page","",Descriptor.UINT,Descriptor.LABEL_OPTIONAL,1);
         registerField("pageSize","",Descriptor.UINT,Descriptor.LABEL_OPTIONAL,2);
         registerField("targetUserId","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,3);
         this.page = param1;
         this.pageSize = param2;
         this.targetUserId = param3;
      }
   }
}

