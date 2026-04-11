extends "res://Scripts/LootContainer.gd"

const SPAWN_MAG = 1
const JOKER = 0

const AMMO_AMOUNT_DEFAULT = false  # true = game default amounts, false = use ranges below
const AMMO_MIN = 1                 # min loose ammo per stack (1-50)
const AMMO_MAX = 5                # max loose ammo per stack (1-50)
const MAG_AMMO_MIN = 0             # min ammo inside spawned magazine (0-50)
const MAG_AMMO_MAX = 5            # max ammo inside spawned magazine (0-50), capped at magazine capacity

func _ready():
	if JOKER == 1:
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
	super(weaponData.ammo)
	if not AMMO_AMOUNT_DEFAULT:
		loot.back().amount = randi_range(AMMO_MIN, AMMO_MAX)
	if SPAWN_MAG == 0:
		return
	for compatible_item in weaponData.compatible:
		if compatible_item.subtype == "Magazine":
			super(compatible_item)
			if not AMMO_AMOUNT_DEFAULT:
				loot.back().amount = min(randi_range(MAG_AMMO_MIN, MAG_AMMO_MAX), weaponData.magazineSize)
			break
