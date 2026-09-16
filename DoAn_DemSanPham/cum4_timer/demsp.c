/*=====================================================================
 *  CUM 4b  -  DEM SAN PHAM BANG NGAT NGOAI INT1     8051 / SDCC
 *---------------------------------------------------------------------
 *  PHAN CUNG THEM: dung MOT nut nhan nua, lam gia cam bien san pham
 *      P3.3 (chan 13) -> nut CAM BIEN -> GND
 *
 *  Gio he thong co HAI nguon ngat chay song song:
 *      Timer 0 (vector 000BH) - moi 1 ms: quet man hinh + dem thoi gian
 *      INT1    (vector 0013H) - moi lan co san pham di qua: dem them 1
 *
 *  BA CHE DO HIEN THI, nhan MODE de xoay vong (dung nhu muc 9 cua de):
 *      COUNT   ->  0125     so san pham da dem
 *      TIME    ->  12.35    12 phut 35 giay
 *      TARGET  ->  P100     muc tieu can dat
 *
 *  LED bao trang thai (dung nhu muc 8 cua de):
 *      XANH = dang chay (RUN)
 *      VANG = tam dung  (PAUSE)
 *      DO   = da dat muc tieu (ALARM), khi product_count >= target_count
 *
 *  BUILD:
 *    sdcc demsp.c; packihx demsp.ihx | Out-File -Encoding ascii demsp.hex
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
#define NUT_MODE       P3_6
/* cam bien nam o P3.3 - khong doc bang lenh, ngat tu goi */
/* ⭐ 16/09: MODE doi tu P3.5 sang P3.6 (chan 16). P3.5 nghi ngo chung
   net voi P3.3 sau khi gan DCLOCK. P3.6 la chan hoan toan sach,
   chua tung co day nao chay qua.
   P3.6 = WR va P3.7 = RD chi mang chuc nang dieu khien khi dung lenh
   MOVX de truy cap RAM NGOAI. Chuong trinh nay khong he dung MOVX va
   EA da noi +5V (chay ROM trong), nen hai chan do la I/O thuong. */

#define SANG   0
#define TAT    1
#define NHAN   0

#define CHON   0
#define BO     1

#define DAU_CHAM  0x80
#define MA_CHU_P  0x73          /* chu "P": sang a b e f g */

#define CHEDO_COUNT   0
#define CHEDO_TIME    1
#define CHEDO_TARGET  2

__code unsigned char MA7DOAN[10] = {
    0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F
};

volatile unsigned char hienthi[4] = { 0x3F, 0x3F, 0x3F, 0x3F };

volatile unsigned int  tick      = 0;
volatile unsigned char giay      = 0;
volatile unsigned char phut      = 0;
volatile unsigned char dang_chay = 0;

volatile unsigned int  product_count = 0;
/*---------------------------------------------------------------------
 *  Muc tieu de bao dong. Ha tu 100 xuong 20 (16/09) cho de thu:
 *  voi DCLOCK 2 Hz thi 20 san pham chi mat 10 giay la den bao.
 *  Cum 5 se cho PC doi so nay qua UART bang lenh "SET COUNT n".
 *-------------------------------------------------------------------*/
unsigned int           target_count  = 20;

/*---------------------------------------------------------------------
 *  Bien chong doi cho cam bien.
 *  Khac > 0 nghia la "dang khoa, bo qua xung moi". Ngat Timer giam no
 *  moi 1 ms, nen dat = 20 la khoa dung 20 ms.
 *-------------------------------------------------------------------*/
volatile unsigned char khoa_cambien = 0;

/*=====================================================================
 *  ISR TIMER 0 - moi 1 ms - vector 000BH
 *=====================================================================*/
void timer0_isr(void) __interrupt(1)
{
    static unsigned char vitri = 0;

    TH0 = 0xFC;                 /* che do 1 khong tu nap lai */
    TL0 = 0x66;

    /*--- quet mot chu so ---*/
    CHON_SO1 = BO;
    CHON_SO2 = BO;
    CHON_SO3 = BO;
    CHON_SO4 = BO;

    DOAN = hienthi[vitri];

    switch (vitri) {
        case 0: CHON_SO1 = CHON; break;
        case 1: CHON_SO2 = CHON; break;
        case 2: CHON_SO3 = CHON; break;
        case 3: CHON_SO4 = CHON; break;
    }

    vitri++;
    if (vitri > 3)
        vitri = 0;

    /*--- dem thoi gian ---*/
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

    /*--- nha dan khoa chong doi cua cam bien ---*/
    if (khoa_cambien)
        khoa_cambien--;
}

/*=====================================================================
 *  ISR NGAT NGOAI 1 (INT1, chan P3.3) - vector 0013H
 *---------------------------------------------------------------------
 *  __interrupt(2) = nguon so 2 = INT1.
 *
 *  ⚠ CHONG DOI TRONG NGAT - day la cho khac han nut bam thuong:
 *    nut bam o chuong trinh chinh thi chong doi bang cach "cho 20 ms
 *    roi doc lai". Trong ISR thi TUYET DOI KHONG duoc cho - ISR phai
 *    thoat that nhanh, dang cho thi ngat Timer khong chay duoc va man
 *    hinh se kho lai.
 *    Cach dung: dat mot cai KHOA, roi de ngat Timer go khoa dan. ISR
 *    nay chi viec nhin khoa, khong cho mot micro giay nao.
 *
 *  ⚠ Co IE1 phan cung TU XOA khi nhay vao ISR (vi dang kich theo canh
 *    xuong, IT1 = 1). Khong phai xoa bang tay - khac han co TI/RI cua
 *    cong noi tiep o cum 5, hai co do PHAI xoa bang tay.
 *=====================================================================*/
void int1_isr(void) __interrupt(2)
{
    if (khoa_cambien)
        return;                 /* con trong thoi gian khoa -> bo qua */

    khoa_cambien = 20;          /* khoa 20 ms ke tu bay gio */

    if (dang_chay)              /* dang PAUSE thi khong dem */
        product_count++;
}

void delay20ms(void)
{
    volatile unsigned char i, j;

    for (j = 0; j < 8; j++)
        for (i = 0; i < 250; i++)
            ;
}

void cap_nhat_hienthi(unsigned char che_do)
{
    unsigned int n;

    switch (che_do) {

        case CHEDO_COUNT:
            /*---------------------------------------------------------
             *  ⚠ product_count la unsigned int = HAI byte, ma ISR co the
             *    tang no BAT CU LUC NAO. Doc hai byte roi rac thi co the
             *    vo dung khe: doc byte thap xong, ngat xen vao lam tran
             *    sang byte cao, roi moi doc byte cao => ra mot con so
             *    chua bao gio ton tai (vi du 0x00FF thanh 0x01FF).
             *
             *    Cach chan: tat ngat tong trong DUNG MOT LENH GAN, roi
             *    bat lai ngay. Doan giua hai dong do goi la vung gang
             *    (critical section). Phai that ngan - tat ngat lau thi
             *    man hinh bi giat.
             *-------------------------------------------------------*/
            EA = 0;
            n = product_count;
            EA = 1;

            hienthi[0] = MA7DOAN[n / 1000];
            hienthi[1] = MA7DOAN[(n / 100) % 10];
            hienthi[2] = MA7DOAN[(n / 10) % 10];
            hienthi[3] = MA7DOAN[n % 10];
            break;

        case CHEDO_TIME:
            hienthi[0] = MA7DOAN[phut / 10];
            hienthi[1] = MA7DOAN[phut % 10] | DAU_CHAM;
            hienthi[2] = MA7DOAN[giay / 10];
            hienthi[3] = MA7DOAN[giay % 10];
            break;

        case CHEDO_TARGET:
            n = target_count;
            hienthi[0] = MA_CHU_P;
            hienthi[1] = MA7DOAN[(n / 100) % 10];
            hienthi[2] = MA7DOAN[(n / 10) % 10];
            hienthi[3] = MA7DOAN[n % 10];
            break;
    }
}

void main(void)
{
    unsigned char che_do = CHEDO_COUNT;
    unsigned int  dem_tam;

    P2 = 0xFF;
    P3 = 0xFF;                  /* ⭐ day chot P3 len 1 - cam bien o P3.3
                                   cung phai duoc tha noi cao thi moi co
                                   canh xuong luc nhan */
    DOAN = 0x00;

    /*--- Timer 0: ngat 1 ms ---*/
    TMOD = 0x01;
    TH0  = 0xFC;
    TL0  = 0x66;

    /*--- Ngat ngoai 1: kich theo CANH XUONG ---*/
    IT1 = 1;                    /* ⚠ IT1 = 1 la canh xuong (moi lan nhan
                                   dem dung 1 lan).
                                   IT1 = 0 la theo MUC THAP - giu nut la
                                   ngat lien tuc, dem loan len, gan nhu
                                   khong bao gio muon. */

    ET0 = 1;                    /* cho phep ngat Timer 0 */
    EX1 = 1;                    /* cho phep ngat ngoai 1 */
    EA  = 1;                    /* cong tac tong */
    TR0 = 1;                    /* Timer 0 chay */

    while (1) {

        cap_nhat_hienthi(che_do);

        /*--- START/STOP: chay / tam dung ---*/
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

        /*--- MODE: xoay vong COUNT -> TIME -> TARGET ---*/
        if (NUT_MODE == NHAN) {
            delay20ms();
            if (NUT_MODE == NHAN) {
                che_do++;
                if (che_do > CHEDO_TARGET)
                    che_do = CHEDO_COUNT;

                while (NUT_MODE == NHAN)
                    ;
            }
        }

        /*--- RESET: xoa so dem va thoi gian ---*/
        if (NUT_RESET == NHAN) {
            delay20ms();
            if (NUT_RESET == NHAN) {
                EA = 0;
                product_count = 0;
                EA = 1;

                giay = 0;
                phut = 0;
                tick = 0;

                while (NUT_RESET == NHAN)
                    ;
            }
        }

        /*--- 3 LED bao trang thai ---*/
        if (dang_chay) {
            LED_XANH = SANG;
            LED_VANG = TAT;
        } else {
            LED_XANH = TAT;
            LED_VANG = SANG;
        }

        EA = 0;
        dem_tam = product_count;
        EA = 1;

        if (dem_tam >= target_count)    /* dat muc tieu -> bao dong */
            LED_DO = SANG;
        else
            LED_DO = TAT;
    }
}
