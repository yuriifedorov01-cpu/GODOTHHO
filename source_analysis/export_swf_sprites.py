import os
import json
import subprocess

BASE_DIR = r"D:\PERENOS_GODOT\source_analysis\decompiled_mygame"
OUT_DIR = r"D:\PERENOS_GODOT\assets\extracted"
SPRITES_DIR = os.path.join(OUT_DIR, "swf_sprites")
JAVA_EXE = r"D:\PERENOS_GODOT\tools\jre\bin\java.exe"
FFDEC_JAR = r"D:\PERENOS_GODOT\tools\ffdec\ffdec.jar"
SWF_PATH = r"D:\HHT_CLIENT\MyGame.swf"

with open(os.path.join(OUT_DIR, "embedded_images_map.json"), "r", encoding="utf-8") as f:
    emap = json.load(f)

tilesets = emap["tilesetSymbols"]
vectors = emap["vectorMonsterAndFxSymbols"]

# Also include ambient/hazard gameplay sprites from symbols.csv
extra_gameplay_classes = [
    "fairyareawhole_fla.bouncepad_2",
    "area_fla.mushroombouncer_27",
    "MyGame_fla.kreetusteethanimation_121",
    "com.game_objects.BeholderCannon",
    "com.game_objects.Cloud",
    "EnvironmentProjectile",
    "com.game_objects.BushShooter",
    "MushroomSpike",
    "Pendulum",
    "com.game_objects.RobotAlarmBuilding",
    "com.game_objects.StandSwitch",
    "DarknessBall",
    "FlyAnimation",
    "Arrow",
    "LightningBolt",
    "SplashAnimation",
    "InteractBubble",
    "com.game_objects.ambient_objects.Portal",
    "Halo"
]

extra_symbols = []
for cname in extra_gameplay_classes:
    cid = emap["symbolsByName"].get(cname)
    if cid is not None:
        extra_symbols.append({"characterId": cid, "symbolClass": cname})

all_to_export = tilesets + vectors + extra_symbols
ids_str = ",".join(str(x["characterId"]) for x in all_to_export)

print(f"Exporting {len(all_to_export)} DefineSprite symbols ({len(tilesets)} tilesets, {len(vectors)} vectors, {len(extra_symbols)} gameplay objects)...")
cmd = [
    JAVA_EXE, "-jar", FFDEC_JAR,
    "-selectid", ids_str,
    "-format", "sprite:png",
    "-export", "sprite",
    SPRITES_DIR,
    SWF_PATH
]
res = subprocess.run(cmd, capture_output=True, text=True)
print("FFDec exit code:", res.returncode)
if res.returncode != 0:
    print("STDERR:", res.stderr[-1000:])
else:
    lines = res.stdout.strip().splitlines()
    print("Last lines of FFDec stdout:", "\n".join(lines[-5:]))

# Now scan SPRITES_DIR and update embedded_images_map.json with swfSpritesMap
exported_sprites = {}
for folder in sorted(os.listdir(SPRITES_DIR)):
    fpath = os.path.join(SPRITES_DIR, folder)
    if not os.path.isdir(fpath):
        continue
    pngs = sorted([f for f in os.listdir(fpath) if f.endswith(".png")], key=lambda x: int(os.path.splitext(x)[0]) if os.path.splitext(x)[0].isdigit() else x)
    # folder format: DefineSprite_<id>_<ClassName>
    parts = folder.split("_", 2)
    cid = int(parts[1]) if len(parts) >= 2 and parts[1].isdigit() else None
    cname = parts[2] if len(parts) >= 3 else folder
    exported_sprites[cname] = {
        "characterId": cid,
        "symbolClass": cname,
        "folderName": folder,
        "relativePath": f"swf_sprites/{folder}",
        "fullPath": fpath.replace("\\", "/"),
        "frameCount": len(pngs),
        "frames": [f"swf_sprites/{folder}/{p}" for p in pngs]
    }

emap["exportedSwfSpritesCount"] = len(exported_sprites)
emap["exportedSwfSprites"] = exported_sprites

with open(os.path.join(OUT_DIR, "embedded_images_map.json"), "w", encoding="utf-8") as f:
    json.dump(emap, f, indent=2, ensure_ascii=False)
print(f"Updated embedded_images_map.json with {len(exported_sprites)} exported SWF sprite directories.")
