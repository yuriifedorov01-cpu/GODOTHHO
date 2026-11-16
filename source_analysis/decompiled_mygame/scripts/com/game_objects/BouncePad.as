package com.game_objects
{
   import com.game_objects.enemies.Enemy;
   import com.gravityPackage.GravityObject;
   import com.sound.*;
   import flash.geom.*;
   import starling.*;
   import starling.display.MovieClip;
   import starling.textures.*;
   
   public class BouncePad extends MovieClip
   {
      
      public static const bouncePad_array:Vector.<BouncePad> = new Vector.<BouncePad>();
      
      private var bounds_rect:Rectangle = new Rectangle(0,0,165,165);
      
      public function BouncePad(param1:TextureAtlas)
      {
         var _loc2_:Vector.<Texture> = new Vector.<Texture>();
         _loc2_.push(param1.getTexture("bounce pad 1"),param1.getTexture("bounce pad 2"),param1.getTexture("bounce pad 3"),param1.getTexture("bounce pad 4"));
         _loc2_.push(param1.getTexture("bounce pad 4"),param1.getTexture("bounce pad 4"),param1.getTexture("bounce pad 4"));
         _loc2_.push(param1.getTexture("bounce pad 3"),param1.getTexture("bounce pad 2"));
         super(_loc2_,30);
         stop();
         bouncePad_array.push(this);
      }
      
      public function onEnter() : void
      {
         var _loc1_:Person = null;
         var _loc2_:Enemy = null;
         var _loc3_:Pet = null;
         for each(_loc1_ in MainStarlingStage(root).gameMain.p_array)
         {
            this.testObject(_loc1_.gravityObject);
         }
         for each(_loc2_ in MainStarlingStage(root).gameMain.e_array)
         {
            this.testObject(_loc2_.gravityObject);
         }
         for each(_loc3_ in MainStarlingStage(root).gameMain.pet_array)
         {
            this.testObject(_loc3_.gravityObject);
         }
         if(currentFrame == 0)
         {
            stop();
         }
      }
      
      private function testObject(param1:GravityObject) : void
      {
         if(param1.onGround && param1.hit_rect.intersects(this.bounds_rect) && param1.hit_rect.y + param1.hit_rect.height - 10 < this.bounds_rect.y + 25)
         {
            SoundManager.playSound(SoundLibrary.boing_sound,x,y,true,parent);
            param1.velY -= 32;
            gotoAndPlay(1);
         }
      }
      
      override public function set x(param1:Number) : void
      {
         this.bounds_rect.x = param1;
         super.x = param1;
      }
      
      override public function set y(param1:Number) : void
      {
         this.bounds_rect.y = param1;
         super.y = param1;
      }
   }
}

