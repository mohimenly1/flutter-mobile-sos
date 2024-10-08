import 'package:flutter/material.dart';
import 'package:shop/components/product/news_card.dart';
import 'package:shop/models/news_model.dart';
import 'package:shop/route/route_constants.dart';

import '../../../constants.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // While loading use 👇
          //  BookMarksSlelton(),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            // sliver: SliverGrid(
            //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            //     maxCrossAxisExtent: 200.0,
            //     mainAxisSpacing: defaultPadding,
            //     crossAxisSpacing: defaultPadding,
            //     childAspectRatio: 0.66,
            //   ),
            //   // delegate: SliverChildBuilderDelegate(
            //   //   (BuildContext context, int index) {
            //   //     return NewsCard(
            //   //       image: demoNewsHandler[index].image,
            //   //       brandName: demoNewsHandler[index].brandName,
            //   //       title: demoNewsHandler[index].title,
            //   //       price: demoNewsHandler[index].price,
            //   //       priceAfetDiscount: demoNewsHandler[index].priceAfetDiscount,
            //   //       dicountpercent: demoNewsHandler[index].dicountpercent,
            //   //       press: () {
            //   //         Navigator.pushNamed(context, productDetailsScreenRoute);
            //   //       },
            //   //     );
            //   //   },
            //   //   childCount: demoNewsHandler.length,
            //   // ),
            // ),
          ),
        ],
      ),
    );
  }
}
