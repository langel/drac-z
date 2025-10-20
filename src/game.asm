
game_new: subroutine
	
	lda #$00
	sta command_id
	jsr state_map_load_room

	jsr state_explore_init

	rts

