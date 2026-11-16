package com.game_objects
{
   import com.game_objects.enemies.Enemy;
   import com.gravityPackage.*;
   import com.math.*;
   import com.stats.*;
   import com.utilities.*;
   import com.visual_effects.*;
   import flash.geom.*;
   import starling.display.Image;
   import starling.extensions.lighting.*;
   import starling.textures.*;
   import starling.utils.*;
   
   public class Projectile extends Image
   {
      
      public var isMagic:Boolean = false;
      
      public var lifeSpan:int = 20;
      
      public var piercing:Boolean = false;
      
      public var isMagicSecondary:Boolean = false;
      
      public var isSecondaryShot:Boolean = false;
      
      public var creator:Person;
      
      private var counter:int = 0;
      
      public var maxHits:uint = 1;
      
      public var hitName_array:Vector.<String> = new Vector.<String>();
      
      private var largerHit_rect:Rectangle;
      
      public var gravityObject:GravityObject;
      
      public function Projectile(param1:String, param2:Person)
      {
         var _loc3_:LightStyle = null;
         this.creator = param2;
         super(Assets.items_textureAtlas.getTexture(param1));
         pivotX += width / 2;
         pivotY += height / 2;
         touchable = false;
         var _loc4_:Rectangle = new Rectangle(-30,-15,55,25);
         this.gravityObject = new GravityObject(this,_loc4_);
         if(GameMain.lighting)
         {
            _loc3_ = new LightStyle(Assets.itemsPetsLightMap_textureAtlas.getTexture(param1));
            _loc3_.ambientRatio = 0.3;
            _loc3_.diffuseRatio = 0.7;
            _loc3_.specularRatio = 0.1;
            _loc3_.shininess = 1;
            _loc3_.textureSmoothing = TextureSmoothing.NONE;
            style = _loc3_;
         }
      }
      
      public function onEnter(param1:GameMain, param2:Person, param3:int) : void
      {
         var _loc4_:Enemy = null;
         var _loc5_:int = 0;
         var _loc6_:Number = Number(NaN);
         var _loc7_:Number = Number(NaN);
         var _loc8_:Person = null;
         var _loc9_:Pet = null;
         ++this.counter;
         if(ItemStat(Stats.wStats[this.creator.bodyAnimator.weaponString]).isRange > 0 && ItemStat(Stats.wStats[this.creator.bodyAnimator.weaponString]).sRate == 0)
         {
            CircleCreator.createCircle(x,y);
         }
         this.gravityObject.applyGravity(param1,param1.gravity);
         if(this.counter == 1 && this.gravityObject.onGround)
         {
            param1.projectile_array.removeAt(param3);
            removeFromParent(true);
            return;
         }
         rotation = deg2rad(RotateTo.rotTo(x,x + this.gravityObject.velX,y,y + (this.gravityObject.velY + param1.gravity)) + 180);
         this.largerHit_rect = getBounds(parent);
         this.largerHit_rect.height += 20;
         for each(_loc4_ in param1.e_array)
         {
            if(_loc4_.hitTester.hit_rect.intersects(this.largerHit_rect))
            {
               if(this.piercing == false || this.hitName_array.indexOf(_loc4_.name) == -1)
               {
                  this.hitName_array.push(_loc4_.name);
                  _loc5_ = Stats.wStats[this.creator.bodyAnimator.weaponString].isRange ? 10 : 20;
                  _loc6_ = Number(MoveTo.getDirX(Moves.moveByName(Moves.BASIC_SHOOT_ARCHER).knockback + this.creator.arrowKnockbackLvl + Math.abs(this.gravityObject.velX / _loc5_),rad2deg(rotation + 90)));
                  _loc7_ = Number(MoveTo.getDirY(Moves.moveByName(Moves.BASIC_SHOOT_ARCHER).knockback + this.creator.arrowKnockbackLvl + Math.abs(this.gravityObject.velY / _loc5_),rad2deg(rotation + 90)));
                  _loc6_ = _loc4_.gravityObject.getWeightEffectVel(_loc6_);
                  _loc7_ = _loc4_.gravityObject.getWeightEffectVel(_loc7_);
                  _loc4_.gravityObject.velX += _loc6_;
                  _loc4_.gravityObject.velY += _loc7_;
                  if(this.creator == param2)
                  {
                     param1.theConnection.send("dmgE",_loc4_.name,param2.bodyAnimator.weapon2String != "none" && Stats.wStats[param2.bodyAnimator.weapon2String].isMagic && this.isMagicSecondary || this.isSecondaryShot,"p",_loc6_,_loc7_,_loc4_.x,_loc4_.y);
                     param1.lastEnemyNameHit = _loc4_.name;
                  }
                  if(this.hitName_array.length >= this.maxHits)
                  {
                     param1.projectile_array.removeAt(param3);
                     removeFromParent(true);
                  }
                  return;
               }
            }
         }
         if(param1.isPvpArea)
         {
            for each(_loc8_ in param1.p_array)
            {
               if(this.creator != _loc8_ && _loc8_.hitTester.hit_rect.intersects(this.largerHit_rect))
               {
                  if(!(param1.c_mc.currentFrame == 114 && _loc8_.guild == this.creator.guild && _loc8_.guild != ""))
                  {
                     if(this.piercing == false || this.hitName_array.indexOf(_loc8_.name) == -1)
                     {
                        this.hitName_array.push(_loc8_.name);
                        if(_loc8_.isPlayer && param2.health > 0)
                        {
                           param1.theConnection.send("PdmgP",this.creator.name,this.creator.bodyAnimator.weapon2String != "none" && Stats.wStats[this.creator.bodyAnimator.weapon2String].isMagic && this.isMagicSecondary || this.isSecondaryShot,"p",param1.player.bodyAnimator.currentLabel == "block");
                        }
                        if(this.hitName_array.length >= this.maxHits)
                        {
                           param1.projectile_array.removeAt(param3);
                           removeFromParent(true);
                        }
                        return;
                     }
                  }
               }
            }
            for each(_loc9_ in param1.pet_array)
            {
               if(_loc9_.owner != this.creator && _loc9_.gravityObject.hit_rect.intersects(this.largerHit_rect))
               {
                  if(!(param1.c_mc.currentFrame == 114 && _loc9_.owner.guild == this.creator.guild && _loc9_.owner.guild != ""))
                  {
                     if(this.piercing == false || this.hitName_array.indexOf(_loc9_.name) == -1)
                     {
                        this.hitName_array.push(_loc9_.name);
                        if(_loc9_.owner.isPlayer)
                        {
                           param1.theConnection.send("PdmgPet",this.creator.name,_loc9_.name,true);
                        }
                        if(this.hitName_array.length >= this.maxHits)
                        {
                           param1.projectile_array.removeAt(param3);
                           removeFromParent(true);
                        }
                        return;
                     }
                  }
               }
            }
         }
         if(this.counter > this.lifeSpan)
         {
            param1.projectile_array.removeAt(param3);
            removeFromParent(true);
            return;
         }
      }
   }
}

