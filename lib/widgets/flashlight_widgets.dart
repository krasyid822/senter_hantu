import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlashlightButton extends StatelessWidget {
  final bool isOn;
  final VoidCallback? onTap;
  final Animation<double> pulseAnimation;
  final Animation<double> rotationAnimation;

  const FlashlightButton({
    super.key,
    required this.isOn,
    required this.onTap,
    required this.pulseAnimation,
    required this.rotationAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap?.call();
      },
      child: AnimatedBuilder(
        animation: pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: isOn ? pulseAnimation.value : 1.0,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOn ? Colors.yellow[300] : Colors.grey[800],
                boxShadow: isOn
                    ? [
                        BoxShadow(
                          color: Colors.yellow.withValues(alpha: 0.5),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                border: Border.all(
                  color: isOn ? Colors.yellow[600]! : Colors.grey[600]!,
                  width: 3,
                ),
              ),
              child: AnimatedBuilder(
                animation: rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: isOn ? rotationAnimation.value * 2 * 3.14159 : 0,
                    child: Icon(
                      isOn ? Icons.flashlight_on : Icons.flashlight_off,
                      size: 80,
                      color: isOn ? Colors.black : Colors.white,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class BrightnessSlider extends StatelessWidget {
  final double brightness;
  final ValueChanged<double> onChanged;
  final bool isFlashlightOn;

  const BrightnessSlider({
    super.key,
    required this.brightness,
    required this.onChanged,
    required this.isFlashlightOn,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Kecerahan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isFlashlightOn ? Colors.black87 : Colors.white70,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isFlashlightOn ? Colors.orange[100] : Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'PWM Simulation Mode',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isFlashlightOn ? Colors.orange[800] : Colors.orange[300],
            ),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            children: [
              Icon(
                Icons.brightness_low,
                color: isFlashlightOn ? Colors.black54 : Colors.white54,
              ),
              Expanded(
                child: Slider(
                  value: brightness,
                  min: 0.1,
                  max: 1.0,
                  divisions: 9,
                  activeColor: isFlashlightOn ? Colors.orange : Colors.yellow,
                  inactiveColor: isFlashlightOn
                      ? Colors.grey[300]
                      : Colors.grey[700],
                  onChanged: (value) {
                    HapticFeedback.selectionClick();
                    onChanged(value);
                  },
                ),
              ),
              Icon(
                Icons.brightness_high,
                color: isFlashlightOn ? Colors.black54 : Colors.white54,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${(brightness * 100).round()}%',
              style: TextStyle(
                fontSize: 14,
                color: isFlashlightOn ? Colors.black54 : Colors.white54,
              ),
            ),
            const SizedBox(width: 10),
            if (brightness < 0.95)
              Icon(
                Icons.flash_on,
                size: 16,
                color: isFlashlightOn ? Colors.orange[600] : Colors.orange[300],
              ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          brightness >= 0.95
              ? 'Mode: Steady Light'
              : brightness <= 0.15
              ? 'Mode: Slow Pulse'
              : 'Mode: PWM Pulse',
          style: TextStyle(
            fontSize: 12,
            fontStyle: FontStyle.italic,
            color: isFlashlightOn ? Colors.black45 : Colors.white54,
          ),
        ),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 5,
      ),
    );
  }
}
