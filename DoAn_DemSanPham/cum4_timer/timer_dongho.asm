;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.0 #15242 (MINGW64)
;--------------------------------------------------------
	.module timer_dongho
	
	.optsdcc -mmcs51 --model-small
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _MA7DOAN
	.globl _main
	.globl _cap_nhat_hienthi
	.globl _delay20ms
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
_timer0_isr_vitri_10000_2:
	.ds 1
;--------------------------------------------------------
; overlayable items in internal ram
;--------------------------------------------------------
	.area	OSEG    (OVR,DATA)
_delay20ms_i_10000_8:
	.ds 1
_delay20ms_j_10000_8:
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
;	timer_dongho.c:98: static unsigned char vitri = 0;
	mov	_timer0_isr_vitri_10000_2,#0x00
;	timer_dongho.c:70: volatile unsigned char hienthi[4] = { 0x3F, 0x3F | DAU_CHAM, 0x3F, 0x3F };
	mov	_hienthi,#0x3f
	mov	(_hienthi + 0x0001),#0xbf
	mov	(_hienthi + 0x0002),#0x3f
	mov	(_hienthi + 0x0003),#0x3f
;	timer_dongho.c:72: volatile unsigned int  tick      = 0;   /* dem so lan ngat, 1000 = 1 giay */
	clr	a
	mov	_tick,a
	mov	(_tick + 1),a
;	timer_dongho.c:73: volatile unsigned char giay      = 0;
	mov	_giay,a
;	timer_dongho.c:74: volatile unsigned char phut      = 0;
	mov	_phut,a
;	timer_dongho.c:75: volatile unsigned char dang_chay = 0;
	mov	_dang_chay,a
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
;	timer_dongho.c:96: void timer0_isr(void) __interrupt(1)
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
;	timer_dongho.c:102: TH0 = 0xFC;
	mov	_TH0,#0xfc
;	timer_dongho.c:103: TL0 = 0x66;
	mov	_TL0,#0x66
;	timer_dongho.c:106: CHON_SO1 = BO;                      /* tat het truoc */
;	assignBit
	setb	_P2_0
;	timer_dongho.c:107: CHON_SO2 = BO;
;	assignBit
	setb	_P2_1
;	timer_dongho.c:108: CHON_SO3 = BO;
;	assignBit
	setb	_P2_2
;	timer_dongho.c:109: CHON_SO4 = BO;
;	assignBit
	setb	_P2_3
;	timer_dongho.c:111: DOAN = hienthi[vitri];              /* roi moi doi du lieu */
	mov	a,_timer0_isr_vitri_10000_2
	add	a, #_hienthi
	mov	r1,a
	mov	_P1,@r1
;	timer_dongho.c:113: switch (vitri) {                    /* roi moi bat so moi */
	mov	a,_timer0_isr_vitri_10000_2
	add	a,#0xff - 0x03
	jc	00105$
	mov	a,_timer0_isr_vitri_10000_2
	mov	b,#0x03
	mul	ab
	mov	dptr,#00155$
	jmp	@a+dptr
00155$:
	ljmp	00101$
	ljmp	00102$
	ljmp	00103$
	ljmp	00104$
;	timer_dongho.c:114: case 0: CHON_SO1 = CHON; break;
00101$:
;	assignBit
	clr	_P2_0
;	timer_dongho.c:115: case 1: CHON_SO2 = CHON; break;
	sjmp	00105$
00102$:
;	assignBit
	clr	_P2_1
;	timer_dongho.c:116: case 2: CHON_SO3 = CHON; break;
	sjmp	00105$
00103$:
;	assignBit
	clr	_P2_2
;	timer_dongho.c:117: case 3: CHON_SO4 = CHON; break;
	sjmp	00105$
00104$:
;	assignBit
	clr	_P2_3
;	timer_dongho.c:118: }
00105$:
;	timer_dongho.c:120: vitri++;
	inc	_timer0_isr_vitri_10000_2
;	timer_dongho.c:121: if (vitri > 3)
	mov	a,_timer0_isr_vitri_10000_2
	add	a,#0xff - 0x03
	jnc	00107$
;	timer_dongho.c:122: vitri = 0;
	mov	_timer0_isr_vitri_10000_2,#0x00
00107$:
;	timer_dongho.c:125: if (dang_chay) {
	mov	a,_dang_chay
	jz	00116$
;	timer_dongho.c:126: tick++;
	mov	r6,_tick
	mov	r7,(_tick + 1)
	mov	a,#0x01
	add	a, r6
	mov	_tick,a
	clr	a
	addc	a, r7
	mov	(_tick + 1),a
;	timer_dongho.c:127: if (tick >= 1000) {
	clr	c
	mov	a,_tick
	subb	a,#0xe8
	mov	a,(_tick + 1)
	subb	a,#0x03
	jc	00116$
;	timer_dongho.c:128: tick = 0;
	clr	a
	mov	_tick,a
	mov	(_tick + 1),a
;	timer_dongho.c:129: giay++;
	mov	a,_giay
	inc	a
	mov	_giay,a
;	timer_dongho.c:130: if (giay >= 60) {
	mov	a,#0x100 - 0x3c
	add	a,_giay
	jnc	00116$
;	timer_dongho.c:131: giay = 0;
	mov	_giay,#0x00
;	timer_dongho.c:132: phut++;
	mov	a,_phut
	inc	a
	mov	_phut,a
;	timer_dongho.c:133: if (phut >= 100)
	mov	a,#0x100 - 0x64
	add	a,_phut
	jnc	00116$
;	timer_dongho.c:134: phut = 0;
	mov	_phut,#0x00
00116$:
;	timer_dongho.c:138: }
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
;Allocation info for local variables in function 'delay20ms'
;------------------------------------------------------------
;i             Allocated with name '_delay20ms_i_10000_8'
;j             Allocated with name '_delay20ms_j_10000_8'
;------------------------------------------------------------
;	timer_dongho.c:140: void delay20ms(void)
;	-----------------------------------------
;	 function delay20ms
;	-----------------------------------------
_delay20ms:
;	timer_dongho.c:144: for (j = 0; j < 8; j++)
	mov	_delay20ms_j_10000_8,#0x00
00107$:
	mov	a,#0x100 - 0x08
	add	a,_delay20ms_j_10000_8
	jc	00109$
;	timer_dongho.c:145: for (i = 0; i < 250; i++)
	mov	_delay20ms_i_10000_8,#0x00
00104$:
	mov	a,#0x100 - 0xfa
	add	a,_delay20ms_i_10000_8
	jc	00108$
	mov	a,_delay20ms_i_10000_8
	inc	a
	mov	_delay20ms_i_10000_8,a
	sjmp	00104$
00108$:
;	timer_dongho.c:144: for (j = 0; j < 8; j++)
	mov	a,_delay20ms_j_10000_8
	inc	a
	mov	_delay20ms_j_10000_8,a
	sjmp	00107$
00109$:
;	timer_dongho.c:147: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'cap_nhat_hienthi'
;------------------------------------------------------------
;	timer_dongho.c:149: void cap_nhat_hienthi(void)
;	-----------------------------------------
;	 function cap_nhat_hienthi
;	-----------------------------------------
_cap_nhat_hienthi:
;	timer_dongho.c:151: hienthi[0] = MA7DOAN[phut / 10];
	mov	r7,_phut
	mov	b,#0x0a
	mov	a,r7
	div	ab
	mov	dptr,#_MA7DOAN
	movc	a,@a+dptr
	mov	_hienthi, a
;	timer_dongho.c:152: hienthi[1] = MA7DOAN[phut % 10] | DAU_CHAM;
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
;	timer_dongho.c:153: hienthi[2] = MA7DOAN[giay / 10];
	mov	r7,_giay
	mov	b,#0x0a
	mov	a,r7
	div	ab
	mov	dptr,#_MA7DOAN
	movc	a,@a+dptr
	mov	(_hienthi + 0x0002), a
;	timer_dongho.c:154: hienthi[3] = MA7DOAN[giay % 10];
	mov	r7,_giay
	mov	b,#0x0a
	mov	a,r7
	div	ab
	mov	a,b
	mov	dptr,#_MA7DOAN
	movc	a,@a+dptr
	mov	(_hienthi + 0x0003), a
;	timer_dongho.c:155: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
;den_do        Allocated to registers r7 
;------------------------------------------------------------
;	timer_dongho.c:157: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	timer_dongho.c:159: unsigned char den_do = 0;
	mov	r7,#0x00
;	timer_dongho.c:161: P2 = 0xFF;                  /* tat het 4 so, tat 3 LED don, P2.7 len 1 */
	mov	_P2,#0xff
;	timer_dongho.c:162: P3 = 0xFF;
	mov	_P3,#0xff
;	timer_dongho.c:163: DOAN = 0x00;
	mov	_P1,r7
;	timer_dongho.c:176: TMOD = 0x01;
	mov	_TMOD,#0x01
;	timer_dongho.c:177: TH0  = 0xFC;                /* nap lan dau */
	mov	_TH0,#0xfc
;	timer_dongho.c:178: TL0  = 0x66;
	mov	_TL0,#0x66
;	timer_dongho.c:180: ET0 = 1;                    /* cho phep rieng ngat Timer 0 */
;	assignBit
	setb	_ET0
;	timer_dongho.c:181: EA  = 1;                    /* ⭐ cong tac TONG - thieu dong nay thi
;	assignBit
	setb	_EA
;	timer_dongho.c:183: TR0 = 1;                    /* cho Timer 0 chay */
;	assignBit
	setb	_TR0
;	timer_dongho.c:185: while (1) {
00135$:
;	timer_dongho.c:187: cap_nhat_hienthi();
	push	ar7
	lcall	_cap_nhat_hienthi
	pop	ar7
;	timer_dongho.c:197: if (NUT_STARTSTOP == NHAN) {
	jb	_P3_2,00110$
;	timer_dongho.c:198: delay20ms();
	push	ar7
	lcall	_delay20ms
	pop	ar7
;	timer_dongho.c:199: if (NUT_STARTSTOP == NHAN) {
	jb	_P3_2,00110$
;	timer_dongho.c:200: if (dang_chay)
	mov	a,_dang_chay
	jz	00102$
;	timer_dongho.c:201: dang_chay = 0;
	mov	_dang_chay,#0x00
	sjmp	00104$
00102$:
;	timer_dongho.c:203: dang_chay = 1;
	mov	_dang_chay,#0x01
;	timer_dongho.c:205: while (NUT_STARTSTOP == NHAN)
00104$:
	jnb	_P3_2,00104$
00110$:
;	timer_dongho.c:210: if (NUT_MODE == NHAN) {
	jb	_P3_5,00120$
;	timer_dongho.c:211: delay20ms();
	push	ar7
	lcall	_delay20ms
	pop	ar7
;	timer_dongho.c:212: if (NUT_MODE == NHAN) {
	jb	_P3_5,00120$
;	timer_dongho.c:213: if (den_do)
	mov	a,r7
	jz	00112$
;	timer_dongho.c:214: den_do = 0;
	mov	r7,#0x00
	sjmp	00114$
00112$:
;	timer_dongho.c:216: den_do = 1;
	mov	r7,#0x01
;	timer_dongho.c:218: while (NUT_MODE == NHAN)
00114$:
	jnb	_P3_5,00114$
00120$:
;	timer_dongho.c:223: if (NUT_RESET == NHAN) {
	jb	_P2_7,00127$
;	timer_dongho.c:224: delay20ms();
	push	ar7
	lcall	_delay20ms
	pop	ar7
;	timer_dongho.c:225: if (NUT_RESET == NHAN) {
	jb	_P2_7,00127$
;	timer_dongho.c:226: giay = 0;
;	timer_dongho.c:227: phut = 0;
;	timer_dongho.c:228: tick = 0;
	clr	a
	mov	_giay,a
	mov	_phut,a
	mov	_tick,a
	mov	(_tick + 1),a
;	timer_dongho.c:230: while (NUT_RESET == NHAN)
00121$:
	jnb	_P2_7,00121$
00127$:
;	timer_dongho.c:236: if (dang_chay) {
	mov	a,_dang_chay
	jz	00129$
;	timer_dongho.c:237: LED_XANH = SANG;
;	assignBit
	clr	_P2_4
;	timer_dongho.c:238: LED_VANG = TAT;
;	assignBit
	setb	_P2_5
	sjmp	00130$
00129$:
;	timer_dongho.c:240: LED_XANH = TAT;
;	assignBit
	setb	_P2_4
;	timer_dongho.c:241: LED_VANG = SANG;
;	assignBit
	clr	_P2_5
00130$:
;	timer_dongho.c:244: if (den_do)
	mov	a,r7
	jz	00132$
;	timer_dongho.c:245: LED_DO = SANG;
;	assignBit
	clr	_P2_6
	sjmp	00135$
00132$:
;	timer_dongho.c:247: LED_DO = TAT;
;	assignBit
	setb	_P2_6
;	timer_dongho.c:249: }
	sjmp	00135$
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
