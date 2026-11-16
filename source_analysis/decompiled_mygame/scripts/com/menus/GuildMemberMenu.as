package com.menus
{
   import com.game_objects.*;
   import com.math.*;
   import com.ui.*;
   import com.utilities.*;
   import flash.display.*;
   import flash.geom.*;
   import playerio.DatabaseObject;
   import starling.*;
   import starling.display.*;
   import starling.events.*;
   import starling.text.*;
   import starling.textures.*;
   
   public final class GuildMemberMenu extends StarlingGameMenu implements IScrollableGameMenu
   {
      
      public static var guildMemberMenu_textureAtlas:TextureAtlas;
      
      private var __guild:String;
      
      public var whatToShow:String;
      
      private var deny_btn:Button;
      
      private var kick_btn:Button;
      
      private var allowJoin_btn:Button;
      
      private var title_txt:TextField = new TextField(220,33,"",AllTextFormats.title_textFormat);
      
      public var memberName_txt:TextField = new TextField(180,24,"",AllTextFormats.giveName_textFormat);
      
      private var info_txt:TextField = new TextField(169,116,"",AllTextFormats.info_textFormat);
      
      private var list_sprite:starling.display.Sprite = new Sprite();
      
      private var personClone:Person;
      
      private var panel_array:Vector.<Image> = new Vector.<Image>();
      
      private var nameText_array:Vector.<TextField> = new Vector.<TextField>();
      
      private var contText_array:Vector.<TextField> = new Vector.<TextField>();
      
      private var mask_canvas:Canvas = new Canvas();
      
      private var scroll_btn:Button = new Button(guildMemberMenu_textureAtlas.getTexture("scroll_btn"));
      
      public function GuildMemberMenu(param1:GameMain, param2:String, param3:String = "members")
      {
         var _loc4_:Image = null;
         var _loc5_:Button = null;
         _loc4_ = null;
         _loc5_ = null;
         var _loc6_:Image = null;
         var _loc7_:Image = null;
         var _loc8_:TextField = null;
         var _loc9_:TextField = null;
         super();
         this.__guild = param2;
         this.whatToShow = param3;
         _loc4_ = new Image(guildMemberMenu_textureAtlas.getTexture("panel"));
         _loc4_.x = -313;
         _loc4_.y = -208;
         addChild(_loc4_);
         _loc5_ = new Button(guildMemberMenu_textureAtlas.getTexture("x_btn_00"),"",null,guildMemberMenu_textureAtlas.getTexture("x_btn_01"));
         _loc5_.x = 197;
         _loc5_.y = -192;
         _loc5_.pivotX = 30;
         _loc5_.pivotY = 19;
         _loc5_.name = "x_btn";
         addChild(_loc5_);
         this.deny_btn = new Button(guildMemberMenu_textureAtlas.getTexture("deny_btn_00"));
         this.deny_btn.x = 146;
         this.deny_btn.y = 163;
         this.deny_btn.pivotX = 33;
         this.deny_btn.pivotY = 15;
         this.deny_btn.name = "deny_btn";
         addChild(this.deny_btn);
         this.kick_btn = new Button(guildMemberMenu_textureAtlas.getTexture("kick_btn_00"));
         this.kick_btn.x = 146;
         this.kick_btn.y = 200;
         this.kick_btn.pivotX = 33;
         this.kick_btn.pivotY = 15;
         this.kick_btn.name = "kick_btn";
         addChild(this.kick_btn);
         this.allowJoin_btn = new Button(guildMemberMenu_textureAtlas.getTexture("allowJoin_btn_00"));
         this.allowJoin_btn.x = 126;
         this.allowJoin_btn.y = 200;
         this.allowJoin_btn.pivotX = 83;
         this.allowJoin_btn.pivotY = 15;
         this.allowJoin_btn.scaleWhenOver = this.deny_btn.scaleWhenOver = this.kick_btn.scaleWhenOver = 0.95;
         this.allowJoin_btn.name = "allowJoin_btn";
         addChild(this.allowJoin_btn);
         this.deny_btn.visible = this.kick_btn.visible = this.allowJoin_btn.visible = false;
         this.scroll_btn.x = -9;
         this.scroll_btn.y = -132;
         this.scroll_btn.pivotX = 15;
         this.scroll_btn.pivotY = 19;
         this.scroll_btn.name = "scroll_btn";
         this.scroll_btn.visible = !GameMain.isMobile;
         addChild(this.scroll_btn);
         this.title_txt.text = param3 == "members" ? "GUILD MEMBERS" : "PENDING MEMBERS";
         this.title_txt.x = -149;
         this.title_txt.y = -206;
         addChild(this.title_txt);
         this.memberName_txt.x = 12;
         this.memberName_txt.y = -173;
         addChild(this.memberName_txt);
         this.info_txt.x = 16;
         this.info_txt.y = 14;
         addChild(this.info_txt);
         this.title_txt.touchable = this.memberName_txt.touchable = this.info_txt.touchable = false;
         this.title_txt.batchable = this.memberName_txt.batchable = this.info_txt.batchable = true;
         this.mask_canvas.drawRectangle(-202,-190,312,387);
         this.list_sprite.x = -134;
         this.list_sprite.y = 21;
         this.list_sprite.mask = this.mask_canvas;
         this.list_sprite.name = "itemScrollList";
         addChild(this.list_sprite);
         if(GameMain.isMobile)
         {
            _loc6_ = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("dark green pixel"));
            _loc6_.x = -140;
            _loc6_.y = -474;
            _loc6_.width = 250;
            _loc6_.height = 40 * 34;
            _loc6_.name = "itemScrollList";
            this.list_sprite.addChild(_loc6_);
         }
         var _loc10_:int = 0;
         while(_loc10_ < 40)
         {
            _loc7_ = new Image(guildMemberMenu_textureAtlas.getTexture("name panel_00"));
            _loc7_.x = -165;
            _loc7_.y = -485 + 33 * _loc10_;
            _loc7_.touchable = false;
            this.list_sprite.addChild(_loc7_);
            this.panel_array.push(_loc7_);
            _loc10_++;
         }
         _loc10_ = 0;
         while(_loc10_ < 40)
         {
            _loc8_ = new TextField(185,24,"----------",AllTextFormats.memberName_textFormat);
            _loc8_.x = -158;
            _loc8_.y = -482 + 33 * _loc10_;
            _loc8_.batchable = true;
            _loc8_.touchable = false;
            this.list_sprite.addChild(_loc8_);
            this.nameText_array.push(_loc8_);
            _loc10_++;
         }
         _loc10_ = 0;
         while(_loc10_ < 40)
         {
            _loc9_ = new TextField(112,27,"",AllTextFormats.contribute_textFormat);
            _loc9_.x = -12;
            _loc9_.y = -480 + 33 * _loc10_;
            _loc9_.batchable = true;
            _loc9_.touchable = false;
            this.list_sprite.addChild(_loc9_);
            this.contText_array.push(_loc9_);
            _loc10_++;
         }
         this.personClone = new Person(param1,false,"");
         this.personClone.x = 114;
         this.personClone.y = -70;
         this.personClone.scaleX = -1;
         this.personClone.touchable = false;
         this.personClone.visible = false;
         addChild(this.personClone);
         drag_image = new Image(Texture.fromBitmapData(new BitmapData(470,36,false,16711680)));
         drag_image.x = -306;
         drag_image.y = -207;
         drag_image.name = "drag_image";
         drag_image.alpha = 0;
         addChild(drag_image);
         this.list_sprite.y = 324;
         this.mask_canvas.y = -303;
         addEventListener(Event.ENTER_FRAME,this.onEnter);
      }
      
      private function onEnter(param1:Event) : void
      {
         this.personClone.bodyAnimator.onEnter();
         if(this.personClone.bodyAnimator.currentLabel != "standing")
         {
            this.personClone.bodyAnimator.gotoAndPlayInt(0);
         }
      }
      
      public function updateMe() : void
      {
         var _loc1_:int = int(this.panel_array.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this.panel_array[_loc2_].texture = guildMemberMenu_textureAtlas.getTexture("name panel_00");
            this.panel_array[_loc2_].touchable = this.panel_array[_loc2_].useHandCursor = false;
            this.nameText_array[_loc2_].text = "----------";
            this.contText_array[_loc2_].text = "";
            _loc2_++;
         }
         _loc1_ = this.whatToShow == "members" ? int(CommonCalls.returnObject(GuildMenu.guilds_array,this.__guild).mArray.length) : int(CommonCalls.returnObject(GuildMenu.guilds_array,this.__guild).pendingMembers_array.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.panel_array[_loc2_].touchable = true;
            this.panel_array[_loc2_].useHandCursor = true;
            this.nameText_array[_loc2_].text = this.whatToShow == "members" ? Person.removeNamePrefix(CommonCalls.returnObject(GuildMenu.guilds_array,this.__guild).mArray[_loc2_]) : Person.removeNamePrefix(CommonCalls.returnObject(GuildMenu.guilds_array,this.__guild).pendingMembers_array[_loc2_]);
            this.contText_array[_loc2_].text = this.whatToShow == "members" ? CommonCalls.returnObject(GuildMenu.guilds_array,this.__guild).cArray[_loc2_] : "";
            _loc2_++;
         }
      }
      
      public function setSelectedMemberBlank() : *
      {
         var _loc1_:int = int(this.panel_array.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            if(this.nameText_array[_loc2_].text == this.memberName_txt.text)
            {
               this.panel_array[_loc2_].texture = guildMemberMenu_textureAtlas.getTexture("name panel_00");
               this.panel_array[_loc2_].touchable = this.panel_array[_loc2_].useHandCursor = false;
               this.nameText_array[_loc2_].text = "----------";
               this.contText_array[_loc2_].text = "";
            }
            _loc2_++;
         }
         this.memberName_txt.text = "";
         this.personClone.visible = false;
         this.info_txt.text = "";
         this.deny_btn.visible = false;
         this.allowJoin_btn.visible = false;
      }
      
      public function selectMember(param1:starling.display.DisplayObject) : void
      {
         var _loc2_:int = int(this.panel_array.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this.panel_array[_loc3_].texture = guildMemberMenu_textureAtlas.getTexture("name panel_00");
            if(this.panel_array[_loc3_] == param1)
            {
               this.memberName_txt.text = this.nameText_array[_loc3_].text;
               if(this.whatToShow == "members")
               {
                  this.info_txt.text = "contribution: " + this.contText_array[_loc3_].text;
               }
            }
            _loc3_++;
         }
         Image(param1).texture = guildMemberMenu_textureAtlas.getTexture("name panel_01");
         var _loc4_:String = "";
         if(this.whatToShow == "members")
         {
            _loc2_ = int(CommonCalls.returnObject(GuildMenu.guilds_array,this.__guild).memberDisplayNames.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if(CommonCalls.returnObject(GuildMenu.guilds_array,this.__guild).memberDisplayNames[_loc3_] == this.memberName_txt.text)
               {
                  _loc4_ = CommonCalls.returnObject(GuildMenu.guilds_array,this.__guild).mArray[_loc3_];
                  break;
               }
               _loc3_++;
            }
         }
         else if(this.whatToShow == "pending members")
         {
            _loc2_ = int(CommonCalls.returnObject(GuildMenu.guilds_array,this.__guild).pendingMemberDisplayNames.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if(CommonCalls.returnObject(GuildMenu.guilds_array,this.__guild).pendingMemberDisplayNames[_loc3_] == this.memberName_txt.text)
               {
                  _loc4_ = CommonCalls.returnObject(GuildMenu.guilds_array,this.__guild).pendingMembers_array[_loc3_];
                  break;
               }
               _loc3_++;
            }
         }
         if(_loc4_.indexOf("facebook") != 0 && _loc4_.indexOf("kongregate") != 0 && _loc4_.indexOf("steam") != 0)
         {
            MainStarlingStage(root).gameMain.theClient.bigDB.load("PlayerObjects",_loc4_,this.guildMemberInfoLoaded);
         }
         else
         {
            MainStarlingStage(root).gameMain.theClient.bigDB.loadSingle("PlayerObjects","nameIndex",[_loc4_],this.guildMemberInfoLoaded);
         }
         if(this.whatToShow == "members" && Person.removeNamePrefix(CommonCalls.returnObject(GuildMenu.guilds_array,this.__guild).leader) == MainStarlingStage(root).gameMain.player.name && this.memberName_txt.text != MainStarlingStage(root).gameMain.player.name)
         {
            this.kick_btn.visible = true;
         }
         else if(this.whatToShow == "pending members" && (CommonCalls.returnObject(GuildMenu.guilds_array,this.__guild).leader == MainStarlingStage(root).gameMain.theClient.connectUserId || Person.removeNamePrefix(CommonCalls.returnObject(GuildMenu.guilds_array,this.__guild).leader) == MainStarlingStage(root).gameMain.player.name))
         {
            this.allowJoin_btn.visible = CommonCalls.returnObject(GuildMenu.guilds_array,this.__guild).mArray.length < 40;
            this.deny_btn.visible = true;
         }
         else
         {
            this.kick_btn.visible = false;
            this.allowJoin_btn.visible = false;
            this.deny_btn.visible = false;
         }
      }
      
      public function guildMemberInfoLoaded(param1:DatabaseObject) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Date = FriendMenu.parseDate(param1.login);
         this.personClone.visible = true;
         MainStarlingStage(root).gameMain.setPersonCopy(this.personClone,param1);
         if(param1.name == undefined)
         {
            param1.name = param1.key;
         }
         var _loc5_:String = "";
         if(this.title_txt.text != "PENDING MEMBERS")
         {
            _loc2_ = int(this.nameText_array.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if(this.nameText_array[_loc3_].text == Person.removeNamePrefix(param1.name))
               {
                  _loc5_ = "\nContribution: " + this.contText_array[_loc3_].text;
                  break;
               }
               _loc3_++;
            }
         }
         this.info_txt.text = "name: " + Person.removeNamePrefix(param1.name) + "\n" + "level: " + param1.lev + _loc5_ + "\nactive: " + _loc4_.toDateString();
      }
      
      public function scroll(param1:Number) : void
      {
         var _loc2_:Point = new Point(0,param1);
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
         this.list_sprite.y = Math.abs(CalcDist.getDistY(this.scroll_btn.y,194) * 2.9) - 627;
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
         if(this.list_sprite.y > 320 && param1 > 0)
         {
            this.list_sprite.y = 320;
         }
         if(this.list_sprite.y < -612 && param1 < 0)
         {
            this.list_sprite.y = -612;
         }
         this.mask_canvas.y -= this.list_sprite.y - _loc2_;
      }
      
      public function get guild() : String
      {
         return this.__guild;
      }
   }
}

