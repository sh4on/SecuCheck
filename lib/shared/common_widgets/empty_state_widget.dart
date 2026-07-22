import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';

// empty state widget shown when there is no data to display
class EmptyStateWidget extends StatelessWidget {
  // descriptive message shown below the icon
  final String message;

  const EmptyStateWidget({super.key, required this.message});

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // muted inbox icon representing no content
            const Icon(
              Icons.inbox_outlined,
              color: AppColors.textMuted,
              size: 56,
            ),
            const SizedBox(height: AppSizes.md),
            // descriptive message
            Text(
              message,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
