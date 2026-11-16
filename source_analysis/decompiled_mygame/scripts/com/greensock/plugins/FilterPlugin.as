package com.greensock.plugins
{
   import com.greensock.TweenLite;
   import flash.filters.*;
   
   public class FilterPlugin extends TweenPlugin
   {
      
      public static const API:Number = 2;
      
      protected var _target:Object;
      
      protected var _type:Class;
      
      protected var _filter:BitmapFilter;
      
      protected var _index:int;
      
      protected var _remove:Boolean;
      
      private var _tween:TweenLite;
      
      public function FilterPlugin(param1:String = "", param2:Number = 0)
      {
         super(param1,param2);
      }
      
      protected function _initFilter(param1:*, param2:Object, param3:TweenLite, param4:Class, param5:BitmapFilter, param6:Array) : Boolean
      {
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:HexColorsPlugin = null;
         this._target = param1;
         this._tween = param3;
         this._type = param4;
         var _loc10_:Array = this._target.filters;
         var _loc11_:Object = param2 is BitmapFilter ? {} : param2;
         if(_loc11_.index != null)
         {
            this._index = _loc11_.index;
         }
         else
         {
            this._index = _loc10_.length;
            if(_loc11_.addFilter != true)
            {
               while(--this._index > -1 && !(_loc10_[this._index] is this._type))
               {
               }
            }
         }
         if(this._index < 0 || !(_loc10_[this._index] is this._type))
         {
            if(this._index < 0)
            {
               this._index = _loc10_.length;
            }
            if(this._index > _loc10_.length)
            {
               _loc8_ = _loc10_.length - 1;
               while(++_loc8_ < this._index)
               {
                  _loc10_[_loc8_] = new BlurFilter(0,0,1);
               }
            }
            _loc10_[this._index] = param5;
            this._target.filters = _loc10_;
         }
         this._filter = _loc10_[this._index];
         this._remove = _loc11_.remove == true;
         _loc8_ = int(param6.length);
         while(--_loc8_ > -1)
         {
            _loc7_ = param6[_loc8_];
            if(_loc7_ in param2 && this._filter[_loc7_] != param2[_loc7_])
            {
               if(_loc7_ == "color" || _loc7_ == "highlightColor" || _loc7_ == "shadowColor")
               {
                  _loc9_ = new HexColorsPlugin();
                  _loc9_._initColor(this._filter,_loc7_,param2[_loc7_]);
                  _addTween(_loc9_,"setRatio",0,1,_propName);
               }
               else if(_loc7_ == "quality" || _loc7_ == "inner" || _loc7_ == "knockout" || _loc7_ == "hideObject")
               {
                  this._filter[_loc7_] = param2[_loc7_];
               }
               else
               {
                  _addTween(this._filter,_loc7_,this._filter[_loc7_],param2[_loc7_],_propName);
               }
            }
         }
         return true;
      }
      
      override public function setRatio(param1:Number) : void
      {
         super.setRatio(param1);
         var _loc2_:Array = this._target.filters;
         if(!(_loc2_[this._index] is this._type))
         {
            this._index = _loc2_.length;
            while(--this._index > -1 && !(_loc2_[this._index] is this._type))
            {
            }
            if(this._index == -1)
            {
               this._index = _loc2_.length;
            }
         }
         if(param1 == 1 && this._remove && this._tween._time == this._tween._duration && this._tween.data != "isFromStart")
         {
            if(this._index < _loc2_.length)
            {
               _loc2_.splice(this._index,1);
            }
         }
         else
         {
            _loc2_[this._index] = this._filter;
         }
         this._target.filters = _loc2_;
      }
   }
}

