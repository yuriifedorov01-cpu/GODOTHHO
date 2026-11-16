package com.game_objects.enemies
{
   import com.AI.*;
   import flash.geom.*;
   
   public class MushroomBall extends Enemy
   {
      
      private var mushroomBallAI:MushroomBallAI = new MushroomBallAI(this);
      
      public function MushroomBall()
      {
         super("mushroom ball",new Rectangle(-21,-40,42,50),this.mushroomBallAI);
         __hasDash = true;
      }
   }
}

