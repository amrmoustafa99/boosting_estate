import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/boost/views/listing_page.dart';

void main() {
  runApp(const BoostListingApp());
}

class BoostListingApp extends StatelessWidget {
  const BoostListingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boost Listing',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: const ListingPage(),
    );
  }
}
