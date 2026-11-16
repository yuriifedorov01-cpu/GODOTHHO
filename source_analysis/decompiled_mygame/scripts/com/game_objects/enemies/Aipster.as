package com.game_objects.enemies
{
   import flash.geom.*;
   
   public class Aipster extends Enemy
   {
      
      public function Aipster()
      {
         super("aipster",new Rectangle(-26,-57,74,120));
         __hasDash = true;
      }
   }
}

