extends Node


var _current_scene: Node
var _current_overlay: Node
var _scene_registry = {
	"main_menu": preload("res://scenes/game/main_menu.tscn"),
	"game_over_menu": preload("res://scenes/game/game_over_menu.tscn"),
	"game": preload("res://scenes/game/game.tscn"),
}

func _get_registered_scene(scene_name: String) -> PackedScene:
	return _scene_registry[scene_name] as PackedScene

func set_current_scene(scene_name: String) -> void:
	if _current_scene:
		_current_scene.free.call_deferred()
		_current_scene = null
	await get_tree().process_frame
	
	_current_scene = _get_registered_scene(scene_name).instantiate()
	add_child.call_deferred(_current_scene)

func show_overlay(scene_name: String) -> void:
	if _current_overlay:
		_current_overlay.free.call_deferred()
		_current_overlay = null
	await get_tree().process_frame
	
	_current_overlay = CanvasLayer.new()
	_current_scene.add_child.call_deferred(_current_overlay)
	await get_tree().process_frame
	
	_current_overlay.add_child.call_deferred(
		_get_registered_scene(scene_name).instantiate())

func hide_overlay() -> void:
	if _current_overlay:
		_current_overlay.free.call_deferred()
		_current_overlay = null
