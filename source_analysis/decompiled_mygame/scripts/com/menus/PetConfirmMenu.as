package com.menus
{
   import com.game_objects.*;
   import com.stats.*;
   import com.ui.*;
   import com.utilities.*;
   import feathers.controls.*;
   import flash.display.*;
   import playerio.Message;
   import starling.*;
   import starling.display.*;
   import starling.events.*;
   import starling.text.*;
   import starling.textures.*;
   
   public final class PetConfirmMenu extends StarlingGameMenu
   {
      
      private const buy_btn:Button = new Button(ItemMenu.itemMenu_textureAtlas.getTexture("buy_btn"));
      
      private const valid_txt:TextField = new TextField(432,21,"",AllTextFormats.valid_textFormat);
      
      private const name_txt:TextInput = new TextInput();
      
      private var petClone:Pet;
      
      public function PetConfirmMenu(param1:String, param2:GameMain)
      {
         var _loc4_:Button = null;
         var _loc5_:TextField = null;
         var _loc3_:Image = null;
         _loc4_ = null;
         super();
         _loc3_ = new Image(ItemMenu.itemMenu_textureAtlas.getTexture("pet confirm panel"));
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
         this.buy_btn.x = 178;
         this.buy_btn.y = 161;
         this.buy_btn.pivotX = 33;
         this.buy_btn.pivotY = 15;
         this.buy_btn.name = "buyPetValid_btn";
         addChild(this.buy_btn);
         _loc5_ = new TextField(384,34,"PURCHASE " + param1.toUpperCase(),AllTextFormats.title_textFormat);
         _loc5_.x = -180;
         _loc5_.y = -123;
         _loc5_.touchable = false;
         addChild(_loc5_);
         this.valid_txt.x = -201;
         this.valid_txt.y = 105;
         this.valid_txt.touchable = false;
         addChild(this.valid_txt);
         this.name_txt.x = -94;
         this.name_txt.y = 48;
         this.name_txt.width = 241;
         this.name_txt.height = 27;
         this.name_txt.maxChars = 20;
         this.name_txt.textEditorProperties.fontFamily = "Arial";
         this.name_txt.textEditorProperties.fontSize = 18;
         this.name_txt.name = this.name_txt.textEditorProperties.name = "petName_txt";
         addChild(this.name_txt);
         this.petClone = new Pet(param2,"",param1);
         this.petClone.fitPreview(300,150);
         this.petClone.x = 13;
         this.petClone.y = -3;
         this.petClone.touchable = false;
         addChild(this.petClone);
         drag_image = new Image(Texture.fromBitmapData(new BitmapData(426,36,false,16711680)));
         drag_image.x = -216;
         drag_image.y = -125;
         drag_image.name = "drag_image";
         drag_image.alpha = 0;
         addChild(drag_image);
         addEventListener(Event.ENTER_FRAME,this.onEnter);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
      }
      
      public function buyPet() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Person = MainStarlingStage(root).gameMain.player;
         if(_loc2_.money >= Stats.petStats[this.petClone.type].cost)
         {
            _loc1_ = 0;
            if(_loc2_.pet_array.length == 0)
            {
               _loc1_ = 0;
            }
            else if(_loc2_.pet_array[0].isCompanion && _loc2_.pet_array.length == MainStarlingStage(root).gameMain.maxPets)
            {
               _loc1_ = 2;
            }
            else if(_loc2_.pet_array[0].isCompanion == false && _loc2_.pet_array.length == MainStarlingStage(root).gameMain.maxPets - 1)
            {
               _loc1_ = 1;
            }
            if(CussFilter.checkString(this.name_txt.text) != "")
            {
               this.valid_txt.text = "Cannot use profanity in pet name";
            }
            else if(this.name_txt.text.search(MainStarlingStage(root).gameMain.validString) != -1)
            {
               this.valid_txt.text = "pet name contains invalid characters";
            }
            else if(this.name_txt.text != "" && _loc1_ == 0)
            {
               MainStarlingStage(root).gameMain.theConnection.addMessageHandler("validatePet",this.gotPetValidate);
               MainStarlingStage(root).gameMain.theConnection.send("buyPet",this.name_txt.text,this.petClone.type);
               this.buy_btn.visible = false;
            }
            else if(_loc1_ != 0)
            {
               MainStarlingStage(root).gameMain.createAlert("You cannot carry any more pets");
            }
            else
            {
               this.valid_txt.text = "Please enter a pet name";
            }
         }
         else if(_loc1_ != 0)
         {
            MainStarlingStage(root).gameMain.createAlert("You cannot carry any more pets");
         }
         else
         {
            MainStarlingStage(root).gameMain.createAlert("You do not have enough money to buy a " + this.petClone.type);
         }
      }
      
      private function gotPetValidate(param1:Message, param2:Boolean, param3:String = "", param4:String = "") : void
      {
         var _loc5_:Pet = null;
         if(param2)
         {
            MainStarlingStage(root).gameMain.player.money = MainStarlingStage(root).gameMain.player.money - Stats.petStats[param4].cost;
            MainStarlingStage(root).gameMain.createAlert("You have purchased a " + param4 + " named " + param3 + "!",true);
            if(StarlingGameMenu.getFocusMenu() is PetConfirmMenu)
            {
               StarlingGameMenu.removeFocusMenu();
            }
            _loc5_ = MainStarlingStage(root).gameMain.createPet(false,MainStarlingStage(root).gameMain.player,param3,param4,Stats.petStats[param4].health,Stats.petStats[param4].health,Stats.petStats[param4].power,Stats.petStats[param4].dex,Stats.petStats[param4].defense,20,"n",2);
            _loc5_.shoes_uint = 1;
         }
         else if(parent != null)
         {
            this.buy_btn.visible = true;
            if(param3 == "money")
            {
               this.valid_txt.text = "You do not have enough money for this pet";
            }
            else
            {
               this.valid_txt.text = "Pet name has already been taken, try another name";
            }
         }
         MainStarlingStage(root).gameMain.theConnection.removeMessageHandler("validatePet",this.gotPetValidate);
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
      
      private function onRemoved(param1:Event) : void
      {
         MainStarlingStage(root).gameMain.theConnection.removeMessageHandler("validatePet",this.gotPetValidate);
      }
   }
}

