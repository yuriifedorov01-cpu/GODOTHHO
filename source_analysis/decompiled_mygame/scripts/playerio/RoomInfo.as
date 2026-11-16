package playerio
{
   public class RoomInfo
   {
      
      private var _id:String;
      
      private var _roomType:String;
      
      private var _onlineUsers:int;
      
      private var _roomData:Object;
      
      public function RoomInfo(param1:String, param2:String, param3:int, param4:Object)
      {
         super();
         this._id = param1;
         this._roomType = param2;
         this._onlineUsers = param3;
         this._roomData = param4;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get serverType() : String
      {
         return this._roomType;
      }
      
      public function get roomType() : String
      {
         return this._roomType;
      }
      
      public function get onlineUsers() : int
      {
         return this._onlineUsers;
      }
      
      public function get initData() : Object
      {
         return this._roomData;
      }
      
      public function get data() : Object
      {
         return this._roomData;
      }
      
      public function toString() : String
      {
         var _loc2_:String = null;
         var _loc1_:String = "[playerio.RoomInfo]\n";
         _loc1_ += "id:\t\t\t\t" + this.id + "\n";
         _loc1_ += "roomType:\t\t" + this.roomType + "\n";
         _loc1_ += "onlineUsers:\t" + this.onlineUsers + "\n";
         _loc1_ += "initData:\t\tId\t\t\t\t\t\tValue\n";
         _loc1_ += "\t\t\t\t-------------------------------------------\n";
         for(_loc2_ in this.initData)
         {
            _loc1_ += "\t\t\t\t" + _loc2_ + "\t\t\t\t\t".substring(_loc2_.length / 4) + "\t" + this.initData[_loc2_] + "\n";
         }
         return _loc1_;
      }
   }
}

