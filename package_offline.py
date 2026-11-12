#!/usr/bin/env python3
"""Build one offline Windows ZIP from native RiftVoice and untouched VB-Audio package."""
from pathlib import Path
import hashlib,struct,zipfile,zlib

ROOT=Path(__file__).resolve().parent
ZIP=ROOT/'RiftVoice_0.3.0_by_Swir_OFFLINE_CS2_Windows11_x64.zip'
PREFIX='RiftVoice_0.3.0_by_Swir_Windows11_x64'
DRIVER=ROOT/'VBCABLE_Driver_Pack46.zip'

def chunk(t,d):
    return struct.pack('>I',len(d))+t+d+struct.pack('>I',zlib.crc32(t+d)&0xffffffff)

def icon_bytes():
    glyph=('1111100','1100010','1100010','1111100','1101100','1100110','1100011','0000000')
    rows=[]
    for y in range(64):
        row=bytearray()
        for x in range(64):
            d=(x-31.5)**2+(y-31.5)**2
            rgb=(12,17,32)
            if 775<d<1000:rgb=(121,77,248)
            if 720<d<=775:rgb=(28,184,238)
            xx=(x-16)//4; yy=(y-16)//4
            if 16<=x<44 and 16<=y<48 and 0<=yy<len(glyph) and 0<=xx<7 and glyph[yy][xx]=='1':rgb=(58,220,255)
            row.extend((*rgb,255))
        rows.append(b'\0'+bytes(row))
    png=b'\x89PNG\r\n\x1a\n'+chunk(b'IHDR',struct.pack('>IIBBBBB',64,64,8,6,0,0,0))+chunk(b'IDAT',zlib.compress(b''.join(rows),9))+chunk(b'IEND',b'')
    return struct.pack('<HHH',0,1,1)+struct.pack('<BBBBHHII',64,64,0,0,1,32,len(png),22)+png

def main():
    if not (ROOT/'RiftVoice.exe').is_file():raise RuntimeError('RiftVoice.exe missing')
    if not DRIVER.is_file() or DRIVER.stat().st_size<100000:raise RuntimeError('Vendor ZIP missing')
    with zipfile.ZipFile(DRIVER) as z:
        if not any(Path(n).name.lower()=='vbcable_setup_x64.exe' for n in z.namelist()):raise RuntimeError('Vendor x64 installer missing')
    data={}
    for n in ['RiftVoice.exe','README.md','START_TUTAJ.cmd','INSTALUJ_VIRTUAL_MIC.cmd','URUCHOM_RIFTVOICE.cmd','DIAGNOSTYKA_AUDIO.cmd']:
        data[n]=(ROOT/n).read_bytes()
    data['RiftVoice.ico']=icon_bytes()
    data['INSTRUKCJA_PL.txt']=(ROOT/'distribution/INSTRUKCJA_PL_OFFLINE.txt').read_bytes()
    data['third_party/VBCABLE_Driver_Pack46.zip']=DRIVER.read_bytes()
    for folder in ['source','tools','docs']:
        for p in (ROOT/folder).rglob('*'):
            if p.is_file() and p.name not in ['FAQ_PL.md','TEST_REPORT.txt']:
                data[p.relative_to(ROOT).as_posix()]=p.read_bytes()
    for n in list(data):
        if n.endswith('.cmd'):data[n]=data[n].replace(b'\r\n',b'\n').replace(b'\n',b'\r\n')
    data['SHA256SUMS.txt']=(''.join(f'{hashlib.sha256(data[n]).hexdigest()} *{n}\n' for n in sorted(data))).encode()
    with zipfile.ZipFile(ZIP,'w') as z:
        for n,b in sorted(data.items()):
            method=zipfile.ZIP_STORED if n.endswith('.zip') else zipfile.ZIP_DEFLATED
            z.writestr(PREFIX+'/'+n,b,compress_type=method)
    if ZIP.stat().st_size<1000000:raise RuntimeError('Package too small')
    print('ZIP:',ZIP.name,'bytes:',ZIP.stat().st_size,'SHA256:',hashlib.sha256(ZIP.read_bytes()).hexdigest())

if __name__=='__main__':main()
