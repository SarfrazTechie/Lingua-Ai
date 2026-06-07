import 'dart:math';
import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class WaveformWidget extends StatefulWidget {
  final bool isActive;
  const WaveformWidget({super.key, required this.isActive});
  @override
  State<WaveformWidget> createState() => _WaveformWidgetState();
}

class _WaveformWidgetState extends State<WaveformWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  late List<double> _heights;

  @override
  void initState() {
    super.initState();
    _heights = List.generate(20, (_) => 4.0);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _controller.addListener(_updateHeights);
  }

  void _updateHeights() {
    if (!mounted || !widget.isActive) return;
    setState(() {
      _heights = List.generate(20, (_) =>
          4.0 + _random.nextDouble() * 36.0);
    });
  }

  @override
  void didUpdateWidget(WaveformWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.repeat();
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.stop();
      setState(() {
        _heights = List.generate(20, (_) => 4.0);
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateHeights);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(20, (i) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 4,
          height: _heights[i],
          decoration: BoxDecoration(
            color: widget.isActive
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
