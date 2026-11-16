package com.game_objects.power_up_effects
{
   import com.game_objects.Person;
   import com.utilities.*;
   import flash.geom.Rectangle;
   import starling.*;
   import starling.animation.*;
   import starling.display.*;
   import starling.events.*;
   import starling.textures.*;
   
   public final class Aura extends Sprite
   {
      
      private var person:Person;
      
      private var __auraNum:uint = 0;
      
      private var aura:MovieClip;
      
      private var blueAura:MovieClip;
      
      private var counter:int = 0;
      
      private const auraSpark_array:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      public function Aura(param1:Person)
      {
         super();
         this.person = param1;
         touchGroup = true;
         touchable = false;
         this.auraNum = Math.ceil(this.person.energyController.fullTotalScale * 7);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
      }
      
      public function onEnter() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:MovieClip = null;
         _loc1_ = null;
         _loc2_ = null;
         ++this.counter;
         x = this.person.x;
         y = this.person.y + 40;
         this.auraNum = Math.ceil(this.person.energyController.fullTotalScale * 7);
         if(this.aura.currentFrame == 0 || this.aura.currentFrame == 1)
         {
            this.aura.scaleX = 1;
         }
         else
         {
            this.aura.scaleX = -1;
         }
         if(this.blueAura != null && this.blueAura.parent != null)
         {
            if(this.blueAura.currentFrame == 0 || this.blueAura.currentFrame == 1)
            {
               this.blueAura.scaleX = 1;
            }
            else
            {
               this.blueAura.scaleX = -1;
            }
         }
         var _loc3_:int = 150 - this.person.energyController.fullTotalScale * 100;
         if(this.counter % _loc3_ == 0)
         {
            _loc1_ = this.aura.bounds;
            _loc2_ = new MovieClip(Assets.powerUp_textureAtlas.getTextures("aura spark"),15);
            _loc2_.x = _loc1_.left + Math.random() * _loc1_.width;
            _loc2_.y = _loc1_.top + Math.random() * _loc1_.height;
            _loc2_.pivotX = _loc2_.width / 2;
            _loc2_.pivotY = _loc2_.height / 2;
            _loc2_.alpha = 0.65;
            _loc2_.scaleX = _loc2_.x < _loc1_.left + _loc1_.width / 2 ? 1 : -1;
            _loc2_.loop = false;
            _loc2_.play();
            _loc2_.touchable = false;
            _loc2_.textureSmoothing = TextureSmoothing.NONE;
            addChild(_loc2_);
            MainStarlingStage(root).gameMain.main_juggler.add(_loc2_);
            this.auraSpark_array.push(_loc2_);
         }
         var _loc4_:int = int(this.auraSpark_array.length);
         var _loc5_:* = int(_loc4_ - 1);
         while(_loc5_ >= 0)
         {
            if(this.auraSpark_array[_loc5_].isComplete)
            {
               MainStarlingStage(root).gameMain.main_juggler.remove(this.auraSpark_array[_loc5_]);
               this.auraSpark_array[_loc5_].removeFromParent(true);
               this.auraSpark_array.removeAt(_loc5_);
            }
            _loc5_--;
         }
      }
      
      private function set auraNum(param1:uint) : void
      {
         var _loc2_:Vector.<Texture> = null;
         var _loc3_:int = 0;
         var _loc4_:Vector.<Texture> = null;
         if(param1 == 0)
         {
            return;
         }
         var _loc5_:int = int(this.__auraNum);
         this.__auraNum = param1 > 7 ? 7 : param1;
         if(_loc5_ != this.__auraNum)
         {
            if(this.aura != null && this.aura.parent != null)
            {
               MainStarlingStage(this.person.root).gameMain.main_juggler.remove(this.aura);
               this.aura.removeFromParent(true);
            }
            if(this.blueAura != null && this.blueAura.parent != null)
            {
               MainStarlingStage(this.person.root).gameMain.main_juggler.remove(this.blueAura);
               this.blueAura.removeFromParent(true);
            }
            _loc2_ = Assets.powerUp_textureAtlas.getTextures("aura " + this.__auraNum,_loc2_);
            _loc2_.push(_loc2_[0],_loc2_[1]);
            this.aura = new MovieClip(_loc2_,15);
            this.aura.pivotX = this.aura.width / 2;
            this.aura.pivotY = this.aura.height - this.aura.height / 15;
            this.aura.alpha = 0.65;
            this.aura.touchable = false;
            this.aura.textureSmoothing = TextureSmoothing.NONE;
            this.aura.play();
            addChild(this.aura);
            MainStarlingStage(this.person.root).gameMain.main_juggler.add(this.aura);
            _loc3_ = param1 < 7 ? int(this.__auraNum - 3) : 3;
            if(_loc3_ > 0)
            {
               _loc4_ = Assets.powerUp_textureAtlas.getTextures("blue aura " + _loc3_,_loc4_);
               _loc4_.push(_loc4_[0],_loc4_[1]);
               this.blueAura = new MovieClip(_loc4_,15);
               this.blueAura.pivotX = this.blueAura.width / 2;
               this.blueAura.pivotY = this.blueAura.height - this.blueAura.height / 15;
               this.blueAura.alpha = 0.65;
               this.blueAura.touchable = false;
               this.blueAura.textureSmoothing = TextureSmoothing.NONE;
               this.blueAura.play();
               addChildAt(this.blueAura,0);
               MainStarlingStage(this.person.root).gameMain.main_juggler.add(this.blueAura);
            }
         }
      }
      
      private function onRemoved(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = 0;
         if(this.person.root != null)
         {
            _loc2_ = numChildren;
            _loc3_ = int(_loc2_ - 1);
            while(_loc3_ >= 0)
            {
               MainStarlingStage(this.person.root).gameMain.main_juggler.remove(IAnimatable(getChildAt(_loc3_)));
               _loc3_--;
            }
         }
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
      }
   }
}

