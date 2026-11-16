package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class SaveObjectChangesArgs extends Message
   {
      
      public var lockType:int;
      
      public var changesets:Array = [];
      
      public var changesetsDummy:BigDBChangeset = null;
      
      public var createIfMissing:Boolean;
      
      public function SaveObjectChangesArgs(param1:int, param2:Array, param3:Boolean)
      {
         super();
         registerField("lockType","",Descriptor.ENUM,Descriptor.LABEL_OPTIONAL,1);
         registerField("changesets","playerio.generated.messages.BigDBChangeset",Descriptor.MESSAGE,Descriptor.LABEL_REPEATED,2);
         registerField("createIfMissing","",Descriptor.BOOL,Descriptor.LABEL_OPTIONAL,3);
         this.lockType = param1;
         this.changesets = param2;
         this.createIfMissing = param3;
      }
   }
}

