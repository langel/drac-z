

state_map_load_room: subroutine
	; a = room_id
	sta room_id

	shift_r 3
	clc
	adc #$80
	sta room_data_hi
	lda room_id
	shift_l 5
	sta room_data_lo

	rts
