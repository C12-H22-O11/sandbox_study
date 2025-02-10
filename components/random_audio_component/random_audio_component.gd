class_name RandomAudioComponent extends AudioStreamPlayer3D
## Component that plays a random audio stream out of a list.


## List of audio streams to randomly choose from.
@export var audio_streams: Array[AudioStream]

## Selects a random audio stream and plays it.
func play_random() -> void:
	if audio_streams.size() > 0:
		stream = audio_streams.pick_random()
		play()
