import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/flashlight_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _sosSpeed = 1.0;
  double _strobeSpeed = 1.0;
  bool _hapticFeedback = true;
  bool _keepScreenOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // SOS Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pengaturan SOS',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text('Kecepatan SOS'),
                  Slider(
                    value: _sosSpeed,
                    min: 0.5,
                    max: 2.0,
                    divisions: 6,
                    label: '${_sosSpeed.toStringAsFixed(1)}x',
                    onChanged: (value) {
                      setState(() {
                        _sosSpeed = value;
                      });
                      HapticFeedback.selectionClick();
                    },
                  ),
                  Text(
                    'Kecepatan: ${_sosSpeed.toStringAsFixed(1)}x',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Strobe Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pengaturan Strobe',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text('Kecepatan Strobe'),
                  Slider(
                    value: _strobeSpeed,
                    min: 0.1,
                    max: 2.0,
                    divisions: 19,
                    label: '${_strobeSpeed.toStringAsFixed(1)}x',
                    onChanged: (value) {
                      setState(() {
                        _strobeSpeed = value;
                      });
                      HapticFeedback.selectionClick();
                    },
                  ),
                  Text(
                    'Kecepatan: ${_strobeSpeed.toStringAsFixed(1)}x',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // General Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pengaturan Umum',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Haptic Feedback Toggle
                  SwitchListTile(
                    title: const Text('Haptic Feedback'),
                    subtitle: const Text(
                      'Getaran saat berinteraksi dengan tombol',
                    ),
                    value: _hapticFeedback,
                    onChanged: (value) {
                      setState(() {
                        _hapticFeedback = value;
                      });
                      if (value) {
                        HapticFeedback.mediumImpact();
                      }
                    },
                  ),

                  const Divider(),

                  // Keep Screen On Toggle
                  SwitchListTile(
                    title: const Text('Layar Tetap Hidup'),
                    subtitle: const Text(
                      'Mencegah layar mati saat flashlight aktif',
                    ),
                    value: _keepScreenOn,
                    onChanged: (value) {
                      setState(() {
                        _keepScreenOn = value;
                      });
                      if (_hapticFeedback) {
                        HapticFeedback.selectionClick();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Custom Patterns
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pola Kustom',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Quick Flash Patterns
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildPatternButton(
                        'Heartbeat',
                        [300, 100, 300, 500],
                        Icons.favorite,
                        Colors.red,
                      ),
                      _buildPatternButton(
                        'Police',
                        [100, 100, 100, 100, 100, 500],
                        Icons.local_police,
                        Colors.blue,
                      ),
                      _buildPatternButton(
                        'Disco',
                        [50, 50, 50, 50, 50, 50],
                        Icons.nightlife,
                        Colors.purple,
                      ),
                      _buildPatternButton(
                        'Morse A',
                        [200, 200, 600, 200],
                        Icons.abc,
                        Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // About Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tentang Aplikasi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text('Senter Hantu v1.0'),
                  const Text('Aplikasi senter dengan fitur advanced'),
                  const Text('Dioptimalkan untuk Android API Level 36'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.info_outline, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Flashlight tersedia: ${FlashlightService.hasFlashlight ? "Ya" : "Tidak"}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatternButton(
    String label,
    List<int> pattern,
    IconData icon,
    Color color,
  ) {
    return ElevatedButton.icon(
      onPressed: () async {
        if (_hapticFeedback) {
          HapticFeedback.mediumImpact();
        }
        await FlashlightService.blinkPattern(pattern);
      },
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: const Size(80, 36),
      ),
    );
  }
}
