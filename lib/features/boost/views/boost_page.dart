import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../models/boost_option.dart';
import '../models/boost_selection_state.dart';
import '../models/listing_model.dart';
import '../widgets/boost_button.dart';
import '../widgets/boost_option_card.dart';
import '../widgets/price_summary.dart';
import 'success_page.dart';

/// Screen 2: The main Boost Page.
/// Displays all boost options as selectable cards.
/// Tracks selection state and shows a live price summary.
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

  void _handleBoostTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SuccessPage(
          listing: widget.listing,
          state: _selectionState,
          onBackToListing: () {
            widget.onBoostSuccess();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
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
          // Scrollable content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppTheme.spaceM),
              children: [
                _buildListingPreview(),
                const SizedBox(height: AppTheme.spaceL),
                _buildSectionHeader(),
                const SizedBox(height: AppTheme.spaceM),

                // Render each boost option as a card
                ..._options.map(
                  (option) => Padding(
                    padding: const EdgeInsets.only(bottom: AppTheme.spaceM),
                    child: BoostOptionCard(
                      option: option,
                      state: _selectionState,
                      onStateChanged: _updateState,
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spaceS),
              ],
            ),
          ),

          // Sticky bottom section: price summary + CTA button
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PriceSummary(state: _selectionState),
              const SizedBox(height: AppTheme.spaceS),
              BoostButton(state: _selectionState, onBoost: _handleBoostTap),
              const SizedBox(height: AppTheme.spaceM),
            ],
          ),
        ],
      ),
    );
  }

  /// Compact listing card at top of boost page for context
  Widget _buildListingPreview() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceM),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          // Mini image placeholder
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusS),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, color: Colors.grey);
              },
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
                Text(
                  '\$${widget.listing.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
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
