import 'package:flutter/material.dart';

// String uri = 'http://192.168.56.1:3000';
// String uri = 'http://192.168.0.105:3000';
String uri = 'http://192.168.0.243:3000';

class GlobalVariables {
  // COLORS
  static const appBarGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 115, 81, 53),
      Color.fromARGB(255, 165, 126, 78),
    ],
    stops: [0.5, 1.0],
  );

  static const secondaryColor = Color.fromARGB(255, 115, 81, 53);
  static const backgroundColor = Color(0xfffefefe);
  static const Color greyBackgroundCOlor = Color(0xffffffec);
  static var selectedNavBarColor = const Color(0xff38220f);
  static const unselectedNavBarColor = Color.fromARGB(255, 122, 91, 70);
  static const starColor = Color.fromRGBO(255, 153, 0, 1);

  static const List<Map<String, String>> categoryImages = [
    {
      'title': 'Coffee',
      'image': 'assets/images/coffee-category.png',
    },
    {
      'title': 'Tea',
      'image': 'assets/images/tea-category.png',
    },
    {
      'title': 'Sandwiches',
      'image': 'assets/images/sandwich-category.png',
    },
    {
      'title': 'Desserts',
      'image': 'assets/images/dessert-category.png',
    },
    {
      'title': 'Breakfast',
      'image': 'assets/images/breakfast-category.png',
    },
  ];
  static const List<String> carouselImages = [
    'assets/images/carousel-1.png',
    'assets/images/carousel-2.png',
    'assets/images/carousel-3.png',
    'assets/images/carousel-4.png',
  ];
}
