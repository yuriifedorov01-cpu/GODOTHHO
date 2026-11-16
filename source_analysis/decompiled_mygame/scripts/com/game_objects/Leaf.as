package com.game_objects
{
   import com.gravityPackage.*;
   import com.math.*;
   import com.utilities.*;
   import flash.geom.*;
   import starling.*;
   import starling.display.Image;
   import starling.extensions.lighting.*;
   import starling.textures.*;
   import starling.utils.*;
   
   public class Leaf extends Image
   {
      
      public static const leaf_array:Vector.<Leaf> = new Vector.<Leaf>();
      
      private var gravityObject:GravityObject;
      
      public function Leaf(param1:String)
      {
         var _loc2_:LightStyle = null;
         super(Assets.treesFish_textureAtlas.getTexture(param1));
         this.gravityObject = new GravityObject(this,new Rectangle(-20,-20,40,40));
         this.gravityObject.velX = Math.random() * 4 * RanOne.ranOne();
         textureSmoothing = TextureSmoothing.NONE;
         this.gravityObject.counter = Math.random() > 0.95 ? -3600 : 0;
         touchable = false;
         pivotX = 10;
         pivotY = 10;
         rotation = deg2rad(Math.random() * 360);
         leaf_array.push(this);
         if(GameMain.lighting)
         {
            _loc2_ = new LightStyle(Assets.treeFishLighMap_textureAtlas.getTexture(param1));
            _loc2_.ambientRatio = 0.3;
            _loc2_.diffuseRatio = 0.7;
            _loc2_.specularRatio = 0.1;
            _loc2_.shininess = 1;
            _loc2_.textureSmoothing = TextureSmoothing.NONE;
            style = _loc2_;
         }
      }
      
      public function onEnter(param1:int) : void
      {
         var _loc2_:Person = null;
         var _loc3_:Person = null;
         if(parent == null)
         {
            leaf_array.removeAt(param1);
            return;
         }
         ++this.gravityObject.counter;
         this.gravityObject.accelDownMultiplier = -0.85;
         this.gravityObject.applyGravity(MainStarlingStage(root).gameMain,MainStarlingStage(root).gameMain.gravity);
         if(this.gravityObject.onGround == false && this.gravityObject.velY > 2 && this.gravityObject.counter % 15 == 0 && Math.random() > 0.7)
         {
            this.gravityObject.velX += Math.random() * 6 * RanOne.ranOne();
         }
         if(this.gravityObject.velX != 0 && this.gravityObject.onGround == false)
         {
            rotation += deg2rad(5 * this.gravityObject.velX);
         }
         if(this.gravityObject.counter % 10 == 0)
         {
            for each(_loc3_ in MainStarlingStage(root).gameMain.p_array)
            {
               if(Math.abs(_loc3_.gravityObject.velX) > 3 && _loc3_.hitTester.hit_rect.intersects(this.gravityObject.hit_rect))
               {
                  this.gravityObject.velY -= Math.random() * Math.abs(_loc3_.gravityObject.velX) / 2;
                  this.gravityObject.velX += _loc3_.gravityObject.velX * 0.5;
               }
            }
         }
         for each(_loc2_ in MainStarlingStage(root).gameMain.p_array)
         {
            if(_loc2_.powerUpVisuals.poweringUp && CalcDist.getDist(_loc2_,this) < _loc2_.energyController.fullTotalScale * 400)
            {
               this.gravityObject.velX += x < _loc2_.x ? 0.31 : -0.31;
               this.gravityObject.velY += y < _loc2_.y ? 0.3 : -0.3;
            }
         }
         if(this.gravityObject.counter > 450)
         {
            alpha -= 0.04;
            if(alpha <= 0)
            {
               removeFromParent(true);
               leaf_array.removeAt(param1);
               return;
            }
         }
      }
   }
}

