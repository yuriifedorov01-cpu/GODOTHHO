package com.game_objects.hit_detect
{
   public interface IHitObject
   {
      
      function onJumpHit() : void;
      
      function onMeleeHit() : void;
      
      function onProjectileHit() : void;
   }
}

