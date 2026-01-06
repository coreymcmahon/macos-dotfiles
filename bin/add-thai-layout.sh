#!/usr/bin/env bash
set -euo pipefail

##
# Adds Thai keyboard layout to the current host's input sources

LAYOUT_NAME="Thai"
TIS_ID="com.apple.keylayout.Thai"

# 1) Locate the built-in keylayout file
KEYLAYOUT_FILE="$(/usr/bin/find "/System/Library/Keyboard Layouts" -maxdepth 4 \
  -name "${LAYOUT_NAME}.keylayout" -print -quit 2>/dev/null || true)"

if [[ -z "${KEYLAYOUT_FILE}" ]]; then
  echo "Couldn't find ${LAYOUT_NAME}.keylayout under /System/Library/Keyboard Layouts"
  exit 1
fi

# 2) Extract the numeric layout id from the XML
LAYOUT_ID="$(
  /usr/bin/perl -ne 'print $1 and exit if /<keyboard[^>]*\sid="(-?\d+)"/' \
  "${KEYLAYOUT_FILE}"
)"

if [[ -z "${LAYOUT_ID}" ]]; then
  echo "Couldn't extract KeyboardLayout ID from: ${KEYLAYOUT_FILE}"
  exit 1
fi

# 3) Add to the per-host HIToolbox arrays
add_source() {
  local key="$1"

  if /usr/bin/defaults -currentHost read com.apple.HIToolbox "${key}" 2>/dev/null \
    | /usr/bin/grep -Eq "KeyboardLayout ID\"? = (\"?${LAYOUT_ID}\"?)"; then
    return 0
  fi

  /usr/bin/defaults -currentHost write com.apple.HIToolbox "${key}" -array-add \
    "<dict>\
<key>InputSourceKind</key><string>Keyboard Layout</string>\
<key>KeyboardLayout ID</key><integer>${LAYOUT_ID}</integer>\
<key>KeyboardLayout Name</key><string>${LAYOUT_NAME}</string>\
</dict>"
}

for k in AppleEnabledInputSources AppleInputSourceHistory AppleSelectedInputSources; do
  add_source "${k}"
done

echo "Added ${LAYOUT_NAME} (id=${LAYOUT_ID}) for this host."
echo "You will usually need to log out/in or reboot before it appears in System Settings / the Input menu."
