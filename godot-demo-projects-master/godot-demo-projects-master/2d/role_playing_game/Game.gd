extends Node

@export var combat_screen: NodePath
@export var exploration_screen: NodePath

const PLAYER_WIN = "res://dialogue/dialogue_data/player_won.json"
const PLAYER_LOSE = "res://dialogue/dialogue_data/player_lose.json"

func _ready():
	exploration_screen = get_node(exploration_screen)
	combat_screen = get_node(combat_screen)
	combat_screen.combat_finished.connect(self._on_combat_finished)
	for n in $Exploration/Grid.get_children():
		if not n.type == n.CellType.ACTOR:
			continue
		if not n.has_node("DialoguePlayer"):
			continue
		n.get_node(^"DialoguePlayer").dialogue_finished.connect(self._on_opponent_dialogue_finished.bind(n))
	remove_child(combat_screen)


func start_combat(combat_actors):
	remove_child($Exploration)
	$AnimationPlayer.play("fade")
	await $AnimationPlayer.animation_finished
	add_child(combat_screen)
	combat_screen.show()
	combat_screen.initialize(combat_actors)
	$AnimationPlayer.play_backwards("fade")


func _on_opponent_dialogue_finished(opponent):
	if opponent.lost:
		return
	var player = $Exploration/Grid/Player
	var combatants = [player.combat_actor, opponent.combat_actor]
	start_combat(combatants)


func _on_combat_finished(winner, _loser):
	remove_child(combat_screen)
	$AnimationPlayer.play_backwards("fade")
	add_child(exploration_screen)
	var dialogue = load("res://dialogue/dialogue_player/DialoguePlayer.tscn").instantiate()
	if winner.name == "Player":
		dialogue.dialogue_file = PLAYER_WIN
	else:
		dialogue.dialogue_file = PLAYER_LOSE
	await $AnimationPlayer.animation_finished
	var player = $Exploration/Grid/Player
	exploration_screen.get_node(^"DialogueUI").show_dialogue(player, dialogue)
	combat_screen.clear_combat()
	await dialogue.dialogue_finished
	dialogue.queue_free()
