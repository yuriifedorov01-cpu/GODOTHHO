package com.ui
{
   import com.utilities.*;
   import starling.text.*;
   
   public final class AllTextFormats
   {
      
      public static var name_textFormat:TextFormat;
      
      public static var chalkLeft_textFormat:TextFormat;
      
      public static var chalkRight_textFormat:TextFormat;
      
      public static var lotteryTickets_textFormat:TextFormat;
      
      public static var lotteryCoins_textFormat:TextFormat;
      
      public static var xp_textFormat:TextFormat;
      
      public static var talk_textFormat:TextFormat;
      
      public static var headline_textFormat:TextFormat;
      
      public static var desc_textFormat:TextFormat;
      
      public static var money_textFormat:TextFormat;
      
      public static var item_textFormat:TextFormat;
      
      public static var itemStorage_textFormat:TextFormat;
      
      public static var stats_textFormat:TextFormat;
      
      public static var bonus_textFormat:TextFormat;
      
      public static var ability_textFormat:TextFormat;
      
      public static var petType_textFormat:TextFormat;
      
      public static var title_textFormat:TextFormat;
      
      public static var petName_textFormat:TextFormat;
      
      public static var level_textFormat:TextFormat;
      
      public static var xp2_textFormat:TextFormat;
      
      public static var cost_textFormat:TextFormat;
      
      public static var type_textFormat:TextFormat;
      
      public static var colon_textFormat:TextFormat;
      
      public static var classDesc_textFormat:TextFormat;
      
      public static var emailNotice_textFormat:TextFormat;
      
      public static var fish_textFormat:TextFormat;
      
      public static var info_textFormat:TextFormat;
      
      public static var friendName_textFormat:TextFormat;
      
      public static var banned_textFormat:TextFormat;
      
      public static var guildChat_textFormat:TextFormat;
      
      public static var friendNamePiece_textFormat:TextFormat;
      
      public static var memberName_textFormat:TextFormat;
      
      public static var info2_textFormat:TextFormat;
      
      public static var contribute_textFormat:TextFormat;
      
      public static var item2_textFormat:TextFormat;
      
      public static var stats2_textFormat:TextFormat;
      
      public static var yourItemType_textFormat:TextFormat;
      
      public static var ticketsTitle_textFormat:TextFormat;
      
      public static var ticketStats_textFormat:TextFormat;
      
      public static var ticketsSell_textFormat:TextFormat;
      
      public static var item3_textFormat:TextFormat;
      
      public static var entries_textFormat:TextFormat;
      
      public static var costs_textFormat:TextFormat;
      
      public static var friendList_textFormat:TextFormat;
      
      public static var playerTotals_textFormat:TextFormat;
      
      public static var desc2_textFormat:TextFormat;
      
      public static var toggleOff_textFormat:TextFormat;
      
      public static var toggleOn_textFormat:TextFormat;
      
      public static var qualityOff_textFormat:TextFormat;
      
      public static var qualityOn_textFormat:TextFormat;
      
      public static var buttons_textFormat:TextFormat;
      
      public static var valid_textFormat:TextFormat;
      
      public static var petName2_textFormat:TextFormat;
      
      public static var petName3_textFormat:TextFormat;
      
      public static var petType2_textFormat:TextFormat;
      
      public static var stats3_textFormat:TextFormat;
      
      public static var petLvl_textFormat:TextFormat;
      
      public static var name2_textFormat:TextFormat;
      
      public static var desc3_textFormat:TextFormat;
      
      public static var percent_textFormat:TextFormat;
      
      public static var xpSplit_textFormat:TextFormat;
      
      public static var type2_textFormat:TextFormat;
      
      public static var cost2_textFormat:TextFormat;
      
      public static var skillPoints_textFormat:TextFormat;
      
      public static var skill_textFormat:TextFormat;
      
      public static var showBasic_textFormat:TextFormat;
      
      public static var showWarrior_textFormat:TextFormat;
      
      public static var showArcher_textFormat:TextFormat;
      
      public static var showWizard_textFormat:TextFormat;
      
      public static var showCowboy_textFormat:TextFormat;
      
      public static var giveTickets_textFormat:TextFormat;
      
      public static var giveName_textFormat:TextFormat;
      
      public static var haveTickets_textFormat:TextFormat;
      
      public static var chat_textFormat:TextFormat;
      
      public static var money2_textFormat:TextFormat;
      
      public static var tickets_textFormat:TextFormat;
      
      public static var confirmed_textFormat:TextFormat;
      
      public static var chatPM_textFormat:TextFormat;
      
      public static var energyInfo_textFormat:TextFormat;
      
      public static var confirm_textFormat:TextFormat;
      
      public function AllTextFormats()
      {
         super();
      }
      
      public static function init() : void
      {
         name_textFormat = new TextFormat(Assets.names_font.name,12,16777215);
         chalkLeft_textFormat = new TextFormat(Assets.chalk_font.name,14,16777215,"left");
         chalkRight_textFormat = new TextFormat(Assets.chalk_font.name,14,16777215,"right");
         lotteryTickets_textFormat = new TextFormat(Assets.lottery_font.name,46,16777215,"right");
         lotteryCoins_textFormat = new TextFormat(Assets.lottery_font.name,34,16777215,"right");
         xp_textFormat = new TextFormat(Assets.stats_font.name,16,16777215,"left");
         talk_textFormat = new TextFormat(Assets.talk_font.name,10,0,"left","top");
         headline_textFormat = new TextFormat(Assets.stats_font.name,14,16777215);
         desc_textFormat = new TextFormat(Assets.stats_font.name,13,16777215,"left","top");
         money_textFormat = new TextFormat(Assets.stats_font.name,21,16777215,"left","top");
         item_textFormat = new TextFormat(Assets.stats_font.name,18,16777215,"left");
         itemStorage_textFormat = new TextFormat(Assets.stats_font.name,27,16777215);
         stats_textFormat = new TextFormat(Assets.stats_font.name,14,16777215,"left","top");
         bonus_textFormat = new TextFormat(Assets.stats_font.name,17,16777113,"left");
         ability_textFormat = new TextFormat(Assets.stats_font.name,17,16777215,"left");
         petType_textFormat = new TextFormat(Assets.stats_font.name,13,16777215);
         title_textFormat = new TextFormat(Assets.stats_font.name,28,16777215);
         petName_textFormat = new TextFormat(Assets.stats_font.name,18,16777215);
         level_textFormat = new TextFormat(Assets.stats_font.name,24,16777215,"left");
         xp2_textFormat = new TextFormat(Assets.stats_font.name,15,16777215,"left");
         cost_textFormat = new TextFormat(Assets.stats_font.name,16,16777215,"left");
         type_textFormat = new TextFormat(Assets.stats_font.name,26,16776960);
         colon_textFormat = new TextFormat(Assets.stats_font.name,26,16777215,"right");
         classDesc_textFormat = new TextFormat(Assets.readable_font.name,14,16777215,"left","top");
         emailNotice_textFormat = new TextFormat(Assets.readable_font.name,12,16777215,"right");
         fish_textFormat = new TextFormat(Assets.stats_font.name,16,16777215,"left","top");
         info_textFormat = new TextFormat(Assets.stats_font.name,14,16777215,"left","top");
         friendName_textFormat = new TextFormat(Assets.stats_font.name,19,16777215);
         banned_textFormat = new TextFormat(Assets.stats_font.name,42,16711680);
         guildChat_textFormat = new TextFormat(Assets.stats_font.name,22,16777215,"left");
         friendNamePiece_textFormat = new TextFormat(Assets.stats_font.name,17,16777215,"left");
         memberName_textFormat = new TextFormat(Assets.stats_font.name,19,16777215,"left");
         info2_textFormat = new TextFormat(Assets.stats_font.name,15,16777215,"left","top");
         contribute_textFormat = new TextFormat(Assets.readable_font.name,17,16777215,"right");
         item2_textFormat = new TextFormat(Assets.stats_font.name,19,16777215,"left");
         stats2_textFormat = new TextFormat(Assets.stats_font.name,16,16777215,"left","top");
         yourItemType_textFormat = new TextFormat(Assets.stats_font.name,14,16777215);
         ticketsTitle_textFormat = new TextFormat(Assets.stats_font.name,16,16777215);
         ticketStats_textFormat = new TextFormat(Assets.stats_font.name,14,16777215,"left");
         ticketsSell_textFormat = new TextFormat(Assets.stats_font.name,14,16776960,"right");
         item3_textFormat = new TextFormat(Assets.stats_font.name,17,16777215,"left");
         entries_textFormat = new TextFormat(Assets.stats_font.name,20,16777215,"left");
         costs_textFormat = new TextFormat(Assets.stats_font.name,18,16777215,"left");
         friendList_textFormat = new TextFormat(Assets.stats_font.name,16,16777215,"left","top");
         playerTotals_textFormat = new TextFormat(Assets.stats_font.name,18,16777215,"left");
         desc2_textFormat = new TextFormat(Assets.stats_font.name,20,16777215,"left");
         toggleOff_textFormat = new TextFormat(Assets.stats_font.name,22,16777215);
         toggleOn_textFormat = new TextFormat(Assets.stats_font.name,22,16776960);
         qualityOff_textFormat = new TextFormat(Assets.stats_font.name,20,16777215);
         qualityOn_textFormat = new TextFormat(Assets.stats_font.name,20,16776960);
         buttons_textFormat = new TextFormat(Assets.stats_font.name,14,16777215,"left");
         valid_textFormat = new TextFormat(Assets.readable_font.name,13,16711680,"left");
         petName2_textFormat = new TextFormat(Assets.stats_font.name,17,16777215,"left");
         petName3_textFormat = new TextFormat(Assets.stats_font.name,22,16777215);
         petType2_textFormat = new TextFormat(Assets.stats_font.name,17,16777215);
         stats3_textFormat = new TextFormat(Assets.readable_font.name,16,16777215,"left","top");
         petLvl_textFormat = new TextFormat(Assets.stats_font.name,15,16777215);
         name2_textFormat = new TextFormat(Assets.stats_font.name,18,16777215,"left");
         desc3_textFormat = new TextFormat(Assets.readable_font.name,14,16777215,"left","top");
         percent_textFormat = new TextFormat(Assets.stats_font.name,18,16777215,"left");
         xpSplit_textFormat = new TextFormat(Assets.stats_font.name,32,16777215);
         type2_textFormat = new TextFormat(Assets.stats_font.name,26,16777215);
         cost2_textFormat = new TextFormat(Assets.stats_font.name,18,16777215);
         skillPoints_textFormat = new TextFormat(Assets.stats_font.name,42,16777215);
         skill_textFormat = new TextFormat(Assets.stats_font.name,14,16776960,"left");
         showBasic_textFormat = new TextFormat(Assets.stats_font.name,18,16777215,"left");
         showWarrior_textFormat = new TextFormat(Assets.stats_font.name,18,16563902,"left");
         showArcher_textFormat = new TextFormat(Assets.stats_font.name,18,13040575,"left");
         showWizard_textFormat = new TextFormat(Assets.stats_font.name,18,12377854,"left");
         showCowboy_textFormat = new TextFormat(Assets.stats_font.name,18,15785372,"left");
         giveTickets_textFormat = new TextFormat(Assets.stats_font.name,24,16777215);
         giveName_textFormat = new TextFormat(Assets.stats_font.name,19,16777215);
         haveTickets_textFormat = new TextFormat(Assets.stats_font.name,18,16777215);
         chat_textFormat = new TextFormat(Assets.readable_font.name,12,16777215,"left","top");
         money2_textFormat = new TextFormat(Assets.stats_font.name,15,16777215,"left");
         tickets_textFormat = new TextFormat(Assets.stats_font.name,16,16777215,"left");
         confirmed_textFormat = new TextFormat(Assets.stats_font.name,38,16777215);
         chatPM_textFormat = new TextFormat(Assets.readable_font.name,11,16777215,"left","top");
         energyInfo_textFormat = new TextFormat(Assets.stats_font.name,16,16777215,"right","top");
         confirm_textFormat = new TextFormat(Assets.readable_font.name,18,16777215);
         classDesc_textFormat.leading = -5;
         fish_textFormat.leading = 12;
         friendList_textFormat.leading = 10;
         info_textFormat.leading = 5;
         stats_textFormat.leading = 10;
         desc_textFormat.leading = -3;
         info2_textFormat.leading = 10;
         stats2_textFormat.leading = 10;
         desc2_textFormat.leading = 10;
         energyInfo_textFormat.leading = 10;
      }
   }
}

