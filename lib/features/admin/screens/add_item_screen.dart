import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee/common/widgets/custom_button.dart';
import 'package:coffee/common/widgets/custom_textfield.dart';
import 'package:coffee/constants/global_variables.dart';
import 'package:coffee/constants/utils.dart';
import 'package:coffee/features/admin/services/admin_services.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddItemScreen extends StatefulWidget {
  static const String routeName = '/add-item';
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final AdminServices adminServices = AdminServices();
  
  String category = 'Coffee';

  List<File> images = [];
  final _addItemFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    itemNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
  }

  List<String> itemCategories = [
    'Coffee',
    'Tea',
    'Desserts',
    'Sandwiches',
    'Breakfast',
  ];
  void addItemToMenu() {
    if (_addItemFormKey.currentState!.validate() && images.isNotEmpty) {
      adminServices.addItemToMenu(
        context: context,
        name: itemNameController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        category: category,
        images: images,
      );
    }
  }

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: GlobalVariables.appBarGradient,
              ),
            ),
            title: const Text(
              'Add Item',
              style: TextStyle(
                color: Colors.white,
              ),
            )),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addItemFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                images.isNotEmpty
                    ? CarouselSlider(
                        items: images.map((i) {
                          return Builder(
                            builder: (BuildContext context) => Image.file(
                              i,
                              fit: BoxFit.cover,
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: 200,
                        ),
                      )
                    : GestureDetector(
                        onTap: selectImages,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add,
                                  size: 40,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  'Select Item Images',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade500),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextField(
                    controller: itemNameController, hintText: 'Item Name'),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: descriptionController,
                  hintText: 'Description',
                  maxLines: 7,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(controller: priceController, hintText: 'Price'),
                const SizedBox(
                  height: 10,
                ),
                
                SizedBox(
                    width: double.infinity,
                    child: DropdownButton(
                      value: category,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: itemCategories.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (String? newVal) {
                        setState(() {
                          category = newVal!;
                        });
                      },
                    )),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                  text: 'Add',
                  onTap: addItemToMenu,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
