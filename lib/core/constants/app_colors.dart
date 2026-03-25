import 'package:flutter/material.dart';

/// Цветовая схема приложения
class AppColors {
  AppColors._();

  // Основные цвета
  static const Color primary = Color.fromARGB(255, 3, 168, 244);
  static const Color primaryLight = Color.fromARGB(195, 33, 149, 243);
  static const Color primaryDark = Color.fromARGB(255, 30, 136, 229);

  // Цвета для волн
  static const Color waveBack = Color.fromARGB(217, 3, 168, 244);
  static const Color waveFront = Color.fromARGB(195, 33, 149, 243);

  // Градиент волны
  static const List<Color> waveGradient = [
    Colors.lightBlueAccent,
    Color(0xff0d47a1), // blue.shade900
  ];

  // Цвета кнопки
  static const Color buttonDefault = Colors.blue;
  static const Color buttonDisabled = Colors.blueGrey;
  static const Color buttonText = Colors.white;

  // Тени
  static const Color shadowLight = Color.fromARGB(25, 0, 0, 0);
  static const Color shadowDark = Color.fromARGB(51, 0, 0, 0);
}
