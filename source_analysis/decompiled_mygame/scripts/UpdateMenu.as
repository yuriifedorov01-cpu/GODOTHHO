package
{
   import fl.controls.UIScrollBar;
   import flash.accessibility.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.engine.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol563")]
   public dynamic class UpdateMenu extends MovieClip
   {
      
      public var agreement_scrollBar:UIScrollBar;
      
      public var agreement_txt:TextField;
      
      public var closeUpdates_btn:SimpleButton;
      
      public var __setPropDict:Dictionary = new Dictionary(true);
      
      public function UpdateMenu()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      internal function __setProp_agreement_scrollBar_updatemenu_text_1() : *
      {
         if(this.__setPropDict[this.agreement_scrollBar] == undefined || int(this.__setPropDict[this.agreement_scrollBar]) != 2)
         {
            this.__setPropDict[this.agreement_scrollBar] = 2;
            try
            {
               this.agreement_scrollBar["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            }
            this.agreement_scrollBar.direction = "vertical";
            this.agreement_scrollBar.scrollTargetName = "agreement_txt";
            this.agreement_scrollBar.visible = true;
            try
            {
               this.agreement_scrollBar["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            }
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         this.__setProp_agreement_scrollBar_updatemenu_text_1();
      }
   }
}

