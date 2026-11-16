package com.protobuf
{
   import flash.utils.*;
   
   public class CodedInputStream
   {
      
      private static const DEFAULT_RECURSION_LIMIT:int = 64;
      
      private static const DEFAULT_SIZE_LIMIT:int = 67108864;
      
      private var bufferSize:int;
      
      private var bufferSizeAfterLimit:int = 0;
      
      private var bufferPos:int = 0;
      
      private var input:IDataInput;
      
      private var lastTag:int = 0;
      
      private var sizeLimit:int = 67108864;
      
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
            case 0:
               while(this.input.readUnsignedByte() >= 128)
               {
               }
               return true;
            case 2:
               this.skipRawBytes(this.readRawVarint32());
               return true;
            case 3:
               this.skipMessage();
               this.checkLastTagWas(WireFormat.makeTag(WireFormat.getTagFieldNumber(param1),4));
               return true;
            case 4:
               return false;
            case 5:
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
         switch(param1 - 1)
         {
            case 0:
               return this.readDouble();
            case 1:
               return this.readFloat();
            case 2:
               return this.readInt64();
            case 4:
               return this.readInt32();
            case 6:
               return this.readFixed32();
            case 7:
               return this.readBool();
            case 8:
               return this.readString();
            case 11:
               return this.readBytes();
            case 12:
               return this.readUInt32();
            case 13:
               return this.readEnum();
            case 14:
               return this.readSFixed32();
            case 16:
               return this.readSInt32();
            default:
               return null;
         }
      }
      
      public function readInt64() : Number
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = Number(this.input.readUnsignedByte());
         var _loc5_:* = 0;
         var _loc6_:Array = [];
         while(_loc4_ >= 128)
         {
            _loc6_[_loc5_++] = _loc4_ & 0x7F;
            _loc4_ = Number(this.input.readUnsignedByte());
         }
         _loc6_[_loc5_++] = _loc4_;
         var _loc7_:Boolean = false;
         if(_loc6_.length == 10)
         {
            _loc7_ = true;
            _loc6_.pop();
            --_loc6_[0];
            _loc1_ = 0;
            while(_loc6_[_loc1_] < 0)
            {
               _loc6_[_loc1_] = 127;
               --_loc6_[_loc1_ + 1];
            }
            _loc2_ = 0;
            while(_loc2_ < _loc6_.length)
            {
               _loc6_[_loc2_] = 0x7F ^ _loc6_[_loc2_];
               _loc2_++;
            }
         }
         var _loc8_:Number = 0;
         var _loc9_:Number = 1;
         _loc3_ = 0;
         while(_loc3_ < _loc6_.length)
         {
            _loc8_ += _loc6_[_loc3_] * _loc9_;
            _loc9_ *= 128;
            _loc3_++;
         }
         return _loc7_ ? -_loc8_ : _loc8_;
      }
      
      public function readRawVarint32() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = this.readRawByte();
         if(_loc2_ >= 0)
         {
            return _loc2_;
         }
         var _loc3_:int = _loc2_ & 0x7F;
         _loc2_ = this.readRawByte();
         if(_loc2_ >= 0)
         {
            _loc3_ |= _loc2_ << 7;
         }
         else
         {
            _loc3_ |= (_loc2_ & 0x7F) << 7;
            _loc2_ = this.readRawByte();
            if(_loc2_ >= 0)
            {
               _loc3_ |= _loc2_ << 14;
            }
            else
            {
               _loc3_ |= (_loc2_ & 0x7F) << 14;
               _loc2_ = this.readRawByte();
               if(_loc2_ >= 0)
               {
                  _loc3_ |= _loc2_ << 21;
               }
               else
               {
                  _loc3_ |= (_loc2_ & 0x7F) << 21;
                  _loc3_ |= (_loc2_ = this.readRawByte()) << 28;
                  if(_loc2_ < 0)
                  {
                     _loc1_ = 0;
                     while(_loc1_ < 5)
                     {
                        if(this.readRawByte() >= 0)
                        {
                           return _loc3_;
                        }
                        _loc1_++;
                     }
                     throw InvalidProtocolBufferException.malformedVarint();
                  }
               }
            }
         }
         return _loc3_;
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

