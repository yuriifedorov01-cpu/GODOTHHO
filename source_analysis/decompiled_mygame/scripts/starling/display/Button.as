package starling.display
{
   import flash.geom.*;
   import flash.ui.*;
   import starling.events.*;
   import starling.styles.MeshStyle;
   import starling.text.*;
   import starling.textures.Texture;
   
   public class Button extends DisplayObjectContainer
   {
      
      private static const MAX_DRAG_DIST:Number = 50;
      
      private var _upState:Texture;
      
      private var _downState:Texture;
      
      private var _overState:Texture;
      
      private var _disabledState:Texture;
      
      private var _contents:Sprite;
      
      private var _body:Image;
      
      private var _textField:TextField;
      
      private var _textBounds:Rectangle;
      
      private var _overlay:Sprite;
      
      private var _scaleWhenDown:Number;
      
      private var _scaleWhenOver:Number;
      
      private var _alphaWhenDown:Number;
      
      private var _alphaWhenDisabled:Number;
      
      private var _useHandCursor:Boolean;
      
      private var _enabled:Boolean;
      
      private var _state:String;
      
      private var _triggerBounds:Rectangle;
      
      public function Button(param1:Texture, param2:String = "", param3:Texture = null, param4:Texture = null, param5:Texture = null)
      {
         super();
         if(param1 == null)
         {
            throw new ArgumentError("Texture \'upState\' cannot be null");
         }
         this._upState = param1;
         this._downState = param3;
         this._overState = param4;
         this._disabledState = param5;
         this._state = ButtonState.UP;
         this._body = new Image(param1);
         this._body.pixelSnapping = true;
         this._scaleWhenDown = param3 ? 1 : 0.9;
         this._scaleWhenOver = this._alphaWhenDown = 1;
         this._alphaWhenDisabled = param5 ? 1 : 0.5;
         this._enabled = true;
         this._useHandCursor = true;
         this._textBounds = new Rectangle(0,0,this._body.width,this._body.height);
         this._triggerBounds = new Rectangle();
         this._contents = new Sprite();
         this._contents.addChild(this._body);
         addChild(this._contents);
         addEventListener(TouchEvent.TOUCH,this.onTouch);
         this.touchGroup = true;
         this.text = param2;
      }
      
      override public function dispose() : void
      {
         if(this._textField)
         {
            this._textField.dispose();
         }
         super.dispose();
      }
      
      public function readjustSize() : void
      {
         var _loc1_:Number = Number(this._body.width);
         var _loc2_:Number = Number(this._body.height);
         this._body.readjustSize();
         var _loc3_:Number = this._body.width / _loc1_;
         var _loc4_:Number = this._body.height / _loc2_;
         this._textBounds.x *= _loc3_;
         this._textBounds.y *= _loc4_;
         this._textBounds.width *= _loc3_;
         this._textBounds.height *= _loc4_;
         if(this._textField)
         {
            this.createTextField();
         }
      }
      
      private function createTextField() : void
      {
         if(this._textField == null)
         {
            this._textField = new TextField(this._textBounds.width,this._textBounds.height);
            this._textField.pixelSnapping = this._body.pixelSnapping;
            this._textField.touchable = false;
            this._textField.autoScale = true;
            this._textField.batchable = true;
         }
         this._textField.width = this._textBounds.width;
         this._textField.height = this._textBounds.height;
         this._textField.x = this._textBounds.x;
         this._textField.y = this._textBounds.y;
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Boolean = false;
         Mouse.cursor = Boolean(this._useHandCursor) && Boolean(this._enabled) && param1.interactsWith(this) ? MouseCursor.BUTTON : MouseCursor.AUTO;
         var _loc3_:Touch = param1.getTouch(this);
         if(!this._enabled)
         {
            return;
         }
         if(_loc3_ == null)
         {
            this.state = ButtonState.UP;
         }
         else if(_loc3_.phase == TouchPhase.HOVER)
         {
            this.state = ButtonState.OVER;
         }
         else if(_loc3_.phase == TouchPhase.BEGAN && this._state != ButtonState.DOWN)
         {
            this._triggerBounds = getBounds(stage,this._triggerBounds);
            this._triggerBounds.inflate(MAX_DRAG_DIST,MAX_DRAG_DIST);
            this.state = ButtonState.DOWN;
         }
         else if(_loc3_.phase == TouchPhase.MOVED)
         {
            _loc2_ = Boolean(this._triggerBounds.contains(_loc3_.globalX,_loc3_.globalY));
            if(this._state == ButtonState.DOWN && !_loc2_)
            {
               this.state = ButtonState.UP;
            }
            else if(this._state == ButtonState.UP && _loc2_)
            {
               this.state = ButtonState.DOWN;
            }
         }
         else if(_loc3_.phase == TouchPhase.ENDED && this._state == ButtonState.DOWN)
         {
            this.state = ButtonState.UP;
            if(!_loc3_.cancelled)
            {
               dispatchEventWith(Event.TRIGGERED,true);
            }
         }
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      public function set state(param1:String) : void
      {
         this._state = param1;
         this._contents.x = this._contents.y = 0;
         this._contents.scaleX = this._contents.scaleY = this._contents.alpha = 1;
         switch(this._state)
         {
            case ButtonState.DOWN:
               this.setStateTexture(this._downState);
               this._contents.alpha = this._alphaWhenDown;
               this._contents.scaleX = this._contents.scaleY = this._scaleWhenDown;
               this._contents.x = (1 - this._scaleWhenDown) / 2 * this._body.width;
               this._contents.y = (1 - this._scaleWhenDown) / 2 * this._body.height;
               break;
            case ButtonState.UP:
               this.setStateTexture(this._upState);
               break;
            case ButtonState.OVER:
               this.setStateTexture(this._overState);
               this._contents.scaleX = this._contents.scaleY = this._scaleWhenOver;
               this._contents.x = (1 - this._scaleWhenOver) / 2 * this._body.width;
               this._contents.y = (1 - this._scaleWhenOver) / 2 * this._body.height;
               break;
            case ButtonState.DISABLED:
               this.setStateTexture(this._disabledState);
               this._contents.alpha = this._alphaWhenDisabled;
               break;
            default:
               throw new ArgumentError("Invalid button state: " + this._state);
         }
      }
      
      private function setStateTexture(param1:Texture) : void
      {
         this._body.texture = param1 ? param1 : this._upState;
      }
      
      public function get scaleWhenDown() : Number
      {
         return this._scaleWhenDown;
      }
      
      public function set scaleWhenDown(param1:Number) : void
      {
         this._scaleWhenDown = param1;
      }
      
      public function get scaleWhenOver() : Number
      {
         return this._scaleWhenOver;
      }
      
      public function set scaleWhenOver(param1:Number) : void
      {
         this._scaleWhenOver = param1;
      }
      
      public function get alphaWhenDown() : Number
      {
         return this._alphaWhenDown;
      }
      
      public function set alphaWhenDown(param1:Number) : void
      {
         this._alphaWhenDown = param1;
      }
      
      public function get alphaWhenDisabled() : Number
      {
         return this._alphaWhenDisabled;
      }
      
      public function set alphaWhenDisabled(param1:Number) : void
      {
         this._alphaWhenDisabled = param1;
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(this._enabled != param1)
         {
            this._enabled = param1;
            this.state = param1 ? ButtonState.UP : ButtonState.DISABLED;
         }
      }
      
      public function get text() : String
      {
         return this._textField ? this._textField.text : "";
      }
      
      public function set text(param1:String) : void
      {
         if(param1.length == 0)
         {
            if(this._textField)
            {
               this._textField.text = param1;
               this._textField.removeFromParent();
            }
         }
         else
         {
            this.createTextField();
            this._textField.text = param1;
            if(this._textField.parent == null)
            {
               this._contents.addChild(this._textField);
            }
         }
      }
      
      public function get textFormat() : TextFormat
      {
         if(this._textField == null)
         {
            this.createTextField();
         }
         return this._textField.format;
      }
      
      public function set textFormat(param1:TextFormat) : void
      {
         if(this._textField == null)
         {
            this.createTextField();
         }
         this._textField.format = param1;
      }
      
      public function get textStyle() : MeshStyle
      {
         if(this._textField == null)
         {
            this.createTextField();
         }
         return this._textField.style;
      }
      
      public function set textStyle(param1:MeshStyle) : void
      {
         if(this._textField == null)
         {
            this.createTextField();
         }
         this._textField.style = param1;
      }
      
      public function get style() : MeshStyle
      {
         return this._body.style;
      }
      
      public function set style(param1:MeshStyle) : void
      {
         this._body.style = param1;
      }
      
      public function get upState() : Texture
      {
         return this._upState;
      }
      
      public function set upState(param1:Texture) : void
      {
         if(param1 == null)
         {
            throw new ArgumentError("Texture \'upState\' cannot be null");
         }
         if(this._upState != param1)
         {
            this._upState = param1;
            if(this._state == ButtonState.UP || this._state == ButtonState.DISABLED && this._disabledState == null || this._state == ButtonState.DOWN && this._downState == null || this._state == ButtonState.OVER && this._overState == null)
            {
               this.setStateTexture(param1);
            }
         }
      }
      
      public function get downState() : Texture
      {
         return this._downState;
      }
      
      public function set downState(param1:Texture) : void
      {
         if(this._downState != param1)
         {
            this._downState = param1;
            if(this._state == ButtonState.DOWN)
            {
               this.setStateTexture(param1);
            }
         }
      }
      
      public function get overState() : Texture
      {
         return this._overState;
      }
      
      public function set overState(param1:Texture) : void
      {
         if(this._overState != param1)
         {
            this._overState = param1;
            if(this._state == ButtonState.OVER)
            {
               this.setStateTexture(param1);
            }
         }
      }
      
      public function get disabledState() : Texture
      {
         return this._disabledState;
      }
      
      public function set disabledState(param1:Texture) : void
      {
         if(this._disabledState != param1)
         {
            this._disabledState = param1;
            if(this._state == ButtonState.DISABLED)
            {
               this.setStateTexture(param1);
            }
         }
      }
      
      public function get textBounds() : Rectangle
      {
         return this._textBounds;
      }
      
      public function set textBounds(param1:Rectangle) : void
      {
         this._textBounds.copyFrom(param1);
         this.createTextField();
      }
      
      public function get color() : uint
      {
         return this._body.color;
      }
      
      public function set color(param1:uint) : void
      {
         this._body.color = param1;
      }
      
      public function get textureSmoothing() : String
      {
         return this._body.textureSmoothing;
      }
      
      public function set textureSmoothing(param1:String) : void
      {
         this._body.textureSmoothing = param1;
      }
      
      public function get overlay() : Sprite
      {
         if(this._overlay == null)
         {
            this._overlay = new Sprite();
         }
         this._contents.addChild(this._overlay);
         return this._overlay;
      }
      
      override public function get useHandCursor() : Boolean
      {
         return this._useHandCursor;
      }
      
      override public function set useHandCursor(param1:Boolean) : void
      {
         this._useHandCursor = param1;
      }
      
      public function get pixelSnapping() : Boolean
      {
         return this._body.pixelSnapping;
      }
      
      public function set pixelSnapping(param1:Boolean) : void
      {
         this._body.pixelSnapping = param1;
         if(this._textField)
         {
            this._textField.pixelSnapping = param1;
         }
      }
      
      override public function set width(param1:Number) : void
      {
         var _loc2_:Number = param1 / (this.scaleX || 1);
         var _loc3_:Number = _loc2_ / (this._body.width || 1);
         this._body.width = _loc2_;
         this._textBounds.x *= _loc3_;
         this._textBounds.width *= _loc3_;
         if(this._textField)
         {
            this._textField.width = _loc2_;
         }
      }
      
      override public function set height(param1:Number) : void
      {
         var _loc2_:Number = param1 / (this.scaleY || 1);
         var _loc3_:Number = _loc2_ / (this._body.height || 1);
         this._body.height = _loc2_;
         this._textBounds.y *= _loc3_;
         this._textBounds.height *= _loc3_;
         if(this._textField)
         {
            this._textField.height = _loc2_;
         }
      }
      
      public function get scale9Grid() : Rectangle
      {
         return this._body.scale9Grid;
      }
      
      public function set scale9Grid(param1:Rectangle) : void
      {
         this._body.scale9Grid = param1;
      }
   }
}

