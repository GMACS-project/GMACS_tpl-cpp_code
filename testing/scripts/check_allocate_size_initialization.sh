#!/usr/bin/env bash
set -euo pipefail


# Return variable names used in .allocate(...) dimensions before first initialization.
# Usage:
#   find_uninitialized_allocate_size_vars <file.cpp>
#   find_uninitialized_allocate_size_vars --details <file.cpp>
#
# Names only example:
## testing/scripts/check_allocate_size_initialization.sh _build/gmacs.cpp
# Detailed example:
## testing/scripts/check_allocate_size_initialization.sh --details _build/gmacs.cpp
## or after sourcing: find_uninitialized_allocate_size_vars --details _build/gmacs.cpp
find_uninitialized_allocate_size_vars() {
  local mode="names"
  local cpp_file="${1:-}"

  if [[ "${1:-}" == "--details" || "${1:-}" == "-d" ]]; then
    mode="details"
    cpp_file="${2:-}"
  fi

  if [[ -z "${cpp_file}" ]]; then
    echo "Usage: find_uninitialized_allocate_size_vars [--details|-d] <path/to/file.cpp>" >&2
    return 2
  fi
  if [[ ! -f "${cpp_file}" ]]; then
    echo "File not found: ${cpp_file}" >&2
    return 2
  fi

  CHECK_ALLOC_MODE="${mode}" perl -ne '
    BEGIN {
      $mode = $ENV{"CHECK_ALLOC_MODE"} // "names";
    }

    BEGIN {
      %skip = map { $_ => 1 } qw(
        allocate TRUE FALSE NaN Inf
        int long short float double bool char const unsigned signed size_t
        if for while do switch case return break continue
        sum square sqr mfexp elem_prod first_difference dnorm fabs min max str
        endl cout cerr cin ios trunc fixed setw setprecision setfixed
        indexmin indexmax size
      );
    }

    # Step 1: record first use of every token inside .allocate(...) arguments.
    while (/\b([A-Za-z_][A-Za-z0-9_]*)\.allocate\(([^\n\)]*)\)/g) {
      $args = $2;
      while ($args =~ /\b([A-Za-z_][A-Za-z0-9_]*)\b/g) {
        $t = $1;
        next if $skip{$t};
        next if $t =~ /^[0-9]+$/;
        $first_use{$t} //= $.;
      }
    }

    # Step 2: record first likely initialization/assignment line for each token.
    for $v (keys %first_use) {
      if (!defined $first_init{$v}) {
        if (/$v\s*=\s*[^=]/ || />>\s*$v\b/ || /\b$v\.initialize\(/ || /\b$v\.allocate\(/) {
          $first_init{$v} = $.;
        }
      }
    }

    END {
      for $v (sort { $first_use{$a} <=> $first_use{$b} } keys %first_use) {
        if (!defined $first_init{$v} || $first_init{$v} > $first_use{$v}) {
          if ($mode eq "details") {
            $init = defined $first_init{$v} ? $first_init{$v} : "NONE";
            print "$v\tfirst_use=".$first_use{$v}."\tfirst_init=".$init."\n";
          } else {
            print "$v\n";
          }
        }
      }
    }
  ' "${cpp_file}" | awk '!seen[$0]++'
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  if [[ "${1:-}" == "--details" || "${1:-}" == "-d" ]]; then
    if [[ $# -lt 2 ]]; then
      echo "Usage: $0 [--details|-d] <path/to/file.cpp>" >&2
      exit 2
    fi
    CHECK_ALLOC_MODE="details" find_uninitialized_allocate_size_vars "$1" "$2"
  else
    CHECK_ALLOC_MODE="names" find_uninitialized_allocate_size_vars "$@"
  fi
fi
