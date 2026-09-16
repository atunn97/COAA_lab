;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.0 #15242 (MINGW64)
;--------------------------------------------------------
	.module quet4so
	
	.optsdcc -mmcs51 --model-small
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _MA7DOAN
	.globl _main
	.globl _nap_so
	.globl _quet_mot_vong
	.globl _tat_het_so
	.globl _delay5ms
	.globl _delay20ms
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
;--------------------------------------------------------
; overlayable items in internal ram
;--------------------------------------------------------
	.area	OSEG    (OVR,DATA)
_delay20ms_i_10000_2:
	.ds 1
_delay20ms_j_10000_2:
	.ds 1
	.area	OSEG    (OVR,DATA)
_delay5ms_i_10000_6:
	.ds 1
_delay5ms_j_10000_6:
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
;	quet4so.c:84: unsigned char hienthi[4] = { 0, 0, 0, 0 };
	mov	_hienthi,#0x00
	mov	(_hienthi + 0x0001),#0x00
	mov	(_hienthi + 0x0002),#0x00
	mov	(_hienthi + 0x0003),#0x00
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
;Allocation info for local variables in function 'delay20ms'
;------------------------------------------------------------
;i             Allocated with name '_delay20ms_i_10000_2'
;j             Allocated with name '_delay20ms_j_10000_2'
;------------------------------------------------------------
;	quet4so.c:89: void delay20ms(void)
;	-----------------------------------------
;	 function delay20ms
;	-----------------------------------------
_delay20ms:
	ar7 = 0x07
	ar6 = 0x06
	ar5 = 0x05
	ar4 = 0x04
	ar3 = 0x03
	ar2 = 0x02
	ar1 = 0x01
	ar0 = 0x00
;	quet4so.c:93: for (j = 0; j < 8; j++)
	mov	_delay20ms_j_10000_2,#0x00
00107$:
	mov	a,#0x100 - 0x08
	add	a,_delay20ms_j_10000_2
	jc	00109$
;	quet4so.c:94: for (i = 0; i < 250; i++)
	mov	_delay20ms_i_10000_2,#0x00
00104$:
	mov	a,#0x100 - 0xfa
	add	a,_delay20ms_i_10000_2
	jc	00108$
	mov	a,_delay20ms_i_10000_2
	inc	a
	mov	_delay20ms_i_10000_2,a
	sjmp	00104$
00108$:
;	quet4so.c:93: for (j = 0; j < 8; j++)
	mov	a,_delay20ms_j_10000_2
	inc	a
	mov	_delay20ms_j_10000_2,a
	sjmp	00107$
00109$:
;	quet4so.c:96: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'delay5ms'
;------------------------------------------------------------
;i             Allocated with name '_delay5ms_i_10000_6'
;j             Allocated with name '_delay5ms_j_10000_6'
;------------------------------------------------------------
;	quet4so.c:106: void delay5ms(void)
;	-----------------------------------------
;	 function delay5ms
;	-----------------------------------------
_delay5ms:
;	quet4so.c:110: for (j = 0; j < 2; j++)
	mov	_delay5ms_j_10000_6,#0x00
00107$:
	mov	a,#0x100 - 0x02
	add	a,_delay5ms_j_10000_6
	jc	00109$
;	quet4so.c:111: for (i = 0; i < 250; i++)
	mov	_delay5ms_i_10000_6,#0x00
00104$:
	mov	a,#0x100 - 0xfa
	add	a,_delay5ms_i_10000_6
	jc	00108$
	mov	a,_delay5ms_i_10000_6
	inc	a
	mov	_delay5ms_i_10000_6,a
	sjmp	00104$
00108$:
;	quet4so.c:110: for (j = 0; j < 2; j++)
	mov	a,_delay5ms_j_10000_6
	inc	a
	mov	_delay5ms_j_10000_6,a
	sjmp	00107$
00109$:
;	quet4so.c:113: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'tat_het_so'
;------------------------------------------------------------
;	quet4so.c:120: void tat_het_so(void)
;	-----------------------------------------
;	 function tat_het_so
;	-----------------------------------------
_tat_het_so:
;	quet4so.c:122: CHON_SO1 = BO;
;	assignBit
	setb	_P2_0
;	quet4so.c:123: CHON_SO2 = BO;
;	assignBit
	setb	_P2_1
;	quet4so.c:124: CHON_SO3 = BO;
;	assignBit
	setb	_P2_2
;	quet4so.c:125: CHON_SO4 = BO;
;	assignBit
	setb	_P2_3
;	quet4so.c:126: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'quet_mot_vong'
;------------------------------------------------------------
;vitri         Allocated to registers r7 
;------------------------------------------------------------
;	quet4so.c:140: void quet_mot_vong(void)
;	-----------------------------------------
;	 function quet_mot_vong
;	-----------------------------------------
_quet_mot_vong:
;	quet4so.c:144: for (vitri = 0; vitri < 4; vitri++) {
	mov	r7,#0x00
00107$:
;	quet4so.c:146: tat_het_so();                           /* 1 */
	push	ar7
	lcall	_tat_het_so
	pop	ar7
;	quet4so.c:148: DOAN = MA7DOAN[hienthi[vitri]];         /* 2 */
	mov	a,r7
	add	a, #_hienthi
	mov	r1,a
	mov	a,@r1
	mov	r6,a
	mov	dptr,#_MA7DOAN
	movc	a,@a+dptr
	mov	_P1,a
;	quet4so.c:150: switch (vitri) {                        /* 3 */
	mov	a,r7
	add	a,r7
;	quet4so.c:151: case 0: CHON_SO1 = CHON; break;
	mov	dptr,#00120$
	jmp	@a+dptr
00120$:
	sjmp	00101$
	sjmp	00102$
	sjmp	00103$
	sjmp	00104$
00101$:
;	assignBit
	clr	_P2_0
;	quet4so.c:152: case 1: CHON_SO2 = CHON; break;
	sjmp	00105$
00102$:
;	assignBit
	clr	_P2_1
;	quet4so.c:153: case 2: CHON_SO3 = CHON; break;
	sjmp	00105$
00103$:
;	assignBit
	clr	_P2_2
;	quet4so.c:154: case 3: CHON_SO4 = CHON; break;
	sjmp	00105$
00104$:
;	assignBit
	clr	_P2_3
;	quet4so.c:155: }
00105$:
;	quet4so.c:157: delay5ms();
	push	ar7
	lcall	_delay5ms
	pop	ar7
;	quet4so.c:144: for (vitri = 0; vitri < 4; vitri++) {
	inc	r7
	cjne	r7,#0x04,00121$
00121$:
	jc	00107$
;	quet4so.c:159: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'nap_so'
;------------------------------------------------------------
;gia_tri       Allocated to registers r6 r7 
;------------------------------------------------------------
;	quet4so.c:162: void nap_so(unsigned int gia_tri)
;	-----------------------------------------
;	 function nap_so
;	-----------------------------------------
_nap_so:
;	quet4so.c:164: hienthi[0] = (unsigned char)(gia_tri / 1000);
	mov	r6,dpl
	mov	r7,dph
	mov	__divuint_PARM_2,#0xe8
	mov	(__divuint_PARM_2 + 1),#0x03
	push	ar7
	push	ar6
	lcall	__divuint
	mov	r4, dpl
	pop	ar6
	pop	ar7
	mov	_hienthi,r4
;	quet4so.c:165: hienthi[1] = (unsigned char)((gia_tri / 100) % 10);
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
	pop	ar6
	pop	ar7
	mov	(_hienthi + 0x0001),r4
;	quet4so.c:166: hienthi[2] = (unsigned char)((gia_tri / 10) % 10);
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
	pop	ar6
	pop	ar7
	mov	(_hienthi + 0x0002),r4
;	quet4so.c:167: hienthi[3] = (unsigned char)(gia_tri % 10);
	mov	__moduint_PARM_2,#0x0a
	mov	(__moduint_PARM_2 + 1),#0x00
	mov	dpl, r6
	mov	dph, r7
	lcall	__moduint
	mov	r6, dpl
	mov	(_hienthi + 0x0003),r6
;	quet4so.c:168: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
;dem           Allocated to registers r6 r7 
;vong          Allocated to registers r5 
;dang_chay     Allocated to registers r4 
;den_do        Allocated to registers r3 
;ss_da_xu_ly   Allocated to registers r2 
;mode_da_xu_ly Allocated to registers r1 
;------------------------------------------------------------
;	quet4so.c:170: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	quet4so.c:172: unsigned int  dem  = 0;     /* so dang hien, 0..9999 */
	mov	r6,#0x00
	mov	r7,#0x00
;	quet4so.c:173: unsigned char vong = 0;     /* dem so vong quet da chay */
	mov	r5,#0x00
;	quet4so.c:175: unsigned char dang_chay = 0;        /* 0 = PAUSE, 1 = RUN  */
	mov	r4,#0x00
;	quet4so.c:176: unsigned char den_do    = 0;        /* 0 = tat,   1 = sang */
	mov	r3,#0x00
;	quet4so.c:180: unsigned char ss_da_xu_ly   = 0;
	mov	r2,#0x00
;	quet4so.c:181: unsigned char mode_da_xu_ly = 0;
	mov	r1,#0x00
;	quet4so.c:192: P2 = 0xFF;                  /* 4 chan chon = 1 -> tat het (noi thang: 0 moi la chon)
	mov	_P2,#0xff
;	quet4so.c:195: P3 = 0xFF;                  /* de doc duoc nut START/STOP va MODE */
	mov	_P3,#0xff
;	quet4so.c:196: DOAN = 0x00;                /* tat het 8 doan */
	mov	_P1,r7
;	quet4so.c:198: LED_VANG = SANG;            /* khoi dong o trang thai PAUSE */
;	assignBit
	clr	_P2_5
;	quet4so.c:200: while (1) {
00130$:
;	quet4so.c:202: quet_mot_vong();        /* ~20 ms */
	push	ar7
	push	ar6
	push	ar5
	push	ar4
	push	ar3
	push	ar2
	push	ar1
	lcall	_quet_mot_vong
	pop	ar1
	pop	ar2
	pop	ar3
	pop	ar4
	pop	ar5
	pop	ar6
	pop	ar7
;	quet4so.c:212: vong++;
	inc	r5
;	quet4so.c:213: if (vong >= 50) {
	cjne	r5,#0x32,00206$
00206$:
	jc	00104$
;	quet4so.c:214: vong = 0;
	mov	r5,#0x00
;	quet4so.c:216: dem++;
	inc	r6
	cjne	r6,#0x00,00208$
	inc	r7
00208$:
;	quet4so.c:217: if (dem > 9999)
	clr	c
	mov	a,#0x0f
	subb	a,r6
	mov	a,#0x27
	subb	a,r7
	jnc	00102$
;	quet4so.c:218: dem = 0;
	mov	r6,#0x00
	mov	r7,#0x00
00102$:
;	quet4so.c:220: nap_so(dem);
	mov	dpl, r6
	mov	dph, r7
	push	ar7
	push	ar6
	push	ar5
	push	ar4
	push	ar3
	push	ar2
	push	ar1
	lcall	_nap_so
	pop	ar1
	pop	ar2
	pop	ar3
	pop	ar4
	pop	ar5
	pop	ar6
	pop	ar7
00104$:
;	quet4so.c:235: if (NUT_STARTSTOP == NHAN) {
	jb	_P3_2,00111$
;	quet4so.c:236: if (!ss_da_xu_ly) {
	mov	a,r2
	jnz	00112$
;	quet4so.c:237: ss_da_xu_ly = 1;
	mov	r2,#0x01
;	quet4so.c:238: if (dang_chay)
	mov	a,r4
	jz	00106$
;	quet4so.c:239: dang_chay = 0;
	mov	r4,#0x00
	sjmp	00112$
00106$:
;	quet4so.c:241: dang_chay = 1;
	mov	r4,#0x01
	sjmp	00112$
00111$:
;	quet4so.c:244: ss_da_xu_ly = 0;            /* da nha ra -> cho phep lan sau */
	mov	r2,#0x00
00112$:
;	quet4so.c:247: if (NUT_MODE == NHAN) {
	jb	_P3_5,00119$
;	quet4so.c:248: if (!mode_da_xu_ly) {
	mov	a,r1
	jnz	00120$
;	quet4so.c:249: mode_da_xu_ly = 1;
	mov	r1,#0x01
;	quet4so.c:250: if (den_do)
	mov	a,r3
	jz	00114$
;	quet4so.c:251: den_do = 0;
	mov	r3,#0x00
	sjmp	00120$
00114$:
;	quet4so.c:253: den_do = 1;
	mov	r3,#0x01
	sjmp	00120$
00119$:
;	quet4so.c:256: mode_da_xu_ly = 0;
	mov	r1,#0x00
00120$:
;	quet4so.c:259: if (NUT_RESET == NHAN) {
	jb	_P2_7,00122$
;	quet4so.c:260: dem       = 0;
	mov	r6,#0x00
	mov	r7,#0x00
;	quet4so.c:261: vong      = 0;
	mov	r5,#0x00
;	quet4so.c:262: dang_chay = 0;
	mov	r4,#0x00
;	quet4so.c:263: den_do    = 0;
	mov	r3,#0x00
;	quet4so.c:264: nap_so(dem);
	mov	dptr,#0x0000
	push	ar7
	push	ar6
	push	ar5
	push	ar4
	push	ar3
	push	ar2
	push	ar1
	lcall	_nap_so
	pop	ar1
	pop	ar2
	pop	ar3
	pop	ar4
	pop	ar5
	pop	ar6
	pop	ar7
00122$:
;	quet4so.c:268: if (dang_chay) {
	mov	a,r4
	jz	00124$
;	quet4so.c:269: LED_XANH = SANG;
;	assignBit
	clr	_P2_4
;	quet4so.c:270: LED_VANG = TAT;
;	assignBit
	setb	_P2_5
	sjmp	00125$
00124$:
;	quet4so.c:272: LED_XANH = TAT;
;	assignBit
	setb	_P2_4
;	quet4so.c:273: LED_VANG = SANG;
;	assignBit
	clr	_P2_5
00125$:
;	quet4so.c:276: if (den_do)
	mov	a,r3
	jz	00127$
;	quet4so.c:277: LED_DO = SANG;
;	assignBit
	clr	_P2_6
	ljmp	00130$
00127$:
;	quet4so.c:279: LED_DO = TAT;
;	assignBit
	setb	_P2_6
;	quet4so.c:281: }
	ljmp	00130$
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
