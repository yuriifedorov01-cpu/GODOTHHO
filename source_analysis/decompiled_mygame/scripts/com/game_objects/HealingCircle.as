package com.game_objects
{
   import com.math.*;
   import flash.display.Shape;
   import starling.display.DisplayObject;
   
   public class HealingCircle extends Shape
   {
      
      public var counter:int;
      
      public var fakeRotation:int;
      
      public var healTarget:DisplayObject;
      
      public function HealingCircle(param1:DisplayObject)
      {
         super();
         this.counter = new int(0);
         this.fakeRotation = new int(0);
         this.healTarget = param1;
         graphics.lineStyle(2,102173);
         graphics.beginFill(4587077);
         graphics.drawCircle(0,0,20);
         graphics.endFill();
         alpha = 0.6;
      }
      
      public function gotoTarget() : void
      {
         if(this.healTarget != null && this.healTarget.parent != null)
         {
            this.fakeRotation = RotateTo.rotTo(x,this.healTarget.x,y,this.healTarget.y);
            x += MoveTo.getDirX(10,this.fakeRotation - 90);
            y += MoveTo.getDirY(10,this.fakeRotation - 90);
            scaleX = scaleY = 600 / CalcDist.getDistNumbers(x,y,this.healTarget.x,this.healTarget.y);
            if(scaleX > 1.5)
            {
               scaleX = scaleY = 1.5;
            }
         }
      }
   }
}

