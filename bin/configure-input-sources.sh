#!/bin/bash
set -euo pipefail

##
# Configure keyboard input sources (US, British, Thai) using TISEnableInputSource API

swift - << 'EOF'
import Carbon

let layouts = [
    "com.apple.keylayout.US",
    "com.apple.keylayout.British",
    "com.apple.keylayout.Thai"
]

for layoutID in layouts {
    let filter = [kTISPropertyInputSourceID as String: layoutID] as CFDictionary
    guard let sources = TISCreateInputSourceList(filter, true)?.takeRetainedValue() as? [TISInputSource],
          let source = sources.first else {
        print("[SKIP] \(layoutID) not found")
        continue
    }

    let err = TISEnableInputSource(source)
    if err == noErr {
        print("[OK] \(layoutID)")
    } else {
        print("[ERR] \(layoutID) - error \(err)")
    }
}

// Select US as default
let usFilter = [kTISPropertyInputSourceID as String: "com.apple.keylayout.US"] as CFDictionary
if let sources = TISCreateInputSourceList(usFilter, false)?.takeRetainedValue() as? [TISInputSource],
   let usSource = sources.first {
    TISSelectInputSource(usSource)
    print("[DEFAULT] US selected")
}
EOF
