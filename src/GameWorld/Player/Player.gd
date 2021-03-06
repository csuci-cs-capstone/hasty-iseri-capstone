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
var paused = false
signal harvested(type)

func _physics_process(delta):
	if !paused:
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
			if InteractList.size() > 0:
				interact()
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
		if ismoving() && not $Footsteps.is_playing():
			$Footsteps.play()
		elif !ismoving() && $Footsteps.is_playing():
			$Footsteps.stop()
			

	
	
	
func echo():
	# play list of objects in that player body is in range of
	for i in EchoList:
		if i:
			i.play()
			yield(i, "finished")
			
			
		
	

func interact():
	var sound = $Pickup
	for i in InteractList:
		i.remove_from_group("harvestable")
		#TODO actual inventory system
		sound.play()
		#yield(sound, "finished")
		emit_signal("harvested",i.get_resource())

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
	#if area.get_child(2):
	#	if area.get_child(2).get_class() == "AudioStreamPlayer3D":
	#		EchoList.append(area.get_child(2))
	if area.has_node("AudioStreamPlayer3D"):
		EchoList.append(area.get_node("AudioStreamPlayer3D"))
# remove are from list of sounds to be echoed

func _on_EchoRange7_area_exited(area):
	#if area.get_child(2):
	#	if area.get_child(2).get_class() == "AudioStreamPlayer3D":
	#		EchoList.erase(area.get_child(2))
	if area.has_node("AudioStreamPlayer3D"):
		EchoList.erase(area.get_node("AudioStreamPlayer3D"))


func _on_WalkingEchoRange_area_entered(area):
	#if area.get_child(2):
	#	if area.get_child(2).get_class() == "AudioStreamPlayer3D":
	#		area.get_child(2).play()
	#		if area.is_in_group("harvestable"):
	#			print(area)
	#			InteractList.append(area)
	if area.has_node("AudioStreamPlayer3D"):
		area.get_node("AudioStreamPlayer3D").play()
		if area.is_in_group("harvestable"):
			print(area)
			InteractList.append(area)


func _on_WalkingEchoRange_area_exited(area):
	if area.is_in_group("harvestable"):
		InteractList.erase(area)
	pass # Replace with function body.
