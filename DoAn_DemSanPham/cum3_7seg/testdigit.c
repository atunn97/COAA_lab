/*=====================================================================
 *  CUM 3 - TEST BON CHAN CHON SO CO DOC LAP KHONG
 *---------------------------------------------------------------------
 *  Bai testtinh truoc BAT CA 4 SO CUNG LUC nen no khong phat hien duoc
 *  truong hop 4 chan chon bi noi chung vao mot cho - luc do van ra 8888
 *  rat dep. Bai nay vá dung lo hong do.
 *
 *  Cach chay: moi luc CHI BAT DUNG MOT so, giu 1 GIAY roi chuyen sang
 *  so ke tiep. Cham nhu vay de nhin bang mat thuong, khong can Pause.
 *
 *      giay 1:  chi so TRAI NHAT   sang, hien  1
 *      giay 2:  chi so thu hai     sang, hien  2
 *      giay 3:  chi so thu ba      sang, hien  3
 *      giay 4:  chi so PHAI NHAT   sang, hien  4
 *      roi lap lai
 *
 *  ⭐ DOC KET QUA:
 *
 *    A. Moi luc chi MOT so sang, va con so chay tu trai sang phai
 *       1 _ _ _   ->   _ 2 _ _   ->   _ _ 3 _   ->   _ _ _ 4
 *       => 4 chan chon DOC LAP, mach dung.
 *
 *    B. CA BON so cung sang cung mot chu so, roi cung doi
 *       1111  ->  2222  ->  3333  ->  4444
 *       => 4 chan chon DANG BI NOI CHUNG. Day la loi mach.
 *          Kiem: 4 chan base co ve dung 4 chan P2.0 P2.1 P2.2 P2.3 khong,
 *          hay lo noi ca 4 vao cung mot chan; va 4 chan digit cua LED
 *          co bi noi dinh vao nhau khong.
 *
 *    C. Chi mot vi tri sang mai, con so doi 1 2 3 4 tai cho
 *       => chi mot transistor dan, ba con kia khong noi toi MCU.
 *
 *  BUILD:
 *    sdcc testdigit.c; packihx testdigit.ihx | Out-File -Encoding ascii testdigit.hex
 *=====================================================================*/

#include <8051.h>

#define DOAN       P1

#define CHON_SO1   P2_0         /* trai nhat */
#define CHON_SO2   P2_1
#define CHON_SO3   P2_2
#define CHON_SO4   P2_3         /* phai nhat */

#define LED_XANH   P2_4
#define LED_VANG   P2_5
#define LED_DO     P2_6

#define SANG   0
#define TAT    1

__code unsigned char MA7DOAN[10] = {
    0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F
};

/*---------------------------------------------------------------------
 *  Tre ~1 giay.
 *    than trong cung 9 chu ky x 250 + 4        = 2 254
 *    than tang giua                             = 2 265
 *    (j < 2) => 4 538 chu ky cho moi vong k
 *    k = 200 => 907 600 chu ky
 *    907 600 x 1,085 us = 984 746 us = 0,98 giay
 *-------------------------------------------------------------------*/
void delay1s(void)
{
    volatile unsigned char i, j, k;

    for (k = 0; k < 200; k++)
        for (j = 0; j < 2; j++)
            for (i = 0; i < 250; i++)
                ;
}

void main(void)
{
    unsigned char vitri = 0;

    P2 = 0xF0;                  /* tat 4 so, tat 3 LED don, P2.7 len 1 */
    P3 = 0xFF;
    DOAN = 0x00;

    while (1) {

        /* 1. tat het chan chon */
        CHON_SO1 = 0;
        CHON_SO2 = 0;
        CHON_SO3 = 0;
        CHON_SO4 = 0;

        /* 2. dat du lieu: vi tri 0 hien so 1, vi tri 1 hien so 2, ... */
        DOAN = MA7DOAN[vitri + 1];

        /* 3. bat DUNG MOT chan chon */
        switch (vitri) {
            case 0: CHON_SO1 = 1; LED_XANH = SANG; LED_VANG = TAT;  LED_DO = TAT;  break;
            case 1: CHON_SO2 = 1; LED_XANH = TAT;  LED_VANG = SANG; LED_DO = TAT;  break;
            case 2: CHON_SO3 = 1; LED_XANH = TAT;  LED_VANG = TAT;  LED_DO = SANG; break;
            case 3: CHON_SO4 = 1; LED_XANH = SANG; LED_VANG = SANG; LED_DO = SANG; break;
        }

        delay1s();              /* giu nguyen 1 giay de nhin ro */

        vitri++;
        if (vitri > 3)
            vitri = 0;
    }
}
