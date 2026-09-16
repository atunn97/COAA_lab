;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.0 #15242 (MINGW64)
;--------------------------------------------------------
	.module demsp
	
	.optsdcc -mmcs51 --model-small
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _MA7DOAN
	.globl _main
	.globl _cap_nhat_hienthi
	.globl _delay20ms
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
_timer0_isr_vitri_10000_2:
	.ds 1
;--------------------------------------------------------
; overlayable items in internal ram
;--------------------------------------------------------
	.area	OSEG    (OVR,DATA)
_delay20ms_i_10000_10:
	.ds 1
_delay20ms_j_10000_10:
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
;	demsp.c:94: static unsigned char vitri = 0;
	mov	_timer0_isr_vitri_10000_2,#0x00
;	demsp.c:67: volatile unsigned char hienthi[4] = { 0x3F, 0x3F, 0x3F, 0x3F };
	mov	_hienthi,#0x3f
	mov	(_hienthi + 0x0001),#0x3f
	mov	(_hienthi + 0x0002),#0x3f
	mov	(_hienthi + 0x0003),#0x3f
;	demsp.c:69: volatile unsigned int  tick      = 0;
	clr	a
	mov	_tick,a
	mov	(_tick + 1),a
;	demsp.c:70: volatile unsigned char giay      = 0;
	mov	_giay,a
;	demsp.c:71: volatile unsigned char phut      = 0;
	mov	_phut,a
;	demsp.c:72: volatile unsigned char dang_chay = 0;
	mov	_dang_chay,a
;	demsp.c:74: volatile unsigned int  product_count = 0;
	mov	_product_count,a
	mov	(_product_count + 1),a
;	demsp.c:80: unsigned int           target_count  = 20;
	mov	_target_count,#0x14
	mov	(_target_count + 1),a
;	demsp.c:87: volatile unsigned char khoa_cambien = 0;
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
;	demsp.c:92: void timer0_isr(void) __interrupt(1)
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
;	demsp.c:96: TH0 = 0xFC;                 /* che do 1 khong tu nap lai */
	mov	_TH0,#0xfc
;	demsp.c:97: TL0 = 0x66;
	mov	_TL0,#0x66
;	demsp.c:100: CHON_SO1 = BO;
;	assignBit
	setb	_P2_0
;	demsp.c:101: CHON_SO2 = BO;
;	assignBit
	setb	_P2_1
;	demsp.c:102: CHON_SO3 = BO;
;	assignBit
	setb	_P2_2
;	demsp.c:103: CHON_SO4 = BO;
;	assignBit
	setb	_P2_3
;	demsp.c:105: DOAN = hienthi[vitri];
	mov	a,_timer0_isr_vitri_10000_2
	add	a, #_hienthi
	mov	r1,a
	mov	_P1,@r1
;	demsp.c:107: switch (vitri) {
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
;	demsp.c:108: case 0: CHON_SO1 = CHON; break;
00101$:
;	assignBit
	clr	_P2_0
;	demsp.c:109: case 1: CHON_SO2 = CHON; break;
	sjmp	00105$
00102$:
;	assignBit
	clr	_P2_1
;	demsp.c:110: case 2: CHON_SO3 = CHON; break;
	sjmp	00105$
00103$:
;	assignBit
	clr	_P2_2
;	demsp.c:111: case 3: CHON_SO4 = CHON; break;
	sjmp	00105$
00104$:
;	assignBit
	clr	_P2_3
;	demsp.c:112: }
00105$:
;	demsp.c:114: vitri++;
	inc	_timer0_isr_vitri_10000_2
;	demsp.c:115: if (vitri > 3)
	mov	a,_timer0_isr_vitri_10000_2
	add	a,#0xff - 0x03
	jnc	00107$
;	demsp.c:116: vitri = 0;
	mov	_timer0_isr_vitri_10000_2,#0x00
00107$:
;	demsp.c:119: if (dang_chay) {
	mov	a,_dang_chay
	jz	00115$
;	demsp.c:120: tick++;
	mov	r6,_tick
	mov	r7,(_tick + 1)
	mov	a,#0x01
	add	a, r6
	mov	_tick,a
	clr	a
	addc	a, r7
	mov	(_tick + 1),a
;	demsp.c:121: if (tick >= 1000) {
	clr	c
	mov	a,_tick
	subb	a,#0xe8
	mov	a,(_tick + 1)
	subb	a,#0x03
	jc	00115$
;	demsp.c:122: tick = 0;
	clr	a
	mov	_tick,a
	mov	(_tick + 1),a
;	demsp.c:123: giay++;
	mov	a,_giay
	inc	a
	mov	_giay,a
;	demsp.c:124: if (giay >= 60) {
	mov	a,#0x100 - 0x3c
	add	a,_giay
	jnc	00115$
;	demsp.c:125: giay = 0;
	mov	_giay,#0x00
;	demsp.c:126: phut++;
	mov	a,_phut
	inc	a
	mov	_phut,a
;	demsp.c:127: if (phut >= 100)
	mov	a,#0x100 - 0x64
	add	a,_phut
	jnc	00115$
;	demsp.c:128: phut = 0;
	mov	_phut,#0x00
00115$:
;	demsp.c:134: if (khoa_cambien)
	mov	a,_khoa_cambien
	jz	00118$
;	demsp.c:135: khoa_cambien--;
	mov	a,_khoa_cambien
	dec	a
	mov	_khoa_cambien,a
00118$:
;	demsp.c:136: }
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
;	demsp.c:155: void int1_isr(void) __interrupt(2)
;	-----------------------------------------
;	 function int1_isr
;	-----------------------------------------
_int1_isr:
	push	acc
	push	ar7
	push	ar6
	push	psw
	mov	psw,#0x00
;	demsp.c:157: if (khoa_cambien)
	mov	a,_khoa_cambien
	jz	00102$
;	demsp.c:158: return;                 /* con trong thoi gian khoa -> bo qua */
	sjmp	00105$
00102$:
;	demsp.c:160: khoa_cambien = 20;          /* khoa 20 ms ke tu bay gio */
	mov	_khoa_cambien,#0x14
;	demsp.c:162: if (dang_chay)              /* dang PAUSE thi khong dem */
	mov	a,_dang_chay
	jz	00105$
;	demsp.c:163: product_count++;
	mov	r6,_product_count
	mov	r7,(_product_count + 1)
	mov	a,#0x01
	add	a, r6
	mov	_product_count,a
	clr	a
	addc	a, r7
	mov	(_product_count + 1),a
00105$:
;	demsp.c:164: }
	pop	psw
	pop	ar6
	pop	ar7
	pop	acc
	reti
;	eliminated unneeded push/pop dpl
;	eliminated unneeded push/pop dph
;	eliminated unneeded push/pop b
;------------------------------------------------------------
;Allocation info for local variables in function 'delay20ms'
;------------------------------------------------------------
;i             Allocated with name '_delay20ms_i_10000_10'
;j             Allocated with name '_delay20ms_j_10000_10'
;------------------------------------------------------------
;	demsp.c:166: void delay20ms(void)
;	-----------------------------------------
;	 function delay20ms
;	-----------------------------------------
_delay20ms:
;	demsp.c:170: for (j = 0; j < 8; j++)
	mov	_delay20ms_j_10000_10,#0x00
00107$:
	mov	a,#0x100 - 0x08
	add	a,_delay20ms_j_10000_10
	jc	00109$
;	demsp.c:171: for (i = 0; i < 250; i++)
	mov	_delay20ms_i_10000_10,#0x00
00104$:
	mov	a,#0x100 - 0xfa
	add	a,_delay20ms_i_10000_10
	jc	00108$
	mov	a,_delay20ms_i_10000_10
	inc	a
	mov	_delay20ms_i_10000_10,a
	sjmp	00104$
00108$:
;	demsp.c:170: for (j = 0; j < 8; j++)
	mov	a,_delay20ms_j_10000_10
	inc	a
	mov	_delay20ms_j_10000_10,a
	sjmp	00107$
00109$:
;	demsp.c:173: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'cap_nhat_hienthi'
;------------------------------------------------------------
;che_do        Allocated to registers r7 
;n             Allocated to registers r6 r7 
;------------------------------------------------------------
;	demsp.c:175: void cap_nhat_hienthi(unsigned char che_do)
;	-----------------------------------------
;	 function cap_nhat_hienthi
;	-----------------------------------------
_cap_nhat_hienthi:
	mov	r7, dpl
;	demsp.c:179: switch (che_do) {
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
;	demsp.c:181: case CHEDO_COUNT:
00101$:
;	demsp.c:194: EA = 0;
;	assignBit
	clr	_EA
;	demsp.c:195: n = product_count;
	mov	r6,_product_count
	mov	r7,(_product_count + 1)
;	demsp.c:196: EA = 1;
;	assignBit
	setb	_EA
;	demsp.c:198: hienthi[0] = MA7DOAN[n / 1000];
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
;	demsp.c:199: hienthi[1] = MA7DOAN[(n / 100) % 10];
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
;	demsp.c:200: hienthi[2] = MA7DOAN[(n / 10) % 10];
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
;	demsp.c:201: hienthi[3] = MA7DOAN[n % 10];
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
;	demsp.c:202: break;
	ret
;	demsp.c:204: case CHEDO_TIME:
00102$:
;	demsp.c:205: hienthi[0] = MA7DOAN[phut / 10];
	mov	r7,_phut
	mov	b,#0x0a
	mov	a,r7
	div	ab
	mov	dptr,#_MA7DOAN
	movc	a,@a+dptr
	mov	_hienthi, a
;	demsp.c:206: hienthi[1] = MA7DOAN[phut % 10] | DAU_CHAM;
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
;	demsp.c:207: hienthi[2] = MA7DOAN[giay / 10];
	mov	r7,_giay
	mov	b,#0x0a
	mov	a,r7
	div	ab
	mov	dptr,#_MA7DOAN
	movc	a,@a+dptr
	mov	(_hienthi + 0x0002), a
;	demsp.c:208: hienthi[3] = MA7DOAN[giay % 10];
	mov	r7,_giay
	mov	b,#0x0a
	mov	a,r7
	div	ab
	mov	a,b
	mov	dptr,#_MA7DOAN
	movc	a,@a+dptr
	mov	(_hienthi + 0x0003), a
;	demsp.c:209: break;
	ret
;	demsp.c:211: case CHEDO_TARGET:
00103$:
;	demsp.c:212: n = target_count;
	mov	r6,_target_count
	mov	r7,(_target_count + 1)
;	demsp.c:213: hienthi[0] = MA_CHU_P;
	mov	_hienthi,#0x73
;	demsp.c:214: hienthi[1] = MA7DOAN[(n / 100) % 10];
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
;	demsp.c:215: hienthi[2] = MA7DOAN[(n / 10) % 10];
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
;	demsp.c:216: hienthi[3] = MA7DOAN[n % 10];
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
;	demsp.c:218: }
;	demsp.c:219: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
;che_do        Allocated to registers r7 
;dem_tam       Allocated to registers r5 r6 
;------------------------------------------------------------
;	demsp.c:221: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	demsp.c:223: unsigned char che_do = CHEDO_COUNT;
	mov	r7,#0x00
;	demsp.c:226: P2 = 0xFF;
	mov	_P2,#0xff
;	demsp.c:227: P3 = 0xFF;                  /* ⭐ day chot P3 len 1 - cam bien o P3.3
	mov	_P3,#0xff
;	demsp.c:230: DOAN = 0x00;
	mov	_P1,r7
;	demsp.c:233: TMOD = 0x01;
	mov	_TMOD,#0x01
;	demsp.c:234: TH0  = 0xFC;
	mov	_TH0,#0xfc
;	demsp.c:235: TL0  = 0x66;
	mov	_TL0,#0x66
;	demsp.c:238: IT1 = 1;                    /* ⚠ IT1 = 1 la canh xuong (moi lan nhan
;	assignBit
	setb	_IT1
;	demsp.c:244: ET0 = 1;                    /* cho phep ngat Timer 0 */
;	assignBit
	setb	_ET0
;	demsp.c:245: EX1 = 1;                    /* cho phep ngat ngoai 1 */
;	assignBit
	setb	_EX1
;	demsp.c:246: EA  = 1;                    /* cong tac tong */
;	assignBit
	setb	_EA
;	demsp.c:247: TR0 = 1;                    /* Timer 0 chay */
;	assignBit
	setb	_TR0
;	demsp.c:249: while (1) {
00134$:
;	demsp.c:251: cap_nhat_hienthi(che_do);
	mov	dpl, r7
	push	ar7
	lcall	_cap_nhat_hienthi
	pop	ar7
;	demsp.c:254: if (NUT_STARTSTOP == NHAN) {
	jb	_P3_2,00110$
;	demsp.c:255: delay20ms();
	push	ar7
	lcall	_delay20ms
	pop	ar7
;	demsp.c:256: if (NUT_STARTSTOP == NHAN) {
	jb	_P3_2,00110$
;	demsp.c:257: if (dang_chay)
	mov	a,_dang_chay
	jz	00102$
;	demsp.c:258: dang_chay = 0;
	mov	_dang_chay,#0x00
	sjmp	00104$
00102$:
;	demsp.c:260: dang_chay = 1;
	mov	_dang_chay,#0x01
;	demsp.c:262: while (NUT_STARTSTOP == NHAN)
00104$:
	jnb	_P3_2,00104$
00110$:
;	demsp.c:268: if (NUT_MODE == NHAN) {
	jb	_P3_6,00119$
;	demsp.c:269: delay20ms();
	push	ar7
	lcall	_delay20ms
	pop	ar7
;	demsp.c:270: if (NUT_MODE == NHAN) {
	jb	_P3_6,00119$
;	demsp.c:271: che_do++;
	inc	r7
;	demsp.c:272: if (che_do > CHEDO_TARGET)
	mov	a,r7
	add	a,#0xff - 0x02
	jnc	00113$
;	demsp.c:273: che_do = CHEDO_COUNT;
	mov	r7,#0x00
;	demsp.c:275: while (NUT_MODE == NHAN)
00113$:
	jnb	_P3_6,00113$
00119$:
;	demsp.c:281: if (NUT_RESET == NHAN) {
	jb	_P2_7,00126$
;	demsp.c:282: delay20ms();
	push	ar7
	lcall	_delay20ms
	pop	ar7
;	demsp.c:283: if (NUT_RESET == NHAN) {
	jb	_P2_7,00126$
;	demsp.c:284: EA = 0;
;	assignBit
	clr	_EA
;	demsp.c:285: product_count = 0;
	clr	a
	mov	_product_count,a
	mov	(_product_count + 1),a
;	demsp.c:286: EA = 1;
;	assignBit
	setb	_EA
;	demsp.c:288: giay = 0;
;	demsp.c:289: phut = 0;
;	demsp.c:290: tick = 0;
	clr	a
	mov	_giay,a
	mov	_phut,a
	mov	_tick,a
	mov	(_tick + 1),a
;	demsp.c:292: while (NUT_RESET == NHAN)
00120$:
	jnb	_P2_7,00120$
00126$:
;	demsp.c:298: if (dang_chay) {
	mov	a,_dang_chay
	jz	00128$
;	demsp.c:299: LED_XANH = SANG;
;	assignBit
	clr	_P2_4
;	demsp.c:300: LED_VANG = TAT;
;	assignBit
	setb	_P2_5
	sjmp	00129$
00128$:
;	demsp.c:302: LED_XANH = TAT;
;	assignBit
	setb	_P2_4
;	demsp.c:303: LED_VANG = SANG;
;	assignBit
	clr	_P2_5
00129$:
;	demsp.c:306: EA = 0;
;	assignBit
	clr	_EA
;	demsp.c:307: dem_tam = product_count;
	mov	r5,_product_count
	mov	r6,(_product_count + 1)
;	demsp.c:308: EA = 1;
;	assignBit
	setb	_EA
;	demsp.c:310: if (dem_tam >= target_count)    /* dat muc tieu -> bao dong */
	clr	c
	mov	a,r5
	subb	a,_target_count
	mov	a,r6
	subb	a,(_target_count + 1)
	jc	00131$
;	demsp.c:311: LED_DO = SANG;
;	assignBit
	clr	_P2_6
	ljmp	00134$
00131$:
;	demsp.c:313: LED_DO = TAT;
;	assignBit
	setb	_P2_6
;	demsp.c:315: }
	ljmp	00134$
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
