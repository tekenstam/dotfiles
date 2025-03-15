#!/bin/bash

# Exit on error
set -e

# Parse command line arguments
NO_PROMPT=false
for arg in "$@"; do
  case $arg in
    --no-prompt)
      NO_PROMPT=true
      shift
      ;;
  esac
done

# Function to prompt for confirmation
confirm() {
  if [ "$NO_PROMPT" = true ]; then
    return 0
  fi
  
  local message=$1
  read -p "$message [y/N] " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    return 1
  fi
  return 0
}

# Close any open System Preferences panes to prevent them from overriding settings
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Confirm applying all settings
if ! confirm "This script will modify your macOS default settings. Some changes may require a restart. Continue?"; then
  echo "Operation canceled."
  exit 0
fi

echo "Setting macOS defaults..."

###############################################################################
# General UI/UX                                                               #
###############################################################################

if confirm "Apply General UI/UX settings?"; then
  # Disable the sound effects on boot
  sudo nvram SystemAudioVolume=" "

  # Set sidebar icon size to medium
  defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

  # Set scrollbar behavior
  defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"

  # Expand save panel by default
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

  # Expand print panel by default
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

  # Save to disk (not to iCloud) by default
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

  # Automatically quit printer app once the print jobs complete
  defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
  
  echo "General UI/UX settings applied."
else
  echo "Skipping General UI/UX settings."
fi

###############################################################################
# Finder                                                                      #
###############################################################################

if confirm "Apply Finder settings?"; then
  # Show icons for hard drives, servers, and removable media on the desktop
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

  # Finder: show all filename extensions
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true

  # Finder: show status bar
  defaults write com.apple.finder ShowStatusBar -bool true

  # Finder: show path bar
  defaults write com.apple.finder ShowPathbar -bool true

  # Display full POSIX path as Finder window title
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

  # Keep folders on top when sorting by name
  defaults write com.apple.finder _FXSortFoldersFirst -bool true

  # When performing a search, search the current folder by default
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

  # Avoid creating .DS_Store files on network or USB volumes
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
  
  echo "Finder settings applied."
else
  echo "Skipping Finder settings."
fi

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

if confirm "Apply Dock and Dashboard settings?"; then
  # Set the icon size of Dock items
  defaults write com.apple.dock tilesize -int 50

  # Enable magnification
  defaults write com.apple.dock magnification -bool true
  defaults write com.apple.dock largesize -int 64

  # Minimize windows into their application's icon
  defaults write com.apple.dock minimize-to-application -bool true

  # Enable spring loading for all Dock items
  defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

  # Show indicator lights for open applications in the Dock
  defaults write com.apple.dock show-process-indicators -bool true

  # Automatically hide and show the Dock
  defaults write com.apple.dock autohide -bool true

  # Don't show recent applications in Dock
  defaults write com.apple.dock show-recents -bool false
  
  echo "Dock and Dashboard settings applied."
else
  echo "Skipping Dock and Dashboard settings."
fi

###############################################################################
# Safari & WebKit                                                             #
###############################################################################

if confirm "Apply Safari & WebKit settings?"; then
  # Enable the Develop menu and the Web Inspector in Safari
  defaults write com.apple.Safari IncludeDevelopMenu -bool true
  defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
  defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

  # Add a context menu item for showing the Web Inspector in web views
  defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
  
  echo "Safari & WebKit settings applied."
else
  echo "Skipping Safari & WebKit settings."
fi

###############################################################################
# Mail                                                                        #
###############################################################################

if confirm "Apply Mail settings?"; then
  # Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>`
  defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

  # Display emails in threaded mode
  defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"

  # Disable inline attachments (just show the icons)
  defaults write com.apple.mail DisableInlineAttachmentViewing -bool true
  
  echo "Mail settings applied."
else
  echo "Skipping Mail settings."
fi

###############################################################################
# Calendar                                                                    #
###############################################################################

if confirm "Apply Calendar settings?"; then
  # Show week numbers
  defaults write com.apple.iCal "Show Week Numbers" -bool true

  # Show 7 days
  defaults write com.apple.iCal "n days of week" -int 7

  # Week starts on Monday
  defaults write com.apple.iCal "first day of week" -int 1
  
  echo "Calendar settings applied."
else
  echo "Skipping Calendar settings."
fi

###############################################################################
# Terminal & iTerm 2                                                          #
###############################################################################

if confirm "Apply Terminal settings?"; then
  # Only use UTF-8 in Terminal.app
  defaults write com.apple.terminal StringEncodings -array 4

  # Use the Pro theme by default in Terminal.app
  defaults write com.apple.Terminal "Default Window Settings" -string "Pro"
  defaults write com.apple.Terminal "Startup Window Settings" -string "Pro"
  
  echo "Terminal settings applied."
else
  echo "Skipping Terminal settings."
fi

###############################################################################
# Activity Monitor                                                            #
###############################################################################

if confirm "Apply Activity Monitor settings?"; then
  # Show the main window when launching Activity Monitor
  defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

  # Show all processes in Activity Monitor
  defaults write com.apple.ActivityMonitor ShowCategory -int 0

  # Sort Activity Monitor results by CPU usage
  defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
  defaults write com.apple.ActivityMonitor SortDirection -int 0
  
  echo "Activity Monitor settings applied."
else
  echo "Skipping Activity Monitor settings."
fi

###############################################################################
# Messages                                                                    #
###############################################################################

if confirm "Apply Messages settings?"; then
  # Disable smart quotes as it's annoying for messages that contain code
  defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

  # Disable continuous spell checking
  defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false
  
  echo "Messages settings applied."
else
  echo "Skipping Messages settings."
fi

###############################################################################
# Photos                                                                      #
###############################################################################

if confirm "Apply Photos settings?"; then
  # Prevent Photos from opening automatically when devices are plugged in
  defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true
  
  echo "Photos settings applied."
else
  echo "Skipping Photos settings."
fi

###############################################################################
# TextEdit                                                                    #
###############################################################################

if confirm "Apply TextEdit settings?"; then
  # Use plain text mode for new TextEdit documents
  defaults write com.apple.TextEdit RichText -int 0

  # Open and save files as UTF-8 in TextEdit
  defaults write com.apple.TextEdit PlainTextEncoding -int 4
  defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4
  
  echo "TextEdit settings applied."
else
  echo "Skipping TextEdit settings."
fi

###############################################################################
# App Store                                                                   #
###############################################################################

if confirm "Apply App Store settings?"; then
  # Enable the automatic update check
  defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

  # Check for software updates daily, not just once per week
  defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

  # Download newly available updates in background
  defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

  # Install System data files & security updates
  defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

  # Turn on app auto-update
  defaults write com.apple.commerce AutoUpdate -bool true

  # Disable in-app rating requests
  defaults write com.apple.AppStore InAppReviewEnabled -bool false
  
  echo "App Store settings applied."
else
  echo "Skipping App Store settings."
fi

###############################################################################
# Restart affected applications                                               #
###############################################################################

if confirm "Restart affected applications? This will close Finder and Dock among others."; then
  echo "Done. Note that some of these changes require a logout/restart to take effect."
  echo "Restarting affected applications..."

  for app in "Dock" "Finder" "Safari" "SystemUIServer"; do
    killall "${app}" &> /dev/null
  done
  
  echo "Affected applications restarted."
else
  echo "Changes applied. Some changes may require manually restarting applications or logging out to take effect."
fi

echo "macOS defaults script completed!"
