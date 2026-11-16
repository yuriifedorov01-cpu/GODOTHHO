package com.game_objects
{
   import com.stats.*;
   import com.utilities.*;
   import flash.geom.*;
   import starling.display.*;
   
   public final class VendingMachine extends Sprite
   {
      
      public var items:Vector.<String>;
      
      public var costs:Vector.<uint>;
      
      private var __sellerName:String;
      
      private var __tickets:uint;
      
      public var ticketPrice:uint;
      
      public function VendingMachine(param1:String, param2:String, param3:Vector.<String>, param4:Vector.<uint>, param5:uint, param6:uint)
      {
         var _loc7_:Image = null;
         var _loc8_:Button = null;
         var _loc9_:Image = null;
         _loc7_ = null;
         _loc8_ = null;
         _loc9_ = null;
         super();
         name = param2;
         this.__sellerName = param1;
         this.items = param3;
         this.costs = param4;
         this.ticketPrice = param6;
         _loc7_ = new Image(Assets.items_textureAtlas.getTexture("vending machine"));
         _loc7_.x = -51;
         _loc7_.y = -74;
         _loc7_.touchable = false;
         addChild(_loc7_);
         _loc8_ = new Button(Assets.items_textureAtlas.getTexture("click to interact"));
         _loc8_.x = -2;
         _loc8_.y = -90;
         _loc8_.pivotX += _loc8_.width / 2;
         _loc8_.pivotY = _loc8_.height / 2;
         _loc8_.name = "vendorClick_btn";
         _loc8_.useHandCursor = false;
         addChild(_loc8_);
         _loc9_ = new Image(Assets.items_textureAtlas.getTexture("vending machine window panel"));
         _loc9_.x = -47;
         _loc9_.y = -67;
         _loc9_.width = 67;
         _loc9_.height = 69;
         _loc9_.touchable = false;
         addChildAt(_loc9_,0);
         this.updateMe();
         this.tickets = param5;
      }
      
      public static function canPlaceHere(param1:int, param2:int, param3:int, param4:Sprite) : Boolean
      {
         var _loc5_:Rectangle = new Rectangle(param1 - 56,param2 - 59,113,118);
         var _loc6_:Boolean = true;
         var _loc7_:int = param4.numChildren;
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            if((param4.getChildAt(_loc8_) is VendingMachine || param4.getChildAt(_loc8_) is PetVendor) && _loc5_.intersects(param4.getChildAt(_loc8_).getBounds(param4)))
            {
               _loc6_ = false;
               break;
            }
            _loc8_++;
         }
         return _loc6_;
      }
      
      public function updateMe() : void
      {
         var _loc1_:int = numChildren;
         var _loc2_:* = int(_loc1_ - 1);
         while(_loc2_ >= 0)
         {
            if(getChildAt(_loc2_) is Item)
            {
               removeChildAt(_loc2_);
            }
            _loc2_--;
         }
         var _loc3_:uint = 0;
         _loc1_ = int(this.items.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            if(_loc3_ >= 4)
            {
               break;
            }
            if(Stats.getItemType(Fish.fishNoShinyName(this.items[_loc2_])) != "fish")
            {
               switch(_loc3_)
               {
                  case 0:
                     this.showItem(-20,1,this.items[_loc2_]);
                     break;
                  case 1:
                     this.showItem(6,-6,this.items[_loc2_]);
                     break;
                  case 2:
                     this.showItem(-5,-29,this.items[_loc2_]);
                     break;
                  case 3:
                     this.showItem(7,-34,this.items[_loc2_]);
               }
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      private function showItem(param1:int, param2:int, param3:String) : void
      {
         var _loc4_:Item = new Item(param3,"","");
         _loc4_.x = param1;
         _loc4_.y = param2;
         _loc4_.scaleX = _loc4_.scaleY = 0.6;
         addChildAt(_loc4_,1);
      }
      
      public function get tickets() : uint
      {
         return this.__tickets;
      }
      
      public function set tickets(param1:uint) : *
      {
         var _loc2_:Image = null;
         if(param1 > 0 && this.__tickets == 0)
         {
            _loc2_ = new Image(Assets.items_textureAtlas.getTexture("vending machine tickets"));
            _loc2_.x = 35;
            _loc2_.y = -64;
            _loc2_.touchable = false;
            _loc2_.visible = param1 > 0;
            _loc2_.name = "tickets_image";
            addChild(_loc2_);
         }
         else if(param1 == 0 && this.__tickets > 0)
         {
            removeChild(getChildByName("tickets_image"));
         }
         this.__tickets = param1;
      }
      
      public function get sellerName() : String
      {
         return this.__sellerName;
      }
   }
}

