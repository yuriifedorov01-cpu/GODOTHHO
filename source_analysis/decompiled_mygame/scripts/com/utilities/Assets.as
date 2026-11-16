package com.utilities
{
   import com.game_objects.*;
   import com.helpers.*;
   import com.menus.*;
   import com.sound.*;
   import com.stats.*;
   import com.ui.*;
   import com.utilities.treefortress.textureutils.*;
   import flash.display.*;
   import flash.display3D.*;
   import starling.text.*;
   import starling.textures.*;
   import starling.utils.*;
   
   public final class Assets
   {
      
      public static var talk_font:BitmapFont;
      
      public static var rightClick1_data:BitmapData;
      
      public static var rightClick2_data:BitmapData;
      
      public static var treesFish_textureAtlas:TextureAtlas;
      
      public static var powerUp_textureAtlas:TextureAtlas;
      
      public static var items_textureAtlas:TextureAtlas;
      
      private static var bionicBirdArt:BionicBirdVector;
      
      private static var bouncingMushroomArt:BouncingMushroomVector;
      
      private static var brickMonsterArt:BrickMonsterVector;
      
      private static var carneliaArt:CarneliaVector;
      
      private static var crabArt:CrabVector;
      
      private static var beholderArt:BeholderVector;
      
      private static var drillBotArt:DrillBotVector;
      
      private static var fishurnArt:FishurnVector;
      
      private static var greatFrogArt:GreatFrogVector;
      
      private static var glordArt:GlordVector;
      
      private static var gooCubeArt:GooCubeVector;
      
      private static var giantGooCubeArt:GiantGooCubeVector;
      
      private static var greenBouncerArt:GreenBouncerVector;
      
      private static var greenWalkerArt:GreenWalkerVector;
      
      private static var yellowHairyMonsterArt:YellowHairyMonsterVector;
      
      private static var hornedMonsterArt:HornedMonsterVector;
      
      private static var kreetonArt:KreetonVector;
      
      private static var kreetusArt:KreetusVector;
      
      private static var magmagonArt:MagmagonVector;
      
      private static var leafletArt:LeafletVector;
      
      private static var leaflingArt:LeaflingVector;
      
      private static var lotusEyeArt:LotusEyeVector;
      
      private static var blockBotArt:BlockBotVector;
      
      private static var mushroomBallArt:MushroomBallVector;
      
      private static var stalkerArt:NightstalkerVector;
      
      private static var orangeCrazyArt:OrangeCrazyVector;
      
      private static var penguinArt:PenguinVector;
      
      private static var plantMonsterArt:PlantMonsterVector;
      
      private static var proteumArt:ProteumVector;
      
      private static var pumpkinCreeperArt:PumpkinCreeperVector;
      
      private static var purpleGooArt:PurpleGooVector;
      
      private static var redBouncerArt:RedBouncerVector;
      
      private static var repguanaArt:RepguanaVector;
      
      private static var sasquatchArt:SasquatchVector;
      
      private static var mushroomSquishArt:MushroomSquishVector;
      
      private static var titaniumVultureArt:TitaniumVultureVector;
      
      private static var yellowPuffMonsterArt:YellowPuffMonsterVector;
      
      private static var aipsterArt:AipsterVector;
      
      private static var mongrelArt:MongrelVector;
      
      private static var krakenArt:KrakenVector;
      
      private static var bullopedeArt:BullopedeVector;
      
      private static var flocklingArt:FlocklingVector;
      
      private static var chirpletArt:ChirpletVector;
      
      private static var krawArt:KrawVector;
      
      private static var mushroomBirdArt:MushroomBirdVector;
      
      private static var omegaFluffArt:OmegaFluffVector;
      
      public static var greenAreaLightMap_textureAtlas:TextureAtlas;
      
      public static var greenAreaFGLightMap_textureAtlas:TextureAtlas;
      
      public static var treeFishLighMap_textureAtlas:TextureAtlas;
      
      public static var itemsPetsLightMap_textureAtlas:TextureAtlas;
      
      public static var greenBouncerLightMap_textureAtlas:TextureAtlas;
      
      private static const RightClick1Image:Class = Assets_RightClick1Image;
      
      private static const RightClick2Image:Class = Assets_RightClick2Image;
      
      private static const Font_PNG:Class = Assets_Font_PNG;
      
      private static const Font_XML:Class = Assets_Font_XML;
      
      private static const StatsFont_PNG:Class = Assets_StatsFont_PNG;
      
      private static const StatsFont_XML:Class = Assets_StatsFont_XML;
      
      private static const ReadableFont_PNG:Class = Assets_ReadableFont_PNG;
      
      private static const ReadableFont_XML:Class = Assets_ReadableFont_XML;
      
      private static const LotteryFont_PNG:Class = Assets_LotteryFont_PNG;
      
      private static const LotteryFont_XML:Class = Assets_LotteryFont_XML;
      
      private static const ChalkFont_PNG:Class = Assets_ChalkFont_PNG;
      
      private static const ChalkFont_XML:Class = Assets_ChalkFont_XML;
      
      private static const DamageFont_PNG:Class = Assets_DamageFont_PNG;
      
      private static const DamageFont_XML:Class = Assets_DamageFont_XML;
      
      private static var namesFont_texture:Texture = Texture.fromEmbeddedAsset(Font_PNG,false,false,1,Context3DTextureFormat.BGRA_PACKED);
      
      private static var namesFont_xml:XML = XML(new Font_XML());
      
      public static var names_font:BitmapFont = new BitmapFont(namesFont_texture,namesFont_xml);
      
      private static var statsFont_texture:Texture = Texture.fromEmbeddedAsset(StatsFont_PNG,false,false,1,Context3DTextureFormat.BGRA_PACKED);
      
      private static var statsFont_xml:XML = XML(new StatsFont_XML());
      
      public static var stats_font:BitmapFont = new BitmapFont(statsFont_texture,statsFont_xml);
      
      private static var readableFont_texture:Texture = Texture.fromEmbeddedAsset(ReadableFont_PNG,false,false,1,Context3DTextureFormat.BGRA_PACKED);
      
      private static var readableFont_xml:XML = XML(new ReadableFont_XML());
      
      public static var readable_font:BitmapFont = new BitmapFont(readableFont_texture,readableFont_xml);
      
      private static var lotteryFont_texture:Texture = Texture.fromEmbeddedAsset(LotteryFont_PNG,false,false,1,Context3DTextureFormat.BGRA_PACKED);
      
      private static var lotteryFont_xml:XML = XML(new LotteryFont_XML());
      
      public static var lottery_font:BitmapFont = new BitmapFont(lotteryFont_texture,lotteryFont_xml);
      
      private static var chalkFont_texture:Texture = Texture.fromEmbeddedAsset(ChalkFont_PNG,false,false,1,Context3DTextureFormat.BGRA_PACKED);
      
      private static var chalkFont_xml:XML = XML(new ChalkFont_XML());
      
      public static var chalk_font:BitmapFont = new BitmapFont(chalkFont_texture,chalkFont_xml);
      
      private static var damageFont_texture:Texture = Texture.fromEmbeddedAsset(DamageFont_PNG,false,false,1,Context3DTextureFormat.BGRA_PACKED);
      
      private static var damageFont_xml:XML = XML(new DamageFont_XML());
      
      public static var damage_font:BitmapFont = new BitmapFont(damageFont_texture,damageFont_xml);
      
      public static const textureFormatType:String = GameMain.isMobile ? Context3DTextureFormat.BGRA_PACKED : Context3DTextureFormat.BGRA;
      
      public static var items_object:Object = new Object();
      
      public static var main_assetManager:AssetManagerExtended = new AssetManagerExtended();
      
      public static var lightMap_assetManager:AssetManager = new AssetManager();
      
      private static const enemyArt_array:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      private static const enemyNames_array:Vector.<String> = new Vector.<String>();
      
      TextField.registerBitmapFont(names_font);
      TextField.registerBitmapFont(stats_font);
      TextField.registerBitmapFont(readable_font);
      TextField.registerBitmapFont(lottery_font);
      TextField.registerBitmapFont(chalk_font);
      TextField.registerBitmapFont(damage_font);
      main_assetManager.verbose = false;
      main_assetManager.keepAtlasXmls = true;
      
      public function Assets()
      {
         super();
      }
      
      public static function init(param1:Boolean = false) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:ExplosionVector = null;
         var _loc4_:YellowExplosionVector = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:Bitmap = new Bitmap(new BitmapData(1,1,false,16777215));
         _loc9_.name = "white pixel";
         var _loc10_:TreeFishContainer = new TreeFishContainer();
         _loc10_.addChild(_loc9_);
         treesFish_textureAtlas = AtlasBuilder.containerToTextureAtlas(_loc10_,1024,2048,Context3DTextureFormat.BGRA_PACKED);
         powerUp_textureAtlas = AtlasBuilder.containerToTextureAtlas(new PowerUpContainer(),2048,2048,Context3DTextureFormat.BGRA_PACKED);
         rightClick1_data = (new RightClick1Image() as Bitmap).bitmapData;
         rightClick2_data = (new RightClick2Image() as Bitmap).bitmapData;
         bionicBirdArt = new BionicBirdVector();
         bouncingMushroomArt = new BouncingMushroomVector();
         brickMonsterArt = new BrickMonsterVector();
         carneliaArt = new CarneliaVector();
         crabArt = new CrabVector();
         beholderArt = new BeholderVector();
         drillBotArt = new DrillBotVector();
         fishurnArt = new FishurnVector();
         greatFrogArt = new GreatFrogVector();
         glordArt = new GlordVector();
         gooCubeArt = new GooCubeVector();
         giantGooCubeArt = new GiantGooCubeVector();
         greenBouncerArt = new GreenBouncerVector();
         greenWalkerArt = new GreenWalkerVector();
         yellowHairyMonsterArt = new YellowHairyMonsterVector();
         hornedMonsterArt = new HornedMonsterVector();
         kreetonArt = new KreetonVector();
         kreetusArt = new KreetusVector();
         magmagonArt = new MagmagonVector();
         leafletArt = new LeafletVector();
         leaflingArt = new LeaflingVector();
         lotusEyeArt = new LotusEyeVector();
         blockBotArt = new BlockBotVector();
         mushroomBallArt = new MushroomBallVector();
         stalkerArt = new NightstalkerVector();
         orangeCrazyArt = new OrangeCrazyVector();
         penguinArt = new PenguinVector();
         plantMonsterArt = new PlantMonsterVector();
         proteumArt = new ProteumVector();
         pumpkinCreeperArt = new PumpkinCreeperVector();
         purpleGooArt = new PurpleGooVector();
         redBouncerArt = new RedBouncerVector();
         repguanaArt = new RepguanaVector();
         sasquatchArt = new SasquatchVector();
         mushroomSquishArt = new MushroomSquishVector();
         titaniumVultureArt = new TitaniumVultureVector();
         yellowPuffMonsterArt = new YellowPuffMonsterVector();
         aipsterArt = new AipsterVector();
         mongrelArt = new MongrelVector();
         krakenArt = new KrakenVector();
         bullopedeArt = new BullopedeVector();
         flocklingArt = new FlocklingVector();
         chirpletArt = new ChirpletVector();
         krawArt = new KrawVector();
         mushroomBirdArt = new MushroomBirdVector();
         omegaFluffArt = new OmegaFluffVector();
         enemyArt_array.push(bionicBirdArt,bouncingMushroomArt,brickMonsterArt,carneliaArt,crabArt,beholderArt,drillBotArt,fishurnArt,greatFrogArt,glordArt,gooCubeArt,giantGooCubeArt,greenBouncerArt,greenWalkerArt,yellowHairyMonsterArt,hornedMonsterArt,kreetonArt,kreetusArt,magmagonArt,leafletArt,leaflingArt,lotusEyeArt,blockBotArt,mushroomBallArt,stalkerArt,orangeCrazyArt,penguinArt,plantMonsterArt,proteumArt,pumpkinCreeperArt,purpleGooArt,redBouncerArt,repguanaArt,sasquatchArt,mushroomSquishArt,titaniumVultureArt,yellowPuffMonsterArt,aipsterArt,mongrelArt,krakenArt,bullopedeArt,flocklingArt,chirpletArt,krawArt,mushroomBirdArt,omegaFluffArt);
         enemyNames_array.push("bionic bird","bouncing mushroom","brick monster","Carnelia","crab","dark beholder","drill bot","fishurn","great frog","glord","goo cube","giant goo cube","green bouncer","green walker","yellow hairy monster","horned monster","kreeton","Kreetus","magmagon","leaflet","leafling","lotus eye","block bot","mushroom ball","night stalker","orange crazy","penguin","plant monster","proteum","pumpkin creeper","purple goo","red bouncer","repguana","sasquatch","mushroom squish","titanium vulture","yellow puff monster","aipster","mongrel","kraken","bullopede","flockling","chirplet","kraw","mushroom bird","omega fluff");
         for each(_loc2_ in enemyArt_array)
         {
            _loc2_.stop();
         }
         _loc3_ = new ExplosionVector();
         Explosion.info_array = MovieClipToAtlas.createAtlas(_loc3_,"explosion_",Context3DTextureFormat.BGRA_PACKED);
         _loc4_ = new YellowExplosionVector();
         YellowExplosion.info_array = MovieClipToAtlas.createAtlas(_loc4_,"yellowExplosion_",Context3DTextureFormat.BGRA_PACKED);
         _loc5_ = main_assetManager.getXml("items_pets_bodies").SubTexture.length();
         _loc8_ = 0;
         while(_loc8_ < _loc5_)
         {
            _loc6_ = main_assetManager.getXml("items_pets_bodies").SubTexture[_loc8_];
            _loc7_ = _loc6_.@name;
            if(_loc7_.length > 3 && _loc7_.substr(_loc7_.length - 3,3) == "_00")
            {
               _loc7_ = _loc7_.substr(0,_loc7_.length - 3);
               items_object[_loc7_] = new Object();
               items_object[_loc7_].pivotX = _loc6_.@pivotX;
               items_object[_loc7_].pivotY = _loc6_.@pivotY;
            }
            else
            {
               items_object[_loc7_] = new Object();
               items_object[_loc7_].pivotX = _loc6_.@pivotX;
               items_object[_loc7_].pivotY = _loc6_.@pivotY;
            }
            _loc8_++;
         }
         if(param1)
         {
            lightMap_assetManager.enqueueWithName("working assets/tile sets/normal maps/green area_NORMALS.png","green area texture");
            lightMap_assetManager.enqueueWithName("working assets/tile sets/normal maps/green area foreground_NORMALS.png","green area FG texture");
            lightMap_assetManager.enqueue("working assets/tile sets/normal maps/trees and fish_NORMALS.png");
            lightMap_assetManager.enqueue("working assets/tile sets/normal maps/trees and fish_NORMALS.xml");
            lightMap_assetManager.enqueueWithName("dynamic_content/nonTile_normalMaps/items_pets_bodies_NORMALS.png","items pets texture");
            lightMap_assetManager.enqueue("dynamic_content/nonTile_normalMaps/green bouncer_NORMALS.png");
            lightMap_assetManager.enqueue("dynamic_content/nonTile_normalMaps/green bouncer_NORMALS.xml");
            lightMap_assetManager.verbose = true;
            lightMap_assetManager.loadQueue(lightMapsProgress);
         }
         Stats.wStats["paintball gun"].sound = SoundLibrary.paintball_sound;
         Stats.wStats["handgun"].sound = SoundLibrary.pistol_sound;
         Stats.wStats["shotgun"].sound = SoundLibrary.shotgun_sound;
         Stats.wStats["tommy gun"].sound = SoundLibrary.tommyGun_sound;
         Stats.wStats["ak47"].sound = SoundLibrary.ak47_sound;
         Stats.wStats["M16"].sound = SoundLibrary.M16_sound;
         Stats.wStats["sniper rifle"].sound = SoundLibrary.sniperRifle_sound;
         Stats.wStats["bb gun"].sound = SoundLibrary.bb_sound;
         Stats.wStats["chaingun"].sound = SoundLibrary.chaingun_sound;
         Stats.wStats["mac10"].sound = SoundLibrary.mac10_sound;
         Stats.wStats["mp5"].sound = SoundLibrary.mp5_sound;
         Stats.wStats["potato gun"].sound = SoundLibrary.potatoGun_sound;
         Stats.wStats["xm8 rifle"].sound = SoundLibrary.xm8_sound;
         Stats.wStats["revolver"].sound = SoundLibrary.revolver_sound;
         Stats.wStats["kreeton gun"].sound = SoundLibrary.kreetonGun_sound;
         Stats.wStats["rayon gun"].sound = SoundLibrary.rayonBeam_sound;
         Stats.wStats["bazooka"].sound = SoundLibrary.bazooka_sound;
         Stats.wStats["beholder gun"].sound = SoundLibrary.beholderGun_sound;
         Stats.wStats["machine gun"].sound = SoundLibrary.machineGun_sound;
         Stats.wStats["airsoft gun"].sound = SoundLibrary.airsoft_sound;
         Stats.wStats["es c90"].sound = SoundLibrary.esc90_sound;
         Stats.wStats["skullcrusher gun"].sound = SoundLibrary.skullcrusherGun_sound;
         Stats.wStats["enforcer gun"].sound = SoundLibrary.enforcerGun_sound;
         Stats.wStats["skull bone gun"].sound = SoundLibrary.skullGun_sound;
         Stats.wStats["radiator gun"].sound = SoundLibrary.radiatorGun_sound;
         Stats.wStats["corruptor"].sound = SoundLibrary.corruptor_sound;
         Stats.wStats["neoplasti blaster"].sound = SoundLibrary.neoplastiBlaster_sound;
      }
      
      private static function lightMapsProgress(param1:Number) : void
      {
         var _loc2_:Texture = null;
         var _loc3_:XML = null;
         var _loc4_:Texture = null;
         var _loc5_:XML = null;
         if(param1 == 1)
         {
            _loc2_ = lightMap_assetManager.getTexture("green area texture");
            _loc3_ = TileHandler.createTileAtlasXML(_loc2_.width,_loc2_.height);
            greenAreaLightMap_textureAtlas = new TextureAtlas(_loc2_,_loc3_);
            _loc4_ = lightMap_assetManager.getTexture("green area FG texture");
            _loc5_ = TileHandler.createTileAtlasXML(_loc4_.width,_loc4_.height);
            greenAreaFGLightMap_textureAtlas = new TextureAtlas(_loc4_,_loc5_);
            treeFishLighMap_textureAtlas = lightMap_assetManager.getTextureAtlas("trees and fish_NORMALS");
            itemsPetsLightMap_textureAtlas = new TextureAtlas(lightMap_assetManager.getTexture("items pets texture"),main_assetManager.getXml("items_pets_bodies"));
            greenBouncerLightMap_textureAtlas = lightMap_assetManager.getTextureAtlas("green bouncer_NORMALS");
         }
      }
      
      public static function getEnemyArt(param1:String) : MovieClip
      {
         var _loc2_:uint = uint(enemyNames_array.length);
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            if(enemyNames_array[_loc3_] == param1)
            {
               return enemyArt_array[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public static function enqueuePreloadAssets() : void
      {
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/items_pets_bodies.png");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/items_pets_bodies.xml");
         main_assetManager.textureFormat = Context3DTextureFormat.BGRA_PACKED;
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/character menu.png");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/character menu.xml");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/item menu.png");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/item menu.xml");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/map menu.png");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/map menu.xml");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/char create menu.png");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/char create menu.xml");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/pet menu.png");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/pet menu.xml");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/controls.png");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/controls.xml");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/energy menu.png");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/energy menu.xml");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/guild member menu.png");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/guild member menu.xml");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/heropedia menu.png");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/heropedia menu.xml");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/pet mode menu.png");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/pet mode menu.xml");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/skills menu.png");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/skills menu.xml");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/friends menu.png");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/friends menu.xml");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/talk box.png");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/talk box.xml");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/load screen.png");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/load screen.xml");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/talk_font.png");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/sprite_sheets/talk_font.fnt");
         main_assetManager.enqueue("https://yuriifedorov01-cpu.github.io/hht-client/dynamic_content/misc/pet_body_locations.xml");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/quick hit.mp3","quick hit");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/level up.mp3","level up");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/crunch.mp3","crunch");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/crunch 2.mp3","crunch 2");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/coin get.mp3","coin get");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/item bought.mp3","item bought");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/item sold.mp3","item sold");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/cash register.mp3","cash register");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/teleport.mp3","teleport");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/click.mp3","click");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/new mission.mp3","new mission");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/rock fall.mp3","rock fall");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/boing.mp3","boing");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/pickup.mp3","pickup");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/bow_fire.mp3","bow fire");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/heal sound.mp3","heal sound");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/magic.mp3","magic");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/magic swing.mp3","magic swing");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/new sign on.mp3","new sign on");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/new chat message.mp3","new chat message");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/NFF-usb-yes.mp3","trade request");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/electric zap.mp3","electric zap");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/fireball.mp3","fireball");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/high shine.mp3","high shine");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/NFF-choice-bad.mp3","bad choice");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/sword swoosh 1.mp3","slash");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/sword swoosh 2.mp3","slash 2");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/sword swoosh 3.mp3","slash 3");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/NFF-fake-wind.mp3","wind");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/heavy swing.mp3","swing");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/Thunder_Booming_SE.mp3","thunder");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/alert menu.mp3","alert menu");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/pet evolve.mp3","pet evolve");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/coin box hit.mp3","coin box");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/Metal Hit 01 Sound Effects.mp3","metal hit");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/water swish.mp3","splash");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/gun sounds/M16.mp3","M16");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/gun sounds/pistol.mp3","pistol");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/gun sounds/ak47.mp3","ak47");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/gun sounds/paintball gun.mp3","paintball gun");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/gun sounds/shotgun.mp3","shotgun");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/gun sounds/skullcrusher gun.mp3","skullcrusher gun");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/gun sounds/sniper rifle.mp3","sniper rifle");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/gun sounds/tommy gun.mp3","tommy gun");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/gun sounds/bb gun.mp3","bb gun");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/gun sounds/chaingun.mp3","chaingun");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/gun sounds/mac 10.mp3","mac 10");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/gun sounds/mp5.mp3","mp5");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/gun sounds/potato gun.mp3","potato gun");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/gun sounds/x8 rifle.mp3","x8 rifle");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/gun sounds/bazooka.mp3","bazooka");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/gun sounds/beholder gun.mp3","beholder gun");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/gun sounds/kreeton gun.mp3","kreeton gun");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/gun sounds/rayon beam.mp3","rayon beam");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/gun sounds/enforcer gun.mp3","enforcer gun");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/gun sounds/revolver.mp3","revolver");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/gun sounds/machine gun.mp3","machine gun");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/gun sounds/airsoft gun.mp3","airsoft gun");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/gun sounds/es c90.mp3","es c90");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/gun sounds/skull bone gun.mp3","skull bone gun");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/gun sounds/corruptor.mp3","corruptor");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/gun sounds/neoplasti blaster.mp3","neoplasti blaster");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/chomp.mp3","chomp");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/roar 3.mp3","roar");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/woosh2.mp3","woosh");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/HE GRENADE sound effect.mp3","grenade");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/beholder cannon.mp3","beholder cannon");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/NFF-menu-a.mp3","menu");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/proficient level up.mp3","prof level up");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/stick break.mp3","stick break");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/wood hit.mp3","wood hit 1");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/wood hit2.mp3","wood hit 2");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/logs.mp3","logs");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/controller.mp3","controller on");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/controller disconnect.mp3","controller off");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/wing flap.mp3","wing flap");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/running.mp3","running");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/male grunt 1.mp3","grunt 1");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/male grunt 2.mp3","grunt 2");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/take hit 1.mp3","take hit 1");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/take hit 2.mp3","take hit 2");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/female grunt 1.mp3","female grunt 1");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/female grunt 2.mp3","female grunt 2");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/power up.mp3","power up");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/short zap.mp3","short zap");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/Sci Fi Ring Explosion.mp3","ring explosion");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/light beam.mp3","light beam");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/little dog bark.mp3","little bark");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/medium dog bark.mp3","medium bark");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/big dog bark.mp3","big bark");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/bubble pop.mp3","bubble pop");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/fart1.mp3","fart 1");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/fart2.mp3","fart 2");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/fart3.mp3","fart 3");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/NFF-uncap.mp3","unequip");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/new pm.mp3","new pm");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/jump.mp3","jump");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/jump2.mp3","jump 2");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/epic hit 1.mp3","epic hit");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/power up impact hit.mp3","impact hit");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/power up hit 1.mp3","power up hit");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/low drone.mp3","low drone");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/lightning strike 2.mp3","lightning 1");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/lightning strike 3.mp3","lightning 2");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/gun sounds/radiator gun.mp3","radiator gun");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/glass break.mp3","glass break");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/green bouncer.mp3","green bouncer");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/green walker.mp3","green walker");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/purple goo.mp3","purple goo");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/red bouncer.mp3","red bouncer");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/yellow puff.mp3","yellow puff monster");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/yellow hairy.mp3","yellow hairy monster");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/mushroom ball.mp3","mushroom ball");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/pumpkin.mp3","pumpkin creeper");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/orange crazy.mp3","orange crazy");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/horned monster.mp3","horned monster");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/mushroom squish.mp3","mushroom squish");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/leaflet2.mp3","leaflet");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/leafling.mp3","leafling");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/great frog.mp3","great frog");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/penguin.mp3","penguin");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/plant monster.mp3","plant monster");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/crab.mp3","crab");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/fishurn.mp3","fishurn");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/glorn.mp3","glord");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/block bot.mp3","block bot");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/drill bot.mp3","drill bot");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/bouncing mushroom.mp3","bouncing mushroom");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/sasquatch.mp3","sasquatch");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/kreeton.mp3","kreeton");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/proteum.mp3","proteum");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/repguana.mp3","repguana");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/beholder.mp3","dark beholder");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/stalker.mp3","night stalker");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/lotus eye.mp3","lotus eye");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/brick monster.mp3","brick monster");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/goo cube.mp3","goo cube");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/vulture.mp3","bionic bird");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/hawk.mp3","titanium vulture");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/lava dragon.mp3","magmagon");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/aipster.mp3","aipster");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/mongrel.mp3","mongrel");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/kraken.mp3","kraken");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/bullopede.mp3","bullopede");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/chirplet.mp3","chirplet");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/flockling.mp3","flockling");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/kraw.mp3","kraw");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/mushroom bird.mp3","mushroom bird");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/monster growl.mp3","Carnelia");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/enemy sounds/omega fluff.mp3","omega fluff");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/roar 3.mp3","Kreetus");
         main_assetManager.enqueueWithName("https://yuriifedorov01-cpu.github.io/hht-client/SFX_and_music/SFX/wood split.mp3","wood split");
      }
      
      public static function assignAssets() : void
      {
         var _loc1_:String = null;
         items_textureAtlas = main_assetManager.getTextureAtlas("items_pets_bodies");
         ItemMenu.itemMenu_textureAtlas = main_assetManager.getTextureAtlas("item menu");
         MapMenu.mapMenu_textureAtlas = main_assetManager.getTextureAtlas("map menu");
         CharacterMenu.charMenu_textureAtlas = main_assetManager.getTextureAtlas("character menu");
         PetMenu.petMenu_textureAtlas = main_assetManager.getTextureAtlas("pet menu");
         FriendMenu.friendMenu_textureAtlas = main_assetManager.getTextureAtlas("friends menu");
         EnergyMenu.energyMenu_textureAtlas = main_assetManager.getTextureAtlas("energy menu");
         GuildMemberMenu.guildMemberMenu_textureAtlas = main_assetManager.getTextureAtlas("guild member menu");
         HeropediaMenu.heropediaMenu_textureAtlas = main_assetManager.getTextureAtlas("heropedia menu");
         PetModeMenu.petModeMenu_textureAtlas = main_assetManager.getTextureAtlas("pet mode menu");
         SkillsMenu.skillsMenu_textureAtlas = main_assetManager.getTextureAtlas("skills menu");
         Controls.controls_textureAtlas = main_assetManager.getTextureAtlas("controls");
         TalkBox.talkBox_textureAtlas = main_assetManager.getTextureAtlas("talk box");
         SoundLibrary.hit_sound = main_assetManager.getSound("quick hit");
         SoundLibrary.levelUp_sound = main_assetManager.getSound("level up");
         SoundLibrary.crunch_sound = main_assetManager.getSound("crunch");
         SoundLibrary.crunch2_sound = main_assetManager.getSound("crunch 2");
         SoundLibrary.coinGet_sound = main_assetManager.getSound("coin get");
         SoundLibrary.itemBought_sound = main_assetManager.getSound("item bought");
         SoundLibrary.itemSold_sound = main_assetManager.getSound("item sold");
         SoundLibrary.cashRegister_sound = main_assetManager.getSound("cash register");
         SoundLibrary.teleport_sound = main_assetManager.getSound("teleport");
         SoundLibrary.click_sound = main_assetManager.getSound("click");
         SoundLibrary.newMission_sound = main_assetManager.getSound("new mission");
         SoundLibrary.treeFall_sound = main_assetManager.getSound("rock fall");
         SoundLibrary.boing_sound = main_assetManager.getSound("boing");
         SoundLibrary.pickup_sound = main_assetManager.getSound("pickup");
         SoundLibrary.bow_sound = main_assetManager.getSound("bow fire");
         SoundLibrary.heal_sound = main_assetManager.getSound("heal sound");
         SoundLibrary.magic_sound = main_assetManager.getSound("magic");
         SoundLibrary.magicSwing_sound = main_assetManager.getSound("magic swing");
         SoundLibrary.newSignOn_sound = main_assetManager.getSound("new sign on");
         SoundLibrary.newChat_sound = main_assetManager.getSound("new chat message");
         SoundLibrary.tradeRequest_sound = main_assetManager.getSound("trade request");
         SoundLibrary.electric_sound = main_assetManager.getSound("electric zap");
         SoundLibrary.fireball_sound = main_assetManager.getSound("fireball");
         SoundLibrary.ice_sound = main_assetManager.getSound("high shine");
         SoundLibrary.newEntry_sound = main_assetManager.getSound("bad choice");
         SoundLibrary.swoosh1_sound = main_assetManager.getSound("slash");
         SoundLibrary.swoosh2_sound = main_assetManager.getSound("slash 2");
         SoundLibrary.swoosh3_sound = main_assetManager.getSound("slash 3");
         SoundLibrary.rage_sound = main_assetManager.getSound("wind");
         SoundLibrary.heavySwing_sound = main_assetManager.getSound("swing");
         SoundLibrary.thunder_sound = main_assetManager.getSound("thunder");
         SoundLibrary.alertMenu_sound = main_assetManager.getSound("alert menu");
         SoundLibrary.petEvolve_sound = main_assetManager.getSound("pet evolve");
         SoundLibrary.coinBox_sound = main_assetManager.getSound("coin box");
         SoundLibrary.metal1_sound = main_assetManager.getSound("metal hit");
         SoundLibrary.waterSwish_sound = main_assetManager.getSound("splash");
         SoundLibrary.M16_sound = main_assetManager.getSound("M16");
         SoundLibrary.pistol_sound = main_assetManager.getSound("pistol");
         SoundLibrary.ak47_sound = main_assetManager.getSound("ak47");
         SoundLibrary.paintball_sound = main_assetManager.getSound("paintball gun");
         SoundLibrary.shotgun_sound = main_assetManager.getSound("shotgun");
         SoundLibrary.skullcrusherGun_sound = main_assetManager.getSound("skullcrusher gun");
         SoundLibrary.sniperRifle_sound = main_assetManager.getSound("sniper rifle");
         SoundLibrary.tommyGun_sound = main_assetManager.getSound("tommy gun");
         SoundLibrary.bb_sound = main_assetManager.getSound("bb gun");
         SoundLibrary.chaingun_sound = main_assetManager.getSound("chaingun");
         SoundLibrary.mac10_sound = main_assetManager.getSound("mac 10");
         SoundLibrary.mp5_sound = main_assetManager.getSound("mp5");
         SoundLibrary.potatoGun_sound = main_assetManager.getSound("potato gun");
         SoundLibrary.xm8_sound = main_assetManager.getSound("x8 rifle");
         SoundLibrary.bazooka_sound = main_assetManager.getSound("bazooka");
         SoundLibrary.beholderGun_sound = main_assetManager.getSound("beholder gun");
         SoundLibrary.kreetonGun_sound = main_assetManager.getSound("kreeton gun");
         SoundLibrary.rayonBeam_sound = main_assetManager.getSound("rayon beam");
         SoundLibrary.enforcerGun_sound = main_assetManager.getSound("enforcer gun");
         SoundLibrary.revolver_sound = main_assetManager.getSound("revolver");
         SoundLibrary.machineGun_sound = main_assetManager.getSound("machine gun");
         SoundLibrary.airsoft_sound = main_assetManager.getSound("airsoft gun");
         SoundLibrary.esc90_sound = main_assetManager.getSound("es c90");
         SoundLibrary.corruptor_sound = main_assetManager.getSound("corruptor");
         SoundLibrary.neoplastiBlaster_sound = main_assetManager.getSound("neoplasti blaster");
         SoundLibrary.skullGun_sound = main_assetManager.getSound("skull bone gun");
         SoundLibrary.chomp_sound = main_assetManager.getSound("chomp");
         SoundLibrary.woosh2_sound = main_assetManager.getSound("woosh 2");
         SoundLibrary.explosion_sound = main_assetManager.getSound("grenade");
         SoundLibrary.beholderCannon_sound = main_assetManager.getSound("beholder cannon");
         SoundLibrary.fishCaught_sound = main_assetManager.getSound("menu");
         SoundLibrary.proLevelUp_sound = main_assetManager.getSound("prof level up");
         SoundLibrary.stickBreak_sound = main_assetManager.getSound("stick break");
         SoundLibrary.woodHit1_sound = main_assetManager.getSound("wood hit 1");
         SoundLibrary.woodHit2_sound = main_assetManager.getSound("wood hit 2");
         SoundLibrary.logsFall_sound = main_assetManager.getSound("logs");
         SoundLibrary.controller_sound = main_assetManager.getSound("controller on");
         SoundLibrary.controllerDisconnect_sound = main_assetManager.getSound("controller off");
         SoundLibrary.wingFlap_sound = main_assetManager.getSound("wing flap");
         SoundLibrary.running_sound = main_assetManager.getSound("running");
         SoundLibrary.maleGrunt1_sound = main_assetManager.getSound("grunt 1");
         SoundLibrary.maleGrunt2_sound = main_assetManager.getSound("grunt 2");
         SoundLibrary.takeHit1_sound = main_assetManager.getSound("take hit 1");
         SoundLibrary.takeHit2_sound = main_assetManager.getSound("take hit 2");
         SoundLibrary.femaleGrunt1_sound = main_assetManager.getSound("female grunt 1");
         SoundLibrary.femaleGrunt2_sound = main_assetManager.getSound("female grunt 2");
         SoundLibrary.powerUp_sound = main_assetManager.getSound("power up");
         SoundLibrary.zap_sound = main_assetManager.getSound("short zap");
         SoundLibrary.sciFiExplosion_sound = main_assetManager.getSound("ring explosion");
         SoundLibrary.lightBeam_sound = main_assetManager.getSound("light beam");
         SoundLibrary.littleDogBark_sound = main_assetManager.getSound("little bark");
         SoundLibrary.mediumDogBark_sound = main_assetManager.getSound("medium bark");
         SoundLibrary.bigDogBark_sound = main_assetManager.getSound("big bark");
         SoundLibrary.bubblePop_sound = main_assetManager.getSound("bubble pop");
         SoundLibrary.fart1_sound = main_assetManager.getSound("fart 1");
         SoundLibrary.fart2_sound = main_assetManager.getSound("fart 2");
         SoundLibrary.fart3_sound = main_assetManager.getSound("fart 3");
         SoundLibrary.unEquip_sound = main_assetManager.getSound("unequip");
         SoundLibrary.newPM_sound = main_assetManager.getSound("new pm");
         SoundLibrary.jump_sound = main_assetManager.getSound("jump");
         SoundLibrary.jump2_sound = main_assetManager.getSound("jump 2");
         SoundLibrary.epicHit1_sound = main_assetManager.getSound("epic hit");
         SoundLibrary.powerUpImpact_sound = main_assetManager.getSound("impact hit");
         SoundLibrary.powerUpHit1_sound = main_assetManager.getSound("power up hit");
         SoundLibrary.lowDrone_sound = main_assetManager.getSound("low drone");
         SoundLibrary.thunder2_sound = main_assetManager.getSound("lighting 2");
         SoundLibrary.thunder3_sound = main_assetManager.getSound("lightning 3");
         SoundLibrary.radiatorGun_sound = main_assetManager.getSound("radiator gun");
         SoundLibrary.glassBreak_sound = main_assetManager.getSound("glass break");
         SoundLibrary.woodSplit_sound = main_assetManager.getSound("wood split");
         for each(_loc1_ in Stats.enemyList)
         {
            Stats.eDescs[_loc1_].sound = main_assetManager.getSound(_loc1_);
         }
      }
   }
}

