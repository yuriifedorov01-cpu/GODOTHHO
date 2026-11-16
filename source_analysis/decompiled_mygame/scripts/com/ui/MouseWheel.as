package com.ui
{
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   import flash.utils.*;
   
   public final class MouseWheel
   {
      
      private static var _loader:Loader;
      
      private static var _connectionID:uint;
      
      private static const _bytes:ByteArray = new ByteArray();
      
      private static const _connection:LocalConnection = new LocalConnection();
      
      private static const _dataPart0:Array = new Array(1180128009,671154176,2013267295,4000,7937,4460800,67,50331647,1057226240,34908,589932,1660963951,1667329091,1869508197,1668573551,1845521507);
      
      private static const _dataPart1:Array = new Array(6516590,1852138356,6513008,1953854053,5074805,1935999073,1684294761,1937007982,1701970034,1701670774,1699506547,1952804453,1912631150,1299150195,1700227173,1701576854,218105856,100663296,0,524608,496371968,134350593,8,1873410,525138,395706880,134225046,33556484,2383347712,16778025,161377,1819632896,939562498,262674,2634154009,9832704,67176193,8,85759490,525906,395903488,335582729,262407,16777216,134552726,33556487,1377259414,33556488,2600796160,0,496371968,83953409,8,1873410,525394,385892352);
      
      private static var _captured:Boolean = false;
      
      private static var _complete:Boolean = false;
      
      public function MouseWheel()
      {
         super();
         throw new IllegalOperationError("do not instantiate MouseWheel");
      }
      
      public static function get captured() : Boolean
      {
         return MouseWheel._captured;
      }
      
      public static function capture() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:ByteArray = null;
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:LoaderContext = null;
         if(MouseWheel._captured)
         {
            return;
         }
         if(!MouseWheel._bytes.length)
         {
            _loc1_ = Math.round(Math.random() * 100000);
            while(_loc1_ < 10000)
            {
               _loc1_ = Math.round(Math.random() * 100000);
            }
            MouseWheel._connectionID = _loc1_;
            _loc2_ = MouseWheel._bytes;
            _loc3_ = MouseWheel._dataPart0;
            _loc4_ = _loc3_.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc2_.writeUnsignedInt(_loc3_[_loc5_]);
               _loc5_++;
            }
            _loc2_.writeUTFBytes("_" + MouseWheel._connectionID.toString());
            _loc3_ = MouseWheel._dataPart1;
            _loc4_ = _loc3_.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc2_.writeUnsignedInt(_loc3_[_loc5_]);
               _loc5_++;
            }
            _loc2_.writeShort(0);
         }
         MouseWheel._connection.addEventListener(StatusEvent.STATUS,MouseWheel.handler_status);
         MouseWheel._connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR,MouseWheel.handler_asyncError);
         MouseWheel._captured = true;
         if(MouseWheel._loader)
         {
            MouseWheel.send();
         }
         else
         {
            MouseWheel._loader = new Loader();
            _loc6_ = new LoaderContext(false,ApplicationDomain.currentDomain);
            _loc6_.allowCodeImport = true;
            MouseWheel._loader.loadBytes(MouseWheel._bytes,_loc6_);
            MouseWheel._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,MouseWheel.handler_complete);
         }
      }
      
      public static function release() : void
      {
         if(!MouseWheel._captured)
         {
            return;
         }
         MouseWheel._captured = false;
         MouseWheel.send();
      }
      
      private static function send(param1:Event = null) : void
      {
         if(!MouseWheel._complete)
         {
            return;
         }
         MouseWheel._connection.send("lc_" + MouseWheel._connectionID,"capture",MouseWheel._captured);
      }
      
      private static function handler_complete(param1:Event) : void
      {
         MouseWheel._complete = true;
         if(!MouseWheel._captured)
         {
            MouseWheel.send();
         }
      }
      
      private static function handler_status(param1:StatusEvent) : void
      {
         if(param1.level == "error")
         {
            MouseWheel.send();
         }
      }
      
      private static function handler_asyncError(param1:AsyncErrorEvent) : void
      {
      }
   }
}

