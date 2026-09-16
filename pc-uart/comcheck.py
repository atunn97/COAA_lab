"""
comcheck.py - Kiem tra cau noi COM ao TRUOC khi dinh toi Proteus / 8051.

Chay bang:
    uv run --with pyserial comcheck.py list
    uv run --with pyserial comcheck.py pair COM3 COM4

Muc dich: xac nhan cap cong ao com0com thong nhau. Neu buoc nay chua xanh
thi dung mo Proteus - loi se co qua nhieu cho kha nghi cung luc.
"""

import sys
import time

try:
    import serial
    from serial.tools import list_ports
except ImportError:
    print("Thieu pyserial. Chay lai bang:  uv run --with pyserial comcheck.py ...")
    sys.exit(1)


def cmd_list():
    ports = list(list_ports.comports())
    if not ports:
        print("KHONG CO CONG COM NAO tren may.")
        print()
        print("Nguyen nhan thuong gap, theo thu tu:")
        print("  1. Chua cai com0com.")
        print("  2. Da cai nhung chua doi ten: com0com tao san cap CNCA0/CNCB0,")
        print("     ma ten do Proteus lan pyserial deu KHONG nhan. Phai doi thanh COMx.")
        return 1

    print("Cac cong COM dang co:")
    for p in ports:
        print(f"  {p.device:8}  {p.description}")
    print()

    names = [p.device for p in ports]
    if len(names) >= 2:
        print(f"=> Thu cap noi cheo:  uv run --with pyserial comcheck.py pair {names[0]} {names[1]}")
    else:
        print("=> Moi thay 1 cong. Cap com0com phai ra DU HAI cong thi moi dung.")
    return 0


def _drain(port):
    port.reset_input_buffer()
    port.reset_output_buffer()


def _try_direction(tx, rx, msg, baud):
    tx.write(msg)
    tx.flush()
    deadline = time.time() + 2.0
    got = b""
    while time.time() < deadline and len(got) < len(msg):
        chunk = rx.read(rx.in_waiting or 1)
        if chunk:
            got += chunk
    return got


def cmd_pair(a_name, b_name, baud=9600):
    print(f"Mo {a_name} va {b_name} o {baud} baud, 8-N-1 ...")
    try:
        a = serial.Serial(a_name, baud, timeout=0.2)
    except serial.SerialException as e:
        print(f"KHONG MO DUOC {a_name}: {e}")
        print("  - 'Access denied' = cong dang bi chuong trinh khac giu (vd Proteus dang chay).")
        print("  - 'could not open port' = cong khong ton tai.")
        return 1
    try:
        b = serial.Serial(b_name, baud, timeout=0.2)
    except serial.SerialException as e:
        a.close()
        print(f"KHONG MO DUOC {b_name}: {e}")
        return 1

    ok = True
    try:
        _drain(a)
        _drain(b)

        msg1 = b"PING-A-TO-B\r\n"
        got1 = _try_direction(a, b, msg1, baud)
        if got1 == msg1:
            print(f"  [OK] {a_name} -> {b_name}   nhan du {len(got1)} byte")
        else:
            ok = False
            print(f"  [HONG] {a_name} -> {b_name}   gui {len(msg1)} byte, nhan ve {len(got1)}: {got1!r}")

        _drain(a)
        _drain(b)

        msg2 = b"PING-B-TO-A\r\n"
        got2 = _try_direction(b, a, msg2, baud)
        if got2 == msg2:
            print(f"  [OK] {b_name} -> {a_name}   nhan du {len(got2)} byte")
        else:
            ok = False
            print(f"  [HONG] {b_name} -> {a_name}   gui {len(msg2)} byte, nhan ve {len(got2)}: {got2!r}")
    finally:
        a.close()
        b.close()

    print()
    if ok:
        print("=> CAU NOI SONG. Gio moi mo Proteus:")
        print(f"   COMPIM dat Physical port = {a_name}, con app Python mo {b_name}.")
        print("   (Mot cong chi MOT chuong trinh mo duoc - dung tro ca hai vao cung mot cong.)")
        return 0

    print("=> CAU NOI CHUA THONG. Kiem theo thu tu:")
    print("   1. Hai cong nay co phai la MOT CAP com0com khong?")
    print("      Cap la CNCA0<->CNCB0 doi ten ra. Hai cong roi rac thi khong noi nhau.")
    print("   2. Co chuong trinh nao dang giu cong khong (Proteus, PuTTY, Arduino IDE)?")
    return 1


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        return 2
    cmd = sys.argv[1].lower()
    if cmd == "list":
        return cmd_list()
    if cmd == "pair":
        if len(sys.argv) < 4:
            print("Thieu ten cong. Vi du:  comcheck.py pair COM3 COM4")
            return 2
        baud = int(sys.argv[4]) if len(sys.argv) > 4 else 9600
        return cmd_pair(sys.argv[2], sys.argv[3], baud)
    print(f"Khong hieu lenh: {cmd}")
    print(__doc__)
    return 2


if __name__ == "__main__":
    sys.exit(main())
