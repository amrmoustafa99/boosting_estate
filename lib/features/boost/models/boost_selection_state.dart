import 'boost_option.dart';

class BoostSelectionState {
  final DurationOption? selectedDuration;
  final bool pushSelected;
  final BoostSubOption? selectedInstagram;
  final bool whatsappSelected;

  const BoostSelectionState({
    this.selectedDuration,
    this.pushSelected = false,
    this.selectedInstagram,
    this.whatsappSelected = false,
  });

  ///  total price based on selections
  double get totalPrice {
    double total = 0;
    if (selectedDuration != null) total += selectedDuration!.price;
    if (pushSelected) total += 4.99;
    if (selectedInstagram != null) total += selectedInstagram!.price;
    if (whatsappSelected) total += 6.99;
    return total;
  }

  /// True if at least one option is selected
  bool get hasSelection =>
      selectedDuration != null ||
      pushSelected ||
      selectedInstagram != null ||
      whatsappSelected;

  List<String> get selectedLabels {
    final labels = <String>[];
    if (selectedDuration != null) {
      labels.add('In-App Boost (${selectedDuration!.days} days)');
    }
    if (pushSelected) labels.add('Push Notification');
    if (selectedInstagram != null) {
      labels.add('Instagram ${selectedInstagram!.label}');
    }
    if (whatsappSelected) labels.add('WhatsApp Blast');
    return labels;
  }

  /// Immutable update helpers
  BoostSelectionState copyWith({
    DurationOption? selectedDuration,
    bool clearDuration = false,
    bool? pushSelected,
    BoostSubOption? selectedInstagram,
    bool clearInstagram = false,
    bool? whatsappSelected,
  }) {
    return BoostSelectionState(
      selectedDuration: clearDuration
          ? null
          : (selectedDuration ?? this.selectedDuration),
      pushSelected: pushSelected ?? this.pushSelected,
      selectedInstagram: clearInstagram
          ? null
          : (selectedInstagram ?? this.selectedInstagram),
      whatsappSelected: whatsappSelected ?? this.whatsappSelected,
    );
  }
}
