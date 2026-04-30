import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../models/boost_option.dart';
import '../models/boost_selection_state.dart';
import '../services/boost_queue_service.dart';

class WhatsAppBoostCard extends StatelessWidget {
  final BoostOption option;
  final BoostSelectionState state;
  final ValueChanged<BoostSelectionState> onStateChanged;

  final bool isEligible;
  final String? ineligibilityReason;

  const WhatsAppBoostCard({
    super.key,
    required this.option,
    required this.state,
    required this.onStateChanged,
    this.isEligible = true,
    this.ineligibilityReason,
  });

  bool get _isSelected => state.whatsappSelected;

  @override
  Widget build(BuildContext context) {
    final info = BoostQueueService.instance.getWhatsAppSlotInfo();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: !isEligible
            ? AppTheme.background
            : _isSelected
            ? AppTheme.whatsappGreenLight
            : AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(
          color: !isEligible
              ? AppTheme.border
              : _isSelected
              ? AppTheme.whatsappGreen
              : AppTheme.border,
          width: _isSelected && isEligible ? 2 : 1,
        ),
        boxShadow: _isSelected && isEligible
            ? [
                BoxShadow(
                  color: AppTheme.whatsappGreen.withOpacity(0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : AppTheme.shadowSm,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          onTap: isEligible
              ? () => onStateChanged(
                  state.copyWith(whatsappSelected: !_isSelected),
                )
              : null,
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spaceM),
            child: Column(
              children: [
                _buildHeader(),
                if (!isEligible && ineligibilityReason != null) ...[
                  const SizedBox(height: AppTheme.spaceS),
                  _buildIneligibilityBanner(),
                ],
                if (isEligible && _isSelected) ...[
                  const SizedBox(height: AppTheme.spaceM),
                  _buildSlotInfo(info),
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
                ? AppTheme.whatsappGreen
                : AppTheme.background,
            borderRadius: BorderRadius.circular(AppTheme.radiusS),
          ),
          child: Icon(
            Icons.chat_rounded,
            color: isDisabled
                ? AppTheme.textHint
                : _isSelected
                ? Colors.white
                : AppTheme.whatsappGreen,
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
                      ? const Color(0xFF1A7A47)
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
              '\$${option.fixedPrice!.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDisabled
                    ? AppTheme.textHint
                    : _isSelected
                    ? const Color(0xFF1A7A47)
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
                  ? Icon(
                      Icons.check_circle_rounded,
                      color: AppTheme.whatsappGreen,
                      size: 20,
                      key: const ValueKey('on'),
                    )
                  : Icon(
                      Icons.radio_button_unchecked_rounded,
                      color: AppTheme.border,
                      size: 20,
                      key: const ValueKey('off'),
                    ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSlotInfo(WhatsAppSlotInfo info) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceS + 4),
      decoration: BoxDecoration(
        color: AppTheme.whatsappGreen.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
        border: Border.all(color: AppTheme.whatsappGreen.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.event_available_rounded,
            size: 16,
            color: AppTheme.whatsappGreen,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Next Available Broadcast',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatSlot(info.nextSlot),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A7A47),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.whatsappGreen.withOpacity(0.15),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              '${info.slotsLeft} slots',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A7A47),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatSlot(DateTime dt) {
    return '${DateFormat('EEEE').format(dt)} - ${DateFormat('h:mm a').format(dt)}';
  }
}
