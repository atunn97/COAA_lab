"""
monitor.py - App PC giam sat dong du lieu UART ra/vao he thong dem san pham 8051.

Chay bang:
    uv run --with pyserial monitor.py COM4
    uv run --with pyserial monitor.py COM4 9600

Man hinh in MOI byte ra/vao kem dau thoi gian, dang ASCII + HEX.
Go lenh roi Enter la gui xuong MCU. Go /q de thoat.

Vi sao in ca HEX chu khong chi ASCII: khi sai baud hoac lech khung, ASCII ra
ky tu vo nghia con HEX cho thay CO byte ve, chi sai gia tri. Phan biet duoc
"khong co byte nao" voi "byte ve nhung sai" la tiet kiem duoc hang gio do loi.
"""

import sys
import threading
import time

try:
    import serial
except ImportError:
    print("Thieu pyserial. Chay lai bang:  uv run --with pyserial monitor.py COM4")
    sys.exit(1)

LOG_PATH = "uart_log.txt"

# Cac lenh cua de tai, go so cho nhanh
SHORTCUTS = {
    "1": "START",
    "2": "STOP",
    "3": "RESET",
    "4": "STATUS",
    "5": "SET COUNT 100",
}

stop_flag = threading.Event()
log_file = None
log_lock = threading.Lock()


def stamp():
    return time.strftime("%H:%M:%S") + f".{int(time.time() * 1000) % 1000:03d}"


def emit(line):
    print(line, flush=True)
    with log_lock:
        if log_file:
            log_file.write(line + "\n")
            log_file.flush()


def render(data):
    """Tra ve (phan ascii de doc, phan hex)."""
    ascii_part = "".join(chr(b) if 32 <= b < 127 else "." for b in data)
    hex_part = " ".join(f"{b:02X}" for b in data)
    return ascii_part, hex_part


def reader(port):
    """Doc lien tuc tu cong, gom theo dong cho de doc."""
    buf = bytearray()
    last_rx = time.time()
    while not stop_flag.is_set():
        try:
            chunk = port.read(port.in_waiting or 1)
        except serial.SerialException as e:
            emit(f"[{stamp()}] !! MAT CONG: {e}")
            stop_flag.set()
            return
        now = time.time()
        if chunk:
            buf.extend(chunk)
            last_rx = now
        # Xuat khi gap xuong dong, hoac khi im lang 50 ms (goi du lieu da het)
        while b"\n" in buf:
            line, _, rest = buf.partition(b"\n")
            buf = bytearray(rest)
            a, h = render(line.rstrip(b"\r"))
            emit(f"[{stamp()}] RX <- {a}")
            emit(f"{'':>11}   hex: {h}")
        if buf and (now - last_rx) > 0.05:
            a, h = render(buf)
            emit(f"[{stamp()}] RX <- {a}   (chua co xuong dong)")
            emit(f"{'':>11}   hex: {h}")
            buf = bytearray()
        if not chunk:
            time.sleep(0.01)


def main():
    global log_file

    if len(sys.argv) < 2:
        print(__doc__)
        return 2

    port_name = sys.argv[1]
    baud = int(sys.argv[2]) if len(sys.argv) > 2 else 9600

    try:
        port = serial.Serial(port_name, baud, timeout=0.1)
    except serial.SerialException as e:
        print(f"KHONG MO DUOC {port_name}: {e}")
        print()
        print("  'Access denied'      = cong dang bi giu. Proteus phai gan COMPIM vao")
        print("                         dau KIA cua cap, khong phai cong nay.")
        print("  'could not open port'= cong khong ton tai. Chay:")
        print("                         uv run --with pyserial comcheck.py list")
        return 1

    log_file = open(LOG_PATH, "a", encoding="utf-8")
    emit("=" * 62)
    emit(f"[{stamp()}] MO {port_name} @ {baud} baud, 8-N-1. Log ghi vao {LOG_PATH}")
    emit("Go lenh roi Enter de gui. Phim tat: " +
         " · ".join(f"{k}={v}" for k, v in SHORTCUTS.items()) + " · /q = thoat")
    emit("=" * 62)

    t = threading.Thread(target=reader, args=(port,), daemon=True)
    t.start()

    try:
        while not stop_flag.is_set():
            try:
                text = input()
            except EOFError:
                break
            if text.strip() == "/q":
                break
            if not text:
                continue
            text = SHORTCUTS.get(text.strip(), text)
            data = (text + "\r\n").encode("ascii", errors="replace")
            port.write(data)
            port.flush()
            a, h = render(data)
            emit(f"[{stamp()}] TX -> {a.rstrip('.')}")
            emit(f"{'':>11}   hex: {h}")
    except KeyboardInterrupt:
        pass
    finally:
        stop_flag.set()
        time.sleep(0.15)
        port.close()
        emit(f"[{stamp()}] DONG CONG.")
        if log_file:
            log_file.close()
    return 0


if __name__ == "__main__":
    sys.exit(main())
