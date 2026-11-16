package playerio.generated
{
   import flash.events.EventDispatcher;
   import playerio.Client;
   import playerio.generated.messages.*;
   import playerio.utils.*;
   
   public class GameRequests extends EventDispatcher
   {
      
      protected var channel:HTTPChannel;
      
      protected var client:Client;
      
      public function GameRequests(param1:HTTPChannel, param2:Client)
      {
         super();
         this.channel = param1;
         this.client = param2;
      }
      
      protected function _gameRequestsSend(param1:String, param2:Object, param3:Array, param4:Function = null, param5:Function = null) : void
      {
         var requestType:String = param1;
         var requestData:Object = param2;
         var requestRecipients:Array = param3;
         var callback:Function = param4;
         var errorHandler:Function = param5;
         var input:GameRequestsSendArgs = new GameRequestsSendArgs(requestType,Converter.toKeyValueArray(requestData),requestRecipients);
         var output:GameRequestsSendOutput = new GameRequestsSendOutput();
         this.channel.Request(241,input,output,new GameRequestsSendError(),function(param1:GameRequestsSendOutput):void
         {
            var output:GameRequestsSendOutput = param1;
            if(callback != null)
            {
               try
               {
                  callback();
               }
               catch(e:Error)
               {
                  client.handleCallbackError("GameRequests.gameRequestsSend",e);
                  throw e;
               }
            }
         },function(param1:GameRequestsSendError):void
         {
            var _loc2_:PlayerIOError = new PlayerIOError(param1.message,param1.errorCode);
            if(errorHandler != null)
            {
               errorHandler(_loc2_);
               return;
            }
            throw _loc2_;
         });
      }
      
      protected function _gameRequestsRefresh(param1:Array, param2:Function = null, param3:Function = null) : void
      {
         var playCodes:Array = param1;
         var callback:Function = param2;
         var errorHandler:Function = param3;
         var input:GameRequestsRefreshArgs = new GameRequestsRefreshArgs(playCodes);
         var output:GameRequestsRefreshOutput = new GameRequestsRefreshOutput();
         this.channel.Request(244,input,output,new GameRequestsRefreshError(),function(param1:GameRequestsRefreshOutput):void
         {
            var output:GameRequestsRefreshOutput = param1;
            if(callback != null)
            {
               try
               {
                  callback(output.requests,output.moreRequestsWaiting,output.newPlayCodes);
               }
               catch(e:Error)
               {
                  client.handleCallbackError("GameRequests.gameRequestsRefresh",e);
                  throw e;
               }
            }
         },function(param1:GameRequestsRefreshError):void
         {
            var _loc2_:PlayerIOError = new PlayerIOError(param1.message,param1.errorCode);
            if(errorHandler != null)
            {
               errorHandler(_loc2_);
               return;
            }
            throw _loc2_;
         });
      }
      
      protected function _gameRequestsDelete(param1:Array, param2:Function = null, param3:Function = null) : void
      {
         var requestIds:Array = param1;
         var callback:Function = param2;
         var errorHandler:Function = param3;
         var input:GameRequestsDeleteArgs = new GameRequestsDeleteArgs(requestIds);
         var output:GameRequestsDeleteOutput = new GameRequestsDeleteOutput();
         this.channel.Request(247,input,output,new GameRequestsDeleteError(),function(param1:GameRequestsDeleteOutput):void
         {
            var output:GameRequestsDeleteOutput = param1;
            if(callback != null)
            {
               try
               {
                  callback(output.requests,output.moreRequestsWaiting);
               }
               catch(e:Error)
               {
                  client.handleCallbackError("GameRequests.gameRequestsDelete",e);
                  throw e;
               }
            }
         },function(param1:GameRequestsDeleteError):void
         {
            var _loc2_:PlayerIOError = new PlayerIOError(param1.message,param1.errorCode);
            if(errorHandler != null)
            {
               errorHandler(_loc2_);
               return;
            }
            throw _loc2_;
         });
      }
   }
}

