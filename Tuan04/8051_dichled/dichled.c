#include <8051.h>

void delay_ms(unsigned int ms)
{
    unsigned int i, j;
    for (i = 0; i < ms; i++)
        for (j = 0; j < 120; j++)
            ;
}

void hieuung1_sangdan(void)
{
    volatile unsigned char p = 0xFF;
    unsigned char i;

    for (i = 0; i < 9; i++)
    {
        P1 = p;
        delay_ms(300);
        p = (unsigned char)(p << 1);
    }
}

void hieuung2_blink8(void)
{
    unsigned char p =0x00;
    unsigned char i;

    for (i = 0; i < 16; i++)         /* chớp đúng 8 lần */
    {
        P1=p;
        delay_ms(300);
        p=~p;
    }
}

void hieuung3_dichled(void)
{
    unsigned char p =0xFE;
    unsigned char i;
    for (i=0; i<8; i++)
    {
        P1=p;
        delay_ms(300);
        p = (unsigned char)((p << 1) | 0x01);
    }
}

void main(void)
{
    P1 = 0xFF;                      /* khởi động: tắt hết */

    while (1)
    {
        hieuung1_sangdan();
        hieuung2_blink8();
        hieuung3_dichled();
    }
}