package com.game_objects.enemies
{
   import flash.geom.*;
   
   public class Mongrel extends Enemy
   {
      
      public function Mongrel()
      {
         super("mongrel",new Rectangle(-153,-4,450,356));
         __hasDash = true;
      }
   }
}

