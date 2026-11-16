package com.utilities
{
   import flash.display.*;
   import flash.geom.*;
   import starling.textures.*;
   
   public final class MovieClipToAtlas
   {
      
      public function MovieClipToAtlas()
      {
         super();
      }
      
      public static function createAtlas(param1:MovieClip, param2:String = "", param3:String = "bgra") : Array
      {
         var textureAtlas:TextureAtlas = null;
         var returnArray:Array = null;
         var i:int = 0;
         var bigRect:Rectangle = null;
         var _movieClip:MovieClip = param1;
         var _prefixName:String = param2;
         var _textureFormat:String = param3;
         var bitmapData2:BitmapData = null;
         var bitmapData3:BitmapData = null;
         i = 0;
         var _object3:Object = null;
         var _object4:Object = null;
         var _object5:Object = null;
         bigRect = null;
         var _rect:Rectangle = null;
         var sheet_xml:XML = null;
         var _bitmapData:BitmapData = null;
         var _bitmapData2:BitmapData = null;
         var _bitmapData3:BitmapData = null;
         var visible_rect:Rectangle = null;
         var croppedMain_bitmapData:BitmapData = null;
         var singleBitmapData:BitmapData = null;
         var nonTrans_rect:Rectangle = null;
         var cropped_bitmapData:BitmapData = null;
         var len2:uint = 0;
         var j:uint = 0;
         var cloneSheet_array:Vector.<Object> = null;
         var sheet_object:Object = null;
         var sourceRect:Rectangle = null;
         var newRect:Rectangle = null;
         var newRect2:Rectangle = null;
         var newRect3:Rectangle = null;
         var sheet2_xml:XML = null;
         var sheet3_xml:XML = null;
         var visible2_rect:Rectangle = null;
         var croppedMain2_bitmapData:BitmapData = null;
         var visible3_rect:Rectangle = null;
         var croppedMain3_bitmapData:BitmapData = null;
         var textureAtlas2:TextureAtlas = null;
         var textureAtlas3:TextureAtlas = null;
         var n_makeXML:Function = function(param1:Vector.<Object>):XML
         {
            var _loc2_:Object = null;
            var _loc3_:XML = <TextureAtlas/>;
            i = 0;
            for each(_loc2_ in param1)
            {
               _loc2_.frameX = Math.round(bigRect.x - (_loc2_.mcBounds.x + _loc2_.nonTransRect.x));
               _loc2_.frameY = Math.round(bigRect.y - (_loc2_.mcBounds.y + _loc2_.nonTransRect.y));
               if(i == 0)
               {
                  _loc2_.pivotX = Math.round(bigRect.x) * -1;
                  _loc2_.pivotY = Math.round(bigRect.y) * -1;
                  _loc3_.appendChild(<SubTexture name={_loc2_.name} x={_loc2_.x} y={_loc2_.y} width={_loc2_.width} height={_loc2_.height} frameX={_loc2_.frameX} frameY={_loc2_.frameY} pivotX={_loc2_.pivotX} pivotY={_loc2_.pivotY} frameWidth={bigRect.width} frameHeight={bigRect.height}/>);
               }
               else
               {
                  _loc3_.appendChild(<SubTexture name={_loc2_.name} x={_loc2_.x} y={_loc2_.y} width={_loc2_.width} height={_loc2_.height} frameX={_loc2_.frameX} frameY={_loc2_.frameY} frameWidth={bigRect.width} frameHeight={bigRect.height}/>);
               }
               ++i;
            }
            return _loc3_;
         };
         var sheet_array:Vector.<Object> = new Vector.<Object>();
         var sheet2_array:Vector.<Object> = new Vector.<Object>();
         var sheet3_array:Vector.<Object> = new Vector.<Object>();
         var frameLabels:Vector.<FrameLabel> = new Vector.<FrameLabel>();
         var bitmapData_array:Vector.<BitmapData> = new Vector.<BitmapData>();
         var bitmapData2_array:Vector.<BitmapData> = new Vector.<BitmapData>();
         var bitmapData3_array:Vector.<BitmapData> = new Vector.<BitmapData>();
         var rect_array:Vector.<Rectangle> = new Vector.<Rectangle>();
         var bitmapData:BitmapData = new BitmapData(2048,2048,true,0);
         var matrix:Matrix = new Matrix();
         var singleMatrix:Matrix = new Matrix();
         var spotX:uint = 0;
         var spotY:uint = 0;
         var drawnWidth:uint = 0;
         var drawnHeight:uint = 0;
         var maxHeight:uint = 0;
         var duplicateIndex:int = -1;
         var biggestWidth:int = 0;
         var biggestHeight:int = 0;
         _movieClip.gotoAndStop(1);
         i = 0;
         while(i < _movieClip.totalFrames)
         {
            singleMatrix.tx = _movieClip.getBounds(_movieClip).x * -1;
            singleMatrix.ty = _movieClip.getBounds(_movieClip).y * -1;
            singleBitmapData = new BitmapData(_movieClip.width,_movieClip.height,true,0);
            if(GameMain.isMobile)
            {
               singleBitmapData.drawWithQuality(_movieClip,singleMatrix,null,null,null,false,StageQuality.MEDIUM);
            }
            else
            {
               singleBitmapData.draw(_movieClip,singleMatrix);
            }
            nonTrans_rect = singleBitmapData.getColorBoundsRect(4278190080,0,false);
            cropped_bitmapData = new BitmapData(nonTrans_rect.width,nonTrans_rect.height);
            cropped_bitmapData.copyPixels(singleBitmapData,nonTrans_rect,new Point(0,0));
            singleBitmapData.dispose();
            maxHeight = cropped_bitmapData.height > maxHeight ? uint(cropped_bitmapData.height) : maxHeight;
            spotX = drawnWidth;
            spotY = drawnHeight;
            if(spotX + cropped_bitmapData.width > bitmapData.width)
            {
               drawnWidth = 0;
               drawnHeight += maxHeight;
               spotX = drawnWidth;
               spotY = drawnHeight;
            }
            matrix.tx = spotX;
            matrix.ty = spotY;
            duplicateIndex = -1;
            len2 = bitmapData_array.length;
            if(bitmapData2 != null)
            {
               len2 = bitmapData2_array.length;
            }
            if(bitmapData3 != null)
            {
               len2 = bitmapData3_array.length;
            }
            j = 0;
            while(j < len2)
            {
               if(bitmapData2 == null)
               {
                  if(bitmapData_array[j].compare(cropped_bitmapData) == 0)
                  {
                     duplicateIndex = int(j);
                     break;
                  }
               }
               else if(bitmapData3 == null)
               {
                  if(bitmapData2_array[j].compare(cropped_bitmapData) == 0)
                  {
                     duplicateIndex = int(j);
                     break;
                  }
               }
               else if(bitmapData3_array[j].compare(cropped_bitmapData) == 0)
               {
                  duplicateIndex = int(j);
                  break;
               }
               j++;
            }
            if(bitmapData2 == null)
            {
               bitmapData_array.push(cropped_bitmapData);
            }
            else if(bitmapData3 == null)
            {
               bitmapData2_array.push(cropped_bitmapData);
            }
            else
            {
               bitmapData3_array.push(cropped_bitmapData);
            }
            if(duplicateIndex == -1)
            {
               if(spotY + cropped_bitmapData.height > 2048)
               {
                  if(bitmapData3 != null)
                  {
                     throw new Error("Could not fit movieclip onto three 2048x2048 sheets.  Movieclip is too big");
                  }
                  if(bitmapData2 == null)
                  {
                     bitmapData2 = new BitmapData(2048,2048,true,0);
                  }
                  else
                  {
                     bitmapData3 = new BitmapData(2048,2048,true,0);
                  }
                  spotX = spotY = drawnWidth = drawnHeight = maxHeight = uint(biggestWidth = biggestHeight = 0);
               }
               sourceRect = new Rectangle(0,0,cropped_bitmapData.width,cropped_bitmapData.height);
               if(bitmapData2 == null)
               {
                  bitmapData.copyPixels(cropped_bitmapData,sourceRect,new Point(spotX,spotY));
               }
               else if(bitmapData3 == null)
               {
                  bitmapData2.copyPixels(cropped_bitmapData,sourceRect,new Point(spotX,spotY));
               }
               else
               {
                  bitmapData3.copyPixels(cropped_bitmapData,sourceRect,new Point(spotX,spotY));
               }
               drawnWidth += cropped_bitmapData.width;
            }
            if(bitmapData2 == null)
            {
               cloneSheet_array = sheet_array;
            }
            else if(bitmapData3 == null)
            {
               cloneSheet_array = sheet2_array;
            }
            else
            {
               cloneSheet_array = sheet3_array;
            }
            sheet_object = new Object();
            if(duplicateIndex == -1)
            {
               sheet_object.name = _prefixName == "" ? _movieClip.name : _prefixName;
               sheet_object.name += "_" + (String(_movieClip.currentFrame - 1).length == 1 ? "0" + (_movieClip.currentFrame - 1) : _movieClip.currentFrame - 1);
               sheet_object.x = spotX;
               sheet_object.y = spotY;
               sheet_object.width = cropped_bitmapData.width;
               sheet_object.height = cropped_bitmapData.height;
               sheet_object.mcBounds = _movieClip.getBounds(_movieClip);
               sheet_object.nonTransRect = nonTrans_rect;
               cloneSheet_array.push(sheet_object);
            }
            else
            {
               sheet_object.name = _prefixName == "" ? _movieClip.name : _prefixName;
               sheet_object.name += "_" + (String(_movieClip.currentFrame - 1).length == 1 ? "0" + (_movieClip.currentFrame - 1) : _movieClip.currentFrame - 1);
               sheet_object.x = cloneSheet_array[duplicateIndex].x;
               sheet_object.y = cloneSheet_array[duplicateIndex].y;
               sheet_object.width = cloneSheet_array[duplicateIndex].width;
               sheet_object.height = cloneSheet_array[duplicateIndex].height;
               sheet_object.mcBounds = cloneSheet_array[duplicateIndex].mcBounds;
               sheet_object.nonTransRect = cloneSheet_array[duplicateIndex].nonTransRect;
               cloneSheet_array.push(sheet_object);
            }
            frameLabels.push(new FrameLabel(_movieClip.currentLabel,_movieClip.currentFrame - 1));
            _movieClip.nextFrame();
            i++;
         }
         for each(_object3 in sheet_array)
         {
            newRect = new Rectangle(_object3.mcBounds.x + _object3.nonTransRect.x,_object3.mcBounds.y + _object3.nonTransRect.y,_object3.width,_object3.height);
            rect_array.push(newRect);
         }
         for each(_object4 in sheet2_array)
         {
            newRect2 = new Rectangle(_object4.mcBounds.x + _object4.nonTransRect.x,_object4.mcBounds.y + _object4.nonTransRect.y,_object4.width,_object4.height);
            rect_array.push(newRect2);
         }
         for each(_object5 in sheet3_array)
         {
            newRect3 = new Rectangle(_object5.mcBounds.x + _object5.nonTransRect.x,_object5.mcBounds.y + _object5.nonTransRect.y,_object5.width,_object5.height);
            rect_array.push(newRect3);
         }
         bigRect = new Rectangle(0,0,0,0);
         for each(_rect in rect_array)
         {
            bigRect = bigRect.union(_rect);
         }
         bigRect.width = Math.ceil(bigRect.width);
         bigRect.height = Math.ceil(bigRect.height);
         sheet_xml = n_makeXML(sheet_array);
         if(bitmapData2 != null)
         {
            sheet2_xml = n_makeXML(sheet2_array);
         }
         if(bitmapData3 != null)
         {
            sheet3_xml = n_makeXML(sheet3_array);
         }
         for each(_bitmapData in bitmapData_array)
         {
            _bitmapData.dispose();
         }
         for each(_bitmapData2 in bitmapData2_array)
         {
            _bitmapData2.dispose();
         }
         for each(_bitmapData3 in bitmapData3_array)
         {
            _bitmapData3.dispose();
         }
         visible_rect = bitmapData.getColorBoundsRect(4278190080,0,false);
         croppedMain_bitmapData = new BitmapData(visible_rect.width,visible_rect.height);
         croppedMain_bitmapData.copyPixels(bitmapData,visible_rect,new Point(0,0));
         if(bitmapData2 != null)
         {
            visible2_rect = bitmapData2.getColorBoundsRect(4278190080,0,false);
            croppedMain2_bitmapData = new BitmapData(visible2_rect.width,visible2_rect.height);
            croppedMain2_bitmapData.copyPixels(bitmapData2,visible2_rect,new Point(0,0));
         }
         if(bitmapData3 != null)
         {
            visible3_rect = bitmapData3.getColorBoundsRect(4278190080,0,false);
            croppedMain3_bitmapData = new BitmapData(visible3_rect.width,visible3_rect.height);
            croppedMain3_bitmapData.copyPixels(bitmapData3,visible3_rect,new Point(0,0));
         }
         textureAtlas = new TextureAtlas(Texture.fromBitmapData(croppedMain_bitmapData,false,false,1,_textureFormat),sheet_xml);
         textureAtlas.texture.root.onRestore = null;
         bitmapData.dispose();
         croppedMain_bitmapData.dispose();
         if(bitmapData2 != null)
         {
            textureAtlas2 = new TextureAtlas(Texture.fromBitmapData(croppedMain2_bitmapData,false,false,1,_textureFormat),sheet2_xml);
            textureAtlas2.texture.root.onRestore = null;
            croppedMain2_bitmapData.dispose();
         }
         if(bitmapData3 != null)
         {
            textureAtlas3 = new TextureAtlas(Texture.fromBitmapData(croppedMain3_bitmapData,false,false,1,_textureFormat),sheet3_xml);
            textureAtlas3.texture.root.onRestore = null;
            croppedMain3_bitmapData.dispose();
         }
         returnArray = new Array();
         returnArray.push(textureAtlas,sheet_array[0].pivotX,sheet_array[0].pivotY,frameLabels);
         if(bitmapData2 != null)
         {
            returnArray.push(textureAtlas2);
            bitmapData2.dispose();
         }
         if(bitmapData3 != null)
         {
            returnArray.push(textureAtlas3);
            bitmapData3.dispose();
         }
         _movieClip.stop();
         return returnArray;
      }
   }
}

