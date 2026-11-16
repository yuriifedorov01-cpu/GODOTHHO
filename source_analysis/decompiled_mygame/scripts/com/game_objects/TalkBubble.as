package com.game_objects
{
   import com.ui.*;
   import com.utilities.*;
   import starling.display.Image;
   import starling.extensions.lighting.*;
   import starling.text.*;
   import starling.textures.*;
   
   public final class TalkBubble extends Image
   {
      
      public static var talkBubble_array:Vector.<TalkBubble> = new Vector.<TalkBubble>();
      
      private var __talkID:int;
      
      private var __connectedPerson:Person;
      
      public const connectedTalk_txt:TextField = new TextField(110,15,"",AllTextFormats.talk_textFormat);
      
      public function TalkBubble(param1:String, param2:Person, param3:int)
      {
         var _loc4_:LightStyle = null;
         this.__talkID = param3;
         this.__connectedPerson = param2;
         super(Assets.items_textureAtlas.getTexture("talk bubble"));
         pivotX = Assets.items_object["talk bubble"].pivotX;
         pivotY = Assets.items_object["talk bubble"].pivotY;
         talkBubble_array.push(this);
         this.connectedTalk_txt.text = param1;
         this.connectedTalk_txt.batchable = true;
         this.connectedTalk_txt.touchable = false;
         this.connectedTalk_txt.autoSize = TextFieldAutoSize.VERTICAL;
         height = 15 + this.connectedTalk_txt.height * 1.15;
         if(GameMain.lighting && Assets.itemsPetsLightMap_textureAtlas != null)
         {
            _loc4_ = new LightStyle(Assets.itemsPetsLightMap_textureAtlas.getTexture("talk bubble"));
            _loc4_.ambientRatio = 0.3;
            _loc4_.diffuseRatio = 0.7;
            _loc4_.specularRatio = 0.1;
            _loc4_.shininess = 1;
            _loc4_.textureSmoothing = TextureSmoothing.NONE;
            style = _loc4_;
         }
      }
      
      public function onEnter() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         if(this.__connectedPerson.parent == null || parent == null)
         {
            _loc1_ = TalkBubble.talkBubble_array.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               if(TalkBubble.talkBubble_array[_loc2_] == this)
               {
                  TalkBubble.talkBubble_array.removeAt(_loc2_);
                  removeFromParent(true);
                  this.connectedTalk_txt.removeFromParent(true);
                  return;
               }
               _loc2_++;
            }
         }
         x = this.__connectedPerson.x;
         y = this.__connectedPerson.y - 35;
         this.connectedTalk_txt.x = x - 12;
         this.connectedTalk_txt.y = getBounds(parent).y + 7;
         var _loc3_:int = parent.numChildren;
         _loc1_ = parent.numChildren;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            if(parent.getChildAt(_loc2_) is Tree && Boolean(Tree(parent.getChildAt(_loc2_)).isFG) && _loc2_ <= _loc3_)
            {
               _loc3_ = _loc2_;
            }
            _loc2_++;
         }
         parent.setChildIndex(this.connectedTalk_txt,_loc3_ - 1);
      }
      
      public function get connectedPerson() : Person
      {
         return this.__connectedPerson;
      }
      
      public function get talkID() : int
      {
         return this.__talkID;
      }
   }
}

