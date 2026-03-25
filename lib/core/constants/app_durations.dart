/// Длительности анимаций в приложении
class AppDurations {
  AppDurations._();

  // Волна
  static const Duration waveAnimation = Duration(seconds: 2);

  // Наполнение
  static const Duration fillAnimation = Duration(seconds: 2);
  static const Duration fillToFull = Duration(seconds: 3);
  static const Duration fillReturn = Duration(seconds: 5);

  // Пауза
  static const Duration fillPause = Duration(seconds: 1);

  // Появление контента
  static const Duration contentFade = Duration(seconds: 1);

  // Кнопка
  static const Duration buttonHover = Duration(milliseconds: 200);
  static const Duration buttonSwitch = Duration(milliseconds: 300);
  static const Duration timerDuration = Duration(seconds: 10);

  // Переход
  static const Duration pageTransition = Duration(milliseconds: 900);
}
