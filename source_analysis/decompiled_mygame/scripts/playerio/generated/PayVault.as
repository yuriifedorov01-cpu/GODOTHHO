package playerio.generated
{
   import flash.events.EventDispatcher;
   import playerio.Client;
   import playerio.generated.messages.*;
   import playerio.utils.*;
   
   public class PayVault extends EventDispatcher
   {
      
      protected var channel:HTTPChannel;
      
      protected var client:Client;
      
      public function PayVault(param1:HTTPChannel, param2:Client)
      {
         super();
         this.channel = param1;
         this.client = param2;
      }
      
      protected function _payVaultReadHistory(param1:uint, param2:uint, param3:String, param4:Function = null, param5:Function = null) : void
      {
         var page:uint = param1;
         var pageSize:uint = param2;
         var targetUserId:String = param3;
         var callback:Function = param4;
         var errorHandler:Function = param5;
         var input:PayVaultReadHistoryArgs = new PayVaultReadHistoryArgs(page,pageSize,targetUserId);
         var output:PayVaultReadHistoryOutput = new PayVaultReadHistoryOutput();
         this.channel.Request(160,input,output,new PayVaultReadHistoryError(),function(param1:PayVaultReadHistoryOutput):void
         {
            var output:PayVaultReadHistoryOutput = param1;
            if(callback != null)
            {
               try
               {
                  callback(output.entries);
               }
               catch(e:Error)
               {
                  client.handleCallbackError("PayVault.payVaultReadHistory",e);
                  throw e;
               }
            }
         },function(param1:PayVaultReadHistoryError):void
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
      
      protected function _payVaultRefresh(param1:String, param2:String, param3:Function = null, param4:Function = null) : void
      {
         var lastVersion:String = param1;
         var targetUserId:String = param2;
         var callback:Function = param3;
         var errorHandler:Function = param4;
         var input:PayVaultRefreshArgs = new PayVaultRefreshArgs(lastVersion,targetUserId);
         var output:PayVaultRefreshOutput = new PayVaultRefreshOutput();
         this.channel.Request(163,input,output,new PayVaultRefreshError(),function(param1:PayVaultRefreshOutput):void
         {
            var output:PayVaultRefreshOutput = param1;
            if(callback != null)
            {
               try
               {
                  callback(output.vaultContents);
               }
               catch(e:Error)
               {
                  client.handleCallbackError("PayVault.payVaultRefresh",e);
                  throw e;
               }
            }
         },function(param1:PayVaultRefreshError):void
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
      
      protected function _payVaultConsume(param1:Array, param2:String, param3:Function = null, param4:Function = null) : void
      {
         var ids:Array = param1;
         var targetUserId:String = param2;
         var callback:Function = param3;
         var errorHandler:Function = param4;
         var input:PayVaultConsumeArgs = new PayVaultConsumeArgs(ids,targetUserId);
         var output:PayVaultConsumeOutput = new PayVaultConsumeOutput();
         this.channel.Request(166,input,output,new PayVaultConsumeError(),function(param1:PayVaultConsumeOutput):void
         {
            var output:PayVaultConsumeOutput = param1;
            if(callback != null)
            {
               try
               {
                  callback(output.vaultContents);
               }
               catch(e:Error)
               {
                  client.handleCallbackError("PayVault.payVaultConsume",e);
                  throw e;
               }
            }
         },function(param1:PayVaultConsumeError):void
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
      
      protected function _payVaultCredit(param1:uint, param2:String, param3:String, param4:Function = null, param5:Function = null) : void
      {
         var amount:uint = param1;
         var reason:String = param2;
         var targetUserId:String = param3;
         var callback:Function = param4;
         var errorHandler:Function = param5;
         var input:PayVaultCreditArgs = new PayVaultCreditArgs(amount,reason,targetUserId);
         var output:PayVaultCreditOutput = new PayVaultCreditOutput();
         this.channel.Request(169,input,output,new PayVaultCreditError(),function(param1:PayVaultCreditOutput):void
         {
            var output:PayVaultCreditOutput = param1;
            if(callback != null)
            {
               try
               {
                  callback(output.vaultContents);
               }
               catch(e:Error)
               {
                  client.handleCallbackError("PayVault.payVaultCredit",e);
                  throw e;
               }
            }
         },function(param1:PayVaultCreditError):void
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
      
      protected function _payVaultDebit(param1:uint, param2:String, param3:String, param4:Function = null, param5:Function = null) : void
      {
         var amount:uint = param1;
         var reason:String = param2;
         var targetUserId:String = param3;
         var callback:Function = param4;
         var errorHandler:Function = param5;
         var input:PayVaultDebitArgs = new PayVaultDebitArgs(amount,reason,targetUserId);
         var output:PayVaultDebitOutput = new PayVaultDebitOutput();
         this.channel.Request(172,input,output,new PayVaultDebitError(),function(param1:PayVaultDebitOutput):void
         {
            var output:PayVaultDebitOutput = param1;
            if(callback != null)
            {
               try
               {
                  callback(output.vaultContents);
               }
               catch(e:Error)
               {
                  client.handleCallbackError("PayVault.payVaultDebit",e);
                  throw e;
               }
            }
         },function(param1:PayVaultDebitError):void
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
      
      protected function _payVaultBuy(param1:Array, param2:Boolean, param3:String, param4:Function = null, param5:Function = null) : void
      {
         var items:Array = param1;
         var storeItems:Boolean = param2;
         var targetUserId:String = param3;
         var callback:Function = param4;
         var errorHandler:Function = param5;
         var input:PayVaultBuyArgs = new PayVaultBuyArgs(items,storeItems,targetUserId);
         var output:PayVaultBuyOutput = new PayVaultBuyOutput();
         this.channel.Request(175,input,output,new PayVaultBuyError(),function(param1:PayVaultBuyOutput):void
         {
            var output:PayVaultBuyOutput = param1;
            if(callback != null)
            {
               try
               {
                  callback(output.vaultContents);
               }
               catch(e:Error)
               {
                  client.handleCallbackError("PayVault.payVaultBuy",e);
                  throw e;
               }
            }
         },function(param1:PayVaultBuyError):void
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
      
      protected function _payVaultGive(param1:Array, param2:String, param3:Function = null, param4:Function = null) : void
      {
         var items:Array = param1;
         var targetUserId:String = param2;
         var callback:Function = param3;
         var errorHandler:Function = param4;
         var input:PayVaultGiveArgs = new PayVaultGiveArgs(items,targetUserId);
         var output:PayVaultGiveOutput = new PayVaultGiveOutput();
         this.channel.Request(178,input,output,new PayVaultGiveError(),function(param1:PayVaultGiveOutput):void
         {
            var output:PayVaultGiveOutput = param1;
            if(callback != null)
            {
               try
               {
                  callback(output.vaultContents);
               }
               catch(e:Error)
               {
                  client.handleCallbackError("PayVault.payVaultGive",e);
                  throw e;
               }
            }
         },function(param1:PayVaultGiveError):void
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
      
      protected function _payVaultPaymentInfo(param1:String, param2:Object, param3:Array, param4:Function = null, param5:Function = null) : void
      {
         var provider:String = param1;
         var purchaseArguments:Object = param2;
         var items:Array = param3;
         var callback:Function = param4;
         var errorHandler:Function = param5;
         var input:PayVaultPaymentInfoArgs = new PayVaultPaymentInfoArgs(provider,Converter.toKeyValueArray(purchaseArguments),items);
         var output:PayVaultPaymentInfoOutput = new PayVaultPaymentInfoOutput();
         this.channel.Request(181,input,output,new PayVaultPaymentInfoError(),function(param1:PayVaultPaymentInfoOutput):void
         {
            var output:PayVaultPaymentInfoOutput = param1;
            if(callback != null)
            {
               try
               {
                  callback(Converter.toKeyValueObject(output.providerArguments));
               }
               catch(e:Error)
               {
                  client.handleCallbackError("PayVault.payVaultPaymentInfo",e);
                  throw e;
               }
            }
         },function(param1:PayVaultPaymentInfoError):void
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
      
      protected function _payVaultUsePaymentInfo(param1:String, param2:Object, param3:Function = null, param4:Function = null) : void
      {
         var provider:String = param1;
         var providerArguments:Object = param2;
         var callback:Function = param3;
         var errorHandler:Function = param4;
         var input:PayVaultUsePaymentInfoArgs = new PayVaultUsePaymentInfoArgs(provider,Converter.toKeyValueArray(providerArguments));
         var output:PayVaultUsePaymentInfoOutput = new PayVaultUsePaymentInfoOutput();
         this.channel.Request(184,input,output,new PayVaultUsePaymentInfoError(),function(param1:PayVaultUsePaymentInfoOutput):void
         {
            var output:PayVaultUsePaymentInfoOutput = param1;
            if(callback != null)
            {
               try
               {
                  callback(Converter.toKeyValueObject(output.providerResults),output.vaultContents);
               }
               catch(e:Error)
               {
                  client.handleCallbackError("PayVault.payVaultUsePaymentInfo",e);
                  throw e;
               }
            }
         },function(param1:PayVaultUsePaymentInfoError):void
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

