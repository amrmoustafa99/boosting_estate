import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../models/boost_option.dart';
import '../models/boost_selection_state.dart';
import 'days_selector.dart';

class InAppBoostCard extends StatelessWidget {
  final BoostOption option;
  final BoostSelectionState state;
  final ValueChanged<BoostSelectionState> onStateChanged;

  final bool isEligible;
  final String? ineligibilityReason;

  const InAppBoostCard({
    super.key,
    required this.option,
    required this.state,
    required this.onStateChanged,
    this.isEligible = true,
    this.ineligibilityReason,
  });

  bool get _isSelected => state.selectedDuration != null;

  void _handleTap() {
    if (!isEligible) return;
    if (_isSelected) {
      onStateChanged(state.copyWith(clearDuration: true));
    } else {
      onStateChanged(
        state.copyWith(selectedDuration: option.durationOptions.first),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: !isEligible
            ? AppTheme.background
            : _isSelected
            ? AppTheme.primaryLight
            : AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(
          color: !isEligible
              ? AppTheme.border
              : _isSelected
              ? AppTheme.primary
              : AppTheme.border,
          width: _isSelected && isEligible ? 2 : 1,
        ),
        boxShadow: _isSelected && isEligible
            ? AppTheme.shadowPrimary
            : AppTheme.shadowSm,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          onTap: isEligible ? _handleTap : null,
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                if (!isEligible && ineligibilityReason != null) ...[
                  const SizedBox(height: AppTheme.spaceS),
                  _buildIneligibilityBanner(),
                ],
                if (isEligible && _isSelected) ...[
                  const SizedBox(height: AppTheme.spaceM),
                  _buildPlacements(),
                  const SizedBox(height: AppTheme.spaceM),
                  _buildDurationSection(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIneligibilityBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.errorLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
        border: Border.all(color: AppTheme.error.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 14,
            color: AppTheme.error,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              ineligibilityReason!,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.error,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final isDisabled = !isEligible;
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: isDisabled
                ? AppTheme.border
                : _isSelected
                ? AppTheme.primary
                : AppTheme.background,
            borderRadius: BorderRadius.circular(AppTheme.radiusS),
          ),
          child: Icon(
            Icons.rocket_launch_rounded,
            color: isDisabled
                ? AppTheme.textHint
                : _isSelected
                ? Colors.white
                : AppTheme.primary,
            size: 22,
          ),
        ),
        const SizedBox(width: AppTheme.spaceM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                option.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDisabled
                      ? AppTheme.textHint
                      : _isSelected
                      ? AppTheme.primary
                      : AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                option.subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: isDisabled
                      ? AppTheme.textHint
                      : AppTheme.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppTheme.spaceS),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'from \$${option.durationOptions.first.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isDisabled
                    ? AppTheme.textHint
                    : _isSelected
                    ? AppTheme.primary
                    : AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isDisabled
                  ? const Icon(
                      Icons.block_rounded,
                      color: AppTheme.textHint,
                      size: 20,
                      key: ValueKey('disabled'),
                    )
                  : _isSelected
                  ? const Icon(
                      Icons.check_circle_rounded,
                      color: AppTheme.primary,
                      size: 20,
                      key: ValueKey('on'),
                    )
                  : const Icon(
                      Icons.radio_button_unchecked_rounded,
                      color: AppTheme.border,
                      size: 20,
                      key: ValueKey('off'),
                    ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlacements() {
    final placements = ['For Sale', 'For Rent', 'For Exchange'];
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: placements
          .map(
            (p) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(99),
                border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_rounded,
                    size: 12,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    p,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildDurationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Duration',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        DaysSelector(
          options: option.durationOptions,
          selected: state.selectedDuration,
          onSelect: (d) => onStateChanged(state.copyWith(selectedDuration: d)),
        ),
        if (state.selectedDuration != null) ...[
          const SizedBox(height: 8),
          _buildUnitPriceBreakdown(state.selectedDuration!),
        ],
      ],
    );
  }

  Widget _buildUnitPriceBreakdown(DurationOption selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
        border: Border.all(color: AppTheme.primary.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calculate_outlined,
            size: 14,
            color: AppTheme.primary,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              selected.unitBreakdown,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
          ),
          Text(
            'Total: \$${selected.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
