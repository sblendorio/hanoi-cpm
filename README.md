# Towers of Hanoi - CP/M version
## Contents of package
- **source** - Source code in Turbo Pascal 3.01A (Borland)
 - [**hanoi-p.pas**](https://github.com/sblendorio/hanoi-cpm/blob/master/source/hanoi-p.pas) - Portable version: uses just *KayPro* / *ADM-3A* escape sequences. Black and white.
 - [**hanoi128.pas**](https://github.com/sblendorio/hanoi-cpm/blob/master/source/hanoi128.pas) - Commodore 128 specific version: uses low-level calls and specific escape sequences to get colours.
 - [**graph.inc**](https://github.com/sblendorio/hanoi-cpm/blob/master/source/graph.inc) - Library needed by Commodore 128 specific version
- **binary** - Compiled .COM executable files for CP/M-80
 - [**hanoi-p.com**](https://github.com/sblendorio/hanoi-cpm/raw/master/binary/hanoi-p.com) - Binary portable version
 - [**hanoi128.com**](https://github.com/sblendorio/hanoi-cpm/raw/master/binary/hanoi128.com) - Binary Commodore 128 specific version
- **dists** - Collection of CP/M bootable disk images for Commodore 128
 - [**hanoi.d71**](https://github.com/sblendorio/hanoi-cpm/raw/master/dists/hanoi.d71) - Includes CP/M boot code, all sources and binaries, some utilities
 - [**hanoi.d64**](https://github.com/sblendorio/hanoi-cpm/raw/master/dists/hanoi.d64) - Includes CP/M boot code, all sources and binaries

## Credits
Thanks to [TomHarte](https://github.com/TomHarte) for his [CP/M for OS X](https://github.com/TomHarte/CP-M-for-OS-X)

## Screenshots
### Commodore 128 version
![C128 version](http://www.sblendorio.eu/images/hanoi-128-1.png) ![C128 version](http://www.sblendorio.eu/images/hanoi-128-2.png)
### Portable version
![Portable version](http://www.sblendorio.eu/images/hanoi-p-1.png) ![Portable version](http://www.sblendorio.eu/images/hanoi-p-2.png)
