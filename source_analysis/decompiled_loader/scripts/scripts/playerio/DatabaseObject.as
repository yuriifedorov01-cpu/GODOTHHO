package playerio
{
   import playerio.helpers.FieldToBeRemoved;
   import playerio.utils.Converter;
   
   public dynamic class DatabaseObject
   {
      
      private var _table:String = "";
      
      private var _version:String = "";
      
      private var _creator:uint = 0;
      
      private var _key:String = "";
      
      private var _saveHandler:Function;
      
      private var _cache:DatabaseObject;
      
      private var _createIfMissing:Boolean = false;
      
      private var saveQueue:Array = [];
      
      private var inSave:Boolean = false;
      
      private var prefix:String = "    ";
      
      public function DatabaseObject(param1:String, param2:String, param3:String, param4:uint, param5:Boolean, param6:Function)
      {
         super();
         this._table = param1;
         this._version = param3;
         this._creator = param4;
         this._key = param2;
         this._saveHandler = param6;
         this._createIfMissing = param5;
      }
      
      public function save(param1:Boolean = false, param2:Boolean = false, param3:Function = null, param4:Function = null) : void
      {
         var _loc6_:SaveQueueItem = null;
         var _loc7_:SaveQueueItem = null;
         if(param2)
         {
            throw new Error("FullOverwrite is not yet supported by BigDB - Stay tuned at www.player.io for updates!",0);
         }
         var _loc5_:DatabaseObject = Converter.toDatabaseObject(this.table,Converter.toSparseBigDBObject(this.key,this._version,this._creator,this),this._createIfMissing,null);
         if(this.inSave)
         {
            _loc6_ = this.saveQueue.length > 0 ? this.saveQueue[this.saveQueue.length - 1] : null;
            if(_loc6_ != null && _loc6_.useOptimisticLock == param1 && _loc6_.fullOverwrite == param2)
            {
               _loc6_.data = _loc5_;
               _loc6_.callbacks.push(param3);
               _loc6_.errorHandlers.push(param4);
            }
            else
            {
               _loc7_ = new SaveQueueItem();
               _loc7_.data = _loc5_;
               _loc7_.callbacks.push(param3);
               _loc7_.errorHandlers.push(param4);
               _loc7_.fullOverwrite = param2;
               _loc7_.useOptimisticLock = param1;
               this.saveQueue.push(_loc7_);
            }
            return;
         }
         this.doSave(_loc5_,param1,param2,param3,param4);
      }
      
      public function commit() : void
      {
         this._cache = Converter.toDatabaseObject(this.table,Converter.toSparseBigDBObject(this.key,this._version,this._creator,this),this._createIfMissing,null);
      }
      
      private function doSave(param1:DatabaseObject, param2:Boolean = false, param3:Boolean = false, param4:Function = null, param5:Function = null) : void
      {
         var ret:Object;
         var changed:Boolean;
         var x:String = null;
         var cached:DatabaseObject = param1;
         var useOptimisticLock:Boolean = param2;
         var fullOverwrite:Boolean = param3;
         var callback:Function = param4;
         var errorHandler:Function = param5;
         this.inSave = true;
         ret = {};
         this.compareObject(this._cache,cached,ret);
         changed = false;
         var _loc7_:int = 0;
         var _loc8_:* = ret;
         for(x in _loc8_)
         {
            changed = true;
         }
         if(!changed)
         {
            if(callback != null)
            {
               callback();
            }
            this.emptyQueue();
            return;
         }
         this._saveHandler(this._table,this._key,this._version,ret,useOptimisticLock,this._createIfMissing,function(param1:String):void
         {
            if(param1 == null)
            {
               if(errorHandler == null)
               {
                  throw PlayerIOError.StaleVersion;
               }
               errorHandler(PlayerIOError.StaleVersion);
            }
            else
            {
               _version = param1;
               _cache = cached;
               if(callback != null)
               {
                  callback();
               }
            }
            emptyQueue();
         },function(param1:PlayerIOError):void
         {
            emptyQueue();
            if(errorHandler == null)
            {
               throw param1;
            }
            errorHandler(param1);
         });
      }
      
      private function emptyQueue() : void
      {
         var qi:SaveQueueItem = null;
         this.inSave = false;
         if(this.saveQueue.length != 0)
         {
            qi = this.saveQueue.shift();
            this.doSave(qi.data,qi.useOptimisticLock,qi.fullOverwrite,function():void
            {
               var _loc1_:int = 0;
               while(_loc1_ < qi.callbacks.length)
               {
                  if(qi.callbacks[_loc1_] != null)
                  {
                     qi.callbacks[_loc1_]();
                  }
                  _loc1_++;
               }
            },function(param1:PlayerIOError):void
            {
               var _loc2_:int = 0;
               while(_loc2_ < qi.errorHandlers.length)
               {
                  if(qi.errorHandlers[_loc2_] == null)
                  {
                     throw param1;
                  }
                  qi.errorHandlers[_loc2_](param1);
                  _loc2_++;
               }
            });
         }
      }
      
      public function get table() : String
      {
         return this._table;
      }
      
      public function get key() : String
      {
         return this._key;
      }
      
      private function compareObject(param1:Object, param2:Object, param3:Object = null) : Object
      {
         var ret:Object = null;
         var x:String = null;
         var na:Array = null;
         var no:Object = null;
         var changed:Boolean = false;
         var nx:String = null;
         var before:Object = param1;
         var after:Object = param2;
         var target:Object = param3;
         var setProp:Function = function(param1:String, param2:*):void
         {
            ret[param1] = param2;
         };
         ret = target || {};
         var prop:Object = this.mergePropertyList(before,after);
         for(x in prop)
         {
            if(before[x] !== after[x])
            {
               if(after[x] === undefined)
               {
                  setProp(x,new FieldToBeRemoved());
               }
               else if(before[x] is Array && after[x] is Array)
               {
                  na = this.objectToArray(this.compareObject(before[x],after[x]));
                  if(na.length > 0)
                  {
                     setProp(x,na);
                  }
               }
               else if(before[x] is Object && before[x].constructor == Object && after[x] is Object && after[x].constructor == Object)
               {
                  no = this.compareObject(before[x],after[x]);
                  changed = false;
                  var _loc7_:int = 0;
                  var _loc8_:* = no;
                  for(nx in _loc8_)
                  {
                     changed = true;
                  }
                  if(changed)
                  {
                     setProp(x,no);
                  }
               }
               else
               {
                  setProp(x,after[x]);
               }
            }
         }
         return ret;
      }
      
      private function mergePropertyList(param1:Object, param2:Object) : Object
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc3_:Object = {};
         if(param1 is Array)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               _loc3_[_loc4_] = true;
               _loc4_++;
            }
         }
         else
         {
            for(_loc5_ in param1)
            {
               _loc3_[_loc5_] = true;
            }
         }
         if(param2 is Array)
         {
            _loc6_ = 0;
            while(_loc6_ < param2.length)
            {
               _loc3_[_loc6_] = true;
               _loc6_++;
            }
         }
         else
         {
            for(_loc7_ in param2)
            {
               _loc3_[_loc7_] = true;
            }
         }
         return _loc3_;
      }
      
      private function objectToArray(param1:Object) : Array
      {
         var _loc3_:String = null;
         var _loc2_:Array = [];
         for(_loc3_ in param1)
         {
            _loc2_[parseInt(_loc3_)] = param1[_loc3_];
         }
         return _loc2_;
      }
      
      public function toString() : String
      {
         var _loc1_:String = "[playerio.DatabaseObject]\n";
         return _loc1_ + (this._table + "[\"" + this.key + "\"] = " + this.serialize(this.prefix,this) + " (Version:" + this._version + ")");
      }
      
      private function serialize(param1:String, param2:*) : String
      {
         var _loc6_:int = 0;
         var _loc3_:String = "";
         var _loc4_:String = "";
         var _loc5_:Array = [];
         if(param2 is String)
         {
            return "\"" + param2 + "\"";
         }
         if(param2 is Array)
         {
            _loc3_ = "[\n";
            _loc6_ = 0;
            while(_loc6_ < param2.length)
            {
               if(param2[_loc6_] !== undefined)
               {
                  _loc5_.push({
                     "id":_loc6_,
                     "value":this.serialize(param1 + this.prefix,param2[_loc6_])
                  });
               }
               _loc6_++;
            }
            _loc5_.sortOn("id",Array.NUMERIC);
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               _loc3_ += param1 + _loc5_[_loc6_].id + ":" + _loc5_[_loc6_].value + "\n";
               _loc6_++;
            }
            return _loc3_ + (param1.substring(4) + "]");
         }
         if(param2 is Object)
         {
            if(param2.constructor == Object || param2.constructor == DatabaseObject)
            {
               _loc3_ = "{\n";
               for(_loc4_ in param2)
               {
                  _loc5_.push({
                     "id":_loc4_,
                     "value":this.serialize(param1 + this.prefix,param2[_loc4_])
                  });
               }
               _loc5_.sortOn("id");
               _loc6_ = 0;
               while(_loc6_ < _loc5_.length)
               {
                  _loc3_ += param1 + _loc5_[_loc6_].id + ":" + _loc5_[_loc6_].value + "\n";
                  _loc6_++;
               }
               return _loc3_ + (param1.substring(4) + "}");
            }
         }
         switch(param2)
         {
            case null:
               return "null";
            case undefined:
               return "undefined";
            default:
               return param2.toString();
         }
      }
   }
}

import playerio.DatabaseObject;

class SaveQueueItem
{
   
   public var data:DatabaseObject;
   
   public var callbacks:Array = [];
   
   public var errorHandlers:Array = [];
   
   public var useOptimisticLock:Boolean;
   
   public var fullOverwrite:Boolean;
   
   public function SaveQueueItem()
   {
      super();
   }
}
