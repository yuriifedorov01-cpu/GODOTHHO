package com.game_objects.enemies
{
   import flash.geom.*;
   
   public class DrillBot extends Enemy
   {
      
      public function DrillBot()
      {
         super("drill bot",new Rectangle(-61,-153,119,153));
         __hasDash = true;
      }
   }
}

