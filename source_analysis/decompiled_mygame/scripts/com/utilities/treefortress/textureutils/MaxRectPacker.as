package com.utilities.treefortress.textureutils
{
   import flash.geom.*;
   
   public class MaxRectPacker
   {
      
      public var freeRectangles:Vector.<Rectangle>;
      
      protected var binWidth:Number;
      
      protected var binHeight:Number;
      
      public function MaxRectPacker(param1:Number, param2:Number)
      {
         super();
         this.init(param1,param2);
      }
      
      public function init(param1:Number, param2:Number) : void
      {
         this.binWidth = param1;
         this.binHeight = param2;
         this.freeRectangles = new Vector.<Rectangle>(0);
         this.freeRectangles.push(new Rectangle(0,0,param1,param2));
      }
      
      public function quickInsert(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Rectangle = this.quickFindPositionForNewNodeBestAreaFit(param1,param2);
         if(_loc3_.height == 0)
         {
            return null;
         }
         var _loc4_:* = int(this.freeRectangles.length);
         var _loc5_:* = 0;
         while(_loc5_ < _loc4_)
         {
            if(this.splitFreeNode(this.freeRectangles[_loc5_],_loc3_))
            {
               this.freeRectangles.removeAt(_loc5_);
               _loc4_--;
               _loc5_--;
            }
            _loc5_++;
         }
         this.pruneFreeList();
         return _loc3_;
      }
      
      final protected function quickFindPositionForNewNodeBestAreaFit(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Number = Number(NaN);
         var _loc4_:Rectangle = null;
         var _loc5_:int = int.MAX_VALUE;
         var _loc6_:Rectangle = new Rectangle();
         var _loc7_:int = 0;
         var _loc8_:int = int(this.freeRectangles.length);
         while(_loc7_ < _loc8_)
         {
            _loc4_ = this.freeRectangles[_loc7_];
            if(_loc4_.width >= param1 && _loc4_.height >= param2)
            {
               _loc3_ = _loc4_.width * _loc4_.height - param1 * param2;
               if(_loc3_ < _loc5_)
               {
                  _loc6_.x = _loc4_.x;
                  _loc6_.y = _loc4_.y;
                  _loc6_.width = param1;
                  _loc6_.height = param2;
                  _loc5_ = _loc3_;
               }
            }
            _loc7_++;
         }
         return _loc6_;
      }
      
      protected function splitFreeNode(param1:Rectangle, param2:Rectangle) : Boolean
      {
         var _loc3_:Rectangle = null;
         if(param2.x >= param1.x + param1.width || param2.x + param2.width <= param1.x || param2.y >= param1.y + param1.height || param2.y + param2.height <= param1.y)
         {
            return false;
         }
         if(param2.x < param1.x + param1.width && param2.x + param2.width > param1.x)
         {
            if(param2.y > param1.y && param2.y < param1.y + param1.height)
            {
               _loc3_ = param1.clone();
               _loc3_.height = param2.y - _loc3_.y;
               this.freeRectangles.push(_loc3_);
            }
            if(param2.y + param2.height < param1.y + param1.height)
            {
               _loc3_ = param1.clone();
               _loc3_.y = param2.y + param2.height;
               _loc3_.height = param1.y + param1.height - (param2.y + param2.height);
               this.freeRectangles.push(_loc3_);
            }
         }
         if(param2.y < param1.y + param1.height && param2.y + param2.height > param1.y)
         {
            if(param2.x > param1.x && param2.x < param1.x + param1.width)
            {
               _loc3_ = param1.clone();
               _loc3_.width = param2.x - _loc3_.x;
               this.freeRectangles.push(_loc3_);
            }
            if(param2.x + param2.width < param1.x + param1.width)
            {
               _loc3_ = param1.clone();
               _loc3_.x = param2.x + param2.width;
               _loc3_.width = param1.x + param1.width - (param2.x + param2.width);
               this.freeRectangles.push(_loc3_);
            }
         }
         return true;
      }
      
      protected function pruneFreeList() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:Rectangle = null;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:* = int(this.freeRectangles.length);
         while(_loc3_ < _loc5_)
         {
            _loc4_ = int(_loc3_ + 1);
            _loc1_ = this.freeRectangles[_loc3_];
            while(_loc4_ < _loc5_)
            {
               _loc2_ = this.freeRectangles[_loc4_];
               if(this.isContainedIn(_loc1_,_loc2_))
               {
                  this.freeRectangles.removeAt(_loc3_);
                  _loc3_--;
                  _loc5_--;
                  break;
               }
               if(this.isContainedIn(_loc2_,_loc1_))
               {
                  this.freeRectangles.removeAt(_loc4_);
                  _loc5_--;
                  _loc4_--;
               }
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      final protected function isContainedIn(param1:Rectangle, param2:Rectangle) : Boolean
      {
         return param1.x >= param2.x && param1.y >= param2.y && param1.x + param1.width <= param2.x + param2.width && param1.y + param1.height <= param2.y + param2.height;
      }
   }
}

