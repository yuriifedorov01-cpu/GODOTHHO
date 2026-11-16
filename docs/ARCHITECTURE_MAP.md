# Helmet Heroes (`MyGame.swf` & `HH-cLoader.swf`) — Exhaustive Architecture & Reverse-Engineering Map

> **Generated for Godot 4 Migration (`D:\PERENOS_GODOT`)**
> - **Loader Source**: `D:\PERENOS\HH-cLoader.swf` (decompiled at `D:\PERENOS_GODOT\source_analysis\decompiled_loader\scripts`)
> - **Main Client Source**: `D:\HHT_CLIENT\MyGame.swf` (decompiled at `D:\PERENOS_GODOT\source_analysis\decompiled_mygame\scripts` — 1,016 `.as` scripts)
> - **Embedded Resources**: `D:\PERENOS_GODOT\source_analysis\decompiled_mygame\resources` (235 images, 41 fonts, 2 sounds) & `binaryData` (9 XML files)
> - **External Client Assets**: `D:\HHT_CLIENT\` (`data/`, `dynamic_content/`, `SFX_and_music/`, `cut-scenes/`, `includes/`) & `D:\PERENOS_GODOT\source_analysis\hht-maps`

---

## Table of Contents
1. [Loader & PlayerIO Network Architecture](#1-loader--playerio-network-architecture)
2. [Complete Class & Package Map of `MyGame.swf`](#2-complete-class--package-map-of-mygameswf)
3. [Complete Network Protocol (`addMessageHandler` & `send`)](#3-complete-network-protocol-addmessagehandler--send)
4. [External Data & Asset Formats (`D:\HHT_CLIENT` & `hht-maps`)](#4-external-data--asset-formats-dhht_client--hht-maps)
5. [Engine Subsystems: Rendering, Physics, Animations, Inventory, Combat & UI](#5-engine-subsystems-rendering-physics-animations-inventory-combat--ui)

---

## 1. Loader & PlayerIO Network Architecture

### 1.1 Loader (`HH-cLoader.swf` -> `MyGame.swf`)
- **Document Class**: `HH_cLoader_fla.MainTimeline` (`D:\PERENOS_GODOT\source_analysis\decompiled_loader\scripts\scripts\HH_cLoader_fla\MainTimeline.as`)
- **Stage Setup**: `950 x 700` native resolution, `30 FPS`, `StageAlign.TOP`, `StageScaleMode.SHOW_ALL`.
- **GameFS Redirect Patch**:
  - In `MainTimeline.frame1()`, the loader calls:
    ```actionscript
    content_url = new URLRequest(PlayerIO.gameFS("").getUrl("/MyGame.swf"));
    content_loader.load(content_url);
    ```
  - In `HH-cLoader.swf`'s `playerio.GameFS.getUrl(path, secure)` (`D:\PERENOS_GODOT\source_analysis\decompiled_loader\scripts\scripts\playerio\GameFS.as`), the base URL is patched to:
    `"https://yuriifedorov01-cpu.github.io/hht-client" + this.gameId + param1`
    Because `gameId` is `""`, it resolves to `https://yuriifedorov01-cpu.github.io/hht-client/MyGame.swf`.
  - In `MyGame.swf`, `playerio.GameFS.as` retains the stock `http://r.playerio.com/r/` URL, because `MyGame.swf` bypasses `PlayerIO.gameFS` and hardcodes `https://yuriifedorov01-cpu.github.io/hht-client/...` directly in `com.utilities.Assets`, `com.helpers.AreaCreator`, and `GameMain`.
- **Desktop/Mobile Wrapper Properties Passed to `MyGame.swf`**:
  - `thisURL_string = stage.loaderInfo.url`
  - `trueFullScreenWidth`, `trueFullScreenHeight`
  - `theNativeApp = NativeApplication.nativeApplication`

### 1.2 PlayerIO Connection Parameters
| Parameter | Value | Source Location |
|---|---|---|
| **`gameId`** | `"hho-ygpra4ftumusohpifpdug"` | `GameMain.as:L721, L731, L10039, L14281`, `MainStarlingStage.as:L1412` |
| **`useSecureApiRequests`** | `true` | `GameMain.as:L9759` (`PlayerIO.useSecureApiRequests = true`) |
| **API Endpoint (`HTTPChannel`)** | `https://api.playerio.com/api/{RPCMethodNum}` | `bridge/utils/HTTPChannel.as:L21-22` (both default and SSL URLs set to `https://api.playerio.com/api`) |
| **Client Version (`version_txt`)** | `"9.50"` (checked against `serverVersion` in `pJ` handler) | `com/ui/Controls.as:L282`, `GameMain.as:L3907-3915` |
| **BigDB Cache Version (`dbCacheVersion`)** | `110` (`SharedObject.getLocal("dbItems")`) | `GameMain.as:L620, L996-1000` |
| **Multiplayer Room Type** | `"MyCode"` | `GameMain.as:L768, L927` |
| **Multiplayer Room ID Format** | `{version}-r{currentLevel}_{serverName}` (e.g. `"9.50-r1_Pve Server"`) | `GameMain.as:L768` (`this.starlingStage.controls.version_txt.text + "-r" + this.currentLevel + "_" + this.serverName`) |
| **Default Server Names** | `"Pve Server"` (default `this.serverName`), `"PvP Server"`, legacy `"Main Server 1..3"`, plus up to 30 Private Servers | `GameMain.as:L255, L10560-10564, L14753-14754, L5205-5270` |

### 1.3 PlayerIO Authentication & `connectionId` Flows
All authentication flows occur in `GameMain.as` (`connectToServer` at `L705-755`, `onStarlingRootCreated` at `L10039`, `onClick` at `L1212-1231`, `gotoMainMenuFrame` at `L14278-14743`) and `starling/MainStarlingStage.as` (`L1412`):

1. **Initial Anonymous Stats Bootstrap (`connectionId = "public"`)**:
   - Called immediately on startup in `onStarlingRootCreated` (`GameMain.as:L10039`):
     `PlayerIO.authenticate(stage, "hho-ygpra4ftumusohpifpdug", "public", {"userId": "adsfjhakf"}, null, loadCheckItemAndEnemyStats)`
   - Loads item, weapon, armor, accessory, pet helmet, fish, base pet, and enemy stat tables from BigDB (or reads them from `SharedObject.getLocal("dbItems")` if `dbCacheVersion == 110`).
2. **Standard Username/Password Login (`connectionId = "simpleconnection"`)**:
   - In `connectToServer("simple")` (`GameMain.as:L726-733`):
     `PlayerIO.authenticate(stage, "hho-ygpra4ftumusohpifpdug", "simpleconnection", {"username": mMenu.username_txt.text, "password": mMenu.password_txt.text}, null, ...)`
   - Note: PlayerIO prefixes `connectUserId` with `"simple"` (e.g. `"simple" + username`).
3. **Simple User Registration (`connectionId = "simpleconnection"`)**:
   - In `MainStarlingStage.as:L1412` (when clicking `finished_btn` in `CreateMenu` on desktop/standalone):
     ```actionscript
     PlayerIO.authenticate(Starling.current.nativeStage, "hho-ygpra4ftumusohpifpdug", "simpleconnection", {
        "register": "true",
        "username": gameMain.charCreateMenu.name_txt.text,
        "password": gameMain.charCreateMenu.password_txt.text,
        "email": gameMain.charCreateMenu.email_txt.text
     }, null, gameMain.handleConnect, gameMain.registerError);
     ```
4. **Password Recovery / Password Change / Email Change (`connectionId = "simpleconnection"`)**:
   - Recover password (`GameMain.as:L1212`): `PlayerIO.quickConnect.simpleRecoverPassword("hho-ygpra4ftumusohpifpdug", email, ...)`
   - Change password (`GameMain.as:L1215-1220`): `PlayerIO.authenticate(..., "simpleconnection", {"changepassword": true, "username": ..., "password": ..., "newpassword": ...}, ...)`
   - Change email (`GameMain.as:L1225-1230`): `PlayerIO.authenticate(..., "simpleconnection", {"changeemail": true, "username": ..., "password": ..., "newemail": ...}, ...)`
5. **Portal Linked Accounts (`connectionId = "public"`, `connectType = "basic"`)**:
   - Used for **ArmorGames**, **Y8 (id.net)**, and **MiniPlay** (`GameMain.as:L716-724, L14324-14552`).
   - First authenticates with `"public"` (`{"userId": "adsfjhakf"}`) to look up `linkedUsers` table by portal UID, then fetches a secret hash from the portal helper and authenticates with `"public"` using `{"userId": username, "auth": passwordHash}`.
6. **Facebook OAuth (`connectType = "facebook"`)**:
   - Popup (`GameMain.as:L738`): `PlayerIO.quickConnect.facebookOAuthConnectPopup(stage, "hho-ygpra4ftumusohpifpdug", "_blank", ["publish_stream", "offline_access"], "1", ...)`
   - Canvas (`GameMain.as:L14281`): `PlayerIO.quickConnect.facebookOAuthConnect(stage, "hho-ygpra4ftumusohpifpdug", Facebook.token, null, null, ...)`
7. **Kongregate (`connectionId = "kongregateconnection"`, `connectType = "kongregate"`)**:
   - `GameMain.as:L14560`: `{"userId": Kongregate.uid, "gameAuthToken": Kongregate.token}`.
8. **PlayerIO Publishing Network (`connectionId = "publishingnetwork"`)**:
   - `GameMain.as:L14622`: `{"userToken": PlayerIOPublishingNetwork.token}`.
9. **Steam (`connectionId = "steamconnection"`, `connectType = "steam"`)**:
   - `GameMain.as:L14687`: `{"steamAppId": Steam.steam.getAppID(), "steamSessionTicket": Steam.getAuthToken()}`.

### 1.4 Room Join Flow & `joinData` Schema (`GameMain.joinRoom`, `L757-804`)
1. After authentication, `preLogInLoad()` (`GameMain.as:L10522`) loads the player's record from BigDB `PlayerObjects` using key `theClient.connectUserId` (or opens `CreateMenu` if `null`).
2. In `preLogInLoad()`, if `_dbObject.stage == 51`, it rewrites `_dbObject.stage = 46`, sets `serverName = _dbObject.serv` (if defined), moves `c_mc.gotoAndStop(_dbObject.stage)`, calls `changeLevel(c_mc.currentFrame, "portal" + (i+1), true)`, loads the area background via `AreaCreator.getBGArt`, and calls `joinRoom()`.
3. `joinRoom()` calls:
   ```actionscript
   theClient.multiplayer.createJoinRoom(
      starlingStage.controls.version_txt.text + "-r" + currentLevel + "_" + serverName,
      "MyCode",
      true,
      {},
      tempJoinData,
      handleJoin,
      roomConnectError
   );
   ```
4. **`tempJoinData` Fields**:
   - When `timesLoaded == 0` (initial login in session):
     - `firstJoin`: `true`
     - `relink`: `Boolean` (if `mMenu.relink == true`)
     - `uid`: Portal UID (`ArmorGames.uid`, `y8_api.userID`, `MiniPlay.lechuck.user.id`) when `connectType == "basic"`
   - When `charCreateMenu` is active (new character creation):
     - `url`: `playingURL_string`
     - `skin`: `int` (`1..4` for boy, `5..8` for girl — `selectedGender == "boy" ? selectedSkin : selectedSkin + 4`)
     - `eyes`: `int` (`selectedEyes`)
     - `hair`: `int` (`selectedHair`)
     - `beard`: `int` (`selectedBeard`)
     - `classType`: `String` (`"warrior"`, `"archer"`, `"mage"`, `"cowboy"`)
     - `username`: `String` (`charCreateMenu.name_txt.text`, if `connectType != "simple"`)
     - `onKong`: `Boolean` (`playingURL_string == "kongregate.com"`)
     - `onSteam`: `Boolean` (`playingURL_string == "steampowered.com"`)
     - `onPlayerIO`: `Boolean` (`playingURL_string == "playerio.com"`)
   - On all joins:
     - `x3`: `Boolean` (`hasGuildMoney3x`, if `true`)
     - `dupeSignIn`: `true` (if `dupeSignInAttempts > 0`)

### 1.5 BigDB Tables & Indexes Used by Client
| BigDB Table | Key / Index Used | Access Method | Purpose & Fields | Source Location |
|---|---|---|---|---|
| **`PlayerObjects`** | Key: `connectUserId` or `"simple" + name`<br>Index: `nameIndex` (`["facebook"/"kongregate"/"steam"/"playerio" + name]`)<br>Index: `levelIndex` | `load`, `loadSingle`, `loadRange`, `loadMyPlayerObject` | Core character save: `name`, `stage`, `serv`, `lev`, `xp`, `pow`, `dex`, `def`, `rng`, `mgc`, `art`, `hp`, `tHp`, `mp`, `tMp`, `money`, `ap`, `items`, `helm`, `shirt`, `leg`, `shoe`, `weap`, `weap2`, `acc`, `skin`, `eye`, `hair`, `beard`, `hasHalo`, `guild`, `role`, `books`, `on`, `login` | `GameMain.as:L10626, L14793-14846`, `RankMenu.as:L231` |
| **`pMiscTable`** | Key: `player.name` | `load`, `loadOrCreate`, `save` | Secondary player profile: `startedQuests`, `completedQuests`, `enemyList`, `fishList`, `friends`, `block`, `maps` (unlocked map IDs array), `registeredURL`, `signUpTime` | `GameMain.as:L3825, L3966-4046, L13359, L14068, L14765` |
| **`skillsData`** | Key: `player.name` | `load` | Skill levels & points: `p` (skillPoints), `scrollsUsed`, `jum`, `crit`, `loo`, `trai`, `rag`, `gRag`, `avoi`, `mpR`, `dash`, `dAc`, `blo`, `bar`, `aKn`, `exAr`, `tSh`, `aRai`, `pAr`, `dCru`, `pAt`, `exWar`, `chDis`, `shie`, `mulAt`, `melKn`, `spiAt`, `mShot`, `exWiz`, `cirMa`, `maDis`, `thAt`, `hea`, `gHea`, `gren`, `upw`, `exCo`, `bDi`, `sgun`, `bulK`, `jGre` | `GameMain.as:L4546, L5874-6048`, `SkillsMenu.as:L621` |
| **`proficiencyTable`** | Key: `player.name` | `load` | Professions & Energy max caps: `fishing`, `fishXP`, `chopping`, `chopXP`, `totMax`, `chargeMax`, `abMax`, `levMax`, `enMax`, `pvpMax`, `ranMax`, `rageMax`, `chopMax`, `fishMax` | `GameMain.as:L891, L6050-6070` |
| **`bankData`** | Key: `player.name` | `load` | ATM Bank balance & 13-slot item storage: `money`, `items` | `GameMain.as:L12792`, `BankMenu.as` |
| **`petData`** | Key: `petKey`<br>Index: `ownerIndex` (`[player.name]`) | `load`, `loadRange` | Player-owned pets (up to 8): `key`, `owner`, `oOwner`, `type`, `active`, `health`, `totalHealth`, `power`, `dex`, `def`, `love`, `mode`, `helm`, `shoe`, `companion`, `xpSplit`, `xp`, `lvl` | `GameMain.as:L3826, L4364, L6208-6239, L6794` |
| **`guildsData`** | Key: `guildName`<br>Indexes: `nameIndex`, `killsIndex`, `totalLevelsIndex` | `load`, `loadRange` | Guild records: `key`/`name`, `leader`, `desc`, `levelReq`, `mArray` (members), `pArray` (pending), `kills`, `totalLevels`, `points`, `x3` | `GameMain.as:L1310, L2313-2351, L4177, L5175` |
| **`messageTable`** | Index: `receiverIndex` (`[player.name]`) | `loadRange`, `deleteRange` | Offline/Private messages (PMs): `sender`, `receiver`, `messages` (Array) | `GameMain.as:L904, L4048-4104, L11074` |
| **`vendorData`** | Index: `playerIndex` | `loadRange` (limit 200) | Player item vending machines: `key`, `player`, `area` (default 56), `x`, `y`, `rot`, `items`, `costs`, `tickets`, `tPrice` | `GameMain.as:L907, L6732-6766` |
| **`petVendorData`** | Index: `playerIndex` | `loadRange` (limit 100) | Pet adoption cages in Area 98: `key`, `player`, `x`, `y`, `rot`, `pet`, `coins`, `tickets` | `GameMain.as:L918, L6768-6798` |
| **`lotteryTable`** | Indexes: `ticketIndex`, `coinIndex` | `loadRange` (limit 500) | Lottery entries in Area 83: `tickets`, `coins` | `GameMain.as:L910-911, L7004-7036` |
| **`miscTable`** | Keys: `"lotteryWinners"`, `"lotteryInfo"` | `load` | Lottery state: `winners`, `winnings`, `startTime` | `GameMain.as:L912-913, L7038-7069` |
| **`shinyFishData`** | Index: `timeIndex` | `loadRange` (limit 15) | Recent shiny fish sightings for Fish Radar / Fish List: `fish`, `area`, `time`, `catcher` | `GameMain.as:L12965`, `MapMenu.as:L476` |
| **`linkedUsers`** | Key: Portal UID | `load` | Maps ArmorGames / Y8 / MiniPlay user IDs to `username` | `GameMain.as:L14331, L14431, L14492` |
| **`PayVaultItems`** | Index: `costIndex` | `loadRange` (limit 80) | Ticket prices (`PriceCoins`) for all PayVault items | `GameMain.as:L12894, L15457, L4388-4448` |
| **`weaponStats`** | Index: `costIndex` | `loadRange` (limit 300) | Weapon definitions (cached in `dbItems` SharedObject) | `GameMain.as:L1003, L5351-5422` |
| **`helmetStats`** | Index: `costIndex` | `loadRange` (limit 300) | Helmet definitions (cached in `dbItems`) | `GameMain.as:L1011, L5424-5483` |
| **`shirtStats`** | Index: `costIndex` | `loadRange` (limit 300) | Shirt/armor definitions (cached in `dbItems`) | `GameMain.as:L1019, L5485-5540` |
| **`legStats`** | Index: `costIndex` | `loadRange` (limit 300) | Pants/legs definitions (cached in `dbItems`) | `GameMain.as:L1027, L5542-5597` |
| **`shoeStats`** | Index: `costIndex` | `loadRange` (limit 300) | Shoe definitions (cached in `dbItems`) | `GameMain.as:L1035, L5599-5648` |
| **`accStats`** | Index: `costIndex` | `loadRange` (limit 20) | Accessory definitions (cached in `dbItems`) | `GameMain.as:L1043, L5650-5683` |
| **`itemData`** | Index: `costIndex` | `loadRange` (limit 300) | Consumables, seeds, logs, wood, ores, spawn balls (cached in `dbItems`) | `GameMain.as:L1051, L5685-5724` |
| **`petHelmets`** | Index: `costIndex` | `loadRange` (limit 300) | Pet helmet definitions (cached in `dbItems`) | `GameMain.as:L1059, L5726-5771` |
| **`itemDescs`** | Index: `descIndex` | `loadRange` (limit 700) | Item descriptions (cached in `dbItems`) | `GameMain.as:L1067, L6696-6730` |
| **`fishTable`** | Index: `timeIndex` | `loadRange` (limit 100) | Fish stats (`t` cost, `r` rarity, buffs; cached in `dbItems.fishStats`) | `GameMain.as:L1075, L7071-7100` |
| **`basePetData`** | Index: `costIndex` | `loadRange` (limit 300) | Base pet species stats (`c`, `h`, `pow`, `dx`, `def`, `m`, `d`, `col`) | `GameMain.as:L1081, L6150-6179` |
| **`enemyStats`** | Index: `worthIndex` | `loadRange` (limit 50) | Enemy stats (`h`, `d`, `s`, `w`, `p`, `jump`; cached in `dbItems`) | `GameMain.as:L1084, L5081-5114` |

---

## 2. Complete Class & Package Map of `MyGame.swf`

### 2.1 Package Summary (1,016 Scripts across 81 Packages)

| Package | Files | Total Lines | Total Bytes | Category | Summary of Contents |
|---|---:|---:|---:|---|---|
| `(root)` | 203 | 19,978 | 821,928 | Game Code / Assets | `AcidAreaTiles`, `AcidForegroundTiles`, `AcidHouseForegroundTiles`, `AcidHouseTiles`, ... (+199) |
| `MyGame_fla` | 10 | 229 | 4,389 | Game Code / Assets | `Jimgraffitimain_12`, `butterflywings_356`, `containermain_10`, `evilwings_354`, ... (+6) |
| `area_fla` | 1 | 22 | 416 | Game Code / Assets | `mushroombouncer_27` |
| `com/AI` | 9 | 449 | 12,951 | Game Code / Assets | `BionicBirdAI`, `BouncingMushroomAI`, `EnemyAI`, `GreenBouncerAI`, ... (+5) |
| `com/adobe/crypto` | 1 | 190 | 10,593 | Game Code / Assets | `MD5` |
| `com/adobe/utils` | 2 | 940 | 33,937 | Game Code / Assets | `AGALMiniAssembler`, `IntUtil` |
| `com/apis` | 10 | 906 | 29,702 | Game Code / Assets | `ArmorGames`, `Facebook`, `GooglePlay`, `IDI`, ... (+6) |
| `com/apis/Facebook_API` | 4 | 906 | 27,097 | Game Code / Assets | `FB`, `FBData`, `FBQuery`, `FBWaitable` |
| `com/game_objects` | 39 | 5,938 | 210,728 | Game Code / Assets | `ATM`, `BeholderCannon`, `BouncePad`, `BulletShell`, ... (+35) |
| `com/game_objects/ambient_objects` | 1 | 16 | 291 | Game Code / Assets | `Portal` |
| `com/game_objects/enemies` | 47 | 1,381 | 36,659 | Game Code / Assets | `Aipster`, `Beholder`, `BionicBird`, `BlockBot`, ... (+43) |
| `com/game_objects/extensions` | 6 | 4,755 | 571,972 | Game Code / Assets | `BodyAnimator`, `EnergyController`, `MoveHandler`, `PersonFrameHandler`, ... (+2) |
| `com/game_objects/hit_detect` | 3 | 383 | 14,209 | Game Code / Assets | `HitTester`, `HitType`, `IHitObject` |
| `com/game_objects/power_up_effects` | 6 | 902 | 34,457 | Game Code / Assets | `Aura`, `AuraBall`, `Electrify`, `PowerUpVisuals`, ... (+2) |
| `com/gravityPackage` | 3 | 542 | 20,445 | Game Code / Assets | `GravityObject`, `IGravityObject`, `WindSource` |
| `com/greensock` | 2 | 1,912 | 62,159 | Game Code / Assets | `TweenLite`, `TweenMax` |
| `com/greensock/core` | 3 | 668 | 19,773 | Game Code / Assets | `Animation`, `PropTween`, `SimpleTimeline` |
| `com/greensock/easing` | 14 | 399 | 9,219 | Game Code / Assets | `Back`, `BackIn`, `BackInOut`, `BackOut`, ... (+10) |
| `com/greensock/events` | 1 | 32 | 819 | Game Code / Assets | `TweenEvent` |
| `com/greensock/plugins` | 21 | 2,154 | 69,391 | Game Code / Assets | `AutoAlphaPlugin`, `BevelFilterPlugin`, `BezierPlugin`, `BezierThroughPlugin`, ... (+17) |
| `com/helpers` | 15 | 2,362 | 84,664 | Game Code / Assets | `AntiAutoClicker`, `AreaCreator`, `KeyState`, `KeyStates`, ... (+11) |
| `com/lighting` | 2 | 166 | 5,506 | Game Code / Assets | `Lighting`, `Shadows` |
| `com/math` | 6 | 180 | 4,893 | Game Code / Assets | `CalcDist`, `LineIntersection`, `MoveInCircle`, `MoveTo`, ... (+2) |
| `com/menus` | 39 | 15,254 | 662,755 | Game Code / Assets | `AlertMenu`, `BankMenu`, `BlockBuildMenu`, `BullhornMenu`, ... (+35) |
| `com/menus/add_ons` | 6 | 215 | 5,761 | Game Code / Assets | `Cursor`, `EnergyBar`, `IClickable`, `MapMarker`, ... (+2) |
| `com/newgrounds` | 16 | 3,989 | 121,091 | Game Code / Assets | `API`, `APICommand`, `APIConnection`, `APIEvent`, ... (+12) |
| `com/newgrounds/assets` | 1 | 16 | 361 | Game Code / Assets | `DefaultMedalIcon` |
| `com/newgrounds/components` | 1 | 164 | 4,709 | Game Code / Assets | `MedalPopup` |
| `com/newgrounds/crypto` | 2 | 367 | 15,945 | Game Code / Assets | `MD5`, `RC4` |
| `com/newgrounds/encoders` | 2 | 191 | 5,441 | Game Code / Assets | `BaseN`, `PNGEncoder` |
| `com/newgrounds/encoders/json` | 3 | 599 | 16,423 | Game Code / Assets | `NGJSON`, `decodeJson`, `encodeJson` |
| `com/protobuf` | 6 | 1,190 | 35,602 | Game Code / Assets | `CodedInputStream`, `CodedOutputStream`, `Descriptor`, `InvalidProtocolBufferException`, ... (+2) |
| `com/sound` | 3 | 578 | 16,696 | Game Code / Assets | `LoopedSound`, `SoundLibrary`, `SoundManager` |
| `com/stats` | 6 | 1,326 | 80,537 | Game Code / Assets | `CastleBlockStat`, `ItemStat`, `MoveStat`, `Moves`, ... (+2) |
| `com/ui` | 5 | 1,616 | 69,899 | Game Code / Assets | `AllTextFormats`, `Controls`, `FakeCursor`, `GiveHealthBar`, ... (+1) |
| `com/utilities` | 27 | 2,399 | 112,111 | Game Code / Assets | `AssetManagerExtended`, `AssetManagerFileChecker`, `Assets`, `Assets_ChalkFont_PNG`, ... (+23) |
| `com/utilities/treefortress/textureutils` | 2 | 315 | 11,792 | Game Code / Assets | `AtlasBuilder`, `MaxRectPacker` |
| `com/visual_effects` | 11 | 831 | 26,547 | Game Code / Assets | `AfterImage`, `CircleCreator`, `DrawToBitmap`, `FlashShock`, ... (+7) |
| `fairyareawhole_fla` | 1 | 22 | 412 | Game Code / Assets | `bouncepad_2` |
| `feathers/controls` | 6 | 3,752 | 124,667 | Game Code / Assets | `AutoSizeMode`, `Callout`, `LayoutGroup`, `TextCallout`, ... (+2) |
| `feathers/controls/supportClasses` | 2 | 414 | 12,544 | Game Code / Assets | `IViewPort`, `LayoutViewPort` |
| `feathers/controls/text` | 2 | 2,209 | 74,095 | Game Code / Assets | `BitmapFontTextRenderer`, `StageTextTextEditor` |
| `feathers/core` | 27 | 3,356 | 101,627 | Game Code / Assets | `DefaultFocusManager`, `DefaultPopUpManager`, `FeathersControl`, `FocusManager`, ... (+23) |
| `feathers/events` | 1 | 69 | 2,303 | Game Code / Assets | `FeathersEventType` |
| `feathers/layout` | 8 | 179 | 4,214 | Game Code / Assets | `ILayout`, `ILayoutData`, `ILayoutDisplayObject`, `IVirtualLayout`, ... (+4) |
| `feathers/skins` | 1 | 12 | 197 | Game Code / Assets | `IStyleProvider` |
| `feathers/text` | 2 | 439 | 12,676 | Game Code / Assets | `BitmapFontTextFormat`, `StageTextField` |
| `feathers/utils/display` | 2 | 41 | 776 | Game Code / Assets | `getDisplayObjectDepthFromStage`, `stageToStarling` |
| `feathers/utils/geom` | 2 | 26 | 554 | Game Code / Assets | `matrixToScaleX`, `matrixToScaleY` |
| `fl/containers` | 1 | 429 | 15,203 | Game Code / Assets | `BaseScrollPane` |
| `fl/controls` | 13 | 4,638 | 147,739 | Game Code / Assets | `BaseButton`, `Button`, `ButtonLabelPlacement`, `ColorPicker`, ... (+9) |
| `fl/controls/listClasses` | 3 | 203 | 5,185 | Game Code / Assets | `CellRenderer`, `ICellRenderer`, `ListData` |
| `fl/core` | 3 | 743 | 20,848 | Game Code / Assets | `ComponentShim`, `InvalidationType`, `UIComponent` |
| `fl/data` | 2 | 310 | 10,144 | Game Code / Assets | `DataProvider`, `SimpleCollectionItem` |
| `fl/events` | 6 | 286 | 7,215 | Game Code / Assets | `ColorPickerEvent`, `ComponentEvent`, `DataChangeEvent`, `DataChangeType`, ... (+2) |
| `fl/managers` | 5 | 1,115 | 36,175 | Game Code / Assets | `FocusManager`, `IFocusManager`, `IFocusManagerComponent`, `IFocusManagerGroup`, ... (+1) |
| `fl/motion` | 4 | 714 | 21,702 | Game Code / Assets | `AdjustColor`, `Color`, `ColorMatrix`, `DynamicMatrix` |
| `fl/transitions` | 2 | 340 | 8,929 | Game Code / Assets | `Tween`, `TweenEvent` |
| `fl/transitions/easing` | 1 | 33 | 1,031 | Game Code / Assets | `Strong` |
| `mx/core` | 15 | 1,065 | 29,031 | Game Code / Assets | `BitmapAsset`, `ByteArrayAsset`, `FlexBitmap`, `IAssetLayoutFeatures`, ... (+11) |
| `mx/managers` | 1 | 67 | 1,900 | Game Code / Assets | `ISystemManager` |
| `mx/utils` | 4 | 506 | 14,548 | Game Code / Assets | `IXMLNotifiable`, `NameUtil`, `UIDUtil`, `XMLNotifier` |
| `playerio` | 37 | 4,649 | 156,284 | PlayerIO SDK | `Achievement`, `Achievements`, `BigDB`, `Client`, ... (+33) |
| `playerio/generated` | 16 | 2,557 | 96,992 | PlayerIO SDK | `Achievements`, `BigDB`, `ErrorLog`, `GameRequests`, ... (+12) |
| `playerio/generated/messages` | 202 | 4,830 | 113,357 | PlayerIO SDK | `Achievement`, `AchievementsLoadArgs`, `AchievementsLoadError`, `AchievementsLoadOutput`, ... (+198) |
| `playerio/helpers` | 1 | 18 | 275 | PlayerIO SDK | `FieldToBeRemoved` |
| `playerio/utils` | 5 | 1,558 | 47,798 | PlayerIO SDK | `BinarySerializer`, `Converter`, `HTTPChannel`, `SWFReader`, ... (+1) |
| `starling` | 1 | 3,111 | 169,131 | Game Code / Assets | `MainStarlingStage` |
| `starling/animation` | 5 | 1,262 | 37,220 | Game Code / Assets | `DelayedCall`, `IAnimatable`, `Juggler`, `Transitions`, ... (+1) |
| `starling/core` | 3 | 1,099 | 36,330 | Game Code / Assets | `Starling`, `StatsDisplay`, `starling_internal` |
| `starling/display` | 14 | 4,450 | 135,623 | Game Code / Assets | `BlendMode`, `Button`, `ButtonState`, `Canvas`, ... (+10) |
| `starling/errors` | 4 | 52 | 1,000 | Game Code / Assets | `AbstractClassError`, `AbstractMethodError`, `MissingContextError`, `NotSupportedError` |
| `starling/events` | 10 | 1,544 | 45,032 | Game Code / Assets | `EnterFrameEvent`, `Event`, `EventDispatcher`, `KeyboardEvent`, ... (+6) |
| `starling/extensions/lighting` | 4 | 968 | 31,881 | Game Code / Assets | `LightEffect`, `LightSource`, `LightSource_LightBulbAtlas`, `LightStyle` |
| `starling/filters` | 9 | 2,177 | 66,396 | Game Code / Assets | `BlurFilter`, `ColorMatrixFilter`, `CompositeFilter`, `DisplacementMapFilter`, ... (+5) |
| `starling/geom` | 1 | 608 | 19,214 | Game Code / Assets | `Polygon` |
| `starling/rendering` | 13 | 3,887 | 122,396 | Game Code / Assets | `BatchProcessor`, `BatchToken`, `Effect`, `FilterEffect`, ... (+9) |
| `starling/styles` | 1 | 323 | 9,777 | Game Code / Assets | `MeshStyle` |
| `starling/text` | 9 | 1,996 | 76,821 | Game Code / Assets | `BitmapChar`, `BitmapFont`, `ITextCompositor`, `MiniBitmapFont`, ... (+5) |
| `starling/textures` | 11 | 1,775 | 56,054 | Game Code / Assets | `AtfData`, `ConcretePotTexture`, `ConcreteRectangleTexture`, `ConcreteTexture`, ... (+7) |
| `starling/utils` | 17 | 2,950 | 94,773 | Game Code / Assets | `Align`, `AssetManager`, `Color`, `MathUtil`, ... (+13) |

### 2.2 `GameMain` Timeline & Frame Architecture (`GameMain.as` & `c_mc`)
- **`GameMain.as`** (`15,461 lines`, `677,090 bytes`) is the root `flash.display.MovieClip` of `MyGame.swf`.
  - **Frame 1 (`frame1()`, `L806-848`)**: Initial preloader & Starling bootstrap (`new Starling(MainStarlingStage, stage)`), `SharedObject.getLocal("helmetSave")` & `SharedObject.getLocal("dbItems")`, `onFirstAdded` (`L9741`), `onStarlingRootCreated` (`L10025`), `onPreLoadEnter` (`L10472`).
  - **Frame 2 (`frame2()`, `L850-855`)**: Main game state (`gotoAndStop(2)` at `L10493`). Calls `setMisc()` (`L8915`), initializes `player = createPerson(...)`, `TileHandler.init(starlingStage)`, and opens `MainMenu` (`createMMenu()`).
  - **`this.c_mc` (Native Flash World Container)** & **`this.starlingStage.c_mc` (Starling GPU World Container)**:
    - Both move in lockstep via `focusLevel()` (`L13726`).
    - `this.c_mc` has **145 level frames** (`1..145`, plus `"blank level"`). Calling `this.c_mc.gotoAndStop(_lev)` switches the native Flash level container to the area's frame (which holds area-specific interactive MovieClips like slot machines in Area 33, graffiti in Areas 18/64, alarms in Area 30, signs in Area 37), while tiles, backgrounds, characters, pets, enemies, trees, fish, and UI render on the Starling GPU stage (`starlingStage.c_mc`).

### 2.3 Complete Inventory of All Custom Game & PlayerIO Classes (726 Files)
Below is every non-library `.as` file in `MyGame.swf` grouped by package, with exact file path, line count, size in bytes, superclass, interfaces, and architectural role.

#### Package `(root)` (203 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `AcidAreaTiles.as` | `AcidAreaTiles` | `MovieClip` | 16 | 274 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `AcidForegroundTiles.as` | `AcidForegroundTiles` | `MovieClip` | 16 | 286 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `AcidHouseForegroundTiles.as` | `AcidHouseForegroundTiles` | `MovieClip` | 16 | 296 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `AcidHouseTiles.as` | `AcidHouseTiles` | `MovieClip` | 16 | 276 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `AipsterVector.as` | `AipsterVector` | `MovieClip` | 16 | 274 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `AquaForegroundTiles.as` | `AquaForegroundTiles` | `MovieClip` | 16 | 286 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `AquaHouseForegroundTiles.as` | `AquaHouseForegroundTiles` | `MovieClip` | 16 | 296 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `AquaHouseTiles.as` | `AquaHouseTiles` | `MovieClip` | 16 | 276 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `Arrow.as` | `Arrow` | `MovieClip` | 16 | 258 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `BarnForegroundTiles.as` | `BarnForegroundTiles` | `MovieClip` | 16 | 286 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `BarnTiles.as` | `BarnTiles` | `MovieClip` | 16 | 266 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `BeachAreaTiles.as` | `BeachAreaTiles` | `MovieClip` | 19 | 369 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `BeachForegroundTiles.as` | `BeachForegroundTiles` | `MovieClip` | 16 | 288 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `BeholderAreaTiles.as` | `BeholderAreaTiles` | `MovieClip` | 18 | 328 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `BeholderForegroundTiles.as` | `BeholderForegroundTiles` | `MovieClip` | 16 | 294 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `BeholderHouseForegroundTiles.as` | `BeholderHouseForegroundTiles` | `MovieClip` | 16 | 304 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `BeholderHouseTiles.as` | `BeholderHouseTiles` | `MovieClip` | 16 | 284 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `BeholderVector.as` | `BeholderVector` | `MovieClip` | 16 | 276 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `BionicBirdVector.as` | `BionicBirdVector` | `MovieClip` | 16 | 280 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `Block10Data.as` | `Block10Data` | `BitmapData` | 16 | 305 | 165x165 pixel collision mask BitmapData for tile hit testing |
| `Block11Data.as` | `Block11Data` | `BitmapData` | 16 | 306 | 165x165 pixel collision mask BitmapData for tile hit testing |
| `Block12Data.as` | `Block12Data` | `BitmapData` | 16 | 306 | 165x165 pixel collision mask BitmapData for tile hit testing |
| `Block17Data.as` | `Block17Data` | `BitmapData` | 16 | 304 | 165x165 pixel collision mask BitmapData for tile hit testing |
| `Block18Data.as` | `Block18Data` | `BitmapData` | 16 | 304 | 165x165 pixel collision mask BitmapData for tile hit testing |
| `Block2Data.as` | `Block2Data` | `BitmapData` | 16 | 303 | 165x165 pixel collision mask BitmapData for tile hit testing |
| `Block6Data.as` | `Block6Data` | `BitmapData` | 16 | 303 | 165x165 pixel collision mask BitmapData for tile hit testing |
| `Block7Data.as` | `Block7Data` | `BitmapData` | 16 | 302 | 165x165 pixel collision mask BitmapData for tile hit testing |
| `Block8Data.as` | `Block8Data` | `BitmapData` | 16 | 303 | 165x165 pixel collision mask BitmapData for tile hit testing |
| `Block9Data.as` | `Block9Data` | `BitmapData` | 16 | 303 | 165x165 pixel collision mask BitmapData for tile hit testing |
| `BlockBotVector.as` | `BlockBotVector` | `MovieClip` | 16 | 276 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `BlueMushroomAreaTiles.as` | `BlueMushroomAreaTiles` | `MovieClip` | 19 | 378 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `BlueMushroomForegroundTiles.as` | `BlueMushroomForegroundTiles` | `MovieClip` | 16 | 302 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `BouncingMushroomVector.as` | `BouncingMushroomVector` | `MovieClip` | 16 | 292 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `BrickMonsterVector.as` | `BrickMonsterVector` | `MovieClip` | 16 | 284 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `BullopedeVector.as` | `BullopedeVector` | `MovieClip` | 16 | 278 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `BuyHairButton.as` | `BuyHairButton` | `SimpleButton` | 15 | 217 | SimpleButton subclass for hair purchase buttons in PayVaultMenu |
| `CarneliaVector.as` | `CarneliaVector` | `MovieClip` | 16 | 276 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `CellRenderer_disabledSkin.as` | `CellRenderer_disabledSkin` | `MovieClip` | 16 | 298 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `CellRenderer_downSkin.as` | `CellRenderer_downSkin` | `MovieClip` | 16 | 290 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `CellRenderer_overSkin.as` | `CellRenderer_overSkin` | `MovieClip` | 16 | 290 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `CellRenderer_selectedDisabledSkin.as` | `CellRenderer_selectedDisabledSkin` | `MovieClip` | 16 | 314 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `CellRenderer_selectedDownSkin.as` | `CellRenderer_selectedDownSkin` | `MovieClip` | 16 | 306 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `CellRenderer_selectedOverSkin.as` | `CellRenderer_selectedOverSkin` | `MovieClip` | 16 | 306 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `CellRenderer_selectedUpSkin.as` | `CellRenderer_selectedUpSkin` | `MovieClip` | 16 | 302 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `CellRenderer_upSkin.as` | `CellRenderer_upSkin` | `MovieClip` | 16 | 286 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ChirpletVector.as` | `ChirpletVector` | `MovieClip` | 16 | 276 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `ClientRoot.as` | `ClientRoot` | `Sprite` | 15 | 191 | Unused/minimal Flash MovieClip wrapper |
| `CloudAreaTiles.as` | `CloudAreaTiles` | `MovieClip` | 16 | 276 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `CloudForegroundTiles.as` | `CloudForegroundTiles` | `MovieClip` | 16 | 288 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `CloudHouseForegroundTiles.as` | `CloudHouseForegroundTiles` | `MovieClip` | 16 | 298 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `CloudHouseTiles.as` | `CloudHouseTiles` | `MovieClip` | 16 | 278 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `Coin3xIcon.as` | `Coin3xIcon` | `MovieClip` | 16 | 268 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ColorPicker_backgroundSkin.as` | `ColorPicker_backgroundSkin` | `MovieClip` | 16 | 300 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ColorPicker_colorWell.as` | `ColorPicker_colorWell` | `MovieClip` | 16 | 290 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ColorPicker_disabledSkin.as` | `ColorPicker_disabledSkin` | `MovieClip` | 16 | 296 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ColorPicker_downSkin.as` | `ColorPicker_downSkin` | `MovieClip` | 16 | 288 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ColorPicker_overSkin.as` | `ColorPicker_overSkin` | `MovieClip` | 16 | 288 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ColorPicker_swatchSelectedSkin.as` | `ColorPicker_swatchSelectedSkin` | `MovieClip` | 16 | 308 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ColorPicker_swatchSkin.as` | `ColorPicker_swatchSkin` | `Sprite` | 16 | 286 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ColorPicker_textFieldSkin.as` | `ColorPicker_textFieldSkin` | `MovieClip` | 16 | 298 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ColorPicker_upSkin.as` | `ColorPicker_upSkin` | `MovieClip` | 16 | 284 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ComboBox_disabledSkin.as` | `ComboBox_disabledSkin` | `MovieClip` | 16 | 290 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ComboBox_downSkin.as` | `ComboBox_downSkin` | `MovieClip` | 16 | 282 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ComboBox_overSkin.as` | `ComboBox_overSkin` | `MovieClip` | 16 | 282 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ComboBox_upSkin.as` | `ComboBox_upSkin` | `MovieClip` | 16 | 278 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ConnectMenu.as` | `ConnectMenu` | `MovieClip` | 19 | 351 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `CrabVector.as` | `CrabVector` | `MovieClip` | 16 | 268 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `CutsceneBoarder.as` | `CutsceneBoarder` | `MovieClip` | 16 | 278 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `DarknessBall.as` | `DarknessBall` | `MovieClip` | 16 | 272 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `DeadMenu.as` | `DeadMenu` | `MovieClip` | 22 | 434 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `DebugMenu.as` | `DebugMenu` | `MovieClip` | 30 | 615 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `DrillBotVector.as` | `DrillBotVector` | `MovieClip` | 18 | 323 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `DungeonAreaTiles.as` | `DungeonAreaTiles` | `MovieClip` | 16 | 280 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `DungeonForegroundTiles.as` | `DungeonForegroundTiles` | `MovieClip` | 16 | 292 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `EnemyInfoItem.as` | `EnemyInfoItem` | `MovieClip` | 27 | 523 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `EnvironmentProjectile.as` | `EnvironmentProjectile` | `DamageObject` | 16 | 299 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ExplosionVector.as` | `ExplosionVector` | `MovieClip` | 16 | 277 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `FairyAreaTiles.as` | `FairyAreaTiles` | `MovieClip` | 16 | 276 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `FairyForegroundTiles.as` | `FairyForegroundTiles` | `MovieClip` | 16 | 288 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `FairyHouseForegroundTiles.as` | `FairyHouseForegroundTiles` | `MovieClip` | 16 | 298 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `FairyHouseTiles.as` | `FairyHouseTiles` | `MovieClip` | 16 | 278 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `FemaleHead1.as` | `FemaleHead1` | `BitmapData` | 16 | 303 | Embedded head icon BitmapData for character skin tones |
| `FemaleHead2.as` | `FemaleHead2` | `BitmapData` | 16 | 303 | Embedded head icon BitmapData for character skin tones |
| `FemaleHead3.as` | `FemaleHead3` | `BitmapData` | 16 | 303 | Embedded head icon BitmapData for character skin tones |
| `FemaleHead4.as` | `FemaleHead4` | `BitmapData` | 16 | 303 | Embedded head icon BitmapData for character skin tones |
| `FishurnVector.as` | `FishurnVector` | `MovieClip` | 16 | 274 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `FlocklingVector.as` | `FlocklingVector` | `MovieClip` | 16 | 278 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `FlyAnimation.as` | `FlyAnimation` | `MovieClip` | 16 | 272 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ForestAreaTiles.as` | `ForestAreaTiles` | `MovieClip` | 16 | 278 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `ForestForegroundTiles.as` | `ForestForegroundTiles` | `MovieClip` | 16 | 290 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `GameInputControlName.as` | `GameInputControlName` | `-` | 700 | 25860 | Gamepad control ID-to-human-readable name mapper |
| `GameMain.as` | `GameMain` | `flash.display.MovieClip` | 15462 | 722199 | Master game controller, network router, level manager, input handler, and frame loop (`onEnter`) |
| `GameMasterIcon.as` | `GameMasterIcon` | `MovieClip` | 16 | 276 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `GiantGooCubeVector.as` | `GiantGooCubeVector` | `MovieClip` | 16 | 284 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `GlordVector.as` | `GlordVector` | `MovieClip` | 16 | 270 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `GooCubeVector.as` | `GooCubeVector` | `MovieClip` | 16 | 274 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `GreatFrogVector.as` | `GreatFrogVector` | `MovieClip` | 16 | 278 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `GreenAreaForegroundTiles.as` | `GreenAreaForegroundTiles` | `MovieClip` | 16 | 296 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `GreenAreaTiles.as` | `GreenAreaTiles` | `MovieClip` | 19 | 369 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `GreenBouncerVector.as` | `GreenBouncerVector` | `MovieClip` | 16 | 284 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `GreenWalkerVector.as` | `GreenWalkerVector` | `MovieClip` | 16 | 282 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `GuildListItem.as` | `GuildListItem` | `MovieClip` | 27 | 531 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `Halo.as` | `Halo` | `MovieClip` | 16 | 255 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `HauntedForegroundTiles.as` | `HauntedForegroundTiles` | `MovieClip` | 16 | 292 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `HauntedTiles.as` | `HauntedTiles` | `MovieClip` | 16 | 272 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `HeroEntry.as` | `HeroEntry` | `MovieClip` | 19 | 346 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `HornedMonsterVector.as` | `HornedMonsterVector` | `MovieClip` | 16 | 286 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `HouseForegroundTiles.as` | `HouseForegroundTiles` | `MovieClip` | 16 | 288 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `HouseTiles.as` | `HouseTiles` | `MovieClip` | 16 | 268 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `InfoMenu.as` | `InfoMenu` | `MovieClip` | 25 | 466 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `InteractBubble.as` | `InteractBubble` | `MovieClip` | 22 | 417 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `JungleForegroundTiles.as` | `JungleForegroundTiles` | `MovieClip` | 16 | 290 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `JungleTiles.as` | `JungleTiles` | `MovieClip` | 16 | 270 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `KrakenVector.as` | `KrakenVector` | `MovieClip` | 16 | 272 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `KrawVector.as` | `KrawVector` | `MovieClip` | 16 | 268 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `KreetonVector.as` | `KreetonVector` | `MovieClip` | 16 | 274 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `KreetusVector.as` | `KreetusVector` | `MovieClip` | 18 | 319 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `LavaForegroundTiles.as` | `LavaForegroundTiles` | `MovieClip` | 16 | 286 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `LavaTiles.as` | `LavaTiles` | `MovieClip` | 16 | 266 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `LeafletVector.as` | `LeafletVector` | `MovieClip` | 16 | 274 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `LeaflingVector.as` | `LeaflingVector` | `MovieClip` | 16 | 276 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `LightBeamData.as` | `LightBeamData` | `BitmapData` | 16 | 311 | Embedded BitmapData for mage Light Beam skill effect |
| `LightningBolt.as` | `LightningBolt` | `MovieClip` | 16 | 273 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `List_skin.as` | `List_skin` | `MovieClip` | 16 | 266 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `LoadingCircle.as` | `LoadingCircle` | `MovieClip` | 27 | 738 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `LogOnMenu.as` | `LogOnMenu` | `MovieClip` | 19 | 346 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `LotusEyeVector.as` | `LotusEyeVector` | `MovieClip` | 16 | 276 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `MagmagonVector.as` | `MagmagonVector` | `MovieClip` | 16 | 276 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `MaleHead1.as` | `MaleHead1` | `BitmapData` | 16 | 297 | Embedded head icon BitmapData for character skin tones |
| `MaleHead2.as` | `MaleHead2` | `BitmapData` | 16 | 297 | Embedded head icon BitmapData for character skin tones |
| `MaleHead3.as` | `MaleHead3` | `BitmapData` | 16 | 297 | Embedded head icon BitmapData for character skin tones |
| `MaleHead4.as` | `MaleHead4` | `BitmapData` | 16 | 297 | Embedded head icon BitmapData for character skin tones |
| `MembersInAreaMenu.as` | `MembersInAreaMenu` | `MovieClip` | 19 | 364 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `Minilogo.as` | `Minilogo` | `MovieClip` | 167 | 5354 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `MissionCompleteAnimation.as` | `MissionCompleteAnimation` | `MovieClip` | 19 | 378 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `MongrelVector.as` | `MongrelVector` | `MovieClip` | 16 | 274 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `MushroomBallVector.as` | `MushroomBallVector` | `MovieClip` | 16 | 284 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `MushroomBirdVector.as` | `MushroomBirdVector` | `MovieClip` | 16 | 284 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `MushroomHouseForegroundTiles.as` | `MushroomHouseForegroundTiles` | `MovieClip` | 16 | 304 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `MushroomHouseTiles.as` | `MushroomHouseTiles` | `MovieClip` | 16 | 284 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `MushroomSpike.as` | `MushroomSpike` | `DamageObject` | 16 | 283 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `MushroomSquishVector.as` | `MushroomSquishVector` | `MovieClip` | 16 | 288 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `NewMissionAnimation.as` | `NewMissionAnimation` | `MovieClip` | 19 | 368 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `NightstalkerVector.as` | `NightstalkerVector` | `MovieClip` | 16 | 284 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `OceanAreaTiles.as` | `OceanAreaTiles` | `MovieClip` | 19 | 364 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `OmegaFluffVector.as` | `OmegaFluffVector` | `MovieClip` | 16 | 279 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `OrangeCrazyVector.as` | `OrangeCrazyVector` | `MovieClip` | 16 | 282 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `PVPForegroundTiles.as` | `PVPForegroundTiles` | `MovieClip` | 16 | 284 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `PVPTiles.as` | `PVPTiles` | `MovieClip` | 19 | 357 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `Pendulum.as` | `Pendulum` | `DamageObject` | 16 | 273 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `PenguinVector.as` | `PenguinVector` | `MovieClip` | 16 | 274 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `PersonHair.as` | `PersonHair` | `MovieClip` | 22 | 391 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `PetAreaTiles.as` | `PetAreaTiles` | `MovieClip` | 16 | 272 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `PetForegroundTiles.as` | `PetForegroundTiles` | `MovieClip` | 16 | 284 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `PlantMonsterVector.as` | `PlantMonsterVector` | `MovieClip` | 16 | 284 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `PowerUpContainer.as` | `PowerUpContainer` | `MovieClip` | 58 | 1294 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ProteumVector.as` | `ProteumVector` | `MovieClip` | 16 | 274 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `PumpkinCreeperVector.as` | `PumpkinCreeperVector` | `MovieClip` | 16 | 288 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `PurpleGooVector.as` | `PurpleGooVector` | `MovieClip` | 16 | 278 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `RedBouncerVector.as` | `RedBouncerVector` | `MovieClip` | 16 | 280 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `RedMushForegroundTiles.as` | `RedMushForegroundTiles` | `MovieClip` | 16 | 292 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `RedMushroomTiles.as` | `RedMushroomTiles` | `MovieClip` | 16 | 280 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `RepguanaAreaTiles.as` | `RepguanaAreaTiles` | `MovieClip` | 16 | 282 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `RepguanaForegroundTiles.as` | `RepguanaForegroundTiles` | `MovieClip` | 16 | 294 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `RepguanaVector.as` | `RepguanaVector` | `MovieClip` | 16 | 276 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `RoboForegroundTiles.as` | `RoboForegroundTiles` | `MovieClip` | 16 | 286 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `RobotAreaTiles.as` | `RobotAreaTiles` | `MovieClip` | 16 | 276 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `RobotHouseForegroundTiles.as` | `RobotHouseForegroundTiles` | `MovieClip` | 16 | 298 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `RobotHouseTiles.as` | `RobotHouseTiles` | `MovieClip` | 16 | 278 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `SasquatchVector.as` | `SasquatchVector` | `MovieClip` | 16 | 278 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `ScrollArrowDown_disabledSkin.as` | `ScrollArrowDown_disabledSkin` | `MovieClip` | 16 | 303 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ScrollArrowDown_downSkin.as` | `ScrollArrowDown_downSkin` | `MovieClip` | 16 | 295 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ScrollArrowDown_overSkin.as` | `ScrollArrowDown_overSkin` | `MovieClip` | 16 | 295 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ScrollArrowDown_upSkin.as` | `ScrollArrowDown_upSkin` | `MovieClip` | 16 | 291 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ScrollArrowUp_disabledSkin.as` | `ScrollArrowUp_disabledSkin` | `MovieClip` | 16 | 299 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ScrollArrowUp_downSkin.as` | `ScrollArrowUp_downSkin` | `MovieClip` | 16 | 291 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ScrollArrowUp_overSkin.as` | `ScrollArrowUp_overSkin` | `MovieClip` | 16 | 291 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ScrollArrowUp_upSkin.as` | `ScrollArrowUp_upSkin` | `MovieClip` | 16 | 287 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ScrollBar_thumbIcon.as` | `ScrollBar_thumbIcon` | `MovieClip` | 16 | 285 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ScrollThumb_downSkin.as` | `ScrollThumb_downSkin` | `MovieClip` | 16 | 287 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ScrollThumb_overSkin.as` | `ScrollThumb_overSkin` | `MovieClip` | 16 | 287 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ScrollThumb_upSkin.as` | `ScrollThumb_upSkin` | `MovieClip` | 16 | 283 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ScrollTrack_skin.as` | `ScrollTrack_skin` | `MovieClip` | 16 | 279 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `ServerPanel.as` | `ServerPanel` | `MovieClip` | 27 | 534 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `SkipButton.as` | `SkipButton` | `SimpleButton` | 15 | 211 | SimpleButton for skipping cutscenes |
| `SnowAreaTiles.as` | `SnowAreaTiles` | `MovieClip` | 23 | 469 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `SnowForegroundTiles.as` | `SnowForegroundTiles` | `MovieClip` | 16 | 286 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `SplashAnimation.as` | `SplashAnimation` | `MovieClip` | 16 | 276 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `TextAlert.as` | `TextAlert` | `MovieClip` | 19 | 345 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `TextInput_disabledSkin.as` | `TextInput_disabledSkin` | `MovieClip` | 16 | 291 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `TextInput_upSkin.as` | `TextInput_upSkin` | `MovieClip` | 16 | 279 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `TitaniumVultureVector.as` | `TitaniumVultureVector` | `MovieClip` | 16 | 290 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `TowerAreaTiles.as` | `TowerAreaTiles` | `MovieClip` | 16 | 276 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `TradeRequest.as` | `TradeRequest` | `MovieClip` | 24 | 503 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `TreeFishContainer.as` | `TreeFishContainer` | `MovieClip` | 211 | 5231 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `Tutorial.as` | `Tutorial` | `MovieClip` | 25 | 482 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `UpdateMenu.as` | `UpdateMenu` | `MovieClip` | 77 | 2121 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |
| `WindmillAreaTiles.as` | `WindmillAreaTiles` | `MovieClip` | 19 | 375 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `WindmillForegroundTiles.as` | `WindmillForegroundTiles` | `MovieClip` | 16 | 294 | Embedded Flash MovieClip holding vector tile art frames for area theme |
| `YellowExplosionVector.as` | `YellowExplosionVector` | `MovieClip` | 16 | 288 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `YellowHairyMonsterVector.as` | `YellowHairyMonsterVector` | `MovieClip` | 16 | 296 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `YellowPuffMonsterVector.as` | `YellowPuffMonsterVector` | `MovieClip` | 16 | 294 | Embedded Flash MovieClip holding vector enemy/explosion animation frames (rasterized at runtime via `MovieClipToAtlas`) |
| `focusRectSkin.as` | `focusRectSkin` | `MovieClip` | 16 | 273 | Embedded Flash MovieClip / SimpleButton UI or world prop symbol |

#### Package `MyGame_fla` (10 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `MyGame_fla/Jimgraffitimain_12.as` | `Jimgraffitimain_12` | `MovieClip` | 22 | 418 | Class in `MyGame_fla` |
| `MyGame_fla/butterflywings_356.as` | `butterflywings_356` | `MovieClip` | 22 | 418 | Class in `MyGame_fla` |
| `MyGame_fla/containermain_10.as` | `containermain_10` | `MovieClip` | 30 | 609 | Class in `MyGame_fla` |
| `MyGame_fla/evilwings_354.as` | `evilwings_354` | `MovieClip` | 22 | 408 | Class in `MyGame_fla` |
| `MyGame_fla/jetpack_337.as` | `jetpack_337` | `MovieClip` | 22 | 403 | Class in `MyGame_fla` |
| `MyGame_fla/kreetusteethanimation_121.as` | `kreetusteethanimation_121` | `MovieClip` | 22 | 432 | Class in `MyGame_fla` |
| `MyGame_fla/rayoflight_1.as` | `rayoflight_1` | `MovieClip` | 23 | 463 | Class in `MyGame_fla` |
| `MyGame_fla/remembermemovieclip_300.as` | `remembermemovieclip_300` | `MovieClip` | 22 | 428 | Class in `MyGame_fla` |
| `MyGame_fla/servericons_314.as` | `servericons_314` | `MovieClip` | 22 | 411 | Class in `MyGame_fla` |
| `MyGame_fla/wings_338.as` | `wings_338` | `MovieClip` | 22 | 399 | Class in `MyGame_fla` |

#### Package `area_fla` (1 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `area_fla/mushroombouncer_27.as` | `mushroombouncer_27` | `MovieClip` | 22 | 416 | Class in `area_fla` |

#### Package `com/AI` (9 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/AI/BionicBirdAI.as` | `BionicBirdAI` | `EnemyAI` | 46 | 1098 | Class in `com/AI` |
| `com/AI/BouncingMushroomAI.as` | `BouncingMushroomAI` | `EnemyAI` | 20 | 352 | Class in `com/AI` |
| `com/AI/EnemyAI.as` | `EnemyAI` | `-` | 67 | 1784 | Class in `com/AI` |
| `com/AI/GreenBouncerAI.as` | `GreenBouncerAI` | `EnemyAI` | 20 | 344 | Class in `com/AI` |
| `com/AI/MushroomBallAI.as` | `MushroomBallAI` | `EnemyAI` | 26 | 514 | Class in `com/AI` |
| `com/AI/PetAI.as` | `PetAI` | `-` | 184 | 7073 | Class in `com/AI` |
| `com/AI/PurpleGooAI.as` | `PurpleGooAI` | `EnemyAI` | 20 | 338 | Class in `com/AI` |
| `com/AI/RedBouncerAI.as` | `RedBouncerAI` | `EnemyAI` | 20 | 340 | Class in `com/AI` |
| `com/AI/TitaniumVultureAI.as` | `TitaniumVultureAI` | `EnemyAI` | 46 | 1108 | Class in `com/AI` |

#### Package `com/adobe/crypto` (1 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/adobe/crypto/MD5.as` | `MD5` | `-` | 190 | 10593 | Class in `com/adobe/crypto` |

#### Package `com/adobe/utils` (2 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/adobe/utils/AGALMiniAssembler.as` | `AGALMiniAssembler` | `-` | 888 | 32584 | Class in `com/adobe/utils` |
| `com/adobe/utils/IntUtil.as` | `IntUtil` | `-` | 52 | 1353 | Class in `com/adobe/utils` |

#### Package `com/apis` (10 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/apis/ArmorGames.as` | `ArmorGames` | `-` | 117 | 3879 | Class in `com/apis` |
| `com/apis/Facebook.as` | `Facebook` | `-` | 70 | 1753 | Class in `com/apis` |
| `com/apis/GooglePlay.as` | `GooglePlay` | `-` | 130 | 5355 | Class in `com/apis` |
| `com/apis/IDI.as` | `IDI` | `Sprite` | 167 | 5592 | Class in `com/apis` |
| `com/apis/IOS.as` | `IOS` | `-` | 104 | 3748 | Class in `com/apis` |
| `com/apis/Kongregate.as` | `Kongregate` | `-` | 95 | 2907 | Class in `com/apis` |
| `com/apis/MiniPlay.as` | `MiniPlay` | `-` | 77 | 2753 | Class in `com/apis` |
| `com/apis/Newgrounds.as` | `Newgrounds` | `-` | 44 | 1101 | Class in `com/apis` |
| `com/apis/PlayerIOPublishingNetwork.as` | `PlayerIOPublishingNetwork` | `-` | 53 | 1421 | Class in `com/apis` |
| `com/apis/Steam.as` | `Steam` | `-` | 49 | 1193 | Class in `com/apis` |

#### Package `com/apis/Facebook_API` (4 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/apis/Facebook_API/FB.as` | `FB` | `-` | 464 | 15003 | Class in `com/apis/Facebook_API` |
| `com/apis/Facebook_API/FBData.as` | `FBData` | `-` | 177 | 5096 | Class in `com/apis/Facebook_API` |
| `com/apis/Facebook_API/FBQuery.as` | `FBQuery` | `FBWaitable` | 126 | 3509 | Class in `com/apis/Facebook_API` |
| `com/apis/Facebook_API/FBWaitable.as` | `FBWaitable` | `-` | 139 | 3489 | Class in `com/apis/Facebook_API` |

#### Package `com/game_objects` (39 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/game_objects/ATM.as` | `ATM` | `Sprite` | 54 | 1856 | Class in `com/game_objects` |
| `com/game_objects/BeholderCannon.as` | `BeholderCannon` | `ShootingObject` | 20 | 372 | Class in `com/game_objects` |
| `com/game_objects/BouncePad.as` | `BouncePad` | `MovieClip` | 76 | 2515 | Class in `com/game_objects` |
| `com/game_objects/BulletShell.as` | `BulletShell` | `Image` | 59 | 1858 | Class in `com/game_objects` |
| `com/game_objects/BushShooter.as` | `BushShooter` | `ShootingObject` | 20 | 366 | Class in `com/game_objects` |
| `com/game_objects/Cloud.as` | `Cloud` | `MovieClip` | 25 | 557 | Class in `com/game_objects` |
| `com/game_objects/CoinBox.as` | `CoinBox` | `Image` (impl: I, H, i, t, O, b, j, e, c, t) | 100 | 3275 | Class in `com/game_objects` |
| `com/game_objects/DamageObject.as` | `DamageObject` | `MovieClip` | 101 | 3270 | Class in `com/game_objects` |
| `com/game_objects/EnergyOrb.as` | `EnergyOrb` | `Image` | 55 | 1723 | Class in `com/game_objects` |
| `com/game_objects/Explosion.as` | `Explosion` | `MovieClip` | 96 | 3651 | Class in `com/game_objects` |
| `com/game_objects/Fire.as` | `Fire` | `MovieClip` | 51 | 1528 | Class in `com/game_objects` |
| `com/game_objects/Fish.as` | `Fish` | `Sprite` (impl: I, H, i, t, O, b, j, e, c, t) | 278 | 9407 | Class in `com/game_objects` |
| `com/game_objects/FishingLine.as` | `FishingLine` | `starling.display.Sprite` | 172 | 5479 | Class in `com/game_objects` |
| `com/game_objects/FlyCluster.as` | `FlyCluster` | `Sprite` | 75 | 2733 | Class in `com/game_objects` |
| `com/game_objects/FrozenCube.as` | `FrozenCube` | `Image` | 116 | 4419 | Class in `com/game_objects` |
| `com/game_objects/GuardSymbol.as` | `GuardSymbol` | `Sprite` | 94 | 3278 | Class in `com/game_objects` |
| `com/game_objects/HealingCircle.as` | `HealingCircle` | `Shape` | 46 | 1298 | Class in `com/game_objects` |
| `com/game_objects/Item.as` | `Item` | `Sprite` | 214 | 7833 | Class in `com/game_objects` |
| `com/game_objects/Leaf.as` | `Leaf` | `Image` | 98 | 3597 | Class in `com/game_objects` |
| `com/game_objects/LightPillar.as` | `LightPillar` | `Shape` | 43 | 1351 | Class in `com/game_objects` |
| `com/game_objects/MagicEffect.as` | `MagicEffect` | `Sprite` | 62 | 1887 | Class in `com/game_objects` |
| `com/game_objects/Particle.as` | `Particle` | `Image` | 61 | 2080 | Class in `com/game_objects` |
| `com/game_objects/Person.as` | `Person` | `Sprite` (impl: I, C, l, i, c, k, a, b, l, e, ,,  , I, G, r, a, v, i, t, y, O, b, j, e, c, t) | 1349 | 51091 | Class in `com/game_objects` |
| `com/game_objects/Pet.as` | `Pet` | `Sprite` (impl: I, C, l, i, c, k, a, b, l, e) | 1106 | 41211 | Class in `com/game_objects` |
| `com/game_objects/PetOrb.as` | `PetOrb` | `Image` | 118 | 3856 | Class in `com/game_objects` |
| `com/game_objects/PetVendor.as` | `PetVendor` | `Sprite` | 140 | 4479 | Class in `com/game_objects` |
| `com/game_objects/PipeController.as` | `PipeController` | `-` | 163 | 6616 | Class in `com/game_objects` |
| `com/game_objects/Projectile.as` | `Projectile` | `Image` | 172 | 7362 | Class in `com/game_objects` |
| `com/game_objects/RobotAlarmBuilding.as` | `RobotAlarmBuilding` | `MovieClip` | 16 | 301 | Class in `com/game_objects` |
| `com/game_objects/ShootingObject.as` | `ShootingObject` | `MovieClip` | 32 | 651 | Class in `com/game_objects` |
| `com/game_objects/Smoke.as` | `Smoke` | `Image` | 46 | 1161 | Class in `com/game_objects` |
| `com/game_objects/SplatParticle.as` | `SplatParticle` | `Image` | 77 | 2703 | Class in `com/game_objects` |
| `com/game_objects/Splatter.as` | `Splatter` | `-` | 124 | 4631 | Class in `com/game_objects` |
| `com/game_objects/StandSwitch.as` | `StandSwitch` | `MovieClip` | 22 | 410 | Class in `com/game_objects` |
| `com/game_objects/TalkBubble.as` | `TalkBubble` | `Image` | 97 | 3339 | Class in `com/game_objects` |
| `com/game_objects/Tree.as` | `Tree` | `Image` (impl: I, H, i, t, O, b, j, e, c, t) | 307 | 11053 | Class in `com/game_objects` |
| `com/game_objects/VendingMachine.as` | `VendingMachine` | `Sprite` | 161 | 4969 | Class in `com/game_objects` |
| `com/game_objects/WaterBubble.as` | `WaterBubble` | `Image` | 67 | 1946 | Class in `com/game_objects` |
| `com/game_objects/YellowExplosion.as` | `YellowExplosion` | `MovieClip` | 25 | 616 | Class in `com/game_objects` |

#### Package `com/game_objects/ambient_objects` (1 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/game_objects/ambient_objects/Portal.as` | `Portal` | `MovieClip` | 16 | 291 | Class in `com/game_objects/ambient_objects` |

#### Package `com/game_objects/enemies` (47 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/game_objects/enemies/Aipster.as` | `Aipster` | `Enemy` | 16 | 268 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/Beholder.as` | `Beholder` | `Enemy` | 15 | 251 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/BionicBird.as` | `BionicBird` | `Enemy` | 20 | 447 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/BlockBot.as` | `BlockBot` | `Enemy` | 16 | 271 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/BouncingMushroom.as` | `BouncingMushroom` | `Enemy` | 30 | 756 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/BrickMonster.as` | `BrickMonster` | `Enemy` | 16 | 286 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/Bullopede.as` | `Bullopede` | `Enemy` | 15 | 249 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/Carnelia.as` | `Carnelia` | `Enemy` | 15 | 246 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/Chirplet.as` | `Chirplet` | `Enemy` | 20 | 439 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/Crab.as` | `Crab` | `Enemy` | 16 | 258 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/DrillBot.as` | `DrillBot` | `Enemy` | 16 | 274 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/Enemy.as` | `Enemy` | `starling.display.MovieClip` (impl: I, C, l, i, c, k, a, b, l, e, ,,  , I, G, r, a, v, i, t, y, O, b, j, e, c, t) | 556 | 20822 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/Fishurn.as` | `Fishurn` | `Enemy` | 16 | 267 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/Flockling.as` | `Flockling` | `Enemy` | 20 | 442 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/GiantGooCube.as` | `GiantGooCube` | `Enemy` | 15 | 260 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/Glord.as` | `Glord` | `Enemy` | 15 | 237 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/GooCube.as` | `GooCube` | `Enemy` | 15 | 243 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/GreatFrog.as` | `GreatFrog` | `Enemy` | 16 | 275 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/GreenBouncer.as` | `GreenBouncer` | `Enemy` | 30 | 726 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/GreenWalker.as` | `GreenWalker` | `Enemy` | 16 | 280 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/HornedMonster.as` | `HornedMonster` | `Enemy` | 16 | 286 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/Kraken.as` | `Kraken` | `Enemy` | 15 | 239 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/Kraw.as` | `Kraw` | `Enemy` | 20 | 427 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/Kreeton.as` | `Kreeton` | `Enemy` | 16 | 271 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/Kreetus.as` | `Kreetus` | `Enemy` | 32 | 725 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/Leaflet.as` | `Leaflet` | `Enemy` | 16 | 267 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/Leafling.as` | `Leafling` | `Enemy` | 16 | 271 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/LotusEye.as` | `LotusEye` | `Enemy` | 16 | 274 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/Magmagon.as` | `Magmagon` | `Enemy` | 16 | 274 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/Mongrel.as` | `Mongrel` | `Enemy` | 16 | 269 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/MushroomBall.as` | `MushroomBall` | `Enemy` | 19 | 409 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/MushroomBird.as` | `MushroomBird` | `Enemy` | 20 | 453 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/MushroomSquish.as` | `MushroomSquish` | `Enemy` | 15 | 261 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/Nightstalker.as` | `Nightstalker` | `Enemy` | 16 | 284 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/OmegaFluff.as` | `OmegaFluff` | `Enemy` | 15 | 253 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/OrangeCrazy.as` | `OrangeCrazy` | `Enemy` | 16 | 280 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/Penguin.as` | `Penguin` | `Enemy` | 16 | 267 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/PlantMonster.as` | `PlantMonster` | `Enemy` | 16 | 284 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/Proteum.as` | `Proteum` | `Enemy` | 15 | 243 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/PumpkinCreeper.as` | `PumpkinCreeper` | `Enemy` | 16 | 289 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/PurpleGoo.as` | `PurpleGoo` | `Enemy` | 30 | 705 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/RedBouncer.as` | `RedBouncer` | `Enemy` | 30 | 712 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/Repguana.as` | `Repguana` | `Enemy` | 16 | 274 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/Sasquatch.as` | `Sasquatch` | `Enemy` | 16 | 275 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/TitaniumVulture.as` | `TitaniumVulture` | `Enemy` | 20 | 469 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/YellowHairyMonster.as` | `YellowHairyMonster` | `Enemy` | 16 | 302 | Class in `com/game_objects/enemies` |
| `com/game_objects/enemies/YellowPuffMonster.as` | `YellowPuffMonster` | `Enemy` | 16 | 299 | Class in `com/game_objects/enemies` |

#### Package `com/game_objects/extensions` (6 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/game_objects/extensions/BodyAnimator.as` | `BodyAnimator` | `-` | 2117 | 459710 | Class in `com/game_objects/extensions` |
| `com/game_objects/extensions/EnergyController.as` | `EnergyController` | `-` | 293 | 8249 | Class in `com/game_objects/extensions` |
| `com/game_objects/extensions/MoveHandler.as` | `MoveHandler` | `-` | 814 | 35191 | Class in `com/game_objects/extensions` |
| `com/game_objects/extensions/PersonFrameHandler.as` | `PersonFrameHandler` | `-` | 572 | 25643 | Class in `com/game_objects/extensions` |
| `com/game_objects/extensions/PersonHackCheck.as` | `PersonHackCheck` | `-` | 148 | 3958 | Class in `com/game_objects/extensions` |
| `com/game_objects/extensions/PersonKeyHandler.as` | `PersonKeyHandler` | `-` | 811 | 39221 | Class in `com/game_objects/extensions` |

#### Package `com/game_objects/hit_detect` (3 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/game_objects/hit_detect/HitTester.as` | `HitTester` | `-` | 299 | 12315 | Class in `com/game_objects/hit_detect` |
| `com/game_objects/hit_detect/HitType.as` | `HitType` | `-` | 70 | 1666 | Class in `com/game_objects/hit_detect` |
| `com/game_objects/hit_detect/IHitObject.as` | `IHitObject` | `-` | 14 | 228 | Class in `com/game_objects/hit_detect` |

#### Package `com/game_objects/power_up_effects` (6 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/game_objects/power_up_effects/Aura.as` | `Aura` | `Sprite` | 170 | 6267 | Class in `com/game_objects/power_up_effects` |
| `com/game_objects/power_up_effects/AuraBall.as` | `AuraBall` | `Sprite` | 85 | 3054 | Class in `com/game_objects/power_up_effects` |
| `com/game_objects/power_up_effects/Electrify.as` | `Electrify` | `-` | 102 | 3703 | Class in `com/game_objects/power_up_effects` |
| `com/game_objects/power_up_effects/PowerUpVisuals.as` | `PowerUpVisuals` | `-` | 344 | 14494 | Class in `com/game_objects/power_up_effects` |
| `com/game_objects/power_up_effects/SlashEffect.as` | `SlashEffect` | `-` | 130 | 4314 | Class in `com/game_objects/power_up_effects` |
| `com/game_objects/power_up_effects/SuctionLines.as` | `SuctionLines` | `Sprite` | 71 | 2625 | Class in `com/game_objects/power_up_effects` |

#### Package `com/gravityPackage` (3 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/gravityPackage/GravityObject.as` | `GravityObject` | `-` | 448 | 17142 | Class in `com/gravityPackage` |
| `com/gravityPackage/IGravityObject.as` | `IGravityObject` | `-` | 10 | 145 | Class in `com/gravityPackage` |
| `com/gravityPackage/WindSource.as` | `WindSource` | `Sprite` | 84 | 3158 | Class in `com/gravityPackage` |

#### Package `com/greensock` (2 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/greensock/TweenLite.as` | `TweenLite` | `Animation` | 997 | 32097 | Class in `com/greensock` |
| `com/greensock/TweenMax.as` | `TweenMax` | `TweenLite` (impl: I, E, v, e, n, t, D, i, s, p, a, t, c, h, e, r) | 915 | 30062 | Class in `com/greensock` |

#### Package `com/greensock/core` (3 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/greensock/core/Animation.as` | `Animation` | `-` | 475 | 14590 | Class in `com/greensock/core` |
| `com/greensock/core/PropTween.as` | `PropTween` | `-` | 48 | 1054 | Class in `com/greensock/core` |
| `com/greensock/core/SimpleTimeline.as` | `SimpleTimeline` | `Animation` | 145 | 4129 | Class in `com/greensock/core` |

#### Package `com/greensock/easing` (14 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/greensock/easing/Back.as` | `Back` | `-` | 19 | 354 | Class in `com/greensock/easing` |
| `com/greensock/easing/BackIn.as` | `BackIn` | `Ease` | 26 | 559 | Class in `com/greensock/easing` |
| `com/greensock/easing/BackInOut.as` | `BackInOut` | `Ease` | 28 | 722 | Class in `com/greensock/easing` |
| `com/greensock/easing/BackOut.as` | `BackOut` | `Ease` | 27 | 589 | Class in `com/greensock/easing` |
| `com/greensock/easing/Bounce.as` | `Bounce` | `-` | 19 | 370 | Class in `com/greensock/easing` |
| `com/greensock/easing/BounceIn.as` | `BounceIn` | `Ease` | 33 | 836 | Class in `com/greensock/easing` |
| `com/greensock/easing/BounceInOut.as` | `BounceInOut` | `Ease` | 46 | 1154 | Class in `com/greensock/easing` |
| `com/greensock/easing/BounceOut.as` | `BounceOut` | `Ease` | 32 | 787 | Class in `com/greensock/easing` |
| `com/greensock/easing/Ease.as` | `Ease` | `-` | 63 | 1737 | Class in `com/greensock/easing` |
| `com/greensock/easing/Linear.as` | `Linear` | `Ease` | 23 | 486 | Class in `com/greensock/easing` |
| `com/greensock/easing/Sine.as` | `Sine` | `-` | 19 | 354 | Class in `com/greensock/easing` |
| `com/greensock/easing/SineIn.as` | `SineIn` | `Ease` | 22 | 440 | Class in `com/greensock/easing` |
| `com/greensock/easing/SineInOut.as` | `SineInOut` | `Ease` | 20 | 392 | Class in `com/greensock/easing` |
| `com/greensock/easing/SineOut.as` | `SineOut` | `Ease` | 22 | 439 | Class in `com/greensock/easing` |

#### Package `com/greensock/events` (1 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/greensock/events/TweenEvent.as` | `TweenEvent` | `Event` | 32 | 819 | Class in `com/greensock/events` |

#### Package `com/greensock/plugins` (21 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/greensock/plugins/AutoAlphaPlugin.as` | `AutoAlphaPlugin` | `TweenPlugin` | 43 | 1073 | Class in `com/greensock/plugins` |
| `com/greensock/plugins/BevelFilterPlugin.as` | `BevelFilterPlugin` | `FilterPlugin` | 25 | 772 | Class in `com/greensock/plugins` |
| `com/greensock/plugins/BezierPlugin.as` | `BezierPlugin` | `TweenPlugin` | 790 | 28299 | Class in `com/greensock/plugins` |
| `com/greensock/plugins/BezierThroughPlugin.as` | `BezierThroughPlugin` | `BezierPlugin` | 28 | 640 | Class in `com/greensock/plugins` |
| `com/greensock/plugins/BlurFilterPlugin.as` | `BlurFilterPlugin` | `FilterPlugin` | 25 | 650 | Class in `com/greensock/plugins` |
| `com/greensock/plugins/ColorMatrixFilterPlugin.as` | `ColorMatrixFilterPlugin` | `FilterPlugin` | 185 | 6797 | Class in `com/greensock/plugins` |
| `com/greensock/plugins/ColorTransformPlugin.as` | `ColorTransformPlugin` | `TintPlugin` | 86 | 2841 | Class in `com/greensock/plugins` |
| `com/greensock/plugins/DropShadowFilterPlugin.as` | `DropShadowFilterPlugin` | `FilterPlugin` | 25 | 816 | Class in `com/greensock/plugins` |
| `com/greensock/plugins/EndArrayPlugin.as` | `EndArrayPlugin` | `TweenPlugin` | 96 | 2463 | Class in `com/greensock/plugins` |
| `com/greensock/plugins/FilterPlugin.as` | `FilterPlugin` | `TweenPlugin` | 127 | 3999 | Class in `com/greensock/plugins` |
| `com/greensock/plugins/FrameLabelPlugin.as` | `FrameLabelPlugin` | `FramePlugin` | 46 | 1195 | Class in `com/greensock/plugins` |
| `com/greensock/plugins/FramePlugin.as` | `FramePlugin` | `TweenPlugin` | 43 | 1107 | Class in `com/greensock/plugins` |
| `com/greensock/plugins/GlowFilterPlugin.as` | `GlowFilterPlugin` | `FilterPlugin` | 25 | 765 | Class in `com/greensock/plugins` |
| `com/greensock/plugins/HexColorsPlugin.as` | `HexColorsPlugin` | `TweenPlugin` | 116 | 3290 | Class in `com/greensock/plugins` |
| `com/greensock/plugins/RemoveTintPlugin.as` | `RemoveTintPlugin` | `TintPlugin` | 16 | 278 | Class in `com/greensock/plugins` |
| `com/greensock/plugins/RoundPropsPlugin.as` | `RoundPropsPlugin` | `TweenPlugin` | 82 | 2547 | Class in `com/greensock/plugins` |
| `com/greensock/plugins/ShortRotationPlugin.as` | `ShortRotationPlugin` | `TweenPlugin` | 50 | 1768 | Class in `com/greensock/plugins` |
| `com/greensock/plugins/TintPlugin.as` | `TintPlugin` | `TweenPlugin` | 69 | 2157 | Class in `com/greensock/plugins` |
| `com/greensock/plugins/TweenPlugin.as` | `TweenPlugin` | `-` | 195 | 5735 | Class in `com/greensock/plugins` |
| `com/greensock/plugins/VisiblePlugin.as` | `VisiblePlugin` | `TweenPlugin` | 42 | 1148 | Class in `com/greensock/plugins` |
| `com/greensock/plugins/VolumePlugin.as` | `VolumePlugin` | `TweenPlugin` | 40 | 1051 | Class in `com/greensock/plugins` |

#### Package `com/helpers` (15 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/helpers/AntiAutoClicker.as` | `AntiAutoClicker` | `-` | 58 | 1534 | Class in `com/helpers` |
| `com/helpers/AreaCreator.as` | `AreaCreator` | `-` | 437 | 18523 | Class in `com/helpers` |
| `com/helpers/KeyState.as` | `KeyState` | `-` | 35 | 659 | Class in `com/helpers` |
| `com/helpers/KeyStates.as` | `KeyStates` | `-` | 134 | 4090 | Class in `com/helpers` |
| `com/helpers/LavaRain.as` | `LavaRain` | `Sprite` | 73 | 2519 | Class in `com/helpers` |
| `com/helpers/LavaRain_FlameDropPNG.as` | `LavaRain_FlameDropPNG` | `BitmapAsset` | 16 | 303 | Class in `com/helpers` |
| `com/helpers/LavaRain_FlameDropXML.as` | `LavaRain_FlameDropXML` | `ByteArrayAsset` | 16 | 346 | Class in `com/helpers` |
| `com/helpers/Rain.as` | `Rain` | `Sprite` | 76 | 2545 | Class in `com/helpers` |
| `com/helpers/Rain_RainDropPNG.as` | `Rain_RainDropPNG` | `BitmapAsset` | 16 | 288 | Class in `com/helpers` |
| `com/helpers/Rain_RainDropXML.as` | `Rain_RainDropXML` | `ByteArrayAsset` | 16 | 331 | Class in `com/helpers` |
| `com/helpers/Snow.as` | `Snow` | `Sprite` | 82 | 2779 | Class in `com/helpers` |
| `com/helpers/Snow_SnowflakePNG.as` | `Snow_SnowflakePNG` | `BitmapAsset` | 16 | 291 | Class in `com/helpers` |
| `com/helpers/Snow_SnowflakeXML.as` | `Snow_SnowflakeXML` | `ByteArrayAsset` | 16 | 334 | Class in `com/helpers` |
| `com/helpers/TileDefRegistry.as` | `TileDefRegistry` | `-` | 148 | 4665 | Class in `com/helpers` |
| `com/helpers/TileHandler.as` | `TileHandler` | `-` | 1223 | 45457 | Class in `com/helpers` |

#### Package `com/lighting` (2 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/lighting/Lighting.as` | `Lighting` | `-` | 49 | 1573 | Class in `com/lighting` |
| `com/lighting/Shadows.as` | `Shadows` | `Sprite` | 117 | 3933 | Class in `com/lighting` |

#### Package `com/math` (6 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/math/CalcDist.as` | `CalcDist` | `-` | 49 | 1219 | Class in `com/math` |
| `com/math/LineIntersection.as` | `LineIntersection` | `-` | 38 | 1763 | Class in `com/math` |
| `com/math/MoveInCircle.as` | `MoveInCircle` | `-` | 22 | 535 | Class in `com/math` |
| `com/math/MoveTo.as` | `MoveTo` | `-` | 23 | 466 | Class in `com/math` |
| `com/math/RanOne.as` | `RanOne` | `-` | 18 | 257 | Class in `com/math` |
| `com/math/RotateTo.as` | `RotateTo` | `-` | 30 | 653 | Class in `com/math` |

#### Package `com/menus` (39 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/menus/AlertMenu.as` | `AlertMenu` | `Sprite` | 88 | 2980 | Class in `com/menus` |
| `com/menus/BankMenu.as` | `BankMenu` | `StarlingGameMenu` | 331 | 12759 | Class in `com/menus` |
| `com/menus/BlockBuildMenu.as` | `BlockBuildMenu` | `MovieClip` | 40 | 871 | Class in `com/menus` |
| `com/menus/BullhornMenu.as` | `BullhornMenu` | `GameMenu` | 41 | 1124 | Class in `com/menus` |
| `com/menus/CharacterMenu.as` | `CharacterMenu` | `StarlingGameMenu` | 595 | 30607 | Class in `com/menus` |
| `com/menus/ConfirmMenu.as` | `ConfirmMenu` | `Sprite` | 65 | 1968 | Class in `com/menus` |
| `com/menus/CraftingMenu.as` | `CraftingMenu` | `ItemGameMenu` (impl: I, S, c, r, o, l, l, a, b, l, e, G, a, m, e, M, e, n, u) | 360 | 13223 | Class in `com/menus` |
| `com/menus/CreateMenu.as` | `CreateMenu` | `Sprite` | 756 | 34719 | Class in `com/menus` |
| `com/menus/EnergyMenu.as` | `EnergyMenu` | `StarlingGameMenu` | 297 | 16360 | Class in `com/menus` |
| `com/menus/FishListMenu.as` | `FishListMenu` | `StarlingGameMenu` | 85 | 3383 | Class in `com/menus` |
| `com/menus/FriendMenu.as` | `FriendMenu` | `StarlingGameMenu` (impl: I, S, c, r, o, l, l, a, b, l, e, G, a, m, e, M, e, n, u) | 855 | 36266 | Class in `com/menus` |
| `com/menus/GameMenu.as` | `GameMenu` | `MovieClip` | 123 | 3490 | Class in `com/menus` |
| `com/menus/GuildMemberMenu.as` | `GuildMemberMenu` | `StarlingGameMenu` (impl: I, S, c, r, o, l, l, a, b, l, e, G, a, m, e, M, e, n, u) | 398 | 16360 | Class in `com/menus` |
| `com/menus/GuildMenu.as` | `GuildMenu` | `GameMenu` | 248 | 9435 | Class in `com/menus` |
| `com/menus/HeropediaMenu.as` | `HeropediaMenu` | `StarlingGameMenu` | 353 | 13096 | Class in `com/menus` |
| `com/menus/IScrollableGameMenu.as` | `IScrollableGameMenu` | `-` | 14 | 249 | Class in `com/menus` |
| `com/menus/ItemGameMenu.as` | `ItemGameMenu` | `StarlingGameMenu` | 596 | 27573 | Class in `com/menus` |
| `com/menus/ItemMenu.as` | `ItemMenu` | `ItemGameMenu` (impl: I, S, c, r, o, l, l, a, b, l, e, G, a, m, e, M, e, n, u) | 752 | 29367 | Class in `com/menus` |
| `com/menus/LoadScreen.as` | `LoadScreen` | `Sprite` | 96 | 3802 | Class in `com/menus` |
| `com/menus/LotteryMenu.as` | `LotteryMenu` | `StarlingGameMenu` | 136 | 6211 | Class in `com/menus` |
| `com/menus/MainMenu.as` | `MainMenu` | `MovieClip` | 225 | 6148 | Class in `com/menus` |
| `com/menus/MapMenu.as` | `MapMenu` | `StarlingGameMenu` | 687 | 24461 | Class in `com/menus` |
| `com/menus/MissionMenu.as` | `MissionMenu` | `StarlingGameMenu` (impl: I, S, c, r, o, l, l, a, b, l, e, G, a, m, e, M, e, n, u) | 198 | 7608 | Class in `com/menus` |
| `com/menus/ModeratorMenu.as` | `ModeratorMenu` | `MovieClip` | 61 | 1601 | Class in `com/menus` |
| `com/menus/OptionMenu.as` | `OptionMenu` | `StarlingGameMenu` | 326 | 16772 | Class in `com/menus` |
| `com/menus/PMMenu.as` | `PMMenu` | `StarlingGameMenu` (impl: I, S, c, r, o, l, l, a, b, l, e, G, a, m, e, M, e, n, u) | 679 | 26757 | Class in `com/menus` |
| `com/menus/PayVaultMenu.as` | `PayVaultMenu` | `GameMenu` | 808 | 27355 | Class in `com/menus` |
| `com/menus/PetConfirmMenu.as` | `PetConfirmMenu` | `StarlingGameMenu` | 185 | 7279 | Class in `com/menus` |
| `com/menus/PetItemMenu.as` | `PetItemMenu` | `ItemGameMenu` (impl: I, S, c, r, o, l, l, a, b, l, e, G, a, m, e, M, e, n, u) | 453 | 17971 | Class in `com/menus` |
| `com/menus/PetMenu.as` | `PetMenu` | `StarlingGameMenu` | 545 | 24275 | Class in `com/menus` |
| `com/menus/PetModeMenu.as` | `PetModeMenu` | `StarlingGameMenu` | 286 | 12031 | Class in `com/menus` |
| `com/menus/PetShopMenu.as` | `PetShopMenu` | `StarlingGameMenu` | 215 | 8236 | Class in `com/menus` |
| `com/menus/PetVendMenu.as` | `PetVendMenu` | `StarlingGameMenu` | 169 | 6501 | Class in `com/menus` |
| `com/menus/PresentMenu.as` | `PresentMenu` | `StarlingGameMenu` | 115 | 4693 | Class in `com/menus` |
| `com/menus/RankMenu.as` | `RankMenu` | `GameMenu` | 283 | 12849 | Class in `com/menus` |
| `com/menus/SkillsMenu.as` | `SkillsMenu` | `StarlingGameMenu` (impl: I, S, c, r, o, l, l, a, b, l, e, G, a, m, e, M, e, n, u) | 2139 | 129506 | Class in `com/menus` |
| `com/menus/StarlingGameMenu.as` | `StarlingGameMenu` | `Sprite` | 177 | 5397 | Class in `com/menus` |
| `com/menus/TalkBox.as` | `TalkBox` | `Sprite` | 119 | 4316 | Class in `com/menus` |
| `com/menus/TradeMenu.as` | `TradeMenu` | `ItemGameMenu` (impl: I, S, c, r, o, l, l, a, b, l, e, G, a, m, e, M, e, n, u) | 1355 | 55156 | Class in `com/menus` |

#### Package `com/menus/add_ons` (6 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/menus/add_ons/Cursor.as` | `Cursor` | `-` | 58 | 1505 | Class in `com/menus/add_ons` |
| `com/menus/add_ons/EnergyBar.as` | `EnergyBar` | `Sprite` | 77 | 2555 | Class in `com/menus/add_ons` |
| `com/menus/add_ons/IClickable.as` | `IClickable` | `-` | 10 | 124 | Class in `com/menus/add_ons` |
| `com/menus/add_ons/MapMarker.as` | `MapMarker` | `Image` | 18 | 349 | Class in `com/menus/add_ons` |
| `com/menus/add_ons/RightClickButton.as` | `RightClickButton` | `MovieClip` | 24 | 555 | Class in `com/menus/add_ons` |
| `com/menus/add_ons/RightClickMenu.as` | `RightClickMenu` | `Sprite` | 28 | 673 | Class in `com/menus/add_ons` |

#### Package `com/newgrounds` (16 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/newgrounds/API.as` | `API` | `-` | 1031 | 34776 | Class in `com/newgrounds` |
| `com/newgrounds/APICommand.as` | `APICommand` | `APIEventDispatcher` | 525 | 16450 | Class in `com/newgrounds` |
| `com/newgrounds/APIConnection.as` | `APIConnection` | `-` | 160 | 4311 | Class in `com/newgrounds` |
| `com/newgrounds/APIEvent.as` | `APIEvent` | `Event` | 119 | 3540 | Class in `com/newgrounds` |
| `com/newgrounds/APIEventDispatcher.as` | `APIEventDispatcher` | `-` | 77 | 2034 | Class in `com/newgrounds` |
| `com/newgrounds/BitmapLoader.as` | `BitmapLoader` | `APIEventDispatcher` | 146 | 4105 | Class in `com/newgrounds` |
| `com/newgrounds/Bridge.as` | `Bridge` | `EventDispatcher` | 80 | 2199 | Class in `com/newgrounds` |
| `com/newgrounds/Logger.as` | `Logger` | `-` | 76 | 1989 | Class in `com/newgrounds` |
| `com/newgrounds/Medal.as` | `Medal` | `APIEventDispatcher` | 148 | 4374 | Class in `com/newgrounds` |
| `com/newgrounds/SaveFile.as` | `SaveFile` | `APIEventDispatcher` | 731 | 22539 | Class in `com/newgrounds` |
| `com/newgrounds/SaveGroup.as` | `SaveGroup` | `-` | 127 | 3091 | Class in `com/newgrounds` |
| `com/newgrounds/SaveKey.as` | `SaveKey` | `-` | 82 | 2052 | Class in `com/newgrounds` |
| `com/newgrounds/SaveQuery.as` | `SaveQuery` | `APIEventDispatcher` | 345 | 10637 | Class in `com/newgrounds` |
| `com/newgrounds/SaveRating.as` | `SaveRating` | `-` | 89 | 2338 | Class in `com/newgrounds` |
| `com/newgrounds/Score.as` | `Score` | `-` | 58 | 1252 | Class in `com/newgrounds` |
| `com/newgrounds/ScoreBoard.as` | `ScoreBoard` | `APIEventDispatcher` | 195 | 5404 | Class in `com/newgrounds` |

#### Package `com/newgrounds/assets` (1 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/newgrounds/assets/DefaultMedalIcon.as` | `DefaultMedalIcon` | `BitmapData` | 16 | 361 | Class in `com/newgrounds/assets` |

#### Package `com/newgrounds/components` (1 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/newgrounds/components/MedalPopup.as` | `MedalPopup` | `MovieClip` | 164 | 4709 | Class in `com/newgrounds/components` |

#### Package `com/newgrounds/crypto` (2 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/newgrounds/crypto/MD5.as` | `MD5` | `-` | 228 | 11733 | Class in `com/newgrounds/crypto` |
| `com/newgrounds/crypto/RC4.as` | `RC4` | `-` | 139 | 4212 | Class in `com/newgrounds/crypto` |

#### Package `com/newgrounds/encoders` (2 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/newgrounds/encoders/BaseN.as` | `BaseN` | `-` | 68 | 1731 | Class in `com/newgrounds/encoders` |
| `com/newgrounds/encoders/PNGEncoder.as` | `PNGEncoder` | `-` | 123 | 3710 | Class in `com/newgrounds/encoders` |

#### Package `com/newgrounds/encoders/json` (3 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/newgrounds/encoders/json/NGJSON.as` | `NGJSON` | `-` | 23 | 407 | Class in `com/newgrounds/encoders/json` |
| `com/newgrounds/encoders/json/decodeJson.as` | `decodeJson` | `-` | 329 | 9361 | Class in `com/newgrounds/encoders/json` |
| `com/newgrounds/encoders/json/encodeJson.as` | `encodeJson` | `-` | 247 | 6655 | Class in `com/newgrounds/encoders/json` |

#### Package `com/protobuf` (6 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/protobuf/CodedInputStream.as` | `CodedInputStream` | `-` | 349 | 9850 | Class in `com/protobuf` |
| `com/protobuf/CodedOutputStream.as` | `CodedOutputStream` | `-` | 476 | 14839 | Class in `com/protobuf` |
| `com/protobuf/Descriptor.as` | `Descriptor` | `-` | 94 | 2227 | Class in `com/protobuf` |
| `com/protobuf/InvalidProtocolBufferException.as` | `InvalidProtocolBufferException` | `IOError` | 55 | 2324 | Class in `com/protobuf` |
| `com/protobuf/Message.as` | `Message` | `-` | 158 | 4832 | Class in `com/protobuf` |
| `com/protobuf/WireFormat.as` | `WireFormat` | `-` | 58 | 1530 | Class in `com/protobuf` |

#### Package `com/sound` (3 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/sound/LoopedSound.as` | `LoopedSound` | `-` | 75 | 2226 | Class in `com/sound` |
| `com/sound/SoundLibrary.as` | `SoundLibrary` | `-` | 229 | 6086 | Class in `com/sound` |
| `com/sound/SoundManager.as` | `SoundManager` | `-` | 274 | 8384 | Class in `com/sound` |

#### Package `com/stats` (6 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/stats/CastleBlockStat.as` | `CastleBlockStat` | `-` | 45 | 1025 | Class in `com/stats` |
| `com/stats/ItemStat.as` | `ItemStat` | `-` | 199 | 4768 | Class in `com/stats` |
| `com/stats/MoveStat.as` | `MoveStat` | `-` | 109 | 2671 | Class in `com/stats` |
| `com/stats/Moves.as` | `Moves` | `-` | 194 | 8027 | Class in `com/stats` |
| `com/stats/NPCStat.as` | `NPCStat` | `-` | 61 | 1585 | Class in `com/stats` |
| `com/stats/Stats.as` | `Stats` | `-` | 718 | 62461 | Class in `com/stats` |

#### Package `com/ui` (5 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/ui/AllTextFormats.as` | `AllTextFormats` | `-` | 270 | 13045 | Class in `com/ui` |
| `com/ui/Controls.as` | `Controls` | `Sprite` | 923 | 42276 | Class in `com/ui` |
| `com/ui/FakeCursor.as` | `FakeCursor` | `Sprite` | 151 | 4767 | Class in `com/ui` |
| `com/ui/GiveHealthBar.as` | `GiveHealthBar` | `-` | 133 | 5065 | Class in `com/ui` |
| `com/ui/MouseWheel.as` | `MouseWheel` | `-` | 139 | 4746 | Class in `com/ui` |

#### Package `com/utilities` (27 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/utilities/AssetManagerExtended.as` | `AssetManagerExtended` | `AssetManager` | 90 | 3065 | Class in `com/utilities` |
| `com/utilities/AssetManagerFileChecker.as` | `AssetManagerFileChecker` | `-` | 35 | 920 | Class in `com/utilities` |
| `com/utilities/Assets.as` | `Assets` | `-` | 713 | 55892 | Class in `com/utilities` |
| `com/utilities/Assets_ChalkFont_PNG.as` | `Assets_ChalkFont_PNG` | `BitmapAsset` | 16 | 304 | Class in `com/utilities` |
| `com/utilities/Assets_ChalkFont_XML.as` | `Assets_ChalkFont_XML` | `ByteArrayAsset` | 16 | 347 | Class in `com/utilities` |
| `com/utilities/Assets_DamageFont_PNG.as` | `Assets_DamageFont_PNG` | `BitmapAsset` | 16 | 307 | Class in `com/utilities` |
| `com/utilities/Assets_DamageFont_XML.as` | `Assets_DamageFont_XML` | `ByteArrayAsset` | 16 | 350 | Class in `com/utilities` |
| `com/utilities/Assets_Font_PNG.as` | `Assets_Font_PNG` | `BitmapAsset` | 16 | 289 | Class in `com/utilities` |
| `com/utilities/Assets_Font_XML.as` | `Assets_Font_XML` | `ByteArrayAsset` | 16 | 332 | Class in `com/utilities` |
| `com/utilities/Assets_LotteryFont_PNG.as` | `Assets_LotteryFont_PNG` | `BitmapAsset` | 16 | 310 | Class in `com/utilities` |
| `com/utilities/Assets_LotteryFont_XML.as` | `Assets_LotteryFont_XML` | `ByteArrayAsset` | 16 | 353 | Class in `com/utilities` |
| `com/utilities/Assets_ReadableFont_PNG.as` | `Assets_ReadableFont_PNG` | `BitmapAsset` | 16 | 313 | Class in `com/utilities` |
| `com/utilities/Assets_ReadableFont_XML.as` | `Assets_ReadableFont_XML` | `ByteArrayAsset` | 16 | 356 | Class in `com/utilities` |
| `com/utilities/Assets_RightClick1Image.as` | `Assets_RightClick1Image` | `BitmapAsset` | 16 | 313 | Class in `com/utilities` |
| `com/utilities/Assets_RightClick2Image.as` | `Assets_RightClick2Image` | `BitmapAsset` | 16 | 313 | Class in `com/utilities` |
| `com/utilities/Assets_StatsFont_PNG.as` | `Assets_StatsFont_PNG` | `BitmapAsset` | 16 | 304 | Class in `com/utilities` |
| `com/utilities/Assets_StatsFont_XML.as` | `Assets_StatsFont_XML` | `ByteArrayAsset` | 16 | 347 | Class in `com/utilities` |
| `com/utilities/BitArray.as` | `BitArray` | `-` | 107 | 2732 | Class in `com/utilities` |
| `com/utilities/BitBitmapData.as` | `BitBitmapData` | `-` | 117 | 3321 | Class in `com/utilities` |
| `com/utilities/CommonCalls.as` | `CommonCalls` | `-` | 205 | 6202 | Class in `com/utilities` |
| `com/utilities/CussFilter.as` | `CussFilter` | `-` | 104 | 5504 | Class in `com/utilities` |
| `com/utilities/MovieClipToAtlas.as` | `MovieClipToAtlas` | `-` | 344 | 14792 | Class in `com/utilities` |
| `com/utilities/PerformanceIndex.as` | `PerformanceIndex` | `-` | 50 | 1285 | Class in `com/utilities` |
| `com/utilities/RiseValue.as` | `RiseValue` | `-` | 102 | 3287 | Class in `com/utilities` |
| `com/utilities/RoundToNearest.as` | `RoundToNearest` | `-` | 24 | 482 | Class in `com/utilities` |
| `com/utilities/SiteLock.as` | `SiteLock` | `-` | 94 | 2816 | Class in `com/utilities` |
| `com/utilities/SortDepths.as` | `SortDepths` | `-` | 190 | 7275 | Class in `com/utilities` |

#### Package `com/utilities/treefortress/textureutils` (2 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/utilities/treefortress/textureutils/AtlasBuilder.as` | `AtlasBuilder` | `-` | 154 | 6279 | Class in `com/utilities/treefortress/textureutils` |
| `com/utilities/treefortress/textureutils/MaxRectPacker.as` | `MaxRectPacker` | `-` | 161 | 5513 | Class in `com/utilities/treefortress/textureutils` |

#### Package `com/visual_effects` (11 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `com/visual_effects/AfterImage.as` | `AfterImage` | `-` | 49 | 1473 | Class in `com/visual_effects` |
| `com/visual_effects/CircleCreator.as` | `CircleCreator` | `-` | 68 | 2114 | Class in `com/visual_effects` |
| `com/visual_effects/DrawToBitmap.as` | `DrawToBitmap` | `Bitmap` | 150 | 5166 | Class in `com/visual_effects` |
| `com/visual_effects/FlashShock.as` | `FlashShock` | `-` | 73 | 2125 | Class in `com/visual_effects` |
| `com/visual_effects/SetHue.as` | `SetHue` | `-` | 70 | 2548 | Class in `com/visual_effects` |
| `com/visual_effects/Shake.as` | `Shake` | `-` | 111 | 3289 | Class in `com/visual_effects` |
| `com/visual_effects/ShineEffect.as` | `ShineEffect` | `-` | 46 | 1435 | Class in `com/visual_effects` |
| `com/visual_effects/Shockwave.as` | `Shockwave` | `-` | 86 | 2841 | Class in `com/visual_effects` |
| `com/visual_effects/Shockwave_DMap.as` | `Shockwave_DMap` | `BitmapAsset` | 16 | 296 | Class in `com/visual_effects` |
| `com/visual_effects/StarExplosion.as` | `StarExplosion` | `-` | 86 | 3133 | Class in `com/visual_effects` |
| `com/visual_effects/TalkText.as` | `TalkText` | `-` | 76 | 2127 | Class in `com/visual_effects` |

#### Package `fairyareawhole_fla` (1 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `fairyareawhole_fla/bouncepad_2.as` | `bouncepad_2` | `MovieClip` | 22 | 412 | Class in `fairyareawhole_fla` |

#### Package `feathers/controls` (6 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `feathers/controls/AutoSizeMode.as` | `AutoSizeMode` | `-` | 17 | 282 | Class in `feathers/controls` |
| `feathers/controls/Callout.as` | `Callout` | `FeathersControl` | 1220 | 42552 | Class in `feathers/controls` |
| `feathers/controls/LayoutGroup.as` | `LayoutGroup` | `FeathersControl` | 623 | 20390 | Class in `feathers/controls` |
| `feathers/controls/TextCallout.as` | `TextCallout` | `Callout` (impl: I, T, o, o, l, T, i, p) | 169 | 5555 | Class in `feathers/controls` |
| `feathers/controls/TextInput.as` | `TextInput` | `FeathersControl` (impl: I, T, e, x, t, B, a, s, e, l, i, n, e, C, o, n, t, r, o, l, ,,  , I, N, a, t, i, v, e, F, o, c, u, s, O, w, n, e, r, ,,  , I, S, t, a, t, e, C, o, n, t, e, x, t) | 1702 | 55474 | Class in `feathers/controls` |
| `feathers/controls/TextInputState.as` | `TextInputState` | `-` | 21 | 414 | Class in `feathers/controls` |

#### Package `feathers/controls/supportClasses` (2 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `feathers/controls/supportClasses/IViewPort.as` | `IViewPort` | `IFeathersControl` | 50 | 1379 | Class in `feathers/controls/supportClasses` |
| `feathers/controls/supportClasses/LayoutViewPort.as` | `LayoutViewPort` | `LayoutGroup` (impl: I, V, i, e, w, P, o, r, t) | 364 | 11165 | Class in `feathers/controls/supportClasses` |

#### Package `feathers/controls/text` (2 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `feathers/controls/text/BitmapFontTextRenderer.as` | `BitmapFontTextRenderer` | `FeathersControl` (impl: I, T, e, x, t, R, e, n, d, e, r, e, r, ,,  , I, S, t, a, t, e, O, b, s, e, r, v, e, r) | 950 | 31272 | Class in `feathers/controls/text` |
| `feathers/controls/text/StageTextTextEditor.as` | `StageTextTextEditor` | `FeathersControl` (impl: I, M, u, l, t, i, l, i, n, e, T, e, x, t, E, d, i, t, o, r) | 1259 | 42823 | Class in `feathers/controls/text` |

#### Package `feathers/core` (27 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `feathers/core/DefaultFocusManager.as` | `DefaultFocusManager` | `-` (impl: I, F, o, c, u, s, M, a, n, a, g, e, r) | 718 | 24123 | Class in `feathers/core` |
| `feathers/core/DefaultPopUpManager.as` | `DefaultPopUpManager` | `-` (impl: I, P, o, p, U, p, M, a, n, a, g, e, r) | 262 | 8533 | Class in `feathers/core` |
| `feathers/core/FeathersControl.as` | `FeathersControl` | `Sprite` (impl: I, F, e, a, t, h, e, r, s, C, o, n, t, r, o, l, ,,  , I, L, a, y, o, u, t, D, i, s, p, l, a, y, O, b, j, e, c, t) | 1225 | 37376 | Class in `feathers/core` |
| `feathers/core/FocusManager.as` | `FocusManager` | `-` | 155 | 4939 | Class in `feathers/core` |
| `feathers/core/IFeathersControl.as` | `IFeathersControl` | `IValidating` | 46 | 1210 | Class in `feathers/core` |
| `feathers/core/IFeathersDisplayObject.as` | `IFeathersDisplayObject` | `IFeathersEventDispatcher` | 121 | 3373 | Class in `feathers/core` |
| `feathers/core/IFeathersEventDispatcher.as` | `IFeathersEventDispatcher` | `-` | 22 | 630 | Class in `feathers/core` |
| `feathers/core/IFocusContainer.as` | `IFocusContainer` | `IFocusDisplayObject` | 12 | 241 | Class in `feathers/core` |
| `feathers/core/IFocusDisplayObject.as` | `IFocusDisplayObject` | `IFeathersDisplayObject` | 32 | 890 | Class in `feathers/core` |
| `feathers/core/IFocusExtras.as` | `IFocusExtras` | `-` | 14 | 272 | Class in `feathers/core` |
| `feathers/core/IFocusManager.as` | `IFocusManager` | `-` | 20 | 438 | Class in `feathers/core` |
| `feathers/core/IMeasureDisplayObject.as` | `IMeasureDisplayObject` | `-` | 24 | 530 | Class in `feathers/core` |
| `feathers/core/IMultilineTextEditor.as` | `IMultilineTextEditor` | `ITextEditor` | 12 | 218 | Class in `feathers/core` |
| `feathers/core/INativeFocusOwner.as` | `INativeFocusOwner` | `IFocusDisplayObject` | 12 | 222 | Class in `feathers/core` |
| `feathers/core/IPopUpManager.as` | `IPopUpManager` | `-` | 29 | 881 | Class in `feathers/core` |
| `feathers/core/IStateContext.as` | `IStateContext` | `IFeathersEventDispatcher` | 10 | 164 | Class in `feathers/core` |
| `feathers/core/IStateObserver.as` | `IStateObserver` | `-` | 12 | 210 | Class in `feathers/core` |
| `feathers/core/ITextBaselineControl.as` | `ITextBaselineControl` | `IFeathersControl` | 10 | 159 | Class in `feathers/core` |
| `feathers/core/ITextEditor.as` | `ITextEditor` | `IFeathersControl` | 48 | 1253 | Class in `feathers/core` |
| `feathers/core/ITextRenderer.as` | `ITextRenderer` | `IFeathersControl` | 20 | 437 | Class in `feathers/core` |
| `feathers/core/IToggle.as` | `IToggle` | `IFeathersControl` | 12 | 212 | Class in `feathers/core` |
| `feathers/core/IToolTip.as` | `IToolTip` | `IFeathersControl` | 12 | 199 | Class in `feathers/core` |
| `feathers/core/IValidating.as` | `IValidating` | `IFeathersDisplayObject` | 12 | 193 | Class in `feathers/core` |
| `feathers/core/PopUpManager.as` | `PopUpManager` | `-` | 102 | 3349 | Class in `feathers/core` |
| `feathers/core/PropertyProxy.as` | `PropertyProxy` | `Proxy` | 168 | 5028 | Class in `feathers/core` |
| `feathers/core/TokenList.as` | `TokenList` | `EventDispatcher` | 109 | 2700 | Class in `feathers/core` |
| `feathers/core/ValidationQueue.as` | `ValidationQueue` | `-` (impl: I, A, n, i, m, a, t, a, b, l, e) | 137 | 3847 | Class in `feathers/core` |

#### Package `feathers/events` (1 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `feathers/events/FeathersEventType.as` | `FeathersEventType` | `-` | 69 | 2303 | Class in `feathers/events` |

#### Package `feathers/layout` (8 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `feathers/layout/ILayout.as` | `ILayout` | `IFeathersEventDispatcher` | 20 | 827 | Class in `feathers/layout` |
| `feathers/layout/ILayoutData.as` | `ILayoutData` | `IFeathersEventDispatcher` | 12 | 160 | Class in `feathers/layout` |
| `feathers/layout/ILayoutDisplayObject.as` | `ILayoutDisplayObject` | `IFeathersDisplayObject` | 18 | 399 | Class in `feathers/layout` |
| `feathers/layout/IVirtualLayout.as` | `IVirtualLayout` | `ILayout` | 23 | 716 | Class in `feathers/layout` |
| `feathers/layout/LayoutBoundsResult.as` | `LayoutBoundsResult` | `-` | 25 | 456 | Class in `feathers/layout` |
| `feathers/layout/RelativePosition.as` | `RelativePosition` | `-` | 27 | 609 | Class in `feathers/layout` |
| `feathers/layout/VerticalAlign.as` | `VerticalAlign` | `-` | 21 | 400 | Class in `feathers/layout` |
| `feathers/layout/ViewPortBounds.as` | `ViewPortBounds` | `-` | 33 | 647 | Class in `feathers/layout` |

#### Package `feathers/skins` (1 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `feathers/skins/IStyleProvider.as` | `IStyleProvider` | `-` | 12 | 197 | Class in `feathers/skins` |

#### Package `feathers/text` (2 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `feathers/text/BitmapFontTextFormat.as` | `BitmapFontTextFormat` | `-` | 47 | 1262 | Class in `feathers/text` |
| `feathers/text/StageTextField.as` | `StageTextField` | `EventDispatcher` | 392 | 11414 | Class in `feathers/text` |

#### Package `feathers/utils/display` (2 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `feathers/utils/display/getDisplayObjectDepthFromStage.as` | `getDisplayObjectDepthFromStage` | `-` | 21 | 392 | Class in `feathers/utils/display` |
| `feathers/utils/display/stageToStarling.as` | `stageToStarling` | `-` | 20 | 384 | Class in `feathers/utils/display` |

#### Package `feathers/utils/geom` (2 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `feathers/utils/geom/matrixToScaleX.as` | `matrixToScaleX` | `-` | 13 | 277 | Class in `feathers/utils/geom` |
| `feathers/utils/geom/matrixToScaleY.as` | `matrixToScaleY` | `-` | 13 | 277 | Class in `feathers/utils/geom` |

#### Package `fl/containers` (1 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `fl/containers/BaseScrollPane.as` | `BaseScrollPane` | `UIComponent` | 429 | 15203 | Class in `fl/containers` |

#### Package `fl/controls` (13 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `fl/controls/BaseButton.as` | `BaseButton` | `UIComponent` | 217 | 6288 | Class in `fl/controls` |
| `fl/controls/Button.as` | `Button` | `LabelButton` (impl: I, F, o, c, u, s, M, a, n, a, g, e, r, C, o, m, p, o, n, e, n, t) | 115 | 3452 | Class in `fl/controls` |
| `fl/controls/ButtonLabelPlacement.as` | `ButtonLabelPlacement` | `-` | 21 | 402 | Class in `fl/controls` |
| `fl/controls/ColorPicker.as` | `ColorPicker` | `UIComponent` (impl: I, F, o, c, u, s, M, a, n, a, g, e, r, C, o, m, p, o, n, e, n, t) | 875 | 30203 | Class in `fl/controls` |
| `fl/controls/ComboBox.as` | `ComboBox` | `UIComponent` (impl: I, F, o, c, u, s, M, a, n, a, g, e, r, C, o, m, p, o, n, e, n, t) | 852 | 26507 | Class in `fl/controls` |
| `fl/controls/LabelButton.as` | `LabelButton` | `BaseButton` (impl: I, F, o, c, u, s, M, a, n, a, g, e, r, C, o, m, p, o, n, e, n, t) | 316 | 9983 | Class in `fl/controls` |
| `fl/controls/List.as` | `List` | `SelectableList` (impl: I, F, o, c, u, s, M, a, n, a, g, e, r, C, o, m, p, o, n, e, n, t) | 466 | 15537 | Class in `fl/controls` |
| `fl/controls/ScrollBar.as` | `ScrollBar` | `UIComponent` | 417 | 14218 | Class in `fl/controls` |
| `fl/controls/ScrollBarDirection.as` | `ScrollBarDirection` | `-` | 17 | 300 | Class in `fl/controls` |
| `fl/controls/ScrollPolicy.as` | `ScrollPolicy` | `-` | 19 | 319 | Class in `fl/controls` |
| `fl/controls/SelectableList.as` | `SelectableList` | `BaseScrollPane` (impl: I, F, o, c, u, s, M, a, n, a, g, e, r, C, o, m, p, o, n, e, n, t) | 715 | 22231 | Class in `fl/controls` |
| `fl/controls/TextInput.as` | `TextInput` | `UIComponent` (impl: I, F, o, c, u, s, M, a, n, a, g, e, r, C, o, m, p, o, n, e, n, t) | 393 | 11269 | Class in `fl/controls` |
| `fl/controls/UIScrollBar.as` | `UIScrollBar` | `ScrollBar` | 215 | 7030 | Class in `fl/controls` |

#### Package `fl/controls/listClasses` (3 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `fl/controls/listClasses/CellRenderer.as` | `CellRenderer` | `LabelButton` (impl: I, C, e, l, l, R, e, n, d, e, r, e, r) | 112 | 3196 | Class in `fl/controls/listClasses` |
| `fl/controls/listClasses/ICellRenderer.as` | `ICellRenderer` | `-` | 28 | 650 | Class in `fl/controls/listClasses` |
| `fl/controls/listClasses/ListData.as` | `ListData` | `-` | 63 | 1339 | Class in `fl/controls/listClasses` |

#### Package `fl/core` (3 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `fl/core/ComponentShim.as` | `ComponentShim` | `MovieClip` | 16 | 281 | Class in `fl/core` |
| `fl/core/InvalidationType.as` | `InvalidationType` | `-` | 29 | 651 | Class in `fl/core` |
| `fl/core/UIComponent.as` | `UIComponent` | `Sprite` | 698 | 19916 | Class in `fl/core` |

#### Package `fl/data` (2 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `fl/data/DataProvider.as` | `DataProvider` | `EventDispatcher` | 288 | 9741 | Class in `fl/data` |
| `fl/data/SimpleCollectionItem.as` | `SimpleCollectionItem` | `-` | 22 | 403 | Class in `fl/data` |

#### Package `fl/events` (6 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `fl/events/ColorPickerEvent.as` | `ColorPickerEvent` | `Event` | 41 | 986 | Class in `fl/events` |
| `fl/events/ComponentEvent.as` | `ComponentEvent` | `Event` | 39 | 1015 | Class in `fl/events` |
| `fl/events/DataChangeEvent.as` | `DataChangeEvent` | `Event` | 61 | 1599 | Class in `fl/events` |
| `fl/events/DataChangeType.as` | `DataChangeType` | `-` | 29 | 666 | Class in `fl/events` |
| `fl/events/ListEvent.as` | `ListEvent` | `Event` | 65 | 1726 | Class in `fl/events` |
| `fl/events/ScrollEvent.as` | `ScrollEvent` | `Event` | 51 | 1223 | Class in `fl/events` |

#### Package `fl/managers` (5 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `fl/managers/FocusManager.as` | `FocusManager` | `-` (impl: I, F, o, c, u, s, M, a, n, a, g, e, r) | 787 | 26507 | Class in `fl/managers` |
| `fl/managers/IFocusManager.as` | `IFocusManager` | `-` | 41 | 1085 | Class in `fl/managers` |
| `fl/managers/IFocusManagerComponent.as` | `IFocusManagerComponent` | `-` | 22 | 462 | Class in `fl/managers` |
| `fl/managers/IFocusManagerGroup.as` | `IFocusManagerGroup` | `-` | 16 | 303 | Class in `fl/managers` |
| `fl/managers/StyleManager.as` | `StyleManager` | `-` | 249 | 7818 | Class in `fl/managers` |

#### Package `fl/motion` (4 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `fl/motion/AdjustColor.as` | `AdjustColor` | `-` | 121 | 3686 | Class in `fl/motion` |
| `fl/motion/Color.as` | `Color` | `ColorTransform` | 146 | 5305 | Class in `fl/motion` |
| `fl/motion/ColorMatrix.as` | `ColorMatrix` | `DynamicMatrix` | 166 | 4667 | Class in `fl/motion` |
| `fl/motion/DynamicMatrix.as` | `DynamicMatrix` | `-` | 281 | 8044 | Class in `fl/motion` |

#### Package `fl/transitions` (2 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `fl/transitions/Tween.as` | `Tween` | `EventDispatcher` | 302 | 7852 | Class in `fl/transitions` |
| `fl/transitions/TweenEvent.as` | `TweenEvent` | `Event` | 38 | 1077 | Class in `fl/transitions` |

#### Package `fl/transitions/easing` (1 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `fl/transitions/easing/Strong.as` | `Strong` | `-` | 33 | 1031 | Class in `fl/transitions/easing` |

#### Package `mx/core` (15 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `mx/core/BitmapAsset.as` | `BitmapAsset` | `FlexBitmap` (impl: I, F, l, e, x, A, s, s, e, t, ,,  , I, F, l, e, x, D, i, s, p, l, a, y, O, b, j, e, c, t, ,,  , I, L, a, y, o, u, t, D, i, r, e, c, t, i, o, n, E, l, e, m, e, n, t) | 466 | 13761 | Class in `mx/core` |
| `mx/core/ByteArrayAsset.as` | `ByteArrayAsset` | `ByteArray` (impl: I, F, l, e, x, A, s, s, e, t) | 19 | 341 | Class in `mx/core` |
| `mx/core/FlexBitmap.as` | `FlexBitmap` | `Bitmap` | 33 | 732 | Class in `mx/core` |
| `mx/core/IAssetLayoutFeatures.as` | `IAssetLayoutFeatures` | `-` | 91 | 2420 | Class in `mx/core` |
| `mx/core/IChildList.as` | `IChildList` | `-` | 33 | 908 | Class in `mx/core` |
| `mx/core/IFlexAsset.as` | `IFlexAsset` | `-` | 10 | 85 | Class in `mx/core` |
| `mx/core/IFlexDisplayObject.as` | `IFlexDisplayObject` | `IBitmapDrawable` | 123 | 3457 | Class in `mx/core` |
| `mx/core/IFlexModuleFactory.as` | `IFlexModuleFactory` | `-` | 37 | 1066 | Class in `mx/core` |
| `mx/core/ILayoutDirectionElement.as` | `ILayoutDirectionElement` | `-` | 14 | 265 | Class in `mx/core` |
| `mx/core/IPropertyChangeNotifier.as` | `IPropertyChangeNotifier` | `IEventDispatcher` | 12 | 161 | Class in `mx/core` |
| `mx/core/IRepeaterClient.as` | `IRepeaterClient` | `-` | 24 | 558 | Class in `mx/core` |
| `mx/core/IUIComponent.as` | `IUIComponent` | `IFlexDisplayObject` | 99 | 2831 | Class in `mx/core` |
| `mx/core/IUID.as` | `IUID` | `-` | 12 | 162 | Class in `mx/core` |
| `mx/core/RSLData.as` | `RSLData` | `-` | 86 | 2178 | Class in `mx/core` |
| `mx/core/mx_internal.as` | `mx_internal` | `-` | 6 | 106 | Class in `mx/core` |

#### Package `mx/managers` (1 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `mx/managers/ISystemManager.as` | `ISystemManager` | `IEventDispatcher` | 67 | 1900 | Class in `mx/managers` |

#### Package `mx/utils` (4 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `mx/utils/IXMLNotifiable.as` | `IXMLNotifiable` | `-` | 10 | 197 | Class in `mx/utils` |
| `mx/utils/NameUtil.as` | `NameUtil` | `-` | 96 | 2604 | Class in `mx/utils` |
| `mx/utils/UIDUtil.as` | `UIDUtil` | `-` | 277 | 8361 | Class in `mx/utils` |
| `mx/utils/XMLNotifier.as` | `XMLNotifier` | `-` | 123 | 3386 | Class in `mx/utils` |

#### Package `playerio` (37 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `playerio/Achievement.as` | `Achievement` | `-` | 85 | 1974 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/Achievements.as` | `Achievements` | `playerio.generated.Achievements` | 203 | 7053 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/BigDB.as` | `BigDB` | `playerio.generated.BigDB` | 226 | 8405 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/Client.as` | `Client` | `-` | 179 | 5067 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/Connection.as` | `Connection` | `-` | 436 | 13976 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/DatabaseObject.as` | `DatabaseObject` | `-` | 393 | 11930 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/ErrorLog.as` | `ErrorLog` | `playerio.generated.ErrorLog` | 26 | 847 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/GameFS.as` | `GameFS` | `-` | 95 | 2602 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/GameRequest.as` | `GameRequest` | `-` | 60 | 1308 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/GameRequestSendDialogResult.as` | `GameRequestSendDialogResult` | `-` | 28 | 583 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/GameRequests.as` | `GameRequests` | `playerio.generated.GameRequests` | 128 | 4412 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/Message.as` | `Message` | `-` | 164 | 4703 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/MessageEvent.as` | `MessageEvent` | `Event` | 25 | 508 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/Multiplayer.as` | `Multiplayer` | `playerio.generated.Multiplayer` | 72 | 2776 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/Notification.as` | `Notification` | `-` | 43 | 921 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/NotificationEndpoint.as` | `NotificationEndpoint` | `-` | 52 | 1166 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/Notifications.as` | `Notifications` | `playerio.generated.Notifications` | 237 | 8030 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/OneScore.as` | `OneScore` | `playerio.generated.OneScore` | 126 | 4295 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/OneScoreValue.as` | `OneScoreValue` | `-` | 43 | 904 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/PayVault.as` | `PayVault` | `playerio.generated.PayVault` | 251 | 8012 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/PayVaultHistoryEntry.as` | `PayVaultHistoryEntry` | `-` | 82 | 2290 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/PlayerIO.as` | `PlayerIO` | `playerio.generated.PlayerIO` | 160 | 6757 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/PlayerIOError.as` | `PlayerIOError` | `Error` | 146 | 10401 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/PlayerIORegistrationError.as` | `PlayerIORegistrationError` | `PlayerIOError` | 25 | 637 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/PlayerInsight.as` | `PlayerInsight` | `playerio.generated.PlayerInsight` | 103 | 3312 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/PublishingNetwork.as` | `PublishingNetwork` | `EventDispatcher` | 75 | 2333 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/PublishingNetworkDialog.as` | `PublishingNetworkDialog` | `-` | 177 | 6981 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/PublishingNetworkPayments.as` | `PublishingNetworkPayments` | `-` | 70 | 2563 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/PublishingNetworkProfile.as` | `PublishingNetworkProfile` | `-` | 59 | 1358 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/PublishingNetworkProfiles.as` | `PublishingNetworkProfiles` | `-` | 44 | 1347 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/PublishingNetworkRelations.as` | `PublishingNetworkRelations` | `-` | 177 | 5962 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/QuickConnect.as` | `QuickConnect` | `playerio.generated.QuickConnect` | 282 | 12488 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/RoomInfo.as` | `RoomInfo` | `-` | 71 | 1819 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/Social.as` | `Social` | `-` | 72 | 2226 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/StringForm.as` | `StringForm` | `-` | 96 | 2648 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/UserAchievement.as` | `UserAchievement` | `-` | 29 | 574 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/VaultItem.as` | `VaultItem` | `-` | 109 | 3116 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |

#### Package `playerio/generated` (16 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `playerio/generated/Achievements.as` | `Achievements` | `EventDispatcher` | 231 | 8959 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/BigDB.as` | `BigDB` | `EventDispatcher` | 308 | 11425 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/ErrorLog.as` | `ErrorLog` | `EventDispatcher` | 53 | 1721 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/GameRequests.as` | `GameRequests` | `EventDispatcher` | 128 | 4677 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/LockType.as` | `LockType` | `-` | 19 | 316 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/Multiplayer.as` | `Multiplayer` | `EventDispatcher` | 175 | 6617 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/Notifications.as` | `Notifications` | `EventDispatcher` | 198 | 7741 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/OneScore.as` | `OneScore` | `EventDispatcher` | 159 | 5416 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/PayVault.as` | `PayVault` | `EventDispatcher` | 344 | 13121 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/PlayerIO.as` | `PlayerIO` | `MovieClip` | 82 | 3668 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/PlayerIOError.as` | `PlayerIOError` | `playerio.PlayerIOError` | 206 | 7611 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/PlayerIORegistrationError.as` | `PlayerIORegistrationError` | `playerio.PlayerIORegistrationError` | 15 | 408 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/PlayerInsight.as` | `PlayerInsight` | `EventDispatcher` | 261 | 10102 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/QuickConnect.as` | `QuickConnect` | `EventDispatcher` | 252 | 11466 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/Social.as` | `Social` | `EventDispatcher` | 91 | 3036 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/ValueType.as` | `ValueType` | `-` | 35 | 708 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |

#### Package `playerio/generated/messages` (202 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `playerio/generated/messages/Achievement.as` | `Achievement` | `Message` | 36 | 867 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/AchievementsLoadArgs.as` | `AchievementsLoadArgs` | `Message` | 19 | 382 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/AchievementsLoadError.as` | `AchievementsLoadError` | `Message` | 21 | 423 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/AchievementsLoadOutput.as` | `AchievementsLoadOutput` | `Message` | 20 | 477 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/AchievementsProgressAddArgs.as` | `AchievementsProgressAddArgs` | `Message` | 23 | 558 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/AchievementsProgressAddError.as` | `AchievementsProgressAddError` | `Message` | 21 | 437 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/AchievementsProgressAddOutput.as` | `AchievementsProgressAddOutput` | `Message` | 23 | 565 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/AchievementsProgressCompleteArgs.as` | `AchievementsProgressCompleteArgs` | `Message` | 19 | 421 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/AchievementsProgressCompleteError.as` | `AchievementsProgressCompleteError` | `Message` | 21 | 447 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/AchievementsProgressCompleteOutput.as` | `AchievementsProgressCompleteOutput` | `Message` | 23 | 575 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/AchievementsProgressMaxArgs.as` | `AchievementsProgressMaxArgs` | `Message` | 23 | 543 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/AchievementsProgressMaxError.as` | `AchievementsProgressMaxError` | `Message` | 21 | 437 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/AchievementsProgressMaxOutput.as` | `AchievementsProgressMaxOutput` | `Message` | 23 | 565 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/AchievementsProgressSetArgs.as` | `AchievementsProgressSetArgs` | `Message` | 23 | 543 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/AchievementsProgressSetError.as` | `AchievementsProgressSetError` | `Message` | 21 | 437 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/AchievementsProgressSetOutput.as` | `AchievementsProgressSetOutput` | `Message` | 23 | 565 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/AchievementsRefreshArgs.as` | `AchievementsRefreshArgs` | `Message` | 19 | 397 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/AchievementsRefreshError.as` | `AchievementsRefreshError` | `Message` | 21 | 429 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/AchievementsRefreshOutput.as` | `AchievementsRefreshOutput` | `Message` | 23 | 548 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/ArrayProperty.as` | `ArrayProperty` | `Message` | 23 | 497 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/AuthenticateArgs.as` | `AuthenticateArgs` | `Message` | 47 | 1537 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/AuthenticateError.as` | `AuthenticateError` | `Message` | 21 | 415 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/AuthenticateOutput.as` | `AuthenticateOutput` | `Message` | 58 | 1858 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/AuthenticateStartDialog.as` | `AuthenticateStartDialog` | `Message` | 23 | 531 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/BigDBChangeset.as` | `BigDBChangeset` | `Message` | 32 | 791 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/BigDBObject.as` | `BigDBObject` | `Message` | 29 | 685 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/BigDBObjectId.as` | `BigDBObjectId` | `Message` | 21 | 400 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/ConnectArgs.as` | `ConnectArgs` | `Message` | 49 | 1479 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/ConnectError.as` | `ConnectError` | `Message` | 21 | 405 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/ConnectOutput.as` | `ConnectOutput` | `Message` | 35 | 941 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/CreateJoinRoomArgs.as` | `CreateJoinRoomArgs` | `Message` | 43 | 1276 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/CreateJoinRoomError.as` | `CreateJoinRoomError` | `Message` | 21 | 419 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/CreateJoinRoomOutput.as` | `CreateJoinRoomOutput` | `Message` | 26 | 620 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/CreateObjectsArgs.as` | `CreateObjectsArgs` | `Message` | 25 | 633 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/CreateObjectsError.as` | `CreateObjectsError` | `Message` | 21 | 417 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/CreateObjectsOutput.as` | `CreateObjectsOutput` | `Message` | 20 | 434 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/CreateRoomArgs.as` | `CreateRoomArgs` | `Message` | 37 | 1025 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/CreateRoomError.as` | `CreateRoomError` | `Message` | 21 | 411 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/CreateRoomOutput.as` | `CreateRoomOutput` | `Message` | 18 | 323 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/DeleteIndexRangeArgs.as` | `DeleteIndexRangeArgs` | `Message` | 35 | 1036 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/DeleteIndexRangeError.as` | `DeleteIndexRangeError` | `Message` | 21 | 423 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/DeleteIndexRangeOutput.as` | `DeleteIndexRangeOutput` | `Message` | 15 | 250 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/DeleteObjectsArgs.as` | `DeleteObjectsArgs` | `Message` | 21 | 487 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/DeleteObjectsError.as` | `DeleteObjectsError` | `Message` | 21 | 417 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/DeleteObjectsOutput.as` | `DeleteObjectsOutput` | `Message` | 15 | 244 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/FacebookOAuthConnectArgs.as` | `FacebookOAuthConnectArgs` | `Message` | 41 | 1244 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/FacebookOAuthConnectError.as` | `FacebookOAuthConnectError` | `Message` | 21 | 431 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/FacebookOAuthConnectOutput.as` | `FacebookOAuthConnectOutput` | `Message` | 38 | 1068 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/GameRequestsDeleteArgs.as` | `GameRequestsDeleteArgs` | `Message` | 19 | 395 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/GameRequestsDeleteError.as` | `GameRequestsDeleteError` | `Message` | 21 | 427 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/GameRequestsDeleteOutput.as` | `GameRequestsDeleteOutput` | `Message` | 23 | 573 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/GameRequestsRefreshArgs.as` | `GameRequestsRefreshArgs` | `Message` | 19 | 394 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/GameRequestsRefreshError.as` | `GameRequestsRefreshError` | `Message` | 21 | 429 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/GameRequestsRefreshOutput.as` | `GameRequestsRefreshOutput` | `Message` | 26 | 676 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/GameRequestsSendArgs.as` | `GameRequestsSendArgs` | `Message` | 29 | 814 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/GameRequestsSendError.as` | `GameRequestsSendError` | `Message` | 21 | 423 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/GameRequestsSendOutput.as` | `GameRequestsSendOutput` | `Message` | 15 | 250 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/JoinRoomArgs.as` | `JoinRoomArgs` | `Message` | 29 | 746 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/JoinRoomError.as` | `JoinRoomError` | `Message` | 21 | 407 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/JoinRoomOutput.as` | `JoinRoomOutput` | `Message` | 23 | 523 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/KeyValuePair.as` | `KeyValuePair` | `Message` | 21 | 392 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/KongregateConnectArgs.as` | `KongregateConnectArgs` | `Message` | 41 | 1235 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/KongregateConnectError.as` | `KongregateConnectError` | `Message` | 21 | 425 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/KongregateConnectOutput.as` | `KongregateConnectOutput` | `Message` | 32 | 870 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/ListRoomsArgs.as` | `ListRoomsArgs` | `Message` | 37 | 1072 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/ListRoomsError.as` | `ListRoomsError` | `Message` | 21 | 409 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/ListRoomsOutput.as` | `ListRoomsOutput` | `Message` | 20 | 414 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/LoadIndexRangeArgs.as` | `LoadIndexRangeArgs` | `Message` | 39 | 1155 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/LoadIndexRangeError.as` | `LoadIndexRangeError` | `Message` | 21 | 419 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/LoadIndexRangeOutput.as` | `LoadIndexRangeOutput` | `Message` | 20 | 436 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/LoadMatchingObjectsArgs.as` | `LoadMatchingObjectsArgs` | `Message` | 33 | 880 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/LoadMatchingObjectsError.as` | `LoadMatchingObjectsError` | `Message` | 21 | 429 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/LoadMatchingObjectsOutput.as` | `LoadMatchingObjectsOutput` | `Message` | 20 | 446 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/LoadMyPlayerObjectArgs.as` | `LoadMyPlayerObjectArgs` | `Message` | 15 | 250 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/LoadMyPlayerObjectError.as` | `LoadMyPlayerObjectError` | `Message` | 21 | 427 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/LoadMyPlayerObjectOutput.as` | `LoadMyPlayerObjectOutput` | `Message` | 20 | 460 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/LoadObjectsArgs.as` | `LoadObjectsArgs` | `Message` | 21 | 483 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/LoadObjectsError.as` | `LoadObjectsError` | `Message` | 21 | 413 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/LoadObjectsOutput.as` | `LoadObjectsOutput` | `Message` | 20 | 430 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/NewBigDBObject.as` | `NewBigDBObject` | `Message` | 26 | 601 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/Notification.as` | `Notification` | `Message` | 31 | 821 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/NotificationsDeleteEndpointsArgs.as` | `NotificationsDeleteEndpointsArgs` | `Message` | 25 | 684 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/NotificationsDeleteEndpointsError.as` | `NotificationsDeleteEndpointsError` | `Message` | 21 | 447 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/NotificationsDeleteEndpointsOutput.as` | `NotificationsDeleteEndpointsOutput` | `Message` | 23 | 577 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/NotificationsEndpoint.as` | `NotificationsEndpoint` | `Message` | 29 | 720 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/NotificationsEndpointId.as` | `NotificationsEndpointId` | `Message` | 21 | 426 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/NotificationsRefreshArgs.as` | `NotificationsRefreshArgs` | `Message` | 19 | 399 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/NotificationsRefreshError.as` | `NotificationsRefreshError` | `Message` | 21 | 431 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/NotificationsRefreshOutput.as` | `NotificationsRefreshOutput` | `Message` | 23 | 561 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/NotificationsRegisterEndpointsArgs.as` | `NotificationsRegisterEndpointsArgs` | `Message` | 25 | 684 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/NotificationsRegisterEndpointsError.as` | `NotificationsRegisterEndpointsError` | `Message` | 21 | 451 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/NotificationsRegisterEndpointsOutput.as` | `NotificationsRegisterEndpointsOutput` | `Message` | 23 | 581 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/NotificationsSendArgs.as` | `NotificationsSendArgs` | `Message` | 21 | 509 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/NotificationsSendError.as` | `NotificationsSendError` | `Message` | 21 | 425 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/NotificationsSendOutput.as` | `NotificationsSendOutput` | `Message` | 15 | 252 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/NotificationsToggleEndpointsArgs.as` | `NotificationsToggleEndpointsArgs` | `Message` | 29 | 821 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/NotificationsToggleEndpointsError.as` | `NotificationsToggleEndpointsError` | `Message` | 21 | 447 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/NotificationsToggleEndpointsOutput.as` | `NotificationsToggleEndpointsOutput` | `Message` | 23 | 577 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/ObjectProperty.as` | `ObjectProperty` | `Message` | 23 | 500 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/OneScoreAddArgs.as` | `OneScoreAddArgs` | `Message` | 19 | 357 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/OneScoreAddError.as` | `OneScoreAddError` | `Message` | 21 | 413 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/OneScoreAddOutput.as` | `OneScoreAddOutput` | `Message` | 20 | 440 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/OneScoreLoadArgs.as` | `OneScoreLoadArgs` | `Message` | 19 | 374 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/OneScoreLoadError.as` | `OneScoreLoadError` | `Message` | 21 | 415 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/OneScoreLoadOutput.as` | `OneScoreLoadOutput` | `Message` | 20 | 442 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/OneScoreRefreshArgs.as` | `OneScoreRefreshArgs` | `Message` | 15 | 244 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/OneScoreRefreshError.as` | `OneScoreRefreshError` | `Message` | 21 | 421 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/OneScoreRefreshOutput.as` | `OneScoreRefreshOutput` | `Message` | 20 | 448 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/OneScoreSetArgs.as` | `OneScoreSetArgs` | `Message` | 19 | 357 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/OneScoreSetError.as` | `OneScoreSetError` | `Message` | 21 | 413 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/OneScoreSetOutput.as` | `OneScoreSetOutput` | `Message` | 20 | 440 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/OneScoreValue.as` | `OneScoreValue` | `Message` | 27 | 574 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultBuyArgs.as` | `PayVaultBuyArgs` | `Message` | 29 | 775 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultBuyError.as` | `PayVaultBuyError` | `Message` | 21 | 413 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultBuyItemInfo.as` | `PayVaultBuyItemInfo` | `Message` | 23 | 527 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultBuyOutput.as` | `PayVaultBuyOutput` | `Message` | 20 | 464 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultConsumeArgs.as` | `PayVaultConsumeArgs` | `Message` | 23 | 518 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultConsumeError.as` | `PayVaultConsumeError` | `Message` | 21 | 421 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultConsumeOutput.as` | `PayVaultConsumeOutput` | `Message` | 20 | 472 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultContents.as` | `PayVaultContents` | `Message` | 26 | 591 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultCreditArgs.as` | `PayVaultCreditArgs` | `Message` | 27 | 651 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultCreditError.as` | `PayVaultCreditError` | `Message` | 21 | 419 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultCreditOutput.as` | `PayVaultCreditOutput` | `Message` | 20 | 470 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultDebitArgs.as` | `PayVaultDebitArgs` | `Message` | 27 | 649 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultDebitError.as` | `PayVaultDebitError` | `Message` | 21 | 417 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultDebitOutput.as` | `PayVaultDebitOutput` | `Message` | 20 | 468 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultGiveArgs.as` | `PayVaultGiveArgs` | `Message` | 25 | 631 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultGiveError.as` | `PayVaultGiveError` | `Message` | 21 | 415 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultGiveOutput.as` | `PayVaultGiveOutput` | `Message` | 20 | 466 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultHistoryEntry.as` | `PayVaultHistoryEntry` | `Message` | 36 | 892 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultItem.as` | `PayVaultItem` | `Message` | 29 | 696 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultPaymentInfoArgs.as` | `PayVaultPaymentInfoArgs` | `Message` | 31 | 912 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultPaymentInfoError.as` | `PayVaultPaymentInfoError` | `Message` | 21 | 429 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultPaymentInfoOutput.as` | `PayVaultPaymentInfoOutput` | `Message` | 20 | 478 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultReadHistoryArgs.as` | `PayVaultReadHistoryArgs` | `Message` | 27 | 658 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultReadHistoryError.as` | `PayVaultReadHistoryError` | `Message` | 21 | 429 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultReadHistoryOutput.as` | `PayVaultReadHistoryOutput` | `Message` | 20 | 464 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultRefreshArgs.as` | `PayVaultRefreshArgs` | `Message` | 23 | 539 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultRefreshError.as` | `PayVaultRefreshError` | `Message` | 21 | 421 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultRefreshOutput.as` | `PayVaultRefreshOutput` | `Message` | 20 | 472 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultUsePaymentInfoArgs.as` | `PayVaultUsePaymentInfoArgs` | `Message` | 25 | 673 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultUsePaymentInfoError.as` | `PayVaultUsePaymentInfoError` | `Message` | 21 | 435 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PayVaultUsePaymentInfoOutput.as` | `PayVaultUsePaymentInfoOutput` | `Message` | 25 | 702 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PlayerInsightEvent.as` | `PlayerInsightEvent` | `Message` | 21 | 413 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PlayerInsightRefreshArgs.as` | `PlayerInsightRefreshArgs` | `Message` | 15 | 254 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PlayerInsightRefreshError.as` | `PlayerInsightRefreshError` | `Message` | 21 | 431 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PlayerInsightRefreshOutput.as` | `PlayerInsightRefreshOutput` | `Message` | 20 | 464 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PlayerInsightSessionKeepAliveArgs.as` | `PlayerInsightSessionKeepAliveArgs` | `Message` | 15 | 272 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PlayerInsightSessionKeepAliveError.as` | `PlayerInsightSessionKeepAliveError` | `Message` | 21 | 449 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PlayerInsightSessionKeepAliveOutput.as` | `PlayerInsightSessionKeepAliveOutput` | `Message` | 15 | 276 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PlayerInsightSessionStopArgs.as` | `PlayerInsightSessionStopArgs` | `Message` | 15 | 262 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PlayerInsightSessionStopError.as` | `PlayerInsightSessionStopError` | `Message` | 21 | 439 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PlayerInsightSessionStopOutput.as` | `PlayerInsightSessionStopOutput` | `Message` | 15 | 266 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PlayerInsightSetSegmentsArgs.as` | `PlayerInsightSetSegmentsArgs` | `Message` | 19 | 401 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PlayerInsightSetSegmentsError.as` | `PlayerInsightSetSegmentsError` | `Message` | 21 | 439 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PlayerInsightSetSegmentsOutput.as` | `PlayerInsightSetSegmentsOutput` | `Message` | 20 | 472 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PlayerInsightState.as` | `PlayerInsightState` | `Message` | 23 | 533 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PlayerInsightTrackEventsArgs.as` | `PlayerInsightTrackEventsArgs` | `Message` | 21 | 507 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PlayerInsightTrackEventsError.as` | `PlayerInsightTrackEventsError` | `Message` | 21 | 439 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PlayerInsightTrackEventsOutput.as` | `PlayerInsightTrackEventsOutput` | `Message` | 15 | 266 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PlayerInsightTrackExternalPaymentArgs.as` | `PlayerInsightTrackExternalPaymentArgs` | `Message` | 23 | 542 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PlayerInsightTrackExternalPaymentError.as` | `PlayerInsightTrackExternalPaymentError` | `Message` | 21 | 457 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PlayerInsightTrackExternalPaymentOutput.as` | `PlayerInsightTrackExternalPaymentOutput` | `Message` | 15 | 284 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PlayerInsightTrackInvitedByArgs.as` | `PlayerInsightTrackInvitedByArgs` | `Message` | 23 | 587 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PlayerInsightTrackInvitedByError.as` | `PlayerInsightTrackInvitedByError` | `Message` | 21 | 445 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/PlayerInsightTrackInvitedByOutput.as` | `PlayerInsightTrackInvitedByOutput` | `Message` | 15 | 272 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/RoomInfo.as` | `RoomInfo` | `Message` | 29 | 675 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SaveObjectChangesArgs.as` | `SaveObjectChangesArgs` | `Message` | 29 | 795 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SaveObjectChangesError.as` | `SaveObjectChangesError` | `Message` | 21 | 425 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SaveObjectChangesOutput.as` | `SaveObjectChangesOutput` | `Message` | 18 | 345 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/ServerEndpoint.as` | `ServerEndpoint` | `Message` | 21 | 399 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SimpleConnectArgs.as` | `SimpleConnectArgs` | `Message` | 41 | 1239 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SimpleConnectError.as` | `SimpleConnectError` | `Message` | 21 | 417 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SimpleConnectOutput.as` | `SimpleConnectOutput` | `Message` | 35 | 953 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SimpleGetCaptchaArgs.as` | `SimpleGetCaptchaArgs` | `Message` | 27 | 625 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SimpleGetCaptchaError.as` | `SimpleGetCaptchaError` | `Message` | 21 | 423 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SimpleGetCaptchaOutput.as` | `SimpleGetCaptchaOutput` | `Message` | 21 | 446 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SimpleRecoverPasswordArgs.as` | `SimpleRecoverPasswordArgs` | `Message` | 23 | 545 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SimpleRecoverPasswordError.as` | `SimpleRecoverPasswordError` | `Message` | 21 | 433 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SimpleRecoverPasswordOutput.as` | `SimpleRecoverPasswordOutput` | `Message` | 15 | 260 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SimpleRegisterArgs.as` | `SimpleRegisterArgs` | `Message` | 63 | 2037 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SimpleRegisterError.as` | `SimpleRegisterError` | `Message` | 33 | 807 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SimpleRegisterOutput.as` | `SimpleRegisterOutput` | `Message` | 35 | 955 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SimpleUserGetSecureLoginInfoArgs.as` | `SimpleUserGetSecureLoginInfoArgs` | `Message` | 15 | 270 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SimpleUserGetSecureLoginInfoError.as` | `SimpleUserGetSecureLoginInfoError` | `Message` | 21 | 447 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SimpleUserGetSecureLoginInfoOutput.as` | `SimpleUserGetSecureLoginInfoOutput` | `Message` | 22 | 486 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SocialLoadProfilesArgs.as` | `SocialLoadProfilesArgs` | `Message` | 19 | 386 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SocialLoadProfilesError.as` | `SocialLoadProfilesError` | `Message` | 21 | 427 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SocialLoadProfilesOutput.as` | `SocialLoadProfilesOutput` | `Message` | 20 | 451 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SocialProfile.as` | `SocialProfile` | `Message` | 33 | 782 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SocialRefreshArgs.as` | `SocialRefreshArgs` | `Message` | 15 | 240 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SocialRefreshError.as` | `SocialRefreshError` | `Message` | 21 | 417 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SocialRefreshOutput.as` | `SocialRefreshOutput` | `Message` | 28 | 732 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SteamConnectArgs.as` | `SteamConnectArgs` | `Message` | 41 | 1252 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SteamConnectError.as` | `SteamConnectError` | `Message` | 21 | 415 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/SteamConnectOutput.as` | `SteamConnectOutput` | `Message` | 35 | 951 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/UserAchievements.as` | `UserAchievements` | `Message` | 23 | 528 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/ValueObject.as` | `ValueObject` | `Message` | 56 | 1555 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/WaitingGameRequest.as` | `WaitingGameRequest` | `Message` | 32 | 767 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/WriteErrorArgs.as` | `WriteErrorArgs` | `Message` | 37 | 1019 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/WriteErrorError.as` | `WriteErrorError` | `Message` | 21 | 411 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/generated/messages/WriteErrorOutput.as` | `WriteErrorOutput` | `Message` | 15 | 238 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |

#### Package `playerio/helpers` (1 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `playerio/helpers/FieldToBeRemoved.as` | `FieldToBeRemoved` | `-` | 18 | 275 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |

#### Package `playerio/utils` (5 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `playerio/utils/BinarySerializer.as` | `BinarySerializer` | `EventDispatcher` | 443 | 13305 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/utils/Converter.as` | `Converter` | `-` | 440 | 14418 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/utils/HTTPChannel.as` | `HTTPChannel` | `-` | 127 | 3711 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/utils/SWFReader.as` | `SWFReader` | `-` | 463 | 14145 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |
| `playerio/utils/Utilities.as` | `Utilities` | `-` | 85 | 2219 | PlayerIO Client SDK & Protobuf RPC / Multiplayer / BigDB / PayVault implementation |

#### Package `starling` (1 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `starling/MainStarlingStage.as` | `MainStarlingStage` | `starling.display.Sprite` | 3111 | 169131 | Starling root DisplayObjectContainer; manages `c_mc`, touch/click routing for all Starling menus/buttons, and character creation submit |

#### Package `starling/animation` (5 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `starling/animation/DelayedCall.as` | `DelayedCall` | `EventDispatcher` (impl: I, A, n, i, m, a, t, a, b, l, e) | 134 | 3745 | Class in `starling/animation` |
| `starling/animation/IAnimatable.as` | `IAnimatable` | `-` | 10 | 140 | Class in `starling/animation` |
| `starling/animation/Juggler.as` | `Juggler` | `-` (impl: I, A, n, i, m, a, t, a, b, l, e) | 322 | 9794 | Class in `starling/animation` |
| `starling/animation/Transitions.as` | `Transitions` | `-` | 231 | 7340 | Class in `starling/animation` |
| `starling/animation/Tween.as` | `Tween` | `EventDispatcher` (impl: I, A, n, i, m, a, t, a, b, l, e) | 565 | 16201 | Class in `starling/animation` |

#### Package `starling/core` (3 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `starling/core/Starling.as` | `Starling` | `starling.events.EventDispatcher` | 913 | 30510 | Class in `starling/core` |
| `starling/core/StatsDisplay.as` | `StatsDisplay` | `-` | 180 | 5749 | Class in `starling/core` |
| `starling/core/starling_internal.as` | `starling_internal` | `-` | 6 | 71 | Class in `starling/core` |

#### Package `starling/display` (14 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `starling/display/BlendMode.as` | `BlendMode` | `-` | 111 | 3343 | Class in `starling/display` |
| `starling/display/Button.as` | `Button` | `DisplayObjectContainer` | 508 | 15162 | Class in `starling/display` |
| `starling/display/ButtonState.as` | `ButtonState` | `-` | 24 | 466 | Class in `starling/display` |
| `starling/display/Canvas.as` | `Canvas` | `DisplayObjectContainer` | 103 | 2975 | Class in `starling/display` |
| `starling/display/DisplayObject.as` | `DisplayObject` | `EventDispatcher` | 993 | 29639 | Class in `starling/display` |
| `starling/display/DisplayObjectContainer.as` | `DisplayObjectContainer` | `DisplayObject` | 497 | 16020 | Class in `starling/display` |
| `starling/display/Image.as` | `Image` | `Quad` | 416 | 14979 | Class in `starling/display` |
| `starling/display/Mesh.as` | `Mesh` | `DisplayObject` | 246 | 6635 | Class in `starling/display` |
| `starling/display/MeshBatch.as` | `MeshBatch` | `Mesh` | 223 | 6496 | Class in `starling/display` |
| `starling/display/MovieClip.as` | `MovieClip` | `Image` (impl: I, A, n, i, m, a, t, a, b, l, e) | 565 | 16489 | Class in `starling/display` |
| `starling/display/Quad.as` | `Quad` | `Mesh` | 155 | 4947 | Class in `starling/display` |
| `starling/display/Sprite.as` | `Sprite` | `DisplayObjectContainer` | 13 | 178 | Class in `starling/display` |
| `starling/display/Sprite3D.as` | `Sprite3D` | `DisplayObjectContainer` | 320 | 9675 | Class in `starling/display` |
| `starling/display/Stage.as` | `Stage` | `starling.display.DisplayObjectContainer` | 276 | 8619 | Class in `starling/display` |

#### Package `starling/errors` (4 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `starling/errors/AbstractClassError.as` | `AbstractClassError` | `Error` | 13 | 257 | Class in `starling/errors` |
| `starling/errors/AbstractMethodError.as` | `AbstractMethodError` | `Error` | 13 | 268 | Class in `starling/errors` |
| `starling/errors/MissingContextError.as` | `MissingContextError` | `Error` | 13 | 253 | Class in `starling/errors` |
| `starling/errors/NotSupportedError.as` | `NotSupportedError` | `Error` | 13 | 222 | Class in `starling/errors` |

#### Package `starling/events` (10 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `starling/events/EnterFrameEvent.as` | `EnterFrameEvent` | `Event` | 20 | 428 | Class in `starling/events` |
| `starling/events/Event.as` | `Event` | `-` | 178 | 5149 | Class in `starling/events` |
| `starling/events/EventDispatcher.as` | `EventDispatcher` | `-` | 205 | 5949 | Class in `starling/events` |
| `starling/events/KeyboardEvent.as` | `KeyboardEvent` | `Event` | 77 | 1854 | Class in `starling/events` |
| `starling/events/ResizeEvent.as` | `ResizeEvent` | `Event` | 27 | 567 | Class in `starling/events` |
| `starling/events/Touch.as` | `Touch` | `-` | 266 | 7051 | Class in `starling/events` |
| `starling/events/TouchEvent.as` | `TouchEvent` | `Event` | 171 | 5032 | Class in `starling/events` |
| `starling/events/TouchMarker.as` | `TouchMarker` | `-` | 112 | 3253 | Class in `starling/events` |
| `starling/events/TouchPhase.as` | `TouchPhase` | `-` | 30 | 680 | Class in `starling/events` |
| `starling/events/TouchProcessor.as` | `TouchProcessor` | `-` | 458 | 15069 | Class in `starling/events` |

#### Package `starling/extensions/lighting` (4 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `starling/extensions/lighting/LightEffect.as` | `LightEffect` | `MeshEffect` | 236 | 9054 | Class in `starling/extensions/lighting` |
| `starling/extensions/lighting/LightSource.as` | `LightSource` | `Sprite3D` | 274 | 8242 | Class in `starling/extensions/lighting` |
| `starling/extensions/lighting/LightSource_LightBulbAtlas.as` | `LightSource_LightBulbAtlas` | `BitmapAsset` | 16 | 352 | Class in `starling/extensions/lighting` |
| `starling/extensions/lighting/LightStyle.as` | `LightStyle` | `MeshStyle` | 442 | 14233 | Class in `starling/extensions/lighting` |

#### Package `starling/filters` (9 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `starling/filters/BlurFilter.as` | `BlurFilter` | `FragmentFilter` | 234 | 7567 | Class in `starling/filters` |
| `starling/filters/ColorMatrixFilter.as` | `ColorMatrixFilter` | `FragmentFilter` | 217 | 8107 | Class in `starling/filters` |
| `starling/filters/CompositeFilter.as` | `CompositeFilter` | `FragmentFilter` | 308 | 9429 | Class in `starling/filters` |
| `starling/filters/DisplacementMapFilter.as` | `DisplacementMapFilter` | `FragmentFilter` | 363 | 10074 | Class in `starling/filters` |
| `starling/filters/FilterChain.as` | `FilterChain` | `FragmentFilter` | 180 | 5276 | Class in `starling/filters` |
| `starling/filters/FilterHelper.as` | `FilterHelper` | `-` | 231 | 6789 | Class in `starling/filters` |
| `starling/filters/FragmentFilter.as` | `FragmentFilter` | `EventDispatcher` | 518 | 15702 | Class in `starling/filters` |
| `starling/filters/GlowFilter.as` | `GlowFilter` | `FragmentFilter` | 106 | 3018 | Class in `starling/filters` |
| `starling/filters/IFilterHelper.as` | `IFilterHelper` | `-` | 20 | 434 | Class in `starling/filters` |

#### Package `starling/geom` (1 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `starling/geom/Polygon.as` | `Polygon` | `-` | 608 | 19214 | Class in `starling/geom` |

#### Package `starling/rendering` (13 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `starling/rendering/BatchProcessor.as` | `BatchProcessor` | `-` | 230 | 6682 | Class in `starling/rendering` |
| `starling/rendering/BatchToken.as` | `BatchToken` | `-` | 51 | 1343 | Class in `starling/rendering` |
| `starling/rendering/Effect.as` | `Effect` | `-` | 256 | 7438 | Class in `starling/rendering` |
| `starling/rendering/FilterEffect.as` | `FilterEffect` | `Effect` | 109 | 3191 | Class in `starling/rendering` |
| `starling/rendering/IndexData.as` | `IndexData` | `-` | 479 | 14369 | Class in `starling/rendering` |
| `starling/rendering/MeshEffect.as` | `MeshEffect` | `FilterEffect` | 97 | 2972 | Class in `starling/rendering` |
| `starling/rendering/MeshStyle.as` | `MeshStyle` | `EventDispatcher` | 287 | 8384 | Class in `starling/rendering` |
| `starling/rendering/Painter.as` | `Painter` | `-` | 687 | 21850 | Class in `starling/rendering` |
| `starling/rendering/Program.as` | `Program` | `-` | 74 | 2151 | Class in `starling/rendering` |
| `starling/rendering/RenderState.as` | `RenderState` | `-` | 319 | 9580 | Class in `starling/rendering` |
| `starling/rendering/VertexData.as` | `VertexData` | `-` | 1060 | 37717 | Class in `starling/rendering` |
| `starling/rendering/VertexDataAttribute.as` | `VertexDataAttribute` | `-` | 40 | 1034 | Class in `starling/rendering` |
| `starling/rendering/VertexDataFormat.as` | `VertexDataFormat` | `-` | 198 | 5685 | Class in `starling/rendering` |

#### Package `starling/styles` (1 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `starling/styles/MeshStyle.as` | `MeshStyle` | `EventDispatcher` | 323 | 9777 | Class in `starling/styles` |

#### Package `starling/text` (9 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `starling/text/BitmapChar.as` | `BitmapChar` | `-` | 93 | 2134 | Class in `starling/text` |
| `starling/text/BitmapFont.as` | `BitmapFont` | `-` (impl: I, T, e, x, t, C, o, m, p, o, s, i, t, o, r) | 562 | 18390 | Class in `starling/text` |
| `starling/text/ITextCompositor.as` | `ITextCompositor` | `-` | 14 | 344 | Class in `starling/text` |
| `starling/text/MiniBitmapFont.as` | `MiniBitmapFont` | `-` | 269 | 24817 | Class in `starling/text` |
| `starling/text/TextField.as` | `TextField` | `DisplayObjectContainer` | 452 | 13702 | Class in `starling/text` |
| `starling/text/TextFieldAutoSize.as` | `TextFieldAutoSize` | `-` | 24 | 512 | Class in `starling/text` |
| `starling/text/TextFormat.as` | `TextFormat` | `EventDispatcher` | 242 | 6509 | Class in `starling/text` |
| `starling/text/TextOptions.as` | `TextOptions` | `-` | 97 | 2432 | Class in `starling/text` |
| `starling/text/TrueTypeCompositor.as` | `TrueTypeCompositor` | `-` | 243 | 7981 | Class in `starling/text` |

#### Package `starling/textures` (11 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `starling/textures/AtfData.as` | `AtfData` | `-` | 114 | 2858 | Class in `starling/textures` |
| `starling/textures/ConcretePotTexture.as` | `ConcretePotTexture` | `-` | 122 | 4215 | Class in `starling/textures` |
| `starling/textures/ConcreteRectangleTexture.as` | `ConcreteRectangleTexture` | `-` | 33 | 1020 | Class in `starling/textures` |
| `starling/textures/ConcreteTexture.as` | `ConcreteTexture` | `Texture` | 220 | 6025 | Class in `starling/textures` |
| `starling/textures/ConcreteVideoTexture.as` | `ConcreteVideoTexture` | `-` | 72 | 2088 | Class in `starling/textures` |
| `starling/textures/RenderTexture.as` | `RenderTexture` | `SubTexture` | 229 | 7504 | Class in `starling/textures` |
| `starling/textures/SubTexture.as` | `SubTexture` | `Texture` | 208 | 5762 | Class in `starling/textures` |
| `starling/textures/Texture.as` | `Texture` | `-` | 468 | 17509 | Class in `starling/textures` |
| `starling/textures/TextureAtlas.as` | `TextureAtlas` | `-` | 168 | 5397 | Class in `starling/textures` |
| `starling/textures/TextureOptions.as` | `TextureOptions` | `-` | 114 | 3075 | Class in `starling/textures` |
| `starling/textures/TextureSmoothing.as` | `TextureSmoothing` | `-` | 27 | 601 | Class in `starling/textures` |

#### Package `starling/utils` (17 files)
| File Path (`scripts/...`) | Class / Interface | Extends | Lines | Bytes | Role / Description |
|---|---|---|---:|---:|---|
| `starling/utils/Align.as` | `Align` | `-` | 41 | 1057 | Class in `starling/utils` |
| `starling/utils/AssetManager.as` | `AssetManager` | `starling.events.EventDispatcher` | 1228 | 41206 | Class in `starling/utils` |
| `starling/utils/Color.as` | `Color` | `-` | 133 | 3966 | Class in `starling/utils` |
| `starling/utils/MathUtil.as` | `MathUtil` | `-` | 103 | 3395 | Class in `starling/utils` |
| `starling/utils/MatrixUtil.as` | `MatrixUtil` | `-` | 295 | 11850 | Class in `starling/utils` |
| `starling/utils/MeshSubset.as` | `MeshSubset` | `-` | 30 | 700 | Class in `starling/utils` |
| `starling/utils/MeshUtil.as` | `MeshUtil` | `-` | 75 | 2382 | Class in `starling/utils` |
| `starling/utils/Padding.as` | `Padding` | `EventDispatcher` | 110 | 2688 | Class in `starling/utils` |
| `starling/utils/Pool.as` | `Pool` | `-` | 133 | 3728 | Class in `starling/utils` |
| `starling/utils/RectangleUtil.as` | `RectangleUtil` | `-` | 258 | 8298 | Class in `starling/utils` |
| `starling/utils/RenderUtil.as` | `RenderUtil` | `-` | 217 | 7276 | Class in `starling/utils` |
| `starling/utils/ScaleMode.as` | `ScaleMode` | `-` | 27 | 582 | Class in `starling/utils` |
| `starling/utils/StringUtil.as` | `StringUtil` | `-` | 88 | 2132 | Class in `starling/utils` |
| `starling/utils/SystemUtil.as` | `SystemUtil` | `-` | 145 | 3951 | Class in `starling/utils` |
| `starling/utils/deg2rad.as` | `deg2rad` | `-` | 9 | 134 | Class in `starling/utils` |
| `starling/utils/execute.as` | `execute` | `-` | 49 | 1294 | Class in `starling/utils` |
| `starling/utils/rad2deg.as` | `rad2deg` | `-` | 9 | 134 | Class in `starling/utils` |

### 2.4 Third-Party Library Packages Summary (290 Files)
- **`starling.*`** (`108 files`): Starling Framework 2.x (`starling.core`, `starling.display`, `starling.textures`, `starling.rendering`, `starling.filters`, `starling.events`, `starling.text`, `starling.utils`, `starling.animation`, `starling.geom`, `starling.styles`, `starling.extensions.lighting` + `PDParticleSystem`).
- **`feathers.*`** (`127 files`): Feathers UI library (`feathers.controls`, `feathers.core`, `feathers.layout`, `feathers.skins`, `feathers.data`, `feathers.events`, `feathers.system`, `feathers.utils`, `feathers.dragDrop`, `feathers.motion`) used for scrollable text inputs (`StageTextTextEditor`, `TextInput`, `ScrollText`) in Starling menus.
- **`com.greensock.*`** (`39 files`): GreenSock TweenMax / TweenLite animation library (`TweenMax`, `TweenLite`, easing equations, plugins).
- **`fl.*` & `mx.*`** (`17 files`): Adobe Flash UI components (`ColorPicker` in `BullhornMenu`, `motion.Color`).
- **`com.adobe.*`** (`5 files`): `AGALMiniAssembler` and `MD5`.
- **`com.netease.protobuf.*`** (`15 files`): ActionScript 3 Protocol Buffers runtime used by `bridge.*` (PlayerIO SDK) and ` IDI` (Y8 SDK).
- **`com.newgrounds.*`** (`20 files`): Newgrounds API (`API`, `Medal`, `ScoreBoard`, `SaveFile`, etc.).
- **`de.polygonal.ds.*`** (`3 files`): Polygonal Data Structures (`BitVector`) used by `BitBitmapData` for 1-bit collision masks.

---

## 3. Complete Network Protocol (`addMessageHandler` & `send`)

### 3.1 Incoming Server -> Client Messages (`connection.addMessageHandler`)
There are **101 unique game message handlers** registered on `theConnection` (plus 2 internal PlayerIO room join handlers in `Multiplayer.as`).
Almost all handlers are registered in `GameMain.handleJoin` (`GameMain.as:L858-928`), with conditional/dynamic registrations in `changeLevel` (`pSaved`), `debugCommand` (`debugSGot`, `gotRoomInfo`), `guildNameCheckLoaded` (`guildCre`), `ItemMenu` (`boughtVItem`, `tryBankItemDep`), and level-specific handlers (`newLotto` on level 83, `roboInv`/`endRoboInv` on level 30, `slotDone`/`iSlotDone` on level 33).

> **Note on `Message` Parameter Indexing**: In PlayerIO's ActionScript callback dispatch, the first parameter of every handler callback is `param1:playerio.Message`, and `param2, param3, ...` are automatically unpacked from `Message` indices `0, 1, ...` in exact order. Two handlers (`petsSummonedForward` and `EnemyAI.syncGot`) read `param1:Message` directly via `param1.getString(...)` / `param1.getInt(...)`.

| # | Message Type | Handler Method | File & Line | Exact Ordered Arguments (after `param1:Message`) & Semantic Meaning |
|---:|---|---|---|---|
| 1 | `"pJoin"` | `playerJoined` | `GameMain.as:L799` | `1. param2:Number` -> `serverVersion` |
| 2 | `"PIn"` | `personInfoGot` | `GameMain.as:L800` | `1. param2:String`, `2. param3:int`, `3. param4:int` |
| 3 | `"newP"` | `singlePersonInfoGot` | `GameMain.as:L801` | `1. param2:String` -> `var _loc37_:Person`, `2. param3:int` -> `var _loc37_:Person`, `3. param4:int` -> `var _loc37_:Person`, `4. param5:int` -> `var _loc37_:Person`, `5. param6:int` -> `var _loc37_:Person`, `6. param7:int` -> `var _loc37_:Person`, `7. param8:int` -> `var _loc37_:Person`, `8. param9:int` -> `var _loc37_:Person`, `9. param10:int` -> `var _loc36_:String`, `10. param11:int` -> `var _loc37_:Person`, `11. param12:int` -> `var _loc37_:Person`, `12. param13:int` -> `var _loc37_:Person`, `13. param14:int` -> `var _loc37_:Person`, `14. param15:int` -> `var _loc37_:Person`, `15. param16:int` -> `var _loc37_:Person`, `16. param17:int` -> `var _loc37_:Person`, `17. param18:int` -> `var _loc37_:Person`, `18. param19:int` -> `var _loc37_:Person`, `19. param20:int` -> `var _loc37_:Person`, `20. param21:int` -> `var _loc37_:Person`, `21. param22:int` -> `var _loc37_:Person`, `22. param23:int` -> `var _loc37_:Person`, `23. param24:Boolean` -> `_loc37_.bodyAnimator.hasHalo`, `24. param25:String` -> `_loc37_.guild`, `25. param26:int` -> `_loc37_.moveDir`, `26. param27:Boolean`, `27. param28:Boolean`, `28. param29:int` -> `_loc37_.shieldMasteryLvl`, `29. param30:Boolean`, `30. param31:int` -> `var _loc37_:Person`, `31. param32:int` -> `var _loc37_:Person`, `32. param33:uint` -> `_loc37_.fishingLvl`, `33. param34:int`, `34. param35:String` -> `_loc37_.role` |
| 4 | `"newPM"` | `personMiscInfoGot` | `GameMain.as:L802` | `1. param2:String`, `2. param3:int` -> `_loc19_.jumpSkillLvl`, `3. param4:int` -> `_loc19_.bulletDistanceLvl`, `4. param5:int` -> `_loc19_.magicShotsLvl`, `5. param6:int` -> `_loc19_.magicDistanceLvl`, `6. param7:int` -> `_loc19_.upwardShootLvl`, `7. param8:int` -> `_loc19_.piercingArrowLvl`, `8. param9:int` -> `_loc19_.thunderAttackLvl`, `9. param10:int` -> `_loc19_.grenadeLvl`, `10. param11:int` -> `_loc19_.tripleShotLvl`, `11. param12:int` -> `_loc19_.lightBeamLvl`, `12. param13:int` -> `_loc19_.shotgunLvl`, `13. param14:int` -> `_loc19_.arrowRainLvl`, `14. param15:Boolean` -> `_loc19_.hasBaitExtend`, `15. param16:int` -> `_loc19_.barrageLvl`, `16. param17:Boolean` -> `_loc19_.gravityObject.maxJumps`, `17. param18:int` -> `_loc19_.dashLvl` |
| 5 | `"friendOnline"` | `friendOnlineGot` | `GameMain.as:L803` | `1. param2:String` |
| 6 | `"guildMemberOnline"` | `guildMemberOnlineGot` | `GameMain.as:L804` | `1. param2:String` |
| 7 | `"petIn"` | `singlePetInfoGot` | `GameMain.as:L805` | `1. param2:String` -> `_loc19_`, `2. param3:String` -> `_loc19_`, `3. param4:String` -> `_loc19_`, `4. param5:int` -> `_loc19_.x`, `5. param6:int` -> `_loc19_.y`, `6. param7:int` -> `_loc19_`, `7. param8:int` -> `_loc19_.lvl`, `8. param9:int` -> `_loc19_`, `9. param10:int` -> `_loc19_`, `10. param11:int` -> `_loc19_`, `11. param12:int` -> `_loc19_`, `12. param13:int` -> `_loc19_`, `13. param14:String` -> `_loc19_`, `14. param15:int` -> `_loc19_.gravityObject.counter`, `15. param16:int`, `16. param17:int` -> `_loc19_.shoes_uint`, `17. param18:Boolean` |
| 8 | `"orb"` | `newOrbGot` | `GameMain.as:L806` | `1. param2:String`, `2. param3:String`, `3. param4:int`, `4. param5:int`, `5. param6:String`, `6. param7:Boolean` |
| 9 | `"UserL"` | `personDisconnect` | `GameMain.as:L807` | `1. param2:String` |
| 10 | `"newE"` | `newEnemyCreatedGot` | `GameMain.as:L808` | `1. param2:String` -> `var _enemyType:String`, `2. param3:String` -> `var _enemyName:String`, `3. param4:int` -> `var _enemyX:int`, `4. param5:int` -> `var _enemyY:int`, `5. param6:int` -> `var _enemyMoveCounter:int`, `6. param7:int` -> `var _enemyMoveDir:int`, `7. param8:int` -> `var _enemyHealth:int`, `8. param9:String` -> `var _targetPlayerName:String`, `9. param10:String = ""` -> `var _playerControl:String` |
| 11 | `"Ei"` | `enemyInfoGot` | `GameMain.as:L809` | `1. param2:String`, `2. param3:int` -> `_loc10_.x`, `3. param4:int` -> `_loc10_.y`, `4. param5:int` -> `_loc10_.health`, `5. param6:int` -> `_loc10_.moveDir`, `6. param7:int` -> `_loc10_.enemyAI.moveCounter`, `7. param8:int` -> `_loc10_.dirChangeTime`, `8. param9:String = ""` -> `_loc10_.enemyAI.target` |
| 12 | `"petI"` | `petInfoGot` | `GameMain.as:L810` | `1. param2:String`, `2. param3:int` -> `_loc6_.x`, `3. param4:int` -> `_loc6_.y` |
| 13 | `"item"` | `newItemCreatedGot` | `GameMain.as:L811` | `1. param2:String`, `2. param3:int`, `3. param4:int`, `4. param5:String`, `5. param6:int`, `6. param7:String = ""`, `7. param8:Number = 0`, `8. param9:Number = -14` |
| 14 | `"geIIn"` | `itemInfoGot` | `GameMain.as:L812` | `1. param2:String`, `2. param3:int` -> `item_array[j].x`, `3. param4:int` -> `item_array[j].y` |
| 15 | `"geIRe"` | `itemRemovedGot` | `GameMain.as:L813` | `1. param2:String`, `2. param3:String` |
| 16 | `"geReAllIIn"` | `singleItemInfoGot` | `GameMain.as:L814` | `1. param2:String`, `2. param3:int`, `3. param4:int`, `4. param5:String`, `5. param6:int` |
| 17 | `"chat"` | `newChatMessageGot` | `GameMain.as:L815` | `1. param2:String`, `2. param3:String` |
| 18 | `"getNewEquip"` | `newEquipGot` | `GameMain.as:L816` | `1. param2:String`, `2. param3:int` -> `_loc10_.bodyAnimator.helmetFrame`, `3. param4:int` -> `_loc10_.bodyAnimator.shirtFrame`, `4. param5:int` -> `_loc10_.bodyAnimator.pantsFrame`, `5. param6:int` -> `_loc10_.bodyAnimator.weaponFrame`, `6. param7:int` -> `_loc10_.bodyAnimator.shoeFrame`, `7. param8:int` -> `_loc10_.bodyAnimator.weapon2Frame`, `8. param9:int` |
| 19 | `"dmgE"` | `enemyDamagedGot` | `GameMain.as:L817` | `1. param2:String`, `2. param3:String` -> `var _loc20_:Person`, `3. param4:Boolean` -> `_loc12_`, `4. param5:int` -> `_loc11_.gravityObject.velX +`, `5. param6:int` -> `_loc11_.gravityObject.velY +`, `6. param7:int` -> `_loc11_.health`, `7. param8:int` -> `_loc11_.moveDir`, `8. param9:Boolean` -> `_loc11_.wasCritHit`, `9. param10:Boolean = false` |
| 20 | `"eSync"` | `enemySyncGot` | `GameMain.as:L818` | `1. param2:String` -> `var _loc4_:Array` |
| 21 | `"XP"` | `updatePersonXP` | `GameMain.as:L819` | `1. param2:String` -> `var _pName:String`, `2. param3:uint` -> `var _xpEarned:uint`, `3. param4:Boolean = false` -> `var _levelUp:Boolean` |
| 22 | `"updPetXP"` | `updatePetXP` | `GameMain.as:L820` | `1. param2:String` -> `var _petName:String`, `2. param3:int` -> `var _xp:int`, `3. param4:Boolean = false` -> `var _levelUp:Boolean`, `4. param5:int = 0` -> `var _newLvl:int`, `5. param6:int = 0` -> `var _newPower:int`, `6. param7:int = 0` -> `var _newDex:int`, `7. param8:int = 0` -> `var _newDefense:int`, `8. param9:int = 0` -> `var _newHealth:int`, `9. param10:int = 0` -> `var _newTotalHealth:int` |
| 23 | `"iBoughtCheck"` | `itemBought` | `GameMain.as:L821` | `1. param2:String`, `2. param3:int` -> `player.money`, `3. param4:Boolean` |
| 24 | `"iSold"` | `itemSold` | `GameMain.as:L822` | `1. param2:int` -> `player.money` |
| 25 | `"pointUse"` | `abilityPointUsed` | `GameMain.as:L823` | `1. param2:String`, `2. param3:int` -> `_loc14_.totalHealth`, `3. param4:int`, `4. param5:int` -> `_loc14_.power`, `5. param6:int` -> `_loc14_.dex`, `6. param7:int` -> `_loc14_.defense`, `7. param8:int` -> `_loc14_.abilityPoints`, `8. param9:int` -> `_loc14_.range`, `9. param10:*` -> `_loc14_.totalMP`, `10. param11:int` -> `_loc14_.MP`, `11. param12:int` -> `_loc14_.magic`, `12. param13:int` -> `_loc14_.artillery` |
| 26 | `"dmgP"` | `playerDamaged` | `GameMain.as:L824` | `1. param2:String` -> `var _loc15_:Person`, `2. param3:int` -> `_loc15_.health`, `3. param4:String`, `4. param5:int`, `5. param6:Boolean = false`, `6. param7:Boolean = false`, `7. param8:int = 0`, `8. param9:int = 0`, `9. param10:int = 0`, `10. param11:Boolean = false`, `11. param12:Boolean = false` |
| 27 | `"envDmgP"` | `playerEnvDamaged` | `GameMain.as:L825` | `1. param2:String`, `2. param3:int` -> `_loc5_.health`, `3. param4:int` |
| 28 | `"kD"` | `personKeyDown` | `GameMain.as:L826` | `1. param2:String`, `2. param3:uint`, `3. param4:int = 2147483647`, `4. param5:int = 2147483647` |
| 29 | `"kU"` | `personKeyUp` | `GameMain.as:L827` | `1. param2:String`, `2. param3:uint`, `3. param4:int = 2147483647`, `4. param5:int = 2147483647` |
| 30 | `"geKicked"` | `getKicked` | `GameMain.as:L828` | `1. param2:Boolean`, `2. param3:String = "You have been logged in from somewhere else"` -> `disconnectReason` |
| 31 | `"PHea"` | `personHealed` | `GameMain.as:L829` | `1. param2:String`, `2. param3:int` -> `_loc6_.health`, `3. param4:int` -> `_loc6_.MP`, `4. param5:Boolean = true` |
| 32 | `"geTReq"` | `tradeRequestReceived` | `GameMain.as:L830` | `1. param2:String` |
| 33 | `"tDecl"` | `tradeDeclined` | `GameMain.as:L831` | `1. param2:String`, `2. param3:Boolean` |
| 34 | `"tAcc"` | `tradeAccepted` | `GameMain.as:L832` | `1. param2:String` |
| 35 | `"rageStart"` | `rageStart` | `GameMain.as:L833` | `1. param2:String`, `2. param3:Boolean = false` |
| 36 | `"rageEnd"` | `rageEnd` | `GameMain.as:L834` | `1. param2:String` |
| 37 | `"ping"` | `pingGot` | `GameMain.as:L835` | *(No payload parameters)* |
| 38 | `"petActi"` | `petActivated` | `GameMain.as:L836` | `1. param2:String`, `2. param3:String` -> `_loc4_` |
| 39 | `"withdPet"` | `petWithdraw` | `GameMain.as:L837` | `1. param2:String`, `2. param3:String` |
| 40 | `"petMChange"` | `petModeChanged` | `GameMain.as:L838` | `1. param2:String`, `2. param3:String`, `3. param4:String` -> `_loc6_.mode` |
| 41 | `"petIEquip"` | `petItemEquipped` | `GameMain.as:L839` | `1. param2:String`, `2. param3:String`, `3. param4:int`, `4. param5:int` |
| 42 | `"petHeal"` | `petHealedGot` | `GameMain.as:L840` | `1. param2:String`, `2. param3:String`, `3. param4:int` -> `_loc5_.health` |
| 43 | `"dmgPet"` | `petDamageGot` | `GameMain.as:L841` | `1. param2:String`, `2. param3:int` |
| 44 | `"checkEvo"` | `checkPetEvolution` | `GameMain.as:L842` | `1. param2:String`, `2. param3:String` |
| 45 | `"petEvolved"` | `petEvolved` | `GameMain.as:L843` | `1. param2:String`, `2. param3:String` -> `_loc6_.type`, `3. param4:Boolean = false` |
| 46 | `"alert"` | `getAlert` | `GameMain.as:L844` | `1. param2:String`, `2. param3:Boolean = false`, `3. param4:Boolean = false` |
| 47 | `"PLove"` | `getPetLove` | `GameMain.as:L845` | `1. param2:String`, `2. param3:*` |
| 48 | `"gePetConTog"` | `getPetModeToggled` | `GameMain.as:L846` | `1. param2:String`, `2. param3:Boolean` |
| 49 | `"singlePing"` | `gotSinglePing` | `GameMain.as:L847` | `1. param2:String`, `2. param3:int` |
| 50 | `"geIpCheck"` | `ipBanCheckGot` | `GameMain.as:L848` | *(No payload parameters)* |
| 51 | `"proxyDetected"` | `proxyDetected` | `GameMain.as:L849` | *(No payload parameters)* |
| 52 | `"geShout"` | `shoutGot` | `GameMain.as:L850` | `1. param2:uint`, `2. param3:String`, `3. param4:String` |
| 53 | `"SBall"` | `spawnBallInfoGot` | `GameMain.as:L851` | `1. param2:String`, `2. param3:int`, `3. param4:int`, `4. param5:String` |
| 54 | `"fish"` | `fishCreatedGot` | `GameMain.as:L852` | `1. param2:String`, `2. param3:int` -> `_loc7_`, `3. param4:int` -> `_loc7_`, `4. param5:String`, `5. param6:Boolean` |
| 55 | `"count"` | `serverCounterGot` | `GameMain.as:L853` | `1. param2:int` -> `serverCounter` |
| 56 | `"fishRe"` | `fishRemovedGot` | `GameMain.as:L854` | `1. param2:String` -> `var _catcherName:String`, `2. param3:String` -> `var _fishName:String` |
| 57 | `"tree"` | `treeGot` | `GameMain.as:L855` | `1. param2:String`, `2. param3:String`, `3. param4:int`, `4. param5:int`, `5. param6:int`, `6. param7:Boolean` |
| 58 | `"tDmg"` | `treeDamagedGot` | `GameMain.as:L856` | `1. param2:String`, `2. param3:int`, `3. param4:String`, `4. param5:Boolean` |
| 59 | `"petSumFwd"` | `petsSummonedForward` | `GameMain.as:L857` | *(No payload parameters)* |
| 60 | `"eContr"` | `enemyControlled` | `GameMain.as:L858` | `1. param2:String`, `2. param3:String` |
| 61 | `"eNoCont"` | `enemyNoControl` | `GameMain.as:L859` | `1. param2:String` |
| 62 | `"tile"` | `singleTileGot` | `GameMain.as:L860` | `1. param2:int`, `2. param3:int`, `3. param4:int` |
| 63 | `"portal"` | `portalGot` | `GameMain.as:L861` | `1. param2:int` -> `var _loc6_:Image`, `2. param3:int` -> `var _loc6_:Image`, `3. param4:uint` -> `var _loc6_:Image` |
| 64 | `"unleash"` | `powerUnleashed` | `GameMain.as:L862` | `1. param2:String`, `2. param3:Number`, `3. param4:Number` -> `_loc5_.energyController.charge` |
| 65 | `"eChar"` | `energyChargeGot` | `GameMain.as:L863` | `1. param2:String`, `2. param3:Number`, `3. param4:Number` |
| 66 | `"fraudCheckGot"` | `fraudCheckGot` | `GameMain.as:L864` | `1. param2:String` -> `_loc3_` |
| 67 | `"noCharMade"` | `noCharMade` | `GameMain.as:L867` | *(No payload parameters)* |
| 68 | `"newVendorSet"` | `newVendorSet` | `GameMain.as:L871` | `1. param2:String` -> `_loc7_`, `2. param3:int` -> `_loc7_`, `3. param4:int` -> `_loc7_`, `4. param5:String` -> `_loc7_`, `5. param6:Number` -> `_loc7_.rotation` |
| 69 | `"newVItemAdded"` | `newVItemAdded` | `GameMain.as:L872` | `1. param2:String`, `2. param3:String`, `3. param4:uint` |
| 70 | `"boughtVTickets"` | `boughtVendorTickets` | `GameMain.as:L873` | `1. param2:String`, `2. param3:uint`, `3. param4:String` |
| 71 | `"newBCannon"` | `newBeholderCannonGot` | `GameMain.as:L877` | `1. param2:int` -> `_loc4_.x`, `2. param3:int` -> `_loc4_.y` |
| 72 | `"beCannonReGot"` | `beholderCannonRemoved` | `GameMain.as:L878` | `1. param2:int` |
| 73 | `"newPVenSet"` | `newPetVendorSet` | `GameMain.as:L882` | `1. param2:String`, `2. param3:int`, `3. param4:int`, `4. param5:String`, `5. param6:Number` -> `petVendor.rotation` |
| 74 | `"petBoughtFromVend"` | `removePetVendor` | `GameMain.as:L883` | `1. param2:String`, `2. param3:String` |
| 75 | `"tileDefs"` | `tileDefsGot` | `GameMain.as:L885` | `1. param2:String` |
| 76 | `"geTiles"` | `tileDataGot` | `GameMain.as:L886` | `1. param2:uint`, `2. param3:ByteArray`, `3. param4:ByteArray`, `4. param5:ByteArray`, `5. param6:ByteArray`, `6. param7:ByteArray`, `7. param8:ByteArray` |
| 77 | `"geAtm"` | `geAtmGot` | `GameMain.as:L887` | `1. param2:int`, `2. param3:int`, `3. param4:int` |
| 78 | `"pLoaded"` | `playerLoaded` | `GameMain.as:L890` | `1. param2:String` -> `player.name`, `2. param3:int` -> `player.power`, `3. param4:uint` -> `player.money`, `4. param5:int` -> `player.bodyAnimator.originalHair`, `5. param6:int` -> `player.bodyAnimator.helmetFrame`, `6. param7:int` -> `player.bodyAnimator.shirtFrame`, `7. param8:int` -> `player.bodyAnimator.pantsFrame`, `8. param9:int` -> `player.bodyAnimator.weaponFrame`, `9. param10:int` -> `player.bodyAnimator.gender`, `10. param11:int` -> `player.bodyAnimator.eyes`, `11. param12:int` -> `player.lev`, `12. param13:String` -> `personItem_array`, `13. param14:int` -> `player.abilityPoints`, `14. param15:int` -> `player.dex`, `15. param16:int` -> `player.defense`, `16. param17:int` -> `player.currentLevelXP`, `17. param18:int` -> `player.totalHealth`, `18. param19:int` -> `player.health`, `19. param20:int` -> `player.bodyAnimator.shoeFrame`, `20. param21:int` -> `player.range`, `21. param22:int` -> `player.totalMP`, `22. param23:int` -> `player.MP`, `23. param24:int` -> `player.magic`, `24. param25:int` -> `player.bodyAnimator.weapon2Frame`, `25. param26:Boolean` -> `player.bodyAnimator.hasHalo`, `26. param27:String` -> `player.guild`, `27. param28:int` -> `player.bodyAnimator.beard`, `28. param29:int` -> `player.artillery`, `29. param30:Boolean` -> `hasGuildMoney3x`, `30. param31:int` -> `player.bodyAnimator.accessoryFrame`, `31. param32:String` -> `player.role` |
| 79 | `"wrongCap"` | `wrongCap` | `GameMain.as:L899` | `1. param2:String = ""` -> `param2` |
| 80 | `"newLotto"` | `newLotteryPurchase` | `GameMain.as:L914` | `1. param2:uint` -> `player.tickets`, `2. param3:uint` -> `player.money`, `3. param4:String` |
| 81 | `"roboInv"` | `startRoboCityInvasion` | `GameMain.as:L922` | `1. param2:Boolean = false` -> `var _alreadyHappening:Boolean` |
| 82 | `"endRoboInv"` | `endRoboCityInvasion` | `GameMain.as:L923` | `1. param2:Number = 3` -> `var _fadeTime:Number` |
| 83 | `"guildCre"` | `guildCreatedGot` | `GameMain.as:L5151` | `1. param2:String` -> `player.guild` |
| 84 | `"debugSGot"` | `debugStatsGot` | `GameMain.as:L8660` | `1. param2:int`, `2. param3:int`, `3. param4:int`, `4. param5:int`, `5. param6:int`, `6. param7:int`, `7. param8:int`, `8. param9:int`, `9. param10:int`, `10. param11:Boolean` |
| 85 | `"gotRoomInfo"` | `roomNameGot` | `GameMain.as:L8693` | `1. param2:int` |
| 86 | `"ranksGot"` | `this.rankMenu.ranksGot` | `GameMain.as:L12136` | `1. param2:String` -> `_loc16_`, `2. param3:int` -> `enemyKills_txt.text`, `3. param4:int` -> `_loc18_`, `4. param5:int` -> `_loc21_`, `5. param6:int` -> `pvpKills_txt.text`, `6. param7:uint` -> `guildContribute_txt.text`, `7. param8:int` -> `guildLevels_txt.text`, `8. param9:int` -> `guildKills_txt.text`, `9. param10:int` -> `bonusRight_txt.text` |
| 87 | `"giTradeOffer"` | `this.tradeMenu.newTradeOffer` | `GameMain.as:L12619` | `1. param2:String`, `2. param3:String` -> `_loc6_`, `3. param4:Boolean`, `4. param5:int` -> `opponentMoneyOffer` |
| 88 | `"giTConfirm"` | `this.tradeMenu.showOConfirmed` | `GameMain.as:L12620` | *(No payload parameters)* |
| 89 | `"giTMessage"` | `newTradeMessage` | `GameMain.as:L12621` | `1. param2:String`, `2. param3:String` |
| 90 | `"giTVerify"` | `tradeVerified` | `GameMain.as:L12622` | `1. param2:String`, `2. param3:String` -> `else if(param3 !`, `3. param4:uint` -> `player.money`, `4. param5:String = ""`, `5. param6:String = ""` |
| 91 | `"giTClosed"` | `tradeClosed` | `GameMain.as:L12623` | `1. param2:String` |
| 92 | `"giPetOffer"` | `this.tradeMenu.newPetOffer` | `GameMain.as:L12624` | `1. param2:String`, `2. param3:String`, `3. param4:String` -> `_loc14_`, `4. param5:int` -> `_loc14_.helmet_uint`, `5. param6:int` -> `_loc14_.shoes_uint`, `6. param7:int` -> `_loc14_.lvl`, `7. param8:int` -> `_loc14_.power`, `8. param9:int` -> `_loc14_.dex`, `9. param10:int` -> `_loc14_.defense`, `10. param11:int` -> `_loc14_.totalHealth`, `11. param12:int` -> `_loc14_.love` |
| 93 | `"giPetWithdraw"` | `this.tradeMenu.newPetWithdraw` | `GameMain.as:L12625` | `1. param2:String` |
| 94 | `"giTicketOffer"` | `this.tradeMenu.newTicketOffer` | `GameMain.as:L12626` | `1. param2:String`, `2. param3:int` -> `oTickets_txt.text` |
| 95 | `"tradeLock"` | `this.tradeMenu.tradeLocked` | `GameMain.as:L12627` | `1. param2:Boolean = true` |
| 96 | `"finalTConfirm"` | `finalTradeConfirmed` | `GameMain.as:L12628` | *(No payload parameters)* |
| 97 | `"pSaved"` | `playerSaved` | `GameMain.as:L13504` | *(No payload parameters)* |
| 98 | `"bankDone"` | `bankTransferDone` | `com/menus/BankMenu.as:L232` | `1. param2:int` -> `gameMain.player.money +`, `2. param3:Boolean = false` |
| 99 | `"bankDone"` | `bankTransferDone` | `com/menus/BankMenu.as:L250` | `1. param2:int` -> `gameMain.player.money +`, `2. param3:Boolean = false` |
| 100 | `"itemCrafted"` | `itemCraftedGot` | `com/menus/CraftingMenu.as:L210` | `1. param2:String` -> `var _loc4_:int` |
| 101 | `"validatePet"` | `gotPetValidate` | `com/menus/PetConfirmMenu.as:L114` | `1. param2:Boolean`, `2. param3:String = ""` -> `_loc5_`, `3. param4:String = ""` |

#### Detailed Parameter Semantics for Major Multi-Parameter Incoming Messages
- **`"pLoaded"` -> `GameMain.playerLoaded` (`GameMain.as:L3736`, 31 payload arguments)**:
  1. `name:String` (`player.name`)
  2. `power:int` (`player.power`)
  3. `money:uint` (`player.money`)
  4. `originalHair:int` (`bodyAnimator.originalHair` / `hair`)
  5. `helmetFrame:int` (`bodyAnimator.helmetFrame`)
  6. `shirtFrame:int` (`bodyAnimator.shirtFrame`)
  7. `pantsFrame:int` (`bodyAnimator.pantsFrame`)
  8. `weaponFrame:int` (`bodyAnimator.weaponFrame`)
  9. `skin:int` (`1..4` male, `5..8` female, `9` zombie)
  10. `eyes:int` (`bodyAnimator.eyes`)
  11. `lev:int` (`player.lev`)
  12. `itemsCSV:String` (comma-separated inventory `personItem_array`)
  13. `abilityPoints:int` (`player.abilityPoints`)
  14. `dex:int` (`player.dex`, sets `moveSpeed = 7 + dex / 176`)
  15. `defense:int` (`player.defense`)
  16. `currentLevelXP:int` (`player.currentLevelXP`)
  17. `totalHealth:int` (`player.totalHealth`)
  18. `health:int` (`player.health`)
  19. `shoeFrame:int` (`bodyAnimator.shoeFrame`)
  20. `range:int` (`player.range`)
  21. `totalMP:int` (`player.totalMP`)
  22. `MP:int` (`player.MP`)
  23. `magic:int` (`player.magic`)
  24. `weapon2Frame:int` (`bodyAnimator.weapon2Frame`)
  25. `hasHalo:Boolean` (`bodyAnimator.hasHalo`)
  26. `guild:String` (`player.guild`)
  27. `beard:int` (`bodyAnimator.beard`)
  28. `artillery:int` (`player.artillery`)
  29. `hasGuildMoney3x:Boolean` (`this.hasGuildMoney3x`)
  30. `accessoryFrame:int` (`bodyAnimator.accessoryFrame`)
  31. `role:String` (`player.role`, e.g. GM/moderator icon check)

- **`"sP"` -> `GameMain.singlePersonInfoGot` (`GameMain.as:L2898`, 34 payload arguments — spawns remote player)**:
  1. `name:String`, 2. `x:int`, 3. `y:int`, 4. `hair:int`, 5. `helmetFrame:int`, 6. `shirtFrame:int`, 7. `pantsFrame:int`, 8. `weaponFrame:int`, 9. `skin:int`, 10. `eyes:int`, 11. `shoeFrame:int`, 12. `lev:int`, 13. `power:int`, 14. `totalHealth:int`, 15. `health:int`, 16. `dex:int`, 17. `defense:int`, 18. `range:int`, 19. `totalMP:int`, 20. `MP:int`, 21. `magic:int`, 22. `weapon2Frame:int`, 23. `hasHalo:Boolean`, 24. `guild:String`, 25. `moveDir:int`, 26. `leftKeyDown:Boolean`, 27. `rightKeyDown:Boolean`, 28. `shieldMasteryLvl:int`, 29. `hasDoubleDrop:Boolean`, 30. `beard:int`, 31. `artillery:int`, 32. `fishingLvl:uint`, 33. `accessoryFrame:int`, 34. `role:String`.

- **`"pMisc"` -> `GameMain.personMiscInfoGot` (`GameMain.as:L2935`, 17 payload arguments — remote player skills)**:
  1. `name:String`, 2. `jumpSkillLvl:int`, 3. `bulletDistanceLvl:int`, 4. `magicShotsLvl:int`, 5. `magicDistanceLvl:int`, 6. `upwardShootLvl:int`, 7. `piercingArrowLvl:int`, 8. `thunderAttackLvl:int`, 9. `grenadeLvl:int`, 10. `tripleShotLvl:int`, 11. `lightBeamLvl:int`, 12. `shotgunLvl:int`, 13. `arrowRainLvl:int`, 14. `hasBaitExtend:Boolean`, 15. `barrageLvl:int`, 16. `hasDoubleJump:Boolean`, 17. `dashLvl:int`.

- **`"sPet"` -> `GameMain.singlePetInfoGot` (`GameMain.as:L2964`, 17 payload arguments — spawns remote/active pet)**:
  1. `petName:String`, 2. `ownerName:String`, 3. `petType:String`, 4. `x:int`, 5. `y:int`, 6. `helmetFrame:int`, 7. `lvl:int`, 8. `power:int`, 9. `health:int`, 10. `totalHealth:int`, 11. `dex:int`, 12. `defense:int`, 13. `mode:String`, 14. `counter:int`, 15. `unused:int`, 16. `shoesFrame:int`, 17. `isControllingPet:Boolean`.

- **`"tD"` -> `GameMain.tileDataGot` (`GameMain.as:L2731`, 7 payload arguments — area tile layers)**:
  1. `mapWidthInTiles:uint`, 2. `mainGroundBytes:ByteArray`, 3. `waterBytes:ByteArray`, 4. `ground2Bytes:ByteArray`, 5. `ground3Bytes:ByteArray`, 6. `foregroundBytes:ByteArray`, 7. `artBytes:ByteArray`.
  *(Each `ByteArray` is zlib-compressed or raw 2-byte big-endian signed `short` per tile cell; see Section 5.1).*

- **`"eD"` -> `GameMain.enemyDamagedGot` (`GameMain.as:L3138`, 9 payload arguments)**:
  1. `enemyName:String`, 2. `attackerName:String`, 3. `isSecondaryWeapon:Boolean`, 4. `knockbackVelX:int`, 5. `knockbackVelY:int`, 6. `newHealth:int`, 7. `moveDir:int`, 8. `wasCritHit:Boolean`, 9. `noHitEffects:Boolean = false`.

- **`"pD"` -> `GameMain.playerDamaged` (`GameMain.as:L3291`, 11 payload arguments)**:
  1. `victimName:String`, 2. `newHealth:int`, 3. `attackerName:String`, 4. `damageAmount:int`, 5. `wasCritHit:Boolean = false`, 6. `wasAvoided:Boolean = false`, 7. `fireDamage:int = 0`, 8. `shockDamage:int = 0`, 9. `iceDamage:int = 0`, 10. `isBlocked:Boolean = false`, 11. `noTakeHitAnim:Boolean = false`.

### 3.2 Outgoing Client -> Server Messages (`connection.send` / `sendMessage`)
There are **110 unique outgoing message types** across **228 `.send(...)` call sites** in the codebase.

| # | Message Type | Call Sites (File:Line) | Exact Ordered Arguments & Types | Purpose / Trigger |
|---:|---|---|---|---|
| 1 | `"100000Bought"` | `GameMain.as:L4480` | *(no args)* | Sent from `GameMain.as` |
| 2 | `"20000Bought"` | `GameMain.as:L4470` | *(no args)* | Sent from `GameMain.as` |
| 3 | `"3000Bought"` | `GameMain.as:L4460` | *(no args)* | Sent from `GameMain.as` |
| 4 | `"500000Bought"` | `GameMain.as:L4490` | *(no args)* | Sent from `GameMain.as` |
| 5 | `"MouseWheel.send();"` | `com/ui/MouseWheel.as:L85`, `com/ui/MouseWheel.as:L104`, `com/ui/MouseWheel.as:L121`, `com/ui/MouseWheel.as:L129` | *(no args)* | Sent from `MouseWheel.as` |
| 6 | `"P"` | `GameMain.as:L2812`, `GameMain.as:L10896` | `int(this.player.gravityObject.hit_rect.x)`, `int(this.player.gravityObject.hit_rect.y)` | Sent from `GameMain.as` |
| 7 | `"PdmgP"` | `GameMain.as:L10938`, `com/game_objects/Explosion.as:L71`, `com/game_objects/Projectile.as:L126`, `com/game_objects/extensions/MoveHandler.as:L678` | `this.p_array[this.i].name`, `!this.player.hitTester.hitType.isPrimary`, `_loc3_`, `this.player.bodyAnimator.currentLabel == "block"` <br>OR<br> `this.creatorName`, `false`, `"grenade"`, `this.gameMain.player.bodyAnimator.currentLabel == "block"` <br>OR<br> `this.creator.name`, `this.creator.bodyAnimator.weapon2String != "none" && Stats.wStats[this.creator.bodyAnimator.weapon2String].isMagic && this.isMagicSecondary || this.isSecondaryShot`, `"p"`, `param1.player.bodyAnimator.currentLabel == "block"` <br>*(+1 variants)* | Sent from `GameMain.as` |
| 8 | `"PdmgPet"` | `com/game_objects/Projectile.as:L149` | `this.creator.name`, `_loc9_.name`, `true` | Sent from `Projectile.as` |
| 9 | `"_loc2_.command.send(_loc2_.connection);"` | `com/newgrounds/APICommand.as:L92` | *(no args)* | Sent from `APICommand.as` |
| 10 | `"_loc5_.send(this);"` | `com/newgrounds/APIConnection.as:L143` | *(no args)* | Sent from `APIConnection.as` |
| 11 | `"aPointReset"` | `GameMain.as:L5129` | *(no args)* | Sent from `GameMain.as` |
| 12 | `"acceptT"` | `GameMain.as:L1276` | `e.target.parent.traderName` | Sent from `GameMain.as` |
| 13 | `"ban"` | `com/apis/GooglePlay.as:L76`, `com/game_objects/extensions/PersonHackCheck.as:L125` | `"Banned for payment reversal"` <br>OR<br> `_reason` | Sent from `GooglePlay.as` |
| 14 | `"bankD"` | `com/menus/BankMenu.as:L233` | `uint(this.deposit_txt.text)` | Sent from `BankMenu.as` |
| 15 | `"bankItem"` | `com/menus/BankMenu.as:L270` | `this.itemText_array[_loc1_].text` | Sent from `BankMenu.as` |
| 16 | `"bankW"` | `com/menus/BankMenu.as:L251` | `uint(this.withdrawl_txt.text)` | Sent from `BankMenu.as` |
| 17 | `"beCannonRe"` | `GameMain.as:L13254`, `GameMain.as:L13280` | `int(param1.y)` | Sent from `GameMain.as` |
| 18 | `"boughtBlueBall"` | `GameMain.as:L4813` | *(no args)* | Sent from `GameMain.as` |
| 19 | `"boughtGreenBall"` | `GameMain.as:L4803` | *(no args)* | Sent from `GameMain.as` |
| 20 | `"boughtGuild3x"` | `GameMain.as:L4842` | *(no args)* | Sent from `GameMain.as` |
| 21 | `"boughtHairBasic"` | `GameMain.as:L4540` | `this.pvMenu.lastHairBought` | Sent from `GameMain.as` |
| 22 | `"boughtHalo"` | `GameMain.as:L4517` | *(no args)* | Sent from `GameMain.as` |
| 23 | `"boughtItemVendor"` | `GameMain.as:L4793` | *(no args)* | Sent from `GameMain.as` |
| 24 | `"boughtOrangeBall"` | `GameMain.as:L4833` | *(no args)* | Sent from `GameMain.as` |
| 25 | `"boughtPVAcc"` | `GameMain.as:L4936`, `GameMain.as:L4947`, `GameMain.as:L4958`, `GameMain.as:L4969` (+6 more) | `"red cape"`, `"redcape"` <br>OR<br> `"jet pack"`, `"jetpack"` <br>OR<br> `"monkey tail"`, `"monkeytail"` <br>*(+7 variants)* | Sent from `GameMain.as` |
| 26 | `"boughtPetVendor"` | `GameMain.as:L4925` | *(no args)* | Sent from `GameMain.as` |
| 27 | `"boughtSpecialHair"` | `GameMain.as:L4529` | `this.pvMenu.lastHairBought` | Sent from `GameMain.as` |
| 28 | `"boughtYellowBall"` | `GameMain.as:L4823` | *(no args)* | Sent from `GameMain.as` |
| 29 | `"breakChainsaw"` | `com/game_objects/extensions/PersonKeyHandler.as:L735` | *(no args)* | Sent from `PersonKeyHandler.as` |
| 30 | `"breakNet"` | `com/game_objects/extensions/PersonKeyHandler.as:L728` | *(no args)* | Sent from `PersonKeyHandler.as` |
| 31 | `"buyItem"` | `GameMain.as:L7605` | `"letter to Cleveland"` | Sent from `GameMain.as` |
| 32 | `"buyPet"` | `com/menus/PetConfirmMenu.as:L115` | `this.name_txt.text`, `this.petClone.type` | Sent from `PetConfirmMenu.as` |
| 33 | `"caughtFish"` | `com/game_objects/Fish.as:L259`, `com/game_objects/Person.as:L967` | `name` <br>OR<br> `this.fishingLine.caughtFish.name` | Sent from `Fish.as` |
| 34 | `"chLvl"` | `GameMain.as:L13505` | `this.c_mc.currentFrame` | Sent from `GameMain.as` |
| 35 | `"chainsawBought"` | `GameMain.as:L4863` | *(no args)* | Sent from `GameMain.as` |
| 36 | `"cheRevSha"` | `GameMain.as:L13768` | `playingURL_string` | Sent from `GameMain.as` |
| 37 | `"chickenBought"` | `GameMain.as:L4875` | *(no args)* | Sent from `GameMain.as` |
| 38 | `"controlEnemy"` | `com/game_objects/enemies/Enemy.as:L473` | `name` | Sent from `Enemy.as` |
| 39 | `"craftItem"` | `com/menus/CraftingMenu.as:L208` | `item_txt.text` | Sent from `CraftingMenu.as` |
| 40 | `"creGuild"` | `GameMain.as:L5152` | `this.guildMenu.guildName_txt.text`, `this.guildMenu.guildDesc_txt.text` | Sent from `GameMain.as` |
| 41 | `"declineT"` | `GameMain.as:L1285`, `GameMain.as:L4228`, `GameMain.as:L4265` | `e.target.parent.traderName`, `false` <br>OR<br> `param2`, `false` <br>OR<br> `param2`, `true` | Sent from `GameMain.as` |
| 42 | `"dmgE"` | `com/game_objects/Explosion.as:L62`, `com/game_objects/Projectile.as:L101`, `com/game_objects/extensions/MoveHandler.as:L672`, `com/game_objects/power_up_effects/PowerUpVisuals.as:L298` | `_loc2_.name`, `false`, `"grenade"`, `_loc4_`, `_loc5_`, `_loc2_.x`, `_loc2_.y` <br>OR<br> `_loc4_.name`, `param2.bodyAnimator.weapon2String != "none" && Stats.wStats[param2.bodyAnimator.weapon2String].isMagic && this.isMagicSecondary || this.isSecondaryShot`, `"p"`, `_loc6_`, `_loc7_`, `_loc4_.x`, `_loc4_.y` <br>OR<br> `_loc9_[_loc3_].name`, `Stats.wStats[this.person.bodyAnimator.weaponString].defense > 0`, `"thunder"`, `_loc7_`, `_loc8_`, `_loc9_[_loc3_].x`, `_loc9_[_loc3_].y` <br>*(+1 variants)* | Sent from `Explosion.as` |
| 43 | `"dmgP"` | `GameMain.as:L13028` | `param1.name`, `this.player.bodyAnimator.currentLabel == "block"` | Sent from `GameMain.as` |
| 44 | `"dmgPet"` | `com/game_objects/Pet.as:L270` | `_loc1_.name`, `name` | Sent from `Pet.as` |
| 45 | `"doDevStuff"` | `GameMain.as:L8674` | *(no args)* | Sent from `GameMain.as` |
| 46 | `"doSummonPetFwd"` | `com/game_objects/extensions/MoveHandler.as:L561` | *(no args)* | Sent from `MoveHandler.as` |
| 47 | `"editGuildDesc"` | `GameMain.as:L1384` | `this.guildMenu.guildDesc_txt.text`, `uint(this.guildMenu.guildLevelReq_txt.text)` | Sent from `GameMain.as` |
| 48 | `"envDmgP"` | `GameMain.as:L13102` | `param1.power` | Sent from `GameMain.as` |
| 49 | `"fAdd"` | `GameMain.as:L14076` | `_friendName`, `_type` | Sent from `GameMain.as` |
| 50 | `"fRem"` | `GameMain.as:L14156` | `_username`, `_type` | Sent from `GameMain.as` |
| 51 | `"fishNetBought"` | `GameMain.as:L4853` | *(no args)* | Sent from `GameMain.as` |
| 52 | `"fraudCheck"` | `GameMain.as:L4447` | *(no args)* | Sent from `GameMain.as` |
| 53 | `"geRoomInfo"` | `GameMain.as:L8694` | *(no args)* | Sent from `GameMain.as` |
| 54 | `"geSerStats"` | `GameMain.as:L8661` | *(no args)* | Sent from `GameMain.as` |
| 55 | `"getRanks"` | `GameMain.as:L12135` | *(no args)* | Sent from `GameMain.as` |
| 56 | `"giBullhorn"` | `GameMain.as:L4783` | *(no args)* | Sent from `GameMain.as` |
| 57 | `"giChat"` | `com/ui/Controls.as:L769` | `CussFilter.checkAndSubstitute(this.message_txt.text)`, `MainStarlingStage(root).gameMain.player.name` | Sent from `Controls.as` |
| 58 | `"giDeadP"` | `GameMain.as:L10858`, `GameMain.as:L10880` | `"off map"` <br>OR<br> *(no args)* | Sent from `GameMain.as` |
| 59 | `"giEvoCrystal"` | `GameMain.as:L4689` | *(no args)* | Sent from `GameMain.as` |
| 60 | `"giNewEquip"` | `GameMain.as:L13303` | `param1`, `Stats.getItemType(param1)`, `param2` | Sent from `GameMain.as` |
| 61 | `"giPing"` | `GameMain.as:L11128` | *(no args)* | Sent from `GameMain.as` |
| 62 | `"giReI"` | `GameMain.as:L10987`, `com/game_objects/Pet.as:L403`, `com/game_objects/extensions/PersonKeyHandler.as:L543` | `_loc5_.name`, `int(_loc5_.gravityObject.hit_rect.x)`, `int(_loc5_.gravityObject.hit_rect.y)` <br>OR<br> `_loc2_.name`, `int(_loc2_.gravityObject.hit_rect.x)`, `int(_loc2_.gravityObject.hit_rect.y)` <br>OR<br> `_loc4_.name`, `int(_loc4_.gravityObject.hit_rect.x)`, `int(_loc4_.gravityObject.hit_rect.y)` | Sent from `GameMain.as` |
| 63 | `"giTRequest"` | `GameMain.as:L2449` | `RightClickMenu(e.target.parent.parent).params.personName` | Sent from `GameMain.as` |
| 64 | `"guildRage"` | `com/game_objects/extensions/PersonKeyHandler.as:L463`, `com/game_objects/extensions/PersonKeyHandler.as:L464` | *(no args)* | Sent from `PersonKeyHandler.as` |
| 65 | `"hitCBox"` | `com/game_objects/CoinBox.as:L58` | `int(x)`, `int(y)` | Sent from `CoinBox.as` |
| 66 | `"itemStorageBought"` | `GameMain.as:L4624` | *(no args)* | Sent from `GameMain.as` |
| 67 | `"joinGuild"` | `GameMain.as:L1348` | `this.guildMenu.guildName_txt.text` | Sent from `GameMain.as` |
| 68 | `"kd"` | `com/game_objects/Pet.as:L393`, `com/game_objects/extensions/PersonFrameHandler.as:L372`, `com/game_objects/extensions/PersonKeyHandler.as:L226`, `com/game_objects/extensions/PersonKeyHandler.as:L250` (+17 more) | `param1` <br>OR<br> `Keyboard.V`, `this.person.bodyAnimator.currentFrame` <br>OR<br> `Keyboard.O` <br>*(+13 variants)* | Sent from `Pet.as` |
| 69 | `"ku"` | `GameMain.as:L9279`, `com/game_objects/extensions/PersonFrameHandler.as:L528`, `com/game_objects/extensions/PersonKeyHandler.as:L679`, `com/game_objects/extensions/PersonKeyHandler.as:L683` | `Keyboard.C` <br>OR<br> `Keyboard.O` <br>OR<br> `param1` <br>*(+1 variants)* | Sent from `GameMain.as` |
| 70 | `"lc_" + MouseWheel._connectionID"` | `com/ui/MouseWheel.as:L113` | `"capture"`, `MouseWheel._captured` | Sent from `MouseWheel.as` |
| 71 | `"lockTrade"` | `com/menus/TradeMenu.as:L1166` | `this.traderName` | Sent from `TradeMenu.as` |
| 72 | `"maxEnergyBought"` | `GameMain.as:L4742` | `3000` | Sent from `GameMain.as` |
| 73 | `"modeEnable"` | `com/menus/PetModeMenu.as:L259` | `this.selectedPet`, `Stats.returnModeAbrv(this.name_txt.text)` | Sent from `PetModeMenu.as` |
| 74 | `"newOffer"` | `com/menus/TradeMenu.as:L803`, `com/menus/TradeMenu.as:L858`, `com/menus/TradeMenu.as:L1009`, `com/menus/TradeMenu.as:L1019` | `this.traderName`, `item_txt.text`, `true`, `0` <br>OR<br> `this.traderName`, `item_txt.text`, `false`, `0` <br>OR<br> `this.traderName`, `"none"`, `false`, `this.playerMoneyOffer + param1` <br>*(+1 variants)* | Sent from `TradeMenu.as` |
| 75 | `"noControlEnemy"` | `com/game_objects/enemies/Enemy.as:L496` | `this.moveDir` | Sent from `Enemy.as` |
| 76 | `"noTrade"` | `com/menus/TradeMenu.as:L747` | `this.traderName` | Sent from `TradeMenu.as` |
| 77 | `"offerPet"` | `com/menus/TradeMenu.as:L992` | `item_txt.text`, `this.traderName` | Sent from `TradeMenu.as` |
| 78 | `"orbFocusBought"` | `GameMain.as:L4764` | *(no args)* | Sent from `GameMain.as` |
| 79 | `"pHealed"` | `GameMain.as:L7544`, `GameMain.as:L7545`, `GameMain.as:L15183`, `GameMain.as:L15187` (+2 more) | `this.player.totalHealth - this.player.health`, `this.player.totalMP - this.player.MP` <br>OR<br> `50` <br>OR<br> `20`, `100` <br>*(+2 variants)* | Sent from `GameMain.as` |
| 80 | `"param1.send(this);"` | `com/newgrounds/APIConnection.as:L148` | *(no args)* | Sent from `APIConnection.as` |
| 81 | `"permSaleBought"` | `GameMain.as:L4599` | *(no args)* | Sent from `GameMain.as` |
| 82 | `"petHealed"` | `com/game_objects/extensions/PersonKeyHandler.as:L511` | `20 + this.person.guildHealLvl * 5`, `_loc3_.name` | Sent from `PersonKeyHandler.as` |
| 83 | `"petHitE"` | `com/game_objects/Pet.as:L643`, `com/game_objects/enemies/Enemy.as:L305` | `name`, `_loc2_.name` <br>OR<br> `_loc3_.name`, `name` | Sent from `Pet.as` |
| 84 | `"petHitP"` | `GameMain.as:L10953`, `com/game_objects/Pet.as:L652` | `_loc2_.name` <br>OR<br> `name` | Sent from `GameMain.as` |
| 85 | `"petIn"` | `com/game_objects/Pet.as:L253` | `this.gravityObject.hit_rect.x`, `this.gravityObject.hit_rect.y`, `this.moveDir`, `name` | Sent from `Pet.as` |
| 86 | `"petXPBought"` | `GameMain.as:L4653` | *(no args)* | Sent from `GameMain.as` |
| 87 | `"pingDone"` | `GameMain.as:L6147` | `this.player.ping` | Sent from `GameMain.as` |
| 88 | `"privateServerBought"` | `GameMain.as:L4897` | `this.pvMenu.serverName_txt.text`, `_loc1_`, `_loc2_` | Sent from `GameMain.as` |
| 89 | `"prof"` | `GameMain.as:L11613` | `this.player.choppingLvl`, `this.player.chopXP`, `this.player.fishingLvl`, `this.player.fishXP` | Sent from `GameMain.as` |
| 90 | `"proxyCheck"` | `GameMain.as:L3844` | *(no args)* | Sent from `GameMain.as` |
| 91 | `"qComplete"` | `GameMain.as:L12259` | `_missionName`, `Stats.missionStats[_missionName].worth` | Sent from `GameMain.as` |
| 92 | `"qStart"` | `GameMain.as:L12200` | `_missionName` | Sent from `GameMain.as` |
| 93 | `"removeCompanion"` | `GameMain.as:L4679` | *(no args)* | Sent from `GameMain.as` |
| 94 | `"requestPings"` | `GameMain.as:L8670` | *(no args)* | Sent from `GameMain.as` |
| 95 | `"reviveP"` | `GameMain.as:L1400` | *(no args)* | Sent from `GameMain.as` |
| 96 | `"sellI"` | `GameMain.as:L7880`, `GameMain.as:L7951`, `GameMain.as:L7952`, `GameMain.as:L7953` (+16 more) | `"letter to Cleveland"`, `false` <br>OR<br> `"apple"`, `false` <br>OR<br> `"garbage can lid"`, `false` <br>*(+6 variants)* | Sent from `GameMain.as` |
| 97 | `"shout"` | `GameMain.as:L2282` | `this.bullhornMenu.colorPicker.selectedColor`, `CussFilter.checkAndSubstitute(this.bullhornMenu.shout_txt.text)` | Sent from `GameMain.as` |
| 98 | `"startRoboInvasion"` | `GameMain.as:L8709` | *(no args)* | Sent from `GameMain.as` |
| 99 | `"tClosed"` | `com/menus/TradeMenu.as:L410` | `this.traderName` | Sent from `TradeMenu.as` |
| 100 | `"tConfirm"` | `com/menus/TradeMenu.as:L1156` | `this.traderName` | Sent from `TradeMenu.as` |
| 101 | `"tMessage"` | `com/menus/TradeMenu.as:L469` | `this.traderName`, `CussFilter.checkAndSubstitute(this.message_txt.text)` | Sent from `TradeMenu.as` |
| 102 | `"teleBought"` | `GameMain.as:L4611` | *(no args)* | Sent from `GameMain.as` |
| 103 | `"this._outConnection.send(this._widgetId,"sendEvent","trace",String(param1.data));"` | `com/newgrounds/Bridge.as:L39` | *(no args)* | Sent from `Bridge.as` |
| 104 | `"this._outConnection.send(this._widgetId,"sendEvent",param1,param2);"` | `com/newgrounds/Bridge.as:L53` | *(no args)* | Sent from `Bridge.as` |
| 105 | `"togPetCon"` | `com/game_objects/Person.as:L1011`, `com/game_objects/Person.as:L1028` | `true` <br>OR<br> `false` | Sent from `Person.as` |
| 106 | `"treeHit"` | `com/game_objects/Tree.as:L254`, `com/game_objects/Tree.as:L262` | `name`, `this.hitTester.hitType.isPrimary` | Sent from `Tree.as` |
| 107 | `"unleash"` | `com/game_objects/extensions/PersonKeyHandler.as:L529` | `this.person.energyController.fullTotal`, `this.person.energyController.charge` | Sent from `PersonKeyHandler.as` |
| 108 | `"updateGLevels"` | `GameMain.as:L1363` | *(no args)* | Sent from `GameMain.as` |
| 109 | `"useFish"` | `GameMain.as:L15400` | `param1` | Sent from `GameMain.as` |
| 110 | `"useMP"` | `com/game_objects/Person.as:L598`, `com/game_objects/Person.as:L631`, `com/game_objects/Person.as:L691`, `com/game_objects/extensions/MoveHandler.as:L253` (+16 more) | `this.levelMP(ARROW_TRIPLE_MP)` <br>OR<br> `SHOTGUN_MP * this.shotgunLvl` <br>OR<br> `this.levelMP(2)` <br>*(+15 variants)* | Sent from `Person.as` |
| 111 | `"useScroll"` | `GameMain.as:L15202`, `GameMain.as:L15207`, `GameMain.as:L15212`, `GameMain.as:L15217` (+5 more) | `"book of power"` <br>OR<br> `"book of magic"` <br>OR<br> `"book of range"` <br>*(+6 variants)* | Sent from `GameMain.as` |
| 112 | `"useSpawnBall"` | `GameMain.as:L15311`, `GameMain.as:L15337`, `GameMain.as:L15363`, `GameMain.as:L15389` | `"green spawn ball"` <br>OR<br> `"blue spawn ball"` <br>OR<br> `"yellow spawn ball"` <br>*(+1 variants)* | Sent from `GameMain.as` |
| 113 | `"vendPet"` | `com/menus/PetVendMenu.as:L106` | `this.petName`, `this.currentVendor.name`, `uint(this.coins_txt.text)`, `uint(this.tickets_txt.text)` | Sent from `PetVendMenu.as` |
| 114 | `"withdrawPet"` | `com/menus/TradeMenu.as:L903` | `item_txt.text`, `this.traderName` | Sent from `TradeMenu.as` |
| 115 | `"xpSplitCh"` | `com/menus/PetModeMenu.as:L227` | `this.selectedPet`, `10 + _loc2_ * 15` | Sent from `PetModeMenu.as` |
| 116 | `"zombBought"` | `GameMain.as:L4634` | *(no args)* | Sent from `GameMain.as` |

---

## 4. External Data & Asset Formats (`D:\HHT_CLIENT` & `hht-maps`)

### 4.1 Directory Structure of `D:\HHT_CLIENT` vs `hht-maps`
| Subdirectory | File Count | Total Size | Description |
|---|---:|---:|---|
| `D:\HHT_CLIENT\MyGame.swf` | 1 | 6,951,367 B (~6.95 MB) | Main compiled Flash game SWF (Flash 32, 950x700, 30 FPS) |
| `D:\HHT_CLIENT\data\` | 158 | ~2.75 MB | 144 map JSON files (`map_1.json` .. `map_145.json`, excluding `map_51.json`) + 14 static game data JSON dumps (`helmetStats.json`, `weaponStats.json`, `enemyStats.json`, `npcs.json`, etc.) |
| `D:\PERENOS_GODOT\source_analysis\hht-maps` | 144 | ~2.60 MB | Git repository of `map_1.json` .. `map_145.json`. **Verified 100% byte-for-byte identical** to `D:\HHT_CLIENT\data\map_*.json` (0 diffs). |
| `D:\HHT_CLIENT\dynamic_content\backgrounds\` | 60 | ~6.4 MB | 30 Starling TextureAtlas pairs (`backgrounds1.png` + `backgrounds1.xml` .. `backgrounds30.png` + `backgrounds30.xml`) |
| `D:\HHT_CLIENT\dynamic_content\sprite_sheets\` | 36 | ~18.5 MB | 17 Starling TextureAtlas `.png` + `.xml` pairs + 1 BitmapFont (`talk_font.png` + `talk_font.fnt`) |
| `D:\HHT_CLIENT\dynamic_content\misc\` | 2 | ~155 KB | `pet_body_locations.xml` & `pet_body_locations.json` (skeletal part offsets for all 60 pets) |
| `D:\HHT_CLIENT\SFX_and_music\` | 173 | ~24.8 MB | 21 music tracks (`.mp3`), 82 general SFX (`SFX/*.mp3`), 27 gun SFX (`SFX/guns/*.mp3`), 43 enemy SFX (`SFX/enemies/*.mp3`) |
| `D:\HHT_CLIENT\cut-scenes\` | 2 | ~1.99 MB | `helmet heros cutscene.swf` (1.69 MB) and `helmethero cutscene2.swf` (300 KB) |
| `D:\HHT_CLIENT\includes\` | 2 | 47 B | `getIP.php` (`country=US&ip=127.0.0.1`) and `getTotal.php` (`server1=1&server2=0&server3=0&server4=0&serverPVP=0&totalPlayers=1`) |

### 4.2 Map JSON Format (`D:\HHT_CLIENT\data\map_1.json` .. `map_145.json`)
- **Total Maps**: 144 (`map_1.json` to `map_145.json`; **`map_51.json` does not exist** — `GameMain.as:L10566` redirects `stage == 51` to `46`).
- **Top-Level JSON Keys**:
  ```json
  {
    "stage": 1,
    "width": 40,
    "height": 12,
    "layers": {
      "mainGround": [ ... ],
      "water": [ ... ],
      "ground2": [ ... ],
      "ground3": [ ... ],
      "foreground": [ ... ],
      "art": [ ... ]
    },
    "objects": {
      "portals": [ { "id": 1, "x": 5280, "y": 642 } ],
      "trees": [ { "id": 0, "type": "green tree", "x": 995, "y": 752, "foreground": false, "health": 30 } ],
      "atms": [ { "x": 1660, "y": 643, "layer": 1 } ],
      "shootingObjects": [],
      "damageObjects": [],
      "movingPlatforms": [],
      "bouncePads": [],
      "windSources": [],
      "pipes": [],
      "coinBoxes": [],
      "enemies": [ { "type": "green bouncer", "x": 1500, "y": 700 } ]
    }
  }
  ```
- **Grid & Coordinate System**:
  - Each tile cell is **`165 x 165` pixels** (`TileHandler.TILE_SIZE = 165`).
  - Each layer in `layers` is a 1D array of length `width * height` (row-major: `row = int(index / width)`, `col = index % width`, pixel position `x = col * 165`, `y = row * 165`).
  - When the server sends `"tD"` (`tileDataGot`), it packs each layer into a `ByteArray` of 16-bit signed integers (`writeShort`), where `-1` (or `0` in `map_*.json` depending on layer encoding) means empty cell, and `>= 1` is the 1-based frame index into the area's tile sheet (`GreenAreaTiles`, etc.).

### 4.3 Static Data JSON Schemas in `D:\HHT_CLIENT\data\`
 These 14 JSON files mirror the PlayerIO BigDB stat tables:
1. **`helmetStats.json`** (134 items): `{ "key": "archer hat", "f": 2, "def": 2, "c": 25, "lvl": 1, "hair": true, "rng": 2, "pow": 0, "mgc": 0, "art": 0, "craftItems": [...], "craftCosts": [...] }`
2. **`shirtStats.json`** (100 items): `{ "key": "red shirt", "f": 1, "def": 1, "c": 15, "lvl": 1, "pow": 0, "rng": 0, "mgc": 0, "art": 0, "craftItems": [...], "craftCosts": [...] }`
3. **`legStats.json`** (99 items): `{ "key": "blue jeans", "f": 1, "def": 1, "c": 15, "lvl": 1, "pow": 0, "rng": 0, "mgc": 0, "art": 0, "craftItems": [...], "craftCosts": [...] }`
4. **`shoeStats.json`** (41 items): `{ "key": "brown shoes", "f": 1, "def": 1, "c": 30, "lvl": 1, "pow": 0, "rng": 0, "mgc": 0, "art": 0 }`
5. **`weaponStats.json`** (194 items): `{ "key": "short sword", "f": 1, "min": 2, "max": 5, "c": 20, "lvl": 1, "rng": false, "two": false, "mgc": false, "fire": 0, "shock": 0, "ice": 0, "sr": 0, "def": 0, "craftItems": [...], "craftCosts": [...] }`
6. **`accStats.json`** (12 items): `{ "key": "red cape", "f": 2, "def": 50, "c": 50000, "lvl": 50, "pow": 0 }`
7. **`itemData.json`** (21 items): `{ "key": "apple", "c": 10, "areas": [1, 2, ...], "craftItems": [...], "craftCosts": [...] }`
8. **`itemDescs.json`** (10 items): `{ "key": "apple", "d": "Heals 50 HP" }`
9. **`petHelmets.json`** (35 items): `{ "key": "pet Viking helmet", "f": 3, "def": 10, "c": 500, "lvl": 5, "l": 2, "h": 0, "spe": 0 }` (`l` = luck, `h` = heal, `spe` = speed)
10. **`basePetData.json`** (60 species): `{ "key": "Marshy", "c": 1000, "h": 80, "pow": 3, "dx": 2, "def": 2, "m": "a,d,h", "d": "description", "col": "green" }`
11. **`petData.json`** (20 sample pets): `{ "key": "PetName", "owner": "...", "type": "Marshy", "active": true, "health": 80, "totalHealth": 80, "power": 3, "dex": 2, "def": 2, "love": 50, "mode": "a", "helm": 2, "shoe": 24, "xpSplit": 50, "xp": 0, "lvl": 1 }`
12. **`petVendorData.json`** (6 sample pet vendors): `{ "key": "...", "player": "...", "x": 1200, "y": 748, "pet": "...", "coins": 50000, "tickets": 0 }`
13. **`enemyStats.json`** (46 enemy types): `{ "key": "green bouncer", "h": 17, "d": 1, "s": 2, "w": 6, "p": 3, "jump": 13, "items": [{"n": "apple", "o": 0.05}] }` (`h` = health, `d` = defense, `s` = moveSpeed, `w` = worth/XP, `p` = power, `jump` = jumpPower)
14. **`PayVaultItems.json`** (57 items): `{ "key": "doublejump", "PriceCoins": 140 }`
15. **`npcs.json`**: Array of NPC definitions & shop inventories.

### 4.4 Dynamic Content (`D:\HHT_CLIENT\dynamic_content\`) & Embedded SWF Resources
- **Starling Sprite Sheets (`dynamic_content/sprite_sheets/`)**:
  - Loaded on startup by `Assets.enqueuePreloadAssets()` (`com/utilities/Assets.as:L103-155`):
  - `items_pets_bodies.png/.xml` (`Assets.items_textureAtlas` — all character body parts, weapons, helmets, shirts, pants, shoes, accessories, pets, items, projectiles, orbs, UI icons)
  - `trees_fish.png/.xml` & `tree_fish_light_map.png/.xml` (`Assets.treesFish_textureAtlas` — trees, fish, portals, water splashes, normal maps)
  - `power_up_textures.png/.xml` (`Assets.powerUp_textureAtlas` — energy auras, lightning, rocks, rage glow)
  - `controls.png/.xml` (`Assets.controls_textureAtlas` — HUD bars, buttons, mobile virtual joystick/buttons)
  - Menu atlases: `character_menu`, `item_menu`, `map_menu`, `create_menu`, `pet_menu`, `pet_mode_menu`, `skills_menu`, `friend_menu`, `guild_member_menu`, `heropedia_menu`, `energy_menu`, `talk_box`, `load_screen`
  - `talk_font.png/.fnt` (BitmapFont for NPC/player speech bubbles)
- **Area Backgrounds (`dynamic_content/backgrounds/backgrounds1..30.png/.xml`)**:
  - Loaded on demand per area theme by `AreaCreator.getBGArt(levelFrame, callback)` (`com/helpers/AreaCreator.as`).
  - Each atlas contains `sky`, `background1` (near parallax), `background2` (mid parallax), `background3` (far parallax), and optional `cloud1`, `cloud2`.
- **Pet Skeletal Layout (`dynamic_content/misc/pet_body_locations.xml`)**:
  - Loaded into `Pet.petBodies_xml` (`GameMain.as:L10502`). Defines per-species (`<Marshy>`, `<Marshruto>`, `<Marshraptor>`, etc.) sub-node coordinates (`x`, `y`, `pivotX`, `pivotY`, `rotation`) for `body`, `head`, `helmet`, `foot1`, `foot2`, `tail`, `wing1`, `wing2`, `hand1`, `hand2`.
- **Embedded SWF BinaryData (`D:\PERENOS_GODOT\source_analysis\decompiled_mygame\binaryData\`)**:
  - 6 BitmapFont XMLs (`DamageFont`, `LotteryFont`, `ReadableFont`, `Font`, `ChalkFont`, `StatsFont`) paired with embedded PNGs in `resources/images/` (`Assets.as:L22-57`).
  - 3 PDParticleSystem XMLs (`Snow_SnowflakeXML`, `LavaRain_FlameDropXML`, `Rain_RainDropXML`).

---

## 5. Engine Subsystems: Rendering, Physics, Animations, Inventory, Combat & UI

### 5.1 Dual-Stage Rendering & Depth Sorting (`MainStarlingStage`, `SortDepths`, `TileHandler`)
- **Dual Display Architecture**:
  - **Stage3D (Starling)**: Renders behind the classic Flash display list. Root is `starling.MainStarlingStage`.
    - Layer 0: `AreaCreator.sky` (full-viewport background quad/image)
    - Layers 1..3: `AreaCreator.background3`, `background2`, `background1` (parallax scrolling layers; hidden when `StageQuality.LOW`), plus `cloud1`, `cloud2`
    - World Container: `starlingStage.c_mc` (`starling.display.Sprite`)
    - Weather Overlay: `Snow`, `Rain`, `LavaRain`
    - HUD & Starling Menus: `starlingStage.controls` (`com.ui.Controls`) + active `StarlingGameMenu` instances
  - **Classic Flash DisplayList (`GameMain`)**: Renders on top of Stage3D.
    - `this.c_mc` (`flash.display.MovieClip`): Synchronized to `starlingStage.c_mc.x/y`. Holds vector `DamageObject`s, `ShootingObject`s (`BeholderCannon`), `EnvironmentProjectile`s, `HealingCircle`s, `LightningBolt`s, `Cloud`s, and level-specific MovieClips (slot machines, signs, alarms).
    - Classic Flash Menus (`com.menus.GameMenu` subclasses: `MainMenu`, `PayVaultMenu`, `GuildMenu`, `LotteryMenu`, `CraftingMenu`, `PetShopMenu`, `RankMenu`, `MissionMenu`, `OptionMenu`, `DeadMenu`, `ConnectMenu`, `DebugMenu`), `FakeCursor`, `TextAlert`, and `cutscene_loader`.
- **Depth Regions inside `starlingStage.c_mc` (`com/utilities/SortDepths.as`)**:
  - `SortDepths` maintains ordered z-layers inside `starlingStage.c_mc` using reference arrays:
    - `REGION_1` (Back): Background tile art (`TileHandler.tileArt_array`), `rageGlow_image`
    - `REGION_2` (Mid-Back): Main ground tiles (`TileHandler.tileMain_array`), background `Tree`s, `Fish`, `Portal`s, `WaterSplash`, `IceChunk` particles, background `ATM`
    - `REGION_4` / `REGION_4B` (Characters & Interactive Entities): `VendingMachine`s, `PetVendor`s, `Enemy` instances, `Person` instances (`p_array`, `npc_array`), `Pet` instances (`pet_array`), `Item` drops, `Projectile`s, `PetOrb`s, `FishingLine`s, `Smoke`, `Explosion`, `TalkBubble`s, `GiveHealthBar`s, `Fire`
    - Foreground: Foreground `Tree`s and `TileHandler.tileForeground_array`
- **Runtime Vector-to-Starling TextureAtlas Rasterization (`TileHandler`, `MovieClipToAtlas`, `AtlasBuilder`)**:
  - Area tiles (`GreenAreaTiles`, etc., 59 classes) and Enemy animations (`GreenBouncerVector`, etc., 46 classes) are stored as classic Flash vector `MovieClip`s inside `MyGame.swf`.
  - When entering an area (`TileHandler.convertAreaArt(level)`), `AtlasBuilder.buildFromMovieClip` rasterizes each frame of the theme's tile `MovieClip` at `165x165` into a GPU `TextureAtlas` (`TileHandler.mainArt_textureAtlas` and `foregroundArt_textureAtlas`).
  - Similarly, when an `Enemy` type is first spawned on a map, `MovieClipToAtlas.createAtlas` rasterizes all frames of its `*Vector` MovieClip into `Enemy.enemyAssets_array[type]` (caching the `TextureAtlas` and per-frame pivot offsets for reuse until `emptyGameArrays()` disposes them on level change).
- **Camera & Parallax Scrolling (`GameMain.focusLevel`, `L13726`)**:
  - Centers the player at screen coordinates `(475, 449)` on a `950x700` viewport.
  - `SCROLL_X_MODIFIER = 2.5`, `SCROLL_Y_MODIFIER = 6`:
    - `background1` scrolls at `1 / 2.5` (X) and `1 / 6` (Y) of world movement.
    - `background2` scrolls at `1 / 5.0` (X) and `1 / 12` (Y).
    - `background3` scrolls at `1 / 10.0` (X) and `1 / 24` (Y).
  - `AreaCreator.preventBGOffscreenX/Y()` clamps camera/background edges to map bounds.

### 5.2 Physics & Collision System (`GravityObject`, `TileHandler`, `TileDefRegistry`, `BitBitmapData`)
- **Physics Constants (`com/gravityPackage/GravityObject.as`)**:
  - Frame rate: **30 ticks/second** (`onEnter` loop in `GameMain.as:L10227`, with hit-stop frame catchup `hitStopFramesSkipped`).
  - `gravity = 1.1` px/frame² (modified by `accelDownMultiplier`: water buoyancy, accessories like `pink balloon` `-10%`, `balloon pack` `-20%`, `red cape` glide, `jet pack` / `heli pack` upward thrust, or Warrior `accelDownLvl` skill).
  - `groundFriction = 0.83` (multiplied per frame when `leftDown == false && rightDown == false`; slippery acid/ice tiles reduce friction).
  - `airFriction = 0.96`.
  - `maxFallSpeed = 25` px/frame.
  - `maxGap = 20` px (step-up height for walking up slopes and stairs without jumping).
  - Player move speed formula: `moveSpeed = 7 + dex / 176` (plus pet shoe speed bonuses).
  - Player jump velocity formula: `jumpPower = 20 + jumpSkillLvl * 0.3` (`maxJumps = 2` if player owns `doublejump` PayVault item, else `1`).
- **Collision Layers & Pixel-Level Bitmasks**:
  - `TileHandler` maintains four 2D tile grids (`tileMain_array`, `tileGround2_array`, `tileGround3_array`, `tileWater_array`), where each `165x165` cell stores a tile ID and references a 1-bit pixel mask (`BitBitmapData` built from `Block1Data`..`Block10Data` or `TileDefRegistry` server payload).
  - `tileMain_array`: Solid terrain (blocks horizontal, downward, and upward movement depending on tile definition).
  - `tileGround2_array` & `tileGround3_array`: One-way / semi-solid platforms (players can jump up through them and drop down through them via `dropThroughCounter`).
  - `tileWater_array`: Water/swimming volume (`inWater = true`, triggers splash & water bubbles, modifies gravity and movement).
  - **Special Physics Objects**: `BouncePad` (launches `velY`), `WindSource` (applies continuous push velocity), `PipeController` (Aqualantis suction transport pipes), `MovingPlatform`.

### 5.3 Character, Pet & Monster Animation System (`BodyAnimator`, `Moves`, `Pet`, `Enemy`)
- **Player/NPC Skeletal Frame-Table Animator (`com/game_objects/extensions/BodyAnimator.as`, `2,953 lines`)**:
  - Unlike enemies, `Person` does **not** use pre-rendered full-body sprite sheets. Instead, `BodyAnimator` composes a character out of **15 separate Starling `Image`/`Sprite` layers** from `Assets.items_textureAtlas`:
    - `shadow_image`, `pet` (when mounted), `accessory_image`, `handRight_image`, `weaponRight_sprite`, `footRight_image`, `footLeft_image`, `legRight_image`, `legLeft_image`, `body_image` (shirt), `head_image` (skin + gender), `eyes_image`, `beard_image`, `hair_image`, `helmet_image`, `armLeft_image`, `handLeft_image`, `weaponLeft_sprite`.
  - `BodyAnimator` contains **985 timeline frames** and **49 named animation labels** (`standing`, `walking`, `jumping`, `falling`, `block`, `take hit`, `chop`, `fish`, `unleash`, `pet standing`, `pet walking`, plus all melee/ranged/magic/cowboy attack animations).
  - Each frame `1..985` indexes into pre-baked static arrays (`headX_array`, `headY_array`, `headRot_array`, `bodyX_array`, ..., `weaponLeftMatrix_array`, `weaponRightMatrix_array`) that apply exact `(x, y, scaleX, scaleY, rotation, skewX, skewY)` transforms to every body part and weapon on each tick (`updateFrame()`).
  - Frame script triggers are handled by `PersonFrameHandler.as` (spawning arrows/bullets/magic projectiles, playing swing sounds, creating slash trails, resetting `canDamage`).
- **Combat Moves Registry (`com/stats/Moves.as` & `MoveStat.as`)**:
  - Defines every attack animation's `startFrame`, `endFrame`, `hitStartFrame`, `hitEndFrame`, `damageMultiplier`, and MP cost (`BASIC_SLASH`, `SECOND_SLASH`, `THIRD_SLASH`, `FOURTH_SLASH`, `SPIN_ATTACK`, `LUNGE_ATTACK`, `DOWN_SLASH`, `DOWN_STAB`, `GROUND_STAB`, `CHAIN_ATTACK`, `BOW_SHOOT`, `TRIPLE_SHOT`, `ARROW_RAIN`, `GUN_SHOOT`, `SHOTGUN_SHOOT`, `BARRAGE`, `UPWARD_SHOOT`, `MAGIC_SHOOT`, `SUMMON_BEAM`, `THUNDER_ATTACK`, etc.).
- **Pet Animator (`com/game_objects/Pet.as` & `PetAI.as`)**:
  - Uses `Pet.petBodies_xml` (`pet_body_locations.xml`) to position modular pet body parts (`body`, `head`, `helmet`, `foot1`, `foot2`, `tail`, `wing1`, `wing2`, `hand1`, `hand2`) from `Assets.items_textureAtlas`.
  - Procedurally animates walking/jumping/attacking via sine-wave/tween limb rotations (`updateFrame()`).
  - Supports 5 modes (`com/stats/PetModeStat.as`):
    - `"a"` (Attack enemies), `"d"` (Defend owner), `"h"` (Heal owner), `"l"` (Loot items/coins), `"m"` (Mount — attaches pet inside `owner.bodyAnimator.pet` and switches player animations to `pet *`).
  - Inactive living pets spawn a floating `PetOrb` around their owner that grants stat bonuses (`power`, `range`, `magic`).
- **Enemy Animator & AI (`com/game_objects/enemies/Enemy.as` & `EnemyAI.as`)**:
  - Subclasses `starling.display.MovieClip` (47 concrete enemy classes in `com/game_objects/enemies/`).
  - Supports frame labels (`standing`/`walking`, `attack`, `hit`, `jump`, `shoot`).
  - `EnemyAI.as` runs deterministic movement/jumping/aggro logic synchronized across clients via `moveCounter`, `dirChangeTime`, and server `"eI"` / `"eSync"` messages.
  - Players with `hasEnemyControl` (PayVault item `enemycontrol`) can possess and manually control regular enemies via right-click -> `"control me"` (`"eControl"` / `"eNoControl"`).

### 5.4 Inventory, Equipment, Crafting, Bank, Vendors & Trading
- **Inventory (`GameMain.personItem_array`)**:
  - Stored as `Vector.<String>` of item names (`maxItems = 20` default, `30` with `moreitems`, `40` with `moremoreitems`).
  - Categorized by `Stats.getItemType(itemName)`: `"helmet"`, `"shirt"`, `"pants"`, `"shoes"`, `"weapon"`, `"accessory"`, `"pet helmet"`, `"item"`, `"fish"`.
- **Equipment Slots (`BodyAnimator` & `Person`)**:
  - 7 Player slots: `helmetFrame`, `shirtFrame`, `pantsFrame`, `shoeFrame`, `weaponFrame` (Primary), `weapon2Frame` (Off-hand / Shield / Dual-wield for Cowboys & Warriors), `accessoryFrame`.
  - 2 Pet slots per pet: `helmet_uint` (`petHelmets`), `shoes_uint` (shares player `shoeStats`).
  - Equipping calls `GameMain.equipItem(itemName, isSecondary)` -> sends `"giNewEquip"` (`itemName`, `itemType`, `isSecondary`) -> server validates & broadcasts `"nEq"` (`newEquipGot`).
- **Wood Chopping, Fishing & Crafting (`Tree.as`, `Fish.as`, `CraftingMenu.as`)**:
  - **Chopping**: Press `C` near a `Tree` -> plays `chop` animation -> sends `"treeHit"` -> server broadcasts `"treeDmg"`. Felled trees drop logs; players plant seeds (`"plant"`) to grow 3-stage trees and gain `choppingLvl` / `chopXP`.
  - **Fishing**: Equip `fishing pole` and press `C` near water -> casts `FishingLine` (`"line"`, `"lineIn"`). When `Fish` bites, player reels it in (`"fishGet"`) or swings a `net` (`"netSwing"`). Caught fish can be eaten for timed stat buffs (`"useFish"`) or used in crafting. `shiny` fish are tracked globally in `shinyFishData`.
  - **Crafting (`CraftingMenu.as`)**: Refining 10 logs into processed wood (NPCs 92/93/94) or combining wood + fish + monster drops + coins into equipment (`"craft"`, `itemName`, `itemType`).
- **ATM Bank (`BankMenu.as`)**:
  - Located in towns (Areas 12, 30, 55, 83, 97, 138). Stores coins (`"bankDep"`, `"bankW"`) and up to 13 items (`"bankItemDep"`, `"bankItemW"`, requires `bankitems` PayVault unlock).
- **Player Vending Machines & Pet Adoption (`VendingMachine.as`, `PetVendor.as`)**:
  - Players place permanent `item vendor` booths (`"setVendor"`) to sell up to 8 items and tickets for coins across all servers.
  - In Area 98 (Pet Adoption District), players place `pet vendor` cages (`"setPetVendor"`) to sell pets for coins or tickets (`"buyVPet"`).
- **Player-to-Player Trading (`TradeMenu.as`, `TradeRequest.as`)**:
  - Right-click player -> `"trade"` sends `"giTRequest"`. Target accepts (`"acceptT"`) -> opens `TradeMenu`.
  - Players add items (`"tItem"`), coins (`"tMoney"`), pets (`"tPet"`), or tickets (`"tTickets"`), chat (`"tChat"`), lock (`"tConfirm"`), and finalize (`"tFinal"` -> server responds with `"tVerified"`).

### 5.5 Combat, Skills, Energy Unleash & PvP/PvE
- **Input & Move Execution (`PersonKeyHandler.as` & `MoveHandler.as`)**:
  - Keyboard (`WASD` / Arrows, `Space` Attack, `B` Forward Attack, `N` Down Attack, `M` Up Attack, `V` Block/Secondary, `C` Chop/Fish/Skill, `E` Loot, `R` Self Rage, `T` Guild Rage, `H` Self Heal, `G` Guild Heal, `K` Special/Fart, `Y` Unleash Energy, `Q` Pet Bubble, `Z` Toggle Pet/Enemy Manual Control, `L` Quick Item).
  - `PersonKeyHandler` translates key presses into network packets (`"kd"`, `"ku"`) and triggers `MoveHandler` to transition `BodyAnimator` into the appropriate attack/skill animation based on equipped weapon type (Melee, Bow, Gun, Wand/Staff) and learned skills.
- **Hit Detection (`HitTester.as` & `Projectile.as`)**:
  - **Client-Authoritative Hit Detection with Server Damage Validation**:
    - Local client checks intersections between `player.bodyAnimator.weaponLeft_sprite` / `weaponRight_sprite` (or `Projectile` bounds) and `enemy.hitTester.hit_rect` (or remote `person.hitTester.hit_rect` in PvP).
    - On melee hit against an enemy, client sends `"dmg"` (`enemyName`, `moveDir`, `attackType`, `isSecondaryWeapon`, `expectedHealth`).
    - On projectile hit against an enemy, client sends `"pHitE"` (`enemyName`, `moveDir`, `isMagic`, `isSecondary`, `attackType`, `hitCount`).
    - Server calculates actual damage, crits, knockback, and elemental status effects (Fire DoT, Ice Freeze, Shock stun) and broadcasts `"eD"` (`enemyDamagedGot`) and `"x"` (`updatePersonXP`) / `"petXP"` (`updatePetXP`).
    - Enemy contact damage against the local player is checked every 32 frames in `onEnemy` (`GameMain.as:L13026`) -> sends `"dmgP"` (`enemyName`, `isBlocking`) -> server broadcasts `"pD"` (`playerDamaged`).
- **Boss Fights**:
  - **Giant Goo Cube** (Area 27), **Carnelia** (Area 72), **Kreetus** (Area 116): Feature dedicated boss health bar in `Controls`, minion `HealingCircle` mechanics (`L13030-13065`), and `BeholderCannon` destructible turrets in Area 116.
- **Energy Unleash System (`EnergyController.as` & `PowerUpVisuals.as`)**:
  - Players accumulate 8 sub-bars of energy (`charge`, `absorbed`, `level`, `enemy`, `pvp`, `random`, `chop`, `fish`).
  - Holding `Y` charges energy (`"eCharge"`); releasing unleashes an anime-style aura (`"unleash"` -> `powerUnleashed`), boosting stats, spawning `UpRock`s, `GroundBolt`s, screen shake, and `SlashEffect`s with hit-stop (`hitStopCounter = -3`).
- **PvP & Guild vs Guild (GvG)**:
  - `isPvpArea` (`GameMain.as:L8853`) is `true` on the `"PvP Server"` or in **Areas 112, 113, and 114** (Area 114 is Guild vs Guild, where same-guild members cannot damage each other: `L10910`).

### 5.6 UI Architecture (`Controls`, `StarlingGameMenu`, `GameMenu`)
- **HUD (`com/ui/Controls.as`)**:
  - Rendered in Starling (`starlingStage.controls`).
  - Top-left: Health bar, MP bar, Energy bar (`energy_btn`), Level & XP bar, Money counter, active Pet health/XP bars.
  - Top-right menu bar: `char_btn` (`CharacterMenu`), `items_btn` (`ItemMenu`), `pets_btn` (`PetMenu`), `friends_btn` (`FriendMenu`), `missions_btn` (`MissionMenu`), `map_btn` (`MapMenu`), `heropedia_btn` (`HeropediaMenu`), `payvault_btn` (`PayVaultMenu`), `options_btn` (`OptionMenu`).
  - Bottom-center: Chat log (`chat_txt`), chat input (`message_txt`), and quick-slot item button.
  - Mobile mode (`GameMain.isMobile`): Adds virtual thumbstick (`analogStick_btn`) and touch action buttons (`attack_btn`, `jump_btn`, `block_btn`, `loot_btn`, `chopFish_btn`, `unleash_btn`, `etc_btn`).
- **Dual Menu System**:
  - **`StarlingGameMenu` (`com/menus/StarlingGameMenu.as`)**: GPU-accelerated draggable windows built from sprite sheet atlases (`CharacterMenu`, `ItemMenu`, `MapMenu`, `CreateMenu`, `PetMenu`, `PetModeMenu`, `PetItemMenu`, `SkillsMenu`, `FriendMenu`, `GuildMemberMenu`, `HeropediaMenu`, `EnergyMenu`, `TalkBox`, `LoadScreen`, `TradeMenu`, `PresentMenu`, `AlertMenu`, `ConfirmMenu`).
  - **`GameMenu` (`com/menus/GameMenu.as`)**: Classic Flash `MovieClip` windows added to the native stage (`MainMenu`, `PayVaultMenu`, `GuildMenu`, `BankMenu`, `PMMenu`, `LotteryMenu`, `CraftingMenu`, `PetShopMenu`, `PetConfirmMenu`, `PetVendMenu`, `FishListMenu`, `RankMenu`, `MissionMenu`, `OptionMenu`, `InfoMenu`, `UpdateMenu`, `DeadMenu`, `ConnectMenu`, `DebugMenu`, `BullhornMenu`, `ModeratorMenu`).
