extends "res://Scripts/LootContainer.gd"

# After adding a weapon to the container loot, also add its matching ammo.
func CreateLoot(item: ItemData):
	super(item)
	if item.type != "Weapon":
		return
	var weaponData: WeaponData = item as WeaponData
	if weaponData == null or weaponData.ammo == null:
		return
	super(weaponData.ammo)
