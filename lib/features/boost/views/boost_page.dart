import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../models/boost_option.dart';
import '../models/boost_selection_state.dart';
import '../models/listing_model.dart';
import '../widgets/boost_button.dart';
import '../widgets/in_app_boost_card.dart';
import '../widgets/instagram_boost_card.dart';
import '../widgets/price_summary.dart';
import '../widgets/push_notification_card.dart';
import '../widgets/whatsapp_boost_card.dart';
import 'renew_page.dart';
import 'success_page.dart';

class BoostPage extends StatefulWidget {
  final ListingModel listing;
  final void Function(BoostSelectionState state) onBoostSuccess;

  const BoostPage({
    super.key,
    required this.listing,
    required this.onBoostSuccess,
  });

  @override
  State<BoostPage> createState() => _BoostPageState();
}

class _BoostPageState extends State<BoostPage> {
  BoostSelectionState _selectionState = const BoostSelectionState();
  final List<BoostOption> _options = BoostOptionsMockData.all;

  void _updateState(BoostSelectionState newState) {
    setState(() => _selectionState = newState);
  }

  String? _ineligibilityReason(BoostType type) {
    final status = widget.listing.status;

    if (status == ListingStatus.expiringSoon) {
      return 'هذا التعزيز غير متاح لإعلان على وشك الانتهاء. يرجى تجديد الإعلان أولاً.';
    }
    if (status == ListingStatus.expired) {
      return 'انتهى هذا الإعلان. يرجى تجديده قبل التعزيز.';
    }
    return null;
  }

  bool _isEligible(BoostType type) => _ineligibilityReason(type) == null;

  void _handleBoostTap() {
    if (_selectionState.selectedDuration != null &&
        widget.listing.remainingDays != null &&
        widget.listing.remainingDays! <
            _selectionState.selectedDuration!.days) {
      _showRenewalDialog();
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SuccessPage(
          listing: widget.listing,
          state: _selectionState,
          onBackToListing: () {
            widget.onBoostSuccess(_selectionState);
            Navigator.of(context)
              ..pop()
              ..pop();
          },
        ),
      ),
    );
  }

  void _showRenewalDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
        ),
        backgroundColor: AppTheme.errorLight,
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppTheme.error, size: 22),
            SizedBox(width: 8),
            Text(
              'لا يمكن المتابعة',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.error,
              ),
            ),
          ],
        ),
        content: const Text(
          'الوقت المتبقي لإعلانك أقل من مدة التعزيز التي اخترتها. جدّد الإعلان للمتابعة.',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'إلغاء',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      RenewPage(listing: widget.listing, onRenewSuccess: () {}),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusS),
              ),
            ),
            child: const Text('تجديد الإعلان'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('تمييز الإعلان'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppTheme.spaceM),
              children: [
                _buildListingPreview(),
                const SizedBox(height: AppTheme.spaceL),
                _buildSectionHeader(),
                const SizedBox(height: AppTheme.spaceM),
                ..._options.map(
                  (option) => Padding(
                    padding: const EdgeInsets.only(bottom: AppTheme.spaceM),
                    child: _buildCard(option),
                  ),
                ),
                const SizedBox(height: AppTheme.spaceS),
              ],
            ),
          ),
          PriceSummary(state: _selectionState),
          BoostButton(state: _selectionState, onBoost: _handleBoostTap),
          const SizedBox(height: AppTheme.spaceM),
        ],
      ),
    );
  }

  Widget _buildCard(BoostOption option) {
    switch (option.type) {
      case BoostType.inApp:
        return InAppBoostCard(
          option: option,
          state: _selectionState,
          onStateChanged: _updateState,
          isEligible: _isEligible(option.type),
          ineligibilityReason: _ineligibilityReason(option.type),
          listingRemainingDays: widget.listing.remainingDays,
          onRenewListing: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    RenewPage(listing: widget.listing, onRenewSuccess: () {}),
              ),
            );
          },
        );
      case BoostType.pushNotification:
        return PushNotificationCard(
          option: option,
          state: _selectionState,
          onStateChanged: _updateState,
          isEligible: _isEligible(option.type),
          ineligibilityReason: _ineligibilityReason(option.type),
        );
      case BoostType.instagram:
        return InstagramBoostCard(
          option: option,
          state: _selectionState,
          onStateChanged: _updateState,
          isEligible: _isEligible(option.type),
          ineligibilityReason: _ineligibilityReason(option.type),
        );
      case BoostType.whatsapp:
        return WhatsAppBoostCard(
          option: option,
          state: _selectionState,
          onStateChanged: _updateState,
          isEligible: _isEligible(option.type),
          ineligibilityReason: _ineligibilityReason(option.type),
        );
    }
  }

  Widget _buildListingPreview() {
    final firstImage = widget.listing.images.isNotEmpty
        ? widget.listing.images.first
        : null;
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceM),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusS),
            child: firstImage != null
                ? Image.asset(
                    firstImage,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1A56DB), Color(0xFF60A5FA)],
                      ),
                    ),
                    child: const Icon(
                      Icons.home_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
          ),
          const SizedBox(width: AppTheme.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.listing.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 12,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        widget.listing.location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${widget.listing.price.toStringAsFixed(0)} د.ك',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primary,
                      ),
                    ),
                    const Spacer(),
                    _buildStatusBadge(widget.listing.status),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ListingStatus status) {
    Color color;
    Color bg;
    switch (status) {
      case ListingStatus.newListing:
        color = AppTheme.primary;
        bg = AppTheme.primaryLight;
        break;
      case ListingStatus.active:
        color = AppTheme.success;
        bg = AppTheme.successLight;
        break;
      case ListingStatus.expiringSoon:
        color = AppTheme.warning;
        bg = AppTheme.warningLight;
        break;
      case ListingStatus.expired:
        color = AppTheme.error;
        bg = AppTheme.errorLight;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        status == ListingStatus.newListing
            ? 'جديد'
            : status == ListingStatus.active
            ? 'نشط'
            : status == ListingStatus.expiringSoon
            ? 'ينتهي قريباً'
            : 'منتهي',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'خدمات الترويج الاحترافية',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'اجذب المزيد من المشترين — اختر الأدوات المناسبة لزيادة مشاهدات إعلانك.',
          style: TextStyle(
            fontSize: 13,
            color: AppTheme.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
