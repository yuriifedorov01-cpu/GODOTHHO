extends Control
class_name HeropediaMenu
## HeropediaMenu — Энциклопедия врагов и рыб (порт com.menus.HeropediaMenu.as).
## 3 экрана:
## - panel 1: список врагов (из StatsDB.enemy_stats / enemyList профиля) и рыб (из fishList профиля)
## - panel 2: карточка врага со статами/описанием, кнопкой звука (sound btn) и кнопкой назад (back btn)
## - panel 3: карточка рыбы со статами/описанием и кнопкой назад (back btn)

signal closed()
signal enemy_sound_requested(enemy_name: String)

@export var is_draggable: bool = true

const FLASH_OFFSET: Vector2 = Vector2(336.0, 208.0)

# Оригинальные описания врагов из Stats.as:252-297 (setEDesc, 46 врагов)
const ENEMY_DESCRIPTIONS: Dictionary = {
	"bouncing mushroom": "The Bouncing Mushroom is nothing more than a large mushroom which has been brought to life.  When the seed from two blue mushrooms meet, they form a large blue mushroom plant.  When this plant reaches two weeks old, it sprouts to life into what is known as the Bouncing Mushroom.  Scientists are still trying to figure out to this day how a plant turns into a living creature.  Because of their large size Bouncing Mushrooms are highly dangerous.  As a result of lab testing, Bouncing Mushrooms are estimated to be extinct within 20 years.",
	"crab": "The Crab is considered the pest of the beach.  They strive in populated areas with humans.  Their sharp claws can easily take off arms and legs of others and should not be taken lightly.  Crabs are almost never friendly and are even hated by other creatures such as the Red Bouncer.  The Crab's hard shell and sharp claws make it a formidable enemy.",
	"green bouncer": "The Green Bouncer is the weakest creature known to man. They survive off of plant leaves and can travel from place to place simply by bouncing. Although they sometimes travel in packs, they pose a very low threat to humans. Because of their small size, life expectancy for the Green Bouncer is usually no more than a few months before it is killed by a stronger creature.",
	"green walker": "Green Walkers have evolved from the Green Bouncers.  Sprouting legs, they no longer need to hop from place to place.  Green walkers, aside from their slightly larger size and legs, share almost all of the same qualities as the Green Bouncer.  Because they are so friendly, children sometimes ride on the back of them to get from place to place.",
	"horned monster": "Horned monsters live in the depths of dead and abandoned woods.  They eat smaller creatures than themselves and use their horn to take down prey. Horned monsters are angry creatures that are very aggressive towards humans.",
	"mushroom ball": "Mushroom Balls are one of the first creatures to roam the earth having legs.  Unlike the Bouncer family they have two eyes, and a fairly hard shelled mushroom top.  Their mushroom shell protects them from enemies stronger than them.  Sometimes when they fall they have a tough time getting back up because of their shape and size and can be left upside down for hours, days, or even until they die.",
	"mushroom squish": "A small creature, the Mushroom Squish uses its mooshy body to squirm around its environment. Mushroom Squishes are very weak creatures and do not pose much of a threat to nearby humans. They are able to digest mud and dirt, and like to live in damp, dirty places.",
	"orange crazy": "Orange Crazies roam free in the upper windmill areas of the earth.  Most people do not enjoy being around them because of their ugly looks and faster movement.  Orange Crazies eat smaller creatures such as Green Bouncers and Mushroom Squish.  They are easily angered creatures and should be approached with caution for the first time.",
	"plant monster": "One of the toughest creatures to roam the earth is the Plant Monster.  They spend all day protecting their eggs and will not hesitate to destroy anyone who approaches them.  If a Plant Monster goes without eating for days they will sometimes eat their eggs, despite protecting them for so long.  There are hundreds of cases of people dying every year from being attacked by Plant Monsters.  Their strong reptilian scales and aggravated personality make them an enemy to be reckoned with.",
	"purple goo": "Purple Goo, although larger than the Green Bouncer, are still very weak creatures. They roam free, viewing the world through their one large eye. It is believed that roughly 30% of all Purple Goo are blind due to their susceptibility to having their eye punctured. Because of their frequent blindness, some humans capture them and use them as toys, referring to them as 'purple footballs'.",
	"red bouncer": "Red Bouncers are part of the Bouncer Family.  They live in sandy areas and can pose a small threat to weaker humans.  Bloated with ocean water, the Red Bouncer is able to move around by bouncing on its bottom.  Red bouncers are the toughest of the three bouncers.",
	"yellow hairy monster": "Yellow Hairy Monsters are one of the most hated creatures in the world.  Many people hate them because of their angry look and because they are a nuisance.  They eat whatever they can including other creatures, people's clothes, and even infant humans if left unattended.  Although they lurk on the outskirts of Fairyville, Yellow Hairy Monsters are anything but friendly.",
	"yellow puff monster": "Big, mean, and scary the Yellow Puff Monster does its best to take out anything that is not its kind.  They should be approached with extreme caution and can only be taken down by those who have been thoroughly trained.  There have been reports that humans have come across a few of them which are friendly, but most are not.  Despite their large mouths, they do not eat anything they kill.  They only eat trees and bugs.  Sometimes, the yellow coats from their bodies are made into fur coats.",
	"pumpkin creeper": "The Pumpkin Creeper is a fairly powerful creature that is able to withstand several hits from an opponent before it is knocked out.  Their hard pumpkin shell protects them from hits but is also used as food by those stronger than it.  Pumpkin Creepers live in dark places that have little to no sunlight.",
	"great frog": "Large, dumb, and in charge.  The great frog is a big and powerful enemy, although its intelligence  is very low.  They live in forests amongst pine trees and eat mostly bugs.  Because of their incredible strength most humans cannot get near them, making the areas they live in uninhabitable.  Because of their close living quarters, great frogs often get in fights with plant monsters.",
	"penguin": "Penguins live in cold snowy forests and survive off of eating fish.  It has become a custom tradition that penguin mothers craft knight helmets for their young when they reach age 3.  The knight helmet is to protect them from enemies stronger than them, giving penguins the slight edge defensively and helping them to overcome predators.",
	"sasquatch": "Unbelievably  powerful, the sasquatch is the ultimate destroyer.  Only the most legendary people on earth are able to take one down.  Few people are able to go anywhere near one without risking serious injury or death.  Sasquatches survive off of eating anything they can, plants or animal.  An estimated 2,000 people a year are killed by them.  Sasquatches are extremely dangerous and should be approached with EXTREME caution.",
	"goo cube": "A large, goo filled green cube.  Goo cubes live in dark dungeons and maintain themselves by absorbing bacteria.  It is often argued that goo cubes are lifeless and should not be considered living creatures.  Some say they are merely a collection of scum and bacteria.  Despite their abundance of health, goo cubes have very low attack because of their inability to fight.  Because of their large healths, goo cubes are best taken down with groups of people.",
	"brick monster": "Brick monsters are thought to have originated from a combination of brick combined with the goo cube.  They are very dumb monsters who survive from eating nothing.  Because of their large size and very hard brick skin, they are able to withstand attacks with little to no damage.  It is said that in a fight, even a sasquatch does little to damage to a brick monster.  Travelers beware.",
	"block bot": "Block bots are one of the most technologically advanced creatures in existence.  They were created by man and have evolved for many years until they were able to re-create more of themselves.  They are so smart that scientists consider them a living creature.  Not only are block bots very smart, but they are a formidable opponent.",
	"night stalker": "Blind dinosaurs, the night stalker is a very angry predator.  It feasts off of other creatures weaker than it.  Much like a bat, they use sonar to navigate around their environment.  During their early development, they can be used as pets known as stalklings.",
	"drill bot": "Created solely for war, the drill bot is much different from block bots.  While block bots are very smart robots, drill bots are very dumb and lack any real artificial intelligence.  They are programmed purely for fighting and know nothing else.  They cannot reproduce themselves and know only how to kill.  Their bodies are made of the same strong metal that block bots are created from giving them a very high defense.",
	"lotus eye": "Lotus eyes are the rulers of the rain forest.  Using its one massive eye and several smaller eyes its vision is unmatched by any other creature.  Lotus eyes eat other living creatures and are capable of eating plant monsters and even great frogs.  Using their spider like legs they are very fast and agile creatures.  Lotus eyes can only be hunted in packs or by the most powerful of hunters.",
	"dark beholder": "Dark Beholders are rulers of the wastelands.  They eat night stalkers to stay alive.  Unlike most other creatures, dark beholders do not sleep.  Their bodies can function around the clock without ever needing rest.  When they get old and die, their scales are used to make incredibly strong armor and weapons.  99% of people who have ever seen a dark beholder are no longer alive.",
	"Carnelia": "Carnelia is the evil mother of nature.  She gains life through the aura of other creatures.  Whenever enemies are around, her health replenishes.  It is near impossible for a single human to take down Carnelia on their own.  It is said that even the scales of a dark beholder can be penetrated by the teeth of Carnelia.  It is said that the roots of all trees in the rain forest stem back to her.",
	"leafling": "Leafling are grown, not bred.  They are born from seeds and begin to have a heartbeat at just under one month of age.  Their lifespan can last anywhere from 2 to 3 years, unless they are killed by a predator before they die of natural causes.  Leafling do not attack other creatures, they eat their meals from nature.",
	"leaflet": "Tiny creatures that appear in very large quantity, they are the early forms of Leaflings before they grow larger.  They are very weak, non-hostile creatures that survive off of the earth.  Because of their weak bodies and low attack, humans often use them as training for their new founded pets.",
	"glord": "Large and powerful, glords are the rulers of Elandra Island.  They are born without legs and use their arms to walk from place to place.  Because of this, their arms are roughly 2-3 times stronger than the arms of a normal creature.  This makes them very strong and capable of knocking out their victims with a single punch.",
	"kreeton": "Its rock like body gives it an incredibly high defense.  Due to its lack of arms and spikes however, its attack remains slightly lower than that of a dark beholder.  Its large eyes allow it to see prey from nearly every direction.  If a kreeton is slain, the earth can be felt shaking from the heavy bodies falling.",
	"giant goo cube": "A large mass of goo, the giant goo cube is approximately 4-5 times the size of a normal goo cube.  Despite their incredible size, they are not a major threat.  Their lack of brain or ligaments makes it very hard for them to attack humans or any other creatures.  However, due to their large weight, they can cause a fair amount of damage to those who are weak.  The giant goo cube also possesses a very large health and gains health from fellow goo cubes in the vicinity.",
	"repguana": "Even the most prestige heroes and champions have been crushed and obliterated by this monstrosity.  The repguana is relentless and kills anything that comes near it, regardless of friend or foe.  Although the scales remain weaker than that of a kreeton, they are still extremely tough and light weight, making them ideal for archers and those who must carry light equipment.  Due to its large size and fangs, there are only a select few people in the world that can take this mighty beast down.",
	"Kreetus": "A monstrous inbred disaster, Kreetus is a mutant freak spawned as the offspring of a dark beholder and kreeton.  Its large kreeton shelled body is extremely tough and helps it withstand attacks from even the most supreme adversary.  Despite its hard shell it has a major crack running down the center of it, exposing Kreetus's heart to open attacks.  Kreetus has been around for over 1,000 years and has fathered over 3,000 kreeton and dark beholder offspring.",
	"fishurn": "A large fish with legs, fishurn were once considered a form of mermaid.  They can swim like a fish using the large fins on the back of their head and they can also walk like a human.  Similar to fish they also have a very low intelligence and will eat any small bug or debris they see in front of them.  Their wide spread eyes allow them to see in front of them as well as on the sides.",
	"proteum": "Ruler of the sea, proteum are massive whale fish with electricity infused in their body.  They can gobble up entire creatures in one bite without even realizing it.  Their sharp teeth allow them to slice prey in half within one chomp.  The train bridge running from Mushroom Village to Aqualantis must be rebuilt once a year because of the damage done to it by hungry proteum chewing on the support beams.  On average one proteum eats approximately 50 - 70 fishurn a day.",
	"bionic bird": "A robotic bird that flies down from the sky attacking any humans nearby.  Their primary goal programmed into their memory is to defend any titanium vultures in the area.  The bionic bird is a very hostile creature that survives from battery charges emitted from the large lights near Robo City.  Upon their arrival, Robo City alarms are set to warn players of their impending attack.  Bionic bird's wing are constructed from sharp razor blade metal enabling them to cause major damage to enemies.",
	"titanium vulture": "The titanium vulture is a humongous bird made out of titanium metal.  The titanium metal is twice the strength of steel and half the weight.  This light weight metal allows the bird to be light enough to take flight.  Their wings are much like the wings of bionic birds and are made of several razor sections enabling them to cut enemies inflicting major damage.  Titanium vulture only appear on Robo City on very rare occasions.  When visitors to Robo City hear the sirens go off, those too weak to face the titanium vultures should take shelter.  There are few strong enough to take on its great power.",
	"magmagon": "Magmagon, the king of the dragons.  It lives in lava fields and is thought to be an imbreded monster than has become partially infused with its environment.  Because of this, it has volcano lava running through its veins.  Magmagons do not have a heart.  Instead, their bodies are powered by a red emerald on their chest, emitting a magical energy that allows their body to sustain life.  Despite the emerald being exposed, it is extremely hard making it nearly indestructible.  It is said a magmagon can crush a repguana with less than four attacks.  Although it is equipped with wings, due to their massive size and weight, they are only able to get a few feet off the ground.",
	"aipster": "A crazy monkey whose bodies are well adapted for fighting.  The scars on their eyes are from their first fight as young aipsters at about 2 weeks old.  After just 1 week of being born, they were begin to show signs of hostility.  They eat the tops of mushroom plants and mushroom squish enemies for food.  They use their pointed front teeth to kill the mushroom squish before they eat them.",
	"mongrel": "Half living creature, half mechanical experiment.  The mongrel is an experiment made by scientists about 80 years ago.  It was the scientists goal to create a cyborg monster.  The experiment malfunctioned and the monster ended up killing its creators.  It is a mutant, having 5 heads.  Each head has a mind of its own but is limited to the movement of the overall machine.  If the gears were to stop, the monster would slowly die.  The mongrel is a purely hostile enemy, always at war with itself and each of the different heads.",
	"kraken": "The 6 limbed beast, they call it.  The krakens' body mouth is always dripping acid.  Acid is always running through its veins and due to a weird phenomenom in its body this acid blood often oozes out of its body.  The krakens eight eyes give it a extremely great eye sight, allowing it to detect foes in roughly half the time of a normal predator.  The kraken has an extremely low mental capacity, having only killing and eating built into its brain.  Its large number of pointed teeth will pop the limbs straight off of its victims.",
	"bullopede": "This rugged beast is over 40 feet long and has one serious temper.  It punctures and kills it enemies with it's two large teeth before eating them.  For larger prey, it will battle them with its chin horns on it's face.   The bullopede contains serveral large piercings on its body.  Because of this, it's often called 'The Emo Worm' for those who mock it.",
	"chirplet": "This smaller bird is very tender.  It is one of the least aggressive enemies you will encounter.  It can however, still pose a small threat to those who are weak.  It survives from eating berries.  Its large eyes give it highly accurate eyes able to see far distances.",
	"flockling": "The flockling is a very irritable and angry bird.  They can become irritated just my the sound of their own wings flapping.  Because of this, they are almost always angry.  This also makes them a very hostile enemy, ready to attack anything it sees.  Their beaks can leave a sharp pierce in humans if they are not wearing adequate armor",
	"kraw": "Kraws are sloppy flying birds.  Because of their slightly larger size and nonoptimal aerodynamic structure, they are not the best flying birds around.  Their very scummy hairy appearance scares away smaller prey.  If you happen to attack one of these birds, they may shed quite a bit of hair feathers when harmed.",
	"mushroom bird": "The large mushroom on its head helps protects its head from attacks.  The mushroom also contains the birds brain as well as all of its organs.  So even though the mushroom protects it, it can also be detrimental to the birds life if harmed.  Sometimes, they will eat mushroom ball enemies for food.",
	"omega fluff": "Named after the large amounts of fur on its body, the omega fluff is a vicious creature.  They reside in one of the most pleasant places on earth, but despite its fluffy coat it is a horribly mean beast.  Their mouth is so large that they can swallow a sasquatch it just one bite without even chewing it."
}

var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

var panel_bg: TextureRect = null
var close_btn: TextureButton = null
var content_layer: Control = null

var selected_enemy: String = ""
var selected_fish: String = ""
var enemy_list: Array[String] = []
var fish_list: Array[String] = []

var enemy_panel_buttons: Array[TextureButton] = []
var fish_panel_buttons: Array[TextureButton] = []
var back_btn: TextureButton = null
var sound_btn: TextureButton = null

var card_title_label: Label = null
var card_stats_label: Label = null
var card_desc_label: Label = null
var card_shiny_unknown_label: Label = null
var card_enemy_sprite: AnimatedSprite2D = null

var _current_panel: String = "panel 1"
var _using_custom_lists: bool = false


func _init(p_enemy_list: Array[String] = [], p_fish_list: Array[String] = []) -> void:
	enemy_list = p_enemy_list.duplicate()
	fish_list = p_fish_list.duplicate()
	_using_custom_lists = not (enemy_list.is_empty() and fish_list.is_empty())


func _ready() -> void:
	custom_minimum_size = Vector2(819, 532)
	size = Vector2(819, 532)
	if not _using_custom_lists:
		_load_from_profile()
	_build_base_ui()
	goto_main()


func show_menu() -> void:
	visible = true
	update_display()


func update_display() -> void:
	if not _using_custom_lists:
		_load_from_profile()
	if _current_panel == "panel 2" and not selected_enemy.is_empty():
		show_enemy_stats(selected_enemy)
	elif _current_panel == "panel 3" and not selected_fish.is_empty():
		show_fish_stats(selected_fish)
	else:
		goto_main()


func _load_from_profile() -> void:
	var pio: Node = get_node_or_null("/root/PlayerIOClient")
	if pio == null or not ("my_player_object" in pio) or not (pio.my_player_object is Dictionary):
		return
	enemy_list.clear()
	fish_list.clear()
	var p_obj: Dictionary = pio.my_player_object
	var raw_enemies: Variant = p_obj.get("enemyList", "")
	if raw_enemies is String and not raw_enemies.is_empty():
		for part: String in raw_enemies.split(",", false):
			var clean: String = part.strip_edges()
			if not clean.is_empty() and not enemy_list.has(clean):
				enemy_list.append(clean)
	elif raw_enemies is Array:
		for e_item: Variant in raw_enemies:
			var clean: String = str(e_item).strip_edges()
			if not clean.is_empty() and not enemy_list.has(clean):
				enemy_list.append(clean)

	var raw_fish: Variant = p_obj.get("fishList", "")
	if raw_fish is String and not raw_fish.is_empty():
		for part: String in raw_fish.split(",", false):
			var clean: String = part.strip_edges()
			if not clean.is_empty() and not fish_list.has(clean):
				fish_list.append(clean)
	elif raw_fish is Array:
		for f_item: Variant in raw_fish:
			var clean: String = str(f_item).strip_edges()
			if not clean.is_empty() and not fish_list.has(clean):
				fish_list.append(clean)


func set_discovered_lists(p_enemy_list: Array[String], p_fish_list: Array[String]) -> void:
	enemy_list = p_enemy_list.duplicate()
	fish_list = p_fish_list.duplicate()
	_using_custom_lists = true
	if is_inside_tree():
		goto_main()


func _build_base_ui() -> void:
	var atlas_loader: Node = _get_atlas_loader()
	atlas_loader.register_starling_atlas("heropedia menu")

	# HeropediaMenu.as:39-42: panel 1 (819x532) at (-336, -208)
	panel_bg = TextureRect.new()
	panel_bg.name = "PanelBG"
	panel_bg.texture = atlas_loader.get_starling_texture("heropedia menu", "panel 1")
	panel_bg.position = Vector2.ZERO
	panel_bg.size = Vector2(819, 532)
	panel_bg.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(panel_bg)

	# HeropediaMenu.as:43-49: x btn at (477, -193), pivot (30, 19) -> (783, -4)
	close_btn = TextureButton.new()
	close_btn.name = "CloseButton"
	close_btn.texture_normal = atlas_loader.get_starling_texture("heropedia menu", "x btn")
	close_btn.position = Vector2(477.0 - 30.0, -193.0 - 19.0) + FLASH_OFFSET
	close_btn.focus_mode = Control.FOCUS_NONE
	close_btn.pressed.connect(close_menu)
	add_child(close_btn)

	content_layer = Control.new()
	content_layer.name = "ContentLayer"
	content_layer.position = Vector2.ZERO
	content_layer.size = Vector2(821, 532)
	content_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(content_layer)


func _clear_content() -> void:
	enemy_panel_buttons.clear()
	fish_panel_buttons.clear()
	back_btn = null
	sound_btn = null
	card_title_label = null
	card_stats_label = null
	card_desc_label = null
	card_shiny_unknown_label = null
	card_enemy_sprite = null
	for child: Node in content_layer.get_children():
		content_layer.remove_child(child)
		child.queue_free()


func goto_main() -> void:
	if not _using_custom_lists:
		_load_from_profile()
	_clear_content()
	selected_enemy = ""
	selected_fish = ""
	_current_panel = "panel 1"

	var atlas_loader: Node = _get_atlas_loader()
	var panel_tex: Texture2D = atlas_loader.get_starling_texture("heropedia menu", "panel 1")
	panel_bg.texture = panel_tex
	panel_bg.size = Vector2(819, 532)
	custom_minimum_size = Vector2(819, 532)
	size = Vector2(819, 532)

	var click_tex_1: Texture2D = atlas_loader.get_starling_texture("heropedia menu", "click panel 1")
	var click_tex_2: Texture2D = atlas_loader.get_starling_texture("heropedia menu", "click panel 2")
	var click_tex_3: Texture2D = atlas_loader.get_starling_texture("heropedia menu", "click panel 3")
	var shine_tex: Texture2D = atlas_loader.get_starling_texture("heropedia menu", "shine")
	var stats_font: Font = atlas_loader.get_bitmap_font("stats_font.fnt")

	var total_enemies: int = _get_total_enemy_types()
	var total_fish: int = _get_total_fish_types()

	# Враги (HeropediaMenu.as:75-141): 3 колонки, шаг 146x27
	var col: int = 0
	var row: int = 0
	for i: int in range(total_enemies):
		if i % 3 == 0 and i > 0:
			row += 1
			col = 0
		var e_name: String = enemy_list[i] if i < enemy_list.size() else "??????"
		var is_known: bool = (e_name != "??????")

		var btn: TextureButton = TextureButton.new()
		btn.name = "EnemySlot_%d" % i
		btn.texture_normal = click_tex_1 if is_known else click_tex_3
		btn.texture_hover = click_tex_2 if is_known else click_tex_3
		# HeropediaMenu.as:86-89: x = -216 + col*146, y = -106 + row*27, pivot (105, 14) -> (15 + col*146, 88 + row*27)
		btn.position = Vector2(-216.0 - 105.0 + float(col) * 146.0, -106.0 - 14.0 + float(row) * 27.0) + FLASH_OFFSET
		btn.size = Vector2(146, 32)
		btn.disabled = not is_known
		btn.focus_mode = Control.FOCUS_NONE
		if is_known:
			var captured_enemy: String = e_name
			btn.pressed.connect(func() -> void: show_enemy_stats(captured_enemy))
		content_layer.add_child(btn)
		enemy_panel_buttons.append(btn)

		var lbl: Label = Label.new()
		lbl.name = "EnemyLabel_%d" % i
		lbl.text = e_name
		# HeropediaMenu.as:128-130: 130x20 at (-316 + col*146, -119 + row*27) -> (20 + col*146, 89 + row*27)
		lbl.position = Vector2(-316.0 + float(col) * 146.0, -119.0 + float(row) * 27.0) + FLASH_OFFSET
		lbl.size = Vector2(130, 20)
		lbl.clip_text = true
		lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		lbl.add_theme_font_override("font", stats_font)
		lbl.add_theme_font_size_override("font_size", 15)
		lbl.add_theme_color_override("font_color", Color.WHITE)
		content_layer.add_child(lbl)

		col += 1

	# Рыбы (HeropediaMenu.as:96-184): 3 колонки, шаг 117x24, scale 0.8
	col = 0
	row = 0
	for i: int in range(total_fish):
		if i % 3 == 0 and i > 0:
			row += 1
			col = 0
		var raw_fish: String = fish_list[i] if i < fish_list.size() else "??????"
		var f_name: String = _fish_no_shiny_name(raw_fish)
		var is_known: bool = (raw_fish != "??????")

		var btn: TextureButton = TextureButton.new()
		btn.name = "FishSlot_%d" % i
		btn.texture_normal = click_tex_1 if is_known else click_tex_3
		btn.texture_hover = click_tex_2 if is_known else click_tex_3
		# HeropediaMenu.as:106-110: x = 207 + col*117, y = -104 + row*24, pivot (105, 14), scale 0.8
		btn.position = Vector2(207.0 - 105.0 * 0.8 + float(col) * 117.0, -104.0 - 14.0 * 0.8 + float(row) * 24.0) + FLASH_OFFSET
		btn.scale = Vector2(0.8, 0.8)
		btn.size = Vector2(146, 32)
		btn.disabled = not is_known
		btn.focus_mode = Control.FOCUS_NONE
		if is_known:
			var captured_fish: String = f_name
			btn.pressed.connect(func() -> void: show_fish_stats(captured_fish))
		content_layer.add_child(btn)
		fish_panel_buttons.append(btn)

		var lbl: Label = Label.new()
		lbl.name = "FishLabel_%d" % i
		lbl.text = f_name
		# HeropediaMenu.as:153-155: 130x20 at (125 + col*117, -114 + row*24)
		lbl.position = Vector2(125.0 + float(col) * 117.0, -114.0 + float(row) * 24.0) + FLASH_OFFSET
		lbl.size = Vector2(130, 20)
		lbl.clip_text = true
		lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		lbl.add_theme_font_override("font", stats_font)
		lbl.add_theme_font_size_override("font_size", 13)
		lbl.add_theme_color_override("font_color", Color.WHITE)
		content_layer.add_child(lbl)

		if is_known and _has_shiny_fish(f_name) and shine_tex != null:
			var shine_rect: TextureRect = TextureRect.new()
			shine_rect.name = "FishShine_%d" % i
			shine_rect.texture = shine_tex
			shine_rect.position = Vector2(229.0 - 10.0 + float(col) * 117.0, -106.0 - 10.0 + float(row) * 24.0) + FLASH_OFFSET
			shine_rect.scale = Vector2(0.92, 0.92)
			shine_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
			content_layer.add_child(shine_rect)

		col += 1


func show_enemy_stats(enemy_name: String) -> void:
	_clear_content()
	selected_enemy = enemy_name
	_current_panel = "panel 2"

	var atlas_loader: Node = _get_atlas_loader()
	panel_bg.texture = atlas_loader.get_starling_texture("heropedia menu", "panel 2")
	panel_bg.size = Vector2(820, 483)
	custom_minimum_size = Vector2(820, 483)
	size = Vector2(820, 483)

	var stats_font: Font = atlas_loader.get_bitmap_font("stats_font.fnt")
	var readable_font: Font = atlas_loader.get_bitmap_font("readable_font.fnt")

	_add_back_button(atlas_loader)

	# HeropediaMenu.as:209-215: sound btn at (-106, 19), pivot (14, 13)
	sound_btn = TextureButton.new()
	sound_btn.name = "EnemySoundBtn"
	sound_btn.texture_normal = atlas_loader.get_starling_texture("heropedia menu", "sound btn")
	sound_btn.position = Vector2(-106.0 - 14.0, 19.0 - 13.0) + FLASH_OFFSET
	sound_btn.focus_mode = Control.FOCUS_NONE
	sound_btn.pressed.connect(func() -> void: enemy_sound_requested.emit(selected_enemy))
	content_layer.add_child(sound_btn)

	# HeropediaMenu.as:221-223: name (250x28) at (-310, -164)
	card_title_label = Label.new()
	card_title_label.name = "EnemyTitleLabel"
	card_title_label.text = enemy_name
	card_title_label.position = Vector2(-310.0, -164.0) + FLASH_OFFSET
	card_title_label.size = Vector2(250, 28)
	card_title_label.add_theme_font_override("font", stats_font)
	card_title_label.add_theme_font_size_override("font_size", 22)
	card_title_label.add_theme_color_override("font_color", Color.WHITE)
	content_layer.add_child(card_title_label)

	var sdb: Node = _get_stats_db()
	var e_data: Dictionary = sdb.get_enemy_data(enemy_name) if sdb != null else {}

	var stats_text: String = "Данные врага не найдены в StatsDB"
	var desc_text: String = str(ENEMY_DESCRIPTIONS.get(enemy_name, "не установлено"))
	if not e_data.is_empty():
		var hp_val: Variant = e_data.get("h", e_data.get("health", 0))
		var def_val: Variant = e_data.get("d", e_data.get("defense", 0))
		var spd_val: float = float(e_data.get("s", e_data.get("moveSpeed", 0.0)))
		var worth_val: int = int(e_data.get("w", e_data.get("worth", 0)))
		var xp_val: int = int(e_data.get("xp", worth_val * 3))
		var height_val: Variant = e_data.get("height", "?")
		var pwr_val: Variant = e_data.get("p", e_data.get("power", 0))
		var speed_mph: float = snappedf(spd_val * 8.0, 0.1)
		stats_text = "Health: %s\nDefense: %s\nSpeed: %s mph\nXP: %d\nWorth: $%d\nHeight: %s feet\nPower: %s" % [
			str(hp_val), str(def_val), str(speed_mph), xp_val, worth_val, str(height_val), str(pwr_val)
		]
		if e_data.has("desc") and not str(e_data["desc"]).is_empty():
			desc_text = str(e_data["desc"])

	# HeropediaMenu.as:216-220, 234-241: спрайт врага справа (252, 44), scale = 0.5
	var swf: Node = _get_swf_loader()
	if swf != null and swf.has_method("get_enemy_sprite_frames"):
		var frames: SpriteFrames = swf.get_enemy_sprite_frames(enemy_name)
		if frames != null:
			card_enemy_sprite = AnimatedSprite2D.new()
			card_enemy_sprite.name = "EnemyPreviewSprite"
			card_enemy_sprite.sprite_frames = frames
			card_enemy_sprite.animation = &"default"
			card_enemy_sprite.frame = 0
			card_enemy_sprite.scale = Vector2(0.5, 0.5)
			var y_offset: float = 44.0
			if enemy_name == "mongrel":
				y_offset -= 170.0
			elif enemy_name == "omega fluff":
				y_offset -= 37.0
			card_enemy_sprite.position = Vector2(252.0, y_offset) + FLASH_OFFSET
			content_layer.add_child(card_enemy_sprite)

	# HeropediaMenu.as:225-228: stats (224x142) at (-310, -125)
	card_stats_label = Label.new()
	card_stats_label.name = "EnemyStatsLabel"
	card_stats_label.text = stats_text
	card_stats_label.position = Vector2(-310.0, -125.0) + FLASH_OFFSET
	card_stats_label.size = Vector2(224, 160)
	card_stats_label.add_theme_font_override("font", stats_font)
	card_stats_label.add_theme_font_size_override("font_size", 17)
	card_stats_label.add_theme_color_override("font_color", Color.WHITE)
	content_layer.add_child(card_stats_label)

	# HeropediaMenu.as:229-233: desc (768x148) at (-310, 63)
	card_desc_label = Label.new()
	card_desc_label.name = "EnemyDescLabel"
	card_desc_label.text = desc_text
	card_desc_label.position = Vector2(-310.0, 63.0) + FLASH_OFFSET
	card_desc_label.size = Vector2(768, 148)
	card_desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	card_desc_label.add_theme_font_override("font", readable_font)
	card_desc_label.add_theme_font_size_override("font_size", 14)
	card_desc_label.add_theme_color_override("font_color", Color.WHITE)
	content_layer.add_child(card_desc_label)


func show_fish_stats(fish_name: String) -> void:
	_clear_content()
	selected_fish = fish_name
	_current_panel = "panel 3"

	var atlas_loader: Node = _get_atlas_loader()
	panel_bg.texture = atlas_loader.get_starling_texture("heropedia menu", "panel 3")
	panel_bg.size = Vector2(821, 483)
	custom_minimum_size = Vector2(821, 483)
	size = Vector2(821, 483)

	var stats_font: Font = atlas_loader.get_bitmap_font("stats_font.fnt")
	var readable_font: Font = atlas_loader.get_bitmap_font("readable_font.fnt")

	_add_back_button(atlas_loader)

	# HeropediaMenu.as:283-291: "?" if shiny not caught
	if not _has_shiny_fish(fish_name):
		card_shiny_unknown_label = Label.new()
		card_shiny_unknown_label.name = "ShinyUnknownLabel"
		card_shiny_unknown_label.text = "?"
		card_shiny_unknown_label.position = Vector2(30.0, -30.0) + FLASH_OFFSET
		card_shiny_unknown_label.size = Vector2(93, 57)
		card_shiny_unknown_label.add_theme_font_override("font", stats_font)
		card_shiny_unknown_label.add_theme_font_size_override("font_size", 38)
		card_shiny_unknown_label.add_theme_color_override("font_color", Color.WHITE)
		content_layer.add_child(card_shiny_unknown_label)

	# HeropediaMenu.as:292-294: name (250x28) at (-310, -164)
	card_title_label = Label.new()
	card_title_label.name = "FishTitleLabel"
	card_title_label.text = fish_name
	card_title_label.position = Vector2(-310.0, -164.0) + FLASH_OFFSET
	card_title_label.size = Vector2(250, 28)
	card_title_label.add_theme_font_override("font", stats_font)
	card_title_label.add_theme_font_size_override("font_size", 22)
	card_title_label.add_theme_color_override("font_color", Color.WHITE)
	content_layer.add_child(card_title_label)

	# StatsDB пока не содержит таблицу fishStats (не установлено)
	var f_data: Dictionary = {}
	var sdb: Node = _get_stats_db()
	if sdb != null and "fish_stats" in sdb and sdb.fish_stats is Dictionary and sdb.fish_stats.has(fish_name):
		f_data = sdb.fish_stats[fish_name]

	var stats_text: String = "не установлено (таблица fishStats отсутствует в StatsDB)"
	var desc_text: String = "не установлено (таблица fishDescs отсутствует в StatsDB)"
	if not f_data.is_empty():
		var rare_val: int = int(f_data.get("rare", 100))
		var occurrence: String = "common"
		if rare_val < 15:
			occurrence = "rare"
		elif rare_val < 50:
			occurrence = "uncommon"
		stats_text = "Bite speed: %s ms\nWorth: $%s\nHeal: %s hp\nOccurance: %s" % [
			str(f_data.get("time", 0)), str(f_data.get("cost", 0)), str(f_data.get("heal", 0)), occurrence
		]
		desc_text = str(f_data.get("desc", desc_text))

	# HeropediaMenu.as:305-308: stats (224x142) at (-310, -145)
	card_stats_label = Label.new()
	card_stats_label.name = "FishStatsLabel"
	card_stats_label.text = stats_text
	card_stats_label.position = Vector2(-310.0, -145.0) + FLASH_OFFSET
	card_stats_label.size = Vector2(280, 142)
	card_stats_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	card_stats_label.add_theme_font_override("font", stats_font)
	card_stats_label.add_theme_font_size_override("font_size", 17)
	card_stats_label.add_theme_color_override("font_color", Color.WHITE)
	content_layer.add_child(card_stats_label)

	# HeropediaMenu.as:309-313: desc (768x148) at (-310, 63)
	card_desc_label = Label.new()
	card_desc_label.name = "FishDescLabel"
	card_desc_label.text = desc_text
	card_desc_label.position = Vector2(-310.0, 63.0) + FLASH_OFFSET
	card_desc_label.size = Vector2(768, 148)
	card_desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	card_desc_label.add_theme_font_override("font", readable_font)
	card_desc_label.add_theme_font_size_override("font_size", 14)
	card_desc_label.add_theme_color_override("font_color", Color.WHITE)
	content_layer.add_child(card_desc_label)


func _add_back_button(atlas_loader: Node) -> void:
	# HeropediaMenu.as:201-208 & 267-274: back btn at (-279, 239), pivot (36, 17) -> (21, 430)
	back_btn = TextureButton.new()
	back_btn.name = "HeroBackBtn"
	back_btn.texture_normal = atlas_loader.get_starling_texture("heropedia menu", "back btn")
	back_btn.position = Vector2(-279.0 - 36.0, 239.0 - 17.0) + FLASH_OFFSET
	back_btn.focus_mode = Control.FOCUS_NONE
	back_btn.pressed.connect(goto_main)
	content_layer.add_child(back_btn)


func _get_total_enemy_types() -> int:
	var sdb: Node = _get_stats_db()
	if sdb == null or not ("enemy_stats" in sdb):
		return enemy_list.size()
	var count: int = 0
	for k: Variant in sdb.enemy_stats.keys():
		if k is int:
			count += 1
	return maxi(count, enemy_list.size())


func _get_total_fish_types() -> int:
	var sdb: Node = _get_stats_db()
	if sdb != null and "fish_stats" in sdb and sdb.fish_stats is Dictionary and not sdb.fish_stats.is_empty():
		return sdb.fish_stats.size()
	return fish_list.size()


func _has_shiny_fish(fish_name: String) -> bool:
	for f: String in fish_list:
		if f.begins_with("shiny") and f.find(fish_name) != -1:
			return true
	return false


static func _fish_no_shiny_name(raw_name: String) -> String:
	if raw_name.begins_with("shiny "):
		return raw_name.substr(6)
	return raw_name


func _gui_input(event: InputEvent) -> void:
	if not is_draggable:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_offset = get_global_mouse_position() - global_position
			move_to_front()
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - drag_offset


func close_menu() -> void:
	visible = false
	closed.emit()


static func _get_atlas_loader() -> Node:
	if Engine.has_singleton("StarlingAtlasLoader"):
		return Engine.get_singleton("StarlingAtlasLoader")
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree != null and tree.root.has_node("StarlingAtlasLoader"):
		return tree.root.get_node("StarlingAtlasLoader")
	return load("res://scripts/autoload/StarlingAtlasLoader.gd").new()


static func _get_stats_db() -> Node:
	if Engine.has_singleton("StatsDB"):
		return Engine.get_singleton("StatsDB")
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree != null and tree.root.has_node("StatsDB"):
		return tree.root.get_node("StatsDB")
	return null


static func _get_swf_loader() -> Node:
	if Engine.has_singleton("SwfSpriteLoader"):
		return Engine.get_singleton("SwfSpriteLoader")
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree != null and tree.root.has_node("SwfSpriteLoader"):
		return tree.root.get_node("SwfSpriteLoader")
	return null
