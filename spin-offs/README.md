# APX fig-Forth study overlay (Atari 8-bit)

Source for a thicker APX environment: Dougherty editor, in-memory messages, help, inspector, stack viewer, ARG/RES locals, `FOLD` (word hiding / pseudo-scopes).

The bootable ATR is **not** stored in git; build it (below) or keep a local copy.

Also in this folder:

- `IDE-SRC.4TH` — combined screens for the overlay
- `EXERCISES.4TH` — sample screens (overwrites screens 80–83 if loaded as written)
- `DEVTOOLS.FTH` — host-side include list for `../pc-tools/preproc.sh`

## Run

1. Emulator: Atari XL/XE OS ROM, BASIC off (Altirra is the usual choice).
2. Boot vanilla APX Extended Fig-Forth Rev. 2, or a disk you previously saved after compiling `IDE-SRC.4TH`.
3. If you have a rebuilt `IDE-BOOT.ATR`, mount and boot that instead.



## What the overlay adds

- Boot banner (`VER`)
- `HELP` / `ED-HELP`
- `/?` word header + decompiler
- Full-screen editor (Mike Dougherty, *Micro 6502*)
- `D1:` `D2:` `DIR` (block/screen oriented, not Atari DOS files)
- `STACK` command-line stack display
- Border color follows `BASE`; errors blink (except message 4 / redefinition)
- Messages in RAM (kernel would otherwise overlay screen-based messages)
- Unnamed locals (arguments / results)
- `FOLD` to hide parenthesized “internal” names



## Edit source on the PC

1. Edit `IDE-SRC.4TH`.
2. Convert: `../pc-tools/txt2scr.sh ./IDE-SRC.4TH` → `IDE-SRC.ATR`.
3. Rebuild using that ATR as in the next section.



## Rebuild

1. Boot vanilla APX Forth (ATR not in this repo; CRC notes are in the root README).
2. `: CORE ; 21 LOAD 40 LOAD 50 LOAD`
3. Mount `IDE-SRC.ATR` (or a sector copy).
4. `1 LOAD`
5. When prompted, mount an empty formatted single-density disk and press Return — or overwrite the source ATR if you accept losing it.

Assembler note in `IDE-SRC.4TH`: graphics words assume Mullarky’s assembler from the APX disk (`50 LOAD`), not Ragsdale. Pantola’s `EDYTOR-FORTH` wants Ragsdale; it is not the default editor here.