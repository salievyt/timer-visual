import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/constants.dart';

/// Кнопка с таймером обратного отсчёта и вводом времени
class TimerButton extends StatefulWidget {
  final VoidCallback? onPressed;

  const TimerButton({
    super.key,
    this.onPressed,
  });

  @override
  State<TimerButton> createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  bool _isTimerRunning = false;
  bool _showInput = false;
  int _timerSeconds = 10;
  final TextEditingController _inputController = TextEditingController();

  late AnimationController _timerController;

  @override
  void initState() {
    super.initState();
    _inputController.text = _timerSeconds.toString();
    _initTimerController();
  }

  void _initTimerController() {
    _timerController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _timerSeconds),
    );

    _timerController.addStatusListener(_onTimerStatusChanged);
    _timerController.addListener(_onTimerTick);
  }

  void _onTimerStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _isTimerRunning = false;
      });
      _timerController.reset();
    }
  }

  void _onTimerTick() {
    setState(() {});
  }

  void _startTimer() {
    if (_isTimerRunning) return;

    setState(() {
      _isTimerRunning = true;
    });
    _timerController.forward();
    widget.onPressed?.call();
  }

  void _onInputSubmitted(String value) {
    final seconds = int.tryParse(value);
    if (seconds != null && seconds > 0 && seconds <= 3600) {
      setState(() {
        _timerSeconds = seconds;
        _showInput = false;
      });
      _timerController.duration = Duration(seconds: seconds);
    }
  }

  void _toggleInput() {
    setState(() {
      _showInput = !_showInput;
      if (!_showInput) {
        _inputController.text = _timerSeconds.toString();
      }
    });
  }

  @override
  void dispose() {
    _timerController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: AppDurations.buttonHover,
        child: _showInput ? _buildInputMode() : _buildButton(),
      ),
    );
  }

  Widget _buildInputMode() {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Секунды:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 100,
            child: TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
              ),
              onSubmitted: _onInputSubmitted,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => _onInputSubmitted(_inputController.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildTimerCircle(),
        _buildMainButton(),
        _buildSettingsButton(),
      ],
    );
  }

  Widget _buildSettingsButton() {
    return Positioned(
      top: 0,
      right: 0,
      child: GestureDetector(
        onTap: _toggleInput,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
              ),
            ],
          ),
          child: const Icon(
            Icons.settings,
            size: 20,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildTimerCircle() {
    return SizedBox(
      width: 230,
      height: 230,
      child: AnimatedBuilder(
        animation: _timerController,
        builder: (context, child) {
          return CustomPaint(
            painter: TimerCirclePainter(
              progress: _timerController.value,
              color: AppColors.primary,
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainButton() {
    return SizedBox(
      width: 200,
      height: 200,
      child: ElevatedButton(
        onPressed: _startTimer,
        style: _buildButtonStyle(),
        child: _buildButtonContent(),
      ),
    );
  }

  ButtonStyle _buildButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor:
          _isTimerRunning ? AppColors.buttonDisabled : AppColors.buttonDefault,
      foregroundColor: AppColors.buttonText,
      elevation: _isHovered ? 20 : 0,
      shape: const CircleBorder(),
    );
  }

  Widget _buildButtonContent() {
    return AnimatedSwitcher(
      duration: AppDurations.buttonSwitch,
      child: _isTimerRunning
          ? _buildTimerText()
          : _buildStartText(),
    );
  }

  Widget _buildTimerText() {
    final remainingSeconds = (_timerSeconds * (1 - _timerController.value)).ceil();
    return Text(
      '$remainingSeconds',
      key: const ValueKey('timer'),
      style: const TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildStartText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Start',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$_timerSeconds сек',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

/// Painter для кругового таймера
class TimerCirclePainter extends CustomPainter {
  final double progress;
  final Color color;

  TimerCirclePainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackgroundCircle(canvas, size);
    _drawProgressArc(canvas, size);
  }

  void _drawBackgroundCircle(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..strokeWidth = 8.0
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      size.center(Offset.zero),
      size.width / 2,
      paint,
    );
  }

  void _drawProgressArc(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final arcAngle = 2 * math.pi * (1 - progress);
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: size.width / 2,
    );

    canvas.drawArc(
      rect,
      -math.pi / 2,
      arcAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(TimerCirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
