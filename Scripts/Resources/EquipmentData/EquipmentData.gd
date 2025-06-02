class_name EquipmentData
extends Resource


@export var equipment_scene : PackedScene
@export var equipment_name : String
@export var type : Equipment.EquipmentType = Equipment.EquipmentType.WEAPON
@export var tier : Equipment.EquipmentTier = Equipment.EquipmentTier.ONE
@export var string_id : String
@export_multiline var equipment_description : String
@export_multiline var equipment_details : String
@export var equipment_icon : Texture2D
@export var buy_cost : float
@export var sell_value : float 
