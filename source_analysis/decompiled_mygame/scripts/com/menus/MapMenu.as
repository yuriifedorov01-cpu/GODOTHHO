package com.menus
{
   import com.game_objects.*;
   import com.menus.add_ons.*;
   import com.stats.*;
   import com.ui.*;
   import flash.display.*;
   import flash.utils.*;
   import playerio.DatabaseObject;
   import starling.*;
   import starling.display.*;
   import starling.text.*;
   import starling.textures.*;
   
   public final class MapMenu extends StarlingGameMenu
   {
      
      public static var mapMenu_textureAtlas:TextureAtlas;
      
      private var friendList_txt:TextField = new TextField(168,312,"YOU",AllTextFormats.friendList_textFormat);
      
      public var fishMap_btn:Button;
      
      private var unlockedMaps:Vector.<uint>;
      
      private var currentArea:uint = 1;
      
      private var friendStages:Vector.<uint> = new Vector.<uint>();
      
      private var markerPos:Object = {};
      
      private var ringsImg:Image = null;
      
      private var refreshTimer:uint = 0;
      
      private var refreshLeft:int = 0;
      
      private var refreshData:Object = null;
      
      private var refreshBusy:Boolean = false;
      
      private var refreshToken:int = 0;
      
      private var refreshNames:Array = [];
      
      private var arrowImg:Image = null;
      
      public function MapMenu(param1:Boolean, param2:uint, param3:int, param4:String, param5:int, param6:Vector.<DatabaseObject>, param7:Vector.<uint>)
      {
         var _loc8_:Image = null;
         var _loc9_:Button = null;
         var _loc10_:TextField = null;
         var _loc14_:Button = null;
         var _loc16_:Image = null;
         _loc8_ = null;
         _loc9_ = null;
         _loc10_ = null;
         var _loc11_:DatabaseObject = null;
         var _loc12_:Button = null;
         var _loc13_:BitmapData = null;
         super();
         this.unlockedMaps = param7;
         this.currentArea = param2;
         _loc8_ = new Image(mapMenu_textureAtlas.getTexture("panel"));
         _loc8_.x = -329;
         _loc8_.y = -173;
         addChild(_loc8_);
         _loc14_ = new Button(mapMenu_textureAtlas.getTexture("rechooseServer_btn_00"));
         _loc14_.x = -192;
         _loc14_.y = 298;
         _loc14_.pivotX = 124;
         _loc14_.pivotY = 17;
         _loc14_.scaleWhenOver = 0.95;
         _loc14_.name = "rechooseServer_btn";
         addChild(_loc14_);
         _loc9_ = new Button(mapMenu_textureAtlas.getTexture("x_btn_00"),"",mapMenu_textureAtlas.getTexture("x_btn_01"));
         _loc9_.x = 513;
         _loc9_.y = -157;
         _loc9_.pivotX = 30;
         _loc9_.pivotY = 19;
         _loc9_.name = "x_btn";
         addChild(_loc9_);
         if(param1)
         {
            this.fishMap_btn = new Button(mapMenu_textureAtlas.getTexture("fishMap_btn_00"));
            this.fishMap_btn.x = -267;
            this.fishMap_btn.y = 268;
            this.fishMap_btn.name = "fishMap_btn";
            addChild(this.fishMap_btn);
            _loc12_ = new Button(mapMenu_textureAtlas.getTexture("fishList_btn_00"));
            _loc12_.x = -174;
            _loc12_.y = 268;
            _loc12_.scaleWhenOver = this.fishMap_btn.scaleWhenOver = 0.95;
            _loc12_.name = "fishList_btn";
            addChild(_loc12_);
            this.fishMap_btn.pivotX = _loc12_.pivotX = 49;
            this.fishMap_btn.pivotY = _loc12_.pivotY = 13;
         }
         this.createMapMarkers();
         var _loc15_:TextField = new TextField(241,23,"Total online players: " + param3,AllTextFormats.playerTotals_textFormat);
         _loc15_.x = -271;
         addChild(_loc15_);
         _loc10_ = new TextField(280,23,param4 + " Players: " + param5.toString(),AllTextFormats.playerTotals_textFormat);
         _loc10_.x = 25;
         _loc10_.y = _loc15_.y = -136;
         addChild(_loc10_);
         this.friendList_txt.x = -312;
         this.friendList_txt.y = -96;
         addChild(this.friendList_txt);
         _loc15_.touchable = _loc10_.touchable = this.friendList_txt.touchable = false;
         _loc15_.batchable = _loc10_.batchable = this.friendList_txt.batchable = true;
         for each(_loc11_ in param6)
         {
            if(_loc11_.on)
            {
               if(_loc11_.name == undefined)
               {
                  _loc11_.name = _loc11_.key;
               }
               this.friendList_txt.text += "\n" + Person.removeNamePrefix(_loc11_.name);
               if(_loc11_.stage != undefined && _loc11_.stage > 0)
               {
                  if(this.friendStages.indexOf(uint(_loc11_.stage)) < 0)
                  {
                     this.friendStages.push(uint(_loc11_.stage));
                  }
               }
            }
         }
         try
         {
            this.buildMapOverlay();
         }
         catch(mapOverlayErr:Error)
         {
         }
         try
         {
            this.rebuildRings();
         }
         catch(ringsErr:Error)
         {
         }
         try
         {
            this.scheduleFriendRefresh();
         }
         catch(refreshErr:Error)
         {
         }
         _loc16_ = new Image(Texture.fromBitmapData(new BitmapData(624,36,false,16711680)));
         _loc16_.x = -324;
         _loc16_.y = -174;
         _loc16_.alpha = 0;
         _loc16_.name = "drag_image";
         addChild(_loc16_);
      }
      
      private function createMapMarkers() : void
      {
         var self:MapMenu = null;
         self = this;
         var n_createMarker:Function = function(param1:int, param2:int, param3:int, param4:Number = 1):void
         {
            var _loc6_:MapMarker = null;
            self.markerPos[param3] = {
               "x":param1,
               "y":param2,
               "s":param4
            };
            var _loc5_:uint = 0;
            _loc6_ = null;
            for each(_loc5_ in unlockedMaps)
            {
               if(_loc5_ == param3)
               {
                  _loc6_ = new MapMarker(mapMenu_textureAtlas.getTexture("map marker"));
                  _loc6_.x = param1;
                  _loc6_.y = param2;
                  _loc6_.scaleX = _loc6_.scaleY = param4;
                  _loc6_.pivotX = _loc6_.pivotY = 11;
                  _loc6_.name = "level_" + param3;
                  _loc6_.useHandCursor = _loc6_.touchable = true;
                  addChild(_loc6_);
                  break;
               }
            }
         };
         n_createMarker(-120,176,1,1);
         n_createMarker(-94,169,2,1);
         n_createMarker(-66,175,4,1);
         n_createMarker(-88,143,3,1);
         n_createMarker(-40,180,5,1);
         n_createMarker(-15,184,8,1);
         n_createMarker(-84,114,6,1);
         n_createMarker(-33,207,7,1);
         n_createMarker(26,188,44,1);
         n_createMarker(50,176,45,1);
         n_createMarker(77,183,46,1);
         n_createMarker(105,174,47,1);
         n_createMarker(120,196,48,1);
         n_createMarker(74,208,49,1);
         n_createMarker(57,228,50,1);
         n_createMarker(143,239,67,1);
         n_createMarker(121,253,68,1);
         n_createMarker(96,260,69,1);
         n_createMarker(173,241,70,1);
         n_createMarker(197,255,71,1);
         n_createMarker(224,266,72,1);
         n_createMarker(190,276,74,0.649993896484375);
         n_createMarker(137,277,73,1);
         n_createMarker(58,283,75,1);
         n_createMarker(30,273,76,1);
         n_createMarker(16,302,80,1);
         n_createMarker(6,252,77,1);
         n_createMarker(-21,257,78,1);
         n_createMarker(6,282,79,0.649993896484375);
         n_createMarker(97,130,111,1);
         n_createMarker(112,107,114,0.79998779296875);
         n_createMarker(78,107,113,0.79998779296875);
         n_createMarker(63,124,112,0.79998779296875);
         n_createMarker(141,154,52,1);
         n_createMarker(153,135,53,1);
         n_createMarker(178,130,54,1);
         n_createMarker(197,160,64,1);
         n_createMarker(218,143,127,1);
         n_createMarker(245,160,57,1);
         n_createMarker(243,124,126,1);
         n_createMarker(153,110,56,1);
         n_createMarker(178,107,119,0.649993896484375);
         n_createMarker(184,97,120,0.649993896484375);
         n_createMarker(197,95,121,0.649993896484375);
         n_createMarker(210,103,122,0.649993896484375);
         n_createMarker(218,114,123,0.649993896484375);
         n_createMarker(-75,73,9,1);
         n_createMarker(-70,47,10,1);
         n_createMarker(-99,47,14,1);
         n_createMarker(-73,19,11,1);
         n_createMarker(-60,-7,12,1);
         n_createMarker(-40,-26,13,1);
         n_createMarker(-86,-2,15,0.649993896484375);
         n_createMarker(-87,-20,16,0.649993896484375);
         n_createMarker(-73,-33,17,0.649993896484375);
         n_createMarker(-5,-40,18,1);
         n_createMarker(11,-17,19,1);
         n_createMarker(5,9,20,1);
         n_createMarker(-8,50,21,1);
         n_createMarker(-1,76,22,1);
         n_createMarker(-33,74,26,1);
         n_createMarker(-5,106,24,1);
         n_createMarker(-33,102,25,1);
         n_createMarker(-43,128,27,0.79998779296875);
         n_createMarker(22,83,23,1);
         n_createMarker(51,87,125,1);
         n_createMarker(89,64,109,1);
         n_createMarker(113,60,28,1);
         n_createMarker(132,45,29,1);
         n_createMarker(157,33,30,1);
         n_createMarker(181,45,31,1);
         n_createMarker(185,14,32,1);
         n_createMarker(133,20,124,0.649993896484375);
         n_createMarker(141,8,117,0.649993896484375);
         n_createMarker(156,8,118,0.649993896484375);
         n_createMarker(216,26,33,1);
         n_createMarker(243,27,34,1);
         n_createMarker(265,16,35,1);
         n_createMarker(281,-6,36,1);
         n_createMarker(290,-35,37,1);
         n_createMarker(310,-16,38,1);
         n_createMarker(288,-57,39,0.649993896484375);
         n_createMarker(259,-28,116,1);
         n_createMarker(240,2,40,1);
         n_createMarker(372,31,41,1);
         n_createMarker(394,14,42,1);
         n_createMarker(413,36,43,1);
         n_createMarker(449,68,104,1);
         n_createMarker(425,82,105,1);
         n_createMarker(399,75,106,1);
         n_createMarker(372,71,107,1);
         n_createMarker(347,72,108,1);
         n_createMarker(172,195,58,1);
         n_createMarker(200,198,59,1);
         n_createMarker(230,205,60,1);
         n_createMarker(261,210,61,1);
         n_createMarker(210,221,62,1);
         n_createMarker(282,176,63,1);
         n_createMarker(295,155,115,1);
         n_createMarker(291,127,65,1);
         n_createMarker(280,100,66,1);
         n_createMarker(272,250,81,1);
         n_createMarker(295,234,82,1);
         n_createMarker(309,214,83,1);
         n_createMarker(330,191,84,1);
         n_createMarker(341,165,85,1);
         n_createMarker(336,110,86,1);
         n_createMarker(362,123,87,1);
         n_createMarker(388,136,88,1);
         n_createMarker(393,114,92,0.649993896484375);
         n_createMarker(414,118,89,1);
         n_createMarker(417,147,90,1);
         n_createMarker(400,169,91,1);
         n_createMarker(479,87,93,1);
         n_createMarker(495,62,94,1);
         n_createMarker(493,10,101,1);
         n_createMarker(468,-1,102,1);
         n_createMarker(440,3,95,1);
         n_createMarker(413,-19,96,1);
         n_createMarker(386,-37,97,1);
         n_createMarker(350,-38,98,1);
         n_createMarker(325,-55,100,1);
         n_createMarker(404,-49,130,0.649993896484375);
         n_createMarker(405,-68,131,0.649993896484375);
         n_createMarker(405,-88,132,0.649993896484375);
         n_createMarker(379,-55,129,0.649993896484375);
         n_createMarker(375,-69,128,0.649993896484375);
         n_createMarker(440,-29,103,1);
         n_createMarker(172,160,110,1);
         n_createMarker(199,129,55,1);
         n_createMarker(352,0,134,0.9999919688239433);
         n_createMarker(339,21,135,0.9999919688239433);
         n_createMarker(323,40,136,0.9999919688239433);
         n_createMarker(300,49,137,0.9999919688239433);
         n_createMarker(358,-59,99,1);
         n_createMarker(392,-62,133,0.649993896484375);
         n_createMarker(281,68,138,0.9999919688239433);
         n_createMarker(256,59,139,0.6499790838491556);
         n_createMarker(267,49,140,0.6499790838491556);
         n_createMarker(282,44,141,0.6499790838491556);
         n_createMarker(244,85,142,0.9999919688239433);
         n_createMarker(222,73,143,0.9999919688239433);
         n_createMarker(198,71,144,0.9999919688239433);
         n_createMarker(213,53,145,0.6499790838491556);
      }
      
      private function buildMapOverlay() : void
      {
         var _loc13_:Image = null;
         var _loc1_:Number = -350;
         var _loc2_:Number = -185;
         var _loc3_:int = 900;
         var _loc4_:int = 560;
         var _loc5_:Shape = new Shape();
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:starling.display.DisplayObject = null;
         var _loc10_:starling.display.DisplayObject = null;
         var _loc11_:Object = {};
         var _loc12_:String = null;
         for each(_loc6_ in this.unlockedMaps)
         {
            _loc9_ = getChildByName("level_" + _loc6_);
            if(!(_loc9_ == null || Stats.levelStats[_loc6_] == undefined))
            {
               _loc7_ = 1;
               while(_loc7_ <= 7)
               {
                  _loc8_ = int(Stats.levelStats[_loc6_]["portal" + _loc7_ + "Lead"]);
                  if(_loc8_ > 0)
                  {
                     _loc10_ = getChildByName("level_" + _loc8_);
                     if(_loc10_ != null)
                     {
                        _loc12_ = _loc6_ < _loc8_ ? _loc6_ + "_" + _loc8_ : _loc8_ + "_" + _loc6_;
                        if(_loc11_[_loc12_] == undefined)
                        {
                           _loc11_[_loc12_] = true;
                           _loc5_.graphics.lineStyle(2.5,1052688,0.9);
                           _loc5_.graphics.moveTo(_loc9_.x - _loc1_,_loc9_.y - _loc2_);
                           _loc5_.graphics.lineTo(_loc10_.x - _loc1_,_loc10_.y - _loc2_);
                        }
                     }
                  }
                  _loc7_++;
               }
            }
         }
         _loc13_ = this.makeOverlayImage(_loc5_,_loc3_,_loc4_,_loc1_,_loc2_);
         if(numChildren > 1)
         {
            addChildAt(_loc13_,1);
         }
         else
         {
            addChild(_loc13_);
         }
      }
      
      private function makeOverlayImage(param1:Shape, param2:int, param3:int, param4:Number, param5:Number) : Image
      {
         var _loc7_:Image = null;
         var _loc6_:BitmapData = new BitmapData(param2,param3,true,0);
         _loc6_.draw(param1);
         _loc7_ = new Image(Texture.fromBitmapData(_loc6_));
         _loc7_.x = param4;
         _loc7_.y = param5;
         _loc7_.touchable = false;
         return _loc7_;
      }
      
      private function drawRing(param1:Shape, param2:uint, param3:uint, param4:Number, param5:Number) : void
      {
         var _loc6_:Object = this.markerPos[param2];
         if(_loc6_ == null)
         {
            return;
         }
         var _loc7_:Number = _loc6_.s > 0 ? Number(_loc6_.s) : 1;
         var _loc8_:Number = 11.5 * _loc7_;
         var _loc9_:Number = _loc6_.x - param4;
         var _loc10_:Number = _loc6_.y - param5;
         param1.graphics.lineStyle(1,0,1);
         param1.graphics.drawCircle(_loc9_,_loc10_,_loc8_ + 2);
         param1.graphics.lineStyle(4,param3,1);
         param1.graphics.drawCircle(_loc9_,_loc10_,_loc8_);
         param1.graphics.lineStyle(1,0,1);
         param1.graphics.drawCircle(_loc9_,_loc10_,_loc8_ - 2);
      }
      
      private function rebuildRings() : void
      {
         var _loc3_:BitmapData = null;
         if(this.ringsImg != null)
         {
            this.ringsImg.removeFromParent(true);
            this.ringsImg = null;
         }
         var _loc1_:Shape = new Shape();
         var _loc2_:uint = 0;
         for each(_loc2_ in this.friendStages)
         {
            this.drawRing(_loc1_,_loc2_,3066944,-350,-185);
         }
         this.drawRing(_loc1_,this.currentArea,12607743,-350,-185);
         _loc3_ = new BitmapData(900,560,true,0);
         _loc3_.draw(_loc1_);
         this.ringsImg = new Image(Texture.fromBitmapData(_loc3_));
         this.ringsImg.x = -350;
         this.ringsImg.y = -185;
         this.ringsImg.touchable = false;
         addChild(this.ringsImg);
      }
      
      private function scheduleFriendRefresh() : void
      {
         var self:MapMenu = null;
         if(this.refreshTimer != 0)
         {
            clearTimeout(this.refreshTimer);
            this.refreshTimer = 0;
         }
         self = this;
         this.refreshTimer = setTimeout(function():void
         {
            try
            {
               self.refreshFriendZones();
            }
            catch(timerErr:Error)
            {
            }
         },15000);
      }
      
      private function refreshFriendZones() : void
      {
         var names:*;
         var total:int;
         var i:int;
         var tk:int = 0;
         var self:MapMenu = null;
         this.refreshTimer = 0;
         if(root == null)
         {
            return;
         }
         this.scheduleFriendRefresh();
         if(this.refreshBusy)
         {
            return;
         }
         names = FriendMenu.friends_array;
         total = names == null ? 0 : int(names.length);
         if(total <= 0)
         {
            if(this.friendStages.length > 0)
            {
               this.friendStages = new Vector.<uint>();
               this.rebuildRings();
            }
            this.friendList_txt.text = "YOU";
            return;
         }
         this.refreshBusy = true;
         this.refreshData = {};
         this.refreshNames = [];
         this.refreshLeft = total;
         ++this.refreshToken;
         tk = int(this.refreshToken);
         self = this;
         setTimeout(function():void
         {
            try
            {
               self.forceRefreshDone(tk);
            }
            catch(wdErr:Error)
            {
            }
         },4000);
         i = 0;
         i = 0;
         while(i < total)
         {
            this.loadOneFriend(String(names[i]),tk);
            i++;
         }
      }
      
      private function loadOneFriend(param1:String, param2:int) : void
      {
         var self:MapMenu = null;
         var _name:String = param1;
         var _token:int = param2;
         self = this;
         if(root == null)
         {
            return;
         }
         MainStarlingStage(root).gameMain.theClient.bigDB.load("PlayerObjects",_name,function(param1:DatabaseObject):void
         {
            self.refreshOneFriend(_name,param1,_token);
         },function(param1:*):void
         {
            self.refreshOneFriend(_name,null,_token);
         });
      }
      
      private function refreshOneFriend(param1:String, param2:DatabaseObject, param3:int) : void
      {
         if(param3 != this.refreshToken || this.refreshData == null)
         {
            return;
         }
         if(param2 != null && Boolean(param2.on))
         {
            this.refreshNames.push(param2.name != null ? String(param2.name) : param1);
            if(param2.stage != undefined && param2.stage > 0)
            {
               this.refreshData[param1] = uint(param2.stage);
            }
         }
         --this.refreshLeft;
         if(this.refreshLeft <= 0)
         {
            this.applyRefreshedFriends(param3);
         }
      }
      
      private function applyRefreshedFriends(param1:int) : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         if(param1 != this.refreshToken || this.refreshData == null)
         {
            return;
         }
         var _loc2_:Vector.<uint> = new Vector.<uint>();
         var _loc3_:String = null;
         for(_loc3_ in this.refreshData)
         {
            if(_loc2_.indexOf(uint(this.refreshData[_loc3_])) < 0)
            {
               _loc2_.push(uint(this.refreshData[_loc3_]));
            }
         }
         this.friendStages = _loc2_;
         _loc4_ = "YOU";
         _loc5_ = 0;
         _loc5_ = 0;
         while(_loc5_ < this.refreshNames.length)
         {
            _loc4_ += "\n" + Person.removeNamePrefix(this.refreshNames[_loc5_]);
            _loc5_++;
         }
         this.friendList_txt.text = _loc4_;
         this.refreshData = null;
         this.refreshBusy = false;
         this.rebuildRings();
      }
      
      private function forceRefreshDone(param1:int) : void
      {
         if(param1 != this.refreshToken || this.refreshData == null)
         {
            return;
         }
         this.applyRefreshedFriends(param1);
      }
      
      public function showTeleportArrow(param1:uint) : void
      {
         if(this.arrowImg != null)
         {
            this.arrowImg.removeFromParent(true);
            this.arrowImg = null;
         }
         var _loc2_:Object = this.markerPos[param1];
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:Number = 26;
         var _loc4_:Number = 18;
         var _loc5_:Shape = new Shape();
         _loc5_.graphics.lineStyle(2,0,1);
         _loc5_.graphics.beginFill(16765470,1);
         _loc5_.graphics.moveTo(0,0);
         _loc5_.graphics.lineTo(_loc3_,0);
         _loc5_.graphics.lineTo(_loc3_ / 2,_loc4_);
         _loc5_.graphics.lineTo(0,0);
         _loc5_.graphics.endFill();
         var _loc6_:BitmapData = new BitmapData(int(_loc3_) + 2,int(_loc4_) + 2,true,0);
         _loc6_.draw(_loc5_);
         var _loc7_:Image = new Image(Texture.fromBitmapData(_loc6_));
         _loc7_.touchable = false;
         _loc7_.x = _loc2_.x - _loc3_ / 2;
         _loc7_.y = _loc2_.y - _loc4_ - 16;
         this.arrowImg = _loc7_;
         addChild(_loc7_);
      }
      
      public function hideTeleportArrow() : void
      {
         if(this.arrowImg != null)
         {
            this.arrowImg.removeFromParent(true);
            this.arrowImg = null;
         }
      }
      
      public function shinyFishMapLoaded(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:DatabaseObject = null;
         if(parent != null)
         {
            this.fishMap_btn.visible = true;
            _loc2_ = int(MainStarlingStage(root).gameMain.c_mc.totalFrames);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if(getChildByName("level_" + (_loc3_ + 1)) != null)
               {
                  getChildByName("level_" + (_loc3_ + 1)).scaleX = getChildByName("level_" + (_loc3_ + 1)).scaleY = 0.5;
               }
               _loc3_++;
            }
            for each(_loc4_ in param1)
            {
               getChildByName("level_" + _loc4_.area).scaleX = getChildByName("level_" + _loc4_.area).scaleX + 0.5;
               getChildByName("level_" + _loc4_.area).scaleY = getChildByName("level_" + _loc4_.area).scaleY + 0.5;
               MapMarker(getChildByName("level_" + _loc4_.area)).shinyFish_array.push(_loc4_.type);
            }
         }
      }
      
      override public function dispose() : void
      {
         if(this.refreshTimer != 0)
         {
            clearTimeout(this.refreshTimer);
            this.refreshTimer = 0;
         }
         this.refreshData = null;
         if(this.ringsImg != null)
         {
            this.ringsImg.removeFromParent(true);
            this.ringsImg = null;
         }
         super.dispose();
      }
   }
}

