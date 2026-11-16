package com.menus
{
   import com.game_objects.*;
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.ui.*;
   import com.visual_effects.*;
   import starling.display.*;
   import starling.events.*;
   import starling.text.*;
   import starling.textures.TextureAtlas;
   
   public final class TalkBox extends Sprite
   {
      
      public static var talkBox_textureAtlas:TextureAtlas;
      
      public var personClone:Person;
      
      public var talk_txt:TextField = new TextField(672,162,"MMMM",AllTextFormats.stats3_textFormat);
      
      public var fullText_string:String;
      
      private var __talkID:int;
      
      public function TalkBox(param1:GameMain, param2:String, param3:int, param4:Person, param5:Boolean, param6:Boolean, param7:Boolean)
      {
         var _loc8_:Button = null;
         var _loc9_:Button = null;
         var _loc10_:Button = null;
         _loc8_ = null;
         _loc9_ = null;
         _loc10_ = null;
         super();
         this.__talkID = param3;
         var _loc11_:Image = new Image(talkBox_textureAtlas.getTexture("panel"));
         _loc11_.x = -412;
         _loc11_.y = -104;
         addChild(_loc11_);
         if(param5)
         {
            _loc8_ = new Button(talkBox_textureAtlas.getTexture("next_btn_00"));
            _loc8_.x = 340;
            _loc8_.y = 104;
            _loc8_.pivotX = 76;
            _loc8_.pivotY = 22;
            _loc8_.scaleWhenOver = 0.95;
            _loc8_.name = "next_btn";
            addChild(_loc8_);
         }
         if(param6)
         {
            _loc9_ = new Button(talkBox_textureAtlas.getTexture("shop_btn_00"));
            _loc9_.x = 202;
            _loc9_.y = 104;
            _loc9_.pivotX = 56;
            _loc9_.pivotY = 22;
            _loc9_.scaleWhenOver = 0.95;
            _loc9_.name = "shop_btn";
            addChild(_loc9_);
         }
         if(param7)
         {
            _loc10_ = new Button(talkBox_textureAtlas.getTexture("sell_btn_00"));
            _loc10_.x = 81;
            _loc10_.y = 104;
            _loc10_.pivotX = 56;
            _loc10_.pivotY = 22;
            _loc10_.scaleWhenOver = 0.95;
            _loc10_.name = "sell_btn";
            addChild(_loc10_);
         }
         this.personClone = new Person(param1,false,param4.name);
         this.personClone.x = -339;
         this.personClone.y = -10;
         this.personClone.touchable = false;
         this.personClone.bodyAnimator.helmetString = param4.bodyAnimator.helmetString;
         this.personClone.bodyAnimator.hair = param4.bodyAnimator.hair;
         this.personClone.bodyAnimator.shirtString = param4.bodyAnimator.shirtString;
         this.personClone.bodyAnimator.pantsString = param4.bodyAnimator.pantsString;
         this.personClone.bodyAnimator.skin = param4.bodyAnimator.skin;
         this.personClone.bodyAnimator.weaponString = param4.bodyAnimator.weaponString;
         this.personClone.bodyAnimator.weapon2String = param4.bodyAnimator.weapon2String;
         this.personClone.bodyAnimator.accessoryString = param4.bodyAnimator.accessoryString;
         this.personClone.bodyAnimator.eyes = param4.bodyAnimator.eyes;
         this.personClone.bodyAnimator.beard = param4.bodyAnimator.beard;
         this.personClone.bodyAnimator.shoeString = param4.bodyAnimator.shoeString;
         addChild(this.personClone);
         this.talk_txt.x = -267;
         this.talk_txt.y = -87;
         this.talk_txt.touchable = false;
         this.talk_txt.text = param2;
         addChild(this.talk_txt);
         this.fullText_string = param2;
         TalkText.talk(this.talk_txt,1);
         addEventListener(Event.ENTER_FRAME,this.onEnter);
         TweenMax.from(this,0.4,{
            "scaleY":0.1,
            "ease":Back.easeOut
         });
      }
      
      private function onEnter(param1:Event) : void
      {
         this.personClone.bodyAnimator.onEnter();
         if(this.personClone.bodyAnimator.currentLabel != "standing")
         {
            this.personClone.bodyAnimator.gotoAndPlayInt(0);
         }
      }
      
      public function get talkID() : int
      {
         return this.__talkID;
      }
   }
}

