package com.game_objects.enemies
{
   import com.AI.*;
   import flash.geom.*;
   
   public class MushroomBird extends Enemy
   {
      
      private var bionicBirdAI:BionicBirdAI = new BionicBirdAI(this);
      
      public function MushroomBird()
      {
         super("mushroom bird",new Rectangle(-39,-89,104,86),this.bionicBirdAI);
         moveType = "flying";
         gravityObject.doApplyGravity = false;
      }
   }
}

