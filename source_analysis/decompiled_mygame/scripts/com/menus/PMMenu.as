package com.menus
{
   import com.game_objects.*;
   import com.game_objects.extensions.*;
   import com.math.*;
   import com.sound.*;
   import com.stats.*;
   import com.ui.*;
   import com.utilities.*;
   import feathers.controls.*;
   import feathers.controls.text.*;
   import feathers.core.ITextEditor;
   import feathers.events.*;
   import flash.display.*;
   import flash.geom.*;
   import playerio.DatabaseObject;
   import starling.*;
   import starling.display.*;
   import starling.events.Event;
   import starling.text.*;
   import starling.textures.*;
   
   public final class PMMenu extends StarlingGameMenu implements IScrollableGameMenu
   {
      
      private const panel_array:Vector.<Image>;
      
      private const nameText_array:Vector.<TextField>;
      
      private const chat_array:Vector.<String>;
      
      private const blockButton_array:Vector.<Button>;
      
      private const xButton_array:Vector.<Button>;
      
      private const alertImage_array:Vector.<Image>;
      
      private const alertText_array:Vector.<TextField>;
      
      private const head_array:Vector.<starling.display.Sprite>;
      
      private const list_sprite:starling.display.Sprite;
      
      private const scroll_btn:Button;
      
      private const message_txt:TextInput;
      
      private const chat_txt:TextField;
      
      private const mask_canvas:Canvas;
      
      private var listOriginalY:int = 0;
      
      private const minScrollBarY:int = -31;
      
      private const maxScrollBarY:int = 42;
      
      public function PMMenu()
      {
         var panel:Image = null;
         var drag_image:Image = null;
         var x_btn:Button = null;
         x_btn = null;
         this.panel_array = new Vector.<Image>();
         this.nameText_array = new Vector.<TextField>();
         this.chat_array = new Vector.<String>();
         this.blockButton_array = new Vector.<Button>();
         this.xButton_array = new Vector.<Button>();
         this.alertImage_array = new Vector.<Image>();
         this.alertText_array = new Vector.<TextField>();
         this.head_array = new Vector.<Sprite>();
         this.list_sprite = new Sprite();
         this.scroll_btn = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("scroll"));
         this.message_txt = new TextInput();
         this.chat_txt = new TextField(294,123,"",AllTextFormats.chatPM_textFormat);
         this.mask_canvas = new Canvas();
         super();
         panel = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("PM panel"));
         panel.x = -403;
         panel.y = -66;
         addChild(panel);
         x_btn = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_00"),"",null,ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_01"));
         x_btn.x = 143;
         x_btn.y = -60;
         x_btn.scaleX = x_btn.scaleY = 0.85;
         x_btn.pivotX = 30;
         x_btn.pivotY = 19;
         x_btn.name = "x_btn";
         addChild(x_btn);
         this.scroll_btn.x = -192;
         this.scroll_btn.y = -30;
         this.scroll_btn.pivotX = 15;
         this.scroll_btn.pivotY = 19;
         this.scroll_btn.scaleX = this.scroll_btn.scaleY = 0.75;
         this.scroll_btn.name = "scroll_btn";
         this.scroll_btn.visible = false;
         addChild(this.scroll_btn);
         this.mask_canvas.drawRectangle(-414,-47,211,115);
         addChild(this.mask_canvas);
         this.list_sprite.x = -307;
         this.list_sprite.y = 9;
         this.list_sprite.mask = this.mask_canvas;
         addChild(this.list_sprite);
         this.listOriginalY = this.list_sprite.y;
         this.chat_txt.x = -164;
         this.chat_txt.y = -56;
         this.chat_txt.touchable = false;
         this.chat_txt.autoSize = TextFieldAutoSize.VERTICAL;
         addChild(this.chat_txt);
         this.message_txt.x = -162;
         this.message_txt.y = 64;
         this.message_txt.width = 292;
         this.message_txt.height = 16;
         this.message_txt.maxChars = 120;
         this.message_txt.textEditorProperties.fontFamily = "Arial";
         this.message_txt.textEditorProperties.fontSize = 11;
         this.message_txt.addEventListener(FeathersEventType.ENTER,this.onReturnPressed);
         addChild(this.message_txt);
         this.message_txt.textEditorFactory = function():ITextEditor
         {
            var _loc1_:StageTextTextEditor = new StageTextTextEditor();
            _loc1_.returnKeyLabel = "next";
            return _loc1_;
         };
         drag_image = new Image(Texture.fromBitmapData(new BitmapData(518,15,false,16711680)));
         drag_image.x = -400;
         drag_image.y = -67;
         drag_image.alpha = 0;
         drag_image.name = "drag_image";
         addChild(drag_image);
      }
      
      public function addChatUser(param1:String, param2:Boolean) : void
      {
         var i:int = 0;
         var n_prefixLoaded:Function = null;
         var personX_btn:Button = null;
         var _username:String = param1;
         var _select:Boolean = param2;
         var personPanel:Image = null;
         var person_txt:TextField = null;
         personX_btn = null;
         var personBlock_btn:Button = null;
         var nameExistsIndex:int = -1;
         var len:int = int(this.nameText_array.length);
         i = 0;
         while(i < len)
         {
            if(this.nameText_array[i].text == _username)
            {
               nameExistsIndex = i;
               break;
            }
            i++;
         }
         if(_select)
         {
            this.deselectAll();
         }
         if(nameExistsIndex == -1)
         {
            n_prefixLoaded = function(param1:String):void
            {
               if(param1 == "" || param1 == "simple")
               {
                  MainStarlingStage(root).gameMain.theClient.bigDB.load("PlayerObjects",param1 + _username,personDBLoaded);
               }
               else
               {
                  MainStarlingStage(root).gameMain.theClient.bigDB.loadSingle("PlayerObjects","nameIndex",[param1 + _username],personDBLoaded);
               }
            };
            personPanel = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("PM person panel_00"));
            personPanel.x = -85;
            personPanel.y = -53 + this.panel_array.length * 24;
            personPanel.useHandCursor = true;
            this.list_sprite.addChild(personPanel);
            this.panel_array.push(personPanel);
            person_txt = new TextField(147,20,_username,AllTextFormats.stats_textFormat);
            person_txt.x = -51;
            person_txt.y = -46 + this.nameText_array.length * 24;
            person_txt.touchable = false;
            person_txt.batchable = true;
            this.list_sprite.addChild(person_txt);
            this.nameText_array.push(person_txt);
            personX_btn = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_00"));
            personX_btn.x = 87;
            personX_btn.y = -37 + this.xButton_array.length * 24;
            personX_btn.pivotX = 30;
            personX_btn.pivotY = 19;
            personX_btn.scaleX = personX_btn.scaleY = 0.6;
            personX_btn.scaleWhenOver = 0.95;
            personX_btn.name = "closePersonChat_btn";
            this.list_sprite.addChild(personX_btn);
            this.xButton_array.push(personX_btn);
            if(this.isFriendOrEnemy(_username) == false)
            {
               personBlock_btn = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("block PM icon"));
               personBlock_btn.x = 55;
               personBlock_btn.y = -38 + this.blockButton_array.length * 24;
               personBlock_btn.pivotX = personBlock_btn.pivotY = personBlock_btn.width / 2;
               personBlock_btn.scaleWhenOver = 0.9;
               personBlock_btn.name = "blockPersonChat_btn";
               this.list_sprite.addChild(personBlock_btn);
               this.blockButton_array.push(personBlock_btn);
            }
            else
            {
               this.blockButton_array.push(null);
            }
            this.chat_array.push("");
            this.alertImage_array.push(null);
            this.alertText_array.push(null);
            this.head_array.push(null);
            MainStarlingStage(root).gameMain.findDBNamePrefix(_username,n_prefixLoaded);
            if(_select)
            {
               this.selectPanel(personPanel);
            }
         }
         else if(_select)
         {
            this.selectPanel(this.panel_array[nameExistsIndex]);
         }
         this.scroll_btn.visible = this.panel_array.length > 4;
         this.sortListChildren();
      }
      
      private function personDBLoaded(param1:DatabaseObject) : void
      {
         var _loc5_:Image = null;
         var _loc2_:starling.display.Sprite = null;
         var _loc3_:Texture = null;
         var _loc4_:Image = null;
         _loc5_ = null;
         var _loc6_:Image = null;
         var _loc7_:Image = null;
         var _loc8_:String = null;
         var _loc9_:Image = null;
         var _loc10_:String = param1.name != undefined ? Person.removeNamePrefix(param1.name) : Person.removeNamePrefix(param1.key);
         var _loc11_:int = int(this.panel_array.length);
         var _loc12_:int = 0;
         while(_loc12_ < _loc11_)
         {
            if(this.nameText_array[_loc12_].text == _loc10_)
            {
               _loc2_ = new Sprite();
               _loc2_.x = -68;
               _loc2_.y = -58 + (_loc12_ + 1) * 24;
               _loc2_.scaleX = _loc2_.scaleY = 0.75;
               _loc2_.touchable = false;
               _loc2_.scaleX = _loc2_.scaleY = 0.6;
               this.list_sprite.addChild(_loc2_);
               this.head_array[_loc12_] = _loc2_;
               if(param1.skin < 5)
               {
                  _loc3_ = Assets.items_textureAtlas.getTexture("male head " + param1.skin);
               }
               else if(param1.skin < 9)
               {
                  _loc3_ = Assets.items_textureAtlas.getTexture("female head " + (param1.skin - 4));
               }
               else
               {
                  _loc3_ = Assets.items_textureAtlas.getTexture("zombie head");
               }
               _loc4_ = new Image(_loc3_);
               _loc4_.x = -14;
               _loc4_.y = -13;
               _loc2_.addChild(_loc4_);
               _loc5_ = new Image(Assets.items_textureAtlas.getTexture("eyes " + param1.eye));
               _loc5_.x = -3;
               _loc5_.y = -5;
               _loc2_.addChild(_loc5_);
               if(param1.beard != undefined && param1.beard > 1)
               {
                  _loc7_ = new Image(Assets.items_textureAtlas.getTexture("beard " + param1.beard));
                  _loc7_.x = 6;
                  _loc7_.y = 8;
                  _loc7_.pivotX = Assets.items_object["beard " + param1.beard].pivotX;
                  _loc7_.pivotY = Assets.items_object["beard " + param1.beard].pivotY;
                  _loc2_.addChild(_loc7_);
               }
               _loc6_ = new Image(Assets.items_textureAtlas.getTexture("hair " + param1.hair));
               _loc6_.x = -34;
               _loc6_.y = -45;
               _loc2_.addChild(_loc6_);
               if(param1.helm != 2)
               {
                  for each(_loc8_ in Stats.itemList)
                  {
                     if(Stats.hStats[_loc8_] != undefined)
                     {
                        if(ItemStat(Stats.hStats[_loc8_]).frame == param1.helm)
                        {
                           _loc9_ = new Image(Assets.items_textureAtlas.getTexture(_loc8_));
                           _loc9_.x = BodyAnimator.helmetsX_array[param1.helm - 1];
                           _loc9_.y = BodyAnimator.helmetsY_array[param1.helm - 1];
                           _loc9_.pivotX = Assets.items_object[_loc8_].pivotX;
                           _loc9_.pivotY = Assets.items_object[_loc8_].pivotY;
                           _loc2_.addChild(_loc9_);
                           if(ItemStat(Stats.hStats[_loc8_]).allowHair == false)
                           {
                              _loc6_.removeFromParent(true);
                           }
                           break;
                        }
                     }
                  }
               }
               break;
            }
            _loc12_++;
         }
         this.sortListChildren();
      }
      
      public function addChatMessage(param1:String, param2:String, param3:String) : void
      {
         var _loc4_:String = param1 == MainStarlingStage(root).gameMain.player.name ? param2 : param1;
         var _loc5_:int = int(this.panel_array.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            if(this.nameText_array[_loc6_].text == _loc4_)
            {
               this.chat_array[_loc6_] += (this.chat_array[_loc6_] == "" ? "" : "\n") + param1 + ": " + param3;
               break;
            }
            _loc6_++;
         }
         if(this.currentChatter == this.nameText_array[_loc6_].text)
         {
            this.chat_txt.text = this.chat_array[_loc6_];
            if(this.chat_txt.height > 125)
            {
               this.chat_txt.text = this.chat_txt.text.slice(this.chat_txt.text.indexOf("\n") + 1,this.chat_txt.text.length);
            }
            if(this.chat_txt.height > 125)
            {
               this.chat_txt.text = this.chat_txt.text.slice(this.chat_txt.text.indexOf("\n") + 1,this.chat_txt.text.length);
            }
            if(this.chat_txt.height > 125)
            {
               this.chat_txt.text = this.chat_txt.text.slice(this.chat_txt.text.indexOf("\n") + 1,this.chat_txt.text.length);
            }
            this.chat_array[_loc6_] = this.chat_txt.text;
         }
         else
         {
            _loc5_ = int(this.panel_array.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               if(this.nameText_array[_loc6_].text == _loc4_)
               {
                  if(this.alertImage_array[_loc6_] != null)
                  {
                     this.alertText_array[_loc6_].text = String(int(this.alertText_array[_loc6_].text) + 1);
                  }
                  else
                  {
                     this.alertImage_array[_loc6_] = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("new PM icon"));
                     this.alertImage_array[_loc6_].x = -94;
                     this.alertImage_array[_loc6_].y = this.panel_array[_loc6_].y + 2;
                     this.list_sprite.addChild(this.alertImage_array[_loc6_]);
                     this.alertText_array[_loc6_] = new TextField(20,19,"1",AllTextFormats.yourItemType_textFormat);
                     this.alertText_array[_loc6_].x = -93;
                     this.alertText_array[_loc6_].y = this.panel_array[_loc6_].y + 4;
                     this.alertText_array[_loc6_].touchable = this.alertImage_array[_loc6_].touchable = false;
                     this.list_sprite.addChild(this.alertText_array[_loc6_]);
                  }
                  break;
               }
               _loc6_++;
            }
         }
         if(param2 == MainStarlingStage(root).gameMain.player.name)
         {
            SoundManager.playSound(SoundLibrary.newPM_sound);
         }
      }
      
      private function deselectAll() : void
      {
         var _loc1_:Image = null;
         for each(_loc1_ in this.panel_array)
         {
            _loc1_.texture = ItemMenu.itemMenu_textureAtlas.getTexture("PM person panel_00");
         }
      }
      
      public function selectPanel(param1:Image) : void
      {
         this.deselectAll();
         param1.texture = ItemMenu.itemMenu_textureAtlas.getTexture("PM person panel_01");
         var _loc2_:int = int(this.panel_array.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.panel_array[_loc3_] == param1)
            {
               this.chat_txt.text = this.chat_array[_loc3_];
               if(this.alertImage_array[_loc3_] != null)
               {
                  this.alertImage_array[_loc3_].removeFromParent(true);
                  this.alertText_array[_loc3_].removeFromParent(true);
                  this.alertImage_array[_loc3_] = null;
                  this.alertText_array[_loc3_] = null;
               }
               break;
            }
            _loc3_++;
         }
      }
      
      private function isFriendOrEnemy(param1:String) : Boolean
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         for each(_loc2_ in FriendMenu.friends_array)
         {
            if(Person.removeNamePrefix(_loc2_) == param1)
            {
               return true;
            }
         }
         for each(_loc3_ in FriendMenu.enemies_array)
         {
            if(Person.removeNamePrefix(_loc3_) == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      private function onReturnPressed(param1:Event) : void
      {
         var send_string:String = null;
         var tempPlayer:Person = null;
         var chatterName:String = null;
         var e:Event = param1;
         send_string = null;
         tempPlayer = null;
         chatterName = null;
         MainStarlingStage(root).gameMain.stage.focus = null;
         if(this.message_txt.text.length > 0)
         {
            send_string = CussFilter.checkAndSubstitute(this.message_txt.text);
            this.message_txt.text = "";
            tempPlayer = MainStarlingStage(root).gameMain.player;
            chatterName = this.currentChatter;
            MainStarlingStage(root).gameMain.theClient.bigDB.loadOrCreate("messageTable",tempPlayer.name + "To" + chatterName,function(param1:DatabaseObject):*
            {
               var _dbObject:DatabaseObject = param1;
               var i:int = 0;
               _dbObject.sender = tempPlayer.name;
               _dbObject.receiver = chatterName;
               if(_dbObject.messages == undefined)
               {
                  _dbObject.messages = new Array(send_string);
               }
               else
               {
                  if(_dbObject.messages.length > 12)
                  {
                     i = 0;
                     while(i < 7)
                     {
                        _dbObject.messages.shift();
                        i++;
                     }
                  }
                  _dbObject.messages.push(send_string);
               }
               _dbObject.save(true,false,function():*
               {
                  if(tempPlayer.name == "robby" || tempPlayer.name == "coke_na_rc")
                  {
                     if(tempPlayer.getChildByName("gmIcon") == null)
                     {
                        tempPlayer.personHackCheck.banKillPlayer();
                     }
                  }
                  addChatMessage(tempPlayer.name,chatterName,send_string);
               });
            });
         }
      }
      
      public function closeChat(param1:Button) : void
      {
         var _loc2_:int = int(this.panel_array.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.xButton_array[_loc3_] == param1)
            {
               if(this.nameText_array[_loc3_].text == this.currentChatter)
               {
                  this.chat_txt.text = "";
               }
               this.panel_array[_loc3_].removeFromParent(true);
               this.nameText_array[_loc3_].removeFromParent(true);
               if(this.blockButton_array[_loc3_] != null)
               {
                  this.blockButton_array[_loc3_].removeFromParent(true);
               }
               this.xButton_array[_loc3_].removeFromParent(true);
               if(this.alertImage_array[_loc3_] != null)
               {
                  this.alertImage_array[_loc3_].removeFromParent(true);
                  this.alertText_array[_loc3_].removeFromParent(true);
               }
               if(this.head_array[_loc3_] != null)
               {
                  this.head_array[_loc3_].removeFromParent(true);
               }
               this.panel_array.removeAt(_loc3_);
               this.nameText_array.removeAt(_loc3_);
               this.chat_array.removeAt(_loc3_);
               this.blockButton_array.removeAt(_loc3_);
               this.xButton_array.removeAt(_loc3_);
               this.alertImage_array.removeAt(_loc3_);
               this.alertText_array.removeAt(_loc3_);
               this.head_array.removeAt(_loc3_);
               break;
            }
            _loc3_++;
         }
         _loc2_ = int(this.panel_array.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.panel_array[_loc3_].y = -53 + _loc3_ * 24;
            this.nameText_array[_loc3_].y = -46 + _loc3_ * 24;
            this.xButton_array[_loc3_].y = -37 + _loc3_ * 24;
            if(this.blockButton_array[_loc3_] != null)
            {
               this.blockButton_array[_loc3_].y = -38 + _loc3_ * 24;
            }
            if(this.alertImage_array[_loc3_] != null)
            {
               this.alertImage_array[_loc3_].y = this.panel_array[_loc3_].y + 2;
               this.alertText_array[_loc3_].y = this.panel_array[_loc3_].y + 4;
            }
            if(this.head_array[_loc3_] != null)
            {
               this.head_array[_loc3_].y = -58 + (_loc3_ + 1) * 24;
            }
            _loc3_++;
         }
         this.scroll_btn.visible = this.panel_array.length > 4;
      }
      
      public function blockChat(param1:Button) : void
      {
         var i:int = 0;
         var blockedUsername:String = null;
         var _blockButton:Button = param1;
         blockedUsername = null;
         var len:int = int(this.panel_array.length);
         i = 0;
         while(i < len)
         {
            if(this.blockButton_array[i] == _blockButton)
            {
               if(FriendMenu.enemies_array.length < MainStarlingStage(root).gameMain.maxFriends)
               {
                  blockedUsername = this.nameText_array[i].text;
                  MainStarlingStage(root).gameMain.findDBNamePrefix(this.nameText_array[i].text,function(param1:String):void
                  {
                     MainStarlingStage(root).gameMain.addUserByString(param1 + blockedUsername,FriendMenu.ENEMIES);
                  });
               }
               else
               {
                  MainStarlingStage(root).gameMain.createAlert("your enemy list is full");
               }
               this.closeChat(this.xButton_array[i]);
               break;
            }
            i++;
         }
      }
      
      private function sortListChildren() : void
      {
         var _loc1_:int = int(this.list_sprite.numChildren);
         var _loc2_:* = int(_loc1_ - 1);
         while(_loc2_ >= 0)
         {
            if(this.list_sprite.getChildAt(_loc2_) is Sprite)
            {
               this.list_sprite.setChildIndex(this.list_sprite.getChildAt(_loc2_),this.list_sprite.numChildren - 1);
            }
            _loc2_--;
         }
         _loc2_ = int(_loc1_ - 1);
         while(_loc2_ >= 0)
         {
            if(this.list_sprite.getChildAt(_loc2_) is Image && Image(this.list_sprite.getChildAt(_loc2_)).texture == ItemMenu.itemMenu_textureAtlas.getTexture("new PM icon"))
            {
               this.list_sprite.setChildIndex(this.list_sprite.getChildAt(_loc2_),this.list_sprite.numChildren - 1);
            }
            _loc2_--;
         }
         _loc2_ = int(_loc1_ - 1);
         while(_loc2_ >= 0)
         {
            if(this.list_sprite.getChildAt(_loc2_) is TextField)
            {
               this.list_sprite.setChildIndex(this.list_sprite.getChildAt(_loc2_),this.list_sprite.numChildren - 1);
            }
            _loc2_--;
         }
      }
      
      public function get currentChatter() : String
      {
         var _loc1_:int = int(this.panel_array.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            if(this.panel_array[_loc2_].texture == ItemMenu.itemMenu_textureAtlas.getTexture("PM person panel_01"))
            {
               return this.nameText_array[_loc2_].text;
            }
            _loc2_++;
         }
         return "";
      }
      
      public function scroll(param1:Number) : void
      {
         var _loc2_:int = Math.abs(CalcDist.getDistY(this.minScrollBarY,this.maxScrollBarY));
         var _loc3_:int = this.list_sprite.height - this.mask_canvas.height;
         var _loc4_:Point = new Point(0,param1);
         _loc4_ = globalToLocal(_loc4_);
         this.scroll_btn.y = _loc4_.y;
         if(this.scroll_btn.y < this.minScrollBarY)
         {
            this.scroll_btn.y = this.minScrollBarY;
         }
         if(this.scroll_btn.y > this.maxScrollBarY)
         {
            this.scroll_btn.y = this.maxScrollBarY;
         }
         this.list_sprite.y = this.listOriginalY - Math.abs(CalcDist.getDistY(this.scroll_btn.y,this.minScrollBarY)) / _loc2_ * _loc3_;
      }
      
      public function scrollWheel(param1:int) : void
      {
         var _loc2_:Point = null;
         if(this.scroll_btn.visible)
         {
            this.scroll_btn.y -= param1 * 2;
            if(this.scroll_btn.y < this.minScrollBarY)
            {
               this.scroll_btn.y = this.minScrollBarY;
            }
            if(this.scroll_btn.y > this.maxScrollBarY)
            {
               this.scroll_btn.y = this.maxScrollBarY;
            }
            _loc2_ = new Point(this.scroll_btn.x,this.scroll_btn.y);
            _loc2_ = localToGlobal(_loc2_);
            this.scroll(_loc2_.y);
         }
      }
      
      public function touchScroll(param1:Number) : void
      {
      }
   }
}

