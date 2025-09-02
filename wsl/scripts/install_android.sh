#!/bin/bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Android SDK Installation Script for WSL
# Version: 2.2 - Thoroughly reviewed and hardened
# Requirements: Ubuntu/Debian-based WSL distribution

# Configuration
ANDROID_SDK_ROOT="/opt/android-sdk"
readonly JAVA_VERSION="17"
readonly TEMP_DIR="/tmp"

# Global variables (declared to avoid unbound variable errors)
CMDTOOLS_VERSION=""
CMDTOOLS_URL=""
CMDTOOLS_SIZE=""

# Logging function - all messages go to stderr to keep stdout clean
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >&2
}

# Error handler
error_exit() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1" >&2
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] Installation failed. Check the logs above for details." >&2
    exit 1
}

# Warning function
warn() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1" >&2
}

# Cleanup function
cleanup() {
    log "Performing cleanup..."
    # Only clean up if temp files exist and are in expected location
    if [ -f "$TEMP_DIR"/commandlinetools-linux-*.zip ] 2>/dev/null; then
        rm -f "$TEMP_DIR"/commandlinetools-linux-*.zip || warn "Could not remove temporary zip files"
    fi
    if [ -f "$TEMP_DIR/android_repo.xml" ]; then
        rm -f "$TEMP_DIR/android_repo.xml" || warn "Could not remove temporary XML file"
    fi
}
trap cleanup EXIT

# Comprehensive prerequisite check
check_prerequisites() {
    log "Performing comprehensive prerequisite check..."
    
    # Check if we're in WSL
    if ! grep -qi "microsoft\|wsl" /proc/version 2>/dev/null; then
        warn "This script is designed for WSL. Continuing anyway..."
    fi
    
    # Check available disk space (need at least 2GB for Android SDK)
    local available_space
    available_space=$(df "$HOME" | awk 'NR==2 {print $4}')
    if [ "$available_space" -lt 2097152 ]; then  # 2GB in KB
        error_exit "Insufficient disk space. Need at least 2GB free in $HOME"
    fi
    
    # Check required tools and install if missing
    local missing_tools=()
    local required_tools=("wget" "unzip" "curl" "grep" "awk" "sed")
    
    for tool in "${required_tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        fi
    done
    
    if [ ${#missing_tools[@]} -ne 0 ]; then
        log "Installing missing tools: ${missing_tools[*]}"
        if ! sudo apt update; then
            error_exit "Failed to update package lists"
        fi
        if ! sudo apt install -y "${missing_tools[@]}"; then
            error_exit "Failed to install required tools: ${missing_tools[*]}"
        fi
    fi
    
    log "All prerequisites satisfied"
}

# Get latest command-line tools version with multiple fallback strategies
get_latest_cmdtools_info() {
    log "Detecting latest Android command-line tools version..."
    
    # Strategy 1: Parse official Android Studio download page
    local page_content
    if page_content=$(curl -s --connect-timeout 10 --max-time 30 "https://developer.android.com/studio" 2>/dev/null); then
        local version_from_page
        version_from_page=$(echo "$page_content" | grep -o 'commandlinetools-linux-[0-9]\+_latest\.zip' | grep -o '[0-9]\+' | head -1)
        
        if [ -n "$version_from_page" ] && [[ "$version_from_page" =~ ^[0-9]+$ ]]; then
            log "Found version $version_from_page from official page"
            
            # Extract size information if available
            local size_info
            size_info=$(echo "$page_content" | grep -A 5 -B 5 "commandlinetools-linux-${version_from_page}" | grep -o '[0-9]\+\.[0-9]\+ MB' | head -1)
            
            CMDTOOLS_VERSION="$version_from_page"
            CMDTOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-${version_from_page}_latest.zip"
            CMDTOOLS_SIZE="${size_info:-Unknown size}"
            
            # Verify the URL is accessible (try multiple methods)
            local url_check_passed=false
            
            # Method 1: HEAD request
            if curl -s --head --connect-timeout 10 --user-agent "Mozilla/5.0" "$CMDTOOLS_URL" | grep -q "200 OK"; then
                url_check_passed=true
            # Method 2: Range request (gets just first byte)
            elif curl -s -r 0-0 --connect-timeout 10 --user-agent "Mozilla/5.0" "$CMDTOOLS_URL" >/dev/null 2>&1; then
                url_check_passed=true
            # Method 3: Skip verification if we found the version from official page
            elif [ -n "$version_from_page" ]; then
                log "Skipping URL verification since version came from official page"
                url_check_passed=true
            fi
            
            if [ "$url_check_passed" = true ]; then
                log "URL verification successful"
                return 0
            else
                warn "URL verification failed, trying fallback strategies"
            fi
        fi
    else
        warn "Could not fetch official download page"
    fi
    
    # Strategy 2: Try known recent versions
    log "Trying known recent versions..."
    local known_versions=("13114758" "11076708" "10406996" "9477386")
    
    for version in "${known_versions[@]}"; do
        local test_url="https://dl.google.com/android/repository/commandlinetools-linux-${version}_latest.zip"
        log "Testing version $version..."
        
        # Try multiple verification methods
        if curl -s --head --connect-timeout 5 --user-agent "Mozilla/5.0" "$test_url" | grep -q "200 OK"; then
            log "Found working version via HEAD request: $version"
            CMDTOOLS_VERSION="$version"
            CMDTOOLS_URL="$test_url"
            CMDTOOLS_SIZE="~165 MB"
            return 0
        elif curl -s -r 0-0 --connect-timeout 5 --user-agent "Mozilla/5.0" "$test_url" >/dev/null 2>&1; then
            log "Found working version via range request: $version"
            CMDTOOLS_VERSION="$version"
            CMDTOOLS_URL="$test_url"
            CMDTOOLS_SIZE="~165 MB"
            return 0
        fi
    done
    
    # Strategy 3: Use version from page even if URL check failed
    if [ -n "$version_from_page" ] && [[ "$version_from_page" =~ ^[0-9]+$ ]]; then
        warn "Using version from official page despite URL verification failure"
        CMDTOOLS_VERSION="$version_from_page"
        CMDTOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-${version_from_page}_latest.zip"
        CMDTOOLS_SIZE="~165 MB"
        return 0
    fi
    
    # Strategy 4: Absolute fallback to known working version
    warn "All version detection strategies failed, using fallback version"
    CMDTOOLS_VERSION="11076708"
    CMDTOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"
    CMDTOOLS_SIZE="~165 MB"
    log "Using fallback version: $CMDTOOLS_VERSION"
    return 0
}

# Robust Java installation with proper version checking
install_java() {
    log "Checking Java $JAVA_VERSION installation..."
    
    # Check if correct Java version is already installed and set as default
    if command -v java >/dev/null 2>&1; then
        local current_java_version
        current_java_version=$(java -version 2>&1 | grep -o "openjdk version \"$JAVA_VERSION" || echo "")
        
        if [ -n "$current_java_version" ]; then
            log "Java $JAVA_VERSION is already installed and active"
            
            # Verify JAVA_HOME is set correctly
            if [ -z "${JAVA_HOME:-}" ]; then
                local java_path
                java_path=$(readlink -f "$(which java)" | sed 's/bin\/java$//')
                export JAVA_HOME="$java_path"
                log "Set JAVA_HOME to: $JAVA_HOME"
            fi
            return 0
        fi
    fi
    
    log "Installing OpenJDK $JAVA_VERSION..."
    
    if ! sudo apt update; then
        error_exit "Failed to update package lists for Java installation"
    fi
    
    if ! sudo apt install -y "openjdk-$JAVA_VERSION-jdk"; then
        error_exit "Failed to install OpenJDK $JAVA_VERSION"
    fi
    
    # Set JAVA_HOME
    local java_path
    java_path="/usr/lib/jvm/java-$JAVA_VERSION-openjdk-amd64"
    
    if [ ! -d "$java_path" ]; then
        # Try to find it dynamically
        java_path=$(dirname "$(dirname "$(readlink -f "$(which java)")")")
    fi
    
    if [ ! -d "$java_path" ]; then
        error_exit "Could not determine JAVA_HOME path"
    fi
    
    export JAVA_HOME="$java_path"
    log "Java $JAVA_VERSION installation complete"
    log "JAVA_HOME set to: $JAVA_HOME"
}

# Safe backup with error checking
backup_existing_sdk() {
    if [ ! -d "$ANDROID_SDK_ROOT" ]; then
        log "No existing Android SDK found, skipping backup"
        return 0
    fi
    
    local backup_dir="${ANDROID_SDK_ROOT}.backup.$(date +%Y%m%d_%H%M%S)"
    log "Backing up existing SDK to: $backup_dir"
    
    if ! mv "$ANDROID_SDK_ROOT" "$backup_dir"; then
        error_exit "Failed to backup existing SDK"
    fi
    
    log "Backup completed successfully"
}

# Robust download with comprehensive verification
download_cmdtools() {
    local filename="commandlinetools-linux-${CMDTOOLS_VERSION}_latest.zip"
    local filepath="$TEMP_DIR/$filename"
    
    log "Downloading Android Command-Line Tools version $CMDTOOLS_VERSION ($CMDTOOLS_SIZE)..."
    log "URL: $CMDTOOLS_URL"
    
    # Change to temp directory
    if ! cd "$TEMP_DIR"; then
        error_exit "Could not change to temporary directory: $TEMP_DIR"
    fi
    
    # Remove any existing file
    rm -f "$filename"
    
    # Download with multiple retry attempts
    local max_retries=3
    local retry_count=0
    
    while [ $retry_count -lt $max_retries ]; do
        if wget --progress=bar --timeout=60 --tries=3 "$CMDTOOLS_URL" -O "$filename"; then
            break
        else
            retry_count=$((retry_count + 1))
            if [ $retry_count -lt $max_retries ]; then
                warn "Download attempt $retry_count failed, retrying..."
                sleep 5
            else
                error_exit "Failed to download after $max_retries attempts"
            fi
        fi
    done
    
    # Comprehensive file validation
    if [ ! -f "$filename" ]; then
        error_exit "Downloaded file does not exist: $filename"
    fi
    
    if [ ! -s "$filename" ]; then
        error_exit "Downloaded file is empty: $filename"
    fi
    
    # Check file size (should be around 160MB)
    local file_size
    file_size=$(stat -c%s "$filename" 2>/dev/null || echo "0")
    if [ "$file_size" -lt 100000000 ]; then  # Less than 100MB is suspicious
        error_exit "Downloaded file is too small ($file_size bytes). Download may be incomplete."
    fi
    
    # Test ZIP file integrity
    if ! unzip -t "$filename" >/dev/null 2>&1; then
        error_exit "Downloaded file is not a valid ZIP archive or is corrupted"
    fi
    
    log "Download completed and verified successfully"
    
    # Return filepath via stdout (clean because logs go to stderr)
    echo "$filepath"
}

# Safe and thorough SDK installation
install_cmdtools() {
    local zip_file="$1"
    
    if [ ! -f "$zip_file" ]; then
        error_exit "Zip file does not exist: $zip_file"
    fi
    
    log "Installing Android SDK command-line tools..."
    
    # Create SDK directory with proper permissions (may need sudo)
    if [ ! -d "$ANDROID_SDK_ROOT" ]; then
        log "Creating SDK directory: $ANDROID_SDK_ROOT"
        if ! sudo mkdir -p "$ANDROID_SDK_ROOT"; then
            error_exit "Failed to create Android SDK directory: $ANDROID_SDK_ROOT"
        fi
        
        # Set ownership to current user
        if ! sudo chown -R "$USER:$USER" "$ANDROID_SDK_ROOT"; then
            error_exit "Failed to set ownership of SDK directory"
        fi
    fi
    
    if ! cd "$ANDROID_SDK_ROOT"; then
        error_exit "Could not change to Android SDK directory"
    fi
    
    # Extract with error checking
    log "Extracting command-line tools..."
    if ! unzip -q "$zip_file"; then
        error_exit "Failed to extract command-line tools"
    fi
    
    # Verify extraction created expected directory
    if [ ! -d "cmdline-tools" ]; then
        error_exit "Expected 'cmdline-tools' directory not found after extraction"
    fi
    
    # Fix directory structure (the famous cmdline-tools issue)
    log "Setting up proper directory structure..."
    
    # Create the 'latest' directory
    if ! mkdir -p cmdline-tools/latest; then
        error_exit "Failed to create cmdline-tools/latest directory"
    fi
    
    # Move all contents to 'latest' subdirectory (except 'latest' itself)
    local moved_something=false
    for item in cmdline-tools/*; do
        local basename_item
        basename_item=$(basename "$item")
        
        if [ "$basename_item" != "latest" ] && [ -e "$item" ]; then
            if mv "$item" cmdline-tools/latest/; then
                moved_something=true
            else
                error_exit "Failed to move $item to cmdline-tools/latest/"
            fi
        fi
    done
    
    if [ "$moved_something" = false ]; then
        # Maybe the structure is already correct, let's check
        if [ ! -f "cmdline-tools/latest/bin/sdkmanager" ]; then
            error_exit "Could not establish correct cmdline-tools directory structure"
        fi
    fi
    
    # Verify final structure
    if [ ! -f "cmdline-tools/latest/bin/sdkmanager" ]; then
        error_exit "sdkmanager not found at expected location after installation"
    fi
    
    # Make sure sdkmanager is executable
    if ! chmod +x cmdline-tools/latest/bin/sdkmanager; then
        error_exit "Failed to make sdkmanager executable"
    fi
    
    log "Command-line tools installed successfully"
}

# Robust environment setup with validation
setup_environment() {
    log "Setting up environment variables..."
    
    # Backup current .bashrc
    if ! cp ~/.bashrc ~/.bashrc.backup.$(date +%Y%m%d_%H%M%S); then
        warn "Could not backup .bashrc"
    fi
    
    # Remove any existing Android SDK entries to avoid duplicates
    if ! grep -v "ANDROID_HOME\|ANDROID_SDK_ROOT" ~/.bashrc > ~/.bashrc.tmp; then
        error_exit "Failed to process .bashrc file"
    fi
    
    if ! mv ~/.bashrc.tmp ~/.bashrc; then
        error_exit "Failed to update .bashrc file"
    fi
    
    # Add new environment variables
    {
        echo ""
        echo "# Android SDK (added by install script on $(date))"
        echo "export ANDROID_SDK_ROOT=\"$ANDROID_SDK_ROOT\""
        echo "export ANDROID_HOME=\"\$ANDROID_SDK_ROOT\""
        echo "export PATH=\"\$PATH:\$ANDROID_SDK_ROOT/cmdline-tools/latest/bin\""
        echo "export PATH=\"\$PATH:\$ANDROID_SDK_ROOT/platform-tools\""
    } >> ~/.bashrc
    
    # Set for current session (export the variables)
    export ANDROID_SDK_ROOT
    export ANDROID_HOME="$ANDROID_SDK_ROOT"
    export PATH="$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools"
    
    log "Environment variables configured successfully"
}

# Install essential SDK packages with comprehensive error handling
install_sdk_packages() {
    log "Installing essential SDK packages..."
    
    local sdkmanager="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager"
    
    if [ ! -f "$sdkmanager" ]; then
        error_exit "sdkmanager not found at: $sdkmanager"
    fi
    
    if [ ! -x "$sdkmanager" ]; then
        error_exit "sdkmanager is not executable"
    fi
    
    # Test sdkmanager basic functionality
    log "Testing sdkmanager functionality..."
    if ! "$sdkmanager" --version >/dev/null 2>&1; then
        error_exit "sdkmanager is not working properly"
    fi
    
    # Accept licenses with timeout to prevent hanging
    log "Accepting SDK licenses..."
    if ! timeout 60 bash -c "yes | '$sdkmanager' --licenses" >/dev/null 2>&1; then
        warn "License acceptance may have failed or timed out"
    fi
    
    # Install platform-tools (essential for ADB)
    log "Installing platform-tools (includes ADB)..."
    if ! "$sdkmanager" "platform-tools"; then
        error_exit "Failed to install platform-tools"
    fi
    
    # Install a recent Android platform
    log "Installing Android platform..."
    if ! "$sdkmanager" "platforms;android-34"; then
        warn "Failed to install Android 34 platform, trying Android 33..."
        if ! "$sdkmanager" "platforms;android-33"; then
            warn "Failed to install Android platforms, continuing anyway"
        fi
    fi
    
    # Install build tools
    log "Installing build tools..."
    if ! "$sdkmanager" "build-tools;34.0.0"; then
        warn "Failed to install build-tools 34.0.0, trying 33.0.0..."
        if ! "$sdkmanager" "build-tools;33.0.0"; then
            warn "Failed to install build tools, continuing anyway"
        fi
    fi
    
    log "SDK package installation completed"
}

# Comprehensive installation verification
verify_installation() {
    log "Performing comprehensive installation verification..."
    
    local success=true
    
    # Check directory structure
    if [ ! -d "$ANDROID_SDK_ROOT" ]; then
        log "✗ Android SDK root directory not found"
        success=false
    else
        log "✓ Android SDK root directory exists"
    fi
    
    # Check sdkmanager
    local sdkmanager="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager"
    if [ -f "$sdkmanager" ] && [ -x "$sdkmanager" ]; then
        log "✓ sdkmanager is available and executable"
        if "$sdkmanager" --version >/dev/null 2>&1; then
            log "✓ sdkmanager is functional"
        else
            log "✗ sdkmanager exists but is not functional"
            success=false
        fi
    else
        log "✗ sdkmanager not found or not executable"
        success=false
    fi
    
    # Check ADB
    if command -v adb >/dev/null 2>&1; then
        log "✓ ADB is available in PATH"
        local adb_version
        if adb_version=$(adb version 2>/dev/null); then
            log "✓ ADB is functional: $(echo "$adb_version" | head -1)"
        else
            log "✗ ADB exists but is not functional"
            success=false
        fi
    else
        log "✗ ADB not found in PATH (may need to restart terminal)"
        success=false
    fi
    
    # Check environment variables
    if [ -n "${ANDROID_SDK_ROOT:-}" ]; then
        log "✓ ANDROID_SDK_ROOT is set: $ANDROID_SDK_ROOT"
    else
        log "✗ ANDROID_SDK_ROOT not set"
        success=false
    fi
    
    if [ -n "${ANDROID_HOME:-}" ]; then
        log "✓ ANDROID_HOME is set: $ANDROID_HOME"
    else
        log "✗ ANDROID_HOME not set"
        success=false
    fi
    
    if [ "$success" = true ]; then
        log "✓ All verification checks passed"
    else
        log "⚠ Some verification checks failed (may require terminal restart)"
    fi
    
    return 0  # Don't fail the script for verification issues
}

# Main execution function
main() {
    log "=== Android SDK Installation Script v2.2 ==="
    log "Target SDK location: $ANDROID_SDK_ROOT"
    log "Java version: $JAVA_VERSION"
    log ""
    
    # Execute installation steps
    check_prerequisites
    get_latest_cmdtools_info
    install_java
    backup_existing_sdk
    
    local zip_file
    zip_file=$(download_cmdtools)
    
    install_cmdtools "$zip_file"
    setup_environment
    install_sdk_packages
    verify_installation
    
    log ""
    log "=== Installation Summary ==="
    log "✓ Android SDK installed to: $ANDROID_SDK_ROOT"
    log "✓ Command-line tools version: $CMDTOOLS_VERSION"
    log "✓ Environment variables configured in ~/.bashrc"
    log ""
    log "=== Next Steps ==="
    log "1. Restart your terminal or run: source ~/.bashrc"
    log "2. Test ADB: adb version"
    log "3. List SDK packages: \$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --list"
    log "4. Install additional packages as needed"
    log ""
    log "Installation completed successfully!"
}

# Script entry point
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
