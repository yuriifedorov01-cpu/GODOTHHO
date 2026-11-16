package feathers.utils.display
{
   import starling.core.*;
   import starling.display.Stage;
   
   public function stageToStarling(param1:Stage) : Starling
   {
      var _loc2_:Starling = null;
      for each(_loc2_ in Starling.all)
      {
         if(_loc2_.stage === param1)
         {
            return _loc2_;
         }
      }
      return null;
   }
}

