/*=====================================================================
 *  CUM 2  -  BA NUT NHAN          8051 / SDCC
 *---------------------------------------------------------------------
 *  Viec cua bai nay: chung minh ba nut doc duoc, va doc DUNG - tuc la
 *  mot lan nhan chi tinh mot lan, khong bi tinh thanh chuc lan.
 *
 *  PHAN CUNG THEM VAO CUM 1 (khong go gi cua cum 1):
 *    P3.2 (chan 12) -> nut START/STOP
 *    P2.7 (chan 28) -> nut RESET
 *    P3.5 (chan 15) -> nut MODE
 *    Moi nut: mot dau vao chan MCU, dau kia xuong GND.
 *    KHONG can tro keo ngoai - P2 va P3 co tro keo noi.
 *    => nhan = chan xuong 0.
 *
 *  CACH CHAY:
 *    Luc bat nguon    : PAUSE  -> LED VANG sang
 *    Nhan START/STOP  : doi qua lai RUN <-> PAUSE  (xanh <-> vang)
 *    Nhan MODE        : bat/tat LED DO
 *    Nhan RESET       : ve PAUSE, tat LED DO
 *
 *  BUILD (PowerShell 5.1 - dung ; chu KHONG dung &&):
 *    sdcc nut3.c; packihx nut3.ihx | Out-File -Encoding ascii nut3.hex
 *=====================================================================*/

#include <8051.h>

/*---------------------------------------------------------------------
 *  Dung tung BIT chu khong ghi ca byte P2.
 *
 *  Ly do: tren P2 dang co LAN CA HAI LOAI - P2.4..P2.6 la dau ra (LED),
 *  con P2.7 la dau vao (nut RESET). Ghi ca byte kieu "P2 = 0xEF" se
 *  keo luon P2.7 xuong 0 va tu do KHONG CON DOC DUOC nut nua.
 *  Ghi tung bit thi cac bit khac giu nguyen.
 *-------------------------------------------------------------------*/
#define LED_XANH   P2_4         /* RUN   */
#define LED_VANG   P2_5         /* PAUSE */
#define LED_DO     P2_6         /* ALARM */

#define NUT_STARTSTOP  P3_2
#define NUT_RESET      P2_7
#define NUT_MODE       P3_5

#define SANG   0                /* LED mac ACTIVE LOW: ghi 0 la sang */
#define TAT    1
#define NHAN   0                /* nut noi xuong GND: nhan la muc 0  */

/*---------------------------------------------------------------------
 *  Tre ~20 ms - dung de CHO HET DOI PHIM.
 *
 *  Tiep diem co khi khong dong dut khoat: no nay 5-20 ms, trong khoang
 *  do muc dien ap nhay 0-1 hang chuc lan. CPU chay 11 trieu lenh moi
 *  giay nen no doc duoc het ca chuc lan nay => mot cai nhan tay thanh
 *  chuc lan nhan neu khong chan.
 *
 *  ⚠ volatile la BAT BUOC: thieu no SDCC 4.5.0 xoa sach vong lap rong
 *    (day la bay da dinh o bai dichled).
 *
 *  HAI CON SO 8 VA 250 O DAU RA? Khong doan - dem tu file nut3.asm do
 *  SDCC sinh ra (mo ra xem la thay nguyen van doan duoi):
 *
 *    than vong trong  mov/add/jc/mov/inc/mov/sjmp = 1+1+2+1+1+1+2 = 9 chu ky
 *    ca vong trong    250 x 9 + 4 (lan thoat)                     = 2 254
 *    than vong ngoai  1+1+2+2 + 2 254 + 1+1+1+2                   = 2 265
 *    ca ham           2 + 8 x 2 265 + 4 + 2 (ret)                 = 18 128 chu ky
 *
 *    18 128 x 1,085 us = 19 670 us = 19,7 ms   (dat: 20 ms)
 *
 *  Day cung la CACH LAY SO cho cot "total cycles" trong bao cao: ban C
 *  khong dem duoc tren code C, phai dem tren file .asm do no sinh ra.
 *-------------------------------------------------------------------*/
void delay20ms(void)
{
    volatile unsigned char i, j;

    for (j = 0; j < 8; j++)
        for (i = 0; i < 250; i++)
            ;
}

/*---------------------------------------------------------------------
 *  BA BUOC CUA MOT LAN DOC NUT DUNG CACH - thieu buoc nao cung hong:
 *
 *    1. thay muc 0                      -> co the la nhan, co the la nhieu
 *    2. cho 20 ms roi DOC LAI           -> con 0 nghia la nhan that
 *    3. cho toi khi NHA ra moi di tiep  -> neu khong, giu nut mot giay
 *                                          la trang thai lat qua lai
 *                                          hang nghin lan
 *
 *  Tra ve 1 neu that su co mot lan nhan.
 *-------------------------------------------------------------------*/
unsigned char da_nhan(unsigned char muc_doc_duoc)
{
    if (muc_doc_duoc != NHAN)
        return 0;               /* buoc 1: khong phai muc 0 -> bo qua */

    delay20ms();                /* buoc 2: cho het doi */
    return 1;
}

void main(void)
{
    unsigned char dang_chay = 0;        /* 0 = PAUSE, 1 = RUN */
    unsigned char den_do    = 0;        /* 0 = tat,   1 = sang */

    /*-----------------------------------------------------------------
     *  ⚠ DONG QUAN TRONG NHAT CUA BAI NAY
     *
     *  Port 8051 la QUASI-BIDIRECTIONAL: moi chan co mot chot. Chot dang
     *  giu 0 thi transistor keo chan xuong mass - luc do du nut ben ngoai
     *  co the nao di nua, DOC VAO VAN RA 0.
     *  Phai ghi 1 ra chot truoc thi chan moi "tha noi cao" va doc duoc.
     *
     *  Sau reset moi port mac dinh = 0xFF nen bo hai dong nay chuong
     *  trinh VAN CHAY DUNG - do may. Cang nguy hiem, vi loi khong bieu
     *  hien ra. Van phai viet cho tuong minh.
     *---------------------------------------------------------------*/
    P2 = 0xFF;
    P3 = 0xFF;

    while (1) {

        /*--- NUT START/STOP: doi qua lai RUN <-> PAUSE ---*/
        if (da_nhan(NUT_STARTSTOP)) {
            if (NUT_STARTSTOP == NHAN) {        /* doc lai sau 20 ms */
                if (dang_chay)
                    dang_chay = 0;
                else
                    dang_chay = 1;

                while (NUT_STARTSTOP == NHAN)   /* buoc 3: cho NHA ra */
                    ;
            }
        }

        /*--- NUT MODE: bat/tat LED DO ---*/
        if (da_nhan(NUT_MODE)) {
            if (NUT_MODE == NHAN) {
                if (den_do)
                    den_do = 0;
                else
                    den_do = 1;

                while (NUT_MODE == NHAN)
                    ;
            }
        }

        /*--- NUT RESET: ve trang thai ban dau ---*/
        if (da_nhan(NUT_RESET)) {
            if (NUT_RESET == NHAN) {
                dang_chay = 0;
                den_do    = 0;

                while (NUT_RESET == NHAN)
                    ;
            }
        }

        /*--- Cap nhat 3 LED theo trang thai hien tai ---*/
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
