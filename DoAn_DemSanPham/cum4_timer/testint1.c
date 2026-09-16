/*=====================================================================
 *  TEST NGAT NGOAI INT1  (chi de do loi, khong phai bai nop)
 *---------------------------------------------------------------------
 *  Bo het 3 che do hien thi, bo START/STOP, bo ALARM, bo dong ho.
 *  Man hinh CHI hien mot thu duy nhat: product_count.
 *  Khong can nhan START - no dem ngay tu luc bat nguon.
 *
 *  Them mot dau hieu song: MOI LAN INT1 CHAY, LED XANH DAO TRANG THAI.
 *  Nen kể cả man hinh 7 doan co truc trac, chi can nhin LED xanh la
 *  biet ngat co an hay khong.
 *
 *  ⭐ DOC KET QUA:
 *
 *    A. LED xanh nhap nhay + so dem tang
 *       -> INT1 TOT. Quay lai demsp.hex, va luc do loi ALARM la that.
 *
 *    B. LED xanh DUNG YEN, so dem = 0000 mai
 *       -> INT1 KHONG HE CHAY. Kiem theo thu tu:
 *          1. DCLOCK da noi dung chan 13 (P3.3) chua?
 *          2. DCLOCK co dang chay khong - nhap dup no xem Frequency
 *             da dat chua (de trong la no khong phat gi ca)
 *          3. Nut BUTTON cu o P3.3 da xoa han chua - con sot day thi
 *             no ghim muc, DCLOCK khong tao duoc canh xuong
 *
 *    C. LED xanh nhap nhay nhung so dem dung yen
 *       -> ngat chay nhung bien khong tang: bao tôi biet, loi phan mem.
 *
 *  BUILD:
 *    sdcc testint1.c; packihx testint1.ihx | Out-File -Encoding ascii testint1.hex
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

#define CHON   0
#define BO     1

__code unsigned char MA7DOAN[10] = {
    0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F
};

volatile unsigned char hienthi[4] = { 0x3F, 0x3F, 0x3F, 0x3F };
volatile unsigned int  product_count = 0;
volatile unsigned char khoa_cambien  = 0;

/* Ngat Timer 0: chi lo quet man hinh */
void timer0_isr(void) __interrupt(1)
{
    static unsigned char vitri = 0;

    TH0 = 0xFC;
    TL0 = 0x66;

    CHON_SO1 = BO;
    CHON_SO2 = BO;
    CHON_SO3 = BO;
    CHON_SO4 = BO;

    DOAN = hienthi[vitri];

    switch (vitri) {
        case 0: CHON_SO1 = CHON; break;
        case 1: CHON_SO2 = CHON; break;
        case 2: CHON_SO3 = CHON; break;
        case 3: CHON_SO4 = CHON; break;
    }

    vitri++;
    if (vitri > 3)
        vitri = 0;

    if (khoa_cambien)
        khoa_cambien--;
}

/* Ngat ngoai 1: dem, va DAO LED XANH de nhin thay bang mat */
void int1_isr(void) __interrupt(2)
{
    if (khoa_cambien)
        return;

    khoa_cambien = 20;

    product_count++;

    LED_XANH = !LED_XANH;       /* dau hieu song: ngat vua chay */
}

void main(void)
{
    unsigned int n;

    P2 = 0xFF;
    P3 = 0xFF;                  /* bat buoc: tha noi cao P3.3 thi moi co
                                   canh xuong luc DCLOCK keo xuong */
    DOAN = 0x00;

    LED_VANG = 1;               /* tat */
    LED_DO   = 1;               /* tat */

    TMOD = 0x01;
    TH0  = 0xFC;
    TL0  = 0x66;

    IT1 = 1;                    /* INT1 kich theo canh xuong */
    ET0 = 1;
    EX1 = 1;
    EA  = 1;
    TR0 = 1;

    while (1) {
        EA = 0;
        n = product_count;
        EA = 1;

        hienthi[0] = MA7DOAN[n / 1000];
        hienthi[1] = MA7DOAN[(n / 100) % 10];
        hienthi[2] = MA7DOAN[(n / 10) % 10];
        hienthi[3] = MA7DOAN[n % 10];
    }
}
