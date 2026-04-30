import 'boost_option.dart';

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

  double get totalPrice {
    double total = 0;
    if (selectedDuration != null) total += selectedDuration!.price;
    if (urgentPushSelected) {
      total += 12.99;
    } else if (pushSelected) {
      total += 4.99;
    }
    for (final fmt in selectedInstagramFormats) {
      total += _instagramPriceFor(fmt);
    }
    if (whatsappSelected) total += 6.99;
    return total;
  }

  double _instagramPriceFor(InstagramFormat fmt) {
    switch (fmt) {
      case InstagramFormat.story:
        return 7.99;
      case InstagramFormat.post:
        return 12.99;
      case InstagramFormat.reel:
        return 19.99;
    }
  }

  bool get hasSelection =>
      selectedDuration != null ||
      pushSelected ||
      urgentPushSelected ||
      selectedInstagramFormats.isNotEmpty ||
      whatsappSelected;

  List<SelectedBoostItem> get selectedItems {
    final items = <SelectedBoostItem>[];
    if (selectedDuration != null) {
      items.add(
        SelectedBoostItem(
          label: 'In-App Featured (${selectedDuration!.days} days)',
          price: selectedDuration!.price,
          isRecurring: true,
          isProcessingAuto: true,
        ),
      );
    }
    if (urgentPushSelected) {
      items.add(
        const SelectedBoostItem(
          label: 'Urgent Push Today (2h)',
          price: 12.99,
          isRecurring: false,
          isProcessingAuto: false,
        ),
      );
    } else if (pushSelected) {
      items.add(
        const SelectedBoostItem(
          label: 'Push Notification',
          price: 4.99,
          isRecurring: false,
          isProcessingAuto: true,
        ),
      );
    }
    for (final fmt in selectedInstagramFormats) {
      items.add(
        SelectedBoostItem(
          label:
              'Instagram ${fmt.name[0].toUpperCase()}${fmt.name.substring(1)}',
          price: _instagramPriceFor(fmt),
          isRecurring: false,
          isProcessingAuto: false,
        ),
      );
    }
    if (whatsappSelected) {
      items.add(
        const SelectedBoostItem(
          label: 'WhatsApp Blast',
          price: 6.99,
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
