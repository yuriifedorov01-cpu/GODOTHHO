package playerio
{
   import playerio.generated.messages.Achievement;
   
   public class Achievement
   {
      
      private var _id:String;
      
      private var _title:String;
      
      private var _description:String;
      
      private var _imageUrl:String;
      
      private var _progress:int;
      
      private var _progressGoal:int;
      
      private var _lastUpdated:Date;
      
      public function Achievement()
      {
         super();
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function get description() : String
      {
         return this._description;
      }
      
      public function get imageUrl() : String
      {
         return this._imageUrl;
      }
      
      public function get progress() : int
      {
         return this._progress;
      }
      
      public function get progressGoal() : int
      {
         return this._progressGoal;
      }
      
      public function get lastUpdated() : Date
      {
         return this._lastUpdated;
      }
      
      public function get progressRatio() : Number
      {
         return this._progress / this._progressGoal;
      }
      
      public function get completed() : Boolean
      {
         return this._progress == this._progressGoal;
      }
      
      internal function _internal_initialize(param1:playerio.generated.messages.Achievement) : void
      {
         this._id = param1.identifier;
         this._title = param1.title;
         this._description = param1.description;
         this._imageUrl = param1.imageUrl;
         this._progress = param1.progress;
         this._progressGoal = param1.progressGoal;
         this._lastUpdated = new Date(param1.lastUpdated * 1000);
      }
   }
}

