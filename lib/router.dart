import 'package:coffee/common/widgets/bottom_bar.dart';
import 'package:coffee/features/address/screens/address_screen.dart';
import 'package:coffee/features/admin/screens/add_item_screen.dart';
import 'package:coffee/features/auth/screens/auth_screen.dart';
import 'package:coffee/features/home/screens/category_deals_screen.dart';
import 'package:coffee/features/home/screens/home_screen.dart';
import 'package:coffee/features/item_details/screens/item_detail_screen.dart';
import 'package:coffee/features/search/screen/search_screen.dart';
import 'package:coffee/models/item.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );
      case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
      case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
      );
      case AddItemScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddItemScreen(),
      );
      case CategoryDealsScreen.routeName:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CategoryDealsScreen(
          category: category,
        ),
      );
      case SearchScreen.routeName:
      var searchQuery = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchScreen(
          searchQuery: searchQuery,
        ),
      );
      case ItemDetailScreen.routeName:
      var item = routeSettings.arguments as Item;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ItemDetailScreen(
          item: item,
        ),
      );
      case AddressScreen.routeName:
      var totalAmount = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddressScreen(totalAmount: totalAmount,),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
