import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

/// Параметры для отрисовки волны
class WaveConfig {
  final double phase;
  final double amplitude;
  final double frequency;
  final double opacity;
  final Color color;

  const WaveConfig({
    required this.phase,
    required this.amplitude,
    required this.frequency,
    required this.opacity,
    required this.color,
  });
}

/// Painter для отрисовки анимированной волны наполнения
class WavePainter extends CustomPainter {
  final double wavePhase;
  final double fillLevel;

  WavePainter({
    required this.wavePhase,
    required this.fillLevel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final baseY = _calculateBaseY(size);
    final gradient = _createGradient(size);

    // Задняя волна
    _drawWave(
      canvas: canvas,
      size: size,
      config: WaveConfig(
        phase: wavePhase,
        amplitude: 10.0,
        frequency: 1.5,
        opacity: 0.4,
        color: AppColors.waveBack,
      ),
      baseY: baseY,
      gradient: gradient,
    );

    // Передняя волна
    _drawWave(
      canvas: canvas,
      size: size,
      config: WaveConfig(
        phase: wavePhase + 0.5,
        amplitude: 15.0,
        frequency: 1.0,
        opacity: 0.6,
        color: AppColors.waveFront,
      ),
      baseY: baseY,
      gradient: gradient,
    );
  }

  double _calculateBaseY(Size size) {
    // fillLevel: 0.0 = низ, 1.0 = верх
    return size.height * (1.0 - fillLevel);
  }

  Shader _createGradient(Size size) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: AppColors.waveGradient,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
  }

  void _drawWave({
    required Canvas canvas,
    required Size size,
    required WaveConfig config,
    required double baseY,
    required Shader gradient,
  }) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = gradient
      ..color = config.color.withValues(alpha: config.opacity);

    final path = _createWavePath(
      size: size,
      phase: config.phase,
      amplitude: config.amplitude,
      frequency: config.frequency,
      baseY: baseY,
    );

    canvas.drawPath(path, paint);
  }

  Path _createWavePath({
    required Size size,
    required double phase,
    required double amplitude,
    required double frequency,
    required double baseY,
  }) {
    final path = Path();
    path.moveTo(0, baseY);

    for (double x = 0; x <= size.width; x++) {
      final y = _calculateWaveY(
        x: x,
        width: size.width,
        phase: phase,
        amplitude: amplitude,
        frequency: frequency,
        baseY: baseY,
      );
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  double _calculateWaveY({
    required double x,
    required double width,
    required double phase,
    required double amplitude,
    required double frequency,
    required double baseY,
  }) {
    final normalizedX = x / width;
    final waveOffset = normalizedX * frequency * 2 * math.pi;
    final phaseOffset = phase * 2 * math.pi;
    return baseY + math.sin(waveOffset + phaseOffset) * amplitude;
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) {
    return oldDelegate.wavePhase != wavePhase ||
        oldDelegate.fillLevel != fillLevel;
  }
}
