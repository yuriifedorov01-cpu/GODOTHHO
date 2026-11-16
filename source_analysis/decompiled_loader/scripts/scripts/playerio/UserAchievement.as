package playerio
{
   internal class UserAchievement
   {
      
      private var _userId:String = "";
      
      private var _achievements:Array = [];
      
      public function UserAchievement(param1:String, param2:Array)
      {
         super();
         this._achievements = param2;
         this._userId = param1;
      }
      
      public function get userId() : String
      {
         return this._userId;
      }
      
      public function get achievements() : Array
      {
         return this._achievements;
      }
   }
}

