package fl.controls
{
   import fl.core.*;
   import fl.events.*;
   import flash.events.*;
   import flash.text.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol562")]
   public class UIScrollBar extends ScrollBar
   {
      
      private static var defaultStyles:Object = {};
      
      protected var inEdit:Boolean = false;
      
      protected var inScroll:Boolean = false;
      
      protected var _scrollTarget:TextField;
      
      public function UIScrollBar()
      {
         super();
      }
      
      public static function getStyleDefinition() : Object
      {
         return UIComponent.mergeStyles(defaultStyles,ScrollBar.getStyleDefinition());
      }
      
      protected function updateScrollTargetProperties() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Number = Number(NaN);
         if(this._scrollTarget == null)
         {
            this.setScrollProperties(pageSize,minScrollPosition,maxScrollPosition,pageScrollSize);
            scrollPosition = 0;
         }
         else
         {
            _loc1_ = this.direction == ScrollBarDirection.HORIZONTAL;
            _loc2_ = _loc1_ ? this._scrollTarget.width : 10;
            this.setScrollProperties(_loc2_,_loc1_ ? 0 : 1,_loc1_ ? this._scrollTarget.maxScrollH : this._scrollTarget.maxScrollV,pageScrollSize);
            scrollPosition = _loc1_ ? this._scrollTarget.scrollH : this._scrollTarget.scrollV;
         }
      }
      
      override public function setScrollProperties(param1:Number, param2:Number, param3:Number, param4:Number = 0) : void
      {
         var _loc5_:Number = param3;
         var _loc6_:Number = param2 < 0 ? 0 : param2;
         if(this._scrollTarget != null)
         {
            if(this.direction == ScrollBarDirection.HORIZONTAL)
            {
               _loc5_ = param3 > this._scrollTarget.maxScrollH ? this._scrollTarget.maxScrollH : _loc5_;
            }
            else
            {
               _loc5_ = param3 > this._scrollTarget.maxScrollV ? this._scrollTarget.maxScrollV : _loc5_;
            }
         }
         super.setScrollProperties(param1,_loc6_,_loc5_,param4);
      }
      
      protected function handleTargetScroll(param1:Event) : void
      {
         if(inDrag)
         {
            return;
         }
         if(!enabled)
         {
            return;
         }
         this.inEdit = true;
         this.updateScrollTargetProperties();
         scrollPosition = this.direction == ScrollBarDirection.HORIZONTAL ? this._scrollTarget.scrollH : this._scrollTarget.scrollV;
         this.inEdit = false;
      }
      
      override public function setScrollPosition(param1:Number, param2:Boolean = true) : void
      {
         super.setScrollPosition(param1,param2);
         if(!this._scrollTarget)
         {
            this.inScroll = false;
            return;
         }
         this.updateTargetScroll();
      }
      
      public function get scrollTargetName() : String
      {
         return this._scrollTarget.name;
      }
      
      override protected function draw() : void
      {
         if(isInvalid(InvalidationType.DATA))
         {
            this.updateScrollTargetProperties();
         }
         super.draw();
      }
      
      override public function set direction(param1:String) : void
      {
         if(isLivePreview)
         {
            return;
         }
         super.direction = param1;
         this.updateScrollTargetProperties();
      }
      
      protected function updateTargetScroll(param1:ScrollEvent = null) : void
      {
         if(this.inEdit)
         {
            return;
         }
         if(this.direction == ScrollBarDirection.HORIZONTAL)
         {
            this._scrollTarget.scrollH = scrollPosition;
         }
         else
         {
            this._scrollTarget.scrollV = scrollPosition;
         }
      }
      
      override public function set minScrollPosition(param1:Number) : void
      {
         super.minScrollPosition = param1 < 0 ? 0 : param1;
      }
      
      override public function set maxScrollPosition(param1:Number) : void
      {
         var _loc2_:Number = param1;
         if(this._scrollTarget != null)
         {
            if(this.direction == ScrollBarDirection.HORIZONTAL)
            {
               _loc2_ = _loc2_ > this._scrollTarget.maxScrollH ? this._scrollTarget.maxScrollH : _loc2_;
            }
            else
            {
               _loc2_ = _loc2_ > this._scrollTarget.maxScrollV ? this._scrollTarget.maxScrollV : _loc2_;
            }
         }
         super.maxScrollPosition = _loc2_;
      }
      
      protected function handleTargetChange(param1:Event) : void
      {
         this.inEdit = true;
         this.setScrollPosition(this.direction == ScrollBarDirection.HORIZONTAL ? this._scrollTarget.scrollH : this._scrollTarget.scrollV,true);
         this.updateScrollTargetProperties();
         this.inEdit = false;
      }
      
      public function update() : void
      {
         this.inEdit = true;
         this.updateScrollTargetProperties();
         this.inEdit = false;
      }
      
      public function set scrollTargetName(param1:String) : void
      {
         var target:String = param1;
         try
         {
            this.scrollTarget = parent.getChildByName(target) as TextField;
         }
         catch(error:Error)
         {
            throw new Error("ScrollTarget not found, or is not a TextField");
         }
      }
      
      public function set scrollTarget(param1:TextField) : void
      {
         if(this._scrollTarget != null)
         {
            this._scrollTarget.removeEventListener(Event.CHANGE,this.handleTargetChange,false);
            this._scrollTarget.removeEventListener(TextEvent.TEXT_INPUT,this.handleTargetChange,false);
            this._scrollTarget.removeEventListener(Event.SCROLL,this.handleTargetScroll,false);
            removeEventListener(ScrollEvent.SCROLL,this.updateTargetScroll,false);
         }
         this._scrollTarget = param1;
         if(this._scrollTarget != null)
         {
            this._scrollTarget.addEventListener(Event.CHANGE,this.handleTargetChange,false,0,true);
            this._scrollTarget.addEventListener(TextEvent.TEXT_INPUT,this.handleTargetChange,false,0,true);
            this._scrollTarget.addEventListener(Event.SCROLL,this.handleTargetScroll,false,0,true);
            addEventListener(ScrollEvent.SCROLL,this.updateTargetScroll,false,0,true);
         }
         invalidate(InvalidationType.DATA);
      }
      
      public function get scrollTarget() : TextField
      {
         return this._scrollTarget;
      }
      
      override public function get direction() : String
      {
         return super.direction;
      }
   }
}

