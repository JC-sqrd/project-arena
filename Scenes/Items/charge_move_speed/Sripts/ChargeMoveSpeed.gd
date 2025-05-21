extends Item

@export var charge_threshold : float = 500000
@export var bonus_damage : Stat
@export var hit_listener : HitListener
@export var charge_particle_system : GPUParticles2D
var charge : float = 0
var charged : bool = false

func _ready():
	item_equipped.connect(_on_item_equipped)
	pass

func _on_item_equipped():
	#actor.applied_damage_with_data.connect(_on_actor_applied_damage_with_data)
	actor.damage_data_created.connect(_on_actor_damage_data_created)
	charge_particle_system.visible = false
	charge_particle_system.reparent(actor, false)
	pass


func _process(delta: float) -> void:
	if actor.velocity.length() > 0:
		charge += actor.velocity.length() * delta
	if charge >= charge_threshold and !charged:
		charge_particle_system.visible = true
		charged = true


func _on_actor_applied_damage_with_data(damage_data : Dictionary):
	if charged and hit_listener != null:
		charged = false
		charge = 0
		charge_particle_system.visible = false
		var hit_data : Dictionary = hit_listener.generate_effect_data()
		hit_data["target"] = damage_data["target"]
		hit_data["source"] = self
		hit_data["actor"] = damage_data["actor"]
		(damage_data["target"] as Entity).on_hit.emit(hit_data)
		pass
	pass

func _on_actor_damage_data_created(damage_data : DamageEffectData):
	if charged and hit_listener != null:
		charged = false
		charge = 0
		charge_particle_system.visible = false
		#print("DAMAGE EFFECT DAMAGE VALUE: " + str(damage_data.damage))
		damage_data.damage += bonus_damage.stat_derived_value
	pass


#func _on_actor_damage_data_created(damage_data : Dictionary):
	#if charged and hit_listener != null:
		#charged = false
		#charge = 0
		#charge_particle_system.visible = false
		#damage_data["damage"] += bonus_damage.stat_derived_value
	#pass
