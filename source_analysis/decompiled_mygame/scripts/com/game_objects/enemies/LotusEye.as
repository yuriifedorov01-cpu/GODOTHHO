package com.game_objects.enemies
{
   import flash.geom.*;
   
   public class LotusEye extends Enemy
   {
      
      public function LotusEye()
      {
         super("lotus eye",new Rectangle(-96,-173,176,171));
         __hasDash = true;
      }
   }
}

