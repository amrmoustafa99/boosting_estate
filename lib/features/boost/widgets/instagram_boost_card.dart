import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/formatting/app_currency.dart';
import '../../../core/theme/app_theme.dart';
import '../models/boost_option.dart';
import '../models/boost_selection_state.dart';

class InstagramBoostCard extends StatelessWidget {
  final BoostOption option;
  final BoostSelectionState state;
  final ValueChanged<BoostSelectionState> onStateChanged;

  final bool isEligible;
  final String? ineligibilityReason;

  const InstagramBoostCard({
    super.key,
    required this.option,
    required this.state,
    required this.onStateChanged,
    this.isEligible = true,
    this.ineligibilityReason,
  });

  bool get _isAnySelected => state.selectedInstagramFormats.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: !isEligible
            ? AppTheme.background
            : _isAnySelected
            ? const Color(0xFFFDF0F7)
            : AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(
          color: !isEligible
              ? AppTheme.border
              : _isAnySelected
              ? AppTheme.instagramPink
              : AppTheme.border,
          width: _isAnySelected && isEligible ? 2 : 1,
        ),
        boxShadow: _isAnySelected && isEligible
            ? [
                BoxShadow(
                  color: AppTheme.instagramPink.withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : AppTheme.shadowSm,
      ),
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
            if (isEligible) ...[
              const SizedBox(height: AppTheme.spaceM),
              _buildFormatChips(),
            ],
          ],
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
            gradient: !isDisabled && _isAnySelected
                ? const LinearGradient(
                    colors: [
                      AppTheme.instagramPurple,
                      AppTheme.instagramPink,
                      Color(0xFFF77737),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isDisabled
                ? AppTheme.border
                : _isAnySelected
                ? null
                : AppTheme.background,
            borderRadius: BorderRadius.circular(AppTheme.radiusS),
          ),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.instagram,
              color: isDisabled
                  ? AppTheme.textHint
                  : _isAnySelected
                  ? Colors.white
                  : AppTheme.instagramPink,
              size: 22,
            ),
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
                      : _isAnySelected
                      ? AppTheme.instagramPink
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'من ${formatKwd(option.instagramOptions.first.price)}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isDisabled
                    ? AppTheme.textHint
                    : _isAnySelected
                    ? AppTheme.instagramPink
                    : AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'اختيار متعدد',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isDisabled
                    ? AppTheme.textHint
                    : _isAnySelected
                    ? AppTheme.instagramPink
                    : AppTheme.textHint,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormatChips() {
    return Row(
      children: option.instagramOptions.map((opt) {
        final isSelected = state.selectedInstagramFormats.contains(opt.format);
        return Expanded(
          child: GestureDetector(
            onTap: () {
              final current = Set<InstagramFormat>.from(
                state.selectedInstagramFormats,
              );
              if (isSelected) {
                current.remove(opt.format);
              } else {
                current.add(opt.format);
              }
              onStateChanged(state.copyWith(selectedInstagramFormats: current));
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: EdgeInsets.only(
                right: opt == option.instagramOptions.last ? 0 : 8,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [
                          AppTheme.instagramPurple,
                          AppTheme.instagramPink,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected ? null : AppTheme.background,
                borderRadius: BorderRadius.circular(AppTheme.radiusS),
                border: Border.all(
                  color: isSelected ? AppTheme.instagramPink : AppTheme.border,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _formatIcon(opt.format),
                    size: 18,
                    color: isSelected ? Colors.white : AppTheme.instagramPink,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    opt.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formatKwd(opt.price),
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected
                          ? Colors.white.withOpacity(0.85)
                          : AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    opt.description,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white.withOpacity(0.7)
                          : AppTheme.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _formatIcon(InstagramFormat fmt) {
    switch (fmt) {
      case InstagramFormat.story:
        return Icons.crop_portrait_rounded;
      case InstagramFormat.post:
        return Icons.grid_on_rounded;
      case InstagramFormat.reel:
        return Icons.play_circle_outline_rounded;
    }
  }
}
