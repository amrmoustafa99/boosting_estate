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
import 'success_page.dart';

class BoostPage extends StatefulWidget {
  final ListingModel listing;
  final VoidCallback onBoostSuccess;

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
      return 'This boost is not available for expiring listings. Please renew your ad first.';
    }
    if (status == ListingStatus.expired) {
      return 'Your listing has expired. Please renew it before boosting.';
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
            widget.onBoostSuccess();
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
        title: const Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppTheme.warning,
              size: 22,
            ),
            SizedBox(width: 8),
            Text(
              'Cannot Continue',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        content: const Text(
          'Your ad has less time remaining than the selected sponsor duration. Renew your ad so you can proceed.',
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
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warning,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusS),
              ),
            ),
            child: const Text('Renew Ad'),
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
        title: const Text('Boost Listing'),
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
                      '\$${widget.listing.price.toStringAsFixed(0)}',
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
            ? 'New'
            : status == ListingStatus.active
            ? 'Active'
            : status == ListingStatus.expiringSoon
            ? 'Expiring'
            : 'Expired',
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
          'Choose Boost Options',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Select one or more options to increase your listing visibility.',
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
