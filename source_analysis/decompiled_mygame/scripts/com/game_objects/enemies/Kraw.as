package com.game_objects.enemies
{
   import com.AI.*;
   import flash.geom.*;
   
   public class Kraw extends Enemy
   {
      
      private var bionicBirdAI:BionicBirdAI = new BionicBirdAI(this);
      
      public function Kraw()
      {
         super("kraw",new Rectangle(-44,-59,87,71),this.bionicBirdAI);
         moveType = "flying";
         gravityObject.doApplyGravity = false;
      }
   }
}

