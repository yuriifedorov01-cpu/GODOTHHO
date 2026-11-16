package fl.events
{
   import flash.events.Event;
   
   public class ScrollEvent extends Event
   {
      
      public static const SCROLL:String = "scroll";
      
      private var _direction:String;
      
      private var _position:Number;
      
      private var _delta:Number;
      
      public function ScrollEvent(param1:String, param2:Number, param3:Number)
      {
         super(ScrollEvent.SCROLL,false,false);
         this._direction = param1;
         this._delta = param2;
         this._position = param3;
      }
      
      public function get position() : Number
      {
         return this._position;
      }
      
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function get delta() : Number
      {
         return this._delta;
      }
      
      override public function toString() : String
      {
         return formatToString("ScrollEvent","type","bubbles","cancelable","direction","delta","position");
      }
      
      override public function clone() : Event
      {
         return new ScrollEvent(this._direction,this._delta,this._position);
      }
   }
}

