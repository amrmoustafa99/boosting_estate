import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../models/boost_selection_state.dart';

/// Displays a breakdown of selected boosts and the running total.
/// Sticks to the bottom of the boost page.
class PriceSummary extends StatelessWidget {
  final BoostSelectionState state;

  const PriceSummary({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (!state.hasSelection) return const SizedBox.shrink();

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: Container(
        margin: const EdgeInsets.only(
          left: AppTheme.spaceM,
          right: AppTheme.spaceM,
          bottom: AppTheme.spaceS,
        ),
        padding: const EdgeInsets.all(AppTheme.spaceM),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          border: Border.all(color: AppTheme.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Section label
            const Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: AppTheme.spaceS),
            const Divider(color: AppTheme.border, height: 1),
            const SizedBox(height: AppTheme.spaceS),

            // Line items
            ...state.selectedLabels.map(
              (label) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 14,
                          color: AppTheme.success,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '\$${_priceForLabel(label).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppTheme.spaceS),
            const Divider(color: AppTheme.border, height: 1),
            const SizedBox(height: AppTheme.spaceS),

            // Total row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  '\$${state.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Gets the price for a label line item — used for the breakdown display
  double _priceForLabel(String label) {
    if (label.contains('In-App')) {
      return state.selectedDuration?.price ?? 0;
    }
    if (label.contains('Push')) return 4.99;
    if (label.contains('Instagram')) {
      return state.selectedInstagram?.price ?? 0;
    }
    if (label.contains('WhatsApp')) return 6.99;
    return 0;
  }
}
