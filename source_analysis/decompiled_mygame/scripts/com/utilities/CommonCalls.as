package com.utilities
{
   import flash.display.DisplayObject;
   import flash.geom.*;
   import starling.MainStarlingStage;
   import starling.core.*;
   import starling.display.DisplayObject;
   import starling.display.Image;
   
   public class CommonCalls
   {
      
      public static var starlingMain:MainStarlingStage;
      
      private static var point:Point = new Point();
      
      public function CommonCalls()
      {
         super();
      }
      
      public static function returnObject(param1:*, param2:String) : Object
      {
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(param1[_loc4_].name == param2)
            {
               return param1[_loc4_];
            }
            _loc4_++;
         }
         return null;
      }
      
      public static function getTotalXPToReachLevel(param1:int) : uint
      {
         var _loc2_:uint = new uint(0);
         var _loc3_:uint = 1;
         while(_loc3_ <= param1 - 1)
         {
            _loc2_ += uint(_loc3_ * (_loc3_ * 1.1 + 50));
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function onScreen(param1:int, param2:int, param3:Boolean = true, param4:Boolean = false) : Boolean
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:int = param4 ? int(starlingMain.c_mc.x) : param1;
         var _loc8_:int = param4 ? int(starlingMain.c_mc.y) : param2;
         if(param4)
         {
            _loc7_ += param1;
            _loc8_ += param2;
         }
         if(param3)
         {
            _loc5_ = Starling.current.viewPort.width / Starling.contentScaleFactor + 100 / Starling.contentScaleFactor;
            _loc6_ = Starling.current.viewPort.height / Starling.contentScaleFactor + 100 / Starling.contentScaleFactor;
            if(_loc7_ > -100 && _loc7_ < _loc5_ && _loc8_ > -100 && _loc8_ < _loc6_)
            {
               return true;
            }
            return false;
         }
         _loc5_ = Starling.current.viewPort.width / Starling.contentScaleFactor;
         _loc6_ = Starling.current.viewPort.height / Starling.contentScaleFactor;
         if(_loc7_ > 0 && _loc7_ < _loc5_ && _loc8_ > 0 && _loc8_ < _loc6_)
         {
            return true;
         }
         return false;
      }
      
      public static function arrayRemove(param1:Array, param2:flash.display.DisplayObject, param3:Boolean) : Boolean
      {
         var _loc4_:int = int(param1.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(param1[_loc5_] == param2)
            {
               if(param3)
               {
                  param1[_loc5_].parent.removeChild(param1[_loc5_]);
               }
               param1.removeAt(_loc5_);
               return true;
            }
            _loc5_++;
         }
         return false;
      }
      
      public static function removeObject(param1:flash.display.DisplayObject, param2:Array = null) : void
      {
         if(param1.parent != null)
         {
            if(param2 == null)
            {
               param1.parent.removeChild(param1);
            }
            else
            {
               arrayRemove(param2,param1,true);
            }
         }
      }
      
      public static function emptyArray(param1:*, param2:Boolean, param3:Boolean = false) : void
      {
         var _loc4_:int = int(param1.length);
         var _loc5_:* = int(_loc4_ - 1);
         while(_loc5_ >= 0)
         {
            if(param1[_loc5_].parent != null && param2)
            {
               if(param3 == false)
               {
                  param1[_loc5_].parent.removeChild(param1[_loc5_]);
               }
               else
               {
                  param1[_loc5_].parent.removeChild(param1[_loc5_],param3);
               }
            }
            param1.pop();
            _loc5_--;
         }
      }
      
      public static function countString(param1:Vector.<String>, param2:String) : uint
      {
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         for each(_loc3_ in param1)
         {
            if(_loc3_ == param2)
            {
               _loc4_++;
            }
         }
         return _loc4_;
      }
      
      public static function getHighestChildIndex(param1:Vector.<starling.display.DisplayObject>) : int
      {
         var _loc2_:starling.display.DisplayObject = null;
         var _loc3_:int = -1;
         var _loc4_:int = -1;
         for each(_loc2_ in param1)
         {
            _loc4_ = _loc2_.parent.getChildIndex(_loc2_);
            if(_loc4_ >= _loc3_)
            {
               _loc3_ = _loc4_;
            }
         }
         return _loc3_;
      }
      
      public static function getLowestChildIndex(param1:Vector.<starling.display.DisplayObject>) : int
      {
         var _loc2_:starling.display.DisplayObject = null;
         var _loc3_:int = int.MAX_VALUE;
         var _loc4_:int = -1;
         for each(_loc2_ in param1)
         {
            _loc4_ = _loc2_.parent.getChildIndex(_loc2_);
            if(_loc4_ <= _loc3_)
            {
               _loc3_ = _loc4_;
            }
         }
         return _loc3_;
      }
      
      public static function uintToCommaString(param1:uint) : String
      {
         return String(param1).replace(/\d{1,3}(?=(\d{3})+(?!\d))/g,"$&,");
      }
      
      public static function intToCommaString(param1:int) : String
      {
         return String(param1).replace(/\d{1,3}(?=(\d{3})+(?!\d))/g,"$&,");
      }
      
      public static function numberToCommaString(param1:Number) : String
      {
         return String(param1).replace(/\d{1,3}(?=(\d{3})+(?!\d))/g,"$&,");
      }
      
      public static function removeAndFullyDispose(param1:Image) : void
      {
         param1.texture.dispose();
         param1.removeFromParent(true);
      }
   }
}

