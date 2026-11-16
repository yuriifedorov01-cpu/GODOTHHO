package com.protobuf
{
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class CodedInputStream
   {
      
      private static const DEFAULT_RECURSION_LIMIT:int = 64;
      
      private static const DEFAULT_SIZE_LIMIT:int = 64 << 20;
      
      private var bufferSize:int;
      
      private var bufferSizeAfterLimit:int = 0;
      
      private var bufferPos:int = 0;
      
      private var input:IDataInput;
      
      private var lastTag:int = 0;
      
      private var sizeLimit:int = DEFAULT_SIZE_LIMIT;
      
      public function CodedInputStream(param1:IDataInput)
      {
         super();
         this.bufferSize = 0;
         this.input = param1;
      }
      
      public static function newInstance(param1:IDataInput) : CodedInputStream
      {
         return new CodedInputStream(param1);
      }
      
      public static function decodeZigZag32(param1:int) : int
      {
         return param1 >>> 1 ^ -(param1 & 1);
      }
      
      public function readTag() : int
      {
         if(this.input.bytesAvailable != 0)
         {
            this.lastTag = this.readRawVarint32();
         }
         else
         {
            this.lastTag = 0;
         }
         return this.lastTag;
      }
      
      public function checkLastTagWas(param1:int) : void
      {
         if(this.lastTag != param1)
         {
            throw InvalidProtocolBufferException.invalidEndTag();
         }
      }
      
      public function skipField(param1:int) : Boolean
      {
         switch(WireFormat.getTagWireType(param1))
         {
            case WireFormat.WIRETYPE_VARINT:
               while(this.input.readUnsignedByte() >= 128)
               {
               }
               return true;
            case WireFormat.WIRETYPE_LENGTH_DELIMITED:
               this.skipRawBytes(this.readRawVarint32());
               return true;
            case WireFormat.WIRETYPE_START_GROUP:
               this.skipMessage();
               this.checkLastTagWas(WireFormat.makeTag(WireFormat.getTagFieldNumber(param1),WireFormat.WIRETYPE_END_GROUP));
               return true;
            case WireFormat.WIRETYPE_END_GROUP:
               return false;
            case WireFormat.WIRETYPE_FIXED32:
               this.readRawLittleEndian32();
               return true;
            default:
               throw InvalidProtocolBufferException.invalidWireType();
         }
      }
      
      public function skipMessage() : void
      {
         var _loc1_:int = 0;
         do
         {
            _loc1_ = this.readTag();
         }
         while(!(_loc1_ == 0 || !this.skipField(_loc1_)));
      }
      
      public function readDouble() : Number
      {
         var _loc1_:int = this.readRawByte();
         var _loc2_:int = this.readRawByte();
         var _loc3_:int = this.readRawByte();
         var _loc4_:int = this.readRawByte();
         var _loc5_:int = this.readRawByte();
         var _loc6_:int = this.readRawByte();
         var _loc7_:int = this.readRawByte();
         var _loc8_:int = this.readRawByte();
         var _loc9_:ByteArray = new ByteArray();
         _loc9_.writeByte(_loc8_);
         _loc9_.writeByte(_loc7_);
         _loc9_.writeByte(_loc6_);
         _loc9_.writeByte(_loc5_);
         _loc9_.writeByte(_loc4_);
         _loc9_.writeByte(_loc3_);
         _loc9_.writeByte(_loc2_);
         _loc9_.writeByte(_loc1_);
         _loc9_.position = 0;
         return _loc9_.readDouble();
      }
      
      public function readFloat() : Number
      {
         var _loc1_:int = this.readRawByte();
         var _loc2_:int = this.readRawByte();
         var _loc3_:int = this.readRawByte();
         var _loc4_:int = this.readRawByte();
         var _loc5_:ByteArray = new ByteArray();
         _loc5_.writeByte(_loc4_);
         _loc5_.writeByte(_loc3_);
         _loc5_.writeByte(_loc2_);
         _loc5_.writeByte(_loc1_);
         _loc5_.position = 0;
         return _loc5_.readFloat();
      }
      
      public function readInt32() : int
      {
         return this.readRawVarint32();
      }
      
      public function readFixed32() : int
      {
         return this.readRawLittleEndian32();
      }
      
      public function readBool() : Boolean
      {
         return this.readRawVarint32() != 0;
      }
      
      public function readString() : String
      {
         var _loc1_:int = this.readRawVarint32();
         return new String(this.readRawBytes(_loc1_));
      }
      
      public function readBytes() : ByteArray
      {
         var _loc1_:int = this.readRawVarint32();
         return this.readRawBytes(_loc1_);
      }
      
      public function readUInt32() : int
      {
         return this.readRawVarint32();
      }
      
      public function readEnum() : int
      {
         return this.readRawVarint32();
      }
      
      public function readSFixed32() : int
      {
         return this.readRawLittleEndian32();
      }
      
      public function readSInt32() : int
      {
         return decodeZigZag32(this.readRawVarint32());
      }
      
      public function readPrimitiveField(param1:int) : Object
      {
         switch(param1)
         {
            case Descriptor.DOUBLE:
               return this.readDouble();
            case Descriptor.FLOAT:
               return this.readFloat();
            case Descriptor.INT32:
               return this.readInt32();
            case Descriptor.FIXED32:
               return this.readFixed32();
            case Descriptor.BOOL:
               return this.readBool();
            case Descriptor.STRING:
               return this.readString();
            case Descriptor.BYTEARRAY:
               return this.readBytes();
            case Descriptor.UINT:
               return this.readUInt32();
            case Descriptor.SFIXED32:
               return this.readSFixed32();
            case Descriptor.SINT32:
               return this.readSInt32();
            case Descriptor.ENUM:
               return this.readEnum();
            case Descriptor.LONG:
               return this.readInt64();
            default:
               trace("Unknown primative field type: " + param1);
               return null;
         }
      }
      
      public function readInt64() : Number
      {
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc1_:Number = this.input.readUnsignedByte();
         var _loc2_:* = 0;
         var _loc3_:Array = [];
         while(_loc1_ >= 128)
         {
            var _loc10_:Number;
            _loc3_[_loc10_ = _loc2_++] = _loc1_ & 0x7F;
            _loc1_ = this.input.readUnsignedByte();
         }
         _loc3_[_loc10_ = _loc2_++] = _loc1_;
         var _loc4_:Boolean = false;
         if(_loc3_.length == 10)
         {
            _loc4_ = true;
            _loc3_.pop();
            --_loc3_[0];
            _loc8_ = 0;
            while(_loc3_[_loc8_] < 0)
            {
               _loc3_[_loc8_] = 127;
               --_loc3_[_loc8_ + 1];
            }
            _loc9_ = 0;
            while(_loc9_ < _loc3_.length)
            {
               _loc3_[_loc9_] = 0x7F ^ _loc3_[_loc9_];
               _loc9_++;
            }
         }
         var _loc5_:Number = 0;
         var _loc6_:Number = 1;
         var _loc7_:int = 0;
         while(_loc7_ < _loc3_.length)
         {
            _loc5_ += _loc3_[_loc7_] * _loc6_;
            _loc6_ *= 128;
            _loc7_++;
         }
         return _loc4_ ? -_loc5_ : _loc5_;
      }
      
      public function readRawVarint32() : int
      {
         var _loc3_:int = 0;
         var _loc1_:int = this.readRawByte();
         if(_loc1_ >= 0)
         {
            return _loc1_;
         }
         var _loc2_:int = _loc1_ & 0x7F;
         _loc1_ = this.readRawByte();
         if(_loc1_ >= 0)
         {
            _loc2_ |= _loc1_ << 7;
         }
         else
         {
            _loc2_ |= (_loc1_ & 0x7F) << 7;
            _loc1_ = this.readRawByte();
            if(_loc1_ >= 0)
            {
               _loc2_ |= _loc1_ << 14;
            }
            else
            {
               _loc2_ |= (_loc1_ & 0x7F) << 14;
               _loc1_ = this.readRawByte();
               if(_loc1_ >= 0)
               {
                  _loc2_ |= _loc1_ << 21;
               }
               else
               {
                  _loc2_ |= (_loc1_ & 0x7F) << 21;
                  _loc2_ |= (_loc1_ = this.readRawByte()) << 28;
                  if(_loc1_ < 0)
                  {
                     _loc3_ = 0;
                     while(_loc3_ < 5)
                     {
                        if(this.readRawByte() >= 0)
                        {
                           return _loc2_;
                        }
                        _loc3_++;
                     }
                     throw InvalidProtocolBufferException.malformedVarint();
                  }
               }
            }
         }
         return _loc2_;
      }
      
      public function readRawLittleEndian32() : int
      {
         var _loc1_:int = this.readRawByte();
         var _loc2_:int = this.readRawByte();
         var _loc3_:int = this.readRawByte();
         var _loc4_:int = this.readRawByte();
         return _loc1_ & 0xFF | (_loc2_ & 0xFF) << 8 | (_loc3_ & 0xFF) << 16 | (_loc4_ & 0xFF) << 24;
      }
      
      public function readRawByte() : int
      {
         return this.input.readByte();
      }
      
      public function readRawBytes(param1:int) : ByteArray
      {
         if(param1 < 0)
         {
            throw InvalidProtocolBufferException.negativeSize();
         }
         var _loc2_:ByteArray = new ByteArray();
         if(param1 != 0)
         {
            this.input.readBytes(_loc2_,0,param1);
         }
         return _loc2_;
      }
      
      public function skipRawBytes(param1:int) : void
      {
         this.readRawBytes(param1);
      }
   }
}

