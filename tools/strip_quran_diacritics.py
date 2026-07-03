#!/usr/bin/env python3
"""
One-time migration: adds arabic_text_plain column to the ayahs table in
assets/quran.db.  The column stores Arabic text with all diacritics, Quranic
annotation marks, format characters, and punctuation removed, leaving only
base Arabic letters (Unicode category Lo) and ASCII spaces.  This allows
diacritic-insensitive LIKE searches.

Run from the repo root:
    python3 tools/strip_quran_diacritics.py

After running, bump _dbVersion in lib/core/utils/database_helper.dart and
commit both the updated DB and the Dart change.
"""

import re
import sqlite3
import sys
import unicodedata
from pathlib import Path

DB_PATH = Path(__file__).parent.parent / "assets" / "quran.db"

# Keep only base Arabic letters (Unicode category Lo) and ASCII space.
# Everything else — tashkeel (Mn), format chars (Cf), modifiers (Lm),
# Quranic pause/end markers (Po: ٪ U+066A, ٭ U+066D), thin spaces — is
# stripped.  Multiple spaces are collapsed to a single space.
def strip_diacritics(text: str) -> str:
    result = []
    for c in text:
        if c == ' ':
            result.append(' ')
        elif unicodedata.category(c) == 'Lo':
            result.append(c)
        # everything else is dropped
    # collapse consecutive spaces
    return re.sub(r' {2,}', ' ', ''.join(result)).strip()


def main() -> None:
    if not DB_PATH.exists():
        print(f"ERROR: DB not found at {DB_PATH}", file=sys.stderr)
        sys.exit(1)

    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()

    # Check whether the column already exists
    cur.execute("PRAGMA table_info(ayahs)")
    cols = [row[1] for row in cur.fetchall()]
    if "arabic_text_plain" in cols:
        print("Column arabic_text_plain already exists — re-populating.")
    else:
        print("Adding column arabic_text_plain …")
        cur.execute("ALTER TABLE ayahs ADD COLUMN arabic_text_plain TEXT")

    # Populate
    cur.execute("SELECT id, arabic_text FROM ayahs")
    rows = cur.fetchall()
    print(f"Processing {len(rows)} ayahs …")

    stripped_rows = [(strip_diacritics(text), row_id) for row_id, text in rows]
    cur.executemany(
        "UPDATE ayahs SET arabic_text_plain = ? WHERE id = ?", stripped_rows
    )

    # Index: won't speed up %query% LIKE (leading wildcard prevents index use)
    # but is cheap, documents intent, and future-proofs for FTS5 content table.
    cur.execute(
        "CREATE INDEX IF NOT EXISTS idx_ayahs_plain "
        "ON ayahs (arabic_text_plain)"
    )

    conn.commit()
    conn.close()

    # Spot-check
    conn2 = sqlite3.connect(DB_PATH)
    sample = conn2.execute(
        "SELECT arabic_text, arabic_text_plain FROM ayahs LIMIT 5"
    ).fetchall()
    conn2.close()

    print("\nSpot-check (original → stripped):")
    for orig, plain in sample:
        print(f"  {orig!r}")
        print(f"  {plain!r}")
        print()

    # Verify no unexpected characters remain
    conn3 = sqlite3.connect(DB_PATH)
    remaining = set()
    for (t,) in conn3.execute("SELECT arabic_text_plain FROM ayahs"):
        for c in t:
            if c != ' ' and unicodedata.category(c) != 'Lo':
                remaining.add((ord(c), repr(c), unicodedata.category(c)))
    conn3.close()

    if remaining:
        print("WARNING: unexpected characters remain:")
        for cp, cr, cat in sorted(remaining):
            print(f"  U+{cp:04X}  {cr}  {cat}")
    else:
        print("Verification passed: only Arabic letters and spaces remain.")

    print("\nDone. Remember to bump _dbVersion in database_helper.dart.")


if __name__ == "__main__":
    main()
