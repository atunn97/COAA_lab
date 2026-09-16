/*=====================================================================
 *  CUM 3 - BAI TEST CHAN g   (de tu kiem chung, khong phai bai nop)
 *---------------------------------------------------------------------
 *  Cau hoi can tra loi: chan g nhap nhay la LOI hay la BINH THUONG?
 *
 *  Bai nay quet 4 so nhu that, nhung so hien la CO DINH - khong dem,
 *  khong doi theo thoi gian. Nhan nut MODE de xoay vong 3 mau:
 *
 *    Mau 1:  0 0 0 0   -> ca 4 so deu KHONG dung doan g
 *                         => chan g (P1.6) phai NAM IM o muc 0
 *
 *    Mau 2:  8 8 8 8   -> ca 4 so deu DUNG doan g
 *                         => chan g phai NAM IM o muc 1
 *
 *    Mau 3:  1 2 3 4   -> so 1 khong dung g, con 2 3 4 deu dung g
 *                         => chan g BAT BUOC phai nhap nhay
 *
 *  Neu ba mau cho ra dung ba ket qua tren thi chan g nhap nhay la
 *  HOAT DONG DUNG cua quet da hop, khong phai loi.
 *
 *  Cach nhin: cho chay, bam Pause (khong phai Stop), roi re chuot vao
 *  chan so 7 cua U1 (P1.6) xem muc logic. Lam vai lan o moi mau.
 *
 *  BUILD:
 *    sdcc testquet.c; packihx testquet.ihx | Out-File -Encoding ascii testquet.hex
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

#define NUT_MODE   P3_5
#define NUT_RESET  P2_7

#define SANG   0
#define TAT    1
#define NHAN   0

__code unsigned char MA7DOAN[10] = {
    0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F
};

/* Ba mau thu, moi mau 4 chu so */
__code unsigned char MAU[3][4] = {
    { 0, 0, 0, 0 },     /* g phai NAM IM muc 0 */
    { 8, 8, 8, 8 },     /* g phai NAM IM muc 1 */
    { 1, 2, 3, 4 }      /* g BAT BUOC nhap nhay */
};

void delay5ms(void)
{
    volatile unsigned char i, j;

    for (j = 0; j < 2; j++)
        for (i = 0; i < 250; i++)
            ;
}

void main(void)
{
    unsigned char vitri;
    unsigned char mau = 0;              /* 0, 1, 2 */
    unsigned char mode_da_xu_ly = 0;

    P2 = 0xF0;
    P3 = 0xFF;
    DOAN = 0x00;

    while (1) {

        /*--- quet mot vong du 4 so ---*/
        for (vitri = 0; vitri < 4; vitri++) {

            CHON_SO1 = 0;               /* 1. tat het */
            CHON_SO2 = 0;
            CHON_SO3 = 0;
            CHON_SO4 = 0;

            DOAN = MA7DOAN[MAU[mau][vitri]];    /* 2. doi du lieu */

            switch (vitri) {            /* 3. bat so moi */
                case 0: CHON_SO1 = 1; break;
                case 1: CHON_SO2 = 1; break;
                case 2: CHON_SO3 = 1; break;
                case 3: CHON_SO4 = 1; break;
            }

            delay5ms();
        }

        /*--- nut MODE: xoay vong 3 mau ---*/
        if (NUT_MODE == NHAN) {
            if (!mode_da_xu_ly) {
                mode_da_xu_ly = 1;
                mau++;
                if (mau > 2)
                    mau = 0;
            }
        } else {
            mode_da_xu_ly = 0;
        }

        /*--- 3 LED don bao dang o mau nao: xanh / vang / do ---*/
        LED_XANH = (mau == 0) ? SANG : TAT;
        LED_VANG = (mau == 1) ? SANG : TAT;
        LED_DO   = (mau == 2) ? SANG : TAT;
    }
}
