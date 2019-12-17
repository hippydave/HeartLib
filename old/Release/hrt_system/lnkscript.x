/* HeartLib API ABS Linker script*/
/* Part of the HeartLib Project*/
/* This file is a mix of the gba_cart.ld and the gba_mb.ld linkerscripts
	for devkitPro.*/
/* Changed made by Sterophonick*/

OUTPUT_FORMAT("elf32-littlearm", "elf32-bigarm", "elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(_start)


MEMORY {
	rom	: ORIGIN = 0x08000000, LENGTH = 32M
	iwram	: ORIGIN = 0x03000000, LENGTH = 32K
	ewram	: ORIGIN = 0x02000000, LENGTH = 256K
}

#if defined HRT_MB /* If make mode is Multiboot */
__text_start	=	ORIGIN(ewram);
__eheap_end	=	ORIGIN(ewram) + LENGTH(ewram);
__iwram_start	=	ORIGIN(iwram);
__iwram_top	=	ORIGIN(iwram) + LENGTH(iwram);;

__sp_irq	=	__iwram_top - 0x060;
__sp_usr	=	__sp_irq - 0x0a0;
__irq_flags	=	0x03007ff8;

SECTIONS
{
	. = __text_start;
	. = __text_start;
	.crt0 :
	{
		KEEP (*(.crt0))
		. = ALIGN(4);
	} >ewram =0xff

	.init :
	{
		KEEP (*(SORT_NONE(.init)))
	} >ewram

	.plt :
	{
		*(.plt)
		. = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
	} >ewram


	.text  ALIGN (4):
	{
		*(EXCLUDE_FILE (*.iwram*) .text)
		*(.text .stub .text.* .gnu.linkonce.t.*)
		KEEP (*(.text.*personality*))
		/* .gnu.warning sections are handled specially by elf32.em.  */
		*(.gnu.warning)
		*(.glue_7t) *(.glue_7) *(.vfp11_veneer)
		. = ALIGN(4);  /* REQUIRED. LD is flaky without it. */
	} >ewram = 0xff

	__text_end = .;
	.fini           :
	{
		KEEP (*(.fini))
		. = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
	} >ewram =0

	.rodata :
	{
		*(.rodata)
		*all.rodata*(*)
		*(.roda)
		*(.rodata.*)
		*(.gnu.linkonce.r*)
		SORT(CONSTRUCTORS)
		. = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
	} >ewram = 0xff

  .ARM.extab   : { *(.ARM.extab* .gnu.linkonce.armextab.*) } >ewram
   __exidx_start = .;
  .ARM.exidx   : { *(.ARM.exidx* .gnu.linkonce.armexidx.*) } >ewram
   __exidx_end = .;
  /* Ensure the __preinit_array_start label is properly aligned.  We
     could instead move the label definition inside the section, but
     the linker would then create the section even if it turns out to
     be empty, which isn't pretty.  */
  . = ALIGN(32 / 8);
  PROVIDE (__preinit_array_start = .);
  .preinit_array     : { KEEP (*(.preinit_array)) } >ewram = 0xff
  PROVIDE (__preinit_array_end = .);
  PROVIDE (__init_array_start = .);
  .init_array     : { KEEP (*(.init_array)) } >ewram = 0xff
  PROVIDE (__init_array_end = .);
  PROVIDE (__fini_array_start = .);
  .fini_array     : { KEEP (*(.fini_array)) } >ewram = 0xff
  PROVIDE (__fini_array_end = .);
	.ctors :
	{
		/*	gcc uses crtbegin.o to find the start of the constructors, so
			we make sure it is first.  Because this is a wildcard, it
			doesn't matter if the user does not actually link against
			crtbegin.o; the linker won't look for a file to match a
			wildcard.  The wildcard also means that it doesn't matter which
			directory crtbegin.o is in.  */
		KEEP (*crtbegin.o(.ctors))
		KEEP (*(EXCLUDE_FILE (*crtend.o) .ctors))
		KEEP (*(SORT(.ctors.*)))
		KEEP (*(.ctors))
		. = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
	} >ewram = 0

	.dtors :
	{
		KEEP (*crtbegin.o(.dtors))
		KEEP (*(EXCLUDE_FILE (*crtend.o) .dtors))
		KEEP (*(SORT(.dtors.*)))
		KEEP (*(.dtors))
		. = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
	} >ewram = 0

	.jcr            : { KEEP (*(.jcr)) } >ewram
	.eh_frame :
	{
		KEEP (*(.eh_frame))
	. = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
	} >ewram = 0

	.gcc_except_table :
	{
		*(.gcc_except_table)
		. = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
	} >ewram = 0

	__iwram_lma = .;

	.iwram __iwram_start : AT (__iwram_lma)
	{
		__iwram_start__ = ABSOLUTE(.) ;
		*(.iwram)
		*iwram.*(.text)
		. = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
		__iwram_end__ = ABSOLUTE(.) ;
	} >iwram = 0xff

	__data_lma = __iwram_lma + SIZEOF(.iwram) ;

	.bss ALIGN(4) (NOLOAD):
	{
		__bss_start__ = ABSOLUTE(.);
		*(.dynbss)
		*(.gnu.linkonce.b*)
		*(.bss*)
		*(COMMON)
		. = ALIGN(4);    /* REQUIRED. LD is flaky without it. */
		__bss_end__ = ABSOLUTE(.) ;
	}

	.data ALIGN(4) : AT (__data_lma)
	{
		__data_start__ = ABSOLUTE(.);
		*(.data)
		*(.data.*)
		*(.gnu.linkonce.d*)
		CONSTRUCTORS
		. = ALIGN(4);  /* REQUIRED. LD is flaky without it. */
		__data_end__  =  ABSOLUTE(.);
	} >iwram = 0xff

	__iwram_overlay_lma = __data_lma + SIZEOF(.data);

	PROVIDE (edata = .);
	__iwram_overlay_start = . ;

	OVERLAY ALIGN(4) : NOCROSSREFS AT (__iwram_overlay_lma)
	{
	   .iwram0 { *(.iwram0) . = ALIGN(4);}
	   .iwram1 { *(.iwram1) . = ALIGN(4);}
	   .iwram2 { *(.iwram2) . = ALIGN(4);}
	   .iwram3 { *(.iwram3) . = ALIGN(4);}
	   .iwram4 { *(.iwram4) . = ALIGN(4);}
	   .iwram5 { *(.iwram5) . = ALIGN(4);}
	   .iwram6 { *(.iwram6) . = ALIGN(4);}
	   .iwram7 { *(.iwram7) . = ALIGN(4);}
	   .iwram8 { *(.iwram8) . = ALIGN(4);}
	   .iwram9 { *(.iwram9) . = ALIGN(4);}
	} >iwram = 0xff

	__ewram_lma = LOADADDR(.iwram0) + SIZEOF(.iwram0)+SIZEOF(.iwram1)+SIZEOF(.iwram2)+SIZEOF(.iwram3)+SIZEOF(.iwram4)+SIZEOF(.iwram5)+SIZEOF(.iwram6)+SIZEOF(.iwram7)+SIZEOF(.iwram8)+SIZEOF(.iwram9);

	__iwram_overlay_end = __ewram_lma ;

	/* v1.3 */
	__ewram_start =  __ewram_lma ;

	.ewram __ewram_start : AT (__ewram_lma)
	{
		*(.ewram)
		. = ALIGN(4);  /* REQUIRED. LD is flaky without it. */
		__ewram_end = ABSOLUTE(.);
	} >ewram = 0xff

	__ewram_overlay_lma = __ewram_lma + SIZEOF(.ewram);

	.sbss ALIGN(4)(NOLOAD):
 	{
		__sbss_start__ = ABSOLUTE(.);
		*(.sbss)
		. = ALIGN(4);
		__sbss_end__  = ABSOLUTE(.);
		__end__ = ABSOLUTE(.);
		__eheap_start = ABSOLUTE(.);
	}

	OVERLAY ALIGN(4): NOCROSSREFS AT (__ewram_overlay_lma)
	{
		.ewram0 { *(.ewram0) . = ALIGN(4);}
		.ewram1 { *(.ewram1) . = ALIGN(4);}
		.ewram2 { *(.ewram2) . = ALIGN(4);}
		.ewram3 { *(.ewram3) . = ALIGN(4);}
		.ewram4 { *(.ewram4) . = ALIGN(4);}
		.ewram5 { *(.ewram5) . = ALIGN(4);}
		.ewram6 { *(.ewram6) . = ALIGN(4);}
		.ewram7 { *(.ewram7) . = ALIGN(4);}
		.ewram8 { *(.ewram8) . = ALIGN(4);}
		.ewram9 { *(.ewram9) . = ALIGN(4);}
	} >ewram = 0xff
	__ewram_overlay_end  = ABSOLUTE(.);

	__eheap_start = __ewram_overlay_end ;

	_end = __ewram_overlay_end;
	__end__ = __ewram_overlay_end;
	__rom_end__ = __ewram_overlay_end;

	/* Stabs debugging sections.  */
	.stab 0 : { *(.stab) }
	.stabstr 0 : { *(.stabstr) }
	.stab.excl 0 : { *(.stab.excl) }
	.stab.exclstr 0 : { *(.stab.exclstr) }
	.stab.index 0 : { *(.stab.index) }
	.stab.indexstr 0 : { *(.stab.indexstr) }
	.comment 0 : { *(.comment) }
	/* DWARF debug sections.
	   Symbols in the DWARF debugging sections are relative to the beginning
	   of the section so we begin them at 0.  */
	/* DWARF 1 */
	.debug          0 : { *(.debug) }
	.line           0 : { *(.line) }
	/* GNU DWARF 1 extensions */
	.debug_srcinfo  0 : { *(.debug_srcinfo) }
	.debug_sfnames  0 : { *(.debug_sfnames) }
	/* DWARF 1.1 and DWARF 2 */
	.debug_aranges  0 : { *(.debug_aranges) }
	.debug_pubnames 0 : { *(.debug_pubnames) }
	/* DWARF 2 */
	.debug_info     0 : { *(.debug_info) }
	.debug_abbrev   0 : { *(.debug_abbrev) }
	.debug_line     0 : { *(.debug_line) }
	.debug_frame    0 : { *(.debug_frame) }
	.debug_str      0 : { *(.debug_str) }
	.debug_loc      0 : { *(.debug_loc) }
	.debug_macinfo  0 : { *(.debug_macinfo) }
	/* SGI/MIPS DWARF 2 extensions */
	.debug_weaknames 0 : { *(.debug_weaknames) }
	.debug_funcnames 0 : { *(.debug_funcnames) }
	.debug_typenames 0 : { *(.debug_typenames) }
	.debug_varnames  0 : { *(.debug_varnames) }
	.stack 0x80000 : { _stack = .; *(.stack) }
	/* These must appear regardless of  .  */
}

#else 
__text_start	=	ORIGIN(rom);
__eheap_end	=	ORIGIN(ewram) + LENGTH(ewram);
__iwram_start	=	ORIGIN(iwram);
__iwram_top	=	ORIGIN(iwram) + LENGTH(iwram);;
__sp_irq	=	__iwram_top - 0x060;
__sp_usr	=	__sp_irq - 0x0a0;
__irq_flags	=	0x03007ff8;

SECTIONS
{
	. = __text_start;
	.crt0 :
	{
		KEEP (*(.crt0))
		. = ALIGN(4);
	} >rom =0xff


	.init :
	{
		KEEP (*(SORT_NONE(.init)))
	} >rom

	.plt :
	{
		*(.plt)
		. = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
	} >rom

	.text  :   /* ALIGN (4): */
	{
		*(EXCLUDE_FILE (*.iwram*) .text)
		*(.text .stub .text.* .gnu.linkonce.t.*)
		KEEP (*(.text.*personality*))
		/* .gnu.warning sections are handled specially by elf32.em.  */
		*(.gnu.warning)
		*(.glue_7t) *(.glue_7) *(.vfp11_veneer)
		. = ALIGN(4);  /* REQUIRED. LD is flaky without it. */
	} >rom = 0xff

	__text_end = .;
	.fini           :
	{
		KEEP (*(.fini))
		. = ALIGN(4);  /* REQUIRED. LD is flaky without it. */
	} >rom =0

	.rodata :
	{
		*(.rodata)
		*all.rodata*(*)
		*(.roda)
		*(.rodata.*)
		*(.gnu.linkonce.r*)
		SORT(CONSTRUCTORS)
		. = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
	} >rom = 0xff
	.ARM.extab   : { *(.ARM.extab* .gnu.linkonce.armextab.*) } >rom
	__exidx_start = .;
	.ARM.exidx   : { *(.ARM.exidx* .gnu.linkonce.armexidx.*) } >rom
	__exidx_end = .;

	.ctors :
	{
		/*	gcc uses crtbegin.o to find the start of the constructors, so
			we make sure it is first.  Because this is a wildcard, it
			doesn't matter if the user does not actually link against
			crtbegin.o; the linker won't look for a file to match a
			wildcard.  The wildcard also means that it doesn't matter which
			directory crtbegin.o is in.  */
		KEEP (*crtbegin.o(.ctors))
		KEEP (*(EXCLUDE_FILE (*crtend.o) .ctors))
		KEEP (*(SORT(.ctors.*)))
		KEEP (*(.ctors))
		. = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
	} >rom = 0

	.dtors :
	{
		KEEP (*crtbegin.o(.dtors))
		KEEP (*(EXCLUDE_FILE (*crtend.o) .dtors))
		KEEP (*(SORT(.dtors.*)))
		KEEP (*(.dtors))
		. = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
	} >rom = 0


	.eh_frame :
	{
		KEEP (*(.eh_frame))
		. = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
	} >rom = 0

	.gcc_except_table :
	{
		*(.gcc_except_table)
		. = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
	} >rom = 0

	__iwram_lma = .;

	.iwram __iwram_start : AT (__iwram_lma)
	{
		__iwram_start__ = ABSOLUTE(.) ;
		*(.iwram)
		*iwram.*(.text)
		. = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
		__iwram_end__ = ABSOLUTE(.) ;
	} >iwram = 0xff

	__data_lma = __iwram_lma + SIZEOF(.iwram) ;

	.bss ALIGN(4) (NOLOAD) :
	{
		__bss_start = ABSOLUTE(.);
		__bss_start__ = ABSOLUTE(.);
		*(.dynbss)
		*(.gnu.linkonce.b*)
		*(.bss*)
		*(COMMON)
		. = ALIGN(4);    /* REQUIRED. LD is flaky without it. */
		__bss_end__ = ABSOLUTE(.);

	} AT>iwram

	.data ALIGN(4) : AT (__data_lma)
	{
		__data_start__ = ABSOLUTE(.);
		*(.data)
		*(.data.*)
		*(.gnu.linkonce.d*)
		CONSTRUCTORS
		. = ALIGN(4);
	} >iwram = 0xff

	__preinit_lma = __data_lma + SIZEOF(.data);

	.preinit_array ALIGN(4)    : AT (__preinit_lma)
	{
		__preinit_array_start = ABSOLUTE(.);
		KEEP (*(.preinit_array))
		__preinit_array_end = ABSOLUTE(.);
	} >iwram

	__init_lma = __preinit_lma + SIZEOF(.preinit_array);

	.init_array  ALIGN(4)   : AT (__init_lma)
	{
		__init_array_start = ABSOLUTE(.);
		KEEP (*(SORT(.init_array.*)))
		KEEP (*(.init_array))
		__init_array_end = ABSOLUTE(.);
	} >iwram

	__fini_lma = __init_lma + SIZEOF(.init_array);

	.fini_array  ALIGN(4)   : AT (__fini_lma)
	{
		__fini_array_start = ABSOLUTE(.);
		KEEP (*(SORT(.fini_array.*)))
		KEEP (*(.fini_array))
  		__fini_array_end = ABSOLUTE(.);
	} >iwram

	__jcr_lma = __fini_lma + SIZEOF(.fini_array);
	.jcr        ALIGN(4)    : AT (__jcr_lma) { KEEP (*(.jcr)) } >iwram

	__data_end__  =  ABSOLUTE(.);
	__iwram_overlay_lma = __jcr_lma + SIZEOF(.jcr);

	__iwram_overlay_start = . ;

	OVERLAY ALIGN(4) : NOCROSSREFS AT (__iwram_overlay_lma)
	{
		.iwram0 { *(.iwram0) . = ALIGN(4);}
		.iwram1 { *(.iwram1) . = ALIGN(4);}
		.iwram2 { *(.iwram2) . = ALIGN(4);}
		.iwram3 { *(.iwram3) . = ALIGN(4);}
		.iwram4 { *(.iwram4) . = ALIGN(4);}
		.iwram5 { *(.iwram5) . = ALIGN(4);}
		.iwram6 { *(.iwram6) . = ALIGN(4);}
		.iwram7 { *(.iwram7) . = ALIGN(4);}
		.iwram8 { *(.iwram8) . = ALIGN(4);}
		.iwram9 { *(.iwram9) . = ALIGN(4);}
	}>iwram = 0xff

	__iwram_overlay_end = . ;
	__ewram_lma = __iwram_overlay_lma + (__iwram_overlay_end - __iwram_overlay_start) ;

	__iheap_start = . ;

	__ewram_start = ORIGIN(ewram);
	.ewram __ewram_start : AT (__ewram_lma)
	{
		*(.ewram)
		. = ALIGN(4);  /* REQUIRED. LD is flaky without it. */
		__ewram_end = ABSOLUTE(.);
	}>ewram = 0xff

	__pad_lma = __ewram_lma + SIZEOF(.ewram);

	.sbss ALIGN(4)(NOLOAD):
 	{
		__sbss_start__ = ABSOLUTE(.);
 		*(.sbss)
 		. = ALIGN(4);
		__sbss_end__  = ABSOLUTE(.);
		__end__ = ABSOLUTE(.);
		__eheap_start = ABSOLUTE(.);
 	} AT>ewram

	/* EZF Advance strips trailing 0xff bytes, add a pad section so nothing important is removed */
	.pad ALIGN(4) : AT (__pad_lma)
	{
		LONG(0x52416b64)
		LONG(0x4d)
		. = ALIGN(4);  /* REQUIRED. LD is flaky without it. */
	} = 0xff
	__rom_end__ = __pad_lma + SIZEOF(.pad);


	/* Stabs debugging sections.  */
	.stab 0 : { *(.stab) }
	.stabstr 0 : { *(.stabstr) }
	.stab.excl 0 : { *(.stab.excl) }
	.stab.exclstr 0 : { *(.stab.exclstr) }
	.stab.index 0 : { *(.stab.index) }
	.stab.indexstr 0 : { *(.stab.indexstr) }
	.comment 0 : { *(.comment) }
	/*	DWARF debug sections.
		Symbols in the DWARF debugging sections are relative to the beginning
		of the section so we begin them at 0.  */
	/* DWARF 1 */
	.debug          0 : { *(.debug) }
	.line           0 : { *(.line) }
	/* GNU DWARF 1 extensions */
	.debug_srcinfo  0 : { *(.debug_srcinfo) }
	.debug_sfnames  0 : { *(.debug_sfnames) }
	/* DWARF 1.1 and DWARF 2 */
	.debug_aranges  0 : { *(.debug_aranges) }
	.debug_pubnames 0 : { *(.debug_pubnames) }
	/* DWARF 2 */
	.debug_info     0 : { *(.debug_info) }
	.debug_abbrev   0 : { *(.debug_abbrev) }
	.debug_line     0 : { *(.debug_line) }
	.debug_frame    0 : { *(.debug_frame) }
	.debug_str      0 : { *(.debug_str) }
	.debug_loc      0 : { *(.debug_loc) }
	.debug_macinfo  0 : { *(.debug_macinfo) }
	/* SGI/MIPS DWARF 2 extensions */
	.debug_weaknames 0 : { *(.debug_weaknames) }
	.debug_funcnames 0 : { *(.debug_funcnames) }
	.debug_typenames 0 : { *(.debug_typenames) }
	.debug_varnames  0 : { *(.debug_varnames) }
	.stack 0x80000 : { _stack = .; *(.stack) }
	/* These must appear regardless of  .  */
  .note.gnu.arm.ident 0 : { KEEP (*(.note.gnu.arm.ident)) }
  .ARM.attributes 0 : { KEEP (*(.ARM.attributes)) }
  /DISCARD/ : { *(.note.GNU-stack) }
}
#endif