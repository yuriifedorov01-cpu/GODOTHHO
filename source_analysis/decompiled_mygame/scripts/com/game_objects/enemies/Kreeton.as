package com.game_objects.enemies
{
   import flash.geom.*;
   
   public class Kreeton extends Enemy
   {
      
      public function Kreeton()
      {
         super("kreeton",new Rectangle(-106,-210,193,202));
         __hasDash = true;
      }
   }
}

