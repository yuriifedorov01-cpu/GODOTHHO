package playerio
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   import playerio.generated.PlayerIOError;
   import playerio.generated.messages.ServerEndpoint;
   import playerio.utils.BinarySerializer;
   
   public class Connection
   {
      
      private static var connections:Array = [];
      
      private static const encodeChars:Array = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","0","1","2","3","4","5","6","7","8","9","+","/"];
      
      private static const decodeChars:Array = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,62,-1,-1,-1,63,52,53,54,55,56,57,58,59,60,61,-1,-1,-1,-1,-1,-1,-1,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,-1,-1,-1,-1,-1,-1,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,-1,-1,-1,-1,-1];
      
      private var socket:Socket;
      
      private var serializer:BinarySerializer;
      
      private var messageHandlers:Array = [];
      
      private var disconnectHandlers:Array = [];
      
      private var errorHandler:Function;
      
      private var client:Client;
      
      private var devserver:String;
      
      private var callback:Function;
      
      public var roomId:String;
      
      private var debugArr:ByteArray = new ByteArray();
      
      private var sendDebugInfo:Boolean = true;
      
      private var messagesReceived:int = 0;
      
      public function Connection(param1:Client, param2:String, param3:String, param4:Array, param5:Object, param6:Function, param7:Function, param8:String)
      {
         super();
         connections.push(this);
         this.client = param1;
         this.roomId = param2;
         this.errorHandler = param7;
         this.devserver = param8;
         this.callback = param6;
         this.serializer = new BinarySerializer();
         this.serializer.addEventListener(MessageEvent.ON_MESSAGE,this.handleMessage);
         if(param4.length > 1 && param4[0].port == 80)
         {
            param4.push(param4.shift());
         }
         this.doConnect(param3,param5,param4);
      }
      
      public static function encode(param1:ByteArray) : String
      {
         var _loc7_:int = 0;
         var _loc2_:Array = [];
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:int = param1.length % 3;
         var _loc6_:int = param1.length - _loc5_;
         while(_loc3_ < _loc6_)
         {
            _loc7_ = param1[_loc3_++] << 16 | param1[_loc3_++] << 8 | param1[_loc3_++];
            var _loc8_:Number;
            _loc2_[_loc8_ = _loc4_++] = encodeChars[_loc7_ >> 18] + encodeChars[_loc7_ >> 12 & 0x3F] + encodeChars[_loc7_ >> 6 & 0x3F] + encodeChars[_loc7_ & 0x3F];
         }
         if(_loc5_ == 1)
         {
            _loc7_ = int(param1[_loc3_++]);
            _loc2_[_loc8_ = _loc4_++] = encodeChars[_loc7_ >> 2] + encodeChars[(_loc7_ & 3) << 4] + "==";
         }
         else if(_loc5_ == 2)
         {
            _loc7_ = param1[_loc3_++] << 8 | param1[_loc3_++];
            _loc2_[_loc8_ = _loc4_++] = encodeChars[_loc7_ >> 10] + encodeChars[_loc7_ >> 4 & 0x3F] + encodeChars[(_loc7_ & 0x0F) << 2] + "=";
         }
         return _loc2_.join("");
      }
      
      private function doConnect(param1:String, param2:Object, param3:Array) : void
      {
         var hadConnection:Boolean = false;
         var disposed:Boolean = false;
         var tempSS:Socket = null;
         var serverInfo:Array = null;
         var key:String = param1;
         var joinData:Object = param2;
         var endpoints:Array = param3;
         var endpoint:ServerEndpoint = endpoints.shift() as ServerEndpoint;
         hadConnection = false;
         disposed = false;
         if(this.devserver != null)
         {
            serverInfo = this.devserver.split(":");
            tempSS = new Socket(serverInfo[0],serverInfo[1]);
         }
         else
         {
            tempSS = new Socket(endpoint.address,endpoint.port);
         }
         tempSS.addEventListener(Event.CLOSE,function():void
         {
            var handler:Function = null;
            if(disposed)
            {
               return;
            }
            for each(handler in disconnectHandlers)
            {
               try
               {
                  handler();
               }
               catch(e:Error)
               {
                  client.handleCallbackError("Connection.addDisconnectHandler",e);
                  throw e;
               }
            }
         });
         tempSS.addEventListener(Event.CONNECT,function(param1:Event):void
         {
            var _loc3_:String = null;
            if(disposed)
            {
               try
               {
                  tempSS.close();
               }
               catch(e:Error)
               {
               }
               return;
            }
            socket = tempSS;
            hadConnection = true;
            tempSS.writeByte(0);
            tempSS.flush();
            var _loc2_:Message = createMessage("join",key);
            for(_loc3_ in joinData)
            {
               _loc2_.add(_loc3_.toString());
               _loc2_.add(joinData[_loc3_].toString());
            }
            sendMessage(_loc2_);
         });
         tempSS.addEventListener(IOErrorEvent.IO_ERROR,function(param1:IOErrorEvent):void
         {
            disposed = true;
            try
            {
               tempSS.close();
            }
            catch(e:Error)
            {
            }
            if(devserver)
            {
               throwError("Unable to connect to development server on " + devserver + ". Is the development server running?",1);
            }
            else if(endpoints.length != 0 && !hadConnection)
            {
               doConnect(key,joinData,endpoints);
            }
            else
            {
               throwError("Unable to connect to player.io multiplayer server due to IO Error [" + param1.text + "]",1);
            }
         });
         tempSS.addEventListener(SecurityErrorEvent.SECURITY_ERROR,function(param1:SecurityErrorEvent):void
         {
            disposed = true;
            try
            {
               tempSS.close();
            }
            catch(e:Error)
            {
            }
            if(!hadConnection)
            {
               if(endpoints.length != 0 && !hadConnection)
               {
                  doConnect(key,joinData,endpoints);
               }
               else
               {
                  throwError("Unable to connect to player.io multiplayer server due to Security Error [" + param1.text + "]",1);
               }
            }
         });
         tempSS.addEventListener(ProgressEvent.SOCKET_DATA,function():void
         {
            var l:int;
            var a:int;
            var b:int = 0;
            if(disposed)
            {
               try
               {
                  tempSS.close();
               }
               catch(e:Error)
               {
               }
               return;
            }
            l = int(tempSS.bytesAvailable);
            a = 0;
            while(a < l)
            {
               b = int(tempSS.readUnsignedByte());
               if(debugArr.length < 1024 * 100)
               {
                  debugArr.writeByte(b);
               }
               else
               {
                  sendDebugInfo = false;
               }
               try
               {
                  serializer.AddByte(b);
               }
               catch(e:Error)
               {
                  if(sendDebugInfo)
                  {
                     client.handleSystemError("Unable to deserialize multiplayer message",e,{"binary":encode(debugArr)});
                  }
                  throw e;
               }
               a++;
            }
         });
      }
      
      public function addMessageHandler(param1:String, param2:Function) : void
      {
         this.messageHandlers.push(new MessageHandler(param1,param2));
      }
      
      public function removeMessageHandler(param1:String, param2:Function) : void
      {
         var _loc4_:MessageHandler = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.messageHandlers.length)
         {
            _loc4_ = this.messageHandlers[_loc3_] as MessageHandler;
            if(_loc4_.type == param1 && _loc4_.handler == param2)
            {
               this.messageHandlers.splice(_loc3_,1);
               return;
            }
            _loc3_++;
         }
      }
      
      public function disconnect() : void
      {
         if(Boolean(this.socket) && this.socket.connected)
         {
            this.socket.close();
         }
      }
      
      public function addDisconnectHandler(param1:Function) : void
      {
         this.disconnectHandlers.push(param1);
      }
      
      public function removeDisconnectHandler(param1:Function) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.disconnectHandlers.length)
         {
            if(this.disconnectHandlers[_loc2_] == param1)
            {
               this.disconnectHandlers.splice(_loc2_,1);
               return;
            }
            _loc2_++;
         }
      }
      
      public function get connected() : Boolean
      {
         return this.socket.connected;
      }
      
      public function createMessage(param1:String, ... rest) : Message
      {
         var _loc3_:Message = new Message(param1);
         var _loc4_:int = 0;
         while(_loc4_ < rest.length)
         {
            _loc3_.add(rest[_loc4_]);
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function send(param1:String, ... rest) : void
      {
         var _loc3_:Message = new Message(param1);
         var _loc4_:int = 0;
         while(_loc4_ < rest.length)
         {
            _loc3_.add(rest[_loc4_]);
            _loc4_++;
         }
         this.sendMessage(_loc3_);
      }
      
      public function sendMessage(param1:Message) : void
      {
         var _loc2_:ByteArray = null;
         if(Boolean(this.socket) && this.socket.connected)
         {
            _loc2_ = this.serializer.SerializeMessage(param1 as Message);
            _loc2_.position = 0;
            this.socket.writeBytes(_loc2_,0,_loc2_.length);
            this.socket.flush();
         }
         else
         {
            this.throwError("Unable to send data to server when disconnected from server",2);
         }
      }
      
      private function handleMessage(param1:MessageEvent) : void
      {
         var err:playerio.generated.PlayerIOError = null;
         var a:int = 0;
         var m:MessageHandler = null;
         var args:Array = null;
         var b:int = 0;
         var e:MessageEvent = param1;
         ++this.messagesReceived;
         if(e.message.type == "playerio.joinresult")
         {
            if(e.message.getBoolean(0))
            {
               try
               {
                  this.callback(this);
               }
               catch(e:Error)
               {
                  client.handleCallbackError("Connection.connect",e);
                  throw e;
               }
            }
            else
            {
               err = new playerio.generated.PlayerIOError(e.message.getString(2),e.message.getInt(1));
               if(this.errorHandler == null)
               {
                  throw err;
               }
               this.errorHandler(err);
            }
         }
         else
         {
            a = 0;
            while(a < this.messageHandlers.length)
            {
               m = this.messageHandlers[a] as MessageHandler;
               if(m.type == e.message.type || m.type == null || m.type == "*")
               {
                  args = [e.message];
                  b = 0;
                  while(b < e.message.length && b < m.handler.length - 1)
                  {
                     args.push(e.message.getObject(b));
                     b++;
                  }
                  try
                  {
                     m.handler.apply(m.handler,args);
                  }
                  catch(e:Error)
                  {
                     client.handleCallbackError("Connection.addMessageHandler(\"" + m.type + "\")",e);
                     throw e;
                  }
               }
               a++;
            }
         }
      }
      
      private function throwError(param1:String, param2:int) : void
      {
         var _loc3_:playerio.generated.PlayerIOError = new playerio.generated.PlayerIOError(param1,param2);
         if(this.errorHandler != null)
         {
            this.errorHandler(_loc3_);
            return;
         }
         this.client.handleCallbackErrorVerbose("Error occurred while talking to player.io multiplayer servers.",_loc3_);
         throw _loc3_;
      }
   }
}

class MessageHandler
{
   
   public var type:String;
   
   public var handler:Function;
   
   public function MessageHandler(param1:String, param2:Function)
   {
      super();
      this.type = param1;
      this.handler = param2;
   }
}
