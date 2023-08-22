extends Node

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"is_unlocked" : is_unlocked
	}
	return save_dict
