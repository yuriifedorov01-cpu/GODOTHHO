package playerio.utils
{
   import com.protobuf.Message;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.*;
   import flash.utils.*;
   
   public class HTTPChannel
   {
      
      private var useSSL:Boolean = false;
      
      private var _token:String = "";
      
      private var _headers:Array = [];
      
      public function HTTPChannel(param1:Boolean = false)
      {
         super();
         this.useSSL = param1;
      }
      
      private function get endpoint() : String
      {
         return this.useSSL ? "https://api.playerio.com/api" : "https://api.playerio.com/api";
      }
      
      public function set headers(param1:Array) : void
      {
         this._headers = param1;
      }
      
      public function Request(param1:int, param2:Message, param3:Message, param4:Message, param5:Function, param6:Function) : void
      {
         var r:URLRequest = null;
         var b:ByteArray = null;
         var tba:ByteArray = null;
         var loader:URLLoader = null;
         var RPCMethod:int = param1;
         var messageInput:Message = param2;
         var messageOutput:Message = param3;
         var messageError:Message = param4;
         var success:Function = param5;
         var error:Function = param6;
         loader = new URLLoader();
         loader.dataFormat = "binary";
         loader.addEventListener("complete",function(param1:Event):void
         {
            var _loc2_:int = 0;
            var _loc3_:ByteArray = loader.data;
            _loc3_.position = 0;
            if(_loc3_.readUnsignedByte() != 0)
            {
               _loc2_ = int(_loc3_.readUnsignedShort());
               _token = _loc3_.readUTFBytes(_loc2_);
            }
            var _loc4_:int = int(_loc3_.readUnsignedByte());
            if(_loc4_ == 0)
            {
               messageError.readFromDataOutput(_loc3_);
               error(messageError);
            }
            else if(_loc4_ == 1)
            {
               messageOutput.readFromDataOutput(_loc3_);
               success(messageOutput);
            }
         });
         loader.addEventListener("ioError",function(param1:IOErrorEvent):void
         {
            try
            {
               (messageError as Object).message = "[PlayerIOError] " + param1.text;
            }
            catch(e:Error)
            {
            }
            error(messageError);
         });
         loader.addEventListener("securityError",function(param1:SecurityError):void
         {
            try
            {
               (messageError as Object).message = "[PlayerIOError] " + param1.message;
            }
            catch(e:Error)
            {
            }
            error(messageError);
         });
         r = new URLRequest(this.endpoint + "/" + RPCMethod);
         r.requestHeaders = this._headers;
         r.method = "POST";
         if(this._token != "")
         {
            r.requestHeaders = [new URLRequestHeader("playertoken",this._token)];
         }
         b = new ByteArray();
         messageInput.writeToDataOutput(b);
         if(b.length == 0)
         {
            tba = new ByteArray();
            tba.writeByte(8);
            tba.writeByte(0);
            r.data = tba;
         }
         else
         {
            r.data = b;
         }
         loader.load(r);
      }
      
      public function set token(param1:String) : void
      {
         this._token = param1;
      }
      
      public function get token() : String
      {
         return this._token;
      }
   }
}

