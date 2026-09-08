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
| `phanB-cua-toi.asm` | Bài tự viết — bước 1 (nhập + kiểm hợp lệ) và bước 2 (rẽ nhánh chẵn/lẻ) | dở dang, dừng ở `output` |
| `phanB-mau.asm` | Bản mẫu đầy đủ cả 5 bước, để đối chiếu | dịch sạch |
| ⭐ `phanB.asm` | **BẢN MANG ĐI THI** — đầy đủ 5 bước | ✅ **đã chạy thật, đúng 3/3 lượt (08/09)** |

## ✅ Đã kiểm trên emulator — sáng 08/09/2026

Ba lượt, đúng hết. Biên dịch ra `phanB.com_` lúc 09:15, nguồn mở từ `Desktop\phanB.asm`.

| Lượt | Nhập | Màn hình mong đợi | Bắt lỗi gì |
|---|---|---|---|
| 1 | `8` → `n` | `1096` / `16` | tổng **hai chữ số** — ca duy nhất bắt được |
| 2 | `7` → `y` → `3` → `n` | `5040` / `9` rồi `6` / `6` | mất số `0`, **và** `SI` cộng dồn sai ở lượt hai |
| 3 | `0` `9` `a` → `4` → `n` | ba lần `SAI, NHAP LAI:` rồi `548` / `17` | ba đường kiểm hợp lệ + nhánh chẵn |

⚠️ Ở lượt 2, nếu dòng cuối in ra **`24`** thay vì `6` thì `xor si,si` đang nằm ngoài nhãn
`nhapso` — kéo vào ngay dưới nhãn đó. Lượt một vẫn đúng y hệt, chỉ lượt hai mới lộ.

Kiểm stack: trước `ret` cuối, `SP` phải về **`FFFE`**.

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
