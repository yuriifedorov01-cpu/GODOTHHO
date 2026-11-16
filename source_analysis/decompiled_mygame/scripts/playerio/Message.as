package playerio
{
   import flash.utils.*;
   
   public class Message
   {
      
      private var content:Array = [];
      
      private var _type:String;
      
      public function Message(param1:String, ... rest)
      {
         var _loc3_:int = 0;
         super();
         this._type = param1;
         _loc3_ = 0;
         while(_loc3_ < rest.length)
         {
            this._add(rest[_loc3_]);
            _loc3_++;
         }
      }
      
      public function add(... rest) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < rest.length)
         {
            this._add(rest[_loc2_]);
            _loc2_++;
         }
      }
      
      public function getNumber(param1:int) : Number
      {
         return this.content[param1] as Number;
      }
      
      public function getInt(param1:int) : int
      {
         return this.content[param1] as int;
      }
      
      public function getUInt(param1:int) : uint
      {
         return this.content[param1] as uint;
      }
      
      public function getString(param1:int) : String
      {
         return this.content[param1].toString();
      }
      
      public function getBoolean(param1:int) : Boolean
      {
         return this.content[param1] as Boolean;
      }
      
      public function getByteArray(param1:int) : ByteArray
      {
         return this.content[param1] as ByteArray;
      }
      
      public function getObject(param1:int) : *
      {
         return this.content[param1];
      }
      
      public function clone(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.content.length)
         {
            param1.Add(this.content[_loc2_]);
            _loc2_++;
         }
      }
      
      public function get length() : int
      {
         return this.content.length;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function set type(param1:String) : void
      {
         this._type = param1;
      }
      
      public function toString() : String
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         var _loc3_:ByteArray = null;
         var _loc4_:String = "[playerio.Message]\n";
         _loc4_ += "type:\t\t" + this.type + "\n";
         _loc4_ += "length:\t\t" + this.length + "\n";
         _loc4_ += "content:\tId\tType\t\tValue\n";
         _loc4_ += "\t\t\t---------------------\n";
         _loc1_ = 0;
         for(; _loc1_ < this.content.length; _loc1_++)
         {
            _loc2_ = this.content[_loc1_];
            if(_loc2_ === undefined)
            {
               _loc4_ += "\t\t\t" + _loc1_ + "\tundefined\t\t" + _loc2_ + "\n";
               continue;
            }
            if(_loc2_ is String)
            {
               _loc4_ += "\t\t\t" + _loc1_ + "\tString\t\t" + _loc2_ + "\n";
               continue;
            }
            if(_loc2_ is Boolean)
            {
               _loc4_ += "\t\t\t" + _loc1_ + "\tBoolean\t\t" + _loc2_ + "\n";
               continue;
            }
            if(_loc2_ is ByteArray)
            {
               _loc4_ += "\t\t\t" + _loc1_ + "\tByteArray\tLength:" + _loc2_.length + "\n";
               continue;
            }
            _loc3_ = new ByteArray();
            _loc3_.writeInt(_loc2_);
            _loc3_.position = 0;
            switch(_loc2_)
            {
               case _loc3_.readInt():
                  _loc4_ += "\t\t\t" + _loc1_ + "\tint\t\t\t" + _loc2_ + "\n";
                  break;
               case _loc3_ = new ByteArray(),_loc3_.writeUnsignedInt(_loc2_),_loc3_.position = 0,_loc3_.readUnsignedInt():
                  _loc4_ += "\t\t\t" + _loc1_ + "\tuint\t\t" + _loc2_ + "\n";
                  break;
               case _loc3_ = new ByteArray(),_loc3_.writeFloat(_loc2_),_loc3_.position = 0,_loc3_.readFloat():
                  _loc4_ += "\t\t\t" + _loc1_ + "\tFloat\t\t" + _loc2_ + "\n";
                  break;
               default:
                  _loc4_ += "\t\t\t" + _loc1_ + "\tDouble\t\t" + _loc2_ + "\n";
            }
         }
         return _loc4_;
      }
      
      private function _add(param1:*) : void
      {
         if(param1 is Number || param1 is Boolean || param1 is String || param1 is ByteArray)
         {
            this.content.push(param1);
            return;
         }
         throw new Error(typeof param1 + " is not yet supported");
      }
   }
}

