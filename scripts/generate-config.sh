#!/usr/bin/env sh
# Generates config.js from Netlify build-time env vars.
# Empty strings disable tracking; the app still boots normally.

set -eu

BUILD=$(git rev-parse --short=4 HEAD 2>/dev/null || echo "dev")

# Escape double quotes and backslashes for safe JS string literals.
escape_js() {
  printf '%s' "$1" | tr -d '\r\n' | sed 's/\\/\\\\/g; s/"/\\"/g'
}

SUPABASE_URL_ESC=$(escape_js "${SUPABASE_URL:-}")
SUPABASE_ANON_KEY_ESC=$(escape_js "${SUPABASE_ANON_KEY:-}")
BUILD_ESC=$(escape_js "${BUILD}")

cat > config.js <<EOF
"use strict";

window.__DOISHOT_CONFIG = {
  SUPABASE_URL: "${SUPABASE_URL_ESC}",
  SUPABASE_ANON_KEY: "${SUPABASE_ANON_KEY_ESC}",
  BUILD: "${BUILD_ESC}",
};
EOF

echo "generated config.js (SUPABASE_URL set: $([ -n "${SUPABASE_URL:-}" ] && echo yes || echo no))"
