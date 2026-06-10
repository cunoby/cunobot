-- ==========================================
-- CUSTOM PREMIUM UI LIBRARY (LOADER) 289
-- ==========================================
local Speed_Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/cunoby/BangBoy/refs/heads/main/D.lua"))()

Speed_Library.SetNotification = function(self, args)
    if type(args) == "table" then
        local judul = args.Title or "Info"
        local isi = args.Content or args.Description or ""
    end
end

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser       = game:GetService("VirtualUser")
local LocalPlayer       = Players.LocalPlayer
local PlayerGui         = LocalPlayer.PlayerGui
local PetsService       = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("PetsService")
local ActivePetsService = require(ReplicatedStorage.Modules.PetServices.ActivePetsService)
local PetUtilities      = require(ReplicatedStorage.Modules.PetServices.PetUtilities)
local PetMutationRegistry = require(ReplicatedStorage.Data.PetRegistry.PetMutationRegistry)

-- ==========================================
-- STATE & VARIABEL MESIN
-- ==========================================
local FavPet = {}
local NonFav = {}
local PetTeamElephant = {}
local PetTeamLeveling = {}
local PetTeamAge100 = {}
local PetBahan = {}
local ElephantMinAge = 50
local ElephantResetAge = 1
local LevelingMinAge = 1
local LevelingMaxAge = 50
local Age100MinAge   = 55
local Age100MaxAge   = 100
local BahanBatchSize = 2

-- ==========================================
-- STATE & VARIABEL MESIN (PABRIK 2: PUSH 50)
-- ==========================================
local PetTeamPush50 = {}
local PetBahanPush50 = {}
local Push50BatchSize = 2
local Push50TargetAge = 50
local AutoPush50On = false

local AutoElephantOn = false
local WaktuTerakhirGerak = 0
local FaseFarming = "TANAM"  
local BahanDiKebun = {} 
local GajahMentokNotif = false
local CycleCount = 0
local WaktuStartBot = tick()
local WaktuStartCycle = tick()
local WebhookURL = ""
local AntiAFKOn = true
local IsRefreshingUI = false 
local IsBooting = true 

-- ==========================================
-- STATE VARIABEL SIKLUS EGG
-- ==========================================
local PilihanEgg = {}
local JumlahTanamEgg = 1
local AutoPlaceOn = false

local PilihanPetBronto = {}
local BrontoKgTarget = 4.0
local AutoHatchOn = false

local PilihanSellPet = {}
local SellKgTarget = 4.0
local SellDelay = 1.0
local AutoSellOn = false

local TeamReduce = {}
local TeamHatch = {}
local TeamSell = {}
local TeamBronto = {}
local AutoSwitchOn = false

local SiklusHatch = "PLACE_EGG" 
local EggMaxNotif = false 

-- Data Dropdown (Nanti bisa diubah sesuai nama asli di game)
local ListEggGame = {
    "Anti Bee Egg", "Bee Egg", "Bird Egg", "Black Spotty Egg", "Bug Egg", 
    "Carnival Egg", "Christmas Egg", "Common Egg", "Common Summer Egg", 
    "Corrupted Zen Egg", "Dinosaur Egg", "Divine Egg", "Easter Egg", 
    "Enchanted Egg", "Epic Egg", "Exotic Bug Egg", "Fake Egg", "Fall Egg", 
    "Festive Premium Christmas Egg", "Festive Premium Winter Egg", 
    "GIANT Premium Fall Egg", "Gem Egg", "Ghostly Premium Spooky Egg", 
    "Gilded Choc Golden Egg", "Gilded Choc Premium Golden Egg", 
    "Gilded Choc Premium Springtide Egg", "Gilded Choc Springtide Egg", 
    "Golden Egg", "Gourmet Egg", "Hive Egg", "Jungle Egg", "Legendary Egg", 
    "Lich Crystal", "Mythical Egg", "New Year's Egg", "Night Egg", "Oasis Egg", 
    "Paradise Egg", "Premium Anti Bee Egg", "Premium Bird Egg", 
    "Premium Carnival Egg", "Premium Christmas Egg", "Premium Fall Egg", 
    "Premium Golden Egg", "Premium Hive Egg", "Premium New Year's Egg", 
    "Premium Night Egg", "Premium Oasis Egg", "Premium Primal Egg", 
    "Premium Prototype Bee Egg", "Premium Safari Egg", "Premium Spooky Egg", 
    "Premium Springtide Egg", "Premium Winter Egg", "Primal Egg", 
    "Prototype Bee Egg", "Rainbow Premium Bird Egg", "Rainbow Premium Carnival Egg", 
    "Rainbow Premium Hive Egg", "Rainbow Premium New Year's Egg", 
    "Rainbow Premium Primal Egg", "Rainbow Premium Safari Egg", "Rare Egg", 
    "Rare Summer Egg", "Safari Egg", "Spooky Egg", "Springtide Egg", "Sprout Egg", 
    "Uncommon Egg", "Winter Egg", "Zen Egg"
}

local ListPetGame = {
    "Dog", "Golden Lab", "Bunny", "Black Bunny", "Pink Bunny", "Rainbow Pink Bunny", 
    "Cat", "Deer", "Chicken", "Orange Tabby", "Spotted Deer", "Rooster", "Monkey", 
    "Pig", "Silver Monkey", "Turtle", "Cow", "Sea Otter", "Polar Bear", "Caterpillar", 
    "Snail", "Giant Ant", "Praying Mantis", "Dragonfly", "Panda", "Pink Panda", 
    "Hedgehog", "Kiwi", "Mole", "Frog", "Echo Frog", "Raccoon", "Night Owl", 
    "Brown Owl", "Rainbow Brown Owl", "Owl", "Grey Mouse", "Squirrel", "Brown Mouse", 
    "Red Giant Ant", "Red Fox", "Red Rose Fox", "Chicken Zombie", "Blood Hedgehog", 
    "Blood Kiwi", "Blood Owl", "Moon Cat", "Bee", "Honey Bee", "Petal Bee", 
    "Bear Bee", "Queen Bee", "Wasp", "Tarantula Hawk", "Moth", "Butterfly", 
    "Disco Bee", "Cooked Owl", "Pack Bee", "Starfish", "Crab", "Seagull", "Cuckoo", 
    "Rainbow Cuckoo", "Toucan", "Flamingo", "Sea Turtle", "Seal", "Orangutan", 
    "Peacock", "Capybara", "Scarlet Macaw", "Ostrich", "Black Bird", "Rainbow Black Bird", 
    "Mimic Octopus", "Meerkat", "Sand Snake", "Axolotl", "Hyacinth Macaw", "Fennec Fox", 
    "Hamster", "Bald Eagle", "Raptor", "Stegosaurus", "Triceratops", "Pterodactyl", 
    "Brontosaurus", "Radioactive Stegosaurus", "T-Rex", "Parasaurolophus", "Iguanodon", 
    "Pachycephalosaurus", "Dilophosaurus", "Ankylosaurus", "Spinosaurus", 
    "Rainbow Parasaurolophus", "Rainbow Iguanodon", "Rainbow Pachycephalosaurus", 
    "Rainbow Dilophosaurus", "Rainbow Ankylosaurus", "Rainbow Spinosaurus", "Shiba Inu", 
    "Nihonzaru", "Tanuki", "Tanchozuru", "Kappa", "Kitsune", "Birb", "Gold Finch", 
    "Rainbow Gold Finch", "Rainbow Birb", "Koi", "Football", "Maneki-neko", "Kodama", 
    "Corrupted Kodama", "Raiju", "Corrupted Kitsune", "Rainbow Maneki-neko", 
    "Rainbow Kodama", "Rainbow Corrupted Kitsune", "Bagel Bunny", "Pancake Mole", 
    "Sushi Bear", "Spaghetti Sloth", "French Fry Ferret", "Mochi Mouse", "Junkbot", 
    "Bacon Pig", "Hotdog Daschund", "Lobster Thermidor", "Sunny-Side Chicken", 
    "Gorilla Chef", "Rainbow Bacon Pig", "Rainbow Hotdog Daschund", "Rainbow Lobster Thermidor", 
    "Dairy Cow", "Jackalope", "Seedling", "Golem", "Golden Goose", "Spriggan", 
    "Peach Wasp", "Apple Gazelle", "Lemon Lion", "Green Bean", "Elk", "Mandrake", 
    "Griffin", "Gnome", "Rainbow Elk", "Rainbow Mandrake", "Rainbow Griffin", 
    "Ladybug", "Pixie", "Imp", "Glimmering Sprite", "Cockatrice", "Cardinal", "Shroomie", 
    "Phoenix", "Wisp", "Drake", "Luminous Sprite", "Rainbow Cardinal", "Rainbow Shroomie", 
    "Rainbow Phoenix", "Robin", "Badger", "Grizzly Bear", "Barn Owl", "Swan", 
    "GIANT Robin", "GIANT Badger", "GIANT Grizzly Bear", "GIANT Barn Owl", "GIANT Swan", 
    "Chipmunk", "Red Squirrel", "Marmot", "Sugar Glider", "Space Squirrel", "Salmon", 
    "Woodpecker", "Mallard", "Red Panda", "Tree Frog", "Hummingbird", "Iguana", 
    "Chimpanzee", "Tiger", "Blue Jay", "Silver Dragonfly", "Firefly", "Mizuchi", 
    "Rainbow Blue Jay", "GIANT Silver Dragonfly", "GIANT Firefly", "Rainbow Mizuchi", 
    "Chubby Chipmunk", "Farmer Chipmunk", "Idol Chipmunk", "Chinchilla", 
    "Rainbow Farmer Chipmunk", "Rainbow Idol Chipmunk", "Rainbow Chinchilla", "Hyrax", 
    "Fortune Squirrel", "Bat", "Bone Dog", "Spider", "Black Cat", "Headless Horseman", 
    "Ghostly Bat", "Ghostly Bone Dog", "Ghostly Spider", "Ghostly Black Cat", 
    "Ghostly Headless Horseman", "Pumpkin Rat", "Ghost Bear", "Wolf", "Reaper", "Crow", 
    "Goat", "Goblin", "Dark Spriggan", "Hex Serpent", "Ghostly Dark Spriggan", "Scarab", 
    "Tomb Marmot", "Mummy", "Ghostly Scarab", "Ghostly Tomb Marmot", "Ghostly Mummy", 
    "Lich", "Woody", "Specter", "Armadillo", "Stag Beetle", "Mantis Shrimp", "Hydra", 
    "Oxpecker", "Zebra", "Giraffe", "Rhino", "Elephant", "GIANT Armadillo", 
    "Rainbow Stag Beetle", "GIANT Mantis Shrimp", "Rainbow Hydra", "Rainbow Oxpecker", 
    "Rainbow Zebra", "Rainbow Giraffe", "Rainbow Rhino", "Rainbow Elephant", "Gecko", 
    "Hyena", "Cape Buffalo", "Hippo", "Crocodile", "Lion", "Topaz Snail", "Amethyst Beetle", 
    "Emerald Snake", "Sapphire Macaw", "Diamond Panther", "Ruby Squid", "Termite", 
    "Geode Turtle", "Trapdoor Spider", "Goblin Miner", "Smithing Dog", "Cheetah", 
    "Silver Piggy", "Golden Piggy", "Clam", "Magpie", "Bearded Dragon", "Rainbow Clam", 
    "Rainbow Magpie", "Rainbow Bearded Dragon", "Pack Mule", "Water Buffalo", "Chimera", 
    "Sheckling", "Messenger Pigeon", "Camel", "Snowman Soldier", "Snowman Builder", 
    "Arctic Fox", "Frost Dragon", "GIANT Snowman Soldier", "GIANT Snowman Builder", 
    "Rainbow Arctic Fox", "Rainbow Frost Dragon", "Gift Rat", "Penguin", "Snow Bunny", 
    "French Hen", "Christmas Gorilla", "Mistletoad", "Krampus", "Rainbow Snow Bunny", 
    "Rainbow French Hen", "Rainbow Christmas Gorilla", "Rainbow Mistletoad", 
    "Rainbow Krampus", "Turtle Dove", "Reindeer", "Nutcracker", "Yeti", "Ice Golem", 
    "Festive Turtle Dove", "Festive Reindeer", "Festive Nutcracker", "Festive Yeti", 
    "Festive Ice Golem", "Pine Beetle", "Cocoa Cat", "Eggnog Chick", "Red-Nosed Reindeer", 
    "Partridge", "Santa Bear", "Moose", "Frost Squirrel", "Wendigo", "Festive Partridge", 
    "Festive Santa Bear", "Festive Moose", "Festive Frost Squirrel", "Festive Wendigo", 
    "Summer Kiwi", "Christmas Spirit", "New Year's Bird", "Firework Sprite", 
    "Celebration Puppy", "New Year's Chimp", "Star Wolf", "New Year's Dragon", 
    "Rainbow New Year's Bird", "Rainbow Firework Sprite", "Rainbow Celebration Puppy", 
    "Rainbow New Year's Chimp", "Rainbow Star Wolf", "Rainbow New Year's Dragon", 
    "Unicycle Monkey", "Performer Seal", "Bear on Bike", "Show Pony", "Carnival Elephant", 
    "Rainbow Unicycle Monkey", "Rainbow Performer Seal", "Rainbow Bear on Bike", 
    "Rainbow Show Pony", "Rainbow Carnival Elephant", "Angora Goat", "Tsuchinoko", 
    "Wind-Up Rat", "Flame Bee", "Champion Beetle", "German Shepherd", "Calico", 
    "Goblin Gardener", "Galah Cockatoo", "Albino Peacock", "Lioness", "White Tiger", 
    "Diamond Dragonfly", "Giant Scorpion", "Blue Whale", "Wind Wyvern", "Firemite", 
    "Ash Raven", "Hazehound", "Cerberus", "GIANT Firemite", "GIANT Ash Raven", 
    "Rainbow Hazehound", "Rainbow Cerberus", "Chocolate Bunny", "Easter Egg Chick", 
    "Marshmallow Lamb", "Easter Bunny", "Gilded Choc Chocolate Bunny", 
    "Gilded Choc Easter Egg Chick", "Gilded Choc Marshmallow Lamb"
}

-- ==========================================
-- STATE
-- ==========================================

local TargetHarvestItem = {}
local AutoCollectOn = false
local TargetSubmitItem = {}
local AutoSubmitOn = false

local ListBuahEvent = {
    "Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Buttercup", "Big Buttercup", 
    "Bigger Buttercup", "Biggest Buttercup", "Beast Buttercup", "Shadow Buttercup", 
    "Big Shadow Buttercup", "Bigger Shadow Buttercup", "Biggest Shadow Buttercup", 
    "Beast Shadow Buttercup", "Tomato", "Corn", "Daffodil", "Cauliflower", "Watermelon", 
    "Rafflesia", "Green Apple", "Avocado", "Banana", "Pineapple", "Kiwi", "Bell Pepper", 
    "Prickly Pear", "Loquat", "Feijoa", "Pitcher Plant", "Pumpkin", "Apple", "Bamboo", 
    "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cacao", 
    "Beanstalk", "Ember Lily", "Sugar Apple", "Burning Bud", "Giant Pinecone", 
    "Elder Strawberry", "Romanesco", "Crimson Thorn", "Great Pumpkin", "Trinity Fruit", 
    "Four Leaf Clover", "Zebrazinkle", "Alien Apple", "Octobloom", "Peppermint Vine", 
    "Reindeer Root", "Spirit Sparkle", "Super", "Halloween Super", "Broccoli", "Potato", 
    "Brussels Sprout", "Cocomango", "Wild Carrot", "Pear", "Cantaloupe", "Parasol Flower", 
    "Rosy Delight", "Elephant Ears", "Delphinium", "Lily of the Valley", "Traveler's Fruit", 
    "Peace Lily", "Aloe Vera", "Guanabana", "Crocus", "Succulent", "Violet Corn", "Bendboo", 
    "Cocovine", "Dragon Pepper", "Raspberry", "Peach", "Papaya", "Passionfruit", 
    "Soul Fruit", "Cursed Fruit", "Cranberry", "Durian", "Eggplant", "Lotus", 
    "Venus Fly Trap", "Nightshade", "Glowshroom", "Mint", "Moonflower", "Starfruit", 
    "Moonglow", "Moon Blossom", "Chocolate Carrot", "Red Lollipop", "Candy Sunflower", 
    "Easter Egg", "Candy Blossom", "Candy Blossom 2026", "Crimson Vine", "Moon Melon", 
    "Blood Banana", "Celestiberry", "Moon Mango", "Rose", "Foxglove", "Lilac", "Pink Lily", 
    "Purple Dahlia", "Legacy Sunflower", "Lavender", "Nectarshade", "Nectarine", 
    "Hive Fruit", "Manuka Flower", "Dandelion", "Lumira", "Honeysuckle", "Bee Balm", 
    "Nectar Thorn", "Suncoil", "Liberty Lily", "Firework Flower", "Stonebite", 
    "Paradise Petal", "Horned Dinoshroom", "Boneboo", "Firefly Fern", "Fossilight", 
    "Bone Blossom", "Horsetail", "Lingonberry", "Amber Spine", "Grand Volcania", 
    "Zenflare", "Sakura Bush", "Soft Sunshine", "Spiked Mango", "Monoblooma", "Serenity", 
    "Taro Flower", "Zen Rocks", "Hinomai", "Maple Apple", "Enkaku", "Dezen", 
    "Lucky Bamboo", "Tranquil Bloom", "Fruitball", "Onion", "Jalapeno", "Crown Melon", 
    "Sugarglaze", "Tall Asparagus", "Grand Tomato", "Artichoke", "Taco Fern", 
    "Twisted Tangle", "Veinpetal", "Rhubarb", "Badlands Pepper", "Pricklefruit", 
    "King Cabbage", "Spring Onion", "Butternut Squash", "Bitter Melon", "Golden Egg", 
    "Flare Daisy", "Duskpuff", "Mangosteen", "Poseidon Plant", "Gleamroot", 
    "Princess Thorn", "Mandrake", "Canary Melon", "Amberheart", "Crown of Thorns", 
    "Calla Lily", "Cyclamen", "Glowpod", "Flare Melon", "Willowberry", "Sunbulb", 
    "Lightshoot", "Glowthorn", "Briar Rose", "Pink Rose", "Spirit Flower", "Wispwing", 
    "Emerald Bud", "Pyracantha", "Aetherfruit", "Radish", "Blue Raspberry", 
    "Horned Melon", "Ackee", "Urchin Plant", "Pixie Faern", "Untold Bell", "Turnip", 
    "Parsley", "Meyer Lemon", "Carnival Pumpkin", "Kniphofia", "Golden Peach", 
    "Maple Resin", "Mangrove", "Autumn Shroom", "Fall Berry", "Speargrass", "Torchflare", 
    "Auburn Pine", "Firewell", "Sundew", "Black Bat Flower", "Mandrone Berry", 
    "Corpse Flower", "Inferno Quince", "Multitrap", "Naval Wort", "Evo Beetroot I", 
    "Evo Beetroot II", "Evo Beetroot III", "Evo Beetroot IV", "Evo Blueberry I", 
    "Evo Blueberry II", "Evo Blueberry III", "Evo Blueberry IV", "Evo Pumpkin I", 
    "Evo Pumpkin II", "Evo Pumpkin III", "Evo Pumpkin IV", "Evo Mushroom I", 
    "Evo Mushroom II", "Evo Mushroom III", "Evo Mushroom IV", "Evo Apple I", 
    "Evo Apple II", "Evo Apple III", "Evo Apple IV", "Hazelnut", "Persimmon", "Acorn", 
    "Acorn Squash", "Ferntail", "Pecan", "Fissure Berry", "Bloodred Mushroom", 
    "Jack O Lantern", "Ghoul Root", "Chicken Feed", "Seer Vine", "Poison Apple", 
    "Banesberry", "Candy Cornflower", "Blood Orange", "Zombie Fruit", "Wisp Flower", 
    "Mummy's Hand", "Weeping Branch", "Ghost Bush", "Devilroot", "Wereplant", 
    "Severed Spine", "Glass Kiwi", "Spider Vine", "Monster Flower", "Horned Redrose", 
    "Banana Orchid", "Viburnum Berry", "Buddhas Hand", "Ghost Pepper", "Mahogany", 
    "Thornspire", "Wyrmvine", "Orange Delight", "Protea", "Baobab", "Daisy", 
    "Bamboo Tree", "Amberfruit Shrub", "Castor Bean", "Java Banana", "Peacock Tail", 
    "Lumin Bloom", "Luna Stem", "Zucchini", "Olive", "Hollow Bamboo", "Yarrow", 
    "Gem Fruit", "Coilvine", "Asteris", "Pomegranate", "Wild Pineapple", "Coinfruit", 
    "Sherrybloom", "Pinkside Dandelion", "Cookie Stack", "Poinsettia", "Antlerbloom", 
    "Holly Berry", "Gift Berry", "Gingerbread Blossom", "Heart Blossom", "Frosty Bite", 
    "Cryo Rose", "Bush Flake", "Rosemary", "Cryoshard", "Frostwing", "Pollen Cone", 
    "Peppermint Pop", "Gumdrop", "Christmas Cracker", "Candy Cane", "Snowman Sprout", 
    "Christmas Tree", "Sparkle Slice", "Colorpop Crop", "Firework Fern", "Kernel Curl", 
    "Bonanza Bloom", "Shimmersprout", "Crimson Cranberry", "Confetti Tula", "Hexberry", 
    "Peanut", "Yellow Core", "Crunchnut", "Candlite", "Frost Pepper", "Plumwillow", 
    "Blooming Cactus", "Madcrown Vine", "Magma Pepper", "Frost Fern", "Noble Flower", 
    "Lemon", "Cherry Blossom", "Ice Cream Bean", "Lime", "White Mulberry", 
    "Merica Mushroom", "Dragon Sapling", "Sinisterdrip", "Purple Cabbage", 
    "Log Pumpkin", "Aura Flora", "Mutant Carrot", "King Palm", "Spectralis", 
    "Spirit Lantern", "Aurora Vine", "Coolcool Beanbeanstalk", "Snaparino Beanarini", 
    "Fennel", "Melon Flower", "Frostspike", "Gooseberry", "Black Magic Ears", 
    "Helenium", "Jelpod", "Wild Berry", "Filbert Nut", "Turkish Hazel", "Cherry", 
    "Witch Cap", "Skull Flower", "Mind Root", "Vampbloom", "Sugarcane", "Queen Fruit", 
    "Crassula Umbrella", "Faestar", "Madras Thorn", "Aqua Lily", "Sunflower", 
    "Observee", "Akebi", "Monster Plum", "Gift Root", "Mammoth Mistletoe", 
    "Crown Pumpkin", "Cyberflare", "Rambutan", "Strange Man's Wheat", "Walnut", 
    "Leifo Fruit", "Festive Bamboo", "Iciclesco", "Icestalite", "Grand Cucumber", 
    "Wild Frond", "Mauve Fruit", "Archling", "Cold Snap Suckle", "Frostline Flake", 
    "Wintercreep", "Milk Table", "Ornament Vine", "Frost Bush", "Tinsel", "Wreath Span", 
    "New Years Tinsel", "Taffy Tree", "Jungle Queen Bulb", "Star Palm", "Heart Gem", 
    "Witches Hair", "Luminova", "Jungle Kiwano", "Birds Nest", "Candy Carrot", 
    "Chocolate Berry", "Gumball", "Liquorice", "Sugar Melon", "Chocolate Coconut", 
    "Gummy Cactus", "Sour Lemon", "Eggfruit", "Easter Sprout", "Easter Candy Carrot", 
    "Easter Chocolate Berry", "Easter Gumball", "Easter Liquorice", "Easter Sugar Melon", 
    "Easter Chocolate Coconut", "Easter Gummy Cactus", "Easter Egg Melon", 
    "Easter Sour Lemon", "Easter Eggfruit", "Easter Easter Sprout", "Drowned Flower", 
    "Saskia", "Mini Pumpkin", "Amazon Feather Fern", "Jungle Cherry", "Boreal Orange", 
    "Purple Treeshroom", "Eggsnapper", "DJ Delight", "Blue Candypop", "Egg Melon", 
    "Elder Candy Blossom", "Bunny Berry", "Bonnet Bloom", "Egg Shroom", 
    "Waddling Willow", "Marshmallow Root", "Jelly Bean Sprout", "Basket Bouquet", 
    "Sugar Snapdragon", "Honey Daisy", "Honey Dew", "Ambercomb", "Coneflower", 
    "Birds of Paradise", "Honey Honey Daisy", "Honey Honey Dew", "Honey Ambercomb", 
    "Honey Coneflower", "Honey Birds of Paradise", "Stingpetal", "Woodbine", 
    "Honey Dipper", "Bee Bell", "Hive Petal", "Bumble Bulb", "Honey Carrot", 
    "Honey Strawberry", "Honey Blueberry", "Honey Buttercup", "Honey Tomato", 
    "Honey Corn", "Honey Daffodil", "Honey Watermelon", "Honey Pumpkin", "Honey Apple", 
    "Honey Bamboo", "Honey Coconut", "Honey Cactus", "Honey Dragon Fruit", "Honey Mango", 
    "Honey Grape", "Honey Mushroom", "Honey Pepper", "Honey Cacao", "Honey Sunflower", 
    "Honey Beanstalk", "Honey Ember Lily", "Honey Sugar Apple", "Honey Burning Bud", 
    "Honey Giant Pinecone", "Honey Elder Strawberry", "Honey Romanesco", 
    "Honey Crimson Thorn", "Honey Zebrazinkle", "Honey Octobloom", "Honey Alien Apple", 
    "Honey Pollenvine", "Honey Stingpetal", "Honey Woodbine", "Honey Honey Dipper", 
    "Honey Bee Bell", "Honey Hive Petal", "Honey Bumble Bulb", "Pollenvine", 
    "Obby Oddvine", "Pollen Puffball", "Grape Droplet", "Pohutukawa", "Honey Hollow", 
    "Honey Honey Hollow", "Starbloom Daisy", "Cocoa Pod", "Astrobush", "Lumi Shroom", 
    "Sweetheart Flower", "Bendbark", "Pinkfruit Palm", "Stinger Reed", "Spiketail", 
    "Royal Rose", "Hexpetal", "Sun Bloom", "Suncrest Orchid", "Swivel Stinger", 
    "Haskap Berry", "Bee Lantern", "Honey Orange Tulip", "Amber Flower", "Hollyhock", 
    "Glacial Petal", "Snakeskin Tulip", "Royal Jelly Cup", "Queen of the Forest", 
    "Monarch Jellpod", "Firepit Flower", "Hearth Reed", "Firefly Spiral", "Drizzle Cane", 
    "Red Hornet", "Purple Sprout", "Mallow Melt", "Flamebud", "Campfire Clover"
}

-- ==========================================
-- FITUR AUTO-SAVE (DATABASE LOKAL)
-- ==========================================
local HttpService = game:GetService("HttpService")
local SaveFileName = "FSMBot_Gery_Save.json"
local SavedData = { 
    Gajah = {}, Leveling = {}, Age100 = {}, Bahan = {}, PickPlace = {}, PushTeam = {}, PushBahan = {}, 
    AutoStartFSM = false, AutoStartPush = false, AutoStartPickPlace = false, AutoStartRejoin = false,
    -- [BARU] Laci khusus untuk menyimpan data Tab Auto Hatch
    Hatch = { 
        PilihanEgg = {}, JmlTanam = 1, AutoPlace = false,
        PilBronto = {}, KgBronto = 4.0, AutoHatch = false,
        PilSell = {}, KgSell = 4.0, DelaySell = 1.0, AutoSell = false,
        TeamReduce = {}, TeamHatch = {}, TeamSell = {}, TeamBronto = {}, AutoSwitch = false
    },
    Input = { ElMin = 50, LevMin = 0, LevMax = 50, AgeMin = 55, AgeMax = 100, BahanBatch = 2, PushTarget = 50, PushBatch = 2, DelayPick = 0.5, DelayPlace = 0.5, RejoinTime = 60, Webhook = "" },
    Garden = {
        TargetHarvest = {}, AutoCollectKalem = false, AutoCollect = false,
        AutoSellInterval = 60, AutoSellTimer = false, AutoSellFull = false
    },
    Campfire = {
        TargetSubmit = {}, AutoSubmit = false,
        Slot1 = "", Slot2 = "", Slot3 = "", AutoCraft = false
    }
}

pcall(function()
    if isfile and readfile and isfile(SaveFileName) then
        local raw = readfile(SaveFileName)
        local data = HttpService:JSONDecode(raw)
        if data then
            SavedData.Gajah = data.Gajah or {}
            SavedData.Leveling = data.Leveling or {}
            SavedData.Age100 = data.Age100 or {}
            SavedData.Bahan = data.Bahan or {}
            SavedData.PickPlace = data.PickPlace or {}
            SavedData.PushTeam = data.PushTeam or {}
            SavedData.PushBahan = data.PushBahan or {}
            SavedData.AutoStartFSM = data.AutoStartFSM or false 
            SavedData.AutoStartPush = data.AutoStartPush or false 
            SavedData.AutoStartPickPlace = data.AutoStartPickPlace or false 
            SavedData.AutoStartRejoin = data.AutoStartRejoin or false 
            
            if data.Hatch then
                for k, v in pairs(data.Hatch) do SavedData.Hatch[k] = v end
            end
            if data.Input then
                for k, v in pairs(data.Input) do SavedData.Input[k] = v end
            end
            if data.Garden then for k, v in pairs(data.Garden) do SavedData.Garden[k] = v end end
            if data.Campfire then for k, v in pairs(data.Campfire) do SavedData.Campfire[k] = v end end
        end
    end
end)

local function SaveSettings()
    pcall(function()
        if writefile then writefile(SaveFileName, HttpService:JSONEncode(SavedData)) end
    end)
end

local ElephantMinAge = SavedData.Input.ElMin
local LevelingMinAge = SavedData.Input.LevMin
local LevelingMaxAge = SavedData.Input.LevMax
local Age100MinAge   = SavedData.Input.AgeMin
local Age100MaxAge   = SavedData.Input.AgeMax
local BahanBatchSize = SavedData.Input.BahanBatch
local Push50TargetAge = SavedData.Input.PushTarget
local Push50BatchSize = SavedData.Input.PushBatch
local DelayToPick = SavedData.Input.DelayPick
local DelayToPlace = SavedData.Input.DelayPlace
local AutoRejoinMenit = SavedData.Input.RejoinTime
local AutoRejoinOn = false
WebhookURL = SavedData.Input.Webhook or ""
-- Sinkronisasi Data Hatch dari Save-an
PilihanEgg = SavedData.Hatch.PilihanEgg
JumlahTanamEgg = SavedData.Hatch.JmlTanam
AutoPlaceOn = SavedData.Hatch.AutoPlace
PilihanPetBronto = SavedData.Hatch.PilBronto
BrontoKgTarget = SavedData.Hatch.KgBronto
AutoHatchOn = SavedData.Hatch.AutoHatch
PilihanSellPet = SavedData.Hatch.PilSell
SellKgTarget = SavedData.Hatch.KgSell
SellDelay = SavedData.Hatch.DelaySell
AutoSellOn = SavedData.Hatch.AutoSell
AutoSwitchOn = SavedData.Hatch.AutoSwitch
if AutoSwitchOn then SiklusHatch = "PLACE_EGG" end
-- [SINKRONISASI BARU] Data Garden & Campfire
local TargetHarvestItem = SavedData.Garden.TargetHarvest
local AutoCollectKalemOn = SavedData.Garden.AutoCollectKalem
local AutoCollectOn = SavedData.Garden.AutoCollect

local TargetSubmitItem = SavedData.Campfire.TargetSubmit
local AutoSubmitOn = SavedData.Campfire.AutoSubmit
local SlotSettings = { [1] = SavedData.Campfire.Slot1, [2] = SavedData.Campfire.Slot2, [3] = SavedData.Campfire.Slot3 }
local AutoCraftManagerOn = SavedData.Campfire.AutoCraft

-- ==========================================
-- VARIABEL & SISTEM SADAP SERVER (TARGET TIME ENGINE)
-- ==========================================
local PetKebun = {}
local PickPlacePets = {}
local AutoPickPlaceOn = false
local TargetSelesaiPet = {} 
local SedangDiProses = {}

local PetCooldownsUpdated = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("PetCooldownsUpdated")
PetCooldownsUpdated.OnClientEvent:Connect(function(uuid, cdData)
    if not AutoPickPlaceOn then return end
    if cdData then
        local slotUtama = cdData[1] or cdData["1"]
        if slotUtama and type(slotUtama) == "table" and slotUtama.Time then
            TargetSelesaiPet[uuid] = os.clock() + slotUtama.Time
        end
    end
end)

-- ==========================================
-- 1. FUNGSI KEBUN & PET
-- ==========================================
local function GetMyFarmCenter()
    local farmFolder = workspace:FindFirstChild("Farm") or workspace:FindFirstChild("Farms")
    if not farmFolder then return nil end
    for _, kebun in ipairs(farmFolder:GetChildren()) do
        local ownerVal = kebun:FindFirstChild("Important") and kebun.Important:FindFirstChild("Data") and kebun.Important.Data:FindFirstChild("Owner")
        if ownerVal and tostring(ownerVal.Value) == LocalPlayer.Name then
            local center = kebun:FindFirstChild("Spawn_Point") or kebun:FindFirstChild("Center_Point")
            if center then return center:IsA("BasePart") and center.CFrame or CFrame.new(center.Value) end
        end
    end
    return nil
end

local function PlacePet(petId)
    WaktuTerakhirGerak = tick()
    local koordinatKebun = GetMyFarmCenter()
    if not koordinatKebun then return false end
    local sukses, _ = pcall(function() PetsService:FireServer("EquipPet", petId, koordinatKebun) end)
    return sukses
end

local function PickupPet(petId)
    WaktuTerakhirGerak = tick()
    local sukses, _ = pcall(function() PetsService:FireServer("UnequipPet", petId) end)
    return sukses
end

local function TarikSemuaPetDiAwal()
    pcall(function()
        local scrollingFrame = PlayerGui.ActivePetUI.Frame.Main.PetDisplay.ScrollingFrame
        if scrollingFrame then
            for _, item in ipairs(scrollingFrame:GetChildren()) do
                if string.find(item.Name, "-") then PickupPet(item.Name) task.wait(0.1) end
            end
        end
    end)
end

local function AmbilUmurDiKebun(petId)
    local umur = 0
    pcall(function()
        local data = ActivePetsService:GetPetData(LocalPlayer.Name, petId)
        if data and data.PetData then umur = data.PetData.Level end
    end)
    return umur
end

local function RegisterPet(uuid, isFav)
    local data = ActivePetsService:GetPetData(LocalPlayer.Name, uuid)
    if not data then return end
    
    local petType = data.PetType or "Unknown"
    local nama = petType
    
    pcall(function()
        local mutType = data.PetData and data.PetData.MutationType
        if mutType then
            local mutString = PetMutationRegistry.EnumToPetMutation and PetMutationRegistry.EnumToPetMutation[mutType]
            if mutString and mutString ~= "Normal" then nama = mutString .. " " .. petType end
        end
    end)
    
    local umur = data.PetData and data.PetData.Level or 1
    
    -- [PERBAIKAN]: Blokir pet bahan yang sudah Age 100 agar tidak masuk Dropdown
    if not isFav and umur >= Age100MaxAge then return end
    
    local uuidBersih = string.gsub(uuid, "[^%w]", "") 
    local uuidPendek = string.sub(uuidBersih, 1, 4)
    local teksDropdown = nama .. " [#" .. string.upper(uuidPendek) .. "]"
    local dataPet = { Id = uuid, Nama = nama, Umur = umur, Teks = teksDropdown }
    
    local targetTable = isFav and FavPet or NonFav
    for _, p in ipairs(targetTable) do if p.Id == uuid then return end end
    table.insert(targetTable, dataPet)
end

local function ScanTas()
    table.clear(FavPet) table.clear(NonFav)
    local tas = LocalPlayer:FindFirstChild("Backpack")
    if tas then
        for _, item in ipairs(tas:GetChildren()) do
            if item:GetAttribute("ItemType") == "Pet" then
                local uuid = item:GetAttribute("PET_UUID")
                if uuid and uuid ~= "" then
                    local isFav = item:GetAttribute("d") == true
                    RegisterPet(uuid, isFav)
                end
            end
        end
    end
    
    pcall(function()
        local physFolder = workspace:FindFirstChild("PetsPhysical")
        if physFolder then
            for _, item in ipairs(physFolder:GetChildren()) do
                local owner = item:GetAttribute("OWNER")
                local uuid = item:GetAttribute("UUID")
                if owner == LocalPlayer.Name and uuid then
                    local data = ActivePetsService:GetPetData(LocalPlayer.Name, uuid)
                    if data and data.PetData then
                        local isFav = data.PetData.IsFavorite == true
                        RegisterPet(uuid, isFav)
                    end
                end
            end
        end
    end)
end

local function ScanKebun()
    table.clear(PetKebun)
    local function IsDuplikat(uuid)
        for _, p in ipairs(PetKebun) do if p.Id == uuid then return true end end
        return false
    end

    pcall(function()
        local physFolder = workspace:FindFirstChild("PetsPhysical")
        if physFolder then
            for _, item in ipairs(physFolder:GetChildren()) do
                local owner = item:GetAttribute("OWNER")
                local uuid = item:GetAttribute("UUID")
                
                if owner == LocalPlayer.Name and uuid and not IsDuplikat(uuid) then
                    local data = ActivePetsService:GetPetData(LocalPlayer.Name, uuid)
                    if data and data.PetType then 
                        local petType = data.PetType
                        local namaPet = petType
                        
                        local mutType = data.PetData and data.PetData.MutationType
                        if mutType then
                            local mutString = PetMutationRegistry.EnumToPetMutation and PetMutationRegistry.EnumToPetMutation[mutType]
                            if mutString and mutString ~= "Normal" then namaPet = mutString .. " " .. petType end
                        end
                        
                        local uuidBersih = string.gsub(uuid, "[^%w]", "") 
                        local uuidPendek = string.sub(uuidBersih, 1, 4) 
                        local teksDropdown = namaPet .. " [#" .. string.upper(uuidPendek) .. "]"
                        table.insert(PetKebun, { Id = uuid, Nama = namaPet, Teks = teksDropdown })
                    end
                end
            end
        end
        
        if #PetKebun == 0 then
            local scrollingFrame = PlayerGui.ActivePetUI.Frame.Main.PetDisplay.ScrollingFrame
            if scrollingFrame then
                for _, item in ipairs(scrollingFrame:GetChildren()) do
                    if string.find(item.Name, "-") then
                        local uuid = item.Name
                        if not IsDuplikat(uuid) then
                            local data = ActivePetsService:GetPetData(LocalPlayer.Name, uuid)
                            if data and data.PetType then 
                                local petType = data.PetType
                                local namaPet = petType
                                
                                local mutType = data.PetData and data.PetData.MutationType
                                if mutType then
                                    local mutString = PetMutationRegistry.EnumToPetMutation and PetMutationRegistry.EnumToPetMutation[mutType]
                                    if mutString and mutString ~= "Normal" then namaPet = mutString .. " " .. petType end
                                end
                                
                                local uuidBersih = string.gsub(uuid, "[^%w]", "") 
                                local uuidPendek = string.sub(uuidBersih, 1, 4) 
                                local teksDropdown = namaPet .. " [#" .. string.upper(uuidPendek) .. "]"
                                table.insert(PetKebun, { Id = uuid, Nama = namaPet, Teks = teksDropdown })
                            end
                        end
                    end
                end
            end
        end
    end)
end

local function InfoBahan()
    local daftarNama = {}
    for _, id in ipairs(BahanDiKebun) do
        local namaPet = "Unknown"
        pcall(function()
            local data = ActivePetsService:GetPetData(LocalPlayer.Name, id)
            if data and data.PetType then 
                namaPet = data.PetType
                local mutType = data.PetData and data.PetData.MutationType
                if mutType then
                    local mutString = PetMutationRegistry.EnumToPetMutation and PetMutationRegistry.EnumToPetMutation[mutType]
                    if mutString and mutString ~= "Normal" then namaPet = mutString .. " " .. namaPet end
                end
            end
        end)
        table.insert(daftarNama, namaPet)
    end
    return #daftarNama == 0 and "Bahan" or table.concat(daftarNama, " & ")
end

local function GetDetailBahan()
    if #BahanDiKebun == 0 then return "> **[Bahan Kosong]**\n> **Name :** -\n> **Age :** 0\n> **Kg :** 0" end
    local teksDetail = ""
    for i, id in ipairs(BahanDiKebun) do
        local namaPet = "Unknown"
        local umurPet = 0
        local beratPet = 0
        
        pcall(function()
            local data = ActivePetsService:GetPetData(LocalPlayer.Name, id)
            if data and data.PetData then
                namaPet = data.PetType or "Unknown"
                local mutType = data.PetData and data.PetData.MutationType
                if mutType then
                    local mutString = PetMutationRegistry.EnumToPetMutation and PetMutationRegistry.EnumToPetMutation[mutType]
                    if mutString and mutString ~= "Normal" then namaPet = mutString .. " " .. namaPet end
                end
                umurPet = data.PetData.Level
                local baseWeight = data.PetData.BaseWeight
                beratPet = PetUtilities:CalculateWeight(baseWeight, umurPet, data.PetType)
            end
        end)
        
        local beratFormat = string.format("%.2f", beratPet)
        teksDetail = teksDetail .. "> **[Bahan " .. i .. "]**\n> **Name :** " .. namaPet .. "\n> **Age :** " .. umurPet .. "\n> **Kg :** " .. beratFormat
        if i < #BahanDiKebun then teksDetail = teksDetail .. "\n> \n" end
    end
    return teksDetail
end

local function GetSisaBahan()
    local sisa = 0
    for _, petBahan in ipairs(PetBahan) do
        local inKebun = false
        for _, id in ipairs(BahanDiKebun) do
            if id == petBahan.Id then
                inKebun = true
                if AmbilUmurDiKebun(id) < Age100MaxAge then sisa = sisa + 1 end
                break
            end
        end
        if not inKebun then
            for _, p in ipairs(NonFav) do
                if p.Id == petBahan.Id then
                    if p.Umur < Age100MaxAge then sisa = sisa + 1 end
                    break
                end
            end
        end
    end
    return sisa
end

-- ==========================================
-- FUNGSI BANTUAN (EQUIP & RAM SCANNER)
-- ==========================================

local function GetEggPlantPositions()
    local positions = {}
    local farmFolder = workspace:FindFirstChild("Farm") or workspace:FindFirstChild("Farms")
    if not farmFolder then return positions end
    
    for _, kebun in ipairs(farmFolder:GetChildren()) do
        local ownerVal = kebun:FindFirstChild("Important") and kebun.Important:FindFirstChild("Data") and kebun.Important.Data:FindFirstChild("Owner")
        if ownerVal and tostring(ownerVal.Value) == LocalPlayer.Name then
            local plantLocs = kebun.Important:FindFirstChild("Plant_Locations")
            if plantLocs then
                for _, loc in ipairs(plantLocs:GetChildren()) do
                    -- Mengambil semua part bernama Can_Plant (kiri dan kanan)
                    if string.find(loc.Name, "Can_Plant") and loc:IsA("BasePart") then
                        table.insert(positions, loc.Position)
                    end
                end
            end
        end
    end
    return positions
end


local function PegangItemDariTas(namaAtauUUID)
    local char = LocalPlayer.Character
    local tas = LocalPlayer:FindFirstChild("Backpack")
    if not char or not tas then return false end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return false end

    -- Cari item di tas (berdasarkan nama atau UUID)
    for _, item in ipairs(tas:GetChildren()) do
        if item:IsA("Tool") then
            local uuid = item:GetAttribute("PET_UUID") or item:GetAttribute("OBJECT_UUID")
            if item.Name == namaAtauUUID or uuid == namaAtauUUID then
                humanoid:EquipTool(item)
                return item
            end
        end
    end
    return false
end

local function SimpanSemuaItem()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid:UnequipTools()
    end
end

-- Fungsi Mengganti Tim (Un-equip semua, lalu Equip tim baru)
local function GantiTim(tabelTim)
    print("🔄 Ganti Tim ke: " .. (#tabelTim > 0 and "Tim Terpilih" or "Kosong"))
    pcall(function()
        -- 1. Tarik semua pet dari kebun
        local scrollingFrame = LocalPlayer.PlayerGui.ActivePetUI.Frame.Main.PetDisplay.ScrollingFrame
        if scrollingFrame then
            for _, item in ipairs(scrollingFrame:GetChildren()) do
                if string.find(item.Name, "-") then 
                    PetsService:FireServer("UnequipPet", item.Name) 
                end
            end
        end
        task.wait(0.5)
        
        -- 2. Turunkan tim baru
        local koordinatKebun = GetMyFarmCenter() -- Mengambil fungsi dari script utamamu
        if koordinatKebun then
            for _, pet in ipairs(tabelTim) do
                PetsService:FireServer("EquipPet", pet.Id, koordinatKebun)
                task.wait(0.2)
            end
        end
    end)
end 

-- ==========================================
-- 2. SISTEM WEBHOOK DISCORD
-- ==========================================
local function FormatWaktu(detik)
    local h = math.floor(detik / 3600)
    local m = math.floor((detik % 3600) / 60)
    local s = math.floor(detik % 60)
    return string.format("%02d:%02d:%02d", h, m, s)
end

local function GetPing()
    local ping = "N/A"
    pcall(function() ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) end)
    return ping .. " ms"
end

local function GetTeamNames(teamTable)
    local names = {}
    for _, pet in ipairs(teamTable) do table.insert(names, pet.Nama) end
    if #names == 0 then return "Kosong" end
    return table.concat(names, ", ")
end

local function KirimWebhook(teksFase, embedData)
    if WebhookURL == "" or string.find(WebhookURL, "MASUKKAN") then return end
    pcall(function()
        local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
        if req then
            req({
                Url = WebhookURL, Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = game:GetService("HttpService"):JSONEncode({ ["content"] = "", ["embeds"] = { embedData } })
            })
        end
    end)
end

local function LogPesan(teksFase)
    print(teksFase)
    local waktuFaseBerjalan = tick() - WaktuStartCycle 
    WaktuStartCycle = tick() 
    
    task.spawn(function()
        local dataEmbed = {
            ["title"] = teksFase,
            ["fields"] = {
                { ["name"] = "Information Pet", ["value"] = GetDetailBahan() .. "\n> ────────────────\n> **Cycle Count :** " .. CycleCount .. "\n> **Duration :** " .. FormatWaktu(tick() - WaktuStartBot) .. "\n> **Phase Time :** " .. FormatWaktu(waktuFaseBerjalan), ["inline"] = false },
                { ["name"] = "Game Info", ["value"] = "> **Game Ping :** " .. GetPing() .. "\n> **Total Pets :** " .. (#FavPet + #NonFav) .. "\n> **Sisa Bahan :** " .. GetSisaBahan() .. " Pet", ["inline"] = false },
                { ["name"] = "Teams Inventory", ["value"] = "> **Team Elephant :** " .. GetTeamNames(PetTeamElephant) .. "\n> **Team Leveling :** " .. GetTeamNames(PetTeamLeveling) .. "\n> **Team Age100 :** " .. GetTeamNames(PetTeamAge100), ["inline"] = false }
            },
            ["footer"] = { ["text"] = "FSM Bot by Gery • " .. os.date("%d/%m/%y, %H:%M") }
        }
        KirimWebhook(teksFase, dataEmbed)
    end)
end

-- ==========================================
-- 3. PEMBUATAN CUSTOM UI (SUSUNAN TAB BARU)
-- ==========================================
local Window = Speed_Library:CreateWindow({
    Title = "FSM Bot Auto-Farming",
    Description = "Ultimate Edition by Gery",
    TabWidth = 140,
    SizeUi = UDim2.fromOffset(580, 340)
})

local function AmbilDaftarNama(tabelPet)
    local daftar = {}
    for _, pet in ipairs(tabelPet) do table.insert(daftar, pet.Teks) end
    return #daftar > 0 and daftar or {"Kosong"}
end

local function UpdateMultiSelectState(tabelSumber, daftarPilihanUI, tabelStateTarget)
    if IsRefreshingUI then return end 
    table.clear(tabelStateTarget) 
    for _, namaDipilih in ipairs(daftarPilihanUI) do
        for _, pet in ipairs(tabelSumber) do
            if pet.Teks == namaDipilih then table.insert(tabelStateTarget, pet) end
        end
    end
end

-- [PERBAIKAN]: Tab Push 50 pindah ke posisi 2
local TabGarden = Window:CreateTab({Name = "Garden", Icon = "rbxassetid://7734010488"})
local TabEvent = Window:CreateTab({Name = "CampFire", Icon = "rbxassetid://7734010488"})
local TabLeveling = Window:CreateTab({Name = "Auto Leveling", Icon = "rbxassetid://7734010488"})
local TabPush50   = Window:CreateTab({Name = "Push Age 50",   Icon = "rbxassetid://7734010488"})
local TabAutoHatch = Window:CreateTab({Name = " Auto Hatch", Icon = "rbxassetid://7734010488"})
local TabMisc     = Window:CreateTab({Name = "MISC",          Icon = "rbxassetid://7734010488"})
local TabSetting  = Window:CreateTab({Name = "Settings",      Icon = "rbxassetid://7734010488"})

-- ==========================================
-- 1. BAGIAN AUTO PANEN (COLLECT)
-- ==========================================
local SecFarming = TabGarden:AddSection(" Auto Farming Crops", false)

SecFarming:AddDropdown({ 
    Title = "Pilih Tanaman Untuk Dipanen", 
    Content = "Bisa pilih lebih dari satu", 
    Multi = true, 
    Options = ListBuahEvent, 
    Default = SavedData.Garden.TargetHarvest, -- Terhubung dengan database
    Callback = function(Opt) 
        TargetHarvestItem = Opt 
        SavedData.Garden.TargetHarvest = Opt
        SaveSettings()
    end 
})

SecFarming:AddToggle({ 
    Title = "Mode Kalem (Anti-Lag)", 
    Content = "Centang untuk panen satu-satu. Matikan untuk panen INSTAN!",
    Default = SavedData.Garden.AutoCollectKalem, -- Terhubung dengan database
    Callback = function(Value) 
        AutoCollectKalemOn = Value 
        SavedData.Garden.AutoCollectKalem = Value
        SaveSettings()
    end 
})

SecFarming:AddToggle({ 
    Title = "MULAI AUTO Collect", 
    Content = "Otomatis memanen tanaman yang kamu centang.",
    Default = SavedData.Garden.AutoCollect, -- Terhubung dengan database
    Callback = function(Value) 
        AutoCollectOn = Value 
        SavedData.Garden.AutoCollect = Value
        SaveSettings()
    end 
})



-- ==========================================
-- 2. BAGIAN AUTO SUBMIT API UNGGUN
-- ==========================================
local SecSubmit = TabEvent:AddSection(" Campfire", false)

SecSubmit:AddDropdown({ 
    Title = "Pilih Buah Untuk Dibakar", 
    Content = "Pilih buah sampah/tumbal (Bisa lebih dari satu)", 
    Multi = true, 
    Options = ListBuahEvent, 
    Default = SavedData.Campfire.TargetSubmit, -- Terhubung dengan database
    Callback = function(Opt) 
        TargetSubmitItem = Opt 
        SavedData.Campfire.TargetSubmit = Opt
        SaveSettings()
    end 
})

SecSubmit:AddToggle({ 
    Title = "MULAI GHOST AUTO SUBMIT", 
    Content = "Membakar buah langsung dari dalam tas secara instan!",
    Default = SavedData.Campfire.AutoSubmit, -- Terhubung dengan database
    Callback = function(Value) 
        AutoSubmitOn = Value 
        SavedData.Campfire.AutoSubmit = Value
        SaveSettings()
    end 
})
-- ==========================================
-- 3. BAGIAN AUTO CRAFTING CAMPFIRE (V26 MODULAR RECIPE)
-- ==========================================
local SecCraft = TabEvent:AddSection("🛠️ Auto Crafting Manager", false)

local ListBarangCraft = {
    "Areaclaimer", "Avocado", "Banana", "Campfire Crate", "Campfire Egg", 
    "Cauliflower", "Common Summer Egg", "Energy Chew", "Feijoa", 
    "Firepit Flower", "Green Apple", "Hearth Reed", "Kiwi", "Paradise Egg", 
    "Pitcher Plant", "Prickly Pear", "Rare Summer Egg", "Super Watering Can"
}

-- Menyimpan Tier dan Index (Hanya untuk keperluan format kirim ke Server)
local ItemCraftData = {
    ["Firepit Flower"]     = {Tier = 1, Index = 1},
    ["Cauliflower"]        = {Tier = 1, Index = 2},
    ["Campfire Crate"]     = {Tier = 2, Index = 1},
    ["Common Summer Egg"]  = {Tier = 2, Index = 2},
    ["Green Apple"]        = {Tier = 2, Index = 3},
    ["Avocado"]            = {Tier = 2, Index = 4},
    ["Super Watering Can"] = {Tier = 3, Index = 1},
    ["Areaclaimer"]        = {Tier = 3, Index = 2},
    ["Banana"]             = {Tier = 3, Index = 3},
    ["Kiwi"]               = {Tier = 3, Index = 4},
    ["Hearth Reed"]        = {Tier = 4, Index = 1},
    ["Rare Summer Egg"]    = {Tier = 4, Index = 2},
    ["Prickly Pear"]       = {Tier = 4, Index = 3},
    ["Feijoa"]             = {Tier = 5, Index = 1},
    ["Paradise Egg"]       = {Tier = 5, Index = 2},
    ["Energy Chew"]        = {Tier = 5, Index = 3},
    ["Pitcher Plant"]      = {Tier = 5, Index = 4},
    ["Campfire Egg"]       = {Tier = 5, Index = 5}
}

-- 🚨 DATABASE RESEP MODULAR (Sangat gampang diedit kalau resep game berubah!)
local ResepGamedata = {
    ["Firepit Flower"]     = {{"Daffodil", 2, "Seed"}, {"Uncommon Egg", 1, "Egg"}, {"Advanced Sprinkler", 1, "Gear"}},
    ["Cauliflower"]        = {{"Common Egg", 1, "Egg"}, {"Corn", 2, "Seed"}, {"Cacao", 1, "Fruit"}},
    ["Campfire Crate"]     = {{"Uncommon Egg", 1, "Egg"}, {"Recall Wrench", 1, "Gear"}, {"Trowel", 1, "Gear"}},
    ["Common Summer Egg"]  = {{"Common Egg", 1, "Egg"}, {"Silver Ingot", 1, "Cosmetic"}, {"Pepper", 1, "Fruit"}},
    ["Green Apple"]        = {{"Sugar Apple", 1, "Fruit"}, {"Apple", 3, "Seed"}, {"Advanced Sprinkler", 1, "Gear"}},
    ["Avocado"]            = {{"Bamboo", 3, "Seed"}, {"Cactus", 1, "Fruit"}, {"Advanced Sprinkler", 2, "Gear"}},
    ["Super Watering Can"] = {{"Watering Can", 15, "Gear"}, {"Master Sprinkler", 1, "Gear"}},
    ["Areaclaimer"]        = {{"Harvest Tool", 1, "Gear"}, {"Reclaimer", 5, "Gear"}, {"Recall Wrench", 1, "Gear"}},
    ["Banana"]             = {{"Godly Sprinkler", 2, "Gear"}, {"Coconut", 1, "Fruit"}, {"Watermelon", 1, "Seed"}},
    ["Kiwi"]               = {{"Blueberry", 3, "Seed"}, {"Uncommon Egg", 1, "Egg"}, {"Mango", 1, "Fruit"}},
    ["Hearth Reed"]        = {{"Godly Sprinkler", 1, "Gear"}, {"Advanced Sprinkler", 1, "Gear"}, {"Coconut", 1, "Seed"}},
    ["Rare Summer Egg"]    = {{"Rare Egg", 3, "Egg"}, {"Gold Ingot", 1, "Cosmetic"}, {"Beanstalk", 1, "Seed"}}, 
    ["Prickly Pear"]       = {{"Dragon Fruit", 1, "Seed"}, {"Master Sprinkler", 1, "Gear"}, {"Giant Pinecone", 1, "Fruit"}},
    ["Feijoa"]             = {{"Mango", 1, "Seed"}, {"Rare Egg", 1, "Egg"}, {"Master Sprinkler", 3, "Gear"}, {"Elder Strawberry", 1, "Fruit"}},
    ["Paradise Egg"]       = {{"Mythical Egg", 2, "Egg"}, {"Master Sprinkler", 3, "Gear"}, {"Gold Ingot", 1, "Cosmetic"}}, 
    ["Energy Chew"]        = {{"Rare Egg", 1, "Egg"}, {"Beanstalk", 1, "Seed"}, {"Grape", 1, "Seed"}},
    ["Pitcher Plant"]      = {{"Pepper", 1, "Seed"}, {"Grandmaster Sprinkler", 1, "Gear"}, {"Burning Bud", 1, "Fruit"}, {"Magnifying Glass", 10, "Gear"}},
    ["Campfire Egg"]       = {{"Rare Egg", 1, "Egg"}, {"Mango", 1, "Seed"}} 
}

local SlotSettings = { [1] = "", [2] = "", [3] = "" }

for i = 1, 3 do
    local slotKey = "Slot" .. tostring(i)
    local savedSlot = SavedData.Campfire[slotKey]
    
    SecCraft:AddDropdown({ 
        Title = "Pilih Crafting Slot " .. i, 
        Options = ListBarangCraft, 
        -- Jika database ada isinya, panggil sebagai array agar UI library bisa membacanya
        Default = (savedSlot and savedSlot ~= "") and {savedSlot} or {}, 
        Callback = function(Opt) 
            local val = type(Opt) == "table" and Opt[1] or Opt 
            SlotSettings[i] = val 
            SavedData.Campfire[slotKey] = val
            SaveSettings()
        end 
    })
end

SecCraft:AddToggle({ 
    Title = "NYALAKAN AUTO CRAFT MANAGER", 
    Content = "V26: Modular Recipe (Bebas Edit Resep)",
    Default = SavedData.Campfire.AutoCraft, -- Terhubung dengan database
    Callback = function(Value) 
        AutoCraftManagerOn = Value 
        SavedData.Campfire.AutoCraft = Value
        SaveSettings()
    end 
})

-- ==========================================
-- KILL-SWITCH & SENSOR PEREDAM POPUP
-- ==========================================
_G.FSMCraftLoopID = (_G.FSMCraftLoopID or 0) + 1
local currentLoopID = _G.FSMCraftLoopID

if _G.FSMCraftSensorConnection then _G.FSMCraftSensorConnection:Disconnect() end
local FrameFolder = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Top_Notification"):WaitForChild("Frame")
_G.FSMCraftSensorConnection = FrameFolder.ChildAdded:Connect(function(node)
    if AutoCraftManagerOn then
        task.wait(0.05)
        local txt = string.lower(node:GetAttribute("OG") or "")
        if string.find(txt, "no available") or string.find(txt, "no empty") or string.find(txt, "not ready") or string.find(txt, "missing") or string.find(txt, "slot is empty") then
            node.Visible = false
            pcall(function() node:Destroy() end)
        end
    end
end)

-- ==========================================
-- MESIN UTAMA (Mata Dewa + Stack Reader)
-- ==========================================
local MissingSpamLock = {}
local SlotLock = { [1] = 0, [2] = 0, [3] = 0 }

task.spawn(function()
    while task.wait(0.5) do 
        if currentLoopID ~= _G.FSMCraftLoopID then break end 
        
        if AutoCraftManagerOn then
            local player = game.Players.LocalPlayer
            local WaktuSekarang = os.clock()
            
            local function CariBahan(namaBahan, tipeBahan, jumlahDibutuhkan)
                local searchName = string.lower(namaBahan or "")
                local uuids_terkumpul = {}
                local targetJumlah = jumlahDibutuhkan or 1
                local raw_uuids = {} 
                
                local function NameMatch(namaItem)
                    namaItem = string.lower(namaItem or "")
                    if searchName == "master sprinkler" and string.find(namaItem, "grandmaster") then return false end
                    if searchName == "rare egg" and string.find(namaItem, "summer") then return false end
                    if searchName == "mythical egg" and string.find(namaItem, "summer") then return false end
                    if searchName == "common egg" and string.find(namaItem, "summer") then return false end
                    
                    local bersihNama = string.gsub(namaItem, "[%s_]", "")
                    local bersihSearch = string.gsub(searchName, "[%s_]", "")
                    
                    if string.find(bersihNama, bersihSearch) then return true end
                    return false
                end

                local function InsertUUID(id, amount)
                    if not id or targetJumlah <= 0 then return end
                    
                    -- [FIX EXECUTOR BUG]: Memisahkan fungsi string agar tidak bertabrakan
                    local strId, _ = string.gsub(tostring(id), "[{}]", "")
                    local cleanId = string.lower(strId)
                    local amt = tonumber(amount) or 1
                    
                    if raw_uuids[cleanId] then
                        local old_amt = raw_uuids[cleanId]
                        if amt > old_amt then
                            targetJumlah = targetJumlah - (amt - old_amt)
                            raw_uuids[cleanId] = amt
                        end
                    else
                        raw_uuids[cleanId] = amt
                        table.insert(uuids_terkumpul, id)
                        targetJumlah = targetJumlah - amt
                    end
                end

                -- [FIX API DEVELOPER]: Proteksi pcall & cek type function untuk Cosmetic
                if tipeBahan == "Cosmetic" then
                    pcall(function()
                        local CosmeticService = require(game:GetService("ReplicatedStorage").Modules.CosmeticServices.CosmeticService)
                        if CosmeticService and type(CosmeticService.GetAllCosmetics) == "function" and type(CosmeticService.GetAllEquippedCosmetics) == "function" then
                            local allCosmetics = CosmeticService:GetAllCosmetics()
                            local allEquipped = CosmeticService:GetAllEquippedCosmetics()
                            for uuid, data in pairs(allCosmetics) do
                                if targetJumlah <= 0 then break end
                                if not allEquipped[uuid] and NameMatch(data.Name or "") then
                                    InsertUUID("Cosmetic:" .. tostring(uuid), 1)
                                end
                            end
                        end
                    end)
                    return (targetJumlah <= 0) and uuids_terkumpul or nil
                end

                -- [PRIORITAS UTAMA]: Cek Tas (Backpack) Fisik Dulu
                local wadahFisik = {}
                if player:FindFirstChild("Backpack") then for _, v in ipairs(player.Backpack:GetChildren()) do table.insert(wadahFisik, v) end end
                if player.Character then for _, v in ipairs(player.Character:GetChildren()) do table.insert(wadahFisik, v) end end
                
                for _, item in ipairs(wadahFisik) do
                    if targetJumlah <= 0 then break end
                    
                    local namaFisik = item.Name
                    pcall(function() namaFisik = item:GetAttribute("f") or item.Name end)
                    
                    local itemString = item:FindFirstChild("Item_String")
                    if itemString and itemString.Value then
                        namaFisik = itemString.Value
                    end
                    
                    if NameMatch(namaFisik) then
                        local isValid = false
                        local namaItemLower = string.lower(namaFisik)
                        local atributB = item:GetAttribute("b")
                        
                        if tipeBahan == "Seed" and string.find(namaItemLower, "seed") then isValid = true
                        elseif tipeBahan == "Fruit" and (atributB == "j" or not string.find(namaItemLower, "seed")) then isValid = true
                        elseif tipeBahan ~= "Seed" and tipeBahan ~= "Fruit" then isValid = true end
                        
                        if isValid then
                            local uid = item:GetAttribute("c") or item:GetAttribute("ITEM_UUID") or item:GetAttribute("OBJECT_UUID") or item:GetAttribute("UUID") or item:GetAttribute("PET_UUID")
                            local jumlahDiItem = tonumber(item:GetAttribute("e")) or tonumber(item:GetAttribute("Amount")) or tonumber(item:GetAttribute("Quantity")) or tonumber(item:GetAttribute("Uses")) or 1
                            InsertUUID(uid, jumlahDiItem)
                        end
                    end
                end

                -- [FIX API DEVELOPER]: Proteksi pcall & cek type function untuk DataService
                if targetJumlah > 0 then
                    pcall(function()
                        local DataService = require(game:GetService("ReplicatedStorage").Modules.DataService)
                        if DataService and type(DataService.GetData) == "function" then
                            local pData = DataService:GetData()
                            if pData and type(pData.InventoryData) == "table" then
                                for uuid, item in pairs(pData.InventoryData) do
                                    if targetJumlah <= 0 then break end
                                    
                                    local itemData = item.ItemData or {}
                                    local realName = itemData.ItemName or itemData.SeedName or itemData.FruitName or itemData.GearName or itemData.Name or itemData.Type or itemData.Seed or itemData.EggName or itemData.PetEggName or itemData.PetEggType or ""
                                    
                                    if NameMatch(realName) then
                                        local isValid = false
                                        local nameLower = string.lower(realName)
                                        if tipeBahan == "Seed" and string.find(nameLower, "seed") then isValid = true
                                        elseif tipeBahan == "Fruit" and not string.find(nameLower, "seed") then isValid = true
                                        elseif tipeBahan ~= "Seed" and tipeBahan ~= "Fruit" then isValid = true end

                                        if isValid then
                                            local amount = tonumber(itemData.Quantity) or tonumber(itemData.Uses) or tonumber(item.Quantity) or tonumber(item.Uses) or 1
                                            InsertUUID(uuid, amount)
                                        end
                                    end
                                end
                            end
                        end
                    end)
                end
                
                return (targetJumlah <= 0) and uuids_terkumpul or nil
            end

            for slot = 1, 3 do
                if WaktuSekarang >= SlotLock[slot] then
                    local isSlotReady = false
                    local isSlotEmpty = false
                    
                    pcall(function()
                        local slotUI = player.PlayerGui.SummerCrafting.Crafting.Main.Campfire.Crafting["Craft"..tostring(slot)]
                        local tierValue = slotUI:FindFirstChild("TierValue")
                        local timeLeft = slotUI:FindFirstChild("TimeLeft")
                        
                        if timeLeft and timeLeft.Visible and string.find(string.upper(timeLeft.Text), "CLAIM") then
                            isSlotReady = true
                        end
                        if tierValue and tierValue.Visible and string.find(string.upper(tierValue.Text), "EMPTY") then
                            isSlotEmpty = true
                        end
                    end)
                    
                    if isSlotReady then
                        pcall(function() game:GetService("ReplicatedStorage").GameEvents.SummerCraftingService.ClaimCraft:FireServer(slot) end)
                        SlotLock[slot] = os.clock() + 2 
                        
                    elseif isSlotEmpty then
                        local itemTarget = SlotSettings[slot]
                        if itemTarget and itemTarget ~= "" then
                            -- LOGIKA YANG SUDAH DIREVISI MENJADI NAMA (STRING)
                            local dataFormat = ItemCraftData[itemTarget]
                            local resepDibutuhkan = ResepGamedata[itemTarget] 
                            
                            if resepDibutuhkan and dataFormat then
                                local tabelUUIDBahan = {} 
                                local semuaBahanCukup = true
                                local bahanKurangLog = ""
                                
                                for _, syarat in ipairs(resepDibutuhkan) do
                                    local daftarUUIDBahan = CariBahan(syarat[1], syarat[3], syarat[2])
                                    if not daftarUUIDBahan then 
                                        semuaBahanCukup = false 
                                        bahanKurangLog = syarat[1] .. " (Butuh " .. syarat[2] .. ")"
                                        break
                                    else 
                                        table.insert(tabelUUIDBahan, daftarUUIDBahan) 
                                    end
                                end
                                
                                if semuaBahanCukup and #tabelUUIDBahan > 0 then
                                    MissingSpamLock[itemTarget] = false 
                                    local craftKeyFormat = tostring(dataFormat.Tier) .. ":" .. tostring(dataFormat.Index) .. ":" .. itemTarget
                                    pcall(function() game:GetService("ReplicatedStorage").GameEvents.SummerCraftingService.StartCraft:FireServer(craftKeyFormat, tabelUUIDBahan) end)
                                    SlotLock[slot] = os.clock() + 3 
                                    
                                elseif not semuaBahanCukup then
                                    if not MissingSpamLock[itemTarget] then
                                        MissingSpamLock[itemTarget] = true
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)





-- SECTION 1: GAJAH
local SecGajah = TabLeveling:AddSection("Team Gajah Settings", false)
SecGajah:AddButton({
    Title = "🔄 Refresh Data Tas", 
    Content = "Klik ini jika daftar dropdown Kosong",
    Callback = function()
        WaktuTerakhirGerak = 0 
        UpdateSemuaDropdown(true) 
        Speed_Library:SetNotification({Title = "Refresh Sukses", Description = "Berhasil", Content = "Daftar tas diperbarui!", Time = 2})
    end
})

local DropGajah = SecGajah:AddDropdown({
    Title = "Pilih Team Gajah", Content = "Pilih 1 atau lebih", Multi = true, Options = {"Kosong"}, Default = SavedData.Gajah,
    Callback = function(Options) 
        UpdateMultiSelectState(FavPet, Options, PetTeamElephant) 
        if not IsRefreshingUI then SavedData.Gajah = Options SaveSettings() end
    end
})
SecGajah:AddInput({ Title = "Min Age (Blessing)", Content = "Umur minimal gajah ditarik", Default = tostring(SavedData.Input.ElMin), Callback = function(Text) ElephantMinAge = tonumber(Text) or 50; SavedData.Input.ElMin = ElephantMinAge; SaveSettings() end })

-- SECTION 2: LEVELING
local SecLeveling = TabLeveling:AddSection("Team Leveling Settings", false)
local DropLeveling = SecLeveling:AddDropdown({
    Title = "Pilih Team Leveling", Content = "Pilih 1 atau lebih", Multi = true, Options = {"Kosong"}, Default = SavedData.Leveling,
    Callback = function(Options) 
        UpdateMultiSelectState(FavPet, Options, PetTeamLeveling) 
        if not IsRefreshingUI then SavedData.Leveling = Options SaveSettings() end
    end
})
SecLeveling:AddInput({ Title = "Minimum Age", Content = "Batas bawah", Default = tostring(SavedData.Input.LevMin), Callback = function(Text) LevelingMinAge = tonumber(Text) or 0; SavedData.Input.LevMin = LevelingMinAge; SaveSettings() end })
SecLeveling:AddInput({ Title = "Maximum Age", Content = "Batas atas", Default = tostring(SavedData.Input.LevMax), Callback = function(Text) LevelingMaxAge = tonumber(Text) or 50; SavedData.Input.LevMax = LevelingMaxAge; SaveSettings() end })

-- SECTION 3: AGE 100
local SecAge100 = TabLeveling:AddSection("Team Age 100 Settings", false)
local DropAge100 = SecAge100:AddDropdown({
    Title = "Pilih Team Age 100", Content = "Pilih 1 atau lebih", Multi = true, Options = {"Kosong"}, Default = SavedData.Age100,
    Callback = function(Options) 
        UpdateMultiSelectState(FavPet, Options, PetTeamAge100) 
        if not IsRefreshingUI then SavedData.Age100 = Options SaveSettings() end
    end
})
SecAge100:AddInput({ Title = "Minimum Age", Content = "Bypass Gajah", Default = tostring(SavedData.Input.AgeMin), Callback = function(Text) Age100MinAge = tonumber(Text) or 55; SavedData.Input.AgeMin = Age100MinAge; SaveSettings() end })
SecAge100:AddInput({ Title = "Maximum Age", Content = "Target panen", Default = tostring(SavedData.Input.AgeMax), Callback = function(Text) Age100MaxAge = tonumber(Text) or 100; SavedData.Input.AgeMax = Age100MaxAge; SaveSettings() end })

-- SECTION 4: BAHAN
local ToggleMesin
local SecBahan = TabLeveling:AddSection("Konfigurasi Bahan", false)
local DropBahan = SecBahan:AddDropdown({
    Title = "Pilih Pet Bahan", Content = "Pilih dari Non-Fav", Multi = true, Options = {"Kosong"}, Default = SavedData.Bahan,
    Callback = function(Options) 
        UpdateMultiSelectState(NonFav, Options, PetBahan) 
        if not IsRefreshingUI then SavedData.Bahan = Options SaveSettings() end
    end
})
SecBahan:AddInput({ Title = "Batch Size", Content = "Jumlah tanam per putaran", Default = tostring(SavedData.Input.BahanBatch), Callback = function(Text) BahanBatchSize = tonumber(Text) or 2; SavedData.Input.BahanBatch = BahanBatchSize; SaveSettings() end })
ToggleMesin = SecBahan:AddToggle({
    Title = "▶️ MULAI MESIN OTOMATIS", Content = "Pastikan semua setting benar", 
    Default = SavedData.AutoStartFSM, 
    Callback = function(Value)
        if IsBooting then return end 
        AutoElephantOn = Value
        SavedData.AutoStartFSM = Value
        SaveSettings()
        
        if AutoElephantOn then
            task.spawn(TarikSemuaPetDiAwal)
            task.wait(1)
            FaseFarming = "TANAM" WaktuStartCycle = tick()
            Speed_Library:SetNotification({Title = "Sistem Menyala", Description = "Mesin Berjalan", Content = "Otomasi FSM telah diaktifkan!", Time = 3})
        else
            Speed_Library:SetNotification({Title = "Sistem Mati", Description = "Mesin Dimatikan", Content = "Menarik semua pet dari kebun...", Time = 3})
            task.spawn(TarikSemuaPetDiAwal) 
        end
    end
})

-- PABRIK 2: TAB PUSH AGE 50
local SecPushSet = TabPush50:AddSection("Push 50 Settings", false)
local DropPushLeveling = SecPushSet:AddDropdown({
    Title = "Pilih Team Leveling", Content = "Pet untuk bantu naikin EXP", Multi = true, Options = {"Kosong"}, Default = SavedData.PushTeam,
    Callback = function(Options) 
        UpdateMultiSelectState(FavPet, Options, PetTeamPush50) 
        if not IsRefreshingUI then SavedData.PushTeam = Options SaveSettings() end
    end
})
local DropPushBahan = SecPushSet:AddDropdown({
    Title = "Pilih Pet Bahan", Content = "Pet yang akan dipanen", Multi = true, Options = {"Kosong"}, Default = SavedData.PushBahan,
    Callback = function(Options) 
        UpdateMultiSelectState(NonFav, Options, PetBahanPush50) 
        if not IsRefreshingUI then SavedData.PushBahan = Options SaveSettings() end
    end
})
SecPushSet:AddInput({ Title = "Target Age", Content = "Umur panen bahan", Default = tostring(SavedData.Input.PushTarget), Callback = function(Text) Push50TargetAge = tonumber(Text) or 50; SavedData.Input.PushTarget = Push50TargetAge; SaveSettings() end })
SecPushSet:AddInput({ Title = "Batch Size", Content = "Jumlah tanam per putaran", Default = tostring(SavedData.Input.PushBatch), Callback = function(Text) Push50BatchSize = tonumber(Text) or 2; SavedData.Input.PushBatch = Push50BatchSize; SaveSettings() end })

local ToggleMesinPush
ToggleMesinPush = SecPushSet:AddToggle({
    Title = "▶️ MULAI PABRIK PUSH 50", Content = "Leveling murni tanpa Gajah", 
    Default = SavedData.AutoStartPush, 
    Callback = function(Value)
        if IsBooting then return end 
        AutoPush50On = Value
        SavedData.AutoStartPush = Value
        SaveSettings()
        
        if AutoPush50On then
            if ToggleMesin then ToggleMesin:Set(false) end 
            FaseFarming = "TANAM_PUSH" WaktuStartCycle = tick()
            Speed_Library:SetNotification({Title = "Pabrik 2 Menyala", Description = "Push 50 Aktif", Content = "Mesin berjalan!", Time = 3})
        else
            if not AutoElephantOn then task.spawn(TarikSemuaPetDiAwal) end
        end
    end
})


-- ==========================================
-- MENU UI: AUTO HATCH & CYCLE (DENGAN AUTO-SAVE)
-- ==========================================
local SecPlace = TabAutoHatch:AddSection("Place Egg", false)
SecPlace:AddDropdown({ Title = "Pilih Egg untuk Ditanam", Multi = true, Options = ListEggGame, Default = SavedData.Hatch.PilihanEgg, Callback = function(Opt) PilihanEgg = Opt; SavedData.Hatch.PilihanEgg = Opt; SaveSettings() end })
SecPlace:AddInput({ Title = "Jumlah Egg Ditanam", Content = "Batas max telur di kebun", Default = tostring(SavedData.Hatch.JmlTanam), Callback = function(Txt) JumlahTanamEgg = tonumber(Txt) or 1; SavedData.Hatch.JmlTanam = JumlahTanamEgg; SaveSettings() end })
SecPlace:AddToggle({ Title = "▶️ AUTO PLACE EGG", Default = SavedData.Hatch.AutoPlace, Callback = function(Val) AutoPlaceOn = Val; SavedData.Hatch.AutoPlace = Val; SaveSettings() end })

local SecHatch = TabAutoHatch:AddSection("Auto Hatch & Bronto", false)
SecHatch:AddDropdown({ Title = "Pilih Pet Khusus (Bronto)", Multi = true, Options = ListPetGame, Default = SavedData.Hatch.PilBronto, Callback = function(Opt) PilihanPetBronto = Opt; SavedData.Hatch.PilBronto = Opt; SaveSettings() end })
SecHatch:AddInput({ Title = "Target Berat (Kg) Bronto", Content = "Jika di atas ini, tim Bronto turun", Default = tostring(SavedData.Hatch.KgBronto), Callback = function(Txt) BrontoKgTarget = tonumber(Txt) or 4.0; SavedData.Hatch.KgBronto = BrontoKgTarget; SaveSettings() end })
SecHatch:AddToggle({ Title = "▶️ AUTO HATCH", Default = SavedData.Hatch.AutoHatch, Callback = function(Val) AutoHatchOn = Val; SavedData.Hatch.AutoHatch = Val; SaveSettings() end })

local SecSell = TabAutoHatch:AddSection("Sell Pet", false)
SecSell:AddDropdown({ Title = "Pilih Pet untuk Dijual", Multi = true, Options = ListPetGame, Default = SavedData.Hatch.PilSell, Callback = function(Opt) PilihanSellPet = Opt; SavedData.Hatch.PilSell = Opt; SaveSettings() end })
SecSell:AddInput({ Title = "Tahan Pet (Kg)", Content = "Di atas berat ini JANGAN dijual", Default = tostring(SavedData.Hatch.KgSell), Callback = function(Txt) SellKgTarget = tonumber(Txt) or 4.0; SavedData.Hatch.KgSell = SellKgTarget; SaveSettings() end })
SecSell:AddInput({ Title = "Delay Jual (Detik)", Content = "Jeda per pet", Default = tostring(SavedData.Hatch.DelaySell), Callback = function(Txt) SellDelay = tonumber(Txt) or 1.0; SavedData.Hatch.DelaySell = SellDelay; SaveSettings() end })
SecSell:AddToggle({ Title = "▶️ AUTO SELL PET", Default = SavedData.Hatch.AutoSell, Callback = function(Val) AutoSellOn = Val; SavedData.Hatch.AutoSell = Val; SaveSettings() end })

local SecSwitch = TabAutoHatch:AddSection("Team Manager & Switch", false)
local DropTeamReduce = SecSwitch:AddDropdown({ Title = "Team Reduce Egg", Multi = true, Options = {"Kosong"}, Default = SavedData.Hatch.TeamReduce, Callback = function(Opt) UpdateMultiSelectState(FavPet, Opt, TeamReduce); if not IsRefreshingUI then SavedData.Hatch.TeamReduce = Opt; SaveSettings() end end })
local DropTeamHatch  = SecSwitch:AddDropdown({ Title = "Team Hatch", Multi = true, Options = {"Kosong"}, Default = SavedData.Hatch.TeamHatch, Callback = function(Opt) UpdateMultiSelectState(FavPet, Opt, TeamHatch); if not IsRefreshingUI then SavedData.Hatch.TeamHatch = Opt; SaveSettings() end end })
local DropTeamSell   = SecSwitch:AddDropdown({ Title = "Team Sell", Multi = true, Options = {"Kosong"}, Default = SavedData.Hatch.TeamSell, Callback = function(Opt) UpdateMultiSelectState(FavPet, Opt, TeamSell); if not IsRefreshingUI then SavedData.Hatch.TeamSell = Opt; SaveSettings() end end })
local DropTeamBronto = SecSwitch:AddDropdown({ Title = "Team Brontosaurus", Multi = true, Options = {"Kosong"}, Default = SavedData.Hatch.TeamBronto, Callback = function(Opt) UpdateMultiSelectState(FavPet, Opt, TeamBronto); if not IsRefreshingUI then SavedData.Hatch.TeamBronto = Opt; SaveSettings() end end })

SecSwitch:AddButton({ 
    Title = "🔄 Refresh Daftar Tim", Content = "Klik untuk memuat pet Favoritmu",
    Callback = function()
        local daftarFav = AmbilDaftarNama(FavPet) 
        DropTeamReduce:Refresh(daftarFav, SavedData.Hatch.TeamReduce)
        DropTeamHatch:Refresh(daftarFav, SavedData.Hatch.TeamHatch)
        DropTeamSell:Refresh(daftarFav, SavedData.Hatch.TeamSell)
        DropTeamBronto:Refresh(daftarFav, SavedData.Hatch.TeamBronto)
    end 
})

SecSwitch:AddToggle({ Title = "🔄 NYALAKAN AUTO SWITCH CYCLE", Content = "Menjalankan siklus cerdas FSM", Default = SavedData.Hatch.AutoSwitch, Callback = function(Val) AutoSwitchOn = Val; SavedData.Hatch.AutoSwitch = Val; SaveSettings(); if Val then SiklusHatch = "PLACE_EGG" end end })


-- SECTION 5: TAB MISC (SADAP SERVER SKILL CANCEL)
local SecPickPlace = TabMisc:AddSection("Pickup And Place", false)
local DropPickPlace 

-- [PERBAIKAN]: Tombol Scan mengosongkan centangan agar polos!
SecPickPlace:AddButton({
    Title = "🔍 Scan Pet di Kebun", Content = "Tembus pandang tanpa buka UI game!",
    Callback = function()
        ScanKebun()
        if DropPickPlace then DropPickPlace:Refresh(AmbilDaftarNama(PetKebun), {}) end
        table.clear(PickPlacePets)
        if not IsRefreshingUI then SavedData.PickPlace = {} SaveSettings() end
        Speed_Library:SetNotification({Title = "Scan Selesai", Description = "Berhasil", Content = "Daftar pet diperbarui & Pilihan di-reset!", Time = 2})
    end
})

-- =======================================
-- 1. BUAT DROPDOWN (Mode Menunggu FSM)
-- =======================================
local PilihanTersimpan = {} 

DropPickPlace = SecPickPlace:AddDropdown({ 
    Title = "Pilih Pet", 
    Multi = true, 
    Options = {"Menunggu FSM nanam..."}, 
    Default = {}, 
    Flag = "SaveDropdownPet", -- Kunci save untuk UI Library
    Callback = function(Options) 
        PilihanTersimpan = Options 
        table.clear(PickPlacePets)
        local mapPilihan = {}
        for _, nama in ipairs(Options) do mapPilihan[nama] = true end
        
        for _, pet in ipairs(PetKebun) do 
            if mapPilihan[pet.Teks] then table.insert(PickPlacePets, pet) end 
        end
    end 
})

-- =======================================
-- 2. RADAR PENGAWAS (Scan SEKALI SAJA Saat Rejoin)
-- =======================================
task.spawn(function()
    while task.wait(1) do -- Radar mengecek kebun
        local physFolder = Workspace:FindFirstChild("PetsPhysical")
        local jumlahPetDiKebun = 0
        
        if physFolder then
            for _, item in ipairs(physFolder:GetChildren()) do
                if item:GetAttribute("OWNER") == LocalPlayer.Name then
                    jumlahPetDiKebun = jumlahPetDiKebun + 1
                end
            end
        end
        
        -- Jika FSM sudah mulai menanam pet untuk PERTAMA KALINYA
        if jumlahPetDiKebun > 0 then
            
            task.wait(3) -- Jeda 3 detik biar semua pet sempat ditanam
            
            ScanKebun() -- Lakukan pemindaian UUID
            
            local daftarNama = {}
            for _, pet in ipairs(PetKebun) do table.insert(daftarNama, pet.Teks) end
            
            if #daftarNama > 0 then
                -- Ambil memori centangan dari save UI
                local SaveAnLama = Speed_Library.Flags and Speed_Library.Flags["SaveDropdownPet"] or PilihanTersimpan
                
                -- Refresh Dropdown & Centang otomatis pet
                DropPickPlace:Refresh(daftarNama, SaveAnLama)
                
                -- Eksekusi mesin Pick & Place
                if DropPickPlace.Callback then
                    DropPickPlace.Callback(SaveAnLama)
                end
                
                Speed_Library:SetNotification({Title = "Auto-Scan Selesai", Content = "Radar dimatikan agar tidak ganggu Switch Team!", Time = 3})
            end
            
            -- 🔴 HANCURKAN RADAR (Break Loop) 
            -- Ini memastikan scan tidak akan pernah terulang lagi di server ini!
            break 
        end
    end
end)


SecPickPlace:AddInput({ Title = "Delay To Pick", Content = "Jeda narik (0.5)", Default = tostring(SavedData.Input.DelayPick), Callback = function(Text) DelayToPick = tonumber(Text) or 0.5; SavedData.Input.DelayPick = DelayToPick; SaveSettings() end })
SecPickPlace:AddInput({ Title = "Delay To Place", Content = "Jeda nanam (0.5)", Default = tostring(SavedData.Input.DelayPlace), Callback = function(Text) DelayToPlace = tonumber(Text) or 0.5; SavedData.Input.DelayPlace = DelayToPlace; SaveSettings() end })

local TogglePickPlace
TogglePickPlace = SecPickPlace:AddToggle({ 
    Title = "▶️ MULAI SADAP SKILL", Content = "Bisa jalan bareng FSM atau mandiri!", 
    Default = SavedData.AutoStartPickPlace, 
    Callback = function(Value) 
        if IsBooting then return end 
        AutoPickPlaceOn = Value 
        SavedData.AutoStartPickPlace = Value
        SaveSettings()
    end 
})

-- SECTION 5.5: AUTO REJOIN (TAB MISC)
local SecRejoin = TabMisc:AddSection("Auto Rejoin Settings", false)
SecRejoin:AddInput({ 
    Title = "Rejoin Timer (Menit)", Content = "Berapa menit sekali untuk rejoin?", Default = tostring(SavedData.Input.RejoinTime), 
    Callback = function(Text) AutoRejoinMenit = tonumber(Text) or 60; SavedData.Input.RejoinTime = AutoRejoinMenit; SaveSettings() end 
})

local ToggleRejoin
ToggleRejoin = SecRejoin:AddToggle({
    Title = "▶️ AUTO REJOIN SERVER", Content = "Otomatis reconnect setelah waktu habis", Default = SavedData.AutoStartRejoin, 
    Callback = function(Value)
        if IsBooting then return end
        AutoRejoinOn = Value
        SavedData.AutoStartRejoin = Value
        SaveSettings()
    end
})

-- ==========================================
-- SECTION 5.6: POTATO MODE (TAB MISC)
-- ==========================================
local SecPotato = TabMisc:AddSection("Potato Mode (Optimasi)", false)

SecPotato:AddButton({
    Title = "🥔 Aktifkan Mode Kentang", 
    Content = "Grafik burik, RAM aman! (Harus rejoin untuk kembali)",
    Callback = function()
        local Workspace = game:GetService("Workspace")
        local Lighting = game:GetService("Lighting")
        local Terrain = Workspace:WaitForChild("Terrain")

        -- 1. Matikan Cahaya & Efek Langit
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 1

        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect:IsA("PostEffect") or effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or effect:IsA("DepthOfFieldEffect") or effect:IsA("Atmosphere") or effect:IsA("Sky") then
                pcall(function() effect.Enabled = false end)
            end
        end

        -- 2. Matikan Air & Rumput 3D
        pcall(function()
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 1
            Terrain.Decoration = false 
        end)

        -- 3. Fungsi Penghancur Tekstur & Partikel
        local function OptimasiObjek(obj)
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.CastShadow = false
                obj.Reflectance = 0
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 1 
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                obj.Enabled = false 
            end
        end

        -- Sapu bersih objek yang sudah ada
        for _, obj in ipairs(Workspace:GetDescendants()) do
            task.spawn(function() pcall(function() OptimasiObjek(obj) end) end)
        end

        -- Pasang CCTV untuk objek yang baru masuk map
        Workspace.DescendantAdded:Connect(function(obj)
            pcall(function() OptimasiObjek(obj) end)
        end)

        -- 4. Paksa settingan render bawaan Roblox ke terendah
        pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
        
        -- Notifikasi Berhasil
        Speed_Library:SetNotification({
            Title = "Potato Mode", 
            Description = "Aktif", 
            Content = "Grafik berhasil diturunkan. Game super ringan!", 
            Time = 3
        })
    end
})

-- ==========================================
-- SECTION 5.7: ESP EGG (TAB MISC)
-- ==========================================
local function FormatWaktuESP(seconds)
    if not seconds or seconds <= 0 then return "00:00" end
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60
    if h > 0 then return string.format("%d:%02d:%02d", h, m, s)
    else return string.format("%02d:%02d", m, s) end
end

local function BersihkanESP()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "ESP" and obj:IsA("Folder") then
            obj:Destroy()
        end
    end
end

local function Toggle_ESPEgg(state)
    getgenv().ESP_EGG_AKTIF = state
    
    if getgenv().FSM_ESP_LOOP then task.cancel(getgenv().FSM_ESP_LOOP) end
    if getgenv().FSM_RAM_LOOP then task.cancel(getgenv().FSM_RAM_LOOP) end
    if getgenv().FSM_EVENT_ADD then getgenv().FSM_EVENT_ADD:Disconnect() end
    
    if state then
        local stokMatang = {}
        local listBrankas = {}
        local butuhScanRAM = false
        local lastScanTime = 0

        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "Objects_Physical" and obj:IsA("Folder") then
                table.insert(listBrankas, obj)
            end
        end

        getgenv().FSM_EVENT_ADD = workspace.DescendantAdded:Connect(function(obj)
            if obj.Name == "Objects_Physical" and obj:IsA("Folder") then
                table.insert(listBrankas, obj)
            end
        end)

        getgenv().FSM_RAM_LOOP = task.spawn(function()
            while task.wait(1) do
                if butuhScanRAM and (os.clock() - lastScanTime > 5) then
                    lastScanTime = os.clock()
                    butuhScanRAM = false 
                    local tempStok = {}
                    for _, laci in pairs(getgc(true)) do
                        if type(laci) == "table" then
                            for kunci, kotakKecil in pairs(laci) do
                                if type(kunci) == "string" and string.len(kunci) > 20 and type(kotakKecil) == "table" then
                                    local sukses, dataTelur = pcall(function() return kotakKecil.Data end)
                                    if sukses and type(dataTelur) == "table" then
                                        local baseWeight = rawget(dataTelur, "BaseWeight")
                                        local jenisPet = rawget(dataTelur, "Type") or "Pet"
                                        local randomData = rawget(dataTelur, "RandomPetData")
                                        if not baseWeight and type(randomData) == "table" then
                                            baseWeight = rawget(randomData, "BaseWeight")
                                            jenisPet = rawget(randomData, "Type") or jenisPet
                                        end
                                        if baseWeight then
                                            tempStok[kunci] = {
                                                Spesies = jenisPet,
                                                Berat = string.format("%.2f", tonumber(baseWeight) * 1.1)
                                            }
                                        end
                                    end
                                end
                            end
                        end
                    end
                    stokMatang = tempStok 
                end
            end
        end)

        getgenv().FSM_ESP_LOOP = task.spawn(function()
            while task.wait(0.2) do
                for _, brankas in pairs(listBrankas) do
                    if brankas and brankas.Parent then
                        for _, objek in pairs(brankas:GetChildren()) do 
                            local ownerText = tostring(objek:GetAttribute("OWNER") or "")
                            local namaAsli = tostring(LocalPlayer.Name)
                            local namaTampilan = tostring(LocalPlayer.DisplayName)
                            
                            if string.find(ownerText, namaAsli) or string.find(ownerText, namaTampilan) then
                                local uuidFisik = objek:GetAttribute("OBJECT_UUID")
                                if uuidFisik then
                                    local part = objek.PrimaryPart
                                    if not part then
                                        for _, child in pairs(objek:GetDescendants()) do
                                            if child:IsA("BasePart") then part = child break end
                                        end
                                    end
                                    
                                    if part then
                                        local folderESP = part:FindFirstChild("ESP")
                                        if not folderESP then
                                            folderESP = Instance.new("Folder")
                                            folderESP.Name = "ESP"
                                            folderESP.Parent = part
                                            
                                            local modelESP = Instance.new("Model")
                                            modelESP.Name = "ESP"
                                            modelESP.Parent = folderESP
                                            
                                            local billboard = Instance.new("BillboardGui")
                                            billboard.Name = "BillboardGui"
                                            billboard.Adornee = part
                                            billboard.Size = UDim2.new(6, 0, 2.5, 0)
                                            billboard.StudsOffset = Vector3.new(0, 3.5, 0)
                                            billboard.AlwaysOnTop = true
                                            billboard.Parent = modelESP
                                            
                                            local textLabel = Instance.new("TextLabel")
                                            textLabel.Name = "TextLabel"
                                            textLabel.Parent = billboard
                                            textLabel.Size = UDim2.new(1, 0, 1, 0)
                                            textLabel.BackgroundTransparency = 1
                                            textLabel.TextScaled = true
                                            textLabel.Font = Enum.Font.FredokaOne
                                            textLabel.TextStrokeTransparency = 0.5
                                            textLabel.RichText = true 
                                        end
                                        
                                        local label = part.ESP.ESP.BillboardGui.TextLabel
                                        local sisaWaktu = objek:GetAttribute("TimeToHatch")
                                        local namaTelur = objek:GetAttribute("EggName") or "Egg"
                                        
                                        if sisaWaktu and sisaWaktu > 0 then
                                            label.Text = "<font color='rgb(255,200,50)'>" .. namaTelur .. "\n" .. FormatWaktuESP(sisaWaktu) .. "</font>"
                                        else
                                            if not stokMatang[uuidFisik] then
                                                butuhScanRAM = true
                                                label.Text = "<font color='rgb(150,150,150)'>" .. namaTelur .. "\n0.00 KG</font>"
                                            else
                                                local data = stokMatang[uuidFisik]
                                                if tonumber(data.Berat) >= 2.5 then
                                                    label.Text = "<font color='rgb(50,255,50)'>" .. data.Spesies .. "\n" .. data.Berat .. " KG</font>"
                                                else
                                                    label.Text = "<font color='rgb(255,255,255)'>" .. data.Spesies .. "\n" .. data.Berat .. " KG</font>"
                                                end
                                            end
                                        end
                                    end
                                end
                            else
                                local part = objek.PrimaryPart
                                if not part then
                                    for _, child in pairs(objek:GetDescendants()) do
                                        if child:IsA("BasePart") then part = child break end
                                    end
                                end
                                if part then
                                    local hapusFolder = part:FindFirstChild("ESP")
                                    if hapusFolder then hapusFolder:Destroy() end
                                end
                            end
                        end
                    end
                end
            end
        end)
    else
        BersihkanESP()
    end
end

local SecVisual = TabMisc:AddSection("Visual & Bantuan", false)
SecVisual:AddToggle({ 
    Title = "👁️ NYALAKAN ESP EGG", 
    Content = "Melihat isi telur sebelum menetas",
    Default = false, 
    Callback = function(Val) 
        Toggle_ESPEgg(Val) 
    end 
})


-- SECTION 6: SETTINGS & SECFITUR
local SecSet = TabSetting:AddSection("Webhook & Update", false)
SecSet:AddInput({
    Title = "URL Webhook", Content = "Paste link Discord", Default = SavedData.Input.Webhook or "",
    Callback = function(Text) WebhookURL = Text; SavedData.Input.Webhook = Text; SaveSettings() end
})
SecSet:AddButton({
    Title = "Test Webhook", Content = "Kirim pesan test",
    Callback = function()
        if WebhookURL == "" then Speed_Library:SetNotification({Title = "Gagal", Description = "Error", Content = "Link Webhook kosong!", Time = 3})
        else KirimWebhook("✅ **TEST BERHASIL!** Custom UI Gery sudah terhubung!", {["title"] = "Test", ["description"] = "Aman!"}) end
    end
})

-- ==========================================
-- 4. SENSOR UI ANTI-LAG & CCTV
-- ==========================================
local function UpdateSemuaDropdown(paksaRefresh)
    if not paksaRefresh and (tick() - WaktuTerakhirGerak < 3) then return end 
    
    IsRefreshingUI = true 
    ScanTas()
    -- [PERBAIKAN]: ScanKebun() dihapus agar tidak ganggu memori Pick & Place!
    
    local daftarFav = AmbilDaftarNama(FavPet)
    local daftarNonFav = AmbilDaftarNama(NonFav)

    -- [PERBAIKAN]: FUNGSI SAPU GAIB
    local function BersihkanGaib(pilihanLama, daftarTersedia)
        if type(pilihanLama) ~= "table" then return {} end
        local pilihanValid = {}
        for _, pil in ipairs(pilihanLama) do
            for _, sedia in ipairs(daftarTersedia) do
                if pil == sedia then table.insert(pilihanValid, pil) break end
            end
        end
        return pilihanValid
    end
    
    if DropGajah then DropGajah:Refresh(daftarFav, BersihkanGaib(DropGajah.Value, daftarFav)) end
    if DropLeveling then DropLeveling:Refresh(daftarFav, BersihkanGaib(DropLeveling.Value, daftarFav)) end
    if DropAge100 then DropAge100:Refresh(daftarFav, BersihkanGaib(DropAge100.Value, daftarFav)) end
    if DropBahan then DropBahan:Refresh(daftarNonFav, BersihkanGaib(DropBahan.Value, daftarNonFav)) end
    if DropPushLeveling then DropPushLeveling:Refresh(daftarFav, BersihkanGaib(DropPushLeveling.Value, daftarFav)) end
    if DropPushBahan then DropPushBahan:Refresh(daftarNonFav, BersihkanGaib(DropPushBahan.Value, daftarNonFav)) end
    
    IsRefreshingUI = false 
    
    if DropGajah then UpdateMultiSelectState(FavPet, DropGajah.Value, PetTeamElephant) end
    if DropLeveling then UpdateMultiSelectState(FavPet, DropLeveling.Value, PetTeamLeveling) end
    if DropAge100 then UpdateMultiSelectState(FavPet, DropAge100.Value, PetTeamAge100) end
    if DropBahan then UpdateMultiSelectState(NonFav, DropBahan.Value, PetBahan) end
    if DropPushLeveling then UpdateMultiSelectState(FavPet, DropPushLeveling.Value, PetTeamPush50) end
    if DropPushBahan then UpdateMultiSelectState(NonFav, DropPushBahan.Value, PetBahanPush50) end
end

local tas = LocalPlayer:WaitForChild("Backpack")

local function PantauBintangPet(item)
    if item:GetAttribute("ItemType") == "Pet" then 
        -- 🔒 KUNCI SENSOR: Biar nggak dobel pas masuk tas!
        if not item:GetAttribute("CCTV_Bintang") then
            item:SetAttribute("CCTV_Bintang", true)
            item:GetAttributeChangedSignal("d"):Connect(function() 
                task.wait(0.1) UpdateSemuaDropdown() 
            end) 
        end
    end
end

for _, item in ipairs(tas:GetChildren()) do PantauBintangPet(item) end

tas.ChildAdded:Connect(function(item) 
    if item:GetAttribute("ItemType") == "Pet" then 
        PantauBintangPet(item) 
        -- 🛑 BLOKIR REFRESH UI KALAU PICK & PLACE NYALA
        if not AutoPickPlaceOn then
            task.wait(0.1) UpdateSemuaDropdown() 
        end
    end 
end)

tas.ChildRemoved:Connect(function(item) 
    if item:GetAttribute("ItemType") == "Pet" then 
        -- 🛑 BLOKIR REFRESH UI KALAU PICK & PLACE NYALA
        if not AutoPickPlaceOn then
            UpdateSemuaDropdown() 
        end
    end 
end)

local function SetupCCTVNotif()
    local FrameFolder = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Top_Notification"):WaitForChild("Frame")
    local function CekNotifikasi(uiNode)
        if string.find(uiNode.Name, "Notification") then
            local function BacaAtribut()
                local textOG = uiNode:GetAttribute("OG")
                if textOG and textOG ~= "" then
                    local teksKecil = string.lower(textOG)
                    
                    -- 1. Sensor Gajah Mentok
                    if string.find(teksKecil, "elephant trumpeted") and string.find(teksKecil, "weight cap") then
                        LogPesan("🚨 [Sistem] Alarm CCTV: Gajah mentok terdeteksi!") 
                        GajahMentokNotif = true 
                    end
                    
                    -- 2. Sensor Telur Penuh
                    if string.find(teksKecil, "max pet eggs reached") then
                        EggMaxNotif = true
                    end
                    
                    -- 3. Sensor Tas Penuh [FIX KABEL SCOPE]
                    if string.find(teksKecil, "max backpack space") then
                        getgenv().TasPenuh = true -- CCTV langsung lempar sinyal tanpa banyak tanya!
                    end
                end
            end
            BacaAtribut() 
            uiNode:GetAttributeChangedSignal("OG"):Connect(BacaAtribut)
        end
    end
    FrameFolder.ChildAdded:Connect(function(node) task.wait(0.1) CekNotifikasi(node) end)
end
task.spawn(SetupCCTVNotif)


-- ==========================================
-- 4.5 MESIN PARALEL: AUTO PICK & PLACE (FINAL VERSION)
-- ==========================================
local SedangDiProses = {}
local JamSelesaiCD = {} 
local BlokirSinyalNol = {} 

local PetCooldownsUpdated = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("PetCooldownsUpdated")
PetCooldownsUpdated.OnClientEvent:Connect(function(uuid, cdData)
    if not AutoPickPlaceOn then return end
    
    if cdData then
        local slotUtama = cdData[1] or cdData["1"]
        if slotUtama and type(slotUtama) == "table" and slotUtama.Time then
            
            -- Cek apakah pet ada di daftar Pick & Place
            local masukDaftar = false
            for _, pet in ipairs(PickPlacePets) do
                if pet.Id == uuid then masukDaftar = true break end
            end
            if not masukDaftar then return end
            
            local sisaWaktu = slotUtama.Time
            local jamSekarang = os.clock()
            
            -- 🛡️ FILTER 1: Anti Hantu Lag
            if sisaWaktu == 0 and BlokirSinyalNol[uuid] and jamSekarang < BlokirSinyalNol[uuid] then
                return
            end
            
            if SedangDiProses[uuid] then return end
            
            -- 🛡️ FILTER 2: Kunci Jam CD
            if sisaWaktu == 0 then
                if JamSelesaiCD[uuid] and JamSelesaiCD[uuid] <= jamSekarang then return end
                JamSelesaiCD[uuid] = jamSekarang
            else
                JamSelesaiCD[uuid] = jamSekarang + sisaWaktu
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.03) do -- Respon super cepat
        if not AutoPickPlaceOn then continue end
        
        local jamSekarang = os.clock()
        
        -- Fungsi Perlindungan FSM
        local function IsPetActiveInFSM(petId)
            if AutoElephantOn then
                local isFSMTarget = false
                for _, p in ipairs(PetTeamLeveling) do if p.Id == petId then isFSMTarget = true end end
                for _, p in ipairs(PetTeamElephant) do if p.Id == petId then isFSMTarget = true end end
                for _, p in ipairs(PetTeamAge100) do if p.Id == petId then isFSMTarget = true end end
                if not isFSMTarget then return true end 
            elseif AutoPush50On then
                local isPushTarget = false
                for _, p in ipairs(PetTeamPush50) do if p.Id == petId then isPushTarget = true end end
                if not isPushTarget then return true end 
            end
            return true 
        end
        
        for _, pet in ipairs(PickPlacePets) do
            local uuid = pet.Id
            
            if JamSelesaiCD[uuid] and not SedangDiProses[uuid] then
                
                -- LOGIKA FINAL: Jeda 1 Detik + Aman dari FSM Utama
                if jamSekarang >= (JamSelesaiCD[uuid] + 1) and IsPetActiveInFSM(uuid) then
                    
                    SedangDiProses[uuid] = true
                    BlokirSinyalNol[uuid] = jamSekarang + DelayToPick + DelayToPlace + 1 
                    JamSelesaiCD[uuid] = nil 
                    
                    -- Tangan Gaib Eksekusi
                    task.spawn(function()
                        local koordinatPusat = GetMyFarmCenter()
                        
                        WaktuTerakhirGerak = tick() 
                        task.wait(DelayToPick)
                        pcall(function() PetsService:FireServer("UnequipPet", uuid) end)
                        
                        task.wait(DelayToPlace)
                        if koordinatPusat then
                            WaktuTerakhirGerak = tick() 
                            pcall(function() PetsService:FireServer("EquipPet", uuid, koordinatPusat) end)
                        end
                        
                        task.wait(0.03)
                        SedangDiProses[uuid] = nil
                    end)
                end
            end
        end
    end
end)


-- ==========================================
-- 5. MESIN FSM OTOMATISASI UTAMA
-- ==========================================
task.spawn(function()
    while task.wait(0.5) do 
        if AutoElephantOn then
            if FaseFarming == "TANAM" then
                table.clear(BahanDiKebun) ScanTas() 
                local targetDitanam = {}
                for _, petBahan in ipairs(PetBahan) do 
                    local petSegar = nil
                    for _, p in ipairs(NonFav) do if p.Id == petBahan.Id then petSegar = p break end end
                    if petSegar and petSegar.Umur < Age100MaxAge then
                        table.insert(targetDitanam, petSegar)
                        if #targetDitanam >= BahanBatchSize then break end
                    end
                end
                
                local bahanDitanam = 0
                for _, pet in ipairs(targetDitanam) do PlacePet(pet.Id) table.insert(BahanDiKebun, pet.Id) bahanDitanam = bahanDitanam + 1 task.wait(0.5) end
                
                if bahanDitanam == 0 then LogPesan("[Sistem] Selesai!") AutoElephantOn = false ToggleMesin:Set(false) continue end
                for _, petTeam in ipairs(PetTeamLeveling) do PlacePet(petTeam.Id) task.wait(0.5) end
                FaseFarming = "LEVELING" LogPesan("[Fase] Masuk Fase LEVELING...")

            elseif FaseFarming == "LEVELING" then
                local semuaSiapBlessing = true
                for _, id in ipairs(BahanDiKebun) do if AmbilUmurDiKebun(id) < ElephantMinAge then semuaSiapBlessing = false break end end
                if semuaSiapBlessing then
                    LogPesan("[Fase] " .. InfoBahan() .. " -> Gajah") GajahMentokNotif = false
                    for _, petTeam in ipairs(PetTeamLeveling) do PickupPet(petTeam.Id) task.wait(0.4) end
                    for _, petTeam in ipairs(PetTeamElephant) do PlacePet(petTeam.Id) task.wait(0.4) end
                    FaseFarming = "BLESSING"
                end

            elseif FaseFarming == "BLESSING" then
                local semuaSuksesReset = true
                local semuaDiatasMinAge = true
                for _, id in ipairs(BahanDiKebun) do
                    local umurSekarang = AmbilUmurDiKebun(id)
                    if umurSekarang > 0 then 
                        if umurSekarang > (ElephantResetAge + 5) then semuaSuksesReset = false end 
                        if umurSekarang < ElephantMinAge then semuaDiatasMinAge = false end
                    else 
                        semuaSuksesReset = false semuaDiatasMinAge = false
                    end
                end

                if semuaSuksesReset then
                    LogPesan("✅ [Fase] Reset Sukses " .. InfoBahan()) GajahMentokNotif = false
                    for _, petTeam in ipairs(PetTeamElephant) do PickupPet(petTeam.Id) task.wait(0.4) end
                    for _, petTeam in ipairs(PetTeamLeveling) do PlacePet(petTeam.Id) task.wait(0.4) end
                    FaseFarming = "LEVELING" 
                elseif GajahMentokNotif and not semuaDiatasMinAge then
                    LogPesan("🔄 [Sinkronisasi] Ada pet yang baru reset. Kembali Leveling!") GajahMentokNotif = false
                    for _, petTeam in ipairs(PetTeamElephant) do PickupPet(petTeam.Id) task.wait(0.4) end
                    for _, petTeam in ipairs(PetTeamLeveling) do PlacePet(petTeam.Id) task.wait(0.4) end
                    FaseFarming = "LEVELING"
                elseif GajahMentokNotif and semuaDiatasMinAge then
                    GajahMentokNotif = false 
                    local butuhPush = false
                    for _, id in ipairs(BahanDiKebun) do if AmbilUmurDiKebun(id) < Age100MinAge then butuhPush = true break end end
                    if butuhPush then
                        LogPesan("⚠️ [Fase] Push Leveling " .. InfoBahan())
                        for _, petTeam in ipairs(PetTeamElephant) do PickupPet(petTeam.Id) task.wait(0.4) end
                        for _, petTeam in ipairs(PetTeamLeveling) do PlacePet(petTeam.Id) task.wait(0.4) end
                        FaseFarming = "PUSH_LEVELING"
                    else
                        LogPesan("⏩ [Fase] Langsung Age 100 " .. InfoBahan())
                        for _, petTeam in ipairs(PetTeamElephant) do PickupPet(petTeam.Id) task.wait(0.4) end
                        for _, petTeam in ipairs(PetTeamAge100) do PlacePet(petTeam.Id) task.wait(0.4) end
                        FaseFarming = "MENUJU_100"
                    end
                end

            elseif FaseFarming == "PUSH_LEVELING" then
                local semuaSiapAge100 = true
                for _, id in ipairs(BahanDiKebun) do if AmbilUmurDiKebun(id) < Age100MinAge then semuaSiapAge100 = false break end end
                if semuaSiapAge100 then
                    LogPesan("[Fase] Push Selesai, masuk Age 100")
                    for _, petTeam in ipairs(PetTeamLeveling) do PickupPet(petTeam.Id) task.wait(0.4) end
                    for _, petTeam in ipairs(PetTeamAge100) do PlacePet(petTeam.Id) task.wait(0.4) end
                    FaseFarming = "MENUJU_100"
                end

            elseif FaseFarming == "MENUJU_100" then
                local semuaSudahMax = true
                for _, id in ipairs(BahanDiKebun) do if AmbilUmurDiKebun(id) < Age100MaxAge then semuaSudahMax = false break end end
                if semuaSudahMax then
                    LogPesan("🎉 [PANEN] " .. InfoBahan() .. " max!") CycleCount = CycleCount + 1 WaktuStartCycle = tick()
                    for _, id in ipairs(BahanDiKebun) do PickupPet(id) task.wait(0.4) end
                    for _, petTeam in ipairs(PetTeamAge100) do PickupPet(petTeam.Id) task.wait(0.4) end
                    FaseFarming = "TANAM" 
                end
            end

        elseif AutoPush50On then
            if FaseFarming == "TANAM_PUSH" then
                table.clear(BahanDiKebun) ScanTas() 
                local targetDitanam = {}
                for _, petBahan in ipairs(PetBahanPush50) do 
                    local petSegar = nil
                    for _, p in ipairs(NonFav) do if p.Id == petBahan.Id then petSegar = p break end end
                    if petSegar and petSegar.Umur < Push50TargetAge then
                        table.insert(targetDitanam, petSegar)
                        if #targetDitanam >= Push50BatchSize then break end
                    end
                end
                
                local bahanDitanam = 0
                for _, pet in ipairs(targetDitanam) do PlacePet(pet.Id) table.insert(BahanDiKebun, pet.Id) bahanDitanam = bahanDitanam + 1 task.wait(0.5) end
                
                if bahanDitanam == 0 then LogPesan("[Sistem] Selesai!") AutoPush50On = false if ToggleMesinPush then ToggleMesinPush:Set(false) end continue end
                for _, petTeam in ipairs(PetTeamPush50) do PlacePet(petTeam.Id) task.wait(0.5) end
                FaseFarming = "LEVELING_PUSH" LogPesan("[Push 50] Menuju Umur " .. Push50TargetAge .. "...")

            elseif FaseFarming == "LEVELING_PUSH" then
                local semuaSudahMax = true
                for _, id in ipairs(BahanDiKebun) do if AmbilUmurDiKebun(id) < Push50TargetAge then semuaSudahMax = false break end end
                if semuaSudahMax then
                    LogPesan("🎉 [PANEN PUSH 50] " .. InfoBahan() .. " max!") CycleCount = CycleCount + 1 WaktuStartCycle = tick()
                    for _, id in ipairs(BahanDiKebun) do PickupPet(id) task.wait(0.4) end
                    for _, petTeam in ipairs(PetTeamPush50) do PickupPet(petTeam.Id) task.wait(0.4) end
                    FaseFarming = "TANAM_PUSH" 
                end
            end
        end
    end
end)

-- ==========================================
-- 5.5 MESIN SIKLUS EGG (AUTO HATCH CYCLE)
-- ==========================================
task.spawn(function()
    while task.wait(1) do
        
        if AutoSwitchOn then
            -- MENGHITUNG TELUR DI KEBUN
            local telurDiKebun = {}
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == "Objects_Physical" and obj:IsA("Folder") then
                    for _, item in pairs(obj:GetChildren()) do
                        if string.find(tostring(item:GetAttribute("OWNER")), LocalPlayer.Name) and item:GetAttribute("EggName") then
                            table.insert(telurDiKebun, item)
                        end
                    end
                end
            end

            -- PHASE 1: PLACE EGG
            if SiklusHatch == "PLACE_EGG" then
                if EggMaxNotif then
                    EggMaxNotif = false 
                    GantiTim(TeamReduce)
                    SiklusHatch = "WAIT_HATCH"
                elseif #telurDiKebun < JumlahTanamEgg then
                    local titikTanam = GetEggPlantPositions()
                    local indexTitik = 1
                    
                    for _, namaEggTarget in ipairs(PilihanEgg) do
                        if #telurDiKebun >= JumlahTanamEgg or EggMaxNotif then break end
                        
                        local toolDipegang = PegangItemDariTas(namaEggTarget)
                        if toolDipegang then
                            -- Rumus putaran Kiri-Kanan yang adil
                            local jumlahTitik = #titikTanam > 0 and #titikTanam or 1
                            local targetPos = titikTanam[((indexTitik - 1) % jumlahTitik) + 1] or Vector3.new(0,0,0)
                            
                            task.wait(0.5)
                            pcall(function() 
                                ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("PetEggService"):FireServer("CreateEgg", targetPos)
                            end)
                            
                            task.wait(0.5)
                            SimpanSemuaItem()
                            task.wait(0.5)
                            
                            table.insert(telurDiKebun, toolDipegang)
                            indexTitik = indexTitik + 1
                        end
                    end
                end
                
                if #telurDiKebun >= JumlahTanamEgg then
                    GantiTim(TeamReduce)
                    SiklusHatch = "WAIT_HATCH"
                end

            -- PHASE 2: TUNGGU & HATCH
            elseif SiklusHatch == "WAIT_HATCH" then
                local targetHatchItem = nil
                for _, egg in ipairs(telurDiKebun) do
                    local waktu = egg:GetAttribute("TimeToHatch")
                    if not waktu or waktu <= 0 then
                        targetHatchItem = egg
                        break
                    end
                end

                if targetHatchItem then
                    local uuidFisik = targetHatchItem:GetAttribute("OBJECT_UUID")
                    local prediksiKg = 0
                    local prediksiNama = "Unknown"
                    local butuhBronto = false
                    
                    for _, laci in pairs(getgc(true)) do
                        if type(laci) == "table" then
                            for kunci, kotakKecil in pairs(laci) do
                                if kunci == uuidFisik and type(kotakKecil) == "table" then
                                    pcall(function()
                                        local dataTelur = kotakKecil.Data
                                        local bw = rawget(dataTelur, "BaseWeight") or (rawget(dataTelur, "RandomPetData") and rawget(dataTelur.RandomPetData, "BaseWeight"))
                                        local ty = rawget(dataTelur, "Type") or (rawget(dataTelur, "RandomPetData") and rawget(dataTelur.RandomPetData, "Type"))
                                        if bw then prediksiKg = tonumber(bw) * 1.1 end
                                        if ty then prediksiNama = ty end
                                    end)
                                end
                            end
                        end
                    end

                    for _, namaBronto in ipairs(PilihanPetBronto) do
                        if prediksiNama == namaBronto and prediksiKg >= BrontoKgTarget then
                            butuhBronto = true break
                        end
                    end

                    if butuhBronto then
                        GantiTim(TeamBronto)
                    else
                        GantiTim(TeamHatch)
                    end
                    
                                        task.wait(1) 
                    pcall(function()
                        ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("PetEggService"):FireServer("HatchPet", targetHatchItem)
                    end)
                    task.wait(1.5)

                end
                
                if #telurDiKebun == 0 then SiklusHatch = "POST_HATCH" end

            -- PHASE 3: POST-HATCH (SELL)
            elseif SiklusHatch == "POST_HATCH" then
                if AutoSellOn then
                    GantiTim(TeamSell)
                    task.wait(5)
                    
                    -- Fungsi radar khusus untuk mencari pet di Tas & Tangan
                    local function CariPetDijual()
                        local tas = LocalPlayer:FindFirstChild("Backpack")
                        local char = LocalPlayer.Character
                        local semuaItem = {}
                        
                        if tas then for _, v in ipairs(tas:GetChildren()) do table.insert(semuaItem, v) end end
                        if char then for _, v in ipairs(char:GetChildren()) do table.insert(semuaItem, v) end end
                        
                        for _, item in ipairs(semuaItem) do
                            if item:IsA("Tool") and item:GetAttribute("ItemType") == "Pet" then
                                local namaPet = item.Name
                                local bw = item:GetAttribute("BaseWeight") or 0
                                local kgAsli = tonumber(bw) * 1.1
                                
                                local cocokList = false
                                for _, sellNama in ipairs(PilihanSellPet) do
                                    if string.find(namaPet, sellNama) then cocokList = true break end
                                end
                                
                                if cocokList and kgAsli < SellKgTarget then
                                    return item -- Ditemukan pet yang cocok!
                                end
                            end
                        end
                        return nil
                    end

                    -- Looping jual selama radar masih menemukan target
                    local targetJual = CariPetDijual()
                    while targetJual and AutoSwitchOn and AutoSellOn do
                        local toolDipegang = PegangItemDariTas(targetJual:GetAttribute("PET_UUID"))
                        if toolDipegang then
                            task.wait(0.5)
                            pcall(function() 
                                ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("SellPet_RE"):FireServer(toolDipegang, true) 
                            end)
                            task.wait(SellDelay)
                        else
                            task.wait(0.5) -- Jeda aman jika gagal pegang
                        end
                        
                        -- Scan ulang sisa pet setelah 1 terjual
                        targetJual = CariPetDijual()
                    end
                    
                    GantiTim(TeamReduce)
                    SiklusHatch = "PLACE_EGG"
                else
                    GantiTim(TeamReduce)
                    SiklusHatch = "PLACE_EGG"
                end
            end

            
        -- ==========================================
        -- MODE 2: INDEPENDENT (AUTO SWITCH MATI)
        -- ==========================================
        else
            -- [1] INDEPENDENT: AUTO PLACE EGG
            if AutoPlaceOn then
                if EggMaxNotif then
                    EggMaxNotif = false
                else
                    local telurDiKebun = 0
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj.Name == "Objects_Physical" and obj:IsA("Folder") then
                            for _, item in pairs(obj:GetChildren()) do
                                if string.find(tostring(item:GetAttribute("OWNER")), LocalPlayer.Name) and item:GetAttribute("EggName") then
                                    telurDiKebun = telurDiKebun + 1
                                end
                            end
                        end
                    end

                    if telurDiKebun < JumlahTanamEgg then
                        local titikTanam = GetEggPlantPositions()
                        local indexTitik = 1
                        
                        for _, namaEggTarget in ipairs(PilihanEgg) do
                            if telurDiKebun >= JumlahTanamEgg or EggMaxNotif then break end
                            
                            local toolDipegang = PegangItemDariTas(namaEggTarget)
                            if toolDipegang then
                                local jumlahTitik = #titikTanam > 0 and #titikTanam or 1
                                local targetPos = titikTanam[((indexTitik - 1) % jumlahTitik) + 1] or Vector3.new(0,0,0)
                                
                                task.wait(0.5)
                                pcall(function() 
                                    ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("PetEggService"):FireServer("CreateEgg", targetPos)
                                end)
                                
                                task.wait(0.5)
                                SimpanSemuaItem()
                                task.wait(0.5)
                                
                                telurDiKebun = telurDiKebun + 1
                                indexTitik = indexTitik + 1
                            end
                        end
                    end
                end
            end
            
            -- [2] INDEPENDENT: AUTO HATCH EGG
            if AutoHatchOn then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj.Name == "Objects_Physical" and obj:IsA("Folder") then
                        for _, item in pairs(obj:GetChildren()) do 
                            local ownerText = tostring(item:GetAttribute("OWNER") or "")
                            if string.find(ownerText, LocalPlayer.Name) then
                                local uuidFisik = item:GetAttribute("OBJECT_UUID")
                                local sisaWaktu = item:GetAttribute("TimeToHatch")
                                local isEgg = item:GetAttribute("EggName") ~= nil
                                
                                if isEgg and uuidFisik then
                                    if not sisaWaktu or sisaWaktu <= 0 then
                                        pcall(function()
                                            ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("PetEggService"):FireServer("HatchPet", item)
                                        end)
                                        task.wait(1) -- Jeda anti-spam
                                    end

                                end
                            end
                        end
                    end
                end
            end
            
            -- [3] INDEPENDENT: AUTO SELL PET
            if AutoSellOn then
                local function CariPetDijualIndie()
                    local tas = LocalPlayer:FindFirstChild("Backpack")
                    local char = LocalPlayer.Character
                    local semuaItem = {}
                    if tas then for _, v in ipairs(tas:GetChildren()) do table.insert(semuaItem, v) end end
                    if char then for _, v in ipairs(char:GetChildren()) do table.insert(semuaItem, v) end end
                    
                    for _, item in ipairs(semuaItem) do
                        if item:IsA("Tool") and item:GetAttribute("ItemType") == "Pet" then
                            local namaPet = item.Name
                            local bw = item:GetAttribute("BaseWeight") or 0
                            local kgAsli = tonumber(bw) * 1.1
                            
                            local cocokList = false
                            for _, sellNama in ipairs(PilihanSellPet) do
                                if string.find(namaPet, sellNama) then cocokList = true break end
                            end
                            
                            if cocokList and kgAsli < SellKgTarget then return item end
                        end
                    end
                    return nil
                end

                local targetJual = CariPetDijualIndie()
                if targetJual then
                    local toolDipegang = PegangItemDariTas(targetJual:GetAttribute("PET_UUID"))
                    if toolDipegang then
                        task.wait(0.5)
                        pcall(function() 
                            ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("SellPet_RE"):FireServer(toolDipegang, true) 
                        end)
                        task.wait(SellDelay)
                    end
                end
            end

            
        end
    end
end)

-- ==========================================
-- MESIN AUTO-COLLECT FRUIT V2 (LEBIH AKURAT)
-- ==========================================
task.spawn(function()
    while task.wait(1.5) do -- Jeda 1.5 detik
        if AutoCollectOn then
            local daftarTanaman = {}
            local myFarm = nil
            local LocalPlayer = game.Players.LocalPlayer
            
            -- 1. Cari Kebun Kita Dulu
            local farmFolder = workspace:FindFirstChild("Farm")
            if farmFolder then
                for _, kebun in ipairs(farmFolder:GetChildren()) do
                    local ownerVal = kebun:FindFirstChild("Important") and kebun.Important:FindFirstChild("Data") and kebun.Important.Data:FindFirstChild("Owner")
                    if ownerVal and tostring(ownerVal.Value) == LocalPlayer.Name then
                        myFarm = kebun
                        break
                    end
                end
            end

            -- 2. Gunakan Radar CollectionService (Jalan Pintas Developer)
            if myFarm then
                local semuaPrompt = game:GetService("CollectionService"):GetTagged("CollectPrompt")
                
                for _, prompt in ipairs(semuaPrompt) do
                    -- Pastikan prompt itu aktif dan posisinya ADA DI DALAM KEBUN KITA
                    if prompt.Enabled and prompt:IsDescendantOf(myFarm) then
                        
                        -- Mengambil wujud fisik tanaman (Sesuai script asli server)
                        local targetPlant = prompt.Parent and prompt.Parent.Parent
                        
                        if targetPlant then
                            -- SISTEM FILTER TANAMAN
                            if TargetHarvestItem and #TargetHarvestItem > 0 then
                                local namaCocok = false
                                for _, namaPilihan in ipairs(TargetHarvestItem) do
                                    -- Cek nama (diubah ke huruf kecil agar anti-typo)
                                    if string.find(string.lower(targetPlant.Name), string.lower(namaPilihan)) then
                                        namaCocok = true
                                        break
                                    end
                                end
                                
                                if namaCocok then
                                    table.insert(daftarTanaman, targetPlant)
                                end
                            else
                                -- Jika Dropdown KOSONG (tidak ada yang dicentang), panen SEMUA
                                table.insert(daftarTanaman, targetPlant)
                            end
                        end
                    end
                end
            end

            -- 3. Eksekusi Panen Massal
            -- 3. Eksekusi Panen (Pilihan Mode Sesuai Centangan UI)
            if #daftarTanaman > 0 then
                if AutoCollectKalemOn then
                    -- MODE KALEM: Eksekusi satu per satu dengan jeda 0.05 detik
                    for _, tanaman in ipairs(daftarTanaman) do
                        if not AutoCollectOn then break end -- Rem darurat kalau UI dimatikan
                        pcall(function()
                            game:GetService("ReplicatedStorage").GameEvents.Crops.Collect:FireServer({tanaman})
                        end)
                        task.wait(0.05) 
                    end
                else
                    -- MODE BRUTAL (ASLI): Tembak sekaligus semua isi tabel ke server!
                    pcall(function()
                        game:GetService("ReplicatedStorage").GameEvents.Crops.Collect:FireServer(daftarTanaman)
                    end)
                end
            end
        end
    end
end)

-- ==========================================
-- MESIN AUTO-SUBMIT CAMPFIRE EVENT (GHOST EQUIP + DEX ATTRIBUTE)
-- ==========================================
task.spawn(function()
    while task.wait(0.5) do
        if AutoSubmitOn and TargetSubmitItem and #TargetSubmitItem > 0 then
            local player = game.Players.LocalPlayer
            local character = player.Character
            local backpack = player:FindFirstChild("Backpack")
            
            if character and backpack then
                for _, namaPilihan in ipairs(TargetSubmitItem) do
                    if not AutoSubmitOn then break end
                    
                    local itemDitemukan = nil
                    
                    -- Fungsi lokal pemindai DNA Item
                    local function cekItem(item)
                        if item:IsA("Tool") and string.find(string.lower(item.Name), string.lower(namaPilihan)) then
                            -- FILTER MUTLAK: Cek atribut "b" (j = Buah, n = Seed)
                            if item:GetAttribute("b") == "j" then
                                return true
                            end
                        end
                        return false
                    end
                    
                    -- 1. Cek di tangan dulu 
                    for _, item in ipairs(character:GetChildren()) do
                        if cekItem(item) then
                            itemDitemukan = item
                            break
                        end
                    end
                    
                    -- 2. Kalau tidak ada di tangan, cari di tas (Backpack)
                    if not itemDitemukan then
                        for _, item in ipairs(backpack:GetChildren()) do
                            if cekItem(item) then
                                itemDitemukan = item
                                break
                            end
                        end
                    end
                    
                    -- 3. Jika buah murni ("j") ditemukan, eksekusi sinkronisasi
                    if itemDitemukan then
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            if itemDitemukan.Parent == backpack then
                                humanoid:EquipTool(itemDitemukan)
                            end
                            
                            -- Tunggu sampai tool benar-benar ada di Character
                            local timeout = 0
                            while itemDitemukan.Parent ~= character and timeout < 20 do
                                task.wait(0.1)
                                timeout = timeout + 1
                            end
                            
                            if itemDitemukan.Parent == character then
                                task.wait(0.5) -- Jeda ekstra memastikan ping stabil
                                
                                pcall(function()
                                    game:GetService("ReplicatedStorage").GameEvents.SummerFire.Submit:FireServer()
                                end)
                                
                                task.wait(0.8)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- ==========================================
-- BAGIAN AUTO SELL INVENTORY (TP + SELL ALL)
-- ==========================================
local SecAutoSell = TabGarden:AddSection("💰 Auto Sell Inventory", false)

-- Fungsi Utama: Teleport -> Jual -> Teleport Balik
local function EksekusiJualDanTeleport()
    local player = game.Players.LocalPlayer
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
    if hrp then
        -- 1. Rekam posisi saat ini (di kebun)
        local posisiAwal = hrp.CFrame
        
        -- Kordinat pasti NPC Jual yang kamu dapatkan
        local kordinatJual = CFrame.new(36.587677, 2.99999976, 0.426784247, -0.00114657253, -1.72207173e-08, -0.999999344, -4.84557327e-13, 1, -1.7220728e-08, 0.999999344, -1.92602583e-11, -0.00114657253)
        
        -- 2. Menghilang dan muncul di depan NPC
        hrp.CFrame = kordinatJual
        task.wait(0.4) -- Jeda sangat singkat agar server menyadari karaktermu pindah
        
        -- 3. Rampok uangnya (Jual Semua)
        pcall(function()
            game:GetService("ReplicatedStorage").GameEvents.Sell_Inventory:FireServer()
        end)
        task.wait(0.4) -- Jeda aman memastikan koin sudah masuk ke saldo
        
        -- 4. Kembali ke kebun secara gaib
        hrp.CFrame = posisiAwal
    end
end


local AutoSellInterval = SavedData.Garden.AutoSellInterval
SecAutoSell:AddInput({
    Title = "Interval Auto Sell (Detik)", 
    Content = "Jeda waktu otomatis", 
    Default = tostring(SavedData.Garden.AutoSellInterval), 
    Callback = function(Text) 
        AutoSellInterval = tonumber(Text) or 60 
        SavedData.Garden.AutoSellInterval = AutoSellInterval
        SaveSettings()
    end 
})

local AutoSellTimerOn = SavedData.Garden.AutoSellTimer
SecAutoSell:AddToggle({ 
    Title = "▶️ Auto Sell (Berdasarkan Waktu)", 
    Default = SavedData.Garden.AutoSellTimer, 
    Callback = function(Value) 
        AutoSellTimerOn = Value 
        SavedData.Garden.AutoSellTimer = Value
        SaveSettings()
    end 
})

local AutoSellFullOn = SavedData.Garden.AutoSellFull
SecAutoSell:AddToggle({ 
    Title = "▶️ Auto Sell (Saat Penuh)", 
    Default = SavedData.Garden.AutoSellFull, 
    Callback = function(Value) 
        AutoSellFullOn = Value 
        SavedData.Garden.AutoSellFull = Value
        SaveSettings()
    end 
})

-- Tombol Eksekusi Manual (Tidak perlu disave)
SecAutoSell:AddButton({ 
    Title = "💸 Cuci Gudang Sekarang (Manual)", 
    Content = "Teleport, jual, dan balik", 
    Callback = function() 
        task.spawn(EksekusiJualDanTeleport) 
        end 
})


-- ==========================================
-- MESIN LOOPING AUTO SELL
-- ==========================================
task.spawn(function()
    local timerHitung = 0
    getgenv().TasPenuh = false -- Pastikan mati saat pertama kali script jalan
    
    while task.wait(1) do
        -- 1. Eksekusi Timer Waktu
        if AutoSellTimerOn and AutoSellInterval > 0 then
            timerHitung = timerHitung + 1
            if timerHitung >= AutoSellInterval then
                EksekusiJualDanTeleport()
                timerHitung = 0 
            end
        else
            timerHitung = 0
        end
        
        -- 2. Eksekusi saat mendengar Alarm CCTV Tas Penuh
        if getgenv().TasPenuh then
            -- Nah, mesin ini mengecek apakah tombol Auto Sell di UI kamu centang?
            if AutoSellFullOn then 
                EksekusiJualDanTeleport()
                task.wait(2) -- Jeda aman
            end
            
            getgenv().TasPenuh = false -- WAJIB DIRESET MATI (Baik sedang centang UI atau tidak)
        end
    end
end)

-- ==========================================
-- 6. SISTEM ANTI-AFK & 6.5 AUTO REJOIN
-- ==========================================
LocalPlayer.Idled:Connect(function()
    if AntiAFKOn then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

task.spawn(function()
    while task.wait(5) do
        if AutoRejoinOn and AutoRejoinMenit > 0 then
            local waktuJalan = tick() - WaktuStartBot
            local targetDetik = AutoRejoinMenit * 60
            if waktuJalan >= targetDetik then
                LogPesan("🔄 [Sistem] Waktu Rejoin (" .. AutoRejoinMenit .. " Menit) telah tiba! Mencoba Reconnect...")
                task.wait(2)
                local TeleportService = game:GetService("TeleportService")
                pcall(function()
                    if #Players:GetPlayers() <= 1 then LocalPlayer:Kick("\n[FSM Bot] Rejoining Server...") task.wait() TeleportService:Teleport(game.PlaceId, LocalPlayer)
                    else TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end
                end)
                task.wait(15) 
            end
        end
    end
end)

-- ==========================================
-- FITUR AUTO RECONNECT (ANTI DC / ERROR 277)
-- ==========================================
local SecMisc = TabSetting:AddSection("🛡️ Keamanan & Jaringan", false) -- Ganti TabSetting jika kamu taruh di tab lain

local AutoReconnectOn = false
SecMisc:AddToggle({ 
    Title = "🔄 Auto Reconnect (Anti DC)", 
    Content = "Otomatis Rejoin saat kena Error 277 atau terputus", 
    Default = false, 
    Callback = function(Value) 
        AutoReconnectOn = Value 
    end 
})

-- Mesin Pendeteksi Layar Error Roblox
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")

-- Metode 1: Mendeteksi perubahan pesan error di layar
GuiService.ErrorMessageChanged:Connect(function(errorMessage)
    if AutoReconnectOn and errorMessage and errorMessage ~= "" then
        task.wait(5) -- Jeda 5 detik agar koneksi HP-mu bernapas dulu
        pcall(function()
            -- Memaksa masuk kembali ke server (JobId) yang sama persis
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
        end)
    end
end)

-- Metode 2: Pendeteksi Agresif (Membaca Pop-up UI Core Roblox)
pcall(function()
    CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
        if AutoReconnectOn and child.Name == 'ErrorPrompt' then
            task.wait(5)
            pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
            end)
        end
    end)
end)

-- ==========================================
-- 7. BOOTING & INISIALISASI AWAL (Smart Wait)
-- ==========================================
task.spawn(function()
    local timerTunggu = 0
    while timerTunggu < 15 do task.wait(1) timerTunggu = timerTunggu + 1 ScanTas() if #FavPet > 0 or #NonFav > 0 then break end end
    
    WaktuTerakhirGerak = 0 
    UpdateSemuaDropdown(true) 
    
    IsBooting = false 
    Speed_Library:SetNotification({Title = "Berhasil", Description = "Injected", Content = "FSM Bot Ultimate siap!", Time = 5})
    
    if SavedData.AutoStartFSM then print("[Sistem] Mengaktifkan kembali Mesin Utama secara otomatis!") AutoElephantOn = true FaseFarming = "TANAM" WaktuStartCycle = tick()
    elseif SavedData.AutoStartPush then print("[Sistem] Mengaktifkan kembali Mesin Push 50 secara otomatis!") AutoPush50On = true FaseFarming = "TANAM_PUSH" WaktuStartCycle = tick() end
    if SavedData.AutoStartPickPlace then print("[Sistem] Mengaktifkan kembali Pick & Place secara otomatis!") AutoPickPlaceOn = true end
    if SavedData.AutoStartRejoin then print("[Sistem] Mengaktifkan kembali Auto Rejoin secara otomatis!") AutoRejoinOn = true end
    if SavedData.Garden.AutoCollect then print("[Sistem] Auto Collect menyala!") AutoCollectOn = true end
    if SavedData.Campfire.AutoSubmit then print("[Sistem] Ghost Submit menyala!") AutoSubmitOn = true end
    if SavedData.Campfire.AutoCraft then print("[Sistem] Craft Manager menyala!") AutoCraftManagerOn = true end
end)
