import 'package:flutter/material.dart';

import '../../../core/formatting/app_currency.dart';
import '../../../core/theme/app_theme.dart';
import '../models/boost_option.dart';
import '../models/boost_selection_state.dart';

class InAppBoostCard extends StatelessWidget {
  final BoostOption option;
  final BoostSelectionState state;
  final ValueChanged<BoostSelectionState> onStateChanged;
  final bool isEligible;
  final String? ineligibilityReason;

  /// The number of days remaining on the listing (null = no expiry limit).
  final int? listingRemainingDays;

  /// Opens تجديد الإعلان (مثلاً [RenewPage]) عند الحاجة.
  final VoidCallback? onRenewListing;

  const InAppBoostCard({
    super.key,
    required this.option,
    required this.state,
    required this.onStateChanged,
    this.isEligible = true,
    this.ineligibilityReason,
    this.listingRemainingDays,
    this.onRenewListing,
  });

  static const int _step = 3;
  static const int _minDays = 3;

  bool get _isSelected => state.selectedDuration != null;
  int get _currentDays => state.selectedDuration?.days ?? _minDays;

  /// 5 د.ك لكل 3 أيام
  double _priceForDays(int days) {
    const double kwdPerThreeDays = 5;
    return (days / _step) * kwdPerThreeDays;
  }

  bool _exceedsListingLife(int days) {
    if (listingRemainingDays == null) return false;
    return days > listingRemainingDays!;
  }

  void _handleTap() {
    if (!isEligible) return;
    if (_isSelected) {
      onStateChanged(state.copyWith(clearDuration: true));
    } else {
      const days = _minDays;
      onStateChanged(
        state.copyWith(
          selectedDuration: DurationOption(
            days: days,
            price: _priceForDays(days),
          ),
        ),
      );
    }
  }

  void _increment() {
    final newDays = _currentDays + _step;
    onStateChanged(
      state.copyWith(
        selectedDuration: DurationOption(
          days: newDays,
          price: _priceForDays(newDays),
        ),
      ),
    );
  }

  void _decrement() {
    final newDays = _currentDays - _step;
    if (newDays < _minDays) {
      onStateChanged(state.copyWith(clearDuration: true));
      return;
    }
    onStateChanged(
      state.copyWith(
        selectedDuration: DurationOption(
          days: newDays,
          price: _priceForDays(newDays),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final exceeds = _isSelected && _exceedsListingLife(_currentDays);

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
              : exceeds
              ? AppTheme.warning
              : _isSelected
              ? AppTheme.primary
              : AppTheme.border,
          width: _isSelected && isEligible ? 2 : 1,
        ),
        boxShadow: _isSelected && isEligible
            ? (exceeds ? AppTheme.shadowMd : AppTheme.shadowPrimary)
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
                  _buildBanner(
                    ineligibilityReason!,
                    AppTheme.errorLight,
                    AppTheme.error,
                  ),
                ],
                if (isEligible && _isSelected) ...[
                  const SizedBox(height: AppTheme.spaceM),
                  _buildPlacements(),
                  const SizedBox(height: AppTheme.spaceM),
                  _buildDurationStepper(),
                  if (exceeds) ...[
                    const SizedBox(height: AppTheme.spaceS),
                    _buildRenewalWarning(),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(String message, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
        border: Border.all(color: fg.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, size: 14, color: fg),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 12, color: fg, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRenewalWarning() {
    final remaining = listingRemainingDays;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.errorLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
        border: Border.all(color: AppTheme.error.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 16,
                color: AppTheme.error,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  remaining == null
                      ? 'مدة التعزيز تتجاوز تاريخ انتهاء إعلانك. قلّل المدة أو جدّد الإعلان أولاً.'
                      : 'مدة التعزيز تتجاوز تاريخ انتهاء إعلانك (متبقي $remaining ${remaining == 1 ? 'يوم' : 'أيام'}). قلّل المدة أو جدّد الإعلان.',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.error,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (onRenewListing != null) ...[
            const SizedBox(height: 10),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton.icon(
                onPressed: onRenewListing,
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 18,
                  color: AppTheme.error,
                ),
                label: const Text(
                  'تجديد الإعلان',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.error,
                  ),
                ),
              ),
            ),
          ],
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
              '${formatKwd(_priceForDays(_minDays))} / 3 أيام',
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
    final placements = ['للبيع', 'للإيجار', 'للتبادل'];
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

  Widget _buildDurationStepper() {
    final days = _currentDays;
    final price = _priceForDays(days);
    final canDecrement = days > _minDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'مدة التمييز',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _stepButton(
              icon: Icons.remove_rounded,
              enabled: canDecrement,
              onTap: _decrement,
              isDestructive: !canDecrement,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(AppTheme.radiusS),
                  border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    Text(
                      '$days يوم',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatKwd(price),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            _stepButton(
              icon: Icons.add_rounded,
              enabled: true,
              onTap: _increment,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(AppTheme.radiusS),
            border: Border.all(color: AppTheme.primary.withOpacity(0.12)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 14,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'السعر: ${formatKwd(5)} / 3 أيام',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              Text(
                'الإجمالي: ${formatKwd(price)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stepButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = enabled
        ? (isDestructive ? AppTheme.error : AppTheme.primary)
        : AppTheme.textHint;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: enabled
              ? (isDestructive
                    ? AppTheme.errorLight
                    : AppTheme.primary.withOpacity(0.1))
              : AppTheme.background,
          borderRadius: BorderRadius.circular(AppTheme.radiusS),
          border: Border.all(
            color: enabled ? color.withOpacity(0.4) : AppTheme.border,
          ),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}
