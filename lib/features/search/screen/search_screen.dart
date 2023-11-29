import 'package:coffee/common/widgets/loader.dart';
import 'package:coffee/constants/global_variables.dart';
import 'package:coffee/features/home/widgets/address_box.dart';
import 'package:coffee/features/item_details/screens/item_detail_screen.dart';
import 'package:coffee/features/search/services/search_services.dart';
import 'package:coffee/features/search/widgets/searched_item.dart';
import 'package:coffee/models/item.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search-screen';
  final String searchQuery;
  const SearchScreen({
    super.key,
    required this.searchQuery,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(
      context,
      SearchScreen.routeName,
      arguments: query,
    );
  }

  List<Item>? items;
  final SearchServices searchServices = SearchServices();

  @override
  void initState() {
    super.initState();
    fetchSearchedItems();
  }

  fetchSearchedItems() async {
    items = await searchServices.fetchSearchedItems(
        context: context, searchQuery: widget.searchQuery);
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
      body: items == null
          ? const Loader()
          : Column(
              children: [
                const AddressBox(),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: items!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                          context,
                          ItemDetailScreen.routeName,
                          arguments: items![index],
                        );
                        },
                        child: SearchedItem(item: items![index]),
                      );
                    },
                  ),
                )
              ],
            ),
    );
  }
}
