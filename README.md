# TT KTMT — Thực tập Kiến trúc máy tính

Bài nộp hàng tuần. Mỗi tuần một thư mục `TuanNN`.

| Tuần | Nội dung | Trạng thái |
|---|---|---|
| [Tuan01](Tuan01) | Cài môi trường · 8086 cộng 2 số · 8051 blink LED · Report 15 video | Đã gom đủ |

## Tuan01 — bốn mục nộp

| # | Yêu cầu | File |
|---|---|---|
| 1 | Hướng dẫn cài đặt emu8086 · Proteus 8 · VS Code | `Software Installation Guide - emu8086, Proteus 8, VS Code.pdf` |
| 2 | 8086: nhập 2 số, tính tổng, xuất ra cửa sổ đen | `8086_testcong/` — source ASM + file hướng dẫn |
| 3 | 8051: nhấp nháy 1 LED, chu kì 1 s | `8051_blink/` — code ASM và C, file hex, file Proteus |
| 4 | Trả lời câu hỏi của 15 video đầu | `Trả lời câu hỏi cuối bài.pdf` |

## Môi trường

- **emu8086 4.08rt** — `C:\emu8086`, build ra `C:\emu8086\MyBuild`
- **SDCC 4.5.0** — biên dịch C sang `.hex` cho 8051. Bản rút gọn cho 8051 đi kèm repo ở `tools/sdcc`
  (GPL, giấy phép trong thư mục đó), clone về là dịch được, không cần cài
- **Proteus** — mô phỏng mạch blink LED
- **VS Code** — soạn thảo; mở cả thư mục repo thì **Ctrl+Shift+B** dịch file đang mở ra `.hex`

## Dịch ra `.hex` trên máy bất kỳ

Kéo-thả file `.c` hoặc `.asm` lên **`hex.cmd`** → `.hex` nằm ngay cạnh file gốc.
Code viết cho Keil (`reg52.h`, `sbit X = P1^0`, `interrupt 1`…) được `keil2sdcc.ps1` tự đổi sang SDCC, file gốc giữ nguyên.

**Mạch Proteus phải nằm cùng thư mục với file `.hex` nó nạp.** Proteus lưu đường dẫn tới hex
*tương đối* so với file `.pdsprj`; để mạch ở chỗ khác (Documents, Desktop…) thì sang máy khác mạch không tìm thấy hex.

Thạch anh 12 MHz, LED mắc active LOW từ +5V qua trở 330 Ω xuống chân P1.0.
