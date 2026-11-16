package feathers.controls
{
   import feathers.core.*;
   import feathers.skins.IStyleProvider;
   import flash.ui.*;
   import starling.display.*;
   import starling.events.EnterFrameEvent;
   
   public class TextCallout extends Callout implements IToolTip
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      public static const DEFAULT_CHILD_STYLE_NAME_TEXT_RENDERER:String = "feathers-text-callout-text-renderer";
      
      public static var calloutFactory:Function = defaultCalloutFactory;
      
      protected var textRenderer:ITextRenderer;
      
      protected var textRendererStyleName:String = "feathers-text-callout-text-renderer";
      
      protected var _text:String;
      
      protected var _textRendererFactory:Function;
      
      protected var _customTextRendererStyleName:String;
      
      public function TextCallout()
      {
         super();
         this.isQuickHitAreaEnabled = true;
      }
      
      public static function defaultCalloutFactory() : TextCallout
      {
         var _loc1_:TextCallout = new TextCallout();
         _loc1_.closeOnTouchBeganOutside = true;
         _loc1_.closeOnTouchEndedOutside = true;
         _loc1_.closeOnKeys = new <uint>[Keyboard.BACK,Keyboard.ESCAPE];
         return _loc1_;
      }
      
      public static function show(param1:String, param2:DisplayObject, param3:String = "any", param4:Boolean = true, param5:Function = null, param6:Function = null) : TextCallout
      {
         if(!param2.stage)
         {
            throw new ArgumentError("TextCallout origin must be added to the stage.");
         }
         var _loc7_:Function = param5;
         if(_loc7_ == null)
         {
            _loc7_ = calloutFactory != null ? calloutFactory : defaultCalloutFactory;
         }
         var _loc8_:TextCallout = TextCallout(_loc7_());
         _loc8_.text = param1;
         _loc8_.supportedDirections = param3;
         _loc8_.origin = param2;
         _loc7_ = param6;
         if(_loc7_ == null)
         {
            _loc7_ = calloutOverlayFactory != null ? calloutOverlayFactory : PopUpManager.defaultOverlayFactory;
         }
         PopUpManager.addPopUp(_loc8_,param4,false,_loc7_);
         _loc8_.validate();
         return _loc8_;
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(param1:String) : void
      {
         if(this._text === param1)
         {
            return;
         }
         this._text = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get textRendererFactory() : Function
      {
         return this._textRendererFactory;
      }
      
      public function set textRendererFactory(param1:Function) : void
      {
         if(this._textRendererFactory == param1)
         {
            return;
         }
         this._textRendererFactory = param1;
         this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
      }
      
      public function get customTextRendererStyleName() : String
      {
         return this._customTextRendererStyleName;
      }
      
      public function set customTextRendererStyleName(param1:String) : void
      {
         if(this._customTextRendererStyleName == param1)
         {
            return;
         }
         this._customTextRendererStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         if(TextCallout.globalStyleProvider !== null)
         {
            return TextCallout.globalStyleProvider;
         }
         return Callout.globalStyleProvider;
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_RENDERER);
         if(_loc3_)
         {
            this.createTextRenderer();
         }
         if(_loc3_ || _loc1_ || _loc2_)
         {
            this.refreshTextRendererData();
         }
         super.draw();
      }
      
      protected function createTextRenderer() : void
      {
         if(this.textRenderer)
         {
            this.removeChild(DisplayObject(this.textRenderer),true);
            this.textRenderer = null;
         }
         var _loc1_:Function = this._textRendererFactory != null ? this._textRendererFactory : FeathersControl.defaultTextRendererFactory;
         this.textRenderer = ITextRenderer(_loc1_());
         var _loc2_:String = this._customTextRendererStyleName !== null ? this._customTextRendererStyleName : this.textRendererStyleName;
         this.textRenderer.styleNameList.add(_loc2_);
         this._content = DisplayObject(this.textRenderer);
         this.addChild(this._content);
      }
      
      protected function refreshTextRendererData() : void
      {
         this.textRenderer.text = this._text;
         this.textRenderer.visible = Boolean(this._text) && this._text.length > 0;
      }
      
      override protected function callout_enterFrameHandler(param1:EnterFrameEvent) : void
      {
         if(this.isCreated)
         {
            this.positionToOrigin();
         }
      }
   }
}

