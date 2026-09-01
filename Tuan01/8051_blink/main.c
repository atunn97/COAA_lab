/*=====================================================================
  BLINK 1 LED DON  -  AT89C51 (ho 8051)
  ---------------------------------------------------------------------
  Phan cung mo phong tren Proteus:

        +5V
         |
        [R] 330 ohm
         |
         V  LED (anode noi len tren, cathode noi xuong chan MCU)
         |
      P1.0 (chan so 1 cua AT89C51)

  >>> LUU Y QUAN TRONG (day la cho moi nguoi hay sai):
      Port cua 8051 CHI KEO XUONG MASS TOT (sink ~10-20mA),
      con keo len +5V thi rat yeu (source chi vai chuc micro-Ampe).
      => Phai mac LED kieu "active LOW" nhu hinh tren:
         P1_0 = 0  ->  chan xuong 0V  ->  co dong dien chay qua LED -> SANG
         P1_0 = 1  ->  chan len 5V    ->  hai dau LED bang dien ap  -> TAT

  Thach anh (crystal): 12 MHz  ->  1 machine cycle = 1 us
=====================================================================*/

#include <8051.h>      /* SDCC: dinh nghia san P0,P1,P2,P3, P1_0, TMOD... */

/*---------------------------------------------------------------------
  Ham tre bang vong lap phan mem (cach don gian nhat de bat dau).
  Khong chinh xac tuyet doi, nhung du dung de nhin LED chop bang mat.
---------------------------------------------------------------------*/
void delay_ms(unsigned int ms)
{
    unsigned int i, j;
    for (i = 0; i < ms; i++)
        for (j = 0; j < 120; j++)
            ;                       /* vong lap rong ~1ms @12MHz */
}

void main(void)
{
    P1_0 = 1;                       /* khoi dau: LED tat */

    while (1)                       /* vi dieu khien chay mai mai */
    {
        P1_0 = 0;                   /* keo chan xuong 0V -> LED SANG */
        delay_ms(500);              /* giu sang 0,5 giay             */

        P1_0 = 1;                   /* tha chan len 5V  -> LED TAT   */
        delay_ms(500);              /* giu tat 0,5 giay              */
    }
}
