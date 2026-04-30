import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../models/listing_model.dart';

class RenewPage extends StatefulWidget {
  final ListingModel listing;
  final VoidCallback onRenewSuccess;

  const RenewPage({
    super.key,
    required this.listing,
    required this.onRenewSuccess,
  });

  @override
  State<RenewPage> createState() => _RenewPageState();
}

class _RenewPageState extends State<RenewPage> {
  int _selectedDays = 30;
  final Map<int, double> _plans = {30: 29.99, 60: 49.99, 90: 69.99};

  double get _subtotal => _plans[_selectedDays]!;
  double get _vat => _subtotal * 0.14;
  double get _total => _subtotal + _vat;

  void _goToPayment() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusXL),
        ),
      ),
      builder: (_) => _buildPaymentSheet(),
    );
  }

  Widget _buildPaymentSheet() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceL),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Confirm Payment',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spaceM),
          _summaryRow('Listing renewal', '$_selectedDays days'),
          _summaryRow('Subtotal', '\$${_subtotal.toStringAsFixed(2)}'),
          _summaryRow('VAT (14%)', '\$${_vat.toStringAsFixed(2)}'),
          const Divider(color: AppTheme.border),
          _summaryRow('Total', '\$${_total.toStringAsFixed(2)}', isBold: true),
          const SizedBox(height: AppTheme.spaceL),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // close sheet
                _onPaymentSuccess();
              },
              child: Text('Pay \$${_total.toStringAsFixed(2)}'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 15 : 13,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 16 : 13,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: isBold ? AppTheme.primary : AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _onPaymentSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.successLight,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: AppTheme.success,
                size: 44,
              ),
            ),
            const SizedBox(height: AppTheme.spaceM),
            const Text(
              'Listing Renewed!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: AppTheme.spaceS),
            const Text(
              'Your listing is now active and visible in search results.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onRenewSuccess();
                Navigator.of(context)
                  ..pop() // close dialog
                  ..pop(); // go back to listing page
              },
              child: const Text('Back to Listing'),
            ),
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
        title: const Text('Renew Listing'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
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
                const Text(
                  'Select Duration',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: AppTheme.spaceM),
                ..._plans.entries.map((e) => _buildPlanCard(e.key, e.value)),
                const SizedBox(height: AppTheme.spaceM),
                _buildInfoBox(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.spaceM),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _goToPayment,
                child: Text('Continue — \$${_subtotal.toStringAsFixed(2)}'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(int days, double price) {
    final isSelected = _selectedDays == days;
    return GestureDetector(
      onTap: () => setState(() => _selectedDays = days),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: AppTheme.spaceS),
        padding: const EdgeInsets.all(AppTheme.spaceM),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryLight : AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: isSelected ? AppTheme.primary : AppTheme.border,
            ),
            const SizedBox(width: AppTheme.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$days days',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.textPrimary,
                    ),
                  ),
                  if (days == 60)
                    const Text(
                      'Best value · save 17%',
                      style: TextStyle(fontSize: 11, color: AppTheme.success),
                    ),
                  if (days == 90)
                    const Text(
                      'Maximum visibility',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              '\$${price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListingPreview() {
    // same as BoostPage._buildListingPreview() — reuse your existing widget
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
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusS),
              gradient: const LinearGradient(
                colors: [Color(0xFF1A56DB), Color(0xFF60A5FA)],
              ),
            ),
            child: const Icon(
              Icons.home_rounded,
              color: Colors.white,
              size: 26,
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
                Text(
                  widget.listing.location,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '\$${widget.listing.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primary,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.errorLight,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: const Text(
                        'Expired',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceM),
      decoration: BoxDecoration(
        color: AppTheme.primaryLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded, size: 16, color: AppTheme.primary),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'After renewal your listing will be reactivated immediately. All existing photos and details are preserved.',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.primary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
