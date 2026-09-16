# keil2sdcc.ps1 - doi cu phap Keil C51 sang SDCC, GIU NGUYEN SO DONG (loi bao dong nao la dong do cua file goc)
# hex.cmd goi:  exit 0 = file da viet cho SDCC, khong ghi gi
#               exit 1 = co cu phap Keil, da ghi ban doi ra $Dst
#               exit 2 = loi doc/ghi file
param([string]$Src, [string]$Dst)
$ErrorActionPreference = 'Stop'
trap { Write-Host "[LOI] keil2sdcc: $_"; exit 2 }

# Latin-1 doc/ghi dung tung byte -> comment tieng Viet (UTF-8) di qua nguyen ven
$latin1 = [Text.Encoding]::GetEncoding(28591)
$lines = [IO.File]::ReadAllText($Src, $latin1) -split '(?<=\n)'

# dia chi cac SFR danh dia chi bit, cho "sbit X = PSW^7"
$bitAddr = @{ P0=0x80; TCON=0x88; P1=0x90; SCON=0x98; P2=0xA0; IE=0xA8; P3=0xB0;
              IP=0xB8; T2CON=0xC8; PSW=0xD0; ACC=0xE0; B=0xF0 }

$sbitFromSfr = {
    param($m)
    $sfr = $m.Groups[3].Value
    if (-not $bitAddr.ContainsKey($sfr)) { return $m.Value }   # khong biet dia chi -> de nguyen, SDCC se bao loi
    '{0}__sbit __at(0x{1:X2}) {2};' -f $m.Groups[1].Value, ($bitAddr[$sfr] + [int]$m.Groups[4].Value), $m.Groups[2].Value
}

$rules = @(
    @('include',   '#include\s*[<"][Rr][Ee][Gg]5([12])\.[Hh][>"]', '#include <805$1.h>'),
    @('sbit',      '^(\s*)sbit\s+(\w+)\s*=\s*(\w+)\s*\^\s*([0-7])\s*;', $sbitFromSfr),
    @('sbit',      '^(\s*)sbit\s+(\w+)\s*=\s*(0x[0-9A-Fa-f]+|\d+)\s*;', '$1__sbit __at($3) $2;'),
    @('sfr',       '^(\s*)sfr\s+(\w+)\s*=\s*(0x[0-9A-Fa-f]+|\d+)\s*;', '$1__sfr __at($3) $2;'),
    @('bit',       '(?<!\w)bit(?=\s+[A-Za-z_]\w*\s*[=;,()\[])', '__bit'),
    @('code/data', '(?<=[A-Za-z_]\w*\s+)(code|data|idata|xdata|pdata)(?=\s+\*?\s*[A-Za-z_]\w*\s*[\[=;,)])', '__$1'),
    @('interrupt', '\)\s*interrupt\s+(\d+)', ') __interrupt($1)'),
    @('using',     '(?<!\w)using\s+(\d+)', '__using($1)'),
    @('reentrant', '\)\s*reentrant(?!\w)', ') __reentrant')
)

$changes = [ordered]@{}
for ($i = 0; $i -lt $lines.Count; $i++) {
    foreach ($r in $rules) {
        $old = $lines[$i]
        if ($r[2] -is [scriptblock]) {
            $lines[$i] = [regex]::Replace($old, $r[1], [Text.RegularExpressions.MatchEvaluator]$r[2])
        } else {
            $lines[$i] = [regex]::Replace($old, $r[1], $r[2])
        }
        if ($lines[$i] -ne $old) {
            if (-not $changes.Contains($r[0])) { $changes[$r[0]] = New-Object Collections.ArrayList }
            if (-not $changes[$r[0]].Contains($i + 1)) { [void]$changes[$r[0]].Add($i + 1) }
        }
    }
}

if ($changes.Count -eq 0) { exit 0 }

[void](New-Item -ItemType Directory -Force (Split-Path $Dst))
[IO.File]::WriteAllText($Dst, ($lines -join ''), $latin1)
Write-Host '[KEIL] File viet cho Keil C51 - da tu doi sang SDCC (file goc giu nguyen):'
foreach ($k in $changes.Keys) { Write-Host ('       {0,-10} dong {1}' -f $k, ($changes[$k] -join ' ')) }
Write-Host "       Ban da doi: $Dst"
Write-Host ''
exit 1
