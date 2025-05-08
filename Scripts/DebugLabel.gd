extends Control

@export var player_character : PlayerCharacter
@export var stats_manager : StatManager
@export var level_manager : LevelManager
@export var strength_label : Label
@export var vitality_label : Label
@export var magic_label : Label
@export var ad_label : Label
@export var md_label : Label
@export var as_label : Label
@export var ms_label : Label
@export var ar_label : Label
@export var mr_label : Label
@export var crit_label : Label
@export var arp_label : Label
@export var mp_label : Label
@export var ls_label : Label
@export var level_label : Label
@export var fps_label : Label
@export var level_bar : TextureProgressBar

var old_exp : float

var strength_value : float

func _ready():
	if player_character != null:
		player_character.stat_manager.stat_manager_ready.connect(
			func(): 
				stats_manager = player_character.stat_manager
		)
	if level_manager != null:
		old_exp = level_manager.current_exp
		level_bar.value = level_manager.current_exp
	#stats_manager = player_character.stat_manager
	
	pass

func _process(delta):
	if strength_label != null:
		if stats_manager.get_stat("strength") != null:
			strength_label.text = "STRENGTH: " + str(floor(stats_manager.stats["strength"].stat_derived_value))
	if vitality_label != null:
		if stats_manager.get_stat("vitality") != null:
			vitality_label.text = "VITALITY: " + str(floor(stats_manager.stats["vitality"].stat_derived_value))
	if magic_label != null:
		if stats_manager.get_stat("magic") != null:
			magic_label.text = "MAGIC: " + str(floor(stats_manager.stats["magic"].stat_derived_value))
	if ad_label != null:
		if stats_manager.get_stat("attack_damage") != null:
			ad_label.text = "ATTACK DAMAGE: " + str(floor(stats_manager.stats["attack_damage_mult"].stat_derived_value))
	if md_label != null:
		if stats_manager.get_stat("magic_damage") != null:
			md_label.text = "MAGIC DAMAGE: " + str(floor(stats_manager.stats["magic_damage_mult"].stat_derived_value))
	if as_label != null:
		if stats_manager.get_stat("attack_speed_mult") != null:
			as_label.text = "ATTACK SPEED: " + str(snapped(stats_manager.stats["attack_speed_mult"].stat_derived_value, 0.01))
	if ms_label != null:
		if stats_manager.get_stat("move_speed") != null:
			ms_label.text = "MOVE SPEED: " + str(floor(stats_manager.stats["move_speed"].stat_derived_value))
	if ar_label != null:
		if stats_manager.get_stat("armor") != null:
			ar_label.text = "ARMOR: " + str(floor(stats_manager.stats["armor"].stat_derived_value))
	if mr_label != null:
		if stats_manager.get_stat("magic_resist") != null:
			mr_label.text = "MAGIC RESIST: " + str(floor(stats_manager.stats["magic_resist"].stat_derived_value))
	if crit_label != null:
		if stats_manager.get_stat("crit_chance") != null:
			crit_label.text = "CRIT CHANCE: " + str((stats_manager.stats["crit_chance"].stat_derived_value) * 100) + "%"
	if arp_label != null:
		if stats_manager.get_stat("armor_pen") != null:
			arp_label.text = "ARMOR PEN: " + str((stats_manager.stats["armor_pen"].stat_derived_value) * 100) + "%"
	if mp_label != null:
		if stats_manager.get_stat("magic_pen") != null:
			mp_label.text = "MAGIC PEN: " + str((stats_manager.stats["magic_pen"].stat_derived_value) * 100) + "%" 
	if ls_label != null:
		if stats_manager.get_stat("lifesteal") != null:
			ls_label.text = "LIFESTEAL: " + str((stats_manager.stats["lifesteal"].stat_derived_value) * 100) + "%"
	if fps_label != null:
		fps_label.text = "FPS: " + str(Engine.get_frames_per_second())
	
	if level_manager != null:
		if level_bar != null:
			level_bar.max_value = level_manager.exp_to_level
			#level_bar.value = lerp(level_manager.current_exp, level_manager.current_exp, 0.2)
			level_bar.value = old_exp
		if level_label != null:
			level_label.text = str(level_manager.current_level)
	
	if level_manager != null and old_exp != level_manager.current_exp:
		old_exp = clampf(lerp(old_exp, level_manager.current_exp + 0.2, 0.1), 0, level_manager.current_exp)
