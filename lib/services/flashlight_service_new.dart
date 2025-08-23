import 'dart:async';
import 'package:camera/camera.dart';
import 'package:torch_light/torch_light.dart';
import 'package:permission_handler/permission_handler.dart';

class FlashlightService {
  static bool _isFlashlightOn = false;
  static bool _hasFlashlight = false;
  static double _brightness = 1.0;
  static StreamController<bool>? _statusController;
  static StreamController<double>? _brightnessController;
  static CameraController? _cameraController;
  static Timer? _pulseTimer;
  static bool _supportsBrightnessControl = false;

  static Stream<bool> get statusStream => _statusController!.stream;
  static Stream<double> get brightnessStream => _brightnessController!.stream;
  static bool get isFlashlightOn => _isFlashlightOn;
  static bool get hasFlashlight => _hasFlashlight;
  static double get brightness => _brightness;
  static bool get supportsBrightnessControl => _supportsBrightnessControl;

  static Future<void> initialize() async {
    _statusController = StreamController<bool>.broadcast();
    _brightnessController = StreamController<double>.broadcast();
    await checkFlashlightAvailability();
    await requestCameraPermission();
    await _initializeCamera();
  }

  static void dispose() {
    if (_isFlashlightOn) {
      turnOff();
    }
    _pulseTimer?.cancel();
    _cameraController?.dispose();
    _statusController?.close();
    _brightnessController?.close();
  }

  static Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
          cameras.first,
          ResolutionPreset.low,
          enableAudio: false,
        );
        await _cameraController!.initialize();

        // Enable brightness control simulation for all devices
        _supportsBrightnessControl = true;
      }
    } catch (e) {
      _supportsBrightnessControl = false;
    }
  }

  static Future<bool> checkFlashlightAvailability() async {
    try {
      _hasFlashlight = await TorchLight.isTorchAvailable();
      return _hasFlashlight;
    } catch (e) {
      _hasFlashlight = false;
      return false;
    }
  }

  static Future<PermissionStatus> requestCameraPermission() async {
    return await Permission.camera.request();
  }

  static Future<bool> turnOn({double? brightness}) async {
    if (!_hasFlashlight) return false;

    try {
      if (brightness != null) {
        _brightness = brightness;
      }

      await TorchLight.enableTorch();
      _isFlashlightOn = true;
      _statusController?.add(_isFlashlightOn);

      // Apply brightness control
      await _applyBrightness();

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> turnOff() async {
    try {
      _pulseTimer?.cancel();
      await TorchLight.disableTorch();
      _isFlashlightOn = false;
      _statusController?.add(_isFlashlightOn);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> toggle() async {
    if (_isFlashlightOn) {
      return await turnOff();
    } else {
      return await turnOn();
    }
  }

  static Future<void> setBrightness(double brightness) async {
    _brightness = brightness.clamp(0.1, 1.0);
    _brightnessController?.add(_brightness);

    if (_isFlashlightOn) {
      await _applyBrightness();
    }
  }

  static Future<void> _applyBrightness() async {
    if (!_isFlashlightOn) return;

    _pulseTimer?.cancel();

    if (_brightness >= 0.95) {
      // Full brightness - steady on
      await TorchLight.enableTorch();
    } else if (_brightness <= 0.15) {
      // Very low brightness - slow pulse
      _startPulsing(Duration(milliseconds: (800 * (1 - _brightness)).round()));
    } else {
      // Medium brightness - fast pulse to simulate dimming
      final pulseSpeed = (100 + (300 * (1 - _brightness))).round();
      _startPulsing(Duration(milliseconds: pulseSpeed));
    }
  }

  static void _startPulsing(Duration interval) {
    _pulseTimer?.cancel();

    bool isOn = true;
    int cycleCount = 0;
    final onDuration = (interval.inMilliseconds * _brightness).round();
    final offDuration = interval.inMilliseconds - onDuration;

    _pulseTimer = Timer.periodic(Duration(milliseconds: 50), (timer) async {
      if (!_isFlashlightOn) {
        timer.cancel();
        return;
      }

      cycleCount += 50;

      if (isOn && cycleCount >= onDuration) {
        await TorchLight.disableTorch();
        isOn = false;
        cycleCount = 0;
      } else if (!isOn && cycleCount >= offDuration) {
        await TorchLight.enableTorch();
        isOn = true;
        cycleCount = 0;
      }
    });
  }

  // SOS Signal (... --- ...)
  static Future<void> startSOSSignal() async {
    if (!_hasFlashlight) return;

    // Turn off current flashlight
    if (_isFlashlightOn) {
      await turnOff();
    }

    // SOS pattern: 3 short, 3 long, 3 short
    for (int i = 0; i < 3; i++) {
      // 3 short flashes
      for (int j = 0; j < 3; j++) {
        await TorchLight.enableTorch();
        await Future.delayed(const Duration(milliseconds: 200));
        await TorchLight.disableTorch();
        await Future.delayed(const Duration(milliseconds: 200));
      }

      await Future.delayed(const Duration(milliseconds: 500));

      // 3 long flashes
      for (int j = 0; j < 3; j++) {
        await TorchLight.enableTorch();
        await Future.delayed(const Duration(milliseconds: 600));
        await TorchLight.disableTorch();
        await Future.delayed(const Duration(milliseconds: 200));
      }

      await Future.delayed(const Duration(milliseconds: 500));

      // 3 short flashes
      for (int j = 0; j < 3; j++) {
        await TorchLight.enableTorch();
        await Future.delayed(const Duration(milliseconds: 200));
        await TorchLight.disableTorch();
        await Future.delayed(const Duration(milliseconds: 200));
      }

      if (i < 2) {
        await Future.delayed(const Duration(milliseconds: 1000));
      }
    }
  }

  // Strobe Mode
  static Future<void> startStrobeMode({
    Duration duration = const Duration(seconds: 10),
  }) async {
    if (!_hasFlashlight) return;

    // Turn off current flashlight
    if (_isFlashlightOn) {
      await turnOff();
    }

    // Strobe for specified duration
    final endTime = DateTime.now().add(duration);
    while (DateTime.now().isBefore(endTime)) {
      await TorchLight.enableTorch();
      await Future.delayed(const Duration(milliseconds: 100));
      await TorchLight.disableTorch();
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  // Custom pattern blink
  static Future<void> blinkPattern(List<int> pattern) async {
    if (!_hasFlashlight) return;

    // Turn off current flashlight
    if (_isFlashlightOn) {
      await turnOff();
    }

    for (int duration in pattern) {
      await TorchLight.enableTorch();
      await Future.delayed(Duration(milliseconds: duration));
      await TorchLight.disableTorch();
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
}
