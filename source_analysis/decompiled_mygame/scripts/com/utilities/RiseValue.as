package com.utilities
{
   import starling.events.*;
   import starling.text.*;
   
   public class RiseValue
   {
      
      public static var textField_array:Vector.<TextField> = new Vector.<TextField>();
      
      public static var baseText_array:Vector.<String> = new Vector.<String>();
      
      public static var currentValue_array:Vector.<Number> = new Vector.<Number>();
      
      public static var goalValue_array:Vector.<int> = new Vector.<int>();
      
      public static var increment_array:Vector.<Number> = new Vector.<Number>();
      
      public static var i:int = new int(0);
      
      public static var len:int = new int(0);
      
      public function RiseValue()
      {
         super();
      }
      
      public static function riseTo(param1:TextField, param2:String, param3:Number, param4:int, param5:Number = 1) : void
      {
         if(param1.hasEventListener(Event.ENTER_FRAME))
         {
            param1.removeEventListener(Event.ENTER_FRAME,onTextFieldEnter);
            len = textField_array.length;
            i = 0;
            while(i < len)
            {
               if(textField_array[i].name == param1.name)
               {
                  textField_array.removeAt(i);
                  baseText_array.removeAt(i);
                  currentValue_array.removeAt(i);
                  goalValue_array.removeAt(i);
                  increment_array.removeAt(i);
                  break;
               }
               ++i;
            }
         }
         param1.addEventListener(Event.ENTER_FRAME,onTextFieldEnter);
         textField_array.push(param1);
         baseText_array.push(param2);
         currentValue_array.push(param3);
         goalValue_array.push(param4);
         increment_array.push(param5);
      }
      
      private static function onTextFieldEnter(param1:Event) : void
      {
         len = textField_array.length;
         i = 0;
         while(i < len)
         {
            if(textField_array[i].name == TextField(param1.target).name)
            {
               currentValue_array[i] += increment_array[i];
               if(currentValue_array[i] >= goalValue_array[i])
               {
                  currentValue_array[i] = goalValue_array[i];
               }
               TextField(param1.target).text = baseText_array[i] + CommonCalls.uintToCommaString(currentValue_array[i]);
               if(currentValue_array[i] == goalValue_array[i])
               {
                  textField_array.removeAt(i);
                  baseText_array.removeAt(i);
                  currentValue_array.removeAt(i);
                  goalValue_array.removeAt(i);
                  increment_array.removeAt(i);
               }
               break;
            }
            ++i;
         }
      }
      
      public static function getCurrentValue(param1:TextField, param2:Number) : Number
      {
         len = textField_array.length;
         i = 0;
         while(i < len)
         {
            if(textField_array[i].name == param1.name)
            {
               return currentValue_array[i];
            }
            ++i;
         }
         return param2;
      }
   }
}

