package com.apis
{
   import playerio.PlayerIOError;
   
   public final class GooglePlay
   {
      
      private static var googleGames:Object;
      
      private static var gameMain:GameMain;
      
      public function GooglePlay()
      {
         super();
      }
      
      public static function init(param1:GameMain) : void
      {
         gameMain = param1;
         if(AndroidIAB.isSupported())
         {
            AndroidIAB.create();
            AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.SERVICE_READY,onInitSuccess);
            AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.SERVICE_NOT_SUPPORTED,onInitError);
            AndroidIAB.androidIAB.startBillingService("MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAymNrMQng5GSD7guAqtd8Vx6LVMJtwnKe8VTklr/vvic0ENmRW69JO6xTqTnCfB5TxtL4At3nbw3hnufqQgG3AYWAjR06YDVv43ccRHIP/cKgeHUWtwRIpDv/DIb9L4KMTJai4h71ulwJ+i6ERnjUXpug8l9Q4gphUYlBQs4OQ2qzMSeMo/f9DjM600D7QvgmVNgmCYRAiqjD5obu4dGMEy1auZC10EOB3aV6LUJk1sV9SFJHnPEIjVU9/uKIoJmPj7fD37T5ucwernHDuIVbMwqUAQGnJcsq55/NRpgNU616vgnEfIiPM1okAuYAaAX2gKtsdJV7nJvGXVllzzCx6wIDAQAB");
         }
      }
      
      private static function onInitSuccess(param1:Object) : void
      {
         AndroidIAB.androidIAB.loadPlayerInventory();
         AndroidIAB.androidIAB.removeEventListener(AndroidBillingEvent.SERVICE_READY,onInitSuccess);
         AndroidIAB.androidIAB.removeEventListener(AndroidBillingEvent.SERVICE_NOT_SUPPORTED,onInitError);
         AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.PURCHASE_SUCCEEDED,onPurchaseSuccess);
         AndroidIAB.androidIAB.addEventListener(AndroidBillingErrorEvent.PURCHASE_FAILED,onPurchaseError);
         AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.CONSUME_SUCCEEDED,onConsumeSucceeded);
         AndroidIAB.androidIAB.addEventListener(AndroidBillingErrorEvent.CONSUME_FAILED,onConsumeFailed);
      }
      
      private static function onInitError(param1:Object) : void
      {
         AndroidIAB.androidIAB.removeEventListener(AndroidBillingEvent.SERVICE_NOT_SUPPORTED,onInitError);
         gameMain.createAlert("In app billing will not work on this phone");
      }
      
      public static function checkRestore() : void
      {
         AndroidIAB.androidIAB.loadPlayerInventory();
         if(AndroidIAB.androidIAB.hasEventListener(AndroidBillingEvent.INVENTORY_LOADED) == false)
         {
            AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.INVENTORY_LOADED,onPurchaseRestore);
            AndroidIAB.androidIAB.addEventListener(AndroidBillingErrorEvent.LOAD_INVENTORY_FAILED,onPurchaseRestoreError);
         }
      }
      
      private static function onPurchaseSuccess(param1:Object) : void
      {
         gameMain.createAlert("You\'ve purchased: " + param1.purchases[0].itemId,true);
         AndroidIAB.androidIAB.consumeItem(param1.purchases[0].itemId);
      }
      
      private static function onPurchaseError(param1:Object) : void
      {
         gameMain.createAlert("Google Play purchase error.");
      }
      
      private static function onPurchaseRestore(param1:Object) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in param1.purchases)
         {
            gameMain.createAlert("Registered purchase: " + _loc2_.itemId,true);
            AndroidIAB.androidIAB.consumeItem(_loc2_.itemId);
            if(_loc2_.purchaseState == AndroidPurchase.STATE_REFUNDED)
            {
               gameMain.theConnection.send("ban","Banned for payment reversal");
            }
         }
      }
      
      private static function onPurchaseRestoreError(param1:Object) : void
      {
         gameMain.createAlert("Google Play purchase restore failed");
      }
      
      private static function onConsumeSucceeded(param1:Object) : void
      {
         var info_object:Object = null;
         var e:Object = param1;
         gameMain.createAlert("Google Play tickets consumed",true);
         info_object = new Object();
         info_object.inapp_signed_data = e.jsonData;
         info_object.inapp_signature = e.signature;
         gameMain.theClient.payVault.usePaymentInfo("googleplayv2",info_object,function(param1:Object):void
         {
            gameMain.createAlert("PlayerIO purchase success",true);
         },function(param1:PlayerIOError):void
         {
            gameMain.createAlert(param1.message);
         });
      }
      
      private static function onConsumeFailed(param1:Object) : void
      {
         gameMain.createAlert("Google play tickets consumption failed");
      }
      
      public static function purchaseItem(param1:String) : void
      {
         AndroidIAB.androidIAB.purchaseItem(param1);
      }
      
      private static function onSignedIn(param1:Object) : void
      {
         gameMain.createAlert("player signed in – ready to use google games services!");
      }
      
      private static function onSignInFailed(param1:Object) : void
      {
         gameMain.createAlert("something went wrong signing in.");
      }
      
      private static function onSignedOut(param1:Object) : void
      {
         gameMain.createAlert("player signed out.");
      }
   }
}

