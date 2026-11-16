package com.utilities
{
   import flash.display.*;
   import flash.text.*;
   
   public class SiteLock
   {
      
      private static var url:String;
      
      private static var urlStart:Number;
      
      private static var urlEnd:Number;
      
      private static var domain:String;
      
      private static var lastDot:Number;
      
      private static var domEnd:Number;
      
      private static var a:int;
      
      private static var i:int;
      
      private static var len:int;
      
      private static var bitmap:Bitmap;
      
      private static var lock_txt:TextField;
      
      private static var bitmapData:BitmapData = new BitmapData(1000,1000,false,0);
      
      private static var textFormat:TextFormat = new TextFormat("arial",22,14483456);
      
      public function SiteLock()
      {
         super();
      }
      
      public static function to(param1:Stage, param2:Array) : void
      {
         bitmap = new Bitmap(bitmapData);
         param1.addChild(bitmap);
         lock_txt = new TextField();
         lock_txt.text = "Sorry, this game is site-locked to" + "\n" + param2[0] + "\n \n" + "Please try looking for this game on another site.";
         lock_txt.width = param1.stageWidth;
         lock_txt.height = 400;
         lock_txt.x = 0;
         lock_txt.y = param1.stageHeight / 3;
         lock_txt.selectable = false;
         textFormat.align = "center";
         lock_txt.setTextFormat(textFormat);
         param1.addChild(lock_txt);
         getHostedURL(param1);
         len = param2.length;
         i = 0;
         while(i < len)
         {
            if(domain == param2[i])
            {
               param1.removeChild(bitmap);
               param1.removeChild(lock_txt);
               break;
            }
            ++i;
         }
      }
      
      public static function getHostedURL(param1:Object) : String
      {
         url = param1.loaderInfo.url;
         urlStart = url.indexOf("://") + 3;
         urlEnd = url.indexOf("/",urlStart);
         domain = url.substring(urlStart,urlEnd);
         lastDot = domain.lastIndexOf(".") - 1;
         domEnd = domain.lastIndexOf(".",lastDot) + 1;
         domain = domain.substring(domEnd,domain.length);
         return domain;
      }
      
      public static function getMainDomainString(param1:String) : String
      {
         urlStart = param1.indexOf("://") + 3;
         urlEnd = param1.indexOf("/",urlStart);
         domain = param1.substring(urlStart,urlEnd);
         lastDot = domain.lastIndexOf(".") - 1;
         domEnd = domain.lastIndexOf(".",lastDot) + 1;
         domain = domain.substring(domEnd,domain.length);
         return domain;
      }
   }
}

