#!/usr/bin/env bash
# Publish the contents of site/ to the gh-pages branch.
# Usage: ./deploy.sh

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SITE_DIR="$ROOT/site"
BRANCH="gh-pages"

if [[ ! -d "$SITE_DIR" ]]; then
  echo "site/ directory not found at $SITE_DIR" >&2
  exit 1
fi

if [[ -n "$(git -C "$ROOT" status --porcelain)" ]]; then
  echo "Working tree has uncommitted changes. Commit or stash first." >&2
  exit 1
fi

ORIGINAL_BRANCH="$(git -C "$ROOT" rev-parse --abbrev-ref HEAD)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

cp -R "$SITE_DIR"/. "$TMP_DIR"/

# Create or switch to the gh-pages branch (orphan if it does not exist yet).
if git -C "$ROOT" show-ref --verify --quiet "refs/heads/$BRANCH"; then
  git -C "$ROOT" checkout "$BRANCH"
else
  git -C "$ROOT" checkout --orphan "$BRANCH"
  git -C "$ROOT" rm -rf . >/dev/null 2>&1 || true
fi

# Clean any tracked files left over from previous deploys.
git -C "$ROOT" ls-files | xargs -r rm -f
find "$ROOT" -maxdepth 1 -type d ! -name '.git' ! -name "$(basename "$ROOT")" -exec rm -rf {} +

cp -R "$TMP_DIR"/. "$ROOT"/

# A .nojekyll file stops GitHub Pages from interpreting filenames as Jekyll directives.
touch "$ROOT/.nojekyll"

git -C "$ROOT" add -A
if git -C "$ROOT" diff --cached --quiet; then
  echo "No changes to deploy."
else
  git -C "$ROOT" commit -m "deploy: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  git -C "$ROOT" push origin "$BRANCH"
  echo "Deployed to $BRANCH."
fi

git -C "$ROOT" checkout "$ORIGINAL_BRANCH"
