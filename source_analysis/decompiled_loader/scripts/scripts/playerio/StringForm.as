package playerio
{
   internal class StringForm
   {
      
      public function StringForm()
      {
         super();
      }
      
      internal static function decodeStringDictionary(param1:String) : Object
      {
         var result:Object = null;
         var key:String = null;
         var i:int = 0;
         var colonIndex:int = 0;
         var length:int = 0;
         var str:String = null;
         var input:String = param1;
         try
         {
            result = {};
            key = null;
            i = 2;
            while(i < input.length)
            {
               colonIndex = input.indexOf(":",i);
               length = int(input.substr(i,colonIndex - i));
               str = input.substr(colonIndex + 1,length);
               i = colonIndex + 1 + length + 1;
               if(key == null)
               {
                  key = str;
               }
               else
               {
                  result[key] = str;
                  key = null;
               }
            }
            return result;
         }
         catch(e:Error)
         {
            return {"error":e.message};
         }
      }
      
      internal static function encodeStringDictionary(param1:Object) : String
      {
         var _loc3_:String = null;
         var _loc2_:String = "A";
         if(param1 != null)
         {
            for(_loc3_ in param1)
            {
               if(param1[_loc3_] != undefined)
               {
                  _loc2_ += ":";
                  _loc2_ += _loc3_.length;
                  _loc2_ += ":";
                  _loc2_ += _loc3_;
                  _loc2_ += ":";
                  _loc2_ += (param1[_loc3_] as String).length;
                  _loc2_ += ":";
                  _loc2_ += param1[_loc3_] as String;
               }
            }
         }
         return _loc2_;
      }
      
      internal static function decodeStringArray(param1:String) : Array
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc2_:Array = [];
         var _loc3_:int = 2;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1.indexOf(":",_loc3_);
            _loc5_ = int(param1.substr(_loc3_,_loc4_ - _loc3_));
            _loc6_ = param1.substr(_loc4_ + 1,_loc5_);
            _loc3_ = _loc4_ + 1 + _loc5_ + 1;
            _loc2_.push(_loc6_);
         }
         return _loc2_;
      }
   }
}

