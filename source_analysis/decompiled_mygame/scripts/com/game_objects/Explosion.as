package com.game_objects
{
   import com.game_objects.enemies.Enemy;
   import com.math.*;
   import com.utilities.*;
   import starling.display.*;
   import starling.textures.*;
   
   public class Explosion extends MovieClip
   {
      
      public static var info_array:Array;
      
      public static const explosion_array:Vector.<Explosion> = new Vector.<Explosion>();
      
      private var gameMain:GameMain;
      
      public var hit_array:Vector.<DisplayObject> = new Vector.<DisplayObject>();
      
      private var __creatorName:String;
      
      public function Explosion(param1:String, param2:GameMain)
      {
         this.gameMain = param2;
         super(TextureAtlas(info_array[0]).getTextures("explosion_"),30);
         pivotX = info_array[1];
         pivotY = info_array[2];
         this.__creatorName = param1;
         touchable = false;
         loop = false;
         textureSmoothing = TextureSmoothing.NONE;
      }
      
      public function onEnter(param1:uint) : void
      {
         var _loc2_:Enemy = null;
         var _loc3_:int = 0;
         var _loc4_:Number = Number(NaN);
         var _loc5_:Number = Number(NaN);
         if(isComplete || parent == null)
         {
            this.gameMain.main_juggler.remove(this);
            explosion_array.removeAt(param1);
            removeFromParent(true);
            return;
         }
         if(this.creatorName == this.gameMain.player.name)
         {
            for each(_loc2_ in this.gameMain.e_array)
            {
               if(this.hasHitObject(_loc2_) == false && getBounds(parent).intersects(_loc2_.hitTester.hit_rect))
               {
                  this.hit_array.push(_loc2_);
                  _loc3_ = CalcDist.getDistNumbers(x,y,_loc2_.x,_loc2_.y) / 4;
                  _loc3_ = _loc3_ < 0 ? 0 : int(40 - _loc3_);
                  _loc4_ = Number(MoveTo.getDirX(_loc3_,RotateTo.rotTo(x,_loc2_.x,y,_loc2_.y) + 270));
                  _loc5_ = -MoveTo.getDirY(_loc3_,RotateTo.rotTo(x,_loc2_.x,y,_loc2_.y) + 270) - 5;
                  _loc4_ = _loc2_.gravityObject.getWeightEffectVel(_loc4_);
                  _loc5_ = _loc2_.gravityObject.getWeightEffectVel(_loc5_);
                  _loc2_.gravityObject.velX += _loc4_;
                  _loc2_.gravityObject.velY += _loc5_;
                  this.gameMain.theConnection.send("dmgE",_loc2_.name,false,"grenade",_loc4_,_loc5_,_loc2_.x,_loc2_.y);
               }
            }
         }
         else if(this.hasHitObject(this.gameMain.player) == false && Boolean(this.gameMain.player.hitTester.hit_rect.intersects(getBounds(parent))))
         {
            if(CommonCalls.returnObject(this.gameMain.p_array,this.creatorName) == null || this.gameMain.c_mc.currentFrame != 29 || this.gameMain.player.guild != CommonCalls.returnObject(this.gameMain.p_array,this.creatorName).guild)
            {
               this.hit_array.push(this.gameMain.player);
               this.gameMain.theConnection.send("PdmgP",this.creatorName,false,"grenade",this.gameMain.player.bodyAnimator.currentLabel == "block");
            }
         }
      }
      
      private function hasHitObject(param1:DisplayObject) : Boolean
      {
         var _loc2_:DisplayObject = null;
         for each(_loc2_ in this.hit_array)
         {
            if(param1.name == _loc2_.name)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get creatorName() : String
      {
         return this.__creatorName;
      }
   }
}

