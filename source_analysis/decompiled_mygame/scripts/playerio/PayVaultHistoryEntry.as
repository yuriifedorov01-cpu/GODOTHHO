package playerio
{
   public dynamic class PayVaultHistoryEntry
   {
      
      private var _amount:int;
      
      private var _type:String;
      
      private var _timestamp:Date;
      
      private var _itemKeys:Array;
      
      private var _reason:String;
      
      private var _providerTransactionId:String;
      
      private var _providerPrice:String;
      
      public function PayVaultHistoryEntry(param1:int, param2:String, param3:Date, param4:Array, param5:String, param6:String, param7:String)
      {
         super();
         this._amount = param1;
         this._type = param2;
         this._timestamp = param3;
         this._itemKeys = param4;
         this._reason = param5;
         this._providerTransactionId = param6;
         this._providerPrice = param7;
      }
      
      public function get amount() : int
      {
         return this._amount;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function get timestamp() : Date
      {
         return this._timestamp;
      }
      
      public function get itemKeys() : Array
      {
         return this._itemKeys;
      }
      
      public function get reason() : String
      {
         return this._reason;
      }
      
      public function get providerTransactionId() : String
      {
         return this._providerTransactionId;
      }
      
      public function get providerPrice() : String
      {
         return this._providerPrice;
      }
      
      public function toString() : String
      {
         var _loc1_:String = "[playerio.PayVaultHistoryEntry] = {\n";
         _loc1_ += "\ttype:\"" + this._type + "\"\n";
         _loc1_ += "\tamount:" + this._amount + "\n";
         _loc1_ += "\ttimestamp:" + this._timestamp + "\n";
         _loc1_ += "\titemKeys:[" + this._itemKeys + "]\n";
         _loc1_ += "\treason:\"" + this._reason + "\"\n";
         _loc1_ += "\tproviderTransactionId:" + (this._providerTransactionId !== null ? "\"" + this._providerTransactionId + "\"" : "null") + "\n";
         _loc1_ += "\tproviderPrice:\"" + this._providerPrice + "\"\n";
         return _loc1_ + "}";
      }
   }
}

