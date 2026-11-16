package playerio.generated.messages
{
   import com.protobuf.Descriptor;
   import com.protobuf.Message;
   
   public final class Achievement extends Message
   {
      
      public var identifier:String;
      
      public var title:String;
      
      public var description:String;
      
      public var imageUrl:String;
      
      public var progressGoal:uint;
      
      public var progress:uint;
      
      public var lastUpdated:Number;
      
      public function Achievement()
      {
         super();
         registerField("identifier","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,1);
         registerField("title","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,2);
         registerField("description","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,3);
         registerField("imageUrl","",Descriptor.STRING,Descriptor.LABEL_OPTIONAL,4);
         registerField("progressGoal","",Descriptor.UINT,Descriptor.LABEL_OPTIONAL,5);
         registerField("progress","",Descriptor.UINT,Descriptor.LABEL_OPTIONAL,6);
         registerField("lastUpdated","",Descriptor.LONG,Descriptor.LABEL_OPTIONAL,7);
      }
   }
}

