# Ôn tập KT2 + KT3 — viết chương trình 8086

Bài luyện cho hai bài kiểm tra viết chương trình làm tại lớp **thứ Tư 09/09/2026**
(KT2 full tài liệu · KT3 chỉ 1 tờ A4 in ra). Đây **không phải bài nộp**, chỉ là bài luyện.

## Đề

Đề thi thử tự dựng, Phần A 15′ + Phần B 50′. Phần B: nhập `N` (1–8, có bắt nhập lại) →
`N` chẵn thì `K = N × 137`, `N` lẻ thì `K = N!` → in `K` hệ 10 → dòng thứ hai in tổng chữ số →
hỏi `LAM LAI? (y/n)`.

Ràng buộc: file `.COM`, `org 100h`, chỉ dùng `INT 21h` với `AH = 1, 2, 9`, mọi giá trị 16 bit.

## Ba file

| File | Nội dung | Trạng thái |
|---|---|---|
| `phanB-cua-toi.asm` | Bài tự viết — bước 1 (nhập + kiểm hợp lệ) và bước 2 (rẽ nhánh chẵn/lẻ) | chưa có phần `output` |
| `phanB-mau.asm` | Bản mẫu đầy đủ cả 5 bước, để đối chiếu | dịch sạch, **chưa chạy thật trong emulator** |
| `phanB.asm` | Bản đang mở làm việc (hiện là bản sao của `phanB-mau.asm`) | |

## Ca kiểm thử

| N | Nhánh | K | Tổng chữ số |
|---|---|---|---|
| 1 | 1! | 1 | 1 |
| 2 | ×137 | 274 | 13 |
| 3 | 3! | 6 | 6 |
| 4 | ×137 | 548 | 17 |
| 5 | 5! | 120 | 3 |
| 6 | ×137 | 822 | 12 |
| 7 | 7! | 5040 | 9 |
| 8 | ×137 | 1096 | 16 |

`0`, `9`, chữ cái → không hợp lệ, phải báo lỗi rồi bắt nhập lại.

Hai ca phân loại là **5040** và **1096**: vòng lặp in nào dừng theo *số dư* thay vì theo *thương*
sẽ nuốt mất số `0`. Riêng **1096** là ca duy nhất bắt được lỗi in tổng hai chữ số (16).

## Lưu ý môi trường

⛔ **Không để mã nguồn trong `C:\emu8086\MyBuild\`.** Ngày 07/09/2026 emu8086 hết hạn, lần cài lại
đã xoá trắng thư mục đó và mất bài. Master để ở `Desktop\`, mở bằng `File → Open` từ đó.

🔧 Soát cú pháp không cần mở emulator: thêm `format binary` + `use16` vào đầu file, bỏ chữ `offset`,
rồi chạy `C:\emu8086\fasm\FASM.EXE`.
