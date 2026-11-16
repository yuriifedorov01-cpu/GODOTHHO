package com.game_objects
{
   import com.gravityPackage.*;
   import com.utilities.*;
   import flash.geom.*;
   import starling.*;
   import starling.display.Image;
   import starling.utils.*;
   
   public class BulletShell extends Image
   {
      
      private static var bulletShell_array:Vector.<BulletShell> = new Vector.<BulletShell>();
      
      private var gravityObject:GravityObject;
      
      private var rotSpeed:int = 0;
      
      public function BulletShell(param1:int)
      {
         super(Assets.items_textureAtlas.getTexture("bullet shell"));
         pivotX = 6;
         pivotY = 3;
         touchable = false;
         this.rotSpeed = 3 + Math.random() * 25;
         this.gravityObject = new GravityObject(this,new Rectangle(-15,-15,30,30));
         this.gravityObject.velY = -(6 + Math.random() * 9);
         this.gravityObject.velX = (3 + Math.random() * 5) * param1;
         bulletShell_array.push(this);
      }
      
      public static function onEnterAll() : void
      {
         var _loc1_:int = int(bulletShell_array.length);
         var _loc2_:* = int(_loc1_ - 1);
         while(_loc2_ >= 0)
         {
            bulletShell_array[_loc2_].onEnter(_loc2_);
            _loc2_--;
         }
      }
      
      public function onEnter(param1:int) : void
      {
         ++this.gravityObject.counter;
         if(parent == null || this.gravityObject.counter > 90)
         {
            bulletShell_array.removeAt(param1);
            removeFromParent(true);
            return;
         }
         this.gravityObject.applyGravity(MainStarlingStage(root).gameMain,MainStarlingStage(root).gameMain.gravity);
         this.rotSpeed = this.gravityObject.onGround ? 0 : int(this.rotSpeed);
         rotation += deg2rad(this.rotSpeed);
      }
   }
}

