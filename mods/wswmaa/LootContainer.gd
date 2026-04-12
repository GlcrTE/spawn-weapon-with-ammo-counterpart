extends "res://Scripts/LootContainer.gd"

var modSettings = preload("res://mods/wswmaa/ModSettings.tres")

func _ready():
	if modSettings.joker_debug:
		joker = true
	super()

# After adding a weapon to the container loot, also add its matching ammo and magazine.
func CreateLoot(item: ItemData):
	super(item)
	if item.type != "Weapon":
		return
	var weaponData: WeaponData = item as WeaponData
	if weaponData == null or weaponData.ammo == null:
		return
	if modSettings.spawn_ammo:
		super(weaponData.ammo)
		if modSettings.use_custom_amounts:
			loot.back().amount = randi_range(modSettings.ammo_min, modSettings.ammo_max)
	if not modSettings.spawn_mag:
		return
	for compatible_item in weaponData.compatible:
		if compatible_item.subtype == "Magazine":
			super(compatible_item)
			if modSettings.use_custom_amounts:
				loot.back().amount = min(randi_range(modSettings.mag_ammo_min, modSettings.mag_ammo_max), weaponData.magazineSize)
			break
