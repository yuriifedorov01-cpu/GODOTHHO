package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class LoadObjectsArgs extends Message
   {
      
      public var objectIds:Array = [];
      
      public var objectIdsDummy:BigDBObjectId = null;
      
      public function LoadObjectsArgs(param1:Array)
      {
         super();
         registerField("objectIds","playerio.generated.messages.BigDBObjectId",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,1);
         this.objectIds = param1;
      }
   }
}

