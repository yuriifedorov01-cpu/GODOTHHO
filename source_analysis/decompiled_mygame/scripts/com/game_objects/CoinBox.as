package com.game_objects
{
   import com.game_objects.hit_detect.*;
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.sound.*;
   import com.utilities.*;
   import com.visual_effects.*;
   import flash.geom.*;
   import starling.*;
   import starling.display.Image;
   import starling.textures.Texture;
   
   public final class CoinBox extends Image implements IHitObject
   {
      
      public static const coinBox_array:Vector.<CoinBox> = new Vector.<CoinBox>();
      
      public var hitTester:HitTester;
      
      public var originalX:int;
      
      public var originalY:int;
      
      private var lastHitCounter:int = 0;
      
      public function CoinBox(param1:Texture)
      {
         super(param1);
         this.hitTester = new HitTester(this,new Rectangle(60,57,65,51));
         coinBox_array.push(this);
      }
      
      public function onEnter(param1:Vector.<Person>, param2:Vector.<Projectile>) : void
      {
         ++this.lastHitCounter;
         switch(this.hitTester.hitCheck(param1,param2).basicType)
         {
            case HitType.MELEE_TYPE:
               this.onMeleeHit();
               break;
            case HitType.PROJ_TYPE:
               this.onProjectileHit();
               break;
            case HitType.JUMP_TYPE:
               this.onJumpHit();
         }
      }
      
      public function onJumpHit() : void
      {
         if(this.lastHitCounter > 20 && parent != null)
         {
            if(CommonCalls.onScreen(x,y,true,true))
            {
               if(this.hitTester.hitType.hitter is Person && Boolean(Person(this.hitTester.hitType.hitter).isPlayer))
               {
                  MainStarlingStage(root).gameMain.theConnection.send("hitCBox",int(x),int(y));
               }
               this.lastHitCounter = 0;
               TweenMax.to(this,0.08,{
                  "y":y - 30,
                  "ease":Linear.easeNone,
                  "overwrite":false,
                  "onComplete":this.onAnimateDone
               });
               SoundManager.playSound(SoundLibrary.coinBox_sound,x,y,true,parent);
            }
         }
      }
      
      public function onMeleeHit() : void
      {
         if(this.hitTester.hitType.hitter.y + 20 > y)
         {
            SoundManager.playSound(SoundLibrary.metal1_sound,x,y,true,parent);
            MainStarlingStage(root).gameMain.createHitAnimation(this.hitTester.hit_rect.x + 25,this.hitTester.hit_rect.y + Math.random() * 50,this.hitTester.hitType.hitter.scaleX * -1);
            SetHue.tintObject(this);
         }
      }
      
      public function onProjectileHit() : void
      {
         SoundManager.playSound(SoundLibrary.metal1_sound,x,y,true,parent);
         MainStarlingStage(root).gameMain.createHitAnimation(this.hitTester.hitType.hitter.x,this.hitTester.hitType.hitter.y,this.hitTester.hitType.hitter.x > x ? 1 : -1);
         SetHue.tintObject(this);
      }
      
      private function onAnimateDone() : void
      {
         TweenMax.to(this,0.08,{
            "y":y + 30,
            "ease":Linear.easeNone,
            "overwrite":false
         });
      }
   }
}

