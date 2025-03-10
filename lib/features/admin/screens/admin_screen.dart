// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:coffee/constants/global_variables.dart';
import 'package:coffee/features/admin/screens/analytics_screen.dart';
import 'package:coffee/features/admin/screens/orders_screen.dart';
import 'package:coffee/features/admin/screens/posts_screen.dart';
import 'package:coffee/features/reservation/adminReservationScreen.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const PostsScreen(),
    const AnalyticsScreen(),
    const OrdersScreen(),
    AdminReservationScreen(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              alignment: Alignment.topLeft,
              child: Image.asset(
                'assets/images/coffee-cup.png',
                width: 50,
                height: 45,
              ),
            ),
            const Text(
              'Admin',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ]),
        ),
      ),
      body: pages[_page],
      //posts
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
          //analytics
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
                child: const Icon(Icons.analytics_outlined),
              ),
              label: ''),
          //orders
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
                child: const Icon(Icons.all_inbox_outlined),
              ),
              label: ''),

          // added at 30-th dec
          BottomNavigationBarItem(
              icon: Container(
                width: bottomBarWidth,
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                  color: _page == 3
                      ? GlobalVariables.selectedNavBarColor
                      : GlobalVariables.backgroundColor,
                  width: bottomBarBorderWidth,
                ))),
                child: const Icon(Icons.calendar_today_outlined),
              ),
              label: ''),
        ],
      ),
    );
  }
}
