package com.protobuf
{
   import flash.utils.*;
   
   public final class CodedOutputStream
   {
      
      public static const DEFAULT_BUFFER_SIZE:int = 4096;
      
      public static var LITTLE_ENDIAN_32_SIZE:int = 4;
      
      private var limit:int;
      
      private var position:int;
      
      private var output:IDataOutput;
      
      public function CodedOutputStream(param1:IDataOutput)
      {
         super();
         this.output = param1;
         this.limit = 4096;
      }
      
      public static function newInstance(param1:IDataOutput) : CodedOutputStream
      {
         return new CodedOutputStream(param1);
      }
      
      public static function computeVarint64Size(param1:int, param2:Number) : int
      {
         return computeTagSize(param1) + computeRawVarint64Size(param2);
      }
      
      public static function computeRawVarint64Size(param1:Number) : int
      {
         if(param1 < 0)
         {
            return 10;
         }
         var _loc2_:int = 1;
         while(param1 > 128)
         {
            param1 = Math.floor(param1 / 128);
            _loc2_++;
         }
         return _loc2_;
      }
      
      public static function computeFieldSize(param1:int, param2:*, param3:int) : int
      {
         if(param2 is String)
         {
            return computeStringSize(param1,param2 as String);
         }
         if(param2 is Boolean)
         {
            return computeBoolSize(param1,param2 as Boolean);
         }
         if(param2 is Number && param3 == 13)
         {
            return computeUInt32Size(param1,param2 as uint);
         }
         if(param2 is Number && param3 == 5)
         {
            return computeInt32Size(param1,param2 as int);
         }
         if(param2 is Number && param3 == 2)
         {
            return computeFloatSize(param1,param2 as Number);
         }
         if(param2 is Number && param3 == 1)
         {
            return computeDoubleSize(param1,param2 as Number);
         }
         if(param2 is Number && param3 == 3)
         {
            return computeVarint64Size(param1,param2 as Number);
         }
         if(param2 is Number)
         {
            return computeInt32Size(param1,param2 as Number);
         }
         if(param2 is Message)
         {
            return param2.getSerializedSize();
         }
         throw new InvalidProtocolBufferException("Could not compute size of field, type was not valid");
      }
      
      public static function computeDoubleSize(param1:int, param2:Number) : int
      {
         return computeTagSize(param1) + LITTLE_ENDIAN_32_SIZE;
      }
      
      public static function computeFloatSize(param1:int, param2:Number) : int
      {
         return computeTagSize(param1) + LITTLE_ENDIAN_32_SIZE;
      }
      
      public static function computeInt32Size(param1:int, param2:int) : int
      {
         if(param2 >= 0)
         {
            return computeTagSize(param1) + computeRawVarint32Size(param2);
         }
         return computeTagSize(param1) + 10;
      }
      
      public static function computeFixed32Size(param1:int, param2:int) : int
      {
         return computeTagSize(param1) + LITTLE_ENDIAN_32_SIZE;
      }
      
      public static function computeBoolSize(param1:int, param2:Boolean) : int
      {
         return computeTagSize(param1) + 1;
      }
      
      public static function computeStringSize(param1:int, param2:String) : int
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeUTFBytes(param2);
         return computeTagSize(param1) + computeRawVarint32Size(_loc3_.length) + _loc3_.length;
      }
      
      public static function computeGroupSize(param1:int, param2:Message) : int
      {
         return computeTagSize(param1) * 2 + param2.getSerializedSize();
      }
      
      public static function computeMessageSize(param1:int, param2:Message) : int
      {
         var _loc3_:int = param2.getSerializedSize();
         return computeTagSize(param1) + computeRawVarint32Size(_loc3_) + _loc3_;
      }
      
      public static function computeBytesSize(param1:int, param2:ByteArray) : int
      {
         var _loc3_:int = int(param2.length);
         return computeTagSize(param1) + computeRawVarint32Size(_loc3_) + _loc3_;
      }
      
      public static function computeUInt32Size(param1:int, param2:int) : int
      {
         return computeTagSize(param1) + computeRawVarint32Size(param2);
      }
      
      public static function computeEnumSize(param1:int, param2:int) : int
      {
         return computeTagSize(param1) + computeRawVarint32Size(param2);
      }
      
      public static function computeSFixed32Size(param1:int, param2:int) : int
      {
         return computeTagSize(param1) + LITTLE_ENDIAN_32_SIZE;
      }
      
      public static function computeSInt32Size(param1:int, param2:int) : int
      {
         return computeTagSize(param1) + computeRawVarint32Size(encodeZigZag32(param2));
      }
      
      public static function computeMessageSetExtensionSize(param1:int, param2:Message) : int
      {
         return computeTagSize(1) * 2 + computeUInt32Size(2,param1) + computeMessageSize(3,param2);
      }
      
      public static function computeRawMessageSetExtensionSize(param1:int, param2:String) : int
      {
         var _loc3_:* = null;
         _loc3_.writeUTFBytes(param2);
         return computeTagSize(1) * 2 + computeUInt32Size(2,param1) + computeBytesSize(3,_loc3_);
      }
      
      public static function computeTagSize(param1:int) : int
      {
         return computeRawVarint32Size(WireFormat.makeTag(param1,0));
      }
      
      public static function computeRawVarint32Size(param1:int) : int
      {
         if((param1 & -128) == 0)
         {
            return 1;
         }
         if((param1 & -16384) == 0)
         {
            return 2;
         }
         if((param1 & -2097152) == 0)
         {
            return 3;
         }
         if((param1 & -268435456) == 0)
         {
            return 4;
         }
         return 5;
      }
      
      public static function encodeZigZag32(param1:int) : int
      {
         return param1 << 1 ^ param1 >> 31;
      }
      
      public function writeVariableInt64(param1:int, param2:Number) : void
      {
         this.writeTag(param1,0);
         this.writeRawVariableInt64(param2);
      }
      
      public function writeRawVariableInt64(param1:Number) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Number = Number(NaN);
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(param1 < 0)
         {
            param1 = Math.abs(param1);
            _loc2_ = [0,0,0,0,0,0,0,0,0];
            _loc3_ = [127,127,127,127,127,127,127,127,127,1];
            _loc4_ = 0;
            while(param1 >= 128)
            {
               _loc2_[_loc4_++] = param1 & 0x7F;
               param1 = Math.floor(param1 / 128);
            }
            _loc2_[_loc4_++] = param1 & 0x7F;
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length)
            {
               _loc3_[_loc5_] ^= _loc2_[_loc5_];
               _loc5_++;
            }
            ++_loc3_[0];
            _loc6_ = 0;
            while(_loc3_[_loc6_] > 127)
            {
               _loc3_[_loc6_] = 0;
               ++_loc3_[_loc6_ + 1];
            }
            _loc7_ = 0;
            while(_loc7_ < _loc3_.length - 1)
            {
               _loc3_[_loc7_] |= 128;
               _loc7_++;
            }
            _loc8_ = 0;
            while(_loc8_ < _loc3_.length)
            {
               this.writeRawByte(_loc3_[_loc8_]);
               _loc8_++;
            }
         }
         else
         {
            while(param1 >= 128)
            {
               _loc9_ = param1 & 0x7F | 0x80;
               this.writeRawByte(_loc9_);
               param1 = Math.floor(param1 / 128);
            }
            this.writeRawByte(param1);
         }
      }
      
      public function writeDouble(param1:int, param2:Number) : void
      {
         this.writeTag(param1,1);
         this.writeRawDouble(param2);
      }
      
      public function writeRawDouble(param1:Number) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeDouble(param1);
         _loc2_.position = 0;
         var _loc3_:int = _loc2_.readByte();
         var _loc4_:int = _loc2_.readByte();
         var _loc5_:int = _loc2_.readByte();
         var _loc6_:int = _loc2_.readByte();
         var _loc7_:int = _loc2_.readByte();
         var _loc8_:int = _loc2_.readByte();
         var _loc9_:int = _loc2_.readByte();
         var _loc10_:int = _loc2_.readByte();
         this.writeRawByte(_loc10_);
         this.writeRawByte(_loc9_);
         this.writeRawByte(_loc8_);
         this.writeRawByte(_loc7_);
         this.writeRawByte(_loc6_);
         this.writeRawByte(_loc5_);
         this.writeRawByte(_loc4_);
         this.writeRawByte(_loc3_);
      }
      
      public function writeFloat(param1:int, param2:Number) : void
      {
         this.writeTag(param1,5);
         this.writeRawFloat(param2);
      }
      
      public function writeRawFloat(param1:Number) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeFloat(param1);
         _loc2_.position = 0;
         var _loc3_:int = _loc2_.readByte();
         var _loc4_:int = _loc2_.readByte();
         var _loc5_:int = _loc2_.readByte();
         var _loc6_:int = _loc2_.readByte();
         this.writeRawByte(_loc6_);
         this.writeRawByte(_loc5_);
         this.writeRawByte(_loc4_);
         this.writeRawByte(_loc3_);
      }
      
      public function writeInt32(param1:int, param2:Number) : void
      {
         this.writeTag(param1,0);
         this.writeRawVarint32(param2);
      }
      
      public function writeFixed32(param1:int, param2:int) : void
      {
         this.writeTag(param1,5);
         this.writeRawLittleEndian32(param2);
      }
      
      public function writeBool(param1:int, param2:Boolean) : void
      {
         this.writeTag(param1,0);
         this.writeRawByte(param2 ? 1 : 0);
      }
      
      public function writeString(param1:int, param2:String) : void
      {
         this.writeTag(param1,2);
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeUTFBytes(param2);
         this.writeRawVarint32(_loc3_.length);
         this.writeRawBytes(_loc3_);
      }
      
      public function writeMessage(param1:int, param2:Message) : void
      {
         this.writeTag(param1,2);
         var _loc3_:ByteArray = new ByteArray();
         param2.writeToDataOutput(_loc3_);
         _loc3_.position = 0;
         this.writeRawVarint32(_loc3_.length);
         this.output.writeBytes(_loc3_,0,_loc3_.length);
      }
      
      public function writeBytes(param1:int, param2:ByteArray) : void
      {
         this.writeTag(param1,2);
         param2.position = 0;
         this.writeRawVarint32(param2.length);
         this.writeRawBytes(param2);
      }
      
      public function writeUInt32(param1:int, param2:int) : void
      {
         this.writeTag(param1,0);
         this.writeRawVarint32(param2);
      }
      
      public function writeEnum(param1:int, param2:int) : void
      {
         this.writeTag(param1,0);
         this.writeRawVarint32(param2);
      }
      
      public function writeSFixed32(param1:int, param2:int) : void
      {
         this.writeTag(param1,5);
         this.writeRawLittleEndian32(param2);
      }
      
      public function writeSInt32(param1:int, param2:int) : void
      {
         this.writeTag(param1,0);
         this.writeRawVarint32(encodeZigZag32(param2));
      }
      
      public function writeField(param1:int, param2:*, param3:int) : void
      {
         if(param2 is String)
         {
            this.writeString(param1,param2 as String);
         }
         else if(param2 is Boolean)
         {
            this.writeBool(param1,param2 as Boolean);
         }
         else if(param2 is Number && param3 == 13)
         {
            this.writeUInt32(param1,param2 as uint);
         }
         else if(param2 is int && param3 == 5)
         {
            this.writeInt32(param1,param2 as int);
         }
         else if(param2 is Number && param3 == 2)
         {
            this.writeFloat(param1,param2 as Number);
         }
         else if(param2 is Number && param3 == 1)
         {
            this.writeDouble(param1,param2 as Number);
         }
         else if(param2 is Number && param3 == 3)
         {
            this.writeVariableInt64(param1,param2 as Number);
         }
         else if(param2 is Number)
         {
            this.writeInt32(param1,param2 as Number);
         }
         else
         {
            if(!(param2 is ByteArray))
            {
               throw new InvalidProtocolBufferException("Tried to write primative field type, but type was not valid");
            }
            this.writeBytes(param1,param2 as ByteArray);
         }
      }
      
      public function writeRawByte(param1:int) : void
      {
         this.output.writeByte(param1);
      }
      
      public function writeRawBytes(param1:ByteArray) : void
      {
         this.writeRawBytesPartial(param1,0,param1.length);
      }
      
      public function writeRawBytesPartial(param1:ByteArray, param2:int, param3:int) : void
      {
         this.output.writeBytes(param1,param2,param3);
      }
      
      public function writeTag(param1:int, param2:int) : void
      {
         this.writeRawVarint32(WireFormat.makeTag(param1,param2));
      }
      
      public function writeRawVarint32(param1:int) : void
      {
         while((param1 & -128) != 0)
         {
            this.writeRawByte(param1 & 0x7F | 0x80);
            param1 >>>= 7;
         }
         this.writeRawByte(param1);
      }
      
      public function writeRawLittleEndian32(param1:int) : void
      {
         this.writeRawByte(param1 & 0xFF);
         this.writeRawByte(param1 >> 8 & 0xFF);
         this.writeRawByte(param1 >> 16 & 0xFF);
         this.writeRawByte(param1 >> 24 & 0xFF);
      }
   }
}

