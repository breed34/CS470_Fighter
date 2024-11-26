class_name Ninja
extends Fighter

@export var ninja_variant: Enums.NinjaVariant
@export var mesh_instance: MeshInstance3D
@export var punch_damage: float
@export var kick_damage: float
@export var punch_cooldown: float
@export var kick_cooldown: float

func _ready() -> void:
	super.set_attacks([
		Attack.from("punch", punch_cooldown, punch_area, punch_damage),
		Attack.from("kick", kick_cooldown, kick_area, kick_damage),
	])
	
	var mat = mesh_instance.mesh.surface_get_material(0) as StandardMaterial3D
	if (ninja_variant == Enums.NinjaVariant.RED):
		mat.albedo_texture = load("res://assets/characters/ninja/textures/Ch24_1001_Red_Diffuse.png")
	
	mesh_instance.mesh.surface_set_material(0, mat)
	super._ready()
