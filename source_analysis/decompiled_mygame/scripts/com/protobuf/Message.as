package com.protobuf
{
   import flash.utils.*;
   
   public class Message
   {
      
      protected var fieldDescriptors:Array;
      
      public function Message()
      {
         super();
         if(this.fieldDescriptors == null)
         {
            this.fieldDescriptors = [];
         }
      }
      
      public function writeToCodedStream(param1:CodedOutputStream) : void
      {
         var _loc2_:Descriptor = null;
         var _loc3_:* = undefined;
         for each(_loc2_ in this.fieldDescriptors)
         {
            if(this[_loc2_.fieldName] == null)
            {
               if(_loc2_.isRequired())
               {
               }
            }
            else if(_loc2_.isRepeated() && this[_loc2_.fieldName] is Array)
            {
               for each(_loc3_ in this[_loc2_.fieldName])
               {
                  if(_loc2_.isMessage())
                  {
                     param1.writeMessage(_loc2_.fieldNumber,_loc3_);
                  }
                  else
                  {
                     param1.writeField(_loc2_.fieldNumber,_loc3_,_loc2_.type);
                  }
               }
            }
            else if(_loc2_.isMessage())
            {
               if(this[_loc2_.fieldName] is Message)
               {
                  param1.writeMessage(_loc2_.fieldNumber,this[_loc2_.fieldName]);
               }
            }
            else
            {
               param1.writeField(_loc2_.fieldNumber,this[_loc2_.fieldName],_loc2_.type);
            }
         }
      }
      
      public function writeToDataOutput(param1:IDataOutput) : void
      {
         var _loc2_:CodedOutputStream = CodedOutputStream.newInstance(param1);
         this.writeToCodedStream(_loc2_);
      }
      
      public function readFromCodedStream(param1:CodedInputStream) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Descriptor = null;
         var _loc4_:* = undefined;
         var _loc5_:Class = null;
         var _loc6_:int = 0;
         var _loc7_:ByteArray = null;
         var _loc8_:int = param1.readTag();
         while(_loc8_ != 0)
         {
            _loc2_ = int(WireFormat.getTagFieldNumber(_loc8_));
            _loc3_ = this.getDescriptorByFieldNumber(_loc2_);
            if(_loc3_ != null)
            {
               if(_loc3_.isMessage())
               {
                  _loc5_ = getDefinitionByName(_loc3_.messageClass) as Class;
                  _loc4_ = new _loc5_();
                  _loc6_ = param1.readRawVarint32();
                  _loc7_ = param1.readRawBytes(_loc6_);
                  _loc7_.position = 0;
                  _loc4_.readFromDataOutput(_loc7_);
               }
               else
               {
                  _loc4_ = param1.readPrimitiveField(_loc3_.type);
               }
               if(_loc3_.isRepeated() && this[_loc3_.fieldName] is Array)
               {
                  this[_loc3_.fieldName].push(_loc4_);
               }
               else
               {
                  this[_loc3_.fieldName] = _loc4_;
               }
            }
            else
            {
               param1.skipField(_loc8_);
            }
            _loc8_ = param1.readTag();
         }
      }
      
      public function readFromDataOutput(param1:IDataInput) : void
      {
         var _loc2_:CodedInputStream = CodedInputStream.newInstance(param1);
         this.readFromCodedStream(_loc2_);
      }
      
      public function getSerializedSize() : int
      {
         var _loc2_:Descriptor = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.fieldDescriptors)
         {
            if(this[_loc2_.fieldName] != null)
            {
               _loc1_ += CodedOutputStream.computeFieldSize(_loc2_.fieldNumber,this[_loc2_.fieldName],_loc2_.type);
            }
         }
         return _loc1_;
      }
      
      protected function registerField(param1:String, param2:String, param3:int, param4:int, param5:int) : void
      {
         if(this.fieldDescriptors[param1] == null)
         {
            this.fieldDescriptors[param1] = new Descriptor(param1,param2,param3,param4,param5);
         }
      }
      
      public function getDescriptorByFieldNumber(param1:int) : Descriptor
      {
         var _loc2_:Descriptor = null;
         for each(_loc2_ in this.fieldDescriptors)
         {
            if(_loc2_.fieldNumber == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getDescriptor(param1:String) : Descriptor
      {
         return this.fieldDescriptors[param1];
      }
   }
}

