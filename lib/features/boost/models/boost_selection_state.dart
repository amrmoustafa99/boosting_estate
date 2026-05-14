import 'boost_option.dart';
import '../services/boost_queue_service.dart';

class BoostSelectionState {
  final DurationOption? selectedDuration;
  final bool pushSelected;
  final bool urgentPushSelected;
  final Set<InstagramFormat> selectedInstagramFormats;
  final bool whatsappSelected;

  const BoostSelectionState({
    this.selectedDuration,
    this.pushSelected = false,
    this.urgentPushSelected = false,
    this.selectedInstagramFormats = const {},
    this.whatsappSelected = false,
  });

  bool get _urgentPushSoldOut =>
      BoostQueueService.instance.getPushSlotInfo().urgentSoldOut;

  double get totalPrice {
    double total = 0;
    if (selectedDuration != null) total += selectedDuration!.price;
    if (urgentPushSelected && !_urgentPushSoldOut) {
      total += 8;
    } else if (pushSelected) {
      total += 3;
    }
    for (final fmt in selectedInstagramFormats) {
      total += _instagramPriceFor(fmt);
    }
    if (whatsappSelected) total += 2;
    return total;
  }

  String _instagramLabelAr(InstagramFormat fmt) {
    switch (fmt) {
      case InstagramFormat.story:
        return 'ترويج انستقرام — ستوري';
      case InstagramFormat.post:
        return 'ترويج انستقرام — منشور';
      case InstagramFormat.reel:
        return 'ترويج انستقرام — ريلز';
    }
  }

  double _instagramPriceFor(InstagramFormat fmt) {
    switch (fmt) {
      case InstagramFormat.story:
        return 2;
      case InstagramFormat.post:
        return 5;
      case InstagramFormat.reel:
        return 8;
    }
  }

  bool get hasSelection =>
      selectedDuration != null ||
      pushSelected ||
      (urgentPushSelected && !_urgentPushSoldOut) ||
      selectedInstagramFormats.isNotEmpty ||
      whatsappSelected;

  List<SelectedBoostItem> get selectedItems {
    final items = <SelectedBoostItem>[];
    if (selectedDuration != null) {
      items.add(
        SelectedBoostItem(
          label:
              'تمييز الإعلان داخل التطبيق (${selectedDuration!.days} ${selectedDuration!.days == 1 ? 'يوم' : 'أيام'})',
          price: selectedDuration!.price,
          isRecurring: true,
          isProcessingAuto: true,
        ),
      );
    }
    if (urgentPushSelected && !_urgentPushSoldOut) {
      items.add(
        const SelectedBoostItem(
          label: 'تنبيه عاجل اليوم (خلال ساعتين)',
          price: 8,
          isRecurring: false,
          isProcessingAuto: false,
        ),
      );
    } else if (pushSelected) {
      items.add(
        const SelectedBoostItem(
          label: 'تنبيهات مباشرة (Push)',
          price: 3,
          isRecurring: false,
          isProcessingAuto: true,
        ),
      );
    }
    for (final fmt in selectedInstagramFormats) {
      items.add(
        SelectedBoostItem(
          label: _instagramLabelAr(fmt),
          price: _instagramPriceFor(fmt),
          isRecurring: false,
          isProcessingAuto: false,
        ),
      );
    }
    if (whatsappSelected) {
      items.add(
        const SelectedBoostItem(
          label: 'برودكاست واتساب',
          price: 2,
          isRecurring: false,
          isProcessingAuto: false,
        ),
      );
    }
    return items;
  }

  List<String> get selectedLabels => selectedItems.map((e) => e.label).toList();

  BoostSelectionState copyWith({
    DurationOption? selectedDuration,
    bool clearDuration = false,
    bool? pushSelected,
    bool? urgentPushSelected,
    Set<InstagramFormat>? selectedInstagramFormats,
    bool? whatsappSelected,
  }) {
    return BoostSelectionState(
      selectedDuration: clearDuration
          ? null
          : (selectedDuration ?? this.selectedDuration),
      pushSelected: pushSelected ?? this.pushSelected,
      urgentPushSelected: urgentPushSelected ?? this.urgentPushSelected,
      selectedInstagramFormats:
          selectedInstagramFormats ?? this.selectedInstagramFormats,
      whatsappSelected: whatsappSelected ?? this.whatsappSelected,
    );
  }
}

class SelectedBoostItem {
  final String label;
  final double price;
  final bool isRecurring;
  final bool isProcessingAuto;

  const SelectedBoostItem({
    required this.label,
    required this.price,
    required this.isRecurring,
    required this.isProcessingAuto,
  });
}
