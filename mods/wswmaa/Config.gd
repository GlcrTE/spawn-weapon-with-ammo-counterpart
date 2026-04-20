extends Node

var modSettings = preload("res://mods/wswmaa/ModSettings.tres")
var McmHelpers = load("res://ModConfigurationMenu/Scripts/Doink Oink/MCM_Helpers.tres")

const FILE_PATH = "user://MCM/WeaponAmmoSpawner"
const MOD_ID = "WeaponAmmoSpawner"
const MOD_VERSION = "0.3.0"

func _ready() -> void:
	var config = ConfigFile.new()

	config.set_value("Meta", "mod_version", MOD_VERSION)

	config.set_value("Bool", "spawn_ammo", {
		"name" = "Spawn Ammo",
		"tooltip" = "When enabled, loose ammo matching the weapon's caliber is added to the container alongside any spawned weapon.",
		"default" = true,
		"value" = true,
		"menu_pos" = 1
	})

	config.set_value("Bool", "spawn_mag", {
		"name" = "Spawn Magazine",
		"tooltip" = "When enabled, a compatible magazine is added to the container alongside any spawned weapon.",
		"default" = true,
		"value" = true,
		"menu_pos" = 2
	})

	config.set_value("Bool", "random_spawn", {
		"name" = "Randomize Spawns",
		"tooltip" = "When enabled, each enabled item (ammo and magazine) has a random chance to spawn instead of always spawning. Chance is controlled by the sliders below.",
		"default" = false,
		"value" = false,
		"menu_pos" = 3
	})

	config.set_value("Int", "ammo_chance", {
		"name" = "Ammo Spawn Chance (%)",
		"tooltip" = "Percentage chance that loose ammo spawns with the weapon. Only applies when Randomize Spawns and Spawn Ammo are both enabled.",
		"default" = 50,
		"value" = 50,
		"menu_pos" = 4,
		"minRange" = 0,
		"maxRange" = 100
	})

	config.set_value("Int", "mag_chance", {
		"name" = "Magazine Spawn Chance (%)",
		"tooltip" = "Percentage chance that a magazine spawns with the weapon. Only applies when Randomize Spawns and Spawn Magazine are both enabled.",
		"default" = 50,
		"value" = 50,
		"menu_pos" = 5,
		"minRange" = 0,
		"maxRange" = 100
	})

	config.set_value("Bool", "use_custom_amounts", {
		"name" = "Use Custom Ammo Amounts",
		"tooltip" = "When enabled, ammo and magazine fill amounts are controlled by the min/max ranges below. When disabled, the game's default amounts are used instead.",
		"default" = true,
		"value" = true,
		"menu_pos" = 6
	})

	config.set_value("Int", "ammo_min", {
		"name" = "Loose Ammo Min",
		"tooltip" = "Minimum number of loose ammo rounds spawned per stack. Only applies when Use Custom Ammo Amounts is enabled.",
		"default" = 1,
		"value" = 1,
		"menu_pos" = 7,
		"minRange" = 1,
		"maxRange" = 50
	})

	config.set_value("Int", "ammo_max", {
		"name" = "Loose Ammo Max",
		"tooltip" = "Maximum number of loose ammo rounds spawned per stack. Only applies when Use Custom Ammo Amounts is enabled.",
		"default" = 5,
		"value" = 5,
		"menu_pos" = 8,
		"minRange" = 1,
		"maxRange" = 50
	})

	config.set_value("Int", "mag_ammo_min", {
		"name" = "Magazine Fill Min",
		"tooltip" = "Minimum number of rounds loaded into a spawned magazine. Only applies when Use Custom Ammo Amounts is enabled.",
		"default" = 0,
		"value" = 0,
		"menu_pos" = 9,
		"minRange" = 0,
		"maxRange" = 50
	})

	config.set_value("Int", "mag_ammo_max", {
		"name" = "Magazine Fill Max",
		"tooltip" = "Maximum number of rounds loaded into a spawned magazine, capped at the weapon's magazine capacity. Only applies when Use Custom Ammo Amounts is enabled.",
		"default" = 5,
		"value" = 5,
		"menu_pos" = 10,
		"minRange" = 0,
		"maxRange" = 50
	})

	config.set_value("Bool", "joker_debug", {
		"name" = "Joker Debug Mode",
		"tooltip" = "Enables the Joker debug flag on LootContainers. Intended for development and testing only.",
		"default" = false,
		"value" = false,
		"menu_pos" = 11
	})

	if !FileAccess.file_exists(FILE_PATH + "/config.ini"):
		DirAccess.open("user://").make_dir_recursive(FILE_PATH)
		config.save(FILE_PATH + "/config.ini")
	else:
		if McmHelpers != null:
			McmHelpers.CheckConfigurationHasUpdated(MOD_ID, config, FILE_PATH + "/config.ini")
		config.load(FILE_PATH + "/config.ini")

	_on_config_updated(config)

	if McmHelpers != null:
		McmHelpers.RegisterConfiguration(
			MOD_ID,
			"Weapons Spawn with Mag and Ammo",
			FILE_PATH,
			"Controls ammo and magazine spawning alongside weapons found in loot containers.",
			{
				"config.ini" = _on_config_updated
			}
		)

func _on_config_updated(config: ConfigFile) -> void:
	modSettings.spawn_ammo = config.get_value("Bool", "spawn_ammo")["value"]
	modSettings.spawn_mag = config.get_value("Bool", "spawn_mag")["value"]
	modSettings.random_spawn = config.get_value("Bool", "random_spawn")["value"]
	modSettings.ammo_chance = config.get_value("Int", "ammo_chance")["value"]
	modSettings.mag_chance = config.get_value("Int", "mag_chance")["value"]
	modSettings.use_custom_amounts = config.get_value("Bool", "use_custom_amounts")["value"]
	modSettings.ammo_min = config.get_value("Int", "ammo_min")["value"]
	modSettings.ammo_max = config.get_value("Int", "ammo_max")["value"]
	modSettings.mag_ammo_min = config.get_value("Int", "mag_ammo_min")["value"]
	modSettings.mag_ammo_max = config.get_value("Int", "mag_ammo_max")["value"]
	modSettings.joker_debug = config.get_value("Bool", "joker_debug")["value"]
