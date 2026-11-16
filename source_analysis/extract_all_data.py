import os
import re
import json
import math

BASE_DIR = r"D:\PERENOS_GODOT\source_analysis\decompiled_mygame"
OUT_DIR = r"D:\PERENOS_GODOT\assets\extracted"
os.makedirs(OUT_DIR, exist_ok=True)

def read_text(rel_path):
    with open(os.path.join(BASE_DIR, rel_path), "r", encoding="utf-8", errors="replace") as f:
        return f.read()

# ==============================================================================
# 1. BODY ANIMATOR & PERSON FRAME HANDLER -> body_animator_data.json
# ==============================================================================
print("Extracting body_animator_data.json...")
ba_text = read_text(r"scripts\com\game_objects\extensions\BodyAnimator.as")
pfh_text = read_text(r"scripts\com\game_objects\extensions\PersonFrameHandler.as")
moves_text = read_text(r"scripts\com\stats\Moves.as")

# 1a. Item offset arrays (weaponsX_array, etc.)
offset_arrays = {}
offset_pattern = re.compile(r"(\w+_array)\.push\(([-0-9.,\s]+)\);")
for m in offset_pattern.finditer(ba_text):
    arr_name = m.group(1)
    vals_str = m.group(2)
    vals = [float(x.strip()) if '.' in x else int(x.strip()) for x in vals_str.split(',') if x.strip()]
    offset_arrays[arr_name] = vals

# 1b. frameLabels
fl_match = re.search(r"frameLabels\.push\((.*?)\);", ba_text, re.DOTALL)
frame_labels = []
if fl_match:
    frame_labels = [x.strip() for x in re.findall(r'"([^"]*)"', fl_match.group(1))]

# 1c. Matrix arrays pushed in constructor
matrix_names = [
    "headMatrix_array",
    "bodyMatrix_array",
    "leftArmMatrix_array",
    "rightArmMatrix_array",
    "leftLegMatrix_array",
    "rightLegMatrix_array",
    "weapon1Matrix_array",
    "weapon2Matrix_array",
    "accMatrix_array"
]

raw_matrices = {}
decomposed_arrays = {}

part_prefix_map = {
    "headMatrix_array": ("head", None),
    "bodyMatrix_array": ("body", None),
    "leftArmMatrix_array": ("leftArm", "armLeft"),
    "rightArmMatrix_array": ("rightArm", "armRight"),
    "leftLegMatrix_array": ("leftLeg", "legLeft"),
    "rightLegMatrix_array": ("rightLeg", "legRight"),
    "weapon1Matrix_array": ("weapon1", "weaponLeft"),
    "weapon2Matrix_array": ("weapon2", "weaponRight"),
    "accMatrix_array": ("acc", "accessory")
}

for mname in matrix_names:
    m_match = re.search(rf"{mname}\.push\((.*?)\);", ba_text, re.DOTALL)
    if not m_match:
        print(f"WARNING: {mname} not found!")
        continue
    content = m_match.group(1)
    mat_tuples = re.findall(r"new Matrix\(([^)]+)\)", content)
    mats = []
    xs, ys, rots, sxs, sys_arr = [], [], [], [], []
    for mt in mat_tuples:
        nums = [float(x.strip()) for x in mt.split(",")]
        a, b, c, d, tx, ty = nums
        mats.append([a, b, c, d, tx, ty])
        xs.append(tx)
        ys.append(ty)
        rot_rad = math.atan2(b, a)
        rots.append(round(rot_rad, 6))
        sx = math.hypot(a, b)
        if a < 0 and abs(b) < 0.3:
            sx = -sx
            rots[-1] = round(math.atan2(b, -a), 6)
        sy = math.hypot(c, d)
        sxs.append(round(sx, 4))
        sys_arr.append(round(sy, 4))
    raw_matrices[mname] = mats
    p1, p2 = part_prefix_map[mname]
    for p in ([p1, p2] if p2 else [p1]):
        raw_matrices[f"{p}Matrix_array"] = mats
        decomposed_arrays[f"{p}X_array"] = xs
        decomposed_arrays[f"{p}Y_array"] = ys
        decomposed_arrays[f"{p}Rot_array"] = rots
        decomposed_arrays[f"{p}ScaleX_array"] = sxs
        decomposed_arrays[f"{p}ScaleY_array"] = sys_arr

# 1d. Parse Moves.as first so we have endFrame and resetFrameString for animations
const_map = {}
for m in re.finditer(r'public static const (\w+):String\s*=\s*"([^"]+)";', moves_text):
    const_map[m.group(1)] = m.group(2)

key_map = {
    "0": 0,
    "Keyboard.UP": 38,
    "Keyboard.DOWN": 40,
    "Keyboard.LEFT": 37,
    "Keyboard.RIGHT": 39,
    "Keyboard.SPACE": 32
}

moves_list = []
moves_by_name = {}

# Parse MoveStat blocks in Moves.as
move_blocks = re.split(r'(?=(?:private static var )?moveStat(?::MoveStat)?\s*=\s*new MoveStat)', moves_text)
for blk in move_blocks:
    m = re.search(
        r'new MoveStat\(\s*(\w+)\s*,\s*([^,]+)\s*,\s*([^,]+)\s*,\s*(\d+)\s*,\s*(\d+)\s*(?:,\s*"([^"]*)"\s*(?:,\s*(\d+)\s*(?:,\s*([\w\.]+))?)?)?\s*\)',
        blk
    )
    if not m:
        continue
    const_name = m.group(1)
    move_name = const_map.get(const_name, const_name)
    earliest_str = m.group(2).strip()
    earliest_combo = 4294967295 if "MAX_VALUE" in earliest_str else int(earliest_str)
    end_str = m.group(3).strip()
    end_frame = 4294967295 if "MAX_VALUE" in end_str else int(end_str)
    start_dmg = int(m.group(4))
    end_dmg = int(m.group(5))
    reset_str = m.group(6) if m.group(6) is not None else "standing"
    charge_frame = int(m.group(7)) if m.group(7) is not None else 0
    key_str = m.group(8) if m.group(8) is not None else "0"

    hr_m = re.search(r'moveStat\.__hitRot\s*=\s*(-?\d+);', blk)
    kb_m = re.search(r'moveStat\.__knockback\s*=\s*(-?\d+);', blk)
    hit_rot = int(hr_m.group(1)) if hr_m else 0
    knockback = int(kb_m.group(1)) if kb_m else 5

    obj = {
        "constName": const_name,
        "name": move_name,
        "earliestCombo": earliest_combo,
        "endFrame": end_frame,
        "startDmgFrame": start_dmg,
        "endDmgFrame": end_dmg,
        "resetFrameString": reset_str,
        "chargeFrame": charge_frame,
        "key1": key_str,
        "keyCode": key_map.get(key_str, 0),
        "hitRot": hit_rot,
        "knockback": knockback
    }
    moves_list.append(obj)
    moves_by_name[move_name] = obj

# Parse loop frames from PersonFrameHandler.handleLoopFrames
loop_resets = {
    49: {"target": "standing", "isLoop": True},
}
for m in re.finditer(r'case (\d+):\s*this\.person\.bodyAnimator\.gotoAndPlay\("([^"]+)"\);', pfh_text):
    f_idx = int(m.group(1))
    target = m.group(2)
    loop_resets[f_idx] = {"target": target, "isLoop": True}

for mv in moves_list:
    if mv["endFrame"] < 10000:
        loop_resets[mv["endFrame"]] = {"target": mv["resetFrameString"], "isLoop": False}

animations = []
animations_by_name = {}
if frame_labels:
    cur_label = frame_labels[0]
    start_f = 0
    for idx in range(1, len(frame_labels)):
        lbl = frame_labels[idx]
        if lbl != cur_label:
            end_f = idx - 1
            if cur_label != "":
                reset_info = loop_resets.get(end_f, None)
                is_loop = (reset_info is not None and reset_info["target"] == cur_label)
                reset_to = reset_info["target"] if reset_info else None
                anim_obj = {
                    "name": cur_label,
                    "startFrame": start_f,
                    "endFrame": end_f,
                    "startFrame1Based": start_f + 1,
                    "endFrame1Based": end_f + 1,
                    "length": end_f - start_f + 1,
                    "loop": is_loop,
                    "resetTo": reset_to
                }
                animations.append(anim_obj)
                animations_by_name[cur_label] = anim_obj
            cur_label = lbl
            start_f = idx
    end_f = len(frame_labels) - 1
    if cur_label != "":
        reset_info = loop_resets.get(end_f, None)
        is_loop = (reset_info is not None and reset_info["target"] == cur_label)
        reset_to = reset_info["target"] if reset_info else None
        anim_obj = {
            "name": cur_label,
            "startFrame": start_f,
            "endFrame": end_f,
            "startFrame1Based": start_f + 1,
            "endFrame1Based": end_f + 1,
            "length": end_f - start_f + 1,
            "loop": is_loop,
            "resetTo": reset_to
        }
        animations.append(anim_obj)
        animations_by_name[cur_label] = anim_obj

# Backfill startFrame in moves_list
for mv in moves_list:
    ainfo = animations_by_name.get(mv["name"], {})
    mv["startFrame"] = ainfo.get("startFrame", None)

frame_addons = {
    "slashes": [
        {"frame": 76, "type": "slash 1", "x": 15.65, "y": -11.35, "pivotX": 0, "pivotY": 0, "rotation": 0, "scaleX": 1, "scaleY": 1, "duration": 2},
        {"frame": 97, "type": "slash 2", "x": 18.85, "y": 5.5, "pivotX": 0, "pivotY": 0, "rotation": 0, "scaleX": 1, "scaleY": 1, "duration": 2},
        {"frame": 115, "type": "slash 3", "x": 0.4, "y": -32.6, "pivotX": 0, "pivotY": 0, "rotation": 0, "scaleX": 1, "scaleY": 1, "duration": 2},
        {"frame": 130, "type": "slash 2", "x": 17.85, "y": 4.5, "pivotX": 0, "pivotY": 0, "rotation": 0, "scaleX": 1, "scaleY": 1, "duration": 2},
        {"frame": 161, "type": "slash 3", "x": 16.4, "y": -30.6, "pivotX": 0, "pivotY": 0, "rotation": 0, "scaleX": 1, "scaleY": 1, "duration": 2},
        {"frame": 176, "type": "slash 4", "x": -10, "y": -51, "pivotX": 0, "pivotY": 0, "rotation": 0, "scaleX": 1, "scaleY": 1, "duration": 2},
        {"frame": 203, "type": "slash 2", "x": 20.85, "y": 2.5, "pivotX": 0, "pivotY": 0, "rotation": 0, "scaleX": 1, "scaleY": 1, "duration": 2},
        {"frame": 258, "type": "slash 1", "x": 10.65, "y": 2.65, "pivotX": 0, "pivotY": 0, "rotation": 0, "scaleX": 1, "scaleY": 1, "duration": 2},
        {"frame": 421, "type": "slash 1", "x": 16.65, "y": -20.35, "pivotX": 0, "pivotY": 0, "rotation": 0, "scaleX": 1, "scaleY": 1, "duration": 2},
        {"frame": 432, "type": "slash 3", "x": -22.6, "y": -44.6, "pivotX": 0, "pivotY": 0, "rotation": 0, "scaleX": 1, "scaleY": 1, "duration": 2},
        {"frame": 442, "type": "slash 1", "x": -2.35, "y": -14.35, "pivotX": 0, "pivotY": 0, "rotation": 0, "scaleX": 1, "scaleY": 1, "duration": 2},
        {"frame": 456, "type": "slash 4", "x": 51.35, "y": -2.7, "pivotX": 43.35, "pivotY": 23.3, "rotation": 0.2564, "scaleX": 1, "scaleY": 1, "duration": 2},
        {"frame": 472, "type": "slash 2", "x": 32.85, "y": -5.5, "pivotX": 0, "pivotY": 0, "rotation": 0, "scaleX": 1, "scaleY": 1, "duration": 2},
        {"frame": 484, "type": "slash 1", "x": 20.65, "y": -21.35, "pivotX": 0, "pivotY": 0, "rotation": 0, "scaleX": 1, "scaleY": 1, "duration": 2},
        {"frame": 798, "type": "slash 4", "x": 25.35, "y": -19.7, "pivotX": 43.35, "pivotY": 23.3, "rotation": 0, "scaleX": 1, "scaleY": 1, "duration": 2},
        {"frame": 829, "type": "slash 4", "x": 45.35, "y": 6.3, "pivotX": 43.35, "pivotY": 23.3, "rotation": 0.7854, "scaleX": 1, "scaleY": 1, "duration": 2},
        {"frame": 844, "type": "slash 1", "x": 16.65, "y": -13.35, "pivotX": 0, "pivotY": 0, "rotation": 0, "scaleX": 1, "scaleY": 1, "duration": 2},
        {"frame": 872, "type": "slash 1", "x": 68, "y": 46.5, "pivotX": 30.35, "pivotY": 31.85, "rotation": 0.2602, "scaleX": 1, "scaleY": 1, "duration": 2},
        {"frame": 943, "type": "slash 1", "x": 35, "y": -13.35, "pivotX": 0, "pivotY": 0, "rotation": 0, "scaleX": 1, "scaleY": 1, "duration": 2},
        {"frame": 947, "type": "slash 1", "x": 115.85, "y": 13.7, "pivotX": 30.35, "pivotY": 31.85, "rotation": 0, "scaleX": -1, "scaleY": 1, "duration": 3},
        {"frame": 950, "type": "slash 1", "x": 35, "y": -13.35, "pivotX": 0, "pivotY": 0, "rotation": 0, "scaleX": 1, "scaleY": 1, "duration": 3},
        {"frame": 953, "type": "slash 1", "x": 115.85, "y": 13.7, "pivotX": 30.35, "pivotY": 31.85, "rotation": 0, "scaleX": -1, "scaleY": 1, "duration": 2}
    ],
    "gunFlashes": [
        {"frame": 698, "x": 85.05, "y": -3.15, "rotation": 0},
        {"frame": 702, "x": 85.05, "y": -3.15, "rotation": 0},
        {"frame": 705, "x": 85.05, "y": -3.15, "rotation": 0},
        {"frame": 709, "x": 98.05, "y": -3.15, "rotation": 0},
        {"frame": 768, "x": 84.05, "y": -4.15, "rotation": 0},
        {"frame": 808, "x": 69.05, "y": -23.15, "rotation": 0},
        {"frame": 864, "x": 15.85, "y": -82.55, "rotation": -1.309},
        {"frame": 868, "x": 15.85, "y": -82.55, "rotation": -1.309},
        {"frame": 884, "x": 111.05, "y": -4.15, "rotation": 0},
        {"frame": 911, "x": 87.3, "y": 54.8, "rotation": 0.7854},
        {"frame": 916, "x": 87.3, "y": 54.8, "rotation": 0.7854}
    ],
    "fartPuffFrame": 681
}

person_frame_triggers = {
    "loopAndResetFrames": {str(k): v for k, v in sorted(loop_resets.items())},
    "footstepSoundFrames": [54, 65, 622, 631],
    "swimSoundFrames": [243],
    "eatSoundFrames": [306, 314],
    "chopFrames": {
        "checkTree": 329,
        "swingSound": 333,
        "hitTree": 334,
        "endChop": 343
    },
    "fishingFrames": {
        "castSound": 359,
        "createLine": 362,
        "idleStart": 369,
        "idleLoopEnd": 417
    },
    "meleeSwingSoundFrames": [76, 97, 115, 130, 146, 161, 176, 190, 203, 217, 258, 843, 871, 797, 829, 943, 946, 949, 953, 421, 432, 442, 456, 472, 484, 608],
    "rangedProjectileFrames": {
        "shootGun1": [699, 706],
        "shootGun2": [702, 709],
        "shootUpward1": [864],
        "shootUpward2": [868],
        "shootJumpDown1": [911],
        "shootJumpDown2": [916],
        "shootSingleGun": [768, 808],
        "shootShotgun": [884],
        "throwGrenade": [892],
        "throwJumpGrenade": [926],
        "shootMagic": [715, 725, 738, 756, 801],
        "shootArrow": [721, 734, 745, 804],
        "barrageArrows": [855, 856, 857],
        "tripleShot": [902],
        "arrowRain": [939],
        "piercingArrow": [972],
        "homingLaser": [988],
        "summonBeam": [836],
        "downCrushImpact": [874]
    }
}

body_animator_data = {
    "totalFrames": len(frame_labels),
    "frameLabels": frame_labels,
    "animations": animations,
    "animationsByName": animations_by_name,
    "matrices": raw_matrices,
    "decomposed": decomposed_arrays,
    "itemOffsets": offset_arrays,
    "frameAddons": frame_addons,
    "personFrameTriggers": person_frame_triggers
}

with open(os.path.join(OUT_DIR, "body_animator_data.json"), "w", encoding="utf-8") as f:
    json.dump(body_animator_data, f, indent=2, ensure_ascii=False)
print(f"Saved body_animator_data.json: {len(frame_labels)} frames, {len(animations)} animations, {len(raw_matrices['headMatrix_array'])} matrix frames.")

# ==============================================================================
# 2. MOVES DATA -> moves_data.json
# ==============================================================================
moves_data = {
    "attackResetTime": 22,
    "totalMoves": len(moves_list),
    "moves": moves_list,
    "movesByName": moves_by_name
}
with open(os.path.join(OUT_DIR, "moves_data.json"), "w", encoding="utf-8") as f:
    json.dump(moves_data, f, indent=2, ensure_ascii=False)
print(f"Saved moves_data.json: {len(moves_list)} moves.")

# ==============================================================================
# 3. SKILLS META -> skills_meta.json
# ==============================================================================
print("Extracting skills_meta.json...")
stats_text = read_text(r"scripts\com\stats\Stats.as")
person_text = read_text(r"scripts\com\game_objects\Person.as")

person_mp_consts = {}
for m in re.finditer(r'public static const (\w+_MP|SUMMON_PET_FWD):\*\s*=\s*(\d+);|public static const (\w+_MP|SUMMON_PET_FWD):int\s*=\s*(\d+);', person_text):
    k = m.group(1) or m.group(3)
    v = int(m.group(2) or m.group(4))
    person_mp_consts[k] = v

skills_base = {}
for m in re.finditer(r'setNewSkill\("([^"]+)",\s*([^,]+),\s*(\d+)\);', stats_text):
    sname = m.group(1)
    max_str = m.group(2).strip()
    max_lvl = 2147483647 if "MAX_VALUE" in max_str else int(max_str)
    req_pts = int(m.group(3))
    skills_base[sname] = {
        "id": sname,
        "maxLvl": max_lvl,
        "requiredSkillPointsPerUpgrade": req_pts
    }

# Also include the 4 extra skills in SkillsMenu.as that aren't in Stats.setNewSkill (summon pets, chain distance, homing laser, mind control)
extra_skills_in_menu = {
    "summon pets": {"id": "summon pets", "maxLvl": 20, "requiredSkillPointsPerUpgrade": 1},
    "chain distance": {"id": "chain distance", "maxLvl": 15, "requiredSkillPointsPerUpgrade": 1},
    "homing laser": {"id": "homing laser", "maxLvl": 10, "requiredSkillPointsPerUpgrade": 2},
    "mind control": {"id": "mind control", "maxLvl": 10, "requiredSkillPointsPerUpgrade": 2}
}
for k, v in extra_skills_in_menu.items():
    if k not in skills_base:
        skills_base[k] = v

skill_details = {
    "jump height": {"category": "basic", "iconTexture": "jump icon", "personProperty": "jumpSkillLvl", "title": "Jump", "mpCost": 0, "useKey": "W / UP", "description": "Increases the height of your jump.", "formula": "jumpPower = 11 + jumpSkillLvl * 0.25", "effectText": "jump + (lvl - 1)"},
    "critical hit": {"category": "basic", "iconTexture": "critical icon", "personProperty": "criticalLvl", "title": "Critical", "mpCost": 0, "useKey": "Passive", "description": "Gives a higher chance of doing critical damage to enemies. Critical attacks do 150% normal damage.", "formula": "critChancePercent = (criticalLvl - 1) * 2.5", "effectText": "(lvl - 1) * 2.5% chance"},
    "loot steal": {"category": "basic", "iconTexture": "loot steal icon", "personProperty": "lootStealLvl", "title": "Loot Steal", "mpCost": 0, "useKey": "Passive", "description": "Decreases the time needed before you are allowed to steal someone's item drop.", "formula": "waitSeconds = 11 - (lootStealLvl - 1) * 0.6", "effectText": "wait 11 - (lvl - 1) * 0.6 seconds"},
    "training": {"category": "basic", "iconTexture": "training icon", "personProperty": "trainingLvl", "title": "Training", "mpCost": 0, "useKey": "Passive", "description": "Adds onto the amount of XP gained per kill.", "formula": "xpBonusPercent = (trainingLvl - 1) * 2.5", "effectText": "+(lvl - 1) * 2.5% more XP"},
    "self rage": {"category": "basic", "iconTexture": "self rage icon", "personProperty": "selfRageLvl", "title": "Self Rage", "mpCost": 35, "useKey": "R", "description": "Temporarily boosts your power, magic, range, or artillery.", "formula": "statBoost = (selfRageLvl - 1) * 6", "effectText": "+((lvl - 1) * 6) to stats"},
    "guild rage": {"category": "basic", "iconTexture": "guild rage icon", "personProperty": "guildRageLvl", "title": "Guild Rage", "mpCost": 45, "useKey": "T", "description": "Temporarily boosts you and surrounding guild members' power, magic, range, or artillery.", "formula": "statBoost = (guildRageLvl - 1) * 3", "effectText": "+((lvl - 1) * 3) to stats"},
    "avoidability": {"category": "basic", "iconTexture": "avoidability icon", "personProperty": "avoidabilityLvl", "title": "Avoidability", "mpCost": 0, "useKey": "Passive", "description": "Allows a chance to avoid getting hit by an enemy.", "formula": "avoidChancePercent = (avoidabilityLvl - 1) * 2", "effectText": "(lvl - 1) * 2% chance to avoid"},
    "mp restore": {"category": "basic", "iconTexture": "mp restore icon", "personProperty": "mpRestoreLvl", "title": "MP Restore", "mpCost": 0, "useKey": "Passive", "description": "Automatically regenerates MP every 10 seconds.", "formula": "mpPer10Sec = (mpRestoreLvl - 1) * 7", "effectText": "+((lvl - 1) * 7) MP every 10 seconds"},
    "speed dash": {"category": "basic", "iconTexture": "dash icon", "personProperty": "dashLvl", "title": "Dash", "mpCost": 3, "useKey": "Double-tap Left/Right", "description": "Allows you to dash left or right at a faster speed.", "formula": "dashSpeedBonus = (dashLvl - 1) * 3", "effectText": "+((lvl - 1) * 3) to speed"},
    "accel down": {"category": "basic", "iconTexture": "accelerate down icon", "personProperty": "accelDownLvl", "title": "Accelerate Down", "mpCost": 0, "useKey": "S / DOWN (in air)", "description": "Accelerate downwards when jumping.", "formula": "fallSpeedBonus = (accelDownLvl - 1) * 2", "effectText": "+((lvl - 1) * 2) to downward speed"},
    "summon pets": {"category": "basic", "iconTexture": "summon pets icon", "personProperty": "summonPetLvl", "title": "Summon Pets Forward", "mpCost": 15, "useKey": "Y", "description": "Summon your active pets forward to do a quick attack.", "formula": "petDamagePercent = 100 + (summonPetLvl - 2) * 14 (0 at lvl 1)", "effectText": "Pets do 100 + (lvl - 2) * 14% damage"},
    "block": {"category": "warrior", "iconTexture": "block icon", "personProperty": "blockLvl", "title": "Block", "mpCost": 2, "useKey": "Q (Hold)", "description": "Allows you to reduce the damage taken by an enemy.", "formula": "damageReducedPercent = (blockLvl - 1) * 6", "effectText": "(lvl - 1) * 6% damage reduced"},
    "down crush": {"category": "warrior", "iconTexture": "down crush icon", "personProperty": "downCrushLvl", "title": "Down Crush", "mpCost": 3, "useKey": "C (in air)", "description": "Jump and perform a downward stab onto enemies.", "formula": "damagePercent = (downCrushLvl > 1 ? 100 + (downCrushLvl - 1) * 18 : 0)", "effectText": "100 + (lvl - 1) * 18% damage"},
    "power attack": {"category": "warrior", "iconTexture": "power attack icon", "personProperty": "powerAttackLvl", "title": "Power Attack", "mpCost": 6, "useKey": "C", "description": "Take a lunge forward and perform a powerful melee attack.", "formula": "damagePercent = (powerAttackLvl > 1 ? 100 + (powerAttackLvl - 1) * 14 : 0)", "effectText": "100 + (lvl - 1) * 14% damage"},
    "expert warrior": {"category": "warrior", "iconTexture": "expert warrior icon", "personProperty": "expertWarriorLvl", "title": "Expert Warrior", "mpCost": 0, "useKey": "Passive", "description": "Decreases the variance in damage done with melee weapons.", "formula": "minDamageMasteryPercent = (expertWarriorLvl - 1) * 7", "effectText": "(lvl - 1) * 7% mastery"},
    "chain distance": {"category": "warrior", "iconTexture": "chain distance icon", "personProperty": "chainDistanceLvl", "title": "Chain Distance", "mpCost": 0, "useKey": "Passive", "description": "Increases the distance of your chain attack when using chain weapons.", "formula": "extraDistance = (chainDistanceLvl - 1) * 10", "effectText": "+((lvl - 1) * 10) distance"},
    "shield mastery": {"category": "warrior", "iconTexture": "shield mastery icon", "personProperty": "shieldMasteryLvl", "title": "Shield Mastery", "mpCost": 0, "useKey": "Passive", "description": "Boosts the defense of your shield if you have one equipped.", "formula": "shieldDefenseBoostPercent = (shieldMasteryLvl - 1) * 6", "effectText": "+(lvl - 1) * 6% shield defense"},
    "multi attack": {"category": "warrior", "iconTexture": "multi attack icon", "personProperty": "multiAttackLvl", "title": "Multi-Attack", "mpCost": 8, "useKey": "V", "description": "Allows you to quickly perform multiple melee attacks.", "formula": "damagePercent = (multiAttackLvl > 1 ? 30 + (multiAttackLvl - 1) * 15 : 0)", "effectText": "30 + (lvl - 1) * 15% damage per hit"},
    "melee knockback": {"category": "warrior", "iconTexture": "melee knockback icon", "personProperty": "meleeKnockbackLvl", "title": "Melee Knockback", "mpCost": 0, "useKey": "Passive", "description": "Increases the knockback of your melee weapons.", "formula": "knockbackBonus = (meleeKnockbackLvl - 1) * 1.5", "effectText": "+((lvl - 1) * 1.5) knockback"},
    "air slash": {"category": "warrior", "iconTexture": "air slash icon", "personProperty": "airSlashLvl", "title": "Air Slash", "mpCost": 6, "useKey": "E (Hold & Release)", "description": "Charge your melee weapon and unleash a flying slash projectile.", "formula": "damagePercent = (airSlashLvl > 1 ? 75 + (airSlashLvl - 2) * 16 : 0)", "effectText": "75 + (lvl - 2) * 16% damage"},
    "spin attack": {"category": "warrior", "iconTexture": "spin attack icon", "personProperty": "spinAttackLvl", "title": "Spin Attack", "mpCost": 5, "useKey": "V (in air)", "description": "Jump and spin in a circle to hit surrounding enemies.", "formula": "damagePercent = (spinAttackLvl > 1 ? 100 + (spinAttackLvl - 1) * 9 : 0)", "effectText": "100 + (lvl - 1) * 9% damage"},
    "arrow barrage": {"category": "archer", "iconTexture": "barrage icon", "personProperty": "barrageLvl", "title": "Arrow Barrage", "mpCost": 7, "useKey": "C", "description": "Shoot a quick barrage of 3 arrows.", "formula": "damagePercentPerArrow = (barrageLvl > 1 ? 32 + (barrageLvl - 1) * 8 : 0)", "effectText": "32 + (lvl - 1) * 8% damage per arrow"},
    "arrow knockback": {"category": "archer", "iconTexture": "arrow knockback icon", "personProperty": "arrowKnockbackLvl", "title": "Arrow Knockback", "mpCost": 0, "useKey": "Passive", "description": "Increases the knockback of your arrows.", "formula": "knockbackBonus = (arrowKnockbackLvl - 1) * 2", "effectText": "+((lvl - 1) * 2) knockback"},
    "expert archer": {"category": "archer", "iconTexture": "expert archer icon", "personProperty": "expertArcherLvl", "title": "Expert Archer", "mpCost": 0, "useKey": "Passive", "description": "Decreases the variance in damage done with bows.", "formula": "minDamageMasteryPercent = (expertArcherLvl - 1) * 7", "effectText": "(lvl - 1) * 7% mastery"},
    "triple shot": {"category": "archer", "iconTexture": "triple shot icon", "personProperty": "tripleShotLvl", "title": "Triple Shot", "mpCost": 8, "useKey": "C (in air)", "description": "Jump and shoot 3 arrows downward at an angle.", "formula": "damagePercent = (tripleShotLvl > 1 ? 45 + (tripleShotLvl - 1) * 10 : 0)", "effectText": "45 + (lvl - 1) * 10% damage per arrow"},
    "arrow rain": {"category": "archer", "iconTexture": "arrow rain icon", "personProperty": "arrowRainLvl", "title": "Arrow Rain", "mpCost": 9, "useKey": "V", "description": "Shoot arrows into the sky that rain down on enemies.", "formula": "damagePercent = (arrowRainLvl > 1 ? 65 + (arrowRainLvl - 1) * 12 : 0)", "effectText": "65 + (lvl - 1) * 12% damage per arrow"},
    "piercing arrow": {"category": "archer", "iconTexture": "piercing arrow icon", "personProperty": "piercingArrowLvl", "title": "Piercing Arrow", "mpCost": 6, "useKey": "V (in air)", "description": "Shoot a powerful arrow that pierces through multiple enemies.", "formula": "damagePercent = (piercingArrowLvl > 1 ? 85 + (piercingArrowLvl - 1) * 13 : 0)", "effectText": "85 + (lvl - 1) * 13% damage"},
    "homing laser": {"category": "archer", "iconTexture": "homing laser icon", "personProperty": "homingLaserLvl", "title": "Homing Laser", "mpCost": 0, "useKey": "E (Hold & Release)", "description": "Charge your bow and fire homing lasers at enemies.", "formula": "numLasers = int((homingLaserLvl - 1) / 3) + 1; damagePercent = 60 + (homingLaserLvl - 1) * 9", "effectText": "60 + (lvl - 1) * 9% damage"},
    "magic shots": {"category": "wizard", "iconTexture": "magic shots icon", "personProperty": "magicShotsLvl", "title": "Magic Shots", "mpCost": 0, "useKey": "Passive", "description": "Increases the number of magic projectiles shot at once.", "formula": "extraProjectiles = magicShotsLvl - 1", "effectText": "+(lvl - 1) extra magic balls"},
    "expert wizard": {"category": "wizard", "iconTexture": "expert wizard icon", "personProperty": "expertWizardLvl", "title": "Expert Wizard", "mpCost": 0, "useKey": "Passive", "description": "Decreases the variance in damage done with magic weapons.", "formula": "minDamageMasteryPercent = (expertWizardLvl - 1) * 7", "effectText": "(lvl - 1) * 7% mastery"},
    "circular attack": {"category": "wizard", "iconTexture": "light beam icon", "personProperty": "lightBeamLvl", "title": "Light Beam", "mpCost": 10, "useKey": "C", "description": "Summon a beam of light in front of you to damage enemies.", "formula": "damagePercent = (lightBeamLvl > 1 ? 100 + (lightBeamLvl - 1) * 18 : 0)", "effectText": "100 + (lvl - 1) * 18% damage"},
    "magic distance": {"category": "wizard", "iconTexture": "magic distance icon", "personProperty": "magicDistanceLvl", "title": "Magic Distance", "mpCost": 0, "useKey": "Passive", "description": "Increases the distance magic projectiles travel.", "formula": "distanceBonus = (magicDistanceLvl - 1) * 35", "effectText": "+((lvl - 1) * 35) distance"},
    "thunder attack": {"category": "wizard", "iconTexture": "thunder icon", "personProperty": "thunderAttackLvl", "title": "Thunder", "mpCost": 23, "useKey": "V", "description": "Summon storm clouds that strike enemies with lightning.", "formula": "damagePercent = (thunderAttackLvl > 1 ? 90 + (thunderAttackLvl - 1) * 14 : 0)", "effectText": "90 + (lvl - 1) * 14% damage"},
    "self heal": {"category": "wizard", "iconTexture": "self heal icon", "personProperty": "selfHealLvl", "title": "Self Heal", "mpCost": 15, "useKey": "H", "description": "Heal yourself using MP.", "formula": "healAmount = (selfHealLvl - 1) * 45", "effectText": "Heals (lvl - 1) * 45 HP"},
    "guild heal": {"category": "wizard", "iconTexture": "guild heal icon", "personProperty": "guildHealLvl", "title": "Guild Heal", "mpCost": 19, "useKey": "G", "description": "Heal yourself and nearby guild members.", "formula": "healAmount = (guildHealLvl - 1) * 30", "effectText": "Heals (lvl - 1) * 30 HP"},
    "mind control": {"category": "wizard", "iconTexture": "mind control icon", "personProperty": "mindControlLvl", "title": "Mind Control", "mpCost": 0, "useKey": "E (Hold & Release)", "description": "Shoot a mind control orb to temporarily control an enemy.", "formula": "controlDurationSec = 6 + (mindControlLvl - 1) * 2", "effectText": "Control enemy for 6 + (lvl - 1) * 2 sec"},
    "grenade attack": {"category": "cowboy", "iconTexture": "grenade icon", "personProperty": "grenadeLvl", "title": "Grenade", "mpCost": 50, "useKey": "V", "description": "Throw an explosive grenade forward.", "formula": "damagePercent = (grenadeLvl > 1 ? 120 + (grenadeLvl - 1) * 20 : 0)", "effectText": "120 + (lvl - 1) * 20% damage"},
    "upward shoot": {"category": "cowboy", "iconTexture": "upward shoot icon", "personProperty": "upwardShootLvl", "title": "Upward Shoot", "mpCost": 2, "useKey": "C", "description": "Shoot bullets upward at an angle.", "formula": "damagePercent = (upwardShootLvl > 1 ? 80 + (upwardShootLvl - 1) * 12 : 0)", "effectText": "80 + (lvl - 1) * 12% damage"},
    "expert cowboy": {"category": "cowboy", "iconTexture": "expert cowboy icon", "personProperty": "expertCowboyLvl", "title": "Expert Cowboy", "mpCost": 0, "useKey": "Passive", "description": "Decreases the variance in damage done with guns.", "formula": "minDamageMasteryPercent = (expertCowboyLvl - 1) * 7", "effectText": "(lvl - 1) * 7% mastery"},
    "bullet distance": {"category": "cowboy", "iconTexture": "bullet distance icon", "personProperty": "bulletDistanceLvl", "title": "Bullet Distance", "mpCost": 0, "useKey": "Passive", "description": "Increases the distance bullets travel.", "formula": "distanceBonus = (bulletDistanceLvl - 1) * 35", "effectText": "+((lvl - 1) * 35) distance"},
    "shotgun attack": {"category": "cowboy", "iconTexture": "shotgun icon", "personProperty": "shotgunLvl", "title": "Shotgun", "mpCost": 50, "useKey": "C (Ground)", "description": "Fire a powerful shotgun blast that hits multiple enemies.", "formula": "damagePercent = (shotgunLvl > 1 ? 110 + (shotgunLvl - 1) * 18 : 0)", "effectText": "110 + (lvl - 1) * 18% damage"},
    "bullet knockback": {"category": "cowboy", "iconTexture": "bullet knockback icon", "personProperty": "bulletKnockbackLvl", "title": "Bullet Knockback", "mpCost": 0, "useKey": "Passive", "description": "Increases the knockback of your bullets.", "formula": "knockbackBonus = (bulletKnockbackLvl - 1) * 1.5", "effectText": "+((lvl - 1) * 1.5) knockback"},
    "jump grenade": {"category": "cowboy", "iconTexture": "jump grenade icon", "personProperty": "jumpGrenadeLvl", "title": "Jump Grenade", "mpCost": 5, "useKey": "V (in air)", "description": "Jump and throw a grenade downward while flipping backward.", "formula": "damagePercent = (jumpGrenadeLvl > 1 ? 110 + (jumpGrenadeLvl - 1) * 16 : 0)", "effectText": "110 + (lvl - 1) * 16% damage"}
}

skills_list = []
skills_by_id = {}
for sname, sbase in skills_base.items():
    det = skill_details.get(sname, {})
    merged = {
        **sbase,
        "category": det.get("category", "basic"),
        "iconTexture": det.get("iconTexture", ""),
        "personProperty": det.get("personProperty", ""),
        "title": det.get("title", sname.title()),
        "mpCost": det.get("mpCost", 0),
        "useKey": det.get("useKey", ""),
        "description": det.get("description", ""),
        "formula": det.get("formula", ""),
        "effectText": det.get("effectText", "")
    }
    skills_list.append(merged)
    skills_by_id[sname] = merged

skills_meta = {
    "totalSkills": len(skills_list),
    "mpConstants": person_mp_consts,
    "categories": ["basic", "warrior", "archer", "wizard", "cowboy"],
    "skills": skills_list,
    "skillsById": skills_by_id
}
with open(os.path.join(OUT_DIR, "skills_meta.json"), "w", encoding="utf-8") as f:
    json.dump(skills_meta, f, indent=2, ensure_ascii=False)
print(f"Saved skills_meta.json: {len(skills_list)} skills.")

# ==============================================================================
# 4. MISSIONS DATA -> missions_data.json
# ==============================================================================
print("Extracting missions_data.json...")
gm_text = read_text(r"scripts\GameMain.as")

npcs_list = []
npcs_by_talk = {}
npc_pattern = re.compile(
    r'new NPCStat\(\s*(\d+)\s*,\s*"([^"]+)"\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*"([^"]+)"\s*,\s*"([^"]+)"\s*,\s*"([^"]+)"\s*,\s*"([^"]+)"\s*,\s*"([^"]+)"\s*,\s*"([^"]+)"\s*,\s*(\d+)(?:\s*,\s*(\d+))?(?:\s*,\s*(-?\d+))?(?:\s*,\s*"([^"]+)")?(?:\s*,\s*(\d+))?(?:\s*,\s*(\d+))?\s*\)'
)
for m in npc_pattern.finditer(gm_text):
    npc_obj = {
        "area": int(m.group(1)),
        "name": m.group(2),
        "x": int(m.group(3)),
        "y": int(m.group(4)),
        "hair": m.group(5),
        "helmet": m.group(6),
        "shirt": m.group(7),
        "pants": m.group(8),
        "weapon": m.group(9),
        "weapon2": m.group(10),
        "talkTrigger": int(m.group(11)),
        "eyes": int(m.group(12)) if m.group(12) else 1,
        "dir": int(m.group(13)) if m.group(13) else 1,
        "gender": m.group(14) if m.group(14) else "male",
        "skin": int(m.group(15)) if m.group(15) else 2,
        "shoes": int(m.group(16)) if m.group(16) else 1
    }
    npcs_list.append(npc_obj)
    npcs_by_talk[npc_obj["talkTrigger"]] = npc_obj

missions_raw = []
for m in re.finditer(r'setNewMission\("((?:\\\'|[^"])+)"\s*,\s*(\d+)\s*,\s*"((?:\\\'|[^"])+)"\s*,\s*(true|false)\s*,\s*(true|false)\);', stats_text):
    mname = m.group(1).replace("\\'", "'")
    worth = int(m.group(2))
    desc = m.group(3).replace("\\'", "'")
    missions_raw.append({"name": mname, "worthXP": worth, "description": desc})

mission_quest_meta = {
    "The Black Hooded Hatchet": {
        "npcName": "Robby", "npcTalkTrigger": 1, "startTalkID": 7, "completeTalkID": 10,
        "requirement": {"type": "item", "item": "hatchet", "count": 1, "consumesItem": False},
        "extraRewards": {"achievement": "BLACK_HOODED_HATCHET"}
    },
    "Find the Cult's Hideout": {
        "npcName": "Robby", "npcTalkTrigger": 1, "startTalkID": 11, "completeTalkID": 22,
        "prerequisiteMission": "The Black Hooded Hatchet",
        "requirement": {"type": "talkToNPC", "targetNpcName": "Gordo", "targetNpcTalkTrigger": 16, "targetArea": 16},
        "extraRewards": {}
    },
    "Get Hambone Apples": {
        "npcName": "Hambone", "npcTalkTrigger": 6, "startTalkID": 12, "completeTalkID": 13,
        "requirement": {"type": "item", "item": "apple", "count": 10, "consumesItem": True},
        "extraRewards": {}
    },
    "Get Brody a Garbage Can Lid": {
        "npcName": "Brody", "npcTalkTrigger": 7, "startTalkID": 14, "completeTalkID": 15,
        "requirement": {"type": "item", "item": "garbage can lid", "count": 1, "consumesItem": True},
        "extraRewards": {}
    },
    "Get Jim Sanders Some Gear": {
        "npcName": "Jim Sanders", "npcTalkTrigger": 12, "startTalkID": 16, "completeTalkID": 17,
        "requirement": {"type": "items", "items": [{"item": "wooden sword", "count": 1}, {"item": "wooden shield", "count": 1}, {"item": "pot helmet", "count": 1}], "consumesItem": True},
        "extraRewards": {}
    },
    "Give Cleveland His Letter": {
        "npcName": "Gordo", "npcTalkTrigger": 16, "startTalkID": 18, "completeTalkID": 19,
        "prerequisiteMission": "Find the Cult's Hideout",
        "turnInNpcName": "Cleveland", "turnInNpcTalkTrigger": 18,
        "requirement": {"type": "deliverItem", "item": "letter to Cleveland", "count": 1, "consumesItem": True},
        "extraRewards": {}
    },
    "Look Like a Black Hood": {
        "npcName": "Kip", "npcTalkTrigger": 19, "startTalkID": 20, "completeTalkID": 21,
        "requirement": {"type": "equip", "helmet": "black hood", "shirt": "black robe", "pants": "black pants"},
        "extraRewards": {"money": 6000}
    },
    "Get Gordon Watermelon": {
        "npcName": "Gordon", "npcTalkTrigger": 21, "startTalkID": 23, "completeTalkID": 24,
        "requirement": {"type": "item", "item": "watermelon", "count": 5, "consumesItem": True},
        "extraRewards": {}
    },
    "Get Pablo a Monster Skull": {
        "npcName": "Pablo", "npcTalkTrigger": 29, "startTalkID": 25, "completeTalkID": 26,
        "requirement": {"type": "item", "item": "monster skull", "count": 1, "consumesItem": True},
        "extraRewards": {}
    },
    "Show Joshua All Enemies": {
        "npcName": "Joshua", "npcTalkTrigger": 34, "startTalkID": 28, "completeTalkID": 29,
        "requirement": {"type": "heropediaEnemies", "count": 29},
        "extraRewards": {"achievement": "ALL_ENEMIES"}
    },
    "Get Scarlet a Hockey Mask": {
        "npcName": "Scarlet", "npcTalkTrigger": 35, "startTalkID": 30, "completeTalkID": 31,
        "requirement": {"type": "item", "item": "hockey mask", "count": 1, "consumesItem": True},
        "extraRewards": {}
    },
    "Look Like the Lost Warrior": {
        "npcName": "Tootsie", "npcTalkTrigger": 41, "startTalkID": 32, "completeTalkID": 33,
        "requirement": {"type": "equip", "helmet": "spartan helmet", "shirt": "spartan armor", "pants": "spartan legs", "weapon": "spartan sword", "weapon2": "spartan shield"},
        "extraRewards": {"achievement": "LOST_WARRIOR"}
    },
    "Solve Jimmy's Puzzle": {
        "npcName": "Jimmy", "npcTalkTrigger": 44, "startTalkID": 34, "completeTalkID": 35,
        "requirement": {"type": "puzzle", "description": "Equip weapon matching your username length"},
        "extraRewards": {}
    },
    "Complete Albert's Puzzle": {
        "npcName": "Albert", "npcTalkTrigger": 51, "startTalkID": 36, "completeTalkID": 37,
        "requirement": {"type": "puzzle", "description": "Say secret phrase based on your level in chat near Albert"},
        "extraRewards": {}
    },
    "Get Cassie Pumpkin Helmets": {
        "npcName": "Cassie", "npcTalkTrigger": 54, "startTalkID": 38, "completeTalkID": 39,
        "requirement": {"type": "item", "item": "pumpkin helmet", "count": 3, "consumesItem": True},
        "extraRewards": {}
    },
    "Complete Billbert's Puzzle": {
        "npcName": "Billbert", "npcTalkTrigger": 59, "startTalkID": 40, "completeTalkID": 41,
        "requirement": {"type": "puzzle", "description": "Match hair style to riddle hint"},
        "extraRewards": {}
    },
    "Collect 4 Pets": {
        "npcName": "Clyde", "npcTalkTrigger": 68, "startTalkID": 46, "completeTalkID": 47,
        "requirement": {"type": "petsOwned", "count": 4},
        "extraRewards": {}
    },
    "Ride a Pet": {
        "npcName": "Bucky", "npcTalkTrigger": 69, "startTalkID": 48, "completeTalkID": 49,
        "requirement": {"type": "ridingPet", "isRiding": True},
        "extraRewards": {}
    },
    "Catch Every Fish": {
        "npcName": "Barnaby", "npcTalkTrigger": 77, "startTalkID": 51, "completeTalkID": 52,
        "requirement": {"type": "heropediaFish", "count": 33},
        "extraRewards": {}
    },
    "Solve Philbert's Puzzle": {
        "npcName": "Philbert", "npcTalkTrigger": 98, "startTalkID": 58, "completeTalkID": 59,
        "requirement": {"type": "equip", "description": "Wear red shirt (if name.length <= 10) or white shirt (if name.length > 10)"},
        "extraRewards": {}
    },
    "Reach High Energy Level": {
        "npcName": "Derek", "npcTalkTrigger": 104, "startTalkID": 63, "completeTalkID": 0,
        "requirement": {"type": "energyLevel", "minEnergy": 9000},
        "extraRewards": {}
    }
}

missions_list = []
for idx, m in enumerate(missions_raw):
    mname = m["name"]
    qmeta = mission_quest_meta.get(mname, {})
    talk_trig = qmeta.get("npcTalkTrigger", 0)
    npc_info = npcs_by_talk.get(talk_trig, None)
    merged = {
        "index": idx,
        "name": mname,
        "worthXP": m["worthXP"],
        "description": m["description"],
        "npcGiver": npc_info["name"] if npc_info else qmeta.get("npcName", ""),
        "npcArea": npc_info["area"] if npc_info else 1,
        "npcPosition": {"x": npc_info["x"], "y": npc_info["y"]} if npc_info else None,
        "npcTalkTrigger": talk_trig,
        **qmeta
    }
    missions_list.append(merged)

missions_data = {
    "totalMissions": len(missions_list),
    "missions": missions_list,
    "npcs": npcs_list
}
with open(os.path.join(OUT_DIR, "missions_data.json"), "w", encoding="utf-8") as f:
    json.dump(missions_data, f, indent=2, ensure_ascii=False)
print(f"Saved missions_data.json: {len(missions_list)} missions, {len(npcs_list)} NPCs.")

# ==============================================================================
# 5. AREAS META -> areas_meta.json
# ==============================================================================
print("Extracting areas_meta.json...")
mm_full = read_text(r"scripts\com\menus\MapMenu.as")

# 5a. Parse setNewLevel(level, p1, p2, p3, p4, p5, p6, p7, fname, closestHeal, waterTint, waterTintInt)
levels_dict = {}
lvl_pattern = re.compile(
    r'setNewLevel\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*(?:,\s*"((?:\\\'|[^"])*)")?(?:\s*,\s*(-?\d+))?(?:\s*,\s*"([^"]*)")?(?:\s*,\s*(-?\d+))?\s*\);'
)
for m in lvl_pattern.finditer(stats_text):
    lid = int(m.group(1))
    p1 = int(m.group(2))
    p2 = int(m.group(3))
    p3 = int(m.group(4))
    p4 = int(m.group(5))
    p5 = int(m.group(6))
    p6 = int(m.group(7))
    p7 = int(m.group(8))
    lname = m.group(9).replace("\\'", "'") if m.group(9) is not None else ""
    closest_heal = int(m.group(10)) if m.group(10) is not None else 3
    water_tint = m.group(11) if m.group(11) is not None else "blue"
    water_tint_int = int(m.group(12)) if m.group(12) is not None else 0
    levels_dict[lid] = {
        "level": lid,
        "name": lname,
        "portals": {
            "portal1Lead": p1,
            "portal2Lead": p2,
            "portal3Lead": p3,
            "portal4Lead": p4,
            "portal5Lead": p5,
            "portal6Lead": p6,
            "portal7Lead": p7
        },
        "closestHeal": closest_heal,
        "waterTint": water_tint,
        "waterTintInt": water_tint_int
    }

def get_area_theme(p):
    if p in (1, 2, 3, 4, 5, 118): return 1
    if p in (8, 9, 10, 11, 27): return 2
    if p in (6, 7): return 3
    if p == 12: return 4
    if p in (13, 14, 15, 17, 19, 20): return 5
    if p in (16, 18): return 6
    if p in (21, 22, 23, 24, 25): return 7
    if p == 26: return 8
    if p == 28: return 9
    if p in (29, 30, 31, 32, 33, 38): return 10
    if p in (34, 35, 36, 37, 50, 99, 100): return 11
    if p in (39, 40, 41, 42, 43, 44): return 12
    if p in (45, 46, 47, 48, 52, 53): return 13
    if p == 49: return 14
    if p in (54, 55, 56, 57, 58, 59): return 15
    if p in (60, 61, 62, 63, 64, 65): return 16
    if p in (66, 67, 68, 69, 70, 71, 72): return 17
    if p in (73, 74, 75, 76, 77, 78): return 18
    if p in (79, 80, 81, 82, 83): return 19
    if p in (84, 85, 86, 87, 88, 89, 90, 91, 92): return 20
    if p in (93, 94, 95, 96, 97, 98): return 21
    if p in (101, 102, 103, 104, 105, 106, 107, 108, 109, 110): return 22
    if p == 111: return 23
    if p in (112, 113, 114): return 24
    if p in (115, 116): return 25
    if p == 117: return 26
    if p in (119, 120, 121, 122, 123, 124, 125, 126, 127): return 27
    if p in (128, 129, 130): return 28
    if p in (131, 132, 133, 134, 135, 136, 137, 138): return 29
    if p in (139, 140, 141): return 30
    if p in (142, 143, 144, 145): return 16
    return 1

# Exact mapping from TileHandler.convertAreaArt (lines 838-966)
theme_tiles = {
    1: ("GreenAreaTiles", "GreenAreaForegroundTiles"),
    2: ("RedMushroomTiles", "RedMushForegroundTiles"),
    3: ("BlueMushroomAreaTiles", "BlueMushroomForegroundTiles"),
    4: ("FairyAreaTiles", "FairyForegroundTiles"),
    5: ("BeachAreaTiles", "BeachForegroundTiles"),
    6: ("PVPTiles", "PVPForegroundTiles"),
    7: ("JungleTiles", "JungleForegroundTiles"),
    8: ("ForestAreaTiles", "ForestForegroundTiles"),
    9: ("SnowAreaTiles", "SnowForegroundTiles"),
    10: ("RobotAreaTiles", "RoboForegroundTiles"),
    11: ("BeholderAreaTiles", "BeholderForegroundTiles"),
    12: ("PetAreaTiles", "PetForegroundTiles"),
    13: ("OceanAreaTiles", "AquaForegroundTiles"),
    14: ("HauntedTiles", "HauntedForegroundTiles"),
    15: ("WindmillAreaTiles", "WindmillForegroundTiles"),
    16: ("RepguanaAreaTiles", "RepguanaForegroundTiles"),
    17: ("LavaTiles", "LavaForegroundTiles"),
    18: ("DungeonAreaTiles", "DungeonForegroundTiles"),
    19: ("HouseTiles", "HouseForegroundTiles"),
    20: ("TowerAreaTiles", None),
    21: ("AcidAreaTiles", "AcidForegroundTiles"),
    22: ("MushroomHouseTiles", "MushroomHouseForegroundTiles"),
    23: ("FairyHouseTiles", "FairyHouseForegroundTiles"),
    24: ("RobotHouseTiles", "RobotHouseForegroundTiles"),
    25: ("BeholderHouseTiles", "BeholderHouseForegroundTiles"),
    26: ("BarnTiles", "BarnForegroundTiles"),
    27: ("AcidHouseTiles", "AcidHouseForegroundTiles"),
    28: ("AquaHouseTiles", "AquaHouseForegroundTiles"),
    29: ("CloudAreaTiles", "CloudForegroundTiles"),
    30: ("CloudHouseTiles", "CloudHouseForegroundTiles")
}

theme_music = {
    1: "spread your wings.mp3",
    2: "mushroom_music.mp3",
    3: "Picket_Fences_full_mix.mp3",
    4: "Cutie_Pie_full_mix.mp3",
    5: "beach-music.mp3",
    6: "Bringing_Faith_full_mix.mp3",
    7: "Dance_Of_The_Dragons_full_mix.mp3",
    8: "Forgotten_Time_full_mix.mp3",
    9: "Mister_Magician_full_mix.mp3",
    10: "Tomorrow_Here_full_mix_mp3.mp3",
    11: "Modern_Warriors_full_mix.mp3",
    12: "Times_Of_Change_full_mix 2.mp3",
    13: "Survivors_full_mix.mp3",
    14: "Suite_Trip_full_mix.mp3",
    15: "windmill-music.mp3",
    16: "Surreal_State_full_mix.mp3",
    17: "Raise_Me_Up_full_mix.mp3",
    18: "Here_To_Forever_full_mix_mp3.mp3",
    21: "Art_Of_The_East_full_mix.mp3",
    29: "150413_Our_World_Alive-free_download.mp3"
}

map_markers = {}
for case_m in re.finditer(r'case (\d+):\s*(.*?)\s*break;', mm_full, re.DOTALL):
    lvl_id = int(case_m.group(1))
    body = case_m.group(2)
    sp = re.search(r'setPoint\(\s*([^,]+)\s*,\s*([^,]+)\s*,\s*([^)]+)\s*\)', body)
    if sp:
        try:
            mx = float(sp.group(1).strip())
            my = float(sp.group(2).strip())
            ms = float(sp.group(3).strip())
            map_markers[lvl_id] = {"x": mx, "y": my, "scale": ms}
        except ValueError:
            pass

atm_positions = {
    55: {"x": 1693, "y": 694},
    12: {"x": 863, "y": 1349},
    83: {"x": 3534, "y": 689},
    30: {"x": 3503, "y": 355},
    97: {"x": 3896, "y": 364},
    138: {"x": 3660, "y": 1182}
}

# Tile collision and mirror rules from TileHandler.as & TileDefRegistry.as
tile_rules = {
    "tilePixelSize": 165,
    "mainAtlasSize": {"width": 1980, "height": 1980, "cols": 12, "rows": 12, "maxTiles": 144},
    "foregroundAtlasSize": {"width": 825, "height": 1485, "cols": 5, "rows": 9, "maxTiles": 45},
    "mirroredMainTiles": {
        "4": 2,
        "10": 9,
        "16": 14,
        "20": {"default": 18, "exceptTheme16": 20},
        "21": 55,
        "22": 54,
        "33": 67,
        "42": 62,
        "50": 48,
        "64": 52,
        "77": 75,
        "78": 73
    },
    "specialInteractiveTiles": {
        "30": {"themes": [2, 4], "type": "BouncePad"},
        "31": {"themes": "all", "type": "CoinBox"}
    },
    "waterAnimatedTiles": {
        "mainLayer": [25],
        "foregroundLayerByTheme": {
            "1": 19, "2": 14, "3": 9, "4": 14, "5": 14, "7": 14, "8": 14, "9": 14,
            "10": 4, "11": 24, "12": 9, "13": 14, "14": 14, "15": 14, "16": 14, "17": 14, "21": 14
        }
    },
    "collisionShapes": [
        {"tiles": [0, 25, 38, 40, 72, 75, 77], "layers": ["main", "water"], "type": "rect", "x": 0, "y": 0, "w": 165, "h": 165},
        {"tiles": [19, 36, 44, 73, 78], "layers": ["main", "ground2", "ground3", "water"], "type": "rect", "x": 0, "y": 25, "w": 165, "h": 140},
        {"tiles": [14, 18], "layers": ["main", "ground2", "ground3", "water"], "type": "rect", "x": 25, "y": 25, "w": 140, "h": 140},
        {"tiles": [16, 20], "layers": ["main", "ground2", "ground3", "water"], "type": "rect", "x": 0, "y": 25, "w": 140, "h": 140},
        {"tiles": [30], "layers": ["main", "ground2", "ground3", "water"], "type": "rect", "x": 25, "y": 25, "w": 115, "h": 140},
        {"tiles": [48, 64], "layers": ["main", "water"], "type": "rect", "x": 0, "y": 0, "w": 140, "h": 165},
        {"tiles": [50, 52], "layers": ["main", "water"], "type": "rect", "x": 25, "y": 0, "w": 140, "h": 165},
        {"tiles": [31], "layers": ["main", "water"], "type": "rect", "x": 56, "y": 61, "w": 50, "h": 45},
        {"tiles": [42], "layers": ["main", "water"], "type": "bitmap", "blockData": "Block2Data", "x": 0, "y": 0, "w": 165, "h": 165},
        {"tiles": [62], "layers": ["main", "water"], "type": "bitmap", "blockData": "Block9Data", "x": 0, "y": 0, "w": 165, "h": 165},
        {"tiles": [54, 10], "layers": ["main", "water"], "type": "slope", "blockData": "Block6Data", "slope": 27, "x": 0, "y": 25, "w": 165, "h": 140},
        {"tiles": [55], "layers": ["main", "water"], "type": "slope", "blockData": "Block7Data", "slope": 27, "x": 0, "y": 107, "w": 116, "h": 58},
        {"tiles": [67], "layers": ["main", "water"], "type": "slope", "blockData": "Block8Data", "slope": 27, "x": 0, "y": 0, "w": 165, "h": 165},
        {"tiles": [22, 9], "layers": ["main", "water"], "type": "slope", "blockData": "Block11Data", "slope": -27, "x": 0, "y": 25, "w": 166, "h": 140},
        {"tiles": [21], "layers": ["main", "water"], "type": "slope", "blockData": "Block10Data", "slope": -27, "x": 49, "y": 107, "w": 116, "h": 58},
        {"tiles": [33], "layers": ["main", "water"], "type": "slope", "blockData": "Block12Data", "slope": -27, "x": 0, "y": 0, "w": 165, "h": 165},
        {"tiles": [95], "layers": ["main"], "theme": 13, "type": "pipe_top", "blockData": "Block17Data", "x": 40, "y": 80, "w": 89, "h": 91},
        {"tiles": [107], "layers": ["main"], "theme": 13, "type": "pipe_mid", "x": 55, "y": 0, "w": 60, "h": 165},
        {"tiles": [119], "layers": ["main"], "theme": 13, "type": "pipe_bottom", "blockData": "Block18Data", "x": 40, "y": 0, "w": 89, "h": 91}
    ]
}

# Also extract enemy & environment hazard stats from Stats.as for completeness
enemy_descs = {}
for m in re.finditer(r'setEDesc\("([^"]+)",\s*"([^"]+)",\s*[^,]+,\s*"((?:\\\'|[^"])*)",\s*(-?\d+(?:\.\d+)?),\s*(-?\d+(?:\.\d+)?)\);', stats_text):
    enemy_descs[m.group(1)] = {
        "name": m.group(1),
        "colorString": m.group(2),
        "description": m.group(3).replace("\\'", "'"),
        "fireX": float(m.group(4)),
        "fireY": float(m.group(5))
    }

env_hazards = []
for m in re.finditer(r'setNewEnv\("([^"]+)",\s*(\d+)', stats_text):
    env_hazards.append({"name": m.group(1), "power": int(m.group(2))})

areas_list = []
areas_by_level = {}
for lid in range(1, 146):
    lbase = levels_dict.get(lid, {
        "level": lid,
        "name": f"Unused Level {lid}",
        "portals": {f"portal{i}Lead": 0 for i in range(1, 8)},
        "closestHeal": 3,
        "waterTint": "blue",
        "waterTintInt": 0
    })
    theme = get_area_theme(lid)
    main_tiles, fg_tiles = theme_tiles.get(theme, ("GreenAreaTiles", "GreenAreaForegroundTiles"))
    has_bg = theme not in (18, 19, 20)
    bg_atlas = f"backgrounds{theme}" if has_bg else None
    music = theme_music.get(theme, None)
    area_npcs = [n for n in npcs_list if n["area"] == lid]
    area_obj = {
        **lbase,
        "existsInStats": lid in levels_dict,
        "theme": theme,
        "mainTilesClass": main_tiles,
        "foregroundTilesClass": fg_tiles,
        "backgroundAtlas": bg_atlas,
        "musicTrack": music,
        "isPvpArea": lid in (112, 113, 114),
        "isBossHealArea": lid in (27, 72, 116),
        "mapMarker": map_markers.get(lid, None),
        "atmPosition": atm_positions.get(lid, None),
        "npcs": area_npcs
    }
    areas_list.append(area_obj)
    areas_by_level[str(lid)] = area_obj

areas_meta = {
    "totalLevels": 145,
    "definedLevelsCount": len(levels_dict),
    "themes": {
        str(t): {
            "theme": t,
            "mainTilesClass": theme_tiles[t][0],
            "foregroundTilesClass": theme_tiles[t][1],
            "backgroundAtlas": f"backgrounds{t}" if t not in (18, 19, 20) else None,
            "musicTrack": theme_music.get(t, None)
        } for t in range(1, 31)
    },
    "tileRules": tile_rules,
    "envHazards": env_hazards,
    "enemyDescriptions": enemy_descs,
    "areas": areas_list,
    "areasByLevel": areas_by_level
}

with open(os.path.join(OUT_DIR, "areas_meta.json"), "w", encoding="utf-8") as f:
    json.dump(areas_meta, f, indent=2, ensure_ascii=False)
print(f"Saved areas_meta.json: {len(areas_list)} levels ({len(levels_dict)} defined in Stats.as), {len(enemy_descs)} enemy descs.")
