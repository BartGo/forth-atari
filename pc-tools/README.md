# pc-tools/

Host-side helpers. Output disk images are gitignored (`*.ATR`).

| File | Use |
|------|-----|
| `txt2scr.sh` | Bash. One listing → single-density ATR with 64-character Forth screens and `-->` / `;S` markers. Used for `IDE-SRC.4TH`. |
| `fs2atr.sh` | Untested (author: Buki). Expects `*.fs`, GNU `stat -c`, flattens newlines and uppercases. Not aligned with this repo’s `.4TH` screen files. |
| `preproc.sh` | Bash. Expands `{ $$path }` include lines. Example consumer: `spin-offs/DEVTOOLS.FTH`. Paths must match git case. |
| `scr2altirra.cmd` | Windows. Mounts a generated ATR in Altirra. Set `ALTIRRA` to `Altirra64.exe` (full path). Optional `IDE_BOOT` if you have a rebuilt study disk. |

Example:

```bash
./txt2scr.sh ../spin-offs/IDE-SRC.4TH
```

```cmd
set ALTIRRA=C:\path\to\Altirra64.exe
scr2altirra.cmd D:\path\to\source.ATR
```
