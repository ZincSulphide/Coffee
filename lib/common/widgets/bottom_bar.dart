import 'package:coffee/constants/global_variables.dart';
import 'package:coffee/features/account/screens/account_screen.dart';
import 'package:coffee/features/cart/screens/cart_screen.dart';
import 'package:coffee/features/home/screens/home_screen.dart';
import 'package:coffee/features/reservation/reservationScreen.dart';
import 'package:coffee/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = '/actual-home';
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const HomeScreen(),
    const AccountScreen(),
    const CartScreen(),
    ReservationScreen(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userCartLen = context.watch<UserProvider>().user.cart.length;
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: updatePage,
        items: [
          BottomNavigationBarItem(
              icon: Container(
                width: bottomBarWidth,
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                  color: _page == 0
                      ? GlobalVariables.selectedNavBarColor
                      : GlobalVariables.backgroundColor,
                  width: bottomBarBorderWidth,
                ))),
                child: const Icon(Icons.home_outlined),
              ),
              label: ''),
          //account/profile
          BottomNavigationBarItem(
              icon: Container(
                width: bottomBarWidth,
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                  color: _page == 1
                      ? GlobalVariables.selectedNavBarColor
                      : GlobalVariables.backgroundColor,
                  width: bottomBarBorderWidth,
                ))),
                child: const Icon(Icons.person_outline_outlined),
              ),
              label: ''),
          //cart
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                color: _page == 2
                    ? GlobalVariables.selectedNavBarColor
                    : GlobalVariables.backgroundColor,
                width: bottomBarBorderWidth,
              ))),
              child: badges.Badge(
                badgeContent: Text(
                  userCartLen.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                badgeStyle: const badges.BadgeStyle(badgeColor: Colors.brown),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
            ),
            label: '',
          ),
          // added 30th dec
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                color: _page == 2
                    ? GlobalVariables.selectedNavBarColor
                    : GlobalVariables.backgroundColor,
                width: bottomBarBorderWidth,
              ))),
              // child: badges.Badge(
              //   badgeContent: Text(
              //     userCartLen.toString(),
              //     style: const TextStyle(color: Colors.white),
              //   ),
              //   badgeStyle: const badges.BadgeStyle(badgeColor: Colors.brown),
              child: const Icon(Icons.calendar_today_outlined),
              // ),
            ),
            label: '',
          )
        ],
      ),
    );
  }
}
