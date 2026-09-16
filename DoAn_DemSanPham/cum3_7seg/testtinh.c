/*=====================================================================
 *  CUM 3 - BAI TEST TINH   (chi dung de DO LOI MACH, khong phai bai nop)
 *---------------------------------------------------------------------
 *  Bo sach phan quet, bo vong lap, bo mang, bo phep chia.
 *  Chuong trinh chi ghi DUNG HAI GIA TRI roi dung yen mai mai.
 *
 *  Muc dich: tach bach "loi mach" voi "loi code".
 *
 *    Neu thay 8888 (co ca 4 dau cham)  -> MACH DUNG, quay lai quet4so.hex
 *    Neu khong thay gi                 -> LOI MACH phia transistor / chan chung
 *
 *  Vi sao bai nay dang tin: no bat 4 so SANG CUNG LUC va giu nguyen,
 *  khong co gi nhap nhay, khong phu thuoc thoi gian. Nhin mot cai la biet.
 *
 *  BUILD:
 *    sdcc testtinh.c; packihx testtinh.ihx | Out-File -Encoding ascii testtinh.hex
 *=====================================================================*/

#include <8051.h>

void main(void)
{
    /*-----------------------------------------------------------------
     *  P2 = 0xCF = 1100 1111
     *      P2.0..P2.3 = 1  -> BAT ca 4 so cung luc (qua NPN: 1 la dan)
     *      P2.4       = 0  -> LED XANH sang   \  hai den nay sang la
     *      P2.5       = 0  -> LED VANG sang   /  bang chung chip dang chay
     *      P2.6       = 1  -> LED DO tat
     *      P2.7       = 1  -> chot len 1 (nut RESET)
     *---------------------------------------------------------------*/
    P2 = 0xCF;

    /* Tat ca 8 doan = 1 -> moi so hien "8" kem dau cham */
    P1 = 0xFF;

    while (1)
        ;                       /* dung yen, khong lam gi them */
}
