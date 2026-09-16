/*=====================================================================
 *  CUM 3 - TEST 4 CHAN CHON SO, BAN NOI THANG (BO TRANSISTOR)
 *---------------------------------------------------------------------
 *  Giong het testdigit.c, CHI KHAC MOT CHO: logic chon so bi DAO.
 *
 *    Ban co transistor NPN : MCU = 1 -> transistor dan -> so SANG
 *    Ban noi thang         : MCU = 0 -> keo cathode xuong mass -> so SANG
 *
 *  PHAN CUNG:
 *    Bo 4 transistor va 4 tro base.
 *    Noi THANG chan digit cua LED vao chan MCU:
 *        chan 1 (so trai nhat) -> P2.0  (chan 21)
 *        chan 2                -> P2.1  (chan 22)
 *        chan 3                -> P2.2  (chan 23)
 *        chan 4 (so phai nhat) -> P2.3  (chan 24)
 *
 *  ⚠ Chi lam duoc trong MO PHONG. Mach that thi mot so sang ca 8 doan
 *    rut toi ~80 mA qua chan chung - vuot xa suc mot chan MCU, phai co
 *    transistor. Proteus bo qua gioi han dong nay.
 *    => Bao cao van phai ve transistor va giai thich ly do.
 *
 *  KET QUA MONG DOI: moi giay dung MOT so sang, chay tu trai sang phai
 *        1 _ _ _   ->   _ 2 _ _   ->   _ _ 3 _   ->   _ _ _ 4
 *
 *  BUILD:
 *    sdcc testdigit_truc.c; packihx testdigit_truc.ihx | Out-File -Encoding ascii testdigit_truc.hex
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

#define SANG   0
#define TAT    1

/* ⭐ DAO SO VOI BAN TRANSISTOR: 0 = chon so nay, 1 = tat */
#define CHON   0
#define BO     1

__code unsigned char MA7DOAN[10] = {
    0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F
};

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

    /* P2 = 0xFF: 4 chan chon deu = 1 -> TAT het (vi gio 0 moi la chon),
       3 LED don = 1 -> tat, P2.7 = 1 -> con doc duoc nut */
    P2 = 0xFF;
    P3 = 0xFF;
    DOAN = 0x00;

    while (1) {

        /* 1. tat het chan chon */
        CHON_SO1 = BO;
        CHON_SO2 = BO;
        CHON_SO3 = BO;
        CHON_SO4 = BO;

        /* 2. dat du lieu */
        DOAN = MA7DOAN[vitri + 1];

        /* 3. bat DUNG MOT chan chon */
        switch (vitri) {
            case 0: CHON_SO1 = CHON; LED_XANH = SANG; LED_VANG = TAT;  LED_DO = TAT;  break;
            case 1: CHON_SO2 = CHON; LED_XANH = TAT;  LED_VANG = SANG; LED_DO = TAT;  break;
            case 2: CHON_SO3 = CHON; LED_XANH = TAT;  LED_VANG = TAT;  LED_DO = SANG; break;
            case 3: CHON_SO4 = CHON; LED_XANH = SANG; LED_VANG = SANG; LED_DO = SANG; break;
        }

        delay1s();

        vitri++;
        if (vitri > 3)
            vitri = 0;
    }
}
