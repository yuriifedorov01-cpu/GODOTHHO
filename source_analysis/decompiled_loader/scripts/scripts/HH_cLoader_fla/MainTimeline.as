package HH_cLoader_fla
{
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.system.Capabilities;
   import flash.system.LoaderContext;
   import flash.system.Security;
   import playerio.PlayerIO;
   
   [SWF(width="950", height="700", backgroundColor="#ffffff", frameRate="30")]
   public dynamic class MainTimeline extends MovieClip
   {
      
      public var thisURL_string:String;
      
      public var loaderContext:LoaderContext;
      
      public var urlLoader:URLLoader;
      
      public var url:URLRequest;
      
      public var loader:Loader;
      
      public function MainTimeline()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function onLoadComplete(param1:Event) : void
      {
         this.loader.loadBytes(this.urlLoader.data,this.loaderContext);
         addChild(this.loader);
      }
      
      internal function frame1() : *
      {
         trace(Capabilities.playerType);
         if(Capabilities.playerType != "Desktop")
         {
            Security.allowDomain("*");
         }
         this.thisURL_string = this.loaderInfo.url;
         this.loaderContext = new LoaderContext();
         this.loaderContext.allowCodeImport = true;
         this.urlLoader = new URLLoader();
         this.urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
         this.url = new URLRequest(PlayerIO.gameFS("").getUrl("/MyGame.swf"));
         this.urlLoader.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this.urlLoader.load(this.url);
         this.loader = new Loader();
      }
   }
}

