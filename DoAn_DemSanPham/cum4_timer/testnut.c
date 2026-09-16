/*=====================================================================
 *  TEST BA NUT  (chi de do loi, khong phai bai nop)
 *---------------------------------------------------------------------
 *  Bo sach ngat, bo quet man hinh, bo dem. Chuong trinh chi lam dung
 *  mot viec: soi guong trang thai ba chan nut len ba LED don.
 *
 *      LED XANH  <-  P3.2  (nut START/STOP)
 *      LED VANG  <-  P3.5  (nut MODE)        <- cai dang nghi
 *      LED DO    <-  P2.7  (nut RESET)
 *
 *  Nut noi xuong GND nen nhan = muc 0; LED mac active LOW nen ghi 0 la
 *  sang. Vay: NHAN NUT NAO -> LED TUONG UNG SANG. Khong nhan thi tat.
 *
 *  ⭐ BON KET QUA CO THE, moi cai chi mot nguyen nhan khac nhau:
 *
 *    1. Nhan MODE -> LED VANG sang, tha ra -> tat
 *       => nut MODE TOT. Loi nam o cho khac, quay lai soi phan mem.
 *
 *    2. Nhan MODE -> LED VANG khong nhuc nhich
 *       => day nut MODE dut, hoac chua noi ve GND.
 *          Soi lai chan 15 cua U1.
 *
 *    3. Khong nhan gi ma LED VANG da sang san
 *       => P3.5 dang bi keo xuong 0 boi cai gi do khac.
 *
 *    4. ⭐ DE DCLOCK CHAY (khong dung tay vao nut nao ca):
 *       LED VANG NHAP NHAY theo nhip clock
 *       => P3.3 va P3.5 DANG CHUNG MOT NET. Generator ap tin hieu len
 *          ca hai chan, nut MODE khong the keo xuong duoc nua.
 *          Day dung la kieu loi da gap o bon chan digit.
 *
 *  Lam luon phep thu 4 truoc - no khong can dung tay, chi ngoi nhin.
 *
 *  BUILD:
 *    sdcc testnut.c; packihx testnut.ihx | Out-File -Encoding ascii testnut.hex
 *=====================================================================*/

#include <8051.h>

#define CHON_SO1   P2_0
#define CHON_SO2   P2_1
#define CHON_SO3   P2_2
#define CHON_SO4   P2_3

#define LED_XANH   P2_4
#define LED_VANG   P2_5
#define LED_DO     P2_6

#define NUT_STARTSTOP  P3_2
#define NUT_MODE       P3_6
#define NUT_RESET      P2_7

void main(void)
{
    /* Day chot len 1 de doc duoc nut - dong bat buoc, port 8051 la
       quasi-bidirectional */
    P2 = 0xFF;
    P3 = 0xFF;

    P1 = 0x00;                  /* tat 8 doan cho khoi roi mat */

    while (1) {
        /* Tat het 4 chu so (noi thang: 1 la tat) de man hinh 7 doan
           khong sang gi, chi con 3 LED don noi chuyen */
        CHON_SO1 = 1;
        CHON_SO2 = 1;
        CHON_SO3 = 1;
        CHON_SO4 = 1;

        /* Chep thang muc logic cua chan nut ra chan LED.
           Nut nhan = 0  ->  LED = 0  ->  LED sang. */
        LED_XANH = NUT_STARTSTOP;
        LED_VANG = NUT_MODE;
        LED_DO   = NUT_RESET;
    }
}
