package feathers.controls
{
   import feathers.core.*;
   import feathers.events.*;
   import feathers.layout.*;
   import feathers.skins.IStyleProvider;
   import flash.geom.*;
   import starling.display.*;
   import starling.events.*;
   import starling.rendering.*;
   
   public class LayoutGroup extends FeathersControl
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      private static const HELPER_RECTANGLE:Rectangle = new Rectangle();
      
      protected static const INVALIDATION_FLAG_CLIPPING:String = "clipping";
      
      public static const AUTO_SIZE_MODE_STAGE:String = "stage";
      
      public static const AUTO_SIZE_MODE_CONTENT:String = "content";
      
      public static const ALTERNATE_STYLE_NAME_TOOLBAR:String = "feathers-toolbar-layout-group";
      
      protected var items:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      protected var viewPortBounds:ViewPortBounds = new ViewPortBounds();
      
      protected var _layoutResult:LayoutBoundsResult = new LayoutBoundsResult();
      
      protected var _layout:ILayout;
      
      protected var _clipContent:Boolean = false;
      
      protected var originalBackgroundWidth:Number = NaN;
      
      protected var originalBackgroundHeight:Number = NaN;
      
      protected var _backgroundSkinPushToken:BatchToken = new BatchToken();
      
      protected var _backgroundSkinPopToken:BatchToken = new BatchToken();
      
      protected var currentBackgroundSkin:DisplayObject;
      
      protected var _backgroundSkin:DisplayObject;
      
      protected var _backgroundDisabledSkin:DisplayObject;
      
      protected var _autoSizeMode:String = "content";
      
      protected var _ignoreChildChanges:Boolean = false;
      
      public function LayoutGroup()
      {
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.layoutGroup_addedToStageHandler);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.layoutGroup_removedFromStageHandler);
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return LayoutGroup.globalStyleProvider;
      }
      
      public function get layout() : ILayout
      {
         return this._layout;
      }
      
      public function set layout(param1:ILayout) : void
      {
         if(this._layout == param1)
         {
            return;
         }
         if(this._layout)
         {
            this._layout.removeEventListener(Event.CHANGE,this.layout_changeHandler);
         }
         this._layout = param1;
         if(this._layout)
         {
            if(this._layout is IVirtualLayout)
            {
               IVirtualLayout(this._layout).useVirtualLayout = false;
            }
            this._layout.addEventListener(Event.CHANGE,this.layout_changeHandler);
            this.invalidate(INVALIDATION_FLAG_LAYOUT);
         }
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      public function get clipContent() : Boolean
      {
         return this._clipContent;
      }
      
      public function set clipContent(param1:Boolean) : void
      {
         if(this._clipContent == param1)
         {
            return;
         }
         this._clipContent = param1;
         if(!param1)
         {
            this.mask = null;
         }
         this.invalidate(INVALIDATION_FLAG_CLIPPING);
      }
      
      public function get backgroundSkin() : DisplayObject
      {
         return this._backgroundSkin;
      }
      
      public function set backgroundSkin(param1:DisplayObject) : void
      {
         if(this._backgroundSkin == param1)
         {
            return;
         }
         if(Boolean(param1) && Boolean(param1.parent))
         {
            param1.removeFromParent();
         }
         this._backgroundSkin = param1;
         this.invalidate(INVALIDATION_FLAG_SKIN);
      }
      
      public function get backgroundDisabledSkin() : DisplayObject
      {
         return this._backgroundDisabledSkin;
      }
      
      public function set backgroundDisabledSkin(param1:DisplayObject) : void
      {
         if(this._backgroundDisabledSkin == param1)
         {
            return;
         }
         if(Boolean(param1) && Boolean(param1.parent))
         {
            param1.removeFromParent();
         }
         this._backgroundDisabledSkin = param1;
         this.invalidate(INVALIDATION_FLAG_SKIN);
      }
      
      public function get autoSizeMode() : String
      {
         return this._autoSizeMode;
      }
      
      public function set autoSizeMode(param1:String) : void
      {
         if(this._autoSizeMode == param1)
         {
            return;
         }
         this._autoSizeMode = param1;
         if(this.stage)
         {
            if(this._autoSizeMode == AutoSizeMode.STAGE)
            {
               this.stage.addEventListener(Event.RESIZE,this.stage_resizeHandler);
            }
            else
            {
               this.stage.removeEventListener(Event.RESIZE,this.stage_resizeHandler);
            }
         }
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      override public function addChildAt(param1:DisplayObject, param2:int) : DisplayObject
      {
         if(param1 is IFeathersControl)
         {
            param1.addEventListener(FeathersEventType.RESIZE,this.child_resizeHandler);
         }
         if(param1 is ILayoutDisplayObject)
         {
            param1.addEventListener(FeathersEventType.LAYOUT_DATA_CHANGE,this.child_layoutDataChangeHandler);
         }
         var _loc3_:int = this.items.indexOf(param1);
         if(_loc3_ == param2)
         {
            return param1;
         }
         if(_loc3_ >= 0)
         {
            this.items.removeAt(_loc3_);
         }
         this.items.insertAt(param2,param1);
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
         return super.addChildAt(param1,param2);
      }
      
      override public function removeChildAt(param1:int, param2:Boolean = false) : DisplayObject
      {
         if(param1 >= 0 && param1 < this.items.length)
         {
            this.items.removeAt(param1);
         }
         var _loc3_:DisplayObject = super.removeChildAt(param1,param2);
         if(_loc3_ is IFeathersControl)
         {
            _loc3_.removeEventListener(FeathersEventType.RESIZE,this.child_resizeHandler);
         }
         if(_loc3_ is ILayoutDisplayObject)
         {
            _loc3_.removeEventListener(FeathersEventType.LAYOUT_DATA_CHANGE,this.child_layoutDataChangeHandler);
         }
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
         return _loc3_;
      }
      
      override public function setChildIndex(param1:DisplayObject, param2:int) : void
      {
         super.setChildIndex(param1,param2);
         var _loc3_:int = this.items.indexOf(param1);
         if(_loc3_ === param2)
         {
            return;
         }
         this.items.removeAt(_loc3_);
         this.items.insertAt(param2,param1);
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      override public function swapChildrenAt(param1:int, param2:int) : void
      {
         super.swapChildrenAt(param1,param2);
         var _loc3_:DisplayObject = this.items[param1];
         var _loc4_:DisplayObject = this.items[param2];
         this.items[param1] = _loc4_;
         this.items[param2] = _loc3_;
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      override public function sortChildren(param1:Function) : void
      {
         super.sortChildren(param1);
         this.items.sort(param1);
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      override public function hitTest(param1:Point) : DisplayObject
      {
         var _loc2_:Number = param1.x;
         var _loc3_:Number = param1.y;
         var _loc4_:DisplayObject = super.hitTest(param1);
         if(_loc4_)
         {
            if(!this._isEnabled)
            {
               return this;
            }
            return _loc4_;
         }
         if(!this.visible || !this.touchable)
         {
            return null;
         }
         if(Boolean(this.currentBackgroundSkin) && this._hitArea.contains(_loc2_,_loc3_))
         {
            return this;
         }
         return null;
      }
      
      override public function render(param1:Painter) : void
      {
         var _loc2_:DisplayObject = null;
         if(Boolean(this.currentBackgroundSkin) && Boolean(this.currentBackgroundSkin.visible) && this.currentBackgroundSkin.alpha > 0)
         {
            _loc2_ = this.currentBackgroundSkin.mask;
            param1.pushState(this._backgroundSkinPushToken);
            param1.setStateTo(this.currentBackgroundSkin.transformationMatrix,this.currentBackgroundSkin.alpha,this.currentBackgroundSkin.blendMode);
            if(_loc2_)
            {
               param1.drawMask(_loc2_);
            }
            this.currentBackgroundSkin.render(param1);
            if(_loc2_)
            {
               param1.eraseMask(_loc2_);
            }
            param1.popState(this._backgroundSkinPopToken);
         }
         super.render(param1);
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._backgroundSkin) && this._backgroundSkin.parent !== this)
         {
            this._backgroundSkin.dispose();
         }
         if(Boolean(this._backgroundDisabledSkin) && this._backgroundDisabledSkin.parent !== this)
         {
            this._backgroundDisabledSkin.dispose();
         }
         this.layout = null;
         super.dispose();
      }
      
      public function readjustLayout() : void
      {
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      override protected function initialize() : void
      {
         var _loc1_:DisplayObject = null;
         if(this.stage !== null)
         {
            _loc1_ = this.stage.root;
         }
         if(_loc1_ === this)
         {
            this.autoSizeMode = AutoSizeMode.STAGE;
         }
         super.initialize();
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_CLIPPING);
         var _loc5_:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
         var _loc6_:Boolean = this.isInvalid(INVALIDATION_FLAG_SKIN);
         var _loc7_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         if(Boolean(!_loc2_ && _loc5_) && Boolean(this._layout) && this._layout.requiresLayoutOnScroll)
         {
            _loc2_ = true;
         }
         if(_loc6_ || _loc7_)
         {
            this.refreshBackgroundSkin();
         }
         if(_loc3_ || _loc2_ || _loc6_ || _loc7_)
         {
            this.refreshViewPortBounds();
            if(this._layout)
            {
               _loc1_ = this._ignoreChildChanges;
               this._ignoreChildChanges = true;
               this._layout.layout(this.items,this.viewPortBounds,this._layoutResult);
               this._ignoreChildChanges = _loc1_;
            }
            else
            {
               this.handleManualLayout();
            }
            this.handleLayoutResult();
            this.refreshBackgroundLayout();
            this.validateChildren();
         }
         if(_loc3_ || _loc4_)
         {
            this.refreshClipRect();
         }
      }
      
      protected function refreshBackgroundSkin() : void
      {
         var _loc1_:DisplayObject = this.currentBackgroundSkin;
         if(!this._isEnabled && Boolean(this._backgroundDisabledSkin))
         {
            this.currentBackgroundSkin = this._backgroundDisabledSkin;
         }
         else
         {
            this.currentBackgroundSkin = this._backgroundSkin;
         }
         if(this.currentBackgroundSkin)
         {
            if(this.originalBackgroundWidth !== this.originalBackgroundWidth || this.originalBackgroundHeight !== this.originalBackgroundHeight)
            {
               if(this.currentBackgroundSkin is IValidating)
               {
                  IValidating(this.currentBackgroundSkin).validate();
               }
               this.originalBackgroundWidth = this.currentBackgroundSkin.width;
               this.originalBackgroundHeight = this.currentBackgroundSkin.height;
            }
         }
         if(this.currentBackgroundSkin !== _loc1_)
         {
            this.setRequiresRedraw();
         }
      }
      
      protected function refreshBackgroundLayout() : void
      {
         if(this.currentBackgroundSkin === null)
         {
            return;
         }
         if(this.currentBackgroundSkin.width !== this.actualWidth || this.currentBackgroundSkin.height !== this.actualHeight)
         {
            this.currentBackgroundSkin.width = this.actualWidth;
            this.currentBackgroundSkin.height = this.actualHeight;
            this.setRequiresRedraw();
         }
      }
      
      protected function refreshViewPortBounds() : void
      {
         this.viewPortBounds.x = 0;
         this.viewPortBounds.y = 0;
         this.viewPortBounds.scrollX = 0;
         this.viewPortBounds.scrollY = 0;
         if(this._autoSizeMode === AutoSizeMode.STAGE && this._explicitWidth !== this._explicitWidth)
         {
            this.viewPortBounds.explicitWidth = this.stage.stageWidth;
         }
         else
         {
            this.viewPortBounds.explicitWidth = this._explicitWidth;
         }
         if(this._autoSizeMode === AutoSizeMode.STAGE && this._explicitHeight !== this._explicitHeight)
         {
            this.viewPortBounds.explicitHeight = this.stage.stageHeight;
         }
         else
         {
            this.viewPortBounds.explicitHeight = this._explicitHeight;
         }
         var _loc1_:Number = this._explicitMinWidth;
         if(_loc1_ !== _loc1_)
         {
            _loc1_ = 0;
         }
         var _loc2_:Number = this._explicitMinHeight;
         if(_loc2_ !== _loc2_)
         {
            _loc2_ = 0;
         }
         if(this.originalBackgroundWidth === this.originalBackgroundWidth && this.originalBackgroundWidth > _loc1_)
         {
            _loc1_ = this.originalBackgroundWidth;
         }
         if(this.originalBackgroundHeight === this.originalBackgroundHeight && this.originalBackgroundHeight > _loc2_)
         {
            _loc2_ = this.originalBackgroundHeight;
         }
         this.viewPortBounds.minWidth = _loc1_;
         this.viewPortBounds.minHeight = _loc2_;
         this.viewPortBounds.maxWidth = this._maxWidth;
         this.viewPortBounds.maxHeight = this._maxHeight;
      }
      
      protected function handleLayoutResult() : void
      {
         this.setSizeInternal(this._layoutResult.viewPortWidth,this._layoutResult.viewPortHeight,false);
      }
      
      protected function handleManualLayout() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:Number = Number(NaN);
         var _loc3_:Number = Number(NaN);
         var _loc4_:Number = this.viewPortBounds.explicitWidth;
         if(_loc4_ !== _loc4_)
         {
            _loc4_ = 0;
         }
         var _loc5_:Number = this.viewPortBounds.explicitHeight;
         if(_loc5_ !== _loc5_)
         {
            _loc5_ = 0;
         }
         var _loc6_:Boolean = this._ignoreChildChanges;
         this._ignoreChildChanges = true;
         var _loc7_:int = int(this.items.length);
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc1_ = this.items[_loc8_];
            if(!(_loc1_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc1_).includeInLayout))
            {
               if(_loc1_ is IValidating)
               {
                  IValidating(_loc1_).validate();
               }
               _loc2_ = _loc1_.x + _loc1_.width;
               _loc3_ = _loc1_.y + _loc1_.height;
               if(_loc2_ === _loc2_ && _loc2_ > _loc4_)
               {
                  _loc4_ = _loc2_;
               }
               if(_loc3_ === _loc3_ && _loc3_ > _loc5_)
               {
                  _loc5_ = _loc3_;
               }
            }
            _loc8_++;
         }
         this._ignoreChildChanges = _loc6_;
         this._layoutResult.contentX = 0;
         this._layoutResult.contentY = 0;
         this._layoutResult.contentWidth = _loc4_;
         this._layoutResult.contentHeight = _loc5_;
         var _loc9_:Number = this.viewPortBounds.minWidth;
         var _loc10_:Number = this.viewPortBounds.minHeight;
         if(_loc4_ < _loc9_)
         {
            _loc4_ = _loc9_;
         }
         if(_loc5_ < _loc10_)
         {
            _loc5_ = _loc10_;
         }
         var _loc11_:Number = this.viewPortBounds.maxWidth;
         var _loc12_:Number = this.viewPortBounds.maxHeight;
         if(_loc4_ > _loc11_)
         {
            _loc4_ = _loc11_;
         }
         if(_loc5_ > _loc12_)
         {
            _loc5_ = _loc12_;
         }
         this._layoutResult.viewPortWidth = _loc4_;
         this._layoutResult.viewPortHeight = _loc5_;
      }
      
      protected function validateChildren() : void
      {
         var _loc1_:DisplayObject = null;
         if(this.currentBackgroundSkin is IValidating)
         {
            IValidating(this.currentBackgroundSkin).validate();
         }
         var _loc2_:int = int(this.items.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = this.items[_loc3_];
            if(_loc1_ is IValidating)
            {
               IValidating(_loc1_).validate();
            }
            _loc3_++;
         }
      }
      
      protected function refreshClipRect() : void
      {
         var _loc1_:Quad = null;
         _loc1_ = null;
         if(!this._clipContent)
         {
            return;
         }
         _loc1_ = this.mask as Quad;
         if(_loc1_)
         {
            _loc1_.x = 0;
            _loc1_.y = 0;
            _loc1_.width = this.actualWidth;
            _loc1_.height = this.actualHeight;
         }
         else
         {
            _loc1_ = new Quad(1,1,16711935);
            _loc1_.width = this.actualWidth;
            _loc1_.height = this.actualHeight;
            this.mask = _loc1_;
         }
      }
      
      protected function layoutGroup_addedToStageHandler(param1:Event) : void
      {
         if(this._autoSizeMode == AutoSizeMode.STAGE)
         {
            this.stage.addEventListener(Event.RESIZE,this.stage_resizeHandler);
         }
      }
      
      protected function layoutGroup_removedFromStageHandler(param1:Event) : void
      {
         this.stage.removeEventListener(Event.RESIZE,this.stage_resizeHandler);
      }
      
      protected function layout_changeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      protected function child_resizeHandler(param1:Event) : void
      {
         if(this._ignoreChildChanges)
         {
            return;
         }
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      protected function child_layoutDataChangeHandler(param1:Event) : void
      {
         if(this._ignoreChildChanges)
         {
            return;
         }
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      protected function stage_resizeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
   }
}

