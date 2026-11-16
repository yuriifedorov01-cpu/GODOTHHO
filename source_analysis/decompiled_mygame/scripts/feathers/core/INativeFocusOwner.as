package feathers.core
{
   import flash.display.InteractiveObject;
   
   public interface INativeFocusOwner extends IFocusDisplayObject
   {
      
      function get nativeFocus() : InteractiveObject;
   }
}

