package com.game_objects.enemies
{
   import flash.geom.*;
   
   public class Leaflet extends Enemy
   {
      
      public function Leaflet()
      {
         super("leaflet",new Rectangle(-22,-29,41,34));
         __hasDash = true;
      }
   }
}

