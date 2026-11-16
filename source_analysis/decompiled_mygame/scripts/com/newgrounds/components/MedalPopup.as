package com.newgrounds.components
{
   import com.newgrounds.*;
   import flash.accessibility.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4178")]
   public dynamic class MedalPopup extends MovieClip
   {
      
      public var medalPointsText:TextField;
      
      public var medalIcon:MovieClip;
      
      public var _unlockedMedal:Medal;
      
      public var medalNameClip:MovieClip;
      
      public var alwaysOnTop:String;
      
      public var _alwaysOnTop:Boolean;
      
      public var _medalScrollRect:Rectangle;
      
      public var _medalQueue:Array;
      
      public function MedalPopup()
      {
         super();
         addFrameScript(0,this.frame1,14,this.frame15,22,this.frame23,83,this.frame84,104,this.frame105);
      }
      
      public function medalPopupEnterFrame(param1:Event) : void
      {
         var topIndex:uint = 0;
         var event:Event = param1;
         if(this._alwaysOnTop)
         {
            try
            {
               if(parent)
               {
                  topIndex = parent.numChildren - 1;
                  if(parent.getChildIndex(this) != topIndex)
                  {
                     parent.setChildIndex(this,topIndex);
                  }
               }
            }
            catch(error:*)
            {
               removeEventListener(Event.ENTER_FRAME,medalPopupEnterFrame);
            }
         }
         if(this._medalScrollRect)
         {
            this._medalScrollRect.offset(2,0);
            this.medalNameClip.scrollRect = this._medalScrollRect;
            if(this._medalScrollRect.left >= this.medalNameClip.textField.textWidth + 10)
            {
               this._medalScrollRect = null;
               play();
            }
         }
      }
      
      internal function frame15() : *
      {
         if(this._unlockedMedal)
         {
            if(Boolean(this.medalNameClip) && Boolean(this.medalNameClip.textField))
            {
               this.medalNameClip.textField.text = this._unlockedMedal.name;
            }
            if(this.medalPointsText)
            {
               this.medalPointsText.text = this._unlockedMedal.value.toString();
            }
            if(this.medalNameClip.textField.textWidth > this.medalNameClip.width)
            {
               this._medalScrollRect = new Rectangle(-this.medalNameClip.width,0,this.medalNameClip.width,this.medalNameClip.height);
               this.medalNameClip.textField.width = 1000;
               this.medalNameClip.scrollRect = this._medalScrollRect;
            }
            addEventListener(Event.ENTER_FRAME,this.medalPopupEnterFrame);
         }
      }
      
      public function onMedalUnlocked(param1:APIEvent) : void
      {
         if(param1.success)
         {
            this._medalQueue.push(param1.data);
            this.showNextUnlock();
         }
      }
      
      internal function frame84() : *
      {
         if(this._medalScrollRect)
         {
            stop();
         }
      }
      
      internal function frame1() : *
      {
         gotoAndStop("hidden");
         API.addEventListener(APIEvent.MEDAL_UNLOCKED,this.onMedalUnlocked);
         x = int(x);
         y = int(y);
         this._medalQueue = [];
         this._alwaysOnTop = true;
         if(this.alwaysOnTop)
         {
            this._alwaysOnTop = this.alwaysOnTop == "true";
         }
      }
      
      internal function frame23() : *
      {
         if(Boolean(this._unlockedMedal) && Boolean(this.medalIcon))
         {
            this._unlockedMedal.attachIcon(this.medalIcon);
         }
      }
      
      public function showNextUnlock() : void
      {
         if(this._unlockedMedal)
         {
            return;
         }
         if(!this._medalQueue.length)
         {
            gotoAndStop("hidden");
            removeEventListener(Event.ENTER_FRAME,this.medalPopupEnterFrame);
            return;
         }
         this._unlockedMedal = Medal(this._medalQueue.shift());
         gotoAndPlay("medalUnlocked");
      }
      
      internal function frame105() : *
      {
         stop();
         this._unlockedMedal = null;
         this.showNextUnlock();
      }
   }
}

