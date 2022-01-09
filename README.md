English | [Русский](https://github.com/Bs0Dd/brainfuck-86rk/blob/main/README-ru_RU.md)

# Brainfuck for Radio-86RK

![title](https://raw.githubusercontent.com/Bs0Dd/brainfuck-86rk/main/pictures/bfon86rk.png)

Surely those radio amateurs who lived in the USSR heard (and someone even collected) about the home 8-bit computer [Radio-86RK](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B4%D0%B8%D0%BE-86%D0%A0%D0%9A). The computer was quite simple to manufacture and therefore gained great popularity.  
It works on the KR580VM80A processor (Intel 8080A clone), has a B/W video system on the KR580VG75 (Intel 8275 clone), 32Kb of RAM and is capable of loading/saving data to an audio device. Therefore, nothing prevents you from performing Brainfuck on it.

## Interpreter versions
The interpreter exists in two versions: "К" and "П".  
 * Version "К" (Cassette) after startup, using the bootloader in the ROM-BIOS, loads the Brainfuck code into memory and then executes it.
 * Version "П" (Memory) assumes that the user has somehow already placed the Brainfuck code in memory, starting at address **0x019A**, and immediately executes it.

## Address data
For Brainfuck programs, 25000 8-bit cells are allocated (the standard 30,000 cannot be allocated due to only 32KB of RAM)  
	Addresses: **0x1458-0x75FF**  
For Brainfuck the code is allocated: in the "К" version - 4655 bytes, in the "П" version - 4798 bytes  
	Addresses:	**0x0229-0x1457** or **0x019A-0x1457**  
The interpreter occupies: in the "К" version - 553 bytes, in the "П" version - 410 bytes  
	Addresses:	**0x0000-0x0228** or **0x0000-0x0199**

## Peculiarities
* The performer is able to report basic errors that occurred while loading or executing Brainfuck code.
 The program will stop if: when loading the code from the cassette, the checksums did not match; the file from the cassette is too large; the pointer to the cell has gone out of the allocated memory; there is no opening/closing bracket in the code.

* Any Brainfuck code must end with a **0x00** byte indicating the end of the code.

* If the Brainfuck code asks for a character, a ">" sign will appear on a new line. After pressing the key, the character will be displayed and transferred to the code.

## Working on clones
There are many clones and partially compatible computers with Radio-86RK.
The work has been tested on the following clones (using an emulator):
* Spectr-001
* Apogee BK-01

Not workable on:
* Microsha (another system for calculating checksum, other addresses of the bootloader routines and return to the monitor)
* Micro-80 (no checksum calculation, other addresses of bootloader routines and return to monitor)
* Partner 01.01 (other addresses of bootloader routines and return to monitor)
* UT-88 (another system for calculating checksum, other addresses of the bootloader routines and return to the monitor)

It is possible that separate branches with versions for them will be created for these computers (I do not know the correct addresses yet).

## FAQ

* After starting, instead of, for example, "Hello World!", The display shows a strange "HЕЛЛО WОРЛД!".

   ![letters](https://raw.githubusercontent.com/Bs0Dd/brainfuck-86rk/main/pictures/hello.png)
	  
   This problem is related to the video controller device. Its character generator is designed for 128 characters, therefore, to fit Russian letters, small English letters were removed from it and replaced by their phonetic counterparts in Russian.  
   This situation can be corrected by rewriting the program to display the text in capital English letters, for example, "HELLO WORLD!"
	  
* Printing text is "scattered" across the display

   ![nolf](https://raw.githubusercontent.com/Bs0Dd/brainfuck-86rk/main/pictures/nolf.png)
	  
   Most likely the Brainfuck code to go to the next line prints only the LF character (**0x0A**), since on modern systems it performs a newline and move the cursor to the beginning. This is not the case on this computer, so to move the cursor to the beginning, you need to type CR (**0x0D**).  
   To fix this problem, it is enough to add the line `+++ .---` after each command that outputs LF in the code. Then, after LF, CR will be displayed immediately and there will be no problems with the line feed.
   
## Changelog
* Version 1.4
   * Reduced the size of the "К" version
   * Fixed a bug in the stop on error system
   * Fixed a critical bug that breaks command execution when the address of the current cell is from **0x2B00**.
* Version 1.3
   * First public version.
   * Fixed a critical bug that, in some circumstances, leads to the program freezing.
* Version 1.2
   * The performer no longer stores the address of the end of the Brainfuck code, but stops when it reaches the **0x00** character. This allowed to simplify the program and reduce the size.
   * Division into versions "К" and "П".
* Version 1.1
   * Optimized and minified code.
* Version 1.0
   * First version, non-public.
