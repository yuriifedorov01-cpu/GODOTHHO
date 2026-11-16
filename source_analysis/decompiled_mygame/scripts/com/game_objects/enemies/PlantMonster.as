package com.game_objects.enemies
{
   import flash.geom.*;
   
   public class PlantMonster extends Enemy
   {
      
      public function PlantMonster()
      {
         super("plant monster",new Rectangle(-25,-97,57,107));
         __hasDash = true;
      }
   }
}

