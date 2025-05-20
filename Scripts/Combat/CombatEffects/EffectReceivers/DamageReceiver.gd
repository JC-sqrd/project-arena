class_name DamageReceiver
extends EffectReceiver

#@export var damage_listener : DamageListener


func _ready():
	pass

func receive_effect(data : Dictionary):
	#var damage_received : float = 0
	#var target : Entity = data["target"] as Entity
	#var actor : Entity
	#if data["actor"] != null:
		#actor = data["actor"] as Entity
	##var hit_data : Dictionary = data
	#if data.has("damage_effect") and data.has("source"):
		#var damage_data : Dictionary = data["damage_effect"]
		#damage_data["target"] = data["target"]
		#damage_data["source"] = data["source"]
		#damage_data["actor"] = data["actor"]
		#
		#if damage_data.has("checks"):
			#for check in damage_data["checks"]:
				#if check is BonusValueCondition:
					#if check.condition_met(data):
						#damage_data["damage"] += check.calculate_bonus_value(damage_data)#check.get_bonus_value()
						#pass
			#pass
		##Apply damage
		#damage_received = target.damage_listener.apply_mitigation_effects(damage_data)
		#damage_data["total_damage"] = damage_received
		#
		#if damage_data.has("lifesteal"):
			#var lifesteal_effect = damage_data["lifesteal"] as DamageReceiver.Lifesteal
			#lifesteal_effect.lifesteal(data, damage_data)
			#
		#if damage_data.has("critical"):
			#if damage_data["critical"]:
				#actor.critical_striked.emit(data)
		#
		##owner.take_damage(damage_data)
		##print("Damage source: " + str(damage_data["source"]))
		#target.took_damage.emit(damage_received)
		#target.took_damage_with_type.emit(damage_received, damage_data["damage_type"])
		#target.took_damage_with_data.emit(damage_data)
		#if actor != null:
			#actor.applied_damage_with_data.emit(damage_data)
	var damage_received : float = 0
	var target : Entity = data["target"] as Entity
	var actor : Entity
	var bonus_damage : float = 0
	if data["actor"] != null:
		actor = data["actor"] as Entity
	#var hit_data : Dictionary = data
	if data != null and data.has("damage_effect") and data.has("source"):
		var damage_data : DamageEffectData = data["damage_effect"]
		damage_data.target = data["target"]
		damage_data.source = data["source"]
		if data["actor"] != null:
			damage_data.actor = data["actor"]
		
		for check in damage_data.checks:
			if check is BonusValueCondition:
				if check.condition_met(data):
					bonus_damage += check.calculate_bonus_value(damage_data)#check.get_bonus_value()
					pass
			pass
		damage_data.damage += bonus_damage
		#Apply damage
		print("DAMAGE EFFECT DAMAGE RECIEVED: " + str(bonus_damage))
		damage_received = target.damage_listener.apply_mitigation_effects(damage_data)
		damage_data.total_damage = damage_received
		damage_data.damage -= bonus_damage
		
		if damage_data.is_lifesteal:
			var lifesteal_effect : DamageReceiver.Lifesteal = damage_data.lifesteal 
			lifesteal_effect.lifesteal(data, damage_data)
			
		if damage_data.critical:
			actor.critical_striked.emit(data)
		
		#owner.take_damage(damage_data)
		#print("Damage source: " + str(damage_data["source"]))
		target.took_damage.emit(damage_received)
		target.took_damage_with_type.emit(damage_received, damage_data.damage_type)
		target.took_damage_with_data.emit(damage_data)
		if actor != null:
			actor.applied_damage_with_data.emit(damage_data)
		damage_data.recieved = true
	pass


class Lifesteal:
	var percentage : float = 0
	var lifesteal_type : Enums.DamageType = Enums.DamageType.PHYSICAL
	
	func _init(percentage : float, lifesteal_type : Enums.DamageType):
		self.percentage = percentage
		self.lifesteal_type = lifesteal_type
		pass
	
	func lifesteal(hit_data : Dictionary, damage_data : DamageEffectData):
		if hit_data["actor"] != null:
			var actor : Entity = hit_data.get("actor") as Entity
			actor.heal(_create_heal_data(hit_data, damage_data.damage * percentage))
		pass
	
	func _create_heal_data(hit_data : Dictionary, heal_amount : float):
		var heal_data : Dictionary
		heal_data["source"] = hit_data.get("source")
		heal_data["heal_amount"] = heal_amount 
		heal_data["type"] = lifesteal_type 
		return heal_data
	
	func _to_string():
		return "lifesteal_percent: " + str(percentage) 
