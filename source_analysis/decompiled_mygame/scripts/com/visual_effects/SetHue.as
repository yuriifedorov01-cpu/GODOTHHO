package com.visual_effects
{
   import fl.motion.*;
   import flash.display.DisplayObject;
   import flash.filters.ColorMatrixFilter;
   import flash.utils.*;
   import starling.display.DisplayObject;
   import starling.filters.*;
   
   public class SetHue
   {
      
      public function SetHue()
      {
         super();
      }
      
      public static function setObjectHue(param1:flash.display.DisplayObject, param2:int, param3:int = 0, param4:int = 0, param5:int = 0) : int
      {
         var _loc6_:AdjustColor = new AdjustColor();
         _loc6_.brightness = param3;
         _loc6_.contrast = param5;
         _loc6_.saturation = param4;
         _loc6_.hue = param2;
         var _loc7_:Array = _loc6_.CalculateFinalFlatArray();
         var _loc8_:flash.filters.ColorMatrixFilter = new flash.filters.ColorMatrixFilter(_loc7_);
         param1.filters = [_loc8_];
         return param2;
      }
      
      public static function setStarlingObjectHue(param1:starling.display.DisplayObject, param2:int, param3:int = 0, param4:int = 0, param5:int = 0) : void
      {
         var _loc6_:AdjustColor = new AdjustColor();
         _loc6_.brightness = param3;
         _loc6_.contrast = param5;
         _loc6_.saturation = param4;
         _loc6_.hue = param2;
         var _loc7_:Vector.<Number> = Vector.<Number>(_loc6_.CalculateFinalFlatArray());
         var _loc8_:starling.filters.ColorMatrixFilter = new starling.filters.ColorMatrixFilter(_loc7_);
         var _loc9_:FilterChain = new FilterChain(_loc8_);
         param1.filter = _loc9_;
      }
      
      public static function tintObject(param1:starling.display.DisplayObject, param2:int = 16711680, param3:Boolean = true, param4:Number = 1) : void
      {
         var _object:starling.display.DisplayObject = param1;
         var _tint:int = param2;
         var _tween:Boolean = param3;
         var _alpha:Number = param4;
         var colorFilter:starling.filters.ColorMatrixFilter = null;
         var filterChain:FilterChain = null;
         if(_object.filter == null)
         {
            colorFilter = new starling.filters.ColorMatrixFilter();
            colorFilter.tint(_tint,_alpha);
            filterChain = new FilterChain(colorFilter);
            _object.filter = filterChain;
            if(_tween)
            {
               setTimeout(function():void
               {
                  _object.filter = null;
               },150);
            }
         }
      }
   }
}

