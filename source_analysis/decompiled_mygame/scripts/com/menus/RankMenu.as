package com.menus
{
   import com.game_objects.Person;
   import com.game_objects.Pet;
   import com.stats.*;
   import flash.display.*;
   import flash.text.TextField;
   import playerio.Connection;
   import playerio.Message;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol690")]
   public final class RankMenu extends GameMenu
   {
      
      public var bonusLeft_txt:TextField;
      
      public var bonusRight_txt:TextField;
      
      public var chopBar_mc:MovieClip;
      
      public var chopRank_txt:TextField;
      
      public var chopScore_txt:TextField;
      
      public var chopTotal_txt:TextField;
      
      public var chop_txt:TextField;
      
      public var enemyKills_txt:TextField;
      
      public var fishBar_mc:MovieClip;
      
      public var fishRank_txt:TextField;
      
      public var fishScore_txt:TextField;
      
      public var fishTotal_txt:TextField;
      
      public var fish_txt:TextField;
      
      public var guildBar_mc:MovieClip;
      
      public var guildConBar_mc:MovieClip;
      
      public var guildConScore_txt:TextField;
      
      public var guildConTotal_txt:TextField;
      
      public var guildContributeRank_txt:TextField;
      
      public var guildContribute_txt:TextField;
      
      public var guildKillsRank_txt:TextField;
      
      public var guildKills_txt:TextField;
      
      public var guildLevelsRank_txt:TextField;
      
      public var guildLevels_txt:TextField;
      
      public var guildPvpBar_mc:MovieClip;
      
      public var guildPvpScore_txt:TextField;
      
      public var guildPvpTotal_txt:TextField;
      
      public var guildScore_txt:TextField;
      
      public var guildTotal_txt:TextField;
      
      public var hitArea_mc:MovieClip;
      
      public var killScore_txt:TextField;
      
      public var killsBar_mc:MovieClip;
      
      public var killsRankTotal_txt:TextField;
      
      public var killsRank_txt:TextField;
      
      public var levelBar_mc:MovieClip;
      
      public var levelRank_txt:TextField;
      
      public var levelScore_txt:TextField;
      
      public var levelTotal_txt:TextField;
      
      public var level_txt:TextField;
      
      public var loadingCircle_mc:LoadingCircle;
      
      public var loadingOverlay_mc:MovieClip;
      
      public var overallBar_mc:MovieClip;
      
      public var overallRank_txt:TextField;
      
      public var overallTotal_txt:TextField;
      
      public var pet1_mc:MovieClip;
      
      public var pet2_mc:MovieClip;
      
      public var pet3_mc:MovieClip;
      
      public var pet4_mc:MovieClip;
      
      public var pet5_mc:MovieClip;
      
      public var pet6_mc:MovieClip;
      
      public var pet7_mc:MovieClip;
      
      public var pet8_mc:MovieClip;
      
      public var petBar_mc:MovieClip;
      
      public var petLevels_txt:TextField;
      
      public var petRankTotal_txt:TextField;
      
      public var petRank_txt:TextField;
      
      public var petScore_txt:TextField;
      
      public var pvpBar_mc:MovieClip;
      
      public var pvpKillsRankTotal_txt:TextField;
      
      public var pvpKillsRank_txt:TextField;
      
      public var pvpKills_txt:TextField;
      
      public var pvpScore_txt:TextField;
      
      public var title_txt:TextField;
      
      public var totalScore_txt:TextField;
      
      public var x_btn:SimpleButton;
      
      private var mainPlayer:Person;
      
      private var mainConnection:Connection;
      
      private var yourEnemyList:Vector.<String>;
      
      private var yourFishList:Vector.<String>;
      
      public function RankMenu(param1:Person, param2:Vector.<String>, param3:Vector.<String>, param4:Connection)
      {
         super();
         addFrameScript(0,this.frame1);
         this.loadingCircle_mc.loadingText_txt.text = "loading ranks...";
         this.mainPlayer = param1;
         this.mainConnection = param4;
         this.yourEnemyList = param2;
         this.yourFishList = param3;
      }
      
      public function ranksGot(param1:Message, param2:String, param3:int, param4:int, param5:int, param6:int, param7:uint, param8:int, param9:int, param10:int) : void
      {
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Pet = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:XML = null;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         if(GameMenu.menu_array.indexOf(this) > -1)
         {
            if(getChildByName("loadingOverlay_mc").parent != null)
            {
               removeChild(getChildByName("loadingOverlay_mc"));
               removeChild(getChildByName("loadingCircle_mc"));
            }
            _loc11_ = 0;
            while(_loc11_ < 8)
            {
               getChildByName("pet" + String(_loc11_ + 1) + "_mc").visible = false;
               _loc11_++;
            }
            _loc12_ = new int(0);
            for each(_loc13_ in this.mainPlayer.pet_array)
            {
               _loc12_ += _loc13_.lvl;
            }
            _loc14_ = 0;
            _loc15_ = int(Stats.missionList.length);
            _loc11_ = 0;
            while(_loc11_ < _loc15_)
            {
               if(Stats.missionStats[Stats.missionList[_loc11_]].completed)
               {
                  _loc14_++;
               }
               _loc11_++;
            }
            _loc16_ = new XML(param2);
            this.level_txt.text = "level: " + String(this.mainPlayer.lev);
            this.levelRank_txt.text = _loc16_.level != "" && int(_loc16_.level) <= int(_loc16_.levelsTotal) ? _loc16_.level : "N/A";
            this.levelTotal_txt.text = _loc16_.levelsTotal;
            this.petLevels_txt.text = "levels: " + String(_loc12_);
            this.petRank_txt.text = _loc16_.petRank != "" && int(_loc16_.petRank) <= int(_loc16_.petRankTotal) ? _loc16_.petRank : "N/A";
            this.enemyKills_txt.text = "kills: " + String(param3);
            this.killsRank_txt.text = _loc16_.enemyKills != "" && int(_loc16_.enemyKills) <= int(_loc16_.killsTotal) ? _loc16_.enemyKills : "N/A";
            this.pvpKillsRank_txt.text = _loc16_.pvpKills != "" && int(_loc16_.pvpKills) <= int(_loc16_.pvpKillsTotal) ? _loc16_.pvpKills : "N/A";
            this.guildLevelsRank_txt.text = _loc16_.guildLevels != "" && int(_loc16_.guildLevels) <= int(_loc16_.guildTotal) ? _loc16_.guildLevels : "N/A";
            this.guildContributeRank_txt.text = _loc16_.guildContribute != "" && int(_loc16_.guildContribute) <= int(_loc16_.guildConTotal) ? _loc16_.guildContribute : "N/A";
            this.guildKillsRank_txt.text = _loc16_.guildKills != "" && int(_loc16_.guildKills) <= int(_loc16_.guildPvpTotal) ? _loc16_.guildKills : "N/A";
            this.petRankTotal_txt.text = _loc16_.petRankTotal;
            this.killsRankTotal_txt.text = _loc16_.killsTotal;
            this.pvpKills_txt.text = "kills: " + String(param6);
            this.pvpKillsRankTotal_txt.text = _loc16_.pvpKillsTotal;
            this.guildTotal_txt.text = _loc16_.guildTotal;
            this.guildConTotal_txt.text = _loc16_.guildConTotal;
            this.guildPvpTotal_txt.text = _loc16_.guildPvpTotal;
            this.overallRank_txt.text = _loc16_.overall != "" && int(_loc16_.overall) <= int(_loc16_.overallTotal) ? _loc16_.overall : "N/A";
            this.overallTotal_txt.text = _loc16_.overallTotal;
            this.fish_txt.text = "level: " + this.mainPlayer.fishingLvl;
            this.fishRank_txt.text = _loc16_.fish;
            this.fishTotal_txt.text = _loc16_.fishTotal;
            this.chop_txt.text = "level: " + this.mainPlayer.choppingLvl;
            this.chopRank_txt.text = _loc16_.chop;
            this.chopTotal_txt.text = _loc16_.chopTotal;
            _loc11_ = 0;
            while(_loc11_ < this.mainPlayer.pet_array.length)
            {
               getChildByName("pet" + String(_loc11_ + 1) + "_mc").visible = true;
               MovieClip(getChildByName("pet" + String(_loc11_ + 1) + "_mc")).petName_txt.text = this.mainPlayer.pet_array[_loc11_].name;
               if(_loc16_.eachPetRank[this.mainPlayer.pet_array[_loc11_].name] != undefined)
               {
                  MovieClip(getChildByName("pet" + String(_loc11_ + 1) + "_mc")).rank_txt.text = _loc16_.eachPetRank[this.mainPlayer.pet_array[_loc11_].name];
               }
               _loc11_++;
            }
            this.levelBar_mc.scaleX = this.levelRank_txt.text != "N/A" ? (int(this.levelTotal_txt.text) - int(this.levelRank_txt.text)) / int(this.levelTotal_txt.text) : 0;
            this.petBar_mc.scaleX = this.petRank_txt.text != "N/A" ? (int(this.petRankTotal_txt.text) - int(this.petRank_txt.text)) / int(this.petRankTotal_txt.text) : 0;
            this.killsBar_mc.scaleX = this.killsRank_txt.text != "N/A" ? (int(this.killsRankTotal_txt.text) - int(this.killsRank_txt.text)) / int(this.killsRankTotal_txt.text) : 0;
            this.pvpBar_mc.scaleX = this.pvpKillsRank_txt.text != "N/A" ? (int(this.pvpKillsRankTotal_txt.text) - int(this.pvpKillsRank_txt.text)) / int(this.pvpKillsRankTotal_txt.text) : 0;
            this.guildBar_mc.scaleX = this.guildLevelsRank_txt.text != "N/A" ? (int(this.guildTotal_txt.text) - int(this.guildLevelsRank_txt.text)) / int(this.guildTotal_txt.text) : 0;
            this.guildConBar_mc.scaleX = this.guildContributeRank_txt.text != "N/A" ? (int(this.guildConTotal_txt.text) - int(this.guildContributeRank_txt.text)) / int(this.guildConTotal_txt.text) : 0;
            this.guildPvpBar_mc.scaleX = this.guildKillsRank_txt.text != "N/A" ? (int(this.guildPvpTotal_txt.text) - int(this.guildKillsRank_txt.text)) / int(this.guildPvpTotal_txt.text) : 0;
            this.overallBar_mc.scaleX = this.overallRank_txt.text != "N/A" ? (int(this.overallTotal_txt.text) - int(this.overallRank_txt.text)) / int(this.overallTotal_txt.text) : 0;
            this.fishBar_mc.scaleX = this.fishRank_txt.text != "N/A" ? (int(this.fishTotal_txt.text) - int(this.fishRank_txt.text)) / int(this.fishTotal_txt.text) : 0;
            this.chopBar_mc.scaleX = this.chopRank_txt.text != "N/A" ? (int(this.chopTotal_txt.text) - int(this.chopRank_txt.text)) / int(this.chopTotal_txt.text) : 0;
            this.levelScore_txt.text = String(int(this.levelBar_mc.scaleX * 100000));
            this.petScore_txt.text = String(int(this.petBar_mc.scaleX * 55000));
            this.killScore_txt.text = String(int(this.killsBar_mc.scaleX * 20000));
            this.pvpScore_txt.text = String(int(this.pvpBar_mc.scaleX * 15000));
            this.guildScore_txt.text = String(int(this.guildBar_mc.scaleX * 20000));
            this.guildConScore_txt.text = String(int(this.guildConBar_mc.scaleX * 11000));
            this.guildPvpScore_txt.text = String(int(this.guildPvpBar_mc.scaleX * 9000));
            this.fishScore_txt.text = String(int(this.fishBar_mc.scaleX * 8000));
            this.chopScore_txt.text = String(int(this.chopBar_mc.scaleX * 7000));
            _loc17_ = this.yourEnemyList.length * 230 + this.yourFishList.length * 115;
            _loc18_ = param4 * 10;
            _loc19_ = this.mainPlayer.pet_array.length * 500;
            _loc20_ = _loc14_ * 250;
            _loc21_ = param5 * 1.5;
            this.bonusLeft_txt.text = "Heropedia bonus: " + String(_loc17_) + "\nUsed books bonus: " + String(_loc18_) + "\nOwned pets bonus: " + String(_loc19_);
            this.bonusRight_txt.text = "Completed Quests bonus: " + String(_loc20_) + "\nPayvault bonus: " + String(_loc21_) + "\nGuild Leader bonus: " + String(param10);
            this.guildLevels_txt.text = "levels: " + String(param8);
            this.guildContribute_txt.text = "contribute: " + String(param7);
            this.guildKills_txt.text = "kills: " + String(param9);
            this.totalScore_txt.text = String(int(this.levelScore_txt.text) + int(this.fishScore_txt.text) + int(this.chopScore_txt.text) + int(this.petScore_txt.text) + int(this.killScore_txt.text) + int(this.pvpScore_txt.text) + int(this.guildScore_txt.text) + int(this.guildConScore_txt.text) + int(this.guildPvpScore_txt.text) + _loc17_ + _loc18_ + _loc19_ + _loc20_ + _loc21_ + param10);
         }
         this.mainConnection.removeMessageHandler("ranksGot",this.ranksGot);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

