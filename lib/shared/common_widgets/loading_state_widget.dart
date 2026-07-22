import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';

// full-screen loading state with a pulsing spinner and descriptive message
class LoadingStateWidget extends StatelessWidget {
  final String loadingMessage;

  const LoadingStateWidget({
    super.key,
    required this.loadingMessage,
  });

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // accent-colored spinner
          const CircularProgressIndicator(
            color: AppColors.accent,
            strokeWidth: 2.5,
          ),
          const SizedBox(height: AppSizes.md),
          // descriptive loading message
          Text(
            loadingMessage,
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
