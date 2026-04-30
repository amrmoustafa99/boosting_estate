import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../generated/assets.dart';
import '../models/listing_model.dart';
import 'boost_page.dart';
import 'renew_page.dart';

class ListingPage extends StatefulWidget {
  const ListingPage({super.key});

  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  ListingModel _listing = ListingModel.newListing;
  int _currentImage = 0;
  final PageController _pageController = PageController();

  List<String> get _images =>
      _listing.images.isNotEmpty ? _listing.images : [Assets.listings1];

  void _onBoostSuccess() {
    setState(() {
      _listing = _listing.copyWith(isBoosted: true, boostRemainingDays: 9);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('My Listing'),
        leading: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStateSwitcher(),
            const SizedBox(height: AppTheme.spaceM),
            _buildImageGallery(),
            const SizedBox(height: AppTheme.spaceM),
            _buildListingDetails(),
            const SizedBox(height: AppTheme.spaceM),
            _buildStatsRow(),
            const SizedBox(height: AppTheme.spaceL),
            _buildBoostSection(),
          ],
        ),
      ),
    );
  }

  // ── State Switcher ────────────────────────────────────────────

  Widget _buildStateSwitcher() {
    final states = [
      ('New', ListingModel.newListing),
      ('Active', ListingModel.activeListing),
      ('Expiring', ListingModel.expiringSoonListing),
      ('Expired', ListingModel.expiredListing),
      ('Boosted', ListingModel.boostedListing),
    ];

    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceS),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              'Preview State',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: states.map((s) {
                final isActive =
                    _listing.id == s.$2.id && _listing.status == s.$2.status;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _listing = s.$2;
                      _currentImage = 0;
                    });
                    if (_pageController.hasClients) {
                      _pageController.jumpToPage(0);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: isActive ? AppTheme.primary : AppTheme.background,
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                      border: Border.all(
                        color: isActive ? AppTheme.primary : AppTheme.border,
                      ),
                    ),
                    child: Text(
                      s.$1,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isActive ? Colors.white : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Image Gallery ─────────────────────────────────────────────

  Widget _buildImageGallery() {
    final images = _images;

    return Column(
      children: [
        Stack(
          children: [
            // Gallery
            Container(
              height: 260,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radiusL),
                color: AppTheme.surface,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusL),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: images.length,
                  onPageChanged: (i) => setState(() => _currentImage = i),
                  itemBuilder: (context, index) => Image.asset(
                    images[index],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppTheme.border,
                      child: const Center(
                        child: Icon(
                          Icons.broken_image_rounded,
                          size: 48,
                          color: AppTheme.textHint,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Boosted badge
            if (_listing.isBoosted)
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.warning,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppTheme.shadowMd,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'BOOSTED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Status badge (non-boosted)
            if (!_listing.isBoosted)
              Positioned(top: 12, left: 12, child: _buildImageStatusBadge()),

            // Image counter
            Positioned(
              bottom: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${_currentImage + 1} / ${images.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),

        // Dots indicator
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(images.length, (i) {
            final isActive = i == _currentImage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive ? AppTheme.primary : AppTheme.border,
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildImageStatusBadge() {
    Color color;
    IconData icon;
    String label;
    switch (_listing.status) {
      case ListingStatus.newListing:
        color = AppTheme.primary;
        icon = Icons.fiber_new_rounded;
        label = 'NEW';
        break;
      case ListingStatus.active:
        color = AppTheme.success;
        icon = Icons.check_circle_rounded;
        label = 'ACTIVE';
        break;
      case ListingStatus.expiringSoon:
        color = AppTheme.warning;
        icon = Icons.timer_rounded;
        label = 'EXPIRING SOON';
        break;
      case ListingStatus.expired:
        color = AppTheme.error;
        icon = Icons.cancel_rounded;
        label = 'EXPIRED';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ── Listing Details ───────────────────────────────────────────

  Widget _buildListingDetails() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceM),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  _listing.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildDetailStatusBadge(),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.location_on_rounded,
                size: 14,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                _listing.location,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceM),
          Text(
            '\$${_listing.price.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: AppTheme.primary,
            ),
          ),
          if (_listing.remainingDays != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  _listing.status == ListingStatus.expiringSoon
                      ? Icons.timer_rounded
                      : Icons.calendar_today_rounded,
                  size: 13,
                  color: _listing.status == ListingStatus.expiringSoon
                      ? AppTheme.warning
                      : AppTheme.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  _listing.remainingDays == 0
                      ? 'Listing expired'
                      : '${_listing.remainingDays} days remaining',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _listing.status == ListingStatus.expiringSoon
                        ? AppTheme.warning
                        : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailStatusBadge() {
    Color color;
    Color bg;
    String label;
    switch (_listing.status) {
      case ListingStatus.newListing:
        color = AppTheme.primary;
        bg = AppTheme.primaryLight;
        label = 'New';
        break;
      case ListingStatus.active:
        color = AppTheme.success;
        bg = AppTheme.successLight;
        label = 'Active';
        break;
      case ListingStatus.expiringSoon:
        color = AppTheme.warning;
        bg = AppTheme.warningLight;
        label = 'Expiring';
        break;
      case ListingStatus.expired:
        color = AppTheme.error;
        bg = AppTheme.errorLight;
        label = 'Expired';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ── Stats Row ─────────────────────────────────────────────────

  Widget _buildStatsRow() {
    return Row(
      children: [
        _statChip(Icons.king_bed_rounded, '${_listing.bedrooms} Beds'),
        const SizedBox(width: AppTheme.spaceS),
        _statChip(Icons.bathtub_rounded, '${_listing.bathrooms} Baths'),
        const SizedBox(width: AppTheme.spaceS),
        _statChip(
          Icons.square_foot_rounded,
          '${_listing.areaSqft.toStringAsFixed(0)} sqft',
        ),
      ],
    );
  }

  Widget _statChip(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          border: Border.all(color: AppTheme.border),
          boxShadow: AppTheme.shadowSm,
        ),
        child: Column(
          children: [
            Icon(icon, size: 24, color: AppTheme.primary),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Boost Section ─────────────────────────────────────────────

  Widget _buildBoostSection() {
    if (_listing.status == ListingStatus.expired) {
      return _buildExpiredSection();
    }
    if (_listing.isBoosted) {
      return _buildBoostedSection();
    }
    return _buildNotBoostedSection();
  }

  Widget _buildNotBoostedSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.spaceM),
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(AppTheme.radiusL),
            border: Border.all(color: AppTheme.primary.withOpacity(0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    ),
                    child: const Icon(
                      Icons.trending_up_rounded,
                      color: AppTheme.primary,
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spaceS),
                  const Text(
                    'Boost Your Listing',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spaceS),
              const Text(
                'Get 5x more views and sell faster',
                style: TextStyle(fontSize: 15, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: AppTheme.spaceS),
              Row(
                children: [
                  const Icon(
                    Icons.flash_on_rounded,
                    color: Colors.orange,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Boosted listings get higher ranking & visibility',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spaceM),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            boxShadow: AppTheme.shadowPrimary,
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _listing.canBoost ? _navigateToBoost : null,
              icon: const Icon(
                Icons.rocket_launch_rounded,
                size: 18,
                color: AppTheme.accent,
              ),
              label: const Text('Boost Listing'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBoostedSection() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceM),
      decoration: BoxDecoration(
        color: AppTheme.warningLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(color: AppTheme.warning.withOpacity(0.4)),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppTheme.radiusS),
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  color: AppTheme.warning,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppTheme.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Listing is Boosted!',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      '${_listing.boostRemainingDays} days remaining',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.warning,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_listing.boostRemainingDays}d left',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceM),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _navigateToBoost,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Extend Boost'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.warning,
                side: const BorderSide(color: AppTheme.warning),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiredSection() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceM),
      decoration: BoxDecoration(
        color: AppTheme.errorLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(color: AppTheme.error.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.cancel_rounded, color: AppTheme.error, size: 20),
              SizedBox(width: 8),
              Text(
                'Listing Expired',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'This listing has expired and cannot be boosted. Please renew it first.',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppTheme.spaceM),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RenewPage(
                      listing: _listing,
                      onRenewSuccess: () {
                        setState(() {
                          _listing = _listing.copyWith(
                            status: ListingStatus.active,
                            remainingDays: 30,
                          );
                        });
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Renew Listing'),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            ),
          ),
        ],
      ),
    );
  }

  // ── Navigation ────────────────────────────────────────────────

  void _navigateToBoost() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            BoostPage(listing: _listing, onBoostSuccess: _onBoostSuccess),
      ),
    );
  }
}
