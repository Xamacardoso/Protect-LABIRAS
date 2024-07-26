extends Node2D

# dicionário de cenas de inimigos
var enemies : Dictionary = {
	"porco"            : preload("res://scenes/enemies/porco.tscn"),
	"preguica"         : preload("res://scenes/enemies/preguica.tscn"),
	"café"             : preload("res://scenes/enemies/café.tscn"),
	"prostiranha"      : preload("res://scenes/enemies/prostiranha.tscn"),
	"corrupto"         : preload("res://scenes/enemies/corrupto.tscn"),
	"amostradinho"     : preload("res://scenes/enemies/amostradinho.tscn"),
	"agiota"           : preload("res://scenes/enemies/agiota.tscn"),
	"covid20"          : preload("res://scenes/enemies/covid20.tscn"),
	"homemdascavernas" : preload("res://scenes/enemies/homemdascavernas.tscn"),
	"formiga"          : preload("res://scenes/enemies/formiga.tscn"),
	"carteira"         : preload("res://scenes/enemies/carteira.tscn"),
}

@onready var top = $Top
@onready var bottom = $Bottom
@onready var spawn_timer = get_node("SpawnTimer");

func _ready():
	Global.levelNode = self;
	move_camera_to_place();

func _process(delta) -> void:
	stop_spawn_timer();

## função para pausar o timer quando a quantidade de inimigos instanciados cheagr ao limite
func stop_spawn_timer() -> void:
	#verificando se ja foram instanciados todos inimigos da wave atual
	if Global.enemies_already_instatiated == Global.max_enemy_per_wave:
		spawn_timer.stop();

func _get_random_position() -> Vector2:
	return Vector2(top.global_position.x, randf_range(top.global_position.y, bottom.global_position.y))
	
## função para spawnar inimigos
func _on_spawn_timer_timeout():
	# array de keys do dicionionário de inimigos
	var _keys_enemies = enemies.keys();
	# seleciona um indice aleatório no array de chaves de inimigos
	var _enemy = randi_range(0, _keys_enemies.size() - 1);
	# guarda instancia de um inimigo aleatório selecionado 
	var enemy_instance = enemies.get(_keys_enemies[_enemy]).instantiate();
	# define a posição aleatória de nascimento do inimigo
	enemy_instance.global_position = _get_random_position()
	# adiciona com a instância como filha
	add_child(enemy_instance)
	# verifica se a wave minima do inimigo instanciado esta de acordo com a wave atual
	if Global.enemyNode.wave_min <= Global.current_wave:
		var nodes = get_tree().get_nodes_in_group("spawn")
		var node = nodes[randi() % nodes.size()]
		Global.enemies_already_instatiated += 1;     # incrementa a quantiade de inimigos instanciados
		return
	# caso não estja, remove o inimigo da cena
	Global.enemyNode.queue_free();
	# e repete todo o processo até que instancie um inimigo que possue wave minima menor ou igual a atual wave
	_on_spawn_timer_timeout();

func move_camera_to_place():
	$CanvasLayer/TextureRect.global_position = Vector2(0 ,-480);
	$Camera2D.zoom = Vector2(1.0,1.0);
	$Camera2D.position = Vector2(-480.0,270.0);
	var _bgTween = get_tree().create_tween();
	var _cameraPosTween = get_tree().create_tween();
	var _cameraZoomTween = get_tree().create_tween();
	_cameraZoomTween.tween_property($Camera2D, "zoom", Vector2(0.67,0.67), 3).set_trans(Tween.TRANS_QUART);
	_cameraPosTween.tween_property($Camera2D, "position", Vector2(654, 140), 3).set_trans(Tween.TRANS_QUART);
	_bgTween = _bgTween.tween_property($CanvasLayer/TextureRect, "position", Vector2(-480,-540), 3).set_trans(Tween.TRANS_QUART);
	

