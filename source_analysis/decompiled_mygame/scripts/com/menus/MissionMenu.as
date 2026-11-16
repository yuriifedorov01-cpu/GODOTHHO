package com.menus
{
   import com.math.*;
   import com.stats.*;
   import com.ui.*;
   import flash.display.*;
   import flash.geom.*;
   import starling.core.*;
   import starling.display.*;
   import starling.text.*;
   import starling.textures.*;
   
   public final class MissionMenu extends StarlingGameMenu implements IScrollableGameMenu
   {
      
      private const panel_array:Vector.<Image> = new Vector.<Image>();
      
      private const missionText_array:Vector.<TextField> = new Vector.<TextField>();
      
      private const list_sprite:starling.display.Sprite = new Sprite();
      
      private const mission_txt:TextField = new TextField(361,25,"",AllTextFormats.qualityOff_textFormat);
      
      private const desc_txt:TextField = new TextField(425,46,"",AllTextFormats.desc_textFormat);
      
      private const scroll_btn:Button = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("scroll"));
      
      private const mask_canvas:Canvas = new Canvas();
      
      public function MissionMenu()
      {
         var _loc1_:Image = null;
         var _loc8_:Button = null;
         _loc1_ = null;
         var _loc2_:Image = null;
         var _loc3_:Image = null;
         var _loc4_:String = null;
         var _loc5_:Image = null;
         var _loc6_:String = null;
         var _loc7_:TextField = null;
         super();
         _loc1_ = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("mission menu panel"));
         _loc1_.x = -265;
         _loc1_.y = -208;
         addChild(_loc1_);
         _loc8_ = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_00"),"",ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_01"));
         _loc8_.x = 226;
         _loc8_.y = -193;
         _loc8_.pivotX = 30;
         _loc8_.pivotY = 19;
         _loc8_.name = "x_btn";
         addChild(_loc8_);
         this.scroll_btn.x = 208;
         this.scroll_btn.y = -132;
         this.scroll_btn.pivotX = 15;
         this.scroll_btn.pivotY = 19;
         this.scroll_btn.name = "scroll_btn";
         this.scroll_btn.visible = !GameMain.isMobile;
         addChild(this.scroll_btn);
         this.mask_canvas.drawRectangle(-230,-161,460,361);
         this.list_sprite.x = -30;
         this.list_sprite.y = -12;
         this.list_sprite.mask = this.mask_canvas;
         this.list_sprite.name = "itemScrollList";
         addChild(this.list_sprite);
         if(GameMain.isMobile)
         {
            _loc2_ = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("dark green pixel"));
            _loc2_.x = -140;
            _loc2_.y = -474;
            _loc2_.width = 250;
            _loc2_.height = 40 * 34;
            _loc2_.name = "listBackdrop";
            this.list_sprite.addChild(_loc2_);
         }
         var _loc9_:int = 0;
         while(_loc9_ < 21)
         {
            _loc3_ = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("mission panel_00"));
            _loc3_.x = -221;
            _loc3_.y = -158 + _loc9_ * 32;
            _loc3_.touchable = _loc3_.useHandCursor = Stats.missionStats[Stats.missionList[_loc9_]].started;
            this.list_sprite.addChild(_loc3_);
            this.panel_array.push(_loc3_);
            if(Stats.missionStats[Stats.missionList[_loc9_]].started == true)
            {
               _loc4_ = Stats.missionStats[Stats.missionList[_loc9_]].completed == true ? "checkmark" : "x mark";
               _loc5_ = new Image(ItemMenu.itemMenu_textureAtlas.getTexture(_loc4_));
               _loc5_.x = 196;
               _loc5_.y = -144 + _loc9_ * 32;
               _loc5_.pivotX += _loc5_.width / 2;
               _loc5_.pivotY += _loc5_.height / 2;
               _loc5_.touchable = false;
               this.list_sprite.addChild(_loc5_);
            }
            _loc9_++;
         }
         var _loc10_:int = int(Stats.missionList.length);
         _loc9_ = 0;
         while(_loc9_ < _loc10_)
         {
            _loc6_ = Stats.missionStats[Stats.missionList[_loc9_]].started == true ? Stats.missionStats[Stats.missionList[_loc9_]].fname : "????";
            _loc7_ = new TextField(423,26,_loc6_,AllTextFormats.qualityOff_textFormat);
            _loc7_.x = -212;
            _loc7_.y = -156 + _loc9_ * 32;
            _loc7_.touchable = false;
            _loc7_.batchable = true;
            this.list_sprite.addChild(_loc7_);
            this.missionText_array.push(_loc7_);
            _loc9_++;
         }
         this.mission_txt.x = -212;
         this.mission_txt.y = 181;
         addChild(this.mission_txt);
         this.desc_txt.x = -241;
         this.desc_txt.y = 207;
         this.desc_txt.touchable = this.mission_txt.touchable = false;
         this.desc_txt.batchable = this.mission_txt.batchable = true;
         addChild(this.desc_txt);
         var _loc11_:Image = new Image(Texture.fromBitmapData(new BitmapData(458,36,false,16711680)));
         _loc11_.x = -263;
         _loc11_.y = -209;
         _loc11_.alpha = 0;
         _loc11_.name = "drag_image";
         addChild(_loc11_);
      }
      
      public function clickPanel(param1:Image) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = int(this.panel_array.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(this.panel_array[_loc4_] == param1)
            {
               _loc2_ = uint(_loc4_);
            }
            this.panel_array[_loc4_].texture = ItemMenu.itemMenu_textureAtlas.getTexture("mission panel_00");
            _loc4_++;
         }
         this.mission_txt.text = this.missionText_array[_loc2_].text;
         this.desc_txt.text = Stats.missionStats[this.mission_txt.text].desc + " (" + Stats.missionStats[this.mission_txt.text].worth + "xp)";
         param1.texture = ItemMenu.itemMenu_textureAtlas.getTexture("mission panel_01");
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
         this.list_sprite.y = Math.abs(CalcDist.getDistY(this.scroll_btn.y,194) * 0.95) - 324;
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
         if(this.list_sprite.y > -11 && param1 > 0)
         {
            this.list_sprite.y = -11;
         }
         if(this.list_sprite.y < -324 && param1 < 0)
         {
            this.list_sprite.y = -324;
         }
         this.mask_canvas.y -= this.list_sprite.y - _loc2_;
      }
   }
}

