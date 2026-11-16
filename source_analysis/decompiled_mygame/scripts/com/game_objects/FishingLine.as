package com.game_objects
{
   import com.helpers.*;
   import com.utilities.*;
   import flash.display.*;
   import flash.geom.*;
   import starling.*;
   import starling.display.*;
   import starling.events.*;
   import starling.textures.*;
   
   public class FishingLine extends starling.display.Sprite
   {
      
      public static var all_array:Vector.<FishingLine> = new Vector.<FishingLine>();
      
      private var bobber:Image;
      
      private var line:Image;
      
      private var radiusCircle:Image;
      
      private var __global_point:Point;
      
      private var __lineLength:int = 0;
      
      private var counter:int = 0;
      
      public var radius:int;
      
      private var __stopped:Boolean = false;
      
      private var __stopSink:Boolean = false;
      
      public var creator:Person;
      
      public var bite_date:Date;
      
      private var __caughtFish:Fish;
      
      public function FishingLine(param1:Person)
      {
         super();
         this.__global_point = new Point(param1.getBounds(param1.parent).x + (param1.moveDir > 0 ? param1.width - 5 : 5),param1.y + 35);
         if(param1.ridingPet != null)
         {
            this.__global_point.y += 10;
            this.__global_point.x -= param1.moveDir > 0 ? 5 : 0;
         }
         this.radius = param1.hasBaitExtend ? 80 : 50;
         this.creator = param1;
         this.bobber = new Image(Assets.items_textureAtlas.getTexture("fish bobber"));
         this.bobber.x = this.__global_point.x;
         this.bobber.y = this.__global_point.y;
         this.bobber.pivotX = this.bobber.pivotY = 4;
         addChild(this.bobber);
         this.line = new Image(Assets.items_textureAtlas.getTexture("dark gray pixel"));
         this.line.width = 2;
         this.line.x = this.bobber.x;
         this.line.y = this.bobber.y;
         addChildAt(this.line,getChildIndex(this.bobber));
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
         touchable = false;
         all_array.push(this);
      }
      
      public static function checkSpot(param1:int, param2:int, param3:MainStarlingStage) : Boolean
      {
         if(TileHandler.waterHit_bitmapData.getPixel(param1,param2) > 0)
         {
            return true;
         }
         return false;
      }
      
      public function onEnter() : void
      {
         var _loc1_:Shape = null;
         var _loc2_:BitmapData = null;
         ++this.counter;
         if(checkSpot(this.bobber.x,this.bobber.y,MainStarlingStage(root)) == true && this.__stopSink == false)
         {
            this.bobber.y += 2;
            this.line.height += 2;
            this.__lineLength += 2;
         }
         else
         {
            this.__stopped = true;
         }
         if(Boolean(this.__stopped) && Boolean(this.bobber.visible) && this.creator.isPlayer)
         {
            if(this.radiusCircle == null)
            {
               _loc1_ = new Shape();
               _loc1_.graphics.lineStyle(3,16777215);
               _loc1_.graphics.drawCircle(this.radius,this.radius,this.radius);
               _loc2_ = new BitmapData(_loc1_.width,_loc1_.height,true,0);
               _loc2_.draw(_loc1_);
               this.radiusCircle = new Image(Texture.fromBitmapData(_loc2_));
               this.radiusCircle.x = this.bobber.x;
               this.radiusCircle.y = this.bobber.y;
               this.radiusCircle.pivotX = this.radiusCircle.pivotY = this.radiusCircle.height / 2;
               this.radiusCircle.alpha = 0.6;
               addChild(this.radiusCircle);
            }
            else
            {
               this.radiusCircle.alpha = this.counter % 20 == 0 ? 0.1 : 0.5;
            }
         }
      }
      
      private function onRemoved(param1:Event) : void
      {
         if(this.radiusCircle != null)
         {
            this.radiusCircle.texture.dispose();
         }
         stage.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
         var _loc2_:int = int(all_array.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(all_array[_loc3_] == this)
            {
               all_array.removeAt(_loc3_);
               break;
            }
            _loc3_++;
         }
      }
      
      public function get global_point() : Point
      {
         this.__global_point.x = this.bobber.x;
         this.__global_point.y = this.bobber.y;
         this.__global_point = localToGlobal(this.__global_point);
         this.__global_point = parent.globalToLocal(this.__global_point);
         return this.__global_point;
      }
      
      public function get lineLength() : int
      {
         return this.__lineLength;
      }
      
      public function get stopped() : Boolean
      {
         return this.__stopped;
      }
      
      public function set stopSink(param1:Boolean) : void
      {
         this.__stopSink = param1;
      }
      
      public function set caughtFish(param1:Fish) : void
      {
         this.__caughtFish = param1;
         this.bobber.visible = this.__caughtFish == null ? true : false;
         this.bite_date = new Date();
      }
      
      public function get caughtFish() : Fish
      {
         return this.__caughtFish;
      }
   }
}

