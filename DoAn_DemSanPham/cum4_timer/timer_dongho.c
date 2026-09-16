/*=====================================================================
 *  CUM 4  -  NGAT TIMER 0        8051 / SDCC
 *---------------------------------------------------------------------
 *  PHAN CUNG: KHONG THEM GI. Dung y nguyen mach cua cum 3.
 *
 *  Viec cua bai nay: chuyen viec quet man hinh tu CHUONG TRINH CHINH
 *  sang NGAT TIMER. Man hinh tu no sang, chuong trinh chinh khong con
 *  phai lo toi nua.
 *
 *  ⭐ VI SAO PHAI LAM CHUYEN NAY - ly do that, khong phai ly thuyet:
 *
 *    O cum 3, muon cho nguoi dung NHA nut ra thi phai viet
 *          while (nut == NHAN) ;
 *    Nhung cho trong vong do nghia la KHONG QUET nua -> man hinh TAT
 *    NGOM suot thoi gian giu nut. Da phai lach bang co "da_xu_ly".
 *
 *    Khi quet do NGAT lo, chuong trinh chinh muon dung bao lau cung
 *    duoc, man hinh van sang binh thuong. Vong cho nha nut quay lai
 *    dung duoc, va no dung that trong bai nay.
 *
 *  CACH CHAY:
 *    Man hinh hien  mm.ss  (phut.giay), dau cham o giua.
 *    START/STOP : chay / dung dong ho.  Xanh = chay, Vang = dung
 *    RESET      : ve 00.00
 *    MODE       : bat/tat LED do
 *
 *  BUILD:
 *    sdcc timer_dongho.c; packihx timer_dongho.ihx | Out-File -Encoding ascii timer_dongho.hex
 *=====================================================================*/

#include <8051.h>

#define DOAN       P1

#define CHON_SO1   P2_0
#define CHON_SO2   P2_1
#define CHON_SO3   P2_2
#define CHON_SO4   P2_3

#define LED_XANH   P2_4
#define LED_VANG   P2_5
#define LED_DO     P2_6

#define NUT_STARTSTOP  P3_2
#define NUT_RESET      P2_7
#define NUT_MODE       P3_5

#define SANG   0
#define TAT    1
#define NHAN   0

#define CHON   0                /* noi thang: 0 = chon so nay */
#define BO     1

#define DAU_CHAM  0x80          /* bit 7 = dau cham dp */

__code unsigned char MA7DOAN[10] = {
    0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F
};

/*---------------------------------------------------------------------
 *  ⚠ volatile la BAT BUOC voi moi bien dung chung giua chuong trinh
 *    chinh va ISR. Thieu no, trinh dich thay chuong trinh chinh khong
 *    bao gio thay bien doi -> no giu gia tri trong thanh ghi va khong
 *    doc lai RAM nua. Cung ho voi bay SDCC da dinh o bai dichled.
 *
 *  hienthi[] gio chua MA 7 DOAN san, khong chua chu so nua - de con
 *  gan them dau cham (bit 7) cho chu so o giua.
 *-------------------------------------------------------------------*/
volatile unsigned char hienthi[4] = { 0x3F, 0x3F | DAU_CHAM, 0x3F, 0x3F };

volatile unsigned int  tick      = 0;   /* dem so lan ngat, 1000 = 1 giay */
volatile unsigned char giay      = 0;
volatile unsigned char phut      = 0;
volatile unsigned char dang_chay = 0;

/*=====================================================================
 *  ISR TIMER 0  -  chay moi 1 ms
 *---------------------------------------------------------------------
 *  __interrupt(1) = nguon so 1 = Timer 0, vector 000BH.
 *      0 = INT0 (0003H)   1 = Timer0 (000BH)   2 = INT1 (0013H)
 *      3 = Timer1 (001BH) 4 = Serial (0023H)
 *
 *  Moi lan ngat lam dung hai viec, ca hai deu phai NGAN:
 *      1. quet DUNG MOT chu so  -> 4 lan ngat la het mot vong = 4 ms
 *                                  = 250 Hz, mat khong thay nhay
 *      2. dem 1000 lan = 1 giay
 *
 *  ⚠ Che do 1 KHONG tu nap lai, nen phai nap lai TH0/TL0 ngay dau ISR.
 *    Quen la lan sau timer chay tron 65 536 chu ky moi tran -> ngat
 *    thua ra thanh ~71 ms mot lan thay vi 1 ms.
 *
 *  ⚠ Co TF0 thi KHONG phai xoa bang tay - phan cung tu xoa khi nhay
 *    vao ISR. Khac han luc dung kieu hoi vong (polling) o muc 4.3.
 *=====================================================================*/
void timer0_isr(void) __interrupt(1)
{
    static unsigned char vitri = 0;

    /* Nap lai cho lan tran ke tiep: 65536 - 922 = 64614 = 0xFC66
       922 chu ky may x 1,085 us = 1 000,4 us = 1 ms */
    TH0 = 0xFC;
    TL0 = 0x66;

    /*--- viec 1: quet mot chu so ---*/
    CHON_SO1 = BO;                      /* tat het truoc */
    CHON_SO2 = BO;
    CHON_SO3 = BO;
    CHON_SO4 = BO;

    DOAN = hienthi[vitri];              /* roi moi doi du lieu */

    switch (vitri) {                    /* roi moi bat so moi */
        case 0: CHON_SO1 = CHON; break;
        case 1: CHON_SO2 = CHON; break;
        case 2: CHON_SO3 = CHON; break;
        case 3: CHON_SO4 = CHON; break;
    }

    vitri++;
    if (vitri > 3)
        vitri = 0;

    /*--- viec 2: dem thoi gian ---*/
    if (dang_chay) {
        tick++;
        if (tick >= 1000) {
            tick = 0;
            giay++;
            if (giay >= 60) {
                giay = 0;
                phut++;
                if (phut >= 100)
                    phut = 0;
            }
        }
    }
}

void delay20ms(void)
{
    volatile unsigned char i, j;

    for (j = 0; j < 8; j++)
        for (i = 0; i < 250; i++)
            ;
}

void cap_nhat_hienthi(void)
{
    hienthi[0] = MA7DOAN[phut / 10];
    hienthi[1] = MA7DOAN[phut % 10] | DAU_CHAM;
    hienthi[2] = MA7DOAN[giay / 10];
    hienthi[3] = MA7DOAN[giay % 10];
}

void main(void)
{
    unsigned char den_do = 0;

    P2 = 0xFF;                  /* tat het 4 so, tat 3 LED don, P2.7 len 1 */
    P3 = 0xFF;
    DOAN = 0x00;

    /*-----------------------------------------------------------------
     *  CAI DAT TIMER 0 - bon dong, thieu dong nao cung cam
     *
     *  TMOD = 0x01:  nua THAP la Timer 0, nua CAO la Timer 1
     *                0001 = GATE 0, C/T 0 (dem chu ky may, tuc lam
     *                TIMER chu khong phai COUNTER), M1M0 = 01 = che do 1
     *                = bo dem 16 bit.
     *
     *  ⚠ Sau nay them UART thi Timer 1 phai lam bo tao baud o che do 2
     *    => luc do TMOD phai doi thanh 0x21, khong con la 0x01.
     *---------------------------------------------------------------*/
    TMOD = 0x01;
    TH0  = 0xFC;                /* nap lan dau */
    TL0  = 0x66;

    ET0 = 1;                    /* cho phep rieng ngat Timer 0 */
    EA  = 1;                    /* ⭐ cong tac TONG - thieu dong nay thi
                                   khong ngat nao chay, ke ca da bat ET0 */
    TR0 = 1;                    /* cho Timer 0 chay */

    while (1) {

        cap_nhat_hienthi();

        /*-------------------------------------------------------------
         *  ⭐ CHO Y: o day lai duoc phep dung vong cho nha nut.
         *    Giu nut bao lau cung duoc, man hinh VAN SANG BINH THUONG,
         *    vi viec quet da do ngat Timer lo roi. O cum 3 lam vay la
         *    man hinh tat ngom.
         *    Day la cho A tu thay duoc loi ich cua ngat, khong phai
         *    hoc thuoc.
         *-----------------------------------------------------------*/
        if (NUT_STARTSTOP == NHAN) {
            delay20ms();
            if (NUT_STARTSTOP == NHAN) {
                if (dang_chay)
                    dang_chay = 0;
                else
                    dang_chay = 1;

                while (NUT_STARTSTOP == NHAN)
                    ;
            }
        }

        if (NUT_MODE == NHAN) {
            delay20ms();
            if (NUT_MODE == NHAN) {
                if (den_do)
                    den_do = 0;
                else
                    den_do = 1;

                while (NUT_MODE == NHAN)
                    ;
            }
        }

        if (NUT_RESET == NHAN) {
            delay20ms();
            if (NUT_RESET == NHAN) {
                giay = 0;
                phut = 0;
                tick = 0;

                while (NUT_RESET == NHAN)
                    ;
            }
        }

        /*--- 3 LED don bao trang thai ---*/
        if (dang_chay) {
            LED_XANH = SANG;
            LED_VANG = TAT;
        } else {
            LED_XANH = TAT;
            LED_VANG = SANG;
        }

        if (den_do)
            LED_DO = SANG;
        else
            LED_DO = TAT;
    }
}
