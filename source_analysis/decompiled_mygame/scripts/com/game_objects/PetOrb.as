package com.game_objects
{
   import com.math.*;
   import com.utilities.*;
   import starling.display.Image;
   import starling.extensions.lighting.*;
   import starling.textures.*;
   
   public class PetOrb extends Image
   {
      
      public static const petOrb_array:Vector.<PetOrb> = new Vector.<PetOrb>();
      
      private var fakeRotation:Number;
      
      private var plantedX:Number;
      
      private var plantedY:Number;
      
      private var moveSpeed:Number;
      
      private var radX:int;
      
      private var radY:int;
      
      public var bonus:int;
      
      private var __color_string:String;
      
      public var isFocus:Boolean;
      
      public var creator:Person;
      
      public var petName:String;
      
      public function PetOrb(param1:Number, param2:Number, param3:String, param4:uint, param5:Person, param6:String, param7:int, param8:Boolean = false)
      {
         var _loc9_:Texture = null;
         var _loc10_:String = null;
         var _loc11_:LightStyle = null;
         var _loc12_:Number = 2 + param4 / 20;
         _loc12_ = _loc12_ < 10 ? _loc12_ : 10;
         if(param8)
         {
            _loc9_ = Assets.items_textureAtlas.getTexture(param3 + " orb stroke");
         }
         else
         {
            _loc9_ = Assets.items_textureAtlas.getTexture(param3 + " orb");
         }
         super(_loc9_);
         width = height = _loc12_ * 2;
         width += param8 ? 6 : 0;
         height += param8 ? 6 : 0;
         this.isFocus = param8;
         this.__color_string = param3;
         x = param1;
         y = param2;
         this.plantedX = param1;
         this.plantedY = param2;
         this.fakeRotation = 0;
         this.moveSpeed = 0.02 + Math.random() / 16;
         this.creator = param5;
         this.petName = param6;
         this.radX = 10 + Math.random() * 85;
         this.radY = Math.random() * 40;
         this.bonus = param7;
         touchable = false;
         petOrb_array.push(this);
         if(GameMain.lighting)
         {
            _loc10_ = param8 ? param3 + " orb stroke" : param3 + " orb";
            _loc11_ = new LightStyle(Assets.treeFishLighMap_textureAtlas.getTexture(_loc10_));
            _loc11_.ambientRatio = 0.2;
            _loc11_.diffuseRatio = 0.8;
            _loc11_.specularRatio = 0.5;
            _loc11_.shininess = 20;
            _loc11_.textureSmoothing = TextureSmoothing.NONE;
            style = _loc11_;
         }
      }
      
      public function onEnter(param1:int) : void
      {
         if(this.creator != null && this.creator.parent != null)
         {
            this.plantedX += CalcDist.getDistX(this.creator.x,x) / 10;
            this.plantedY += CalcDist.getDistX(this.creator.y - 75,y) / 10;
            this.moveAround();
            return;
         }
         removeFromParent(true);
         petOrb_array.removeAt(param1);
      }
      
      public function moveAround() : void
      {
         var _loc1_:int = int(this.radX);
         var _loc2_:int = int(this.radY);
         var _loc3_:Number = Number(this.moveSpeed);
         if(this.creator.powerUpVisuals.unleashing)
         {
            _loc1_ = this.radX * (1 + this.creator.energyController.fullTotalScale * 2);
            _loc2_ = this.radY * (1 + this.creator.energyController.fullTotalScale * 2);
            _loc3_ = this.moveSpeed * (1 + this.creator.energyController.fullTotalScale * 1.7);
         }
         this.fakeRotation += _loc3_;
         MoveInCircle.moveAround(this,_loc1_,_loc2_,_loc3_ * 25,this.plantedX,this.plantedY,this.fakeRotation);
      }
      
      public function get color_string() : String
      {
         return this.__color_string;
      }
   }
}

