package com.menus
{
   import com.game_objects.*;
   import com.stats.*;
   import com.ui.*;
   import flash.display.*;
   import starling.display.*;
   import starling.text.*;
   import starling.textures.*;
   
   public final class FishListMenu extends StarlingGameMenu
   {
      
      private const types_txt:TextField = new TextField(156,360,"",AllTextFormats.fish_textFormat);
      
      private const locations_txt:TextField = new TextField(189,360,"",AllTextFormats.fish_textFormat);
      
      private const servers_txt:TextField = new TextField(145,360,"",AllTextFormats.fish_textFormat);
      
      private const times_txt:TextField = new TextField(125,360,"",AllTextFormats.fish_textFormat);
      
      public function FishListMenu()
      {
         var _loc1_:Image = null;
         var _loc2_:Button = null;
         _loc1_ = null;
         _loc2_ = null;
         super();
         _loc1_ = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("fish list panel"));
         _loc1_.x = -305;
         _loc1_.y = -124;
         addChild(_loc1_);
         _loc2_ = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_00"),"",ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_01"));
         _loc2_.x = 379;
         _loc2_.y = -108;
         _loc2_.pivotX = 30;
         _loc2_.pivotY = 19;
         _loc2_.name = "x_btn";
         addChild(_loc2_);
         this.types_txt.x = -246;
         addChild(this.types_txt);
         this.locations_txt.x = -86;
         addChild(this.locations_txt);
         this.servers_txt.x = 106;
         addChild(this.servers_txt);
         this.times_txt.x = 254;
         addChild(this.times_txt);
         this.times_txt.y = this.servers_txt.y = this.locations_txt.y = this.types_txt.y = -86;
         this.times_txt.batchable = this.servers_txt.batchable = this.locations_txt.batchable = this.types_txt.batchable = true;
         this.times_txt.touchable = this.servers_txt.touchable = this.locations_txt.touchable = this.types_txt.touchable = false;
         var _loc3_:Image = new Image(Texture.fromBitmapData(new BitmapData(653,36,false,16711680)));
         _loc3_.x = -303;
         _loc3_.y = -125;
         _loc3_.alpha = 0;
         _loc3_.name = "drag_image";
         addChild(_loc3_);
      }
      
      public function shinyFishLoaded(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Item = null;
         this.types_txt.text = this.locations_txt.text = this.servers_txt.text = this.times_txt.text = "";
         var _loc4_:Date = new Date();
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc2_ = (_loc4_.getTime() - param1[_loc5_].time.getTime()) / 1000 / 60;
            this.types_txt.text += "shiny " + param1[_loc5_].type + "\n";
            this.locations_txt.text += Stats.levelStats[param1[_loc5_].area].fname + "\n";
            this.servers_txt.text += param1[_loc5_].server + "\n";
            this.times_txt.text += _loc2_ + " minutes ago\n";
            _loc3_ = new Item("shiny " + param1[_loc5_].type,"","");
            _loc3_.x = -261;
            _loc3_.y = -79 + _loc5_ * 22;
            _loc3_.scaleX = -0.65;
            _loc3_.scaleY = 0.65;
            addChild(_loc3_);
            _loc5_++;
         }
      }
   }
}

