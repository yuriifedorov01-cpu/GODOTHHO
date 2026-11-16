package starling.events
{
   import starling.errors.*;
   
   public final class TouchPhase
   {
      
      public static const HOVER:String = "hover";
      
      public static var RIGHT_BEGAN:String = "right_began";
      
      public static var RIGHT_ENDED:String = "right_ended";
      
      public static const BEGAN:String = "began";
      
      public static const MOVED:String = "moved";
      
      public static const STATIONARY:String = "stationary";
      
      public static const ENDED:String = "ended";
      
      public function TouchPhase()
      {
         super();
         throw new AbstractClassError();
      }
   }
}

