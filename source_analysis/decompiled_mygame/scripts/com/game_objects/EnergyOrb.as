package com.game_objects
{
   import com.math.*;
   import com.utilities.*;
   import starling.display.Image;
   import starling.textures.*;
   
   public class EnergyOrb extends Image
   {
      
      public static const energyOrb_array:Vector.<EnergyOrb> = new Vector.<EnergyOrb>();
      
      private var target_person:Person;
      
      private var fakeRotation:int;
      
      public function EnergyOrb(param1:Person)
      {
         var _loc2_:Number = 0.2 + (param1.lev < 1000 ? param1.lev / 1000 : 1);
         super(Assets.treesFish_textureAtlas.getTexture("energy orb"));
         this.target_person = param1;
         scale = _loc2_;
         touchable = false;
         textureSmoothing = TextureSmoothing.NONE;
         energyOrb_array.push(this);
      }
      
      public function onEnter(param1:int) : void
      {
         if(this.target_person.parent != null && Boolean(this.target_person.powerUpVisuals.poweringUp))
         {
            if(Math.abs(CalcDist.getDistX(this.target_person.x,x)) > 20)
            {
               x += this.target_person.x > x ? 2 : -2;
            }
            if(Math.abs(CalcDist.getDistY(this.target_person.y,y)) > 20)
            {
               y += this.target_person.y > y ? 2 : -2;
            }
            if(CalcDist.getDist(this.target_person,this) < 30)
            {
               this.target_person.energyController.absorbed += scale / 100;
               removeFromParent(true);
               energyOrb_array.removeAt(param1);
               return;
            }
            return;
         }
         removeFromParent(true);
         energyOrb_array.removeAt(param1);
      }
   }
}

