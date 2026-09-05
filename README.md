# Forth-Atari

Source snippets for **APX Extended Fig-Forth Rev. 2** (written by Patrick Mullarky) on Atari 8-bit. This repository is not a Forth system and does not include the APX-20029 distribution.

Most files are fig-Forth **screens** or pasteable listings: type-ins from *Forth Dimensions*, *Micro 6502*, *Tajemnice Atari*, *Bajtek*, plus later adaptations. Comments in each file are the authority for origin, load order, and known breakage.

 Do not run any of this on real hardware without testing on an emulator first.

`drafts/` is expected to be unfinished or wrong.

## Target

Boot **APX Extended Fig-Forth Rev. 2** in an emulator (suggested: Altirra, XL/XE OS, BASIC disabled).

APX-20029 is not redistributed here. A DCM image is listed at [atariarchives.org APX-20029](https://www.atariarchives.org/APX/showinfo.php?cat=20029). Convert DCM → ATR yourself. The `APX20029.ATR` on that page has been reported corrupt. Working images have CRC-32 `F64B50DA` or `E6B43BB4` and may be found on other sites.

Manual: [Extended fig-FORTH Rev. 2](https://archive.org/details/extended-fig-forth-rev-2-apx). Related APX disks (not required for this tree): fun-FORTH (APX-20146), FORTH Turtle Graphics Plus (APX-20157).

fig-Forth background: [Forth, Inc. history notes](https://www.forth.com/resources/forth-programming-language).

Highly recommended video courses: [Mike Miller, APX fig-Forth](https://www.youtube.com/watch?v=c4lT-IQTItM&list=PL9GQGINuWC-2bCTRWZHJzpXMXgmbpp5s6).

## What git contains vs what you generate

Tracked: `.4TH` / `.FTH` / a few `.TXT` listings, `pc-tools/` scripts, and markdown.

Not tracked (`*.ATR`, `*.atr`, `*.OUT`, `OUT.FTH`): floppy images, including a rebuilt study disk. `spin-offs/README.md` describes how to build one from vanilla APX plus `IDE-SRC.4TH`.

Load paths:

1. Read the file header, then paste into Altirra on a booted APX system, or
2. Convert text → ATR with `pc-tools/` and mount as a second disk, or
3. Use the FIG editor (`editors/EDIT.4TH` and similar) to put source on screens.

Filenames on disk are mixed case (e.g. `EDIT.4TH`). Use that spelling on case-sensitive checkouts.

## Layout


| Directory                 | Contents                                                                                                                                                                                                                                            |
| ------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [asm/](asm)               | Forth assembler experiments (Mullarky / Ragsdale). `LINER.4TH`, `LINER2.4TH` (Omirski *Bajtek* line demo), `LINIJKA.TXT` (original disassembly), `PATCHING-NEXT.TXT`.                                                                               |
| [debug/](debug)           | `BREAK&GO.4TH`, `QMEG.FTH`, `STACK-PROMPT.4TH`.                                                                                                                                                                                                     |
| [dictionary/](dictionary) | `LOCALDEF.4TH`, `NAMESPACES.4TH`, `RECOLON.4TH`, `TRANSIENTS.4TH`, `VOCABULARIES.4TH`, `WHERE-USED.4TH`.                                                                                                                                            |
| [docs/](docs)             | Sidecar texts. See [docs/README.md](docs/README.md). Not all of it is APX fig-Forth.                                                                                                                                                                |
| [drafts/](drafts)         | Unstable ports and experiments.                                                                                                                                                                                                                     |
| [editors/](editors)       | `EDIT.4TH` (Dougherty), `EDYTOR-FORTH.4TH` / `EWK.4TH` (Pantola), `FIG-MINI.4TH`, `MTF.4TH`.                                                                                                                                                        |
| [games/](games)           | `ESCAPE.4TH`, `LIFE.4TH`, `MUGWUMP.4TH`.                                                                                                                                                                                                            |
| [io/](io)                 | `DISKCOPY.4TH`, `DISKSIMUL.4TH`.                                                                                                                                                                                                                    |
| [mods/](mods)             | Interpreter / listing tweaks: `3VL.4TH`, `ALGEBRAIC.FTH`, `BLIST.FTH`, `CASEINSENS.4TH`, `COMPENT-XLIST.4TH`, `DOES-PARAM.FTH`, `INWORDPARAM.4TH`, `MESSAGE.4TH`, `MSG4-OFF.FTH`, `PICK&ROLL.4TH`, `PREPROC-IF.4TH`, `TERNARY.4TH`, `WORDHELP.4TH`. |
| [pc-tools/](pc-tools)     | Host conversion. See [pc-tools/README.md](pc-tools/README.md).                                                                                                                                                                                      |
| [spin-offs/](spin-offs)   | Study-oriented APX overlay: `IDE-SRC.4TH`, `EXERCISES.4TH`, `DEVTOOLS.FTH`. [spin-offs/README.md](spin-offs/README.md).                                                                                                                             |
| [variables/](variables)   | `ANON.4TH`, `ARGRES-VAL.4TH`, `DEFER-IS.4TH`, `LOCALS-MINI.4TH`, `LOCALS-STACK.4TH`, `MAP.4TH`, `SEQUENCE.4TH`, `STRINGS.4TH`, `TABLE-LOOKUP.4TH`.                                                                                                  |




## Provenance and license

`LICENSE` (MIT) covers original work by BartGo in this repository.

Magazine type-ins and third-party listings keep whatever notice is in the file. Example: `dictionary/LOCALDEF.4TH` quotes a University of Rochester personal, non-commercial notice from *Forth Dimensions*. That notice is not replaced by MIT.

APX Forth, Atari ROMs, and DCM/ATR images of APX products are outside this license and are not in the tree.