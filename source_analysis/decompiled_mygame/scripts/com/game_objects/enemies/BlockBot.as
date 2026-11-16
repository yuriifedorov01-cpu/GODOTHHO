package com.game_objects.enemies
{
   import flash.geom.*;
   
   public class BlockBot extends Enemy
   {
      
      public function BlockBot()
      {
         super("block bot",new Rectangle(-30,-92,56,97));
         __hasDash = true;
      }
   }
}

