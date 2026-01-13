#!/bin/bash
set -euo pipefail

##
# Disables AI, Crypto, Rewards, VPN, News and applies consistent settings across all profiles for Brave Browser on macOS

BRAVE_DIR="$HOME/Library/Application Support/BraveSoftware/Brave-Browser"
MANAGED_PREFS_DIR="/Library/Managed Preferences"
POLICY_FILE="$MANAGED_PREFS_DIR/com.brave.Browser.plist"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check dependencies
if ! command -v jq &> /dev/null; then
    log_error "jq is required. Install with: brew install jq"
    exit 1
fi

# Check if Brave is running
if pgrep -x "Brave Browser" > /dev/null; then
    log_warn "Brave is currently running."
    read -p "Close Brave and continue? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        osascript -e 'quit app "Brave Browser"'
        sleep 2
    else
        log_error "Please close Brave manually and re-run this script."
        exit 1
    fi
fi

echo "======================================"
echo "  Brave Browser Setup"
echo "======================================"
echo

# List profiles
log_info "Detected profiles:"
LOCAL_STATE="$BRAVE_DIR/Local State"
if [[ -f "$LOCAL_STATE" ]]; then
    jq -r '.profile.info_cache | to_entries[] | "  - \(.key): \(.value.name)"' "$LOCAL_STATE"
else
    log_warn "Could not read Local State file"
fi
echo

# Install managed policies
log_info "Installing managed policies (requires sudo)..."

sudo mkdir -p "$MANAGED_PREFS_DIR"

sudo tee "$POLICY_FILE" > /dev/null << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- === DISABLE BLOAT === -->

    <!-- Brave Rewards (BAT crypto) -->
    <key>BraveRewardsDisabled</key>
    <true/>

    <!-- Brave Wallet (crypto wallet) -->
    <key>BraveWalletDisabled</key>
    <true/>

    <!-- Brave VPN -->
    <key>BraveVPNDisabled</key>
    <true/>

    <!-- Leo AI Assistant -->
    <key>BraveAIChatEnabled</key>
    <false/>

    <!-- Brave News -->
    <key>BraveNewsEnabled</key>
    <false/>

    <!-- === PRIVACY === -->

    <!-- Block third-party cookies -->
    <key>BlockThirdPartyCookies</key>
    <true/>

    <!-- Send Do Not Track -->
    <key>EnableDoNotTrack</key>
    <true/>

    <!-- Disable search suggestions (prevents keystroke leakage) -->
    <key>SearchSuggestEnabled</key>
    <false/>

    <!-- Disable URL predictions -->
    <key>NetworkPredictionOptions</key>
    <integer>2</integer>

    <!-- === TELEMETRY === -->

    <!-- Disable Safe Browsing extended reporting (keeps protection, disables telemetry) -->
    <key>SafeBrowsingExtendedReportingEnabled</key>
    <false/>

    <!-- Disable metrics/usage reporting -->
    <key>MetricsReportingEnabled</key>
    <false/>

    <!-- Disable URL-keyed anonymized data collection -->
    <key>UrlKeyedAnonymizedDataCollectionEnabled</key>
    <false/>

    <!-- Disable cloud spell check (sends text to cloud) -->
    <key>SpellCheckServiceEnabled</key>
    <false/>

    <!-- === SECURITY === -->

    <!-- Disable Chrome Remote Desktop firewall traversal -->
    <key>RemoteAccessHostFirewallTraversal</key>
    <false/>

    <!-- === PERFORMANCE === -->

    <!-- Disable background mode (Brave fully quits when closed) -->
    <key>BackgroundModeEnabled</key>
    <false/>

    <!-- Disable tab hover card images (reduces memory) -->
    <key>TabHoverCardImagesSettings</key>
    <integer>0</integer>

    <!-- === POWER USER === -->

    <!-- Disable first-run welcome flow -->
    <key>SuppressFirstRunDefaultBrowserPrompt</key>
    <true/>

    <!-- Restore downloads bar behavior -->
    <key>DownloadBubbleEnabled</key>
    <false/>

    <!-- Allow incognito -->
    <key>IncognitoModeAvailability</key>
    <integer>0</integer>

    <!-- Enable developer tools -->
    <key>DeveloperToolsAvailability</key>
    <integer>1</integer>
</dict>
</plist>
PLIST

sudo chmod 644 "$POLICY_FILE"
sudo chown root:wheel "$POLICY_FILE"

log_info "Managed policies installed at $POLICY_FILE"

# Patch per-profile preferences
patch_profile() {
    local profile_dir="$1"
    local prefs="$profile_dir/Preferences"
    local profile_name
    profile_name=$(basename "$profile_dir")

    if [[ ! -f "$prefs" ]]; then
        log_warn "Skipping $profile_name (no Preferences file)"
        return
    fi

    log_info "Patching profile: $profile_name"

    jq '
        # === TOOLBAR CLEANUP ===
        .brave.ai_chat.show_toolbar_button = false |
        .brave.wallet.show_wallet_icon_on_toolbar = false |
        .brave.rewards.show_button = false |
        .brave.brave_vpn.show_button = false |
        .brave.sidebar.sidebar_show_option = 0 |

        # === NEW TAB PAGE CLEANUP ===
        .brave.new_tab_page.show_brave_today = false |
        .brave.new_tab_page.show_background_image = false |
        .brave.new_tab_page.show_sponsored_images = false |
        .brave.new_tab_page.show_stats = false |
        .brave.new_tab_page.show_clock = true |
        .brave.new_tab_page.show_top_sites = true |
        .brave.today.show_on_ntp = false |

        # === DISABLE FEATURES ===
        .brave.ai_chat.enabled = false |
        .brave.rewards.enabled = false |
        .brave.wallet.default_wallet2 = 0 |
        .brave.brave_news.show_on_ntp = false |

        # === POWER USER SETTINGS ===
        .omnibox.prevent_url_elisions = true |
        .enable_quic = true |
        .browser.show_home_button = false |
        .browser.tabs.loadOnScrollAndMouseover = true |

        # === DEVELOPER SETTINGS ===
        .devtools.preferences.currentDockState = "\"undocked\"" |
        .devtools.preferences.jsSourceMapsEnabled = "true" |
        .devtools.preferences.cssSourceMapsEnabled = "true" |

        # === PRIVACY EXTRAS ===
        .autofill.credit_card_enabled = false |
        .autofill.profile_enabled = false |
        .webrtc.ip_handling_policy = "default_public_interface_only" |
        .brave.omnibox.show_trending_searches = false |

        # === PERFORMANCE ===
        .performance_tuning.high_efficiency_mode.state = 2 |
        .net.network_prediction_options = 2
    ' "$prefs" > "$prefs.tmp" && mv "$prefs.tmp" "$prefs"
}

log_info "Patching per-profile preferences..."

if [[ -d "$BRAVE_DIR/Default" ]]; then
    patch_profile "$BRAVE_DIR/Default"
fi

for profile in "$BRAVE_DIR"/Profile\ *; do
    if [[ -d "$profile" ]]; then
        patch_profile "$profile"
    fi
done

echo
log_info "Setup complete! Restart Brave for all changes to take effect."
log_info "Run 'brave://policy' in Brave to verify managed policies."
