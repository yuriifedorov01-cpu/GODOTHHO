package playerio
{
   public dynamic class VaultItem
   {
      
      private var _id:String;
      
      private var _itemKey:String;
      
      private var _purchaseDate:Date;
      
      private var prefix:String = "    ";
      
      public function VaultItem(param1:String, param2:String, param3:Date)
      {
         super();
         this._id = param1;
         this._itemKey = param2;
         this._purchaseDate = param3;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get itemKey() : String
      {
         return this._itemKey;
      }
      
      public function get purchaseDate() : Date
      {
         return this._purchaseDate;
      }
      
      public function toString() : String
      {
         var _loc1_:String = "[playerio.VaultItem]";
         return _loc1_ + ("[itemKey=\"" + this._itemKey + "\", id=\"" + this._id + "\", purchaseDate=" + this._purchaseDate + "] = " + this.serialize(this.prefix,this));
      }
      
      private function serialize(param1:String, param2:*) : String
      {
         var _loc3_:int = 0;
         var _loc4_:String = "";
         var _loc5_:String = "";
         var _loc6_:Array = [];
         if(param2 is String)
         {
            return "\"" + param2 + "\"";
         }
         if(param2 is Array)
         {
            _loc4_ = "[\n";
            for(_loc5_ in param2)
            {
               if(param2[_loc5_] !== undefined)
               {
                  _loc6_.push({
                     "id":_loc5_,
                     "value":this.serialize(param1 + this.prefix,param2[_loc5_])
                  });
               }
            }
            _loc6_.sortOn("id",16);
            _loc3_ = 0;
            while(_loc3_ < _loc6_.length)
            {
               _loc4_ += param1 + _loc6_[_loc3_].id + ":" + _loc6_[_loc3_].value + "\n";
               _loc3_++;
            }
            return _loc4_ + (param1.substring(4) + "]");
         }
         if(param2 is Object)
         {
            if(param2.constructor == Object || param2.constructor == VaultItem)
            {
               _loc4_ = "{\n";
               for(_loc5_ in param2)
               {
                  if(param2[_loc5_] !== undefined)
                  {
                     _loc6_.push({
                        "id":_loc5_,
                        "value":this.serialize(param1 + this.prefix,param2[_loc5_])
                     });
                  }
               }
               _loc6_.sortOn("id");
               _loc3_ = 0;
               while(_loc3_ < _loc6_.length)
               {
                  _loc4_ += param1 + _loc6_[_loc3_].id + ":" + _loc6_[_loc3_].value + "\n";
                  _loc3_++;
               }
               return _loc4_ + (param1.substring(4) + "}");
            }
         }
         if(param2 == null)
         {
            return param2;
         }
         return param2.toString();
      }
   }
}

