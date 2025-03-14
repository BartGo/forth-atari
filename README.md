# forth-atari

Snippets of Forth code, mainly for Atari 8-bit and its APX Extended Fig-Forth by Patrick Mullarky. Source and possible issues with the code are mentioned in the comments. Work in progress is usually in the "drafts" folder. Recommended method of using: paste code into Altirra and test. In some cases code is suited for storage on "screens" and it has to be put on the floppy / ATR by using the FIG editor commands.

## snippets (stable)

* -EXE.4TH - EXECUTE conditionally (by myself)
* ANON.4TH - anonymous variables (by Leonard Morgenstern, FDv06n1)
* APX-4TH-EXT.4TH - extensions for APX Forth to make it more friendly to study Forth (by myself but combining multiple tools by others, see comments)
* ARGRES.4TH - simple local variables (by Marc Perkel, FDv03n6)
* ATARI-CONCEPTS.TXT - probable Atari Coin-Op department's documentation for dev tools using Forth (from "figasm, f69asm, computype master.atr", originally present at: "http://annex.retroarchive.org/disks/Atari/Forth-Disks/")
* BREAKPOINTS.4TH - breakpoints (BREAK & GO) by Frank Seuberling and Kim Harris, published in FDv05n1 - in an article signed by Leo Brodie
* CASEINSENS.4TH - making APX Forth case insensitive (extracted from pns-Forth)
* CLASSES-CRUDE.4TH - a primitive class-like mechanism (by myself)
* CO.4TH - a simple "coroutine" mechanism (described in multiple places, see the file for details)
* COMPENT-XLIST.4TH - compiled comments (by myself)
* DEFER-IS.4TH - example of deferred words (vectored execution), based on Henry Laxen's code published in FDv05n6p35
* DISASM - ...
* DISKSIMUL - ...
* EDIT.4TH - very nice screen editor (by Mike Dougherty, published in the Micro Magazine nr __)
* EDIT-BG.4TH - a simple screen editor (by myself)
* EDIT-FIG-MINI.4TH - ...
* ESCAPE.4TH - graphical demo (ported by John Mattes
* INCLUDE.4TH - experimental and useless conditional load in APX Forth
* LOCALS.4TH - most primitive local variables (by myself)
* PANTOLA-TA.4TH - FORTH-EDYTOR by Roland Pantoła (together with EDYTOR WPROWADZANIA and very slightly tuned Ragsdale Assembler)
* RECOLON.4TH - redefine colon words (by EHS, FDv06n3)
* SPACE-FORTH.4TH - words found on the Space Forth floppy (missing from the later APX)
* MUGWUMP.4TH - a game with some graphics (1974 Basic game from PCC, ported into Forth by myself)
* Mugwump-240816.atr - the above, bootable
* UNBUG - a HUGE, mostly tested ans stable set of debugging words and ideas for APX Forth, includes (details and copyright inside the file):
  - previously mentioned CASEINSENS.4TH,
  - slightly modified Fig Editor with extensions (not always stable)
  - SEARCH to search through screens for a string
  - OUTLINE for outline of screens
  - .BUFS to show buffers
  - .CC to show CURRENT and CONTEXT
  - S0, R0, .S, RP@, CALL
  - .EVAR to see user variables and system constants
  - R.N to show return stack (needs testing and probably fixing)
  - BREAK and GO for breakpoints (yeah!)
  - augmented trace (UNRAVEL) for stack trace
  - interpret compile-only words
  - examples how to change APX prompt
  - BASE changing frame colors
  - GOESINTO decompiler
  - ZAP to replace a word (it is bad, use RECOLON instead)
  - some additional links and ideas to enhance the file
* WHERE-USED.4TH - find all the words which refer to a given word (by Nicholas L. Pappas, FDv03n1)

## snippets (experimental / unstable / WIP)

* CHECKSUM.4TH (still broken)
* COREWARS-DRAFT.4TH (early idea)
* DB.4TH
* DISASM.4TH (by John Mattes, ANTIC 3/84 & 4/84)
* DISKSIMUL.4TH (by FIG)
* FN-TCHAK.4TH - words to cooperate with FujiNet, also some string handling (by Thom Cherryhomes)
* FP.4TH - floating point words
* HIRESWUMPUS.4TH
* LNKDLIST.4TH - still unstable
* MESSAGE.4TH - static messages (no disc access)
* NAMESPACES.4TH - early idea, won't work
* SERTTRADE.4TH - still broken, words to reorganize screens
* STATE-DRAFT.4TH
* STRINGS.4TH
* WORD-HIDING.4TH (still broken)
 
## misc


