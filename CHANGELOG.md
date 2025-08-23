# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased - v0.1.0-alpha] - 2025-08-23

### 🚨 KNOWN ISSUES
- **CRITICAL**: Flashlight control not working on Oppo A74 4G (CPH2219)
- **BUILD**: Out of memory errors during `flutter run` command
- **FEATURE**: Brightness control PWM simulation ineffective
- **COMPATIBILITY**: torch_light package device compatibility issues

### ✅ Added
- Basic Flutter app structure with Material Design 3
- Flashlight toggle UI with animations
- Brightness slider with PWM simulation attempt
- SOS and Strobe mode implementations (untested due to core issue)
- Settings screen with theme toggle
- Dark/Light theme support
- Haptic feedback for interactions
- Custom widget components (FlashlightButton, BrightnessSlider)
- Comprehensive error handling and logging

### ✅ Infrastructure
- Android build configuration for API Level 36
- Proper Android permissions (CAMERA, FLASHLIGHT)
- Flutter project structure with services/widgets separation
- Gradle build optimizations
- APK build process working (release: 41.6MB)

### ❌ Failed Features
- Core flashlight control functionality
- Real brightness control (hardware or software)
- Device compatibility testing
- Reliable build process via flutter run

### 🔧 Technical Details
- **Flutter SDK**: 3.9.0
- **Target Android API**: 36
- **Min Android API**: 21
- **Dependencies**: torch_light, permission_handler (camera dependency removed)
- **Build Method**: flutter build apk (manual process required)
- **Tested Device**: Oppo A74 4G - FAILED

### 📚 Documentation
- Comprehensive README with project status
- Issue documentation and troubleshooting guide
- Call for help from Android hardware API experts
- Technical analysis of failures

---

## Release Notes

### Version 0.1.0-alpha - "Proof of Concept"

**STATUS: NOT FUNCTIONAL - DEVELOPMENT ASSISTANCE NEEDED**

This is an alpha release that demonstrates the UI and project structure, but the core flashlight functionality is not working. This release is intended for:

1. **Educational purposes** - Learning Flutter development
2. **Collaboration** - Seeking help from experienced developers
3. **Code review** - Getting feedback on architecture and approach
4. **Device testing** - Testing compatibility across different Android devices

**DO NOT USE THIS IN PRODUCTION OR EMERGENCY SITUATIONS**

The APK can be installed and will show a functional UI, but the flashlight control will display error messages when attempted to be used.

### Installation
1. Download `app-release.apk` from GitHub releases
2. Enable "Install from unknown sources" on your Android device
3. Install the APK
4. Note: The app will not successfully control your device's flashlight

### Known Working Features
- ✅ App launches without crashes
- ✅ UI navigation and animations
- ✅ Settings screen and theme toggle
- ✅ Permission request dialogs

### Known Broken Features
- ❌ Flashlight on/off toggle
- ❌ Brightness control
- ❌ SOS signal mode
- ❌ Strobe mode

### For Developers
If you have experience with:
- Android hardware API development
- Flutter platform channels
- Camera/flashlight low-level access
- Device-specific Android issues

Your contributions would be greatly appreciated! See the README for detailed information on how to help.
