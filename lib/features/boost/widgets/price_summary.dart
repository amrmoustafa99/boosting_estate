import 'package:flutter/material.dart';

import '../../../core/formatting/app_currency.dart';
import '../../../core/theme/app_theme.dart';
import '../models/boost_selection_state.dart';

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
        margin: const EdgeInsets.fromLTRB(
          AppTheme.spaceM,
          0,
          AppTheme.spaceM,
          AppTheme.spaceS,
        ),
        padding: const EdgeInsets.all(AppTheme.spaceM),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          border: Border.all(color: AppTheme.border),
          boxShadow: AppTheme.shadowMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'ملخص الطلب',
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
            ...state.selectedItems.map((item) => _buildLineItem(item)),
            const SizedBox(height: AppTheme.spaceS),
            const Divider(color: AppTheme.border, height: 1),
            const SizedBox(height: AppTheme.spaceS),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'الإجمالي',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  formatKwd(state.totalPrice),
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

  Widget _buildLineItem(SelectedBoostItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            size: 14,
            color: AppTheme.success,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    if (item.isRecurring)
                      _pill(
                        'متكرر',
                        AppTheme.primaryLight,
                        AppTheme.primary,
                      ),
                    if (!item.isProcessingAuto)
                      _pill('يدوي', AppTheme.warningLight, AppTheme.warning),
                    if (item.isProcessingAuto && !item.isRecurring)
                      _pill('تلقائي', AppTheme.successLight, AppTheme.success),
                  ],
                ),
              ],
            ),
          ),
          Text(
            formatKwd(item.price),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(String label, Color bg, Color fg) {
    return Container(
      margin: const EdgeInsets.only(right: 4, top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }
}
