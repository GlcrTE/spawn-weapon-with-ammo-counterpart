extends "res://Scripts/LootContainer.gd"

const SPAWN_MAG = 1
# After adding a weapon to the container loot, also add its matching ammo and magazine.
func CreateLoot(item: ItemData):
	super(item)
	if item.type != "Weapon":
		return
	var weaponData: WeaponData = item as WeaponData
	if weaponData == null or weaponData.ammo == null:
		return
	super(weaponData.ammo)
	if SPAWN_MAG == 0:
		return
	for compatible_item in weaponData.compatible:
		if compatible_item.subtype == "Magazine":
			super(compatible_item)
			break
