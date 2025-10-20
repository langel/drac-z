
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


	jsr cursor_update


	rts
