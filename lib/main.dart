import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/theme/app_theme.dart';
import 'features/boost/models/listing_model.dart';
import 'features/boost/views/listing_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar');
  runApp(const BoostListingApp());
}

class BoostListingApp extends StatelessWidget {
  const BoostListingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تمييز الإعلان',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: ListingPage(
        listing: ListingModel(
          title: 'شقة للبيع — السالمية قطعة 12',
          location: 'السالمية، محافظة حولي، الكويت',
          price: 85000,
          images: [],
          bedrooms: 3,
          bathrooms: 2,
          areaSqft: 120,
          status: ListingStatus.active,
          remainingDays: 15,
          isBoosted: false,
          boostRemainingDays: 0,
          id: '',
        ),
      ),
    );
  }
}
