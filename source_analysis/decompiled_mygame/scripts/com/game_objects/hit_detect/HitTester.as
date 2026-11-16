package com.game_objects.hit_detect
{
   import com.game_objects.*;
   import com.game_objects.enemies.*;
   import com.gravityPackage.*;
   import com.math.*;
   import com.stats.*;
   import com.utilities.*;
   import flash.geom.*;
   import flash.ui.*;
   import starling.*;
   import starling.display.*;
   
   public class HitTester
   {
      
      public var hittable:Boolean = false;
      
      public var cHitOnly:Boolean = false;
      
      public var hitType:HitType = new HitType();
      
      public var hit_rect:Rectangle;
      
      protected var hitOffsetX:int = 0;
      
      protected var hitOffsetY:int = 0;
      
      protected var creator:DisplayObject;
      
      private var __onFire:Boolean = false;
      
      private var __frozen:Boolean = false;
      
      private var fireCounter:int = 0;
      
      private var freezeCounter:int = 0;
      
      private var frozenCube:FrozenCube;
      
      private var fire:Fire;
      
      public function HitTester(param1:DisplayObject, param2:Rectangle)
      {
         super();
         this.hit_rect = param2;
         this.creator = param1;
         this.hitOffsetX = param2.x;
         this.hitOffsetY = param2.y;
      }
      
      public function onEnterMisc() : void
      {
         this.hit_rect.x = this.creator.x + this.hitOffsetX;
         this.hit_rect.y = this.creator.y + this.hitOffsetY;
         if(this.frozenCube != null && this.frozenCube.parent != null)
         {
            this.frozenCube.x = this.hit_rect.x;
            this.frozenCube.y = this.hit_rect.y;
         }
         ++this.freezeCounter;
         if(this.freezeCounter > 50 && Boolean(this.__frozen))
         {
            this.frozen = false;
         }
         if(this.__onFire)
         {
            ++this.fireCounter;
            if(this.fireCounter > 60)
            {
               this.__onFire = false;
               this.fire.removeFromParent(true);
            }
         }
      }
      
      public function hitCheck(param1:Vector.<Person>, param2:Vector.<Projectile> = null) : HitType
      {
         var _loc3_:Rectangle = null;
         var _loc4_:Rectangle = null;
         var _loc5_:Person = null;
         var _loc6_:Boolean = false;
         var _loc7_:Rectangle = null;
         var _loc8_:int = 0;
         var _loc9_:* = 0;
         this.hitType.resetAll();
         this.hit_rect.x = this.creator.x + this.hitOffsetX;
         this.hit_rect.y = this.creator.y + this.hitOffsetY;
         for each(_loc5_ in param1)
         {
            if(!(this.cHitOnly && _loc5_.keyHandler.lastNonDirKey != Keyboard.C))
            {
               if(_loc5_.canDamage && Boolean(MoveStat.isAttackingFrame(_loc5_)))
               {
                  _loc3_ = _loc5_.bodyAnimator.weaponLeft_sprite.getBounds(_loc5_.parent);
                  _loc4_ = _loc5_.bodyAnimator.weaponRight_sprite.getBounds(_loc5_.parent);
                  if(Stats.wStats[_loc5_.bodyAnimator.weaponString].defense == 0 && _loc3_.intersects(this.hit_rect) || _loc4_.intersects(this.hit_rect))
                  {
                     _loc5_.canDamage = false;
                     this.hitType.basicType = HitType.MELEE_TYPE;
                     this.hitType.hitter = _loc5_;
                     this.hitType.isPrimary = Stats.wStats[_loc5_.bodyAnimator.weaponString].defense == 0 && _loc3_.intersects(this.hit_rect);
                     this.hitType.__centerPoint = this.hitCenterPoint(this.hitType.isPrimary ? _loc3_ : _loc4_);
                     break;
                  }
               }
               else if(_loc5_.gravityObject.velY < 0 && _loc5_.isFrameLabel("jumping","pet jumping"))
               {
                  _loc6_ = false;
                  if(this.hit_rect.contains(_loc5_.hitTester.hit_rect.x + _loc5_.hitTester.hit_rect.width - 4,_loc5_.hitTester.hit_rect.y - 30))
                  {
                     _loc6_ = true;
                  }
                  else if(this.hit_rect.contains(_loc5_.hitTester.hit_rect.x + 4,_loc5_.hitTester.hit_rect.y - 30))
                  {
                     _loc6_ = true;
                  }
                  if(_loc6_)
                  {
                     this.hitType.basicType = HitType.JUMP_TYPE;
                     this.hitType.hitter = _loc5_;
                     this.hitType.__centerPoint = null;
                     break;
                  }
               }
            }
         }
         if(param2 != null)
         {
            _loc8_ = int(param2.length);
            _loc9_ = int(_loc8_ - 1);
            while(_loc9_ >= 0)
            {
               if(!(this.cHitOnly && param2[_loc9_].creator.keyHandler.lastNonDirKey != Keyboard.C))
               {
                  _loc7_ = param2[_loc9_].getBounds(param2[_loc9_].parent);
                  if(_loc7_.intersects(this.hit_rect))
                  {
                     this.hitType.basicType = HitType.PROJ_TYPE;
                     this.hitType.isPrimary = !param2[_loc9_].isMagicSecondary && !param2[_loc9_].isSecondaryShot;
                     this.hitType.hitter = param2[_loc9_];
                     param2[_loc9_].parent.removeChild(param2[_loc9_]);
                     param2.removeAt(_loc9_);
                     this.hitType.__centerPoint = this.hitCenterPoint(_loc7_);
                  }
               }
               _loc9_--;
            }
         }
         return this.hitType;
      }
      
      public function playerAdvancedHitCheck(param1:Person) : HitType
      {
         var _loc2_:Rectangle = null;
         var _loc3_:Rectangle = null;
         var _loc4_:int = 0;
         this.hitType.resetAll();
         this.hit_rect.x = this.creator.x + this.hitOffsetX;
         this.hit_rect.y = this.creator.y + this.hitOffsetY;
         if(param1.canDamage && param1.isDamageableFrame && Boolean(MoveStat.isAttackingFrame(param1)))
         {
            _loc2_ = param1.bodyAnimator.weaponLeft_sprite.getBounds(param1.parent);
            _loc3_ = param1.bodyAnimator.weaponRight_sprite.getBounds(param1.parent);
            if(this.hit_rect.intersects(_loc2_) || this.hit_rect.intersects(_loc3_))
            {
               this.hitType.basicType = HitType.MELEE_TYPE;
               this.hitType.hitter = param1;
               this.hitType.moveStat = Moves.moveByName(param1.bodyAnimator.currentLabel);
               if(param1.bodyAnimator.weapon2String == "none")
               {
                  this.hitType.isPrimary = true;
                  this.hitType.__centerPoint = this.hitCenterPoint(_loc2_);
               }
               else if(Stats.wStats[param1.bodyAnimator.weaponString].defense > 0)
               {
                  this.hitType.isPrimary = false;
                  this.hitType.__centerPoint = this.hitCenterPoint(_loc3_);
               }
               else
               {
                  _loc4_ = this.hitType.moveStat.endDmgFrame - Math.floor((this.hitType.moveStat.endDmgFrame - this.hitType.moveStat.startDmgFrame) / 2);
                  this.hitType.isPrimary = param1.bodyAnimator.currentFrame < _loc4_;
                  this.hitType.__centerPoint = this.hitCenterPoint(this.hitType.isPrimary ? _loc2_ : _loc3_);
               }
            }
         }
         if(this.creator is IGravityObject && Boolean(IGravityObject(this.creator).gravityObject.onGround) && param1.bodyAnimator.currentFrame == Moves.moveByName(Moves.GROUND_STAB).startDmgFrame && param1.hitTester.frozen == false)
         {
            if(CalcDist.getDistNumbers(this.creator.x,this.creator.y,param1.x,param1.y) < param1.frameHandler.releasedCharge * 13 && param1.keyHandler.moveStarter.chainedEnemies < param1.multiAttackLvl)
            {
               ++param1.keyHandler.moveStarter.chainedEnemies;
               this.hitType.hitter = param1;
               this.hitType.basicType = HitType.MELEE_TYPE;
               this.hitType.isPrimary = Stats.wStats[param1.bodyAnimator.weaponString].defense == 0;
               this.hitType.moveStat = Moves.moveByName(param1.bodyAnimator.currentLabel);
            }
         }
         if(param1.keyHandler.moveStarter.lightBeam_bitmap != null && param1.keyHandler.moveStarter.lightBeam_bitmap != null)
         {
            if(param1.canDamage && param1.bodyAnimator.currentLabel == Moves.SUMMON_BEAM && param1.bodyAnimator.currentFrame > 945 && param1.bodyAnimator.currentFrame < Moves.moveByName(Moves.SUMMON_BEAM).endFrame - 3 && this.hit_rect.intersects(param1.keyHandler.moveStarter.lightBeam_bitmap.getBounds(param1.keyHandler.moveStarter.lightBeam_bitmap.parent)))
            {
               if(Stats.wStats[param1.bodyAnimator.weaponString].isMagic)
               {
                  this.hitType.isPrimary = true;
               }
               else
               {
                  this.hitType.isPrimary = false;
               }
               this.hitType.basicType = HitType.MELEE_TYPE;
               this.hitType.hitter = param1;
               this.hitType.moveStat = Moves.moveByName(param1.bodyAnimator.currentLabel);
            }
         }
         return this.hitType;
      }
      
      public function petAdvancedHitCheck(param1:Pet) : HitType
      {
         this.hitType.resetAll();
         this.hit_rect.x = this.creator.x + this.hitOffsetX;
         this.hit_rect.y = this.creator.y + this.hitOffsetY;
         if(param1.canDamage && param1.isAttacking && param1.gravityObject.hit_rect.intersects(this.hit_rect))
         {
            this.hitType.hitter = param1;
         }
         return this.hitType;
      }
      
      private function hitCenterPoint(param1:Rectangle) : Point
      {
         var _loc2_:Point = null;
         var _loc3_:Rectangle = this.hit_rect.intersection(param1);
         if(_loc3_.isEmpty() == false)
         {
            _loc2_ = new Point(_loc3_.x + _loc3_.width / 2,_loc3_.y + _loc3_.height / 2);
         }
         return _loc2_;
      }
      
      public function set onFire(param1:Boolean) : void
      {
         if(param1 == true)
         {
            if(this.__onFire == false)
            {
               this.fire = new Fire(this.creator);
               this.fire.offPlaceX = this.creator is Enemy ? int(Stats.eDescs[Enemy(this.creator).type].fireX) : 0;
               this.fire.offPlaceY = this.creator is Enemy ? int(Stats.eDescs[Enemy(this.creator).type].fireY) : -40;
               this.fire.x = this.creator.x + this.fire.offPlaceX * this.creator.scaleX;
               this.fire.y = this.creator.y + this.fire.offPlaceY;
               MainStarlingStage(this.creator.root).c_mc.addChild(this.fire);
               MainStarlingStage(this.creator.root).gameMain.main_juggler.add(this.fire);
            }
            this.fireCounter -= 60;
         }
         this.__onFire = param1;
      }
      
      public function get frozen() : Boolean
      {
         return this.__frozen;
      }
      
      public function set frozen(param1:Boolean) : void
      {
         if(param1 == true)
         {
            this.freezeCounter = 0;
            if(this.creator is MovieClip)
            {
               MovieClip(this.creator).pause();
            }
            if(this.__frozen == false && this.creator is Enemy && Boolean(CommonCalls.onScreen(this.creator.x,this.creator.y,false,true)))
            {
               this.frozenCube = new FrozenCube(this.hit_rect);
               this.frozenCube.x = this.hit_rect.x;
               this.frozenCube.y = this.hit_rect.y;
               this.creator.parent.addChildAt(this.frozenCube,this.creator.parent.getChildIndex(this.creator) + 2);
            }
         }
         else
         {
            if(this.creator is MovieClip)
            {
               MovieClip(this.creator).play();
            }
            if(this.frozenCube != null && this.frozenCube.parent != null)
            {
               this.frozenCube.removeFromParent(true);
            }
         }
         this.__frozen = param1;
      }
   }
}

