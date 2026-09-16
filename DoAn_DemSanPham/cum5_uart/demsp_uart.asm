;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.0 #15242 (MINGW64)
;--------------------------------------------------------
	.module demsp_uart
	
	.optsdcc -mmcs51 --model-small
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _MA7DOAN
	.globl _main
	.globl _cap_nhat_hienthi
	.globl _delay20ms
	.globl _xu_ly_lenh
	.globl _khop
	.globl _gui_trang_thai
	.globl _uart_hai_so
	.globl _uart_so
	.globl _uart_chuoi
	.globl _uart_gui
	.globl _uart_isr
	.globl _int1_isr
	.globl _timer0_isr
	.globl _CY
	.globl _AC
	.globl _F0
	.globl _RS1
	.globl _RS0
	.globl _OV
	.globl _F1
	.globl _P
	.globl _PS
	.globl _PT1
	.globl _PX1
	.globl _PT0
	.globl _PX0
	.globl _RD
	.globl _WR
	.globl _T1
	.globl _T0
	.globl _INT1
	.globl _INT0
	.globl _TXD
	.globl _RXD
	.globl _P3_7
	.globl _P3_6
	.globl _P3_5
	.globl _P3_4
	.globl _P3_3
	.globl _P3_2
	.globl _P3_1
	.globl _P3_0
	.globl _EA
	.globl _ES
	.globl _ET1
	.globl _EX1
	.globl _ET0
	.globl _EX0
	.globl _P2_7
	.globl _P2_6
	.globl _P2_5
	.globl _P2_4
	.globl _P2_3
	.globl _P2_2
	.globl _P2_1
	.globl _P2_0
	.globl _SM0
	.globl _SM1
	.globl _SM2
	.globl _REN
	.globl _TB8
	.globl _RB8
	.globl _TI
	.globl _RI
	.globl _P1_7
	.globl _P1_6
	.globl _P1_5
	.globl _P1_4
	.globl _P1_3
	.globl _P1_2
	.globl _P1_1
	.globl _P1_0
	.globl _TF1
	.globl _TR1
	.globl _TF0
	.globl _TR0
	.globl _IE1
	.globl _IT1
	.globl _IE0
	.globl _IT0
	.globl _P0_7
	.globl _P0_6
	.globl _P0_5
	.globl _P0_4
	.globl _P0_3
	.globl _P0_2
	.globl _P0_1
	.globl _P0_0
	.globl _B
	.globl _ACC
	.globl _PSW
	.globl _IP
	.globl _P3
	.globl _IE
	.globl _P2
	.globl _SBUF
	.globl _SCON
	.globl _P1
	.globl _TH1
	.globl _TH0
	.globl _TL1
	.globl _TL0
	.globl _TMOD
	.globl _TCON
	.globl _PCON
	.globl _DPH
	.globl _DPL
	.globl _SP
	.globl _P0
	.globl _co_lenh
	.globl _buf_len
	.globl _buf
	.globl _alarm
	.globl _khoa_cambien
	.globl _target_count
	.globl _product_count
	.globl _dang_chay
	.globl _phut
	.globl _giay
	.globl _tick
	.globl _hienthi
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
_P0	=	0x0080
_SP	=	0x0081
_DPL	=	0x0082
_DPH	=	0x0083
_PCON	=	0x0087
_TCON	=	0x0088
_TMOD	=	0x0089
_TL0	=	0x008a
_TL1	=	0x008b
_TH0	=	0x008c
_TH1	=	0x008d
_P1	=	0x0090
_SCON	=	0x0098
_SBUF	=	0x0099
_P2	=	0x00a0
_IE	=	0x00a8
_P3	=	0x00b0
_IP	=	0x00b8
_PSW	=	0x00d0
_ACC	=	0x00e0
_B	=	0x00f0
;--------------------------------------------------------
; special function bits
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
_P0_0	=	0x0080
_P0_1	=	0x0081
_P0_2	=	0x0082
_P0_3	=	0x0083
_P0_4	=	0x0084
_P0_5	=	0x0085
_P0_6	=	0x0086
_P0_7	=	0x0087
_IT0	=	0x0088
_IE0	=	0x0089
_IT1	=	0x008a
_IE1	=	0x008b
_TR0	=	0x008c
_TF0	=	0x008d
_TR1	=	0x008e
_TF1	=	0x008f
_P1_0	=	0x0090
_P1_1	=	0x0091
_P1_2	=	0x0092
_P1_3	=	0x0093
_P1_4	=	0x0094
_P1_5	=	0x0095
_P1_6	=	0x0096
_P1_7	=	0x0097
_RI	=	0x0098
_TI	=	0x0099
_RB8	=	0x009a
_TB8	=	0x009b
_REN	=	0x009c
_SM2	=	0x009d
_SM1	=	0x009e
_SM0	=	0x009f
_P2_0	=	0x00a0
_P2_1	=	0x00a1
_P2_2	=	0x00a2
_P2_3	=	0x00a3
_P2_4	=	0x00a4
_P2_5	=	0x00a5
_P2_6	=	0x00a6
_P2_7	=	0x00a7
_EX0	=	0x00a8
_ET0	=	0x00a9
_EX1	=	0x00aa
_ET1	=	0x00ab
_ES	=	0x00ac
_EA	=	0x00af
_P3_0	=	0x00b0
_P3_1	=	0x00b1
_P3_2	=	0x00b2
_P3_3	=	0x00b3
_P3_4	=	0x00b4
_P3_5	=	0x00b5
_P3_6	=	0x00b6
_P3_7	=	0x00b7
_RXD	=	0x00b0
_TXD	=	0x00b1
_INT0	=	0x00b2
_INT1	=	0x00b3
_T0	=	0x00b4
_T1	=	0x00b5
_WR	=	0x00b6
_RD	=	0x00b7
_PX0	=	0x00b8
_PT0	=	0x00b9
_PX1	=	0x00ba
_PT1	=	0x00bb
_PS	=	0x00bc
_P	=	0x00d0
_F1	=	0x00d1
_OV	=	0x00d2
_RS0	=	0x00d3
_RS1	=	0x00d4
_F0	=	0x00d5
_AC	=	0x00d6
_CY	=	0x00d7
;--------------------------------------------------------
; overlayable register banks
;--------------------------------------------------------
	.area REG_BANK_0	(REL,OVR,DATA)
	.ds 8
;--------------------------------------------------------
; internal ram data
;--------------------------------------------------------
	.area DSEG    (DATA)
_hienthi::
	.ds 4
_tick::
	.ds 2
_giay::
	.ds 1
_phut::
	.ds 1
_dang_chay::
	.ds 1
_product_count::
	.ds 2
_target_count::
	.ds 2
_khoa_cambien::
	.ds 1
_alarm::
	.ds 1
_buf::
	.ds 20
_buf_len::
	.ds 1
_co_lenh::
	.ds 1
_timer0_isr_vitri_10000_2:
	.ds 1
_xu_ly_lenh_i_10000_28:
	.ds 1
;--------------------------------------------------------
; overlayable items in internal ram
;--------------------------------------------------------
	.area	OSEG    (OVR,DATA)
	.area	OSEG    (OVR,DATA)
_khop_tu_10000_24:
	.ds 3
	.area	OSEG    (OVR,DATA)
_delay20ms_i_10000_41:
	.ds 1
_delay20ms_j_10000_41:
	.ds 1
;--------------------------------------------------------
; Stack segment in internal ram
;--------------------------------------------------------
	.area SSEG
__start__stack:
	.ds	1

;--------------------------------------------------------
; indirectly addressable internal ram data
;--------------------------------------------------------
	.area ISEG    (DATA)
;--------------------------------------------------------
; absolute internal ram data
;--------------------------------------------------------
	.area IABS    (ABS,DATA)
	.area IABS    (ABS,DATA)
;--------------------------------------------------------
; bit data
;--------------------------------------------------------
	.area BSEG    (BIT)
;--------------------------------------------------------
; paged external ram data
;--------------------------------------------------------
	.area PSEG    (PAG,XDATA)
;--------------------------------------------------------
; uninitialized external ram data
;--------------------------------------------------------
	.area XSEG    (XDATA)
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area XABS    (ABS,XDATA)
;--------------------------------------------------------
; initialized external ram data
;--------------------------------------------------------
	.area XISEG   (XDATA)
	.area HOME    (CODE)
	.area GSINIT0 (CODE)
	.area GSINIT1 (CODE)
	.area GSINIT2 (CODE)
	.area GSINIT3 (CODE)
	.area GSINIT4 (CODE)
	.area GSINIT5 (CODE)
	.area GSINIT  (CODE)
	.area GSFINAL (CODE)
	.area CSEG    (CODE)
;--------------------------------------------------------
; interrupt vector
;--------------------------------------------------------
	.area HOME    (CODE)
__interrupt_vect:
	ljmp	__sdcc_gsinit_startup
	reti
	.ds	7
	ljmp	_timer0_isr
	.ds	5
	ljmp	_int1_isr
	.ds	5
	reti
	.ds	7
	ljmp	_uart_isr
; restartable atomic support routines
	.ds	2
sdcc_atomic_exchange_rollback_start::
	nop
	nop
sdcc_atomic_exchange_pdata_impl:
	movx	a, @r0
	mov	r3, a
	mov	a, r2
	movx	@r0, a
	sjmp	sdcc_atomic_exchange_exit
	nop
	nop
sdcc_atomic_exchange_xdata_impl:
	movx	a, @dptr
	mov	r3, a
	mov	a, r2
	movx	@dptr, a
	sjmp	sdcc_atomic_exchange_exit
sdcc_atomic_compare_exchange_idata_impl:
	mov	a, @r0
	cjne	a, ar2, .+#5
	mov	a, r3
	mov	@r0, a
	ret
	nop
sdcc_atomic_compare_exchange_pdata_impl:
	movx	a, @r0
	cjne	a, ar2, .+#5
	mov	a, r3
	movx	@r0, a
	ret
	nop
sdcc_atomic_compare_exchange_xdata_impl:
	movx	a, @dptr
	cjne	a, ar2, .+#5
	mov	a, r3
	movx	@dptr, a
	ret
sdcc_atomic_exchange_rollback_end::

sdcc_atomic_exchange_gptr_impl::
	jnb	b.6, sdcc_atomic_exchange_xdata_impl
	mov	r0, dpl
	jb	b.5, sdcc_atomic_exchange_pdata_impl
sdcc_atomic_exchange_idata_impl:
	mov	a, r2
	xch	a, @r0
	mov	dpl, a
	ret
sdcc_atomic_exchange_exit:
	mov	dpl, r3
	ret
sdcc_atomic_compare_exchange_gptr_impl::
	jnb	b.6, sdcc_atomic_compare_exchange_xdata_impl
	mov	r0, dpl
	jb	b.5, sdcc_atomic_compare_exchange_pdata_impl
	sjmp	sdcc_atomic_compare_exchange_idata_impl
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME    (CODE)
	.area GSINIT  (CODE)
	.area GSFINAL (CODE)
	.area GSINIT  (CODE)
	.globl __sdcc_gsinit_startup
	.globl __sdcc_program_startup
	.globl __start__stack
	.globl __mcs51_genXINIT
	.globl __mcs51_genXRAMCLEAR
	.globl __mcs51_genRAMCLEAR
;------------------------------------------------------------
;Allocation info for local variables in function 'timer0_isr'
;------------------------------------------------------------
;vitri         Allocated with name '_timer0_isr_vitri_10000_2'
;------------------------------------------------------------
;	demsp_uart.c:108: static unsigned char vitri = 0;
	mov	_timer0_isr_vitri_10000_2,#0x00
;	demsp_uart.c:74: volatile unsigned char hienthi[4] = { 0x3F, 0x3F, 0x3F, 0x3F };
	mov	_hienthi,#0x3f
	mov	(_hienthi + 0x0001),#0x3f
	mov	(_hienthi + 0x0002),#0x3f
	mov	(_hienthi + 0x0003),#0x3f
;	demsp_uart.c:76: volatile unsigned int  tick      = 0;
	clr	a
	mov	_tick,a
	mov	(_tick + 1),a
;	demsp_uart.c:77: volatile unsigned char giay      = 0;
	mov	_giay,a
;	demsp_uart.c:78: volatile unsigned char phut      = 0;
	mov	_phut,a
;	demsp_uart.c:79: volatile unsigned char dang_chay = 0;
	mov	_dang_chay,a
;	demsp_uart.c:81: volatile unsigned int  product_count = 0;
	mov	_product_count,a
	mov	(_product_count + 1),a
;	demsp_uart.c:82: unsigned int           target_count  = 20;
	mov	_target_count,#0x14
	mov	(_target_count + 1),a
;	demsp_uart.c:83: volatile unsigned char khoa_cambien  = 0;
	mov	_khoa_cambien,a
;	demsp_uart.c:95: volatile unsigned char alarm = 0;
	mov	_alarm,a
;	demsp_uart.c:100: volatile unsigned char buf_len = 0;
	mov	_buf_len,a
;	demsp_uart.c:101: volatile unsigned char co_lenh = 0;     /* ISR dat = 1 khi da nhan du mot dong */
	mov	_co_lenh,a
	.area GSFINAL (CODE)
	ljmp	__sdcc_program_startup
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME    (CODE)
	.area HOME    (CODE)
__sdcc_program_startup:
	ljmp	_main
;	return from main will return to caller
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CSEG    (CODE)
;------------------------------------------------------------
;Allocation info for local variables in function 'timer0_isr'
;------------------------------------------------------------
;vitri         Allocated with name '_timer0_isr_vitri_10000_2'
;------------------------------------------------------------
;	demsp_uart.c:106: void timer0_isr(void) __interrupt(1)
;	-----------------------------------------
;	 function timer0_isr
;	-----------------------------------------
_timer0_isr:
	ar7 = 0x07
	ar6 = 0x06
	ar5 = 0x05
	ar4 = 0x04
	ar3 = 0x03
	ar2 = 0x02
	ar1 = 0x01
	ar0 = 0x00
	push	acc
	push	b
	push	dpl
	push	dph
	push	ar7
	push	ar6
	push	ar1
	push	psw
	mov	psw,#0x00
;	demsp_uart.c:110: TH0 = 0xFC;
	mov	_TH0,#0xfc
;	demsp_uart.c:111: TL0 = 0x66;
	mov	_TL0,#0x66
;	demsp_uart.c:113: CHON_SO1 = BO;
;	assignBit
	setb	_P2_0
;	demsp_uart.c:114: CHON_SO2 = BO;
;	assignBit
	setb	_P2_1
;	demsp_uart.c:115: CHON_SO3 = BO;
;	assignBit
	setb	_P2_2
;	demsp_uart.c:116: CHON_SO4 = BO;
;	assignBit
	setb	_P2_3
;	demsp_uart.c:118: DOAN = hienthi[vitri];
	mov	a,_timer0_isr_vitri_10000_2
	add	a, #_hienthi
	mov	r1,a
	mov	_P1,@r1
;	demsp_uart.c:120: switch (vitri) {
	mov	a,_timer0_isr_vitri_10000_2
	add	a,#0xff - 0x03
	jc	00105$
	mov	a,_timer0_isr_vitri_10000_2
	mov	b,#0x03
	mul	ab
	mov	dptr,#00163$
	jmp	@a+dptr
00163$:
	ljmp	00101$
	ljmp	00102$
	ljmp	00103$
	ljmp	00104$
;	demsp_uart.c:121: case 0: CHON_SO1 = CHON; break;
00101$:
;	assignBit
	clr	_P2_0
;	demsp_uart.c:122: case 1: CHON_SO2 = CHON; break;
	sjmp	00105$
00102$:
;	assignBit
	clr	_P2_1
;	demsp_uart.c:123: case 2: CHON_SO3 = CHON; break;
	sjmp	00105$
00103$:
;	assignBit
	clr	_P2_2
;	demsp_uart.c:124: case 3: CHON_SO4 = CHON; break;
	sjmp	00105$
00104$:
;	assignBit
	clr	_P2_3
;	demsp_uart.c:125: }
00105$:
;	demsp_uart.c:127: vitri++;
	inc	_timer0_isr_vitri_10000_2
;	demsp_uart.c:128: if (vitri > 3)
	mov	a,_timer0_isr_vitri_10000_2
	add	a,#0xff - 0x03
	jnc	00107$
;	demsp_uart.c:129: vitri = 0;
	mov	_timer0_isr_vitri_10000_2,#0x00
00107$:
;	demsp_uart.c:131: if (dang_chay) {
	mov	a,_dang_chay
	jz	00115$
;	demsp_uart.c:132: tick++;
	mov	r6,_tick
	mov	r7,(_tick + 1)
	mov	a,#0x01
	add	a, r6
	mov	_tick,a
	clr	a
	addc	a, r7
	mov	(_tick + 1),a
;	demsp_uart.c:133: if (tick >= 1000) {
	clr	c
	mov	a,_tick
	subb	a,#0xe8
	mov	a,(_tick + 1)
	subb	a,#0x03
	jc	00115$
;	demsp_uart.c:134: tick = 0;
	clr	a
	mov	_tick,a
	mov	(_tick + 1),a
;	demsp_uart.c:135: giay++;
	mov	a,_giay
	inc	a
	mov	_giay,a
;	demsp_uart.c:136: if (giay >= 60) {
	mov	a,#0x100 - 0x3c
	add	a,_giay
	jnc	00115$
;	demsp_uart.c:137: giay = 0;
	mov	_giay,#0x00
;	demsp_uart.c:138: phut++;
	mov	a,_phut
	inc	a
	mov	_phut,a
;	demsp_uart.c:139: if (phut >= 100)
	mov	a,#0x100 - 0x64
	add	a,_phut
	jnc	00115$
;	demsp_uart.c:140: phut = 0;
	mov	_phut,#0x00
00115$:
;	demsp_uart.c:145: if (khoa_cambien)
	mov	a,_khoa_cambien
	jz	00118$
;	demsp_uart.c:146: khoa_cambien--;
	mov	a,_khoa_cambien
	dec	a
	mov	_khoa_cambien,a
00118$:
;	demsp_uart.c:147: }
	pop	psw
	pop	ar1
	pop	ar6
	pop	ar7
	pop	dph
	pop	dpl
	pop	b
	pop	acc
	reti
;	eliminated unneeded push/pop ar0
;------------------------------------------------------------
;Allocation info for local variables in function 'int1_isr'
;------------------------------------------------------------
;	demsp_uart.c:152: void int1_isr(void) __interrupt(2)
;	-----------------------------------------
;	 function int1_isr
;	-----------------------------------------
_int1_isr:
	push	acc
	push	ar7
	push	ar6
	push	psw
	mov	psw,#0x00
;	demsp_uart.c:154: if (khoa_cambien)
	mov	a,_khoa_cambien
	jz	00102$
;	demsp_uart.c:155: return;
	sjmp	00105$
00102$:
;	demsp_uart.c:157: khoa_cambien = 20;
	mov	_khoa_cambien,#0x14
;	demsp_uart.c:159: if (dang_chay)
	mov	a,_dang_chay
	jz	00105$
;	demsp_uart.c:160: product_count++;
	mov	r6,_product_count
	mov	r7,(_product_count + 1)
	mov	a,#0x01
	add	a, r6
	mov	_product_count,a
	clr	a
	addc	a, r7
	mov	(_product_count + 1),a
00105$:
;	demsp_uart.c:161: }
	pop	psw
	pop	ar6
	pop	ar7
	pop	acc
	reti
;	eliminated unneeded push/pop dpl
;	eliminated unneeded push/pop dph
;	eliminated unneeded push/pop b
;------------------------------------------------------------
;Allocation info for local variables in function 'uart_isr'
;------------------------------------------------------------
;c             Allocated to registers r7 
;------------------------------------------------------------
;	demsp_uart.c:186: void uart_isr(void) __interrupt(4)
;	-----------------------------------------
;	 function uart_isr
;	-----------------------------------------
_uart_isr:
	push	acc
	push	ar7
	push	ar6
	push	ar0
	push	psw
	mov	psw,#0x00
;	demsp_uart.c:190: if (RI) {
;	demsp_uart.c:191: RI = 0;                 /* xoa bang tay, neu khong ISR goi lai vo tan */
;	assignBit
	jbc	_RI,00152$
	sjmp	00114$
00152$:
;	demsp_uart.c:192: c = SBUF;
	mov	r7,_SBUF
;	demsp_uart.c:194: if (c == '\r' || c == '\n') {
	cjne	r7,#0x0d,00153$
	sjmp	00108$
00153$:
	cjne	r7,#0x0a,00109$
00108$:
;	demsp_uart.c:195: if (buf_len > 0)
	mov	a,_buf_len
	jz	00114$
;	demsp_uart.c:196: co_lenh = 1;    /* da du mot dong -> bao main xu ly */
	mov	_co_lenh,#0x01
	sjmp	00114$
00109$:
;	demsp_uart.c:197: } else if (buf_len < BUF_MAX - 1) {
	mov	a,#0x100 - 0x13
	add	a,_buf_len
	jc	00114$
;	demsp_uart.c:198: if (c >= 'a' && c <= 'z')
	cjne	r7,#0x61,00158$
00158$:
	jc	00104$
	mov	a,r7
	add	a,#0xff - 0x7a
	jc	00104$
;	demsp_uart.c:199: c = c - 32;     /* go chu thuong cung nhan */
	mov	ar6,r7
	mov	a,r6
	add	a,#0xe0
	mov	r7,a
00104$:
;	demsp_uart.c:200: buf[buf_len++] = c;
	mov	a,_buf_len
	mov	r6,a
	inc	a
	mov	_buf_len,a
	mov	a,r6
	add	a, #_buf
	mov	r0,a
	mov	@r0,ar7
00114$:
;	demsp_uart.c:203: }
	pop	psw
	pop	ar0
	pop	ar6
	pop	ar7
	pop	acc
	reti
;	eliminated unneeded push/pop ar1
;	eliminated unneeded push/pop dpl
;	eliminated unneeded push/pop dph
;	eliminated unneeded push/pop b
;------------------------------------------------------------
;Allocation info for local variables in function 'uart_gui'
;------------------------------------------------------------
;c             Allocated to registers r7 
;------------------------------------------------------------
;	demsp_uart.c:213: void uart_gui(char c)
;	-----------------------------------------
;	 function uart_gui
;	-----------------------------------------
_uart_gui:
	mov	r7, dpl
;	demsp_uart.c:222: ES = 0;
;	assignBit
	clr	_ES
;	demsp_uart.c:223: SBUF = c;                   /* ghi vao SBUF la bat dau gui */
	mov	_SBUF,r7
;	demsp_uart.c:224: while (!TI)                 /* cho gui xong */
00101$:
;	demsp_uart.c:226: TI = 0;                     /* xoa bang tay */
;	assignBit
	jbc	_TI,00118$
	sjmp	00101$
00118$:
;	demsp_uart.c:227: ES = 1;
;	assignBit
	setb	_ES
;	demsp_uart.c:228: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'uart_chuoi'
;------------------------------------------------------------
;s             Allocated to registers 
;------------------------------------------------------------
;	demsp_uart.c:230: void uart_chuoi(char *s)
;	-----------------------------------------
;	 function uart_chuoi
;	-----------------------------------------
_uart_chuoi:
	mov	r5, dpl
	mov	r6, dph
	mov	r7, b
;	demsp_uart.c:232: while (*s)
00101$:
	mov	dpl,r5
	mov	dph,r6
	mov	b,r7
	lcall	__gptrget
	mov	r4,a
	jz	00104$
;	demsp_uart.c:233: uart_gui(*s++);
	mov	dpl,r4
	inc	r5
	cjne	r5,#0x00,00120$
	inc	r6
00120$:
	push	ar7
	push	ar6
	push	ar5
	lcall	_uart_gui
	pop	ar5
	pop	ar6
	pop	ar7
	sjmp	00101$
00104$:
;	demsp_uart.c:234: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'uart_so'
;------------------------------------------------------------
;n             Allocated to registers r6 r7 
;------------------------------------------------------------
;	demsp_uart.c:236: void uart_so(unsigned int n)
;	-----------------------------------------
;	 function uart_so
;	-----------------------------------------
_uart_so:
;	demsp_uart.c:238: uart_gui('0' + (char)(n / 1000));
	mov	r6,dpl
	mov	r7,dph
	mov	__divuint_PARM_2,#0xe8
	mov	(__divuint_PARM_2 + 1),#0x03
	push	ar7
	push	ar6
	lcall	__divuint
	mov	r4, dpl
	mov	a,#0x30
	add	a, r4
	mov	dpl,a
	lcall	_uart_gui
	pop	ar6
	pop	ar7
;	demsp_uart.c:239: uart_gui('0' + (char)((n / 100) % 10));
	mov	__divuint_PARM_2,#0x64
	mov	(__divuint_PARM_2 + 1),#0x00
	mov	dpl, r6
	mov	dph, r7
	push	ar7
	push	ar6
	lcall	__divuint
	mov	__moduint_PARM_2,#0x0a
	mov	(__moduint_PARM_2 + 1),#0x00
	lcall	__moduint
	mov	r4, dpl
	mov	a,#0x30
	add	a, r4
	mov	dpl,a
	lcall	_uart_gui
	pop	ar6
	pop	ar7
;	demsp_uart.c:240: uart_gui('0' + (char)((n / 10) % 10));
	mov	__divuint_PARM_2,#0x0a
	mov	(__divuint_PARM_2 + 1),#0x00
	mov	dpl, r6
	mov	dph, r7
	push	ar7
	push	ar6
	lcall	__divuint
	mov	__moduint_PARM_2,#0x0a
	mov	(__moduint_PARM_2 + 1),#0x00
	lcall	__moduint
	mov	r4, dpl
	mov	a,#0x30
	add	a, r4
	mov	dpl,a
	lcall	_uart_gui
	pop	ar6
	pop	ar7
;	demsp_uart.c:241: uart_gui('0' + (char)(n % 10));
	mov	__moduint_PARM_2,#0x0a
	mov	(__moduint_PARM_2 + 1),#0x00
	mov	dpl, r6
	mov	dph, r7
	lcall	__moduint
	mov	r6, dpl
	mov	a,#0x30
	add	a, r6
	mov	dpl,a
;	demsp_uart.c:242: }
	ljmp	_uart_gui
;------------------------------------------------------------
;Allocation info for local variables in function 'uart_hai_so'
;------------------------------------------------------------
;n             Allocated to registers r7 
;------------------------------------------------------------
;	demsp_uart.c:244: void uart_hai_so(unsigned char n)
;	-----------------------------------------
;	 function uart_hai_so
;	-----------------------------------------
_uart_hai_so:
	mov	r7, dpl
;	demsp_uart.c:246: uart_gui('0' + (char)(n / 10));
	mov	ar6,r7
	mov	b,#0x0a
	mov	a,r6
	div	ab
	add	a,#0x30
	mov	dpl,a
	push	ar7
	lcall	_uart_gui
	pop	ar7
;	demsp_uart.c:247: uart_gui('0' + (char)(n % 10));
	mov	b,#0x0a
	mov	a,r7
	div	ab
	mov	r7,b
	mov	a,#0x30
	add	a, r7
	mov	dpl,a
;	demsp_uart.c:248: }
	ljmp	_uart_gui
;------------------------------------------------------------
;Allocation info for local variables in function 'gui_trang_thai'
;------------------------------------------------------------
;n             Allocated to registers r6 r7 
;------------------------------------------------------------
;	demsp_uart.c:250: void gui_trang_thai(void)
;	-----------------------------------------
;	 function gui_trang_thai
;	-----------------------------------------
_gui_trang_thai:
;	demsp_uart.c:254: EA = 0;
;	assignBit
	clr	_EA
;	demsp_uart.c:255: n = product_count;
	mov	r6,_product_count
	mov	r7,(_product_count + 1)
;	demsp_uart.c:256: EA = 1;
;	assignBit
	setb	_EA
;	demsp_uart.c:258: uart_chuoi("COUNT=");
	mov	dptr,#___str_0
	mov	b, #0x80
	push	ar7
	push	ar6
	lcall	_uart_chuoi
	pop	ar6
	pop	ar7
;	demsp_uart.c:259: uart_so(n);
	mov	dpl, r6
	mov	dph, r7
	lcall	_uart_so
;	demsp_uart.c:261: uart_chuoi(" TIME=");
	mov	dptr,#___str_1
	mov	b, #0x80
	lcall	_uart_chuoi
;	demsp_uart.c:262: uart_hai_so(phut);
	mov	dpl, _phut
	lcall	_uart_hai_so
;	demsp_uart.c:263: uart_gui(':');
	mov	dpl, #0x3a
	lcall	_uart_gui
;	demsp_uart.c:264: uart_hai_so(giay);
	mov	dpl, _giay
	lcall	_uart_hai_so
;	demsp_uart.c:266: uart_chuoi(" TARGET=");
	mov	dptr,#___str_2
	mov	b, #0x80
	lcall	_uart_chuoi
;	demsp_uart.c:267: uart_so(target_count);
	mov	dpl, _target_count
	mov	dph, (_target_count + 1)
	lcall	_uart_so
;	demsp_uart.c:269: uart_chuoi(" STATE=");
	mov	dptr,#___str_3
	mov	b, #0x80
	lcall	_uart_chuoi
;	demsp_uart.c:270: if (alarm)
	mov	a,_alarm
	jz	00105$
;	demsp_uart.c:271: uart_chuoi("ALARM");
	mov	dptr,#___str_4
	mov	b, #0x80
	lcall	_uart_chuoi
	sjmp	00106$
00105$:
;	demsp_uart.c:272: else if (dang_chay)
	mov	a,_dang_chay
	jz	00102$
;	demsp_uart.c:273: uart_chuoi("RUN");
	mov	dptr,#___str_5
	mov	b, #0x80
	lcall	_uart_chuoi
	sjmp	00106$
00102$:
;	demsp_uart.c:275: uart_chuoi("PAUSE");
	mov	dptr,#___str_6
	mov	b, #0x80
	lcall	_uart_chuoi
00106$:
;	demsp_uart.c:277: uart_chuoi("\r\n");
	mov	dptr,#___str_7
	mov	b, #0x80
;	demsp_uart.c:278: }
	ljmp	_uart_chuoi
;------------------------------------------------------------
;Allocation info for local variables in function 'khop'
;------------------------------------------------------------
;tu            Allocated with name '_khop_tu_10000_24'
;i             Allocated to registers r4 
;------------------------------------------------------------
;	demsp_uart.c:283: unsigned char khop(char *tu)
;	-----------------------------------------
;	 function khop
;	-----------------------------------------
_khop:
	mov	_khop_tu_10000_24,dpl
	mov	(_khop_tu_10000_24 + 1),dph
	mov	(_khop_tu_10000_24 + 2),b
;	demsp_uart.c:287: while (tu[i]) {
	mov	r4,#0x00
00103$:
	mov	a,r4
	add	a, _khop_tu_10000_24
	mov	r2,a
	clr	a
	addc	a, (_khop_tu_10000_24 + 1)
	mov	r3,a
	mov	r7,(_khop_tu_10000_24 + 2)
	mov	dpl,r2
	mov	dph,r3
	mov	b,r7
	lcall	__gptrget
	mov	r7,a
	jz	00105$
;	demsp_uart.c:288: if (buf[i] != tu[i])
	mov	a,r4
	add	a, #_buf
	mov	r1,a
	mov	a,@r1
	cjne	a,ar7,00127$
	sjmp	00102$
00127$:
;	demsp_uart.c:289: return 0;
	mov	dpl, #0x00
	ret
00102$:
;	demsp_uart.c:290: i++;
	inc	r4
	sjmp	00103$
00105$:
;	demsp_uart.c:292: return 1;
	mov	dpl, #0x01
;	demsp_uart.c:293: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'xu_ly_lenh'
;------------------------------------------------------------
;i             Allocated with name '_xu_ly_lenh_i_10000_28'
;n             Allocated to registers r6 r7 
;------------------------------------------------------------
;	demsp_uart.c:295: void xu_ly_lenh(void)
;	-----------------------------------------
;	 function xu_ly_lenh
;	-----------------------------------------
_xu_ly_lenh:
;	demsp_uart.c:300: buf[buf_len] = 0;           /* ket thuc chuoi */
	mov	a,_buf_len
	add	a, #_buf
	mov	r0,a
	mov	@r0,#0x00
;	demsp_uart.c:302: if (khop("START")) {
	mov	dptr,#___str_8
	mov	b, #0x80
	lcall	_khop
	mov	a, dpl
	jz	00133$
;	demsp_uart.c:303: if (alarm) {
	mov	a,_alarm
	jz	00102$
;	demsp_uart.c:304: uart_chuoi("ERR ALARM - RESET HOAC SET COUNT LON HON\r\n");
	mov	dptr,#___str_9
	mov	b, #0x80
	lcall	_uart_chuoi
	ljmp	00134$
00102$:
;	demsp_uart.c:306: dang_chay = 1;
	mov	_dang_chay,#0x01
;	demsp_uart.c:307: uart_chuoi("OK RUN\r\n");
	mov	dptr,#___str_10
	mov	b, #0x80
	lcall	_uart_chuoi
	ljmp	00134$
00133$:
;	demsp_uart.c:310: } else if (khop("STOP")) {
	mov	dptr,#___str_11
	mov	b, #0x80
	lcall	_khop
	mov	a, dpl
	jz	00130$
;	demsp_uart.c:311: dang_chay = 0;
	mov	_dang_chay,#0x00
;	demsp_uart.c:312: uart_chuoi("OK PAUSE\r\n");
	mov	dptr,#___str_12
	mov	b, #0x80
	lcall	_uart_chuoi
	ljmp	00134$
00130$:
;	demsp_uart.c:314: } else if (khop("RESET")) {
	mov	dptr,#___str_13
	mov	b, #0x80
	lcall	_khop
	mov	a, dpl
	jz	00127$
;	demsp_uart.c:315: EA = 0;
;	assignBit
	clr	_EA
;	demsp_uart.c:316: product_count = 0;
	clr	a
	mov	_product_count,a
	mov	(_product_count + 1),a
;	demsp_uart.c:317: EA = 1;
;	assignBit
	setb	_EA
;	demsp_uart.c:318: giay = 0;
;	demsp_uart.c:319: phut = 0;
;	demsp_uart.c:320: tick = 0;
	clr	a
	mov	_giay,a
	mov	_phut,a
	mov	_tick,a
	mov	(_tick + 1),a
;	demsp_uart.c:321: alarm = 0;
	mov	_alarm,a
;	demsp_uart.c:322: uart_chuoi("OK RESET\r\n");
	mov	dptr,#___str_14
	mov	b, #0x80
	lcall	_uart_chuoi
	ljmp	00134$
00127$:
;	demsp_uart.c:324: } else if (khop("STATUS")) {
	mov	dptr,#___str_15
	mov	b, #0x80
	lcall	_khop
	mov	a, dpl
	jz	00124$
;	demsp_uart.c:325: gui_trang_thai();
	lcall	_gui_trang_thai
	ljmp	00134$
00124$:
;	demsp_uart.c:327: } else if (khop("SET")) {
	mov	dptr,#___str_16
	mov	b, #0x80
	lcall	_khop
	mov	a, dpl
	jnz	00240$
	ljmp	00121$
00240$:
;	demsp_uart.c:329: n = 0;
	mov	r6,#0x00
	mov	r7,#0x00
;	demsp_uart.c:331: while (i < buf_len && (buf[i] < '0' || buf[i] > '9'))
	mov	r5,#0x00
00106$:
	clr	c
	mov	a,r5
	subb	a,_buf_len
	jnc	00108$
	mov	a,r5
	add	a, #_buf
	mov	r1,a
	mov	ar4,@r1
	cjne	r4,#0x30,00242$
00242$:
	jc	00107$
	mov	a,r5
	add	a, #_buf
	mov	r1,a
	mov	a,@r1
	add	a,#0xff - 0x39
	jnc	00108$
00107$:
;	demsp_uart.c:332: i++;
	inc	r5
	sjmp	00106$
00108$:
;	demsp_uart.c:334: if (i >= buf_len) {
	clr	c
	mov	a,r5
	subb	a,_buf_len
	jc	00150$
;	demsp_uart.c:335: uart_chuoi("ERR NO NUMBER\r\n");
	mov	dptr,#___str_17
	mov	b, #0x80
	lcall	_uart_chuoi
	ljmp	00134$
;	demsp_uart.c:337: while (i < buf_len && buf[i] >= '0' && buf[i] <= '9') {
00150$:
	mov	_xu_ly_lenh_i_10000_28,r5
00111$:
	clr	c
	mov	a,_xu_ly_lenh_i_10000_28
	subb	a,_buf_len
	jnc	00113$
	mov	a,_xu_ly_lenh_i_10000_28
	add	a, #_buf
	mov	r1,a
	mov	ar4,@r1
	cjne	r4,#0x30,00247$
00247$:
	jc	00113$
	mov	a,_xu_ly_lenh_i_10000_28
	add	a, #_buf
	mov	r1,a
	mov	a,@r1
	add	a,#0xff - 0x39
	jc	00113$
;	demsp_uart.c:338: n = n * 10 + (unsigned int)(buf[i] - '0');
	mov	__mulint_PARM_2,r6
	mov	(__mulint_PARM_2 + 1),r7
	mov	dptr,#0x000a
	lcall	__mulint
	mov	r3, dpl
	mov	r4, dph
	mov	a,_xu_ly_lenh_i_10000_28
	add	a, #_buf
	mov	r1,a
	mov	ar2,@r1
	mov	r5,#0x00
	mov	a,r2
	add	a,#0xd0
	mov	r2,a
	mov	a,r5
	addc	a,#0xff
	mov	r5,a
	mov	a,r2
	add	a, r3
	mov	r6,a
	mov	a,r5
	addc	a, r4
	mov	r7,a
;	demsp_uart.c:339: i++;
	inc	_xu_ly_lenh_i_10000_28
	sjmp	00111$
00113$:
;	demsp_uart.c:341: target_count = n;
	mov	_target_count,r6
	mov	(_target_count + 1),r7
;	demsp_uart.c:344: EA = 0;
;	assignBit
	clr	_EA
;	demsp_uart.c:345: if (alarm && product_count < target_count)
	mov	a,_alarm
	jz	00115$
	clr	c
	mov	a,_product_count
	subb	a,_target_count
	mov	a,(_product_count + 1)
	subb	a,(_target_count + 1)
	jnc	00115$
;	demsp_uart.c:346: alarm = 0;
	mov	_alarm,#0x00
00115$:
;	demsp_uart.c:347: EA = 1;
;	assignBit
	setb	_EA
;	demsp_uart.c:349: uart_chuoi("OK TARGET=");
	mov	dptr,#___str_18
	mov	b, #0x80
	lcall	_uart_chuoi
;	demsp_uart.c:350: uart_so(target_count);
	mov	dpl, _target_count
	mov	dph, (_target_count + 1)
	lcall	_uart_so
;	demsp_uart.c:351: uart_chuoi("\r\n");
	mov	dptr,#___str_7
	mov	b, #0x80
	lcall	_uart_chuoi
	sjmp	00134$
00121$:
;	demsp_uart.c:355: uart_chuoi("ERR\r\n");
	mov	dptr,#___str_19
	mov	b, #0x80
	lcall	_uart_chuoi
00134$:
;	demsp_uart.c:358: buf_len = 0;
	mov	_buf_len,#0x00
;	demsp_uart.c:359: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'delay20ms'
;------------------------------------------------------------
;i             Allocated with name '_delay20ms_i_10000_41'
;j             Allocated with name '_delay20ms_j_10000_41'
;------------------------------------------------------------
;	demsp_uart.c:361: void delay20ms(void)
;	-----------------------------------------
;	 function delay20ms
;	-----------------------------------------
_delay20ms:
;	demsp_uart.c:365: for (j = 0; j < 8; j++)
	mov	_delay20ms_j_10000_41,#0x00
00107$:
	mov	a,#0x100 - 0x08
	add	a,_delay20ms_j_10000_41
	jc	00109$
;	demsp_uart.c:366: for (i = 0; i < 250; i++)
	mov	_delay20ms_i_10000_41,#0x00
00104$:
	mov	a,#0x100 - 0xfa
	add	a,_delay20ms_i_10000_41
	jc	00108$
	mov	a,_delay20ms_i_10000_41
	inc	a
	mov	_delay20ms_i_10000_41,a
	sjmp	00104$
00108$:
;	demsp_uart.c:365: for (j = 0; j < 8; j++)
	mov	a,_delay20ms_j_10000_41
	inc	a
	mov	_delay20ms_j_10000_41,a
	sjmp	00107$
00109$:
;	demsp_uart.c:368: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'cap_nhat_hienthi'
;------------------------------------------------------------
;che_do        Allocated to registers r7 
;n             Allocated to registers r6 r7 
;------------------------------------------------------------
;	demsp_uart.c:370: void cap_nhat_hienthi(unsigned char che_do)
;	-----------------------------------------
;	 function cap_nhat_hienthi
;	-----------------------------------------
_cap_nhat_hienthi:
	mov	r7, dpl
;	demsp_uart.c:374: switch (che_do) {
	cjne	r7,#0x00,00128$
	sjmp	00101$
00128$:
	cjne	r7,#0x01,00129$
	ljmp	00102$
00129$:
	cjne	r7,#0x02,00130$
	ljmp	00103$
00130$:
	ret
;	demsp_uart.c:375: case CHEDO_COUNT:
00101$:
;	demsp_uart.c:376: EA = 0;
;	assignBit
	clr	_EA
;	demsp_uart.c:377: n = product_count;
	mov	r6,_product_count
	mov	r7,(_product_count + 1)
;	demsp_uart.c:378: EA = 1;
;	assignBit
	setb	_EA
;	demsp_uart.c:379: hienthi[0] = MA7DOAN[n / 1000];
	mov	__divuint_PARM_2,#0xe8
	mov	(__divuint_PARM_2 + 1),#0x03
	mov	dpl, r6
	mov	dph, r7
	push	ar7
	push	ar6
	lcall	__divuint
	mov	r4, dpl
	mov	r5, dph
	pop	ar6
	pop	ar7
	mov	a,r4
	add	a, #_MA7DOAN
	mov	dpl,a
	mov	a,r5
	addc	a, #(_MA7DOAN >> 8)
	mov	dph,a
	clr	a
	movc	a,@a+dptr
	mov	_hienthi, a
;	demsp_uart.c:380: hienthi[1] = MA7DOAN[(n / 100) % 10];
	mov	__divuint_PARM_2,#0x64
	mov	(__divuint_PARM_2 + 1),#0x00
	mov	dpl, r6
	mov	dph, r7
	push	ar7
	push	ar6
	lcall	__divuint
	mov	__moduint_PARM_2,#0x0a
	mov	(__moduint_PARM_2 + 1),#0x00
	lcall	__moduint
	mov	r4, dpl
	mov	r5, dph
	pop	ar6
	pop	ar7
	mov	a,r4
	add	a, #_MA7DOAN
	mov	dpl,a
	mov	a,r5
	addc	a, #(_MA7DOAN >> 8)
	mov	dph,a
	clr	a
	movc	a,@a+dptr
	mov	(_hienthi + 0x0001), a
;	demsp_uart.c:381: hienthi[2] = MA7DOAN[(n / 10) % 10];
	mov	__divuint_PARM_2,#0x0a
	mov	(__divuint_PARM_2 + 1),#0x00
	mov	dpl, r6
	mov	dph, r7
	push	ar7
	push	ar6
	lcall	__divuint
	mov	__moduint_PARM_2,#0x0a
	mov	(__moduint_PARM_2 + 1),#0x00
	lcall	__moduint
	mov	r4, dpl
	mov	r5, dph
	pop	ar6
	pop	ar7
	mov	a,r4
	add	a, #_MA7DOAN
	mov	dpl,a
	mov	a,r5
	addc	a, #(_MA7DOAN >> 8)
	mov	dph,a
	clr	a
	movc	a,@a+dptr
	mov	(_hienthi + 0x0002), a
;	demsp_uart.c:382: hienthi[3] = MA7DOAN[n % 10];
	mov	__moduint_PARM_2,#0x0a
	mov	(__moduint_PARM_2 + 1),#0x00
	mov	dpl, r6
	mov	dph, r7
	lcall	__moduint
	mov	r6, dpl
	mov	r7, dph
	mov	a,r6
	add	a, #_MA7DOAN
	mov	dpl,a
	mov	a,r7
	addc	a, #(_MA7DOAN >> 8)
	mov	dph,a
	clr	a
	movc	a,@a+dptr
	mov	(_hienthi + 0x0003), a
;	demsp_uart.c:383: break;
	ret
;	demsp_uart.c:385: case CHEDO_TIME:
00102$:
;	demsp_uart.c:386: hienthi[0] = MA7DOAN[phut / 10];
	mov	r7,_phut
	mov	b,#0x0a
	mov	a,r7
	div	ab
	mov	dptr,#_MA7DOAN
	movc	a,@a+dptr
	mov	_hienthi, a
;	demsp_uart.c:387: hienthi[1] = MA7DOAN[phut % 10] | DAU_CHAM;
	mov	r7,_phut
	mov	b,#0x0a
	mov	a,r7
	div	ab
	mov	a,b
	mov	dptr,#_MA7DOAN
	movc	a,@a+dptr
	mov	r7,a
	mov	a,#0x80
	orl	a,r7
	mov	(_hienthi + 0x0001),a
;	demsp_uart.c:388: hienthi[2] = MA7DOAN[giay / 10];
	mov	r7,_giay
	mov	b,#0x0a
	mov	a,r7
	div	ab
	mov	dptr,#_MA7DOAN
	movc	a,@a+dptr
	mov	(_hienthi + 0x0002), a
;	demsp_uart.c:389: hienthi[3] = MA7DOAN[giay % 10];
	mov	r7,_giay
	mov	b,#0x0a
	mov	a,r7
	div	ab
	mov	a,b
	mov	dptr,#_MA7DOAN
	movc	a,@a+dptr
	mov	(_hienthi + 0x0003), a
;	demsp_uart.c:390: break;
	ret
;	demsp_uart.c:392: case CHEDO_TARGET:
00103$:
;	demsp_uart.c:393: n = target_count;
	mov	r6,_target_count
	mov	r7,(_target_count + 1)
;	demsp_uart.c:394: hienthi[0] = MA_CHU_P;
	mov	_hienthi,#0x73
;	demsp_uart.c:395: hienthi[1] = MA7DOAN[(n / 100) % 10];
	mov	__divuint_PARM_2,#0x64
	mov	(__divuint_PARM_2 + 1),#0x00
	mov	dpl, r6
	mov	dph, r7
	push	ar7
	push	ar6
	lcall	__divuint
	mov	__moduint_PARM_2,#0x0a
	mov	(__moduint_PARM_2 + 1),#0x00
	lcall	__moduint
	mov	r4, dpl
	mov	r5, dph
	pop	ar6
	pop	ar7
	mov	a,r4
	add	a, #_MA7DOAN
	mov	dpl,a
	mov	a,r5
	addc	a, #(_MA7DOAN >> 8)
	mov	dph,a
	clr	a
	movc	a,@a+dptr
	mov	(_hienthi + 0x0001), a
;	demsp_uart.c:396: hienthi[2] = MA7DOAN[(n / 10) % 10];
	mov	__divuint_PARM_2,#0x0a
	mov	(__divuint_PARM_2 + 1),#0x00
	mov	dpl, r6
	mov	dph, r7
	push	ar7
	push	ar6
	lcall	__divuint
	mov	__moduint_PARM_2,#0x0a
	mov	(__moduint_PARM_2 + 1),#0x00
	lcall	__moduint
	mov	r4, dpl
	mov	r5, dph
	pop	ar6
	pop	ar7
	mov	a,r4
	add	a, #_MA7DOAN
	mov	dpl,a
	mov	a,r5
	addc	a, #(_MA7DOAN >> 8)
	mov	dph,a
	clr	a
	movc	a,@a+dptr
	mov	(_hienthi + 0x0002), a
;	demsp_uart.c:397: hienthi[3] = MA7DOAN[n % 10];
	mov	__moduint_PARM_2,#0x0a
	mov	(__moduint_PARM_2 + 1),#0x00
	mov	dpl, r6
	mov	dph, r7
	lcall	__moduint
	mov	r6, dpl
	mov	r7, dph
	mov	a,r6
	add	a, #_MA7DOAN
	mov	dpl,a
	mov	a,r7
	addc	a, #(_MA7DOAN >> 8)
	mov	dph,a
	clr	a
	movc	a,@a+dptr
	mov	(_hienthi + 0x0003), a
;	demsp_uart.c:399: }
;	demsp_uart.c:400: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
;che_do        Allocated to registers r7 
;giay_cu       Allocated to registers r6 
;dem_tam       Allocated to registers r4 r5 
;------------------------------------------------------------
;	demsp_uart.c:402: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	demsp_uart.c:404: unsigned char che_do   = CHEDO_COUNT;
	mov	r7,#0x00
;	demsp_uart.c:405: unsigned char giay_cu  = 0;
	mov	r6,#0x00
;	demsp_uart.c:408: P2 = 0xFF;
	mov	_P2,#0xff
;	demsp_uart.c:409: P3 = 0xFF;
	mov	_P3,#0xff
;	demsp_uart.c:410: DOAN = 0x00;
	mov	_P1,r7
;	demsp_uart.c:420: TMOD = 0x21;
	mov	_TMOD,#0x21
;	demsp_uart.c:422: TH0 = 0xFC;                 /* Timer 0: ngat moi 1 ms */
	mov	_TH0,#0xfc
;	demsp_uart.c:423: TL0 = 0x66;
	mov	_TL0,#0x66
;	demsp_uart.c:425: TH1 = 0xFD;                 /* Timer 1: 9600 baud @ 11,0592 MHz */
	mov	_TH1,#0xfd
;	demsp_uart.c:426: TL1 = 0xFD;
	mov	_TL1,#0xfd
;	demsp_uart.c:427: SCON = 0x50;                /* che do 1 (8 bit), REN = 1 (cho phep nhan) */
	mov	_SCON,#0x50
;	demsp_uart.c:428: TR1 = 1;                    /* ⚠ phai cho Timer 1 CHAY thi moi co xung baud */
;	assignBit
	setb	_TR1
;	demsp_uart.c:430: IT1 = 1;                    /* INT1 kich canh xuong */
;	assignBit
	setb	_IT1
;	demsp_uart.c:431: ET0 = 1;                    /* ngat Timer 0 */
;	assignBit
	setb	_ET0
;	demsp_uart.c:432: EX1 = 1;                    /* ngat ngoai 1 */
;	assignBit
	setb	_EX1
;	demsp_uart.c:433: ES  = 1;                    /* ⭐ ngat cong noi tiep - de khong bo sot ky tu */
;	assignBit
	setb	_ES
;	demsp_uart.c:434: EA  = 1;                    /* cong tac tong */
;	assignBit
	setb	_EA
;	demsp_uart.c:435: TR0 = 1;
;	assignBit
	setb	_TR0
;	demsp_uart.c:437: uart_chuoi("\r\nHE THONG DEM SAN PHAM - AT89C51\r\n");
	mov	dptr,#___str_20
	mov	b, #0x80
	push	ar7
	push	ar6
	lcall	_uart_chuoi
;	demsp_uart.c:438: uart_chuoi("Lenh: START STOP RESET STATUS | SET COUNT n\r\n");
	mov	dptr,#___str_21
	mov	b, #0x80
	lcall	_uart_chuoi
;	demsp_uart.c:439: gui_trang_thai();
	lcall	_gui_trang_thai
	pop	ar6
	pop	ar7
;	demsp_uart.c:441: while (1) {
00141$:
;	demsp_uart.c:443: cap_nhat_hienthi(che_do);
	mov	dpl, r7
	push	ar7
	push	ar6
	lcall	_cap_nhat_hienthi
	pop	ar6
	pop	ar7
;	demsp_uart.c:446: if (co_lenh) {
	mov	a,_co_lenh
	jz	00102$
;	demsp_uart.c:447: co_lenh = 0;
	mov	_co_lenh,#0x00
;	demsp_uart.c:448: xu_ly_lenh();
	push	ar7
	push	ar6
	lcall	_xu_ly_lenh
	pop	ar6
	pop	ar7
00102$:
;	demsp_uart.c:452: if (dang_chay && giay != giay_cu) {
	mov	a,_dang_chay
	jz	00104$
	mov	a,r6
	cjne	a,_giay,00269$
	sjmp	00104$
00269$:
;	demsp_uart.c:453: giay_cu = giay;
	mov	r6,_giay
;	demsp_uart.c:454: gui_trang_thai();
	push	ar7
	push	ar6
	lcall	_gui_trang_thai
	pop	ar6
	pop	ar7
00104$:
;	demsp_uart.c:458: if (NUT_STARTSTOP == NHAN) {
	jb	_P3_2,00114$
;	demsp_uart.c:459: delay20ms();
	push	ar7
	push	ar6
	lcall	_delay20ms
	pop	ar6
	pop	ar7
;	demsp_uart.c:460: if (NUT_STARTSTOP == NHAN) {
	jb	_P3_2,00114$
;	demsp_uart.c:461: if (!alarm)             /* dang ALARM thi phai RESET truoc */
	mov	a,_alarm
	jnz	00108$
;	demsp_uart.c:462: dang_chay = dang_chay ? 0 : 1;
	mov	a,_dang_chay
	jz	00145$
	mov	r5,#0x00
	sjmp	00146$
00145$:
	mov	r5,#0x01
00146$:
	mov	_dang_chay,r5
;	demsp_uart.c:463: while (NUT_STARTSTOP == NHAN)
00108$:
	jnb	_P3_2,00108$
00114$:
;	demsp_uart.c:468: if (NUT_MODE == NHAN) {
	jb	_P3_6,00123$
;	demsp_uart.c:469: delay20ms();
	push	ar7
	push	ar6
	lcall	_delay20ms
	pop	ar6
	pop	ar7
;	demsp_uart.c:470: if (NUT_MODE == NHAN) {
	jb	_P3_6,00123$
;	demsp_uart.c:471: che_do++;
	inc	r7
;	demsp_uart.c:472: if (che_do > CHEDO_TARGET)
	mov	a,r7
	add	a,#0xff - 0x02
	jnc	00117$
;	demsp_uart.c:473: che_do = CHEDO_COUNT;
	mov	r7,#0x00
;	demsp_uart.c:474: while (NUT_MODE == NHAN)
00117$:
	jnb	_P3_6,00117$
00123$:
;	demsp_uart.c:479: if (NUT_RESET == NHAN) {
	jb	_P2_7,00130$
;	demsp_uart.c:480: delay20ms();
	push	ar7
	push	ar6
	lcall	_delay20ms
	pop	ar6
	pop	ar7
;	demsp_uart.c:481: if (NUT_RESET == NHAN) {
	jb	_P2_7,00130$
;	demsp_uart.c:482: EA = 0;
;	assignBit
	clr	_EA
;	demsp_uart.c:483: product_count = 0;
	clr	a
	mov	_product_count,a
	mov	(_product_count + 1),a
;	demsp_uart.c:484: EA = 1;
;	assignBit
	setb	_EA
;	demsp_uart.c:485: giay  = 0;
;	demsp_uart.c:486: phut  = 0;
;	demsp_uart.c:487: tick  = 0;
	clr	a
	mov	_giay,a
	mov	_phut,a
	mov	_tick,a
	mov	(_tick + 1),a
;	demsp_uart.c:488: alarm = 0;
	mov	_alarm,a
;	demsp_uart.c:489: while (NUT_RESET == NHAN)
00124$:
	jnb	_P2_7,00124$
00130$:
;	demsp_uart.c:501: EA = 0;
;	assignBit
	clr	_EA
;	demsp_uart.c:502: dem_tam = product_count;
	mov	r4,_product_count
	mov	r5,(_product_count + 1)
;	demsp_uart.c:503: EA = 1;
;	assignBit
	setb	_EA
;	demsp_uart.c:505: if (dang_chay && dem_tam >= target_count) {
	mov	a,_dang_chay
	jz	00132$
	clr	c
	mov	a,r4
	subb	a,_target_count
	mov	a,r5
	subb	a,(_target_count + 1)
	jc	00132$
;	demsp_uart.c:506: dang_chay = 0;              /* DUNG day chuyen */
	mov	_dang_chay,#0x00
;	demsp_uart.c:507: alarm     = 1;
	mov	_alarm,#0x01
;	demsp_uart.c:508: uart_chuoi("ALARM! DA DAT MUC TIEU\r\n");
	mov	dptr,#___str_22
	mov	b, #0x80
	push	ar7
	push	ar6
	lcall	_uart_chuoi
;	demsp_uart.c:509: gui_trang_thai();
	lcall	_gui_trang_thai
	pop	ar6
	pop	ar7
00132$:
;	demsp_uart.c:513: if (alarm) {
	mov	a,_alarm
	jz	00138$
;	demsp_uart.c:514: LED_XANH = TAT;
;	assignBit
	setb	_P2_4
;	demsp_uart.c:515: LED_VANG = TAT;
;	assignBit
	setb	_P2_5
;	demsp_uart.c:516: LED_DO   = SANG;
;	assignBit
	clr	_P2_6
	ljmp	00141$
00138$:
;	demsp_uart.c:517: } else if (dang_chay) {
	mov	a,_dang_chay
	jz	00135$
;	demsp_uart.c:518: LED_XANH = SANG;
;	assignBit
	clr	_P2_4
;	demsp_uart.c:519: LED_VANG = TAT;
;	assignBit
	setb	_P2_5
;	demsp_uart.c:520: LED_DO   = TAT;
;	assignBit
	setb	_P2_6
	ljmp	00141$
00135$:
;	demsp_uart.c:522: LED_XANH = TAT;
;	assignBit
	setb	_P2_4
;	demsp_uart.c:523: LED_VANG = SANG;
;	assignBit
	clr	_P2_5
;	demsp_uart.c:524: LED_DO   = TAT;
;	assignBit
	setb	_P2_6
;	demsp_uart.c:527: }
	ljmp	00141$
	.area CSEG    (CODE)
	.area CONST   (CODE)
	.area CONST   (CODE)
_MA7DOAN:
	.db #0x3f	; 63
	.db #0x06	; 6
	.db #0x5b	; 91
	.db #0x4f	; 79	'O'
	.db #0x66	; 102	'f'
	.db #0x6d	; 109	'm'
	.db #0x7d	; 125
	.db #0x07	; 7
	.db #0x7f	; 127
	.db #0x6f	; 111	'o'
	.area CSEG    (CODE)
	.area CONST   (CODE)
___str_0:
	.ascii "COUNT="
	.db 0x00
	.area CSEG    (CODE)
	.area CONST   (CODE)
___str_1:
	.ascii " TIME="
	.db 0x00
	.area CSEG    (CODE)
	.area CONST   (CODE)
___str_2:
	.ascii " TARGET="
	.db 0x00
	.area CSEG    (CODE)
	.area CONST   (CODE)
___str_3:
	.ascii " STATE="
	.db 0x00
	.area CSEG    (CODE)
	.area CONST   (CODE)
___str_4:
	.ascii "ALARM"
	.db 0x00
	.area CSEG    (CODE)
	.area CONST   (CODE)
___str_5:
	.ascii "RUN"
	.db 0x00
	.area CSEG    (CODE)
	.area CONST   (CODE)
___str_6:
	.ascii "PAUSE"
	.db 0x00
	.area CSEG    (CODE)
	.area CONST   (CODE)
___str_7:
	.db 0x0d
	.db 0x0a
	.db 0x00
	.area CSEG    (CODE)
	.area CONST   (CODE)
___str_8:
	.ascii "START"
	.db 0x00
	.area CSEG    (CODE)
	.area CONST   (CODE)
___str_9:
	.ascii "ERR ALARM - RESET HOAC SET COUNT LON HON"
	.db 0x0d
	.db 0x0a
	.db 0x00
	.area CSEG    (CODE)
	.area CONST   (CODE)
___str_10:
	.ascii "OK RUN"
	.db 0x0d
	.db 0x0a
	.db 0x00
	.area CSEG    (CODE)
	.area CONST   (CODE)
___str_11:
	.ascii "STOP"
	.db 0x00
	.area CSEG    (CODE)
	.area CONST   (CODE)
___str_12:
	.ascii "OK PAUSE"
	.db 0x0d
	.db 0x0a
	.db 0x00
	.area CSEG    (CODE)
	.area CONST   (CODE)
___str_13:
	.ascii "RESET"
	.db 0x00
	.area CSEG    (CODE)
	.area CONST   (CODE)
___str_14:
	.ascii "OK RESET"
	.db 0x0d
	.db 0x0a
	.db 0x00
	.area CSEG    (CODE)
	.area CONST   (CODE)
___str_15:
	.ascii "STATUS"
	.db 0x00
	.area CSEG    (CODE)
	.area CONST   (CODE)
___str_16:
	.ascii "SET"
	.db 0x00
	.area CSEG    (CODE)
	.area CONST   (CODE)
___str_17:
	.ascii "ERR NO NUMBER"
	.db 0x0d
	.db 0x0a
	.db 0x00
	.area CSEG    (CODE)
	.area CONST   (CODE)
___str_18:
	.ascii "OK TARGET="
	.db 0x00
	.area CSEG    (CODE)
	.area CONST   (CODE)
___str_19:
	.ascii "ERR"
	.db 0x0d
	.db 0x0a
	.db 0x00
	.area CSEG    (CODE)
	.area CONST   (CODE)
___str_20:
	.db 0x0d
	.db 0x0a
	.ascii "HE THONG DEM SAN PHAM - AT89C51"
	.db 0x0d
	.db 0x0a
	.db 0x00
	.area CSEG    (CODE)
	.area CONST   (CODE)
___str_21:
	.ascii "Lenh: START STOP RESET STATUS | SET COUNT n"
	.db 0x0d
	.db 0x0a
	.db 0x00
	.area CSEG    (CODE)
	.area CONST   (CODE)
___str_22:
	.ascii "ALARM! DA DAT MUC TIEU"
	.db 0x0d
	.db 0x0a
	.db 0x00
	.area CSEG    (CODE)
	.area XINIT   (CODE)
	.area CABS    (ABS,CODE)
