; state00 current interface
;   00 = command cursor
;   01 = move dir select


state_explore_palette:
	hex 0f 05 16 2d
	hex 0f 0c 21 3c
	hex 0f 18 27 36
	hex 0f 0c 21 3c
	hex 0f 16 25 36
	hex 0f 0c 21 3c
	hex 0f 0c 21 3c
	hex 0f 0c 21 3c


state_explore_init: subroutine
	STATE_SET state_explore_update

	jsr render_disable

	lda #$3f
	sta PPU_ADDR
	lda #$00
	sta PPU_ADDR
	ldx #$00
.pal_load_loop
	lda state_explore_palette,x
	sta PPU_DATA
	inx
	cpx #$20
	bne .pal_load_loop

	lda #<main_layout_nam
	sta temp00
	lda #>main_layout_nam
	sta temp01
	lda #$20
	jsr nametable_load

	lda #$23
	sta PPU_ADDR
	lda #$e9
	sta PPU_ADDR
	lda #%10101010
	sta PPU_DATA
	sta PPU_DATA
	sta PPU_DATA
	sta PPU_DATA
	sta PPU_DATA
	sta PPU_DATA

	lda #$00
	sta state00

	jsr render_enable

	rts


state_explore_update: subroutine
	lda #$22
	sta PPU_ADDR
	lda #$c4
	sta PPU_ADDR
	ldy #$00
.room_name_loop
	lda (room_data_lo),y
	sta PPU_DATA
	iny
	cpy #24
	bne .room_name_loop
	; xxx need to create render funtion
	lda scroll_x
	sta PPU_SCROLL
	lda scroll_y
	sta PPU_SCROLL

	; mode and controller stuff
	lda state00
	bne .not_command_state
	jsr state_explore_command
.not_command_state
	lda state00
	cmp #$01
	bne .not_command_move
	jsr state_explore_move
.not_command_move

	; purge sprites
	ldx #$00
	lda #$ef
.sprite_purge
	sta $200,x
	inx
	cpx #$40
	bne .sprite_purge


	jsr arrows_update
	jsr cursor_update


	rts



state_explore_command: subroutine

; CURRENT COMMAND
	lda controls_d
	and #BUTTON_DOWN
	bne .cursor_down
	lda controls_d
	and #BUTTON_UP
	bne .cursor_up
	jmp .cursor_control_done
.cursor_down
	inc command_id
	lda command_id
	cmp #$06
	bne .dont_reset_down
	lda #$00
	sta command_id
.dont_reset_down
	jmp .cursor_control_done
.cursor_up
	dec command_id
	bpl .dont_reset_up
	lda #$05
	sta command_id
.dont_reset_up
.cursor_control_done

; IMPLEMENT COMMAND?
	lda controls_d
	and #BUTTON_A
	beq .implement_done
	; xxx temp
	lda command_id
	bne .implement_done
	inc state00
.implement_done

	rts

controller_to_dir:
	hex ff 02 06 ff 04 03 05 04
	hex 00 01 07 00 ff 06 02 ff

state_explore_move: subroutine
	lda controls
	and #BUTTON_B
	beq .dont_exit_move_mode
	lda #$00
	sta state00
.dont_exit_move_mode

	lda controls
	and #$0f
	tax
	lda controller_to_dir,x
	bmi .not_valid_control
	tay
	; setup dir data ptr
	lda room_data_lo
	clc
	adc #24
	sta temp02
	lda room_data_hi
	sta temp03
	lda (temp02),y
	bmi .not_valid_control
	jsr state_map_load_room
	; back to command mode
	lda #$00
	sta state00
.not_valid_control

	rts
