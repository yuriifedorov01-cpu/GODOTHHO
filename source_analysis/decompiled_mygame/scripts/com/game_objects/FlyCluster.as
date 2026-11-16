package com.game_objects
{
   import com.math.*;
   import com.utilities.*;
   import starling.display.*;
   import starling.utils.*;
   
   public class FlyCluster extends Sprite
   {
      
      private var target:DisplayObject;
      
      private var fly_vector:Vector.<Image> = new Vector.<Image>();
      
      private var radiusX_vector:Vector.<Number> = new Vector.<Number>();
      
      private var radiusY_vector:Vector.<Number> = new Vector.<Number>();
      
      private var speed_vector:Vector.<Number> = new Vector.<Number>();
      
      private var counter_vector:Vector.<int> = new Vector.<int>();
      
      private var dir_vector:Vector.<int> = new Vector.<int>();
      
      private var rotation_vector:Vector.<Number> = new Vector.<Number>();
      
      public function FlyCluster(param1:DisplayObject, param2:int = 1)
      {
         var _loc3_:Image = null;
         super();
         var _loc4_:int = 0;
         while(_loc4_ < param2)
         {
            _loc3_ = new Image(Assets.items_textureAtlas.getTexture("firefly"));
            addChild(_loc3_);
            this.fly_vector.push(_loc3_);
            this.radiusX_vector.push(30 + Math.random() * 30);
            this.radiusY_vector.push(50 + Math.random() * 50);
            this.speed_vector.push(0.05 + Math.random() / 6);
            this.counter_vector.push(int(Math.random() * 25));
            this.dir_vector.push(RanOne.ranOne());
            this.rotation_vector.push(0);
            _loc4_++;
         }
         this.target = param1;
      }
      
      public function controlFlies() : void
      {
         var _loc1_:int = int(this.fly_vector.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            ++this.counter_vector[_loc2_];
            this.rotation_vector[_loc2_] += deg2rad(this.speed_vector[_loc2_] * this.dir_vector[_loc2_]);
            MoveInCircle.moveAround(this.fly_vector[_loc2_],this.radiusX_vector[_loc2_],this.radiusY_vector[_loc2_],2,0,0,rad2deg(this.rotation_vector[_loc2_]));
            if(this.counter_vector[_loc2_] > 20 && this.counter_vector[_loc2_] < 24)
            {
               this.fly_vector[_loc2_].texture = Assets.items_textureAtlas.getTexture("firefly lightup");
            }
            else if(this.counter_vector[_loc2_] > 24)
            {
               this.fly_vector[_loc2_].texture = Assets.items_textureAtlas.getTexture("firefly");
               if(this.counter_vector[_loc2_] > 40)
               {
                  this.counter_vector[_loc2_] = int(Math.random() * 25);
               }
            }
            _loc2_++;
         }
      }
   }
}

