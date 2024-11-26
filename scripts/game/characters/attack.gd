class_name Attack
extends Node


var attack_name: String
var cooldown: float
var area: Area3D
var damage: float

static func from(
	attack_name: String,
	cooldown: float,
	area: Area3D,
	damage: float,
) -> Attack:
	var att = Attack.new()
	att.attack_name = attack_name
	att.cooldown = cooldown
	att.area = area
	att.damage = damage
	return att
