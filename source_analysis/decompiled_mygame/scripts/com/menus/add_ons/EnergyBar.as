package com.menus.add_ons
{
   import com.menus.*;
   import starling.display.*;
   
   public class EnergyBar extends Sprite
   {
      
      private const lines:Image = new Image(EnergyMenu.energyMenu_textureAtlas.getTexture("bar lines"));
      
      private const gradient:Image = new Image(EnergyMenu.energyMenu_textureAtlas.getTexture("bar gradient"));
      
      private const topLine:Image = new Image(EnergyMenu.energyMenu_textureAtlas.getTexture("bar top line"));
      
      private const canvas_mask:Canvas = new Canvas();
      
      private var __maxSize:Number = 0.75;
      
      private var __barSize:Number = 0.3;
      
      public function EnergyBar(param1:Boolean = false)
      {
         super();
         if(param1)
         {
            this.gradient.texture = EnergyMenu.energyMenu_textureAtlas.getTexture("bar blue gradient");
         }
         touchGroup = true;
         touchable = false;
         pivotX = 25;
         this.canvas_mask.drawRectangle(0,0,50,246);
         this.gradient.x = 2;
         this.gradient.y = -5;
         this.gradient.pivotX = this.gradient.width / 2;
         this.gradient.pivotY = this.gradient.height;
         addChild(this.gradient);
         this.lines.pivotX = this.lines.width / 2;
         this.lines.pivotY = this.lines.height;
         this.lines.mask = this.canvas_mask;
         addChild(this.lines);
         this.topLine.pivotX = this.lines.pivotX;
         this.topLine.pivotY = this.topLine.height;
         this.topLine.y = this.lines.y - this.canvas_mask.height + 4;
         addChild(this.topLine);
         this.topLine.touchable = this.gradient.touchable = this.lines.touchable = false;
      }
      
      public function set maxSize(param1:Number) : void
      {
         this.__maxSize = param1 > 1 ? 1 : param1;
         this.topLine.y = 0 - this.__maxSize * 100 * (245 / 100);
         this.canvas_mask.y = this.topLine.y + 243;
         if(this.__maxSize < this.__barSize)
         {
            this.barSize = this.__maxSize;
         }
      }
      
      public function get maxSize() : Number
      {
         return this.__maxSize;
      }
      
      public function set barSize(param1:Number) : void
      {
         this.__barSize = param1 > this.__maxSize ? Number(this.__maxSize) : param1;
         this.gradient.scaleY = this.__barSize * 100 / 100;
      }
      
      public function get barSize() : Number
      {
         return this.__barSize;
      }
   }
}

