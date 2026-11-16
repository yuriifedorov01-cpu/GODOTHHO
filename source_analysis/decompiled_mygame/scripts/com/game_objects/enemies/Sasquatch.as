package com.game_objects.enemies
{
   import flash.geom.*;
   
   public class Sasquatch extends Enemy
   {
      
      public function Sasquatch()
      {
         super("sasquatch",new Rectangle(-28,-137,87,146));
         __hasDash = true;
      }
   }
}

