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
- **SDCC 4.5.0** — biên dịch C sang `.hex` cho 8051
- **Proteus** — mô phỏng mạch blink LED
- **VS Code** — chỉ soạn thảo, không biên dịch được 8051

Thạch anh 12 MHz, LED mắc active LOW từ +5V qua trở 330 Ω xuống chân P1.0.
