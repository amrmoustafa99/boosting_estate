import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../core/formatting/app_currency.dart';
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

  bool _urgentVisuallySelected(PushSlotInfo info) =>
      state.urgentPushSelected && !info.urgentSoldOut;

  @override
  Widget build(BuildContext context) {
    final info = BoostQueueService.instance.getPushSlotInfo();
    final slotLabel = _formatSlot(info.nextNormalSlot);

    return Column(
      children: [
        _buildNormalCard(slotLabel, info.normalSlotsLeft, info.normalPrice),
        const SizedBox(height: AppTheme.spaceS),
        _buildUrgentCard(info),
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
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.bell,
                          color: !isEligible
                              ? AppTheme.textHint
                              : _isNormalSelected
                              ? Colors.white
                              : AppTheme.primary,
                          size: 20,
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
                          formatKwd(price),
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

  Widget _buildUrgentCard(PushSlotInfo info) {
    if (!isEligible) return const SizedBox.shrink();

    final soldOut = info.urgentSoldOut;
    final urgentOn = _urgentVisuallySelected(info);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: soldOut ? AppTheme.background : AppTheme.goldLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(
          color: soldOut
              ? AppTheme.border
              : urgentOn
              ? AppTheme.gold
              : AppTheme.gold.withOpacity(0.4),
          width: urgentOn && !soldOut ? 2 : 1,
        ),
        boxShadow: urgentOn && !soldOut ? AppTheme.shadowGold : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          onTap: soldOut
              ? null
              : () {
                  final newUrgent = !state.urgentPushSelected;
                  onStateChanged(
                    state.copyWith(
                      urgentPushSelected: newUrgent,
                      pushSelected: newUrgent ? false : state.pushSelected,
                    ),
                  );
                },
          child: Opacity(
            opacity: soldOut ? 0.55 : 1.0,
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spaceM),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: soldOut
                          ? AppTheme.border
                          : AppTheme.gold.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    ),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.bolt,
                        color: soldOut ? AppTheme.textHint : AppTheme.gold,
                        size: 22,
                      ),
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
                              'إشعار عاجل',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: soldOut
                                    ? AppTheme.textHint
                                    : const Color(0xFFB8860B),
                              ),
                            ),
                            const SizedBox(width: 6),
                            if (soldOut)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.errorLight,
                                  borderRadius: BorderRadius.circular(99),
                                ),
                                child: const Text(
                                  'نفد اليوم',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.error,
                                  ),
                                ),
                              )
                            else
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.gold.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(99),
                                ),
                                child: Text(
                                  'مميز',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: urgentOn
                                        ? AppTheme.gold
                                        : const Color(0xFFB8860B),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          soldOut
                              ? 'استُنفدت الحصة اليومية — يُفتح غداً'
                              : 'يُرسل خلال ساعتين — اليوم',
                          style: TextStyle(
                            fontSize: 12,
                            color: soldOut
                                ? AppTheme.textHint
                                : AppTheme.textSecondary,
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
                        formatKwd(info.urgentPrice),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: soldOut
                              ? AppTheme.textHint
                              : const Color(0xFFB8860B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      soldOut
                          ? const Icon(
                              Icons.lock_outline_rounded,
                              color: AppTheme.textHint,
                              size: 20,
                            )
                          : AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: urgentOn
                                  ? const Icon(
                                      Icons.check_circle_rounded,
                                      color: AppTheme.gold,
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
                  'أقرب موعد متاح',
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
              slotsLeft == 1 ? 'طلب واحد متبقي' : '$slotsLeft طلبات متبقية',
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
    final time = DateFormat('jm', 'ar').format(dt);
    final dayName = DateFormat('EEEE', 'ar').format(dt);
    if (diff.inDays == 0) return 'اليوم — $time';
    if (diff.inDays == 1) return 'غداً — $time';
    return '$dayName — $time';
  }
}
