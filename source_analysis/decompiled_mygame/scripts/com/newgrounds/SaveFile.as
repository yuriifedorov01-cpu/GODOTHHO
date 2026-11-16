package com.newgrounds
{
   import com.newgrounds.encoders.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.utils.*;
   
   public class SaveFile extends APIEventDispatcher
   {
      
      private static var _currentFile:SaveFile;
      
      public static const ICON_WIDTH:uint = 90;
      
      public static const ICON_HEIGHT:uint = 90;
      
      public static const DEFAULT_ICON:BitmapData = new BitmapData(ICON_WIDTH,ICON_HEIGHT,false,0);
      
      private static const STATUS_PRIVATE:uint = 0;
      
      private static const STATUS_SHARED:uint = 1;
      
      private static const STATUS_UNAPPROVED:uint = 2;
      
      private static const STATUS_APPROVED:uint = 3;
      
      internal static var _imageFilePath:String = "";
      
      internal static var _saveFilePath:String = "";
      
      private var _group:SaveGroup;
      
      private var _name:String;
      
      private var _id:uint;
      
      private var _description:String;
      
      private var _authorId:uint;
      
      private var _authorName:String;
      
      private var _createdDate:String;
      
      private var _modifiedDate:String;
      
      private var _views:uint;
      
      private var _readOnly:Boolean;
      
      private var _public:Boolean;
      
      private var _approved:Boolean;
      
      private var _draft:Boolean;
      
      private var _iconLoader:BitmapLoader;
      
      private var _keys:Object;
      
      private var _ratings:Object;
      
      private var _numVotes:Object;
      
      private var _dataURL:String;
      
      private var _data:*;
      
      private var _dataLoaded:Boolean;
      
      private var _encodedData:*;
      
      private var _encoderQueue:Array;
      
      private var _encoding:Boolean;
      
      private var _encodingParent:Object;
      
      private var _encodingProperty:String;
      
      private var _fileSize:uint;
      
      private var _dataLoader:URLLoader;
      
      public function SaveFile(param1:SaveGroup)
      {
         super();
         this._iconLoader = new BitmapLoader(DEFAULT_ICON,null);
         this._group = param1;
         this._keys = {};
         this._ratings = {};
         this._numVotes = {};
      }
      
      public static function get currentFile() : SaveFile
      {
         return _currentFile;
      }
      
      internal static function fromObject(param1:SaveGroup, param2:Object) : SaveFile
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:SaveKey = null;
         var _loc6_:SaveRating = null;
         var _loc7_:SaveFile = new SaveFile(param1);
         _loc7_._name = param2.filename;
         _loc7_._description = param2.description;
         _loc7_._id = param2.save_id;
         _loc7_._authorId = param2.user_id;
         _loc7_._authorName = param2.user_name;
         _loc7_._createdDate = param2.created;
         _loc7_._modifiedDate = param2.last_update;
         _loc7_._views = param2.views;
         if(Boolean(param2.thumb) && param2.thumb != "")
         {
            _loc7_._iconLoader.url = _imageFilePath + param2.thumb;
         }
         _loc7_._dataURL = _saveFilePath + param2.file;
         _loc7_._fileSize = param2.file_size;
         _loc7_._approved = param2.status != STATUS_UNAPPROVED;
         _loc7_._readOnly = false;
         _loc7_._public = param2.status != STATUS_PRIVATE && param2.status != STATUS_UNAPPROVED;
         for each(_loc3_ in param2.keys)
         {
            _loc5_ = param1.getKeyById(_loc3_.id);
            if(_loc5_)
            {
               _loc7_._keys[_loc5_.name] = _loc5_.validateValue(_loc3_.value);
            }
         }
         for each(_loc4_ in param2.ratings)
         {
            _loc6_ = param1.getRatingById(_loc4_.id);
            if(_loc6_)
            {
               _loc7_._ratings[_loc6_.name] = _loc6_.validateValue(_loc4_.score);
               _loc7_._numVotes[_loc6_.name] = int(_loc4_.votes);
            }
         }
         return _loc7_;
      }
      
      public function get group() : SaveGroup
      {
         return this._group;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get description() : String
      {
         return this._description;
      }
      
      public function set description(param1:String) : void
      {
         this._description = param1;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
      }
      
      public function get bytesLoaded() : uint
      {
         if(this._data)
         {
            return this.bytesTotal;
         }
         if(!this._dataLoader)
         {
            return 0;
         }
         return this._dataLoader.bytesLoaded;
      }
      
      public function get bytesTotal() : uint
      {
         return this._fileSize;
      }
      
      public function get readOnly() : Boolean
      {
         return this._readOnly;
      }
      
      public function get draft() : Boolean
      {
         return this._draft;
      }
      
      public function set draft(param1:Boolean) : void
      {
         this._draft = param1;
      }
      
      public function get authorId() : uint
      {
         return this._authorId;
      }
      
      public function get authorName() : String
      {
         return this._authorName;
      }
      
      public function get keys() : Object
      {
         return this._keys;
      }
      
      public function get ratings() : Object
      {
         return this._ratings;
      }
      
      public function get numVotes() : Object
      {
         return this._numVotes;
      }
      
      public function get views() : uint
      {
         return this._views;
      }
      
      public function get createdDate() : String
      {
         return this._createdDate;
      }
      
      public function get updatedDate() : String
      {
         return this._modifiedDate;
      }
      
      override public function toString() : String
      {
         return "Save File: " + this._name;
      }
      
      public function get icon() : BitmapData
      {
         return this._iconLoader.bitmapData;
      }
      
      public function set icon(param1:BitmapData) : void
      {
         this.createIcon(param1);
      }
      
      public function get iconLoaded() : Boolean
      {
         return this._iconLoader.loaded;
      }
      
      public function createIcon(param1:IBitmapDrawable) : void
      {
         var _loc2_:Number = Number(NaN);
         var _loc3_:Number = Number(NaN);
         var _loc4_:Number = Number(NaN);
         var _loc5_:Rectangle = null;
         var _loc6_:BitmapData = new BitmapData(ICON_WIDTH,ICON_HEIGHT,false,0);
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         if(param1 is BitmapData)
         {
            _loc2_ = Number(BitmapData(param1).width);
            _loc3_ = Number(BitmapData(param1).height);
         }
         else if(param1 is DisplayObject)
         {
            _loc5_ = DisplayObject(param1).getBounds(null);
            _loc7_ = _loc5_.left;
            _loc8_ = _loc5_.top;
            _loc2_ = _loc5_.width;
            _loc3_ = _loc5_.height;
         }
         var _loc9_:Matrix = new Matrix();
         _loc4_ = Math.min(ICON_WIDTH / _loc2_,ICON_HEIGHT / _loc3_);
         _loc9_.translate(-_loc7_,-_loc8_);
         _loc9_.scale(_loc4_,_loc4_);
         _loc9_.translate((ICON_WIDTH - _loc2_ * _loc4_) / 2,(ICON_HEIGHT - _loc3_ * _loc4_) / 2);
         _loc6_.draw(param1,_loc9_);
         this._iconLoader.bitmapData = _loc6_;
      }
      
      public function attachIcon(param1:DisplayObjectContainer) : Sprite
      {
         if(this._iconLoader)
         {
            return this._iconLoader.attachBitmap(param1);
         }
         Logger.logError("No icon available for this sumbission.");
         return null;
      }
      
      public function deleteFile() : void
      {
         if(!this._group.connection.hasUserSession)
         {
            Logger.logError("The user must be logged-in to delete a file.");
            dispatchEvent(new APIEvent(APIEvent.FILE_DELETED,null,APIEvent.ERROR_NOT_LOGGED_IN));
            return;
         }
         if(!this._id)
         {
            Logger.logError("The file does not exist.");
            dispatchEvent(new APIEvent(APIEvent.FILE_DELETED,null,APIEvent.ERROR_NOT_LOGGED_IN));
            return;
         }
         var _loc1_:APICommand = new APICommand("deleteSaveFile");
         _loc1_.secureParameters.save_id = this._id;
         _loc1_.addEventListener(APIEvent.COMMAND_COMPLETE,this.onFileDeleted);
         this._group.connection.sendCommand(_loc1_);
      }
      
      public function save() : void
      {
         if(!this._group.connection.hasUserSession)
         {
            Logger.logError("The user must be logged-in to save a file.");
            dispatchEvent(new APIEvent(APIEvent.FILE_SAVED,null,APIEvent.ERROR_NOT_LOGGED_IN));
            return;
         }
         ++BitmapLoader._cacheSeed;
         _currentFile = this;
         this.encodeData(true);
      }
      
      private function doSave() : void
      {
         var _loc1_:String = null;
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:SaveKey = null;
         var _loc5_:SaveRating = null;
         var _loc6_:ByteArray = null;
         var _loc7_:APICommand = new APICommand("saveFile");
         _loc7_.secureParameters.group = this._group.id;
         _loc7_.secureParameters.user_name = this._group.connection.username;
         _loc7_.secureParameters.filename = this._name;
         _loc7_.secureParameters.description = this._description;
         if(this._draft)
         {
            _loc7_.secureParameters.draft = true;
         }
         if(Boolean(this._id) && !this._readOnly)
         {
            _loc7_.secureParameters.overwrite = 1;
            _loc7_.secureParameters.save_id = this._id;
         }
         var _loc8_:Array = [];
         for(_loc1_ in this._keys)
         {
            _loc4_ = this._group.getKey(_loc1_);
            if(_loc4_)
            {
               _loc8_.push({
                  "id":_loc4_.id,
                  "value":_loc4_.validateValue(this._keys[_loc1_])
               });
            }
            else
            {
               Logger.logError("No key named \"" + _loc1_ + "\" in save group \"" + this._group.name + "\".");
            }
         }
         _loc7_.secureParameters.keys = _loc8_;
         _loc2_ = [];
         for(_loc3_ in this._ratings)
         {
            _loc5_ = this._group.getRating(_loc3_);
            if(_loc5_)
            {
               _loc2_.push({
                  "id":_loc5_.id,
                  "value":_loc5_.validateValue(this._ratings[_loc3_])
               });
            }
            else
            {
               Logger.logError("No rating named \"" + _loc3_ + "\" in save group \"" + this._group.name + "\".");
            }
         }
         _loc7_.secureParameters.ratings = _loc2_;
         _loc6_ = new ByteArray();
         _loc6_.writeObject(this._encodedData);
         _loc6_.compress();
         _loc7_.addFile("file",_loc6_,"file");
         if(this.iconLoaded)
         {
            _loc7_.addFile("thumbnail",PNGEncoder.encode(this.icon),"thumbnail");
         }
         _loc7_.addEventListener(APIEvent.COMMAND_COMPLETE,this.onSaveComplete);
         this._group.connection.sendCommand(_loc7_);
      }
      
      private function encodeData(param1:Boolean) : void
      {
         this._encoderQueue = [];
         this._encoding = param1;
         if(param1)
         {
            this._encodedData = this._data;
            this.preEncodeObject(this,"_encodedData");
         }
         else
         {
            this.preEncodeObject(this,"_data");
         }
         this.encodeObject();
      }
      
      private function preEncodeObject(param1:Object, param2:String) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:Object = param1[param2];
         try
         {
            if(this._encoding)
            {
               _loc3_ = _loc6_ is BitmapData;
            }
            else
            {
               _loc3_ = _loc6_.type == "__bitmap";
            }
         }
         catch(error:*)
         {
         }
         var _loc7_:Object = _loc6_;
         _loc4_ = _loc6_ is ByteArray;
         if(_loc3_)
         {
            this._encoderQueue.push({
               "parent":param1,
               "property":param2
            });
         }
         else if(typeof _loc6_ == "object" && !_loc4_)
         {
            if(this._encoding)
            {
               if(_loc6_ is Array)
               {
                  _loc7_ = [];
               }
               else
               {
                  _loc7_ = {};
               }
               for(_loc5_ in _loc6_)
               {
                  _loc7_[_loc5_] = _loc6_[_loc5_];
               }
               param1[param2] = _loc7_;
            }
            for(_loc5_ in _loc7_)
            {
               this.preEncodeObject(_loc7_,_loc5_);
            }
         }
      }
      
      private function encodeObject() : void
      {
         var _loc1_:Object = null;
         if(!this._encoderQueue.length)
         {
            if(this._encoding)
            {
               this.doSave();
            }
            else
            {
               this._dataLoaded = true;
               this.checkLoadComplete();
            }
            return;
         }
         var _loc2_:Object = this._encoderQueue.pop();
         var _loc3_:Object = _loc2_.parent;
         var _loc4_:String = _loc2_.property;
         var _loc5_:Object = _loc3_[_loc4_];
         if(this._encoding)
         {
            _loc1_ = {
               "type":"__bitmap",
               "width":_loc5_.width,
               "height":_loc5_.height,
               "transparent":_loc5_.transparent
            };
            _loc3_[_loc4_] = _loc1_;
            _loc1_.data = new ByteArray();
            _loc1_.data.writeBytes(_loc5_.getPixels(_loc5_.rect));
            _loc1_.data.position = 0;
         }
         else
         {
            _loc1_ = new BitmapData(_loc5_.width,_loc5_.height,_loc5_.transparent);
            _loc1_.setPixels(_loc1_.rect,_loc5_.data);
            _loc3_[_loc4_] = _loc1_;
         }
         this.encodeObject();
      }
      
      private function onIconLoaded(param1:APIEvent) : void
      {
         if(!param1.success && Boolean(this._iconLoader.url))
         {
            Logger.logWarning("Unable to load the icon for this save file.");
         }
         this._iconLoader.removeEventListener(APIEvent.ICON_LOADED,this.onIconLoaded);
         this.checkLoadComplete();
      }
      
      private function checkLoadComplete() : void
      {
         if(Boolean(this._dataLoaded) && this.iconLoaded)
         {
            Logger.logMessage("Data loaded.");
            dispatchEvent(new APIEvent(APIEvent.FILE_LOADED,this));
         }
      }
      
      private function onDataLoaded(param1:*) : void
      {
         var byteArray:ByteArray = null;
         var data:* = param1;
         try
         {
            if(data)
            {
               byteArray = data;
               byteArray.uncompress();
               this._data = byteArray.readObject();
               this.encodeData(false);
            }
         }
         catch(error:Error)
         {
            Logger.logError("Error while loading data:",error);
            dispatchEvent(new APIEvent(APIEvent.FILE_LOADED,this,APIEvent.ERROR_BAD_FILE));
         }
      }
      
      private function onDataError(param1:String) : void
      {
         Logger.logError("Unable to load data:",param1);
         dispatchEvent(new APIEvent(APIEvent.FILE_LOADED,this,APIEvent.ERROR_BAD_FILE));
      }
      
      private function onSaveComplete(param1:APIEvent) : void
      {
         if(param1.success)
         {
            Logger.logMessage("File \"" + this._name + "\" saved!");
            if(param1.data)
            {
               this._id = param1.data.save_id;
               this._dataURL = unescape(param1.data.file_url);
            }
            dispatchEvent(new APIEvent(APIEvent.FILE_SAVED,this));
         }
         else
         {
            Logger.logError("Error saving file \"" + this._name + "\":",param1.error);
            dispatchEvent(new APIEvent(APIEvent.FILE_SAVED,this,param1.error));
         }
      }
      
      public function sendVote(param1:String, param2:Number) : void
      {
         var _loc3_:SaveRating = this._group.getRating(param1);
         if(!_loc3_)
         {
            Logger.logError("No save rating named \"" + param1 + "\" exists for this save group.");
            dispatchEvent(new APIEvent(APIEvent.VOTE_COMPLETE,{},APIEvent.ERROR_INVALID_ARGUMENT));
            return;
         }
         param2 = _loc3_.validateValue(param2);
         if(isNaN(param2))
         {
            Logger.logError("Invalid vote (" + param2 + "). " + param1 + " allows a range of " + _loc3_.minimum + "-" + _loc3_.maximum + ".");
            dispatchEvent(new APIEvent(APIEvent.VOTE_COMPLETE,{},APIEvent.ERROR_INVALID_ARGUMENT));
            return;
         }
         Logger.logMessage("Voting " + param2 + " for " + param1 + " on " + this._name + "...");
         this._group.connection.sendSimpleCommand("rateSaveFile",this.onVoteComplete,null,{
            "group":this._group.id,
            "save_id":this._id,
            "rating_id":_loc3_.id,
            "vote":param2
         });
      }
      
      private function onVoteComplete(param1:APIEvent) : void
      {
         var _loc2_:SaveRating = null;
         var _loc3_:String = param1.error;
         if(param1.data.already_voted)
         {
            Logger.logError("Vote failed. You\'ve already voted on this rating today.");
            _loc3_ = APIEvent.ERROR_ALREADY_VOTED;
         }
         if(_loc3_ == APIEvent.ERROR_NONE)
         {
            _loc2_ = this._group.getRatingById(param1.data.rating_id);
            if(_loc2_)
            {
               this._ratings[_loc2_.name] = _loc2_.validateValue(param1.data.score);
            }
            Logger.logMessage("Vote complete!");
         }
         dispatchEvent(new APIEvent(APIEvent.VOTE_COMPLETE,this,_loc3_));
      }
      
      private function onFileDeleted(param1:APIEvent) : void
      {
         if(param1.success)
         {
            this._id = 0;
         }
         dispatchEvent(new APIEvent(APIEvent.FILE_DELETED,this,param1.error));
      }
      
      public function clone() : SaveFile
      {
         var _loc1_:String = null;
         var _loc2_:SaveFile = new SaveFile(this._group);
         _loc2_._data = this._data;
         _loc2_._description = this._description;
         _loc2_._draft = this._draft;
         _loc2_._fileSize = this._fileSize;
         _loc2_._iconLoader.bitmapData = this._iconLoader.bitmapData;
         for(_loc1_ in this._keys)
         {
            _loc2_._keys[_loc1_] = this._keys[_loc1_];
         }
         for(_loc1_ in this._ratings)
         {
            _loc2_._ratings[_loc1_] = this._ratings[_loc1_];
         }
         for(_loc1_ in this._numVotes)
         {
            _loc2_._numVotes[_loc1_] = this._numVotes[_loc1_];
         }
         _loc2_._name = this._name;
         return _loc2_;
      }
      
      public function load() : void
      {
         _currentFile = this;
         this._dataLoaded = false;
         this._data = null;
         if(!this.iconLoaded)
         {
            this._iconLoader.addEventListener(APIEvent.ICON_LOADED,this.onIconLoaded);
            this._iconLoader.load();
         }
         this._dataLoader = new URLLoader();
         this._dataLoader.dataFormat = URLLoaderDataFormat.BINARY;
         this._dataLoader.addEventListener(Event.COMPLETE,this.as3DataLoaded);
         this._dataLoader.addEventListener(IOErrorEvent.IO_ERROR,this.as3DataError);
         this._dataLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.as3DataError);
         this._dataLoader.load(new URLRequest(this._dataURL + "&random=" + Math.random()));
      }
      
      private function as3DataLoaded(param1:Event) : void
      {
         this.onDataLoaded(this._dataLoader.data);
      }
      
      private function as3DataError(param1:Event) : void
      {
         this.onDataError(param1.toString());
      }
      
      private function decodeObject(param1:Object) : Object
      {
         var _loc2_:BitmapData = null;
         var _loc3_:String = null;
         if(getQualifiedClassName(param1) == "Object")
         {
            if(param1.type == "__bitmap")
            {
               _loc2_ = new BitmapData(param1.width,param1.height,param1.transparent);
               _loc2_.setPixels(_loc2_.rect,param1.data);
               param1 = _loc2_;
            }
            else
            {
               for(_loc3_ in param1)
               {
                  param1[_loc3_] = this.decodeObject(param1[_loc3_]);
               }
            }
         }
         return param1;
      }
   }
}

