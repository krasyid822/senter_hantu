# Contributing to Senter Hantu

Thank you for your interest in contributing to this project! This Flutter flashlight app is currently facing critical issues and **needs help from experienced developers**.

## 🚨 Current Project Status

**CRITICAL ISSUE**: The core flashlight functionality is not working. This project needs contributors with expertise in:

- Android hardware API development
- Flutter platform channels
- Camera/torch access on Android
- Device-specific compatibility issues

## 🔧 Priority Issues Needing Help

### 1. **Flashlight Control Failure** (CRITICAL)
- **Problem**: `torch_light` package fails on Oppo A74 4G
- **Error**: "Gagal mengontrol flashlight" 
- **Need**: Alternative implementation or device-specific workarounds

### 2. **Memory Management Issues** (HIGH)
- **Problem**: Out of memory during `flutter run`
- **Workaround**: Manual APK build required
- **Need**: Build process optimization

### 3. **Brightness Control** (MEDIUM)
- **Problem**: PWM simulation doesn't provide effective dimming
- **Current**: Timer-based on/off cycling
- **Need**: Better approach for brightness control

## 🛠️ How to Contribute

### Prerequisites
- Flutter SDK 3.9.0+
- Android development experience
- Physical Android device for testing
- Understanding of hardware API limitations

### Setup Development Environment
```bash
git clone [your-repo-url]
cd senter_hantu
flutter pub get

# Note: flutter run may fail with out of memory
# Use this workflow instead:
flutter clean
flutter build apk --debug
adb install build/app/outputs/flutter-apk/app-debug.apk
```

### Testing Process
1. **Install APK** on your Android device
2. **Test flashlight button** - currently shows error
3. **Document device info**: Brand, model, Android version
4. **Try alternative approaches** in code
5. **Report results** with detailed logs

## 🧪 Current Test Results

| Device | Brand | Model | Android | Status | Notes |
|--------|-------|-------|---------|--------|-------|
| CPH2219 | Oppo | A74 4G | Unknown | ❌ Failed | torch_light package not working |

**WE NEED MORE DEVICE TESTING DATA!**

## 💡 Contribution Ideas

### For Android Experts
- Implement native Android module using platform channels
- Research device-specific flashlight access methods
- Create fallback mechanisms for different manufacturers

### For Flutter Developers
- Optimize memory usage and build process
- Improve error handling and user feedback
- Create device compatibility detection

### For Testers
- Test on different Android devices and brands
- Document device-specific behaviors
- Create compatibility matrix

## 📝 Contribution Guidelines

### Code Style
- Follow Dart/Flutter best practices
- Add comments explaining device-specific workarounds
- Include error handling for all hardware access

### Commit Messages
```
feat: add Samsung-specific flashlight implementation
fix: resolve memory leak in flashlight service
test: add device compatibility for Xiaomi Mi 11
docs: update troubleshooting for OnePlus devices
```

### Pull Request Process
1. **Fork** the repository
2. **Create feature branch**: `git checkout -b fix/flashlight-samsung`
3. **Test thoroughly** on your device
4. **Document changes** in CHANGELOG.md
5. **Update README** if needed
6. **Submit PR** with detailed description

### Pull Request Template
```markdown
## What this PR does
- [ ] Fixes flashlight control on [Device Brand/Model]
- [ ] Improves memory usage
- [ ] Adds device compatibility
- [ ] Updates documentation

## Testing
- **Device**: [Brand Model]
- **Android Version**: [Version]
- **Test Results**: [Describe what works/doesn't work]

## Changes Made
- [List key changes]
- [Explain approach used]

## Breaking Changes
- [Any breaking changes]
```

## 🐛 Bug Report Guidelines

When reporting issues, please include:

```markdown
**Device Information**
- Brand: [e.g., Samsung]
- Model: [e.g., Galaxy S21]
- Android Version: [e.g., 13]
- API Level: [e.g., 33]

**Issue Description**
- [Detailed description]
- [Steps to reproduce]
- [Expected vs actual behavior]

**Error Logs**
```
[Paste any error messages or logs here]
```

**Screenshots**
[If applicable]
```

## 🎯 Areas Needing Immediate Help

### 1. Alternative Flashlight Libraries
Research and test alternatives to `torch_light`:
- `flashlight` package
- `camera` package with flash control
- Native Android implementations

### 2. Platform Channels Implementation
Create native Android module:
```kotlin
// Example approach needed
class FlashlightPlugin {
    private fun enableFlashlight(): Boolean {
        // Direct Android Camera2 API access
        // Handle device-specific implementations
    }
}
```

### 3. Device Compatibility Matrix
Build comprehensive device testing:
- Samsung devices
- Xiaomi devices  
- OnePlus devices
- Oppo devices (currently failing)
- Vivo devices
- Google Pixel devices

## 📚 Resources for Contributors

### Android Flashlight Development
- [Camera2 API Documentation](https://developer.android.com/reference/android/hardware/camera2/package-summary)
- [CameraManager Flash Methods](https://developer.android.com/reference/android/hardware/camera2/CameraManager)
- [Flutter Platform Channels](https://docs.flutter.dev/development/platform-integration/platform-channels)

### Device-Specific Issues
- [OEM Camera API Differences](https://developer.android.com/guide/topics/media/camera)
- [Permission Handling Variations](https://developer.android.com/training/permissions/requesting)

## 🏆 Recognition

Contributors who help solve the core flashlight issue will be:
- Listed as project collaborators
- Credited in README
- Added to CONTRIBUTORS.md file

## ❓ Questions?

- **Technical Questions**: Open a GitHub issue with `question` label
- **General Discussion**: Start a GitHub discussion
- **Device Testing**: Report results as GitHub issues with `device-test` label

---

**This project needs your expertise! Even partial solutions or device-specific workarounds are valuable contributions.**
