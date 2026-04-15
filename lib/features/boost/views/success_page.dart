import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../models/boost_selection_state.dart';
import '../models/listing_model.dart';

/// Screen 3: Shown after user taps "Boost Now".
/// Displays confirmation, selected options with status badges,
/// and a "Back to Listing" button.
class SuccessPage extends StatelessWidget {
  final ListingModel listing;
  final BoostSelectionState state;
  final VoidCallback onBackToListing;

  const SuccessPage({
    super.key,
    required this.listing,
    required this.state,
    required this.onBackToListing,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spaceM),
          child: Column(
            children: [
              const SizedBox(height: AppTheme.spaceXL),
              _buildSuccessHeader(),
              const SizedBox(height: AppTheme.spaceXL),
              _buildOrderCard(),
              const SizedBox(height: AppTheme.spaceL),
              _buildBackButton(context),
              const SizedBox(height: AppTheme.spaceM),
            ],
          ),
        ),
      ),
    );
  }

  /// Animated success icon + title + subtitle
  Widget _buildSuccessHeader() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.successLight,
            border: Border.all(
              color: AppTheme.success.withOpacity(0.3),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.success.withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.check_rounded,
            color: AppTheme.success,
            size: 54,
          ),
        ),
        const SizedBox(height: AppTheme.spaceL),
        const Text(
          'Boost Activated!',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: AppTheme.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Your listing is now being promoted.\nSit back and watch the views roll in.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  /// Card showing the selected options with status chips
  Widget _buildOrderCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header
          Padding(
            padding: const EdgeInsets.all(AppTheme.spaceM),
            child: Row(
              children: [
                const Text(
                  'Boost Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${state.totalPrice.toStringAsFixed(2)} total',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.border),

          // Listing reference
          Padding(
            padding: const EdgeInsets.all(AppTheme.spaceM),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A56DB), Color(0xFF60A5FA)],
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image,
                          color: Colors.white70,
                          size: 22,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spaceM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listing.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        listing.location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppTheme.border),

          // Selected boost items with status badges
          Padding(
            padding: const EdgeInsets.all(AppTheme.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Active Boosts',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: AppTheme.spaceS),
                ...state.selectedLabels.map(
                  (label) => _buildBoostLineItem(label),
                ),
              ],
            ),
          ),

          // Info footer
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spaceM,
              vertical: AppTheme.spaceS,
            ),
            decoration: const BoxDecoration(
              color: AppTheme.primaryLight,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppTheme.radiusL),
                bottomRight: Radius.circular(AppTheme.radiusL),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 14,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'Boosts typically go live within 15 minutes',
                    style: TextStyle(fontSize: 12, color: AppTheme.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoostLineItem(String label) {
    final isActive = label.contains('In-App') || label.contains('WhatsApp');
    final statusLabel = isActive ? 'Active' : 'Pending';
    final statusColor = isActive ? AppTheme.success : AppTheme.warning;
    final statusBg = isActive ? AppTheme.successLight : AppTheme.warningLight;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onBackToListing,
        icon: const Icon(Icons.home_rounded, size: 18, color: AppTheme.accent),
        label: const Text('Back to Listing'),
      ),
    );
  }
}
