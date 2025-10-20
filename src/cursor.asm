

cursor_init: subroutine
	rts


cursor_update: subroutine


; RENDER

	; get cursor color
	lda wtf
	asl
	asl
	asl
	tax
	lda sine_table,x
	sta temp00
	lda #89
	sta temp01
	jsr shift_divide_7_into_8
.color_set
	lda temp00
	sta cursor_color

	lda state00
	beq .in_command_mode
	lda #$02
	sta cursor_color
.in_command_mode

	; XXX we're getting real spaghetti
	; is this the explore cursor?
	; or is it abstracted and used 
	; elsewhere?

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
