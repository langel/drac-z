

arrows_pos_x:
	hex 7c a8 b8 a8 7c 50 40 50
arrows_pos_y:
	hex 18 2c 50 74 88 74 50 2c 
arrows_att:
	hex 00 c0 40 40 80 00 00 80
arrows_spr:
	hex 86 89 83 89 86 89 83 89



arrows_update: subroutine

	; setup dir data ptr
	lda room_data_lo
	clc
	adc #24
	sta temp02
	lda room_data_hi
	sta temp03

	; setup colors
	lda #$02
	sta arrow_color
	lda state00
	cmp #$01 ; move mode
	bne .not_move_mode
	lda wtf
	asl
	asl
	asl
	asl
	tax
	lda sine_table,x
	sta temp00
	lda #$89
	sta temp01
	jsr shift_divide_7_into_8
	lda temp00
	sta arrow_color
.not_move_mode


	ldx #$20
	ldy #$00
.arrow_loop
	lda (temp02),y
	sta $100,y
	bmi .not_this_dir
	lda arrows_pos_x,y
	sta spr_x,x
	lda arrows_pos_y,y
	sta spr_y,x
	lda arrows_att,y
	sta spr_a,x
	lda arrows_spr,y
	clc
	adc arrow_color
	sta spr_p,x
.not_this_dir
	inx
	inx
	inx
	inx
	iny
	cpy #$08
	bne .arrow_loop

	rts
