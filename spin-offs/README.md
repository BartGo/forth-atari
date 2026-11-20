# APX fig-Forth extensions for Atari 8-bit

Two versions of extension packages were created:

* APXfigForth11r8 (55716AA2).atr is a tuning of APX Forth, using Ragsdale Assembler and Roland Pantoła's Editor (EDYTOR-FORTH).
* IDE-BOOT.atr is another tuning of the same, based on Mullarky's sources and Dougherty's editor (EDIT)

Both contain multiple tools for decompiling and work with Forth screens.

Once the Forth is booted, use HELP, ED-HELP and /? words to understand how to work with the environment. You need to know APX Forth before.

## Edit source on the PC and convert any of the 4TH/FTH files

You can try to convert included sources into a screen-based ATR:
`../pc-tools/txt2scr.sh ./myfile.4TH` → `myfile.ATR`.

## To rebuild

1. Boot vanilla APX Forth (ATR not in this repo; CRC notes are in the root README).
2. Check the screens to load in the source code of the Forth modification, look for a part like `: CORE ; 21 LOAD 40 LOAD 50 LOAD`
3. LOAD these enhancements to form a bigger kernel (typically with at least DEBUG and ASSEMBLER words)
4. Mount sources converted with txt2scr as a floppy image (or a real floppy, not tested but should work if you do a proper sector copy).
5. Now the core Forth floppy is removed so you won't break it
6. DO `1 LOAD` to proceed with extension loading 
7. When prompted, mount an empty formatted single-density disk and press Return — you can of course overwrite the source ATR if you accept losing it.
