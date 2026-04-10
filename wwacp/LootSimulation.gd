extends "res://Scripts/LootSimulation.gd"

const SPAWN_MAG = 1

# After the vanilla SpawnItems runs, spawn ammo and magazine for every weapon that was placed.
func SpawnItems():
	super()
	for itemData in loot:
		if itemData.type != "Weapon":
			continue
		var weaponData: WeaponData = itemData as WeaponData
		if weaponData == null or weaponData.ammo == null:
			continue
		var ammoItem: ItemData = weaponData.ammo
		if ammoItem.file == "":
			continue
		var ammoScene = Database.get(ammoItem.file)
		if ammoScene == null:
			print("[WeaponAmmoSpawner] Ammo scene not found: " + ammoItem.file)
			continue
		var ammoPickup = ammoScene.instantiate()
		add_child(ammoPickup)
		var dropDir = Vector3(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
		ammoPickup.Unfreeze()
		ammoPickup.linear_velocity = dropDir * 10.0
		var newSlotData = SlotData.new()
		newSlotData.itemData = ammoItem
		if ammoItem.defaultAmount != 0:
			newSlotData.amount = randi_range(1, ammoItem.defaultAmount)
		if Simulation.season == 2 and ammoItem.freezable:
			if randi_range(0, 100) < 10:
				newSlotData.state = "Frozen"
		ammoPickup.slotData = newSlotData
		if SPAWN_MAG == 0:
			continue
		for compatible_item in weaponData.compatible:
			if compatible_item.subtype == "Magazine":
				if compatible_item.file == "":
					break
				var magScene = Database.get(compatible_item.file)
				if magScene == null:
					print("[WeaponAmmoSpawner] Magazine scene not found: " + compatible_item.file)
					break
				var magPickup = magScene.instantiate()
				add_child(magPickup)
				var magDropDir = Vector3(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
				magPickup.Unfreeze()
				magPickup.linear_velocity = magDropDir * 10.0
				var magSlotData = SlotData.new()
				magSlotData.itemData = compatible_item
				magPickup.slotData = magSlotData
				break
