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
         var _loc10_:Object = null;
         var input:String = param1;
         var result:Object = null;
         var key:String = null;
         var i:int = 0;
         var colonIndex:int = 0;
         var length:int = 0;
         var str:String = null;
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
            _loc10_ = {"error":e.message};
         }
         return _loc10_;
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
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:Array = [];
         _loc2_ = 2;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1.indexOf(":",_loc2_);
            _loc4_ = int(param1.substr(_loc2_,_loc3_ - _loc2_));
            _loc5_ = param1.substr(_loc3_ + 1,_loc4_);
            _loc2_ = _loc3_ + 1 + _loc4_ + 1;
            _loc6_.push(_loc5_);
         }
         return _loc6_;
      }
   }
}

