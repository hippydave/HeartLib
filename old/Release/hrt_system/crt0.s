@Part of the HeartLib API Project
@Standard crt0
@Based on Devkitpro gba_crt0.s

	.section	".crt0","ax"
	.global     _start
	.global _init
	.align
	.arm
	.cpu arm7tdmi

_start:
	b	rom_header_end
	.byte 0x24,0xFF,0xAE,0x51,0x69,0x9A,0xA2,0x21,0x3D,0x84,0x82,0x0A,0x84,0xE4,0x09,0xAD,0x11,0x24,0x8B,0x98,0xC0,0x81,0x7F,0x21,0xA3,0x52,0xBE,0x19,0x93,0x09,0xCE,0x20,0x10,0x46,0x4A,0x4A,0xF8,0x27,0x31,0xEC,0x58,0xC7,0xE8,0x33,0x82,0xE3,0xCE,0xBF,0x85,0xF4,0xDF,0x94,0xCE,0x4B,0x09,0xC1,0x94,0x56,0x8A,0xC0,0x13,0x72,0xA7,0xFC,0x9F,0x84,0x4D,0x73,0xA3,0xCA,0x9A,0x61,0x58,0x97,0xA3,0x27,0xFC,0x03,0x98,0x76,0x23,0x1D,0xC7,0x61,0x03,0x04,0xAE,0x56,0xBF,0x38,0x84,0x00,0x40,0xA7,0x0E,0xFD,0xFF,0x52,0xFE,0x03,0x6F,0x95,0x30,0xF1,0x97,0xFB,0xC0,0x85,0x60,0xD6,0x80,0x25,0xA9,0x63,0xBE,0x03,0x01,0x4E,0x38,0xE2,0xF9,0xA2,0x34,0xFF,0xBB,0x3E,0x03,0x44,0x78,0x00,0x90,0xCB,0x88,0x11,0x3A,0x94,0x65,0xC0,0x7C,0x63,0x87,0xF0,0x3C,0xAF,0xD6,0x25,0xE4,0x8B,0x38,0x0A,0xAC,0x72,0x21,0xD4,0xF8,0x07
	.fill	16,1,0			@ Game Title
	.byte   0x30,0x31		@ Maker Code (80000B0h)
	.byte   0x96			@ Fixed Value (80000B2h)
	.byte   0x00			@ Main Unit Code (80000B3h)
	.byte   0x80			@ Device Type (80000B4h)
	.fill	7,1,0			@ unused
	.byte	0x70			@ Software Version No (80000BCh)
	.byte	0x00			@ Complement Check (80000BDh)
	.byte	0x00,0x00    		@ Checksum (80000BEh)

rom_header_end:
	b	start_vector			@ This branch must be here for proper
						@ positioning of the following header.

	.GLOBAL	__boot_method, __slave_number
__boot_method:
	.byte   0				@ boot method (0=ROM boot, 3=Multiplay boot)
__slave_number:
	.byte   0				@ slave # (1=slave#1, 2=slave#2, 3=slave#3)

	.byte   0 				@ reserved
	.byte   0 				@ reserved
	.word   0    				@ reserved
	.word   0				@ reserved
	.word   0    				@ reserved
	.word   0    				@ reserved
	.word   0    				@ reserved
	.word   0    				@ reserved

	.global     start_vector
	.align
start_vector:
	mov	r0, #0x4000000			@ REG_BASE
	str	r0, [r0, #0x208]

	mov	r0, #0x12			@ Switch to IRQ Mode
	msr	cpsr, r0
	ldr	sp, =__sp_irq			@ Set IRQ stack
	mov	r0, #0x1f			@ Switch to System Mode
	msr	cpsr, r0
	ldr	sp, =__sp_usr			@ Set user stack

@ Enter Thumb mode
	add	r0, pc, #1
	bx	r0

	.thumb

	ldr	r0, =__text_start
	lsl	r0, #5				@ Was code compiled at 0x08000000 or higher?
	bcs     DoEWRAMClear			@ yes, you can not run it in external WRAM

	mov     r0, pc
	lsl     r0, #5				@ Are we running from ROM (0x8000000 or higher) ?
	bcc     SkipEWRAMClear			@ No, so no need to do a copy.

@ We were started in ROM, silly emulators. :P
@ So we need to copy to EWRAM.
	mov	r2, #2
	lsl	r2, r2, #24			@ r2= 0x02000000
	ldr	r3, =__end__			@ last ewram address
	sub	r3, r2				@ r3= actual binary size
	mov	r6, r2				@ r6= 0x02000000
	lsl	r1, r2, #2			@ r1= 0x08000000

	bl	CopyMem

	bx	r6				@ Jump to the code to execute

DoEWRAMClear:					@ Clear EWRAM to 0x00
	mov	r1, #0x40
	lsl	r1, #12				@ r1 = 0x40000
	lsl	r0, r1, #7			@ r0 = 0x2000000
	bl	ClearMem

SkipEWRAMClear:					@ Clear IWRAM to 0x00

@ Clear BSS section to 0x00
	ldr	r0, =__bss_start__
	ldr	r1, =__bss_end__
	sub	r1, r0
	bl	ClearMem

@ Clear SBSS section to 0x00
	ldr	r0, =__sbss_start__
	ldr	r1, =__sbss_end__
	sub	r1, r0
	bl	ClearMem

@ Copy initialized data (data section) from LMA to VMA (ROM to RAM)
	ldr	r1, =__data_lma
	ldr	r2, =__data_start__
	ldr	r4, =__data_end__
	bl	CopyMemChk

@ Copy internal work ram (iwram section) from LMA to VMA (ROM to RAM)
	ldr	r1,= __iwram_lma
	ldr	r2,= __iwram_start__
	ldr	r4,= __iwram_end__
	bl	CopyMemChk

@ Copy internal work ram overlay 0 (iwram0 section) from LMA to VMA (ROM to RAM)
	ldr	r2,= __load_stop_iwram0
	ldr	r1,= __load_start_iwram0
	sub	r3, r2, r1			@ Is there any data to copy?
	beq	CIW0Skip			@ no

	ldr	r2,= __iwram_overlay_start
	bl	CopyMem
CIW0Skip:
@ Copy external work ram (ewram section) from LMA to VMA (ROM to RAM)
	ldr	r1, =__ewram_lma
	ldr	r2, =__ewram_start
	ldr	r4, =__ewram_end
	bl	CopyMemChk

CEW0Skip:
@ set heap end
	ldr	r1, =fake_heap_end
	ldr	r0, =__eheap_end
	str	r0, [r1]
@ global constructors
	ldr	r3, =__libc_init_array
	bl	_blx_r3_stub
@ Jump to user code
	mov	r0, #0				@ int argc
	mov	r1, #0				@ char	*argv[]
	ldr	r3, =main
	bl	_blx_r3_stub
	b __crt0_reset
	
@ Clear memory to 0x00 if length != 0
@ r0 = Start Address
@ r1 = Length
ClearMem:
	mov	r2,#3				@ These	commands are used in cases where
	add	r1,r2				@ the length is	not a multiple of 4,
	bic	r1,r2				@ even though it should be.
	beq	ClearMX				@ Length is zero so exit
	mov	r2,#0
	
ClrLoop:
	stmia	r0!, {r2}
	sub	r1,#4
	bne	ClrLoop
	
ClearMX:
	bx	lr

_blx_r3_stub:
	bx	r3

@ Copy memory if length	!= 0
@ r1 = Source Address
@ r2 = Dest Address
@ r4 = Dest Address + Length
CopyMemChk:
	sub	r3, r4, r2			@ Is there any data to copy?
@ Copy memory
@ r1 = Source Address
@ r2 = Dest Address
@ r3 = Length
CopyMem:
	mov	r0, #3				@ These commands are used in cases where
	add	r3, r0				@ the length is not a multiple	of 4,
	bic	r3, r0				@ even	though it should be.
	beq	CIDExit				@ Length is zero so exit

CIDLoop:
	ldmia	r1!, {r0}
	stmia	r2!, {r0}
	sub	r3, #4
	bne	CIDLoop

	
CIDExit:
	bx	lr
	
.thumb
__crt0_reset:
	ldr	r0, =0x04000208
 	mov	r1, #0
	strb	r1, [r0]
	ldr	r0, =0x03007F00
	mov	sp, r0
	b start_vector
	bx lr
		
	.align
	.pool
	.end
