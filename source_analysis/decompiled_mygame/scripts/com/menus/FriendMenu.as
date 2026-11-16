package com.menus
{
   import com.game_objects.*;
   import com.game_objects.extensions.*;
   import com.math.*;
   import com.stats.*;
   import com.ui.*;
   import com.utilities.*;
   import feathers.controls.*;
   import feathers.events.*;
   import flash.display.*;
   import flash.geom.*;
   import playerio.*;
   import starling.*;
   import starling.core.*;
   import starling.display.*;
   import starling.events.*;
   import starling.text.*;
   import starling.textures.*;
   import starling.utils.*;
   
   public final class FriendMenu extends StarlingGameMenu implements IScrollableGameMenu
   {
      
      public static var friendMenu_textureAtlas:TextureAtlas;
      
      public static const FRIENDS:String = "friends";
      
      public static const ENEMIES:String = "enemies";
      
      public static const GUILD:String = "guild";
      
      public static var friends_array:Vector.<String> = new Vector.<String>();
      
      public static var enemies_array:Vector.<String> = new Vector.<String>();
      
      public static var guild_array:Vector.<String> = new Vector.<String>();
      
      public static var friendsInfo_array:Vector.<DatabaseObject> = new Vector.<DatabaseObject>();
      
      public static var guildInfo_array:Vector.<DatabaseObject> = new Vector.<DatabaseObject>();
      
      private static var current_date:Date = new Date();
      
      private var personClone:Person;
      
      private var chat_btn:Button;
      
      private var add_btn:Button;
      
      private var remove_btn:Button;
      
      private const info_txt:TextField = new TextField(165,174,"description",AllTextFormats.info_textFormat);
      
      public const friendName_txt:TextField = new TextField(180,24,"name",AllTextFormats.friendName_textFormat);
      
      public const title_txt:TextField = new TextField(261,33,"FRIENDS",AllTextFormats.title_textFormat);
      
      private var list_sprite:starling.display.Sprite = new Sprite();
      
      private var addPanel_image:Image;
      
      private var addFriendString_btn:Button;
      
      private var scroll_btn:Button;
      
      public var enterName_txt:TextInput;
      
      private const banned_txt:TextField = new TextField(174,142,"BANNED",AllTextFormats.banned_textFormat);
      
      private const mask_canvas:Canvas = new Canvas();
      
      private var panel_array:Vector.<Image> = new Vector.<Image>();
      
      private var nameText_array:Vector.<TextField> = new Vector.<TextField>();
      
      private var status_array:Vector.<Image> = new Vector.<Image>();
      
      private var fullName_array:Vector.<String> = new Vector.<String>();
      
      private var head_array:Vector.<starling.display.Sprite> = new Vector.<Sprite>();
      
      public function FriendMenu(param1:GameMain)
      {
         var _loc4_:Image = null;
         var _loc5_:Button = null;
         var _loc7_:Image = null;
         var _loc2_:Button = null;
         var _loc3_:Button = null;
         super();
         _loc4_ = new Image(friendMenu_textureAtlas.getTexture("panel"));
         _loc4_.x = -307;
         _loc4_.y = -236;
         addChild(_loc4_);
         _loc5_ = new Button(friendMenu_textureAtlas.getTexture("x_btn_00"));
         _loc5_.x = 197;
         _loc5_.y = -222;
         _loc5_.pivotX = 30;
         _loc5_.pivotY = 19;
         _loc5_.scaleWhenOver = 0.95;
         _loc5_.name = "x_btn";
         addChild(_loc5_);
         this.chat_btn = new Button(friendMenu_textureAtlas.getTexture("chat_btn"));
         this.chat_btn.x = 133;
         this.chat_btn.y = 247;
         this.chat_btn.pivotX = 33;
         this.chat_btn.pivotY = 15;
         this.chat_btn.name = "chat_btn";
         addChild(this.chat_btn);
         this.remove_btn = new Button(friendMenu_textureAtlas.getTexture("unFriend_btn_00"));
         this.remove_btn.x = 59;
         this.remove_btn.y = 212;
         this.remove_btn.pivotX = 51;
         this.remove_btn.pivotY = 15;
         this.remove_btn.name = "unFriend_btn";
         addChild(this.remove_btn);
         this.add_btn = new Button(friendMenu_textureAtlas.getTexture("addFriendMenu_btn_00"));
         this.add_btn.x = 44;
         this.add_btn.y = 247;
         this.add_btn.pivotX = 33;
         this.add_btn.pivotY = 15;
         this.add_btn.scaleWhenOver = this.remove_btn.scaleWhenOver = this.chat_btn.scaleWhenOver = 0.95;
         this.add_btn.name = "addFriendMenu_btn";
         addChild(this.add_btn);
         var _loc6_:Button = new Button(friendMenu_textureAtlas.getTexture("friendsTab_btn"));
         _loc6_.x = -220;
         _loc6_.y = -182;
         _loc6_.pivotX = 51;
         _loc6_.pivotY = 18;
         _loc6_.name = "friendsTab_btn";
         addChild(_loc6_);
         if(param1.player.guild != "")
         {
            _loc2_ = new Button(friendMenu_textureAtlas.getTexture("guildTab_btn"));
            _loc2_.x = -95;
            _loc2_.y = -182;
            _loc2_.pivotX = 51;
            _loc2_.pivotY = 18;
            _loc2_.name = "guildTab_btn";
            addChild(_loc2_);
         }
         this.scroll_btn = new Button(friendMenu_textureAtlas.getTexture("scroll_btn"));
         this.scroll_btn.x = -8;
         this.scroll_btn.y = -132;
         this.scroll_btn.pivotX = 15;
         this.scroll_btn.pivotY = 19;
         this.scroll_btn.name = "scroll_btn";
         this.scroll_btn.visible = !GameMain.isMobile;
         addChild(this.scroll_btn);
         if(param1.playingURL_string == "facebook.com")
         {
            _loc3_ = new Button(friendMenu_textureAtlas.getTexture("facebookInvite_btn"));
            _loc3_.x = -235;
            _loc3_.y = 303;
            _loc3_.pivotX = 72;
            _loc3_.pivotY = 22;
            _loc3_.name = "facebookInvite_btn";
            addChild(_loc3_);
         }
         this.mask_canvas.drawRectangle(-201,-187,308,439);
         this.list_sprite.x = -134;
         this.list_sprite.y = 20;
         this.list_sprite.mask = this.mask_canvas;
         this.list_sprite.name = "itemScrollList";
         addChild(this.list_sprite);
         _loc7_ = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("dark green pixel"));
         _loc7_.x = -140;
         _loc7_.y = -474;
         _loc7_.width = 250;
         _loc7_.height = 40 * 34;
         _loc7_.name = "itemScrollList";
         this.list_sprite.addChild(_loc7_);
         this.title_txt.x = -167;
         this.title_txt.y = -236;
         addChild(this.title_txt);
         this.friendName_txt.x = 12;
         this.friendName_txt.y = -172;
         addChild(this.friendName_txt);
         this.info_txt.x = 17;
         this.info_txt.y = 14;
         addChild(this.info_txt);
         this.banned_txt.x = -12;
         this.banned_txt.y = -102;
         this.banned_txt.rotation = deg2rad(-35);
         addChild(this.banned_txt);
         this.title_txt.touchable = this.friendName_txt.touchable = this.info_txt.touchable = this.banned_txt.touchable = false;
         this.title_txt.batchable = this.friendName_txt.batchable = this.info_txt.batchable = this.banned_txt.batchable = true;
         this.remove_btn.visible = this.chat_btn.visible = false;
         this.personClone = new Person(param1,false,"");
         this.personClone.x = 120;
         this.personClone.y = -74;
         this.personClone.scaleX = -1;
         this.personClone.touchable = false;
         addChild(this.personClone);
         drag_image = new Image(Texture.fromBitmapData(new BitmapData(462,36,false,16711680)));
         drag_image.x = -297;
         drag_image.y = -237;
         drag_image.name = "drag_image";
         drag_image.alpha = 0;
         addChild(drag_image);
         addEventListener(Event.ENTER_FRAME,this.onEnter);
         this.list_sprite.y = 292;
         this.mask_canvas.y = -272;
      }
      
      public static function getUserFullString(param1:String) : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = param1.toLowerCase();
         for each(_loc2_ in FriendMenu.friends_array)
         {
            _loc4_ = _loc2_.toLowerCase();
            if(_loc6_ == Person.removeNamePrefix(_loc4_))
            {
               return _loc2_;
            }
         }
         for each(_loc3_ in FriendMenu.enemies_array)
         {
            _loc5_ = _loc3_.toLowerCase();
            if(_loc6_ == Person.removeNamePrefix(_loc5_))
            {
               return _loc3_;
            }
         }
         throw new Error("Username supplied is not on the players friend or enemy list.");
      }
      
      public static function parseDate(param1:String) : Date
      {
         if(param1 == null || param1 == "" || param1 == "undefined")
         {
            return new Date(NaN);
         }
         var _loc2_:Number = Date.parse(param1);
         if(!isNaN(_loc2_))
         {
            return new Date(_loc2_);
         }
         var _loc3_:String = param1;
         _loc3_ = _loc3_.replace("T"," ");
         if(_loc3_.charAt(_loc3_.length - 1) == "Z")
         {
            _loc3_ = _loc3_.substring(0,_loc3_.length - 1);
         }
         var _loc4_:int = _loc3_.indexOf(".");
         if(_loc4_ > -1)
         {
            _loc3_ = _loc3_.substring(0,_loc4_);
         }
         var _loc5_:Array = _loc3_.split(" ");
         if(_loc5_.length < 2)
         {
            return new Date(NaN);
         }
         var _loc6_:Array = String(_loc5_[0]).split("-");
         var _loc7_:Array = String(_loc5_[1]).split(":");
         if(_loc6_.length < 3 || _loc7_.length < 2)
         {
            return new Date(NaN);
         }
         var _loc8_:int = int(_loc6_[0]);
         var _loc9_:int = int(_loc6_[1]) - 1;
         var _loc10_:int = int(_loc6_[2]);
         var _loc11_:int = int(_loc7_[0]);
         var _loc12_:int = int(_loc7_[1]);
         var _loc13_:int = _loc7_.length > 2 ? int(_loc7_[2]) : 0;
         return new Date(Date.UTC(_loc8_,_loc9_,_loc10_,_loc11_,_loc12_,_loc13_));
      }
      
      public static function timeFromNow(param1:String) : int
      {
         var _loc2_:int = new int(parseDate(param1).getTime() / 1000 / 60 / 60 / 24);
         var _loc3_:int = new int(current_date.getTime() / 1000 / 60 / 60 / 24);
         return _loc3_ - _loc2_;
      }
      
      private function onEnter(param1:Event) : void
      {
         this.personClone.bodyAnimator.onEnter();
         if(this.personClone.bodyAnimator.currentLabel != "standing")
         {
            this.personClone.bodyAnimator.gotoAndPlayInt(0);
         }
      }
      
      public function updateMe(param1:Client, param2:String, param3:Boolean = true, param4:String = "") : void
      {
         var _client:Client = param1;
         var _show:String = param2;
         var _deselect:Boolean = param3;
         var _guild:String = param4;
         var tempArray:Vector.<String> = null;
         var i:int = 0;
         var len:int = 0;
         var smallPanel_image:Image = null;
         var status_image:Image = null;
         var panelText:String = null;
         var friendNamePiece_txt:TextField = null;
         var head_sprite:starling.display.Sprite = null;
         var head_image:Image = null;
         var eyes_image:Image = null;
         var beard_image:Image = null;
         var hair_image:Image = null;
         var helmet_image:Image = null;
         var hasRow:Boolean = false;
         var _memberObject:DatabaseObject = null;
         if(_show == GUILD && _guild != "")
         {
            _client.bigDB.load("guildsData",_guild,function(param1:DatabaseObject):void
            {
               var _guildObject:DatabaseObject = param1;
               var _member:String = null;
               guildInfo_array.length = 0;
               CommonCalls.emptyArray(panel_array,true,true);
               CommonCalls.emptyArray(status_array,true,true);
               CommonCalls.emptyArray(nameText_array,true,true);
               CommonCalls.emptyArray(head_array,true,true);
               guild_array = Vector.<String>(_guildObject.mArray);
               updateMe(_client,_show,_deselect);
               for each(_member in _guildObject.mArray)
               {
                  if(_member.indexOf("facebook") != 0 && _member.indexOf("kongregate") != 0 && _member.indexOf("steam") != 0)
                  {
                     _client.bigDB.load("PlayerObjects",_member,function(param1:DatabaseObject):void
                     {
                        guildInfo_array.push(param1);
                        MainStarlingStage(root).gameMain.friendInfoLoaded(param1);
                     });
                  }
                  else
                  {
                     _client.bigDB.loadSingle("PlayerObjects","nameIndex",[_member],function(param1:DatabaseObject):void
                     {
                        guildInfo_array.push(param1);
                        MainStarlingStage(root).gameMain.friendInfoLoaded(param1);
                     });
                  }
               }
            });
         }
         else
         {
            if(_show != GUILD && this.panel_array.length != MainStarlingStage(root).gameMain.maxFriends)
            {
               CommonCalls.emptyArray(this.panel_array,true,true);
               CommonCalls.emptyArray(this.status_array,true,true);
               CommonCalls.emptyArray(this.nameText_array,true,true);
               CommonCalls.emptyArray(this.head_array,true,true);
            }
            switch(_show)
            {
               case FRIENDS:
                  tempArray = friends_array;
                  break;
               case ENEMIES:
                  tempArray = enemies_array;
                  break;
               case GUILD:
                  tempArray = guild_array;
            }
            this.title_txt.text = _show.toUpperCase();
            if(_deselect == true)
            {
               this.friendName_txt.text = this.info_txt.text = "";
               this.chat_btn.visible = false;
               this.remove_btn.visible = false;
               this.personClone.visible = false;
               this.banned_txt.visible = false;
            }
            i = 0;
            len = 0;
            if(this.list_sprite.numChildren == 1)
            {
               len = _show != GUILD ? int(MainStarlingStage(root).gameMain.maxFriends) : 40;
               i = 0;
               while(i < len)
               {
                  smallPanel_image = new Image(friendMenu_textureAtlas.getTexture("friend slot_00"));
                  smallPanel_image.x = -163;
                  smallPanel_image.y = -490 + (i + 1) * 34;
                  smallPanel_image.useHandCursor = smallPanel_image.touchable = i < tempArray.length;
                  this.list_sprite.addChild(smallPanel_image);
                  this.panel_array.push(smallPanel_image);
                  status_image = new Image(friendMenu_textureAtlas.getTexture("offline clip"));
                  status_image.x = 76;
                  status_image.y = -469 + (i + 1) * 34;
                  status_image.pivotX = 27;
                  status_image.pivotY = 12;
                  status_image.touchable = false;
                  this.list_sprite.addChild(status_image);
                  this.status_array.push(status_image);
                  if(i >= tempArray.length || _show != FRIENDS)
                  {
                     status_image.visible = false;
                  }
                  i++;
               }
               i = 0;
               while(i < len)
               {
                  panelText = i < tempArray.length ? (panelText = Person.removeNamePrefix(tempArray[i])) : "--------";
                  this.fullName_array.push(i < tempArray.length ? tempArray[i] : "");
                  friendNamePiece_txt = new TextField(196,22,panelText,AllTextFormats.friendNamePiece_textFormat);
                  friendNamePiece_txt.x = -128;
                  friendNamePiece_txt.y = -481 + (i + 1) * 34;
                  friendNamePiece_txt.batchable = true;
                  friendNamePiece_txt.touchable = false;
                  this.list_sprite.addChild(friendNamePiece_txt);
                  this.nameText_array.push(friendNamePiece_txt);
                  if(i < tempArray.length && _show != ENEMIES)
                  {
                     if(_show == FRIENDS)
                     {
                        if(tempArray[i].indexOf("facebook") != 0 && tempArray[i].indexOf("kongregate") != 0 && tempArray[i].indexOf("steam") != 0)
                        {
                           _client.bigDB.load("PlayerObjects",tempArray[i],MainStarlingStage(root).gameMain.friendInfoLoaded);
                        }
                        else
                        {
                           _client.bigDB.loadSingle("PlayerObjects","nameIndex",[tempArray[i]],MainStarlingStage(root).gameMain.friendInfoLoaded);
                        }
                     }
                  }
                  i++;
               }
               i = 0;
               while(i < len)
               {
                  head_sprite = new Sprite();
                  head_sprite.x = -143;
                  head_sprite.y = -466 + (i + 1) * 34;
                  head_sprite.scaleX = head_sprite.scaleY = 0.75;
                  head_sprite.touchGroup = true;
                  head_sprite.visible = false;
                  this.list_sprite.addChild(head_sprite);
                  this.head_array.push(head_sprite);
                  head_image = new Image(Assets.items_textureAtlas.getTexture("male head 1"));
                  head_image.x = -14;
                  head_image.y = -13;
                  head_image.name = "head";
                  head_sprite.addChild(head_image);
                  eyes_image = new Image(Assets.items_textureAtlas.getTexture("eyes 1"));
                  eyes_image.x = -3;
                  eyes_image.y = -5;
                  eyes_image.name = "eyes";
                  eyes_image.touchable = false;
                  head_sprite.addChild(eyes_image);
                  beard_image = new Image(Assets.items_textureAtlas.getTexture("beard 2"));
                  beard_image.x = 6;
                  beard_image.y = 8;
                  beard_image.name = "beard";
                  head_sprite.addChild(beard_image);
                  hair_image = new Image(Assets.items_textureAtlas.getTexture("hair 1"));
                  hair_image.x = -34;
                  hair_image.y = -45;
                  hair_image.name = "hair";
                  head_sprite.addChild(hair_image);
                  helmet_image = new Image(Assets.items_textureAtlas.getTexture("green beanie"));
                  helmet_image.x = BodyAnimator.helmetsX_array[0];
                  helmet_image.y = BodyAnimator.helmetsY_array[0];
                  helmet_image.pivotX = Assets.items_object["green beanie"].pivotX;
                  helmet_image.pivotY = Assets.items_object["green beanie"].pivotY;
                  helmet_image.name = "helmet";
                  head_sprite.addChild(helmet_image);
                  head_sprite.touchable = head_image.touchable = eyes_image.touchable = beard_image.touchable = hair_image.touchable = helmet_image.touchable = false;
                  i++;
               }
            }
            else
            {
               len = int(MainStarlingStage(root).gameMain.maxFriends);
               i = 0;
               while(i < len)
               {
                  this.panel_array[i].texture = friendMenu_textureAtlas.getTexture("friend slot_00");
                  if(i < tempArray.length)
                  {
                     this.panel_array[i].touchable = this.panel_array[i].useHandCursor = true;
                     this.nameText_array[i].text = Person.removeNamePrefix(tempArray[i]);
                     this.fullName_array[i] = tempArray[i];
                     this.status_array[i].visible = _show != ENEMIES && _show != GUILD;
                  }
                  else
                  {
                     this.panel_array[i].touchable = this.panel_array[i].useHandCursor = false;
                     this.nameText_array[i].text = "--------";
                     this.fullName_array[i] = "";
                     this.head_array[i].visible = false;
                     this.status_array[i].visible = false;
                  }
                  i++;
               }
            }
            this.setAddButtonVisibility(_show);
         }
         len = int(this.head_array.length);
         i = 0;
         while(i < len)
         {
            hasRow = this.nameText_array.length > i && this.nameText_array[i].text != "--------";
            if((_show == FRIENDS || _show == GUILD) && hasRow)
            {
               this.head_array[i].visible = _show != GUILD;
               if(_show == GUILD)
               {
                  for each(_memberObject in guildInfo_array)
                  {
                     if(_memberObject != null && Person.removeNamePrefix(_memberObject.name == undefined ? _memberObject.key : _memberObject.name) == this.nameText_array[i].text)
                     {
                        this.friendInfoLoaded(_memberObject);
                        this.head_array[i].visible = true;
                        break;
                     }
                  }
               }
               else if(friendsInfo_array.length > i)
               {
                  this.friendInfoLoaded(FriendMenu.friendsInfo_array[i]);
               }
            }
            else
            {
               this.head_array[i].visible = false;
            }
            i++;
         }
      }
      
      public function showFriend(param1:DatabaseObject) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:Image = null;
         for each(_loc2_ in this.panel_array)
         {
            _loc2_.texture = FriendMenu.friendMenu_textureAtlas.getTexture("friend slot_00");
         }
         this.removeAddPanel();
         this.friendName_txt.text = Person.removeNamePrefix(param1.name);
         this.personClone.visible = true;
         this.remove_btn.visible = this.title_txt.text != GUILD.toUpperCase() ? true : false;
         var _loc3_:Date = parseDate(param1.login);
         this.banned_txt.visible = param1.ban != undefined;
         this.chat_btn.visible = Boolean(param1.on) && this.title_txt.text != ENEMIES.toUpperCase() ? true : false;
         this.info_txt.text = "name: " + Person.removeNamePrefix(param1.name) + "\n" + "level: " + param1.lev + "\n";
         if(param1.guild != undefined && param1.guild != null && String(param1.guild).length > 0)
         {
            this.info_txt.text += "guild: " + param1.guild + "\n";
         }
         if(this.title_txt.text != ENEMIES.toUpperCase())
         {
            this.info_txt.text += "online: " + (param1.on ? "yes" : "no") + (param1.on ? "" : "\nactive: " + _loc3_.toDateString());
            if(param1.on)
            {
               if(Stats.levelStats[param1.stage] != undefined)
               {
                  this.info_txt.text += "\narea: " + Stats.levelStats[param1.stage].fname;
                  if(param1.serv != undefined)
                  {
                     this.info_txt.text += "\nserver: " + param1.serv;
                  }
               }
               else
               {
                  this.info_txt.text += "\narea: n/a";
               }
            }
         }
         MainStarlingStage(root).gameMain.setPersonCopy(this.personClone,param1);
         this.setAddButtonVisibility(this.title_txt.text);
      }
      
      private function setAddButtonVisibility(param1:String) : void
      {
         var _loc2_:Vector.<String> = null;
         param1 = param1.toLocaleLowerCase();
         switch(param1)
         {
            case FRIENDS:
               _loc2_ = friends_array;
               break;
            case ENEMIES:
               _loc2_ = enemies_array;
               break;
            case GUILD:
               _loc2_ = guild_array;
         }
         if(param1 == FRIENDS && _loc2_.length < MainStarlingStage(root).gameMain.maxFriends)
         {
            this.add_btn.visible = true;
         }
         else if(param1 == ENEMIES && FriendMenu.enemies_array.length < MainStarlingStage(root).gameMain.maxFriends)
         {
            this.add_btn.visible = true;
         }
         else if(param1 == GUILD)
         {
            this.add_btn.visible = false;
         }
      }
      
      public function friendInfoLoaded(param1:DatabaseObject) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:int = int(this.nameText_array.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = param1.name == undefined ? param1.key : param1.name;
            if(this.nameText_array[_loc5_].text == Person.removeNamePrefix(_loc2_))
            {
               this.status_array[_loc5_].texture = param1.on ? friendMenu_textureAtlas.getTexture("online clip") : friendMenu_textureAtlas.getTexture("offline clip");
               this.head_array[_loc5_].visible = true;
               Image(this.head_array[_loc5_].getChildByName("eyes")).texture = Assets.items_textureAtlas.getTexture("eyes " + param1.eye);
               if(param1.beard != undefined && param1.beard > 1)
               {
                  Image(this.head_array[_loc5_].getChildByName("beard")).texture = Assets.items_textureAtlas.getTexture("beard " + param1.beard);
                  Image(this.head_array[_loc5_].getChildByName("beard")).pivotX = Assets.items_object["beard " + param1.beard].pivotX;
                  Image(this.head_array[_loc5_].getChildByName("beard")).pivotY = Assets.items_object["beard " + param1.beard].pivotY;
               }
               else
               {
                  Image(this.head_array[_loc5_].getChildByName("beard")).texture = Assets.items_textureAtlas.getTexture("pet none helmet");
               }
               if(param1.skin < 5)
               {
                  Image(this.head_array[_loc5_].getChildByName("head")).texture = Assets.items_textureAtlas.getTexture("male head " + param1.skin);
               }
               else if(param1.skin < 9)
               {
                  Image(this.head_array[_loc5_].getChildByName("head")).texture = Assets.items_textureAtlas.getTexture("female head " + (param1.skin - 4));
               }
               else
               {
                  Image(this.head_array[_loc5_].getChildByName("head")).texture = Assets.items_textureAtlas.getTexture("zombie head");
               }
               if(param1.helm != 2)
               {
                  for each(_loc3_ in Stats.itemList)
                  {
                     if(Stats.hStats[_loc3_] != undefined)
                     {
                        if(ItemStat(Stats.hStats[_loc3_]).frame == param1.helm)
                        {
                           Image(this.head_array[_loc5_].getChildByName("helmet")).texture = Assets.items_textureAtlas.getTexture(_loc3_);
                           Image(this.head_array[_loc5_].getChildByName("helmet")).x = BodyAnimator.helmetsX_array[param1.helm - 1];
                           Image(this.head_array[_loc5_].getChildByName("helmet")).y = BodyAnimator.helmetsY_array[param1.helm - 1];
                           Image(this.head_array[_loc5_].getChildByName("helmet")).pivotX = Assets.items_object[_loc3_].pivotX;
                           Image(this.head_array[_loc5_].getChildByName("helmet")).pivotY = Assets.items_object[_loc3_].pivotY;
                           break;
                        }
                     }
                  }
                  if(Stats.hStats[_loc3_] != undefined && Boolean(ItemStat(Stats.hStats[_loc3_]).allowHair))
                  {
                     Image(this.head_array[_loc5_].getChildByName("hair")).texture = Assets.items_textureAtlas.getTexture("hair " + param1.hair);
                  }
                  else
                  {
                     Image(this.head_array[_loc5_].getChildByName("hair")).texture = Assets.items_textureAtlas.getTexture("pet none helmet");
                  }
               }
               else
               {
                  Image(this.head_array[_loc5_].getChildByName("helmet")).texture = Assets.items_textureAtlas.getTexture("pet none helmet");
                  Image(this.head_array[_loc5_].getChildByName("hair")).texture = Assets.items_textureAtlas.getTexture("hair " + param1.hair);
               }
               Image(this.head_array[_loc5_].getChildByName("head")).readjustSize();
               Image(this.head_array[_loc5_].getChildByName("eyes")).readjustSize();
               Image(this.head_array[_loc5_].getChildByName("helmet")).readjustSize();
               Image(this.head_array[_loc5_].getChildByName("hair")).readjustSize();
               Image(this.head_array[_loc5_].getChildByName("beard")).readjustSize();
            }
            _loc5_++;
         }
      }
      
      public function showAddPanel() : void
      {
         this.addPanel_image = new Image(friendMenu_textureAtlas.getTexture("add friend panel"));
         this.addPanel_image.x = -9;
         this.addPanel_image.y = 210;
         this.addPanel_image.touchable = false;
         addChild(this.addPanel_image);
         this.addFriendString_btn = new Button(this.add_btn.upState,"",null,this.add_btn.overState);
         this.addFriendString_btn.x = 157;
         this.addFriendString_btn.y = 238;
         this.addFriendString_btn.pivotX = this.add_btn.pivotX;
         this.addFriendString_btn.pivotY = this.add_btn.pivotY;
         this.addFriendString_btn.scaleX = this.addFriendString_btn.scaleY = 0.7;
         this.addFriendString_btn.name = "addFriendString_btn";
         addChild(this.addFriendString_btn);
         this.enterName_txt = new TextInput();
         this.enterName_txt.x = -1;
         this.enterName_txt.y = 231;
         this.enterName_txt.width = 127;
         this.enterName_txt.height = 18;
         this.enterName_txt.textEditorProperties.fontFamily = "Arial";
         this.enterName_txt.textEditorProperties.textAlign = "center";
         this.enterName_txt.text = "";
         this.enterName_txt.name = this.enterName_txt.textEditorProperties.name = "enterName_txt";
         addChild(this.enterName_txt);
         this.enterName_txt.addEventListener(FeathersEventType.ENTER,this.onReturnPressed);
         this.add_btn.visible = this.chat_btn.visible = this.remove_btn.visible = false;
      }
      
      private function onReturnPressed(param1:Event) : void
      {
         var e:Event = param1;
         if(this.enterName_txt.text.length > 0 && this.enterName_txt.text.search(MainStarlingStage(root).gameMain.validString) == -1)
         {
            MainStarlingStage(root).gameMain.findDBNamePrefix(this.enterName_txt.text,function(param1:String):void
            {
               if(enterName_txt.text.length > 0 && enterName_txt.text.search(MainStarlingStage(root).gameMain.validString) == -1)
               {
                  MainStarlingStage(root).gameMain.addUserByString(param1 + enterName_txt.text,title_txt.text.toLowerCase());
               }
               else
               {
                  MainStarlingStage(root).gameMain.createAlert("invalid friend username");
               }
            });
         }
         else
         {
            MainStarlingStage(root).gameMain.createAlert("invalid friend username");
         }
      }
      
      public function removeAddPanel() : void
      {
         if(this.addPanel_image != null)
         {
            this.addPanel_image.removeFromParent(true);
            this.addFriendString_btn.removeFromParent(true);
            this.enterName_txt.removeFromParent(true);
         }
      }
      
      public function panelToName(param1:Image) : String
      {
         var _loc2_:int = int(this.panel_array.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.panel_array[_loc3_] == param1)
            {
               return this.nameText_array[_loc3_].text;
            }
            _loc3_++;
         }
         return "";
      }
      
      public function nameToFullName(param1:String) : String
      {
         var _loc2_:String = null;
         for each(_loc2_ in this.fullName_array)
         {
            if(Person.removeNamePrefix(_loc2_) == param1)
            {
               return _loc2_;
            }
         }
         return "";
      }
      
      public function scroll(param1:Number) : void
      {
         var _loc2_:Point = new Point(0,param1 / Starling.contentScaleFactor);
         _loc2_ = globalToLocal(_loc2_);
         this.scroll_btn.y = _loc2_.y;
         if(this.scroll_btn.y < -134)
         {
            this.scroll_btn.y = -134;
         }
         if(this.scroll_btn.y > 194)
         {
            this.scroll_btn.y = 194;
         }
         var _loc3_:Number = Number(this.list_sprite.y);
         if(MainStarlingStage(root).gameMain.maxFriends == 20 && this.title_txt.text != GUILD.toUpperCase())
         {
            this.list_sprite.y = Math.abs(CalcDist.getDistY(this.scroll_btn.y,194) * 0.8) + 40;
         }
         else if(MainStarlingStage(root).gameMain.maxFriends == 30 && this.title_txt.text != GUILD.toUpperCase())
         {
            this.list_sprite.y = Math.abs(CalcDist.getDistY(this.scroll_btn.y,194) * 1.85) - 300;
         }
         else
         {
            this.list_sprite.y = Math.abs(CalcDist.getDistY(this.scroll_btn.y,194) * 2.82) - 633;
         }
         this.mask_canvas.y -= this.list_sprite.y - _loc3_;
      }
      
      public function scrollWheel(param1:int) : void
      {
         this.scroll_btn.y -= param1 * 2;
         if(this.scroll_btn.y < -134)
         {
            this.scroll_btn.y = -134;
         }
         if(this.scroll_btn.y > 194)
         {
            this.scroll_btn.y = 194;
         }
         var _loc2_:Point = new Point(this.scroll_btn.x,this.scroll_btn.y);
         _loc2_ = localToGlobal(_loc2_);
         this.scroll(_loc2_.y);
      }
      
      public function touchScroll(param1:Number) : void
      {
         var _loc2_:Number = Number(this.list_sprite.y);
         this.list_sprite.y += param1;
         if(this.list_sprite.y > 300 && param1 > 0)
         {
            this.list_sprite.y = 300;
         }
         if(MainStarlingStage(root).gameMain.maxFriends == 20)
         {
            if(this.list_sprite.y < 40 && param1 < 0)
            {
               this.list_sprite.y = 40;
            }
         }
         else if(MainStarlingStage(root).gameMain.maxFriends == 40)
         {
            if(this.list_sprite.y < -642 && param1 < 0)
            {
               this.list_sprite.y = -642;
            }
         }
         else if(this.list_sprite.y < -303 && param1 < 0)
         {
            this.list_sprite.y = -303;
         }
         this.mask_canvas.y -= this.list_sprite.y - _loc2_;
      }
   }
}

