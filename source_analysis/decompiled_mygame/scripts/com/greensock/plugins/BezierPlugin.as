package com.greensock.plugins
{
   import com.greensock.TweenLite;
   import flash.geom.*;
   
   public class BezierPlugin extends TweenPlugin
   {
      
      public static const API:Number = 2;
      
      protected static const _RAD2DEG:Number = 180 / Math.PI;
      
      protected static var _r1:Array = [];
      
      protected static var _r2:Array = [];
      
      protected static var _r3:Array = [];
      
      protected static var _corProps:Object = {};
      
      protected var _target:Object;
      
      protected var _autoRotate:Array;
      
      protected var _round:Object;
      
      protected var _lengths:Array;
      
      protected var _segments:Array;
      
      protected var _length:Number;
      
      protected var _func:Object;
      
      protected var _props:Array;
      
      protected var _l1:Number;
      
      protected var _l2:Number;
      
      protected var _li:Number;
      
      protected var _curSeg:Array;
      
      protected var _s1:Number;
      
      protected var _s2:Number;
      
      protected var _si:Number;
      
      protected var _beziers:Object;
      
      protected var _segCount:int;
      
      protected var _prec:Number;
      
      protected var _timeRes:int;
      
      protected var _initialRotations:Array;
      
      protected var _startRatio:int;
      
      public function BezierPlugin()
      {
         super("bezier");
         this._overwriteProps.pop();
         this._func = {};
         this._round = {};
      }
      
      public static function bezierThrough(param1:Array, param2:Number = 1, param3:Boolean = false, param4:Boolean = false, param5:String = "x,y,z", param6:Object = null) : Object
      {
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc11_:Array = null;
         var _loc12_:int = 0;
         var _loc13_:Number = Number(NaN);
         var _loc14_:Boolean = false;
         var _loc15_:Object = null;
         var _loc16_:Object = {};
         var _loc17_:Object = param6 || param1[0];
         param5 = "," + param5 + ",";
         if(_loc17_ is Point)
         {
            _loc7_ = ["x","y"];
         }
         else
         {
            _loc7_ = [];
            for(_loc9_ in _loc17_)
            {
               _loc7_.push(_loc9_);
            }
         }
         if(param1.length > 1)
         {
            _loc15_ = param1[param1.length - 1];
            _loc14_ = true;
            _loc8_ = int(_loc7_.length);
            while(--_loc8_ > -1)
            {
               _loc9_ = _loc7_[_loc8_];
               if(Math.abs(_loc17_[_loc9_] - _loc15_[_loc9_]) > 0.05)
               {
                  _loc14_ = false;
                  break;
               }
            }
            if(_loc14_)
            {
               param1 = param1.concat();
               if(param6)
               {
                  param1.unshift(param6);
               }
               param1.push(param1[1]);
               param6 = param1[param1.length - 3];
            }
         }
         _r1.length = _r2.length = _r3.length = 0;
         _loc8_ = int(_loc7_.length);
         while(--_loc8_ > -1)
         {
            _loc9_ = _loc7_[_loc8_];
            _corProps[_loc9_] = param5.indexOf("," + _loc9_ + ",") !== -1;
            _loc16_[_loc9_] = _parseAnchors(param1,_loc9_,_corProps[_loc9_],param6);
         }
         _loc8_ = int(_r1.length);
         while(--_loc8_ > -1)
         {
            _r1[_loc8_] = Math.sqrt(_r1[_loc8_]);
            _r2[_loc8_] = Math.sqrt(_r2[_loc8_]);
         }
         if(!param4)
         {
            _loc8_ = int(_loc7_.length);
            while(--_loc8_ > -1)
            {
               if(_corProps[_loc9_])
               {
                  _loc11_ = _loc16_[_loc7_[_loc8_]];
                  _loc12_ = _loc11_.length - 1;
                  _loc10_ = 0;
                  while(_loc10_ < _loc12_)
                  {
                     _loc13_ = _loc11_[_loc10_ + 1].da / _r2[_loc10_] + _loc11_[_loc10_].da / _r1[_loc10_];
                     _r3[_loc10_] = (_r3[_loc10_] || 0) + _loc13_ * _loc13_;
                     _loc10_++;
                  }
               }
            }
            _loc8_ = int(_r3.length);
            while(--_loc8_ > -1)
            {
               _r3[_loc8_] = Math.sqrt(_r3[_loc8_]);
            }
         }
         _loc8_ = int(_loc7_.length);
         _loc10_ = param3 ? 4 : 1;
         while(--_loc8_ > -1)
         {
            _loc9_ = _loc7_[_loc8_];
            _loc11_ = _loc16_[_loc9_];
            _calculateControlPoints(_loc11_,param2,param3,param4,_corProps[_loc9_]);
            if(_loc14_)
            {
               _loc11_.splice(0,_loc10_);
               _loc11_.splice(_loc11_.length - _loc10_,_loc10_);
            }
         }
         return _loc16_;
      }
      
      public static function _parseBezierData(param1:Array, param2:String, param3:Object = null) : Object
      {
         var _loc19_:Number = NaN;
         var _loc4_:Number = Number(NaN);
         var _loc5_:Number = Number(NaN);
         var _loc6_:Number = Number(NaN);
         var _loc7_:Number = Number(NaN);
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:String = null;
         var _loc14_:* = 0;
         var _loc15_:Object = null;
         param2 ||= "soft";
         var _loc16_:Object = {};
         var _loc17_:int = param2 === "cubic" ? 3 : 2;
         var _loc18_:Boolean = param2 === "soft";
         if(_loc18_ && Boolean(param3))
         {
            param1 = [param3].concat(param1);
         }
         if(param1 == null || param1.length < _loc17_ + 1)
         {
            throw new Error("invalid Bezier data");
         }
         if(param1[1] is Point)
         {
            _loc9_ = ["x","y"];
         }
         else
         {
            _loc9_ = [];
            for(_loc13_ in param1[0])
            {
               _loc9_.push(_loc13_);
            }
         }
         _loc10_ = int(_loc9_.length);
         while(--_loc10_ > -1)
         {
            _loc13_ = _loc9_[_loc10_];
            _loc16_[_loc13_] = _loc8_ = [];
            _loc14_ = 0;
            _loc12_ = int(param1.length);
            _loc11_ = 0;
            while(_loc11_ < _loc12_)
            {
               _loc15_ = param1[_loc11_][_loc13_];
               _loc4_ = param3 == null ? Number(param1[_loc11_][_loc13_]) : (typeof _loc15_ === "string" && _loc15_.charAt(1) === "=" ? param3[_loc13_] + Number(_loc15_.charAt(0) + _loc15_.substr(2)) : Number(_loc15_));
               if(_loc18_)
               {
                  if(_loc11_ > 1)
                  {
                     if(_loc11_ < _loc12_ - 1)
                     {
                        _loc8_[_loc19_ = _loc14_++] = (_loc4_ + _loc8_[_loc14_ - 2]) / 2;
                     }
                  }
               }
               _loc8_[_loc19_ = _loc14_++] = _loc4_;
               _loc11_++;
            }
            _loc12_ = _loc14_ - _loc17_ + 1;
            _loc14_ = 0;
            _loc11_ = 0;
            while(_loc11_ < _loc12_)
            {
               _loc4_ = Number(_loc8_[_loc11_]);
               _loc5_ = Number(_loc8_[_loc11_ + 1]);
               _loc6_ = Number(_loc8_[_loc11_ + 2]);
               _loc7_ = _loc17_ === 2 ? 0 : Number(_loc8_[_loc11_ + 3]);
               _loc8_[_loc19_ = _loc14_++] = _loc17_ === 3 ? new Segment(_loc4_,_loc5_,_loc6_,_loc7_) : new Segment(_loc4_,(2 * _loc5_ + _loc4_) / 3,(2 * _loc5_ + _loc6_) / 3,_loc6_);
               _loc11_ += _loc17_;
            }
            _loc8_.length = _loc14_;
         }
         return _loc16_;
      }
      
      protected static function _parseAnchors(param1:Array, param2:String, param3:Boolean, param4:Object) : Array
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Number = Number(NaN);
         var _loc8_:Number = Number(NaN);
         var _loc9_:Number = Number(NaN);
         var _loc10_:Object = null;
         var _loc11_:Array = [];
         if(param4)
         {
            param1 = [param4].concat(param1);
            _loc6_ = int(param1.length);
            while(--_loc6_ > -1)
            {
               _loc10_ = param1[_loc6_][param2];
               if(typeof _loc10_ === "string")
               {
                  if(_loc10_.charAt(1) === "=")
                  {
                     param1[_loc6_][param2] = param4[param2] + Number(_loc10_.charAt(0) + _loc10_.substr(2));
                  }
               }
            }
         }
         _loc5_ = param1.length - 2;
         if(_loc5_ < 0)
         {
            _loc11_[0] = new Segment(param1[0][param2],0,0,param1[_loc5_ < -1 ? 0 : 1][param2]);
            return _loc11_;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = Number(param1[_loc6_][param2]);
            _loc8_ = Number(param1[_loc6_ + 1][param2]);
            _loc11_[_loc6_] = new Segment(_loc7_,0,0,_loc8_);
            if(param3)
            {
               _loc9_ = Number(param1[_loc6_ + 2][param2]);
               _r1[_loc6_] = (_r1[_loc6_] || 0) + (_loc8_ - _loc7_) * (_loc8_ - _loc7_);
               _r2[_loc6_] = (_r2[_loc6_] || 0) + (_loc9_ - _loc8_) * (_loc9_ - _loc8_);
            }
            _loc6_++;
         }
         _loc11_[_loc6_] = new Segment(param1[_loc6_][param2],0,0,param1[_loc6_ + 1][param2]);
         return _loc11_;
      }
      
      protected static function _calculateControlPoints(param1:Array, param2:Number = 1, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false) : void
      {
         var _loc6_:int = 0;
         var _loc7_:Number = Number(NaN);
         var _loc8_:Number = Number(NaN);
         var _loc9_:Number = Number(NaN);
         var _loc10_:Segment = null;
         var _loc11_:Number = Number(NaN);
         var _loc12_:Number = Number(NaN);
         var _loc13_:Number = Number(NaN);
         var _loc14_:Number = Number(NaN);
         var _loc15_:Array = null;
         var _loc16_:Number = Number(NaN);
         var _loc17_:Number = Number(NaN);
         var _loc18_:Number = Number(NaN);
         var _loc19_:int = param1.length - 1;
         var _loc20_:int = 0;
         var _loc21_:Number = Number(param1[0].a);
         _loc6_ = 0;
         while(_loc6_ < _loc19_)
         {
            _loc10_ = param1[_loc20_];
            _loc7_ = _loc10_.a;
            _loc8_ = _loc10_.d;
            _loc9_ = Number(param1[_loc20_ + 1].d);
            if(param5)
            {
               _loc16_ = Number(_r1[_loc6_]);
               _loc17_ = Number(_r2[_loc6_]);
               _loc18_ = (_loc17_ + _loc16_) * param2 * 0.25 / (param4 ? 0.5 : _r3[_loc6_] || 0.5);
               _loc11_ = _loc8_ - (_loc8_ - _loc7_) * (param4 ? param2 * 0.5 : (_loc16_ !== 0 ? _loc18_ / _loc16_ : 0));
               _loc12_ = _loc8_ + (_loc9_ - _loc8_) * (param4 ? param2 * 0.5 : (_loc17_ !== 0 ? _loc18_ / _loc17_ : 0));
               _loc13_ = _loc8_ - (_loc11_ + ((_loc12_ - _loc11_) * (_loc16_ * 3 / (_loc16_ + _loc17_) + 0.5) / 4 || 0));
            }
            else
            {
               _loc11_ = _loc8_ - (_loc8_ - _loc7_) * param2 * 0.5;
               _loc12_ = _loc8_ + (_loc9_ - _loc8_) * param2 * 0.5;
               _loc13_ = _loc8_ - (_loc11_ + _loc12_) / 2;
            }
            _loc11_ += _loc13_;
            _loc12_ += _loc13_;
            _loc10_.c = _loc14_ = _loc11_;
            if(_loc6_ != 0)
            {
               _loc10_.b = _loc21_;
            }
            else
            {
               _loc10_.b = _loc21_ = _loc10_.a + (_loc10_.c - _loc10_.a) * 0.6;
            }
            _loc10_.da = _loc8_ - _loc7_;
            _loc10_.ca = _loc14_ - _loc7_;
            _loc10_.ba = _loc21_ - _loc7_;
            if(param3)
            {
               _loc15_ = cubicToQuadratic(_loc7_,_loc21_,_loc14_,_loc8_);
               param1.splice(_loc20_,1,_loc15_[0],_loc15_[1],_loc15_[2],_loc15_[3]);
               _loc20_ += 4;
            }
            else
            {
               _loc20_++;
            }
            _loc21_ = _loc12_;
            _loc6_++;
         }
         _loc10_ = param1[_loc20_];
         _loc10_.b = _loc21_;
         _loc10_.c = _loc21_ + (_loc10_.d - _loc21_) * 0.4;
         _loc10_.da = _loc10_.d - _loc10_.a;
         _loc10_.ca = _loc10_.c - _loc10_.a;
         _loc10_.ba = _loc21_ - _loc10_.a;
         if(param3)
         {
            _loc15_ = cubicToQuadratic(_loc10_.a,_loc21_,_loc10_.c,_loc10_.d);
            param1.splice(_loc20_,1,_loc15_[0],_loc15_[1],_loc15_[2],_loc15_[3]);
         }
      }
      
      public static function cubicToQuadratic(param1:Number, param2:Number, param3:Number, param4:Number) : Array
      {
         var _loc5_:Object = {"a":param1};
         var _loc6_:Object = {};
         var _loc7_:Object = {};
         var _loc8_:Object = {"c":param4};
         var _loc9_:Number = (param1 + param2) / 2;
         var _loc10_:Number = (param2 + param3) / 2;
         var _loc11_:Number = (param3 + param4) / 2;
         var _loc12_:Number = (_loc9_ + _loc10_) / 2;
         var _loc13_:Number = (_loc10_ + _loc11_) / 2;
         var _loc14_:Number = (_loc13_ - _loc12_) / 8;
         _loc5_.b = _loc9_ + (param1 - _loc9_) / 4;
         _loc6_.b = _loc12_ + _loc14_;
         _loc5_.c = _loc6_.a = (_loc5_.b + _loc6_.b) / 2;
         _loc6_.c = _loc7_.a = (_loc12_ + _loc13_) / 2;
         _loc7_.b = _loc13_ - _loc14_;
         _loc8_.b = _loc11_ + (param4 - _loc11_) / 4;
         _loc7_.c = _loc8_.a = (_loc7_.b + _loc8_.b) / 2;
         return [_loc5_,_loc6_,_loc7_,_loc8_];
      }
      
      public static function quadraticToCubic(param1:Number, param2:Number, param3:Number) : Object
      {
         return new Segment(param1,(2 * param2 + param1) / 3,(2 * param2 + param3) / 3,param3);
      }
      
      protected static function _parseLengthData(param1:Object, param2:uint = 6) : Object
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = Number(NaN);
         var _loc7_:Array = [];
         var _loc8_:Array = [];
         var _loc9_:Number = 0;
         var _loc10_:Number = 0;
         var _loc11_:int = param2 - 1;
         var _loc12_:Array = [];
         var _loc13_:Array = [];
         for(_loc3_ in param1)
         {
            _addCubicLengths(param1[_loc3_],_loc7_,param2);
         }
         _loc5_ = int(_loc7_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc9_ += Math.sqrt(_loc7_[_loc4_]);
            _loc6_ = _loc4_ % param2;
            _loc13_[_loc6_] = _loc9_;
            if(_loc6_ == _loc11_)
            {
               _loc10_ += _loc9_;
               _loc6_ = _loc4_ / param2 >> 0;
               _loc12_[_loc6_] = _loc13_;
               _loc8_[_loc6_] = _loc10_;
               _loc9_ = 0;
               _loc13_ = [];
            }
            _loc4_++;
         }
         return {
            "length":_loc10_,
            "lengths":_loc8_,
            "segments":_loc12_
         };
      }
      
      private static function _addCubicLengths(param1:Array, param2:Array, param3:uint = 6) : void
      {
         var _loc4_:Number = Number(NaN);
         var _loc5_:Number = Number(NaN);
         var _loc6_:Number = Number(NaN);
         var _loc7_:Number = Number(NaN);
         var _loc8_:Number = Number(NaN);
         var _loc9_:Number = Number(NaN);
         var _loc10_:Number = Number(NaN);
         var _loc11_:int = 0;
         var _loc12_:Number = Number(NaN);
         var _loc13_:Segment = null;
         var _loc14_:int = 0;
         var _loc15_:Number = 1 / param3;
         var _loc16_:int = int(param1.length);
         while(--_loc16_ > -1)
         {
            _loc13_ = param1[_loc16_];
            _loc6_ = _loc13_.a;
            _loc7_ = _loc13_.d - _loc6_;
            _loc8_ = _loc13_.c - _loc6_;
            _loc9_ = _loc13_.b - _loc6_;
            _loc4_ = _loc5_ = 0;
            _loc11_ = 1;
            while(_loc11_ <= param3)
            {
               _loc10_ = _loc15_ * _loc11_;
               _loc12_ = 1 - _loc10_;
               _loc4_ = _loc5_ - (_loc5_ = (_loc10_ * _loc10_ * _loc7_ + 3 * _loc12_ * (_loc10_ * _loc8_ + _loc12_ * _loc9_)) * _loc10_);
               _loc14_ = _loc16_ * param3 + _loc11_ - 1;
               param2[_loc14_] = (param2[_loc14_] || 0) + _loc4_ * _loc4_;
               _loc11_++;
            }
         }
      }
      
      override public function _onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         var _loc4_:String = null;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Array = null;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         this._target = param1;
         var _loc11_:Object = param2 is Array ? {"values":param2} : param2;
         this._props = [];
         this._timeRes = _loc11_.timeResolution == null ? 6 : int(_loc11_.timeResolution);
         var _loc12_:Array = _loc11_.values || [];
         var _loc13_:Object = {};
         var _loc14_:Object = _loc12_[0];
         var _loc15_:Object = _loc11_.autoRotate || param3.vars.orientToBezier;
         this._autoRotate = _loc15_ ? (_loc15_ is Array ? _loc15_ as Array : [["x","y","rotation",_loc15_ === true ? 0 : Number(_loc15_)]]) : null;
         if(_loc14_ is Point)
         {
            this._props = ["x","y"];
         }
         else
         {
            for(_loc4_ in _loc14_)
            {
               this._props.push(_loc4_);
            }
         }
         _loc6_ = int(this._props.length);
         while(--_loc6_ > -1)
         {
            _loc4_ = this._props[_loc6_];
            this._overwriteProps.push(_loc4_);
            _loc5_ = Boolean(this._func[_loc4_] = param1[_loc4_] is Function);
            _loc13_[_loc4_] = !_loc5_ ? param1[_loc4_] : param1[Boolean(_loc4_.indexOf("set")) || !("get" + _loc4_.substr(3) in param1) ? _loc4_ : "get" + _loc4_.substr(3)]();
            if(!_loc9_)
            {
               if(_loc13_[_loc4_] !== _loc12_[0][_loc4_])
               {
                  _loc9_ = _loc13_;
               }
            }
         }
         this._beziers = _loc11_.type !== "cubic" && _loc11_.type !== "quadratic" && _loc11_.type !== "soft" ? bezierThrough(_loc12_,isNaN(_loc11_.curviness) ? 1 : Number(_loc11_.curviness),false,_loc11_.type === "thruBasic",_loc11_.correlate || "x,y,z",_loc9_) : _parseBezierData(_loc12_,_loc11_.type,_loc13_);
         this._segCount = this._beziers[_loc4_].length;
         if(this._timeRes)
         {
            _loc10_ = _parseLengthData(this._beziers,this._timeRes);
            this._length = _loc10_.length;
            this._lengths = _loc10_.lengths;
            this._segments = _loc10_.segments;
            this._l1 = this._li = this._s1 = this._si = 0;
            this._l2 = this._lengths[0];
            this._curSeg = this._segments[0];
            this._s2 = this._curSeg[0];
            this._prec = 1 / this._curSeg.length;
         }
         _loc8_ = this._autoRotate;
         if(_loc8_)
         {
            this._initialRotations = [];
            if(!(_loc8_[0] is Array))
            {
               this._autoRotate = _loc8_ = [_loc8_];
            }
            _loc6_ = int(_loc8_.length);
            while(--_loc6_ > -1)
            {
               _loc7_ = 0;
               while(_loc7_ < 3)
               {
                  _loc4_ = _loc8_[_loc6_][_loc7_];
                  this._func[_loc4_] = param1[_loc4_] is Function ? param1[Boolean(_loc4_.indexOf("set")) || !("get" + _loc4_.substr(3) in param1) ? _loc4_ : "get" + _loc4_.substr(3)] : false;
                  _loc7_++;
               }
               _loc4_ = _loc8_[_loc6_][2];
               this._initialRotations[_loc6_] = this._func[_loc4_] ? this._func[_loc4_]() : this._target[_loc4_];
            }
         }
         this._startRatio = param3.vars.runBackwards ? 1 : 0;
         return true;
      }
      
      override public function _kill(param1:Object) : Boolean
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:Array = this._props;
         for(_loc2_ in this._beziers)
         {
            if(_loc2_ in param1)
            {
               delete this._beziers[_loc2_];
               delete this._func[_loc2_];
               _loc3_ = int(_loc4_.length);
               while(--_loc3_ > -1)
               {
                  if(_loc4_[_loc3_] === _loc2_)
                  {
                     _loc4_.splice(_loc3_,1);
                  }
               }
            }
         }
         return super._kill(param1);
      }
      
      override public function _roundProps(param1:Object, param2:Boolean = true) : void
      {
         var _loc3_:Array = this._overwriteProps;
         var _loc4_:int = int(_loc3_.length);
         while(--_loc4_ > -1)
         {
            if(_loc3_[_loc4_] in param1 || "bezier" in param1 || "bezierThrough" in param1)
            {
               this._round[_loc3_[_loc4_]] = param2;
            }
         }
      }
      
      override public function setRatio(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = Number(NaN);
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:Segment = null;
         var _loc7_:Number = Number(NaN);
         var _loc8_:Number = Number(NaN);
         var _loc9_:int = 0;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:Array = null;
         var _loc13_:Segment = null;
         var _loc14_:Number = Number(NaN);
         var _loc15_:Number = Number(NaN);
         var _loc16_:Number = Number(NaN);
         var _loc17_:Number = Number(NaN);
         var _loc18_:Number = Number(NaN);
         var _loc19_:Number = Number(NaN);
         var _loc20_:int = this._segCount;
         var _loc21_:Object = this._func;
         var _loc22_:Object = this._target;
         var _loc23_:Boolean = param1 !== this._startRatio;
         if(this._timeRes == 0)
         {
            _loc2_ = param1 < 0 ? 0 : (param1 >= 1 ? int(_loc20_ - 1) : _loc20_ * param1 >> 0);
            _loc7_ = (param1 - _loc2_ * (1 / _loc20_)) * _loc20_;
         }
         else
         {
            _loc10_ = this._lengths;
            _loc11_ = this._curSeg;
            param1 *= this._length;
            _loc4_ = this._li;
            if(param1 > this._l2 && _loc4_ < _loc20_ - 1)
            {
               _loc9_ = _loc20_ - 1;
               while(_loc4_ < _loc9_ && (this._l2 = _loc10_[++_loc4_]) <= param1)
               {
               }
               this._l1 = _loc10_[_loc4_ - 1];
               this._li = _loc4_;
               this._curSeg = _loc11_ = this._segments[_loc4_];
               this._s2 = _loc11_[this._s1 = this._si = 0];
            }
            else if(param1 < this._l1 && _loc4_ > 0)
            {
               while(_loc4_ > 0 && (this._l1 = _loc10_[--_loc4_]) >= param1)
               {
               }
               if(_loc4_ === 0 && param1 < this._l1)
               {
                  this._l1 = 0;
               }
               else
               {
                  _loc4_++;
               }
               this._l2 = _loc10_[_loc4_];
               this._li = _loc4_;
               this._curSeg = _loc11_ = this._segments[_loc4_];
               this._s1 = Number(_loc11_[(this._si = _loc11_.length - 1) - 1]) || 0;
               this._s2 = _loc11_[this._si];
            }
            _loc2_ = _loc4_;
            param1 -= this._l1;
            _loc4_ = this._si;
            if(param1 > this._s2 && _loc4_ < _loc11_.length - 1)
            {
               _loc9_ = _loc11_.length - 1;
               while(_loc4_ < _loc9_ && (this._s2 = _loc11_[++_loc4_]) <= param1)
               {
               }
               this._s1 = _loc11_[_loc4_ - 1];
               this._si = _loc4_;
            }
            else if(param1 < this._s1 && _loc4_ > 0)
            {
               while(_loc4_ > 0 && (this._s1 = _loc11_[--_loc4_]) >= param1)
               {
               }
               if(_loc4_ === 0 && param1 < this._s1)
               {
                  this._s1 = 0;
               }
               else
               {
                  _loc4_++;
               }
               this._s2 = _loc11_[_loc4_];
               this._si = _loc4_;
            }
            _loc7_ = (_loc4_ + (param1 - this._s1) / (this._s2 - this._s1)) * this._prec;
         }
         _loc3_ = 1 - _loc7_;
         _loc4_ = int(this._props.length);
         while(--_loc4_ > -1)
         {
            _loc5_ = this._props[_loc4_];
            _loc6_ = this._beziers[_loc5_][_loc2_];
            _loc8_ = (_loc7_ * _loc7_ * _loc6_.da + 3 * _loc3_ * (_loc7_ * _loc6_.ca + _loc3_ * _loc6_.ba)) * _loc7_ + _loc6_.a;
            if(this._round[_loc5_])
            {
               _loc8_ = _loc8_ + (_loc8_ > 0 ? 0.5 : -0.5) >> 0;
            }
            if(_loc21_[_loc5_])
            {
               _loc22_[_loc5_](_loc8_);
            }
            else
            {
               _loc22_[_loc5_] = _loc8_;
            }
         }
         if(this._autoRotate != null)
         {
            _loc12_ = this._autoRotate;
            _loc4_ = int(_loc12_.length);
            while(--_loc4_ > -1)
            {
               _loc5_ = _loc12_[_loc4_][2];
               _loc18_ = Number(Number(_loc12_[_loc4_][3]) || 0);
               _loc19_ = _loc12_[_loc4_][4] == true ? 1 : _RAD2DEG;
               _loc6_ = this._beziers[_loc12_[_loc4_][0]][_loc2_];
               _loc13_ = this._beziers[_loc12_[_loc4_][1]][_loc2_];
               _loc14_ = _loc6_.a + (_loc6_.b - _loc6_.a) * _loc7_;
               _loc16_ = _loc6_.b + (_loc6_.c - _loc6_.b) * _loc7_;
               _loc14_ += (_loc16_ - _loc14_) * _loc7_;
               _loc16_ += (_loc6_.c + (_loc6_.d - _loc6_.c) * _loc7_ - _loc16_) * _loc7_;
               _loc15_ = _loc13_.a + (_loc13_.b - _loc13_.a) * _loc7_;
               _loc17_ = _loc13_.b + (_loc13_.c - _loc13_.b) * _loc7_;
               _loc15_ += (_loc17_ - _loc15_) * _loc7_;
               _loc17_ += (_loc13_.c + (_loc13_.d - _loc13_.c) * _loc7_ - _loc17_) * _loc7_;
               _loc8_ = _loc23_ ? Math.atan2(_loc17_ - _loc15_,_loc16_ - _loc14_) * _loc19_ + _loc18_ : Number(this._initialRotations[_loc4_]);
               if(_loc21_[_loc5_])
               {
                  _loc22_[_loc5_](_loc8_);
               }
               else
               {
                  _loc22_[_loc5_] = _loc8_;
               }
            }
         }
      }
   }
}

class Segment
{
   
   public var a:Number;
   
   public var b:Number;
   
   public var c:Number;
   
   public var d:Number;
   
   public var da:Number;
   
   public var ca:Number;
   
   public var ba:Number;
   
   public function Segment(param1:Number, param2:Number, param3:Number, param4:Number)
   {
      super();
      this.a = param1;
      this.b = param2;
      this.c = param3;
      this.d = param4;
      this.da = param4 - param1;
      this.ca = param3 - param1;
      this.ba = param2 - param1;
   }
}
