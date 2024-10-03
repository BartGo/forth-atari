# forth-atari

Snippets of Forth code, mainly for Atari 8-bit and its APX Extended Fig-Forth by Patrick Mullarky.

Source and possible issues with the code mentioned in comments.

Recommended method of using: paste code into Altirra and test.

## snippets (stable)

* -INCLUDE.4TH - experimental and useless conditional load in APX Forth
* ARGRES.4TH - simple local variables (by Marc Perkel, FDv03n6)
* CASEINSENS.4TH - making APX Forth case insensitive (from pns-Forth)
* CO.4TH - a simple "coroutine" mechanism
* COMPENT.4TH - compiled comments (by myself)
* EDIT.4TH - full-screen editor (by Mike Dougherty, Micro Magazine)
* ESCAPE.4TH - graphical demo (ported by John Mattes
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
* ATARI-CONCEPTS.TXT - Atari Coin-Op's documentation for dev tools using Forth

