# Senter Hantu v0.1.0-alpha - Initial Release

⚠️ **WARNING: THIS IS A NON-FUNCTIONAL ALPHA RELEASE** ⚠️

## 🚨 CRITICAL NOTICE

**This app does not work for its intended purpose (flashlight control).** This release is published for:

1. **Educational purposes** - Flutter development learning
2. **Seeking developer assistance** - Need help with Android hardware API
3. **Code review and collaboration** - Looking for experienced contributors
4. **Device compatibility testing** - Testing across different Android devices

**DO NOT rely on this app for emergency flashlight needs.**

## 📱 Installation

### Download Options:
- **Release APK**: `senter-hantu-v0.1.0-alpha.apk` (41.6MB) - Optimized release build
- **Debug APK**: `senter-hantu-v0.1.0-alpha-debug.apk` - Debug build with logging

### Installation Steps:
1. Download the APK file to your Android device
2. Enable "Install from unknown sources" in your device settings
3. Tap the APK file to install
4. Grant camera permission when prompted

## ✅ What Works

- ✅ **App Installation**: Installs and launches without crashes
- ✅ **UI Navigation**: All screens accessible and responsive
- ✅ **Animations**: Smooth Material Design 3 animations
- ✅ **Theme Toggle**: Dark/Light mode switching
- ✅ **Settings Screen**: Configuration options available
- ✅ **Permission Requests**: Properly requests camera permission

## ❌ What Doesn't Work

- ❌ **Flashlight Control**: Main button shows error "Gagal mengontrol flashlight"
- ❌ **Brightness Slider**: No effect on flashlight (PWM simulation failed)
- ❌ **SOS Mode**: Cannot test due to flashlight control failure
- ❌ **Strobe Mode**: Cannot test due to flashlight control failure

## 🔧 Technical Details

### Tested Environment:
- **Device**: Oppo A74 4G (CPH2219)
- **Build Tool**: Flutter 3.9.0
- **Target Android API**: 36
- **Minimum Android API**: 21

### Known Issues:
- `torch_light` package fails on Oppo devices
- Out of memory errors during `flutter run` (resolved with manual APK build)
- Device-specific compatibility problems

### Error Messages You'll See:
- "Gagal mengontrol flashlight" - Main flashlight control error
- "Izin kamera diperlukan" - Camera permission required (normal)
- "Flashlight tidak tersedia di perangkat ini" - Hardware not detected

## 🆘 Help Wanted

This project needs contributors with expertise in:

### Android Development:
- Native Android hardware API access
- Camera2 API and flashlight control
- Device-specific manufacturer implementations
- Platform channels in Flutter

### Areas for Contribution:
1. **Alternative flashlight libraries** research and implementation
2. **Native Android module** development using platform channels
3. **Device compatibility testing** across different brands
4. **Memory optimization** for build process

### How to Help:
1. Fork the repository
2. Test on your Android device
3. Report device compatibility results
4. Submit pull requests with fixes
5. Share knowledge about Android flashlight APIs

## 📊 Device Compatibility

Please help us build a compatibility matrix:

| Device | Brand | Model | Android | Status | Notes |
|--------|-------|-------|---------|--------|-------|
| CPH2219 | Oppo | A74 4G | ? | ❌ Failed | torch_light package error |
| ? | ? | ? | ? | ? | **YOUR DEVICE HERE** |

## 🐛 Bug Reports

If you test this app, please report your results:

**Template for GitHub Issues:**
```markdown
**Device**: [Brand Model]
**Android Version**: [Version]
**APK Tested**: [Release/Debug]
**Result**: [Working/Failed]
**Error Message**: [If any]
**Notes**: [Additional observations]
```

## 📚 Documentation

- **README.md**: Comprehensive project overview and status
- **CONTRIBUTING.md**: Detailed guide for contributors
- **CHANGELOG.md**: Development history and known issues

## 🔗 Repository

**GitHub**: [Repository URL to be added]

## 📄 License

MIT License - See LICENSE file for details

**Disclaimer**: This software is provided as-is for educational purposes. The authors are not responsible for any issues or damages from using this non-functional app.

---

## For Developers

### Building from Source:
```bash
git clone [repository-url]
cd senter_hantu
flutter pub get

# Note: flutter run may fail with out of memory
# Use this approach instead:
flutter clean
flutter build apk --release
```

### Project Structure:
- `lib/main.dart` - Main app entry point
- `lib/services/flashlight_service.dart` - Core issue is here
- `lib/widgets/flashlight_widgets.dart` - UI components
- `lib/screens/settings_screen.dart` - Settings implementation

### Key Files to Review:
- **Flashlight Service**: The main problem area needing fixes
- **PWM Implementation**: Failed brightness control attempt
- **Error Handling**: Comprehensive logging for debugging

**Thank you for any help you can provide to make this project functional!** 🙏
