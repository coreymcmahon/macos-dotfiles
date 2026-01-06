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
check_deps() {
    if ! command -v jq &> /dev/null; then
        log_error "jq is required. Install with: brew install jq"
        exit 1
    fi
}

# Check if Brave is running
check_brave_running() {
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
}

# Install managed policies (requires sudo, applies globally to all profiles)
install_managed_policies() {
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
}

# Per-profile preferences (for settings not covered by managed policies)
patch_profile_preferences() {
    local profile_dir="$1"
    local prefs="$profile_dir/Preferences"
    local profile_name
    profile_name=$(basename "$profile_dir")
    
    if [[ ! -f "$prefs" ]]; then
        log_warn "Skipping $profile_name (no Preferences file)"
        return
    fi
    
    log_info "Patching profile: $profile_name"
    
    # Backup
    cp "$prefs" "$prefs.backup.$(date +%s)"
    
    # Apply transformations
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
        # Show full URLs (no elision)
        .omnibox.prevent_url_elisions = true |
        
        # Disable heavy animations
        .enable_quic = true |
        
        # Tab behavior
        .browser.show_home_button = false |
        .browser.tabs.loadOnScrollAndMouseover = true |
        
        # === DEVELOPER SETTINGS ===
        # Keep DevTools undocked by default
        .devtools.preferences.currentDockState = "\"undocked\"" |
        
        # Enable source maps
        .devtools.preferences.jsSourceMapsEnabled = "true" |
        .devtools.preferences.cssSourceMapsEnabled = "true" |
        
        # === PRIVACY EXTRAS ===
        # Disable form autofill
        .autofill.credit_card_enabled = false |
        .autofill.profile_enabled = false |

        # WebRTC IP handling (prevent local IP leak)
        # Options: "default", "default_public_interface_only", "disable_non_proxied_udp"
        .webrtc.ip_handling_policy = "default_public_interface_only" |

        # Disable trending searches in omnibox
        .brave.omnibox.show_trending_searches = false |

        # === PERFORMANCE ===
        # Memory saver
        .performance_tuning.high_efficiency_mode.state = 2 |

        # Preload pages
        .net.network_prediction_options = 2
    ' "$prefs" > "$prefs.tmp" && mv "$prefs.tmp" "$prefs"
}

# Patch all profiles
patch_all_profiles() {
    log_info "Patching per-profile preferences..."
    
    # Default profile
    if [[ -d "$BRAVE_DIR/Default" ]]; then
        patch_profile_preferences "$BRAVE_DIR/Default"
    fi
    
    # Numbered profiles
    for profile in "$BRAVE_DIR"/Profile\ *; do
        if [[ -d "$profile" ]]; then
            patch_profile_preferences "$profile"
        fi
    done
}

# List existing profiles
list_profiles() {
    log_info "Detected profiles:"
    
    local local_state="$BRAVE_DIR/Local State"
    if [[ -f "$local_state" ]]; then
        jq -r '.profile.info_cache | to_entries[] | "  - \(.key): \(.value.name)"' "$local_state"
    else
        log_warn "Could not read Local State file"
    fi
}

# Verify installation
verify_installation() {
    log_info "Verifying installation..."
    
    if [[ -f "$POLICY_FILE" ]]; then
        echo -e "${GREEN}✓${NC} Managed policies installed"
    else
        echo -e "${RED}✗${NC} Managed policies not found"
    fi
    
    # Check if policies are being read
    if defaults read /Library/Managed\ Preferences/com.brave.Browser BraveRewardsDisabled &>/dev/null; then
        echo -e "${GREEN}✓${NC} Policies readable"
    fi
}

# Uninstall (restore to defaults)
uninstall() {
    log_info "Removing managed policies..."
    sudo rm -f "$POLICY_FILE"
    
    log_info "Restoring preferences from backups..."
    for prefs in "$BRAVE_DIR"/*/Preferences.backup.*; do
        if [[ -f "$prefs" ]]; then
            local original="${prefs%.backup.*}"
            local latest_backup
            latest_backup=$(ls -t "${original}.backup."* 2>/dev/null | head -1)
            if [[ -n "$latest_backup" ]]; then
                cp "$latest_backup" "$original"
                log_info "Restored $(dirname "$prefs" | xargs basename)"
            fi
        fi
    done
    
    log_info "Uninstall complete. Restart Brave for changes to take effect."
}

# Main
main() {
    echo "======================================"
    echo "  Brave Browser Setup"
    echo "======================================"
    echo
    
    case "${1:-install}" in
        install)
            check_deps
            check_brave_running
            list_profiles
            echo
            install_managed_policies
            patch_all_profiles
            echo
            verify_installation
            echo
            log_info "Setup complete! Restart Brave for all changes to take effect."
            log_info "Run 'brave://policy' in Brave to verify managed policies."
            ;;
        uninstall)
            check_brave_running
            uninstall
            ;;
        list)
            list_profiles
            ;;
        verify)
            verify_installation
            ;;
        *)
            echo "Usage: $0 [install|uninstall|list|verify]"
            exit 1
            ;;
    esac
}

main "$@"
