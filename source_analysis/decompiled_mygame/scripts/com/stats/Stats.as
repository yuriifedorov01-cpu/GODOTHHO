package com.stats
{
   import com.sound.*;
   import flash.media.Sound;
   
   public class Stats
   {
      
      private static var defenseStat:ItemStat;
      
      private static var castleBlockStat:CastleBlockStat;
      
      public static var itemList:Array = new Array();
      
      public static var missionList:Vector.<String> = new Vector.<String>();
      
      public static var enemyList:Vector.<String> = new Vector.<String>();
      
      public static var eStats:Array = new Array();
      
      public static var wStats:Array = new Array();
      
      public static var hStats:Array = new Array();
      
      public static var sStats:Array = new Array();
      
      public static var pStats:Array = new Array();
      
      public static var shoesStats:Array = new Array();
      
      public static var itemStats:Array = new Array();
      
      public static var accStats:Array = new Array();
      
      public static var petHelmetStats:Array = new Array();
      
      public static var fishStats:Array = new Array();
      
      public static var allItemDescs:Array = new Array();
      
      public static var envStats:Array = new Array();
      
      public static var missionStats:Array = new Array();
      
      public static var levelStats:Array = new Array();
      
      public static var eDescs:Array = new Array();
      
      public static var fishDescs:Array = new Array();
      
      public static var skillStats:Array = new Array();
      
      public static var petStats:Array = new Array();
      
      public static var petModes:Array = new Array();
      
      public static var petModesList:Array = new Array();
      
      public static var totalEnemyTypes:int = new int(0);
      
      public static var totalFishTypes:int = new int(0);
      
      public static var castleBlockStats:Vector.<CastleBlockStat> = new Vector.<CastleBlockStat>();
      
      public static var helmetsLoaded:Boolean = false;
      
      public static var shirtsLoaded:Boolean = false;
      
      public static var legsLoaded:Boolean = false;
      
      public static var weaponsLoaded:Boolean = false;
      
      public static var shoesLoaded:Boolean = false;
      
      public static var itemsLoaded:Boolean = false;
      
      public static var accessoriesLoaded:Boolean = false;
      
      public static var petHelmetsLoaded:Boolean = false;
      
      public static var fishStatsLoaded:Boolean = false;
      
      public static var basePetStatsLoaded:Boolean = false;
      
      public static var itemDescsLoaded:Boolean = false;
      
      setNewMission("The Black Hooded Hatchet",100,"Locate the man in black clothes with a hatchet who is terrorizing your village.",false,false);
      setNewMission("Find the Cult\'s Hideout",500,"Find out where the cult\'s hideout is.  Mizon said it was far away from him.",false,false);
      setNewMission("Get Hambone Apples",280,"Get 6 apples and give them to Hambone who is poor and hungry.",false,false);
      setNewMission("Get Brody a Garbage Can Lid",800,"Get Brody the shield he always wanted, a garbage can lid.",false,false);
      setNewMission("Get Jim Sanders Some Gear",300,"Get Jim Sanders a sickle because he needs some new gear to be stronger.",false,false);
      setNewMission("Give Cleveland His Letter",400,"Give Cleveland in Mushroom Village, his letter from Arny.",false,false);
      setNewMission("Look Like a Black Hood",2200,"Look like a Black Hooded cult member so you can trick Fredward.",false,false);
      setNewMission("Get Gordon Watermelon",450,"Gordon is trying to start a watermelon farm.  Get him 6 watermelon to help him.",false,false);
      setNewMission("Get Pablo a Monster Skull",3000,"Get Pablo the skull of a monster.  Maybe some enemies will drop them?",false,false);
      setNewMission("Show Joshua All Enemies",2500,"Fill your Hero-pedia up with all enemies info then report back to Joshua.",false,false);
      setNewMission("Get Scarlet a Hockey Mask",430,"Get Scarlet a hockey mask so she can look scarier. Maybe a monster will drop one?",false,false);
      setNewMission("Look Like the Lost Warrior",1800,"Trick Clark into thinking you\'re the lost warrior. His clues are said to be written in stone.",false,false);
      setNewMission("Solve Jimmy\'s Puzzle",1900,"Jimmy drew some graffiti of items on objects throughout the map. Wear the items Jimmy drew.",false,false);
      setNewMission("Complete Albert\'s Puzzle",1200,"Talk to Albert to get clues on what the special helmet he wants you to wear is.",false,false);
      setNewMission("Get Cassie Pumpkin Helmets",2000,"Cassie thinks pumpkin helmets are cool.  Get her two pumpkin helmets.",false,false);
      setNewMission("Complete Billbert\'s Puzzle",1200,"Talk to Billbert to get clues on what the special helmet he wants you to wear is.",false,false);
      setNewMission("Collect 4 Pets",1800,"Complete Wilson\'s triple dog dare and own 4 pets.  Have 4 pets on you at once to finish.",false,false);
      setNewMission("Ride a Pet",1000,"Use a pet as a mount and ride it.  Cheer Patrick up and show him you are riding one.",false,false);
      setNewMission("Catch Every Fish",2200,"Catch every type of fish in your Heropedia and report back to Lamar.",false,false);
      setNewMission("Solve Philbert\'s Puzzle",1500,"Complete Philbert\'s puzzle as his last dying wish for fun.",false,false);
      setNewMission("Reach High Energy Level",12000,"Reach an energy level of at least 9,000 to prove to Derek that you are powerful.",false,false);
      setNewLevel(1,2,0,0,0,0,0,0,"Wooden Plains",7);
      setNewLevel(2,1,4,0,0,0,0,0,"Green Peak",7);
      setNewLevel(3,6,0,4,0,0,0,0,"Tiki Flatts",7);
      setNewLevel(4,5,2,3,0,0,0,0,"Palm Forest",7);
      setNewLevel(5,4,8,7,0,0,0,0,"Coconut Stretch",7);
      setNewLevel(6,3,9,0,0,0,0,0,"High Greens",7);
      setNewLevel(7,0,0,5,8,0,0,0,"Heaths Training Ground",7);
      setNewLevel(8,44,5,0,7,0,0,0,"Indian Territory",7);
      setNewLevel(9,10,6,0,0,0,0,0,"Fairytale Woods",16);
      setNewLevel(10,9,11,14,0,0,0,0,"Candy Lane",16);
      setNewLevel(11,12,10,0,0,0,0,0,"Sugarcane Slopes",16);
      setNewLevel(12,11,13,15,16,17,0,0,"Fairyville",16);
      setNewLevel(13,18,12,0,0,0,0,0,"Lollipop Flatts",16);
      setNewLevel(14,0,0,10,0,0,0,0,"Candy Water Wells",16);
      setNewLevel(15,0,0,12,0,0,0,0,"Anderson Family Home",16);
      setNewLevel(16,0,0,0,12,0,0,0,"Snoop\'s Shop",16);
      setNewLevel(17,0,0,0,0,12,0,0,"Wayne\'s Home",16);
      setNewLevel(18,13,19,0,0,0,0,0,"Windmill Top",16);
      setNewLevel(19,20,18,0,0,0,0,0,"Barren Flatts",16);
      setNewLevel(20,19,21,0,0,0,0,0,"Windy Ridge",16);
      setNewLevel(21,22,20,0,0,0,0,0,"Dungeon Entrance",16);
      setNewLevel(22,21,23,26,24,0,0,0,"Deadly Dungeon",16);
      setNewLevel(23,0,22,125,0,0,0,0,"Goo Dungeon",16);
      setNewLevel(24,0,25,0,22,0,0,0,"Brick Dungeon",16);
      setNewLevel(25,27,24,0,0,0,0,0,"Deep Dungeon",16);
      setNewLevel(26,0,0,22,0,0,0,0,"Long Dungeon",16);
      setNewLevel(27,25,0,0,0,0,0,0,"Giant Goo Cube Den",16);
      setNewLevel(28,29,109,0,0,0,0,0,"Mechanical Drop",117);
      setNewLevel(29,28,30,0,0,0,0,0,"Robotic Structures",117);
      setNewLevel(30,31,29,124,117,118,0,0,"Robo City",117);
      setNewLevel(31,30,33,32,0,0,0,0,"Light Highway",117);
      setNewLevel(32,0,0,31,0,0,0,0,"Future Water Trench",117);
      setNewLevel(33,34,31,0,0,0,0,0,"Wastelands Entrance",117,"purple",33);
      setNewLevel(34,33,35,40,0,0,0,0,"Dark Lands",117,"purple",33);
      setNewLevel(35,36,34,0,0,0,0,0,"Wasted Plains",117,"purple",33);
      setNewLevel(36,35,37,0,40,116,0,0,"Forbidden Huts",117,"purple",33);
      setNewLevel(37,38,36,39,0,0,0,0,"Beholder Lookout",117,"purple",33);
      setNewLevel(38,37,41,0,0,0,0,0,"Indian Burial Grounds",117,"purple",33);
      setNewLevel(39,0,0,37,0,0,0,0,"Bartholomew\'s Shop",117,"purple",33);
      setNewLevel(40,0,0,34,36,0,0,0,"Wastelands Maze",117,"purple",33);
      setNewLevel(41,42,38,0,0,0,0,0,"Repguana Sanction",117);
      setNewLevel(42,41,43,0,0,0,0,0,"Unwelcome Den",117);
      setNewLevel(43,104,42,0,0,0,0,0,"Slimey Territory",117);
      setNewLevel(44,8,45,0,0,0,0,0,"Mushroom Alley",111);
      setNewLevel(45,0,44,0,0,46,0,0,"Squishy Forest",111);
      setNewLevel(46,49,0,111,47,45,0,0,"Mush Front",111);
      setNewLevel(47,48,52,0,46,0,0,0,"Fungus Lane",111);
      setNewLevel(48,47,67,58,0,0,0,0,"Mush Cave",111);
      setNewLevel(49,46,50,0,0,0,0,0,"Monkey Jungle",111);
      setNewLevel(50,0,49,0,0,0,0,0,"Ooka Ooka Shrooms",111);
      setNewLevel(52,53,47,0,0,0,0,0,"Fungus Forest",111);
      setNewLevel(53,52,54,0,0,0,0,0,"Blue Shroom Den",122);
      setNewLevel(54,55,53,56,64,0,0,0,"Fungi Woods",122);
      setNewLevel(55,54,127,121,122,123,120,119,"Mushroom Village",122);
      setNewLevel(56,0,0,54,0,0,0,0,"Mushroom Trading District",122);
      setNewLevel(57,85,0,0,127,0,0,0,"Shroom Slide",122);
      setNewLevel(58,59,0,48,0,0,0,0,"Tropical Beach",7);
      setNewLevel(59,58,60,62,0,0,0,0,"Chillin\' Beach",7);
      setNewLevel(60,61,59,63,62,0,0,0,"Seaside Zone",7);
      setNewLevel(61,60,81,0,0,0,0,0,"Cool Shore",7);
      setNewLevel(62,0,0,59,60,0,0,0,"Coast Side",7);
      setNewLevel(63,115,0,60,0,0,0,0,"Haunted Estate",7,"brown",-163);
      setNewLevel(64,0,0,110,54,127,0,0,"Shroom Passage",122);
      setNewLevel(65,66,115,0,0,0,0,0,"Death Valley",7,"brown",-163);
      setNewLevel(66,65,0,0,0,0,0,0,"Haunted Woods",7,"brown",-163);
      setNewLevel(67,70,48,68,0,0,0,0,"Plant Swamp",79,"green",-123);
      setNewLevel(68,67,69,73,0,0,0,0,"Wet Bog",79,"green",-123);
      setNewLevel(69,0,68,75,0,0,0,0,"Diseased Forest",79,"green",-123);
      setNewLevel(70,67,71,0,0,0,0,0,"Deep Safari Water",79,"green",-123);
      setNewLevel(71,72,70,74,0,0,0,0,"Lotus Eye Bog",79,"green",-123);
      setNewLevel(72,71,0,0,0,0,0,0,"Carnelia\'s Woods",79,"green",-123);
      setNewLevel(73,0,0,68,0,0,0,0,"Egg Den",79,"green",-123);
      setNewLevel(74,0,0,71,0,0,0,0,"Geraldo\'s Food",79);
      setNewLevel(75,76,0,69,0,0,0,0,"Pine Forest",79);
      setNewLevel(76,75,77,79,80,0,0,0,"Deep Forest",79);
      setNewLevel(77,78,76,0,0,0,0,0,"Frog County",79);
      setNewLevel(78,77,0,0,0,0,0,0,"Craftman Falls",79);
      setNewLevel(79,0,0,76,0,0,0,0,"Pablo\'s House",79);
      setNewLevel(80,0,0,0,76,0,0,0,"Pine Timberland",79);
      setNewLevel(81,82,61,0,0,0,0,0,"Cold Front",83);
      setNewLevel(82,81,83,0,0,0,0,0,"Freezing Mountain",83);
      setNewLevel(83,84,82,0,0,0,0,0,"Snowy Flatts",83);
      setNewLevel(84,83,85,0,0,0,0,0,"Yeti Barracks",83);
      setNewLevel(85,57,84,0,0,0,0,0,"Ice Lake",83);
      setNewLevel(86,87,126,87,0,0,0,0,"Deep Ocean",92);
      setNewLevel(87,86,88,86,88,0,0,0,"Proteum Bottom",92);
      setNewLevel(88,89,87,92,87,0,0,0,"Aqualantis",92);
      setNewLevel(89,88,90,93,0,0,0,0,"Coral Reef",92);
      setNewLevel(90,91,89,0,0,0,0,0,"Bayside",92);
      setNewLevel(91,90,0,0,0,0,0,0,"Drowning Pool",92);
      setNewLevel(92,0,0,88,0,0,0,0,"Fishing Fort",92);
      setNewLevel(93,94,0,89,0,0,0,0,"Skymill Floor 1",92);
      setNewLevel(94,93,101,0,0,0,0,0,"Skymill Floor 2",92);
      setNewLevel(95,96,102,103,0,0,0,0,"Tropical Island",133);
      setNewLevel(96,95,97,0,103,0,0,0,"Tranquil Paradise",133);
      setNewLevel(97,99,96,128,133,130,129,98,"Petropolis",133);
      setNewLevel(98,0,0,0,0,0,0,97,"Pet Adoption District",133);
      setNewLevel(99,97,100,0,0,0,0,0,"Elandra Flatts",133);
      setNewLevel(100,0,99,0,0,0,0,0,"Elandra Peak",133);
      setNewLevel(101,102,94,0,0,0,0,0,"Elandra Island",133);
      setNewLevel(102,101,95,0,0,0,0,0,"Peaceful Seaside",133);
      setNewLevel(103,0,0,95,96,0,0,0,"Beauty Hillside",133);
      setNewLevel(104,43,105,0,0,0,0,0,"Lavastone Trench",117,"red",144);
      setNewLevel(105,106,104,0,0,0,0,0,"Heated Stones",117,"red",144);
      setNewLevel(106,105,107,0,0,0,0,0,"Flaming Reef",117,"red",144);
      setNewLevel(107,108,106,0,0,0,0,0,"Molten Lava Mountain",117,"red",144);
      setNewLevel(108,107,134,0,0,0,0,0,"Lava Plains",117,"red");
      setNewLevel(109,125,28,0,0,0,0,0,"Electric Walkway",117);
      setNewLevel(110,0,0,64,0,0,0,0,"Mushroom Drop",122);
      setNewLevel(111,112,113,46,114,0,0,0,"Arena Entrace",111);
      setNewLevel(112,111,0,0,0,0,0,0,"PvP Forest",111);
      setNewLevel(113,0,111,0,0,0,0,0,"Sparring Grounds",111);
      setNewLevel(114,0,0,0,111,0,0,0,"GvG Woodlands",111);
      setNewLevel(115,63,65,0,0,0,0,0,"Ghostly Cemetery",83,"brown",-163);
      setNewLevel(116,0,0,0,0,36,0,0,"Kreetus\' Lair",117,"purple",33);
      setNewLevel(117,0,0,0,30,0,0,0,"Viper\'s Shop",117);
      setNewLevel(118,0,0,0,0,30,0,0,"Robo Lover\'s Home",117);
      setNewLevel(119,0,0,0,0,0,0,55,"The Guild House",122);
      setNewLevel(120,0,0,0,0,0,55,0,"Carter\'s Coconuts",122);
      setNewLevel(121,0,0,55,0,0,0,0,"Shane Shield\'s House",122);
      setNewLevel(122,0,0,0,55,0,0,0,"Mushroom Village Hotel",122);
      setNewLevel(123,0,0,0,0,55,0,0,"Mushroom Library",122);
      setNewLevel(124,0,0,30,0,0,0,0,"Larry\'s House",117);
      setNewLevel(125,109,0,23,0,0,0,0,"Deep Chamber",117);
      setNewLevel(126,127,86,0,0,0,0,0,"Mush Train Station",122);
      setNewLevel(127,126,55,0,57,64,0,0,"Shroom Fields",122);
      setNewLevel(128,0,0,97,0,0,0,0,"Ricardo\'s House Floor 1",133);
      setNewLevel(129,0,0,0,0,0,97,0,"Ricardo\'s House Floor 2",133);
      setNewLevel(130,131,0,0,0,97,0,0,"Pet Building Floor 1",133);
      setNewLevel(131,130,132,0,0,0,0,0,"Pet Building Floor 2",133);
      setNewLevel(132,0,131,0,0,0,0,0,"Pet Building Floor 3",133);
      setNewLevel(133,0,0,0,97,0,0,0,"Pet Helmet Shop",133);
      setNewLevel(134,135,108,0,0,0,0,0,"Acid Flatts",140,"green",-123);
      setNewLevel(135,134,136,0,0,0,0,0,"Acidic Waters",140,"green",-123);
      setNewLevel(136,137,135,0,0,0,0,0,"Toxic Jungle",140,"green",-123);
      setNewLevel(137,136,138,0,0,0,0,0,"Bullopede Lair",140,"green",-123);
      setNewLevel(138,137,142,139,141,140,0,0,"Acid Village",140,"green",-123);
      setNewLevel(139,0,0,138,0,0,0,0,"Zander\'s House",140,"green",-123);
      setNewLevel(140,0,0,0,0,138,0,0,"Acid Healers",140,"green",-123);
      setNewLevel(141,0,0,0,138,0,0,0,"Isaac\'s Equipment Shop",140,"green",-123);
      setNewLevel(142,143,138,0,0,0,0,0,"Clouds of Destiny",145);
      setNewLevel(143,142,144,0,0,0,0,0,"Almighty Heavens",145);
      setNewLevel(144,0,143,145,0,0,0,0,"Sky Kingdom",145);
      setNewLevel(145,0,0,144,0,0,0,0,"Cloud Fort",145);
      setEDesc("bouncing mushroom","blue",null,"The Bouncing Mushroom is nothing more than a large mushroom which has been brought to life.  When the seed from two blue mushrooms meet, they form a large blue mushroom plant.  When this plant reaches two weeks old, it sprouts to life into what is known as the Bouncing Mushroom.  Scientists are still trying to figure out to this day how a plant turns into a living creature.  Because of their large size Bouncing Mushrooms are highly dangerous.  As a result of lab testing, Bouncing Mushrooms are estimated to be extinct within 20 years.",-6,-111);
      setEDesc("crab","red",null,"The Crab is considered the pest of the beach.  They strive in populated areas with humans.  Their sharp claws can easily take off arms and legs of others and should not be taken lightly.  Crabs are almost never friendly and are even hated by other creatures such as the Red Bouncer.  The Crab\'s hard shell and sharp claws make it a formidable enemy.",2,-37);
      setEDesc("green bouncer","lime",null,"The Green Bouncer is the weakest creature known to man. They survive off of plant leaves and can travel from place to place simply by bouncing. Although they sometimes travel in packs, they pose a very low threat to humans. Because of their small size, life expectancy for the Green Bouncer is usually no more than a few months before it is killed by a stronger creature.",4,-27);
      setEDesc("green walker","green",null,"Green Walkers have evolved from the Green Bouncers.  Sprouting legs, they no longer need to hop from place to place.  Green walkers, aside from their slightly larger size and legs, share almost all of the same qualities as the Green Bouncer.  Because they are so friendly, children sometimes ride on the back of them to get from place to place.",0,-33);
      setEDesc("horned monster","green",null,"Horned monsters live in the depths of dead and abandoned woods.  They eat smaller creatures than themselves and use their horn to take down prey. Horned monsters are angry creatures that are very aggressive towards humans.",2,-67);
      setEDesc("mushroom ball","blue",null,"Mushroom Balls are one of the first creatures to roam the earth having legs.  Unlike the Bouncer family they have two eyes, and a fairly hard shelled mushroom top.  Their mushroom shell protects them from enemies stronger than them.  Sometimes when they fall they have a tough time getting back up because of their shape and size and can be left upside down for hours, days, or even until they die.",2,-50);
      setEDesc("mushroom squish","dark red",null,"A small creature, the Mushroom Squish uses its mooshy body to squirm around its environment. Mushroom Squishes are very weak creatures and do not pose much of a threat to nearby humans. They are able to digest mud and dirt, and like to live in damp, dirty places.",5,-19);
      setEDesc("orange crazy","orange",null,"Orange Crazies roam free in the upper windmill areas of the earth.  Most people do not enjoy being around them because of their ugly looks and faster movement.  Orange Crazies eat smaller creatures such as Green Bouncers and Mushroom Squish.  They are easily angered creatures and should be approached with caution for the first time.",9,-59);
      setEDesc("plant monster","dark green",null,"One of the toughest creatures to roam the earth is the Plant Monster.  They spend all day protecting their eggs and will not hesitate to destroy anyone who approaches them.  If a Plant Monster goes without eating for days they will sometimes eat their eggs, despite protecting them for so long.  There are hundreds of cases of people dying every year from being attacked by Plant Monsters.  Their strong reptilian scales and aggravated personality make them an enemy to be reckoned with.",8,-112);
      setEDesc("purple goo","purple",null,"Purple Goo, although larger than the Green Bouncer, are still very weak creatures. They roam free, viewing the world through their one large eye. It is believed that roughly 30% of all Purple Goo are blind due to their susceptibility to having their eye punctured. Because of their frequent blindness, some humans capture them and use them as toys, referring to them as \'purple footballs\'.",5,-29);
      setEDesc("red bouncer","red",null,"Red Bouncers are part of the Bouncer Family.  They live in sandy areas and can pose a small threat to weaker humans.  Bloated with ocean water, the Red Bouncer is able to move around by bouncing on its bottom.  Red bouncers are the toughest of the three bouncers.",3,-35);
      setEDesc("yellow hairy monster","yellow",null,"Yellow Hairy Monsters are one of the most hated creatures in the world.  Many people hate them because of their angry look and because they are a nuisance.  They eat whatever they can including other creatures, people\'s clothes, and even infant humans if left unattended.  Although they lurk on the outskirts of Fairyville, Yellow Hairy Monsters are anything but friendly.",0,-45);
      setEDesc("yellow puff monster","yellow",null,"Big, mean, and scary the Yellow Puff Monster does its best to take out anything that is not its kind.  They should be approached with extreme caution and can only be taken down by those who have been thoroughly trained.  There have been reports that humans have come across a few of them which are friendly, but most are not.  Despite their large mouths, they do not eat anything they kill.  They only eat trees and bugs.  Sometimes, the yellow coats from their bodies are made into fur coats.",-1,-88);
      setEDesc("pumpkin creeper","orange",null,"The Pumpkin Creeper is a fairly powerful creature that is able to withstand several hits from an opponent before it is knocked out.  Their hard pumpkin shell protects them from hits but is also used as food by those stronger than it.  Pumpkin Creepers live in dark places that have little to no sunlight.",5,-62);
      setEDesc("great frog","dark green",null,"Large, dumb, and in charge.  The great frog is a big and powerful enemy, although its intelligence  is very low.  They live in forests amongst pine trees and eat mostly bugs.  Because of their incredible strength most humans cannot get near them, making the areas they live in uninhabitable.  Because of their close living quarters, great frogs often get in fights with plant monsters.",-2,-106);
      setEDesc("penguin","black",null,"Penguins live in cold snowy forests and survive off of eating fish.  It has become a custom tradition that penguin mothers craft knight helmets for their young when they reach age 3.  The knight helmet is to protect them from enemies stronger than them, giving penguins the slight edge defensively and helping them to overcome predators.",2,-88);
      setEDesc("sasquatch","yellow",null,"Unbelievably  powerful, the sasquatch is the ultimate destroyer.  Only the most legendary people on earth are able to take one down.  Few people are able to go anywhere near one without risking serious injury or death.  Sasquatches survive off of eating anything they can, plants or animal.  An estimated 2,000 people a year are killed by them.  Sasquatches are extremely dangerous and should be approached with EXTREME caution.",24,-152);
      setEDesc("goo cube","lime",null,"A large, goo filled green cube.  Goo cubes live in dark dungeons and maintain themselves by absorbing bacteria.  It is often argued that goo cubes are lifeless and should not be considered living creatures.  Some say they are merely a collection of scum and bacteria.  Despite their abundance of health, goo cubes have very low attack because of their inability to fight.  Because of their large healths, goo cubes are best taken down with groups of people.",21,-158);
      setEDesc("brick monster","dark red",null,"Brick monsters are thought to have originated from a combination of brick combined with the goo cube.  They are very dumb monsters who survive from eating nothing.  Because of their large size and very hard brick skin, they are able to withstand attacks with little to no damage.  It is said that in a fight, even a sasquatch does little to damage to a brick monster.  Travelers beware.",1,-180);
      setEDesc("block bot","black",null,"Block bots are one of the most technologically advanced creatures in existence.  They were created by man and have evolved for many years until they were able to re-create more of themselves.  They are so smart that scientists consider them a living creature.  Not only are block bots very smart, but they are a formidable opponent.",-8,-107);
      setEDesc("night stalker","black",null,"Blind dinosaurs, the night stalker is a very angry predator.  It feasts off of other creatures weaker than it.  Much like a bat, they use sonar to navigate around their environment.  During their early development, they can be used as pets known as stalklings.",15,-115);
      setEDesc("drill bot","black",null,"Created solely for war, the drill bot is much different from block bots.  While block bots are very smart robots, drill bots are very dumb and lack any real artificial intelligence.  They are programmed purely for fighting and know nothing else.  They cannot reproduce themselves and know only how to kill.  Their bodies are made of the same strong metal that block bots are created from giving them a very high defense.",2,-170);
      setEDesc("lotus eye","lime",null,"Lotus eyes are the rulers of the rain forest.  Using its one massive eye and several smaller eyes its vision is unmatched by any other creature.  Lotus eyes eat other living creatures and are capable of eating plant monsters and even great frogs.  Using their spider like legs they are very fast and agile creatures.  Lotus eyes can only be hunted in packs or by the most powerful of hunters.",-27,-217);
      setEDesc("dark beholder","purple",null,"Dark Beholders are rulers of the wastelands.  They eat night stalkers to stay alive.  Unlike most other creatures, dark beholders do not sleep.  Their bodies can function around the clock without ever needing rest.  When they get old and die, their scales are used to make incredibly strong armor and weapons.  99% of people who have ever seen a dark beholder are no longer alive.",-36,-305);
      setEDesc("Carnelia","green",null,"Carnelia is the evil mother of nature.  She gains life through the aura of other creatures.  Whenever enemies are around, her health replenishes.  It is near impossible for a single human to take down Carnelia on their own.  It is said that even the scales of a dark beholder can be penetrated by the teeth of Carnelia.  It is said that the roots of all trees in the rain forest stem back to her.",-5,-373);
      setEDesc("leafling","tan",null,"Leafling are grown, not bred.  They are born from seeds and begin to have a heartbeat at just under one month of age.  Their lifespan can last anywhere from 2 to 3 years, unless they are killed by a predator before they die of natural causes.  Leafling do not attack other creatures, they eat their meals from nature.",0,-85);
      setEDesc("leaflet","tan",null,"Tiny creatures that appear in very large quantity, they are the early forms of Leaflings before they grow larger.  They are very weak, non-hostile creatures that survive off of the earth.  Because of their weak bodies and low attack, humans often use them as training for their new founded pets.",6,-27);
      setEDesc("glord","green",null,"Large and powerful, glords are the rulers of Elandra Island.  They are born without legs and use their arms to walk from place to place.  Because of this, their arms are roughly 2-3 times stronger than the arms of a normal creature.  This makes them very strong and capable of knocking out their victims with a single punch.",6,-216);
      setEDesc("kreeton","tan",null,"Its rock like body gives it an incredibly high defense.  Due to its lack of arms and spikes however, its attack remains slightly lower than that of a dark beholder.  Its large eyes allow it to see prey from nearly every direction.  If a kreeton is slain, the earth can be felt shaking from the heavy bodies falling.",-29,-238);
      setEDesc("giant goo cube","lime",null,"A large mass of goo, the giant goo cube is approximately 4-5 times the size of a normal goo cube.  Despite their incredible size, they are not a major threat.  Their lack of brain or ligaments makes it very hard for them to attack humans or any other creatures.  However, due to their large weight, they can cause a fair amount of damage to those who are weak.  The giant goo cube also possesses a very large health and gains health from fellow goo cubes in the vicinity.",-3,-317);
      setEDesc("repguana","lime",null,"Even the most prestige heroes and champions have been crushed and obliterated by this monstrosity.  The repguana is relentless and kills anything that comes near it, regardless of friend or foe.  Although the scales remain weaker than that of a kreeton, they are still extremely tough and light weight, making them ideal for archers and those who must carry light equipment.  Due to its large size and fangs, there are only a select few people in the world that can take this mighty beast down.",152,-291);
      setEDesc("Kreetus","tan",null,"A monstrous inbred disaster, Kreetus is a mutant freak spawned as the offspring of a dark beholder and kreeton.  Its large kreeton shelled body is extremely tough and helps it withstand attacks from even the most supreme adversary.  Despite its hard shell it has a major crack running down the center of it, exposing Kreetus\'s heart to open attacks.  Kreetus has been around for over 1,000 years and has fathered over 3,000 kreeton and dark beholder offspring.",-10,-423);
      setEDesc("fishurn","blue",null,"A large fish with legs, fishurn were once considered a form of mermaid.  They can swim like a fish using the large fins on the back of their head and they can also walk like a human.  Similar to fish they also have a very low intelligence and will eat any small bug or debris they see in front of them.  Their wide spread eyes allow them to see in front of them as well as on the sides.",5,-60);
      setEDesc("proteum","blue",null,"Ruler of the sea, proteum are massive whale fish with electricity infused in their body.  They can gobble up entire creatures in one bite without even realizing it.  Their sharp teeth allow them to slice prey in half within one chomp.  The train bridge running from Mushroom Village to Aqualantis must be rebuilt once a year because of the damage done to it by hungry proteum chewing on the support beams.  On average one proteum eats approximately 50 - 70 fishurn a day.",223,-390);
      setEDesc("bionic bird","blue",null,"A robotic bird that flies down from the sky attacking any humans nearby.  Their primary goal programmed into their memory is to defend any titanium vultures in the area.  The bionic bird is a very hostile creature that survives from battery charges emitted from the large lights near Robo City.  Upon their arrival, Robo City alarms are set to warn players of their impending attack.  Bionic bird\'s wing are constructed from sharp razor blade metal enabling them to cause major damage to enemies.",28,-80);
      setEDesc("titanium vulture","blue",null,"The titanium vulture is a humongous bird made out of titanium metal.  The titanium metal is twice the strength of steel and half the weight.  This light weight metal allows the bird to be light enough to take flight.  Their wings are much like the wings of bionic birds and are made of several razor sections enabling them to cut enemies inflicting major damage.  Titanium vulture only appear on Robo City on very rare occasions.  When visitors to Robo City hear the sirens go off, those too weak to face the titanium vultures should take shelter.  There are few strong enough to take on its great power.",192,-262);
      setEDesc("magmagon","black",null,"Magmagon, the king of the dragons.  It lives in lava fields and is thought to be an imbreded monster than has become partially infused with its environment.  Because of this, it has volcano lava running through its veins.  Magmagons do not have a heart.  Instead, their bodies are powered by a red emerald on their chest, emitting a magical energy that allows their body to sustain life.  Despite the emerald being exposed, it is extremely hard making it nearly indestructible.  It is said a magmagon can crush a repguana with less than four attacks.  Although it is equipped with wings, due to their massive size and weight, they are only able to get a few feet off the ground.",-5,-75);
      setEDesc("aipster","orange",null,"A crazy monkey whose bodies are well adapted for fighting.  The scars on their eyes are from their first fight as young aipsters at about 2 weeks old.  After just 1 week of being born, they were begin to show signs of hostility.  They eat the tops of mushroom plants and mushroom squish enemies for food.  They use their pointed front teeth to kill the mushroom squish before they eat them.",12,-63);
      setEDesc("mongrel","red",null,"Half living creature, half mechanical experiment.  The mongrel is an experiment made by scientists about 80 years ago.  It was the scientists goal to create a cyborg monster.  The experiment malfunctioned and the monster ended up killing its creators.  It is a mutant, having 5 heads.  Each head has a mind of its own but is limited to the movement of the overall machine.  If the gears were to stop, the monster would slowly die.  The mongrel is a purely hostile enemy, always at war with itself and each of the different heads.",83,-19);
      setEDesc("kraken","green",null,"The 6 limbed beast, they call it.  The krakens\' body mouth is always dripping acid.  Acid is always running through its veins and due to a weird phenomenom in its body this acid blood often oozes out of its body.  The krakens eight eyes give it a extremely great eye sight, allowing it to detect foes in roughly half the time of a normal predator.  The kraken has an extremely low mental capacity, having only killing and eating built into its brain.  Its large number of pointed teeth will pop the limbs straight off of its victims.",38,-182);
      setEDesc("bullopede","dark green",null,"This rugged beast is over 40 feet long and has one serious temper.  It punctures and kills it enemies with it\'s two large teeth before eating them.  For larger prey, it will battle them with its chin horns on it\'s face.   The bullopede contains serveral large piercings on its body.  Because of this, it\'s often called \'The Emo Worm\' for those who mock it.",375,-185);
      setEDesc("chirplet","tan",null,"This smaller bird is very tender.  It is one of the least aggressive enemies you will encounter.  It can however, still pose a small threat to those who are weak.  It survives from eating berries.  Its large eyes give it highly accurate eyes able to see far distances.",15,-52);
      setEDesc("flockling","green",null,"The flockling is a very irritable and angry bird.  They can become irritated just my the sound of their own wings flapping.  Because of this, they are almost always angry.  This also makes them a very hostile enemy, ready to attack anything it sees.  Their beaks can leave a sharp pierce in humans if they are not wearing adequate armor",45,-37);
      setEDesc("kraw","tan",null,"Kraws are sloppy flying birds.  Because of their slightly larger size and nonoptimal aerodynamic structure, they are not the best flying birds around.  Their very scummy hairy appearance scares away smaller prey.  If you happen to attack one of these birds, they may shed quite a bit of hair feathers when harmed.",30,-48);
      setEDesc("mushroom bird","blue",null,"The large mushroom on its head helps protects its head from attacks.  The mushroom also contains the birds brain as well as all of its organs.  So even though the mushroom protects it, it can also be detrimental to the birds life if harmed.  Sometimes, they will eat mushroom ball enemies for food.",40,-88);
      setEDesc("omega fluff","blue",null,"Named after the large amounts of fur on its body, the omega fluff is a vicious creature.  They reside in one of the most pleasant places on earth, but despite its fluffy coat it is a horribly mean beast.  Their mouth is so large that they can swallow a sasquatch it just one bite without even chewing it.",-4,-600);
      setFishDesc("sliver","Small, green, and very common.  Slivers are often found in large numbers and are the most commonly seen fish known to man.");
      setFishDesc("swerm","Swerm are newly born mushroom balls and mushroom bouncers.  Before they turn into full size enemies, they are born as very small swerm.  Although they have eyes they cannot see.  They navigate through the water using sonar with their two small antennas.");
      setFishDesc("puffer","Bloated and full of air, the puffer is much like the purple goo enemy.  Humans are often cruel to these fish using them as toys to throw around.  Anyone found doing this is fined for cruelty to fish.");
      setFishDesc("shroomer","A shroomer is a swerm after 1 month of growth.  Their antennas fall off around 3 weeks and they develop a large mushroom shell helping to protect them from prey.");
      setFishDesc("mufungi","Not an evolution of the swerm or shroomer, the mufungi is said to have a brain the size of a crumb.  Some consider them plants, some consider them living fish.");
      setFishDesc("furry feen","Its fur is said to be the softest material known in existence.  Along with their fur, they are also the friendliest fish.  Most furry feens are friendly and soft enough for you to pet.");
      setFishDesc("hairloom","Unlike the furry feen, their fur is very rough and scruffy.  Hairlooms are also not friendly, and like most other fish you cannot pet them.  They are young lion fish with their eyes unopened yet.");
      setFishDesc("hertle","Brother to the hairloom, hertle look very similar to the hairloom yet the texture of their fur is quite different.  The actual size of the hertle\'s body is only 20% of their entire appearance, making them mostly hair.");
      setFishDesc("plant fungus","Fungus from plants, this organism moves as if it is alive.  With no visible eyes, mouth, or gills, one can\'t help but wonder if it is a fish of a plant.");
      setFishDesc("spud","Spud are small, quick, and large in numbers especially in beach areas.  They can be caught and eaten, but due to their small size they do not provide much in terms of food.");
      setFishDesc("flipper","Much like the spud, these fish are most commonly found near beaches.  Flippers are slightly less common than the spud but are overall a very basic fish.");
      setFishDesc("coconut fish","A mystery to modern science, the coconut fish are not offspring of other fish.  Instead they are birthed from coconuts.  To this day no human has ever seen a coconut fish being born.");
      setFishDesc("mud fish","Fat and slow, mud fish are spuds covered in soil and plant erosion.  After being covered in this for several weeks, the soil and plant begin to infuse themselves onto the fish\'s body.");
      setFishDesc("glopper","Gloppers are mud fish after 2 month of growth.  Due to the thick mud on their skin, their growth is greatly hindered and takes roughly three times the amount of time as a fish without mud on its skin.");
      setFishDesc("plant bacteria","This gross and harmfull piece of plant is a living organism covered in bacteria and other sickly debris.  It simply moves around the water aimlessly absorbing polluted chemicals in the water.");
      setFishDesc("metal guppy","The metal guppy is a futuristic fish composed of all metal materials.  Even its organs are solid metal.  The metal guppy weighs roughly 15 pounds despite its small size.");
      setFishDesc("iron minnow","Composed of iron ore from Robo City, the iron minnow is a fairly common fish amongst its parts.  Half way through its life span its body begins to rust making it very unhealthy as it struggles to live.");
      setFishDesc("peep fish","The peep fish is the weakest of all metal fish.  Although its body is very solid, the metal is the weakest of all metals.  Peep fish somtimes use the propellers on their back to move them through the water.");
      setFishDesc("dark tadpole","The dark tadpole is the angriest fish ever caught.  Because of their small size they try to compensate by becoming extemely hostile.  If you\'re not careful, they can easily chew off a finger or toe.");
      setFishDesc("evil pupe","Although not quite as angry as the dark tadpole, evil pupes are still very hostile fish.  They can break their horn off inside any predator who tries to harm them.");
      setFishDesc("dark toad","The least hostile of the Wasteland fish, the dark toad is plump and harmless.  Nevertheless, they should be handled with care because of the small horn on top of their head.");
      setFishDesc("mushroom coy","The mushroom coy is the swerm in its final form before it turns into a mushroom ball.  They are large and are very rarely seen because they often die out before growing to this level.");
      setFishDesc("shroom serpent","The shroom serpent is the most feared fish amongst humans.  Even though it is not very deadly, its snake like body strikes fear in those who come across it.");
      setFishDesc("lion fish","The lion fish is the final growth level of a hairloom.  They are large, rare, and a prize winner for most fisherman.  They are a true work of beauty in mother nature.");
      setFishDesc("stagnant scum","A large chunk of bacteria, stagnant scum can leave incredibly painful electric shocks on humans if they land on you.  The shock is enough to kill a human under the age of 5 causing their heart to stop.");
      setFishDesc("omate","Omate are the final growth stage of a mud fish.  Their bodies are very hard packed with dirt allowing them to be punctured several inches deep before hitting the fishes actual body.");
      setFishDesc("greenspot","Greenspot are rare fish that can only be found in certain bodies of water.  They are large fish but are very basic.  The curve in their horns makes then easy to pick up out of the water.");
      setFishDesc("sharktooth","Large metal fish, sharktooth can cause damage to other creatues.  They cannot bite or pierce enemies but because of their 100+ pound weight they can ram into enemies leaving large painful bruises.");
      setFishDesc("glowshine","Having very tiny eyes and horrible vision they use the small light on top of their head to help them see.  Inside their body are 2 small batteries that react to chemicals in the water giving them an infinite charge, powering the light on their head.");
      setFishDesc("subordinate","One of the largest fish ever recorded, subordinates are fully robotic.  Unlike all other fish they are not living and are run purely by computer programs and machinery.  Conspiracies say that Mad Ricky, leader of the Black Hooded Hatchet cult sometimes folds himself up and hides inside of subordinates.");
      setFishDesc("dark reaper","Dark reapers are very rare and evil fish.  They can be found only in the Wasteland areas.  They grow so large because of the chemicals spilled from the barrels next to the water.");
      setFishDesc("clipper","Clippers are a very common household fish that most people put in their fishing tanks.  They are harmless small little fish found in very large numbers.");
      setFishDesc("pootnick","Slimey little fish, pootnicks are tiny fish that can be found in several regions of water across the world.  They have a slow reaction time and can be easily caught.");
      setFishDesc("root fish","Much like bacteria the rooth fish is composed of earth materials and roots.  Root fish can grow in all shapes and sizes because of their strange root design.");
      setFishDesc("pumpkin shell fish","Pumpkin shell fish are the earliest form of the Pumpkin Creeper enemy before they develop into pumphin.  Their hard pumpkin shell makes them well protected from enemies.");
      setFishDesc("pumphin","They use their seaweed ligaments to help them swim through the water instead of having fins.  Pumphin are said to have emotions similar to humans and should be treated without harm.");
      setFishDesc("snow fish","The snowfish is a fish created primary from snow.  Oddly if a snowfish is in temperatures above freezing, it will melt down to nothing without any sign of internal organs or brain.");
      setFishDesc("ice fish","The ice fish is a cold sharp fish.  Humans should note not to catch an ice fish with their hand or they run the risk of being cut by the sharp ice covering its body.");
      setFishDesc("lava reef fish","The mid size lava fish, these fish are derived from lava coral.  They have no feeling in their body and cannot sense pain.  However this is not a good thing, as it makes them largely unable to sense danger.");
      setFishDesc("lava spud","The smallest of the lava fish, the lava spud are small and exist in large numbers.  Although their bodies are well equipped for the high lava temperatures, they are still very weak and sometimes the weaker of them can die from heat exhaustion.");
      setFishDesc("flame coy","A very hot fish, the flame coy are hard to hold and handle due to the hot flames encompassed around their body.  Their flames can be used to ignite weapons and armor.");
      setFishDesc("beholder guppy","Although it is raised in a very tough and harsh environment, the beholder guppy is not as rough as it would seem.  For living its life in the wastelands it is a charming, gentle, purple fish.  It will only use its horn on it\'s head when presented with danger.");
      setFishDesc("krimper","Unlike the beholder guppy, the krimper is a very fiesty fish.  If it is in the same body of water as a beholder guppy, it is highly unlikely that the beholder guppy will live past the age of 2 weeks before being devoured by the krimper.");
      setPetMode("fept","Full extreme power attack mode","attack","The pet deals 150% damage allowing him to hit things much out of its league.  The attack rate is much slower than full on attack mode.");
      setPetMode("fpt","Full power attack mode","attack","The pet deals 125% damage allowing him to hit things that are out of his league.  However, the attack rate is slower than full on attack mode.");
      setPetMode("fa","Full attack mode","attack","The pet deals 100% damage at a faster rate than full power attack mode but slower rate than quick attack mode.");
      setPetMode("qa","Quick attack mode","attack","The pet deals 75% damage at a faster rate than full attack mode.  Deals the highest overall DPS but in low quantities.");
      setPetMode("fl","Full loot mode","loot","The pet does not attack at all and picks up every item it encounters.");
      setPetMode("m","Mount mode","mount","Allows you to ride your pet.  Your range, magic, artillery, and power increases by 40% of the pets power.");
      setPetMode("hlha","Half loot half attack","attack","Your pet attacks half as often as full attack mode and picks up 50% of the items he encounters.");
      setPetMode("ipd","Increase player dex mode","follow","Your pet becomes a good luck charm and increases your dexterity and critical hit by 15%.  This bonus does NOT increase movement speed for your character.");
      setPetMode("il","Increase luck mode","follow","Increases your chance of getting items drops.  Increases your luck by 4.");
      setPetMode("hfhea","Half loot half extreme attack mode","attack","Your pet attacks deal 150% damage, half as often as full on extreme power attack mode and picks up 50% item drops he encounters.");
      setPetMode("qptqa","25% pick up 75% attack","attack","Your pet attacks 75% as much as he would in full attack mode and picks up 25% of the items he comes across.");
      setPetMode("hcptqa","Half coin pickup and 75% attack mode","attack","Your pet picks up 50% of the coins he encounters and attacks 75% as often as full attack mode.");
      setPetMode("fd","Full on Defensive Mode","follow","Increases your pets defense by 150%.  You pet does not attack or loot in this mode.  Your pets change to defense will not appear in his stats in the pet menu while in this mode.");
      setPetMode("hdha","Half defensive mode half attack mode","attack","Increases your pets defense by 125% and attacks half as often as full attack mode.  Your pets change to defense will not appear in his stats in the pet menu while in this mode.");
      setPetMode("b","Booster mode","follow","Increases your pets defense by 115%, increases your critical hit chance by 115%, and attacks half as much as full attack mode.  Move speed remains the same.");
      setPetMode("n","Nothing","follow","Your pet will not attack, be defensive, loot, etc.  He will simply follow you around.");
      setNewSkill("jump height",10,2);
      setNewSkill("critical hit",20,3);
      setNewSkill("loot steal",45,1);
      setNewSkill("training",int.MAX_VALUE,16);
      setNewSkill("self rage",35,1);
      setNewSkill("guild rage",35,1);
      setNewSkill("mp restore",200,2);
      setNewSkill("avoidability",25,2);
      setNewSkill("speed dash",15,4);
      setNewSkill("accel down",40,1);
      setNewSkill("block",30,1);
      setNewSkill("arrow barrage",6,5);
      setNewSkill("arrow knockback",20,1);
      setNewSkill("expert archer",int.MAX_VALUE,3);
      setNewSkill("triple shot",10,2);
      setNewSkill("arrow rain",6,4);
      setNewSkill("piercing arrow",8,2);
      setNewSkill("down crush",30,1);
      setNewSkill("power attack",225,1);
      setNewSkill("expert warrior",int.MAX_VALUE,3);
      setNewSkill("air slash",40,1);
      setNewSkill("shield mastery",35,1);
      setNewSkill("multi attack",5,3);
      setNewSkill("melee knockback",16,1);
      setNewSkill("spin attack",25,1);
      setNewSkill("magic shots",3,20);
      setNewSkill("expert wizard",int.MAX_VALUE,3);
      setNewSkill("circular attack",6,3);
      setNewSkill("magic distance",20,1);
      setNewSkill("thunder attack",6,5);
      setNewSkill("self heal",150,1);
      setNewSkill("guild heal",150,1);
      setNewSkill("grenade attack",7,5);
      setNewSkill("upward shoot",2,7);
      setNewSkill("expert cowboy",int.MAX_VALUE,3);
      setNewSkill("bullet distance",30,1);
      setNewSkill("shotgun attack",5,15);
      setNewSkill("bullet knockback",6,2);
      setNewSkill("jump grenade",20,1);
      setNewEnv("thorns",25);
      setNewEnv("pendulum",180);
      setNewEnv("purple pit",190);
      setNewEnv("mushroom spike",40);
      setNewEnv("swamp spike",60);
      setNewEnv("beholder cannon",600,SoundLibrary.beholderCannon_sound);
      
      public function Stats()
      {
         super();
      }
      
      public static function setNewWeapon(param1:String, param2:int, param3:int, param4:int, param5:int, param6:Boolean, param7:Boolean, param8:Boolean, param9:uint, param10:uint, param11:uint, param12:uint, param13:int, param14:Vector.<String>, param15:Vector.<int>, param16:uint) : void
      {
         wStats[param1] = new ItemStat(param1,param13,param4,param5,0,0,0,0,false,param2,param3,param6,param7,param8,param9,param10,param11,param12);
         wStats[param1].craftItems_array = param14;
         wStats[param1].craftCosts_array = param15;
         wStats[param1].frame = param16;
         itemList.push(param1);
      }
      
      public static function setNewHelmet(param1:String, param2:uint, param3:int, param4:int, param5:int, param6:Boolean, param7:int, param8:int, param9:int, param10:int, param11:Vector.<String>, param12:Vector.<int>) : void
      {
         hStats[param1] = new ItemStat(param1,param3,param4,param5,param7,param8,param9,param10,param6);
         hStats[param1].craftItems_array = param11;
         hStats[param1].craftCosts_array = param12;
         hStats[param1].frame = param2;
         itemList.push(param1);
      }
      
      public static function setNewShirt(param1:String, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:Vector.<String>, param10:Vector.<int>, param11:uint) : void
      {
         sStats[param1] = new ItemStat(param1,param2,param4,param3,param5,param6,param7,param8);
         sStats[param1].craftItems_array = param9;
         sStats[param1].craftCosts_array = param10;
         sStats[param1].frame = param11;
         itemList.push(param1);
      }
      
      public static function setNewPants(param1:String, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:Vector.<String>, param10:Vector.<int>, param11:uint) : void
      {
         pStats[param1] = new ItemStat(param1,param2,param4,param3,param5,param6,param7,param8);
         pStats[param1].craftItems_array = param9;
         pStats[param1].craftCosts_array = param10;
         pStats[param1].frame = param11;
         itemList.push(param1);
      }
      
      public static function setNewShoes(param1:String, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int) : *
      {
         shoesStats[param1] = new ItemStat(param1,param2,param4,param3,param5,param6,param7,param8);
         shoesStats[param1].frame = param9;
         itemList.push(param1);
      }
      
      public static function setNewItem(param1:String, param2:int, param3:String, param4:Array, param5:Vector.<String>, param6:Vector.<int>) : void
      {
         itemStats[param1] = new ItemStat(param1,0,param2,0,0,0,0,0);
         itemStats[param1].treeType = param3;
         itemStats[param1].craftItems_array = param5;
         itemStats[param1].craftCosts_array = param6;
         if(param4 != null)
         {
            itemStats[param1].treeArea_array = Vector.<uint>(param4);
         }
         itemList.push(param1);
      }
      
      public static function setNewPetHelmet(param1:String, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int) : void
      {
         petHelmetStats[param1] = new ItemStat(param1,param2,param3,param4,0,0,0,0,false,0,0,false,false,false,0,0,0,0,param6,param5,param7);
         petHelmetStats[param1].frame = param8;
         itemList.push(param1);
      }
      
      public static function setNewAccessory(param1:String, param2:int, param3:int, param4:int, param5:int, param6:uint) : void
      {
         accStats[param1] = new ItemStat(param1,param2,param3,param4,0,0,param5,0);
         ItemStat(accStats[param1]).frame = param6;
         itemList.push(param1);
      }
      
      public static function setNewMission(param1:String, param2:int, param3:String, param4:Boolean, param5:Boolean) : void
      {
         missionStats[param1] = {};
         missionStats[param1].fname = param1;
         missionStats[param1].worth = param2;
         missionStats[param1].desc = param3;
         missionStats[param1].started = param4;
         missionStats[param1].completed = param5;
         missionList.push(param1);
      }
      
      public static function setNewLevel(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:String = "", param10:int = 3, param11:String = "blue", param12:int = 0) : void
      {
         levelStats[param1] = {};
         levelStats[param1].portal1Lead = param2;
         levelStats[param1].portal2Lead = param3;
         levelStats[param1].portal3Lead = param4;
         levelStats[param1].portal4Lead = param5;
         levelStats[param1].portal5Lead = param6;
         levelStats[param1].portal6Lead = param7;
         levelStats[param1].portal7Lead = param8;
         levelStats[param1].fname = param9;
         levelStats[param1].closestHeal = param10;
         levelStats[param1].waterTint = param11;
         levelStats[param1].waterTintInt = param12;
      }
      
      public static function setNewEnemy(param1:String, param2:int, param3:int, param4:Number, param5:int, param6:int, param7:int) : void
      {
         eStats[param1] = {};
         eStats[param1].fname = param1;
         eStats[param1].health = param2;
         eStats[param1].defense = param3;
         eStats[param1].moveSpeed = param4;
         eStats[param1].jumpPower = param7;
         eStats[param1].worth = param5;
         eStats[param1].power = param6;
         eStats[param1].desc = eDescs[param1].desc;
         eStats[param1].applyGravity = !(param1 == "Carnelia" || param1 == "Kreetus" || param1 == "bionic bird" || param1 == "titanium vulture" || param1 == "flockling" || param1 == "chirplet" || param1 == "kraw" || param1 == "mushroom bird");
         ++totalEnemyTypes;
      }
      
      public static function setEDesc(param1:String, param2:String, param3:Sound, param4:String, param5:Number, param6:Number) : void
      {
         eDescs[param1] = {};
         eDescs[param1].desc = param4;
         eDescs[param1].sound = param3;
         eDescs[param1].fireX = param5;
         eDescs[param1].fireY = param6;
         eDescs[param1].colorString = param2;
         enemyList.push(param1);
      }
      
      public static function setFishDesc(param1:String, param2:String) : void
      {
         fishDescs[param1] = {};
         fishDescs[param1].desc = param2;
      }
      
      public static function setNewSkill(param1:String, param2:int, param3:int) : void
      {
         skillStats[param1] = {};
         skillStats[param1].skillName = param1;
         skillStats[param1].maxLvl = param2;
         skillStats[param1].required = param3;
      }
      
      public static function setNewEnv(param1:String, param2:int, param3:Sound = null) : void
      {
         envStats[param1] = {};
         envStats[param1].fname = param1;
         envStats[param1].power = param2;
         envStats[param1].sound = param3;
      }
      
      public static function setPetStats(param1:String, param2:int, param3:int, param4:int, param5:int, param6:int, param7:String, param8:String, param9:String) : void
      {
         param7 += ",n";
         petStats[param1] = {};
         petStats[param1].fname = param1;
         petStats[param1].cost = param2;
         petStats[param1].health = param3;
         petStats[param1].power = param4;
         petStats[param1].dex = param5;
         petStats[param1].defense = param6;
         petStats[param1].modes = param7.split(",");
         petStats[param1].desc = param8;
         petStats[param1].sColor = param9;
      }
      
      public static function setFishStats(param1:String, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int) : void
      {
         fishStats[param1] = {};
         fishStats[param1].fname = param1;
         fishStats[param1].time = param2;
         fishStats[param1].heal = int(1000 - param2 / 20 * 30);
         fishStats[param1].rare = param3;
         fishStats[param1].cost = Math.ceil((150 - param3) * (500 - param2) / 35);
         fishStats[param1].desc = fishDescs[param1].desc;
         fishStats[param1].power = param4;
         fishStats[param1].range = param5;
         fishStats[param1].artillery = param6;
         fishStats[param1].magic = param7;
         ++totalFishTypes;
      }
      
      public static function setPetMode(param1:String, param2:String, param3:String, param4:String) : void
      {
         petModes[param1] = new Object();
         petModes[param1].abrv = param1;
         petModes[param1].dname = param2;
         petModes[param1].moveMode = param3;
         petModes[param1].desc = param4;
         petModesList.push(param1);
      }
      
      public static function setCastleBlockStat(param1:String, param2:int, param3:Vector.<String>, param4:Vector.<int>) : void
      {
         castleBlockStat = new CastleBlockStat(param1,param2,param3,param4);
         castleBlockStats.push(castleBlockStat);
      }
      
      public static function getItemType(param1:String) : String
      {
         var _item:String = param1;
         var n_searchItemArray:Function = function(param1:*):Boolean
         {
            var _loc2_:int = int(itemList.length);
            var _loc3_:int = 0;
            while(_loc3_ < _loc2_)
            {
               if(param1[_item] != undefined)
               {
                  return true;
               }
               _loc3_++;
            }
            return false;
         };
         if(n_searchItemArray(wStats))
         {
            return "weapon";
         }
         if(n_searchItemArray(hStats))
         {
            return "helmet";
         }
         if(n_searchItemArray(sStats))
         {
            return "shirt";
         }
         if(n_searchItemArray(pStats))
         {
            return "pants";
         }
         if(n_searchItemArray(shoesStats))
         {
            return "shoes";
         }
         if(n_searchItemArray(itemStats))
         {
            return "item";
         }
         if(n_searchItemArray(petHelmetStats))
         {
            return "pet helmet";
         }
         if(n_searchItemArray(fishStats))
         {
            return "fish";
         }
         if(n_searchItemArray(accStats))
         {
            return "accessory";
         }
         return "not found";
      }
      
      public static function getItemArray(param1:String) : Array
      {
         switch(param1)
         {
            case "weapon":
               return wStats;
            case "helmet":
               return hStats;
            case "shirt":
               return sStats;
            case "pants":
               return pStats;
            case "shoes":
               return shoesStats;
            case "item":
               return itemStats;
            case "pet helmet":
               return petHelmetStats;
            case "fish":
               return fishStats;
            case "accessory":
               return accStats;
            default:
               return null;
         }
      }
      
      public static function returnModeAbrv(param1:String) : String
      {
         var _loc2_:String = null;
         for each(_loc2_ in petModesList)
         {
            if(petModes[_loc2_].dname == param1)
            {
               return _loc2_;
            }
         }
         return "n";
      }
      
      public static function getCastleBlockStatIndex(param1:String) : int
      {
         var _loc2_:int = int(castleBlockStats.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(castleBlockStats[_loc3_].type == param1)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      public static function get allItemsAndEnemiesLoaded() : Boolean
      {
         return helmetsLoaded && shirtsLoaded && legsLoaded && shoesLoaded && itemsLoaded && petHelmetsLoaded && weaponsLoaded && accessoriesLoaded && totalEnemyTypes > 0 && fishStatsLoaded && basePetStatsLoaded && itemDescsLoaded;
      }
   }
}

