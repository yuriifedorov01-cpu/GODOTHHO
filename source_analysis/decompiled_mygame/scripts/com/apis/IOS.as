package com.apis
{
   import playerio.PlayerIOError;
   
   public final class IOS
   {
      
      private static var gameMain:GameMain;
      
      public function IOS()
      {
         super();
      }
      
      public static function init(param1:GameMain) : void
      {
         var _loc2_:Vector.<String> = null;
         gameMain = param1;
         if(StoreKit.isSupported())
         {
            StoreKit.create();
            if(StoreKit.storeKit.isStoreKitAvailable())
            {
               _loc2_ = new Vector.<String>();
               _loc2_.push("helmetheroes.coins10");
               _loc2_.push("helmetheroes.coins50");
               _loc2_.push("helmetheroes.coins100");
               _loc2_.push("helmetheroes.coins220");
               _loc2_.push("helmetheroes.coins450");
               _loc2_.push("helmetheroes.coins1300");
               _loc2_.push("helmetheroes.coins2800");
               StoreKit.storeKit.loadProductDetails(_loc2_);
               StoreKit.storeKit.addEventListener(StoreKitEvent.PRODUCT_DETAILS_LOADED,onProductsLoaded);
               StoreKit.storeKit.addEventListener(StoreKitErrorEvent.PRODUCT_DETAILS_FAILED,onProductsLoadedFailed);
               StoreKit.storeKit.addEventListener(StoreKitEvent.PURCHASE_SUCCEEDED,onPurchaseSuccess);
               StoreKit.storeKit.addEventListener(StoreKitEvent.PURCHASE_CANCELLED,onPurchaseCancelled);
               StoreKit.storeKit.addEventListener(StoreKitEvent.PURCHASE_DEFERRED,onPurchaseDeferred);
               StoreKit.storeKit.addEventListener(StoreKitErrorEvent.PURCHASE_FAILED,onPurchaseFailed);
            }
         }
      }
      
      public static function purchaseItem(param1:uint) : void
      {
         StoreKit.storeKit.purchaseProduct("helmetheroes.coins" + param1);
      }
      
      private static function onProductsLoaded(param1:Object) : void
      {
      }
      
      private static function onProductsLoadedFailed(param1:Object) : void
      {
         gameMain.createAlert(StoreKitErrorEvent(param1).text);
      }
      
      private static function onPurchaseSuccess(param1:Object) : void
      {
         var e:Object = param1;
         var transaction_object:Object = new Object();
         transaction_object.transactionReceipt = StoreKitEvent(e).receipt;
         if(StoreKit.storeKit.isAppReceiptAvailable())
         {
            transaction_object.transactionReceipt = StoreKit.storeKit.getAppReceipt();
         }
         if(StoreKitEvent(e).receipt != null)
         {
            gameMain.theClient.payVault.usePaymentInfo("ios",transaction_object,function(param1:Object):void
            {
               gameMain.createAlert("PlayerIO purchase succes: " + param1.productId);
            },function(param1:PlayerIOError):void
            {
               gameMain.createAlert(param1.message);
            });
         }
      }
      
      private static function onPurchaseCancelled(param1:Object) : void
      {
         gameMain.createAlert("Purchase cancelled");
      }
      
      private static function onPurchaseDeferred(param1:Object) : void
      {
         gameMain.createAlert("Unable to make purchases on this device.  Check parental controls.");
      }
      
      private static function onPurchaseFailed(param1:Object) : void
      {
         gameMain.createAlert("Purchase error: " + StoreKitErrorEvent(param1).text);
      }
      
      public static function paymentsSupported() : Boolean
      {
         if(StoreKit.isSupported())
         {
            return StoreKit.storeKit.isStoreKitAvailable();
         }
         return false;
      }
   }
}

