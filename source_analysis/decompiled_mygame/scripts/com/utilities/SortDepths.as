package com.utilities
{
   import com.game_objects.*;
   import com.helpers.*;
   import com.ui.*;
   import starling.MainStarlingStage;
   import starling.display.*;
   
   public class SortDepths
   {
      
      public static var starlingStage:MainStarlingStage;
      
      public static const REGION_1:String = "region 1";
      
      public static const REGION_2:String = "region 2";
      
      public static const REGION_4:String = "region 4";
      
      public static const REGION_4B:String = "region 4b";
      
      public function SortDepths()
      {
         super();
      }
      
      public static function addAt(param1:DisplayObject, param2:String, param3:String = "") : void
      {
         var _loc4_:int = 0;
         var _loc5_:* = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Image = null;
         var _loc9_:int = 0;
         var _loc10_:Image = null;
         var _loc11_:DisplayObject = null;
         var _loc12_:DisplayObject = null;
         switch(param2)
         {
            case REGION_1:
               _loc7_ = 0;
               _loc9_ = 0;
               for each(_loc10_ in GiveHealthBar.healthBar_array)
               {
                  if(_loc10_.parent != null)
                  {
                     _loc9_ = _loc10_.parent.getChildIndex(_loc10_);
                     if(_loc9_ > _loc7_)
                     {
                        _loc7_ = _loc9_;
                     }
                  }
               }
               if(_loc7_ > 0)
               {
                  starlingStage.c_mc.addChildAt(param1,_loc7_);
               }
               else if(_loc7_ == 0)
               {
                  _loc6_ = int.MAX_VALUE;
                  _loc4_ = int(Tree.tree_array.length);
                  _loc5_ = 0;
                  while(_loc5_ < _loc4_)
                  {
                     if(Tree.tree_array[_loc5_].parent != null && Boolean(Tree.tree_array[_loc5_].isFG) && Tree.tree_array[_loc5_].parent.getChildIndex(Tree.tree_array[_loc5_]) <= _loc6_)
                     {
                        _loc6_ = int(Tree.tree_array[_loc5_].parent.getChildIndex(Tree.tree_array[_loc5_]));
                     }
                     _loc5_++;
                  }
                  if(_loc6_ != int.MAX_VALUE)
                  {
                     starlingStage.c_mc.addChildAt(param1,_loc6_);
                  }
                  else
                  {
                     _loc4_ = starlingStage.c_mc.numChildren;
                     _loc5_ = int(_loc4_ - 1);
                     while(_loc5_ >= 0)
                     {
                        _loc11_ = starlingStage.c_mc.getChildAt(_loc5_);
                        if(Boolean(_loc11_ is Image && _loc11_) && Boolean(_loc11_.name != null) && _loc11_.name.indexOf("FGmainArt") == 0)
                        {
                           _loc6_ = _loc5_;
                        }
                        _loc5_--;
                     }
                     if(_loc6_ < int.MAX_VALUE)
                     {
                        starlingStage.c_mc.addChildAt(param1,_loc6_);
                     }
                     else
                     {
                        starlingStage.c_mc.addChild(param1);
                     }
                  }
               }
               break;
            case REGION_2:
               _loc6_ = TileHandler.getHighestMainArtIndex() + 1;
               if(_loc6_ > 0 && _loc6_ <= starlingStage.c_mc.numChildren)
               {
                  starlingStage.c_mc.addChildAt(param1,_loc6_);
               }
               else
               {
                  starlingStage.c_mc.addChildAt(param1,0);
               }
               break;
            case REGION_4:
               _loc6_ = int.MAX_VALUE;
               if(param3 == REGION_4B)
               {
                  _loc6_ = Math.min(getLowestChildIndex(Vector.<DisplayObject>(starlingStage.gameMain.p_array)),getLowestChildIndex(Vector.<DisplayObject>(starlingStage.gameMain.e_array)),getLowestChildIndex(Vector.<DisplayObject>(starlingStage.gameMain.pet_array)),getLowestChildIndex(Vector.<DisplayObject>(starlingStage.gameMain.item_array)));
                  starlingStage.c_mc.addChildAt(param1,_loc6_);
               }
               else if(param3 == "")
               {
                  _loc6_ = getLowestChildIndex(Vector.<DisplayObject>(GiveHealthBar.healthBG_array));
                  if(_loc6_ != int.MAX_VALUE)
                  {
                     starlingStage.c_mc.addChildAt(param1,_loc6_);
                  }
                  else
                  {
                     _loc4_ = int(Tree.tree_array.length);
                     _loc5_ = 0;
                     while(_loc5_ < _loc4_)
                     {
                        if(Boolean(Tree.tree_array[_loc5_].isFG) && Tree.tree_array[_loc5_].parent.getChildIndex(Tree.tree_array[_loc5_]) <= _loc6_)
                        {
                           _loc6_ = int(Tree.tree_array[_loc5_].parent.getChildIndex(Tree.tree_array[_loc5_]));
                        }
                        _loc5_++;
                     }
                     if(_loc6_ != int.MAX_VALUE)
                     {
                        starlingStage.c_mc.addChildAt(param1,_loc6_);
                     }
                     else
                     {
                        _loc4_ = starlingStage.c_mc.numChildren;
                        _loc5_ = int(_loc4_ - 1);
                        while(_loc5_ >= 0)
                        {
                           _loc12_ = starlingStage.c_mc.getChildAt(_loc5_);
                           if(Boolean(_loc12_ is Image && _loc12_) && Boolean(_loc12_.name != null) && _loc12_.name.indexOf("FGmainArt") == 0)
                           {
                              _loc6_ = _loc5_;
                           }
                           _loc5_--;
                        }
                        if(_loc6_ < int.MAX_VALUE)
                        {
                           starlingStage.c_mc.addChildAt(param1,_loc6_);
                        }
                        else
                        {
                           starlingStage.c_mc.addChild(param1);
                        }
                     }
                  }
               }
               break;
            default:
               throw new Error("The specified region is not a valid region type");
         }
         if(param1.parent == null)
         {
            throw Error(param1 + " did not get added to a parent");
         }
      }
      
      public static function getLowestChildIndex(param1:Vector.<DisplayObject>) : int
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:int = int.MAX_VALUE;
         for each(_loc2_ in param1)
         {
            if(_loc2_.parent != null && _loc2_.parent.getChildIndex(_loc2_) <= _loc3_)
            {
               _loc3_ = _loc2_.parent.getChildIndex(_loc2_);
            }
         }
         return _loc3_;
      }
   }
}

