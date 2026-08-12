#!/usr/bin/env python3
"""claude-context — fast search across your ~/.claude world.

Finds a search term across conversations, plans, agents, and memory, then tells
you the one thing you usually need: *which project* the hit belongs to and the
*real path* so you can open VSCode in the right context.

Search is delegated to ripgrep (fast, respects unicode) and the JSON stream is
parsed and rendered with rich. Machine-readable output modes make this tool
usable by an LLM (including Claude itself) as a cheap recall step before
deciding whether it's worth spending tokens reading full files.

Usage:
    claude-context "can't stream responses"
    claude-context -v "polling"                     # verbose: show every hit
    claude-context -s "gateway envelope"             # --section: whole markdown section
    claude-context --kind memory "CSP"                # restrict to one source kind
    claude-context -i "WebSocket"                     # case-insensitive (default is smart)
    claude-context "gateway" -e "envelope"            # AND: both terms on the line
    claude-context "gateway" -e "envelope" --term-logic or
    claude-context -C 3 "panic"                       # 3 lines of context
    claude-context --since 3d "deploy"                # last 3 days
    claude-context --before 2026-07-01 "deploy"
    claude-context -l "gateway" | xargs -I{} code {}  # paths only, for piping
    claude-context -o "gateway envelope"              # open best match in editor

    # LLM / low-token workflows:
    claude-context "reconnect jitter" --format compact   # grep-able one-liner output
    claude-context "reconnect jitter" --format json       # structured, for tool calls
    claude-context "reconnect jitter"                     # note the [id] shown per hit
    claude-context --expand a1b2c3d4                      # re-hydrate ONE cached hit fully
    claude-context --expand 2                              # or by index from the last run
    claude-context --related a1b2c3d4                      # find similar content elsewhere
    claude-context --related ~/.claude/memory/foo.md        # ...without knowing exact wording
    claude-context "gateway envelope" --recall               # cross-project comparison view
    claude-context "gateway envelope" --stats                 # counts only, no content
    claude-context --list --kind memory                       # browse memories, no search
    claude-context --list --tag websocket                     # browse by tag
    claude-context "gateway" --tag backend --unique --budget 2000

Config (optional): ~/.config/claude-context/config.json
    {
      "root": "~/.claude",
      "kinds": ["conversation", "memory"],
      "exclude": ["projects/**/node_modules/**"],
      "context": 2,
      "max_results": 500,
      "sort": "score",
      "term_logic": "and",
      "format": "rich"
    }
CLI flags always override the config file.
"""

from __future__ import annotations

import argparse
import difflib
import fnmatch
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import threading
from concurrent.futures import ThreadPoolExecutor
from dataclasses import dataclass, field
from datetime import datetime
from pathlib import Path

try:
    from rich.console import Console
    from rich.markdown import Markdown
    from rich.panel import Panel
    from rich.rule import Rule
    from rich.syntax import Syntax
    from rich.table import Table
    from rich.text import Text
except ImportError:
    sys.stderr.write(
        "This tool needs 'rich'. Install it with:  python3 -m pip install rich\n"
    )
    sys.exit(2)


CLAUDE_ROOT = Path(os.environ.get("CLAUDE_ROOT", Path.home() / ".claude"))

CACHE_DIR = Path(os.environ.get(
    "CLAUDE_CONTEXT_CACHE", str(Path.home() / ".cache" / "claude-context")
)).expanduser()
CACHE_FILE = CACHE_DIR / "last.json"

console = Console()


# --------------------------------------------------------------------------- #
# Source kinds — where we search and how to label a hit.
# --------------------------------------------------------------------------- #

KINDS: dict[str, dict] = {
    "conversation": {
        "dirs": ["projects"],
        "globs": ["**/*.jsonl"],
        "label": "Conversation",
        "color": "cyan",
    },
    "project-memory": {
        "dirs": ["projects"],
        "globs": ["**/memory/*.md"],
        "label": "Project Memory",
        "color": "magenta",
    },
    "memory": {
        "dirs": ["memory"],
        "globs": ["*.md"],
        "label": "Memory",
        "color": "magenta",
    },
    "agent-memory": {
        "dirs": ["agent-memory"],
        "globs": ["**/*.md", "**/*.json", "**/*.jsonl", "**/*.txt"],
        "label": "Agent Memory",
        "color": "bright_magenta",
    },
    "plan": {
        "dirs": ["plans"],
        "globs": ["*.md"],
        "label": "Plan",
        "color": "yellow",
    },
    "agent": {
        "dirs": ["agents"],
        "globs": ["**/*.md"],
        "label": "Agent",
        "color": "green",
    },
}

# Kinds whose files are curated markdown (frontmatter/tags/headings apply).
MARKDOWN_KINDS = {"memory", "project-memory", "plan", "agent"}


# --------------------------------------------------------------------------- #
# Data model
# --------------------------------------------------------------------------- #

@dataclass
class Hit:
    path: Path
    line_number: int
    line_text: str
    kind: str
    submatches: list[tuple[int, int]] = field(default_factory=list)  # char offsets

    id: str = ""
    project_dir: str | None = None
    real_path: str | None = None
    snippet: str | None = None
    epoch: float | None = None
    score: float = 0.0
    tags: list[str] = field(default_factory=list)
    frontmatter: dict = field(default_factory=dict)
    tokens_est: int = 0

    context_before: list[str] = field(default_factory=list)
    context_after: list[str] = field(default_factory=list)


def label_for(kind: str) -> str:
    return KINDS[kind]["label"]


def color_for(kind: str) -> str:
    return KINDS[kind]["color"]


def make_hit_id(path: Path, line_number: int) -> str:
    return hashlib.sha1(f"{path}:{line_number}".encode()).hexdigest()[:8]


# --------------------------------------------------------------------------- #
# Config file
# --------------------------------------------------------------------------- #

def load_config() -> dict:
    cfg_path = Path(os.environ.get(
        "CLAUDE_CONTEXT_CONFIG",
        str(Path.home() / ".config" / "claude-context" / "config.json"),
    )).expanduser()
    if cfg_path.exists():
        try:
            return json.loads(cfg_path.read_text())
        except (OSError, json.JSONDecodeError) as e:
            sys.stderr.write(f"warning: could not read config {cfg_path}: {e}\n")
    return {}


# --------------------------------------------------------------------------- #
# ripgrep driver
# --------------------------------------------------------------------------- #

def _char_offsets(text: str, spans_bytes: list[tuple[int, int]]) -> list[tuple[int, int]]:
    """rg reports byte offsets into the UTF-8 line; convert to char offsets so
    downstream string slicing (which is char-based) lines up correctly."""
    if not spans_bytes:
        return []
    encoded = text.encode("utf-8")
    out = []
    for start, end in spans_bytes:
        start_c = len(encoded[:start].decode("utf-8", errors="ignore"))
        end_c = len(encoded[:end].decode("utf-8", errors="ignore"))
        out.append((start_c, end_c))
    return out


def line_matches_all(line: str, terms: list[str], case_insensitive: bool,
                     fixed: bool) -> bool:
    flags = re.IGNORECASE if case_insensitive else 0
    for t in terms:
        pat = re.escape(t) if fixed else t
        try:
            if not re.search(pat, line, flags):
                return False
        except re.error:
            if t not in line:
                return False
    return True


def run_ripgrep(terms: list[str], kinds: list[str], case_insensitive: bool,
                fixed: bool, context: int, excludes: list[str],
                term_logic: str, debug: bool) -> list[Hit]:
    rg = shutil.which("rg")
    hits: list[Hit] = []

    globs: list[str] = []
    search_dirs: set[str] = set()
    for k in kinds:
        for d in KINDS[k]["dirs"]:
            search_dirs.add(d)
        for g in KINDS[k]["globs"]:
            globs.append(g)

    existing_dirs = [d for d in search_dirs if (CLAUDE_ROOT / d).exists()]
    if not existing_dirs:
        return hits

    if rg:
        cmd = [rg, "--json", "--no-heading"]
        cmd.append("-i" if case_insensitive else "-S")
        if fixed:
            cmd.append("-F")
        if context > 0:
            cmd += ["-C", str(context)]
        for g in globs:
            cmd += ["-g", g]
        for pat in excludes:
            cmd += ["-g", pat if pat.startswith("!") else f"!{pat}"]
        for t in terms:
            cmd += ["-e", t]
        cmd += ["--"] + existing_dirs

        if debug:
            console.print(f"[dim]$ {' '.join(cmd)}[/]")

        proc = subprocess.run(cmd, cwd=CLAUDE_ROOT, capture_output=True, text=True)
        if debug and proc.returncode not in (0, 1):
            console.print(f"[red]rg exited {proc.returncode}:[/] {proc.stderr.strip()}")

        events = []
        for line in proc.stdout.splitlines():
            try:
                events.append(json.loads(line))
            except json.JSONDecodeError:
                continue

        n = len(events)
        for idx, ev in enumerate(events):
            if ev.get("type") != "match":
                continue
            data = ev["data"]
            path = (CLAUDE_ROOT / data["path"]["text"]).resolve()
            text = data["lines"]["text"].rstrip("\n")
            spans_bytes = [(sm["start"], sm["end"]) for sm in data.get("submatches", [])]
            spans = _char_offsets(text, spans_bytes)

            before: list[str] = []
            after: list[str] = []
            if context > 0:
                j = idx - 1
                while j >= 0 and len(before) < context:
                    pv = events[j]
                    if pv.get("type") == "context":
                        before.insert(0, pv["data"]["lines"]["text"].rstrip("\n"))
                    else:
                        break
                    j -= 1
                j = idx + 1
                while j < n and len(after) < context:
                    nv = events[j]
                    if nv.get("type") == "context":
                        after.append(nv["data"]["lines"]["text"].rstrip("\n"))
                    else:
                        break
                    j += 1

            hits.append(Hit(
                path=path,
                line_number=data["line_number"],
                line_text=text,
                kind=classify_path(path),
                submatches=spans,
                context_before=before,
                context_after=after,
            ))
    else:
        hits = python_grep(terms, existing_dirs, globs, case_insensitive, fixed, excludes)

    hits = [h for h in hits if h.kind in kinds]

    if term_logic == "and" and len(terms) > 1:
        hits = [h for h in hits if line_matches_all(h.line_text, terms, case_insensitive, fixed)]

    return hits


def python_grep(terms, dirs, globs, case_insensitive, fixed, excludes) -> list[Hit]:
    """Pure-python fallback if ripgrep is missing. Matches any term (OR);
    AND-filtering, if requested, happens afterward in run_ripgrep."""
    flags = re.IGNORECASE if case_insensitive else 0
    patterns = [re.compile(re.escape(t) if fixed else t, flags) for t in terms]
    hits: list[Hit] = []
    seen: set[Path] = set()
    for d in dirs:
        base = CLAUDE_ROOT / d
        for g in globs:
            for path in base.glob(g):
                if not path.is_file() or path in seen:
                    continue
                rel = str(path.relative_to(CLAUDE_ROOT))
                if any(fnmatch.fnmatch(rel, pat.lstrip("!")) for pat in excludes):
                    continue
                seen.add(path)
                try:
                    with path.open("r", errors="replace") as fh:
                        for i, line in enumerate(fh, 1):
                            for pat in patterns:
                                m = pat.search(line)
                                if m:
                                    hits.append(Hit(
                                        path=path.resolve(),
                                        line_number=i,
                                        line_text=line.rstrip("\n"),
                                        kind=classify_path(path.resolve()),
                                        submatches=[(m.start(), m.end())],
                                    ))
                                    break
                except (OSError, UnicodeError):
                    continue
    return hits


def classify_path(path: Path) -> str:
    """Attribute a file path to a source kind, most-specific first."""
    try:
        rel = path.relative_to(CLAUDE_ROOT)
    except ValueError:
        rel = path
    parts = rel.parts
    if parts and parts[0] == "projects":
        if "memory" in parts:
            return "project-memory"
        if path.suffix == ".jsonl":
            return "conversation"
    if parts and parts[0] == "agent-memory":
        return "agent-memory"
    if parts and parts[0] == "memory":
        return "memory"
    if parts and parts[0] == "plans":
        return "plan"
    if parts and parts[0] == "agents":
        return "agent"
    return "conversation" if path.suffix == ".jsonl" else "memory"


# --------------------------------------------------------------------------- #
# Time filtering / sorting
# --------------------------------------------------------------------------- #

_RELATIVE_RE = re.compile(r"^(\d+)([hdwmy])$")
_FILENAME_DATE_RE = re.compile(r"(\d{4}-\d{2}-\d{2})")


def parse_time_bound(s: str) -> float:
    m = _RELATIVE_RE.match(s.strip())
    if m:
        n, unit = int(m.group(1)), m.group(2)
        secs = {"h": 3600, "d": 86400, "w": 604800,
                "m": 2592000, "y": 31536000}[unit] * n
        return datetime.now().timestamp() - secs
    try:
        return datetime.fromisoformat(s).timestamp()
    except ValueError:
        raise ValueError(f"could not parse time '{s}' (use ISO date or e.g. 3d, 12h, 2w)")


def filename_date(path: Path) -> float | None:
    m = _FILENAME_DATE_RE.search(path.name)
    if m:
        try:
            return datetime.fromisoformat(m.group(1)).timestamp()
        except ValueError:
            return None
    return None


def hit_epoch(hit: Hit) -> float | None:
    """Best-effort timestamp: conversation event timestamp > frontmatter date >
    filename date > file mtime."""
    if hit.kind == "conversation":
        try:
            obj = json.loads(hit.line_text)
            ts = obj.get("timestamp")
            if ts:
                return datetime.fromisoformat(ts.replace("Z", "+00:00")).timestamp()
        except Exception:
            pass
    if hit.path.suffix == ".md":
        fm = parse_frontmatter(hit.path)
        d = fm.get("date")
        if d:
            try:
                return datetime.fromisoformat(str(d)).timestamp()
            except ValueError:
                pass
        fd = filename_date(hit.path)
        if fd:
            return fd
    try:
        return hit.path.stat().st_mtime
    except OSError:
        return None


# --------------------------------------------------------------------------- #
# Frontmatter / headings (for memory-ish markdown files)
# --------------------------------------------------------------------------- #

_FRONTMATTER_CACHE: dict[Path, dict] = {}


def parse_frontmatter(path: Path) -> dict:
    """Best-effort YAML-ish frontmatter parser — no PyYAML dependency.
    Handles `key: value`, `key: [a, b]`, and block lists (`- item`)."""
    if path in _FRONTMATTER_CACHE:
        return _FRONTMATTER_CACHE[path]
    fm: dict = {}
    try:
        text = path.read_text(errors="replace")
    except OSError:
        _FRONTMATTER_CACHE[path] = fm
        return fm
    if text.startswith("---"):
        lines = text.splitlines()
        end = None
        for i in range(1, len(lines)):
            if lines[i].strip() == "---":
                end = i
                break
        if end:
            key = None
            for ln in lines[1:end]:
                m = re.match(r"^(\w[\w\-]*):\s*(.*)$", ln)
                if m:
                    key, val = m.group(1), m.group(2).strip()
                    if val.startswith("[") and val.endswith("]"):
                        fm[key] = [v.strip().strip("'\"") for v in val[1:-1].split(",") if v.strip()]
                    elif val == "":
                        fm[key] = []
                    else:
                        fm[key] = val.strip("'\"")
                elif key and re.match(r"^\s*-\s+", ln):
                    item = re.sub(r"^\s*-\s+", "", ln).strip().strip("'\"")
                    if isinstance(fm.get(key), list):
                        fm[key].append(item)
                    else:
                        fm[key] = [item]
    _FRONTMATTER_CACHE[path] = fm
    return fm


def frontmatter_tags(fm: dict) -> list[str]:
    tags = fm.get("tags", [])
    if isinstance(tags, str):
        return [t.strip() for t in tags.split(",") if t.strip()]
    if isinstance(tags, list):
        return [str(t).strip() for t in tags if str(t).strip()]
    return []


def first_heading(path: Path) -> str | None:
    try:
        for line in path.read_text(errors="replace").splitlines():
            s = line.strip()
            if s.startswith("#"):
                return s.lstrip("#").strip()
    except OSError:
        pass
    return None


# --------------------------------------------------------------------------- #
# Enrichment — figure out the real project path, tags, snippet, token cost.
# --------------------------------------------------------------------------- #

def encoded_project_dir(path: Path) -> str | None:
    try:
        rel = path.relative_to(CLAUDE_ROOT / "projects")
    except ValueError:
        return None
    return rel.parts[0] if rel.parts else None


def real_path_from_jsonl_line(line_text: str) -> str | None:
    try:
        obj = json.loads(line_text)
    except json.JSONDecodeError:
        return None
    if obj.get("cwd"):
        return obj["cwd"]
    att = obj.get("attachment")
    if isinstance(att, dict):
        return att.get("cwd")
    return None


def decode_project_dir(encoded: str) -> str:
    """Lossy fallback decode; callers should validate existence before trusting."""
    return "/" + encoded.lstrip("-").replace("-", "/")


_cwd_cache: dict[Path, str | None] = {}
_cwd_cache_lock = threading.Lock()


def peek_cwd(path: Path) -> str | None:
    if path.suffix == ".jsonl":
        proj_root = path.parent
        candidates = [path]
    else:
        proj_root = path
        while proj_root.parent != (CLAUDE_ROOT / "projects") and \
                proj_root.parent != proj_root:
            proj_root = proj_root.parent
        candidates = sorted(proj_root.glob("*.jsonl"))

    with _cwd_cache_lock:
        if proj_root in _cwd_cache:
            return _cwd_cache[proj_root]

    result = None
    for cand in candidates:
        try:
            with cand.open("r", errors="replace") as fh:
                for line in fh:
                    try:
                        obj = json.loads(line)
                    except json.JSONDecodeError:
                        continue
                    if obj.get("cwd"):
                        result = obj["cwd"]
                        break
        except OSError:
            continue
        if result:
            break

    with _cwd_cache_lock:
        _cwd_cache[proj_root] = result
    return result


def enrich(hit: Hit) -> None:
    hit.project_dir = encoded_project_dir(hit.path)

    if hit.kind in ("conversation", "project-memory"):
        real = None
        if hit.kind == "conversation":
            real = real_path_from_jsonl_line(hit.line_text)
        if not real and hit.project_dir:
            real = peek_cwd(hit.path)
        if not real and hit.project_dir:
            guess = decode_project_dir(hit.project_dir)
            real = guess if Path(guess).exists() else f"{guess} (unverified)"
        hit.real_path = real
    else:
        hit.real_path = str(hit.path)

    if hit.path.suffix == ".md":
        hit.frontmatter = parse_frontmatter(hit.path)
        hit.tags = frontmatter_tags(hit.frontmatter)

    hit.snippet = build_snippet(hit)
    hit.tokens_est = max(1, len(hit.snippet or "") // 4)


def enrich_all(hits: list[Hit], workers: int = 8) -> None:
    if not hits:
        return
    with ThreadPoolExecutor(max_workers=workers) as ex:
        list(ex.map(enrich, hits))


def build_snippet(hit: Hit) -> str:
    if hit.kind == "conversation":
        return conversation_snippet(hit)
    text = hit.line_text.strip()
    return _center_on_match(text, hit)


def _center_on_match(text: str, hit: Hit, width: int = 200) -> str:
    if not hit.submatches:
        return text[:width]
    start = hit.submatches[0][0]
    lo = max(0, start - width // 2)
    hi = min(len(text), lo + width)
    prefix = "…" if lo > 0 else ""
    suffix = "…" if hi < len(text) else ""
    return f"{prefix}{text[lo:hi]}{suffix}"


def conversation_snippet(hit: Hit) -> str:
    try:
        obj = json.loads(hit.line_text)
    except json.JSONDecodeError:
        return _center_on_match(hit.line_text, hit)

    msg = obj.get("message")
    role = obj.get("type", "?")
    text = extract_text(msg) if msg is not None else ""
    if not text:
        att = obj.get("attachment")
        if isinstance(att, dict):
            text = att.get("stdout") or att.get("content") or \
                att.get("command") or json.dumps(att)[:200]
    if not text:
        text = _center_on_match(hit.line_text, hit)
    text = _stringify(text)
    return f"[{role}] {text.strip()[:400]}"

def _stringify(value) -> str:
    """Coerce a snippet candidate (which may be a dict/list from a tool
    attachment) into displayable text."""
    if isinstance(value, str):
        return value
    if value is None:
        return ""
    try:
        return json.dumps(value, ensure_ascii=False)[:400]
    except (TypeError, ValueError):
        return str(value)[:400]

def extract_text(msg) -> str:
    if isinstance(msg, str):
        return msg
    if isinstance(msg, dict):
        content = msg.get("content")
        if isinstance(content, str):
            return content
        if isinstance(content, list):
            parts = []
            for block in content:
                if not isinstance(block, dict):
                    continue
                bt = block.get("type")
                if bt in ("text", "thinking"):
                    val = block.get("text") or block.get("thinking", "")
                    parts.append(_stringify(val))
                elif bt == "tool_use":
                    inp = block.get("input", {})
                    parts.append(f"[tool:{block.get('name')}] {json.dumps(inp)[:200]}")
                elif bt == "tool_result":
                    c = block.get("content")
                    parts.append(f"[tool_result] {extract_text({'content': c})}")
            return "\n".join(p for p in parts if p)
    return ""


# --------------------------------------------------------------------------- #
# Relevance scoring
# --------------------------------------------------------------------------- #

_KIND_WEIGHT = {
    "memory": 1.5, "project-memory": 1.4, "agent-memory": 1.3,
    "plan": 1.2, "agent": 1.1, "conversation": 1.0,
}


def compute_score(hit: Hit, terms: list[str], case_insensitive: bool, fixed: bool) -> float:
    flags = re.IGNORECASE if case_insensitive else 0
    freq = 0
    for t in terms:
        pat = re.escape(t) if fixed else t
        try:
            freq += len(re.findall(pat, hit.line_text, flags))
        except re.error:
            freq += hit.line_text.lower().count(t.lower())
    freq = max(freq, 1)
    kind_weight = _KIND_WEIGHT.get(hit.kind, 1.0)
    recency_weight = 1.0
    if hit.epoch:
        age_days = max(0.0, (datetime.now().timestamp() - hit.epoch) / 86400.0)
        recency_weight = 1.0 / (1.0 + age_days / 30.0)
    tag_bonus = 1.1 if hit.tags else 1.0
    return round(freq * kind_weight * (0.5 + recency_weight) * tag_bonus, 3)


# --------------------------------------------------------------------------- #
# Dedup near-identical memories
# --------------------------------------------------------------------------- #

def normalize_for_dedup(text: str) -> str:
    return re.sub(r"\s+", " ", text.strip().lower())


def dedup_hits(hits: list[Hit]) -> tuple[list[Hit], dict[str, list[Hit]]]:
    """Collapse hits whose snippet is effectively identical (same lesson
    copy-pasted into multiple files). Returns (deduped, {primary_id: [dupes]})."""
    seen: dict[str, Hit] = {}
    dupes: dict[str, list[Hit]] = {}
    order: list[Hit] = []
    for h in hits:
        key = normalize_for_dedup(h.snippet or h.line_text)
        if key in seen:
            dupes.setdefault(seen[key].id, []).append(h)
        else:
            seen[key] = h
            order.append(h)
    return order, dupes


# --------------------------------------------------------------------------- #
# Token-budget helper
# --------------------------------------------------------------------------- #

def apply_budget(hits: list[Hit], budget: int | None) -> tuple[list[Hit], bool]:
    if not budget:
        return hits, False
    out: list[Hit] = []
    total = 0
    truncated = False
    for h in hits:
        cost = h.tokens_est or 1
        if total + cost > budget and out:
            truncated = True
            break
        out.append(h)
        total += cost
    return out, truncated


# --------------------------------------------------------------------------- #
# Keyword extraction for --related / auto-suggest
# --------------------------------------------------------------------------- #

STOPWORDS = {
    "the", "a", "an", "and", "or", "but", "if", "then", "else", "for", "of", "to",
    "in", "on", "at", "by", "with", "is", "was", "were", "are", "be", "been",
    "being", "this", "that", "these", "those", "it", "its", "as", "from", "we",
    "you", "i", "they", "he", "she", "them", "our", "your", "their", "not", "no",
    "yes", "do", "does", "did", "have", "has", "had", "will", "would", "could",
    "should", "can", "may", "might", "must", "about", "into", "over", "after",
    "before", "between", "through", "during", "above", "below", "up", "down",
    "out", "off", "again", "further", "than", "so", "just", "also", "because",
    "while", "when", "where", "how", "what", "which", "who", "whom", "there",
    "here", "all", "each", "few", "more", "most", "other", "some", "such",
    "only", "own", "same", "too", "very", "now", "don",
}


def extract_keywords(text: str, top_n: int = 8) -> list[str]:
    words = re.findall(r"[A-Za-z][A-Za-z0-9_\-]{2,}", text.lower())
    freq: dict[str, int] = {}
    for w in words:
        if w in STOPWORDS:
            continue
        freq[w] = freq.get(w, 0) + 1
    ranked = sorted(freq.items(), key=lambda kv: (-kv[1], kv[0]))
    return [w for w, _ in ranked[:top_n]]


def build_vocab(kinds: list[str]) -> list[str]:
    vocab: set[str] = set()
    for k in kinds:
        if k not in MARKDOWN_KINDS and k != "agent-memory":
            continue
        info = KINDS[k]
        for d in info["dirs"]:
            base = CLAUDE_ROOT / d
            if not base.exists():
                continue
            for g in info["globs"]:
                if not g.endswith(".md"):
                    continue
                for path in base.glob(g):
                    if not path.is_file():
                        continue
                    vocab.add(path.stem.replace("-", " ").replace("_", " "))
                    h = first_heading(path)
                    if h:
                        vocab.add(h)
                    for t in frontmatter_tags(parse_frontmatter(path)):
                        vocab.add(t)
    return sorted(vocab)


def suggest_alternatives(term: str, kinds: list[str]) -> list[str]:
    vocab = build_vocab(kinds)
    words: set[str] = set(vocab)
    for entry in vocab:
        words.update(entry.split())
    return difflib.get_close_matches(term, list(words), n=3, cutoff=0.6)


# --------------------------------------------------------------------------- #
# Markdown section extraction (--section / expand)
# --------------------------------------------------------------------------- #

def markdown_section(path: Path, line_number: int) -> str | None:
    try:
        lines = path.read_text(errors="replace").splitlines()
    except OSError:
        return None
    idx = line_number - 1
    if idx < 0 or idx >= len(lines):
        return None

    def heading_level(s: str) -> int | None:
        s2 = s.lstrip()
        if s2.startswith("#"):
            n = len(s2) - len(s2.lstrip("#"))
            if 1 <= n <= 6 and (len(s2) == n or s2[n] == " "):
                return n
        return None

    start = idx
    section_level = None
    while start >= 0:
        lvl = heading_level(lines[start])
        if lvl is not None:
            section_level = lvl
            break
        start -= 1
    if start < 0:
        start = 0

    end = idx + 1
    while end < len(lines):
        lvl = heading_level(lines[end])
        if lvl is not None and section_level is not None and lvl <= section_level:
            break
        end += 1
    return "\n".join(lines[start:end]).strip()


# --------------------------------------------------------------------------- #
# Cache (for --expand / --related) + machine-readable serialization
# --------------------------------------------------------------------------- #

def hit_to_dict(hit: Hit) -> dict:
    return {
        "id": hit.id,
        "kind": hit.kind,
        "label": label_for(hit.kind),
        "path": str(hit.path),
        "real_path": hit.real_path,
        "project_dir": hit.project_dir,
        "line": hit.line_number,
        "snippet": hit.snippet,
        "score": hit.score,
        "tags": hit.tags,
        "epoch": hit.epoch,
        "date": datetime.fromtimestamp(hit.epoch).isoformat() if hit.epoch else None,
        "tokens_est": hit.tokens_est,
    }


def save_cache(hits: list[Hit], terms: list[str]) -> None:
    try:
        CACHE_DIR.mkdir(parents=True, exist_ok=True)
        payload = {
            "terms": terms,
            "root": str(CLAUDE_ROOT),
            "timestamp": datetime.now().isoformat(),
            "hits": [{**hit_to_dict(h), "index": i} for i, h in enumerate(hits, 1)],
        }
        CACHE_FILE.write_text(json.dumps(payload, ensure_ascii=False))
    except OSError:
        pass


def load_cache() -> dict | None:
    try:
        return json.loads(CACHE_FILE.read_text())
    except (OSError, json.JSONDecodeError):
        return None


def render_machine(hits: list[Hit], fmt: str) -> None:
    if fmt == "json":
        print(json.dumps({"count": len(hits), "hits": [hit_to_dict(h) for h in hits]},
                         indent=2, ensure_ascii=False))
    elif fmt == "jsonl":
        for h in hits:
            print(json.dumps(hit_to_dict(h), ensure_ascii=False))
    elif fmt == "compact":
        for i, h in enumerate(hits, 1):
            loc = h.real_path if h.kind in ("conversation", "project-memory") else str(h.path)
            snip = (h.snippet or "").replace("\n", " ")[:120]
            print(f"[{i}] id={h.id} score={h.score:g} {label_for(h.kind):<14} "
                  f"{loc}:{h.line_number}  {snip}")


def render_paths_only(hits: list[Hit]) -> None:
    seen: list[str] = []
    for h in hits:
        p = h.real_path or str(h.path)
        if p not in seen:
            seen.append(p)
    for p in seen:
        print(p)


# --------------------------------------------------------------------------- #
# --expand — re-hydrate one cached hit into full detail, cheaply
# --------------------------------------------------------------------------- #

def expand_content(path: Path, line_number: int, kind: str, context: int) -> str:
    if path.suffix == ".md":
        section = markdown_section(path, line_number)
        if section:
            return section
    try:
        lines = path.read_text(errors="replace").splitlines()
    except OSError:
        return ""
    if kind == "conversation" and 0 < line_number <= len(lines):
        try:
            obj = json.loads(lines[line_number - 1])
            return json.dumps(obj, ensure_ascii=False)
        except json.JSONDecodeError:
            pass
    lo = max(0, line_number - 1 - context)
    hi = min(len(lines), line_number + context)
    return "\n".join(lines[lo:hi])


def do_expand(ref: str, context: int, fmt: str) -> int:
    cache = load_cache()
    if not cache:
        console.print("[red]No cached search results.[/] Run a search first.")
        return 2
    match = None
    for h in cache["hits"]:
        if str(h["index"]) == str(ref) or h["id"] == ref:
            match = h
            break
    if not match:
        console.print(f"[red]No cached hit matching[/] '{ref}'")
        return 2

    path = Path(match["path"])
    line_number = match["line"]
    kind = match["kind"]
    content = expand_content(path, line_number, kind, max(context, 3))

    is_json = False
    if kind == "conversation":
        try:
            json.loads(content)
            is_json = True
        except json.JSONDecodeError:
            is_json = False

    if fmt != "rich":
        payload = dict(match)
        payload["content"] = content
        print(json.dumps(payload, indent=2 if fmt == "json" else None, ensure_ascii=False))
        return 0

    console.print(Rule(f"Expanding [{match['index']}] {label_for(kind)}"))
    meta = Table.grid(padding=(0, 2))
    meta.add_column(style="bold", justify="right")
    meta.add_column(overflow="fold")
    if match.get("real_path"):
        meta.add_row("Real path", Text(match["real_path"], style="green underline"))
    meta.add_row("File", Text(str(path), style="dim"))
    meta.add_row("Line", str(line_number))
    if match.get("tags"):
        meta.add_row("Tags", ", ".join(match["tags"]))
    if match.get("date"):
        meta.add_row("When", match["date"])
    if match.get("score") is not None:
        meta.add_row("Score", f"{match['score']:g}")
    console.print(meta)

    if is_json:
        syn = Syntax(json.dumps(json.loads(content), indent=2, ensure_ascii=False),
                     "json", theme="ansi_dark", word_wrap=True, background_color="default")
        console.print(Panel(syn, title="JSON line", border_style="cyan"))
    elif path.suffix == ".md":
        console.print(Panel(Markdown(content), title="Section", border_style=color_for(kind)))
    else:
        console.print(Panel(content, border_style=color_for(kind)))
    return 0


# --------------------------------------------------------------------------- #
# --related — find similar content without knowing the exact wording
# --------------------------------------------------------------------------- #

def resolve_related_target(ref: str) -> tuple[Path, int, str] | None:
    cache = load_cache()
    if cache:
        for h in cache["hits"]:
            if str(h["index"]) == str(ref) or h["id"] == ref:
                return Path(h["path"]), h["line"], h["kind"]
    p = Path(ref).expanduser()
    if not p.is_absolute():
        p = (CLAUDE_ROOT / ref).resolve()
    if p.exists():
        return p, 1, classify_path(p)
    return None


def do_related(ref: str, kinds: list[str], case_insensitive: bool, fixed: bool,
               context: int, excludes: list[str], debug: bool) -> tuple[list[Hit], list[str]]:
    target = resolve_related_target(ref)
    if not target:
        console.print(f"[red]Could not resolve --related target:[/] {ref}")
        return [], []
    path, line_number, kind = target
    try:
        text = path.read_text(errors="replace")
    except OSError as e:
        console.print(f"[red]Could not read {path}:[/] {e}")
        return [], []

    if path.suffix == ".jsonl":
        lines = text.splitlines()
        idx = max(0, min(line_number - 1, len(lines) - 1)) if lines else 0
        try:
            obj = json.loads(lines[idx])
            text = extract_text(obj.get("message")) or text
        except (json.JSONDecodeError, IndexError):
            pass

    keywords = extract_keywords(text)
    if not keywords:
        console.print("[yellow]Could not extract keywords from target.[/]")
        return [], []

    console.print(f"[dim]Related keywords:[/] {', '.join(keywords)}")
    hits = run_ripgrep(keywords, kinds, case_insensitive, fixed, context,
                       excludes, "or", debug)
    hits = [h for h in hits if h.path.resolve() != path.resolve()]
    return hits, keywords


# --------------------------------------------------------------------------- #
# --list — browse memories/plans/agents without searching
# --------------------------------------------------------------------------- #

def do_list(kinds: list[str], tags_filter: list[str] | None, fmt: str,
            sort: str, term: str | None) -> int:
    entries = []
    for k in kinds:
        info = KINDS[k]
        for d in info["dirs"]:
            base = CLAUDE_ROOT / d
            if not base.exists():
                continue
            for g in info["globs"]:
                for path in base.glob(g):
                    if not path.is_file() or classify_path(path.resolve()) != k:
                        continue
                    fm = parse_frontmatter(path) if path.suffix == ".md" else {}
                    tags = frontmatter_tags(fm)
                    if tags_filter and not (set(tags) & set(tags_filter)):
                        continue
                    title = fm.get("title") or \
                        (first_heading(path) if path.suffix == ".md" else None) or path.stem
                    if term:
                        haystack = f"{title} {path} {' '.join(tags)}".lower()
                        if term.lower() not in haystack:
                            continue
                    try:
                        size = path.stat().st_size
                        mtime = path.stat().st_mtime
                    except OSError:
                        size, mtime = 0, None
                    epoch = None
                    if fm.get("date"):
                        try:
                            epoch = datetime.fromisoformat(str(fm["date"])).timestamp()
                        except ValueError:
                            epoch = None
                    epoch = epoch or filename_date(path) or mtime
                    entries.append({
                        "kind": k, "path": str(path), "title": title, "tags": tags,
                        "date": datetime.fromtimestamp(epoch).isoformat() if epoch else None,
                        "epoch": epoch, "size": size, "tokens_est": max(1, size // 4),
                    })

    entries.sort(key=lambda e: (e["epoch"] or 0), reverse=True) if sort == "recent" \
        else entries.sort(key=lambda e: e["title"].lower())

    if fmt == "json":
        print(json.dumps({"count": len(entries), "entries": entries}, indent=2, ensure_ascii=False))
        return 0 if entries else 1
    if fmt == "jsonl":
        for e in entries:
            print(json.dumps(e, ensure_ascii=False))
        return 0 if entries else 1
    if fmt == "compact":
        for e in entries:
            tags = ",".join(e["tags"]) if e["tags"] else "-"
            print(f"{label_for(e['kind']):<14} {e['path']}  [{tags}]  {e['title']}")
        return 0 if entries else 1

    if not entries:
        console.print("[dim]No entries found.[/]")
        return 1
    table = Table(title=f"{len(entries)} entries")
    table.add_column("Kind", style="bold")
    table.add_column("Title")
    table.add_column("Tags", style="dim")
    table.add_column("Date", style="dim")
    table.add_column("~Tokens", justify="right", style="dim")
    table.add_column("Path", overflow="fold", style="dim")
    for e in entries:
        table.add_row(
            Text(label_for(e["kind"]), style=color_for(e["kind"])),
            e["title"], ", ".join(e["tags"]) or "—",
            (e["date"] or "—")[:10], str(e["tokens_est"]), e["path"],
        )
    console.print(table)
    return 0


# --------------------------------------------------------------------------- #
# Grouping / sorting shared by summary, recall, and --open
# --------------------------------------------------------------------------- #

def group_hits(hits: list[Hit]) -> dict[str, list[Hit]]:
    groups: dict[str, list[Hit]] = {}
    for h in hits:
        if h.kind in ("plan", "agent", "memory", "agent-memory"):
            key = f"(global) {label_for(h.kind)}"
        else:
            key = h.real_path or (h.project_dir or "(unknown)")
        groups.setdefault(key, []).append(h)
    return groups


def build_recall_rows(hits: list[Hit]) -> list[dict]:
    """Group hits by project/location, pick the best-scoring hit per group,
    and return a ranked list of {location, kind, best_hit, hit_count,
    other_ids} dicts. Shared by the rich table and --format json/jsonl/compact
    so every output mode surfaces the same grouped-and-ranked structure
    instead of a flat, ungrouped hit list."""
    groups = group_hits(hits)
    rows = []
    for key, ghits in groups.items():
        best = max(ghits, key=lambda h: h.score)
        other_ids = [h.id for h in ghits if h.id != best.id]
        rows.append({
            "location": key,
            "kind": best.kind,
            "label": label_for(best.kind),
            "best_hit": hit_to_dict(best),
            "hit_count": len(ghits),
            "other_ids": other_ids,
        })
    rows.sort(key=lambda r: r["best_hit"]["score"], reverse=True)
    return rows


def sorted_group_keys(groups: dict[str, list[Hit]], sort: str) -> list[str]:
    if sort == "recent":
        return sorted(groups, key=lambda k: max((h.epoch or 0) for h in groups[k]), reverse=True)
    if sort == "score":
        return sorted(groups, key=lambda k: max((h.score or 0) for h in groups[k]), reverse=True)
    return sorted(groups, key=lambda k: -len(groups[k]))


def best_target(hits: list[Hit], sort: str) -> str | None:
    candidates = [h for h in hits if h.kind in ("conversation", "project-memory") and h.real_path]
    if not candidates:
        candidates = [h for h in hits if h.real_path]
    if not candidates:
        return None
    if sort == "recent":
        candidates.sort(key=lambda h: h.epoch or 0, reverse=True)
        return candidates[0].real_path
    if sort == "score":
        candidates.sort(key=lambda h: h.score or 0, reverse=True)
        return candidates[0].real_path
    counts: dict[str, int] = {}
    for h in candidates:
        counts[h.real_path] = counts.get(h.real_path, 0) + 1
    candidates.sort(key=lambda h: counts[h.real_path], reverse=True)
    return candidates[0].real_path


# --------------------------------------------------------------------------- #
# Rendering — rich output
# --------------------------------------------------------------------------- #

def highlight(text: str, terms: list[str], case_insensitive: bool = True) -> Text:
    t = Text(text)
    t.highlight_words(terms, "bold black on yellow", case_sensitive=not case_insensitive)
    return t


def project_display(hit: Hit) -> tuple[str, str]:
    return hit.project_dir or "—", hit.real_path or str(hit.path)


def render_summary(hits: list[Hit], terms: list[str], sort: str,
                   dupes: dict[str, list[Hit]] | None = None, desc: str | None = None) -> None:
    dupes = dupes or {}
    label = desc or (" AND ".join(terms) if len(terms) > 1 else terms[0])
    if not hits:
        console.print(f"[dim]No matches for[/] [bold]{label}[/]")
        return

    groups = group_hits(hits)
    console.print(Rule(f"[bold]{len(hits)}[/] matches for [bold yellow]{label}[/] across "
                       f"[bold]{len(groups)}[/] locations "
                       f"[dim](pass an id to --expand for full detail)[/]"))

    for key in sorted_group_keys(groups, sort):
        ghits = groups[key]
        first = ghits[0]
        enc = first.project_dir
        color = color_for(first.kind)

        header = Text()
        if first.kind in ("conversation", "project-memory"):
            header.append("Found in Project: ", style="bold")
            header.append(f"{enc or '?'}\n", style=f"bold {color}")
            header.append("Path: ", style="bold")
            header.append(str(key), style="bold green underline")
        else:
            header.append(f"Found in {label_for(first.kind)}\n", style="bold")
            header.append(str(first.path.parent), style="green")

        body = Table.grid(padding=(0, 1))
        body.add_column(justify="right", style="dim", no_wrap=True)
        body.add_column(overflow="fold")

        shown = ghits[:6]
        for h in shown:
            fname = h.path.name
            body.add_row(f"{label_for(h.kind)} (id {h.id}):",
                         Text(fname, style=color_for(h.kind)))
            body.add_row(f"(line {h.line_number}, score {h.score:g})",
                         highlight(h.snippet or "", terms))
            if h.id in dupes:
                body.add_row("", Text(f"(also appears in {len(dupes[h.id])} other location(s))",
                                      style="dim italic"))
        if len(ghits) > len(shown):
            body.add_row("", Text(f"… and {len(ghits) - len(shown)} more hits", style="dim italic"))

        console.print(Panel(body, title=header, title_align="left", border_style=color, padding=(0, 1)))


def render_verbose(hits: list[Hit], terms: list[str], show_section: bool,
                   show_json: bool, show_context: bool) -> None:
    for i, h in enumerate(hits, 1):
        enc, real = project_display(h)
        color = color_for(h.kind)

        head = Text()
        head.append(f"[{i}/{len(hits)}] id={h.id} ", style="dim")
        head.append(f"{label_for(h.kind)}", style=f"bold {color}")
        console.print(Rule(head))

        meta = Table.grid(padding=(0, 2))
        meta.add_column(style="bold", justify="right")
        meta.add_column(overflow="fold")
        if h.kind in ("conversation", "project-memory"):
            meta.add_row("Project", Text(enc, style=color))
            meta.add_row("Real path", Text(real, style="green underline"))
        meta.add_row("File", Text(str(h.path), style="dim"))
        meta.add_row("Line", str(h.line_number))
        meta.add_row("Score", f"{h.score:g}")
        meta.add_row("~Tokens", str(h.tokens_est))
        if h.tags:
            meta.add_row("Tags", ", ".join(h.tags))
        if h.epoch:
            meta.add_row("When", datetime.fromtimestamp(h.epoch).strftime("%Y-%m-%d %H:%M"))
        console.print(meta)

        if show_json and h.kind == "conversation":
            try:
                obj = json.loads(h.line_text)
                syn = Syntax(json.dumps(obj, indent=2, ensure_ascii=False), "json",
                             theme="ansi_dark", word_wrap=True, background_color="default")
                console.print(Panel(syn, title="JSON line", border_style="cyan"))
                continue
            except json.JSONDecodeError:
                pass

        if show_section and h.path.suffix == ".md":
            section = markdown_section(h.path, h.line_number)
            if section:
                console.print(Panel(Markdown(section), title="Section", border_style=color))
                continue

        if show_context and (h.context_before or h.context_after):
            ctx = Table.grid(padding=(0, 1))
            ctx.add_column()
            for line in h.context_before:
                ctx.add_row(Text(line, style="dim"))
            ctx.add_row(highlight(h.snippet or "", terms))
            for line in h.context_after:
                ctx.add_row(Text(line, style="dim"))
            console.print(Panel(ctx, border_style=color))
        else:
            console.print(Panel(highlight(h.snippet or "", terms), border_style=color))


def render_stats(hits: list[Hit]) -> None:
    if not hits:
        console.print("[dim]No matches.[/]")
        return
    by_kind: dict[str, int] = {}
    by_project: dict[str, int] = {}
    for h in hits:
        by_kind[h.kind] = by_kind.get(h.kind, 0) + 1
        key = h.real_path if h.kind in ("conversation", "project-memory") else f"(global) {label_for(h.kind)}"
        by_project[key or "(unknown)"] = by_project.get(key or "(unknown)", 0) + 1

    console.print(Rule(f"[bold]{len(hits)}[/] total matches"))
    t1 = Table(title="By kind")
    t1.add_column("Kind")
    t1.add_column("Hits", justify="right")
    for k, c in sorted(by_kind.items(), key=lambda kv: -kv[1]):
        t1.add_row(Text(label_for(k), style=color_for(k)), str(c))
    console.print(t1)

    t2 = Table(title="By project/location")
    t2.add_column("Location", overflow="fold")
    t2.add_column("Hits", justify="right")
    for loc, c in sorted(by_project.items(), key=lambda kv: -kv[1])[:20]:
        t2.add_row(loc, str(c))
    console.print(t2)


def render_recall(hits: list[Hit], terms: list[str], desc: str | None = None) -> None:
    """Cross-project comparison view — 'where have I dealt with this before?'"""
    label = desc or (" ".join(terms))
    if not hits:
        console.print(f"[dim]No matches for[/] {label}")
        return
    rows = build_recall_rows(hits)

    table = Table(title=f"Recall: {label} — {len(rows)} location(s)")
    table.add_column("Id", style="dim")
    table.add_column("Project/Location", overflow="fold")
    table.add_column("Kind")
    table.add_column("Date", style="dim")
    table.add_column("Score", justify="right")
    table.add_column("Hits", justify="right")
    table.add_column("Takeaway", overflow="fold")
    for row in rows:
        best = row["best_hit"]
        date = (best["date"] or "—")[:10]
        table.add_row(
            best["id"], str(row["location"]),
            Text(row["label"], style=color_for(row["kind"])),
            date, f"{best['score']:g}", str(row["hit_count"]),
            (best["snippet"] or "")[:140],
        )
    console.print(table)
    console.print("[dim]Use --expand <id> for full detail, or --related <id> to dig deeper.[/]")


def render_recall_machine(hits: list[Hit], terms: list[str], fmt: str,
                          desc: str | None = None) -> None:
    """--recall counterpart to render_machine — emits the grouped-by-location,
    ranked-by-score structure (not a flat hit list) for json/jsonl/compact."""
    rows = build_recall_rows(hits)
    label = desc or (" ".join(terms))
    if fmt == "json":
        print(json.dumps({
            "query": label,
            "location_count": len(rows),
            "hit_count": len(hits),
            "locations": rows,
        }, indent=2, ensure_ascii=False))
    elif fmt == "jsonl":
        for row in rows:
            print(json.dumps(row, ensure_ascii=False))
    elif fmt == "compact":
        for row in rows:
            best = row["best_hit"]
            snippet = (best["snippet"] or "").replace("\n", " ")[:100]
            print(f"id={best['id']} score={best['score']:g} "
                  f"hits={row['hit_count']:<3} {row['label']:<14} "
                  f"{row['location']}  {snippet}")


# --------------------------------------------------------------------------- #
# --open support
# --------------------------------------------------------------------------- #

def open_in_editor(path: str) -> None:
    editor = os.environ.get("EDITOR") or shutil.which("code") or shutil.which("subl")
    if not editor:
        console.print("[red]No editor found.[/] Set $EDITOR or install VSCode's 'code' CLI.")
        return
    try:
        subprocess.run([editor, path])
    except OSError as e:
        console.print(f"[red]Failed to open editor:[/] {e}")


# --------------------------------------------------------------------------- #
# CLI
# --------------------------------------------------------------------------- #

def main(argv=None) -> int:
    p = argparse.ArgumentParser(
        prog="claude-context",
        description="Search ~/.claude and find the project + real path for a "
                    "conversation, plan, agent, or memory.",
    )
    p.add_argument("term", nargs="?", help="text or regex to search for")
    p.add_argument("-e", "--extra-term", action="append",
                   help="additional term to search for (repeatable)")
    p.add_argument("--term-logic", choices=["and", "or"], default=None,
                   help="how multiple terms combine (default: and)")
    p.add_argument("-v", "--verbose", action="store_true",
                   help="show every hit with full detail")
    p.add_argument("-s", "--section", action="store_true",
                   help="for markdown hits, render the whole enclosing section")
    p.add_argument("-j", "--json", action="store_true",
                   help="for conversation hits, pretty-print the JSON line")
    p.add_argument("-i", "--ignore-case", action="store_true",
                   help="case-insensitive (default: smart case)")
    p.add_argument("-F", "--fixed", action="store_true",
                   help="treat term as a literal string, not a regex")
    p.add_argument("-k", "--kind", action="append", choices=list(KINDS),
                   help="restrict to one or more source kinds (repeatable)")
    p.add_argument("-C", "--context", type=int, default=None,
                   help="show N lines of context around each hit")
    p.add_argument("--since", help="only hits at/after this time (e.g. 2026-07-01, 3d, 12h)")
    p.add_argument("--before", help="only hits before this time")
    p.add_argument("-n", "--max-results", type=int, default=None,
                   help="cap the number of hits processed/shown")
    p.add_argument("--sort", choices=["count", "recent", "score"], default=None,
                   help="group ordering (default: score)")
    p.add_argument("-l", "--paths-only", action="store_true",
                   help="print matching real paths only, one per line (for piping)")
    p.add_argument("-o", "--open", action="store_true",
                   help="open the best-matching project/file in your editor")
    p.add_argument("-x", "--exclude", action="append",
                   help="glob pattern to exclude (repeatable)")
    p.add_argument("--root", help="override CLAUDE_ROOT")
    p.add_argument("--debug", action="store_true",
                   help="print the underlying ripgrep command")
    p.add_argument("--format", choices=["rich", "json", "jsonl", "compact"], default=None,
                   help="output format — use json/jsonl/compact for LLM/tool consumption")
    p.add_argument("--expand", metavar="ID|INDEX",
                   help="re-hydrate one hit from the last search into full detail")
    p.add_argument("--list", action="store_true",
                   help="browse memories/plans/agents without a search term")
    p.add_argument("--tag", action="append",
                   help="filter to hits/entries with this frontmatter tag (repeatable)")
    p.add_argument("--unique", action="store_true",
                   help="collapse near-duplicate hits (same lesson copied across files)")
    p.add_argument("--budget", type=int, default=None,
                   help="cap total estimated output tokens (keeps highest-scoring hits)")
    p.add_argument("--recall", action="store_true",
                   help="cross-project comparison view: where have I dealt with this before?")
    p.add_argument("--stats", action="store_true",
                   help="counts only, no content — quick sanity check before a full pull")
    p.add_argument("--related", metavar="ID|INDEX|PATH",
                   help="find content related to a prior hit or file, without exact wording")
    args = p.parse_args(argv)

    config = load_config()

    global CLAUDE_ROOT
    root = args.root or config.get("root") or str(CLAUDE_ROOT)
    CLAUDE_ROOT = Path(root).expanduser().resolve()
    if not CLAUDE_ROOT.exists():
        console.print(f"[red]CLAUDE_ROOT not found:[/] {CLAUDE_ROOT}")
        return 2

    fmt = args.format or config.get("format", "rich")
    kinds = args.kind or config.get("kinds") or list(KINDS)
    sort = args.sort or config.get("sort", "score")

    if args.expand:
        context = args.context if args.context is not None else config.get("context", 0)
        return do_expand(args.expand, context, fmt)

    if args.list:
        return do_list(kinds, args.tag, fmt, sort, args.term)

    if not args.related and not args.term:
        p.error("term is required (unless using --list, --expand, or --related)")

    excludes = list(args.exclude or []) + list(config.get("exclude", []))
    extra_terms = list(args.extra_term or [])
    term_logic = args.term_logic or config.get("term_logic", "and")
    context = args.context if args.context is not None else config.get("context", 0)
    max_results = args.max_results if args.max_results is not None else config.get("max_results")

    since_epoch = before_epoch = None
    try:
        if args.since:
            since_epoch = parse_time_bound(args.since)
        if args.before:
            before_epoch = parse_time_bound(args.before)
    except ValueError as e:
        console.print(f"[red]{e}[/]")
        return 2

    desc = None
    with console.status("Searching…", spinner="dots"):
        if args.related:
            hits, keywords_used = do_related(args.related, kinds, args.ignore_case,
                                             args.fixed, context, excludes, args.debug)
            all_terms = keywords_used or [args.related]
            desc = f"related to '{args.related}'" + \
                (f" ({', '.join(keywords_used)})" if keywords_used else "")
        else:
            all_terms = [args.term] + extra_terms
            hits = run_ripgrep(all_terms, kinds, args.ignore_case, args.fixed,
                               context, excludes, term_logic, args.debug)

        for h in hits:
            h.id = make_hit_id(h.path, h.line_number)
            h.epoch = hit_epoch(h)

        if since_epoch is not None:
            hits = [h for h in hits if h.epoch is None or h.epoch >= since_epoch]
        if before_epoch is not None:
            hits = [h for h in hits if h.epoch is None or h.epoch < before_epoch]

        truncated = False
        if max_results is not None and len(hits) > max_results:
            hits = hits[:max_results]
            truncated = True

        enrich_all(hits)

        for h in hits:
            h.score = compute_score(h, all_terms, args.ignore_case, args.fixed)

        dupes: dict[str, list[Hit]] = {}
        if args.unique:
            hits, dupes = dedup_hits(hits)

        if args.tag:
            wanted = set(args.tag)
            hits = [h for h in hits if set(h.tags) & wanted]

        budget_truncated = False
        if args.budget:
            hits = sorted(hits, key=lambda h: h.score, reverse=True)
            hits, budget_truncated = apply_budget(hits, args.budget)

    save_cache(hits, all_terms)

    if fmt == "rich" and not args.related and args.term and len(hits) <= 2:
        suggestions = [s for s in suggest_alternatives(args.term, kinds)
                       if s.lower() != args.term.lower()]
        if suggestions:
            console.print(f"[yellow]Few results — did you mean:[/] {', '.join(suggestions)}")

    if args.paths_only:
        render_paths_only(hits)
        return 0 if hits else 1

    if args.stats:
        render_stats(hits) if fmt == "rich" else render_machine(hits, fmt)
    elif args.recall:
        render_recall(hits, all_terms, desc) if fmt == "rich" else \
            render_recall_machine(hits, all_terms, fmt, desc)
    elif fmt != "rich":
        render_machine(hits, fmt)
    elif args.verbose:
        render_verbose(hits, all_terms, args.section, args.json, context > 0)
        console.print(Rule(f"[dim]{len(hits)} matches[/]"))
    else:
        render_summary(hits, all_terms, sort, dupes, desc)

    if fmt == "rich" and (truncated or budget_truncated):
        console.print("[dim]Results truncated; refine your search, raise -n, or raise --budget.[/]")

    if args.open:
        target = best_target(hits, sort)
        if target:
            if fmt == "rich":
                console.print(f"[dim]Opening[/] [green]{target}[/]")
            open_in_editor(target)
        elif fmt == "rich":
            console.print("[yellow]Nothing to open.[/]")

    return 0 if hits else 1


if __name__ == "__main__":
    try:
        sys.exit(main())
    except BrokenPipeError:
        try:
            sys.stdout.close()
        except Exception:
            pass
        sys.exit(0)
    except KeyboardInterrupt:
        sys.exit(130)
