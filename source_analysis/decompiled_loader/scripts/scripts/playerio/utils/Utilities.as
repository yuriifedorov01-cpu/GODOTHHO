package playerio.utils
{
   import flash.system.Capabilities;
   
   public class Utilities
   {
      
      public static var clientAPI:String = "as3";
      
      public function Utilities()
      {
         super();
      }
      
      public static function getSystemInfo() : Object
      {
         var _loc1_:Array = ["cpuArchitecture","isDebugger","language","manufacturer","os","pixelAspectRatio","playerType","screenDPI","screenResolutionX","screenResolutionY","touchscreenType","version"];
         var _loc2_:Object = {};
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.length)
         {
            if(Capabilities[_loc1_[_loc3_]])
            {
               _loc2_[_loc1_[_loc3_]] = Capabilities[_loc1_[_loc3_]].toString();
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function getSystemInfoString() : String
      {
         var _loc3_:String = null;
         var _loc1_:Object = getSystemInfo();
         var _loc2_:Array = [];
         for(_loc3_ in _loc1_)
         {
            _loc2_.push(_loc3_ + ":" + _loc1_[_loc3_]);
         }
         return _loc2_.join("@|@");
      }
      
      public static function countKeys(param1:Object) : int
      {
         var _loc3_:* = undefined;
         var _loc2_:int = 0;
         for(_loc3_ in param1)
         {
            _loc2_++;
         }
         return _loc2_;
      }
      
      public static function find(param1:Array, param2:Function) : Object
      {
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param2(param1[_loc3_]))
            {
               return param1[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public static function converter(param1:Array, param2:Function) : Array
      {
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc3_.push(param2(param1[_loc4_]));
            _loc4_++;
         }
         return _loc3_;
      }
   }
}

