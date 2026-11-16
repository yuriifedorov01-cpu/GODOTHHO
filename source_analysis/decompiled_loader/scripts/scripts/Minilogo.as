package
{
   import fl.transitions.Tween;
   import fl.transitions.TweenEvent;
   import fl.transitions.easing.Strong;
   import flash.display.MovieClip;
   import flash.display.StageAlign;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.BlurFilter;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.setTimeout;
   import playerio.utils.SWFReader;
   
   public class Minilogo extends MovieClip
   {
      
      public static var showLogo:Boolean = true;
      
      private var align:String;
      
      private var t:Tween;
      
      private var rect:Rectangle;
      
      public function Minilogo(param1:String = "BC")
      {
         var _loc2_:MovieClip = null;
         super();
         this.align = param1;
         this.alpha = 0;
         this.buttonMode = true;
         addEventListener(Event.ADDED_TO_STAGE,this.handleAttach);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.handleClick);
         Minilogo.showLogo = false;
      }
      
      private function handleClick(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         e.preventDefault();
         e.stopImmediatePropagation();
         try
         {
            navigateToURL(new URLRequest("http://playerio.com/?ref=gamelogo"),"_new");
         }
         catch(e:Error)
         {
            trace("Error occurred!");
         }
      }
      
      private function handleResize(param1:Event = null) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.parent)
         {
            _loc2_ = 0;
            _loc3_ = 0;
            if(stage.scaleMode == "noScale")
            {
               switch(stage.align)
               {
                  case "":
                     _loc2_ = -(stage.stageWidth - this.rect.width) / 2;
                     _loc3_ = -(stage.stageHeight - this.rect.height) / 2;
                     break;
                  case StageAlign.TOP:
                     _loc2_ = -(stage.stageWidth - this.rect.width) / 2;
               }
            }
            switch(this.align)
            {
               case "TL":
                  this.x = _loc2_ + 140;
                  this.y = _loc3_ + 45;
                  break;
               case "CL":
                  this.x = _loc2_ + 140;
                  this.y = _loc3_ + stage.stageHeight / 2;
                  break;
               case "BL":
                  this.x = _loc2_ + 140;
                  this.y = _loc3_ + stage.stageHeight - 45;
                  break;
               case "TC":
                  this.x = _loc2_ + stage.stageWidth / 2;
                  this.y = _loc3_ + 45;
                  break;
               case "CC":
                  this.x = _loc2_ + stage.stageWidth / 2;
                  this.y = _loc3_ + stage.stageHeight / 2;
                  break;
               default:
                  this.x = _loc2_ + stage.stageWidth / 2;
                  this.y = _loc3_ + stage.stageHeight - 45;
                  break;
               case "TR":
                  this.x = _loc2_ + stage.stageWidth - 140;
                  this.y = _loc3_ + 45;
                  break;
               case "CR":
                  this.x = _loc2_ + stage.stageWidth - 140;
                  this.y = _loc3_ + stage.stageHeight / 2;
                  break;
               case "BR":
                  this.x = _loc2_ + stage.stageWidth - 140;
                  this.y = _loc3_ + stage.stageHeight - 45;
            }
         }
      }
      
      private function handleEnterFrame(param1:Event) : void
      {
         if(stage.getChildAt(stage.numChildren - 1) != this)
         {
            stage.addChild(this);
         }
      }
      
      private function handleAttach(param1:Event) : void
      {
         if((stage.loaderInfo as Object).hasOwnProperty("bytes"))
         {
            this.rect = new SWFReader((stage.loaderInfo as Object).bytes).dimensions;
         }
         else
         {
            this.rect = new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
         }
         stage.addEventListener(Event.RESIZE,this.handleResize);
         this.handleResize();
         this.t = new Tween(this,"alpha",Strong.easeIn,0,1,0.5,true);
         this.t.addEventListener(TweenEvent.MOTION_FINISH,this.handleCreated);
         this.t.addEventListener(TweenEvent.MOTION_CHANGE,this.handleTick);
         addEventListener(Event.ENTER_FRAME,this.handleEnterFrame);
      }
      
      private function handleCreated(param1:TweenEvent) : void
      {
         setTimeout(this.doRemove,3000);
      }
      
      private function handleTick(param1:Event) : void
      {
         this.filters = [new BlurFilter((1 - this.alpha) * 100,(1 - this.alpha) * 10)];
      }
      
      private function doRemove() : void
      {
         this.t = new Tween(this,"alpha",Strong.easeIn,1,0,0.5,true);
         this.t.addEventListener(TweenEvent.MOTION_CHANGE,this.handleTick);
         this.t.addEventListener(TweenEvent.MOTION_FINISH,this.kill);
         removeEventListener(Event.ENTER_FRAME,this.handleEnterFrame);
         stage.removeEventListener(Event.RESIZE,this.handleResize);
      }
      
      private function kill(param1:Event) : void
      {
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}

