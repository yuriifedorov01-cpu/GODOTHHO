package com.utilities
{
   import flash.filesystem.*;
   import flash.utils.ByteArray;
   
   public class AssetManagerFileChecker
   {
      
      public function AssetManagerFileChecker()
      {
         super();
      }
      
      public function fileExists(param1:String) : Boolean
      {
         return File.applicationStorageDirectory.resolvePath(param1).exists;
      }
      
      public function saveFile(param1:String, param2:ByteArray) : void
      {
         var _loc3_:File = File.applicationStorageDirectory.resolvePath(param1);
         var _loc4_:FileStream = new FileStream();
         _loc4_.open(_loc3_,FileMode.WRITE);
         _loc4_.writeBytes(param2,0,param2.length);
         _loc4_.close();
      }
      
      public function getFile(param1:String) : Object
      {
         return File.applicationStorageDirectory.resolvePath(param1);
      }
   }
}

