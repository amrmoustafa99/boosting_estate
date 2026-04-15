/// Model representing a real estate listing
class ListingModel {
  final String id;
  final String title;
  final String location;
  final double price;
  final int bedrooms;
  final int bathrooms;
  final double areaSqft;
  final bool isBoosted;
  final int? boostRemainingDays;

  const ListingModel({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.areaSqft,
    this.isBoosted = false,
    this.boostRemainingDays,
  });

  ListingModel copyWith({
    bool? isBoosted,
    int? boostRemainingDays,
  }) {
    return ListingModel(
      id: id,
      title: title,
      location: location,
      price: price,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      areaSqft: areaSqft,
      isBoosted: isBoosted ?? this.isBoosted,
      boostRemainingDays: boostRemainingDays ?? this.boostRemainingDays,
    );
  }

  /// Mock listing to use throughout the app
  static const mock = ListingModel(
    id: 'listing_001',
    title: 'Modern Villa with Sea View',
    location: 'Hurghada, Red Sea, Egypt',
    price: 285000,
    bedrooms: 4,
    bathrooms: 3,
    areaSqft: 2450,
    isBoosted: false,
  );

  /// Mock boosted listing (for testing the boosted state)
  static const mockBoosted = ListingModel(
    id: 'listing_001',
    title: 'Modern Villa with Sea View',
    location: 'Hurghada, Red Sea, Egypt',
    price: 285000,
    bedrooms: 4,
    bathrooms: 3,
    areaSqft: 2450,
    isBoosted: true,
    boostRemainingDays: 5,
  );
}
