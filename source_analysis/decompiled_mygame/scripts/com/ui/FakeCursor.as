package com.ui
{
   import com.math.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import starling.core.*;
   import starling.display.DisplayObject;
   import starling.events.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2246")]
   public final class FakeCursor extends Sprite
   {
      
      private var location:Point = new Point();
      
      private var movePowerX:Number = 0;
      
      private var movePowerY:Number = 0;
      
      private var previousX:int = 0;
      
      private var previousY:int = 0;
      
      public function FakeCursor()
      {
         super();
      }
      
      public function mouseDown() : void
      {
         var _loc1_:MouseEvent = null;
         this.location.setTo(x,y);
         var _loc2_:starling.display.DisplayObject = GameMain(root).starlingStage.hitTest(this.location);
         if(_loc2_ != null)
         {
            Starling.current.touchProcessor.enqueue(0,TouchPhase.BEGAN,x,y);
         }
         var _loc3_:InteractiveObject = this.hitTestTop(GameMain(root));
         if(_loc3_ != null)
         {
            _loc1_ = new MouseEvent(MouseEvent.MOUSE_DOWN);
            _loc3_.dispatchEvent(_loc1_);
         }
      }
      
      public function mouseUp() : void
      {
         var _loc1_:MouseEvent = null;
         var _loc2_:MouseEvent = null;
         this.location.setTo(x,y);
         var _loc3_:starling.display.DisplayObject = GameMain(root).starlingStage.hitTest(this.location);
         if(_loc3_ != null)
         {
            Starling.current.touchProcessor.enqueue(0,TouchPhase.ENDED,x,y);
         }
         var _loc4_:InteractiveObject = this.hitTestTop(GameMain(root));
         if(_loc4_ != null)
         {
            _loc1_ = new MouseEvent(MouseEvent.MOUSE_UP);
            _loc2_ = new MouseEvent(MouseEvent.CLICK);
            _loc4_.dispatchEvent(_loc1_);
            _loc4_.dispatchEvent(_loc2_);
         }
      }
      
      public function onEnter() : void
      {
         this.previousX = x;
         this.previousY = y;
         this.move(this.movePowerX,this.movePowerY);
         parent.setChildIndex(this,parent.numChildren - 1);
      }
      
      public function startMoveX(param1:Number) : void
      {
         this.movePowerX = param1 * 18;
      }
      
      public function startMoveY(param1:Number) : void
      {
         this.movePowerY = param1 * 18;
      }
      
      private function move(param1:Number, param2:Number) : void
      {
         var _loc3_:InteractiveObject = null;
         var _loc4_:MouseEvent = null;
         x += param1;
         y += param2;
         this.location.setTo(x,y);
         if(x < 0)
         {
            x = 0;
         }
         else if(x > Starling.current.viewPort.width)
         {
            x = Starling.current.viewPort.width;
         }
         if(y < 0)
         {
            y = 0;
         }
         else if(y > Starling.current.viewPort.height)
         {
            y = Starling.current.viewPort.height;
         }
         if(CalcDist.getDistNumbers(x,y,this.previousX,this.previousY) > 4)
         {
            Starling.current.touchProcessor.enqueue(0,TouchPhase.HOVER,x,y);
            _loc3_ = this.hitTestTop(GameMain(root));
            if(_loc3_ != null)
            {
               _loc4_ = new MouseEvent(MouseEvent.MOUSE_MOVE);
               _loc3_.dispatchEvent(_loc4_);
            }
         }
      }
      
      private function hitTestTop(param1:DisplayObjectContainer) : InteractiveObject
      {
         var _loc2_:flash.display.DisplayObject = null;
         var _loc3_:InteractiveObject = null;
         var _loc4_:uint = uint(param1.numChildren);
         var _loc5_:Point = new Point(x,y);
         _loc5_ = param1.globalToLocal(_loc5_);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc2_ = param1.getChildAt(_loc6_);
            if(_loc2_ != this && _loc2_ is InteractiveObject && Boolean(InteractiveObject(_loc2_).mouseEnabled) && _loc2_.getBounds(param1).contains(_loc5_.x,_loc5_.y))
            {
               if(!(_loc2_ is DisplayObjectContainer) || DisplayObjectContainer(_loc2_).mouseChildren == false)
               {
                  return InteractiveObject(_loc2_);
               }
               _loc3_ = this.hitTestTop(DisplayObjectContainer(_loc2_));
               if(_loc3_ == null)
               {
                  return InteractiveObject(_loc2_);
               }
               return _loc3_;
            }
            _loc6_++;
         }
         return null;
      }
   }
}

