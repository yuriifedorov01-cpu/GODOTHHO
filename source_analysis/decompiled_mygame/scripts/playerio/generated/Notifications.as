package playerio.generated
{
   import flash.events.EventDispatcher;
   import playerio.Client;
   import playerio.generated.messages.*;
   import playerio.utils.HTTPChannel;
   
   public class Notifications extends EventDispatcher
   {
      
      protected var channel:HTTPChannel;
      
      protected var client:Client;
      
      public function Notifications(param1:HTTPChannel, param2:Client)
      {
         super();
         this.channel = param1;
         this.client = param2;
      }
      
      protected function _notificationsRefresh(param1:String, param2:Function = null, param3:Function = null) : void
      {
         var lastVersion:String = param1;
         var callback:Function = param2;
         var errorHandler:Function = param3;
         var input:NotificationsRefreshArgs = new NotificationsRefreshArgs(lastVersion);
         var output:NotificationsRefreshOutput = new NotificationsRefreshOutput();
         this.channel.Request(213,input,output,new NotificationsRefreshError(),function(param1:NotificationsRefreshOutput):void
         {
            var output:NotificationsRefreshOutput = param1;
            if(callback != null)
            {
               try
               {
                  callback(output.version,output.endpoints);
               }
               catch(e:Error)
               {
                  client.handleCallbackError("Notifications.notificationsRefresh",e);
                  throw e;
               }
            }
         },function(param1:NotificationsRefreshError):void
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
      
      protected function _notificationsRegisterEndpoints(param1:String, param2:Array, param3:Function = null, param4:Function = null) : void
      {
         var lastVersion:String = param1;
         var endpoints:Array = param2;
         var callback:Function = param3;
         var errorHandler:Function = param4;
         var input:NotificationsRegisterEndpointsArgs = new NotificationsRegisterEndpointsArgs(lastVersion,endpoints);
         var output:NotificationsRegisterEndpointsOutput = new NotificationsRegisterEndpointsOutput();
         this.channel.Request(216,input,output,new NotificationsRegisterEndpointsError(),function(param1:NotificationsRegisterEndpointsOutput):void
         {
            var output:NotificationsRegisterEndpointsOutput = param1;
            if(callback != null)
            {
               try
               {
                  callback(output.version,output.endpoints);
               }
               catch(e:Error)
               {
                  client.handleCallbackError("Notifications.notificationsRegisterEndpoints",e);
                  throw e;
               }
            }
         },function(param1:NotificationsRegisterEndpointsError):void
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
      
      protected function _notificationsSend(param1:Array, param2:Function = null, param3:Function = null) : void
      {
         var notifications:Array = param1;
         var callback:Function = param2;
         var errorHandler:Function = param3;
         var input:NotificationsSendArgs = new NotificationsSendArgs(notifications);
         var output:NotificationsSendOutput = new NotificationsSendOutput();
         this.channel.Request(219,input,output,new NotificationsSendError(),function(param1:NotificationsSendOutput):void
         {
            var output:NotificationsSendOutput = param1;
            if(callback != null)
            {
               try
               {
                  callback();
               }
               catch(e:Error)
               {
                  client.handleCallbackError("Notifications.notificationsSend",e);
                  throw e;
               }
            }
         },function(param1:NotificationsSendError):void
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
      
      protected function _notificationsToggleEndpoints(param1:String, param2:Array, param3:Boolean, param4:Function = null, param5:Function = null) : void
      {
         var lastVersion:String = param1;
         var endpoints:Array = param2;
         var enabled:Boolean = param3;
         var callback:Function = param4;
         var errorHandler:Function = param5;
         var input:NotificationsToggleEndpointsArgs = new NotificationsToggleEndpointsArgs(lastVersion,endpoints,enabled);
         var output:NotificationsToggleEndpointsOutput = new NotificationsToggleEndpointsOutput();
         this.channel.Request(222,input,output,new NotificationsToggleEndpointsError(),function(param1:NotificationsToggleEndpointsOutput):void
         {
            var output:NotificationsToggleEndpointsOutput = param1;
            if(callback != null)
            {
               try
               {
                  callback(output.version,output.endpoints);
               }
               catch(e:Error)
               {
                  client.handleCallbackError("Notifications.notificationsToggleEndpoints",e);
                  throw e;
               }
            }
         },function(param1:NotificationsToggleEndpointsError):void
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
      
      protected function _notificationsDeleteEndpoints(param1:String, param2:Array, param3:Function = null, param4:Function = null) : void
      {
         var lastVersion:String = param1;
         var endpoints:Array = param2;
         var callback:Function = param3;
         var errorHandler:Function = param4;
         var input:NotificationsDeleteEndpointsArgs = new NotificationsDeleteEndpointsArgs(lastVersion,endpoints);
         var output:NotificationsDeleteEndpointsOutput = new NotificationsDeleteEndpointsOutput();
         this.channel.Request(225,input,output,new NotificationsDeleteEndpointsError(),function(param1:NotificationsDeleteEndpointsOutput):void
         {
            var output:NotificationsDeleteEndpointsOutput = param1;
            if(callback != null)
            {
               try
               {
                  callback(output.version,output.endpoints);
               }
               catch(e:Error)
               {
                  client.handleCallbackError("Notifications.notificationsDeleteEndpoints",e);
                  throw e;
               }
            }
         },function(param1:NotificationsDeleteEndpointsError):void
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

