/*=====================================================================
 *  CUM 5  -  HE THONG DEM SAN PHAM + UART        8051 / SDCC
 *---------------------------------------------------------------------
 *  PHAN CUNG THEM: chi mot linh kien - COMPIM (noi ra cong COM that)
 *      P3.1 (TXD, chan 11) -> chan 3 "TXD" cua COMPIM
 *      P3.0 (RXD, chan 10) -> chan 2 "RXD" cua COMPIM
 *      COMPIM dat: Physical Baud = Virtual Baud = 9600, 8 - NONE - 1
 *      Cac chan DCD DSR RTS CTS DTR RI cua COMPIM de trong het.
 *
 *  ⭐ COMPIM NOI THANG, KHONG NOI CHEO - khac han VIRTUAL TERMINAL.
 *    COMPIM mo phong luon ca soi cap chay toi may tinh nen no DA DAO
 *    SAN BEN TRONG: chan "TXD" cua no la cho NHAN tu mach, chan "RXD"
 *    la cho PHAT ra mach.
 *    Noi cheo thi Proteus bao "Logic contention detected on net ..." -
 *    vi luc do hai DAU RA (P3.1 va chan RXD cua COMPIM) danh nhau.
 *    (VIRTUAL TERMINAL thi nguoc lai: phai noi CHEO.)
 *
 *  ⚠ Clock Frequency cua U1 PHAI la 11.0592MHz.
 *    12 MHz khong chia ra duoc 9600 baud - sai so ~7% -> nhan ra rac.
 *    Day la ly do duy nhat con so 11,0592 ky quac nay ton tai.
 *
 *  BA NGUON NGAT chay song song:
 *      Timer 0 (000BH) moi 1 ms : quet man hinh + dem thoi gian
 *      INT1    (0013H)          : cam bien san pham
 *      Serial  (0023H)          : nhan lenh tu PC, khong bo sot ky tu
 *      Timer 1                  : KHONG ngat - no chi lam bo tao baud
 *
 *  LENH TU PC (go trong app giam sat hoac terminal, Enter de gui):
 *      START           chay
 *      STOP            tam dung
 *      RESET           xoa dem va thoi gian
 *      STATUS          doc trang thai hien tai
 *      SET COUNT 50    doi muc tieu thanh 50
 *
 *  BUILD:
 *    sdcc demsp_uart.c; packihx demsp_uart.ihx | Out-File -Encoding ascii demsp_uart.hex
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

#define NUT_STARTSTOP  P3_2
#define NUT_RESET      P2_7
#define NUT_MODE       P3_6

#define SANG   0
#define TAT    1
#define NHAN   0

#define CHON   0
#define BO     1

#define DAU_CHAM  0x80
#define MA_CHU_P  0x73

#define CHEDO_COUNT   0
#define CHEDO_TIME    1
#define CHEDO_TARGET  2

__code unsigned char MA7DOAN[10] = {
    0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F
};

volatile unsigned char hienthi[4] = { 0x3F, 0x3F, 0x3F, 0x3F };

volatile unsigned int  tick      = 0;
volatile unsigned char giay      = 0;
volatile unsigned char phut      = 0;
volatile unsigned char dang_chay = 0;

volatile unsigned int  product_count = 0;
unsigned int           target_count  = 20;
volatile unsigned char khoa_cambien  = 0;

/*---------------------------------------------------------------------
 *  TRANG THAI THU BA: ALARM (muc 12 cua de)
 *
 *      RUN --( product_count >= target_count )--> ALARM
 *
 *  ALARM khong phai chi la cai den do. No la mot TRANG THAI: day chuyen
 *  DUNG lai, khong dem them, khong tinh gio nua - dung nhu day chuyen
 *  that khi da du so luong dat hang.
 *  Thoat khoi ALARM bang RESET, hoac bang cach dat muc tieu MOI cao hon.
 *-------------------------------------------------------------------*/
volatile unsigned char alarm = 0;

/* Bo dem nhan lenh tu PC - ISR ghi vao, main doc ra => volatile */
#define BUF_MAX 20
volatile char          buf[BUF_MAX];
volatile unsigned char buf_len = 0;
volatile unsigned char co_lenh = 0;     /* ISR dat = 1 khi da nhan du mot dong */

/*=====================================================================
 *  NGAT TIMER 0 - 1 ms
 *=====================================================================*/
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

    if (dang_chay) {
        tick++;
        if (tick >= 1000) {
            tick = 0;
            giay++;
            if (giay >= 60) {
                giay = 0;
                phut++;
                if (phut >= 100)
                    phut = 0;
            }
        }
    }

    if (khoa_cambien)
        khoa_cambien--;
}

/*=====================================================================
 *  NGAT NGOAI 1 - cam bien san pham
 *=====================================================================*/
void int1_isr(void) __interrupt(2)
{
    if (khoa_cambien)
        return;

    khoa_cambien = 20;

    if (dang_chay)
        product_count++;
}

/*=====================================================================
 *  NGAT CONG NOI TIEP - vector 0023H, __interrupt(4)
 *---------------------------------------------------------------------
 *  ⭐ VI SAO PHAI DUNG NGAT DE NHAN - ly do that, da do duoc:
 *
 *    O 9600 baud, moi ky tu den cach nhau 1,04 ms. Neu hoi vong co RI
 *    trong main thi main phai quay xong mot vong trong 1,04 ms - ma
 *    cap_nhat_hienthi() co 4 phep chia + 3 phep chia du tren so 16 bit,
 *    8051 khong co lenh chia 16 bit nen SDCC goi ham thu vien, moi phep
 *    ton vai tram chu ky. Cong them ngat Timer chen vao moi 1 ms, mot
 *    vong main de vuot qua 2 ms.
 *    => cu hai ky tu thi mat mot. "START" vao toi noi thanh "SAT",
 *       khong khop tu khoa nao, MCU tra "ERR" cho MOI lenh.
 *
 *    Ngat thi khac: ky tu vua toi la CPU bo viec dang lam, nhay vao day
 *    nhat no bo bo dem roi quay ve. Khong the bo sot.
 *
 *  ⚠ ISR nay chi NHAT ky tu, KHONG xu ly lenh - vi xu ly lenh co gui
 *    UART tra loi, rat lau. ISR phai ngan. No chi dat co "co_lenh"
 *    roi main lo phan con lai.
 *
 *  ⚠ Co RI KHONG tu xoa - phai CLR bang tay ngay dau ISR.
 *=====================================================================*/
void uart_isr(void) __interrupt(4)
{
    char c;

    if (RI) {
        RI = 0;                 /* xoa bang tay, neu khong ISR goi lai vo tan */
        c = SBUF;

        if (c == '\r' || c == '\n') {
            if (buf_len > 0)
                co_lenh = 1;    /* da du mot dong -> bao main xu ly */
        } else if (buf_len < BUF_MAX - 1) {
            if (c >= 'a' && c <= 'z')
                c = c - 32;     /* go chu thuong cung nhan */
            buf[buf_len++] = c;
        }
    }
}

/*=====================================================================
 *  UART - gui
 *---------------------------------------------------------------------
 *  ⚠ Co TI KHONG tu xoa. Phai CLR bang tay sau moi byte, neu khong
 *    lan gui sau "while (!TI)" roi thang qua va ky tu chong len nhau.
 *    Khac han co TF0 cua Timer va co IE1 cua ngat ngoai - hai co do
 *    phan cung tu xoa.
 *=====================================================================*/
void uart_gui(char c)
{
    /*-----------------------------------------------------------------
     *  ⚠ ES = 0 truoc khi gui: co TI cung goi ngat Serial (chung mot
     *    vector 0023H voi RI). Neu de ES = 1 thi vua ghi SBUF xong la
     *    ISR nhay vao, cuop mat co TI, va vong "while (!TI)" duoi day
     *    doi mai mai -> chuong trinh treo.
     *    Tat ngat Serial trong luc gui, bat lai ngay sau khi xoa TI.
     *---------------------------------------------------------------*/
    ES = 0;
    SBUF = c;                   /* ghi vao SBUF la bat dau gui */
    while (!TI)                 /* cho gui xong */
        ;
    TI = 0;                     /* xoa bang tay */
    ES = 1;
}

void uart_chuoi(char *s)
{
    while (*s)
        uart_gui(*s++);
}

void uart_so(unsigned int n)
{
    uart_gui('0' + (char)(n / 1000));
    uart_gui('0' + (char)((n / 100) % 10));
    uart_gui('0' + (char)((n / 10) % 10));
    uart_gui('0' + (char)(n % 10));
}

void uart_hai_so(unsigned char n)
{
    uart_gui('0' + (char)(n / 10));
    uart_gui('0' + (char)(n % 10));
}

void gui_trang_thai(void)
{
    unsigned int n;

    EA = 0;
    n = product_count;
    EA = 1;

    uart_chuoi("COUNT=");
    uart_so(n);

    uart_chuoi(" TIME=");
    uart_hai_so(phut);
    uart_gui(':');
    uart_hai_so(giay);

    uart_chuoi(" TARGET=");
    uart_so(target_count);

    uart_chuoi(" STATE=");
    if (alarm)
        uart_chuoi("ALARM");
    else if (dang_chay)
        uart_chuoi("RUN");
    else
        uart_chuoi("PAUSE");

    uart_chuoi("\r\n");
}

/*=====================================================================
 *  So sanh buf voi mot tu khoa. Tra ve 1 neu khop.
 *=====================================================================*/
unsigned char khop(char *tu)
{
    unsigned char i = 0;

    while (tu[i]) {
        if (buf[i] != tu[i])
            return 0;
        i++;
    }
    return 1;
}

void xu_ly_lenh(void)
{
    unsigned char i;
    unsigned int  n;

    buf[buf_len] = 0;           /* ket thuc chuoi */

    if (khop("START")) {
        if (alarm) {
            uart_chuoi("ERR ALARM - RESET HOAC SET COUNT LON HON\r\n");
        } else {
            dang_chay = 1;
            uart_chuoi("OK RUN\r\n");
        }

    } else if (khop("STOP")) {
        dang_chay = 0;
        uart_chuoi("OK PAUSE\r\n");

    } else if (khop("RESET")) {
        EA = 0;
        product_count = 0;
        EA = 1;
        giay = 0;
        phut = 0;
        tick = 0;
        alarm = 0;
        uart_chuoi("OK RESET\r\n");

    } else if (khop("STATUS")) {
        gui_trang_thai();

    } else if (khop("SET")) {
        /* Tim chu so dau tien trong chuoi roi doc so tu do */
        n = 0;
        i = 0;
        while (i < buf_len && (buf[i] < '0' || buf[i] > '9'))
            i++;

        if (i >= buf_len) {
            uart_chuoi("ERR NO NUMBER\r\n");
        } else {
            while (i < buf_len && buf[i] >= '0' && buf[i] <= '9') {
                n = n * 10 + (unsigned int)(buf[i] - '0');
                i++;
            }
            target_count = n;

            /* Dat muc tieu moi cao hon so da dem -> thoat khoi ALARM */
            EA = 0;
            if (alarm && product_count < target_count)
                alarm = 0;
            EA = 1;

            uart_chuoi("OK TARGET=");
            uart_so(target_count);
            uart_chuoi("\r\n");
        }

    } else {
        uart_chuoi("ERR\r\n");
    }

    buf_len = 0;
}

void delay20ms(void)
{
    volatile unsigned char i, j;

    for (j = 0; j < 8; j++)
        for (i = 0; i < 250; i++)
            ;
}

void cap_nhat_hienthi(unsigned char che_do)
{
    unsigned int n;

    switch (che_do) {
        case CHEDO_COUNT:
            EA = 0;
            n = product_count;
            EA = 1;
            hienthi[0] = MA7DOAN[n / 1000];
            hienthi[1] = MA7DOAN[(n / 100) % 10];
            hienthi[2] = MA7DOAN[(n / 10) % 10];
            hienthi[3] = MA7DOAN[n % 10];
            break;

        case CHEDO_TIME:
            hienthi[0] = MA7DOAN[phut / 10];
            hienthi[1] = MA7DOAN[phut % 10] | DAU_CHAM;
            hienthi[2] = MA7DOAN[giay / 10];
            hienthi[3] = MA7DOAN[giay % 10];
            break;

        case CHEDO_TARGET:
            n = target_count;
            hienthi[0] = MA_CHU_P;
            hienthi[1] = MA7DOAN[(n / 100) % 10];
            hienthi[2] = MA7DOAN[(n / 10) % 10];
            hienthi[3] = MA7DOAN[n % 10];
            break;
    }
}

void main(void)
{
    unsigned char che_do   = CHEDO_COUNT;
    unsigned char giay_cu  = 0;
    unsigned int  dem_tam;

    P2 = 0xFF;
    P3 = 0xFF;
    DOAN = 0x00;

    /*-----------------------------------------------------------------
     *  TMOD = 0x21
     *      nua CAO  = 0010 -> Timer 1 che do 2 (8 bit TU NAP LAI)
     *                         bat buoc cho bo tao baud
     *      nua THAP = 0001 -> Timer 0 che do 1 (16 bit) cho ngat 1 ms
     *
     *  Truoc day la 0x01 vi chua dung Timer 1.
     *---------------------------------------------------------------*/
    TMOD = 0x21;

    TH0 = 0xFC;                 /* Timer 0: ngat moi 1 ms */
    TL0 = 0x66;

    TH1 = 0xFD;                 /* Timer 1: 9600 baud @ 11,0592 MHz */
    TL1 = 0xFD;
    SCON = 0x50;                /* che do 1 (8 bit), REN = 1 (cho phep nhan) */
    TR1 = 1;                    /* ⚠ phai cho Timer 1 CHAY thi moi co xung baud */

    IT1 = 1;                    /* INT1 kich canh xuong */
    ET0 = 1;                    /* ngat Timer 0 */
    EX1 = 1;                    /* ngat ngoai 1 */
    ES  = 1;                    /* ⭐ ngat cong noi tiep - de khong bo sot ky tu */
    EA  = 1;                    /* cong tac tong */
    TR0 = 1;

    uart_chuoi("\r\nHE THONG DEM SAN PHAM - AT89C51\r\n");
    uart_chuoi("Lenh: START STOP RESET STATUS | SET COUNT n\r\n");
    gui_trang_thai();

    while (1) {

        cap_nhat_hienthi(che_do);

        /*--- ISR da nhat du mot dong lenh -> gio main moi xu ly ---*/
        if (co_lenh) {
            co_lenh = 0;
            xu_ly_lenh();
        }

        /*--- Moi giay tu dong bao trang thai len PC ---*/
        if (dang_chay && giay != giay_cu) {
            giay_cu = giay;
            gui_trang_thai();
        }

        /*--- Ba nut ---*/
        if (NUT_STARTSTOP == NHAN) {
            delay20ms();
            if (NUT_STARTSTOP == NHAN) {
                if (!alarm)             /* dang ALARM thi phai RESET truoc */
                    dang_chay = dang_chay ? 0 : 1;
                while (NUT_STARTSTOP == NHAN)
                    ;
            }
        }

        if (NUT_MODE == NHAN) {
            delay20ms();
            if (NUT_MODE == NHAN) {
                che_do++;
                if (che_do > CHEDO_TARGET)
                    che_do = CHEDO_COUNT;
                while (NUT_MODE == NHAN)
                    ;
            }
        }

        if (NUT_RESET == NHAN) {
            delay20ms();
            if (NUT_RESET == NHAN) {
                EA = 0;
                product_count = 0;
                EA = 1;
                giay  = 0;
                phut  = 0;
                tick  = 0;
                alarm = 0;
                while (NUT_RESET == NHAN)
                    ;
            }
        }

        /*-------------------------------------------------------------
         *  CHUYEN TRANG THAI  RUN -> ALARM
         *
         *  Dat o day (chuong trinh chinh) chu khong dat trong ISR, vi
         *  hai le: ISR phai that ngan, va target_count co the dang duoc
         *  lenh SET COUNT sua giua chung.
         *-----------------------------------------------------------*/
        EA = 0;
        dem_tam = product_count;
        EA = 1;

        if (dang_chay && dem_tam >= target_count) {
            dang_chay = 0;              /* DUNG day chuyen */
            alarm     = 1;
            uart_chuoi("ALARM! DA DAT MUC TIEU\r\n");
            gui_trang_thai();
        }

        /*--- 3 LED bao trang thai ---*/
        if (alarm) {
            LED_XANH = TAT;
            LED_VANG = TAT;
            LED_DO   = SANG;
        } else if (dang_chay) {
            LED_XANH = SANG;
            LED_VANG = TAT;
            LED_DO   = TAT;
        } else {
            LED_XANH = TAT;
            LED_VANG = SANG;
            LED_DO   = TAT;
        }
    }
}
