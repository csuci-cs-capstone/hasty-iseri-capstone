extends KinematicBody

# Member variables
var g = -9.8
var vel = Vector3()
const MAX_SPEED = 5
const ACCEL= 2
const DEACCEL= 4
const MAX_SLOPE_ANGLE = 30
var EchoList = []
var InteractList = []
var footsteps_playing = false
var previous_position
var inv = 0

func _physics_process(delta):
	var dir = Vector3() # Where does the player intend to walk to
	var cam_xform = $target/camera.get_global_transform()

	if Input.is_action_pressed("gameworld_move_forward"):
		dir += -cam_xform.basis[2]
	if Input.is_action_pressed("gameworld_move_backwards"):
		dir += cam_xform.basis[2]
	if Input.is_action_pressed("gameworld_move_left"):
		dir += -cam_xform.basis[0]
	if Input.is_action_pressed("gameworld_move_right"):
		dir += cam_xform.basis[0]
	if Input.is_action_just_pressed("gameworld_echo") && !ismoving():
		echo()
	if Input.is_action_just_pressed("gameworld_interact"):
		interact()
		print(inv)
	dir.y = 0
	dir = dir.normalized()

	vel.y += delta * g

	var hvel = vel
	hvel.y = 0

	var target = dir * MAX_SPEED
	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel * delta)

	vel.x = hvel.x
	vel.z = hvel.z

	vel = move_and_slide(vel, Vector3(0,1,0))
	if ismoving() && !footsteps_playing:
		self.get_child(5).play()
		footsteps_playing = true
	elif !ismoving() && footsteps_playing:
		self.get_child(5).stop()
		footsteps_playing = false
		
	
	
	
func echo():
	# play list of objects in that player body is in range of
	for i in EchoList:
		if i:
			i.play()
			yield(i, "finished")
			
			
		
	

func interact():
	for i in InteractList:
		i.interactable = false
		#TODO actual inventory system
		# emit signal harvested and what harvested
		# play pick up sound
		inv = inv + 1
		InteractList.erase(i)
		
			

func ismoving():
	var moving
	if abs(vel.x) > 1 || abs(vel.z) > 1:
		moving = true
	else:
		moving = false
	return moving
	

# add area to list of sounds to be echoed
func _on_EchoRange7_area_entered(area):
	if area.get_child(2):
		if area.get_child(2).get_class() == "AudioStreamPlayer3D":
			EchoList.append(area.get_child(2))
# remove are from list of sounds to be echoed

func _on_EchoRange7_area_exited(area):
	if area.get_child(2):
		if area.get_child(2).get_class() == "AudioStreamPlayer3D":
			EchoList.erase(area.get_child(2))


func _on_WalkingEchoRange_area_entered(area):
	if area.get_child(2):
		if area.get_child(2).get_class() == "AudioStreamPlayer3D":
			area.get_child(2).play()
			if area.interactable:
				InteractList.append(area)


func _on_WalkingEchoRange_area_exited(area):
	if area.interactable:
		InteractList.erase(area)
	pass # Replace with function body.
