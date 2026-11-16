package starling.filters
{
   import starling.events.*;
   import starling.rendering.Painter;
   import starling.textures.Texture;
   import starling.utils.*;
   
   public class FilterChain extends FragmentFilter
   {
      
      private static var sPadding:Padding = new Padding();
      
      private var _filters:Vector.<FragmentFilter>;
      
      public function FilterChain(... rest)
      {
         var _loc2_:FragmentFilter = null;
         super();
         this._filters = new Vector.<FragmentFilter>(0);
         var _loc3_:int = 0;
         var _loc4_:int = int(rest.length);
         while(_loc3_ < _loc4_)
         {
            _loc2_ = rest[_loc3_] as FragmentFilter;
            if(!_loc2_)
            {
               throw new ArgumentError("pass only fragment filters to the constructor");
            }
            this.addFilterAt(_loc2_,_loc3_);
            _loc3_++;
         }
         this.updatePadding();
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      override public function dispose() : void
      {
         var _loc1_:FragmentFilter = null;
         for each(_loc1_ in this._filters)
         {
            _loc1_.dispose();
         }
         this._filters.length = 0;
         super.dispose();
      }
      
      override protected function setRequiresRedraw() : void
      {
         this.updatePadding();
         super.setRequiresRedraw();
      }
      
      override public function process(param1:Painter, param2:IFilterHelper, param3:Texture = null, param4:Texture = null, param5:Texture = null, param6:Texture = null) : Texture
      {
         var _loc7_:Texture = null;
         var _loc8_:int = int(this._filters.length);
         var _loc9_:Texture = param3;
         var _loc10_:int = 0;
         while(_loc10_ < _loc8_)
         {
            _loc7_ = _loc9_;
            _loc9_ = this._filters[_loc10_].process(param1,param2,_loc7_);
            if(_loc10_)
            {
               param2.putTexture(_loc7_);
            }
            _loc10_++;
         }
         return _loc9_;
      }
      
      override public function get numPasses() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = int(this._filters.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ += this._filters[_loc3_].numPasses;
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function getFilterAt(param1:int) : FragmentFilter
      {
         if(param1 < 0)
         {
            param1 += this.numFilters;
         }
         return this._filters[param1];
      }
      
      public function addFilter(param1:FragmentFilter) : void
      {
         this.addFilterAt(param1,this._filters.length);
      }
      
      public function addFilterAt(param1:FragmentFilter, param2:int) : void
      {
         this._filters.insertAt(param2,param1);
         param1.addEventListener(Event.CHANGE,this.setRequiresRedraw);
         this.setRequiresRedraw();
      }
      
      public function removeFilter(param1:FragmentFilter, param2:Boolean = false) : FragmentFilter
      {
         var _loc3_:int = this.getFilterIndex(param1);
         if(_loc3_ != -1)
         {
            this.removeFilterAt(_loc3_,param2);
         }
         return param1;
      }
      
      public function removeFilterAt(param1:int, param2:Boolean = false) : FragmentFilter
      {
         var _loc3_:FragmentFilter = this._filters.removeAt(param1) as FragmentFilter;
         _loc3_.removeEventListener(Event.CHANGE,this.setRequiresRedraw);
         if(param2)
         {
            _loc3_.dispose();
         }
         this.setRequiresRedraw();
         return _loc3_;
      }
      
      public function getFilterIndex(param1:FragmentFilter) : int
      {
         return this._filters.indexOf(param1);
      }
      
      private function updatePadding() : void
      {
         var _loc1_:FragmentFilter = null;
         var _loc2_:Padding = null;
         sPadding.setTo();
         for each(_loc1_ in this._filters)
         {
            _loc2_ = _loc1_.padding;
            if(_loc2_.left > sPadding.left)
            {
               sPadding.left = _loc2_.left;
            }
            if(_loc2_.right > sPadding.right)
            {
               sPadding.right = _loc2_.right;
            }
            if(_loc2_.top > sPadding.top)
            {
               sPadding.top = _loc2_.top;
            }
            if(_loc2_.bottom > sPadding.bottom)
            {
               sPadding.bottom = _loc2_.bottom;
            }
         }
         this.padding.copyFrom(sPadding);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = int(this._filters.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this._filters[_loc2_].dispatchEvent(param1);
            _loc2_++;
         }
      }
      
      public function get numFilters() : int
      {
         return this._filters.length;
      }
   }
}

