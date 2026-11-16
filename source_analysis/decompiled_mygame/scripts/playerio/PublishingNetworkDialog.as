package playerio
{
   import flash.external.*;
   import flash.system.*;
   import mx.utils.*;
   import playerio.generated.PlayerIOError;
   import playerio.utils.HTTPChannel;
   
   internal class PublishingNetworkDialog
   {
      
      private static var _addedCallbackGlue:Boolean = false;
      
      private static var _savedCallbacks:Object = {};
      
      public function PublishingNetworkDialog()
      {
         super();
      }
      
      public static function showDialog(param1:String, param2:Object, param3:HTTPChannel, param4:Function) : void
      {
         switch(Capabilities.playerType)
         {
            case "ActiveX":
            case "PlugIn":
               javascriptDialog(param1,param2,param3 == null ? null : param3.token,param4);
               return;
            default:
               throw new playerio.generated.PlayerIOError("Cannot show the \'" + param1 + "\' dialog. Dialogs aren\'t supported in the current runtime environment:" + Capabilities.playerType,playerio.PlayerIOError.GeneralError.errorID);
         }
      }
      
      private static function javascriptDialog(param1:String, param2:Object, param3:String, param4:Function) : void
      {
         var _loc5_:String = null;
         if(!ExternalInterface.available)
         {
            throw new playerio.generated.PlayerIOError("ExternalInterface is not available!",0);
         }
         param2.__apitoken__ = param3;
         var _loc6_:String = UIDUtil.createUID().replace("-","").toLowerCase();
         _savedCallbacks[_loc6_] = param4;
         if(!_addedCallbackGlue)
         {
            ExternalInterface.addCallback("JavascriptPlayerIOCallback",javascriptPlayerIOCallback);
            _loc5_ = "";
            _loc5_ += "window.__PlayerIO_Flash_Callback__ = function(callbackId, result){";
            _loc5_ += "\nvar resultStr = \'A\';";
            _loc5_ += "\nresult[\'__PlayerIO_Flash_CallbackId__\'] = callbackId;";
            _loc5_ += "\nfor(var x in result){resultStr+=\':\'+x.length+\':\'+x+\':\'+result[x].length+\':\'+result[x]};";
            _loc5_ += "\n\tfor(var tag in {embed:1,object:1}){";
            _loc5_ += "\n\t\tvar list=document.getElementsByTagName(tag);";
            _loc5_ += "\n\t\tfor(var i=0;i!=list.length;i++){";
            _loc5_ += "\n\t\t\ttry{list[i].JavascriptPlayerIOCallback(resultStr)}catch(e){};";
            _loc5_ += "\n\t\t}";
            _loc5_ += "\n\t}";
            _loc5_ += "\n}";
            ExternalInterface.call("eval",_loc5_);
            _addedCallbackGlue = true;
         }
         var _loc7_:String = "";
         var _loc8_:String = "function(r){window.__PlayerIO_Flash_Callback__(\'" + _loc6_ + "\',r)}";
         _loc7_ += "if(!document.getElementById(\'publishingnetwork\')){alert(\'When using publishingnetworklogin:auto, the containing html page must include the publishingnetwork.js script\')};";
         _loc7_ += "\nif(window.PublishingNetwork){";
         _loc7_ += "\n\twindow.PublishingNetwork.dialog(" + jsonEncode(param1) + "," + getJavascriptLiteral(param2) + "," + _loc8_ + ");";
         _loc7_ += "\n}else{";
         _loc7_ += "\n\tif(!window.PublishingNetwork_WaitingCalls){window.PublishingNetwork_WaitingCalls=[]};";
         _loc7_ += "\n\twindow.PublishingNetwork_WaitingCalls.push([\'dialog\'," + jsonEncode(param1) + "," + getJavascriptLiteral(param2) + "," + _loc8_ + "])";
         _loc7_ += "\n}";
         ExternalInterface.call("eval",_loc7_);
      }
      
      private static function getJavascriptLiteral(param1:Object) : String
      {
         var _loc3_:String = null;
         var _loc2_:String = "{";
         if(param1 != null)
         {
            for(_loc3_ in param1)
            {
               _loc2_ += _loc2_.length == 1 ? "" : ",";
               _loc2_ += jsonEncode(_loc3_);
               _loc2_ += ":";
               _loc2_ += jsonEncode(param1[_loc3_]);
            }
         }
         return _loc2_ + "}";
      }
      
      private static function jsonEncode(param1:String) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(param1 == null)
         {
            return "null";
         }
         _loc2_ = "";
         _loc2_ += "\"";
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            switch(param1.charAt(_loc3_))
            {
               case "\n":
                  _loc2_ += "\\n";
                  break;
               case "\r":
                  _loc2_ += "\\r";
                  break;
               case "\t":
                  _loc2_ += "\\t";
                  break;
               case "\"":
               case "\\":
                  _loc2_ += "\\";
                  _loc2_ += param1[_loc3_];
                  break;
               case "\f":
                  _loc2_ += "\\f";
                  break;
               case "\b":
                  _loc2_ += "\\b";
                  break;
               default:
                  if(param1.charCodeAt(_loc3_) >= 32 && param1.charCodeAt(_loc3_) <= 126)
                  {
                     _loc2_ += param1.charAt(_loc3_);
                  }
                  else
                  {
                     _loc4_ = param1.charCodeAt(_loc3_) < 55296 || param1.charCodeAt(_loc3_) > 57343;
                     if(_loc4_)
                     {
                        _loc5_ = [];
                        _loc6_ = param1.charCodeAt(_loc3_);
                        _loc7_ = 0;
                        while(_loc7_ < 4)
                        {
                           _loc8_ = _loc6_ % 16;
                           _loc5_[3 - _loc7_] = _loc8_ < 10 ? String.fromCharCode("0".charCodeAt(0) + _loc8_) : String.fromCharCode("A".charCodeAt(0) + (_loc8_ - 10));
                           _loc6_ >>= 4;
                           _loc7_++;
                        }
                        _loc2_ += "\\u";
                        _loc2_ += _loc5_.join();
                     }
                  }
            }
            _loc3_++;
         }
         return _loc2_ + "\"";
      }
      
      private static function javascriptPlayerIOCallback(param1:String) : void
      {
         var _loc2_:Function = null;
         var _loc3_:Object = StringForm.decodeStringDictionary(param1);
         var _loc4_:String = _loc3_["__PlayerIO_Flash_CallbackId__"];
         if(_savedCallbacks[_loc4_] != undefined)
         {
            _loc2_ = _savedCallbacks[_loc4_];
            delete _loc3_["__PlayerIO_Flash_CallbackId__"];
            delete _savedCallbacks[_loc4_];
            _loc2_(_loc3_);
         }
      }
   }
}

