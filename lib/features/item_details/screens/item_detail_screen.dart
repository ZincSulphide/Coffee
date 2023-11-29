import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee/common/widgets/custom_button.dart';
import 'package:coffee/common/widgets/star.dart';
import 'package:coffee/constants/global_variables.dart';
import 'package:coffee/features/item_details/services/item_details_services.dart';
import 'package:coffee/features/search/screen/search_screen.dart';
import 'package:coffee/models/item.dart';
import 'package:coffee/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ItemDetailScreen extends StatefulWidget {
  static const String routeName = '/item-details';
  final Item item;
  const ItemDetailScreen({
    super.key,
    required this.item,
  });

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final ItemDetailsServices itemDetailsServices = ItemDetailsServices();

  double avgRating = 0;
  double myRating = 0;
  @override
  void initState() {
    super.initState();
    double totalRating = 0;
    for (int i = 0; i < widget.item.rating!.length; i++) {
      totalRating += widget.item.rating![i].rating;
      if (widget.item.rating![i].userId ==
          Provider.of<UserProvider>(context, listen: false).user.id) {
        myRating = widget.item.rating![i].rating;
      }
    }

    if (totalRating != 0) {
      avgRating = totalRating / widget.item.rating!.length;
    }
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(
      context,
      SearchScreen.routeName,
      arguments: query,
    );
  }

  void addToCart() {
    itemDetailsServices.addToCart(
      context: context,
      item: widget.item,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Container(
                height: 42,
                margin: const EdgeInsets.only(left: 15),
                child: Material(
                  borderRadius: BorderRadius.circular(7),
                  elevation: 1,
                  child: TextFormField(
                    onFieldSubmitted: navigateToSearchScreen,
                    decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide:
                              BorderSide(color: Colors.black38, width: 1),
                        ),
                        hintText: 'Search for Items',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        )),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.transparent,
              height: 42,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: const Icon(
                Icons.mic,
                color: Colors.black,
                size: 25,
              ),
            )
          ]),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.item.id!),
                  Stars(rating: avgRating),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              child: Text(
                widget.item.name,
                style: const TextStyle(fontSize: 15),
              ),
            ),
            CarouselSlider(
              items: widget.item.images.map(
                (i) {
                  return Builder(
                    builder: (BuildContext context) => Image.network(
                      i,
                      fit: BoxFit.contain,
                    ),
                  );
                },
              ).toList(),
              options: CarouselOptions(
                viewportFraction: 1,
                height: 300,
              ),
            ),
            Container(
              color: Colors.white,
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: RichText(
                text: TextSpan(
                  text: 'Price: ',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '\$${widget.item.price}',
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.item.description),
            ),
            Container(
              color: Colors.white,
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 10,
              ),
              child: CustomButton(
                text: 'Order Now',
                onTap: () {},
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 10,
              ),
              child: CustomButton(
                text: 'Add to Order',
                onTap: addToCart,
                color: const Color.fromARGB(255, 198, 147, 114),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Text(
                'Rate the product',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            RatingBar.builder(
              initialRating: myRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(
                horizontal: 4,
              ),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: GlobalVariables.starColor,
              ),
              onRatingUpdate: (rating) {
                itemDetailsServices.rateItem(
                  context: context,
                  item: widget.item,
                  rating: rating,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
