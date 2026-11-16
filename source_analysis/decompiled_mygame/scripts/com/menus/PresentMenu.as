package com.menus
{
   import com.ui.*;
   import flash.display.*;
   import starling.*;
   import starling.display.*;
   import starling.text.*;
   import starling.textures.*;
   
   public final class PresentMenu extends StarlingGameMenu
   {
      
      private const ticketPlus_btn:Button = new Button(CharacterMenu.charMenu_textureAtlas.getTexture("more_btn_00"),"",null,CharacterMenu.charMenu_textureAtlas.getTexture("more_btn_01"));
      
      private const ticketMinus_btn:Button = new Button(CharacterMenu.charMenu_textureAtlas.getTexture("less_btn_00"),"",null,CharacterMenu.charMenu_textureAtlas.getTexture("less_btn_01"));
      
      private const giveTickets_txt:TextField = new TextField(255,30,"Tickets to give: 0",AllTextFormats.giveTickets_textFormat);
      
      private var __ticketsOffered:int;
      
      private var __receiverName:String;
      
      public function PresentMenu(param1:int, param2:String)
      {
         var _loc3_:Image = null;
         var _loc4_:Button = null;
         var _loc5_:Button = null;
         _loc3_ = null;
         _loc4_ = null;
         _loc5_ = null;
         var _loc6_:TextField = null;
         super();
         this.__ticketsOffered = 0;
         this.__receiverName = param2;
         _loc3_ = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("present panel"));
         _loc3_.x = -215;
         _loc3_.y = -124;
         addChild(_loc3_);
         _loc4_ = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_00"),"",null,ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_01"));
         _loc4_.x = 240;
         _loc4_.y = -108;
         _loc4_.pivotX = 30;
         _loc4_.pivotY = 19;
         _loc4_.name = "x_btn";
         addChild(_loc4_);
         _loc5_ = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("confirm"));
         _loc5_.x = 172;
         _loc5_.y = 159;
         _loc5_.pivotX = 59;
         _loc5_.pivotY = 16;
         _loc5_.scaleWhenOver = 0.95;
         _loc5_.name = "presentConfirm_btn";
         addChild(_loc5_);
         this.ticketPlus_btn.x = 106;
         this.ticketPlus_btn.pivotX += this.ticketPlus_btn.width / 2;
         this.ticketPlus_btn.pivotY += this.ticketPlus_btn.height / 2;
         this.ticketPlus_btn.name = "presentTicketsPlus_btn";
         addChild(this.ticketPlus_btn);
         this.ticketMinus_btn.x = 79;
         this.ticketMinus_btn.y = this.ticketPlus_btn.y = 33;
         this.ticketMinus_btn.pivotX += this.ticketMinus_btn.width / 2;
         this.ticketMinus_btn.pivotY += this.ticketMinus_btn.height / 2;
         this.ticketMinus_btn.name = "presentTicketsMinus_btn";
         this.ticketMinus_btn.visible = false;
         addChild(this.ticketMinus_btn);
         var _loc7_:TextField = new TextField(352,24,"Give " + param2 + " a present",AllTextFormats.giveName_textFormat);
         _loc7_.x = -159;
         _loc7_.y = -85;
         addChild(_loc7_);
         _loc6_ = new TextField(238,23,"Tickets available: " + String(param1),AllTextFormats.haveTickets_textFormat);
         _loc6_.x = -170;
         _loc6_.y = -9;
         addChild(_loc6_);
         this.giveTickets_txt.x = -170;
         this.giveTickets_txt.y = 18;
         this.giveTickets_txt.touchable = _loc6_.touchable = _loc7_.touchable = false;
         this.giveTickets_txt.batchable = _loc6_.batchable = _loc7_.batchable = true;
         addChild(this.giveTickets_txt);
         drag_image = new Image(Texture.fromBitmapData(new BitmapData(432,36,false,16711680)));
         drag_image.x = -216;
         drag_image.y = -125;
         drag_image.name = "drag_image";
         drag_image.alpha = 0;
         addChild(drag_image);
      }
      
      public function addTicket() : void
      {
         ++this.__ticketsOffered;
         this.ticketPlus_btn.visible = this.__ticketsOffered >= MainStarlingStage(root).gameMain.player.tickets ? false : true;
         this.giveTickets_txt.text = "Tickets to give: " + String(this.__ticketsOffered);
         this.ticketMinus_btn.visible = true;
      }
      
      public function minusTicket() : void
      {
         --this.__ticketsOffered;
         this.ticketMinus_btn.visible = this.__ticketsOffered == 0 ? false : true;
         this.giveTickets_txt.text = "Tickets to give: " + String(this.__ticketsOffered);
         this.ticketPlus_btn.visible = true;
      }
      
      public function get ticketsOffered() : int
      {
         return this.__ticketsOffered;
      }
      
      public function get receiverName() : String
      {
         return this.__receiverName;
      }
   }
}

