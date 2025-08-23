import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';
import 'package:permission_handler/permission_handler.dart';

class TestFlashlightScreen extends StatefulWidget {
  const TestFlashlightScreen({super.key});

  @override
  State<TestFlashlightScreen> createState() => _TestFlashlightScreenState();
}

class _TestFlashlightScreenState extends State<TestFlashlightScreen> {
  bool _isFlashlightOn = false;
  String _statusMessage = "Belum ditest";
  bool _hasFlashlight = false;

  @override
  void initState() {
    super.initState();
    _checkFlashlight();
  }

  Future<void> _checkFlashlight() async {
    try {
      final hasFlash = await TorchLight.isTorchAvailable();
      setState(() {
        _hasFlashlight = hasFlash;
        _statusMessage = hasFlash
            ? "Flashlight tersedia"
            : "Flashlight TIDAK tersedia";
      });
      print("Flashlight available: $hasFlash");
    } catch (e) {
      setState(() {
        _statusMessage = "Error checking flashlight: $e";
      });
      print("Error checking flashlight: $e");
    }
  }

  Future<void> _testFlashlight() async {
    setState(() {
      _statusMessage = "Testing flashlight...";
    });

    try {
      // Check permission
      final permission = await Permission.camera.status;
      print("Camera permission status: $permission");

      if (!permission.isGranted) {
        print("Requesting camera permission...");
        final result = await Permission.camera.request();
        print("Permission request result: $result");

        if (!result.isGranted) {
          setState(() {
            _statusMessage = "Izin kamera ditolak";
          });
          return;
        }
      }

      if (!_hasFlashlight) {
        setState(() {
          _statusMessage = "Flashlight tidak tersedia di device ini";
        });
        return;
      }

      // Test torch light
      if (_isFlashlightOn) {
        print("Turning OFF flashlight...");
        await TorchLight.disableTorch();
        setState(() {
          _isFlashlightOn = false;
          _statusMessage = "Flashlight OFF - SUCCESS!";
        });
      } else {
        print("Turning ON flashlight...");
        await TorchLight.enableTorch();
        setState(() {
          _isFlashlightOn = true;
          _statusMessage = "Flashlight ON - SUCCESS!";
        });
      }
    } catch (e) {
      print("Error controlling flashlight: $e");
      setState(() {
        _statusMessage = "ERROR: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Flashlight'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isFlashlightOn ? Icons.flashlight_on : Icons.flashlight_off,
                size: 100,
                color: _isFlashlightOn ? Colors.yellow : Colors.grey,
              ),
              const SizedBox(height: 20),
              Text(
                'Status: ${_isFlashlightOn ? "ON" : "OFF"}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _statusMessage,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _testFlashlight,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFlashlightOn ? Colors.red : Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                child: Text(
                  _isFlashlightOn ? 'TURN OFF' : 'TURN ON',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkFlashlight,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  'CHECK AGAIN',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
