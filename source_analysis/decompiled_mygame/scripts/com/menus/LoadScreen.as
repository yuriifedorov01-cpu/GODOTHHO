package com.menus
{
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.utilities.*;
   import starling.core.*;
   import starling.display.*;
   import starling.text.*;
   import starling.textures.*;
   
   public final class LoadScreen extends Sprite
   {
      
      private const load_textFormat:TextFormat = new TextFormat(Assets.stats_font.name,19,16777215,"center","top");
      
      public const loadInfo_txt:TextField = new TextField(254,110,"",this.load_textFormat);
      
      private var ad_panel:Image;
      
      private var button:Button;
      
      private var gameMain:GameMain;
      
      public function LoadScreen(param1:GameMain)
      {
         var _loc2_:Number = NaN;
         _loc2_ = Number(NaN);
         var _loc3_:Image = null;
         super();
         this.gameMain = param1;
         _loc2_ = Starling.current.viewPort.height / 700;
         _loc3_ = new Image(Assets.main_assetManager.getTextureAtlas("load screen").getTexture("load screen"));
         _loc3_.width = Starling.current.viewPort.width / Starling.contentScaleFactor;
         _loc3_.height = Starling.current.viewPort.height / Starling.contentScaleFactor;
         _loc3_.textureSmoothing = TextureSmoothing.NONE;
         addChild(_loc3_);
         this.loadInfo_txt.x = Starling.current.viewPort.width / Starling.contentScaleFactor / 2 - this.loadInfo_txt.width / 2;
         this.loadInfo_txt.y = Starling.current.viewPort.height / Starling.contentScaleFactor / 2 - this.loadInfo_txt.height - 30 * _loc2_;
         this.loadInfo_txt.touchable = false;
         addChild(this.loadInfo_txt);
      }
      
      public function checkDisplayAd() : Boolean
      {
         if(this.gameMain.isPayingUser == false && this.gameMain.player.lev > 16 && this.gameMain.playingURL_string != "kongregate.com" && this.gameMain.playingURL_string != "steampowered.com")
         {
            if(Math.random() > 0.91)
            {
               this.ad_panel = new Image(Assets.main_assetManager.getTextureAtlas("load screen").getTexture("ad"));
               this.ad_panel.x = this.loadInfo_txt.x - 50;
               this.ad_panel.y = this.loadInfo_txt.y + 100;
               this.ad_panel.textureSmoothing = TextureSmoothing.NONE;
               this.ad_panel.touchable = false;
               addChild(this.ad_panel);
               TweenLite.from(this.ad_panel,0.4,{
                  "alpha":0,
                  "ease":Linear.easeNone
               });
               this.button = new Button(Assets.main_assetManager.getTextureAtlas("load screen").getTexture("earn"));
               this.button.x = this.ad_panel.x + 267;
               this.button.y = this.ad_panel.y + 203;
               this.button.pivotX = 32;
               this.button.pivotY = 15;
               this.button.textureSmoothing = TextureSmoothing.NONE;
               this.button.scaleWhenOver = 0.95;
               this.button.name = "buyPersonaly_btn";
               addChild(this.button);
               TweenLite.from(this.button,0.4,{
                  "alpha":0,
                  "ease":Linear.easeNone
               });
               return true;
            }
         }
         return false;
      }
      
      public function removeAd() : void
      {
         TweenLite.to(this.ad_panel,0.3,{
            "alpha":0,
            "ease":Linear.easeNone,
            "onComplete":this.ad_panel.removeFromParent,
            "onCompleteParams":[true]
         });
         TweenLite.to(this.button,0.3,{
            "alpha":0,
            "ease":Linear.easeNone,
            "onComplete":this.button.removeFromParent,
            "onCompleteParams":[true]
         });
      }
   }
}

