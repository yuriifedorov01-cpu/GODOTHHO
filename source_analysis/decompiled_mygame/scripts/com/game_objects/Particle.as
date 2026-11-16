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
   
   public class Particle extends Image
   {
      
      public static var particle_array:Vector.<Particle> = new Vector.<Particle>();
      
      public var gravityObject:GravityObject;
      
      public function Particle(param1:String)
      {
         var _loc2_:LightStyle = null;
         super(Assets.treesFish_textureAtlas.getTexture(param1));
         var _loc3_:Rectangle = new Rectangle(-width,-height,width * 1.5,height * 1.5);
         this.gravityObject = new GravityObject(this,_loc3_);
         this.gravityObject.counter = int(Math.random() * 30);
         this.gravityObject.velX = Math.random() * 20 * RanOne.ranOne();
         this.gravityObject.velY = -(5 + Math.random() * 12);
         pivotX = width / 2;
         pivotY = height / 2;
         rotation = deg2rad(Math.random() * 360);
         touchable = false;
         textureSmoothing = TextureSmoothing.NONE;
         if(GameMain.lighting)
         {
            _loc2_ = new LightStyle(Assets.treeFishLighMap_textureAtlas.getTexture(param1));
            _loc2_.ambientRatio = 0.3;
            _loc2_.diffuseRatio = 0.7;
            _loc2_.specularRatio = 0.4;
            _loc2_.shininess = 12;
            _loc2_.textureSmoothing = TextureSmoothing.NONE;
            style = _loc2_;
         }
         particle_array.push(this);
      }
      
      public function onEnter(param1:int) : void
      {
         ++this.gravityObject.counter;
         this.gravityObject.applyGravity(MainStarlingStage(root).gameMain,MainStarlingStage(root).gameMain.gravity);
         if(this.gravityObject.counter > 300)
         {
            removeFromParent(true);
            particle_array.removeAt(param1);
            return;
         }
      }
   }
}

