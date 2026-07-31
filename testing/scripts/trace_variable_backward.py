#!/usr/bin/env python3
"""Trace backward dependencies for a variable in gmacs.cpp and map to gmacsbase.TPL.

Outputs two CSV files:
1) dependency-ordered trace
2) execution-line-ordered trace

This is a heuristic static analyzer intended for generated ADMB C++ style code.

Github Copilot created a reusable program that takes any variable name and a backward trace of calculations.

Program:

testing/scripts/trace_variable_backward.py
What it does:

Parses assignments/updates in _build/gmacs.cpp
Traces backward dependencies from a target variable to configurable depth
Maps each traced C++ line to matching line(s) in gmacsbase.TPL by normalized code matching
Writes two CSVs:
dependency-ordered
execution-line-ordered
Output format:

order_index
term
depth
via
description
gmacs_cpp_line
gmacs_cpp_code
gmacsbase_tpl_line
gmacsbase_tpl_code
Usage:

Basic:
python3 testing/scripts/trace_variable_backward.py objfun
With explicit files/depth:
python3 testing/scripts/trace_variable_backward.py objfun --cpp _build/gmacs.cpp --tpl gmacsbase.TPL --max-depth 2
Custom output prefix:
python3 testing/scripts/trace_variable_backward.py w_nloglike --out-prefix testing/scripts/w_nloglike_trace
Generated files for a run:

dependency view: testing/scripts/<variable>_backward_trace.csv
execution view: testing/scripts/<variable>_backward_trace_execution_order.csv

"""

from __future__ import annotations

import argparse
import csv
import re
from collections import defaultdict, deque
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterable, List, Optional, Set, Tuple


ASSIGN_RE = re.compile(r"\b([A-Za-z_][A-Za-z0-9_]*)\s*(\([^;=]*\))?\s*([+\-*/]?=)\s*(.+?)\s*;")
IDENT_RE = re.compile(r"\b([A-Za-z_][A-Za-z0-9_]*)\b")
FUNC_DEF_RE = re.compile(
    r"^\s*(?:[\w:<>,~*&\s]+?)\s+([A-Za-z_~][A-Za-z0-9_:~]*)\s*\(([^;{}]*)\)\s*(?:const\s*)?\{\s*$"
)

KEYWORDS = {
    "if",
    "else",
    "for",
    "while",
    "switch",
    "case",
    "return",
    "sizeof",
    "true",
    "false",
    "int",
    "double",
    "float",
    "long",
    "short",
    "bool",
    "char",
    "void",
    "const",
    "class",
    "new",
    "delete",
    "static",
    "template",
}

IGNORE_FUNCS = {
    "sum",
    "elem_prod",
    "square",
    "first_difference",
    "log",
    "exp",
    "mfexp",
    "dnorm",
    "mean",
    "trans",
    "sqrt",
    "fabs",
    "value",
    "max",
    "min",
    "str",
    "to_lower",
    "log_gamma_density",
    "posfun",
}


@dataclass
class Assignment:
    line: int
    lhs: str
    lhs_index: str
    op: str
    rhs: str
    code: str


def strip_line_comment(line: str) -> str:
    # Lightweight stripping for // comments in C++ lines.
    in_str = False
    escaped = False
    for i, ch in enumerate(line):
        if ch == '"' and not escaped:
            in_str = not in_str
        if ch == "\\" and not escaped:
            escaped = True
            continue
        if ch == "/" and not in_str and i + 1 < len(line) and line[i + 1] == "/":
            return line[:i]
        escaped = False
    return line


def load_lines(path: Path) -> List[str]:
    return path.read_text(errors="ignore").splitlines()


def find_function_line(lines: List[str], function_name: str) -> Optional[int]:
    target = function_name.split("::")[-1]
    for i, line in enumerate(lines, start=1):
        m = FUNC_DEF_RE.match(line.strip())
        if not m:
            continue
        name = m.group(1).split("::")[-1]
        if name == target:
            return i
    # Fallback for signatures that the strict parser misses.
    fallback = re.compile(rf"\b(?:[A-Za-z_][A-Za-z0-9_]*::)?{re.escape(target)}\s*\([^;{{}}]*\)")
    for i, line in enumerate(lines, start=1):
        if fallback.search(line):
            return i
    return None


def parse_assignments(lines: List[str]) -> List[Assignment]:
    out: List[Assignment] = []
    for i, raw in enumerate(lines, start=1):
        code_no_comment = strip_line_comment(raw)
        m = ASSIGN_RE.search(code_no_comment)
        if not m:
            continue
        lhs = m.group(1)
        lhs_index = m.group(2) or ""
        op = m.group(3)
        rhs = m.group(4).strip()
        out.append(Assignment(i, lhs, lhs_index, op, rhs, raw.rstrip("\n")))
    return out


def build_assign_index(assignments: Iterable[Assignment]) -> Dict[str, List[Assignment]]:
    idx: Dict[str, List[Assignment]] = defaultdict(list)
    for a in assignments:
        idx[a.lhs].append(a)
    return idx


def build_tpl_line_lookup(tpl_lines: List[str]) -> Dict[str, List[int]]:
    lookup: Dict[str, List[int]] = defaultdict(list)
    for i, line in enumerate(tpl_lines, start=1):
        key = normalize_code(line)
        if key:
            lookup[key].append(i)
    return lookup


def normalize_code(s: str) -> str:
    s = strip_line_comment(s)
    s = " ".join(s.strip().split())
    return s


def map_cpp_line_to_tpl(cpp_line_text: str, cpp_line_num: int, tpl_lookup: Dict[str, List[int]]) -> Optional[int]:
    key = normalize_code(cpp_line_text)
    if not key:
        return None
    candidates = tpl_lookup.get(key)
    if not candidates:
        return None
    return min(candidates, key=lambda n: abs(n - cpp_line_num))


def extract_rhs_dependencies(rhs: str, assignable_names: Set[str]) -> List[str]:
    deps: List[str] = []
    seen: Set[str] = set()

    for m in IDENT_RE.finditer(rhs):
        tok = m.group(1)
        if tok in KEYWORDS:
            continue
        if tok in IGNORE_FUNCS:
            continue
        if tok not in assignable_names:
            continue
        if tok not in seen:
            seen.add(tok)
            deps.append(tok)
    return deps


def describe_assignment(a: Assignment) -> str:
    if a.op == "=":
        return f"assignment to {a.lhs}{a.lhs_index}"
    if a.op == "+=":
        return f"increment of {a.lhs}{a.lhs_index}"
    if a.op == "-=":
        return f"decrement of {a.lhs}{a.lhs_index}"
    return f"update ({a.op}) of {a.lhs}{a.lhs_index}"


def trace_variable(
    variable: str,
    assign_idx: Dict[str, List[Assignment]],
    assignable_names: Set[str],
    max_depth: int,
) -> List[Tuple[str, int, str, Assignment]]:
    """Return rows as (term, depth, via, assignment)."""
    rows: List[Tuple[str, int, str, Assignment]] = []

    q: deque[Tuple[str, int, str]] = deque()
    q.append((variable, 0, "root"))

    visited_pairs: Set[Tuple[str, int]] = set()

    while q:
        var, depth, via = q.popleft()
        if (var, depth) in visited_pairs:
            continue
        visited_pairs.add((var, depth))

        for a in assign_idx.get(var, []):
            rows.append((var, depth, via, a))
            if depth >= max_depth:
                continue
            deps = extract_rhs_dependencies(a.rhs, assignable_names)
            for dep in deps:
                if dep == var:
                    continue
                q.append((dep, depth + 1, var))

    # Deduplicate rows by line/lhs/op to keep output readable.
    seen_rows: Set[Tuple[str, int, int, str, str]] = set()
    uniq: List[Tuple[str, int, str, Assignment]] = []
    for term, depth, via, a in rows:
        key = (term, depth, a.line, a.lhs, a.op)
        if key in seen_rows:
            continue
        seen_rows.add(key)
        uniq.append((term, depth, via, a))
    return uniq


def write_csvs(
    rows: List[Tuple[str, int, str, Assignment]],
    cpp_lines: List[str],
    tpl_lines: List[str],
    tpl_lookup: Dict[str, List[int]],
    dependency_csv: Path,
    execution_csv: Path,
) -> None:
    base_rows = []
    for term, depth, via, a in rows:
        tpl_line = map_cpp_line_to_tpl(a.code, a.line, tpl_lookup)
        base_rows.append(
            {
                "term": term,
                "depth": str(depth),
                "via": via,
                "description": describe_assignment(a),
                "gmacs_cpp_line": str(a.line),
                "gmacs_cpp_code": a.code,
                "gmacsbase_tpl_line": "" if tpl_line is None else str(tpl_line),
                "gmacsbase_tpl_code": "" if tpl_line is None else tpl_lines[tpl_line - 1],
            }
        )

    # Dependency order: depth asc then term then line.
    dep_sorted = sorted(
        base_rows,
        key=lambda r: (int(r["depth"]), r["term"], int(r["gmacs_cpp_line"])),
    )

    fieldnames = [
        "order_index",
        "term",
        "depth",
        "via",
        "description",
        "gmacs_cpp_line",
        "gmacs_cpp_code",
        "gmacsbase_tpl_line",
        "gmacsbase_tpl_code",
    ]

    dependency_csv.parent.mkdir(parents=True, exist_ok=True)
    with dependency_csv.open("w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=fieldnames)
        w.writeheader()
        for i, row in enumerate(dep_sorted, start=1):
            row_out = {"order_index": i}
            row_out.update(row)
            w.writerow(row_out)

    # Execution order: by cpp line then tpl line.
    def to_int(s: str) -> int:
        s = (s or "").strip()
        return int(s) if s.isdigit() else 10**9

    exe_sorted = sorted(
        base_rows,
        key=lambda r: (
            to_int(r["gmacs_cpp_line"]),
            to_int(r["gmacsbase_tpl_line"]),
            int(r["depth"]),
            r["term"],
        ),
    )

    execution_csv.parent.mkdir(parents=True, exist_ok=True)
    with execution_csv.open("w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=fieldnames)
        w.writeheader()
        for i, row in enumerate(exe_sorted, start=1):
            row_out = {"order_index": i}
            row_out.update(row)
            w.writerow(row_out)


def main() -> None:
    p = argparse.ArgumentParser(description="Backward variable trace for gmacs.cpp + gmacsbase.TPL")
    p.add_argument("variable", help="Variable name to trace (e.g., objfun)")
    p.add_argument("--cpp", default="_build/gmacs.cpp", help="Path to generated C++ file")
    p.add_argument("--tpl", default="gmacsbase.TPL", help="Path to source TPL file")
    p.add_argument(
        "--max-depth",
        type=int,
        default=2,
        help="Dependency trace depth from target variable assignments",
    )
    p.add_argument(
        "--start-function",
        default="userfunction",
        help="Function name for context reporting only",
    )
    p.add_argument(
        "--out-prefix",
        default=None,
        help="Output prefix; defaults to testing/scripts/<variable>_backward_trace",
    )
    args = p.parse_args()

    cpp_path = Path(args.cpp)
    tpl_path = Path(args.tpl)

    cpp_lines = load_lines(cpp_path)
    tpl_lines = load_lines(tpl_path)

    assignments = parse_assignments(cpp_lines)
    assign_idx = build_assign_index(assignments)
    assignable_names = set(assign_idx.keys())

    start_line = find_function_line(cpp_lines, args.start_function)
    if start_line is not None:
        # Keep as soft context; do not filter because dependencies can be defined above this line.
        pass

    rows = trace_variable(args.variable, assign_idx, assignable_names, args.max_depth)

    if args.out_prefix:
        prefix = Path(args.out_prefix)
    else:
        prefix = Path(f"testing/scripts/{args.variable}_backward_trace")

    dependency_csv = Path(str(prefix) + ".csv")
    execution_csv = Path(str(prefix) + "_execution_order.csv")

    tpl_lookup = build_tpl_line_lookup(tpl_lines)
    write_csvs(rows, cpp_lines, tpl_lines, tpl_lookup, dependency_csv, execution_csv)

    print(f"Start function context: {args.start_function} at line {start_line if start_line else 'not found'}")
    print(f"Assignments parsed: {len(assignments)}")
    print(f"Trace rows: {len(rows)}")
    print(f"Wrote {dependency_csv}")
    print(f"Wrote {execution_csv}")


if __name__ == "__main__":
    main()
