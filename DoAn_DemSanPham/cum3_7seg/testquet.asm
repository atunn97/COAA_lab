;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.0 #15242 (MINGW64)
;--------------------------------------------------------
	.module testquet
	
	.optsdcc -mmcs51 --model-small
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _MAU
	.globl _MA7DOAN
	.globl _main
	.globl _delay5ms
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
;--------------------------------------------------------
; overlayable items in internal ram
;--------------------------------------------------------
	.area	OSEG    (OVR,DATA)
_delay5ms_i_10000_2:
	.ds 1
_delay5ms_j_10000_2:
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
_main_sloc0_1_0:
	.ds 1
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
; restartable atomic support routines
	.ds	5
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
;Allocation info for local variables in function 'delay5ms'
;------------------------------------------------------------
;i             Allocated with name '_delay5ms_i_10000_2'
;j             Allocated with name '_delay5ms_j_10000_2'
;------------------------------------------------------------
;	testquet.c:59: void delay5ms(void)
;	-----------------------------------------
;	 function delay5ms
;	-----------------------------------------
_delay5ms:
	ar7 = 0x07
	ar6 = 0x06
	ar5 = 0x05
	ar4 = 0x04
	ar3 = 0x03
	ar2 = 0x02
	ar1 = 0x01
	ar0 = 0x00
;	testquet.c:63: for (j = 0; j < 2; j++)
	mov	_delay5ms_j_10000_2,#0x00
00107$:
	mov	a,#0x100 - 0x02
	add	a,_delay5ms_j_10000_2
	jc	00109$
;	testquet.c:64: for (i = 0; i < 250; i++)
	mov	_delay5ms_i_10000_2,#0x00
00104$:
	mov	a,#0x100 - 0xfa
	add	a,_delay5ms_i_10000_2
	jc	00108$
	mov	a,_delay5ms_i_10000_2
	inc	a
	mov	_delay5ms_i_10000_2,a
	sjmp	00104$
00108$:
;	testquet.c:63: for (j = 0; j < 2; j++)
	mov	a,_delay5ms_j_10000_2
	inc	a
	mov	_delay5ms_j_10000_2,a
	sjmp	00107$
00109$:
;	testquet.c:66: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
;vitri         Allocated to registers r3 
;mau           Allocated to registers r7 
;mode_da_xu_ly Allocated to registers r6 
;------------------------------------------------------------
;	testquet.c:68: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	testquet.c:71: unsigned char mau = 0;              /* 0, 1, 2 */
	mov	r7,#0x00
;	testquet.c:72: unsigned char mode_da_xu_ly = 0;
	mov	r6,#0x00
;	testquet.c:74: P2 = 0xF0;
	mov	_P2,#0xf0
;	testquet.c:75: P3 = 0xFF;
	mov	_P3,#0xff
;	testquet.c:76: DOAN = 0x00;
	mov	_P1,r7
;	testquet.c:81: for (vitri = 0; vitri < 4; vitri++) {
00122$:
	mov	a,r7
	mov	b,#0x04
	mul	ab
	add	a, #_MAU
	mov	r4,a
	mov	a,#(_MAU >> 8)
	addc	a, b
	mov	r5,a
	mov	r3,#0x00
00117$:
;	testquet.c:83: CHON_SO1 = 0;               /* 1. tat het */
;	assignBit
	clr	_P2_0
;	testquet.c:84: CHON_SO2 = 0;
;	assignBit
	clr	_P2_1
;	testquet.c:85: CHON_SO3 = 0;
;	assignBit
	clr	_P2_2
;	testquet.c:86: CHON_SO4 = 0;
;	assignBit
	clr	_P2_3
;	testquet.c:88: DOAN = MA7DOAN[MAU[mau][vitri]];    /* 2. doi du lieu */
	mov	a,r3
	add	a, r4
	mov	dpl,a
	clr	a
	addc	a, r5
	mov	dph,a
	clr	a
	movc	a,@a+dptr
	mov	r2,a
	mov	dptr,#_MA7DOAN
	movc	a,@a+dptr
	mov	_P1,a
;	testquet.c:90: switch (vitri) {            /* 3. bat so moi */
	mov	a,r3
	add	a,r3
;	testquet.c:91: case 0: CHON_SO1 = 1; break;
	mov	dptr,#00160$
	jmp	@a+dptr
00160$:
	sjmp	00101$
	sjmp	00102$
	sjmp	00103$
	sjmp	00104$
00101$:
;	assignBit
	setb	_P2_0
;	testquet.c:92: case 1: CHON_SO2 = 1; break;
	sjmp	00105$
00102$:
;	assignBit
	setb	_P2_1
;	testquet.c:93: case 2: CHON_SO3 = 1; break;
	sjmp	00105$
00103$:
;	assignBit
	setb	_P2_2
;	testquet.c:94: case 3: CHON_SO4 = 1; break;
	sjmp	00105$
00104$:
;	assignBit
	setb	_P2_3
;	testquet.c:95: }
00105$:
;	testquet.c:97: delay5ms();
	push	ar7
	push	ar6
	push	ar5
	push	ar4
	push	ar3
	lcall	_delay5ms
	pop	ar3
	pop	ar4
	pop	ar5
	pop	ar6
	pop	ar7
;	testquet.c:81: for (vitri = 0; vitri < 4; vitri++) {
	inc	r3
	cjne	r3,#0x04,00161$
00161$:
	jc	00117$
;	testquet.c:101: if (NUT_MODE == NHAN) {
	jb	_P3_5,00112$
;	testquet.c:102: if (!mode_da_xu_ly) {
	mov	a,r6
	jnz	00113$
;	testquet.c:103: mode_da_xu_ly = 1;
	mov	r6,#0x01
;	testquet.c:104: mau++;
	inc	r7
;	testquet.c:105: if (mau > 2)
	mov	a,r7
	add	a,#0xff - 0x02
	jnc	00113$
;	testquet.c:106: mau = 0;
	mov	r7,#0x00
	sjmp	00113$
00112$:
;	testquet.c:109: mode_da_xu_ly = 0;
	mov	r6,#0x00
00113$:
;	testquet.c:113: LED_XANH = (mau == 0) ? SANG : TAT;
	mov	a,r7
	cjne	a,#0x01,00166$
00166$:
	cpl	c
	mov	_main_sloc0_1_0,c
	clr	a
	rlc	a
	add	a,#0xff
	mov	_P2_4,c
;	testquet.c:114: LED_VANG = (mau == 1) ? SANG : TAT;
	cjne	r7,#0x01,00167$
	mov	a,r7
	sjmp	00168$
00167$:
	clr	a
00168$:
	cjne	a,#0x01,00169$
00169$:
	mov  _main_sloc0_1_0,c
	clr	a
	rlc	a
	add	a,#0xff
	mov	_P2_5,c
;	testquet.c:115: LED_DO   = (mau == 2) ? SANG : TAT;
	clr	a
	cjne	r7,#0x02,00170$
	inc	a
00170$:
	cjne	a,#0x01,00172$
00172$:
	mov  _main_sloc0_1_0,c
	clr	a
	rlc	a
	add	a,#0xff
	mov	_P2_6,c
;	testquet.c:117: }
	ljmp	00122$
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
_MAU:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x01	; 1
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x04	; 4
	.area CSEG    (CODE)
	.area XINIT   (CODE)
	.area CABS    (ABS,CODE)
