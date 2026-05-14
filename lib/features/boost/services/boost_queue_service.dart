/// أيام البث الافتراضية من إعدادات الأدمن (لا تظهر للمستخدم في التطبيق).
const Set<int> kDefaultWhatsappCampaignWeekdays = {
  DateTime.sunday,
  DateTime.tuesday,
  DateTime.thursday,
};

class PushSlotInfo {
  final DateTime nextNormalSlot;
  final double normalPrice;
  final bool urgentAvailable;

  /// عند true: استُنفدت حصة التنبيه العاجل لهذا اليوم.
  final bool urgentSoldOut;

  final double urgentPrice;
  final int normalSlotsLeft;

  const PushSlotInfo({
    required this.nextNormalSlot,
    required this.normalPrice,
    required this.urgentAvailable,
    required this.urgentSoldOut,
    required this.urgentPrice,
    required this.normalSlotsLeft,
  });
}

class WhatsAppSlotInfo {
  final DateTime nextSlot;
  final double price;
  final int slotsLeft;

  const WhatsAppSlotInfo({
    required this.nextSlot,
    required this.price,
    required this.slotsLeft,
  });
}

/// يحاكي إعدادات الأدمن (مواعيد، أسعار بالدينار، حد التنبيه العاجل).
class BoostQueueService {
  static final BoostQueueService instance = BoostQueueService._();
  BoostQueueService._();

  /// عند true يُحاكي انتهاء الحصة اليومية للتنبيه العاجل. اتركها false للتجربة.
  static bool simulateUrgentSoldOut = true;

  static const int whatsappSendHour = 10;
  static const int whatsappSendMinute = 0;

  PushSlotInfo getPushSlotInfo() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1, 21, 0);
    return PushSlotInfo(
      nextNormalSlot: tomorrow,
      normalPrice: 3,
      urgentAvailable: true,
      urgentSoldOut: simulateUrgentSoldOut,
      urgentPrice: 8,
      normalSlotsLeft: 3,
    );
  }

  /// أقرب موعد بث (يستخدم أيام الحملة الافتراضية من إعدادات الأدمن فقط).
  DateTime nextWhatsAppSlot() {
    final days = kDefaultWhatsappCampaignWeekdays;
    final now = DateTime.now();
    for (var add = 0; add <= 14; add++) {
      final d = DateTime(now.year, now.month, now.day + add);
      final at = DateTime(
        d.year,
        d.month,
        d.day,
        whatsappSendHour,
        whatsappSendMinute,
      );
      if (!at.isAfter(now)) continue;
      if (days.contains(at.weekday)) return at;
    }
    return now.add(const Duration(days: 7));
  }

  WhatsAppSlotInfo getWhatsAppSlotInfo() {
    return WhatsAppSlotInfo(
      nextSlot: nextWhatsAppSlot(),
      price: 2,
      slotsLeft: 5,
    );
  }
}
