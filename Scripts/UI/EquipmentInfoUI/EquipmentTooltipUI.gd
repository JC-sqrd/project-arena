class_name EquipmentTooltipUI
extends Control

@onready var tooltip_container: HBoxContainer = %TooltipContainer
@onready var equipment_inventory_slot_icon: EquipmentInventorySlotIcon = %EquipmentInventorySlotIcon
@onready var equipment_name_label: RichTextLabel = %EquipmentNameLabel
@onready var v_box_container: VBoxContainer = $Panel/VBoxContainer
#@onready var stat_v_box_container: VBoxContainer = %StatVBoxContainer
@onready var equipment_tier_ui: EquipmentTierUI = %EquipmentTierUI
@onready var stat_name_container: VBoxContainer = %StatNameContainer
@onready var stat_value_container: VBoxContainer = %StatValueContainer

const ABILITY_TOOLTIP = preload("res://Scenes/UI/AbilityIcons/ability_tooltip.tscn")

func initialize_equipment_tooltip(equipment : Equipment):
	await self.ready
	equipment_inventory_slot_icon.set_equipment(equipment)
	equipment_tier_ui.set_tier(equipment.tier)
	equipment_name_label.text = equipment.equipment_name
	
	if equipment is Weapon and (equipment as Weapon).weapon_ability != null:
		var weapon_ability_tooltip : AbilityTooltip = ABILITY_TOOLTIP.instantiate() as AbilityTooltip
		weapon_ability_tooltip.initialize_ability_tooltip(equipment.weapon_ability)
		tooltip_container.add_child(weapon_ability_tooltip)
	
	for stat in equipment.tooltip_stats:
		var stat_label : Label = Label.new()
		var stat_value_label : Label = Label.new()
		
		stat_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		stat_value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		
		stat_label.modulate = Color.GRAY
		match stat.formatter.prefix:
			stat.formatter.FormatPrefix.NONE:
				stat_value_label.modulate = Color.WHITE
			stat.formatter.FormatPrefix.ADDITIVE:
				stat_value_label.modulate = Color.GREEN
			stat.formatter.FormatPrefix.SUBTRACTIVE:
				stat_value_label.modulate = Color.RED
			_:
				stat_value_label.modulate = Color.WHITE
		
		
		stat_label.text = stat.name 
		stat_value_label.text = stat.formatter.get_formatted_stat_text(stat)#str(stat.stat_derived_value)
		
		stat_name_container.add_child(stat_label)
		stat_value_container.add_child(stat_value_label)
		#stat_v_box_container.add_child(stat_label)
	pass
