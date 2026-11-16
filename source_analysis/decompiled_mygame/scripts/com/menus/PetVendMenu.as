package com.menus
{
   import com.game_objects.*;
   import com.sound.*;
   import com.ui.*;
   import com.utilities.*;
   import feathers.controls.*;
   import flash.display.*;
   import starling.*;
   import starling.display.*;
   import starling.events.*;
   import starling.text.*;
   import starling.textures.*;
   
   public final class PetVendMenu extends StarlingGameMenu
   {
      
      private const vend_btn:Button = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("vend_btn_00"),"",null,ItemMenu.itemMenu_textureAtlas.getTexture("vend_btn_01"));
      
      public const coins_txt:TextInput = new TextInput();
      
      public const tickets_txt:TextInput = new TextInput();
      
      private var __currentVendor:PetVendor;
      
      private var __petName:String;
      
      private var petClone:Pet;
      
      public function PetVendMenu(param1:Pet, param2:PetVendor, param3:GameMain)
      {
         var _loc4_:Image = null;
         var _loc5_:Button = null;
         _loc4_ = null;
         _loc5_ = null;
         var _loc6_:TextField = null;
         super();
         this.__currentVendor = param2;
         this.__petName = param1.name;
         _loc4_ = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("pet vend panel"));
         _loc4_.x = -215;
         _loc4_.y = -124;
         addChild(_loc4_);
         _loc5_ = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_00"),"",null,ItemMenu.itemMenu_textureAtlas.getTexture("x_btn_01"));
         _loc5_.x = 240;
         _loc5_.y = -108;
         _loc5_.pivotX = 30;
         _loc5_.pivotY = 19;
         _loc5_.name = "x_btn";
         addChild(_loc5_);
         this.vend_btn.x = 150;
         this.vend_btn.y = 43;
         this.vend_btn.pivotX = 8;
         this.vend_btn.pivotY = 15;
         this.vend_btn.name = "petVendValid_btn";
         addChild(this.vend_btn);
         _loc6_ = new TextField(384,34,"VEND " + param1.name.toUpperCase(),AllTextFormats.title_textFormat);
         _loc6_.x = -180;
         _loc6_.y = -123;
         _loc6_.touchable = false;
         addChild(_loc6_);
         this.coins_txt.y = -51;
         this.coins_txt.name = this.coins_txt.textEditorProperties.name = "petCoins_txt";
         addChild(this.coins_txt);
         this.tickets_txt.x = this.coins_txt.x = 76;
         this.tickets_txt.y = -17;
         this.tickets_txt.width = this.coins_txt.width = 142;
         this.tickets_txt.height = this.coins_txt.height = 24;
         this.tickets_txt.restrict = this.coins_txt.restrict = "0-9";
         this.tickets_txt.textEditorProperties.fontFamily = this.coins_txt.textEditorProperties.fontFamily = "Arial";
         this.tickets_txt.textEditorProperties.fontSize = this.coins_txt.textEditorProperties.fontSize = 18;
         addChild(this.tickets_txt);
         this.petClone = new Pet(param3,"",param1.type);
         this.petClone.fitPreview(240,140);
         this.petClone.x = -131;
         this.petClone.y = 3;
         this.petClone.helmet_string = param1.helmet_string;
         this.petClone.shoes_string = param1.shoes_string;
         this.petClone.touchable = false;
         addChild(this.petClone);
         drag_image = new Image(Texture.fromBitmapData(new BitmapData(426,36,false,16711680)));
         drag_image.x = -216;
         drag_image.y = -125;
         drag_image.name = "drag_image";
         drag_image.alpha = 0;
         addChild(drag_image);
         addEventListener(Event.ENTER_FRAME,this.onEnter);
      }
      
      public function vendPet() : void
      {
         var _loc1_:Pet = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.coins_txt.text == "")
         {
            this.coins_txt.text = "0";
         }
         if(this.tickets_txt.text == "")
         {
            this.tickets_txt.text = "0";
         }
         if(this.currentVendor.petClone == null)
         {
            this.vend_btn.visible = false;
            MainStarlingStage(root).gameMain.theConnection.send("vendPet",this.petName,this.currentVendor.name,uint(this.coins_txt.text),uint(this.tickets_txt.text));
            _loc1_ = MainStarlingStage(root).gameMain.player.removePetFromMe(this.petName);
            if(_loc1_.height > _loc1_.width)
            {
               this.currentVendor.cage_image.texture = Assets.items_textureAtlas.getTexture("pet cage tall");
               this.currentVendor.cage_image.readjustSize();
               this.currentVendor.cage_image.x = -47;
               this.currentVendor.cage_image.y = -75;
            }
            this.currentVendor.showPet(_loc1_.type,_loc1_.helmet_uint,_loc1_.shoes_uint);
            this.currentVendor.coins = uint(this.coins_txt.text);
            this.currentVendor.tickets = uint(this.tickets_txt.text);
            if(StarlingGameMenu.menu_array.indexOf(MainStarlingStage(root).gameMain.petMenu) > -1)
            {
               StarlingGameMenu.focusMenu(MainStarlingStage(root).gameMain.petMenu);
               StarlingGameMenu.removeFocusMenu();
            }
            SoundManager.playSound(SoundLibrary.itemSold_sound);
            _loc2_ = int(PetOrb.petOrb_array.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if(PetOrb.petOrb_array[_loc3_].petName == _loc1_.name)
               {
                  PetOrb.petOrb_array[_loc3_].removeFromParent(true);
                  PetOrb.petOrb_array.removeAt(_loc3_);
                  break;
               }
               _loc3_++;
            }
            StarlingGameMenu.focusMenu(this);
            StarlingGameMenu.removeFocusMenu();
         }
         else
         {
            MainStarlingStage(root).gameMain.createAlert("There is already a pet here");
         }
      }
      
      private function onEnter(param1:Event) : void
      {
         if(this.petClone != null && this.petClone.parent != null)
         {
            this.petClone.nextFrame();
            if(this.petClone.currentLabel != "standing")
            {
               this.petClone.gotoAndPlayStanding();
            }
         }
      }
      
      public function get currentVendor() : PetVendor
      {
         return this.__currentVendor;
      }
      
      public function get petName() : String
      {
         return this.__petName;
      }
   }
}

