package playerio.utils
{
   import flash.utils.*;
   import playerio.*;
   import playerio.generated.*;
   import playerio.generated.messages.*;
   import playerio.helpers.*;
   
   public class Converter
   {
      
      public function Converter()
      {
         super();
      }
      
      public static function toVaultItemArray(param1:Array) : Array
      {
         var _loc2_:int = 0;
         var _loc3_:PayVaultItem = null;
         var _loc4_:Date = null;
         var _loc5_:VaultItem = null;
         var _loc6_:int = 0;
         var _loc7_:ObjectProperty = null;
         var _loc8_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_] as PayVaultItem;
            _loc4_ = new Date();
            _loc4_.setTime(_loc3_.purchaseDate);
            _loc5_ = new VaultItem(_loc3_.id,_loc3_.itemKey,_loc4_);
            _loc6_ = 0;
            while(_loc6_ < _loc3_.properties.length)
            {
               _loc7_ = _loc3_.properties[_loc6_];
               _loc5_[_loc7_.name] = deserializeValueObject(_loc7_.value);
               _loc6_++;
            }
            _loc8_.push(_loc5_);
            _loc2_++;
         }
         return _loc8_;
      }
      
      public static function toPayVaultHistoryEntryArray(param1:Array) : Array
      {
         var _loc2_:int = 0;
         var _loc3_:playerio.generated.messages.PayVaultHistoryEntry = null;
         var _loc4_:Date = null;
         var _loc5_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_] as playerio.generated.messages.PayVaultHistoryEntry;
            _loc4_ = new Date();
            _loc4_.setTime(_loc3_.timestamp);
            _loc5_.push(new playerio.PayVaultHistoryEntry(_loc3_.amount,_loc3_.type,_loc4_,_loc3_.itemKeys,_loc3_.reason,_loc3_.providerTransactionId,_loc3_.providerPrice));
            _loc2_++;
         }
         return _loc5_;
      }
      
      public static function toBuyItemInfoArray(param1:Array) : Array
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:PayVaultBuyItemInfo = null;
         var _loc5_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            if(!(_loc3_.itemKey is String))
            {
               throw new PlayerIOError("itemKey not defined on parsed item",2);
            }
            _loc4_ = new PayVaultBuyItemInfo();
            _loc4_.itemKey = _loc3_.itemKey;
            _loc4_.payload = getObjectProperties(_loc3_,false,"itemKey");
            _loc5_.push(_loc4_);
            _loc2_++;
         }
         return _loc5_;
      }
      
      public static function toKeyValueArray(param1:Object) : Array
      {
         var _loc4_:String = null;
         var _loc2_:KeyValuePair = null;
         var _loc3_:Array = [];
         for(_loc4_ in param1)
         {
            _loc2_ = new KeyValuePair();
            _loc2_.key = _loc4_;
            if(param1[_loc4_] == undefined)
            {
               _loc2_.value = undefined;
            }
            else
            {
               _loc2_.value = param1[_loc4_].toString();
            }
            _loc3_.push(_loc2_);
         }
         return _loc3_;
      }
      
      public static function toKeyValueObject(param1:Array) : Object
      {
         var _loc2_:int = 0;
         var _loc3_:KeyValuePair = null;
         var _loc4_:Object = {};
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_] as KeyValuePair;
            _loc4_[_loc3_.key] = _loc3_.value;
            _loc2_++;
         }
         return _loc4_;
      }
      
      public static function toRoomInfoArray(param1:Array) : Array
      {
         var _loc2_:int = 0;
         var _loc3_:playerio.generated.messages.RoomInfo = null;
         var _loc4_:playerio.RoomInfo = null;
         var _loc5_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_] as playerio.generated.messages.RoomInfo;
            _loc4_ = new playerio.RoomInfo(_loc3_.id,_loc3_.roomType,_loc3_.onlineUsers,Converter.toKeyValueObject(_loc3_.roomData));
            _loc5_.push(_loc4_);
            _loc2_++;
         }
         return _loc5_;
      }
      
      public static function toDatabaseObject(param1:String, param2:BigDBObject, param3:Boolean, param4:Function) : DatabaseObject
      {
         var _loc6_:ObjectProperty = null;
         if(param2 == null)
         {
            return null;
         }
         var _loc5_:DatabaseObject = new DatabaseObject(param1,param2.key,param2.version,param2.creator,param3,param4);
         for each(_loc6_ in param2.properties)
         {
            _loc5_[_loc6_.name] = deserializeValueObject(_loc6_.value);
         }
         if(param4 != null)
         {
            _loc5_.commit();
         }
         return _loc5_;
      }
      
      public static function toSparseBigDBObject(param1:String, param2:String, param3:int, param4:Object) : BigDBObject
      {
         var _loc7_:String = null;
         var _loc5_:ObjectProperty = null;
         var _loc6_:BigDBObject = new BigDBObject();
         _loc6_.key = param1;
         _loc6_.version = param2;
         _loc6_.creator = param3;
         param4 ||= {};
         for(_loc7_ in param4)
         {
            if(param4[_loc7_] !== undefined)
            {
               _loc5_ = new ObjectProperty();
               _loc5_.name = _loc7_;
               _loc5_.value = getValueObject(param4[_loc7_],true);
               _loc6_.properties.push(_loc5_);
            }
         }
         return _loc6_;
      }
      
      public static function toBigDBObject(param1:String, param2:String, param3:int, param4:Object) : BigDBObject
      {
         var _loc7_:String = null;
         var _loc5_:ObjectProperty = null;
         var _loc6_:BigDBObject = new BigDBObject();
         _loc6_.key = param1;
         _loc6_.version = param2;
         _loc6_.creator = param3;
         param4 ||= {};
         for(_loc7_ in param4)
         {
            _loc5_ = new ObjectProperty();
            _loc5_.name = _loc7_;
            _loc5_.value = getValueObject(param4[_loc7_]);
            _loc6_.properties.push(_loc5_);
         }
         return _loc6_;
      }
      
      public static function toNewBigDBObject(param1:String, param2:String, param3:Object) : NewBigDBObject
      {
         var _loc6_:String = null;
         var _loc4_:ObjectProperty = null;
         var _loc5_:NewBigDBObject = new NewBigDBObject();
         _loc5_.table = param1;
         _loc5_.key = param2;
         param3 ||= {};
         for(_loc6_ in param3)
         {
            _loc4_ = new ObjectProperty();
            _loc4_.name = _loc6_;
            _loc4_.value = getValueObject(param3[_loc6_],true);
            _loc5_.properties.push(_loc4_);
         }
         return _loc5_;
      }
      
      public static function toValueObjectArray(param1:Array) : Array
      {
         var _loc2_:int = 0;
         var _loc3_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_.push(getValueObject(param1[_loc2_]));
            _loc2_++;
         }
         return _loc3_;
      }
      
      private static function getValueObject(param1:*, param2:Boolean = false) : ValueObject
      {
         var _loc3_:ByteArray = null;
         var _loc4_:ByteArray = null;
         var _loc5_:ValueObject = new ValueObject();
         if(param1 is FieldToBeRemoved)
         {
            return null;
         }
         switch(param1)
         {
            case undefined:
               return null;
            case null:
               _loc5_.valueType = 0;
               _loc5_.string = null;
               break;
            default:
               if(param1 is Date)
               {
                  _loc5_.valueType = 8;
                  _loc5_.dateTime = (param1 as Date).getTime();
                  break;
               }
               if(param1 is Array)
               {
                  _loc5_.valueType = 9;
                  _loc5_.arrayProperties = getArrayProperties(param1,param2);
                  break;
               }
               if(param1 is String)
               {
                  _loc5_.valueType = 0;
                  _loc5_.string = param1;
                  break;
               }
               if(param1 is Boolean)
               {
                  _loc5_.valueType = 4;
                  _loc5_.bool = param1;
                  break;
               }
               if(param1 is ByteArray)
               {
                  _loc5_.valueType = 7;
                  _loc5_.byteArray = param1;
                  break;
               }
               if(param1 is Number)
               {
                  _loc3_ = new ByteArray();
                  _loc3_.writeInt(param1);
                  _loc3_.position = 0;
                  _loc4_ = new ByteArray();
                  _loc4_.writeUnsignedInt(param1);
                  _loc4_.position = 0;
                  if(_loc3_.readInt() == param1)
                  {
                     _loc5_.valueType = 1;
                     _loc5_.int32 = param1;
                  }
                  else if(_loc4_.readUnsignedInt() == param1)
                  {
                     _loc5_.valueType = 2;
                     _loc5_.uInt = param1;
                  }
                  else if(Math.floor(param1) == param1 && param1 <= 9223372036854774800 && param1 >= -9223372036854774800)
                  {
                     _loc5_.valueType = 3;
                     _loc5_.long = param1;
                  }
                  else
                  {
                     _loc3_ = new ByteArray();
                     _loc3_.writeFloat(param1);
                     _loc3_.position = 0;
                     if(_loc3_.readFloat() == param1)
                     {
                        _loc5_.valueType = 5;
                        _loc5_.float = param1;
                     }
                     else
                     {
                        _loc5_.valueType = 6;
                        _loc5_.double = param1;
                     }
                  }
                  break;
               }
               if(param1.constructor == Object)
               {
                  _loc5_.valueType = 10;
                  _loc5_.objectProperties = getObjectProperties(param1,param2);
               }
         }
         return _loc5_;
      }
      
      private static function getArrayProperties(param1:Array, param2:Boolean = false) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:ArrayProperty = null;
         var _loc5_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            if(!(param1[_loc3_] === undefined && param2))
            {
               _loc4_ = new ArrayProperty();
               _loc4_.index = _loc3_;
               _loc4_.value = getValueObject(param1[_loc3_],param2);
               _loc5_.push(_loc4_);
            }
            _loc3_++;
         }
         return _loc5_;
      }
      
      public static function getObjectProperties(param1:Object, param2:Boolean = false, param3:String = null) : Array
      {
         var _loc6_:String = null;
         var _loc4_:ObjectProperty = null;
         var _loc5_:Array = [];
         for(_loc6_ in param1)
         {
            if(!(param1[_loc6_] === undefined && param2 || _loc6_ == param3))
            {
               _loc4_ = new ObjectProperty();
               _loc4_.name = _loc6_;
               _loc4_.value = getValueObject(param1[_loc6_],param2);
               _loc5_.push(_loc4_);
            }
         }
         return _loc5_;
      }
      
      private static function deserializeValueObject(param1:ValueObject) : *
      {
         var _loc2_:Date = null;
         switch(param1.valueType)
         {
            case 0:
               return param1.string;
            case 1:
               return param1.int32 || 0;
            case 2:
               return param1.uInt || 0;
            case 3:
               return param1.long || 0;
            case 4:
               return param1.bool;
            case 5:
               return param1.float || 0;
            case 6:
               return param1.double || 0;
            case 7:
               return param1.byteArray;
            case 8:
               _loc2_ = new Date();
               _loc2_.setTime(param1.dateTime);
               return _loc2_;
            case 9:
               return getArray(param1.arrayProperties);
            case 10:
               return getObject(param1.objectProperties);
            default:
               throw new Error("Unknown valuetype in returned BigDBObject",0);
         }
      }
      
      private static function getArray(param1:Array) : Array
      {
         var _loc2_:int = 0;
         var _loc3_:ArrayProperty = null;
         var _loc4_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_] as ArrayProperty;
            if(_loc3_.value != null)
            {
               _loc4_[_loc3_.index] = deserializeValueObject(_loc3_.value);
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      private static function getObject(param1:Array) : Object
      {
         var _loc2_:int = 0;
         var _loc3_:ObjectProperty = null;
         var _loc4_:Object = {};
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_] as ObjectProperty;
            if(_loc3_.value != null)
            {
               _loc4_[_loc3_.name] = deserializeValueObject(_loc3_.value);
            }
            _loc2_++;
         }
         return _loc4_;
      }
   }
}

