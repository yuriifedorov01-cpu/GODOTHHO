package com.game_objects.enemies
{
   import com.AI.*;
   import flash.geom.*;
   
   public class Chirplet extends Enemy
   {
      
      private var bionicBirdAI:BionicBirdAI = new BionicBirdAI(this);
      
      public function Chirplet()
      {
         super("chirplet",new Rectangle(-34,-52,69,68),this.bionicBirdAI);
         moveType = "flying";
         gravityObject.doApplyGravity = false;
      }
   }
}

