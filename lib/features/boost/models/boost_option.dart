enum BoostType { inApp, pushNotification, instagram, whatsapp }

enum InstagramFormat { story, post, reel }

class DurationOption {
  final int days;
  final double price;

  const DurationOption({required this.days, required this.price});

  //   price per 3-day unit, calculated dynamically
  int get units => days ~/ 3;
  double get pricePerUnit => price / units;

  /// lik:   "3 units × $3.33/unit"
  String get unitBreakdown =>
      '$units unit${units > 1 ? 's' : ''} × \$${pricePerUnit.toStringAsFixed(2)}/3-day unit';
}

class InstagramOption {
  final InstagramFormat format;
  final String label;
  final double price;
  final String description;
  const InstagramOption({
    required this.format,
    required this.label,
    required this.price,
    required this.description,
  });
}

class PushSlot {
  final DateTime scheduledAt;
  final bool isUrgent;
  final double price;
  final int availableSlots;

  const PushSlot({
    required this.scheduledAt,
    required this.isUrgent,
    required this.price,
    required this.availableSlots,
  });
}

class WhatsAppSlot {
  final DateTime scheduledAt;
  final double price;
  final int availableSlots;

  const WhatsAppSlot({
    required this.scheduledAt,
    required this.price,
    required this.availableSlots,
  });
}

class BoostOption {
  final String id;
  final BoostType type;
  final String title;
  final String subtitle;
  final String iconAsset;
  final double? fixedPrice;
  final List<DurationOption> durationOptions;
  final List<InstagramOption> instagramOptions;

  const BoostOption({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.iconAsset,
    this.fixedPrice,
    this.durationOptions = const [],
    this.instagramOptions = const [],
  });
}

class BoostOptionsMockData {
  static final List<BoostOption> all = [
    const BoostOption(
      id: 'in_app',
      type: BoostType.inApp,
      title: 'In-App Featured Boost',
      subtitle: 'Homepage & top of search results',
      iconAsset: 'rocket_launch',
      durationOptions: [
        DurationOption(days: 3, price: 9.99),
        DurationOption(days: 6, price: 16.99),
        DurationOption(days: 9, price: 22.99),
        DurationOption(days: 12, price: 27.99),
        DurationOption(days: 15, price: 31.99),
      ],
    ),
    const BoostOption(
      id: 'push_notification',
      type: BoostType.pushNotification,
      title: 'Push Notification',
      subtitle: 'Sent to all nearby users instantly',
      iconAsset: 'notifications_active',
      fixedPrice: 4.99,
    ),
    const BoostOption(
      id: 'instagram',
      type: BoostType.instagram,
      title: 'Instagram Boost',
      subtitle: 'Promote your listing on Instagram',
      iconAsset: 'photo_camera',
      instagramOptions: [
        InstagramOption(
          format: InstagramFormat.story,
          label: 'Story',
          price: 7.99,
          description: '24h visibility',
        ),
        InstagramOption(
          format: InstagramFormat.post,
          label: 'Post',
          price: 12.99,
          description: 'Permanent post',
        ),
        InstagramOption(
          format: InstagramFormat.reel,
          label: 'Reel',
          price: 19.99,
          description: 'Max reach',
        ),
      ],
    ),
    const BoostOption(
      id: 'whatsapp',
      type: BoostType.whatsapp,
      title: 'WhatsApp Blast',
      subtitle: 'Broadcast to active buyers in your area',
      iconAsset: 'chat_bubble',
      fixedPrice: 6.99,
    ),
  ];
}
