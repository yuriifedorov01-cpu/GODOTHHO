package com.game_objects.enemies
{
   import com.AI.*;
   import flash.geom.*;
   
   public class BionicBird extends Enemy
   {
      
      private var bionicBirdAI:BionicBirdAI = new BionicBirdAI(this);
      
      public function BionicBird()
      {
         super("bionic bird",new Rectangle(-69,-72,101,76),this.bionicBirdAI);
         moveType = "flying";
         gravityObject.doApplyGravity = false;
      }
   }
}

