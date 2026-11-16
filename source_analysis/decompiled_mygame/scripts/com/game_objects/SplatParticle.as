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
   
   public class SplatParticle extends Image
   {
      
      public static var particle_array:Vector.<SplatParticle> = new Vector.<SplatParticle>();
      
      private var orbColor:String = "";
      
      private var gravityObject:GravityObject;
      
      public function SplatParticle(param1:String)
      {
         var _loc2_:LightStyle = null;
         this.orbColor = param1;
         super(Assets.items_textureAtlas.getTexture(param1 + " particle"));
         var _loc3_:Rectangle = new Rectangle(-(width / 2),-(height / 2),width * 2,height * 2);
         this.gravityObject = new GravityObject(this,_loc3_);
         this.gravityObject.counter = int(Math.random() * 30);
         this.gravityObject.velX = Math.random() * 20 * RanOne.ranOne();
         this.gravityObject.velY = -(5 + Math.random() * 12);
         touchable = false;
         if(GameMain.lighting)
         {
            _loc2_ = new LightStyle(Assets.itemsPetsLightMap_textureAtlas.getTexture(param1 + " particle"));
            _loc2_.ambientRatio = 0.3;
            _loc2_.diffuseRatio = 0.7;
            _loc2_.specularRatio = 0.6;
            _loc2_.shininess = 20;
            _loc2_.textureSmoothing = TextureSmoothing.NONE;
            style = _loc2_;
         }
         particle_array.push(this);
      }
      
      public function onEnter(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         ++this.gravityObject.counter;
         this.gravityObject.applyGravity(MainStarlingStage(root).gameMain,MainStarlingStage(root).gameMain.gravity);
         if(this.gravityObject.onGround)
         {
            _loc2_ = Math.floor(Math.random() * 3);
            Splatter.tryCreate(true,x,y,this.orbColor + " splatter" + _loc2_);
            removeFromParent(true);
            particle_array.removeAt(param1);
            return;
         }
         if(this.gravityObject.onWall)
         {
            _loc3_ = Math.floor(Math.random() * 3);
            Splatter.tryCreate(false,x,y,this.orbColor + " splatter" + _loc2_);
            removeFromParent(true);
            particle_array.removeAt(param1);
            return;
         }
         if(this.gravityObject.counter > 90)
         {
            removeFromParent(true);
            SplatParticle.particle_array.removeAt(param1);
            return;
         }
      }
   }
}

