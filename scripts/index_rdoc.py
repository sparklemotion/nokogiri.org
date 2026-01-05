#!/usr/bin/env python3
"""
Index RDoc HTML files and add them to the zensical/mkdocs search index.

Run this after `zensical build` to include API docs in search results.
"""

import fnmatch
import json
import os
import sys
from pathlib import Path

from bs4 import BeautifulSoup


def find_rdoc_files(rdoc_dir: Path) -> list[Path]:
    """Find all rdoc HTML files for classes/modules (capitalized names)."""
    files = []
    # Search recursively for HTML files starting with uppercase letter
    for f in rdoc_dir.rglob("[A-Z]*.html"):
        # Skip markdown-derived files like README_md.html
        if "_md.html" in f.name:
            continue
        # Skip files in css/js/doc directories
        if any(part in ["css", "js", "doc"] for part in f.parts):
            continue
        files.append(f)
    return sorted(files)


def extract_entries_from_rdoc(file_path: Path, rdoc_dir: Path) -> list[dict]:
    """Extract search entries from an rdoc HTML file."""
    entries = []

    with open(file_path, "r", encoding="utf-8") as f:
        soup = BeautifulSoup(f.read(), "html.parser")

    main = soup.find("main")
    if not main:
        return entries

    h1 = main.find("h1")
    if not h1:
        return entries

    page_title = h1.get_text().strip()
    # Compute relative path from rdoc directory
    relative_path = file_path.relative_to(rdoc_dir)
    page_url = "rdoc/" + str(relative_path)

    # Add entry for the class/module itself
    description = soup.find("section", class_="description")
    if description:
        # Get text content, strip HTML tags for cleaner search
        desc_text = description.get_text(separator=" ", strip=True)
    else:
        desc_text = ""

    entries.append({
        "location": page_url,
        "level": 1,
        "title": page_title,
        "text": desc_text[:500] if desc_text else "",  # Limit description length
        "path": [page_title],
        "tags": ["api", "rdoc"],
    })

    # Add entries for each method
    for method in soup.find_all("div", class_="method-detail"):
        method_id = method.get("id", "")
        if not method_id:
            continue

        section_url = page_url + "#" + method_id

        # Extract method name/signature
        heading = method.find("div", class_="method-heading")
        if not heading:
            continue

        section_title = ""
        # Try method-callseq first (full signature)
        callseq = heading.find("span", class_="method-callseq")
        if callseq:
            section_title = callseq.get_text().strip()
        else:
            # Fall back to method-name + method-args
            name_span = heading.find("span", class_="method-name")
            args_span = heading.find("span", class_="method-args")
            if name_span:
                section_title = name_span.get_text().strip()
                if args_span:
                    section_title += args_span.get_text().strip()

        if not section_title:
            continue

        # Prefix with class name and appropriate separator
        if method_id.startswith("method-c-"):
            section_title = page_title + "." + section_title
        else:
            section_title = page_title + "#" + section_title

        # Extract method description
        desc_div = method.find("div", class_="method-description")
        method_text = ""
        if desc_div:
            # Get first few paragraphs
            paragraphs = desc_div.find_all("p", limit=3)
            method_text = " ".join(p.get_text(strip=True) for p in paragraphs)

        entries.append({
            "location": section_url,
            "level": 2,
            "title": section_title,
            "text": method_text[:300] if method_text else "",
            "path": [page_title, section_title],
            "tags": ["api", "rdoc", "method"],
        })

    return entries


def main():
    # Determine paths
    script_dir = Path(__file__).parent
    project_root = script_dir.parent

    site_dir = project_root / "site"
    rdoc_dir = project_root / "staging" / "rdoc"
    search_json = site_dir / "search.json"

    if not search_json.exists():
        print(f"Error: {search_json} not found. Run 'zensical build' first.", file=sys.stderr)
        sys.exit(1)

    if not rdoc_dir.exists():
        print(f"Error: {rdoc_dir} not found.", file=sys.stderr)
        sys.exit(1)

    # Load existing search index
    with open(search_json, "r", encoding="utf-8") as f:
        search_index = json.load(f)

    # Remove any existing rdoc entries (to allow re-running)
    original_count = len(search_index["items"])
    search_index["items"] = [
        item for item in search_index["items"]
        if "rdoc" not in item.get("tags", [])
    ]

    # Find and process rdoc files
    rdoc_files = find_rdoc_files(rdoc_dir)
    print(f"Found {len(rdoc_files)} rdoc files to index")

    total_entries = 0
    for rdoc_file in rdoc_files:
        entries = extract_entries_from_rdoc(rdoc_file, rdoc_dir)
        search_index["items"].extend(entries)
        total_entries += len(entries)
        # Show relative path for clarity
        rel_path = rdoc_file.relative_to(rdoc_dir)
        print(f"  {rel_path}: {len(entries)} entries")

    # Write updated search index
    with open(search_json, "w", encoding="utf-8") as f:
        json.dump(search_index, f, separators=(",", ":"))

    print(f"\nAdded {total_entries} rdoc entries to search index")
    print(f"Total entries: {len(search_index['items'])} (was {original_count})")


if __name__ == "__main__":
    main()
