import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../models/boost_option.dart';
import '../models/boost_selection_state.dart';
import '../services/boost_queue_service.dart';

class PushNotificationCard extends StatelessWidget {
  final BoostOption option;
  final BoostSelectionState state;
  final ValueChanged<BoostSelectionState> onStateChanged;

  final bool isEligible;
  final String? ineligibilityReason;

  const PushNotificationCard({
    super.key,
    required this.option,
    required this.state,
    required this.onStateChanged,
    this.isEligible = true,
    this.ineligibilityReason,
  });

  bool get _isNormalSelected => state.pushSelected;
  bool get _isUrgentSelected => state.urgentPushSelected;
  bool get _isAnySelected => _isNormalSelected || _isUrgentSelected;

  @override
  Widget build(BuildContext context) {
    final info = BoostQueueService.instance.getPushSlotInfo();
    final slotLabel = _formatSlot(info.nextNormalSlot);

    return Column(
      children: [
        _buildNormalCard(slotLabel, info.normalSlotsLeft, info.normalPrice),
        const SizedBox(height: AppTheme.spaceS),
        if (info.urgentAvailable) _buildUrgentCard(info.urgentPrice),
      ],
    );
  }

  Widget _buildIneligibilityBanner() {
    return Container(
      margin: const EdgeInsets.only(top: AppTheme.spaceS),
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

  Widget _buildNormalCard(String slotLabel, int slotsLeft, double price) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: !isEligible
            ? AppTheme.background
            : _isNormalSelected
            ? AppTheme.primaryLight
            : AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(
          color: !isEligible
              ? AppTheme.border
              : _isNormalSelected
              ? AppTheme.primary
              : AppTheme.border,
          width: _isNormalSelected && isEligible ? 2 : 1,
        ),
        boxShadow: _isNormalSelected && isEligible
            ? AppTheme.shadowPrimary
            : AppTheme.shadowSm,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          onTap: isEligible
              ? () {
                  final newNormal = !_isNormalSelected;
                  onStateChanged(
                    state.copyWith(
                      pushSelected: newNormal,
                      urgentPushSelected: newNormal
                          ? false
                          : state.urgentPushSelected,
                    ),
                  );
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spaceM),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: !isEligible
                            ? AppTheme.border
                            : _isNormalSelected
                            ? AppTheme.primary
                            : AppTheme.background,
                        borderRadius: BorderRadius.circular(AppTheme.radiusS),
                      ),
                      child: Icon(
                        Icons.notifications_active_rounded,
                        color: !isEligible
                            ? AppTheme.textHint
                            : _isNormalSelected
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
                              color: !isEligible
                                  ? AppTheme.textHint
                                  : _isNormalSelected
                                  ? AppTheme.primary
                                  : AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            option.subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: !isEligible
                                  ? AppTheme.textHint
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: !isEligible
                                ? AppTheme.textHint
                                : _isNormalSelected
                                ? AppTheme.primary
                                : AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: !isEligible
                              ? const Icon(
                                  Icons.block_rounded,
                                  color: AppTheme.textHint,
                                  size: 20,
                                  key: ValueKey('disabled'),
                                )
                              : _isNormalSelected
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
                ),
                if (!isEligible && ineligibilityReason != null)
                  _buildIneligibilityBanner(),
                if (isEligible && _isNormalSelected) ...[
                  const SizedBox(height: AppTheme.spaceM),
                  _buildSlotInfo(slotLabel, slotsLeft),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUrgentCard(double price) {
    if (!isEligible) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        gradient: _isUrgentSelected
            ? const LinearGradient(
                colors: [Color(0xFFB8860B), Color(0xFFD4A017)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: _isUrgentSelected ? null : AppTheme.goldLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(
          color: _isUrgentSelected
              ? AppTheme.gold
              : AppTheme.gold.withOpacity(0.4),
          width: _isUrgentSelected ? 2 : 1,
        ),
        boxShadow: _isUrgentSelected ? AppTheme.shadowGold : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          onTap: () {
            final newUrgent = !_isUrgentSelected;
            onStateChanged(
              state.copyWith(
                urgentPushSelected: newUrgent,
                pushSelected: newUrgent ? false : state.pushSelected,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spaceM),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: _isUrgentSelected
                        ? Colors.white.withOpacity(0.2)
                        : AppTheme.gold.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppTheme.radiusS),
                  ),
                  child: Icon(
                    Icons.bolt_rounded,
                    color: _isUrgentSelected ? Colors.white : AppTheme.gold,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppTheme.spaceM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Urgent Push',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: _isUrgentSelected
                                  ? Colors.white
                                  : const Color(0xFFB8860B),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _isUrgentSelected
                                  ? Colors.white.withOpacity(0.2)
                                  : AppTheme.gold.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              'PREMIUM',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: _isUrgentSelected
                                    ? Colors.white
                                    : const Color(0xFFB8860B),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Sent within 2 hours · Today',
                        style: TextStyle(
                          fontSize: 12,
                          color: _isUrgentSelected
                              ? Colors.white.withOpacity(0.85)
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _isUrgentSelected
                            ? Colors.white
                            : const Color(0xFFB8860B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _isUrgentSelected
                          ? const Icon(
                              Icons.check_circle_rounded,
                              color: Colors.white,
                              size: 20,
                              key: ValueKey('on'),
                            )
                          : Icon(
                              Icons.radio_button_unchecked_rounded,
                              color: AppTheme.gold.withOpacity(0.5),
                              size: 20,
                              key: const ValueKey('off'),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSlotInfo(String slotLabel, int slotsLeft) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceS + 4),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
        border: Border.all(color: AppTheme.primary.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          const Icon(Icons.schedule_rounded, size: 16, color: AppTheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Next Available Slot',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  slotLabel,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              '$slotsLeft slots left',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatSlot(DateTime dt) {
    final now = DateTime.now();
    final diff = dt.difference(now);
    if (diff.inDays == 0) return 'Today - ${DateFormat('h:mm a').format(dt)}';
    if (diff.inDays == 1)
      return 'Tomorrow - ${DateFormat('h:mm a').format(dt)}';
    return '${DateFormat('EEEE').format(dt)} - ${DateFormat('h:mm a').format(dt)}';
  }
}
