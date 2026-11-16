package com.menus
{
   import com.game_objects.*;
   import com.utilities.*;
   import flash.display.*;
   import flash.text.TextField;
   import playerio.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1707")]
   public final class GuildMenu extends GameMenu
   {
      
      public static var guilds_array:Vector.<DatabaseObject> = new Vector.<DatabaseObject>();
      
      public var contributeInfo_btn:SimpleButton;
      
      public var createGuild2_btn:SimpleButton;
      
      public var createGuild_btn:SimpleButton;
      
      public var desc_txt:TextField;
      
      public var editGuild_btn:SimpleButton;
      
      public var guildBack_btn:SimpleButton;
      
      public var guildDesc_txt:TextField;
      
      public var guildLevelReq_txt:TextField;
      
      public var guildName_txt:TextField;
      
      public var guildSearch_btn:SimpleButton;
      
      public var guildsAtoC_btn:SimpleButton;
      
      public var guildsDtoH_btn:SimpleButton;
      
      public var guildsJtoL_btn:SimpleButton;
      
      public var guildsMtoS_btn:SimpleButton;
      
      public var guildsNonAlpha_btn:SimpleButton;
      
      public var guildsStoZ_btn:SimpleButton;
      
      public var guildsTopKills_btn:SimpleButton;
      
      public var guildsTopLevels_btn:SimpleButton;
      
      public var hitArea_mc:MovieClip;
      
      public var join_btn:SimpleButton;
      
      public var leader_txt:TextField;
      
      public var leaveGuild_btn:SimpleButton;
      
      public var levelReqInfo_btn:SimpleButton;
      
      public var list_mc:MovieClip;
      
      public var membersAmount_txt:TextField;
      
      public var miscAlert_txt:TextField;
      
      public var myGuild_btn:SimpleButton;
      
      public var pendingMembers_btn:SimpleButton;
      
      public var reason_txt:TextField;
      
      public var saveGuild_btn:SimpleButton;
      
      public var scroll_btn:SimpleButton;
      
      public var search_txt:TextField;
      
      public var title_txt:TextField;
      
      public var totalContribute_txt:TextField;
      
      public var updateLevels_btn:SimpleButton;
      
      public var viewMembers_btn:SimpleButton;
      
      public var x_btn:SimpleButton;
      
      private var coin3xIcon:Coin3xIcon;
      
      private var guildListItem:GuildListItem;
      
      public function GuildMenu()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function updateMe(param1:String) : void
      {
         if(this.list_mc.getChildByName("item1_mc") != null)
         {
            this.list_mc.removeChild(this.list_mc.item1_mc);
         }
         this.guildName_txt.text = this.leader_txt.text = this.membersAmount_txt.text = this.totalContribute_txt.text = "";
         this.contributeInfo_btn.visible = this.viewMembers_btn.visible = this.leaveGuild_btn.visible = false;
         this.desc_txt.text = "";
         this.join_btn.visible = this.pendingMembers_btn.visible = this.updateLevels_btn.visible = false;
         this.editGuild_btn.visible = false;
         this.myGuild_btn.visible = param1 != "";
         this.createGuild_btn.visible = param1 == "";
      }
      
      public function selectGuild(param1:String, param2:Person, param3:String, param4:MovieClip = null) : void
      {
         var _loc5_:int = this.list_mc.numChildren;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            if(this.list_mc.getChildAt(_loc6_) is GuildListItem)
            {
               MovieClip(this.list_mc.getChildAt(_loc6_)).gotoAndStop(1);
            }
            _loc6_++;
         }
         if(param4 != null)
         {
            param4.gotoAndStop(2);
         }
         this.leader_txt.text = "Leader: " + Person.removeNamePrefix(CommonCalls.returnObject(GuildMenu.guilds_array,param1).leader);
         this.viewMembers_btn.visible = true;
         this.guildName_txt.text = param1;
         this.membersAmount_txt.text = "Members: " + String(CommonCalls.returnObject(GuildMenu.guilds_array,param1).mArray.length) + " / 40";
         this.desc_txt.text = CommonCalls.returnObject(GuildMenu.guilds_array,param1).desc;
         this.leaveGuild_btn.visible = param2.guild == param1;
         this.join_btn.visible = param2.guild != param1;
         this.miscAlert_txt.text = "";
         this.myGuild_btn.visible = param2.guild != param1 && param2.guild != "";
         if(param2.guild == param1 && CommonCalls.returnObject(GuildMenu.guilds_array,param1).leader == param3 || Person.removeNamePrefix(CommonCalls.returnObject(GuildMenu.guilds_array,param1).leader) == param2.name)
         {
            this.pendingMembers_btn.visible = this.editGuild_btn.visible = this.updateLevels_btn.visible = true;
         }
         else
         {
            this.pendingMembers_btn.visible = this.editGuild_btn.visible = this.updateLevels_btn.visible = false;
         }
         var _loc7_:Number = 0;
         _loc6_ = 0;
         while(_loc6_ < CommonCalls.returnObject(GuildMenu.guilds_array,param1).mArray.length)
         {
            _loc7_ += CommonCalls.returnObject(GuildMenu.guilds_array,param1).cArray[_loc6_];
            _loc6_++;
         }
         this.totalContribute_txt.text = "Total Contribution Points: " + String(_loc7_);
         this.contributeInfo_btn.visible = true;
         var _loc8_:int = int(CommonCalls.returnObject(GuildMenu.guilds_array,param1).pendingMemberDisplayNames.length);
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_)
         {
            if(CommonCalls.returnObject(GuildMenu.guilds_array,param1).pendingMemberDisplayNames[_loc9_] == param2.name)
            {
               this.miscAlert_txt.text = "awaiting approval to join";
               this.join_btn.visible = false;
               break;
            }
            _loc9_++;
         }
         if(param2.guild != "")
         {
            this.join_btn.visible = false;
         }
      }
      
      public function guildsLoaded(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1 != null)
         {
            param1.sortOn("key",Array.CASEINSENSITIVE);
            guilds_array.length = 0;
            guilds_array = Vector.<DatabaseObject>(param1);
            _loc2_ = int(guilds_array.length);
            _loc3_ = 0;
            while(_loc3_ < guilds_array.length)
            {
               guilds_array[_loc3_].name = guilds_array[_loc3_].key;
               guilds_array[_loc3_].levelReq = guilds_array[_loc3_].levelReq == undefined ? 0 : guilds_array[_loc3_].levelReq;
               guilds_array[_loc3_].pendingMembers_array = param1[_loc3_].pendingMembers.split(",");
               if(guilds_array[_loc3_].pendingMembers_array.length == 1 && guilds_array[_loc3_].pendingMembers_array[0] == "")
               {
                  guilds_array[_loc3_].pendingMembers_array.length = 0;
               }
               guilds_array[_loc3_].memberDisplayNames = new Array();
               _loc4_ = int(guilds_array[_loc3_].mArray.length);
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  guilds_array[_loc3_].memberDisplayNames[_loc5_] = Person.removeNamePrefix(guilds_array[_loc3_].mArray[_loc5_]);
                  _loc5_++;
               }
               guilds_array[_loc3_].pendingMemberDisplayNames = new Array();
               _loc4_ = int(guilds_array[_loc3_].pendingMembers_array.length);
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  guilds_array[_loc3_].pendingMemberDisplayNames[_loc5_] = Person.removeNamePrefix(guilds_array[_loc3_].pendingMembers_array[_loc5_]);
                  _loc5_++;
               }
               _loc3_++;
            }
            if(currentFrame == 1)
            {
               _loc2_ = int(param1.length);
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  this.guildListItem = new GuildListItem();
                  this.guildListItem.mouseChildren = false;
                  this.guildListItem.buttonMode = true;
                  this.guildListItem.x = 0;
                  this.guildListItem.y = -469 + (this.guildListItem.height + 4) * _loc3_;
                  this.guildListItem.name_txt.text = param1[_loc3_].key;
                  this.guildListItem.membersAmount_txt.text = String(guilds_array[_loc3_].mArray.length) + " / 40";
                  if(guilds_array[_loc3_].has3xMoney != undefined && guilds_array[_loc3_].has3xMoney == true)
                  {
                     this.coin3xIcon = new Coin3xIcon();
                     this.coin3xIcon.x = 246;
                     this.coin3xIcon.y = -3;
                     this.guildListItem.addChild(this.coin3xIcon);
                  }
                  this.list_mc.addChild(this.guildListItem);
                  _loc3_++;
               }
            }
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

