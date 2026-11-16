package com.game_objects
{
   import com.math.*;
   import flash.display.*;
   import flash.geom.*;
   import starling.display.Image;
   import starling.textures.*;
   
   public class FrozenCube extends Image
   {
      
      private var topLeft_point:Point = new Point(0,0);
      
      private var topRight_point:Point;
      
      private var bottomLeft_point:Point;
      
      private var bottomRight_point:Point;
      
      private var bounds_rect:Rectangle;
      
      private var last_point:Point;
      
      private var __originalX:Number;
      
      private var __originalY:Number;
      
      public function FrozenCube(param1:Rectangle)
      {
         var _loc2_:Shape = new Shape();
         this.bottomLeft_point = new Point(0,0 + param1.height);
         this.bottomRight_point = new Point(0 + param1.width,0 + param1.height);
         this.topRight_point = new Point(0 + param1.width,0);
         this.last_point = new Point(this.bottomLeft_point.x,this.bottomLeft_point.y);
         _loc2_.graphics.lineStyle(2,1938374);
         _loc2_.graphics.moveTo(this.last_point.x,this.last_point.y);
         _loc2_.graphics.beginFill(12444917);
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 1;
         while(_loc5_ < 10)
         {
            _loc3_ = Math.abs(CalcDist.getDistX(this.bottomLeft_point.x,this.bottomRight_point.x) / 10);
            this.last_point.x += _loc3_;
            this.last_point.y = this.bottomLeft_point.y + Math.random() * 10 * RanOne.ranOne();
            _loc2_.graphics.lineTo(this.last_point.x,this.last_point.y);
            _loc5_++;
         }
         this.last_point.x = this.bottomRight_point.x;
         this.last_point.y = this.bottomRight_point.y;
         _loc2_.graphics.lineTo(this.last_point.x,this.last_point.y);
         _loc5_ = 1;
         while(_loc5_ < 10)
         {
            _loc4_ = Math.abs(CalcDist.getDistY(this.bottomRight_point.y,this.topRight_point.y) / 10);
            this.last_point.x = this.bottomRight_point.x + Math.random() * 10 * RanOne.ranOne();
            this.last_point.y -= _loc4_;
            _loc2_.graphics.lineTo(this.last_point.x,this.last_point.y);
            _loc5_++;
         }
         this.last_point.x = this.topRight_point.x;
         this.last_point.y = this.topRight_point.y;
         _loc2_.graphics.lineTo(this.last_point.x,this.last_point.y);
         _loc5_ = 1;
         while(_loc5_ < 10)
         {
            _loc3_ = Math.abs(CalcDist.getDistX(this.topRight_point.x,this.topLeft_point.x) / 10);
            this.last_point.x -= _loc3_;
            this.last_point.y = this.topLeft_point.y + Math.random() * 10 * RanOne.ranOne();
            _loc2_.graphics.lineTo(this.last_point.x,this.last_point.y);
            _loc5_++;
         }
         this.last_point.x = this.topLeft_point.x;
         this.last_point.y = this.topRight_point.y;
         _loc2_.graphics.lineTo(this.last_point.x,this.last_point.y);
         _loc5_ = 1;
         while(_loc5_ < 10)
         {
            _loc4_ = Math.abs(CalcDist.getDistY(this.topLeft_point.y,this.bottomLeft_point.y) / 10);
            this.last_point.x = this.bottomLeft_point.x + Math.random() * 10 * RanOne.ranOne();
            this.last_point.y += _loc4_;
            _loc2_.graphics.lineTo(this.last_point.x,this.last_point.y);
            _loc5_++;
         }
         this.last_point.x = this.bottomLeft_point.x;
         this.last_point.y = this.bottomLeft_point.y;
         _loc2_.graphics.lineTo(this.last_point.x,this.last_point.y);
         _loc2_.graphics.endFill();
         this.__originalX = this.topLeft_point.x;
         this.__originalY = this.topLeft_point.y;
         var _loc6_:BitmapData = new BitmapData(_loc2_.width,_loc2_.height,true,0);
         _loc6_.draw(_loc2_);
         touchable = false;
         super(Texture.fromBitmapData(_loc6_));
         alpha = 0.7;
      }
      
      override public function set x(param1:Number) : void
      {
         super.x = param1 - this.__originalX;
      }
      
      override public function set y(param1:Number) : void
      {
         super.y = param1 - this.__originalY;
      }
      
      override public function dispose() : void
      {
         texture.dispose();
         super.dispose();
      }
   }
}

