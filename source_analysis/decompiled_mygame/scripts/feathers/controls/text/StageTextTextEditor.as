package feathers.controls.text
{
   import feathers.core.*;
   import feathers.events.*;
   import feathers.skins.IStyleProvider;
   import feathers.text.*;
   import feathers.utils.display.*;
   import feathers.utils.geom.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.engine.*;
   import flash.ui.*;
   import flash.utils.*;
   import starling.core.*;
   import starling.display.*;
   import starling.events.Event;
   import starling.rendering.Painter;
   import starling.textures.*;
   import starling.utils.*;
   
   public class StageTextTextEditor extends FeathersControl implements IMultilineTextEditor
   {
      
      private static var HELPER_MATRIX3D:Matrix3D;
      
      private static var HELPER_POINT3D:Vector3D;
      
      public static var globalStyleProvider:IStyleProvider;
      
      private static const HELPER_MATRIX:Matrix = new Matrix();
      
      private static const HELPER_POINT:Point = new Point();
      
      protected var stageText:Object;
      
      protected var textSnapshot:Image;
      
      protected var _needsNewTexture:Boolean = false;
      
      protected var _ignoreStageTextChanges:Boolean = false;
      
      protected var _text:String = "";
      
      protected var _measureTextField:TextField;
      
      protected var _stageTextIsTextField:Boolean = false;
      
      protected var _stageTextHasFocus:Boolean = false;
      
      protected var _isWaitingToSetFocus:Boolean = false;
      
      protected var _pendingSelectionBeginIndex:int = -1;
      
      protected var _pendingSelectionEndIndex:int = -1;
      
      protected var _stageTextIsComplete:Boolean = false;
      
      protected var _autoCapitalize:String = "none";
      
      protected var _autoCorrect:Boolean = false;
      
      protected var _color:uint = 0;
      
      protected var _disabledColor:uint = 10066329;
      
      protected var _displayAsPassword:Boolean = false;
      
      protected var _isEditable:Boolean = true;
      
      protected var _isSelectable:Boolean = true;
      
      protected var _fontFamily:String = null;
      
      protected var _fontPosture:String = "normal";
      
      protected var _fontSize:int = 12;
      
      protected var _fontWeight:String = "normal";
      
      protected var _locale:String = "en";
      
      protected var _maxChars:int = 0;
      
      protected var _multiline:Boolean = false;
      
      protected var _restrict:String;
      
      protected var _returnKeyLabel:String = "default";
      
      protected var _softKeyboardType:String = "default";
      
      protected var _textAlign:String = "start";
      
      protected var _lastGlobalScaleX:Number = 0;
      
      protected var _lastGlobalScaleY:Number = 0;
      
      protected var _updateSnapshotOnScaleChange:Boolean = false;
      
      public function StageTextTextEditor()
      {
         super();
         this._stageTextIsTextField = Boolean(/^(Windows|Mac OS|Linux) .*/.exec(Capabilities.os)) || Capabilities.playerType === "Desktop" && Boolean(Capabilities.isDebugger);
         this.isQuickHitAreaEnabled = true;
         this.addEventListener(starling.events.Event.REMOVED_FROM_STAGE,this.textEditor_removedFromStageHandler);
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return globalStyleProvider;
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(param1:String) : void
      {
         if(!param1)
         {
            param1 = "";
         }
         if(this._text == param1)
         {
            return;
         }
         this._text = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
         this.dispatchEventWith(starling.events.Event.CHANGE);
      }
      
      public function get selectionBeginIndex() : int
      {
         if(this._pendingSelectionBeginIndex >= 0)
         {
            return this._pendingSelectionBeginIndex;
         }
         if(this.stageText)
         {
            return this.stageText.selectionAnchorIndex;
         }
         return 0;
      }
      
      public function get selectionEndIndex() : int
      {
         if(this._pendingSelectionEndIndex >= 0)
         {
            return this._pendingSelectionEndIndex;
         }
         if(this.stageText)
         {
            return this.stageText.selectionActiveIndex;
         }
         return 0;
      }
      
      public function get baseline() : Number
      {
         if(!this._measureTextField)
         {
            return 0;
         }
         return this._measureTextField.getLineMetrics(0).ascent;
      }
      
      public function get autoCapitalize() : String
      {
         return this._autoCapitalize;
      }
      
      public function set autoCapitalize(param1:String) : void
      {
         if(this._autoCapitalize == param1)
         {
            return;
         }
         this._autoCapitalize = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get autoCorrect() : Boolean
      {
         return this._autoCorrect;
      }
      
      public function set autoCorrect(param1:Boolean) : void
      {
         if(this._autoCorrect == param1)
         {
            return;
         }
         this._autoCorrect = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function set color(param1:uint) : void
      {
         if(this._color == param1)
         {
            return;
         }
         this._color = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get disabledColor() : uint
      {
         return this._disabledColor;
      }
      
      public function set disabledColor(param1:uint) : void
      {
         if(this._disabledColor == param1)
         {
            return;
         }
         this._disabledColor = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get displayAsPassword() : Boolean
      {
         return this._displayAsPassword;
      }
      
      public function set displayAsPassword(param1:Boolean) : void
      {
         if(this._displayAsPassword == param1)
         {
            return;
         }
         this._displayAsPassword = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get isEditable() : Boolean
      {
         return this._isEditable;
      }
      
      public function set isEditable(param1:Boolean) : void
      {
         if(this._isEditable == param1)
         {
            return;
         }
         this._isEditable = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get isSelectable() : Boolean
      {
         return this._isEditable;
      }
      
      public function set isSelectable(param1:Boolean) : void
      {
         if(this._isSelectable == param1)
         {
            return;
         }
         this._isSelectable = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get setTouchFocusOnEndedPhase() : Boolean
      {
         return true;
      }
      
      public function get fontFamily() : String
      {
         return this._fontFamily;
      }
      
      public function set fontFamily(param1:String) : void
      {
         if(this._fontFamily == param1)
         {
            return;
         }
         this._fontFamily = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get fontPosture() : String
      {
         return this._fontPosture;
      }
      
      public function set fontPosture(param1:String) : void
      {
         if(this._fontPosture == param1)
         {
            return;
         }
         this._fontPosture = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get fontSize() : int
      {
         return this._fontSize;
      }
      
      public function set fontSize(param1:int) : void
      {
         if(this._fontSize == param1)
         {
            return;
         }
         this._fontSize = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get fontWeight() : String
      {
         return this._fontWeight;
      }
      
      public function set fontWeight(param1:String) : void
      {
         if(this._fontWeight == param1)
         {
            return;
         }
         this._fontWeight = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get locale() : String
      {
         return this._locale;
      }
      
      public function set locale(param1:String) : void
      {
         if(this._locale == param1)
         {
            return;
         }
         this._locale = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get maxChars() : int
      {
         return this._maxChars;
      }
      
      public function set maxChars(param1:int) : void
      {
         if(this._maxChars == param1)
         {
            return;
         }
         this._maxChars = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get multiline() : Boolean
      {
         return this._multiline;
      }
      
      public function set multiline(param1:Boolean) : void
      {
         if(this._multiline == param1)
         {
            return;
         }
         this._multiline = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get restrict() : String
      {
         return this._restrict;
      }
      
      public function set restrict(param1:String) : void
      {
         if(this._restrict == param1)
         {
            return;
         }
         this._restrict = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get returnKeyLabel() : String
      {
         return this._returnKeyLabel;
      }
      
      public function set returnKeyLabel(param1:String) : void
      {
         if(this._returnKeyLabel == param1)
         {
            return;
         }
         this._returnKeyLabel = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get softKeyboardType() : String
      {
         return this._softKeyboardType;
      }
      
      public function set softKeyboardType(param1:String) : void
      {
         if(this._softKeyboardType == param1)
         {
            return;
         }
         this._softKeyboardType = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get textAlign() : String
      {
         return this._textAlign;
      }
      
      public function set textAlign(param1:String) : void
      {
         if(this._textAlign == param1)
         {
            return;
         }
         this._textAlign = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get updateSnapshotOnScaleChange() : Boolean
      {
         return this._updateSnapshotOnScaleChange;
      }
      
      public function set updateSnapshotOnScaleChange(param1:Boolean) : void
      {
         if(this._updateSnapshotOnScaleChange == param1)
         {
            return;
         }
         this._updateSnapshotOnScaleChange = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      override public function dispose() : void
      {
         if(this._measureTextField)
         {
            Starling.current.nativeStage.removeChild(this._measureTextField);
            this._measureTextField = null;
         }
         if(this.stageText)
         {
            this.disposeStageText();
         }
         if(this.textSnapshot)
         {
            this.textSnapshot.texture.dispose();
            this.removeChild(this.textSnapshot,true);
            this.textSnapshot = null;
         }
         super.dispose();
      }
      
      override public function render(param1:Painter) : void
      {
         if(Boolean(this.textSnapshot) && this._updateSnapshotOnScaleChange)
         {
            this.getTransformationMatrix(this.stage,HELPER_MATRIX);
            if(matrixToScaleX(HELPER_MATRIX) != this._lastGlobalScaleX || matrixToScaleY(HELPER_MATRIX) != this._lastGlobalScaleY)
            {
               this.invalidate(INVALIDATION_FLAG_SIZE);
               this.validate();
            }
         }
         if(Boolean(this.stageText) && Boolean(this.stageText.visible))
         {
            this.refreshViewPortAndFontSize();
         }
         if(this.textSnapshot)
         {
            this.positionSnapshot();
         }
         super.render(param1);
      }
      
      public function setFocus(param1:Point = null) : void
      {
         var position:Point = param1;
         var positionX:Number = Number(NaN);
         var positionY:Number = Number(NaN);
         var lineIndex:int = 0;
         var bounds:Rectangle = null;
         var boundsX:Number = Number(NaN);
         if(!this._isEditable && SystemUtil.platform === "AND")
         {
            return;
         }
         if(!this._isEditable && !this._isSelectable)
         {
            return;
         }
         if(Boolean(this.stage) && !this.stageText.stage)
         {
            this.stageText.stage = Starling.current.nativeStage;
         }
         if(Boolean(this.stageText) && this._stageTextIsComplete)
         {
            if(position)
            {
               positionX = position.x + 2;
               positionY = position.y + 2;
               if(positionX < 0)
               {
                  this._pendingSelectionBeginIndex = this._pendingSelectionEndIndex = 0;
               }
               else
               {
                  this._pendingSelectionBeginIndex = this._measureTextField.getCharIndexAtPoint(positionX,positionY);
                  if(this._pendingSelectionBeginIndex < 0)
                  {
                     if(this._multiline)
                     {
                        lineIndex = int(positionY / this._measureTextField.getLineMetrics(0).height);
                        try
                        {
                           this._pendingSelectionBeginIndex = this._measureTextField.getLineOffset(lineIndex) + this._measureTextField.getLineLength(lineIndex);
                           if(this._pendingSelectionBeginIndex != this._text.length)
                           {
                              --this._pendingSelectionBeginIndex;
                           }
                        }
                        catch(error:Error)
                        {
                           this._pendingSelectionBeginIndex = this._text.length;
                        }
                     }
                     else
                     {
                        this._pendingSelectionBeginIndex = this._measureTextField.getCharIndexAtPoint(positionX,this._measureTextField.getLineMetrics(0).ascent / 2);
                        if(this._pendingSelectionBeginIndex < 0)
                        {
                           this._pendingSelectionBeginIndex = this._text.length;
                        }
                     }
                  }
                  else
                  {
                     bounds = this._measureTextField.getCharBoundaries(this._pendingSelectionBeginIndex);
                     boundsX = bounds.x;
                     if(Boolean(bounds) && boundsX + bounds.width - positionX < positionX - boundsX)
                     {
                        ++this._pendingSelectionBeginIndex;
                     }
                  }
                  this._pendingSelectionEndIndex = this._pendingSelectionBeginIndex;
               }
            }
            else
            {
               this._pendingSelectionBeginIndex = this._pendingSelectionEndIndex = -1;
            }
            this.stageText.visible = true;
            this.stageText.assignFocus();
         }
         else
         {
            this._isWaitingToSetFocus = true;
         }
      }
      
      public function clearFocus() : void
      {
         if(!this._stageTextHasFocus)
         {
            return;
         }
         Starling.current.nativeStage.focus = null;
      }
      
      public function selectRange(param1:int, param2:int) : void
      {
         if(this._stageTextIsComplete && Boolean(this.stageText))
         {
            this._pendingSelectionBeginIndex = -1;
            this._pendingSelectionEndIndex = -1;
            this.stageText.selectRange(param1,param2);
         }
         else
         {
            this._pendingSelectionBeginIndex = param1;
            this._pendingSelectionEndIndex = param2;
         }
      }
      
      public function measureText(param1:Point = null) : Point
      {
         if(!param1)
         {
            param1 = new Point();
         }
         var _loc2_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc3_:Boolean = this._explicitHeight !== this._explicitHeight;
         if(!_loc2_ && !_loc3_)
         {
            param1.x = this._explicitWidth;
            param1.y = this._explicitHeight;
            return param1;
         }
         if(!this._isInitialized)
         {
            this.initializeInternal();
         }
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc5_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         if(_loc4_ || _loc5_)
         {
            this.refreshMeasureProperties();
         }
         return this.measure(param1);
      }
      
      override protected function initialize() : void
      {
         if(Boolean(this._measureTextField) && !this._measureTextField.parent)
         {
            Starling.current.nativeStage.addChild(this._measureTextField);
         }
         else if(!this._measureTextField)
         {
            this._measureTextField = new TextField();
            this._measureTextField.visible = false;
            this._measureTextField.mouseEnabled = this._measureTextField.mouseWheelEnabled = false;
            this._measureTextField.autoSize = TextFieldAutoSize.LEFT;
            this._measureTextField.multiline = false;
            this._measureTextField.wordWrap = false;
            this._measureTextField.embedFonts = false;
            this._measureTextField.defaultTextFormat = new TextFormat(null,11,0,false,false,false);
            Starling.current.nativeStage.addChild(this._measureTextField);
         }
         this.createStageText();
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         this.commit();
         _loc1_ = this.autoSizeIfNeeded() || _loc1_;
         this.layout(_loc1_);
      }
      
      protected function commit() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         if(_loc2_ || _loc3_)
         {
            this.refreshMeasureProperties();
         }
         var _loc4_:Boolean = this._ignoreStageTextChanges;
         this._ignoreStageTextChanges = true;
         if(_loc1_ || _loc2_)
         {
            this.refreshStageTextProperties();
         }
         if(_loc3_)
         {
            if(this.stageText.text != this._text)
            {
               if(this._pendingSelectionBeginIndex < 0)
               {
                  this._pendingSelectionBeginIndex = this.stageText.selectionActiveIndex;
                  this._pendingSelectionEndIndex = this.stageText.selectionAnchorIndex;
               }
               this.stageText.text = this._text;
            }
         }
         this._ignoreStageTextChanges = _loc4_;
         if(_loc2_ || _loc1_)
         {
            this.stageText.editable = this._isEditable && this._isEnabled;
         }
      }
      
      protected function measure(param1:Point = null) : Point
      {
         if(!param1)
         {
            param1 = new Point();
         }
         var _loc2_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc3_:Boolean = this._explicitHeight !== this._explicitHeight;
         this._measureTextField.autoSize = TextFieldAutoSize.LEFT;
         var _loc4_:Number = this._explicitWidth;
         if(_loc2_)
         {
            _loc4_ = this._measureTextField.textWidth;
            if(_loc4_ < this._explicitMinWidth)
            {
               _loc4_ = this._explicitMinWidth;
            }
            else if(_loc4_ > this._maxWidth)
            {
               _loc4_ = this._maxWidth;
            }
         }
         this._measureTextField.width = _loc4_ + 4;
         var _loc5_:Number = this._explicitHeight;
         if(_loc3_)
         {
            if(this._stageTextIsTextField)
            {
               _loc5_ = this._measureTextField.textHeight;
            }
            else
            {
               _loc5_ = this._measureTextField.height;
            }
            if(_loc5_ < this._explicitMinHeight)
            {
               _loc5_ = this._explicitMinHeight;
            }
            else if(_loc5_ > this._maxHeight)
            {
               _loc5_ = this._maxHeight;
            }
         }
         this._measureTextField.autoSize = TextFieldAutoSize.NONE;
         this._measureTextField.width = this.actualWidth + 4;
         this._measureTextField.height = this.actualHeight;
         param1.x = _loc4_;
         param1.y = _loc5_;
         return param1;
      }
      
      protected function layout(param1:Boolean) : void
      {
         var _loc2_:Rectangle = null;
         var _loc3_:ConcreteTexture = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc6_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc7_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc8_:Boolean = this.isInvalid(INVALIDATION_FLAG_SKIN);
         if(param1 || _loc6_ || _loc8_ || _loc5_)
         {
            this.refreshViewPortAndFontSize();
            this.refreshMeasureTextFieldDimensions();
            _loc2_ = this.stageText.viewPort;
            _loc3_ = this.textSnapshot ? this.textSnapshot.texture.root : null;
            this._needsNewTexture = this._needsNewTexture || !this.textSnapshot || _loc3_.scale != Starling.contentScaleFactor || _loc2_.width != _loc3_.width || _loc2_.height != _loc3_.height;
         }
         if(!this._stageTextHasFocus && (_loc5_ || _loc6_ || _loc7_ || param1 || this._needsNewTexture))
         {
            _loc4_ = this._text.length > 0;
            if(_loc4_)
            {
               this.refreshSnapshot();
            }
            if(this.textSnapshot)
            {
               this.textSnapshot.visible = !this._stageTextHasFocus;
               this.textSnapshot.alpha = _loc4_ ? 1 : 0;
            }
            this.stageText.visible = false;
         }
         this.doPendingActions();
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc1_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc2_:Boolean = this._explicitHeight !== this._explicitHeight;
         if(!_loc1_ && !_loc2_)
         {
            return false;
         }
         this.measure(HELPER_POINT);
         return this.setSizeInternal(HELPER_POINT.x,HELPER_POINT.y,false);
      }
      
      protected function refreshMeasureProperties() : void
      {
         var _loc1_:Number = 1;
         if(Starling.current.supportHighResolutions)
         {
            _loc1_ = Number(Starling.current.nativeStage.contentsScaleFactor);
         }
         this._measureTextField.displayAsPassword = this._displayAsPassword;
         this._measureTextField.maxChars = this._maxChars;
         this._measureTextField.restrict = this._restrict;
         this._measureTextField.multiline = this._measureTextField.wordWrap = this._multiline;
         var _loc2_:TextFormat = this._measureTextField.defaultTextFormat;
         _loc2_.color = this._color;
         _loc2_.font = this._fontFamily;
         _loc2_.italic = this._fontPosture == FontPosture.ITALIC;
         _loc2_.size = this._fontSize * _loc1_;
         _loc2_.bold = this._fontWeight == FontWeight.BOLD;
         var _loc3_:String = this._textAlign;
         if(_loc3_ == TextFormatAlign.START)
         {
            _loc3_ = TextFormatAlign.LEFT;
         }
         else if(_loc3_ == TextFormatAlign.END)
         {
            _loc3_ = TextFormatAlign.RIGHT;
         }
         _loc2_.align = _loc3_;
         this._measureTextField.defaultTextFormat = _loc2_;
         this._measureTextField.setTextFormat(_loc2_);
         if(this._text.length == 0)
         {
            this._measureTextField.text = " ";
         }
         else
         {
            this._measureTextField.text = this._text;
         }
      }
      
      protected function refreshStageTextProperties() : void
      {
         if(this.stageText.multiline != this._multiline)
         {
            if(this.stageText)
            {
               this.disposeStageText();
            }
            this.createStageText();
         }
         this.stageText.autoCapitalize = this._autoCapitalize;
         this.stageText.autoCorrect = this._autoCorrect;
         if(this._isEnabled)
         {
            this.stageText.color = this._color;
         }
         else
         {
            this.stageText.color = this._disabledColor;
         }
         this.stageText.displayAsPassword = this._displayAsPassword;
         this.stageText.fontFamily = this._fontFamily;
         this.stageText.fontPosture = this._fontPosture;
         this.stageText.fontWeight = this._fontWeight;
         this.stageText.locale = this._locale;
         this.stageText.maxChars = this._maxChars;
         this.stageText.restrict = this._restrict;
         this.stageText.returnKeyLabel = this._returnKeyLabel;
         this.stageText.softKeyboardType = this._softKeyboardType;
         this.stageText.textAlign = this._textAlign;
      }
      
      protected function doPendingActions() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this._isWaitingToSetFocus)
         {
            this._isWaitingToSetFocus = false;
            this.setFocus();
         }
         if(this._pendingSelectionBeginIndex >= 0)
         {
            _loc1_ = this._pendingSelectionBeginIndex;
            _loc2_ = this._pendingSelectionEndIndex < 0 ? this._pendingSelectionBeginIndex : this._pendingSelectionEndIndex;
            this._pendingSelectionBeginIndex = -1;
            this._pendingSelectionEndIndex = -1;
            if(this.stageText.selectionAnchorIndex != _loc1_ || this.stageText.selectionActiveIndex != _loc2_)
            {
               this.selectRange(_loc1_,_loc2_);
            }
         }
      }
      
      protected function texture_onRestore() : void
      {
         if(this.textSnapshot.texture.scale != Starling.contentScaleFactor)
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
         else
         {
            this.refreshSnapshot();
            if(this.textSnapshot)
            {
               this.textSnapshot.visible = !this._stageTextHasFocus;
               this.textSnapshot.alpha = this._text.length > 0 ? 1 : 0;
            }
            if(!this._stageTextHasFocus)
            {
               this.stageText.visible = false;
            }
         }
      }
      
      protected function refreshSnapshot() : void
      {
         var nativeScaleFactor:Number = NaN;
         var globalScaleX:Number = NaN;
         var globalScaleY:Number = NaN;
         var viewPort:Rectangle = null;
         var bitmapData:BitmapData = null;
         viewPort = null;
         var newTexture:Texture = null;
         bitmapData = null;
         var scaleFactor:Number = Number(NaN);
         var existingTexture:Texture = null;
         if(Boolean(this.stage) && !this.stageText.stage)
         {
            this.stageText.stage = Starling.current.nativeStage;
         }
         if(!this.stageText.stage)
         {
            this.invalidate(INVALIDATION_FLAG_DATA);
            return;
         }
         viewPort = this.stageText.viewPort;
         if(viewPort.width == 0 || viewPort.height == 0)
         {
            return;
         }
         nativeScaleFactor = 1;
         if(Starling.current.supportHighResolutions)
         {
            nativeScaleFactor = Number(Starling.current.nativeStage.contentsScaleFactor);
         }
         try
         {
            bitmapData = new BitmapData(viewPort.width * nativeScaleFactor,viewPort.height * nativeScaleFactor,true,16711935);
            this.stageText.drawViewPortToBitmapData(bitmapData);
         }
         catch(error:Error)
         {
            bitmapData.dispose();
            bitmapData = new BitmapData(viewPort.width,viewPort.height,true,16711935);
            this.stageText.drawViewPortToBitmapData(bitmapData);
         }
         if(!this.textSnapshot || this._needsNewTexture)
         {
            scaleFactor = Number(Starling.contentScaleFactor);
            newTexture = Texture.empty(bitmapData.width / scaleFactor,bitmapData.height / scaleFactor,true,false,false,scaleFactor);
            newTexture.root.uploadBitmapData(bitmapData);
            newTexture.root.onRestore = this.texture_onRestore;
         }
         if(!this.textSnapshot)
         {
            this.textSnapshot = new Image(newTexture);
            this.addChild(this.textSnapshot);
         }
         else if(this._needsNewTexture)
         {
            this.textSnapshot.texture.dispose();
            this.textSnapshot.texture = newTexture;
            this.textSnapshot.readjustSize();
         }
         else
         {
            existingTexture = this.textSnapshot.texture;
            existingTexture.root.uploadBitmapData(bitmapData);
         }
         this.getTransformationMatrix(this.stage,HELPER_MATRIX);
         globalScaleX = Number(matrixToScaleX(HELPER_MATRIX));
         globalScaleY = Number(matrixToScaleY(HELPER_MATRIX));
         if(this._updateSnapshotOnScaleChange)
         {
            this.textSnapshot.scaleX = 1 / globalScaleX;
            this.textSnapshot.scaleY = 1 / globalScaleY;
            this._lastGlobalScaleX = globalScaleX;
            this._lastGlobalScaleY = globalScaleY;
         }
         else
         {
            this.textSnapshot.scaleX = 1;
            this.textSnapshot.scaleY = 1;
         }
         if(nativeScaleFactor > 1 && bitmapData.width == viewPort.width)
         {
            this.textSnapshot.scaleX *= nativeScaleFactor;
            this.textSnapshot.scaleY *= nativeScaleFactor;
         }
         bitmapData.dispose();
         this._needsNewTexture = false;
      }
      
      protected function refreshViewPortAndFontSize() : void
      {
         var _loc1_:Number = Number(NaN);
         var _loc2_:Number = Number(NaN);
         var _loc3_:Number = Number(NaN);
         HELPER_POINT.x = HELPER_POINT.y = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         if(this._stageTextIsTextField)
         {
            _loc4_ = 2;
            _loc5_ = 4;
         }
         this.getTransformationMatrix(this.stage,HELPER_MATRIX);
         if(this._stageTextHasFocus || this._updateSnapshotOnScaleChange)
         {
            _loc1_ = Number(matrixToScaleX(HELPER_MATRIX));
            _loc2_ = Number(matrixToScaleY(HELPER_MATRIX));
            _loc3_ = _loc1_;
            if(_loc2_ < _loc3_)
            {
               _loc3_ = _loc2_;
            }
         }
         else
         {
            _loc1_ = 1;
            _loc2_ = 1;
            _loc3_ = 1;
         }
         if(this.is3D)
         {
            HELPER_MATRIX3D = this.getTransformationMatrix3D(this.stage,HELPER_MATRIX3D);
            HELPER_POINT3D = MatrixUtil.transformCoords3D(HELPER_MATRIX3D,-_loc4_,-_loc4_,0,HELPER_POINT3D);
            HELPER_POINT.setTo(HELPER_POINT3D.x,HELPER_POINT3D.y);
         }
         else
         {
            MatrixUtil.transformCoords(HELPER_MATRIX,-_loc4_,-_loc4_,HELPER_POINT);
         }
         var _loc6_:Number = 1;
         if(Starling.current.supportHighResolutions)
         {
            _loc6_ = Number(Starling.current.nativeStage.contentsScaleFactor);
         }
         var _loc7_:Number = Starling.contentScaleFactor / _loc6_;
         var _loc8_:Rectangle = Starling.current.viewPort;
         var _loc9_:Rectangle = this.stageText.viewPort;
         if(!_loc9_)
         {
            _loc9_ = new Rectangle();
         }
         _loc9_.x = Math.round(_loc8_.x + HELPER_POINT.x * _loc7_);
         _loc9_.y = Math.round(_loc8_.y + HELPER_POINT.y * _loc7_);
         var _loc10_:Number = Math.round((this.actualWidth + _loc5_) * _loc7_ * _loc1_);
         if(_loc10_ < 1 || _loc10_ !== _loc10_)
         {
            _loc10_ = 1;
         }
         var _loc11_:Number = Math.round((this.actualHeight + _loc5_) * _loc7_ * _loc2_);
         if(_loc11_ < 1 || _loc11_ !== _loc11_)
         {
            _loc11_ = 1;
         }
         _loc9_.width = _loc10_;
         _loc9_.height = _loc11_;
         this.stageText.viewPort = _loc9_;
         _loc7_ = Number(Starling.contentScaleFactor);
         var _loc12_:int = this._fontSize * _loc7_ * _loc3_;
         if(this.stageText.fontSize != _loc12_)
         {
            this.stageText.fontSize = _loc12_;
         }
      }
      
      protected function refreshMeasureTextFieldDimensions() : void
      {
         this._measureTextField.width = this.actualWidth + 4;
         this._measureTextField.height = this.actualHeight;
      }
      
      protected function positionSnapshot() : void
      {
         this.getTransformationMatrix(this.stage,HELPER_MATRIX);
         var _loc1_:Number = 0;
         if(this._stageTextIsTextField)
         {
            _loc1_ = 2;
         }
         this.textSnapshot.x = Math.round(HELPER_MATRIX.tx) - HELPER_MATRIX.tx - _loc1_;
         this.textSnapshot.y = Math.round(HELPER_MATRIX.ty) - HELPER_MATRIX.ty - _loc1_;
      }
      
      protected function disposeStageText() : void
      {
         if(!this.stageText)
         {
            return;
         }
         this.stageText.removeEventListener(flash.events.Event.CHANGE,this.stageText_changeHandler);
         this.stageText.removeEventListener(KeyboardEvent.KEY_DOWN,this.stageText_keyDownHandler);
         this.stageText.removeEventListener(KeyboardEvent.KEY_UP,this.stageText_keyUpHandler);
         this.stageText.removeEventListener(FocusEvent.FOCUS_IN,this.stageText_focusInHandler);
         this.stageText.removeEventListener(FocusEvent.FOCUS_OUT,this.stageText_focusOutHandler);
         this.stageText.removeEventListener(flash.events.Event.COMPLETE,this.stageText_completeHandler);
         this.stageText.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE,this.stageText_softKeyboardActivateHandler);
         this.stageText.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE,this.stageText_softKeyboardDeactivateHandler);
         this.stageText.stage = null;
         this.stageText.dispose();
         this.stageText = null;
      }
      
      protected function createStageText() : void
      {
         var StageTextType:Class = null;
         var initOptions:Object = null;
         var StageTextInitOptionsType:Class = null;
         this._stageTextIsComplete = false;
         try
         {
            StageTextType = Class(getDefinitionByName("flash.text.StageText"));
            StageTextInitOptionsType = Class(getDefinitionByName("flash.text.StageTextInitOptions"));
            initOptions = new StageTextInitOptionsType(this._multiline);
         }
         catch(error:Error)
         {
            StageTextType = StageTextField;
            initOptions = {"multiline":this._multiline};
         }
         this.stageText = new StageTextType(initOptions);
         this.stageText.visible = false;
         this.stageText.addEventListener(flash.events.Event.CHANGE,this.stageText_changeHandler);
         this.stageText.addEventListener(KeyboardEvent.KEY_DOWN,this.stageText_keyDownHandler);
         this.stageText.addEventListener(KeyboardEvent.KEY_UP,this.stageText_keyUpHandler);
         this.stageText.addEventListener(FocusEvent.FOCUS_IN,this.stageText_focusInHandler);
         this.stageText.addEventListener(FocusEvent.FOCUS_OUT,this.stageText_focusOutHandler);
         this.stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE,this.stageText_softKeyboardActivateHandler);
         this.stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE,this.stageText_softKeyboardDeactivateHandler);
         this.stageText.addEventListener(flash.events.Event.COMPLETE,this.stageText_completeHandler);
         this.invalidate();
      }
      
      protected function dispatchKeyFocusChangeEvent(param1:KeyboardEvent) : void
      {
         var _loc2_:Starling = stageToStarling(this.stage);
         var _loc3_:FocusEvent = new FocusEvent(FocusEvent.KEY_FOCUS_CHANGE,true,false,null,param1.shiftKey,param1.keyCode);
         _loc2_.nativeStage.dispatchEvent(_loc3_);
      }
      
      protected function textEditor_removedFromStageHandler(param1:starling.events.Event) : void
      {
         this.stageText.stage = null;
      }
      
      protected function stageText_changeHandler(param1:flash.events.Event) : void
      {
         if(this._ignoreStageTextChanges)
         {
            return;
         }
         this.text = this.stageText.text;
      }
      
      protected function stageText_completeHandler(param1:flash.events.Event) : void
      {
         this.stageText.removeEventListener(flash.events.Event.COMPLETE,this.stageText_completeHandler);
         this.invalidate();
         this._stageTextIsComplete = true;
      }
      
      protected function stageText_focusInHandler(param1:FocusEvent) : void
      {
         this._stageTextHasFocus = true;
         this.addEventListener(starling.events.Event.ENTER_FRAME,this.hasFocus_enterFrameHandler);
         if(this.textSnapshot)
         {
            this.textSnapshot.visible = false;
         }
         this.invalidate(INVALIDATION_FLAG_SKIN);
         this.dispatchEventWith(FeathersEventType.FOCUS_IN);
      }
      
      protected function stageText_focusOutHandler(param1:FocusEvent) : void
      {
         this._stageTextHasFocus = false;
         this.stageText.selectRange(1,1);
         this.invalidate(INVALIDATION_FLAG_DATA);
         this.invalidate(INVALIDATION_FLAG_SKIN);
         this.dispatchEventWith(FeathersEventType.FOCUS_OUT);
      }
      
      protected function hasFocus_enterFrameHandler(param1:starling.events.Event) : void
      {
         var _loc2_:starling.display.DisplayObject = null;
         if(this._stageTextHasFocus)
         {
            _loc2_ = this;
            do
            {
               if(!_loc2_.visible)
               {
                  this.stageText.stage.focus = null;
                  break;
               }
               _loc2_ = _loc2_.parent;
            }
            while(_loc2_);
         }
         else
         {
            this.removeEventListener(starling.events.Event.ENTER_FRAME,this.hasFocus_enterFrameHandler);
         }
      }
      
      protected function stageText_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(!this._multiline && (param1.keyCode == Keyboard.ENTER || param1.keyCode == Keyboard.NEXT))
         {
            param1.preventDefault();
            this.dispatchEventWith(FeathersEventType.ENTER);
         }
         else if(param1.keyCode == Keyboard.BACK)
         {
            param1.preventDefault();
            Starling.current.nativeStage.focus = Starling.current.nativeStage;
         }
         if(param1.keyCode === Keyboard.TAB && Boolean(FocusManager.isEnabledForStage(this.stage)))
         {
            param1.preventDefault();
            this.dispatchKeyFocusChangeEvent(param1);
         }
      }
      
      protected function stageText_keyUpHandler(param1:KeyboardEvent) : void
      {
         if(!this._multiline && (param1.keyCode == Keyboard.ENTER || param1.keyCode == Keyboard.NEXT))
         {
            param1.preventDefault();
         }
         if(param1.keyCode === Keyboard.TAB && Boolean(FocusManager.isEnabledForStage(this.stage)))
         {
            param1.preventDefault();
         }
      }
      
      protected function stageText_softKeyboardActivateHandler(param1:SoftKeyboardEvent) : void
      {
         this.dispatchEventWith(FeathersEventType.SOFT_KEYBOARD_ACTIVATE,true);
      }
      
      protected function stageText_softKeyboardDeactivateHandler(param1:SoftKeyboardEvent) : void
      {
         this.dispatchEventWith(FeathersEventType.SOFT_KEYBOARD_DEACTIVATE,true);
      }
   }
}

