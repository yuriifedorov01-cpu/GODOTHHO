package com.game_objects
{
   import com.game_objects.extensions.*;
   import com.gravityPackage.*;
   import com.stats.*;
   import com.utilities.*;
   import com.visual_effects.*;
   import flash.geom.*;
   import starling.*;
   import starling.display.*;
   import starling.events.*;
   import starling.extensions.lighting.*;
   import starling.textures.*;
   import starling.utils.*;
   
   public class Item extends Sprite
   {
      
      public var worth:int = 0;
      
      public var playerDibs:String;
      
      public var creatorName:String;
      
      private var fakeRotation:Number = 0;
      
      public var gravityObject:GravityObject;
      
      private var __type:String = "";
      
      private var scaleIn:Boolean = false;
      
      private var object1:Image;
      
      private var image2:Image;
      
      private var image3:Image;
      
      public function Item(param1:String, param2:String, param3:String, param4:Boolean = true)
      {
         var _loc7_:Texture = null;
         var _loc9_:Texture = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         _loc7_ = null;
         super();
         this.__type = param1;
         _loc5_ = Stats.getItemType(Fish.fishNoShinyName(param1));
         if(Assets.items_textureAtlas.getTexture(param1) != null && Assets.items_textureAtlas.getTexture(param1 + "_") == null)
         {
            this.object1 = new Image(Assets.items_textureAtlas.getTexture(param1));
            if(GameMain.lighting)
            {
               this.setLightStyle(this.object1,param1);
            }
         }
         else if(Assets.items_textureAtlas.getTexture(param1 + "_00") == null)
         {
            _loc9_ = Assets.treesFish_textureAtlas.getTexture(Fish.fishNoShinyName(param1));
            if(_loc9_ != null)
            {
               this.object1 = new Image(_loc9_);
               this.setLightStyle(this.object1,param1,true);
            }
         }
         else
         {
            this.object1 = new MovieClip(Assets.items_textureAtlas.getTextures(param1 + "_"),30);
            MovieClip(this.object1).stop();
            if(param4)
            {
               addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
               addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
            }
         }
         _loc6_ = Fish.fishNoShinyName(param1);
         if(this.object1 != null && Stats.fishStats[_loc6_] == undefined && Assets.items_object[_loc6_] != undefined)
         {
            this.object1.pivotX = Assets.items_object[_loc6_].pivotX;
            this.object1.pivotY = Assets.items_object[_loc6_].pivotY;
         }
         if(this.object1 != null)
         {
            this.object1.touchable = false;
            addChild(this.object1);
         }
         if(_loc5_ == "pants" && Assets.items_textureAtlas.getTexture(param1) != null)
         {
            this.image2 = new Image(Assets.items_textureAtlas.getTexture(param1));
            this.image2.x += 25;
            this.image2.scaleX = -1;
            this.image2.touchable = false;
            if(this.object1 != null)
            {
               this.image2.pivotX = this.object1.pivotX;
               this.image2.pivotY = this.object1.pivotY;
            }
            addChild(this.image2);
         }
         else if(_loc5_ == "shirt" && Stats.sStats[param1] != undefined && Assets.items_textureAtlas.getTexture(param1 + " arm") != null && Assets.items_object[param1 + " arm"] != undefined)
         {
            _loc7_ = Assets.items_textureAtlas.getTexture(param1 + " arm");
            this.image2 = new Image(_loc7_);
            this.image2.rotation = deg2rad(35);
            this.image2.x = BodyAnimator.armX_array[ItemStat(Stats.sStats[param1]).frame - 1] - 13;
            addChild(this.image2);
            this.image3 = new Image(_loc7_);
            this.image3.scaleX = -1;
            this.image3.x = BodyAnimator.armX_array[ItemStat(Stats.sStats[param1]).frame - 1] + 15;
            this.image3.y = this.image2.y = BodyAnimator.armY_array[ItemStat(Stats.sStats[param1]).frame - 1];
            this.image3.pivotX = this.image2.pivotX = Assets.items_object[param1 + " arm"].pivotX;
            this.image3.pivotY = this.image2.pivotY = Assets.items_object[param1 + " arm"].pivotY;
            this.image3.touchable = this.image2.touchable = false;
            this.image3.rotation = deg2rad(-35);
            addChildAt(this.image3,0);
         }
         else if(_loc5_ == "fish")
         {
            pivotX += width / 2;
            pivotY += height / 2;
         }
         if(_loc5_ == "weapon")
         {
            rotation = deg2rad(-55);
         }
         touchGroup = true;
         touchable = false;
         var _loc8_:Rectangle = new Rectangle(-(width / 2),-(height / 2),width,height);
         _loc8_.width = _loc8_.width < 40 ? 40 : _loc8_.width;
         _loc8_.height = _loc8_.height < 40 ? 40 : _loc8_.height;
         this.gravityObject = new GravityObject(this,_loc8_);
         this.playerDibs = param2;
         if(this.playerDibs != "" && this.playerDibs != param3 && this.playerDibs != "-none-")
         {
            alpha = 0.5;
         }
         if(param1.indexOf("shiny") == 0)
         {
            SetHue.setStarlingObjectHue(this,60);
         }
         if(GameMain.lighting)
         {
            if(this.image2 != null)
            {
               this.setLightStyle(this.image2,param1);
            }
            if(this.image3 != null)
            {
               this.setLightStyle(this.image3,param1);
            }
         }
      }
      
      private function setLightStyle(param1:Image, param2:String, param3:Boolean = false) : void
      {
         var _loc4_:TextureAtlas = null;
         var _loc5_:LightStyle = null;
         if(GameMain.lighting && Assets.itemsPetsLightMap_textureAtlas != null)
         {
            param1.style = null;
            _loc4_ = param3 == false ? Assets.itemsPetsLightMap_textureAtlas : Assets.treeFishLighMap_textureAtlas;
            _loc5_ = new LightStyle(_loc4_.getTexture(param2));
            _loc5_.ambientRatio = 0.3;
            _loc5_.diffuseRatio = 0.7;
            _loc5_.specularRatio = 0.1;
            _loc5_.shininess = 1;
            _loc5_.textureSmoothing = TextureSmoothing.NONE;
            param1.style = _loc5_;
         }
      }
      
      private function onAdded(param1:Event) : void
      {
         MainStarlingStage(root).gameMain.main_juggler.add(MovieClip(this.object1));
      }
      
      private function onRemoved(param1:Event) : void
      {
         MainStarlingStage(root).gameMain.main_juggler.remove(MovieClip(this.object1));
      }
      
      public function onEnter(param1:Person) : void
      {
         ++this.gravityObject.counter;
         if(this.__type == "coin")
         {
            scaleX += this.scaleIn ? -0.1 : 0.1;
            if(scaleX < 0.1)
            {
               this.scaleIn = false;
            }
            else if(scaleX > 1)
            {
               this.scaleIn = true;
            }
         }
         if(this.gravityObject.counter > int(210 - param1.lootStealLvl * 2) || this.playerDibs == MainStarlingStage(root).gameMain.player.name)
         {
            if(this.playerDibs != "-none-")
            {
               alpha = 1;
            }
         }
         this.gravityObject.applyGravity(MainStarlingStage(root).gameMain,MainStarlingStage(root).gameMain.gravity);
      }
      
      public function get type() : String
      {
         return this.__type;
      }
   }
}

