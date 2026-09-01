/*=====================================================================
  BAN NANG CAO: BLINK LED dung TIMER 0 (chinh xac ve thoi gian)
  ---------------------------------------------------------------------
  Vong lap for() o ban co ban chi la "dem cho het gio" -> thoi gian
  phu thuoc vao trinh bien dich. Timer 0 la bo dem PHAN CUNG ben trong
  8051 nen thoi gian chuan, khong doi khi doi compiler.

  Nguyen ly:
    - Thach anh 12MHz -> 8051 chia 12 -> timer dem len 1 lan moi 1us
    - Timer 0 che do 1 (16 bit) dem tu 0..65535 roi tran (overflow)
    - Muon tre 50ms = 50000us -> nap gia tri dau = 65536 - 50000 = 15536
      15536 = 0x3CB0  ->  TH0 = 0x3C ; TL0 = 0xB0
    - Lap lai 10 lan  ->  500ms
=====================================================================*/

#include <8051.h>

/* Tre chinh xac 50ms bang Timer 0 (che do 16 bit) */
void delay_50ms(void)
{
    TMOD &= 0xF0;      /* xoa 4 bit thap (phan cau hinh cua Timer 0) */
    TMOD |= 0x01;      /* Timer 0, mode 1 = dem 16 bit               */

    TH0 = 0x3C;        /* nap byte cao  cua 15536 */
    TL0 = 0xB0;        /* nap byte thap cua 15536 */

    TF0 = 0;           /* xoa co bao tran          */
    TR0 = 1;           /* BAT timer chay           */

    while (TF0 == 0)   /* doi den khi timer tran (dung 50ms sau)  */
        ;

    TR0 = 0;           /* TAT timer      */
    TF0 = 0;           /* xoa co bao tran */
}

/* Goi delay_50ms nhieu lan de duoc thoi gian dai hon */
void delay_ms(unsigned int ms)
{
    unsigned int n = ms / 50;
    while (n--)
        delay_50ms();
}

void main(void)
{
    while (1)
    {
        P1_0 = 0;          /* LED SANG */
        delay_ms(500);

        P1_0 = 1;          /* LED TAT  */
        delay_ms(500);
    }
}
