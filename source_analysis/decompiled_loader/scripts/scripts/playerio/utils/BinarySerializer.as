package playerio.utils
{
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import playerio.Message;
   import playerio.MessageEvent;
   
   public class BinarySerializer extends EventDispatcher
   {
      
      public static const ON_MESSAGE:String = "onmessage";
      
      public static const ShortStringPattern:uint = parseInt("11000000",2);
      
      public static const ShortUnsignedIntPattern:uint = parseInt("10000000",2);
      
      public static const ShortByteArrayPattern:uint = parseInt("01000000",2);
      
      public static const UnsignedLongPattern:uint = parseInt("00111000",2);
      
      public static const LongPattern:uint = parseInt("00110000",2);
      
      public static const ByteArrayPattern:uint = parseInt("00010000",2);
      
      public static const StringPattern:uint = parseInt("00001100",2);
      
      public static const UnsignedIntPattern:uint = parseInt("00001000",2);
      
      public static const IntPattern:uint = parseInt("00000100",2);
      
      public static const DoublePattern:uint = parseInt("00000011",2);
      
      public static const FloatPattern:uint = parseInt("00000010",2);
      
      public static const BooleanTruePattern:uint = parseInt("00000001",2);
      
      public static const BooleanFalsePattern:uint = parseInt("00000000",2);
      
      private var tokens:Array;
      
      private var tokenBuilder:TokenBuilder = null;
      
      private var messageBuilder:MessageBuilder = null;
      
      public function BinarySerializer()
      {
         this.tokens = [];
         super();
         this.tokens.push(new Token(ShortStringPattern,this.readUnsignedInt,function(param1:ByteArray):String
         {
            return param1.readUTFBytes(param1.length);
         }));
         this.tokens.push(new Token(ShortUnsignedIntPattern,this.readUnsignedInt));
         this.tokens.push(new Token(ShortByteArrayPattern,this.readUnsignedInt,function(param1:ByteArray):ByteArray
         {
            return param1;
         }));
         this.tokens.push(new Token(UnsignedLongPattern,this.readLength,function():int
         {
            trace("Longs are unsupported in ActionScript, returning (int)0.");
            return 0;
         }));
         this.tokens.push(new Token(LongPattern,this.readLength,function():int
         {
            trace("Longs are unsupported in ActionScript, returning (int)0.");
            return 0;
         }));
         this.tokens.push(new Token(ByteArrayPattern,this.readLength,this.readUnsignedInt,function(param1:ByteArray):ByteArray
         {
            return param1;
         }));
         this.tokens.push(new Token(StringPattern,this.readLength,this.readUnsignedInt,function(param1:ByteArray):String
         {
            return param1.readUTFBytes(param1.length);
         }));
         this.tokens.push(new Token(UnsignedIntPattern,this.readLength,this.readUnsignedInt));
         this.tokens.push(new Token(IntPattern,this.readLength,function(param1:ByteArray):int
         {
            return readUnsignedInt(param1);
         }));
         this.tokens.push(new Token(DoublePattern,function(param1:ByteArray):int
         {
            return 8;
         },function(param1:ByteArray):Number
         {
            return param1.readDouble();
         }));
         this.tokens.push(new Token(FloatPattern,function(param1:ByteArray):int
         {
            return 4;
         },function(param1:ByteArray):Number
         {
            return param1.readFloat();
         }));
         this.tokens.push(new Token(BooleanTruePattern,function(param1:ByteArray):Boolean
         {
            return true;
         }));
         this.tokens.push(new Token(BooleanFalsePattern,function(param1:ByteArray):Boolean
         {
            return false;
         }));
      }
      
      private function readLength(param1:ByteArray) : uint
      {
         return this.readUnsignedInt(param1) + 1;
      }
      
      private function readUnsignedInt(param1:ByteArray) : uint
      {
         var _loc2_:uint = 0;
         while(param1.position < param1.length)
         {
            _loc2_ = uint(_loc2_ << 8 | param1.readUnsignedByte());
         }
         return _loc2_;
      }
      
      public function AddByte(param1:uint) : void
      {
         var _loc2_:Token = null;
         if(this.tokenBuilder == null)
         {
            for each(_loc2_ in this.tokens)
            {
               if((_loc2_.Type & param1) == _loc2_.Type)
               {
                  this.tokenBuilder = new TokenBuilder(_loc2_);
                  this.tokenBuilder.addEventListener(TokenEvent.ON_VALUE,this.onValue);
                  this.tokenBuilder.AddByte(param1 & ~_loc2_.Type);
                  break;
               }
            }
         }
         else
         {
            this.tokenBuilder.AddByte(param1);
         }
      }
      
      public function AddBytes(param1:ByteArray) : void
      {
         param1.position = 0;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this.AddByte(param1.readUnsignedByte());
            _loc2_++;
         }
      }
      
      public function Serialize(param1:*) : ByteArray
      {
         if(param1 is Number || param1 is Boolean || param1 is String || param1 is ByteArray)
         {
            return this.serialize(param1);
         }
         throw new Error(typeof param1 + " is not yet supported");
      }
      
      public function SerializeMessage(param1:Message) : ByteArray
      {
         var t:ByteArray;
         var ret:ByteArray = null;
         var m:Message = param1;
         ret = new ByteArray();
         var l:ByteArray = this.serialize(m.length);
         ret.writeBytes(l,0,l.length);
         t = this.serialize(m.type);
         ret.writeBytes(t,0,t.length);
         m.clone({"Add":function(param1:*):void
         {
            var _loc2_:* = Serialize(param1);
            ret.writeBytes(_loc2_,0,_loc2_.length);
         }});
         ret.position = 0;
         return ret;
      }
      
      private function serialize(param1:*) : ByteArray
      {
         var _loc3_:ByteArray = null;
         var _loc4_:ByteArray = null;
         var _loc2_:ByteArray = new ByteArray();
         if(param1 is String)
         {
            _loc4_ = new ByteArray();
            _loc4_.writeUTFBytes(param1);
            if(_loc4_.length < 64)
            {
               _loc2_.writeByte(ShortStringPattern | _loc4_.length);
            }
            else
            {
               this.writeHeader(StringPattern,_loc2_,this.getUIntBytes(_loc4_.length));
            }
            _loc2_.writeUTFBytes(param1);
         }
         if(param1 is Boolean)
         {
            _loc2_.writeByte(param1 == true ? int(BooleanTruePattern) : int(BooleanFalsePattern));
         }
         if(param1 is ByteArray)
         {
            param1.position = 0;
            if(param1.length < 64)
            {
               _loc2_.writeByte(ShortByteArrayPattern | param1.length);
            }
            else
            {
               this.writeHeader(ByteArrayPattern,_loc2_,this.getUIntBytes(param1.length));
            }
            _loc2_.writeBytes(param1,0,param1.length);
         }
         if(param1 is Number)
         {
            _loc3_ = new ByteArray();
            _loc3_.writeInt(param1);
            _loc3_.position = 0;
            if(_loc3_.readInt() == param1)
            {
               if(param1 >= 0 && param1 < 64)
               {
                  _loc2_.writeByte(ShortUnsignedIntPattern | param1);
               }
               else
               {
                  this.writeHeader(IntPattern,_loc2_,this.trim(_loc3_));
               }
            }
            else
            {
               _loc3_ = new ByteArray();
               _loc3_.writeUnsignedInt(param1);
               _loc3_.position = 0;
               if(_loc3_.readUnsignedInt() == param1)
               {
                  this.writeHeader(UnsignedIntPattern,_loc2_,this.trim(_loc3_));
               }
               else
               {
                  _loc3_ = new ByteArray();
                  _loc3_.writeFloat(param1);
                  _loc3_.position = 0;
                  if(_loc3_.readFloat() == param1)
                  {
                     _loc2_.writeByte(FloatPattern);
                     _loc2_.writeFloat(param1);
                  }
                  else
                  {
                     _loc2_.writeByte(DoublePattern);
                     _loc2_.writeDouble(param1);
                  }
               }
            }
         }
         _loc2_.position = 0;
         return _loc2_;
      }
      
      private function onMessage(param1:MessageEvent) : void
      {
         this.messageBuilder.removeEventListener(MessageEvent.ON_MESSAGE,this.onMessage);
         this.messageBuilder = null;
         this.dispatchEvent(new MessageEvent(MessageEvent.ON_MESSAGE,param1.message));
      }
      
      private function onValue(param1:TokenEvent) : void
      {
         if(this.messageBuilder == null)
         {
            this.messageBuilder = new MessageBuilder();
            this.messageBuilder.addEventListener(MessageEvent.ON_MESSAGE,this.onMessage);
         }
         this.tokenBuilder.removeEventListener(TokenEvent.ON_VALUE,this.onValue);
         this.tokenBuilder = null;
         this.messageBuilder.AddValue(param1.Value);
      }
      
      private function writeHeader(param1:int, param2:ByteArray, param3:ByteArray) : void
      {
         param2.writeByte(param1 | param3.length - 1);
         param3.position = 0;
         param2.writeBytes(param3,0,param3.length);
      }
      
      private function getUIntBytes(param1:int) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUnsignedInt(param1);
         return this.trim(_loc2_);
      }
      
      private function trim(param1:ByteArray) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.position = 0;
         param1.position = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1.readUnsignedByte() != 0)
            {
               _loc2_.writeBytes(param1,_loc3_,param1.length - _loc3_);
               return _loc2_;
            }
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.ByteArray;
import playerio.Message;
import playerio.MessageEvent;

class MessageBuilder extends EventDispatcher
{
   
   private var message:Message;
   
   private var length:int = -1;
   
   public function MessageBuilder()
   {
      super();
      this.message = new Message("");
   }
   
   public function AddValue(param1:*) : void
   {
      if(this.length == -1)
      {
         this.length = param1;
      }
      else
      {
         if(this.message.type == "")
         {
            this.message.type = param1;
         }
         else
         {
            this.message.add(param1);
         }
         if(this.length == this.message.length)
         {
            dispatchEvent(new MessageEvent(MessageEvent.ON_MESSAGE,this.message));
         }
      }
   }
}

class TokenBuilder extends EventDispatcher
{
   
   private var token:Token;
   
   private var offset:uint = 0;
   
   private var length:uint = 1;
   
   private var tba:ByteArray = new ByteArray();
   
   public function TokenBuilder(param1:Token)
   {
      super();
      this.token = param1;
   }
   
   public function AddByte(param1:int) : void
   {
      this.tba.writeByte(param1);
      if(this.tba.length == this.length)
      {
         this.tba.position = 0;
         if(this.offset == this.token.length - 1)
         {
            dispatchEvent(new TokenEvent(TokenEvent.ON_VALUE,this.token.Handlers[this.token.Handlers.length - 1](this.tba)));
         }
         else
         {
            this.length = this.token.Handlers[this.offset](this.tba);
            this.tba = new ByteArray();
            ++this.offset;
            if(this.length == 0)
            {
               dispatchEvent(new TokenEvent(TokenEvent.ON_VALUE,this.token.Handlers[this.token.Handlers.length - 1](this.tba)));
            }
         }
      }
   }
}

class Token
{
   
   public var Handlers:Array = [];
   
   public var Type:uint;
   
   public function Token(param1:uint, ... rest)
   {
      super();
      this.Type = param1;
      var _loc3_:int = 0;
      while(_loc3_ < rest.length)
      {
         this.Handlers.push(rest[_loc3_]);
         _loc3_++;
      }
   }
   
   public function get length() : int
   {
      return this.Handlers.length;
   }
}

class TokenEvent extends Event
{
   
   public static const ON_VALUE:String = "onValue";
   
   public var Value:*;
   
   public function TokenEvent(param1:String, param2:*)
   {
      this.Value = param2;
      super(param1);
   }
   
   override public function clone() : Event
   {
      return new TokenEvent(type,this.Value);
   }
}
