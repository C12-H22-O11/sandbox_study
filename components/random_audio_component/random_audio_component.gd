class_name RandomAudioComponent extends AudioStreamPlayer3D

@export var audio_streams: Array[AudioStream]

func play_random() -> void:
	if audio_streams.size() > 0:
		stream = audio_streams.pick_random()
	play()
