#!/usr/bin/env python3
"""Generate nested function call outlines for gmacs.cpp.

Modes:
- full:     list all functions in file with L1 and L2 in-file calls
- filtered: show rooted call trees from selected entry-point functions

Generated outputs:

Full outline: testing/scripts/gmacs_nested_call_outline.txt
Filtered outline (separate file): testing/scripts/gmacs_nested_call_outline_filtered.txt
What the script supports:

Full mode for all functions with L1/L2 call lists.
Filtered mode for rooted call trees.
User flag control via --mode full or --mode filtered.
Optional root selection for filtered mode via --roots.
Optional depth controls via --max-depth and --recursive-repeat-depth.
Example commands:

python3 testing/scripts/generate_gmacs_call_outline.py --mode full --source _build/gmacs.cpp
python3 testing/scripts/generate_gmacs_call_outline.py --mode filtered --source _build/gmacs.cpp --roots userfunction,report --max-depth 2
python3 testing/scripts/generate_gmacs_call_outline.py --mode filtered --source _build/gmacs.cpp --roots report --output testing/scripts/report_only_call_tree.txt
Notes:

The filtered file currently uses roots userfunction and report.
Script syntax was validated with py_compile.
"""

from __future__ import annotations

import argparse
import re
from pathlib import Path
from typing import Dict, List, Set


def _strip_comments(text: str) -> str:
    text = re.sub(r"/\*.*?\*/", lambda m: "\n" * m.group(0).count("\n"), text, flags=re.S)
    text = re.sub(r"//.*", "", text)
    return text


def _extract_functions(lines: List[str]) -> Dict[str, dict]:
    sig_re = re.compile(
        r"^\s*(?:template\s*<[^>]+>\s*)?(?:[\w:<>,~*&\s]+\s+)?"
        r"([A-Za-z_~][A-Za-z0-9_:~]*)\s*\(([^;{}]*)\)\s*(?:const\s*)?(\{)?\s*$"
    )
    control_names = {"if", "for", "while", "switch", "catch"}

    funcs: List[dict] = []
    i = 0
    n = len(lines)
    while i < n:
        m = sig_re.match(lines[i])
        if not m:
            i += 1
            continue

        qname = m.group(1)
        sname = qname.split("::")[-1]
        if sname in control_names:
            i += 1
            continue

        brace_line = None
        if m.group(3) == "{":
            brace_line = i + 1
        else:
            j = i + 1
            while j < n and lines[j].strip() == "":
                j += 1
            if j < n and lines[j].strip() == "{":
                brace_line = j + 1
            else:
                i += 1
                continue

        depth = 0
        end_line = None
        for k in range(brace_line - 1, n):
            depth += lines[k].count("{")
            depth -= lines[k].count("}")
            if depth == 0:
                end_line = k + 1
                break

        if end_line is None:
            i += 1
            continue

        funcs.append(
            {
                "qname": qname,
                "sname": sname,
                "sig_line": i + 1,
                "start": brace_line,
                "end": end_line,
            }
        )
        i = end_line

    # Keep the last definition by short name.
    return {f["sname"]: f for f in funcs}


def _build_call_map(lines: List[str], funcs: Dict[str, dict]) -> None:
    name_set = set(funcs)
    call_re = re.compile(r"\b([A-Za-z_][A-Za-z0-9_]*)\s*\(")
    keywords = {"if", "for", "while", "switch", "return", "sizeof", "catch"}

    for sname, f in funcs.items():
        body_lines = lines[f["start"] - 1 : f["end"]]
        if body_lines:
            body_lines[0] = body_lines[0].split("{", 1)[-1]
        body = "\n".join(body_lines)
        body = re.sub(r'"(\\.|[^"\\])*"', '""', body)

        calls: List[str] = []
        for m in call_re.finditer(body):
            c = m.group(1)
            if c in keywords:
                continue
            if c in name_set:
                calls.append(c)

        seen: Set[str] = set()
        uniq = []
        for c in calls:
            if c != sname and c not in seen:
                seen.add(c)
                uniq.append(c)
        f["calls"] = uniq


def _find_recursive(funcs: Dict[str, dict]) -> List[str]:
    adj = {k: v.get("calls", []) for k, v in funcs.items()}

    def can_reach(start: str, target: str) -> bool:
        stack = [start]
        seen = set()
        while stack:
            cur = stack.pop()
            for nx in adj.get(cur, []):
                if nx == target:
                    return True
                if nx not in seen:
                    seen.add(nx)
                    stack.append(nx)
        return False

    return sorted([n for n in funcs if can_reach(n, n)])


def _format_full(funcs: Dict[str, dict], recursive: List[str], source: Path) -> str:
    out: List[str] = []
    out.append(f"Nested Function Call Outline for {source}")
    out.append("Scope: functions defined in this file; nested calls shown to level 2.")
    out.append("Recursion policy: recursion is not expanded in this mode; see filtered mode for rooted trees.")
    out.append(f"Function count: {len(funcs)}")
    out.append("")
    out.append(
        "Recursive functions detected (heuristic): "
        + (", ".join(recursive) if recursive else "none")
    )
    out.append("")

    for name in sorted(funcs):
        f = funcs[name]
        out.append(f"{name}  [line {f['sig_line']}]")
        l1 = f.get("calls", [])
        if not l1:
            out.append("  L1: (no in-file calls detected)")
            out.append("")
            continue

        out.append("  L1: " + ", ".join(l1))
        for c1 in l1:
            c1_calls = funcs[c1].get("calls", []) if c1 in funcs else []
            if not c1_calls:
                out.append(f"  L2 via {c1}: (no in-file calls detected)")
            else:
                out.append(f"  L2 via {c1}: " + ", ".join(c1_calls))
        out.append("")

    return "\n".join(out)


def _format_filtered(
    funcs: Dict[str, dict],
    recursive: List[str],
    source: Path,
    roots: List[str],
    max_depth: int,
    recursive_repeat_depth: int,
) -> str:
    out: List[str] = []
    out.append(f"Filtered Nested Call Tree for {source}")
    out.append("Scope: rooted trees from selected entry points; in-file calls only.")
    out.append(f"Roots: {', '.join(roots)}")
    out.append(f"Max depth: {max_depth}")
    out.append(f"Recursive repeat depth: {recursive_repeat_depth}")
    out.append("")
    out.append(
        "Recursive functions detected (heuristic): "
        + (", ".join(recursive) if recursive else "none")
    )
    out.append("")

    def walk(node: str, depth: int, path: List[str], rec_repeats: int) -> None:
        indent = "  " * depth
        line = f"{indent}- {node}"
        if node in funcs:
            line += f" [line {funcs[node]['sig_line']}]"
        out.append(line)

        if depth >= max_depth:
            return
        if node not in funcs:
            return

        children = funcs[node].get("calls", [])
        if not children:
            return

        for child in children:
            if child in path:
                if rec_repeats >= recursive_repeat_depth:
                    out.append(f"{'  ' * (depth + 1)}- {child} (recursive limit reached)")
                    continue
                walk(child, depth + 1, path + [child], rec_repeats + 1)
            else:
                walk(child, depth + 1, path + [child], rec_repeats)

    for r in roots:
        if r not in funcs:
            out.append(f"- {r} (root not found in file)")
            out.append("")
            continue
        walk(r, depth=0, path=[r], rec_repeats=0)
        out.append("")

    return "\n".join(out)


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate nested call outlines for gmacs.cpp")
    parser.add_argument("--source", default="_build/gmacs.cpp", help="Path to source C++ file")
    parser.add_argument("--mode", choices=["full", "filtered"], required=True, help="Output mode")
    parser.add_argument(
        "--output",
        help=(
            "Output file path. Defaults: testing/scripts/gmacs_nested_call_outline.txt for full, "
            "testing/scripts/gmacs_nested_call_outline_filtered.txt for filtered"
        ),
    )
    parser.add_argument(
        "--roots",
        default="userfunction,report",
        help="Comma-separated root function names for filtered mode",
    )
    parser.add_argument("--max-depth", type=int, default=2, help="Max tree depth for filtered mode")
    parser.add_argument(
        "--recursive-repeat-depth",
        type=int,
        default=2,
        help="Max repeated recursive expansions per path in filtered mode",
    )
    args = parser.parse_args()

    source = Path(args.source)
    if not source.exists():
        raise FileNotFoundError(f"Source file not found: {source}")

    output = Path(args.output) if args.output else (
        Path("testing/scripts/gmacs_nested_call_outline.txt")
        if args.mode == "full"
        else Path("testing/scripts/gmacs_nested_call_outline_filtered.txt")
    )

    text = _strip_comments(source.read_text(errors="ignore"))
    lines = text.splitlines()
    funcs = _extract_functions(lines)
    _build_call_map(lines, funcs)
    recursive = _find_recursive(funcs)

    if args.mode == "full":
        rendered = _format_full(funcs, recursive, source)
    else:
        roots = [r.strip() for r in args.roots.split(",") if r.strip()]
        rendered = _format_filtered(
            funcs,
            recursive,
            source,
            roots,
            args.max_depth,
            args.recursive_repeat_depth,
        )

    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(rendered)
    print(f"Wrote {output}")


if __name__ == "__main__":
    main()
