extends "res://Scripts/LootSimulation.gd"

var modSettings = preload("res://mods/scripts/ModSettings.tres")

# After the vanilla SpawnItems runs, spawn ammo and magazine for every weapon that was placed.
func SpawnItems():
	var children_before = get_children()
	super()

	# Reposition weapon pickups added by super so they stay within 1m of our origin
	for child in get_children():
		if child in children_before:
			continue
		if child is RigidBody3D:
			child.position = Vector3(randf_range(-1.0, 1.0), 0.1, randf_range(-1.0, 1.0))
			child.linear_velocity = Vector3.ZERO

	if not modSettings.spawn_ammo and not modSettings.spawn_mag:
		return

	for itemData in loot:
		if itemData.type != "Weapon":
			continue
		var weaponData: WeaponData = itemData as WeaponData
		if weaponData == null or weaponData.ammo == null:
			continue

		if modSettings.spawn_ammo:
			var ammoItem: ItemData = weaponData.ammo
			if ammoItem.file == "":
				continue
			var ammoScene = Database.get(ammoItem.file)
			if ammoScene == null:
				print("[WeaponAmmoSpawner] Ammo scene not found: " + ammoItem.file)
				continue
			var ammoPickup = ammoScene.instantiate()
			add_child(ammoPickup)
			ammoPickup.position = Vector3(randf_range(-1.0, 1.0), 0.1, randf_range(-1.0, 1.0))
			ammoPickup.Unfreeze()
			ammoPickup.linear_velocity = Vector3.ZERO
			var newSlotData = SlotData.new()
			newSlotData.itemData = ammoItem
			if modSettings.use_custom_amounts:
				newSlotData.amount = randi_range(modSettings.ammo_min, modSettings.ammo_max)
			else:
				if ammoItem.defaultAmount != 0:
					newSlotData.amount = randi_range(1, ammoItem.defaultAmount)
			if Simulation.season == 2 and ammoItem.freezable:
				if randi_range(0, 100) < 10:
					newSlotData.state = "Frozen"
			ammoPickup.slotData = newSlotData

		if not modSettings.spawn_mag:
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
				magPickup.position = Vector3(randf_range(-1.0, 1.0), 0.1, randf_range(-1.0, 1.0))
				magPickup.Unfreeze()
				magPickup.linear_velocity = Vector3.ZERO
				var magSlotData = SlotData.new()
				magSlotData.itemData = compatible_item
				if modSettings.use_custom_amounts:
					magSlotData.amount = min(randi_range(modSettings.mag_ammo_min, modSettings.mag_ammo_max), weaponData.magazineSize)
				else:
					if compatible_item.defaultAmount != 0:
						magSlotData.amount = randi_range(1, compatible_item.defaultAmount)
				magPickup.slotData = magSlotData
				break
