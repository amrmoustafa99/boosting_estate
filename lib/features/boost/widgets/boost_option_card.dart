import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../models/boost_option.dart';
import '../models/boost_selection_state.dart';
import 'days_selector.dart';

/// Reusable card widget for each boost option.
/// Handles its own rendering based on [BoostType]:
///  - In-App Boost: shows DaysSelector when selected
///  - Instagram: shows sub-option chips when selected
///  - Push / WhatsApp: simple toggle card
class BoostOptionCard extends StatelessWidget {
  final BoostOption option;
  final BoostSelectionState state;
  final ValueChanged<BoostSelectionState> onStateChanged;

  const BoostOptionCard({
    super.key,
    required this.option,
    required this.state,
    required this.onStateChanged,
  });

  /// Returns true if this card is in a "selected" state
  bool get _isSelected {
    switch (option.type) {
      case BoostType.inApp:
        return state.selectedDuration != null;
      case BoostType.pushNotification:
        return state.pushSelected;
      case BoostType.instagram:
        return state.selectedInstagram != null;
      case BoostType.whatsapp:
        return state.whatsappSelected;
    }
  }

  /// Toggle the primary selection for this card
  void _handleTap() {
    switch (option.type) {
      case BoostType.inApp:
        if (state.selectedDuration != null) {
          // Deselect
          onStateChanged(state.copyWith(clearDuration: true));
        } else {
          // Select first duration by default
          onStateChanged(
            state.copyWith(selectedDuration: option.durationOptions.first),
          );
        }
        break;
      case BoostType.pushNotification:
        onStateChanged(state.copyWith(pushSelected: !state.pushSelected));
        break;
      case BoostType.instagram:
        if (state.selectedInstagram != null) {
          onStateChanged(state.copyWith(clearInstagram: true));
        } else {
          onStateChanged(
            state.copyWith(selectedInstagram: option.subOptions.first),
          );
        }
        break;
      case BoostType.whatsapp:
        onStateChanged(
          state.copyWith(whatsappSelected: !state.whatsappSelected),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: _isSelected ? AppTheme.primaryLight : AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(
          color: _isSelected ? AppTheme.accent : AppTheme.border,
          width: _isSelected ? 2 : 1,
        ),
        boxShadow: _isSelected
            ? [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          onTap: _handleTap,
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                // Show sub-options only when selected
                if (_isSelected && option.type == BoostType.inApp) ...[
                  const SizedBox(height: AppTheme.spaceM),
                  _buildDurationSelector(),
                ],
                if (_isSelected && option.type == BoostType.instagram) ...[
                  const SizedBox(height: AppTheme.spaceM),
                  _buildInstagramSubOptions(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Header row: icon, title/subtitle, price, checkmark
  Widget _buildHeader() {
    return Row(
      children: [
        // Icon container
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _isSelected ? AppTheme.primary : AppTheme.background,
            borderRadius: BorderRadius.circular(AppTheme.radiusS),
          ),
          child: Icon(
            _iconData(option.iconAsset),
            color: _isSelected ? Colors.white : AppTheme.primary,
            size: 22,
          ),
        ),
        const SizedBox(width: AppTheme.spaceM),

        // Title & subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                option.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _isSelected ? AppTheme.primary : AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                option.subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppTheme.spaceS),

        // Price + check
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildPriceChip(),
            const SizedBox(height: 4),
            _buildCheckIcon(),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceChip() {
    String priceText;
    if (option.fixedPrice != null) {
      priceText = '\$${option.fixedPrice!.toStringAsFixed(2)}';
    } else if (option.type == BoostType.inApp) {
      priceText =
          'from \$${option.durationOptions.first.price.toStringAsFixed(2)}';
    } else {
      priceText = 'from \$${option.subOptions.first.price.toStringAsFixed(2)}';
    }

    return Text(
      priceText,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: _isSelected ? AppTheme.primary : AppTheme.textSecondary,
      ),
    );
  }

  Widget _buildCheckIcon() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: _isSelected
          ? const Icon(
              Icons.check_circle_rounded,
              color: AppTheme.primary,
              size: 20,
              key: ValueKey('checked'),
            )
          : const Icon(
              Icons.radio_button_unchecked_rounded,
              color: AppTheme.border,
              size: 20,
              key: ValueKey('unchecked'),
            ),
    );
  }

  /// Duration day chips for In-App Boost
  Widget _buildDurationSelector() {
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
          onSelect: (duration) =>
              onStateChanged(state.copyWith(selectedDuration: duration)),
        ),
      ],
    );
  }

  /// Sub-option chips for Instagram
  Widget _buildInstagramSubOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Format',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: option.subOptions.map((sub) {
            final isSelected = state.selectedInstagram?.id == sub.id;
            return Expanded(
              child: GestureDetector(
                onTap: () =>
                    onStateChanged(state.copyWith(selectedInstagram: sub)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primary : AppTheme.background,
                    borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    border: Border.all(
                      color: isSelected ? AppTheme.primary : AppTheme.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        sub.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '\$${sub.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected
                              ? Colors.white.withOpacity(0.85)
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Maps string names to Material icons
  IconData _iconData(String name) {
    switch (name) {
      case 'rocket_launch':
        return Icons.rocket_launch_rounded;
      case 'notifications_active':
        return Icons.notifications_active_rounded;
      case 'photo_camera':
        return Icons.photo_camera_rounded;
      case 'chat_bubble':
        return Icons.chat_bubble_rounded;
      default:
        return Icons.star_rounded;
    }
  }
}
