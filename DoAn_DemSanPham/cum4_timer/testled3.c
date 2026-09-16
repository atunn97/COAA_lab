/*=====================================================================
 *  TEST BA LED DON  (chi de do loi, khong phai bai nop)
 *---------------------------------------------------------------------
 *  Khong ngat, khong quet, khong dem, KHONG DOC MOT NUT NAO.
 *  Chuong trinh chi bat LAN LUOT tung LED, moi cai 1 giay:
 *
 *      giay 1:  chi XANH sang   (P2.4)
 *      giay 2:  chi VANG sang   (P2.5)
 *      giay 3:  chi DO   sang   (P2.6)
 *      roi lap lai
 *
 *  ⭐ VI SAO CAN BAI NAY dù da co testnut:
 *    testnut bat LED do bang cach chep muc cua NUT RESET (P2.7) sang
 *    chan LED do (P2.6). Neu con LED do that ra dang noi o P2.7 - tuc
 *    CHUNG CHAN voi nut RESET - thi nhan nut se keo chan xuong 0 va
 *    LED van sang. Nhin thi tuong "LED do con song va noi dung", that
 *    ra no sang vi CAI NUT, khong phai vi code.
 *    Bai nay khong dung toi nut nao, nen khong the nham duoc nua.
 *
 *  ⭐ DOC KET QUA:
 *    A. Ca ba LED lan luot sang deu   -> ba LED noi dung chan.
 *                                        Loi ALARM nam cho khac.
 *    B. Xanh va vang sang, DO KHONG BAO GIO SANG
 *                                     -> LED do KHONG o chan P2.6.
 *                                        Nhieu kha nang no dang o P2.7
 *                                        (chan 28), chung voi nut RESET.
 *                                        Soi lai day cua no: phai ve
 *                                        chan 27.
 *    C. Hai LED cung sang mot luc     -> hai chan chung net.
 *
 *  BUILD:
 *    sdcc testled3.c; packihx testled3.ihx | Out-File -Encoding ascii testled3.hex
 *=====================================================================*/

#include <8051.h>

#define CHON_SO1   P2_0
#define CHON_SO2   P2_1
#define CHON_SO3   P2_2
#define CHON_SO4   P2_3

#define LED_XANH   P2_4
#define LED_VANG   P2_5
#define LED_DO     P2_6

#define SANG   0
#define TAT    1

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
    unsigned char buoc = 0;

    P2 = 0xFF;                  /* tat het */
    P3 = 0xFF;
    P1 = 0x00;                  /* tat 8 doan */

    while (1) {
        /* Tat het 4 chu so de man hinh 7 doan khong sang, khoi roi mat */
        CHON_SO1 = 1;
        CHON_SO2 = 1;
        CHON_SO3 = 1;
        CHON_SO4 = 1;

        switch (buoc) {
            case 0:
                LED_XANH = SANG;  LED_VANG = TAT;   LED_DO = TAT;
                break;
            case 1:
                LED_XANH = TAT;   LED_VANG = SANG;  LED_DO = TAT;
                break;
            case 2:
                LED_XANH = TAT;   LED_VANG = TAT;   LED_DO = SANG;
                break;
        }

        delay1s();

        buoc++;
        if (buoc > 2)
            buoc = 0;
    }
}
