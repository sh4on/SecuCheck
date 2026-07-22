import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';

// animated circular score ring with a custom arc painter and score counter
class ScoreRingWidget extends StatelessWidget {
  // final computed score (used for arc and color)
  final int score;

  // animated counter value that ticks up to score (drives the number text)
  final int animatedScore;

  const ScoreRingWidget({
    super.key,
    required this.score,
    required this.animatedScore,
  });

  // pick color based on score threshold
  Color get _scoreColor {
    if (score >= 80) return AppColors.safe;
    if (score >= 50) return AppColors.warning;
    return AppColors.critical;
  }

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: AppSizes.scoreRingSize,
      height: AppSizes.scoreRingSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // animated arc drawn via custom painter
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: score / 100.0),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOut,
            builder: (final context, final progress, final _) {
              return CustomPaint(
                size: const Size(AppSizes.scoreRingSize, AppSizes.scoreRingSize),
                painter: _ScoreArcPainter(
                  progress: progress,
                  color: _scoreColor,
                ),
              );
            },
          ),
          // score number and label centered inside the ring
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$animatedScore',
                style: AppTextStyles.scoreNumber.copyWith(color: _scoreColor),
              ),
              Text(
                AppStrings.securityScoreLabel,
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// custom painter that draws the track ring and the filled arc
class _ScoreArcPainter extends CustomPainter {
  final double progress;
  final Color color;

  const _ScoreArcPainter({required this.progress, required this.color});

  @override
  void paint(final Canvas canvas, final Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - AppSizes.scoreRingStrokeWidth) / 2;

    // background track paint — muted surface color
    final trackPaint = Paint()
      ..color = AppColors.surfaceVariant
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppSizes.scoreRingStrokeWidth
      ..strokeCap = StrokeCap.round;

    // full circle as the background track
    canvas.drawCircle(center, radius, trackPaint);

    // foreground arc paint — colored by score threshold
    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppSizes.scoreRingStrokeWidth
      ..strokeCap = StrokeCap.round;

    // draw arc starting from the top (-pi/2) sweeping clockwise by progress fraction
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,                // start angle: top of circle
      2 * pi * progress,      // sweep angle: proportional to score
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(final _ScoreArcPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
