enum BoostType { inApp, pushNotification, instagram, whatsapp }

enum InstagramFormat { story, post, reel }

class DurationOption {
  final int days;
  final double price;

  const DurationOption({required this.days, required this.price});

  int get units => days ~/ 3;
  double get pricePerUnit => price / units;

  /// عرض تفصيلي بالعربية (للشاشات التي تعرض وحدات الـ 3 أيام).
  String get unitBreakdownAr {
    final u = units;
    final unitWord = u == 1 ? 'وحدة' : 'وحدات';
    return '$u $unitWord × ${pricePerUnit.toStringAsFixed(2)} د.ك / 3 أيام';
  }
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
      title: 'تمييز الإعلان داخل التطبيق',
      subtitle: 'يظهر إعلانك في مقدمة نتائج البحث',
      iconAsset: 'rocket_launch',
    ),
    const BoostOption(
      id: 'push_notification',
      type: BoostType.pushNotification,
      title: 'تنبيهات مباشرة (Push)',
      subtitle: 'إرسال تنبيه فوري لآلاف المهتمين في منطقتك',
      iconAsset: 'notifications_active',
      fixedPrice: 3,
    ),
    const BoostOption(
      id: 'instagram',
      type: BoostType.instagram,
      title: 'ترويج انستقرام',
      subtitle: 'نشر عبر حسابنا (57k+ متابع)',
      iconAsset: 'photo_camera',
      instagramOptions: [
        InstagramOption(
          format: InstagramFormat.story,
          label: 'ستوري',
          price: 2,
          description: 'ظهور لمدة 24 ساعة',
        ),
        InstagramOption(
          format: InstagramFormat.post,
          label: 'بوست',
          price: 5,
          description: 'منشور دائم',
        ),
        InstagramOption(
          format: InstagramFormat.reel,
          label: 'ريلز',
          price: 8,
          description: 'أقصى انتشار',
        ),
      ],
    ),
    const BoostOption(
      id: 'whatsapp',
      type: BoostType.whatsapp,
      title: 'برودكاست واتساب',
      subtitle: 'إرسال تفاصيل العقار إلى قوائم المشتركين المهتمين',
      iconAsset: 'chat_bubble',
      fixedPrice: 2,
    ),
  ];
}
