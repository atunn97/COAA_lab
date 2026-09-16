;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.0 #15242 (MINGW64)
;--------------------------------------------------------
	.module testint1
	
	.optsdcc -mmcs51 --model-small
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _MA7DOAN
	.globl _main
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
	.globl _khoa_cambien
	.globl _product_count
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
_product_count::
	.ds 2
_khoa_cambien::
	.ds 1
_timer0_isr_vitri_10000_2:
	.ds 1
;--------------------------------------------------------
; overlayable items in internal ram
;--------------------------------------------------------
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
;	testint1.c:59: static unsigned char vitri = 0;
	mov	_timer0_isr_vitri_10000_2,#0x00
;	testint1.c:52: volatile unsigned char hienthi[4] = { 0x3F, 0x3F, 0x3F, 0x3F };
	mov	_hienthi,#0x3f
	mov	(_hienthi + 0x0001),#0x3f
	mov	(_hienthi + 0x0002),#0x3f
	mov	(_hienthi + 0x0003),#0x3f
;	testint1.c:53: volatile unsigned int  product_count = 0;
	clr	a
	mov	_product_count,a
	mov	(_product_count + 1),a
;	testint1.c:54: volatile unsigned char khoa_cambien  = 0;
	mov	_khoa_cambien,a
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
;	testint1.c:57: void timer0_isr(void) __interrupt(1)
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
	push	ar1
	push	psw
	mov	psw,#0x00
;	testint1.c:61: TH0 = 0xFC;
	mov	_TH0,#0xfc
;	testint1.c:62: TL0 = 0x66;
	mov	_TL0,#0x66
;	testint1.c:64: CHON_SO1 = BO;
;	assignBit
	setb	_P2_0
;	testint1.c:65: CHON_SO2 = BO;
;	assignBit
	setb	_P2_1
;	testint1.c:66: CHON_SO3 = BO;
;	assignBit
	setb	_P2_2
;	testint1.c:67: CHON_SO4 = BO;
;	assignBit
	setb	_P2_3
;	testint1.c:69: DOAN = hienthi[vitri];
	mov	a,_timer0_isr_vitri_10000_2
	add	a, #_hienthi
	mov	r1,a
	mov	_P1,@r1
;	testint1.c:71: switch (vitri) {
	mov	a,_timer0_isr_vitri_10000_2
	add	a,#0xff - 0x03
	jc	00105$
	mov	a,_timer0_isr_vitri_10000_2
	mov	b,#0x03
	mul	ab
	mov	dptr,#00131$
	jmp	@a+dptr
00131$:
	ljmp	00101$
	ljmp	00102$
	ljmp	00103$
	ljmp	00104$
;	testint1.c:72: case 0: CHON_SO1 = CHON; break;
00101$:
;	assignBit
	clr	_P2_0
;	testint1.c:73: case 1: CHON_SO2 = CHON; break;
	sjmp	00105$
00102$:
;	assignBit
	clr	_P2_1
;	testint1.c:74: case 2: CHON_SO3 = CHON; break;
	sjmp	00105$
00103$:
;	assignBit
	clr	_P2_2
;	testint1.c:75: case 3: CHON_SO4 = CHON; break;
	sjmp	00105$
00104$:
;	assignBit
	clr	_P2_3
;	testint1.c:76: }
00105$:
;	testint1.c:78: vitri++;
	inc	_timer0_isr_vitri_10000_2
;	testint1.c:79: if (vitri > 3)
	mov	a,_timer0_isr_vitri_10000_2
	add	a,#0xff - 0x03
	jnc	00107$
;	testint1.c:80: vitri = 0;
	mov	_timer0_isr_vitri_10000_2,#0x00
00107$:
;	testint1.c:82: if (khoa_cambien)
	mov	a,_khoa_cambien
	jz	00110$
;	testint1.c:83: khoa_cambien--;
	mov	a,_khoa_cambien
	dec	a
	mov	_khoa_cambien,a
00110$:
;	testint1.c:84: }
	pop	psw
	pop	ar1
	pop	dph
	pop	dpl
	pop	b
	pop	acc
	reti
;	eliminated unneeded push/pop ar0
;------------------------------------------------------------
;Allocation info for local variables in function 'int1_isr'
;------------------------------------------------------------
;	testint1.c:87: void int1_isr(void) __interrupt(2)
;	-----------------------------------------
;	 function int1_isr
;	-----------------------------------------
_int1_isr:
	push	acc
	push	ar7
	push	ar6
	push	psw
	mov	psw,#0x00
;	testint1.c:89: if (khoa_cambien)
	mov	a,_khoa_cambien
	jz	00102$
;	testint1.c:90: return;
	sjmp	00103$
00102$:
;	testint1.c:92: khoa_cambien = 20;
	mov	_khoa_cambien,#0x14
;	testint1.c:94: product_count++;
	mov	r6,_product_count
	mov	r7,(_product_count + 1)
	mov	a,#0x01
	add	a, r6
	mov	_product_count,a
	clr	a
	addc	a, r7
	mov	(_product_count + 1),a
;	testint1.c:96: LED_XANH = !LED_XANH;       /* dau hieu song: ngat vua chay */
	cpl	_P2_4
00103$:
;	testint1.c:97: }
	pop	psw
	pop	ar6
	pop	ar7
	pop	acc
	reti
;	eliminated unneeded push/pop dpl
;	eliminated unneeded push/pop dph
;	eliminated unneeded push/pop b
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
;n             Allocated to registers r6 r7 
;------------------------------------------------------------
;	testint1.c:99: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	testint1.c:103: P2 = 0xFF;
	mov	_P2,#0xff
;	testint1.c:104: P3 = 0xFF;                  /* bat buoc: tha noi cao P3.3 thi moi co
	mov	_P3,#0xff
;	testint1.c:106: DOAN = 0x00;
	mov	_P1,#0x00
;	testint1.c:108: LED_VANG = 1;               /* tat */
;	assignBit
	setb	_P2_5
;	testint1.c:109: LED_DO   = 1;               /* tat */
;	assignBit
	setb	_P2_6
;	testint1.c:111: TMOD = 0x01;
	mov	_TMOD,#0x01
;	testint1.c:112: TH0  = 0xFC;
	mov	_TH0,#0xfc
;	testint1.c:113: TL0  = 0x66;
	mov	_TL0,#0x66
;	testint1.c:115: IT1 = 1;                    /* INT1 kich theo canh xuong */
;	assignBit
	setb	_IT1
;	testint1.c:116: ET0 = 1;
;	assignBit
	setb	_ET0
;	testint1.c:117: EX1 = 1;
;	assignBit
	setb	_EX1
;	testint1.c:118: EA  = 1;
;	assignBit
	setb	_EA
;	testint1.c:119: TR0 = 1;
;	assignBit
	setb	_TR0
;	testint1.c:121: while (1) {
00102$:
;	testint1.c:122: EA = 0;
;	assignBit
	clr	_EA
;	testint1.c:123: n = product_count;
	mov	r6,_product_count
	mov	r7,(_product_count + 1)
;	testint1.c:124: EA = 1;
;	assignBit
	setb	_EA
;	testint1.c:126: hienthi[0] = MA7DOAN[n / 1000];
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
;	testint1.c:127: hienthi[1] = MA7DOAN[(n / 100) % 10];
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
;	testint1.c:128: hienthi[2] = MA7DOAN[(n / 10) % 10];
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
;	testint1.c:129: hienthi[3] = MA7DOAN[n % 10];
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
;	testint1.c:131: }
	ljmp	00102$
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
	.area XINIT   (CODE)
	.area CABS    (ABS,CODE)
