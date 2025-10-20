

cursor_init: subroutine
	rts


cursor_update: subroutine

	; purge sprites
	ldx #$00
	lda #$ef
.sprite_purge
	sta $200,x
	inx
	cpx #$20
	bne .sprite_purge



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


; RENDER

	; get cursor color
	lda wtf
	asl
	tax
	lda sine_table,x
	sta temp00
	lda #89
	sta temp01
	jsr shift_divide_7_into_8
	lda temp00
	sta cursor_color

.command_cursor
	lda cursor_color
	clc
	adc #$80
	sta spr_p
	sta spr_p+4
	sta spr_p+8
	sta spr_p+12
	; attr
	lda #$00
	sta spr_a
	lda #$40
	sta spr_a+4
	lda #$80
	sta spr_a+8
	lda #$c0
	sta spr_a+12
	; x pos
	lda #$cb
	sta spr_x
	sta spr_x+8
	clc
	adc #$22
	sta spr_x+4
	sta spr_x+12
	; y pos
	lda command_id
	sta temp00
	lda #24
	sta temp01
	jsr shift_multiply
	lda temp00
	clc
	adc #$0a
	sta spr_y
	sta spr_y+4
	clc
	adc #$12
	sta spr_y+8
	sta spr_y+12
	rts
