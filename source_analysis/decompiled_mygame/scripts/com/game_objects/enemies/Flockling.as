package com.game_objects.enemies
{
   import com.AI.*;
   import flash.geom.*;
   
   public class Flockling extends Enemy
   {
      
      private var bionicBirdAI:BionicBirdAI = new BionicBirdAI(this);
      
      public function Flockling()
      {
         super("flockling",new Rectangle(-20,-31,83,63),this.bionicBirdAI);
         moveType = "flying";
         gravityObject.doApplyGravity = false;
      }
   }
}

