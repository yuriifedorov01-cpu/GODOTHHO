package com.AI
{
   import com.game_objects.*;
   import com.math.*;
   import flash.ui.*;
   import starling.display.*;
   
   public class PetAI
   {
      
      private var pet:Pet;
      
      private var distX:int = 0;
      
      private var lostCounter:uint = 0;
      
      private var gameMain:GameMain;
      
      private var target:DisplayObject;
      
      private var goingBackToOwner:Boolean = false;
      
      public function PetAI(param1:Pet, param2:GameMain)
      {
         super();
         this.pet = param1;
         this.gameMain = param2;
      }
      
      public function handleAI() : void
      {
         var _loc1_:Vector.<String> = null;
         var _loc2_:Vector.<String> = null;
         var _loc3_:Item = null;
         if(this.pet.moveMode == "follow")
         {
            this.followObject(this.pet.owner);
         }
         else if(this.pet.moveMode == "attack" || this.pet.moveMode == "loot")
         {
            if(CalcDist.getDistNumbers(this.pet.x,this.pet.y,this.pet.owner.x,this.pet.owner.y) < 600 && this.goingBackToOwner == false)
            {
               if(this.pet.moveMode == "attack")
               {
                  this.target = null;
                  if(this.gameMain.isPvpArea == false)
                  {
                     this.target = this.pet.findTarget(Vector.<DisplayObject>(this.gameMain.e_array),600);
                  }
                  else
                  {
                     _loc1_ = new Vector.<String>();
                     _loc1_.push(this.pet.owner.name);
                     this.target = this.pet.findTarget(Vector.<DisplayObject>(this.gameMain.p_array),600,_loc1_);
                     this.target = this.target != null && Object(this.target).health != undefined && Object(this.target).health > 0 ? this.target : null;
                  }
                  if(this.target != null)
                  {
                     if(this.pet.gravityObject.counter % this.pet.attackRate == 0 && this.pet.isAttacking == false && CalcDist.getDistNumbers(this.pet.x,this.pet.y,this.target.x,this.target.y) < 100 && (this.pet.moveDir == 1 && this.pet.x < this.target.x) || this.pet.moveDir == -1 && this.pet.x > this.target.x)
                     {
                        this.pet.keyPress(Keyboard.SPACE);
                        this.pet.keyRelease(Keyboard.SPACE);
                     }
                  }
               }
               else
               {
                  _loc2_ = new Vector.<String>();
                  for each(_loc3_ in this.gameMain.item_array)
                  {
                     if(_loc3_.type.indexOf("spawn ball") > 0 && _loc3_.type != "grenade")
                     {
                        _loc2_.push(_loc3_.name);
                     }
                  }
                  this.target = this.pet.findTarget(Vector.<DisplayObject>(this.gameMain.item_array),600,_loc2_);
                  if(Boolean(this.pet.owner.isPlayer) && this.pet.gravityObject.counter % 30 == 0 && this.target != null && Boolean(this.pet.gravityObject.hit_rect.intersects(this.target.getBounds(this.target.parent))))
                  {
                     this.pet.keyPress(Keyboard.E);
                     this.pet.keyRelease(Keyboard.E);
                  }
               }
            }
            else
            {
               this.target = this.pet.owner;
               this.goingBackToOwner = CalcDist.getDistNumbers(this.pet.x,this.pet.y,this.pet.owner.x,this.pet.owner.y) < 70 ? false : true;
            }
            this.target = this.target == null ? this.pet.owner : this.target;
            if(this.target is Item)
            {
               this.followObject(this.target,130,10);
            }
            else
            {
               this.followObject(this.target,130);
            }
            if(this.pet.gravityObject.counter % 300 == 0 && (this.pet.mode == "hlha" || this.pet.mode == "hfhea" || this.pet.mode == "qptqa" || this.pet.mode == "hcptqa"))
            {
               this.pet.moveMode = this.pet.moveMode == "loot" ? "attack" : "loot";
            }
         }
      }
      
      public function followObject(param1:DisplayObject, param2:int = 50, param3:uint = 50) : void
      {
         var _loc4_:Boolean = false;
         this.distX = CalcDist.getDistX(param1.x,this.pet.x);
         if(this.distX < -param3)
         {
            if(this.pet.keyStates.getKeyState(Keyboard.LEFT).isDown == false)
            {
               this.pet.keyPress(Keyboard.LEFT);
               this.pet.keyRelease(Keyboard.RIGHT);
            }
            if(this.distX < -150 && this.pet.dashing == false)
            {
               this.pet.keyPress(Keyboard.LEFT);
               if(this.pet.dashing == false)
               {
                  this.pet.keyRelease(Keyboard.LEFT);
               }
            }
         }
         else if(this.distX > param3)
         {
            if(this.pet.keyStates.getKeyState(Keyboard.RIGHT).isDown == false)
            {
               this.pet.keyPress(Keyboard.RIGHT);
               this.pet.keyRelease(Keyboard.LEFT);
            }
            if(this.distX > 150 && this.pet.dashing == false)
            {
               this.pet.keyPress(Keyboard.RIGHT);
               if(this.pet.dashing == false)
               {
                  this.pet.keyRelease(Keyboard.RIGHT);
               }
            }
         }
         else
         {
            this.pet.keyRelease(Keyboard.RIGHT);
            this.pet.keyRelease(Keyboard.LEFT);
         }
         if(param1.getBounds(param1.parent).y + param1.height < this.pet.getBounds(this.pet.parent).y + this.pet.height - param2)
         {
            _loc4_ = false;
            if(param1 is Person)
            {
               if(Boolean(Person(param1).gravityObject.onGround) && Person(param1).gravityObject.groundSlope != 0 && Boolean(this.pet.gravityObject.onGround))
               {
                  _loc4_ = true;
               }
            }
            if(_loc4_ == false && (this.pet.gravityObject.jumps == 0 || Math.abs(this.pet.gravityObject.velY) < 1))
            {
               this.pet.keyPress(Keyboard.UP);
               this.pet.keyRelease(Keyboard.UP);
            }
         }
         else if(param1.y > this.pet.y + 140)
         {
            this.pet.keyPress(Keyboard.DOWN);
            this.pet.keyRelease(Keyboard.DOWN);
         }
         if(CalcDist.getDistNumbers(param1.x,param1.y,this.pet.x,this.pet.y) > 350)
         {
            ++this.lostCounter;
            if(this.lostCounter > 100 && this.pet.bubbling == false)
            {
               this.pet.owner.keyHandler.keyPress(Keyboard.Q);
               this.pet.owner.keyHandler.keyRelease(Keyboard.Q);
            }
         }
         else
         {
            this.lostCounter = 0;
         }
      }
   }
}

