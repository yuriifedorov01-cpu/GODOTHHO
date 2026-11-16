package com.visual_effects
{
   import flash.display.*;
   import flash.geom.*;
   
   public class DrawToBitmap extends Bitmap
   {
      
      private static var bitmap:Bitmap;
      
      private static var bitmapData:BitmapData;
      
      private static var global_point:Point = new Point();
      
      public function DrawToBitmap()
      {
         super();
      }
      
      public static function drawAsBitmap(param1:DisplayObject, param2:String = "", param3:Boolean = true, param4:DisplayObjectContainer = null, param5:int = -1, param6:Boolean = true) : Bitmap
      {
         if(param2 == "")
         {
            param2 = "bitmap" + String(int(Math.random() * 3000));
         }
         var _loc7_:* = new Matrix();
         _loc7_.tx = Math.abs(param1.getBounds(param1).x);
         _loc7_.ty = Math.abs(param1.getBounds(param1).y);
         bitmapData = new BitmapData(param1.width + 5,param1.height + 5,true,4278190080);
         bitmapData.fillRect(bitmapData.rect,0);
         bitmapData.draw(param1,_loc7_);
         bitmap = new Bitmap(bitmapData);
         bitmap.name = param2;
         if(param4 != null)
         {
            bitmap.x = param1.getBounds(param1.parent).x;
            bitmap.y = param1.getBounds(param1.parent).y;
         }
         if(param1.scaleX == -1)
         {
            bitmap.scaleX = param1.scaleX;
            bitmap.x += param1.width;
         }
         if(param4 == null && param6)
         {
            param1.parent.addChildAt(bitmap,param1.parent.getChildIndex(param1));
         }
         else if(param6)
         {
            global_point.x = bitmap.x;
            global_point.y = bitmap.y;
            global_point = param1.parent.localToGlobal(global_point);
            global_point = param4.globalToLocal(global_point);
            bitmap.x = global_point.x;
            bitmap.y = global_point.y;
            if(param6)
            {
               if(param5 > -1)
               {
                  param4.addChildAt(bitmap,param5);
               }
               else
               {
                  param4.addChild(bitmap);
               }
            }
         }
         if(param3)
         {
            param1.parent.removeChild(param1);
         }
         return bitmap;
      }
      
      public static function cropTransparentPixels(param1:Bitmap) : void
      {
         var _loc2_:Rectangle = null;
         _loc2_ = null;
         var _loc3_:BitmapData = null;
         if(param1.width > 1 && param1.height > 1)
         {
            _loc2_ = param1.bitmapData.getColorBoundsRect(4278190080,0,false);
            _loc3_ = new BitmapData(_loc2_.width,_loc2_.height);
            _loc3_.copyPixels(param1.bitmapData,_loc2_,new Point(0,0));
            param1.bitmapData.dispose();
            param1.bitmapData = _loc3_;
            param1.x += _loc2_.x;
            param1.y += _loc2_.y;
         }
      }
      
      public static function combineAsBitmap(param1:Vector.<DisplayObject>) : Bitmap
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:Bitmap = null;
         if(param1.length == 0)
         {
            throw new Error("Must supply at least one object to be converted into a bitmap");
         }
         var _loc4_:Sprite = new Sprite();
         param1[0].parent.addChildAt(_loc4_,param1[0].parent.getChildIndex(param1[0]));
         for each(_loc2_ in param1)
         {
            _loc4_.addChild(_loc2_);
         }
         _loc3_ = drawAsBitmap(_loc4_,"");
         _loc3_.smoothing = true;
         return _loc3_;
      }
      
      public static function tileBitmapData(param1:BitmapData, param2:uint, param3:uint) : Vector.<Bitmap>
      {
         var _loc4_:Rectangle = null;
         var _loc5_:uint = 0;
         var _loc6_:BitmapData = null;
         var _loc7_:Bitmap = null;
         var _loc8_:Rectangle = new Rectangle(0,0,param2,param3);
         var _loc9_:Point = new Point(0,0);
         var _loc10_:Vector.<Bitmap> = new Vector.<Bitmap>();
         var _loc11_:uint = Math.ceil(param1.width / param2);
         var _loc12_:uint = Math.ceil(param1.height / param3);
         var _loc13_:uint = 0;
         while(_loc13_ < _loc11_)
         {
            _loc8_.x = _loc13_ * param2;
            _loc5_ = 0;
            while(_loc5_ < _loc12_)
            {
               _loc8_.y = _loc5_ * param3;
               _loc6_ = new BitmapData(_loc8_.width,_loc8_.height,true,0);
               _loc6_.copyPixels(param1,_loc8_,_loc9_);
               _loc4_ = _loc6_.getColorBoundsRect(4278190080,0,false);
               if(_loc4_.width > 0 && _loc4_.height > 0)
               {
                  _loc7_ = new Bitmap(_loc6_);
                  _loc7_.x = _loc13_ * param2;
                  _loc7_.y = _loc5_ * param3;
                  DrawToBitmap.cropTransparentPixels(_loc7_);
                  _loc10_.push(_loc7_);
               }
               _loc5_++;
            }
            _loc13_++;
         }
         return _loc10_;
      }
   }
}

