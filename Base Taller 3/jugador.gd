extends CharacterBody2D
# Movimiento resuelto: avanza solo y salta mientras se mantenga la tecla. El Taller 3 se escribe abajo.

@export var speed = 300.0       # px/s hacia la derecha
@export var gravedad = 2400.0   # px/s²
@export var salto = 820.0       # px/s hacia arriba
@export var giro = 300
@export var meta_x = 4000 # Posicion de la meta en x

@onready var sprite = $AnimatedSprite2D
@onready var musica= $Musica 
@onready  var explosion = $Explosion

var impirmir = false
var inicio = Vector2.ZERO
var muriendo = false
var intentos = 1



func _physics_process(delta):
	mover(delta)
	girar(delta)
	if muriendo: return
	if is_on_wall(): morir()
	
func mover(delta):
	velocity.x = speed
	if is_on_floor():
		if Input.is_action_pressed("saltar"):
			velocity.y = -salto
	else:
		velocity.y += gravedad * delta
	move_and_slide()
	
func girar (delta):
	if not is_on_floor():
		sprite.rotation += deg_to_rad(giro) * delta
		impirmir = false
	else: 
		sprite.rotation = snappedf(sprite.rotation, PI / 2)
		if not impirmir:
			print(rad_to_deg(sprite.rotation))
			impirmir = true
func  _ready():
	musica.play()

func progreso() ->int : 
	var porcentaje = ((global_position.x - inicio.x)/(meta_x-inicio.x))* 100
	return int(clamp (porcentaje, 0, 100))

func morir():
	muriendo = true
	print("Intento ", intentos, ": ", progreso(), " %")
	velocity = Vector2.ZERO
	
	
	musica.stop()
	sprite.rotation = 0
	sprite.play("explotar")
	explosion.play()
	
	
	await  sprite.animation_finished
	
	global_position = inicio
	sprite.play("normal")
	intentos +=1
	musica.play()
	muriendo = false
	
	
