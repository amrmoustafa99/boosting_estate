class PushSlotInfo {
  final DateTime nextNormalSlot;
  final double normalPrice;
  final bool urgentAvailable;
  final double urgentPrice;
  final int normalSlotsLeft;

  const PushSlotInfo({
    required this.nextNormalSlot,
    required this.normalPrice,
    required this.urgentAvailable,
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

/// Mock queue service simulating admin-configured slot system
class BoostQueueService {
  static final BoostQueueService instance = BoostQueueService._();
  BoostQueueService._();

  PushSlotInfo getPushSlotInfo() {
    final now = DateTime.now();
    // Next normal slot: tomorrow at 5 PM
    final tomorrow = DateTime(now.year, now.month, now.day + 1, 17, 0);
    return PushSlotInfo(
      nextNormalSlot: tomorrow,
      normalPrice: 4.99,
      urgentAvailable: true,
      urgentPrice: 12.99,
      normalSlotsLeft: 3,
    );
  }

  WhatsAppSlotInfo getWhatsAppSlotInfo() {
    final now = DateTime.now();
    // Next WhatsApp slot: Friday at 7 PM
    final daysUntilFriday = (DateTime.friday - now.weekday + 7) % 7;
    final nextFriday = DateTime(
      now.year,
      now.month,
      now.day + (daysUntilFriday == 0 ? 7 : daysUntilFriday),
      19,
      0,
    );
    return WhatsAppSlotInfo(nextSlot: nextFriday, price: 6.99, slotsLeft: 5);
  }
}
