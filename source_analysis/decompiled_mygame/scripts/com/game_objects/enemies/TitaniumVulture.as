package com.game_objects.enemies
{
   import com.AI.*;
   import flash.geom.*;
   
   public class TitaniumVulture extends Enemy
   {
      
      private var vultureAI:TitaniumVultureAI = new TitaniumVultureAI(this);
      
      public function TitaniumVulture()
      {
         super("titanium vulture",new Rectangle(-272,-359,411,333),this.vultureAI);
         moveType = "flying";
         gravityObject.doApplyGravity = false;
      }
   }
}

