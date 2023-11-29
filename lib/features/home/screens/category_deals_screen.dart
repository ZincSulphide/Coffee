import 'package:coffee/common/widgets/loader.dart';
import 'package:coffee/constants/global_variables.dart';
import 'package:coffee/features/home/services/home_services.dart';
import 'package:coffee/features/item_details/screens/item_detail_screen.dart';
import 'package:coffee/models/item.dart';
import 'package:flutter/material.dart';

class CategoryDealsScreen extends StatefulWidget {
  static const String routeName = '/category-deals';
  final String category;
  const CategoryDealsScreen({
    super.key,
    required this.category,
  });

  @override
  State<CategoryDealsScreen> createState() => _CategoryDealsScreenState();
}

class _CategoryDealsScreenState extends State<CategoryDealsScreen> {
  List<Item>? itemList;
  final HomeServices homeServices = HomeServices();
  @override
  void initState() {
    super.initState();
    fetchCategoryItems();
  }

  fetchCategoryItems() async {
    itemList = await homeServices.fetchCategoryItems(
      context: context,
      category: widget.category,
    );
    setState(() {});
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
            title: Text(
              widget.category,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: itemList == null
            ? const Loader()
            : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Keep shopping for ${widget.category}',
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 170,
                      child: GridView.builder(
                        itemCount: itemList!.length,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(
                          left: 15,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 1.4,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          final item = itemList![index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                ItemDetailScreen.routeName,
                                arguments: item,
                              );
                            },
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 100,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black12,
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Image.network(
                                        item.images[0],
                                        fit: BoxFit.cover,
                                        height: 120,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: const EdgeInsets.only(
                                    left: 0,
                                    top: 5,
                                    right: 15,
                                  ),
                                  child: Text(
                                    item.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
            ));
  }
}
