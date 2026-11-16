package feathers.controls.supportClasses
{
   import feathers.controls.*;
   import feathers.core.*;
   import starling.display.DisplayObject;
   
   public class LayoutViewPort extends LayoutGroup implements IViewPort
   {
      
      private var _minVisibleWidth:Number = 0;
      
      private var _maxVisibleWidth:Number = Infinity;
      
      private var _actualVisibleWidth:Number = 0;
      
      private var _explicitVisibleWidth:Number = NaN;
      
      private var _minVisibleHeight:Number = 0;
      
      private var _maxVisibleHeight:Number = Infinity;
      
      private var _actualVisibleHeight:Number = 0;
      
      private var _explicitVisibleHeight:Number = NaN;
      
      private var _contentX:Number = 0;
      
      private var _contentY:Number = 0;
      
      private var _horizontalScrollPosition:Number = 0;
      
      private var _verticalScrollPosition:Number = 0;
      
      public function LayoutViewPort()
      {
         super();
      }
      
      public function get minVisibleWidth() : Number
      {
         return this._minVisibleWidth;
      }
      
      public function set minVisibleWidth(param1:Number) : void
      {
         if(this._minVisibleWidth == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("minVisibleWidth cannot be NaN");
         }
         this._minVisibleWidth = param1;
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      public function get maxVisibleWidth() : Number
      {
         return this._maxVisibleWidth;
      }
      
      public function set maxVisibleWidth(param1:Number) : void
      {
         if(this._maxVisibleWidth == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("maxVisibleWidth cannot be NaN");
         }
         this._maxVisibleWidth = param1;
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      public function get visibleWidth() : Number
      {
         if(this._explicitVisibleWidth !== this._explicitVisibleWidth)
         {
            return this._actualVisibleWidth;
         }
         return this._explicitVisibleWidth;
      }
      
      public function set visibleWidth(param1:Number) : void
      {
         if(this._explicitVisibleWidth == param1 || param1 !== param1 && this._explicitVisibleWidth !== this._explicitVisibleWidth)
         {
            return;
         }
         this._explicitVisibleWidth = param1;
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      public function get minVisibleHeight() : Number
      {
         return this._minVisibleHeight;
      }
      
      public function set minVisibleHeight(param1:Number) : void
      {
         if(this._minVisibleHeight == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("minVisibleHeight cannot be NaN");
         }
         this._minVisibleHeight = param1;
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      public function get maxVisibleHeight() : Number
      {
         return this._maxVisibleHeight;
      }
      
      public function set maxVisibleHeight(param1:Number) : void
      {
         if(this._maxVisibleHeight == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("maxVisibleHeight cannot be NaN");
         }
         this._maxVisibleHeight = param1;
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      public function get visibleHeight() : Number
      {
         if(this._explicitVisibleHeight !== this._explicitVisibleHeight)
         {
            return this._actualVisibleHeight;
         }
         return this._explicitVisibleHeight;
      }
      
      public function set visibleHeight(param1:Number) : void
      {
         if(this._explicitVisibleHeight == param1 || param1 !== param1 && this._explicitVisibleHeight !== this._explicitVisibleHeight)
         {
            return;
         }
         this._explicitVisibleHeight = param1;
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      public function get contentX() : Number
      {
         return this._contentX;
      }
      
      public function get contentY() : Number
      {
         return this._contentY;
      }
      
      public function get horizontalScrollStep() : Number
      {
         if(this.actualWidth < this.actualHeight)
         {
            return this.actualWidth / 10;
         }
         return this.actualHeight / 10;
      }
      
      public function get verticalScrollStep() : Number
      {
         if(this.actualWidth < this.actualHeight)
         {
            return this.actualWidth / 10;
         }
         return this.actualHeight / 10;
      }
      
      public function get horizontalScrollPosition() : Number
      {
         return this._horizontalScrollPosition;
      }
      
      public function set horizontalScrollPosition(param1:Number) : void
      {
         if(this._horizontalScrollPosition == param1)
         {
            return;
         }
         this._horizontalScrollPosition = param1;
         this.invalidate(INVALIDATION_FLAG_SCROLL);
      }
      
      public function get verticalScrollPosition() : Number
      {
         return this._verticalScrollPosition;
      }
      
      public function set verticalScrollPosition(param1:Number) : void
      {
         if(this._verticalScrollPosition == param1)
         {
            return;
         }
         this._verticalScrollPosition = param1;
         this.invalidate(INVALIDATION_FLAG_SCROLL);
      }
      
      override public function dispose() : void
      {
         this.layout = null;
         super.dispose();
      }
      
      override protected function refreshViewPortBounds() : void
      {
         this.viewPortBounds.x = 0;
         this.viewPortBounds.y = 0;
         this.viewPortBounds.scrollX = this._horizontalScrollPosition;
         this.viewPortBounds.scrollY = this._verticalScrollPosition;
         if(this._autoSizeMode == AutoSizeMode.STAGE && this._explicitVisibleWidth !== this._explicitVisibleWidth)
         {
            this.viewPortBounds.explicitWidth = this.stage.stageWidth;
         }
         else
         {
            this.viewPortBounds.explicitWidth = this._explicitVisibleWidth;
         }
         if(this._autoSizeMode == AutoSizeMode.STAGE && this._explicitVisibleHeight !== this._explicitVisibleHeight)
         {
            this.viewPortBounds.explicitHeight = this.stage.stageHeight;
         }
         else
         {
            this.viewPortBounds.explicitHeight = this._explicitVisibleHeight;
         }
         this.viewPortBounds.minWidth = this._minVisibleWidth;
         this.viewPortBounds.minHeight = this._minVisibleHeight;
         this.viewPortBounds.maxWidth = this._maxVisibleWidth;
         this.viewPortBounds.maxHeight = this._maxVisibleHeight;
      }
      
      override protected function handleLayoutResult() : void
      {
         this.setSizeInternal(this._layoutResult.contentWidth,this._layoutResult.contentHeight,false);
         this._contentX = this._layoutResult.contentX;
         this._contentY = this._layoutResult.contentY;
         this._actualVisibleWidth = this._layoutResult.viewPortWidth;
         this._actualVisibleHeight = this._layoutResult.viewPortHeight;
      }
      
      override protected function handleManualLayout() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:Number = Number(NaN);
         var _loc3_:Number = Number(NaN);
         var _loc4_:Number = Number(NaN);
         var _loc5_:Number = Number(NaN);
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         var _loc8_:Number = this.viewPortBounds.explicitWidth;
         var _loc9_:Number = _loc8_;
         this.doNothing();
         if(_loc9_ !== _loc9_)
         {
            _loc9_ = 0;
         }
         var _loc10_:Number = this.viewPortBounds.explicitHeight;
         var _loc11_:Number = _loc10_;
         this.doNothing();
         if(_loc11_ !== _loc11_)
         {
            _loc11_ = 0;
         }
         this._ignoreChildChanges = true;
         var _loc12_:int = int(this.items.length);
         var _loc13_:int = 0;
         while(_loc13_ < _loc12_)
         {
            _loc1_ = this.items[_loc13_];
            if(_loc1_ is IValidating)
            {
               IValidating(_loc1_).validate();
            }
            _loc2_ = _loc1_.x;
            _loc3_ = _loc1_.y;
            _loc4_ = _loc2_ + _loc1_.width;
            _loc5_ = _loc3_ + _loc1_.height;
            if(_loc2_ === _loc2_ && _loc2_ < _loc6_)
            {
               _loc6_ = _loc2_;
            }
            if(_loc3_ === _loc3_ && _loc3_ < _loc7_)
            {
               _loc7_ = _loc3_;
            }
            if(_loc4_ === _loc4_ && _loc4_ > _loc9_)
            {
               _loc9_ = _loc4_;
            }
            if(_loc5_ === _loc5_ && _loc5_ > _loc11_)
            {
               _loc11_ = _loc5_;
            }
            _loc13_++;
         }
         this._contentX = _loc6_;
         this._contentY = _loc7_;
         var _loc14_:Number = this.viewPortBounds.minWidth;
         var _loc15_:Number = this.viewPortBounds.maxWidth;
         var _loc16_:Number = this.viewPortBounds.minHeight;
         var _loc17_:Number = this.viewPortBounds.maxHeight;
         var _loc18_:Number = _loc9_ - _loc6_;
         if(_loc18_ < _loc14_)
         {
            _loc18_ = _loc14_;
         }
         else if(_loc18_ > _loc15_)
         {
            _loc18_ = _loc15_;
         }
         var _loc19_:Number = _loc11_ - _loc7_;
         if(_loc19_ < _loc16_)
         {
            _loc19_ = _loc16_;
         }
         else if(_loc19_ > _loc17_)
         {
            _loc19_ = _loc17_;
         }
         this._ignoreChildChanges = false;
         if(_loc8_ !== _loc8_)
         {
            this._actualVisibleWidth = _loc18_;
         }
         else
         {
            this._actualVisibleWidth = _loc8_;
         }
         if(_loc10_ !== _loc10_)
         {
            this._actualVisibleHeight = _loc19_;
         }
         else
         {
            this._actualVisibleHeight = _loc10_;
         }
         this._layoutResult.contentX = 0;
         this._layoutResult.contentY = 0;
         this._layoutResult.contentWidth = _loc18_;
         this._layoutResult.contentHeight = _loc19_;
         this._layoutResult.viewPortWidth = _loc18_;
         this._layoutResult.viewPortHeight = _loc19_;
      }
      
      protected function doNothing() : void
      {
      }
   }
}

