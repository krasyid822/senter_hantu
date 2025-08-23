import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'services/flashlight_service.dart';
import 'widgets/flashlight_widgets.dart';
import 'theme/app_theme.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const SenterHantuApp());
}

class SenterHantuApp extends StatelessWidget {
  const SenterHantuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Senter Hantu',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const FlashlightScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FlashlightScreen extends StatefulWidget {
  const FlashlightScreen({super.key});

  @override
  State<FlashlightScreen> createState() => _FlashlightScreenState();
}

class _FlashlightScreenState extends State<FlashlightScreen>
    with TickerProviderStateMixin {
  bool _isFlashlightOn = false;
  bool _hasFlashlight = false;
  double _brightness = 1.0;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _initializeFlashlight();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    FlashlightService.dispose();
    super.dispose();
  }

  Future<void> _initializeFlashlight() async {
    try {
      print('Main: Starting flashlight initialization');
      await FlashlightService.initialize();

      setState(() {
        _hasFlashlight = FlashlightService.hasFlashlight;
      });

      print(
        'Main: Flashlight initialization completed. HasFlashlight: $_hasFlashlight',
      );

      // Listen to flashlight status changes
      FlashlightService.statusStream.listen((isOn) {
        setState(() {
          _isFlashlightOn = isOn;
        });

        if (isOn) {
          _pulseController.repeat(reverse: true);
          _rotationController.repeat();
        } else {
          _pulseController.stop();
          _rotationController.stop();
        }
      });

      // Listen to brightness changes
      FlashlightService.brightnessStream.listen((brightness) {
        setState(() {
          _brightness = brightness;
        });
      });

      setState(() {
        _hasFlashlight = FlashlightService.hasFlashlight;
        _brightness = FlashlightService.brightness;
      });

      // Request permission if needed
      final permission = await FlashlightService.requestCameraPermission();
      if (permission != PermissionStatus.granted) {
        _showPermissionDialog();
      }
    } catch (e) {
      print('Main: Error during flashlight initialization: $e');
      _showErrorDialog('Gagal menginisialisasi flashlight: ${e.toString()}');
    }
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Izin Kamera Diperlukan'),
          content: const Text(
            'Aplikasi ini memerlukan izin kamera untuk mengontrol flashlight.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Pengaturan'),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _toggleFlashlight() async {
    if (!_hasFlashlight) {
      _showErrorDialog('Flashlight tidak tersedia di perangkat ini');
      return;
    }

    try {
      // Check camera permission first
      final permission = await Permission.camera.status;
      if (!permission.isGranted) {
        final result = await Permission.camera.request();
        if (!result.isGranted) {
          _showErrorDialog(
            'Izin kamera diperlukan untuk menggunakan flashlight',
          );
          return;
        }
      }

      final success = await FlashlightService.toggle();
      if (!success) {
        _showErrorDialog('Gagal mengontrol flashlight. Coba restart aplikasi.');
        return;
      }

      // Haptic feedback
      if (FlashlightService.isFlashlightOn) {
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      _showErrorDialog('Error: ${e.toString()}');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _startSOSSignal() async {
    if (!_hasFlashlight) return;

    await FlashlightService.startSOSSignal();
    HapticFeedback.heavyImpact();
  }

  Future<void> _startStrobeMode() async {
    if (!_hasFlashlight) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mode Strobe'),
          content: const Text(
            'Mode strobe akan berjalan selama 10 detik. Tekan OK untuk memulai.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                Navigator.of(context).pop();
                await FlashlightService.startStrobeMode();
                HapticFeedback.heavyImpact();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isFlashlightOn ? Colors.white : Colors.black,
      appBar: AppBar(
        title: const Text(
          'Senter Hantu',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: _isFlashlightOn ? Colors.grey[300] : Colors.grey[900],
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: _isFlashlightOn ? Colors.grey[300] : Colors.grey[900],
          statusBarIconBrightness: _isFlashlightOn
              ? Brightness.dark
              : Brightness.light,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _isFlashlightOn
                ? [Colors.white, Colors.grey[100]!]
                : [Colors.black, Colors.grey[900]!],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Status text
              Text(
                _isFlashlightOn ? 'FLASHLIGHT ON' : 'FLASHLIGHT OFF',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _isFlashlightOn ? Colors.black54 : Colors.white70,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 40),

              // Main flashlight button
              FlashlightButton(
                isOn: _isFlashlightOn,
                onTap: _hasFlashlight ? _toggleFlashlight : null,
                pulseAnimation: _pulseAnimation,
                rotationAnimation: _rotationAnimation,
              ),

              const SizedBox(height: 60),

              // Brightness control
              if (_isFlashlightOn)
                BrightnessSlider(
                  brightness: _brightness,
                  isFlashlightOn: _isFlashlightOn,
                  onChanged: (value) async {
                    await FlashlightService.setBrightness(value);
                  },
                ),

              const SizedBox(height: 40),

              // Flash availability status
              if (!_hasFlashlight)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.red[900],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning, color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Flashlight tidak tersedia',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _isFlashlightOn ? Colors.grey[200] : Colors.grey[900],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // SOS Button
            ActionButton(
              icon: Icons.sos,
              label: 'SOS',
              onPressed: _hasFlashlight ? _startSOSSignal : null,
              backgroundColor: Colors.red[700]!,
            ),

            // Strobe Button
            ActionButton(
              icon: Icons.flash_on,
              label: 'Strobe',
              onPressed: _hasFlashlight ? _startStrobeMode : null,
              backgroundColor: Colors.blue[700]!,
            ),
          ],
        ),
      ),
    );
  }
}
