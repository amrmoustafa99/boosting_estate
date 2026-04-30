import '../../../generated/assets.dart';

enum ListingStatus { newListing, active, expiringSoon, expired }

class ListingModel {
  final String id;
  final String title;
  final String location;
  final double price;
  final int bedrooms;
  final int bathrooms;
  final double areaSqft;
  final ListingStatus status;
  final int? remainingDays;
  final bool isBoosted;
  final int? boostRemainingDays;
  final List<String> images;

  const ListingModel({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.areaSqft,
    required this.status,
    this.remainingDays,
    this.isBoosted = false,
    this.boostRemainingDays,
    this.images = const [],
  });

  // ✅ FIX 1: expiringSoon removed — only new & active listings can be boosted
  bool get canBoost =>
      status == ListingStatus.newListing || status == ListingStatus.active;

  String get statusLabel {
    switch (status) {
      case ListingStatus.newListing:
        return 'New';
      case ListingStatus.active:
        return 'Active';
      case ListingStatus.expiringSoon:
        return 'Expiring Soon';
      case ListingStatus.expired:
        return 'Expired';
    }
  }

  ListingModel copyWith({
    bool? isBoosted,
    int? boostRemainingDays,
    ListingStatus? status,
    int? remainingDays,
    List<String>? images,
  }) {
    return ListingModel(
      id: id,
      title: title,
      location: location,
      price: price,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      areaSqft: areaSqft,
      status: status ?? this.status,
      remainingDays: remainingDays ?? this.remainingDays,
      isBoosted: isBoosted ?? this.isBoosted,
      boostRemainingDays: boostRemainingDays ?? this.boostRemainingDays,
      images: images ?? this.images,
    );
  }

  // ── Mock States ───────────────────────────────────────────────
  static const newListing = ListingModel(
    id: 'listing_001',
    title: 'Modern Villa with Sea View',
    location: 'Hurghada, Red Sea, Egypt',
    price: 285000,
    bedrooms: 4,
    bathrooms: 3,
    areaSqft: 2450,
    status: ListingStatus.newListing,
    images: [Assets.listings1, Assets.listings3, Assets.listings4],
  );

  static const activeListing = ListingModel(
    id: 'listing_002',
    title: 'Luxury Penthouse Downtown',
    location: 'New Cairo, Cairo, Egypt',
    price: 520000,
    bedrooms: 3,
    bathrooms: 2,
    areaSqft: 1800,
    status: ListingStatus.active,
    remainingDays: 25,
    images: [Assets.listings5, Assets.listings22, Assets.listings1],
  );

  static const expiringSoonListing = ListingModel(
    id: 'listing_003',
    title: 'Cozy Studio Near Beach',
    location: 'Ain Sokhna, Suez, Egypt',
    price: 85000,
    bedrooms: 1,
    bathrooms: 1,
    areaSqft: 650,
    status: ListingStatus.expiringSoon,
    remainingDays: 2,
    images: [Assets.listings5, Assets.listings22, Assets.listings1],
  );

  static const expiredListing = ListingModel(
    id: 'listing_004',
    title: 'Family Apartment with Garden',
    location: 'Maadi, Cairo, Egypt',
    price: 175000,
    bedrooms: 3,
    bathrooms: 2,
    areaSqft: 1400,
    status: ListingStatus.expired,
    remainingDays: 0,
    images: [Assets.listings5, Assets.listings22, Assets.listings1],
  );

  static const boostedListing = ListingModel(
    id: 'listing_005',
    title: 'Modern Villa with Sea View',
    location: 'Hurghada, Red Sea, Egypt',
    price: 285000,
    bedrooms: 4,
    bathrooms: 3,
    areaSqft: 2450,
    status: ListingStatus.active,
    remainingDays: 18,
    isBoosted: true,
    boostRemainingDays: 5,
    images: [Assets.listings5, Assets.listings22, Assets.listings1],
  );

  static const mock = newListing;
}
