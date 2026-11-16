package com.visual_effects
{
   import com.sound.*;
   import flash.media.*;
   import starling.events.*;
   import starling.text.TextField;
   
   public class TalkText
   {
      
      private static var tField:TextField;
      
      private static var words:String = new String();
      
      private static var tSpeed:int = new int(0);
      
      private static var i:int = new int(0);
      
      private static var j:uint = new uint(0);
      
      private static var lineAmt:uint = new uint(0);
      
      private static var timesSkipped:uint = new uint(0);
      
      public static var textBlip_sound:Sound = new Sound();
      
      public function TalkText()
      {
         super();
      }
      
      public static function talk(param1:TextField, param2:int) : void
      {
         words = param1.text;
         tField = param1;
         tSpeed = param2;
         param1.addEventListener(Event.ENTER_FRAME,onTextEnter);
         param1.text = "";
      }
      
      public static function onTextEnter(param1:Event) : void
      {
         i = 0;
         while(i < tSpeed)
         {
            if((words.charAt(tField.text.length - 1) == "." || words.charAt(tField.text.length - 1) == "!" || words.charAt(tField.text.length - 1) == "?") && timesSkipped < 9)
            {
               ++timesSkipped;
               break;
            }
            if(words.charAt(tField.text.length - 1) == "," && timesSkipped < 5)
            {
               ++timesSkipped;
               break;
            }
            timesSkipped = 0;
            tField.text += words.charAt(tField.text.length);
            SoundManager.playSound(textBlip_sound);
            ++i;
         }
         if(tField.text.length == words.length)
         {
            tField.removeEventListener(Event.ENTER_FRAME,onTextEnter);
            return;
         }
      }
      
      public static function removeTextListener() : void
      {
         tField.removeEventListener(Event.ENTER_FRAME,onTextEnter);
         tField = null;
      }
   }
}

