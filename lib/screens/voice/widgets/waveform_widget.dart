import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class WaveformWidget extends StatefulWidget {
  final bool isActive;
  const WaveformWidget({super.key, required this.isActive});
  @override
  State<WaveformWidget> createState() => _WaveformWidgetState();
}

class _WaveformWidgetState extends State<WaveformWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _anims;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(20, (i) => AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 300 + (i * 50)),
        ));
    _anims = _controllers.map((c) =>
        Tween<double>(begin: 4, end: 40).animate(
          CurvedAnimation(parent: c, curve: Curves.easeInOut),
        )).toList();
  }

  @override
  void didUpdateWidget(WaveformWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive) {
      for (var i = 0; i < _controllers.length; i++) {
        Future.delayed(Duration(milliseconds: i * 30), () {
          if (mounted) _controllers[i].repeat(reverse: true);
        });
      }
    } else {
      for (final c in _controllers) {
        c.stop();
      }
      for (final c in _controllers) {
        c.reset();
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(_controllers.length, (i) {
        return AnimatedBuilder(
          animation: _anims[i],
          builder: (_, __) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 4,
            height: widget.isActive ? _anims[i].value : 4,
            decoration: BoxDecoration(
              color: widget.isActive
                  ? AppColors.primary
                  : AppColors.primary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
