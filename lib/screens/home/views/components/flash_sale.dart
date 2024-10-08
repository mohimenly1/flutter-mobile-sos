import 'package:flutter/material.dart';

import '/components/Banner/M/banner_m_with_counter.dart';
import '../../../../constants.dart';

class FlashSale extends StatelessWidget {
  const FlashSale({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // While loading show 👇
        // const BannerMWithCounterSkelton(),
        BannerMWithCounter(
          duration: const Duration(hours: 8),
          text: "",
          press: () {},
        ),
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        // While loading show 👇
        // const ProductsSkelton(),
        // SizedBox(
        //   height: 220,
        //   child: ListView.builder(
        //     scrollDirection: Axis.horizontal,
        //     // Find demoFlashSaleProducts on models/NewsModel.dart
        //     itemCount: demoFlashSaleProducts.length,
        //     itemBuilder: (context, index) => Padding(
        //       padding: EdgeInsets.only(
        //         left: defaultPadding,
        //         right: index == demoFlashSaleProducts.length - 1
        //             ? defaultPadding
        //             : 0,
        //       ),
        //       child: NewsCard(
        //         image: demoFlashSaleProducts[index].image,
        //         brandName: demoFlashSaleProducts[index].brandName,
        //         title: demoFlashSaleProducts[index].title,
        //         price: demoFlashSaleProducts[index].price,
        //         priceAfetDiscount:
        //             demoFlashSaleProducts[index].priceAfetDiscount,
        //         dicountpercent: demoFlashSaleProducts[index].dicountpercent,
        //         press: () {
        //           Navigator.pushNamed(context, productDetailsScreenRoute,
        //               arguments: index.isEven);
        //         },
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
