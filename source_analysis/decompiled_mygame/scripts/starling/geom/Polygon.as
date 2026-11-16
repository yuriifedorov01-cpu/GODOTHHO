package starling.geom
{
   import flash.geom.*;
   import flash.utils.*;
   import starling.rendering.*;
   import starling.utils.*;
   
   public class Polygon
   {
      
      private static var sRestIndices:Vector.<uint> = new Vector.<uint>(0);
      
      private var _coords:Vector.<Number>;
      
      public function Polygon(param1:Array = null)
      {
         super();
         this._coords = new Vector.<Number>(0);
         this.addVertices.apply(this,param1);
      }
      
      public static function createEllipse(param1:Number, param2:Number, param3:Number, param4:Number) : Polygon
      {
         return new Ellipse(param1,param2,param3,param4);
      }
      
      public static function createCircle(param1:Number, param2:Number, param3:Number) : Polygon
      {
         return new Ellipse(param1,param2,param3,param3);
      }
      
      public static function createRectangle(param1:Number, param2:Number, param3:Number, param4:Number) : Polygon
      {
         return new PolygonRectangle(param1,param2,param3,param4);
      }
      
      private static function isConvexTriangle(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Boolean
      {
         return (param2 - param4) * (param5 - param3) + (param3 - param1) * (param6 - param4) >= 0;
      }
      
      private static function areVectorsIntersecting(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Boolean
      {
         if(param1 == param3 && param2 == param4 || param5 == param7 && param6 == param8)
         {
            return false;
         }
         var _loc9_:Number = param3 - param1;
         var _loc10_:Number = param4 - param2;
         var _loc11_:Number = param7 - param5;
         var _loc12_:Number = param8 - param6;
         var _loc13_:Number = _loc12_ * _loc9_ - _loc11_ * _loc10_;
         if(_loc13_ == 0)
         {
            return false;
         }
         var _loc14_:Number = (_loc10_ * (param5 - param1) - _loc9_ * (param6 - param2)) / _loc13_;
         if(_loc14_ < 0 || _loc14_ > 1)
         {
            return false;
         }
         var _loc15_:Number = _loc10_ ? (param6 - param2 + _loc14_ * _loc12_) / _loc10_ : (param5 - param1 + _loc14_ * _loc11_) / _loc9_;
         return _loc15_ >= 0 && _loc15_ <= 1;
      }
      
      public function clone() : Polygon
      {
         var _loc1_:Polygon = new Polygon();
         var _loc2_:int = int(this._coords.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_._coords[_loc3_] = this._coords[_loc3_];
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function reverse() : void
      {
         var _loc1_:Number = Number(NaN);
         var _loc2_:int = int(this._coords.length);
         var _loc3_:int = _loc2_ / 2;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc1_ = Number(this._coords[_loc4_]);
            this._coords[_loc4_] = this._coords[_loc2_ - _loc4_ - 2];
            this._coords[_loc2_ - _loc4_ - 2] = _loc1_;
            _loc1_ = Number(this._coords[_loc4_ + 1]);
            this._coords[_loc4_ + 1] = this._coords[_loc2_ - _loc4_ - 1];
            this._coords[_loc2_ - _loc4_ - 1] = _loc1_;
            _loc4_ += 2;
         }
      }
      
      public function addVertices(... rest) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = int(rest.length);
         var _loc4_:int = int(this._coords.length);
         if(_loc3_ > 0)
         {
            if(rest[0] is Point)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc3_)
               {
                  this._coords[_loc4_ + _loc2_ * 2] = (rest[_loc2_] as Point).x;
                  this._coords[_loc4_ + _loc2_ * 2 + 1] = (rest[_loc2_] as Point).y;
                  _loc2_++;
               }
            }
            else
            {
               if(!(rest[0] is Number))
               {
                  throw new ArgumentError("Invalid type: " + getQualifiedClassName(rest[0]));
               }
               _loc2_ = 0;
               while(_loc2_ < _loc3_)
               {
                  this._coords[_loc4_ + _loc2_] = rest[_loc2_];
                  _loc2_++;
               }
            }
         }
      }
      
      public function setVertex(param1:int, param2:Number, param3:Number) : void
      {
         if(param1 >= 0 && param1 <= this.numVertices)
         {
            this._coords[param1 * 2] = param2;
            this._coords[param1 * 2 + 1] = param3;
            return;
         }
         throw new RangeError("Invalid index: " + param1);
      }
      
      public function getVertex(param1:int, param2:Point = null) : Point
      {
         if(param1 >= 0 && param1 < this.numVertices)
         {
            param2 ||= new Point();
            param2.setTo(this._coords[param1 * 2],this._coords[param1 * 2 + 1]);
            return param2;
         }
         throw new RangeError("Invalid index: " + param1);
      }
      
      public function contains(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:Number = Number(NaN);
         var _loc5_:Number = Number(NaN);
         var _loc6_:Number = Number(NaN);
         var _loc7_:Number = Number(NaN);
         var _loc8_:int = this.numVertices - 1;
         var _loc9_:uint = 0;
         _loc3_ = 0;
         while(_loc3_ < this.numVertices)
         {
            _loc4_ = Number(this._coords[_loc3_ * 2]);
            _loc5_ = Number(this._coords[_loc3_ * 2 + 1]);
            _loc6_ = Number(this._coords[_loc8_ * 2]);
            _loc7_ = Number(this._coords[_loc8_ * 2 + 1]);
            if((_loc5_ < param2 && _loc7_ >= param2 || _loc7_ < param2 && _loc5_ >= param2) && (_loc4_ <= param1 || _loc6_ <= param1))
            {
               _loc9_ ^= uint(_loc4_ + (param2 - _loc5_) / (_loc7_ - _loc5_) * (_loc6_ - _loc4_) < param1);
            }
            _loc8_ = _loc3_;
            _loc3_++;
         }
         return _loc9_ != 0;
      }
      
      public function containsPoint(param1:Point) : Boolean
      {
         return this.contains(param1.x,param1.y);
      }
      
      public function triangulate(param1:IndexData = null, param2:int = 0) : IndexData
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:* = 0;
         var _loc6_:uint = 0;
         var _loc7_:Boolean = false;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:int = this.numVertices;
         var _loc12_:int = this.numTriangles;
         if(param1 == null)
         {
            param1 = new IndexData(_loc12_ * 3);
         }
         if(_loc12_ == 0)
         {
            return param1;
         }
         sRestIndices.length = _loc11_;
         _loc3_ = 0;
         while(_loc3_ < _loc11_)
         {
            sRestIndices[_loc3_] = _loc3_;
            _loc3_++;
         }
         _loc4_ = 0;
         _loc5_ = _loc11_;
         var _loc13_:Point = Pool.getPoint();
         var _loc14_:Point = Pool.getPoint();
         var _loc15_:Point = Pool.getPoint();
         var _loc16_:Point = Pool.getPoint();
         while(_loc5_ > 3)
         {
            _loc7_ = false;
            _loc8_ = uint(sRestIndices[_loc4_ % _loc5_]);
            _loc9_ = uint(sRestIndices[(_loc4_ + 1) % _loc5_]);
            _loc10_ = uint(sRestIndices[(_loc4_ + 2) % _loc5_]);
            _loc13_.setTo(this._coords[2 * _loc8_],this._coords[2 * _loc8_ + 1]);
            _loc14_.setTo(this._coords[2 * _loc9_],this._coords[2 * _loc9_ + 1]);
            _loc15_.setTo(this._coords[2 * _loc10_],this._coords[2 * _loc10_ + 1]);
            if(isConvexTriangle(_loc13_.x,_loc13_.y,_loc14_.x,_loc14_.y,_loc15_.x,_loc15_.y))
            {
               _loc7_ = true;
               _loc3_ = 3;
               while(_loc3_ < _loc5_)
               {
                  _loc6_ = uint(sRestIndices[(_loc4_ + _loc3_) % _loc5_]);
                  _loc16_.setTo(this._coords[2 * _loc6_],this._coords[2 * _loc6_ + 1]);
                  if(MathUtil.isPointInTriangle(_loc16_,_loc13_,_loc14_,_loc15_))
                  {
                     _loc7_ = false;
                     break;
                  }
                  _loc3_++;
               }
            }
            if(_loc7_)
            {
               param1.addTriangle(_loc8_ + param2,_loc9_ + param2,_loc10_ + param2);
               sRestIndices.removeAt((_loc4_ + 1) % _loc5_);
               _loc5_--;
               _loc4_ = 0;
            }
            else if(++_loc4_ == _loc5_)
            {
               break;
            }
         }
         Pool.putPoint(_loc13_);
         Pool.putPoint(_loc14_);
         Pool.putPoint(_loc15_);
         Pool.putPoint(_loc16_);
         param1.addTriangle(sRestIndices[0] + param2,sRestIndices[1] + param2,sRestIndices[2] + param2);
         return param1;
      }
      
      public function copyToVertexData(param1:VertexData = null, param2:int = 0, param3:String = "position") : void
      {
         var _loc4_:int = this.numVertices;
         var _loc5_:int = param2 + _loc4_;
         if(param1.numVertices < _loc5_)
         {
            param1.numVertices = _loc5_;
         }
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            param1.setPoint(param2 + _loc6_,param3,this._coords[_loc6_ * 2],this._coords[_loc6_ * 2 + 1]);
            _loc6_++;
         }
      }
      
      public function toString() : String
      {
         var _loc1_:String = "[Polygon";
         var _loc2_:int = this.numVertices;
         if(_loc2_ > 0)
         {
            _loc1_ += "\n";
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ += "  [Vertex " + _loc3_ + ": " + "x=" + this._coords[_loc3_ * 2].toFixed(1) + ", " + "y=" + this._coords[_loc3_ * 2 + 1].toFixed(1) + "]" + (_loc3_ == _loc2_ - 1 ? "\n" : ",\n");
            _loc3_++;
         }
         return _loc1_ + "]";
      }
      
      public function get isSimple() : Boolean
      {
         var _loc12_:int = 0;
         var _loc1_:Number = Number(NaN);
         var _loc2_:Number = Number(NaN);
         var _loc3_:Number = Number(NaN);
         var _loc4_:Number = Number(NaN);
         var _loc5_:Number = Number(NaN);
         var _loc6_:int = 0;
         var _loc7_:Number = Number(NaN);
         var _loc8_:Number = Number(NaN);
         var _loc9_:Number = Number(NaN);
         var _loc10_:Number = Number(NaN);
         var _loc11_:int = int(this._coords.length);
         if(_loc11_ <= 6)
         {
            return true;
         }
         _loc12_ = 0;
         loop0:
         while(_loc12_ < _loc11_)
         {
            _loc1_ = Number(this._coords[_loc12_]);
            _loc2_ = Number(this._coords[_loc12_ + 1]);
            _loc3_ = Number(this._coords[(_loc12_ + 2) % _loc11_]);
            _loc4_ = Number(this._coords[(_loc12_ + 3) % _loc11_]);
            _loc5_ = _loc12_ + _loc11_ - 2;
            _loc6_ = _loc12_ + 4;
            while(true)
            {
               if(_loc6_ >= _loc5_)
               {
                  _loc12_ += 2;
                  continue loop0;
               }
               _loc7_ = Number(this._coords[_loc6_ % _loc11_]);
               _loc8_ = Number(this._coords[(_loc6_ + 1) % _loc11_]);
               _loc9_ = Number(this._coords[(_loc6_ + 2) % _loc11_]);
               _loc10_ = Number(this._coords[(_loc6_ + 3) % _loc11_]);
               if(areVectorsIntersecting(_loc1_,_loc2_,_loc3_,_loc4_,_loc7_,_loc8_,_loc9_,_loc10_))
               {
                  break;
               }
               _loc6_ += 2;
            }
            return false;
         }
         return true;
      }
      
      public function get isConvex() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = int(this._coords.length);
         if(_loc2_ < 6)
         {
            return true;
         }
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(!isConvexTriangle(this._coords[_loc1_],this._coords[_loc1_ + 1],this._coords[(_loc1_ + 2) % _loc2_],this._coords[(_loc1_ + 3) % _loc2_],this._coords[(_loc1_ + 4) % _loc2_],this._coords[(_loc1_ + 5) % _loc2_]))
            {
               return false;
            }
            _loc1_ += 2;
         }
         return true;
      }
      
      public function get area() : Number
      {
         var _loc1_:int = 0;
         var _loc2_:Number = 0;
         var _loc3_:int = int(this._coords.length);
         if(_loc3_ >= 6)
         {
            _loc1_ = 0;
            while(_loc1_ < _loc3_)
            {
               _loc2_ += this._coords[_loc1_] * this._coords[(_loc1_ + 3) % _loc3_];
               _loc2_ -= this._coords[_loc1_ + 1] * this._coords[(_loc1_ + 2) % _loc3_];
               _loc1_ += 2;
            }
         }
         return _loc2_ / 2;
      }
      
      public function get numVertices() : int
      {
         return this._coords.length / 2;
      }
      
      public function set numVertices(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = this.numVertices;
         this._coords.length = param1 * 2;
         if(_loc3_ < param1)
         {
            _loc2_ = _loc3_;
            while(_loc2_ < param1)
            {
               this._coords[_loc2_ * 2] = this._coords[_loc2_ * 2 + 1] = 0;
               _loc2_++;
            }
         }
      }
      
      public function get numTriangles() : int
      {
         var _loc1_:int = this.numVertices;
         return _loc1_ >= 3 ? int(_loc1_ - 2) : 0;
      }
   }
}

import flash.errors.*;
import flash.utils.*;
import starling.geom.Polygon;
import starling.rendering.*;

class ImmutablePolygon extends Polygon
{
   
   private var _frozen:Boolean;
   
   public function ImmutablePolygon(param1:Array)
   {
      super(param1);
      this._frozen = true;
   }
   
   override public function addVertices(... rest) : void
   {
      if(this._frozen)
      {
         throw this.getImmutableError();
      }
      super.addVertices.apply(this,rest);
   }
   
   override public function setVertex(param1:int, param2:Number, param3:Number) : void
   {
      if(this._frozen)
      {
         throw this.getImmutableError();
      }
      super.setVertex(param1,param2,param3);
   }
   
   override public function reverse() : void
   {
      if(this._frozen)
      {
         throw this.getImmutableError();
      }
      super.reverse();
   }
   
   override public function set numVertices(param1:int) : void
   {
      if(this._frozen)
      {
         throw this.getImmutableError();
      }
      super.reverse();
   }
   
   private function getImmutableError() : Error
   {
      var _loc1_:String = getQualifiedClassName(this).split("::").pop();
      var _loc2_:String = _loc1_ + " cannot be modified. Call \'clone\' to create a mutable copy.";
      return new IllegalOperationError(_loc2_);
   }
}

class Ellipse extends ImmutablePolygon
{
   
   private var _x:Number;
   
   private var _y:Number;
   
   private var _radiusX:Number;
   
   private var _radiusY:Number;
   
   public function Ellipse(param1:Number, param2:Number, param3:Number, param4:Number, param5:int = -1)
   {
      this._x = param1;
      this._y = param2;
      this._radiusX = param3;
      this._radiusY = param4;
      super(this.getVertices(param5));
   }
   
   private function getVertices(param1:int) : Array
   {
      if(param1 < 0)
      {
         param1 = Math.PI * (this._radiusX + this._radiusY) / 4;
      }
      if(param1 < 6)
      {
         param1 = 6;
      }
      var _loc2_:Array = [];
      var _loc3_:Number = 2 * Math.PI / param1;
      var _loc4_:Number = 0;
      var _loc5_:int = 0;
      while(_loc5_ < param1)
      {
         _loc2_[_loc5_ * 2] = Math.cos(_loc4_) * this._radiusX + this._x;
         _loc2_[_loc5_ * 2 + 1] = Math.sin(_loc4_) * this._radiusY + this._y;
         _loc4_ += _loc3_;
         _loc5_++;
      }
      return _loc2_;
   }
   
   override public function triangulate(param1:IndexData = null, param2:int = 0) : IndexData
   {
      if(param1 == null)
      {
         param1 = new IndexData((numVertices - 2) * 3);
      }
      var _loc3_:uint = 1;
      var _loc4_:uint = numVertices - 1;
      var _loc5_:int = int(_loc3_);
      while(_loc5_ < _loc4_)
      {
         param1.addTriangle(param2,param2 + _loc5_,param2 + _loc5_ + 1);
         _loc5_++;
      }
      return param1;
   }
   
   override public function contains(param1:Number, param2:Number) : Boolean
   {
      var _loc3_:Number = param1 - this._x;
      var _loc4_:Number = param2 - this._y;
      var _loc5_:Number = _loc3_ / this._radiusX;
      var _loc6_:Number = _loc4_ / this._radiusY;
      return _loc5_ * _loc5_ + _loc6_ * _loc6_ <= 1;
   }
   
   override public function get area() : Number
   {
      return Math.PI * this._radiusX * this._radiusY;
   }
   
   override public function get isSimple() : Boolean
   {
      return true;
   }
   
   override public function get isConvex() : Boolean
   {
      return true;
   }
}

class PolygonRectangle extends ImmutablePolygon
{
   
   private var _x:Number;
   
   private var _y:Number;
   
   private var _width:Number;
   
   private var _height:Number;
   
   public function PolygonRectangle(param1:Number, param2:Number, param3:Number, param4:Number)
   {
      this._x = param1;
      this._y = param2;
      this._width = param3;
      this._height = param4;
      super([param1,param2,param1 + param3,param2,param1 + param3,param2 + param4,param1,param2 + param4]);
   }
   
   override public function triangulate(param1:IndexData = null, param2:int = 0) : IndexData
   {
      if(param1 == null)
      {
         param1 = new IndexData(6);
      }
      param1.addTriangle(param2,param2 + 1,param2 + 3);
      param1.addTriangle(param2 + 1,param2 + 2,param2 + 3);
      return param1;
   }
   
   override public function contains(param1:Number, param2:Number) : Boolean
   {
      return param1 >= this._x && param1 <= this._x + this._width && param2 >= this._y && param2 <= this._y + this._height;
   }
   
   override public function get area() : Number
   {
      return this._width * this._height;
   }
   
   override public function get isSimple() : Boolean
   {
      return true;
   }
   
   override public function get isConvex() : Boolean
   {
      return true;
   }
}
