import 'package:coffee/common/widgets/loader.dart';
import 'package:coffee/features/home/services/home_services.dart';
import 'package:coffee/features/item_details/screens/item_detail_screen.dart';
import 'package:coffee/models/item.dart';
import 'package:flutter/material.dart';

class OfferOfDay extends StatefulWidget {
  const OfferOfDay({super.key});

  @override
  State<OfferOfDay> createState() => _OfferOfDayState();
}

class _OfferOfDayState extends State<OfferOfDay> {
  final HomeServices homeServices = HomeServices();
  Item? item;
  @override
  void initState() {
    super.initState();
    fetchOfferOfDay();
  }

  void fetchOfferOfDay() async {
    item = await homeServices.fetchOfferOfDay(context: context);
    setState(() {});
  }

  void navigateToDetailScreen() {
    Navigator.pushNamed(
      context,
      ItemDetailScreen.routeName,
      arguments: item,
    );
  }

  @override
  Widget build(BuildContext context) {
    return item == null
        ? const Loader()
        : item!.name.isEmpty
            ? const SizedBox()
            : GestureDetector(
                onTap: navigateToDetailScreen,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 10, top: 15),
                      child: const Text(
                        'Weekly Specials',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Image.network(
                      item!.images[0],
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 15),
                      alignment: Alignment.topLeft,
                      child: const Text(
                        '\$2.99',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding:
                          const EdgeInsets.only(left: 15, top: 5, right: 40),
                      child: const Text(
                        'Special Latte',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: item!.images
                            .map(
                              (e) => Image.network(
                                e,
                                fit: BoxFit.fitWidth,
                                width: 100,
                                height: 100,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15)
                          .copyWith(left: 15),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'See all offers',
                        style: TextStyle(color: Colors.cyan[800]),
                      ),
                    )
                  ],
                ),
              );
  }
}
