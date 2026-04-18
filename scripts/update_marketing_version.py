#!/usr/bin/env python3

from __future__ import annotations

import pathlib
import re
import sys


VERSION_PATTERN = re.compile(r"^\d+(?:\.\d+){0,2}$")
MARKETING_VERSION_PATTERN = re.compile(r"(MARKETING_VERSION = )([^;]+)(;)")


def main() -> int:
    if len(sys.argv) != 3:
        print("usage: update_marketing_version.py <pbxproj_path> <version>", file=sys.stderr)
        return 1

    pbxproj_path = pathlib.Path(sys.argv[1])
    version = sys.argv[2].strip()

    if not pbxproj_path.is_file():
        print(f"file not found: {pbxproj_path}", file=sys.stderr)
        return 1

    if not VERSION_PATTERN.fullmatch(version):
        print(f"invalid version: {version}", file=sys.stderr)
        return 1

    original = pbxproj_path.read_text(encoding="utf-8")
    updated, replacements = MARKETING_VERSION_PATTERN.subn(rf"\g<1>{version}\g<3>", original)

    if replacements == 0:
      print("MARKETING_VERSION not found", file=sys.stderr)
      return 1

    if updated == original:
      print(f"MARKETING_VERSION is already {version}", file=sys.stderr)
      return 1

    pbxproj_path.write_text(updated, encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
