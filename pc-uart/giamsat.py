"""
giamsat.py - App PC giam sat he thong dem san pham AT89C51 qua UART.

Chay bang:
    uv run --with pyserial giamsat.py

Khong can tham so - chon cong COM ngay tren giao dien.

Giao dien gom bon phan:
  - thanh ket noi : chon cong COM, baud, nut Ket noi
  - bang so       : COUNT / TIME / TARGET / STATE doc duoc tu xa
  - ba den bao    : RUN / PAUSE / ALARM, giong ba LED tren mach
  - bang lenh     : START STOP RESET STATUS va o dat muc tieu
  - nhat ky       : moi byte ra vao kem gio, xem duoc ca ASCII lan HEX

Day la "chuong trinh PC don gian de giam sat he thong" o muc 19 cua de tai.
"""

import queue
import re
import threading
import time
import tkinter as tk
from tkinter import ttk, filedialog, messagebox

try:
    import serial
    from serial.tools import list_ports
except ImportError:
    raise SystemExit("Thieu pyserial. Chay lai bang:  uv run --with pyserial giamsat.py")


# ---------------------------------------------------------------- mau sac
NEN        = "#11151a"      # nen chung
NEN_PANEL  = "#1a2028"      # nen khung
NEN_LED    = "#0a0d10"      # nen bang so - toi nhu mat LED 7 doan
DO_LED     = "#ff3b2f"      # do cua LED 7 doan
CHU        = "#e6ebf1"
CHU_MO     = "#8a97a5"
VIEN       = "#2a333d"
XANH_RUN   = "#3ddc84"
VANG_PAUSE = "#ffc53d"
DO_ALARM   = "#ff4d4f"
TAT        = "#2b323a"
MAU_TX     = "#7fb2ff"
MAU_RX     = "#3ddc84"
MAU_HT     = "#6b7785"


class App:
    def __init__(self, root):
        self.root = root
        root.title("Giam sat he thong dem san pham - AT89C51")
        root.configure(bg=NEN)
        root.geometry("940x680")
        root.minsize(760, 560)

        self.port = None
        self.doc_thread = None
        self.dung = threading.Event()
        self.hang_doi = queue.Queue()
        self.dem_rx = 0
        self.dem_tx = 0

        self._dung_style()
        self._dung_thanh_ket_noi()
        self._dung_bang_so()
        self._dung_bang_lenh()
        self._dung_nhat_ky()

        self.root.protocol("WM_DELETE_WINDOW", self.dong_app)
        self.root.after(60, self.xu_ly_hang_doi)
        self.nap_danh_sach_cong()

    # ------------------------------------------------------------ style
    def _dung_style(self):
        st = ttk.Style()
        try:
            st.theme_use("clam")
        except tk.TclError:
            pass
        st.configure("TCombobox", fieldbackground=NEN_PANEL, background=NEN_PANEL)

    # ------------------------------------------------- thanh ket noi
    def _dung_thanh_ket_noi(self):
        khung = tk.Frame(self.root, bg=NEN_PANEL, bd=0)
        khung.pack(fill="x", padx=12, pady=(12, 6))

        tk.Label(khung, text="CONG", bg=NEN_PANEL, fg=CHU_MO,
                 font=("Consolas", 9, "bold")).pack(side="left", padx=(12, 6), pady=10)

        self.cb_cong = ttk.Combobox(khung, width=10, state="readonly")
        self.cb_cong.pack(side="left", pady=10)

        tk.Label(khung, text="BAUD", bg=NEN_PANEL, fg=CHU_MO,
                 font=("Consolas", 9, "bold")).pack(side="left", padx=(16, 6))

        self.cb_baud = ttk.Combobox(khung, width=8, state="readonly",
                                    values=["1200", "2400", "4800", "9600", "19200"])
        self.cb_baud.set("9600")
        self.cb_baud.pack(side="left")

        self.nut_lam_moi = tk.Button(khung, text="Lam moi", command=self.nap_danh_sach_cong,
                                     bg=NEN, fg=CHU, activebackground=VIEN,
                                     relief="flat", padx=12, pady=4,
                                     font=("Segoe UI", 9))
        self.nut_lam_moi.pack(side="left", padx=10)

        self.nut_ket_noi = tk.Button(khung, text="Ket noi", command=self.bat_tat_ket_noi,
                                     bg=XANH_RUN, fg="#0a0d10", activebackground="#2fb86c",
                                     relief="flat", padx=20, pady=4,
                                     font=("Segoe UI", 9, "bold"))
        self.nut_ket_noi.pack(side="left")

        self.den_ket_noi = tk.Canvas(khung, width=12, height=12, bg=NEN_PANEL,
                                     highlightthickness=0)
        self.den_ket_noi.pack(side="left", padx=(14, 6))
        self.den_ket_noi.create_oval(1, 1, 11, 11, fill=TAT, outline="", tags="den")

        self.lbl_trangthai = tk.Label(khung, text="Chua ket noi", bg=NEN_PANEL, fg=CHU_MO,
                                      font=("Segoe UI", 9))
        self.lbl_trangthai.pack(side="left")

        self.lbl_dem = tk.Label(khung, text="TX 0  ·  RX 0", bg=NEN_PANEL, fg=CHU_MO,
                                font=("Consolas", 9))
        self.lbl_dem.pack(side="right", padx=14)

    # ---------------------------------------------------- bang so
    def _dung_bang_so(self):
        ngoai = tk.Frame(self.root, bg=NEN)
        ngoai.pack(fill="x", padx=12, pady=6)

        # --- bon o so, nen toi giong mat LED 7 doan ---
        bang = tk.Frame(ngoai, bg=VIEN)
        bang.pack(side="left", fill="both", expand=True)

        self.o_gia_tri = {}
        cot = 0
        for ten, nhan, mau in (
            ("count",  "SAN PHAM",  DO_LED),
            ("time",   "THOI GIAN", DO_LED),
            ("target", "MUC TIEU",  DO_LED),
        ):
            o = tk.Frame(bang, bg=NEN_LED)
            o.grid(row=0, column=cot, sticky="nsew", padx=(0 if cot == 0 else 1), pady=0)
            bang.grid_columnconfigure(cot, weight=1)

            tk.Label(o, text=nhan, bg=NEN_LED, fg=CHU_MO,
                     font=("Consolas", 9, "bold")).pack(anchor="w", padx=14, pady=(12, 0))
            lbl = tk.Label(o, text="----", bg=NEN_LED, fg=mau,
                           font=("Consolas", 34, "bold"))
            lbl.pack(anchor="w", padx=14, pady=(0, 12))
            self.o_gia_tri[ten] = lbl
            cot += 1

        # --- ba den bao trang thai ---
        den = tk.Frame(ngoai, bg=NEN_PANEL)
        den.pack(side="left", fill="y", padx=(10, 0))

        tk.Label(den, text="TRANG THAI", bg=NEN_PANEL, fg=CHU_MO,
                 font=("Consolas", 9, "bold")).pack(anchor="w", padx=14, pady=(12, 8))

        self.den_ve = {}
        for ten, nhan, mau in (("RUN", "RUN", XANH_RUN),
                               ("PAUSE", "PAUSE", VANG_PAUSE),
                               ("ALARM", "ALARM", DO_ALARM)):
            hang = tk.Frame(den, bg=NEN_PANEL)
            hang.pack(anchor="w", padx=14, pady=3)
            c = tk.Canvas(hang, width=16, height=16, bg=NEN_PANEL, highlightthickness=0)
            c.pack(side="left")
            c.create_oval(2, 2, 14, 14, fill=TAT, outline=VIEN, tags="den")
            tk.Label(hang, text=nhan, bg=NEN_PANEL, fg=CHU,
                     font=("Consolas", 10)).pack(side="left", padx=8)
            self.den_ve[ten] = (c, mau)

        tk.Frame(den, bg=NEN_PANEL, height=12).pack()

    # --------------------------------------------------- bang lenh
    def _dung_bang_lenh(self):
        khung = tk.Frame(self.root, bg=NEN_PANEL)
        khung.pack(fill="x", padx=12, pady=6)

        tk.Label(khung, text="LENH", bg=NEN_PANEL, fg=CHU_MO,
                 font=("Consolas", 9, "bold")).pack(side="left", padx=(12, 10), pady=12)

        self.nut_lenh = []
        for nhan, lenh, mau in (("START", "START", XANH_RUN),
                                ("STOP", "STOP", VANG_PAUSE),
                                ("RESET", "RESET", "#5b6875"),
                                ("STATUS", "STATUS", "#4a90d9")):
            b = tk.Button(khung, text=nhan, width=8,
                          command=lambda l=lenh: self.gui_lenh(l),
                          bg=mau, fg="#0a0d10", activebackground=mau,
                          relief="flat", padx=6, pady=5,
                          font=("Segoe UI", 9, "bold"), state="disabled")
            b.pack(side="left", padx=3)
            self.nut_lenh.append(b)

        tk.Frame(khung, bg=VIEN, width=1, height=28).pack(side="left", padx=14)

        tk.Label(khung, text="MUC TIEU", bg=NEN_PANEL, fg=CHU_MO,
                 font=("Consolas", 9, "bold")).pack(side="left", padx=(0, 8))

        self.o_target = tk.Entry(khung, width=7, bg=NEN, fg=CHU, insertbackground=CHU,
                                 relief="flat", font=("Consolas", 11), justify="center")
        self.o_target.insert(0, "20")
        self.o_target.pack(side="left", ipady=4)
        self.o_target.bind("<Return>", lambda e: self.dat_muc_tieu())

        b = tk.Button(khung, text="Dat", command=self.dat_muc_tieu,
                      bg="#4a90d9", fg="#0a0d10", relief="flat", padx=14, pady=5,
                      font=("Segoe UI", 9, "bold"), state="disabled")
        b.pack(side="left", padx=8)
        self.nut_lenh.append(b)

        # o go lenh tu do
        tk.Frame(khung, bg=VIEN, width=1, height=28).pack(side="left", padx=14)
        self.o_tudo = tk.Entry(khung, bg=NEN, fg=CHU, insertbackground=CHU,
                               relief="flat", font=("Consolas", 10))
        self.o_tudo.pack(side="left", fill="x", expand=True, ipady=4, padx=(0, 12))
        self.o_tudo.bind("<Return>", lambda e: self.gui_tudo())

    # ---------------------------------------------------- nhat ky
    def _dung_nhat_ky(self):
        khung = tk.Frame(self.root, bg=NEN_PANEL)
        khung.pack(fill="both", expand=True, padx=12, pady=(6, 12))

        dau = tk.Frame(khung, bg=NEN_PANEL)
        dau.pack(fill="x")

        tk.Label(dau, text="NHAT KY", bg=NEN_PANEL, fg=CHU_MO,
                 font=("Consolas", 9, "bold")).pack(side="left", padx=12, pady=(10, 6))

        self.hien_hex = tk.BooleanVar(value=True)
        tk.Checkbutton(dau, text="Hien HEX", variable=self.hien_hex,
                       bg=NEN_PANEL, fg=CHU_MO, selectcolor=NEN,
                       activebackground=NEN_PANEL, activeforeground=CHU,
                       font=("Segoe UI", 9), relief="flat",
                       highlightthickness=0).pack(side="left", padx=10)

        tk.Button(dau, text="Luu ra file", command=self.luu_nhat_ky,
                  bg=NEN, fg=CHU, relief="flat", padx=12, pady=3,
                  font=("Segoe UI", 9)).pack(side="right", padx=(6, 12))
        tk.Button(dau, text="Xoa", command=self.xoa_nhat_ky,
                  bg=NEN, fg=CHU, relief="flat", padx=12, pady=3,
                  font=("Segoe UI", 9)).pack(side="right")

        vung = tk.Frame(khung, bg=NEN_PANEL)
        vung.pack(fill="both", expand=True, padx=12, pady=(0, 12))

        thanh = tk.Scrollbar(vung)
        thanh.pack(side="right", fill="y")

        self.txt = tk.Text(vung, bg=NEN_LED, fg=CHU, insertbackground=CHU,
                           relief="flat", font=("Consolas", 10),
                           yscrollcommand=thanh.set, wrap="none", height=10)
        self.txt.pack(side="left", fill="both", expand=True)
        thanh.config(command=self.txt.yview)

        self.txt.tag_config("tx", foreground=MAU_TX)
        self.txt.tag_config("rx", foreground=MAU_RX)
        self.txt.tag_config("ht", foreground=MAU_HT)
        self.txt.tag_config("hex", foreground=MAU_HT)

        self.ghi("Chon cong COM roi bam Ket noi.", "ht")
        self.ghi("Cong cua COMPIM trong Proteus va cong o day phai la HAI DAU "
                 "cua cung mot cap - mot cong chi mot chuong trinh mo duoc.", "ht")

    # ------------------------------------------------------- tien ich
    def gio(self):
        return time.strftime("%H:%M:%S") + f".{int(time.time() * 1000) % 1000:03d}"

    def ghi(self, dong, tag="ht"):
        self.txt.insert("end", f"[{self.gio()}] {dong}\n", tag)
        self.txt.see("end")

    def ghi_hex(self, data):
        if not self.hien_hex.get():
            return
        h = " ".join(f"{b:02X}" for b in data)
        self.txt.insert("end", f"{'':>14}hex: {h}\n", "hex")
        self.txt.see("end")

    def xoa_nhat_ky(self):
        self.txt.delete("1.0", "end")

    def luu_nhat_ky(self):
        ten = filedialog.asksaveasfilename(
            defaultextension=".txt",
            initialfile=time.strftime("uart_%Y%m%d_%H%M%S.txt"),
            filetypes=[("Text", "*.txt")])
        if not ten:
            return
        with open(ten, "w", encoding="utf-8") as f:
            f.write(self.txt.get("1.0", "end"))
        self.ghi(f"Da luu nhat ky: {ten}", "ht")

    # --------------------------------------------------- ket noi
    def nap_danh_sach_cong(self):
        ds = [p.device for p in list_ports.comports()]
        self.cb_cong["values"] = ds
        if ds and not self.cb_cong.get():
            self.cb_cong.set(ds[0])
        if not ds:
            self.ghi("Khong thay cong COM nao. Tao cap cong ao roi bam Lam moi.", "ht")

    def bat_tat_ket_noi(self):
        if self.port:
            self.ngat_ket_noi()
        else:
            self.ket_noi()

    def ket_noi(self):
        ten = self.cb_cong.get()
        if not ten:
            messagebox.showwarning("Chua chon cong", "Chon mot cong COM truoc da.")
            return
        try:
            self.port = serial.Serial(ten, int(self.cb_baud.get()), timeout=0.1)
        except serial.SerialException as e:
            self.ghi(f"KHONG MO DUOC {ten}: {e}", "ht")
            self.ghi("  'Access denied' = cong dang bi chuong trinh khac giu. "
                     "COMPIM phai gan dau KIA cua cap.", "ht")
            self.port = None
            return

        self.dung.clear()
        self.doc_thread = threading.Thread(target=self.vong_doc, daemon=True)
        self.doc_thread.start()

        self.nut_ket_noi.config(text="Ngat", bg=DO_ALARM)
        self.den_ket_noi.itemconfig("den", fill=XANH_RUN)
        self.lbl_trangthai.config(text=f"{ten} @ {self.cb_baud.get()} baud, 8-N-1", fg=CHU)
        for b in self.nut_lenh:
            b.config(state="normal")
        self.ghi(f"Da mo {ten} @ {self.cb_baud.get()} baud.", "ht")

    def ngat_ket_noi(self):
        self.dung.set()
        if self.doc_thread:
            self.doc_thread.join(timeout=0.5)
        if self.port:
            try:
                self.port.close()
            except Exception:
                pass
        self.port = None
        self.nut_ket_noi.config(text="Ket noi", bg=XANH_RUN)
        self.den_ket_noi.itemconfig("den", fill=TAT)
        self.lbl_trangthai.config(text="Chua ket noi", fg=CHU_MO)
        for b in self.nut_lenh:
            b.config(state="disabled")
        self.ghi("Da dong cong.", "ht")

    # ------------------------------------------------------ doc/gui
    def vong_doc(self):
        """Chay o thread rieng - chi day du lieu vao hang doi, khong dung
        toi giao dien (tkinter khong an toan khi goi tu thread khac)."""
        dem = bytearray()
        lan_cuoi = time.time()
        while not self.dung.is_set():
            try:
                data = self.port.read(self.port.in_waiting or 1)
            except Exception as e:
                self.hang_doi.put(("loi", str(e)))
                return
            bay_gio = time.time()
            if data:
                dem.extend(data)
                lan_cuoi = bay_gio
            while b"\n" in dem:
                dong, _, con = dem.partition(b"\n")
                dem = bytearray(con)
                self.hang_doi.put(("rx", bytes(dong.rstrip(b"\r"))))
            if dem and (bay_gio - lan_cuoi) > 0.08:
                self.hang_doi.put(("rx", bytes(dem)))
                dem = bytearray()
            if not data:
                time.sleep(0.01)

    def gui_lenh(self, lenh):
        if not self.port:
            return
        data = (lenh + "\r\n").encode("ascii", errors="replace")
        try:
            self.port.write(data)
            self.port.flush()
        except Exception as e:
            self.ghi(f"Loi gui: {e}", "ht")
            return
        self.dem_tx += len(data)
        self.cap_nhat_dem()
        self.ghi(f"TX -> {lenh}", "tx")
        self.ghi_hex(data)

    def gui_tudo(self):
        t = self.o_tudo.get().strip()
        if t:
            self.gui_lenh(t.upper())
            self.o_tudo.delete(0, "end")

    def dat_muc_tieu(self):
        t = self.o_target.get().strip()
        if not t.isdigit():
            messagebox.showwarning("So khong hop le", "Muc tieu phai la mot so nguyen duong.")
            return
        self.gui_lenh(f"SET COUNT {int(t)}")

    # ------------------------------------------------- xu ly du lieu ve
    def xu_ly_hang_doi(self):
        try:
            while True:
                loai, noi_dung = self.hang_doi.get_nowait()
                if loai == "loi":
                    self.ghi(f"MAT CONG: {noi_dung}", "ht")
                    self.ngat_ket_noi()
                    continue
                self.dem_rx += len(noi_dung)
                text = noi_dung.decode("ascii", errors="replace")
                self.ghi(f"RX <- {text}", "rx")
                self.ghi_hex(noi_dung)
                self.doc_trang_thai(text)
                self.cap_nhat_dem()
        except queue.Empty:
            pass
        self.root.after(60, self.xu_ly_hang_doi)

    def cap_nhat_dem(self):
        self.lbl_dem.config(text=f"TX {self.dem_tx}  ·  RX {self.dem_rx}")

    def doc_trang_thai(self, text):
        """Boc so tu dong: COUNT=0012 TIME=00:35 TARGET=0020 STATE=RUN"""
        m = re.search(r"COUNT=(\d+)", text)
        if m:
            self.o_gia_tri["count"].config(text=str(int(m.group(1))).rjust(4))
        m = re.search(r"TIME=(\d+):(\d+)", text)
        if m:
            self.o_gia_tri["time"].config(text=f"{m.group(1)}:{m.group(2)}")
        m = re.search(r"TARGET=(\d+)", text)
        if m:
            self.o_gia_tri["target"].config(text=str(int(m.group(1))).rjust(4))
            if not self.o_target.get().strip():
                self.o_target.insert(0, str(int(m.group(1))))
        m = re.search(r"STATE=(\w+)", text)
        if m:
            self.dat_den(m.group(1).upper())
        if "ALARM" in text.upper():
            self.dat_den("ALARM")

    def dat_den(self, trang_thai):
        for ten, (canvas, mau) in self.den_ve.items():
            canvas.itemconfig("den", fill=mau if ten == trang_thai else TAT)

    # ---------------------------------------------------------- thoat
    def dong_app(self):
        self.dung.set()
        if self.port:
            try:
                self.port.close()
            except Exception:
                pass
        self.root.destroy()


if __name__ == "__main__":
    root = tk.Tk()
    App(root)
    root.mainloop()
