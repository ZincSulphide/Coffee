import 'package:coffee/common/widgets/loader.dart';
import 'package:coffee/constants/global_variables.dart';
import 'package:coffee/features/account/widgets/single_item.dart';
import 'package:coffee/features/admin/screens/add_item_screen.dart';
import 'package:coffee/features/admin/services/admin_services.dart';
import 'package:coffee/models/item.dart';
import 'package:flutter/material.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Item>? items;
  final AdminServices adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    fetchAllItems();
  }

  fetchAllItems() async {
    items = await adminServices.fetchAllItems(context);
    setState(() {});
  }

  void deleteItem(Item item, int index) {
    adminServices.deleteItem(context: context, item: item, onSuccess: () {
      items!.removeAt(index);
      setState(() {});
    });
  } 

  void navigateToAddItem() {
    Navigator.pushNamed(context, AddItemScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return (items == null )
        ? const Loader()
        : Scaffold(
            body: GridView.builder(
              itemCount: items!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                final itemData = items![index];
                return Column(
                  children: [
                    SizedBox(
                      height: 140,
                      child: SingleItem(
                        image: itemData.images[0],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Text(
                            itemData.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        IconButton(
                            onPressed: () => deleteItem(itemData, index),
                            icon: const Icon(Icons.delete_outlined))
                      ],
                    )
                  ],
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: GlobalVariables.secondaryColor,
              onPressed: navigateToAddItem,
              tooltip: 'Add an Item',
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
