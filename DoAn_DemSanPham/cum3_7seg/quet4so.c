/*=====================================================================
 *  CUM 3  -  LED 7 DOAN 4 SO, QUET DA HOP        8051 / SDCC
 *---------------------------------------------------------------------
 *  Viec cua bai nay: hien duoc 4 chu so cung luc bang 12 chan thay vi 32,
 *  va hien ma khong nhay, khong bong ma.
 *
 *  Man hinh dem len 0000 -> 0001 -> ... moi giay mot don vi, de nhin
 *  la biet ngay ca bon so co song va co dung vi tri hay khong.
 *
 *  PHAN CUNG THEM VAO CUM 1 + 2:
 *    P1.0..P1.7 -> 8 doan  a b c d e f g dp   (dung CHUNG cho ca 4 so)
 *                  moi doan qua mot tro 330R
 *    P2.0..P2.3 -> 4 chan CHON SO, qua 4 transistor NPN
 *                  P2.0 = so trai nhat (hang nghin)
 *                  P2.3 = so phai nhat (hang don vi)
 *
 *  ⭐ VI SAO QUET DA HOP:
 *    Noi thang 4 con LED 7 doan can 4 x 8 = 32 chan. Con chip chi co
 *    32 chan I/O tong cong -> khong con chan nao cho nut, LED bao, UART.
 *    Quet da hop dung chung 8 chan doan cho ca 4 so, them 4 chan chon
 *    => het 12 chan.
 *    Doi lai: moi luc CHI MOT SO thuc su sang. Doi so du nhanh (moi so
 *    ~5 ms, vong du 4 so 20 ms = 50 Hz) thi mat nguoi khong kip thay
 *    nhay, tuong ca 4 cung sang.
 *
 *  ⭐ VI SAO PHAI CO 4 TRANSISTOR:
 *    Mot so sang ca 8 doan rut toi ~80 mA qua chan chung cua no - vuot
 *    xa suc mot chan MCU. Transistor gach chan chung xuong mass, chan
 *    MCU chi lai dong base vai mA.
 *    Proteus BO QUA gioi han dong nay, nen bo transistor van thay chay -
 *    mach that thi hong. Day la cau van dap rat hay bi hoi.
 *
 *  BUILD (PowerShell 5.1 - dung ; chu KHONG dung &&):
 *    sdcc quet4so.c; packihx quet4so.ihx | Out-File -Encoding ascii quet4so.hex
 *=====================================================================*/

#include <8051.h>

#define DOAN       P1           /* ca 8 doan mot luc - P1 toan dau ra nen
                                   ghi ca byte thoai mai, khong nhu P2 */

/* 4 chan chon so. Qua transistor NPN nen: 1 = so do SANG, 0 = tat */
#define CHON_SO1   P2_0         /* trai nhat  - hang nghin */
#define CHON_SO2   P2_1         /*            - hang tram  */
#define CHON_SO3   P2_2         /*            - hang chuc  */
#define CHON_SO4   P2_3         /* phai nhat  - hang don vi */

#define LED_XANH   P2_4
#define LED_VANG   P2_5
#define LED_DO     P2_6

#define NUT_STARTSTOP  P3_2
#define NUT_RESET      P2_7
#define NUT_MODE       P3_5

#define SANG   0                /* LED don mac ACTIVE LOW */
#define TAT    1
#define NHAN   0

/*---------------------------------------------------------------------
 *  BANG MA 7 DOAN - loai COMMON CATHODE (doan sang khi chan = 1)
 *  Thu tu bit:  dp g f e d c b a   (bit0 = doan a, bit7 = dau cham)
 *
 *  __code = dat bang nay trong ROM. Thieu tu khoa nay thi trinh dich
 *  chep bang vao RAM luc khoi dong - ton ca RAM lan ROM. 8051 la kien
 *  truc HARVARD: ROM va RAM la hai khong gian nho tach roi, doc ROM
 *  phai bang lenh MOVC.
 *-------------------------------------------------------------------*/
__code unsigned char MA7DOAN[10] = {
    0x3F,   /* 0 */
    0x06,   /* 1  - chi sang b va c, nen so 1 la phep thu NHAY NHAT
                    cho loi sai thu tu doan a..g */
    0x5B,   /* 2 */
    0x4F,   /* 3 */
    0x66,   /* 4 */
    0x6D,   /* 5 */
    0x7D,   /* 6 */
    0x07,   /* 7 */
    0x7F,   /* 8  - sang ca 7 doan */
    0x6F    /* 9 */
};

/* 4 chu so dang hien, [0] la so trai nhat */
unsigned char hienthi[4] = { 0, 0, 0, 0 };

/*---------------------------------------------------------------------
 *  Tre ~20 ms - cho het doi phim, giu nguyen tu cum 2.
 *-------------------------------------------------------------------*/
void delay20ms(void)
{
    volatile unsigned char i, j;

    for (j = 0; j < 8; j++)
        for (i = 0; i < 250; i++)
            ;
}

/*---------------------------------------------------------------------
 *  Tre ~5 ms - thoi gian mot so duoc sang trong mot vong quet.
 *  Dem tu file quet4so.asm do SDCC sinh ra, cung cach nhu cum 2:
 *      than vong trong 9 chu ky x 250 + 4      = 2 254
 *      than vong ngoai                          = 2 265
 *      ca ham: 2 + 2 x 2 265 + 4 + 2            = 4 538 chu ky
 *      4 538 x 1,085 us = 4 924 us = 4,9 ms
 *-------------------------------------------------------------------*/
void delay5ms(void)
{
    volatile unsigned char i, j;

    for (j = 0; j < 2; j++)
        for (i = 0; i < 250; i++)
            ;
}

/* ⭐ 16/09: DA BO 4 TRANSISTOR, noi THANG chan digit vao P2.0..P2.3
   => logic chon so DAO LAI: 0 = chon so nay, 1 = tat */
#define CHON   0
#define BO     1

void tat_het_so(void)
{
    CHON_SO1 = BO;
    CHON_SO2 = BO;
    CHON_SO3 = BO;
    CHON_SO4 = BO;
}

/*---------------------------------------------------------------------
 *  MOT VONG QUET DU 4 SO  (~20 ms  ->  50 Hz)
 *
 *  ⚠ THU TU BA BUOC NAY LA BAT BUOC, DAO LA HONG:
 *      1. TAT het chan chon
 *      2. DOI du lieu tren 8 chan doan
 *      3. BAT chan chon cua so moi
 *
 *  Lam sai thu tu - vi du doi du lieu truoc khi tat so cu - thi trong
 *  khoanh khac do, so CU dang bat lai nhan du lieu cua so MOI. Ket qua
 *  la "BONG MA" (ghosting): chu so nay thoang hien mo o cho chu so kia.
 *-------------------------------------------------------------------*/
void quet_mot_vong(void)
{
    unsigned char vitri;

    for (vitri = 0; vitri < 4; vitri++) {

        tat_het_so();                           /* 1 */

        DOAN = MA7DOAN[hienthi[vitri]];         /* 2 */

        switch (vitri) {                        /* 3 */
            case 0: CHON_SO1 = CHON; break;
            case 1: CHON_SO2 = CHON; break;
            case 2: CHON_SO3 = CHON; break;
            case 3: CHON_SO4 = CHON; break;
        }

        delay5ms();
    }
}

/* Tach so 0..9999 thanh 4 chu so roi nap vao mang hienthi */
void nap_so(unsigned int gia_tri)
{
    hienthi[0] = (unsigned char)(gia_tri / 1000);
    hienthi[1] = (unsigned char)((gia_tri / 100) % 10);
    hienthi[2] = (unsigned char)((gia_tri / 10) % 10);
    hienthi[3] = (unsigned char)(gia_tri % 10);
}

void main(void)
{
    unsigned int  dem  = 0;     /* so dang hien, 0..9999 */
    unsigned char vong = 0;     /* dem so vong quet da chay */

    unsigned char dang_chay = 0;        /* 0 = PAUSE, 1 = RUN  */
    unsigned char den_do    = 0;        /* 0 = tat,   1 = sang */

    /* Co nho "nut nay da xu ly roi, cho toi khi nha ra" - thay cho
       vong cho nha nut cua cum 2, de khong chan vong quet */
    unsigned char ss_da_xu_ly   = 0;
    unsigned char mode_da_xu_ly = 0;

    /*-----------------------------------------------------------------
     *  Khoi tao P2 = 0xF0 = 1111 0000, KHONG phai 0xFF nhu cum truoc:
     *      P2.0..P2.3 = 0  -> tat het 4 so (qua NPN, 0 la tat)
     *      P2.4..P2.6 = 1  -> tat 3 LED don (active LOW, 1 la tat)
     *      P2.7       = 1  -> day chot len 1 de con DOC duoc nut RESET
     *
     *  Mot byte duy nhat ma ba nhom bit mang ba y nghia khac nhau -
     *  day la ly do tu cum 2 tro di phai ghi tung BIT chu dung ghi ca byte.
     *---------------------------------------------------------------*/
    P2 = 0xFF;                  /* 4 chan chon = 1 -> tat het (noi thang: 0 moi la chon)
                                   3 LED don   = 1 -> tat
                                   P2.7        = 1 -> con doc duoc nut RESET */
    P3 = 0xFF;                  /* de doc duoc nut START/STOP va MODE */
    DOAN = 0x00;                /* tat het 8 doan */

    LED_VANG = SANG;            /* khoi dong o trang thai PAUSE */

    while (1) {

        quet_mot_vong();        /* ~20 ms */

        /*-------------------------------------------------------------
         *  Chua dung Timer nen dem giay bang chinh so vong quet:
         *      1 vong ~ 20 ms  ->  50 vong ~ 1 giay
         *
         *  ⚠ Day la cach TAM. No sai so vai phan tram va CPU khong lam
         *    duoc viec gi khac trong luc cho. Cum 4 se thay han bang
         *    ngat Timer - do moi la cach dung.
         *-----------------------------------------------------------*/
        vong++;
        if (vong >= 50) {
            vong = 0;

            dem++;
            if (dem > 9999)
                dem = 0;

            nap_so(dem);
        }

        /*-------------------------------------------------------------
         *  BA NUT - giu nguyen cach lam cua cum 2.
         *
         *  ⚠ O day KHONG cho nha nut bang "while (nut == NHAN);" nhu cum 2
         *    duoc nua: cho trong vong lap do thi man hinh NGUNG QUET va
         *    tat den suot thoi gian giu nut. Thay bang co "da_xu_ly" -
         *    moi lan nhan chi an mot lan, ma vong quet khong bi chan.
         *
         *    Day chinh la ly do that su khien phai chuyen sang ngat Timer
         *    o cum 4: khi man hinh phai duoc quet lien tuc thi khong con
         *    duoc phep dung bat cu vong cho nao trong chuong trinh chinh.
         *-----------------------------------------------------------*/
        if (NUT_STARTSTOP == NHAN) {
            if (!ss_da_xu_ly) {
                ss_da_xu_ly = 1;
                if (dang_chay)
                    dang_chay = 0;
                else
                    dang_chay = 1;
            }
        } else {
            ss_da_xu_ly = 0;            /* da nha ra -> cho phep lan sau */
        }

        if (NUT_MODE == NHAN) {
            if (!mode_da_xu_ly) {
                mode_da_xu_ly = 1;
                if (den_do)
                    den_do = 0;
                else
                    den_do = 1;
            }
        } else {
            mode_da_xu_ly = 0;
        }

        if (NUT_RESET == NHAN) {
            dem       = 0;
            vong      = 0;
            dang_chay = 0;
            den_do    = 0;
            nap_so(dem);
        }

        /*--- Cap nhat 3 LED don theo trang thai ---*/
        if (dang_chay) {
            LED_XANH = SANG;
            LED_VANG = TAT;
        } else {
            LED_XANH = TAT;
            LED_VANG = SANG;
        }

        if (den_do)
            LED_DO = SANG;
        else
            LED_DO = TAT;
    }
}
