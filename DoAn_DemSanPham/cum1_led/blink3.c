/*=====================================================================
 *  CUM 1  -  NHAP NHAY 3 LED DON        8051 / SDCC
 *---------------------------------------------------------------------
 *  Ban C cua blink3_asm.asm. Cung mot viec, de doi chieu 4 chi so
 *  (size / total cycles / execution time / CPI) giua C va ASM.
 *
 *  PHAN CUNG (theo bang chan da chot):
 *    P2.4 -> LED XANH (RUN)   P2.5 -> LED VANG (PAUSE)   P2.6 -> LED DO (ALARM)
 *    Mac ACTIVE LOW: ghi 0 = sang.
 *    Thach anh 11,0592 MHz.
 *
 *  BUILD (PowerShell 5.1 - dung dau ; chu KHONG dung &&):
 *    sdcc blink3.c; packihx blink3.ihx | Out-File -Encoding ascii blink3.hex
 *
 *  ⚠ BAY DA DINH O BAI dichled: SDCC 4.5.0 XOA vong lap rong neu bien
 *    dem khong co volatile - LED se dung im ma nhin code khong thay sai.
 *    Ba bien i, j, k duoi day BAT BUOC co volatile.
 *=====================================================================*/

#include <8051.h>

/* Mau bit xuat ra P2 - xem giai thich trong ban ASM */
#define LED_TAT_HET   0xFF
#define LED_XANH      0xEF      /* 1110 1111 -> P2.4 = 0 */
#define LED_VANG      0xDF      /* 1101 1111 -> P2.5 = 0 */
#define LED_DO        0xBF      /* 1011 1111 -> P2.6 = 0 */

/*---------------------------------------------------------------------
 *  Tre ~500 ms. Dung dung ba con so cua ban ASM (5 / 183 / 250) de hai
 *  ban nhay gan bang nhau - nhung KHONG bang het: trinh dich sinh them
 *  lenh quanh moi vong, nen ban C luon cham hon mot chut. Do chenh lech
 *  do chinh la mot trong nhung con so dang dua vao bao cao.
 *-------------------------------------------------------------------*/
void delay500(void)
{
    volatile unsigned char i, j, k;

    for (k = 0; k < 5; k++)
        for (j = 0; j < 183; j++)
            for (i = 0; i < 250; i++)
                ;
}

void main(void)
{
    P2 = LED_TAT_HET;           /* tat het truoc khi vao vong lap */

    while (1) {
        P2 = LED_XANH;
        delay500();

        P2 = LED_VANG;
        delay500();

        P2 = LED_DO;
        delay500();
    }
}
