import 'package:flutter/material.dart';

import '../../../../constants.dart';
import 'categories.dart';
import 'offers_carousel.dart';

class OffersCarouselAndCategories extends StatelessWidget {
  const OffersCarouselAndCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // While loading use 👇
          // const OffersSkelton(),
          const OffersCarousel(),
          const SizedBox(height: defaultPadding / 2),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Text(
              "الخدمــات",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          // While loading use 👇
          // const CategoriesSkelton(),
          const Categories(),
        ],
      ),
    );
  }
}
