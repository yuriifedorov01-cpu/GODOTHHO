package
{
   import flash.system.*;
   import flash.ui.GameInputControl;
   import flash.ui.GameInputDevice;
   
   public final class GameInputControlName
   {
      
      public static const DPAD_UP:String = "dpadUp";
      
      public static const DPAD_DOWN:String = "dpadDown";
      
      public static const DPAD_LEFT:String = "dpadLeft";
      
      public static const DPAD_RIGHT:String = "dpadRight";
      
      public static const BUTTON_O:String = "buttonO";
      
      public static const BUTTON_A:String = "buttonA";
      
      public static const BUTTON_U:String = "buttonU";
      
      public static const BUTTON_Y:String = "buttonY";
      
      public static const TRIGGER_TOP_LEFT:String = "triggerTopLeft";
      
      public static const TRIGGER_TOP_RIGHT:String = "triggerTopRight";
      
      public static const TRIGGER_BOTTOM_LEFT:String = "triggerBottomLeft";
      
      public static const TRIGGER_BOTTOM_RIGHT:String = "triggerBottomRight";
      
      public static const JOYSTICK_LEFT:String = "joystickLeft";
      
      public static const JOYSTICK_RIGHT:String = "joystickRight";
      
      public static const JOYSTICK_LEFT_X:String = "joystickLeftX";
      
      public static const JOYSTICK_LEFT_Y:String = "joystickLeftY";
      
      public static const JOYSTICK_LEFT_TRIGGER:String = "joystickLeftTrigger";
      
      public static const JOYSTICK_RIGHT_X:String = "joystickRightX";
      
      public static const JOYSTICK_RIGHT_Y:String = "joystickRightY";
      
      public static const JOYSTICK_RIGHT_TRIGGER:String = "joystickRightTrigger";
      
      public static const JOYSTICK_GENERIC:String = "joystickGeneric";
      
      public static const DPAD_UP_DOWN:String = "dpadUpDown";
      
      public static const DPAD_LEFT_RIGHT:String = "dpadLeftRight";
      
      public static const BUTTON_START:String = "buttonStart";
      
      public static const BUTTON_B:String = "buttonB";
      
      public static const BUTTON_X:String = "buttonX";
      
      public static const UNKNOWN:String = "unknown";
      
      public static const STICK_LEFT_X:String = "stickLeftX";
      
      public static const STICK_LEFT_Y:String = "stickLeftY";
      
      public static const STICK_RIGHT_X:String = "stickRightX";
      
      public static const STICK_RIGHT_Y:String = "stickRightY";
      
      public static const STICK_LEFT_BUTTON:String = "stickLeftButton";
      
      public static const STICK_RIGHT_BUTTON:String = "stickRightButton";
      
      public static const LEFT_TRIGGER:String = "leftTrigger";
      
      public static const RIGHT_TRIGGER:String = "rightTrigger";
      
      public static const LEFT_SHOULDER:String = "leftShoulder";
      
      public static const RIGHT_SHOULDER:String = "rightShoulder";
      
      public static const BUTTON_BACK:String = "buttonBack";
      
      public static const BUTTON_HOME:String = "buttonHome";
      
      public function GameInputControlName()
      {
         super();
      }
      
      public static function initialize(param1:GameInputDevice) : void
      {
         var _loc2_:GameInputControl = null;
         var _loc3_:int = 0;
         if(param1.name == "OUYA Game Controller" && Capabilities.manufacturer.search("Android") >= 0)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.numControls)
            {
               _loc2_ = param1.getControlAt(_loc3_);
               switch(_loc2_.id)
               {
                  case "AXIS_0":
                     _loc2_.name = JOYSTICK_LEFT_X;
                     break;
                  case "AXIS_1":
                     _loc2_.name = JOYSTICK_LEFT_Y;
                     break;
                  case "AXIS_17":
                     _loc2_.name = JOYSTICK_LEFT_TRIGGER;
                     break;
                  case "AXIS_11":
                     _loc2_.name = JOYSTICK_RIGHT_X;
                     break;
                  case "AXIS_14":
                     _loc2_.name = JOYSTICK_RIGHT_Y;
                     break;
                  case "AXIS_18":
                     _loc2_.name = JOYSTICK_RIGHT_TRIGGER;
                     break;
                  case "AXIS_32":
                     _loc2_.name = JOYSTICK_GENERIC;
                     break;
                  case "BUTTON_19":
                     _loc2_.name = DPAD_UP;
                     break;
                  case "BUTTON_20":
                     _loc2_.name = DPAD_DOWN;
                     break;
                  case "BUTTON_21":
                     _loc2_.name = DPAD_LEFT;
                     break;
                  case "BUTTON_22":
                     _loc2_.name = DPAD_RIGHT;
                     break;
                  case "BUTTON_96":
                     _loc2_.name = BUTTON_O;
                     break;
                  case "BUTTON_97":
                     _loc2_.name = BUTTON_A;
                     break;
                  case "BUTTON_99":
                     _loc2_.name = BUTTON_U;
                     break;
                  case "BUTTON_100":
                     _loc2_.name = BUTTON_Y;
                     break;
                  case "BUTTON_102":
                     _loc2_.name = TRIGGER_TOP_LEFT;
                     break;
                  case "BUTTON_103":
                     _loc2_.name = TRIGGER_TOP_RIGHT;
                     break;
                  case "BUTTON_104":
                     _loc2_.name = TRIGGER_BOTTOM_LEFT;
                     break;
                  case "BUTTON_105":
                     _loc2_.name = TRIGGER_BOTTOM_RIGHT;
                     break;
                  case "BUTTON_106":
                     _loc2_.name = JOYSTICK_LEFT;
                     break;
                  case "BUTTON_107":
                     _loc2_.name = JOYSTICK_RIGHT;
               }
               _loc3_++;
            }
         }
         else if(param1.name == "Microsoft X-Box 360 pad" && Capabilities.manufacturer.search("Android") >= 0)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.numControls)
            {
               _loc2_ = param1.getControlAt(_loc3_);
               switch(_loc2_.id)
               {
                  case "AXIS_0":
                     _loc2_.name = JOYSTICK_LEFT_X;
                     break;
                  case "AXIS_1":
                     _loc2_.name = JOYSTICK_LEFT_Y;
                     break;
                  case "AXIS_17":
                     _loc2_.name = JOYSTICK_LEFT_TRIGGER;
                     break;
                  case "AXIS_11":
                     _loc2_.name = JOYSTICK_RIGHT_X;
                     break;
                  case "AXIS_14":
                     _loc2_.name = JOYSTICK_RIGHT_Y;
                     break;
                  case "AXIS_18":
                     _loc2_.name = JOYSTICK_RIGHT_TRIGGER;
                     break;
                  case "AXIS_15":
                     _loc2_.name = DPAD_LEFT_RIGHT;
                     break;
                  case "AXIS_16":
                     _loc2_.name = DPAD_UP_DOWN;
                     break;
                  case "BUTTON_96":
                     _loc2_.name = BUTTON_A;
                     break;
                  case "BUTTON_97":
                     _loc2_.name = BUTTON_B;
                     break;
                  case "BUTTON_99":
                     _loc2_.name = BUTTON_X;
                     break;
                  case "BUTTON_100":
                     _loc2_.name = BUTTON_Y;
                     break;
                  case "BUTTON_102":
                     _loc2_.name = TRIGGER_TOP_LEFT;
                     break;
                  case "BUTTON_103":
                     _loc2_.name = TRIGGER_TOP_RIGHT;
                     break;
                  case "BUTTON_106":
                     _loc2_.name = JOYSTICK_LEFT;
                     break;
                  case "BUTTON_107":
                     _loc2_.name = JOYSTICK_RIGHT;
                     break;
                  case "BUTTON_108":
                     _loc2_.name = BUTTON_START;
               }
               _loc3_++;
            }
         }
         else if(param1.name == "Xbox 360 Controller (XInput STANDARD GAMEPAD)" && (Capabilities.manufacturer == "Adobe Windows" || Capabilities.manufacturer == "Google Pepper"))
         {
            _loc3_ = 0;
            while(_loc3_ < param1.numControls)
            {
               _loc2_ = param1.getControlAt(_loc3_);
               switch(_loc2_.id)
               {
                  case "AXIS_0":
                     _loc2_.name = STICK_LEFT_X;
                     break;
                  case "AXIS_1":
                     _loc2_.name = STICK_LEFT_Y;
                     break;
                  case "AXIS_2":
                     _loc2_.name = STICK_RIGHT_X;
                     break;
                  case "AXIS_3":
                     _loc2_.name = STICK_RIGHT_Y;
                     break;
                  case "BUTTON_4":
                     _loc2_.name = BUTTON_A;
                     break;
                  case "BUTTON_5":
                     _loc2_.name = BUTTON_B;
                     break;
                  case "BUTTON_6":
                     _loc2_.name = BUTTON_X;
                     break;
                  case "BUTTON_7":
                     _loc2_.name = BUTTON_Y;
                     break;
                  case "BUTTON_8":
                     _loc2_.name = LEFT_SHOULDER;
                     break;
                  case "BUTTON_9":
                     _loc2_.name = RIGHT_SHOULDER;
                     break;
                  case "BUTTON_10":
                     _loc2_.name = LEFT_TRIGGER;
                     break;
                  case "BUTTON_11":
                     _loc2_.name = RIGHT_TRIGGER;
                     break;
                  case "BUTTON_12":
                     _loc2_.name = BUTTON_BACK;
                     break;
                  case "BUTTON_13":
                     _loc2_.name = BUTTON_START;
                     break;
                  case "BUTTON_14":
                     _loc2_.name = STICK_LEFT_BUTTON;
                     break;
                  case "BUTTON_15":
                     _loc2_.name = STICK_RIGHT_BUTTON;
                     break;
                  case "BUTTON_16":
                     _loc2_.name = DPAD_UP;
                     break;
                  case "BUTTON_17":
                     _loc2_.name = DPAD_DOWN;
                     break;
                  case "BUTTON_18":
                     _loc2_.name = DPAD_LEFT;
                     break;
                  case "BUTTON_19":
                     _loc2_.name = DPAD_RIGHT;
                     break;
                  default:
                     _loc2_.name = UNKNOWN;
               }
               _loc3_++;
            }
         }
         else if(param1.name == "Logitech Cordless RumblePad 2 USB" && Capabilities.manufacturer == "Adobe Windows")
         {
            _loc3_ = 0;
            while(_loc3_ < param1.numControls)
            {
               _loc2_ = param1.getControlAt(_loc3_);
               switch(_loc2_.id)
               {
                  case "AXIS_0":
                     _loc2_.name = STICK_LEFT_X;
                     break;
                  case "AXIS_1":
                     _loc2_.name = STICK_LEFT_Y;
                     break;
                  case "AXIS_2":
                     _loc2_.name = STICK_RIGHT_X;
                     break;
                  case "AXIS_3":
                     _loc2_.name = STICK_RIGHT_Y;
                     break;
                  case "BUTTON_4":
                     _loc2_.name = DPAD_UP;
                     break;
                  case "BUTTON_5":
                     _loc2_.name = DPAD_DOWN;
                     break;
                  case "BUTTON_6":
                     _loc2_.name = DPAD_LEFT;
                     break;
                  case "BUTTON_7":
                     _loc2_.name = DPAD_RIGHT;
                     break;
                  case "BUTTON_8":
                     _loc2_.name = BUTTON_X;
                     break;
                  case "BUTTON_9":
                     _loc2_.name = BUTTON_A;
                     break;
                  case "BUTTON_10":
                     _loc2_.name = BUTTON_B;
                     break;
                  case "BUTTON_11":
                     _loc2_.name = BUTTON_Y;
                     break;
                  case "BUTTON_12":
                     _loc2_.name = LEFT_SHOULDER;
                     break;
                  case "BUTTON_13":
                     _loc2_.name = RIGHT_SHOULDER;
                     break;
                  case "BUTTON_14":
                     _loc2_.name = LEFT_TRIGGER;
                     break;
                  case "BUTTON_15":
                     _loc2_.name = RIGHT_TRIGGER;
                     break;
                  case "BUTTON_16":
                     _loc2_.name = BUTTON_BACK;
                     break;
                  case "BUTTON_17":
                     _loc2_.name = BUTTON_START;
                     break;
                  case "BUTTON_18":
                     _loc2_.name = STICK_LEFT_BUTTON;
                     break;
                  case "BUTTON_19":
                     _loc2_.name = STICK_RIGHT_BUTTON;
                     break;
                  default:
                     _loc2_.name = UNKNOWN;
               }
               _loc3_++;
            }
         }
         else if((param1.name == "Gamepad for Xbox 360" || param1.name == "Wireless 360 Controller" || param1.name == "Controller") && Capabilities.manufacturer == "Adobe Macintosh")
         {
            _loc3_ = 0;
            while(_loc3_ < param1.numControls)
            {
               _loc2_ = param1.getControlAt(_loc3_);
               switch(_loc2_.id)
               {
                  case "AXIS_0":
                     _loc2_.name = STICK_LEFT_X;
                     break;
                  case "AXIS_1":
                     _loc2_.name = STICK_LEFT_Y;
                     break;
                  case "AXIS_2":
                     _loc2_.name = LEFT_TRIGGER;
                     break;
                  case "AXIS_3":
                     _loc2_.name = STICK_RIGHT_X;
                     break;
                  case "AXIS_4":
                     _loc2_.name = STICK_RIGHT_Y;
                     break;
                  case "AXIS_5":
                     _loc2_.name = RIGHT_TRIGGER;
                     break;
                  case "BUTTON_6":
                     _loc2_.name = DPAD_UP;
                     break;
                  case "BUTTON_7":
                     _loc2_.name = DPAD_DOWN;
                     break;
                  case "BUTTON_8":
                     _loc2_.name = DPAD_LEFT;
                     break;
                  case "BUTTON_9":
                     _loc2_.name = DPAD_RIGHT;
                     break;
                  case "BUTTON_10":
                     _loc2_.name = BUTTON_START;
                     break;
                  case "BUTTON_11":
                     _loc2_.name = BUTTON_BACK;
                     break;
                  case "BUTTON_12":
                     _loc2_.name = STICK_LEFT_BUTTON;
                     break;
                  case "BUTTON_13":
                     _loc2_.name = STICK_RIGHT_BUTTON;
                     break;
                  case "BUTTON_14":
                     _loc2_.name = LEFT_SHOULDER;
                     break;
                  case "BUTTON_15":
                     _loc2_.name = RIGHT_SHOULDER;
                     break;
                  case "BUTTON_16":
                     _loc2_.name = BUTTON_HOME;
                     break;
                  case "BUTTON_17":
                     _loc2_.name = BUTTON_A;
                     break;
                  case "BUTTON_18":
                     _loc2_.name = BUTTON_B;
                     break;
                  case "BUTTON_19":
                     _loc2_.name = BUTTON_X;
                     break;
                  case "BUTTON_20":
                     _loc2_.name = BUTTON_Y;
                     break;
                  default:
                     _loc2_.name = UNKNOWN;
               }
               _loc3_++;
            }
         }
         else if((param1.name.search("Gamepad for Xbox 360") >= 0 || param1.name.search("Wireless 360 Controller") >= 0 || param1.name.search("Controller (STANDARD GAMEPAD") >= 0) && Capabilities.manufacturer == "Google Pepper")
         {
            _loc3_ = 0;
            while(_loc3_ < param1.numControls)
            {
               _loc2_ = param1.getControlAt(_loc3_);
               switch(_loc2_.id)
               {
                  case "AXIS_0":
                     _loc2_.name = STICK_LEFT_X;
                     break;
                  case "AXIS_1":
                     _loc2_.name = STICK_LEFT_Y;
                     break;
                  case "AXIS_2":
                     _loc2_.name = LEFT_TRIGGER;
                     break;
                  case "AXIS_3":
                     _loc2_.name = STICK_RIGHT_X;
                     break;
                  case "AXIS_4":
                     _loc2_.name = STICK_RIGHT_Y;
                     break;
                  case "AXIS_5":
                     _loc2_.name = RIGHT_TRIGGER;
                     break;
                  case "BUTTON_6":
                     _loc2_.name = BUTTON_A;
                     break;
                  case "BUTTON_7":
                     _loc2_.name = BUTTON_B;
                     break;
                  case "BUTTON_8":
                     _loc2_.name = BUTTON_X;
                     break;
                  case "BUTTON_9":
                     _loc2_.name = BUTTON_Y;
                     break;
                  case "BUTTON_10":
                     _loc2_.name = LEFT_SHOULDER;
                     break;
                  case "BUTTON_11":
                     _loc2_.name = RIGHT_SHOULDER;
                     break;
                  case "BUTTON_12":
                     _loc2_.name = STICK_LEFT_BUTTON;
                     break;
                  case "BUTTON_13":
                     _loc2_.name = STICK_RIGHT_BUTTON;
                     break;
                  case "BUTTON_14":
                     _loc2_.name = BUTTON_START;
                     break;
                  case "BUTTON_15":
                     _loc2_.name = BUTTON_BACK;
                     break;
                  case "BUTTON_16":
                     _loc2_.name = BUTTON_HOME;
                     break;
                  case "BUTTON_17":
                     _loc2_.name = DPAD_UP;
                     break;
                  case "BUTTON_18":
                     _loc2_.name = DPAD_DOWN;
                     break;
                  case "BUTTON_19":
                     _loc2_.name = DPAD_LEFT;
                     break;
                  case "BUTTON_20":
                     _loc2_.name = DPAD_RIGHT;
                     break;
                  default:
                     _loc2_.name = UNKNOWN;
               }
               _loc3_++;
            }
         }
         else if(param1.name == "Logitech Cordless RumblePad 2" && Capabilities.manufacturer == "Adobe Macintosh")
         {
            _loc3_ = 0;
            while(_loc3_ < param1.numControls)
            {
               _loc2_ = param1.getControlAt(_loc3_);
               switch(_loc2_.id)
               {
                  case "AXIS_0":
                     _loc2_.name = UNKNOWN;
                     break;
                  case "AXIS_1":
                     _loc2_.name = STICK_LEFT_X;
                     break;
                  case "AXIS_2":
                     _loc2_.name = STICK_LEFT_Y;
                     break;
                  case "AXIS_3":
                     _loc2_.name = STICK_RIGHT_X;
                     break;
                  case "AXIS_4":
                     _loc2_.name = STICK_RIGHT_Y;
                     break;
                  case "BUTTON_5":
                     _loc2_.name = DPAD_UP;
                     break;
                  case "BUTTON_6":
                     _loc2_.name = DPAD_DOWN;
                     break;
                  case "BUTTON_7":
                     _loc2_.name = DPAD_LEFT;
                     break;
                  case "BUTTON_8":
                     _loc2_.name = DPAD_RIGHT;
                     break;
                  case "BUTTON_9":
                     _loc2_.name = BUTTON_X;
                     break;
                  case "BUTTON_10":
                     _loc2_.name = BUTTON_A;
                     break;
                  case "BUTTON_11":
                     _loc2_.name = BUTTON_B;
                     break;
                  case "BUTTON_12":
                     _loc2_.name = BUTTON_Y;
                     break;
                  case "BUTTON_13":
                     _loc2_.name = LEFT_SHOULDER;
                     break;
                  case "BUTTON_14":
                     _loc2_.name = RIGHT_SHOULDER;
                     break;
                  case "BUTTON_15":
                     _loc2_.name = LEFT_TRIGGER;
                     break;
                  case "BUTTON_16":
                     _loc2_.name = RIGHT_TRIGGER;
                     break;
                  case "BUTTON_17":
                     _loc2_.name = BUTTON_BACK;
                     break;
                  case "BUTTON_18":
                     _loc2_.name = BUTTON_START;
                     break;
                  case "BUTTON_19":
                     _loc2_.name = STICK_LEFT_BUTTON;
                     break;
                  case "BUTTON_20":
                     _loc2_.name = STICK_RIGHT_BUTTON;
                     break;
                  default:
                     _loc2_.name = UNKNOWN;
               }
               _loc3_++;
            }
         }
         else if(param1.name.search("Logitech Cordless RumblePad 2") >= 0 && Capabilities.manufacturer == "Google Pepper")
         {
            _loc3_ = 0;
            while(_loc3_ < param1.numControls)
            {
               _loc2_ = param1.getControlAt(_loc3_);
               switch(_loc2_.id)
               {
                  case "AXIS_0":
                     _loc2_.name = STICK_LEFT_X;
                     break;
                  case "AXIS_1":
                     _loc2_.name = STICK_LEFT_Y;
                     break;
                  case "AXIS_2":
                     _loc2_.name = STICK_RIGHT_X;
                     break;
                  case "AXIS_3":
                     _loc2_.name = STICK_RIGHT_Y;
                     break;
                  case "BUTTON_4":
                     _loc2_.name = BUTTON_A;
                     break;
                  case "BUTTON_5":
                     _loc2_.name = BUTTON_B;
                     break;
                  case "BUTTON_6":
                     _loc2_.name = BUTTON_X;
                     break;
                  case "BUTTON_7":
                     _loc2_.name = BUTTON_Y;
                     break;
                  case "BUTTON_8":
                     _loc2_.name = LEFT_SHOULDER;
                     break;
                  case "BUTTON_9":
                     _loc2_.name = RIGHT_SHOULDER;
                     break;
                  case "BUTTON_10":
                     _loc2_.name = LEFT_TRIGGER;
                     break;
                  case "BUTTON_11":
                     _loc2_.name = RIGHT_TRIGGER;
                     break;
                  case "BUTTON_12":
                     _loc2_.name = BUTTON_BACK;
                     break;
                  case "BUTTON_13":
                     _loc2_.name = BUTTON_START;
                     break;
                  case "BUTTON_14":
                     _loc2_.name = STICK_LEFT_BUTTON;
                     break;
                  case "BUTTON_15":
                     _loc2_.name = STICK_RIGHT_BUTTON;
                     break;
                  case "BUTTON_16":
                     _loc2_.name = DPAD_UP;
                     break;
                  case "BUTTON_17":
                     _loc2_.name = DPAD_DOWN;
                     break;
                  case "BUTTON_18":
                     _loc2_.name = DPAD_LEFT;
                     break;
                  case "BUTTON_19":
                     _loc2_.name = DPAD_RIGHT;
                     break;
                  default:
                     _loc2_.name = UNKNOWN;
               }
               _loc3_++;
            }
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < param1.numControls)
            {
               _loc2_ = param1.getControlAt(_loc3_);
               _loc2_.name = UNKNOWN;
               _loc3_++;
            }
         }
      }
   }
}

