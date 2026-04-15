enum BoostType { inApp, pushNotification, instagram, whatsapp }

/// Sub-option for boosts like the(Instagram: Story / Post / Reel)
class BoostSubOption {
  final String id;
  final String label;
  final double price;

  const BoostSubOption({
    required this.id,
    required this.label,
    required this.price,
  });
}

/// Duration option for In-App Boost
class DurationOption {
  final int days;
  final double price;

  const DurationOption({required this.days, required this.price});
}

/// Core model for a boost option card
class BoostOption {
  final String id;
  final BoostType type;
  final String title;
  final String subtitle;
  final String iconAsset;
  final double? fixedPrice;
  final List<BoostSubOption> subOptions;
  final List<DurationOption> durationOptions;

  const BoostOption({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.iconAsset,
    this.fixedPrice,
    this.subOptions = const [],
    this.durationOptions = const [],
  });
}

/// Mock data factory , all pricing defined here in one place
class BoostOptionsMockData {
  static final List<BoostOption> all = [
    BoostOption(
      id: 'in_app',
      type: BoostType.inApp,
      title: 'In-App Boost',
      subtitle: 'Appear on homepage & top of search results',
      iconAsset: 'rocket_launch',
      durationOptions: const [
        DurationOption(days: 3, price: 9.99),
        DurationOption(days: 6, price: 16.99),
        DurationOption(days: 9, price: 22.99),
      ],
    ),
    BoostOption(
      id: 'push_notification',
      type: BoostType.pushNotification,
      title: 'Push Notification',
      subtitle: 'Sent once to all nearby users instantly',
      iconAsset: 'notifications_active',
      fixedPrice: 4.99,
    ),
    BoostOption(
      id: 'instagram',
      type: BoostType.instagram,
      title: 'Instagram Boost',
      subtitle: 'Promote your listing on Instagram',
      iconAsset: 'photo_camera',
      subOptions: const [
        BoostSubOption(id: 'story', label: 'Story', price: 7.99),
        BoostSubOption(id: 'post', label: 'Post', price: 12.99),
        BoostSubOption(id: 'reel', label: 'Reel', price: 19.99),
      ],
    ),
    BoostOption(
      id: 'whatsapp',
      type: BoostType.whatsapp,
      title: 'WhatsApp Blast',
      subtitle: 'Broadcast to active buyers in your area',
      iconAsset: 'chat_bubble',
      fixedPrice: 6.99,
    ),
  ];
}
