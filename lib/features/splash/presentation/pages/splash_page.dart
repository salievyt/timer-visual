import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../widgets/wave_painter.dart';
import '../widgets/timer_button.dart';

/// Главный экран приложения с анимацией волны
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _fillController;

  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _startAnimationSequence();
  }

  void _initControllers() {
    _waveController = AnimationController(
      vsync: this,
      duration: AppDurations.waveAnimation,
    )..repeat();

    _fillController = AnimationController(
      vsync: this,
      duration: AppDurations.fillAnimation,
    );
  }

  Future<void> _startAnimationSequence() async {
    // Этап 1: Наполнение до верха
    await _fillController.animateTo(
      1.0,
      duration: AppDurations.fillToFull,
      curve: Curves.easeInOut,
    );

    // Этап 2: Пауза
    await Future.delayed(AppDurations.fillPause);

    // Этап 3: Возврат к уровню 0.8
    await _fillController.animateTo(
      0.2,
      duration: AppDurations.fillReturn,
      curve: Curves.elasticOut,
    );

    // Этап 4: Показать контент
    if (mounted) {
      setState(() {
        _showContent = true;
      });
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    _fillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildContent(),
          _buildWaveLayer(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AnimatedOpacity(
        opacity: _showContent ? 1.0 : 0.0,
        duration: AppDurations.contentFade,
        child: AppBar(
          title: const Text('Timer'),
          centerTitle: true,
          foregroundColor: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return AnimatedOpacity(
      opacity: _showContent ? 1.0 : 0.0,
      duration: AppDurations.contentFade,
      child: Column(
        children: [
          const Spacer(flex: 1),
          const Center(child: TimerButton()),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildWaveLayer() {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: Listenable.merge([_waveController, _fillController]),
        builder: (context, child) {
          return CustomPaint(
            size: Size.infinite,
            painter: WavePainter(
              wavePhase: _waveController.value,
              fillLevel: _fillController.value,
            ),
          );
        },
      ),
    );
  }
}
