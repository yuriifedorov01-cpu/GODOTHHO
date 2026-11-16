package com.game_objects
{
   import com.game_objects.hit_detect.*;
   import com.gravityPackage.*;
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.math.*;
   import com.sound.*;
   import com.ui.*;
   import com.utilities.*;
   import com.visual_effects.*;
   import flash.display.*;
   import flash.geom.*;
   import flash.media.Sound;
   import starling.*;
   import starling.display.Image;
   import starling.extensions.lighting.*;
   import starling.textures.*;
   import starling.utils.*;
   
   public class Tree extends Image implements IHitObject
   {
      
      public static var tree_array:Vector.<Tree> = new Vector.<Tree>();
      
      private static var names_array:Vector.<String> = new Vector.<String>();
      
      private static var hitAreas_array:Vector.<Rectangle> = new Vector.<Rectangle>();
      
      public var health:int = 0;
      
      public var totalHealth:int = 5000;
      
      private var counter:int = 0;
      
      private var __type:String = "";
      
      public var canTint:Boolean = true;
      
      private var __hitRect:Rectangle;
      
      private var hitTester:HitTester;
      
      private var __isFG:Boolean;
      
      private var skewOutward:Boolean = true;
      
      public function Tree(param1:String, param2:String, param3:int, param4:int, param5:GameMain, param6:Boolean)
      {
         var _loc7_:LightStyle = null;
         super(Assets.treesFish_textureAtlas.getTexture(param1));
         textureSmoothing = TextureSmoothing.NONE;
         this.__isFG = param6;
         this.health = this.totalHealth;
         this.__type = param1;
         touchable = false;
         x = param3;
         y = param4 + 15;
         pivotX += width / 2;
         pivotY += height;
         name = param2;
         var _loc8_:Rectangle = new Rectangle(0,0,width / 3,height);
         _loc8_.x -= _loc8_.width / 2;
         _loc8_.y -= _loc8_.height - 15;
         this.hitTester = new HitTester(this,_loc8_);
         this.hitTester.cHitOnly = true;
         if(GameMain.lighting)
         {
            _loc7_ = new LightStyle(Assets.treeFishLighMap_textureAtlas.getTexture(param1));
            _loc7_.ambientRatio = 0.3;
            _loc7_.diffuseRatio = 0.7;
            _loc7_.specularRatio = 0.1;
            _loc7_.shininess = 1;
            _loc7_.textureSmoothing = TextureSmoothing.NONE;
            style = _loc7_;
         }
      }
      
      public function onEnter() : void
      {
         var _loc1_:WindSource = null;
         ++this.counter;
         switch(this.hitTester.hitCheck(MainStarlingStage(root).gameMain.p_array,MainStarlingStage(root).gameMain.projectile_array).basicType)
         {
            case HitType.MELEE_TYPE:
               this.onMeleeHit();
               break;
            case HitType.PROJ_TYPE:
               this.onProjectileHit();
         }
         var _loc2_:int = 0;
         var _loc3_:Number = 0;
         var _loc4_:Point = new Point();
         var _loc5_:Point = new Point();
         for each(_loc1_ in WindSource.wind_array)
         {
            _loc2_ = rad2deg(_loc1_.rotation) + 90;
            _loc4_.setTo(_loc1_.x,_loc1_.y);
            _loc5_.setTo(_loc1_.x + MoveTo.getDirX(_loc1_.power,_loc2_),_loc1_.y + MoveTo.getDirY(_loc1_.power,_loc2_));
            if(LineIntersection.lineIntersectsRect(_loc4_,_loc5_,this.hitTester.hit_rect))
            {
               _loc3_ += deg2rad(MoveTo.getDirX(_loc1_.power - CalcDist.getDistX(x,_loc1_.x),_loc2_) / 125);
            }
         }
         if(_loc3_ != 0)
         {
            if(_loc3_ > 0.17)
            {
               _loc3_ = 0.17;
            }
            else if(_loc3_ < -0.17)
            {
               _loc3_ = -0.17;
            }
            skewX += this.skewOutward ? _loc3_ : -_loc3_;
            if(_loc3_ > 0)
            {
               if(skewX > _loc3_ * 7)
               {
                  this.skewOutward = false;
                  if(Math.random() < 0.3)
                  {
                     this.spawnLeaf();
                  }
               }
               else if(skewX <= 0)
               {
                  this.skewOutward = true;
               }
            }
            else if(skewX < _loc3_ * 7)
            {
               this.skewOutward = false;
               if(Math.random() < 0.3)
               {
                  this.spawnLeaf();
               }
            }
            else if(skewX >= 0)
            {
               this.skewOutward = true;
            }
         }
         else if(skewX != 0 && TweenMax.isTweening(this) == false)
         {
            TweenMax.to(this,0.3,{
               "skewX":0,
               "ease":Linear.easeNone
            });
         }
         if(this.counter % 60 == 0 && Math.random() > 0.8)
         {
            this.spawnLeaf();
         }
      }
      
      public function damageMe(param1:Person, param2:Boolean, param3:int, param4:String) : void
      {
         var _loc5_:Image = null;
         var _loc6_:Image = null;
         var _loc7_:int = 0;
         var _loc8_:Rectangle = null;
         var _loc9_:int = 0;
         var _loc10_:* = undefined;
         var _loc11_:int = 0;
         if(param1.name == param4)
         {
            if(param3 > 0)
            {
               _loc5_ = GiveHealthBar.getBarLinkedTo(this);
               if(_loc5_ == null)
               {
                  _loc5_ = GiveHealthBar.to(this);
                  _loc6_ = GiveHealthBar.getBarBGLinkedTo(this);
                  TweenMax.to(_loc5_,0.8,{
                     "alpha":0,
                     "delay":2,
                     "ease":Linear.easeNone,
                     "overwrite":true,
                     "onComplete":_loc5_.removeFromParent,
                     "onCompleteParams":[true]
                  });
                  TweenMax.to(_loc6_,0.8,{
                     "alpha":0,
                     "delay":2,
                     "ease":Linear.easeNone,
                     "overwrite":true,
                     "onComplete":_loc6_.removeFromParent,
                     "onCompleteParams":[true]
                  });
               }
               _loc5_.scaleX = param3 / this.totalHealth;
            }
            if(param2 == true)
            {
               param1.chopXP += 4;
               MainStarlingStage(root).gameMain.createXPText(4,param1.x,param1.y," chop ");
               MainStarlingStage(root).gameMain.saveProficiency();
            }
         }
         if(CommonCalls.onScreen(x,y,true,true))
         {
            SetHue.tintObject(this);
            MainStarlingStage(root).gameMain.createDamageText(this.health - param3,getBounds(parent).x + width / 2,getBounds(parent).y + height / 2);
            _loc11_ = 0;
            while(_loc11_ < int(Math.ceil(Math.random() * 2)))
            {
               this.spawnLeaf();
               _loc11_++;
            }
         }
         this.health = param3;
         if(this.health <= 0)
         {
            if(MainStarlingStage(root).gameMain.stage.quality != StageQuality.LOW.toUpperCase())
            {
               _loc8_ = getBounds(parent);
               _loc9_ = 0;
               while(_loc9_ < 10)
               {
                  _loc10_ = new SplatParticle("tan");
                  _loc10_.x = _loc8_.x + Math.random() * _loc8_.width;
                  _loc10_.y = _loc8_.y + Math.random() * _loc8_.height;
                  SortDepths.addAt(_loc10_,SortDepths.REGION_4);
                  _loc9_++;
               }
            }
            SoundManager.playSound(SoundLibrary.logsFall_sound,x,y,true,parent);
            removeFromParent(true);
            _loc7_ = int(Tree.tree_array.length);
            _loc11_ = 0;
            while(_loc11_ < _loc7_)
            {
               if(Tree.tree_array[_loc11_] == this)
               {
                  Tree.tree_array.removeAt(_loc11_);
                  break;
               }
               _loc11_++;
            }
            return;
         }
      }
      
      private function onGeneralHit() : void
      {
         Shake.startShake(this);
         SoundManager.playSound(Math.random() > 0.5 ? SoundLibrary.woodHit1_sound : SoundLibrary.woodHit2_sound,x,y,true,parent);
         if(this.hitTester.hitType.hitter == null)
         {
            MainStarlingStage(root).gameMain.createHitAnimation(x + CalcDist.getDistX(this.hitTester.hitType.hitter.x,x) / 4,y + CalcDist.getDistY(y,this.hitTester.hitType.hitter.y) / 2,this.hitTester.hitType.hitter.x > x ? 1 : -1);
            if(this.hitTester.hitType.hitter is Person && Boolean(Person(this.hitTester.hitType.hitter).isPlayer) || this.hitTester.hitType.hitter is Projectile && Boolean(Projectile(this.hitTester.hitType.hitter).creator.isPlayer))
            {
               MainStarlingStage(root).gameMain.theConnection.send("treeHit",name,this.hitTester.hitType.isPrimary);
            }
         }
         else
         {
            MainStarlingStage(root).gameMain.createHitAnimation(x + CalcDist.getDistX(this.hitTester.hitType.hitter.x,x) / 4,y + CalcDist.getDistY(y,this.hitTester.hitType.hitter.y) / 2,this.hitTester.hitType.hitter.x > x ? 1 : -1);
            if(this.hitTester.hitType.hitter is Person && Boolean(Person(this.hitTester.hitType.hitter).isPlayer) || this.hitTester.hitType.hitter is Projectile && Boolean(Projectile(this.hitTester.hitType.hitter).creator.isPlayer))
            {
               MainStarlingStage(root).gameMain.theConnection.send("treeHit",name,this.hitTester.hitType.isPrimary);
            }
         }
      }
      
      private function spawnLeaf() : void
      {
         var _loc1_:Leaf = null;
         if(MainStarlingStage(root).gameMain.stage.quality != StageQuality.LOW.toUpperCase())
         {
            _loc1_ = new Leaf(this.__type + " leaf");
            _loc1_.x = this.hitTester.hit_rect.x + Math.random() * this.hitTester.hit_rect.width;
            _loc1_.y = this.hitTester.hit_rect.y + Math.random() * (this.hitTester.hit_rect.height / 2);
            if(this.__isFG)
            {
               SortDepths.addAt(_loc1_,SortDepths.REGION_2);
            }
            else
            {
               MainStarlingStage(root).c_mc.addChildAt(_loc1_,MainStarlingStage(root).c_mc.getChildIndex(this) + 1);
            }
         }
      }
      
      public function onMeleeHit() : void
      {
         this.onGeneralHit();
      }
      
      public function onProjectileHit() : void
      {
         this.onGeneralHit();
      }
      
      public function onJumpHit() : void
      {
      }
      
      public function get isFG() : Boolean
      {
         return this.__isFG;
      }
   }
}

